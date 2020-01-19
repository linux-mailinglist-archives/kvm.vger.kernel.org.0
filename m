Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB8F142078
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 23:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgASWan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 17:30:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56681 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727195AbgASWan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 17:30:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579473041;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n1JSL5+lp5i+FWnift/jrOLZthE4BXocGHH1lkltVqs=;
        b=HYgKJkP98nV/7y7xdtOwaIWjRNzp2QmFf2ky5z3J5D7yNXjCl6vU/7MhSmb/m4swPxLXmK
        jdfZ1bYh5B/pQJSFO8ob+pfL59XokgcV9xM4YUAkhEm6w/ih+jHyKeIlMozE2QP8d4Q0JL
        dy4WIN4n5m+SIB1zn6lboS8zsH828sE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-Li-AuLZtM1-8mSa2Xz8p3Q-1; Sun, 19 Jan 2020 17:30:37 -0500
X-MC-Unique: Li-AuLZtM1-8mSa2Xz8p3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B48CF1005512
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 22:30:36 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-61.bne.redhat.com [10.64.54.61])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 004E289E9D;
        Sun, 19 Jan 2020 22:30:32 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] tools/kvm_stat: Fix kvm_exit filter name
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, drjones@redhat.com
References: <20191210044829.180122-1-gshan@redhat.com>
 <e02c2678-2b08-8af0-5847-6a2d81d58370@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <1cb916ad-df87-996d-ec41-c186740e3ae3@redhat.com>
Date:   Mon, 20 Jan 2020 09:30:30 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <e02c2678-2b08-8af0-5847-6a2d81d58370@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/20 6:18 AM, Paolo Bonzini wrote:
> On 10/12/19 05:48, Gavin Shan wrote:
>> The filter name is fixed to "exit_reason" for some kvm_exit events, no
>> matter what architect we have. Actually, the filter name ("exit_reason")
>> is only applicable to x86, meaning it's broken on other architects
>> including aarch64.
>>
>> This fixes the issue by providing various kvm_exit filter names, depending
>> on architect we're on. Afterwards, the variable filter name is picked and
>> applied through ioctl(fd, SET_FILTER).
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
>>
> 
> Queued, thanks.
> 
> Paolo
> 

Paolo, actually the v2 instead of this v1 patch needs to be merged:

https://www.spinics.net/lists/kvm/msg202841.html

Thanks,
Gavin


