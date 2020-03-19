Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4C018ACEA
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCSGi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:38:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40893 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbgCSGi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:38:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id f3so1237376wrw.7;
        Wed, 18 Mar 2020 23:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y+nktaaLq//rt3pTh1qwB5YDzhFHsK2WFYNus7vyrUs=;
        b=PcTTe1qW4BuWNCZuXkY4Yu9l5TXlSVsYThA8XXB4Tyjj+MKlw/EUAKpPn/rU7VfqDz
         6xsvSMJgUFkopTEOb0T17dtfOnhCD72A8IeDvQUN3LQCTXpHTXhKDZ/qAY39N///pl1R
         HBaRHgPmiLicOOarbBjuQHsodwCGX6AZocU92I8uNS3WUanNHF4F9B6WlbS78KHH5rOY
         EeaQ1CNn7mTd+iRa8D6Enq5T/L5mAjxK12PscTCvAtb4cn9VDzSnzr0BYrYLdREH60sa
         8nBrIdrI/iXUb+t2nYwe2x7aXHJJHZ81K4v5zDW+s75N6uwVW+rL81ofrg/GOlXNVjbv
         KBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y+nktaaLq//rt3pTh1qwB5YDzhFHsK2WFYNus7vyrUs=;
        b=Ht0Dl47WiIS629paD2CxI40BAjNg3I2/2PjsujjXmOd9SAbcxAa/A+TA4WitNe84sR
         20f4IMY4W+sLhq5w4fFAvZ8gdv/Ng6sBIwyhWxY+irVammYMqYbPkirjDRUMIRsw85Ay
         kFLh/iEn4Ln0Lt943i7BxyQS7FwdvjZ/Sf8kjGOfS3JYPorpUrjqmmFxGiYph4gueTe5
         GxZUo9+ABm/BXwmDoinVlo5YQ3oaeIAOBMMhQpOitJgyvETq5btflQhthLaLLJ+hLp4o
         BQuhCIRQ3DHBeijrlMVA52yoP8fyUHt7MCCTZoCp7bceQOpLHCg27JzI9KtzgM1KwUlG
         Gb2A==
X-Gm-Message-State: ANhLgQ1bZ08CDMwsZq/2ec9ZIC3iS+pHlqoH1iq2qQtruwF4CKxuJYcq
        J7wBSyw+ReSlTNndjFMYQLZICiwh+l8=
X-Google-Smtp-Source: ADFU+vtCaxbcho0z5S9O/qAR+pn9lMBXMGfcXhmi6wSNRf3XTdR72nn/XquXpyT9oI9iQhm/eYzwsQ==
X-Received: by 2002:a5d:66c2:: with SMTP id k2mr2043019wrw.408.1584599934549;
        Wed, 18 Mar 2020 23:38:54 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id l13sm1945665wrm.57.2020.03.18.23.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 23:38:54 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v8 5/5] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Thu, 19 Mar 2020 08:38:36 +0200
Message-Id: <20200319063836.678562-6-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319063836.678562-1-arilou@gmail.com>
References: <20200319063836.678562-1-arilou@gmail.com>
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
index 64f267f10049..0c3d2224dfad 100644
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

