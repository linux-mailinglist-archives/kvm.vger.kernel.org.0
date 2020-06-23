Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62C3204E07
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732048AbgFWJd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:33:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34080 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732026AbgFWJdz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 05:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592904831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxuWU03MOe1DRPaypPqHtlrhzMfxKeff+EnLxbGmDz8=;
        b=KtqrTjTv5IemdFl2V60jeuVco1rjVsJjj/F0xxcTjoe/uUi8UR5QYZd9IrR6+iBvfwpRw+
        qcGzvCuW6cGtJS1RsrbOAjDHGcaWQbZmyZVY9OCW8qouqFnTYw7RsjXk4AXORNpyUiEcZH
        nZhK0SrzFKJ+SnMDS7Mad9ypvzQ2/6k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-_gczfqsxNDOh0kufLoydsw-1; Tue, 23 Jun 2020 05:33:50 -0400
X-MC-Unique: _gczfqsxNDOh0kufLoydsw-1
Received: by mail-wm1-f72.google.com with SMTP id a18so3243642wmm.3
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pxuWU03MOe1DRPaypPqHtlrhzMfxKeff+EnLxbGmDz8=;
        b=Hc8pFBYrKPYqW1qu3aRSEOVElJ/2yDWsvCjk+iNEhgiOfwVehndAEKnal+2Efxtns7
         wpUtF9tOTL7ftRTKFyZYm7THxIlQSCp0b1r8RSFA79Tt+XrTvooVmOOsuZCNZHPvj2/+
         5NnNDpW9W9FSfZ5/HPwUD3EdaKD4Gp5ihVGNmOPrMRq+AtSX+qn73cFaSgHrFFOWMDx/
         uAkbyFR/AF4IZO0p5N4ZphvYr4rRIpwDlZ4+tuRmvG591AMW+oAa+zu/NA78CFnzkA2J
         OEWgu8QCYPqw7KbvrHpZF3Yw8Qw2Z9ZKVCRwzQsG5ahzWLx+rWmeK339eWLE44s9vyNO
         JR/g==
X-Gm-Message-State: AOAM5312vKm7YD5YJCI+P+OKohl4hxf3ygzGrSVAjKWwI27UFlTykgS9
        tkkbJd9HIpqJktcryyH3sWKS3S0cviJ0LoW9n3b2Yf7Ji7aR38tza1EbCdDwFYa37X58EDpuxK7
        KvLr0sGn1+mMB
X-Received: by 2002:a7b:cbc5:: with SMTP id n5mr9620996wmi.95.1592904828840;
        Tue, 23 Jun 2020 02:33:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQCxVojll0c3QhTsi9GUbyXz5HlgVSfJXW40gyU57nFQYyFSThVULts8RRYFzjB2rsCJsW2w==
X-Received: by 2002:a7b:cbc5:: with SMTP id n5mr9620966wmi.95.1592904828515;
        Tue, 23 Jun 2020 02:33:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id b18sm21272231wrn.88.2020.06.23.02.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 02:33:47 -0700 (PDT)
Subject: Re: [PATCH 2/3 v2] kvm-unit-tests: nVMX: Optimize test_guest_dr7() by
 factoring out the loops into a macro
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com
References: <1591384822-71784-1-git-send-email-krish.sadhukhan@oracle.com>
 <1591384822-71784-3-git-send-email-krish.sadhukhan@oracle.com>
 <20200605195820.GB11449@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe059f8a-d052-e0fc-90c6-67fcd7920834@redhat.com>
