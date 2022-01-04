Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947034848EF
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiADTul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiADTuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:50:10 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC4CC061761
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 11:49:56 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id r13-20020a0562140c4d00b004119074a4d9so27958332qvj.12
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 11:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=koYIbVzLeCIp1ky1eF8weLmELE9lQop0nuOmnvUl4iM=;
        b=iEF20O6nEtnzg8QLg5HK2eQWSdMtJV4Yig8SF/aO+OPRLc5fD/RD5+aD5k2tAATXB/
         exX1WoJ9BzW3+g3/wuoHiUQ6rEfC8DeSZgWkvdhGgYSWdVD0GOjyewUpThL9LKVtuHDC
         xJQTXt3qV6G0ba76aVhBXeQKbAZNRRQhM7INjHirJWi1dj+NI6YUlSi/j2PcyLFzaCVl
         znzY3R2cL9ts2cWm13sgzoGMa9yH+HYKW46oK7KTBc9a3p0Ac7Sh50cDXvMItxDvNR2i
         TnKjQbG0/lUHtfMRshb/rMGBMvvpRmYFnt6kB9VcOILtL/ttqLjCfJjYQmWks5Jfucii
         OZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=koYIbVzLeCIp1ky1eF8weLmELE9lQop0nuOmnvUl4iM=;
        b=Aj/k0lc9G0wnBWnX843bfOSCEsi+CYldkoF2Iek2VI1OVLyErHavbG9QHUPqCjc2LT
         EAc2e+jPWJMXHZ0YYnHR82yrGEYUF+xwNlLuBOs9WpBIuC/wtxlyKSfSd27g8IVLVhBb
         gV0SrsegXv0nnSLvOtaidmz4IPhCFG7ZImFl5LRF3XPUMn7LQz6NXG1lhPiN1GVxvC8l
         R1a3erE04G654qAXO1LWpfQCf8oWy9/TzZ/AaoCt9gbZl0Xq0bquTG1xZElTTWz8SL4Q
         uxYyKheErT8l0+t8BDD9rT9SxDniF5vhroRT/BVQplFQ2zECV6oUfTN+0/Ua0a94Z9Xd
         jUcQ==
X-Gm-Message-State: AOAM533xNdOfn7UwxEsNhTJ3569ZwkQff5wZI73Bp+28YSQIcsjN7qUD
        /g8tdK4KzOLYQf2+CYFwu7NPI65cetgp
X-Google-Smtp-Source: ABdhPJyeojFG4fK/2r+cuOGGf0/iG6ojdW9/FWZt+iEktMSbqQcbtVlfPIpRpvAc8OdzwuV2BXd3zsjyzSv1
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:622a:554:: with SMTP id
 m20mr46031673qtx.623.1641325794799; Tue, 04 Jan 2022 11:49:54 -0800 (PST)
Date:   Tue,  4 Jan 2022 19:49:18 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-12-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 11/11] selftests: KVM: aarch64: Add the bitmap firmware
 registers to get-reg-list
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the psuedo-firmware registers KVM_REG_ARM_STD_BMAP,
KVM_REG_ARM_STD_HYP_BMAP, and KVM_REG_ARM_VENDOR_HYP_BMAP to
the base_regs[] list.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..6321f4472fdf 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -686,6 +686,9 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(0),
 	KVM_REG_ARM_FW_REG(1),
 	KVM_REG_ARM_FW_REG(2),
+	KVM_REG_ARM_FW_REG(3),          /* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_REG(4),          /* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_REG(5),          /* KVM_REG_ARM_VENDOR_HYP_BMAP */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
-- 
2.34.1.448.ga2b2bfdf31-goog

