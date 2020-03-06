Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6521217C322
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 17:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCFQjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 11:39:17 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44417 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgCFQjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 11:39:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id n7so3099345wrt.11;
        Fri, 06 Mar 2020 08:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Po8ghn9sRSyYfmDTi+lZZbS3gjK6dyrUhJNG+tTwLV8=;
        b=jBql44M21TnlUvBslRFIzmOeZwCiUQlau6sMsVF3bB0ewubmwCHU+D0qWV9uHVUlgW
         TM+CHOF1gQqbmBFhdOaYQtdwO0k/muGaGtwNwj3IC1g0XW6WYycdSdchIUPPKNLnQTXi
         gk3paS5PAe2gCLbVsC2FVUQLC980D2fIR6JHU3ZkY6UqSrwSskrhpsB86Waa8wf4GrpI
         HHx0+jgiFwHoEDLu0r320UKhAR6qSVLeDmhrafx4vFMcEqgavxTFsm6vbChehZL316P/
         YwtT13Eqp2cf6UExoHAd7nk0qutsZhtHDIiA7MeYJ0Rcqp2lxxnwLaWW/bU5fv3sMPCo
         pG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Po8ghn9sRSyYfmDTi+lZZbS3gjK6dyrUhJNG+tTwLV8=;
        b=hAzOMr/mLQh6VqL9uApqN01jXw87CvEi34dQsYdIsWVdojHo8S3pzmkckHgzHAh1td
         U6CuCMCpBuBgI2EIIoF0LsfUcEFYe6gzcjmO1L3kmjtTl0YS61V/eluWhA54VBnpnFOQ
         dxUndGhuzcxdfQ3vLDC8J2B5y+Pg1j1ANvkRjcWxRXfVhTYgpyw7EqajjQCPm5UKOGo/
         Xuo6+joPrSpScvgoFVDNu3fMxGD73WoNGyF11z4QD7uv4cYs4n/xUpSAiThaGFO82V67
         xD8CEVAkV1lRHGLH5tP+a+3Z7bJB+ArJN9+6W7QM1d1wmjw0mOW5nD6mUXIAxZ8UgCKy
         BpQg==
X-Gm-Message-State: ANhLgQ39fcbs3zqGZd/8y2pAcgooziuwm0lYtMC6bAIB+oSEEUPh4ty9
        9Rpdq8tIBCwR06TCguKayp47AuKm
X-Google-Smtp-Source: ADFU+vuCh1BLncWUkoQnSEtINCW5/ohoFUEgcWFy0HYC7rbc98C4PtmT6iHJT+Ky7GL/46s7ZJmhPA==
X-Received: by 2002:adf:e808:: with SMTP id o8mr4735660wrm.8.1583512754719;
        Fri, 06 Mar 2020 08:39:14 -0800 (PST)
Received: from linux.local ([199.203.162.213])
        by smtp.gmail.com with ESMTPSA id n24sm8812760wra.61.2020.03.06.08.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 08:39:14 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v3 5/5] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Fri,  6 Mar 2020 18:39:09 +0200
Message-Id: <20200306163909.1020369-6-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306163909.1020369-1-arilou@gmail.com>
References: <20200306163909.1020369-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is another mode for the synthetic debugger which uses hypercalls
to send/recv network data instead of the MSR interface.

This interface is much slower and less recommended since you might get
a lot of VMExits while KDVM polling for new packets to recv, rather
than simply checking the pending page to see if there is data avialble
and then request.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 67628796f514..ba3b1e3406ef 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1820,6 +1820,28 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		}
 		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
 		break;
+	case HVCALL_POST_DEBUG_DATA:
+	case HVCALL_RETRIEVE_DEBUG_DATA:
+		if (unlikely(fast)) {
+			ret = HV_STATUS_INVALID_PARAMETER;
+			break;
+		}
+		/* fallthrough */
+	case HVCALL_RESET_DEBUG_SESSION: {
+		struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+		if (!(syndbg->options & HV_X64_SYNDBG_OPTION_USE_HCALLS)) {
+			ret = HV_STATUS_OPERATION_DENIED;
+			break;
+		}
+		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
+		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
+		vcpu->run->hyperv.u.hcall.input = param;
+		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
+		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
+		vcpu->arch.complete_userspace_io =
+				kvm_hv_hypercall_complete_userspace;
+		return 0;
+	}
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
 		break;
-- 
2.24.1

