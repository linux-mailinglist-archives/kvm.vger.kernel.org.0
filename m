Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A759190686
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 08:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgCXHoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 03:44:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39232 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbgCXHoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 03:44:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so7734019wrt.6;
        Tue, 24 Mar 2020 00:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p/3wlNxcNMFw7jrTzgBG5Dh+ASMnMaWn7+NVW5yaE+k=;
        b=tUszOYrftlO9+6b856cDQrHG5tToImPrEevUVtT/teY4wZADjbHVWlXqoUIhucHq4w
         slHJOo394TpQGJhtW43cge8Wpa+5NwVNExRwavNKqrpsIiD/bbedakuGG1toV3eR223j
         YwZv9jQXl6UPB4epQ9qfCgM/gR9yTpwYtDINYowPBmgJlcNclD9nJ0jhr3nL9X5FU2Jd
         iG1f9zXLY5wIK88KqDyZ9jIG+MAzsO1gTB/DVEPKaCK1t6blW4VyKbe3++9d4DDgJpiR
         67PW3mMeeyd5kP7mbvIB9rbYqHidVG1JUjUuf5/mw7UrdPsknxmVBfRlE/X+824CZ8ER
         lQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p/3wlNxcNMFw7jrTzgBG5Dh+ASMnMaWn7+NVW5yaE+k=;
        b=ZnZahRj/ymVMDOHXMSbBuJXfVsQyczhXtTex8an3VnZvdkVkred15CsEBdRqqfCIx7
         YrHkKl+5zdfAYKMvHC9uH9WTwY8pIiE0pFrISMS/EiwrhSZeb0eD3tsEISrNQiuZIeXC
         FfiHR9VSyyfjQZ+psxp3EEym8cFhX7BfshABTzvKAj9Kw+kP2WdCgFpLi9I8VuaeZylz
         TdadueodARyP3MZq40PNCuSCiZZdL2rkJOWxZnAQkM7rWNKJcAL/mNAZFPWF+l3rMwvx
         WkjdmIPGT8PEVv2OTxBpf0ZW1hwUE6GCRT+C7zHkFu5cdUeNujsgne0zRb4Xm3JKz+DV
         5mXQ==
X-Gm-Message-State: ANhLgQ2LFDo10ivZRTfQV3lOxoHXjhtYfFOgsS3Qqrz2rCz7VE5F6Cnx
        UNVZGBHbhkNbCT6paVpyAl5MiFh2bcM=
X-Google-Smtp-Source: ADFU+vs8fhhyG1rPcb1DEohCIUUUzQsdQojyh3hl96IzMTX0oAyu30B/kdeZKz9uiydhdvtVm6SpKQ==
X-Received: by 2002:adf:9ccb:: with SMTP id h11mr14748514wre.22.1585035843671;
        Tue, 24 Mar 2020 00:44:03 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id r15sm22066122wra.19.2020.03.24.00.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 00:44:03 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v10 6/7] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Tue, 24 Mar 2020 09:43:40 +0200
Message-Id: <20200324074341.1770081-7-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324074341.1770081-1-arilou@gmail.com>
References: <20200324074341.1770081-1-arilou@gmail.com>
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
index 59c6eadb7eca..45ff3098e079 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1832,6 +1832,34 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
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

