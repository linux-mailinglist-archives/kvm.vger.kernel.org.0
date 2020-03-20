Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C304F18D5C9
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgCTR27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:28:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35354 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgCTR27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 13:28:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id m3so7289552wmi.0;
        Fri, 20 Mar 2020 10:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bF7ST+Uw4AP61YhxxvxFJK3psApCGN0GVo19aRVBb+k=;
        b=RbkJQ8QQKdMX25KSA2Et2VsxBEOhkKWd8C0EPVQwzaiZAFN5g8J7DK9bEWXsyF7yTy
         2tOt3nYaMcIz/ubNAvPxA/0N1a+jqG7MNrn/iJUNZcyEyTgvlQ4kktJpud4nlaBgt3Rf
         lFOT3OCzL5KCHw5DDD9mUuxkGNeB7teAZ0UnkgZ6MpqtEI5o+jp1ltJOzwSGFBFz0zGx
         EqXgy06s9AXVzxxze3adyYR7MJLR72LZL3V0tzAPXtMTR2nCdCnk0kYR5mEmmuxY75NJ
         JejKiF89e3IOu/1ibgewwR2KfpR/B32rn5V6bbtcX4Hbh1u7SJXLgJAY/oVSujkZR8/Q
         JSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bF7ST+Uw4AP61YhxxvxFJK3psApCGN0GVo19aRVBb+k=;
        b=AbXBoOJ9YJuKh+Wej9mMnlmlRVu6HUiHBOgwUubkOjEDL6QlBVfCBAhVtORrP33kkR
         +kiXVcPRpjINiMYTnCIZ3wtQm/L+9Deb5hjjO4uyepvYj3BntuA7HjTqhm3wuY3S68OM
         C2/JlxW+cvTxLgF9JHkfUYPqRPu/EkJaElH4rdQIWuuYkPU9UPulfYRMXQ+ZMOXpTZDQ
         d0T6D4a61PJdP9f8z9NIznXSaAQ9i9aN8JhFHuqwWZYTgmYpx9LXxjJzpgzT0g/fJuVy
         4RnZMsJmFB16AmWTvuyu1Qioy9TB8OlT8dq0bA/vJIEkSiVyZV2Fq5ulq43Ce5osFGzZ
         mQvA==
X-Gm-Message-State: ANhLgQ15BPXmjlzjV3mV7tApoIPvv98tsNAcmvL70uZvMnDMc2B5C/NN
        8Ji2vuGsrwZH38BY25DRy+Vyw+uYcc4=
X-Google-Smtp-Source: ADFU+vuPRAkCXWQGqIt8DiRO6X0wzcHXMyKhfH4/qINz4oo0MU24Q2dX5qcB01+Hl39yU6ChI4eoZA==
X-Received: by 2002:a1c:25c5:: with SMTP id l188mr12027372wml.105.1584725335196;
        Fri, 20 Mar 2020 10:28:55 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id q4sm11028333wmj.1.2020.03.20.10.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 10:28:54 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v9 6/6] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Fri, 20 Mar 2020 19:28:39 +0200
Message-Id: <20200320172839.1144395-7-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320172839.1144395-1-arilou@gmail.com>
References: <20200320172839.1144395-1-arilou@gmail.com>
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
 arch/x86/kvm/hyperv.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index c130a386f4c1..f17156d36419 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1829,6 +1829,34 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		}
 		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
 		break;
+	case HVCALL_POST_DEBUG_DATA:
+	case HVCALL_RETRIEVE_DEBUG_DATA:
+		if (unlikely(fast)) {
+			ret = HV_STATUS_INVALID_PARAMETER;
+			break;
+		}
+		fallthrough;
+	case HVCALL_RESET_DEBUG_SESSION: {
+		struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+
+		if (!syndbg->active) {
+			ret = HV_STATUS_INVALID_HYPERCALL_CODE;
+			break;
+		}
+
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

