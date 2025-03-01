Return-Path: <kvm+bounces-39794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7AF1A4A7E7
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 03:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDDF8189CF86
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED3D1DA5F;
	Sat,  1 Mar 2025 02:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eymaQZ1n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B25123C9
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 02:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795478; cv=none; b=bA4XcgZSjjBOCRX8DPY8FdFpnMRr2GXQdiBoZLDm8nJh63IpSX/bjne9Yl/M3/To9z/CzXNZtmstOi2CgbMauXzvPKB5nIhHKXvB8EsbiXp154JHiP+pqsJN3tCXNER/VdaYQVMGYCEViipLktB5HbhRyoVGB+AaDAEk9nMxhh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795478; c=relaxed/simple;
	bh=fg/5kR3orj2asKm0AYhn2cpVJnz8N1UiPrzvxdm4eR0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gZtLzSnsDT6BUheYa7mlxDiKQRNMv7Y5sd7uHX/z3msCgOLEqeZPPQl3ZlcLU2S2NuT+pNA44d6b7j8RA+Pp4Q6sx6UaJm6SXGQX+XevTqVzAzRVolFtVcf/TJp+6GTiNMuTdmhI9jC8u5+dvdvdn4Nf3klWoXUm0nl6TEYBzSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eymaQZ1n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740795476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BP/pYMlVg8/R9mOdeA4pdfrtBgymB2WAqoWa82Ch+dk=;
	b=eymaQZ1nPT7uv4NLB/2FWk3f7zVLzzKiRetO3SkAsoBTKS+Kx/QL+wmYrKXEUwy4gVbNhR
	ZEgVj59ZxAURkZtF3lCD8fjt39Sib3KSBYIe17ZmrOH4M6OdznnmV8GaX7e5lDPtNgtwJS
	pU21kqY/bIOwKulHij2eEoamuepxrpo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-BhfbRIRsM5CKEVGb9xEeKA-1; Fri, 28 Feb 2025 21:17:54 -0500
X-MC-Unique: BhfbRIRsM5CKEVGb9xEeKA-1
X-Mimecast-MFC-AGG-ID: BhfbRIRsM5CKEVGb9xEeKA_1740795474
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-474bb848a7dso23712741cf.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:17:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795474; x=1741400274;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BP/pYMlVg8/R9mOdeA4pdfrtBgymB2WAqoWa82Ch+dk=;
        b=pag+r5BwSg+dbAueP5LhfP7v0OJzjAH+CY6C9EYxAg1BcsnmzblVUk8FMdgppCVsX8
         NzesicZ0TZm0qogoFRx/BLGhOP5yIySrNCbhk1mFNqwP7fD43VWn41JCFOWdbflM71cQ
         WC8BJ1vbe1alR+upi71b3d2APwEsNYaEJu1hXJEvBtZfKyq9sVq4I8jBbvc2w9jLTzMN
         KsSp3mpeAd+XH8i0qftK3nbfHDJwdxYWGrCAUsrqa2fPUooG+YDUHFTndViSzVMf/DLO
         yNFwNknjNNybpRjdnX6oVurRHTdRe0To6oS8oAdRc9GLShcXXaqNRHTTJSfOAx87Iy4/
         DGSQ==
X-Gm-Message-State: AOJu0YxqiZ1nBmhw9WJalxN4PUK6vwU2J3BcDNTZlAZFxotA03729D53
	ikf3k/x0I5+35XWcJ3etg7RhvneFL5Zp2ONqbus1AGCeLUm+U/saNy3yJ6UqVwXSlvMFAC6wCSA
	6hy9eIpuYEcLIJKPsMUhpwgVcS9GopLZVuqKBjioQA765TxuStQ==
