Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE2412FED
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 10:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhIUIMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 04:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbhIUIME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 04:12:04 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37C0C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 01:10:36 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 145so4817393pfz.11
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 01:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gqSb6j4QRhVbcfEJejcSoBsQvuv4/cNZIL9rAN4Q0hA=;
        b=PELG7kS3lN8UtXOhNNLdA4nqJ60qmLHh7+zrQsC6JizwO6CT+YPqFBafj62bp7SZqj
         t0dkM6lqQETxe3vXhlMjoTQ6gsFbPGw50UtjDmL652mw7ovatrVJiAddT3xcjTFascjj
         hK5fO3Fy/tpm5EYWb/YSD23E2SMl6sjoWWDrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gqSb6j4QRhVbcfEJejcSoBsQvuv4/cNZIL9rAN4Q0hA=;
        b=3C/Fs1chXuTzvzjLSFsfh5emkm52vft0NNw4cbJl/TW01x7N/m1oc9bSDBx00eGHUw
         dTQ0kFvi1LylT7xz8V9wzVdX7wb/Jpxdt9UzHEfJwziKIFL4kVTY41rAJDyTYe0AnCfS
         /d1QHTJM2H+gIZw1T5eH5fW9QVKPmui12cEfx5HiXyQH7f2H4sjeoAdV/tRXVc5K4hP6
         gyDtZNZ046tqQ3/M2PDkn5zZyx9Iu7coiq3Zrqbebpjp64J6IexJTaSx8AgMV3aahzeM
         XlSfai8z+JFhEOBL5zyberLRUYWkZLHECx0bqVDfmxC+Mm6bB0z0vF9tbqnvHvAKyg6N
         Ss9w==
X-Gm-Message-State: AOAM531r/X11LnlcL4rhaltcMKHojs2bCm6OkY/9fMoPxrGBLAewPsbU
        X7Baf+NZmdB1M6HPXAEujBZy8NKj2SxCbA==
X-Google-Smtp-Source: ABdhPJzEf69drbQ3iEQj+oBbjYexjFbvcsB9OmJbkWU0ykpWZgd3uHqpEwhVmCovht8coMxX6SMWnQ==
X-Received: by 2002:a62:1717:0:b0:440:527f:6664 with SMTP id 23-20020a621717000000b00440527f6664mr27914710pfx.73.1632211836048;
        Tue, 21 Sep 2021 01:10:36 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:2b35:ed47:4cb5:84b])
        by smtp.gmail.com with UTF8SMTPSA id w22sm12947071pgc.56.2021.09.21.01.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 01:10:35 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH 1/3] KVM: x86: add config for non-kvm users of page tracking
Date:   Tue, 21 Sep 2021 17:10:08 +0900
Message-Id: <20210921081010.457591-2-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210921081010.457591-1-stevensd@google.com>
References: <20210921081010.457591-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Add a config option that allows kvm to determine whether or not there
are any external users of page tracking.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/Kconfig         | 3 +++
 drivers/gpu/drm/i915/Kconfig | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ac69894eab88..619186138176 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -129,4 +129,7 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_EXTERNAL_WRITE_TRACKING
+	bool
+
 endif # VIRTUALIZATION
diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index f960f5d7664e..107762427648 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -126,6 +126,7 @@ config DRM_I915_GVT_KVMGT
 	depends on DRM_I915_GVT
 	depends on KVM
 	depends on VFIO_MDEV
+	select KVM_EXTERNAL_WRITE_TRACKING
 	default n
 	help
 	  Choose this option if you want to enable KVMGT support for
-- 
2.33.0.464.g1972c5931b-goog

