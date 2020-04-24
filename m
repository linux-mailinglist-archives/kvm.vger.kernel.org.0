Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5987A1B733A
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgDXLiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbgDXLiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:38:06 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF78C09B046;
        Fri, 24 Apr 2020 04:38:04 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g12so10305660wmh.3;
        Fri, 24 Apr 2020 04:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hjT03eHhQ1dE3AJ2qMjxfwTNnQchau8BzAjB0MfMplY=;
        b=iI1PGy8nES6hDeRdsF06GvtCVXNHa+2QyXXjpyPiG1P5m4oC6prwJFmvdtE/PleiWm
         Da1h5SiXK/kFe8QaTEd/CEIJCM2eyiXGkRGeRnnJrxmtzrx9gHv61+gSPiRgrjSse1OZ
         0+Uh/rJDDZrkeFrvSjeOnDc4I9O12LJnBDvU3245VktJ2vYprdD4/kObgf/YkfpvuWGf
         ME63Ldi6EMtBW/sbsGGJFc7syeoxDiaN9MM5raf3hOVkL5DQtc2nxx8jDT7kW7uq7Tgn
         JarzBz0obteBNH3nRefLstZ3topmgoJD0Ge9OTGsCN1u1vFFpSORRA+82CosLl5qvNTK
         pCYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hjT03eHhQ1dE3AJ2qMjxfwTNnQchau8BzAjB0MfMplY=;
        b=ixkFAuR2yJ6p9FAa7C/qwnAeceZPqQzmcy22L68Diub2SWbMIFL+clJfmnjqv89bBM
         +Be9eSWhS1QsCRTvQb2+u3RX+FPkCk7A5lvXF7nZqSMWDEXX4Tf03x/Lie6y4coVWYkA
         /xDPK7xUT/nujryGY2mVTlhzwvGZW7NdayXVGY+TRz6fBBlSPGXyDrPVx5MOFSHPtWMQ
         ete1WEQZKmFvd+nwvK6yAFsVET8R3Aonq12jeB0AyP+uuccKNqqs9kwRo35x8y0gwXqY
         SxzJL4vCKIxMsFkyXp6nPIExTINT4MDFrqr+9uurMJNT04r5bYQ7MvTIFA0aFeJj5hOv
         Kw5Q==
X-Gm-Message-State: AGi0PuYIhLfDGbp2eHssUukynDow/URyDQllUPTFAkUtY6Cx6buJ39yn
        oCKftNvasc183fTi2cwXH1lQTlyW5EI=
X-Google-Smtp-Source: APiQypL/XYfWJE9aLnvUn5aWZDuAFV9fmnIFisczBW37nZ9lgKGN/1rGxyjDg3A5aw0GetlEYObSzw==
X-Received: by 2002:a05:600c:2645:: with SMTP id 5mr9498220wmy.168.1587728283298;
        Fri, 24 Apr 2020 04:38:03 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id w83sm2451007wmb.37.2020.04.24.04.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 04:38:02 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v11 1/7] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Fri, 24 Apr 2020 14:37:40 +0300
Message-Id: <20200424113746.3473563-2-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200424113746.3473563-1-arilou@gmail.com>
References: <20200424113746.3473563-1-arilou@gmail.com>
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
index efbbe570aa9b..750d005a75bc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5067,9 +5067,11 @@ EOI was received.
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
index 428c7dde6b4b..9cdc5356f542 100644
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