X-Gm-Gg: ASbGncvZG2Z9qHj3frL7oRp3nvkabROX0jqUXO184S8MZ3XGigloBL7WA+8w0DsAhN8
	8Fe+S6ggo25P5dRmC0IpsdOkBJvwxympCfiSLnyBTzEtNPYZyvwd5ICfXvf2fEc2RqYCxOIj2bN
	ZSo1bYIqXN+Z1apRZpbmj9j7UqYIUrSROoS2KHSzVr7tN358X7He1MFYf7ga1jey9v0oUxsBcbu
	PL4dEbuc0OQ7IjMySiA1pWmXG7IHSzY8ngkGPP81Z0/Dzk21QMSNYIiF1O+MUQhypFRYlr8K2zj
	fLbkFQg3FrGaQbU=
X-Received: by 2002:a05:622a:244:b0:471:c999:2b81 with SMTP id d75a77b69052e-474bc09fe97mr61531631cf.29.1740795474081;
        Fri, 28 Feb 2025 18:17:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFN/iXX9LAQdg+hriAADmgoksNH2mZe0QdzYNTYyVp1fDU0v/SNpA9L9q5xpDeWRO8auI7xsA==
X-Received: by 2002:a05:622a:244:b0:471:c999:2b81 with SMTP id d75a77b69052e-474bc09fe97mr61531481cf.29.1740795473756;
        Fri, 28 Feb 2025 18:17:53 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47472409a83sm31618611cf.55.2025.02.28.18.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:17:53 -0800 (PST)
Message-ID: <a70458e20e98da9cd6dd1d272cc16b71bfdd4842.camel@redhat.com>
Subject: Re: [RFC PATCH 11/13] KVM: nSVM: Do not reset TLB_CONTROL in VMCB02
 on nested entry
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 21:17:52 -0500
In-Reply-To: <20250205182402.2147495-12-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-12-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> TLB_CONTROL is reset to TLB_CONTROL_DO_NOTHING on nested transitions to
> L2. This is unnecessary because it should always be
> TLB_CONTROL_DO_NOTHING at this point.
> 
> The flow for setting TLB_CONTROL is as follows:
> 1. In vcpu_enter_guest(), servicing a TLB flush request may set it to
> TLB_CONTROL_FLUSH_ASID in svm_flush_tlb_asid().
> 2. In svm_vcpu_run() -> pre_svm_run(), it may get upgraded to
> TLB_CONTROL_FLUSH_ALL_ASID when assigning a new ASID.
> 3. In svm_cpu_run(), it gets reset to TLB_CONTROL_DO_NOTHING after the
> guest is run.
> 
> Hence, TLB_CONTROL is reset after each run and there is no need to do it
> again on every nested transition to L2.
> 
> There is a TODO in nested_svm_transition_tlb_flush() about this reset
> crushing pending TLB flushes. Remove it, as the reset is not really
> crushing anything as explained above.

I am not sure that we don't crush a pending tlb request: 

svm_flush_tlb_asid can also be called by KVM_REQ_TLB_FLUSH
and set the flush request in both vmcbs, thus later the nested_svm_exit_tlb_flush
can crush this request.

But the patch itself does look OK to me, although I might be mistaken.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky


> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 12bb391884299..8e40ff21f7353 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -512,12 +512,7 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
>  		svm->nested.last_asid = svm->nested.ctl.asid;
>  		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>  	}
> -	/*
> -	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
> -	 * things to fix before this can be conditional:
> -	 *
> -	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> -	 */
> +	/* TODO: optimize unconditional TLB flush/MMU sync */
>  	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>  	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>  }
> @@ -536,7 +531,7 @@ static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
>  	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
>  		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>  
> -	/* See nested_svm_entry_tlb_flush() */
> +	/* TODO: optimize unconditional TLB flush/MMU sync */
>  	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>  	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>  }
> @@ -717,9 +712,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  
>  	/* Done at vmrun: asid.  */
>  
> -	/* Also overwritten later if necessary.  */
> -	svm_clear_tlb_ctl_flush(vmcb02);
> -
>  	/* nested_cr3.  */
>  	if (nested_npt_enabled(svm))
>  		nested_svm_init_mmu_context(vcpu);



