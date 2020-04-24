Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C181B7341
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgDXLiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgDXLiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:38:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080F6C09B045;
        Fri, 24 Apr 2020 04:38:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i10so10373479wrv.10;
        Fri, 24 Apr 2020 04:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FKcPWMZCAUe8c6acnbxNFfpNt2+SpTEs6pyxNkpmr/I=;
        b=Jo5wQIahpC0sx0TEACrJHHEDzufnSEw8oIoz2PtdBLWKmuCaCv/2wMGvfRg3+BX+K6
         IWhXB4tcBQcnvhBgSrn/aNX0aszmq//i4V3mE2pVom+ml4MpDCCaoF/OoEceuLQSm0b7
         uihewejh4RknzT8F/RU+OQk5Dms5vA0O0VBvVyJE+dHpJpGBD+1LwBCAu8avxddb3IGM
         yzazQq8Uf1eRyX4EwH4ZYgwKdtPHNPRBF0bPXY7ItesbiB1/jALbErW36nZC4yENOg/N
         GyylrRrNw0K7zV/5LE2HmoDRnwXKnA2Mp8hTZaJwR258yBt74R/LnrguTuS9xDmAfCt9
         MPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FKcPWMZCAUe8c6acnbxNFfpNt2+SpTEs6pyxNkpmr/I=;
        b=bN53SvVUcIxHyaOonse+sECaJ0bOx+4vaFVHK6KkBAbQjk+ObvuNQNrwr38N0kIX92
         OYyGsi3LSbvFSAaD0gdF+EP8mFu9ow7U+QrqEIFDE3nIY5CbLsrZGO0RZ6x5J5YfJbLO
         sUndKgzYhshBDhuQfwfxbiibNxtr8CVuJQxNvY/HX24OOgFiUMO17tF+V+LSFKqx15DJ
         pWb9cHqaS+e3x3GEoJnzstrZTbf8bvMAyGx7w8wOO+L/r7z/RfXll/L1pkhFxiJv+vnY
         YN53Ow8lnO9x4Uob0j8Pm5MSdxu3o3qfrKZCTp7QQCfdbIEFjzK6SXsD1CGBEPhreuDe
         y5Qg==
X-Gm-Message-State: AGi0Pube/CCYfsmGEd6QgFIufVv9i6zQEq6keefc1iuHFa7FH78qRYnC
        YAE49mArZzDcVdsKh63kM25HVyu/4jo=
X-Google-Smtp-Source: APiQypLDls1cujoU03pQHWQGmrbD3lI2RnP6220FbzyUmBJy9i09Uh020YuC7PsE6qqmqJs6uNJHOw==
X-Received: by 2002:a5d:45cf:: with SMTP id b15mr10400117wrs.78.1587728290553;
        Fri, 24 Apr 2020 04:38:10 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id w83sm2451007wmb.37.2020.04.24.04.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 04:38:10 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v11 6/7] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Fri, 24 Apr 2020 14:37:45 +0300
Message-Id: <20200424113746.3473563-7-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200424113746.3473563-1-arilou@gmail.com>
References: <20200424113746.3473563-1-arilou@gmail.com>
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
index 524b5466a515..744bcef88c70 100644
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

