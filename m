Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD10018784B
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 04:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgCQDsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 23:48:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56142 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgCQDsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 23:48:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id 6so19897781wmi.5;
        Mon, 16 Mar 2020 20:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZuvV9ToDUH9Z7nRm33O7cyqYk/jzexuummxj9jXv5cY=;
        b=c6O8ktamHi9Oh1GyrLJHiLvqcY2n95yRD8WVXHjcI4y2QPZJskBYotxTgzZWe7H/dM
         gZi9K1enurdXRobVtnDia1/njMSurTuGiTsTwX3QTVNKzSW4Bu1rdaa2gWJRcMJfssd1
         IdDqBY+kt14HEsps6BsWvmPaYGOT6WTI0lVA3beHO6B/9fW9mZwWjRtKpIUV0oWoXWzN
         Hdh+6R+dmGi3nc2q0eGnk+proPApt+FzAxPh6EiD91B2HDIG+roZaWBRV7CxpA18UcUg
         53r/UdwihU3RM+1XzsrnzrX+GkeqWjIXbGLbWVtJFU7pDxMaU7o5LA2ZlRj7gTRP2wUj
         CrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZuvV9ToDUH9Z7nRm33O7cyqYk/jzexuummxj9jXv5cY=;
        b=FcOs+FF1JB4lGyVHqeN7kwveLuOGZzY81yYJ6TAPRXX+vvyZseBVeiAe7tIzzMf98S
         A6Hk3H0V6XUGvewUMwuGsGSnlBcWWlz1VM4IHhbxtYwonpboRx1IMWhCM+uItP2fpC0q
         aiNVCcy7QZRDeqeBnpZuqPtbisB5Wh4Gk5flVUUw9BhQjDP9PgSaIrrAUXvYIR9Bh5ny
         pfEeGnWCYxp7UU+w1wVeZnF4qku71+lTJFR0aPq/mYnhAVb/BG6k1mWvdqZmkF91POuq
         uKS3tja3EGlH1ty3DB7xOsUFvaatI+jCvoR2k6ugjk81Uf8zFXubqHW8x6UMjs01xz5c
         NmZw==
X-Gm-Message-State: ANhLgQ00jGUdcMRkc/el/Nok1iT52JgrCiBgPllkeP0ZcdUgAjatgzuW
        l17bai9ARJ53vKaYPERpKIGWKLAyVbE=
X-Google-Smtp-Source: ADFU+vsfA6jxyP1iJUAvW6NbOhlQ2O/oBMgB9+EvODJX0K75zDzntITtS6BsqtkMpzvwj6IieWz25g==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr2510097wma.114.1584416909685;
        Mon, 16 Mar 2020 20:48:29 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id c23sm1457757wrb.79.2020.03.16.20.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 20:48:29 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v6 5/5] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Tue, 17 Mar 2020 05:48:04 +0200
Message-Id: <20200317034804.112538-6-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317034804.112538-1-arilou@gmail.com>
References: <20200317034804.112538-1-arilou@gmail.com>
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
index 917b10a637fc..4a77ff61658b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1821,6 +1821,28 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
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

