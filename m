Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FDE18AC90
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 06:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgCSF7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 01:59:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38196 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbgCSF7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 01:59:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id l20so639630wmi.3;
        Wed, 18 Mar 2020 22:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+UwRA0A0GjwbulQIly7HU3QJrvwc4z7tFYKRIMXfkEE=;
        b=pqNWIUdmljZLUEXle2UXc3DPl4yvWsO0198cZXDN3nA3FOzZTEQQg9tWMZ4Y69fBS1
         dZja+H/1DsLW8m+tni3OzSSdQ2dGOchd9qVbldgciq85sX7FTsK7sd03z/lZAapd4PgV
         evsoubcVe5ZvwUwEl+R7XbLxv1hkohJLt8TLFSnY4828sBhBSAvpo59T+35kjLiEN1D7
         mRb3CWXIXe10mn7IQ2XH7LEmJb2LdYTo+J0Eqh2kq+xxfxNjVP5fhKiE61eut66j1tKM
         rOOkWV58kF0QmZBLP5vYIHKah+QB+UaV/Gcjs6nxyzpbroh25AmySQDqTGCE93slbLTL
         u8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+UwRA0A0GjwbulQIly7HU3QJrvwc4z7tFYKRIMXfkEE=;
        b=DWsLo9eTuqV9cdj/LDv3MuC8WeSAdkOUuYfTyyJOqEyjllCZlQgVRl9ZGpPo4uPkR2
         ySc8QldWiDqBX6I6Pkpuzd/qJSysi0TDK21II8erMOm3oP4QlZ++xBaqCgkRcPQEoAeW
         4Y1H77lz5RDHbgplfihp0YQhDFUgZ5ufcmeWw43FMxK3QkqX3VH1tdBkKFnsraY1qrhf
         44pB+/LNLAQB8Q72vVXVhUO+vhm29FSrYg0gWmJA6x75Lm8xuK1XI8PLS4p85zfhOQ/q
         /XlvTqFX7qgmX+qTbzU6Tq8OduDnBpyC9QECtutj5JiC9FiFuzqk8f/deBsG4frHeSS/
         HcCA==
X-Gm-Message-State: ANhLgQ300gt6pRMNkOWZqs/ZlKVE6SMVYY8PFEOimYOwzR4eG5JvBO8L
        PkwLtZaWXEcvkN1DiFlkWKT/MOTFSjY=
X-Google-Smtp-Source: ADFU+vsMrF6LFXzcVt7ZSe3OO8Z+mrvnlumfyNbqN7y5Z6EABurZVADRCEufaI9ZRJmI3bkDtwC75Q==
X-Received: by 2002:a7b:c305:: with SMTP id k5mr1632966wmj.189.1584597541944;
        Wed, 18 Mar 2020 22:59:01 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id n2sm1884174wro.25.2020.03.18.22.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 22:59:01 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v7 5/5] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Thu, 19 Mar 2020 07:58:42 +0200
Message-Id: <20200319055842.673513-6-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319055842.673513-1-arilou@gmail.com>
References: <20200319055842.673513-1-arilou@gmail.com>
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
index 67f9893150c3..a62a330ed322 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1827,6 +1827,34 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
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

