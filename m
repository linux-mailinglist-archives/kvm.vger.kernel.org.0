Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552EF1E7F19
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 15:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgE2NqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 09:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbgE2NqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 09:46:04 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C292C03E969;
        Fri, 29 May 2020 06:46:04 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k26so3618078wmi.4;
        Fri, 29 May 2020 06:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f2W7JYL0AlKzHXRopAS228NJAzBggI+nNwpElzxyOvA=;
        b=tMoL97qp+tyqWNtFdSIrwLbrnMDGEGBFnvBen8sQomXNZHxPZnHFItqfq5HBJ1Nk66
         SXSLsEOahG9Us2d+CSygrRmw00jfBVKttznmcitg+g3P7vovqIxdgrNP/lPeT+goSo+y
         5aiTP7CwlEOFT7LHduZbE7AiN/we2TMurGgaYsR5pIVp+B35L5j1Ep5QeBYXJss0b3FQ
         o+HeV3hmxOPaxRK1gYBzWVl6tLcI4z51X/oCKZp/S6SQmQA8OvU9DbhTM4w3OrA7jwfL
         cVvh9O4XRhzCLuZ4iHY7OvW8rQe0tyDE0/pimbepLfdlOl9oWcCvOjwowotj2TBrEbZR
         tGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f2W7JYL0AlKzHXRopAS228NJAzBggI+nNwpElzxyOvA=;
        b=tNEr5EmDK0DsWqp0VFKGMyTWU6G6gQ72znRncbKi1JnNEGA4vdIdJjlQmXw3vuwQPD
         xeAtZXMusEofN9moLy4cAtyRqhdkSOdEg89h//69X/cNKvMYpofxkag32qV++gMUrbos
         KKZFxLR/GTTri6tPKAQ3Juca3fS20DdrWXksaMYopyQebt2tkljFTlyoVnp0/SzF7MUF
         Tk4rFpF2GPvejC+AtjDTXV7S+7XKEMxH0ByQZnlrlkGyDEk7PAWcIG1eQP597RRvwWRU
         fXlI5KGkICEmFNigk70nULcEN3fNYitW46v+HMdWbigkJdd7TgExIR9wJodU/ZIuS8i2
         NLCg==
X-Gm-Message-State: AOAM53099SPFnyYf/fZzyIf0TTfO4RRUCL+ia/UIJrJAYW2pSS14JkZ7
        TesC5qH8X2X0uG8KSNWVUCwQo3Yj
X-Google-Smtp-Source: ABdhPJyM0LjmtsOeq0OD3YcjZWRHdyuoO15u9bmdP/6JCks8AUju+qHjEByiXg0VSbW4bOfzCFkRxg==
X-Received: by 2002:a1c:23d2:: with SMTP id j201mr8568639wmj.186.1590759962768;
        Fri, 29 May 2020 06:46:02 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id y37sm12347263wrd.55.2020.05.29.06.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 06:46:02 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, rvkagan@yandex-team.ru,
        Jon Doron <arilou@gmail.com>
Subject: [PATCH v12 5/6] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Fri, 29 May 2020 16:45:42 +0300
Message-Id: <20200529134543.1127440-6-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529134543.1127440-1-arilou@gmail.com>
References: <20200529134543.1127440-1-arilou@gmail.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 3730c38f4f71..640fd98583b1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1836,6 +1836,34 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
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
+		if (!kvm_hv_is_syndbg_enabled(vcpu)) {
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

