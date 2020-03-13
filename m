Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B028A1847EF
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 14:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCMNVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 09:21:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55438 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgCMNVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 09:21:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id 6so9914628wmi.5;
        Fri, 13 Mar 2020 06:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZuvV9ToDUH9Z7nRm33O7cyqYk/jzexuummxj9jXv5cY=;
        b=ZC7jpn2z6ff70az6/KpYUig+zBru1Y1k1KLocjz3tlMZCrZ5E8/zGyQyx1iZjLGTx/
         64ZU66Us4mbVzbr64Y9En34wjTGWObRy/iiCCS7fmFblc5rn+gplHvlL/cFUK83H8h5d
         5s712JYPuNPdPKXQV3OcQph7UD4EsoIqCn3Y4LWcWoXyVDDQGjXZUTVScwJqcyKifqiA
         0WJ6zxPMcYgENmB4QT0rLNXFtcLb3XpF0WyDi1p/owLG4DrJdTEWykwCsH4vyVB9qaeC
         7qvkTXQ2nUTuEkfHq/uIlYMWF757LMwMWI3/ZGZxotv/1WKAC7Hm7A20d/aDgYwcumvz
         Cxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZuvV9ToDUH9Z7nRm33O7cyqYk/jzexuummxj9jXv5cY=;
        b=YKWOwy5z1ATzgms1EjTpVqQol894kG+RtsoyaQS8GfRayGIdeJj8mm/X1Ddwbc3Cqv
         +ZJwVQ17Vu9ZBo5YiScsqdfPk//jkE+LMGIA3yB5rbiEbMjItBXqpPIH0ElJeNFkwR4I
         kJC/CMQJDq9+A9PRsklx4K5afF3QFLRsSWj4Q5zlpTkSVNrqjkv8TUPoIHETIw6zN3p7
         SnhLI/BL624JHkMP3HslorSDpnG19YB1ET55UXYoUhL+shqu3SQ6q4FrlP0fgsnk/17F
         v0M2s/CAfGxHW7XtVip/87DOiIt3J5gpCRNQPRP75/lewFme235li3PDhWi40H2i0Qxu
         RS1Q==
X-Gm-Message-State: ANhLgQ0X6+yKQcc3nxuR7xib7EjiL5a8X3DS0xODtlRd5b3h+042RKFk
        tErY4zkxEhi0yQet2g1luXcAnwgd3Tw=
X-Google-Smtp-Source: ADFU+vtF8Mlmnu6diBu1+JqT7ftvZkzoXHy4rfhORDkRVofVTpfYDp7zg5V58yzpKjk2Cvwpp45Eeg==
X-Received: by 2002:a1c:9a88:: with SMTP id c130mr11400343wme.73.1584105662322;
        Fri, 13 Mar 2020 06:21:02 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id v8sm77112121wrw.2.2020.03.13.06.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 06:21:01 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v5 5/5] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Fri, 13 Mar 2020 15:20:34 +0200
Message-Id: <20200313132034.132315-6-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313132034.132315-1-arilou@gmail.com>
References: <20200313132034.132315-1-arilou@gmail.com>
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

