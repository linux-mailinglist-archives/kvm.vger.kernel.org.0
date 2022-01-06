Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69F2485FB7
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiAFE2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiAFE2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:28:44 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37E2C061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:28:44 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id z20-20020a63d014000000b0034270332922so869878pgf.1
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DZhMao6Nzb59uhYqKntJMb0wcUFVe/fWTq/WjhQp4nI=;
        b=B1o6YWTCTFMPSevDHYwF+9S//2//N1+PXnP+1TlnL9QVCqLT3b6o+97FiIXC2Nrimf
         miXIYFPowqAitUy9yjFgHdCWNDRclnTBeLCH5Cqk/IQuuv1sqpGXycCeZCg2XLfjLKmr
         NJXVdmRvWjbihBhI07UiYrt8d3P1AzRX9cIlQa5D2W02fGotiV22DXZejhidqBzMrUV9
         whlE2JnFHTUHlcOfi8itXDTCtIMGZMvj49srS3x5poke3Unw8P2aIv6/E3RlYvJUyYp8
         T3p8ibnYLW011MeErL4RQkbPIbjwqeJw/1HUVsVCC39UDIVbpKuc5vo1YI91Uf1B/AFd
         RGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DZhMao6Nzb59uhYqKntJMb0wcUFVe/fWTq/WjhQp4nI=;
        b=tPxDwyWvjraiiVz+Gm6yFFnKqYLx6rkztgnD77nbA6OaoX4WgnpAub4IuL4lCP+lJN
         sxUg+dnrPn9gTDLuIctwKI/us6noCGJIzelq0VmfQDnZ8ElPT9MUUXYO0gdU+vpBc0Rr
         0jMTQ+k2pIiepB5CTV4nDjB4ttF2WtztPkSs6E4154izwtKq5KEk7Agu0e0GUjPNg7dz
         oJ2BjdjLcLGlQV6WdtNYSkOBeTFhzAKR/Sfhuu3x1hq1e38361ZumW6CVE7dplxW2slc
         cqE224bcyARezJYJ+8jhpvPZSFXWn2IieL08Xxt/Yxd5AgbYuQMqo02oqXgyoRV84VGW
         UxlQ==
X-Gm-Message-State: AOAM530q5CXgamtAyYm7JpgQB2pyaIspHIG5VocqZm38piK88Om9RJ7h
        s2eadd6bZ+NMGIT8naLFfBZX74YAZdw=
X-Google-Smtp-Source: ABdhPJxHr1H65bcpJbwKoKMxmRj0YdGYEJpmFPmZHlSITljOdjOCkEqQRWhGEdRa2gaCuVOqi+Jbpm101hg=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:6841:b0:149:6791:5a4f with SMTP id
 f1-20020a170902684100b0014967915a4fmr44802796pln.123.1641443324266; Wed, 05
 Jan 2022 20:28:44 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:26:51 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-10-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 09/26] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
expose the value for the guest as it is.  Since KVM doesn't support
IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
expose 0x0 (PMU is not implemented) instead.

Change cpuid_feature_cap_perfmon_field() to update the field value
to 0x0 when it is 0xf.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index eda7ddbed8cf..487ca7555c18 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
 
 	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
 	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
-		val = 0;
+		return (features & ~mask);
 
 	if (val > cap) {
 		features &= ~mask;
-- 
2.34.1.448.ga2b2bfdf31-goog

