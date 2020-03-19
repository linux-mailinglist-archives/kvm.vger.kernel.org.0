Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0612118ACE0
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgCSGiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:38:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35721 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgCSGiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:38:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id m3so717026wmi.0;
        Wed, 18 Mar 2020 23:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qORovMW4qFXFXcdoIljFzjQs+83nq3xI2+7AeVXu0Jo=;
        b=XHgPjea2n+g2SEmEbwyrkXs34T5r0cG6XzKB2M0ynsZeDtSYiUlk+Bp2zTTafyoZdH
         P5g4lj1ImzTMGDW+7Atct6VEBlJbr91iB282aTbVXgr5YmnJubVskQ4yJRoq+D7wTbfV
         O1KeFtRSp7tlRXt0Z61oEwkX9r3rLRf7t0l7iC8V7KAEq8jP3DeOJ5hCYeD0hM12Pkxa
         /MeW5V9zgNPgEgNiRd9Sng2rqvB0414rjJWXWF9eh/CQ9tKxes386kqRTiYlkafwnaxE
         z4vP1rEdpatH19NOPykNj3OVCRo6Y9cqjzQa3u78GmMhDEKsg9zNXl0l70eCrbhr5lVH
         ZQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qORovMW4qFXFXcdoIljFzjQs+83nq3xI2+7AeVXu0Jo=;
        b=bSAbhf7FkdZTUOBGROyQbQ5GH4tAVLbidqTrvmpr9W537L4EsU6CUvU0RwV8xS8jPs
         cRvsIsjW/+/HTruYRhmAkE8G4bH84hfbz6BcNKNIZ7eUYsndhNCcGICWYd6mx8/sF/SU
         JIDykZltrTjMH2hkh4YTVXL2FozronLcCwTVBJcqYYmWm7a+rOW5uxjcCpz5qkCo7zFT
         FAjwMCCDjBA94UVL6bZBhZ7DJzNp71ow0RCiYIL9dbEwQCdy9TTJa4cIoaS7ckoLSNBA
         wgJjbNnqqsdl7Vb3e/2sBU9lsA06DQNIt3skNK1C1DX/RcJmQWnUgsvlSxvBMmSiBiPK
         JGJQ==
X-Gm-Message-State: ANhLgQ2Gj38l/vml8jMzvuoxBabV4zDDJ3ogssnwEdSRiLd8NJ+wmW1W
        QbIYaDDA5A75yCFy6jHpCKZxevsepZI=
X-Google-Smtp-Source: ADFU+vv2umC2Fn4i78nQiQtIaZeOwfGtR6/eYcbt62L8GKOZ7Lk5sF0RJJLR5pkcx4EbYffDB3IWDQ==
X-Received: by 2002:a1c:5506:: with SMTP id j6mr1781381wmb.127.1584599930042;
        Wed, 18 Mar 2020 23:38:50 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id l13sm1945665wrm.57.2020.03.18.23.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 23:38:49 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v8 1/5] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Thu, 19 Mar 2020 08:38:32 +0200
Message-Id: <20200319063836.678562-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319063836.678562-1-arilou@gmail.com>
References: <20200319063836.678562-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The problem the patch is trying to address is the fact that 'struct
kvm_hyperv_exit' has different layout on when compiling in 32 and 64 bit
modes.

In 64-bit mode the default alignment boundary is 64 bits thus
forcing extra gaps after 'type' and 'msr' but in 32-bit mode the
boundary is at 32 bits thus no extra gaps.

This is an issue as even when the kernel is 64 bit, the userspace using
the interface can be both 32 and 64 bit but the same 32 bit userspace has
to work with 32 bit kernel.

The issue is fixed by forcing the 64 bit layout, this leads to ABI
change for 32 bit builds and while we are obviously breaking '32 bit
userspace with 32 bit kernel' case, we're fixing the '32 bit userspace
with 64 bit kernel' one.

As the interface has no (known) users and 32 bit KVM is rather baroque
nowadays, this seems like a reasonable decision.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 Documentation/virt/kvm/api.rst | 2 ++
 include/uapi/linux/kvm.h       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ebd383fba939..4872c47bbcff 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5025,9 +5025,11 @@ EOI was received.
   #define KVM_EXIT_HYPERV_SYNIC          1
   #define KVM_EXIT_HYPERV_HCALL          2
 			__u32 type;
+			__u32 pad1;
 			union {
 				struct {
 					__u32 msr;
+					__u32 pad2;
 					__u64 control;
 					__u64 evt_page;
 					__u64 msg_page;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..7ee0ddc4c457 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -189,9 +189,11 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
 	__u32 type;
+	__u32 pad1;
 	union {
 		struct {
 			__u32 msr;
+			__u32 pad2;
 			__u64 control;
 			__u64 evt_page;
 			__u64 msg_page;
-- 
2.24.1

