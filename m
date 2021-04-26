Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8659936B03D
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhDZJJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbhDZJJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 05:09:16 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593DCC061756
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:35 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id b17so2632356pgh.7
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ze/d40V9r4jheKthRdtDHEg05bx8WqXy096MFG21BNk=;
        b=ZEW/ctj1rqE5BI7PZyNweAk4hCGwOn1XeB1UK3EInZuZ+KOoZj+FZniUs0eawFNTb3
         piyAhNUq9Pt8NKjOGRjvXBUPiX9qxN9duDSUduOf6L6+VgKTaOlJcE4N0Fwb0qughoZE
         OAeozLRUZfPsZt//DGi8umsGUs0nsnU1cT4gM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ze/d40V9r4jheKthRdtDHEg05bx8WqXy096MFG21BNk=;
        b=YDWeJO7eNFy32mBkURs1Jl6Fcyn8MoDOJvEIITlLz3LXVLNx1V076mehGRg9JVOkgk
         1jcJ07tbUrDYDMqe25hD6Q1qhPLP5QVrWSvtx6nXf25jBXJbx1W7E0H9jJCSFX2AXTi4
         wxJYsFVy0iKdtfGGj+utRTYpauOcs+zRB8OIUwspauOlAWdkMit453+vnGomlJdwbpdP
         cmkSsM02sQ3hiBtLkhTBNadX0pgnwlKU2zUaGyG1cQ6Plqi5BPvuckTvX91lNStjfzc9
         FOPWz72r5OE4h2Z7P9Et2cXgEvTuLVPAoOXD51FUiWlnLVilHemKHrFL4kbqWZnPoSl4
         /2Lg==
X-Gm-Message-State: AOAM531xVEx8aMH5wtjtWI3+8GLX857HDlK/F1ovNtQaniCWaGEdW4qD
        dZvjKPOHmVe3meFv6bxvQ5RQher4vtD73A==
X-Google-Smtp-Source: ABdhPJyaxGiniEDS09BITbtGyjkgjq743HWx/3/pq/SXK/DWtL+tSMT3yuzIQODND9+YCVlEcaq/bg==
X-Received: by 2002:a63:a47:: with SMTP id z7mr15779744pgk.350.1619428114657;
        Mon, 26 Apr 2021 02:08:34 -0700 (PDT)
Received: from localhost (160.131.236.35.bc.googleusercontent.com. [35.236.131.160])
        by smtp.gmail.com with UTF8SMTPSA id 22sm14650977pjl.31.2021.04.26.02.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 02:08:34 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     kvm@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [RFC PATCH 3/6] x86/kvm: Add CONFIG_KVM_VIRT_SUSPEND_TIMING
Date:   Mon, 26 Apr 2021 18:06:42 +0900
Message-Id: <20210426090644.2218834-4-hikalium@chromium.org>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
In-Reply-To: <20210426090644.2218834-1-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The config option can be used to enable virtual suspend time injection
support on kvm hosts.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

 arch/x86/kvm/Kconfig | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a788d5120d4d..6cb6795726a2 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -119,4 +119,17 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_VIRT_SUSPEND_TIMING
+	bool "Virtual suspend time injection"
+	depends on KVM=y
+	default n
+	help
+	 This option makes the host's suspension reflected on the guest's clocks.
+	 In other words, guest's CLOCK_MONOTONIC will stop and
+	 CLOCK_BOOTTIME keeps running during the host's suspension.
+	 This feature will only be effective when both guest and host enable
+	 this option.
+
+	 If unsure, say N.
+
 endif # VIRTUALIZATION
-- 
2.31.1.498.g6c1eba8ee3d-goog

