Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B7C167E48
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 14:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgBUNRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 08:17:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30206 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727928AbgBUNRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 08:17:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582291073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V1hq7hichPmlIbNt4BugXxBFFz/gvmzP4rQ+24NrO94=;
        b=gCw0/F2d2LdT8m3BUYc+zh4DGLIywnZBK5SVrPiqpm/oL8U8ZZJAY+kO+jK34dvAnyL1r0
        2cxTqOLidSnJLgfeSfhMA0+RoHZX9o69ODA4I0HRUatZbY8BXv5QQsMvxYs7k0rPgtbKuF
        UM+5+Hq7YC6Ztw6FpStLWZAcsPSpiII=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-rT20qGbXNp6rpWaAGt8tOw-1; Fri, 21 Feb 2020 08:17:49 -0500
X-MC-Unique: rT20qGbXNp6rpWaAGt8tOw-1
Received: by mail-wr1-f69.google.com with SMTP id m15so987712wrs.22
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 05:17:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=V1hq7hichPmlIbNt4BugXxBFFz/gvmzP4rQ+24NrO94=;
        b=opRJX2z4+0948gGpxCrKWNBz6I6ZqXRiQt6/jQiHia0kpk7R6efH+Y+XLNa/un48p1
         x74Zwv81PEEnO2CwkRKcqQQdUzJngxSt6UB4/+Ni+uahumlxzlahss6VqcH9BisSi0a1
         AxZfpndQsJVRV/ijItx+k6uAu1smrRE41Jjhyn9LktnjEKdB+FtbDpFvtfSJ5Bza7hgx
         G+sxEdt0iChKB74BXYwiIATjw1RR4I1uGFfHesZmRWYFyrtJotutBbd2dQm6somgnZlj
         aAke73+rpAOEmOC+9nMO87ztu26lnw4HXsdraAEt7ypvtTwoqqYdzJxaucUD77HX09kT
         61mQ==
X-Gm-Message-State: APjAAAXx/dwEBy33cHwqjpmZXbkkQmbILcio3uCKCcxKXd2fxfR2fzZ/
        B9TCi/77xvNTIpe8o5EEmHyBUfTvDA+KmAR+w/De34WTJS+sXyfCPY2Bn1pi0LJ6MZ0d1Ph0ryB
        7uDsF1OAN5fsi
X-Received: by 2002:adf:f1d0:: with SMTP id z16mr47570311wro.209.1582291068070;
        Fri, 21 Feb 2020 05:17:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzTSKPw3rJbDMXlkNYYK1Amhn6mYuZ/lUidjWbSqXjltG2KRMq2UpnkdFRzz2wb30pBJkhtuw==
X-Received: by 2002:adf:f1d0:: with SMTP id z16mr47570290wro.209.1582291067861;
        Fri, 21 Feb 2020 05:17:47 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o15sm4100095wra.83.2020.02.21.05.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 05:17:46 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] KVM: VMX: Use vpid_sync_context() directly when possible
In-Reply-To: <20200220204356.8837-2-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com> <20200220204356.8837-2-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 14:17:46 +0100
Message-ID: <878skwt6yt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use vpid_sync_context() directly for flows that run if and only if
> enable_vpid=1, or more specifically, nested VMX flows that are gated by
> vmx->nested.msrs.secondary_ctls_high.SECONDARY_EXEC_ENABLE_VPID being
> set, which is allowed if and only if enable_vpid=1.  Because these flows
> call __vmx_flush_tlb() with @invalidate_gpa=false, the if-statement that
> decides between INVEPT and INVVPID will always go down the INVVPID path,
> i.e. call vpid_sync_context() because
> "enable_ept && (invalidate_gpa || !enable_vpid)" always evaluates false.
>
> This helps pave the way toward removing @invalidate_gpa and @vpid from
> __vmx_flush_tlb() and its callers.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 657c2eda357c..19ac4083667f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2466,7 +2466,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		if (nested_cpu_has_vpid(vmcs12) && nested_has_guest_tlb_tag(vcpu)) {
>  			if (vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
>  				vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> -				__vmx_flush_tlb(vcpu, nested_get_vpid02(vcpu), false);
> +				vpid_sync_context(nested_get_vpid02(vcpu));
>  			}
>  		} else {
>  			/*
> @@ -5154,17 +5154,17 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>  			__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR,
>  				vpid02, operand.gla);
>  		} else
> -			__vmx_flush_tlb(vcpu, vpid02, false);
> +			vpid_sync_context(vpid02);

This is a pre-existing condition but coding style requires braces even
for single statements when they were used in another branch.

>  		break;
>  	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
>  	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:
>  		if (!operand.vpid)
>  			return nested_vmx_failValid(vcpu,
>  				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> -		__vmx_flush_tlb(vcpu, vpid02, false);
> +		vpid_sync_context(vpid02);
>  		break;
>  	case VMX_VPID_EXTENT_ALL_CONTEXT:
> -		__vmx_flush_tlb(vcpu, vpid02, false);
> +		vpid_sync_context(vpid02);
>  		break;
>  	default:
>  		WARN_ON_ONCE(1);

Seems to be no change indeed,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

