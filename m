Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8553294DDC
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 15:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441928AbgJUNr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 09:47:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439349AbgJUNr1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 09:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603288046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZfHDVWafNkdCjENNuSOtRhR7dC6UcyfMYDI0dP/L2/8=;
        b=ih+rz6QfMCRzALXSvxkig6AuECRM5jj1uyLP1svOJEYvKKNwWwYG3JNB7eF4X3GSeOlN2c
        jKc3ulWTPMVewpbfcKJZ7RrXCnl0lSwS0NSj3Xeiqeayuufl/BByqY0TXj+Ax3eztAJXjn
        zuqTke5e7GqYquLSu8oPLUAYKqIEnOI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-Mvu6yb1_OhG-oz08XQ5UGw-1; Wed, 21 Oct 2020 09:47:20 -0400
X-MC-Unique: Mvu6yb1_OhG-oz08XQ5UGw-1
Received: by mail-wm1-f72.google.com with SMTP id u5so1578246wme.3
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 06:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZfHDVWafNkdCjENNuSOtRhR7dC6UcyfMYDI0dP/L2/8=;
        b=omUWPTBshysEjo7GwPcv0bh5m7JpBCmzl4KL16TPq689PER5cwjtuPumHPrVyxSKWv
         8DBihDlsk+l+1IelhypUg3fcSE0BiXKHnr3FY4G1uAiV/TV3jgJDShSdssYfwWL/oBY2
         YxEo57wc/IPAVZuzHuNkLzCwdSL93uMaYYWcImD56YGdv/Wy7daNzG4jSAiZ8/W6feJU
         WfIULFNAzDn7LqFFMCoHQ1VpaHStj6OQfdN4bW9Jf+IaCoZ8m/Vkxqe1ixl5hff/ivgQ
         E9+SFP0giQAkGr5mSgjAlI+yAt2tCPxelqVGKXuqN064kd5Ht0YBNGTFraVVCoUFVmsh
         /SwA==
X-Gm-Message-State: AOAM5317GKz/OzmNO+a+iGel1uW5WnDtu0jikdG8LvK9Ocb4sP/BzlpM
        L67xJLhP8ze0OgoT2WGsih4j0Gl4Eh/q1pRQILpN97Ye9mHXQkQ50QZM7j6jRzb6ZlEexg0a+SY
        b5rkMkEBHZZTr
X-Received: by 2002:a5d:6681:: with SMTP id l1mr4986656wru.356.1603288038941;
        Wed, 21 Oct 2020 06:47:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzT3X898JFGFdIxqfOctYKLmPRtbFVtkZcq01x1kOZrSRh4cWtxLWrg6nIpWI6fMefuKxKldA==
X-Received: by 2002:a5d:6681:: with SMTP id l1mr4986638wru.356.1603288038764;
        Wed, 21 Oct 2020 06:47:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e7sm4141284wrm.6.2020.10.21.06.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 06:47:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/10] KVM: VMX: Don't invalidate hv_tlb_eptp if the new EPTP matches
In-Reply-To: <20201020215613.8972-7-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com> <20201020215613.8972-7-sean.j.christopherson@intel.com>
Date:   Wed, 21 Oct 2020 15:47:17 +0200
Message-ID: <87tuun4roa.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Don't invalidate the common EPTP, and thus trigger rechecking of EPTPs
> across all vCPUs, if the new EPTP matches the old/common EPTP.  In all
> likelihood this is a meaningless optimization, but there are (uncommon)
> scenarios where KVM can reload the same EPTP.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4dfde8b64750..e6569bafacdc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3043,7 +3043,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
>  		if (kvm_x86_ops.tlb_remote_flush) {
>  			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>  			to_vmx(vcpu)->ept_pointer = eptp;
> -			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
> +			if (eptp != to_kvm_vmx(kvm)->hv_tlb_eptp)
> +				to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
>  			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>  		}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

