Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE1840EA62
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344087AbhIPS5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbhIPS51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:27 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE946C05BD43
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:27 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id t18-20020a05620a0b1200b003f8729fdd04so44887974qkg.5
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CZEtXXeNpIXSrXo/BVsRgyGrmjyKYgmME4XdGa9+bYM=;
        b=iDaF0p6xegEkAf8PzcMdP3s+fpRHuXXgl97zAq4ajM+U3yjOno3KmoxnJm61JFbhXK
         VfyRyYTBT/uLo9Uia1U724DrLnLXtOayyYodTnCybsEgtgmF7z7Dhlg49Xj+2kd5kCuS
         f/5uHMXCij5W24v2yJVqX83X0oCUciZ/2Zcu5iLecKJhhCtKdR04VgeLk4f4ZDI6Uvja
         DgKQSDcN3Ulv5bHMX42U0ALMNzk93Y24nglw1ddOtJjgG89o6+DYs94hvvscdUsifpmh
         nsUKBVWv9qJs9sdPoTvuv2VHEpnsldk9S13e2PVxhCbzKw6e3WwiVARyCpBs1LD/Z4u3
         Bc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CZEtXXeNpIXSrXo/BVsRgyGrmjyKYgmME4XdGa9+bYM=;
        b=XcdP+3J4rC+/a2JCrdrle//p+uBrHoE39LGTSMe2HX4M23TiPvPouWmrtvTW9pgqUF
         lI6/nrWt+OE4RES8pOQp9HUsL2Sof+FAh/5mUdntDW6DwkuXm3/i3D7/fs3jK/ppHHOE
         jYVaUg3LBBdlRPuU5NGplIRNTqi7jbSnQWGjd4q8sxfSGP8Czor6VV+NGwd80WykGOCC
         cRp/Se8tax2DX8DvMM1qNW9CSxrDfiMV/VF8UthqtJP9AaVuA+RhTbzTL/odU+oj76to
         GB4LgDTOIaYXXjNfsoHDQOEaIDGhTaga6acKouyEjAqCHEu5CSrBO16CW5hVxf0B+lBX
         DpNA==
X-Gm-Message-State: AOAM5318K6QzX1UP4Iv16Lv7SdgkPohgcdQR6MMdEKhLdRyl5q0qQJa+
        pYI7JwCwTyRhui3doiB3Outy1raGBvAuTnUFRaSKkO/0cO5/DPun9vg4VskPiq71supMSQxMsNc
        KR3BWK8JkvJhbCYRmOBw7cML5AfaFcAHGLYonLv+Mr5KVVjc7yyUBn7rbdA==
X-Google-Smtp-Source: ABdhPJzuML//NrffbdQcWfzCfBHgYs5KCnfRh2zIVPiWAz432/WqTbsx1cxsM3dFyt2dwSgzM6wBATO+55o=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:fc5:: with SMTP id 188mr8465782ybp.51.1631816126794;
 Thu, 16 Sep 2021 11:15:26 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:05 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-4-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 3/8] KVM: arm64: Make a helper function to get nr of timer regs
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presently, the number of timer registers is constant. There may be
opt-in behavior in KVM that exposes more timer registers to userspace.
Prepare for the change by switching from a macro to a helper function to
get the number of timer registers.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/guest.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5ce26bedf23c..a13a79f5e0e2 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -588,7 +588,10 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
  * ARM64 versions of the TIMER registers, always available on arm64
  */
 
-#define NUM_TIMER_REGS 3
+static inline unsigned long num_timer_regs(struct kvm_vcpu *vcpu)
+{
+	return 3;
+}
 
 static bool is_timer_reg(u64 index)
 {
@@ -711,7 +714,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 	res += num_sve_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
-	res += NUM_TIMER_REGS;
+	res += num_timer_regs(vcpu);
 
 	return res;
 }
@@ -743,7 +746,7 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	ret = copy_timer_indices(vcpu, uindices);
 	if (ret < 0)
 		return ret;
-	uindices += NUM_TIMER_REGS;
+	uindices += num_timer_regs(vcpu);
 
 	return kvm_arm_copy_sys_reg_indices(vcpu, uindices);
 }
-- 
2.33.0.309.g3052b89438-goog

