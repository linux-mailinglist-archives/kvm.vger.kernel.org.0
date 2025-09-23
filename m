Return-Path: <kvm+bounces-58563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3805B96AFE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:59:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54A997A86AE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8DC27144B;
	Tue, 23 Sep 2025 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJLKhIWs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1BD2E1749
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758643091; cv=none; b=DeaEIj3HjS+VWeplBBFu9bDdSNeq6IZY84d913WCxCm3WxcYOUxBA46kzemC7691G/MgD6lWifantrqWCue1nYrb0bH3kjmRsiF+e3R0zrj36Rk8SLtaQN5PsTtoLjV6KTn8UdX4oIlu/OBib1NtEhR2kQHXtUw3iXg8EMcJSGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758643091; c=relaxed/simple;
	bh=WZ4DNaxOgyOrfwIlHPhd6A559fN5fAE3al+C7vhTkk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SIUKE68u368QlKtY/h2kjXFio7CpA55fVbwWlidyRvN9+TyLk8CybhrFBwvRHnJXQEQw9THRA5gp8hlcO+2KNkVMJvMvTpcX/i9EePiKc1DNZURUHKg6M8P3ZyLgEh6sxOb81Q4P75JVX/cOe1Ve0i4wgg4J4ZYvrr5BauBD260=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MJLKhIWs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758643088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9d3TNqf8jlkrOIuDlAsCdAmPH3oYtwyKBL88rvuUbOU=;
	b=MJLKhIWsvOwoekgHejDo2FrjrYX9suyZ3fXgPV70RCAXWX6lWEtQWt4OFhj2pC7H/UT/sz
	hXC+pcwrhFfT86vBXY//lbg66EPM32d2h8qt5B0EQltlSK9bwF9D7WCqTCU+MMx2pGN4VO
	sjVOmTT41rk1k11fimlpJyJ8MyXLoF4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-NmktJHOtPC239aoILSY6Bw-1; Tue, 23 Sep 2025 11:58:07 -0400
X-MC-Unique: NmktJHOtPC239aoILSY6Bw-1
X-Mimecast-MFC-AGG-ID: NmktJHOtPC239aoILSY6Bw_1758643086
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-63468fe211aso815473a12.2
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 08:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758643086; x=1759247886;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9d3TNqf8jlkrOIuDlAsCdAmPH3oYtwyKBL88rvuUbOU=;
        b=TnO85j2wHeIFPI1fGaYjqsLd/X+KgPxJ+ZVQKvH/r2Ju0mvbA3rvn6NiN6PILTdF3e
         QmR7/eSShpof7lZEotxdssl8hCrFaUoT2h//LVfvOxt7luet7DwgQWmmQoW6KRFa9E3C
         PDHoxChSxdtqnIIZG6GS2EemBHysdYQ8Jj6Pe6yQW1V4pOzZWvCK9koveQ74QscedqSs
         hutkDTGgRBg4HtpE//1RfpNiKuPS6eBbLjnmfJNcdG/3CtUZfuKoqUYR5tV0bW3fZcOm
         7ldsRHVGUagyDuthSWXtBCmmKFthdApBIxn7DEp47QMquu3weYMpnpc8OgaH3tkKkEk1
         pg5A==
X-Forwarded-Encrypted: i=1; AJvYcCVAYkjicWBWriSc7oBt6ENCPNWqCIbW8Ani/8ZodcgZYfiYuVKFmGqaCCd+HhMuyeE+Hsk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxUX808SoC5IudJ4CghdpSw+9UCszNjrsnyDEoMB5MAII8btEk
	kStJKqSI4RtOPqHKDLRmlVnQVuu/3VGiCdnbYVDVJqAF8q8Sx1K3ixxGXIEFgAlltrYawsDlSlN
	LY2OS+Ca7M+kMdxcNl3M9kTzMuyjhfAUHwvDr2K0PVTeVGPMlMQ6ZpA==
X-Gm-Gg: ASbGncvHQ6nnbaRunI6ZvyLcbpPX9ZCBd7pDSEyGDV5ixF+HphLRPa1i4gdt49/A3ly
	f9DMv9JsLR2SSHeFMintMUzvMz+tgwkd/VixVO9oSCMrEuxkjKHCg8W70cn52W+n3+rMPsBvORz
	PmemlH7HsbGc5bEo+6PEAugouaIKWHAGsGySXm3wvA6pYbr6kaoGJqT/Mj/DywBl/jpgasnMEH9
	AqSWn1MYgk9keebU6XqCCpAor+uy4/scj8lopTdkM09ajrUb5LjXrCkwNy+8MRFShl/QS/e6vHw
	MB56KoJnQxheIQmWSaV2HFsn8e+PHv2hCw2hZ9ASohNJSMyBZ+3jDeoxZDm/gIPH58WLPMfmihb
	hU3lJrlCEd/i1cWEg3JBCNgjVGYfrNQ9u+pJg5nYNPqDaxA==
X-Received: by 2002:a05:6402:35c2:b0:633:7017:fcc7 with SMTP id 4fb4d7f45d1cf-634677b58fbmr2614867a12.10.1758643085842;
        Tue, 23 Sep 2025 08:58:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGETODyvlWeYh+fQuYF1s139fQ8a3Y0NNeQNJi+UjfqyHNfq+hya1YJmAC8wr2k79dPO2rLkQ==
