Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51A636B03E
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhDZJJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbhDZJJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 05:09:24 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EC3C061760
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so4809015pjh.1
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TUB8ZW50W1LH/QwrQax9EjDH6gcEGV3rni30bl3X4NY=;
        b=nMLVxO6CIiy/xoC7MTIJbp07rnSHaLHlZQaXqT9LsKQyH9vwAf5oAote5EctuSpRnV
         ZNk0sQSWlXUvYSx+7YcGU6axtY+S79n1oE2UhCNrFJOcSEL4YsgyWEJGtbdGKLJkLgkI
         QennNi2LcO+vB/r1UTYKCXEQNpal4XjwjKvKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TUB8ZW50W1LH/QwrQax9EjDH6gcEGV3rni30bl3X4NY=;
        b=sZN0euoZbJ4ZxYHoe0w89AIai0rryeYKxVlinilmxUJHni8SrOsC2haUCL91hUtGrg
         ppNqedAQFZb7ujLXcDLc+gDaZm41Bp9Ig/93l02I3wfJ7/NY575iWAnm7Ur2KyyiBgEE
         tlaiz8Ql16/H7Z7EfQLz64hEwDbx3tHUFgU+sdxCyqwIzqVSYMfAbSeKrwConl6YuRe7
         1tZ5OniSdAwHU7IaGQfiCcRD82HV4s+vcXJ6MNZluVrj8KkLbn4Qaz8bz4JvdYs2GWml
         I6m72KEKOHRqalqwbq2IWstU6Ngb2+MbC0zB8YeOe8H+Kbs0xwZni2ZScGeIYi7Na/Z0
         hktw==
X-Gm-Message-State: AOAM530H/tTB1OA23uvfvTk2k5SgFthPi7cdsPsVvUXMHK8ayVmpg3Cd
        d5dMw2AXnlWN5cVn6f2NI0YFAI1oC1W77g==
X-Google-Smtp-Source: ABdhPJxz8tmuXwED9CTvIhb+i/UFSl3au8tJ/pNDTPQq4thJ6fB38kVQUMNqaZ8W+CGIK8/FjIcZJA==
X-Received: by 2002:a17:90a:c8:: with SMTP id v8mr21678604pjd.18.1619428121944;
        Mon, 26 Apr 2021 02:08:41 -0700 (PDT)
Received: from localhost (160.131.236.35.bc.googleusercontent.com. [35.236.131.160])
        by smtp.gmail.com with UTF8SMTPSA id j29sm10602171pgl.30.2021.04.26.02.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 02:08:41 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     kvm@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [RFC PATCH 5/6] x86/kvm: Add CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
Date:   Mon, 26 Apr 2021 18:06:44 +0900
Message-Id: <20210426090644.2218834-6-hikalium@chromium.org>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
In-Reply-To: <20210426090644.2218834-1-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The config option can be used to enable virtual suspend time injection
support on kvm guests.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

 arch/x86/Kconfig | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2792879d398e..fac06534c30a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -825,6 +825,19 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config KVM_VIRT_SUSPEND_TIMING_GUEST
+	bool "Virtual suspend time injection (guest side)"
+	depends on KVM_GUEST
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
 config ARCH_CPUIDLE_HALTPOLL
 	def_bool n
 	prompt "Disable host haltpoll when loading haltpoll driver"
-- 
2.31.1.498.g6c1eba8ee3d-goog

