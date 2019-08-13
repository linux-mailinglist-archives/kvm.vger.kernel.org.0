Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790148BB9B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 16:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbfHMOfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 10:35:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51302 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfHMOfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 10:35:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so1749538wma.1
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 07:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lqxf8Z0rQTySZp3AWUTugOPDEfv/sn0v4AQtN6QyRsc=;
        b=gZeDqqhaxagWjfx8Z/UGAbjUTVNDYNPzFQhz2Lmm4z01tC42B0U1LWD4b8aG0j8jCD
         FT/TwMh5uWm7O/yQLIAvme/u0a94NPkkjfZGIwgeqXytj5El1U55mJh7aniBL0XFOsFH
         IH4xVLJuQpZmmZsniLV6opmDgV99I3BYbiw1m1ASdWkqaskowwGT7ytZNQIU09h2QZ0k
         Ei6n9tTpvqWO4EWREn6rYhQdSyh5th2rizlE2GzXXDoiZwuWEIQoeRfniPaQpbcspskn
         kh80qDnI9VfRzWMJS0iYF/rQBq3QmWWkAj2eW2lMmoOi5pChTcUmod8wX3ZD/IE1JfFt
         Mxqw==
X-Gm-Message-State: APjAAAUZIzHdkovh/NiBXFrL7oo0PaiZLqkE96eAL6ML/AbFjNGLKSne
        vBO4mmAN3crEoDjS3yTExWgE2g==
X-Google-Smtp-Source: APXvYqyMYCBhf8rY/MB9/wMH1QCr9Vu6nKQhVNm4wEsOIwP/ZmvzsrgT8mr1A8+NWxaviFXBe7iSWQ==
X-Received: by 2002:a1c:f618:: with SMTP id w24mr3674803wmc.112.1565706930235;
        Tue, 13 Aug 2019 07:35:30 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r190sm3362812wmf.0.2019.08.13.07.35.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 07:35:29 -0700 (PDT)
Subject: Re: [RFC PATCH v6 75/92] kvm: x86: disable gpa_available optimization
 in emulator_read_write_onepage()
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-76-alazar@bitdefender.com>
 <eb748e05-8289-0c05-6907-b6c898f6080b@redhat.com>
 <5d52ca22.1c69fb81.4ceb8.e90bSMTPIN_ADDED_BROKEN@mx.google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5b6f78ca-a5c5-80c4-05af-cbf7fabb96b3@redhat.com>
Date:   Tue, 13 Aug 2019 16:35:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5d52ca22.1c69fb81.4ceb8.e90bSMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 16:33, Adalbert Lazăr wrote:
> On Tue, 13 Aug 2019 10:47:34 +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> On 09/08/19 18:00, Adalbert Lazăr wrote:
>>> If the EPT violation was caused by an execute restriction imposed by the
>>> introspection tool, gpa_available will point to the instruction pointer,
>>> not the to the read/write location that has to be used to emulate the
>>> current instruction.
>>>
>>> This optimization should be disabled only when the VM is introspected,
>>> not just because the introspection subsystem is present.
>>>
>>> Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
>>
>> The right thing to do is to not set gpa_available for fetch failures in 
>> kvm_mmu_page_fault instead:
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 24843cf49579..1bdca40fa831 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -5364,8 +5364,12 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
>>  	enum emulation_result er;
>>  	bool direct = vcpu->arch.mmu->direct_map;
>>  
>> -	/* With shadow page tables, fault_address contains a GVA or nGPA.  */
>> -	if (vcpu->arch.mmu->direct_map) {
>> +	/*
>> +	 * With shadow page tables, fault_address contains a GVA or nGPA.
>> +	 * On a fetch fault, fault_address contains the instruction pointer.
>> +	 */
>> +	if (vcpu->arch.mmu->direct_map &&
>> +	    likely(!(error_code & PFERR_FETCH_MASK)) {
>>  		vcpu->arch.gpa_available = true;
>>  		vcpu->arch.gpa_val = cr2;
>>  	}
>
> Sure, but I think we'll have to extend the check.
> 
> Searching the logs I've found:
> 
>     kvm/x86: re-translate broken translation that caused EPT violation
>     
>     Signed-off-by: Mircea Cirjaliu <mcirjaliu@bitdefender.com>
> 
>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> /home/b/kvmi@9cad844~1/arch/x86/kvm/x86.c:4757,4762 - /home/b/kvmi@9cad844/arch/x86/kvm/x86.c:4757,4763
>   	 */
>   	if (vcpu->arch.gpa_available &&
>   	    emulator_can_use_gpa(ctxt) &&
> + 	    (vcpu->arch.error_code & PFERR_GUEST_FINAL_MASK) &&
>   	    (addr & ~PAGE_MASK) == (vcpu->arch.gpa_val & ~PAGE_MASK)) {
>   		gpa = vcpu->arch.gpa_val;
>   		ret = vcpu_is_mmio_gpa(vcpu, addr, gpa, write);
> 

Yes, adding that check makes sense as well (still in kvm_mmu_page_fault).

Paolo
