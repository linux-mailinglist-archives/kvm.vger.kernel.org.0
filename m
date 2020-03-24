Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D7F19067C
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 08:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgCXHoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 03:44:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53095 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbgCXHoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 03:44:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id z18so2095726wmk.2;
        Tue, 24 Mar 2020 00:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G4SLa8l+3nFk3QG4JtUy0/LZ8zBcZCA5bjAZGfHKUdk=;
        b=QAjiwmznuPXeBwqQ1dlQ7uk23RkAHEa9zHVbzV47FWXOvlrKCu1bRnJKD63JbB53l3
         Pq6EVpKe17Jq/d0Sbz6JeLyXCBDaozAh5+6NpuBGmzbe8yxQQPCU4ktRQprvc9rfury6
         hg0UC4g1xOjKjktltmyEmHncrJPd8Cj/tBvBm2uRQyXP917WiW4+sqolDxWYbOLVaC1B
         WhMDr+4McrxUKr7lCfo9EHLizRoF0o4ZpWg2bYgdOrUcsRuqfZDRv0LT1weOCHYqpUMa
         E09YQzc0l18y/a51TPiWocHgjUuDfhN3qnredyodhA4e299UVcR8nwn+DsPwdLNWz1rc
         v7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G4SLa8l+3nFk3QG4JtUy0/LZ8zBcZCA5bjAZGfHKUdk=;
        b=h2oJFMVwF00eKJT4sdVOC/kS/rr4LiDSr9MJ4MN1R4g8VbjyF1o5aRVCbQ96LGRoUf
         3Z7lMHv+m/umlp1JQPRwaZVRapjw6bcNDspS5yGVG9xLQrmipWg1pKvG+uBkAdBxflIJ
         qWMQ+hEjzWYuaRHGHqcRT7r2OeUC2UkSnNxKbyHBHn3N3EN4hbfxNeVcnG5c29f/j5ZO
         La7+bD1QXB4eujZyX8/m0iL9AuCW80grR15PPmb4mmxd0YBU4bX8ZtE0kB7lSukVFuAS
         CVDH4GHZHm187cxWgfRq9TlHEVeWVkqhMD4A5ft4C8HKKEm66QrAxysinPvWn7TlvIk9
         GyfQ==
X-Gm-Message-State: ANhLgQ3rVzR75nAE+rcl2ECnbuaHYIlWzd7xllsbXvnV5YJMDAaC8PNb
        CdgqA2Vwd2im+8DoLB7rGwcC4XRzGlY=
X-Google-Smtp-Source: ADFU+vvZpLQzvlkI9935lmL7UFek2xUxmHUEUyW6PTRfhwU7zAvV0N8uZmHMJTRoxNeSqAlAR8O2LA==
X-Received: by 2002:a05:600c:24c:: with SMTP id 12mr1858560wmj.186.1585035838502;
        Tue, 24 Mar 2020 00:43:58 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id r15sm22066122wra.19.2020.03.24.00.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 00:43:58 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v10 1/7] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Tue, 24 Mar 2020 09:43:35 +0200
Message-Id: <20200324074341.1770081-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324074341.1770081-1-arilou@gmail.com>
References: <20200324074341.1770081-1-arilou@gmail.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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

