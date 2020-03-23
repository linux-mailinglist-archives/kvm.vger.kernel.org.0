Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE40218F878
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 16:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgCWPYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 11:24:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:47560 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727099AbgCWPYM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 11:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584977051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FY0p3cqwN918CaX62qQRQ+vCrkce6hk743BEWFF5l9Q=;
        b=D910UNy5ex7B3CYBFBiu1cXO2dZdLc4IBIw4QI3KyjmuGZrMyjp+Ca8NQy7nR6CNB9Euwa
        NN54IKftsM1YaUFtJWL+6XEx+vmieJozphhr/90tE7sTCGvJoEUphmsFn5b5hYHEE9PUUp
        qYM4c1Gb78RhGcsrK5sdg8u/IwP2V1c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-7ApNnoHgNxizVTvz00Ha8Q-1; Mon, 23 Mar 2020 11:24:09 -0400
X-MC-Unique: 7ApNnoHgNxizVTvz00Ha8Q-1
Received: by mail-wr1-f70.google.com with SMTP id e10so5763260wru.6
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 08:24:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FY0p3cqwN918CaX62qQRQ+vCrkce6hk743BEWFF5l9Q=;
        b=cQWyRjvfNkAb+7xHxXhc1I8MgjBdNVgDJkN2+fAAzjuVSCvVH7h6D7fe4SPGELeOlB
         JoyjZW23PqhuOY62TccbqNNrmJTP5UAqblra9eMpAZ2vzDMBM0Glxoud9FDn51fJj0XN
         OL8uRahQkHTB5hzVeUaHXCgRVR/nGpSC4eR50LoDNjw24IOQmeP8xom/+6kEbbpgi+xA
         8Y2KPRia8eNVQ8YAG6w7fFY8yiZ2rIxuDgYW5lx3Zp227595uEr9E1Jr1SnP535m++Ax
         RGNBHhHlkYRquiq/iB6OU8oChzctdFGSY5JkGFUyDPfYDjv7TqiPtRHl8bnhjRUmnX7P
         wzPg==
X-Gm-Message-State: ANhLgQ1nLEmi2mvZSjVsE723mZq2uyM6bhX0lFw+WN4rUhxp3smWS6J2
        vpcq6Irei7bDjL3BqMpCH1I1dMvbuXo4nG4exAh9AujgeEEYq9QEe2xRgew8ti8z6Zotf/z79U6
        iVs6RYlprp2RF
X-Received: by 2002:a05:600c:2943:: with SMTP id n3mr6891033wmd.119.1584977048259;
        Mon, 23 Mar 2020 08:24:08 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtkDVZhYjHAo50IfPuPfL1qa/i0rdqwGid9Gyb/xkxCwcgPDAvRvLodCDXDNhgK5xA5ft7xSw==
X-Received: by 2002:a05:600c:2943:: with SMTP id n3mr6891012wmd.119.1584977048031;
        Mon, 23 Mar 2020 08:24:08 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f10sm24052628wrw.96.2020.03.23.08.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 08:24:07 -0700 (PDT)
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
Subject: Re: [PATCH v3 03/37] KVM: nVMX: Invalidate all EPTP contexts when emulating INVEPT for L1
In-Reply-To: <20200320212833.3507-4-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-4-sean.j.christopherson@intel.com>
Date:   Mon, 23 Mar 2020 16:24:05 +0100
Message-ID: <87y2rr857u.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Free all L2 (guest_mmu) roots when emulating INVEPT for L1.  Outstanding
> changes to the EPT tables managed by L1 need to be recognized, and
> relying on KVM to always flush L2's EPTP context on nested VM-Enter is
> dangerous.
>
> Similar to handle_invpcid(), rely on kvm_mmu_free_roots() to do a remote
> TLB flush if necessary, e.g. if L1 has never entered L2 then there is
> nothing to be done.
>
> Nuking all L2 roots is overkill for the single-context variant, but it's
> the safe and easy bet.  A more precise zap mechanism will be added in
> the future.  Add a TODO to call out that KVM only needs to invalidate
> affected contexts.
>
> Fixes: b119019847fbc ("kvm: nVMX: Remove unnecessary sync_roots from handle_invept")
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f3774cef4fd4..9624cea4ed9f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5160,12 +5160,12 @@ static int handle_invept(struct kvm_vcpu *vcpu)
>  		if (!nested_vmx_check_eptp(vcpu, operand.eptp))
>  			return nested_vmx_failValid(vcpu,
>  				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> +
> +		/* TODO: sync only the target EPTP context. */
>  		fallthrough;
>  	case VMX_EPT_EXTENT_GLOBAL:
> -	/*
> -	 * TODO: Sync the necessary shadow EPT roots here, rather than
> -	 * at the next emulated VM-entry.
> -	 */
> +		kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu,
> +				   KVM_MMU_ROOTS_ALL);
>  		break;

An ignorant reader may wonder "and how do we know that L1 actaully uses
EPT" as he may find out that guest_mmu is not being used otherwise. The
answer to the question will likely be "if L1 doesn't use EPT for some of
its guests than there's nothing we should do here as we will be
resetting root_mmu when switching to/from them". Hope the ignorant
reviewer typing this is not very wrong :-)

>  	default:
>  		BUG_ON(1);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

