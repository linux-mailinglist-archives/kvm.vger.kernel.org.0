Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DB2125A06
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 04:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfLSDeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 22:34:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23210 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726779AbfLSDeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 22:34:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576726450;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IAXDZ2yPhWgynCk13CH9tKDg9wRbgefG5kyIZ57F1Fo=;
        b=XQYQ06Ez4p9ei14EVstORoa+c7S+sqigr+aL7lkGHdOVa5fxUTzcVEI6337C0jXEF4xdfv
        WFkX4I16jlFZWeYUw4vTQs8uhNy3x91PiVTE/8+PHljfLY2AQI4hJkpXsoZV+aOuCPgvav
        FDYgBwKOUdxQax6hiwfNWHe3b5IiMQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-ScClcFYTNhOKCCP1lSNHKw-1; Wed, 18 Dec 2019 22:34:08 -0500
X-MC-Unique: ScClcFYTNhOKCCP1lSNHKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C57A593A0;
        Thu, 19 Dec 2019 03:34:07 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-48.bne.redhat.com [10.64.54.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0226426DF8;
        Thu, 19 Dec 2019 03:33:59 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2] tools/kvm_stat: Fix kvm_exit filter name
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, maz@kernel.org
References: <20191217020600.10268-1-gshan@redhat.com>
 <20191218084538.qnnnla6rqcnoeeah@kamzik.brq.redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <6aa080d0-05a3-cbfc-ada0-4482be152fc2@redhat.com>
Date:   Thu, 19 Dec 2019 14:33:57 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191218084538.qnnnla6rqcnoeeah@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/18/19 7:45 PM, Andrew Jones wrote:
> On Tue, Dec 17, 2019 at 01:06:00PM +1100, Gavin Shan wrote:
>> The filter name is fixed to "exit_reason" for some kvm_exit events, no
>> matter what architect we have. Actually, the filter name ("exit_reason")
>> is only applicable to x86, meaning it's broken on other architects
>> including aarch64.
>>
>> This fixes the issue by providing various kvm_exit filter names, depending
>> on architect we're on. Afterwards, the variable filter name is picked and
>> applied by ioctl(fd, SET_FILTER).
>>
>> Reported-by: Andrew Jones <drjones@redhat.com>
> 
> This wasn't reported by me - I was just the middleman. Credit should go
> to Jeff Bastian <jbastian@redhat.com>
> 

Sure. Paolo, please let me know if I need post a v3 to fix it up :)

>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>> v2: Rename exit_field to exit_reason_field
>>      Fix the name to esr_ec for aarch64
>> ---
>>   tools/kvm/kvm_stat/kvm_stat | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
>> index ad1b9e646c49..4cf93110c259 100755
>> --- a/tools/kvm/kvm_stat/kvm_stat
>> +++ b/tools/kvm/kvm_stat/kvm_stat
>> @@ -270,6 +270,7 @@ class ArchX86(Arch):
>>       def __init__(self, exit_reasons):
>>           self.sc_perf_evt_open = 298
>>           self.ioctl_numbers = IOCTL_NUMBERS
>> +        self.exit_reason_field = 'exit_reason'
>>           self.exit_reasons = exit_reasons
>>   
>>       def debugfs_is_child(self, field):
>> @@ -289,6 +290,7 @@ class ArchPPC(Arch):
>>           # numbers depend on the wordsize.
>>           char_ptr_size = ctypes.sizeof(ctypes.c_char_p)
>>           self.ioctl_numbers['SET_FILTER'] = 0x80002406 | char_ptr_size << 16
>> +        self.exit_reason_field = 'exit_nr'
>>           self.exit_reasons = {}
>>   
>>       def debugfs_is_child(self, field):
>> @@ -300,6 +302,7 @@ class ArchA64(Arch):
>>       def __init__(self):
>>           self.sc_perf_evt_open = 241
>>           self.ioctl_numbers = IOCTL_NUMBERS
>> +        self.exit_reason_field = 'esr_ec'
>>           self.exit_reasons = AARCH64_EXIT_REASONS
>>   
>>       def debugfs_is_child(self, field):
>> @@ -311,6 +314,7 @@ class ArchS390(Arch):
>>       def __init__(self):
>>           self.sc_perf_evt_open = 331
>>           self.ioctl_numbers = IOCTL_NUMBERS
>> +        self.exit_reason_field = None
>>           self.exit_reasons = None
>>   
>>       def debugfs_is_child(self, field):
>> @@ -541,8 +545,8 @@ class TracepointProvider(Provider):
>>           """
>>           filters = {}
>>           filters['kvm_userspace_exit'] = ('reason', USERSPACE_EXIT_REASONS)
>> -        if ARCH.exit_reasons:
>> -            filters['kvm_exit'] = ('exit_reason', ARCH.exit_reasons)
>> +        if ARCH.exit_reason_field and ARCH.exit_reasons:
>> +            filters['kvm_exit'] = (ARCH.exit_reason_field, ARCH.exit_reasons)
>>           return filters
>>   
>>       def _get_available_fields(self):
>> -- 
>> 2.23.0
>>
> 
> Looks like a reasonable fix to me.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 

Thanks for the review and comments.

Regards,
Gavin

