Return-Path: <kvm+bounces-42611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A90C2A7B043
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E86653B9646
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F4B25DB1D;
	Thu,  3 Apr 2025 20:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQrH+J3b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A02625DB1A
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743711039; cv=none; b=bjyga1McB06J1FP3lAq5f5YutW41zy/YmEv0zz7Zh5dHn+ZByPOjezGfWAap04TCt2yckBej28jmRbfd2rc1cK03PVBmm0KgUGgZ99mWn5rpcaPS15CBs78zZmN+pYY1pzMENIXdzshUUS+fmaccD41cC7gPYj4+woZXcwBvcQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743711039; c=relaxed/simple;
	bh=lKwS24qlMJz7qt2FuBC0A07MddXWYIbdcvU5/ac6Y0g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pJ1OPOhpPzYj16uUc0JIj2qj4UucJ2qBhrgAitlZNyrvF3ejInnPpEVHv2oBcOOOl+t0obrT6sQiOQajPPg6MJEaUT0c9S80RBbutgXJ/ereHkX8TIeos7WkGQFL5KLyDip6U5midoyH7OZG2JsfChzz8WV+zn3rmXTlHSV0ruo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQrH+J3b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743711036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQfRBMmfXvl2EtXcu+A1ryta0Jtqgfvr8XjFX8n/Bo4=;
	b=EQrH+J3bdl/qWrJ9TsexMdzKmJ+DWE5bEX+ZKd0CmfmFrIi8Oc7VmBLvF5uC1j2LTntoMM
	310TPkTnXDUogHbNMQNfjQIra4aLLZt1UfihopIdBGzv+j07qEtmcg3lmqauLUTMj8yPfm
	RvZcFbkfOJUdUJtZkSsc7pr+P7ax1KE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-S6cgB6qEOlSuuz4w5lRHEA-1; Thu, 03 Apr 2025 16:10:34 -0400
X-MC-Unique: S6cgB6qEOlSuuz4w5lRHEA-1
X-Mimecast-MFC-AGG-ID: S6cgB6qEOlSuuz4w5lRHEA_1743711034
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4768488f4d7so24122201cf.0
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743711034; x=1744315834;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NQfRBMmfXvl2EtXcu+A1ryta0Jtqgfvr8XjFX8n/Bo4=;
        b=aU7iS+vu/gAVTE0UiqNmcTEeB/wUJCOzB0K4K+37jm+vVhJlf/4r0o2wgmmLQRCrWp
         HGaU9lnf1ZFAwUMGw2JV6Wptl4r8+T/mYhgyX/FJmIII+v3mzK/XJALoApQqL52jsPRr
         R/17OL/gLPHz4/J9OeeOKP5r+/IaSnDNOrO493zG4xcyZEAIfcQqGLY9yTAK5B5IQOya
         Kw+aobHmbg5ZONy8w2+HtPkUzee0uij6zEkAgnOOYzi7pJYg7sQGDLaor50Gcrsoap2L
         fVtY8Zjv2SKqduThMJrqlrb4h5jFQ0mMjWkoSO+VqRxEmHyq7SWXkQKBa/MhKTbZjCFb
         gaAA==
X-Forwarded-Encrypted: i=1; AJvYcCVDTEpofmJ9T3XClu8qyzwuCj6OIBS+5c/WZ/Mb+5as1WOSeNJSW4HCmHAh53dQg+pJ0bw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUMlaUlLSPucVZXezYtk0kdRu1Y6Pfn9y4JfQX8/Z7zC47h09D
	gWWPVm3eTq3jt8hxUBk+nsw/49WzrrtyACBUhiJppDePotO1beI1J7E+qhQHNlHAMbnRN7Ngnnj
	32BSUbA4sRVZl/FP3xL6UT8bDYHIlM2whI0GNli6N0xNeJgX6+g==
X-Gm-Gg: ASbGncvj7YJkBTivBwQ8MqVDhlpMUHPMbQt4Qpw8OoC0t3gjpYpNQlyfu26OAQ8VBff
	VMvZhIULJ4JYH5wwATNNFShDIOJHwFuJM7MP430PP+xYQDdllaOQCNgutbY8xdLdlmaSqN5Tm8E
	4qs3V55kki53/t67Re02zPsPm4uNQKhIcB6dWWYJ80ZU9Zcml5NjnTbhuaKSAWCxJHSbWc8GLRB
	oyeX9sa9IxWcq+Ob0EktxZZ8zK7z4aaSl+NKrh0lVeEscMhb8z9j7vsC/R/aEBcKBXTKDGihoq1
	f9cbRtp4RQ95vGs=
X-Received: by 2002:ac8:5889:0:b0:476:7d74:dd06 with SMTP id d75a77b69052e-479249db1bfmr10412431cf.51.1743711034346;
        Thu, 03 Apr 2025 13:10:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiUEiCUHJTJfibAxa5AGVMBjsOkQnjxbSJU3EuUsbs9Vq7cDKMyvdSvO0TjSiHxiVONUSxyA==
X-Received: by 2002:ac8:5889:0:b0:476:7d74:dd06 with SMTP id d75a77b69052e-479249db1bfmr10412131cf.51.1743711034055;
        Thu, 03 Apr 2025 13:10:34 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4791b05895dsm11593541cf.11.2025.04.03.13.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:10:33 -0700 (PDT)
Message-ID: <a377b99b3bc3f6417d098d50351915ddb410fb55.camel@redhat.com>
Subject: Re: [RFC PATCH 17/24] KVM: nSVM: Flush both L1 and L2 ASIDs on
 KVM_REQ_TLB_FLUSH
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:10:32 -0400
In-Reply-To: <20250326193619.3714986-18-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-18-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> KVM_REQ_TLB_FLUSH is used to flush all TLB entries for all contexts
> (e.g. in kvm_flush_remote_tlbs()). Flush both L1 and L2 ASIDs in
> svm_flush_tlb_all() to handle it appropriately.
> 
> This is currently not required as nested transitions do unconditional
> TLB flushes, but this is a step toward eliminating that.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c |  1 -
>  arch/x86/kvm/svm/svm.c    | 10 ++--------
>  2 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c336ab63c6da3..56a4ff480bb3d 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -491,7 +491,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
>  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
>  	 * things to fix before this can be conditional:
>  	 *
> -	 *  - Flush TLBs for both L1 and L2 remote TLB flush
>  	 *  - Honor L1's request to flush an ASID on nested VMRUN
>  	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
>  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fb6b9f88a1504..4cad1085936bb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4064,14 +4064,8 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
>  	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
>  		hv_flush_remote_tlbs(vcpu->kvm);
>  
> -	/*
> -	 * Flush only the current ASID even if the TLB flush was invoked via
> -	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
> -	 * ASIDs to be flushed, KVM uses a single ASID for L1 and L2, and
> -	 * unconditionally does a TLB flush on both nested VM-Enter and nested
> -	 * VM-Exit (via kvm_mmu_reset_context()).
> -	 */
> -	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
> +	svm_flush_tlb_asid(vcpu, false);
> +	svm_flush_tlb_asid(vcpu, true);
>  }
>  
>  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




