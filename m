Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C16FEF8D
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 12:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbjEKKAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 06:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237814AbjEKJ7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 05:59:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1B51FF3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 02:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BC7964BC6
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 09:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C79A8C4339B
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 09:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683799180;
        bh=vZXmP5JUFt2+ykXVd7pzp2XgSzVg4TcDLIbyVY9TKMI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=prl5GIejdp1FO2OJskEuVuxSr6tJrjLSNabzJyX3fll53a6T+Jwss2R3eWN7sJ1YL
         QLzxkylj+tO95ix8PEsKDSwA4+tWcHCiNUHGsV3jowRcHa0ucc+vBFAhXLpqby/rg1
         BFFdqNPgHK2oo5rSTDyGyrJMEJKQD3SWECsPYzVxrpi6znIFFlznHV0kRoGg1kAwnV
         VNXU1Q/Mj5PB33scH/mVPkwy1bdq+E8N0kZo78DWHIsGB2hcgduoiSKrC/0dI2quCv
         fQ/8miFiPqyl+HEAJkT+p42r5S6k28xoTdYta6bILFV6yqe0eboLWBa80BWnoSnP+Z
         R0wQFxjvSc4Yw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AD34BC43144; Thu, 11 May 2023 09:59:40 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217379] Latency issues in irq_bypass_register_consumer
Date:   Thu, 11 May 2023 09:59:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhuangel570@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217379-28872-KU8tTDkhtT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217379-28872@https.bugzilla.kernel.org/>
References: <bug-217379-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217379

--- Comment #2 from zhuangel (zhuangel570@gmail.com) ---
Thanks for the suggestion, Sean.

Before we had a complete optimize for irq_bypass, do you think such kind of=
 fix
is acceptable. We should provide VMM with the ability to turn off irq_bypass
feature for device not need irq_bypass:


diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 737318b1c1d9..a7a018ce954a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1292,7 +1292,7 @@ struct kvm_xen_hvm_config {
 };
 #endif

-#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
+#define KVM_IRQFD_FLAG_DEASSIGN                (1 << 0)
 /*
  * Available with KVM_CAP_IRQFD_RESAMPLE
  *
@@ -1300,7 +1300,8 @@ struct kvm_xen_hvm_config {
  * the irqfd to operate in resampling mode for level triggered interrupt
  * emulation.  See Documentation/virt/kvm/api.rst.
  */
-#define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
+#define KVM_IRQFD_FLAG_RESAMPLE                (1 << 1)
+#define KVM_IRQFD_FLAG_NO_BYPASS       (1 << 2)

 struct kvm_irqfd {
        __u32 fd;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index b0af834ffa95..90fa203d7ef3 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -425,7 +425,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *arg=
s)
                schedule_work(&irqfd->inject);

 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
-       if (kvm_arch_has_irq_bypass()) {
+       if (!(args->flags & KVM_IRQFD_FLAG_NO_BYPASS) &&
kvm_arch_has_irq_bypass()) {
                irqfd->consumer.token =3D (void *)irqfd->eventfd;
                irqfd->consumer.add_producer =3D
kvm_arch_irq_bypass_add_producer;
                irqfd->consumer.del_producer =3D
kvm_arch_irq_bypass_del_producer;
@@ -587,7 +587,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *a=
rgs)
 int
 kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 {
-       if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN | KVM_IRQFD_FLAG_RESAMP=
LE))
+       if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN | KVM_IRQFD_FLAG_RESAMP=
LE
+                               | KVM_IRQFD_FLAG_NO_BYPASS))
                return -EINVAL;

        if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
--
2.31.1

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
