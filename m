Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0335E1CF947
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 17:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgELPeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 11:34:04 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:35700 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730636AbgELPeE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 11:34:04 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id E2A9E2E1557;
        Tue, 12 May 2020 18:33:54 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id BrgdKwMumx-XsbKW7Pj;
        Tue, 12 May 2020 18:33:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589297634; bh=X6ucqqLcRjp+mBIWGLRaFARVZiQhddCV0jDHU+k7NKs=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=jstwrtRh5tRqS92WBC4JfxHprGoqKnunfgkt7EdNM/VhResKzPaWqg3Cbi+gyeRyt
         W6mL6Im1dCGhH2J+n8kg/Kka/nOdn2CNLXNR/gZuT8U6s131iKqpCFCXVtiOUcPVKl
         aDRuknTIHecT40yPo9t2VvEynX0NkOdc9vRVOzoo=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:1303::1:e])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id DuDgN1TaZH-XsYGmraP;
        Tue, 12 May 2020 18:33:54 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Tue, 12 May 2020 18:33:53 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH v11 6/7] x86/kvm/hyper-v: Add support for synthetic
 debugger via hypercalls
Message-ID: <20200512153353.GB9944@rvkaganb.lan>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-7-arilou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424113746.3473563-7-arilou@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:37:45PM +0300, Jon Doron wrote:
> There is another mode for the synthetic debugger which uses hypercalls
> to send/recv network data instead of the MSR interface.
> 
> This interface is much slower and less recommended since you might get
> a lot of VMExits while KDVM polling for new packets to recv, rather
> than simply checking the pending page to see if there is data avialble
> and then request.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 524b5466a515..744bcef88c70 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1832,6 +1832,34 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		}
>  		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
>  		break;
> +	case HVCALL_POST_DEBUG_DATA:
> +	case HVCALL_RETRIEVE_DEBUG_DATA:
> +		if (unlikely(fast)) {
> +			ret = HV_STATUS_INVALID_PARAMETER;
> +			break;
> +		}
> +		fallthrough;
> +	case HVCALL_RESET_DEBUG_SESSION: {
> +		struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +
> +		if (!syndbg->active) {
> +			ret = HV_STATUS_INVALID_HYPERCALL_CODE;
> +			break;
> +		}
> +
> +		if (!(syndbg->options & HV_X64_SYNDBG_OPTION_USE_HCALLS)) {
> +			ret = HV_STATUS_OPERATION_DENIED;
> +			break;
> +		}
> +		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> +		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> +		vcpu->run->hyperv.u.hcall.input = param;
> +		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
> +		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
> +		vcpu->arch.complete_userspace_io =
> +				kvm_hv_hypercall_complete_userspace;
> +		return 0;
> +	}

I'd personally just push every hyperv hypercall not recognized by the
kernel to userspace.  Smth like this:

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bcefa9d4e57e..f0404df0f488 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1644,6 +1644,48 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		}
 		kvm_vcpu_on_spin(vcpu, true);
 		break;
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
+		if (unlikely(fast || !rep_cnt || rep_idx)) {
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		}
+		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
+		break;
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
+		if (unlikely(fast || rep)) {
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		}
+		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
+		break;
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
+		if (unlikely(fast || !rep_cnt || rep_idx)) {
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		}
+		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
+		break;
+	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
+		if (unlikely(fast || rep)) {
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		}
+		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
+		break;
+	case HVCALL_SEND_IPI:
+		if (unlikely(rep)) {
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		}
+		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, false, fast);
+		break;
+	case HVCALL_SEND_IPI_EX:
+		if (unlikely(fast || rep)) {
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		}
+		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
+		break;
 	case HVCALL_SIGNAL_EVENT:
 		if (unlikely(rep)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
@@ -1653,12 +1695,8 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		if (ret != HV_STATUS_INVALID_PORT_ID)
 			break;
 		/* fall through - maybe userspace knows this conn_id. */
-	case HVCALL_POST_MESSAGE:
-		/* don't bother userspace if it has no way to handle it */
-		if (unlikely(rep || !vcpu_to_synic(vcpu)->active)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
+	default:
+		/* forward unrecognized hypercalls to userspace */
 		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
 		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
 		vcpu->run->hyperv.u.hcall.input = param;
@@ -1667,51 +1705,6 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->arch.complete_userspace_io =
 				kvm_hv_hypercall_complete_userspace;
 		return 0;
-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
-		if (unlikely(fast || !rep_cnt || rep_idx)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
-		break;
-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE:
-		if (unlikely(fast || rep)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, false);
-		break;
-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX:
-		if (unlikely(fast || !rep_cnt || rep_idx)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
-		break;
-	case HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX:
-		if (unlikely(fast || rep)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_flush_tlb(vcpu, ingpa, rep_cnt, true);
-		break;
-	case HVCALL_SEND_IPI:
-		if (unlikely(rep)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, false, fast);
-		break;
-	case HVCALL_SEND_IPI_EX:
-		if (unlikely(fast || rep)) {
-			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
-			break;
-		}
-		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
-		break;
-	default:
-		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
-		break;
 	}
 
 	return kvm_hv_hypercall_complete(vcpu, ret);

(would also need a kvm cap for that)

Roman.
