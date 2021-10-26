Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D5743B63D
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 17:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbhJZP7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 11:59:41 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:48836 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237070AbhJZP7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 11:59:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635263836; x=1666799836;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=fJQcIUE1nvSZkHwj16ZLZjZuqMibI6DpxAE7J7fpAlY=;
  b=HbdJQyIn7bZCre6kEh4qh6XAjFUpJV01PJ24hENkNR/0/ax/7HZOBIC4
   nZziGS/6l5fLCwF7Wc7fp3vkHzzEXy7vgjRLPhCRImcSLJdUbrhOGLqMI
   DMuYo6NdLpqha2QCt0oQvdiGW+cUcEa0O+MWh8r7ZRIwUgESEjmf7A0gN
   U=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 26 Oct 2021 08:57:16 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 08:57:16 -0700
Received: from [10.110.83.137] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Tue, 26 Oct 2021
 08:57:15 -0700
Subject: Re: [PATCH] kvm: Avoid shadowing a local in search_memslots()
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211026151310.42728-1-quic_qiancai@quicinc.com>
 <YXgib3l+sSwy8Sje@google.com>
From:   Qian Cai <quic_qiancai@quicinc.com>
Message-ID: <9a9100f8-3e60-2fb7-1200-ec2895ae1b13@quicinc.com>
Date:   Tue, 26 Oct 2021 11:57:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXgib3l+sSwy8Sje@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/26/21 11:44 AM, Sean Christopherson wrote:
> On Tue, Oct 26, 2021, Qian Cai wrote:
>> It is less error-prone to use a different variable name from the existing
>> one in a wider scope. This is also flagged by GCC (W=2):
>>
>> ./include/linux/kvm_host.h: In function 'search_memslots':
>> ./include/linux/kvm_host.h:1246:7: warning: declaration of 'slot' shadows a previous local [-Wshadow]
>>  1246 |   int slot = start + (end - start) / 2;
>>       |       ^~~~
>> ./include/linux/kvm_host.h:1240:26: note: shadowed declaration is here
>>  1240 |  struct kvm_memory_slot *slot;
>>       |                          ^~~~
>>
> 
> Even though this doesn't need to go to stable, probably worth adding a Fixes: to
> acknowledge that this was a recently introduced mess.
> 
>   Fixes: 0f22af940dc8 ("KVM: Move last_used_slot logic out of search_memslots")
> 
> 
>> Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
>> ---
>>  include/linux/kvm_host.h | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 60a35d9fe259..1c1a36f658fe 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -1243,12 +1243,12 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
>>  		return NULL;
>>  
>>  	while (start < end) {
>> -		int slot = start + (end - start) / 2;
>> +		int new_slot = start + (end - start) / 2;
> 
> new_slot isn't a great name, the integer "slot" isn't directly connected to the
> final memslot and may not be representative of the final memslot's index depending
> on how the binary search resolves.
> 
> Maybe "pivot"?  Or just "tmp"?  I also vote to hoist the declaration out of the
> loop precisely to avoid potential shadows, and to also associate the variable
> with the "start" and "end" variables, e.g.

Yes, I like "pivot" and the rest of the feedback makes sense. I'll send
a v2 soon.