X-Received: by 2002:a05:6402:35c2:b0:633:7017:fcc7 with SMTP id 4fb4d7f45d1cf-634677b58fbmr2614836a12.10.1758643085325;
        Tue, 23 Sep 2025 08:58:05 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.127.188])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-62fa5f27640sm10916316a12.39.2025.09.23.08.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 08:58:04 -0700 (PDT)
Message-ID: <7c7a5a75-a786-4a05-a836-4368582ca4c2@redhat.com>
Date: Tue, 23 Sep 2025 17:58:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: x86: Fix a semi theoretical bug in
 kvm_arch_async_page_present_queued
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 x86@kernel.org, Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
References: <20250813192313.132431-1-mlevitsk@redhat.com>
 <20250813192313.132431-3-mlevitsk@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250813192313.132431-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/25 21:23, Maxim Levitsky wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9018d56b4b0a..3d45a4cd08a4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13459,9 +13459,14 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>   
>   void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
>   {
> -	kvm_make_request(KVM_REQ_APF_READY, vcpu);
> -	if (!vcpu->arch.apf.pageready_pending)
> +	/* Pairs with smp_store_release in vcpu_enter_guest. */
> +	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
> +	bool page_ready_pending = READ_ONCE(vcpu->arch.apf.pageready_pending);
> +
> +	if (!in_guest_mode || !page_ready_pending) {
> +		kvm_make_request(KVM_REQ_APF_READY, vcpu);
>   		kvm_vcpu_kick(vcpu);
> +	}

Unlike Sean, I think the race exists in abstract and is not benign, but
there are already enough memory barriers to tame it.

That said, in_guest_mode is a red herring.  The way I look at it, is
through the very common wake/sleep (or kick/check) pattern that has
smp_mb() on both sides.

The pair you are considering consists of this  function (the "kick
side"), and the wrmsr handler for MSR_KVM_ASYNC_PF_ACK (the "check
side").  Let's see how the synchronization between the two sides
happens:

- here, you need to check whether to inject the interrupt.  It looks
like this:

   kvm_make_request(KVM_REQ_APF_READY, vcpu);
   smp_mb();
   if (!READ_ONCE(page_ready_pending))
     kvm_vcpu_kick(vcpu);

- on the other side, after clearing page_ready_pending, there will be a
check for a wakeup:

   WRITE_ONCE(page_ready_pending, false);
   smp_mb();
   if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
     kvm_check_async_pf_completion(vcpu)

except that the "if" is not in kvm_set_msr_common(); it will happen
naturally as part of the first re-entry.


So let's look at the changes you need to make, in order to make the code
look like the above.

- using READ_ONCE/WRITE_ONCE for pageready_pending never hurts

- here in kvm_arch_async_page_present_queued(), a smp_mb__after_atomic()
(compiler barrier on x86) is missing after kvm_make_request():

         kvm_make_request(KVM_REQ_APF_READY, vcpu);
	/*
	 * Tell vCPU to wake up before checking if they need an
	 * interrupt.  Pairs with any memory barrier between
	 * the clearing of pageready_pending and vCPU entry.
	 */
	smp_mb__after_atomic();
         if (!READ_ONCE(vcpu->arch.apf.pageready_pending))
                 kvm_vcpu_kick(vcpu);

- in kvm_set_msr_common(), there are two possibilities.
The easy one is to just use smp_store_mb() to clear
vcpu->arch.apf.pageready_pending.  The other would be a comment
like this:

	WRITE_ONCE(vcpu->arch.apf.pageready_pending, false);
	/*
	 * Ensure they know to wake this vCPU up, before the vCPU
	 * next checks KVM_REQ_APF_READY.  Use an existing memory
	 * barrier between here and thenext kvm_request_pending(),
	 * for example in vcpu_run().
	 */
	/* smp_mb(); */

plus a memory barrier in common code like this:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 706b6fd56d3c..e302c617e4b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11236,6 +11236,11 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
  		if (r <= 0)
  			break;
  
+		/*
+		 * Provide a memory barrier between handle_exit and the
+		 * kvm_request_pending() read in vcpu_enter_guest().  It
+		 * pairs with any barrier after kvm_make_request(), for
+		 * example in kvm_arch_async_page_present_queued().
+		 */
+		smp_mb__before_atomic();
  		kvm_clear_request(KVM_REQ_UNBLOCK, vcpu);
  		if (kvm_xen_has_pending_events(vcpu))
  			kvm_xen_inject_pending_events(vcpu);


The only advantage of this second, more complex approach is that
it shows *why* the race was not happening.  The 50 clock cycles
saved on an MSR write are not worth the extra complication, and
on a quick grep I could not find other cases which rely on the same
implicit barriers.  So I'd say use smp_store_mb(), with a comment
about the pairing with kvm_arch_async_page_present_queued(); and write
in the commit message that the race wasn't happening thanks to unrelated
memory barriers between handle_exit and the kvm_request_pending()
read in vcpu_enter_guest.

Thanks,

Paolo


