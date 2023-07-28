Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3697660A5
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 02:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjG1ARJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 20:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjG1ARH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 20:17:07 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CAC2139
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 17:16:59 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qPBA4-004ru0-9w; Fri, 28 Jul 2023 02:16:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From;
        bh=7VJYracmdU1lDrqbKMkKJZZF7M7W8sV60Ahyvmh99lo=; b=PGPXMDRrQ7Ar6mYIvuWjhFMV62
        gQU+aoBtNWkD5Fz+sloLtCnYkNVf+CcwMXXg8cME2yic0DbzdH9hRThFDL9cc0d/B9YTWY5aNlZfi
        zZy3j9Q8glgyPidYAF/Dl6jdj8VSDmYs8ExPklEZDr3gUd3Z319GD6n9n5czXcmPKcK4+4nLH5FV+
        A+knG8vAsfDJ9TxRguyxoI8I493e0tKShjSk+DqbkDK+2w41/BsLrhTM4Dn7WHknZSTyp2UHPDAQx
        KKCsZmk9FKmY6b/F7X1vlZ+E+/O8h2IZQkyA1+YvBrbPUP7Ss7C/OdMm6qKtuOSLAgRJiqWKyloas
        b2e8Jpfw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qPBA4-0002hb-1r; Fri, 28 Jul 2023 02:16:52 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qPB9y-0000WA-DL; Fri, 28 Jul 2023 02:16:46 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     seanjc@google.com
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues
Date:   Fri, 28 Jul 2023 02:12:57 +0200
Message-ID: <20230728001606.2275586-2-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230728001606.2275586-1-mhal@rbox.co>
References: <20230728001606.2275586-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a spirit of using a sledgehammer to crack a nut, make sync_regs() feed
__set_sregs() and kvm_vcpu_ioctl_x86_set_vcpu_events() with kernel's own
copy of data.

Both __set_sregs() and kvm_vcpu_ioctl_x86_set_vcpu_events() assume they
have exclusive rights to structs they operate on. While this is true when
coming from an ioctl handler (caller makes a local copy of user's data),
sync_regs() breaks this contract; a pointer to a user-modifiable memory
(vcpu->run->s.regs) is provided. This can lead to a situation when incoming
data is checked and/or sanitized only to be re-set by a user thread running
in parallel.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
A note: when servicing kvm_run->kvm_dirty_regs, changes made by
__set_sregs()/kvm_vcpu_ioctl_x86_set_vcpu_events() to on-stack copies of
vcpu->run.s.regs will not be reflected back in vcpu->run.s.regs. Is this
ok?

 arch/x86/kvm/x86.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7f4246e4255f..eb94081bd7e4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11787,15 +11787,22 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 		__set_regs(vcpu, &vcpu->run->s.regs.regs);
 		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_REGS;
 	}
+
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_SREGS) {
-		if (__set_sregs(vcpu, &vcpu->run->s.regs.sregs))
+		struct kvm_sregs sregs = vcpu->run->s.regs.sregs;
+
+		if (__set_sregs(vcpu, &sregs))
 			return -EINVAL;
+
 		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_SREGS;
 	}
+
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_EVENTS) {
-		if (kvm_vcpu_ioctl_x86_set_vcpu_events(
-				vcpu, &vcpu->run->s.regs.events))
+		struct kvm_vcpu_events events = vcpu->run->s.regs.events;
+
+		if (kvm_vcpu_ioctl_x86_set_vcpu_events(vcpu, &events))
 			return -EINVAL;
+
 		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_EVENTS;
 	}
 
-- 
2.41.0

