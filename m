Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03C04C33BE
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiBXR3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiBXR1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:27:15 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C79012AF3
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:38 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id f2-20020a17090a4a8200b001b7dac53bd6so1616147pjh.4
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qK1DQfY/agZG+Ude+bPzbHAaaA6lFwTTxSo+9IjwCXY=;
        b=TPsbqKhxmc0T+PxetBwAhdG6CCG7ROWrKmUGN3BsssTeSIgoXUOQnngTK58e76sGaV
         3u/siqCCo3eM5DO0OYSsT4wYCrRT+O8kY+a4+AnYqBHGb0Rj5B7cI0Hp7dOYnMvbxAD8
         RoAw7AYWgYK31cWIx7Yp8Ht4bfU+zuvlAoRR0OqLqR3iivh7tqnsNUSy8KpcavPHrnPn
         cHFxdJp1nmX7PTiWQDXtuL0nBeCqePhweoxs03ebVOn+oECM3dk8KZwiP6X63bDShGe/
         UcGW8KmUCjDJRi9tzyMH1ow70Y2j+cGCEuvyTbgcVe9mx5/NjKgrxZVEBbSazCAcGvGj
         1GHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qK1DQfY/agZG+Ude+bPzbHAaaA6lFwTTxSo+9IjwCXY=;
        b=658Gu7pdjUDkLsl/+wmCEQuu2kHXm0hHPnXl09rxZIcRek5ynElyLUJUTZjBZyHzEs
         Zhy1NqFW70WCZz3i+1qsoVI6t/pSrpmpjTPrXp4PHndDXnamSnHF8Xr6xsKmIQUDivqJ
         SzyqzlRXvC0E7i4D921ZE2s8rFSF2qsXlGgU2XFmi1G+aB0i4xrVL5gIqj++HpBKn1Xn
         1KCCMAJ5mtDcniJ1wkzsCsHafL5tQs87HUEcfJqQpCoQhi04DNumIpvwNz+FSajVkOaG
         AKNTbA3rignedr6nAIGh2zW5VRNIhmMzwFxYducNKxT2IzwDyeb78g5Xev5psYEwOcJ4
         r2TA==
X-Gm-Message-State: AOAM531SLrjFGYY/1xoXVyx4OniEn1dXNVsEOONjgOf+AEGvwyD6lpss
        1Z/6o+ntPc9+EC4hRtqXBdZmgGmAJp1I
X-Google-Smtp-Source: ABdhPJwU+prJ7BpJEtXxJA5crkhbYqb6Kqs4m4pINVmy8BqVqC8ntCResa6F6puuaRPR78ifpJ3Lzgoe5HTq
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:248c:b0:4ce:1932:80dd with SMTP
 id c12-20020a056a00248c00b004ce193280ddmr3851504pfv.48.1645723597604; Thu, 24
 Feb 2022 09:26:37 -0800 (PST)
Date:   Thu, 24 Feb 2022 17:25:59 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-14-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 13/13] selftests: KVM: aarch64: Add the bitmap firmware
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index f769fc6cd927..42e613a7bb6a 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -686,6 +686,9 @@ static __u64 base_regs[] = {
 	KVM_REG_ARM_FW_REG(0),
 	KVM_REG_ARM_FW_REG(1),
 	KVM_REG_ARM_FW_REG(2),
+	KVM_REG_ARM_FW_BMAP_REG(0),	/* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_BMAP_REG(1),	/* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_BMAP_REG(2),	/* KVM_REG_ARM_VENDOR_HYP_BMAP */
 	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 0, 2),
-- 
2.35.1.473.g83b2b277ed-goog

