Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DC54140E8
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 06:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhIVFAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 01:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhIVFAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 01:00:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3962C061575
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 21:59:09 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l6so939091plh.9
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 21:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gqSb6j4QRhVbcfEJejcSoBsQvuv4/cNZIL9rAN4Q0hA=;
        b=mt/9jHsDCA1xTg0Mio6XFFkBY6kanMnDTiik24deES2GxH2eBfIxjyTrw3wjYpohT/
         2XjAV3srDZ1wH65KAXKgIGA/G11CdTopvJJDjGvzpy5+WS92lTKTeeIqwq/CLFWaXttG
         pjXUQ9qqlnRpjg7Jk0wi8qGljiTsUdrPEu7LQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gqSb6j4QRhVbcfEJejcSoBsQvuv4/cNZIL9rAN4Q0hA=;
        b=U0PluNDHhZbBFIom2U/ocu8o7QjZECXFD1SD9mEfscnh9IiWMOh8q0eYSbL3kCT/BT
         xJyYZmuSmi9x4vUpR140+6Hcd2KoW8oVjnjrgFjC5U0pMgNb5GoUV8uvIARGPDjUtxCc
         PX0zSx0wD6vBQqM3j9hcXxDl3pQ9cZc4GSQs3fO1vqr3DZbiGZq036mp6tcMLa+nbtEk
         RSqmsQ9zzTDzmTwbwhoeQPicLKuJ4aCCyNei7sRUA7fAcDXovz56QoUey+wf9RGgOFO7
         B3gF8q90Q4SWtxsQZveYSomeOLR4HlN2NNM9e6cW0dxbskcaeXCw02W+KOj7dwrho2Vl
         CDFw==
X-Gm-Message-State: AOAM531bumD2pabKxNRn7Z2a/pvQXAg6iXaZ2I/s1+FG/dMDxPMrAF3Y
        S20oVU9aAdF9yLCVTV8cguphDg==
X-Google-Smtp-Source: ABdhPJx5Td2464n+D2Ic7uFsDSlCR+7CTyMGJFroTLZE5Pi2ikM1KBsAsBpyc3VCQnBcFmm6AFfZjg==
X-Received: by 2002:a17:90a:8505:: with SMTP id l5mr9285899pjn.173.1632286749291;
        Tue, 21 Sep 2021 21:59:09 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:9a20:20f1:af4d:610c])
        by smtp.gmail.com with UTF8SMTPSA id fr17sm688940pjb.17.2021.09.21.21.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 21:59:09 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v2 1/2] KVM: x86: add config for non-kvm users of page tracking
Date:   Wed, 22 Sep 2021 13:58:58 +0900
Message-Id: <20210922045859.2011227-2-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210922045859.2011227-1-stevensd@google.com>
References: <20210922045859.2011227-1-stevensd@google.com>
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

