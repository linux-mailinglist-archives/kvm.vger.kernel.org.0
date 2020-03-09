Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9263417E6D8
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 19:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgCISUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 14:20:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45142 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbgCISUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 14:20:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id m9so3483809wro.12;
        Mon, 09 Mar 2020 11:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZuvV9ToDUH9Z7nRm33O7cyqYk/jzexuummxj9jXv5cY=;
        b=m8Jok7sCQNWnwYNHKCfaVNpFBSYjbnw+4AXeXL6HRDg5w50lIMUOQXmdyRjOlCBjva
         bWeEaeYa9bVR+z49/0syHHQdJAI6npbwKpKtmWoBEfaCVn+MIprqyVwzMFRzdHTcj2v4
         4ekXOKViqSd79b55C1w76nxRsTalCb+Bz3E+/8OI7XtV3Y+vUNYAONlSTDpZzfCNgp5X
         7e5H7Y5M8OmJRO/GmQ1Hi408DvYGOrm90uWNn15R7eeNdpCrTSPkSyZkrIJt75r/sIP2
         e4YpxVix1tApIlm62wyxcSFJ5SPN+PE74o5SMcd/DI3scNj2c9V3l+ParZc2H69ffVNr
         F4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZuvV9ToDUH9Z7nRm33O7cyqYk/jzexuummxj9jXv5cY=;
        b=dqQj50w6VAB8m/zMxutcit+bgCOBejPHFzZOjqA3MOyjq/Lzc64tUhWH0ijM+pSwpA
         uMkzuMnqaXpdl+8R4fzJ9CzaxOlS1pnLt9nLTnT+ph1LbpGVZsiLD88MxAtHqoFgS9X4
         A9bGis3SBlh6hd89/RvX6C0QZJ806qG+RqsF8KijBxGO5zLZpaL4egCuO5ZkaH26CLym
         CPwswCwdKU+jZxovxfyyvf4wptaPFwA2TCzihqK4sB8VKauXqaboiyDfYJHPmCoqY/5Z
         /0SuaaO4amUT1YeisbMsZ9+e9LMNVEJCzwMcfTaap3wyn4iWVL8fUmNWaj62m7xIBXRL
         d7Jg==
X-Gm-Message-State: ANhLgQ1tkT/WLSMYGDI51LgiBPULeTOECGHQFpANwAmGuki+M2QbRxBA
        iZNiwevo0g0IXe12cAorD+lzgDuauNM=
X-Google-Smtp-Source: ADFU+vugc8hnbGwfCv/PXiYp5Te6OiGBnMt3bbfftT/dAvQvdpTuMo1Bd4/ssIARyE1aJ7OlbNNWhw==
X-Received: by 2002:adf:ed91:: with SMTP id c17mr20494288wro.388.1583778032488;
        Mon, 09 Mar 2020 11:20:32 -0700 (PDT)
Received: from linux.local ([31.154.166.148])
        by smtp.gmail.com with ESMTPSA id t6sm8371828wrr.49.2020.03.09.11.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 11:20:32 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v4 5/5] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Mon,  9 Mar 2020 20:20:17 +0200
Message-Id: <20200309182017.3559534-6-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309182017.3559534-1-arilou@gmail.com>
References: <20200309182017.3559534-1-arilou@gmail.com>
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

