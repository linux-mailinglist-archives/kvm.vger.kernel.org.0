Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD68192713
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 12:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgCYL0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 07:26:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:57094 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727290AbgCYL0G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 07:26:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585135564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ae3Bh1ZlBbd/KBQwXPKN94pXtAOxkLC5jA3b9yhby3k=;
        b=auIs9v0qfrhrMr50Ie6U/lh5krwTQKRrZU+20Ov2BB/4LaLwPGHfIeoDFstJmF0qutZevE
        z1JcTa/x1HdhqjwzTJV1Kmk6q6EkTyU1m3Wd9d+HWnEAz0K7CVXtTxjmcn1ddE9OgwH8+1
        u3yXGlqcP6TW/2h3C9IcSiuDA43IjJM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-bZb-MNbaO6OHmhZLCBKVRw-1; Wed, 25 Mar 2020 07:26:03 -0400
X-MC-Unique: bZb-MNbaO6OHmhZLCBKVRw-1
Received: by mail-wm1-f69.google.com with SMTP id m4so2383938wme.0
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 04:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ae3Bh1ZlBbd/KBQwXPKN94pXtAOxkLC5jA3b9yhby3k=;
        b=fU8PubUSULzDq+41oNbZ0nIOBJgsgVixjannLd06J5TtshLWhTbgA/7izcRzzRraa2
         yYey3IpSPbh+bLwsqJZMTEqsQitgUurH/azLle990aEZkGXsAf5t2qlNWSS6S+YIF+xf
         jXF4jnOa4Sk05mMtnA/ebylOAmoCIVU8nBSKd/WLZsxIpLbg+7XNApCBWCSj4AcOKyKf
         DgOmCYgmMn3D2AbgthlweHLUnHez25SHW2zFPm1MZtDC5tZ9uaZBimIcEokVLL6YUor3
         adhNph0qx2rI7LpVMWnlOUnnG3X9jJAD35m8chV6P2/ZkSu8I6NA26ueT7zkIbm0G95N
         EIvQ==
X-Gm-Message-State: ANhLgQ08dnnAhtvRGfglVi0VgI/x3zAgNAr+PXR51AgQxNXAHaHbq2Ze
        +lEhPaWJil4OhGBykYRGbaK+VgBJiD2pP2TxWx8YMyVc37PhFZW81z70NGuUS6gYQ32P/adsjo+
        q3l3gBr0rnD6h
X-Received: by 2002:adf:db49:: with SMTP id f9mr2754394wrj.145.1585135562106;
        Wed, 25 Mar 2020 04:26:02 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vspLasieFBMXL6fs0QKpXZ526e9DIUxbZmAHTCJGxNfXakPND5GK++oNxLnkbN0fT32b1RV3w==
X-Received: by 2002:adf:db49:: with SMTP id f9mr2754380wrj.145.1585135561893;
        Wed, 25 Mar 2020 04:26:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u16sm33886558wro.23.2020.03.25.04.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 04:26:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 19/37] KVM: nVMX: Move nested_get_vpid02() to vmx/nested.h
In-Reply-To: <20200320212833.3507-20-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-20-sean.j.christopherson@intel.com>
Date:   Wed, 25 Mar 2020 12:25:59 +0100
Message-ID: <87r1xg65h4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move nested_get_vpid02() to vmx/nested.h so that a future patch can
> reference it from vmx.c to implement context-specific TLB flushing.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 7 -------
>  arch/x86/kvm/vmx/nested.h | 7 +++++++
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0c71db6fec5a..77819d890088 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1154,13 +1154,6 @@ static bool nested_has_guest_tlb_tag(struct kvm_vcpu *vcpu)
>  	       (nested_cpu_has_vpid(vmcs12) && to_vmx(vcpu)->nested.vpid02);
>  }
>  
> -static u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -
> -	return vmx->nested.vpid02 ? vmx->nested.vpid02 : vmx->vpid;
> -}
> -
>  static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
>  {
>  	superset &= mask;
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 21d36652f213..debc5eeb5757 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -60,6 +60,13 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
>  		vmx->nested.hv_evmcs;
>  }
>  
> +static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	return vmx->nested.vpid02 ? vmx->nested.vpid02 : vmx->vpid;
> +}
> +
>  static inline unsigned long nested_ept_get_eptp(struct kvm_vcpu *vcpu)
>  {
>  	/* return the page table to be shadowed - in our case, EPT12 */

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

