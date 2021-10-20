Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39941434879
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhJTKD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTKD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 06:03:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E58FC06161C;
        Wed, 20 Oct 2021 03:01:44 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so2122249pjb.0;
        Wed, 20 Oct 2021 03:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=6kc/cN3ZuEGloIKQBOBsCOKny975VL/82QULHlwqbfs=;
        b=NbSWq/oNPWWkRVOJbtosn48unWwHGDCRBANrCHcJGcxhCBgcMlJYowlheYyYqO57oO
         Gn3yx7rEgDOmoUotHc26l9uoVKL++Xd8EtPS4/9hRDCgr8ilrFHLzG/VoQJYrXmx+PvU
         3NuSL6SoqIXJx23NqTCKn4YTLUJnlX7hNtBkbhbdgaSuIHBSXQfBZIUTorM2l19Swtuj
         kh2ii4Xm0NKW8KLf1U30r90WxxdJA7+ZuW4oyVIfrjlKBxlEcpSdNKRfjHJoZkl1ielf
         83wKMNGUoniUW18kbePqyzXjEw5xkJ4lbsprvpay1516jjRMKDV0oamsOuRjeEK+9lVQ
         z7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6kc/cN3ZuEGloIKQBOBsCOKny975VL/82QULHlwqbfs=;
        b=5oukIbray1CfyG/CscLypOVgcFQKNTz1ElMeD/EcnWw5P+8+P+Wc5IJRZYL6xVm+nE
         QR6D4yYbyZc3lpqfDl6+VSKwgi3iqxfymaElJYZ/xXrL0C96PBEAknE6PW3oM8wD2Jgo
         28/ojOUjJkuBHe882wIQiR/hwr8qHzLMDO+L6WSfeKG2nBdO8reH4sCfCJjM0JK4wSMG
         XOnUjyLY6JfZ81MU8NSh29Ty/VLfAK86CfJdR3bhgTMi+e0SSzbS/ZDdVdQXPbAl9AXb
         jdKRIISmDKvObcS6PoATLIS/flASWV92RsTucP8nllQ8ew52yN4JH4GrOwcGB4rHTpDl
         Pyew==
X-Gm-Message-State: AOAM531+8P6RsU75vQnxA9WzgpaK6OjkSGH77yrnG3DEsqbibZzUZW7G
        TC5RFalfoygr2g9byb2M7lbcMb3Gkw6UbQ==
X-Google-Smtp-Source: ABdhPJz3fq68DnUovXpQbEZOnr1UE1ptJqlAq3gkdrbEUTXglHNDN2LA4SEvlD8V0B6RHdJCiqcyJw==
X-Received: by 2002:a17:90b:4c0d:: with SMTP id na13mr6120297pjb.232.1634724103566;
        Wed, 20 Oct 2021 03:01:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id bb12sm5127129pjb.0.2021.10.20.03.01.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Oct 2021 03:01:43 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v4] KVM: Avoid expensive "should kick" operation for running vCPU
Date:   Wed, 20 Oct 2021 03:00:53 -0700
Message-Id: <1634724053-73627-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Avoid the moderately expensive "should kick" operation if this pCPU
is currently running the target vCPU.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v3 -> v4:
 * check running vCPU in a separate patch
v2 -> v3:
 * use kvm_arch_vcpu_get_wait()
v1 -> v2:
 * move checking running vCPU logic to kvm_vcpu_kick
 * check rcuwait_active(&vcpu->wait) etc

 virt/kvm/kvm_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7851f3a1b5f7..4a4684e55ef5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3325,11 +3325,22 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 * vCPU also requires it to leave IN_GUEST_MODE.
 	 */
 	me = get_cpu();
+
+	/*
+	 * avoid the moderately expensive "should kick" operation if this pCPU
+	 * is currently running the target vcpu, in which case it's a KVM bug
+	 * if the vCPU is in the inner run loop.
+	 */
+	if (vcpu == __this_cpu_read(kvm_running_vcpu) &&
+	    !WARN_ON_ONCE(vcpu->mode == IN_GUEST_MODE))
+		goto out;
+
 	if (kvm_arch_vcpu_should_kick(vcpu)) {
 		cpu = READ_ONCE(vcpu->cpu);
 		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
 	}
+out:
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
-- 
2.25.1

