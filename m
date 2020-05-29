Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67F91E7F15
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 15:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgE2NqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 09:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgE2NqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 09:46:00 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD85C03E969;
        Fri, 29 May 2020 06:45:59 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j198so6866867wmj.0;
        Fri, 29 May 2020 06:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hjT03eHhQ1dE3AJ2qMjxfwTNnQchau8BzAjB0MfMplY=;
        b=Q8FIdXQGiAnfzPYerdUI2ObKUeFZLkPa6hGLB6t8k7w03e1k++0XqNoz+ATgNN/lqG
         5mdnCd7vj1Sqnp/EZLBSS7w4HdAkQ8RsC5fxFvjL50HC+nFf97Phrk8txR5NmZDbGqEX
         odalYUJD35+G14GLhDeaD1qEaPBWfhxMNFqTfNeKNAWT/VUila/h4cusPjCakjvWur1r
         Rmo9S3Zi5aEk4kZrP9yPSR78BG5lvOHN61AfhNl+oMPVfgBkpp4eA5ohdr3RCP4O2geN
         dyDJGJ9xmIkLQkqkpHoJrCTr+z/mAti7hLg/qOUppjhAdKCftcn7mTYy8wx9Z+paD3wy
         EZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hjT03eHhQ1dE3AJ2qMjxfwTNnQchau8BzAjB0MfMplY=;
        b=KCLYNQxJfDcyEcvd8TCHmBhC7p0VZp/+25aQ7uV8FJIr32eC3WbVw9PfBxH+kNRzgj
         Ot5gSxTnv/BO2Tko64mqMO075OliNwXCr2JhKjym+Qb1zPS5cUQjbW5Nh9vUyHLl9qe6
         7EwC2KUCtoM28KkLJByKcoN5MoGztuz01vs/JNk8doujq2HETeIaAoqeUsC510pMvV56
         KNN6SZDA7tqARbuUIlIQU0W5RvPl1SNQ5KzccVLLlM1a5GHL0ewtZZm4eeqtoqSgZR/i
         WZMwz3pvPED+7KTQOsky3ziUaWy/RcaEA6fggxdgMgU+bH1p9QAU95envUkMYZi4QagX
         dxDg==
X-Gm-Message-State: AOAM532J/kwGiPaH9KFYtJYmEbZMZevhDT0XQmkgdaIg7ZHUbcUwNVH1
        WE4L8W4abu5RJWxeUTVsY0oBrkFm
X-Google-Smtp-Source: ABdhPJxinWMzhrGuUwG301mAo+1OAUGgdCNtv8YATF709K7bgg8BOM4HDBB2beh7n+ttmVTL6PIWaA==
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr8336605wmf.4.1590759957544;
        Fri, 29 May 2020 06:45:57 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id y37sm12347263wrd.55.2020.05.29.06.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 06:45:57 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, rvkagan@yandex-team.ru,
        Jon Doron <arilou@gmail.com>
Subject: [PATCH v12 1/6] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
Date:   Fri, 29 May 2020 16:45:38 +0300
Message-Id: <20200529134543.1127440-2-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529134543.1127440-1-arilou@gmail.com>
References: <20200529134543.1127440-1-arilou@gmail.com>
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

