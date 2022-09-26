Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16415EAE3D
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 19:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiIZRdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 13:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiIZRdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 13:33:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA94B7D1FB
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 09:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664211077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q+29jlz3/7GREROrLWc2j0HzMb3Q+G4jXjPTDYgt8Mg=;
        b=Qzwnegoa0qGvw3udPTYMor0XfF+Xi5azG//7pe3xme4xdGnlUNeGxoE1iJdQLfV6TxupLf
        ZvKo5lIBcWUobqYr8gSqkQ855A2RQauS3Vbi7sbRDPuXzH3+OhvG/BE+5Su1y1tXCHe8br
        Ssb55ZJ/w+JiopEmgXC68iuHOrNyqDY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-nt2ZYBGEOkafDIJz_wVGGg-1; Mon, 26 Sep 2022 12:51:13 -0400
X-MC-Unique: nt2ZYBGEOkafDIJz_wVGGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B4D929ABA03;
        Mon, 26 Sep 2022 16:51:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D38240C2064;
        Mon, 26 Sep 2022 16:51:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
Date:   Mon, 26 Sep 2022 12:51:12 -0400
Message-Id: <20220926165112.603078-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

32-bit KVM has extra complications in the code due to:

- different ways to write 64-bit values in VMCS

- different handling of DS and ES selectors as well as FS/GS bases

- lack of CR8 and EFER

- lack of XFD

- impossibility of writing 64-bit PTEs atomically

The last is the big one, because it prevents from using the TDP MMU
unconditionally.

Since 32-bit processors with virtualization extensions are a historical
curiosity, and even 32-bit userspace can only deal with small guests
due to limited address space, it makes sense to restrict KVM to 64-bit
hosts and kernels.

In preparation for that make 32-bit KVM depend on CONFIG_BROKEN, and
opportunistically rephrase the help message---processors with
virtualization extensions are supported even if they are not
"fairly recent".

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e3cbd7706136..a107df22ffee 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -21,6 +21,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM
+	depends on X86_64 || BROKEN
 	depends on HIGH_RES_TIMERS
 	depends on X86_LOCAL_APIC
 	select PREEMPT_NOTIFIERS
@@ -50,12 +51,13 @@ config KVM
 	select HAVE_KVM_PM_NOTIFIER if PM
 	help
 	  Support hosting fully virtualized guest machines using hardware
-	  virtualization extensions.  You will need a fairly recent
-	  processor equipped with virtualization extensions. You will also
-	  need to select one or more of the processor modules below.
+	  virtualization extensions. You will also need to select one or
+	  more of the processor modules below.
 
 	  This module provides access to the hardware capabilities through
-	  a character device node named /dev/kvm.
+	  a character device node named /dev/kvm.  You might have to enable
+	  virtualization extensions in the firmware setup if the device is
+	  not visible.
 
 	  To compile this as a module, choose M here: the module
 	  will be called kvm.
-- 
2.31.1

