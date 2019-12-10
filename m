Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6885119FA8
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 00:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfLJXwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 18:52:38 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35855 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725999AbfLJXwi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 18:52:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576021958;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TIO9zs8NN3eSgTisMQQTEwgibCOYL+49uPYv5n0gDo=;
        b=BU2jWxd3ecKuJ49gnZClmvAC9TcQYTCsGSMzo68zy2t/xMmBgbBrSLJFXgrLC+LJlZQEut
        7yzRFhfQkMb0to0CbmL/1RNxacWog/tKCfW82w460aNLdJkrL/0r0P/5jB29gOrPOfRmAy
        v5AkiIjkQwMa8gzJC9fcCsJ7qz7FIss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-NboiEzHIN1WNBTIJy9fyew-1; Tue, 10 Dec 2019 18:52:36 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3D1F1023154
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 23:52:35 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-44.bne.redhat.com [10.64.54.44])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 962A35C28C;
        Tue, 10 Dec 2019 23:52:31 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] tools/kvm_stat: Fix kvm_exit filter name
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com
References: <20191210044829.180122-1-gshan@redhat.com>
 <871rtcd0wo.fsf@vitty.brq.redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <9159a786-6a5f-e8be-33b8-19a765cedd68@redhat.com>
Date:   Wed, 11 Dec 2019 10:52:29 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <871rtcd0wo.fsf@vitty.brq.redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: NboiEzHIN1WNBTIJy9fyew-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/19 7:45 PM, Vitaly Kuznetsov wrote:
> Gavin Shan <gshan@redhat.com> writes:
> 
>> The filter name is fixed to "exit_reason" for some kvm_exit events, no
>> matter what architect we have. Actually, the filter name ("exit_reason")
>> is only applicable to x86, meaning it's broken on other architects
>> including aarch64.
>>
>> This fixes the issue by providing various kvm_exit filter names, depending
>> on architect we're on. Afterwards, the variable filter name is picked and
>> applied through ioctl(fd, SET_FILTER).
> 
> Would it actually make sense to standardize (to certain extent) kvm_exit
> tracepoints instead?
> 

Yes, It makes sense, but it's something for future if you agree. Besides,
It seems that other kvm tracepoints need standardization either.

>>
>> Reported-by: Andrew Jones <drjones@redhat.com>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   tools/kvm/kvm_stat/kvm_stat | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
>> index ad1b9e646c49..f9273614b7e3 100755
>> --- a/tools/kvm/kvm_stat/kvm_stat
>> +++ b/tools/kvm/kvm_stat/kvm_stat
>> @@ -270,6 +270,7 @@ class ArchX86(Arch):
>>       def __init__(self, exit_reasons):
>>           self.sc_perf_evt_open = 298
>>           self.ioctl_numbers = IOCTL_NUMBERS
>> +        self.exit_field = 'exit_reason'
> 
> Also, 'exit_field' name is confusing (probably because I'm thinking of
> VMCS fields)
> 

Ok. How about to have 'exit_reason_field' or 'exit_filter_name'?

>>           self.exit_reasons = exit_reasons
>>   
>>       def debugfs_is_child(self, field):
>> @@ -289,6 +290,7 @@ class ArchPPC(Arch):
>>           # numbers depend on the wordsize.
>>           char_ptr_size = ctypes.sizeof(ctypes.c_char_p)
>>           self.ioctl_numbers['SET_FILTER'] = 0x80002406 | char_ptr_size << 16
>> +        self.exit_field = 'exit_nr'
>>           self.exit_reasons = {}
>>   
>>       def debugfs_is_child(self, field):
>> @@ -300,6 +302,7 @@ class ArchA64(Arch):
>>       def __init__(self):
>>           self.sc_perf_evt_open = 241
>>           self.ioctl_numbers = IOCTL_NUMBERS
>> +        self.exit_field = 'ret'
> 
> And this is the most confusing part. Why do we have 'ret' as an exit
> reason in the first place?
> 

ah, it turns to be 'esr_ec', which is the class code from ESR_EL2. Will fix in v2.
The field name isn't meaningful and it's to be sorted out in future standardization
by the way :)


>>           self.exit_reasons = AARCH64_EXIT_REASONS
>>   
>>       def debugfs_is_child(self, field):
>> @@ -311,6 +314,7 @@ class ArchS390(Arch):
>>       def __init__(self):
>>           self.sc_perf_evt_open = 331
>>           self.ioctl_numbers = IOCTL_NUMBERS
>> +        self.exit_field = None
>>           self.exit_reasons = None
>>   
>>       def debugfs_is_child(self, field):
>> @@ -541,8 +545,8 @@ class TracepointProvider(Provider):
>>           """
>>           filters = {}
>>           filters['kvm_userspace_exit'] = ('reason', USERSPACE_EXIT_REASONS)
>> -        if ARCH.exit_reasons:
>> -            filters['kvm_exit'] = ('exit_reason', ARCH.exit_reasons)
>> +        if ARCH.exit_field and ARCH.exit_reasons:
>> +            filters['kvm_exit'] = (ARCH.exit_field, ARCH.exit_reasons)
>>           return filters
>>   
>>       def _get_available_fields(self):
> 

Regards,
Gavin