Date:   Tue, 23 Jun 2020 11:33:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200605195820.GB11449@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 21:58, Sean Christopherson wrote:
> I don't think "optimize" is the word you're looking for.  Moving code into
> a macro doesn't optimize anything, the only thing it does is consolidate
> code.
> 
> On Fri, Jun 05, 2020 at 07:20:21PM +0000, Krish Sadhukhan wrote:
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>  x86/vmx_tests.c | 36 ++++++++++++++++++++----------------
>>  1 file changed, 20 insertions(+), 16 deletions(-)
>>
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 4308ef3..7dd8bfb 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -7704,6 +7704,19 @@ static void vmx_host_state_area_test(void)
>>  	test_load_host_perf_global_ctrl();
>>  }
>>  
>> +#define TEST_GUEST_VMCS_FIELD_RESERVED_BITS(start, end, inc, fld, str_name,\
>> +					    val, msg, xfail)		\
>> +{									\
>> +	u64 tmp;							\
>> +	int i;								\
>> +									\
>> +	for (i = start; i <= end; i = i + inc) {			\
> 
> The "i = i + inc" is weird, not to mention a functional change as the callers
> are passing in '4', i.e. this only checks every fourth bit.
> 
> IMO this whole macro is overkill and doesn't help readability in the callers,
> there are too many parameters to cross reference.  What about adding a more
> simple helper to iterate over every bit, e.g. 
> 
> 	for_each_bit(0, 63, val) {
> 		vmcs_write(GUEST_DR7, val);
> 		test_guest_state("ENT_LOAD_DBGCTLS disabled", false,
> 				 val, "GUEST_DR7");
> 	}
> 
> and
> 
>         for_each_bit(0, 63, val) {
>                 vmcs_write(GUEST_DR7, val);
>                 test_guest_state("ENT_LOAD_DBGCTLS enabled", val >> 32,
>                                  val, "GUEST_DR7");
>         }
> 
> 
> I'm guessing the for_each_bit() thing can be reused in other flows besides
> guest state checks.

I agree, and I've not queued this patch (I used v1 because there were
other #ifdef __x86_64__ anyway, and sent a patch to get rid of them all).

Paolo

>> +		tmp = val | (1ull << i);				\
>> +		vmcs_write(fld, tmp);					\
>> +		test_guest_state(msg, xfail, val, str_name);		\
>> +	}								\
>> +}
>> +
>>  /*
>>   * If the "load debug controls" VM-entry control is 1, bits 63:32 in
>>   * the DR7 field must be 0.
>> @@ -7714,26 +7727,17 @@ static void test_guest_dr7(void)
>>  {
>>  	u32 ent_saved = vmcs_read(ENT_CONTROLS);
>>  	u64 dr7_saved = vmcs_read(GUEST_DR7);
>> -	u64 val;
>> -	int i;
>>  
>>  	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS) {
>> -		vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
>> -		for (i = 0; i < 64; i++) {
>> -			val = 1ull << i;
>> -			vmcs_write(GUEST_DR7, val);
>> -			test_guest_state("ENT_LOAD_DBGCTLS disabled", false,
>> -					 val, "GUEST_DR7");
>> -		}
>> +		vmcs_write(ENT_CONTROLS, ent_saved & ~ENT_LOAD_DBGCTLS);
>> +		TEST_GUEST_VMCS_FIELD_RESERVED_BITS(0, 63, 4, GUEST_DR7,
>> +		    "GUEST_DR7", dr7_saved, "ENT_LOAD_DBGCTLS disabled", false);
>>  	}
>>  	if (ctrl_enter_rev.clr & ENT_LOAD_DBGCTLS) {
>> -		vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
>> -		for (i = 0; i < 64; i++) {
>> -			val = 1ull << i;
>> -			vmcs_write(GUEST_DR7, val);
>> -			test_guest_state("ENT_LOAD_DBGCTLS enabled", i >= 32,
>> -					 val, "GUEST_DR7");
>> -		}
>> +		vmcs_write(ENT_CONTROLS, ent_saved | ENT_LOAD_DBGCTLS);
>> +		TEST_GUEST_VMCS_FIELD_RESERVED_BITS(0, 63, 4, GUEST_DR7,
>> +		    "GUEST_DR7", dr7_saved, "ENT_LOAD_DBGCTLS enabled",
>> +		    i >= 32);
>>  	}
>>  	vmcs_write(GUEST_DR7, dr7_saved);
>>  	vmcs_write(ENT_CONTROLS, ent_saved);
>> -- 
>> 1.8.3.1
>>
> 

