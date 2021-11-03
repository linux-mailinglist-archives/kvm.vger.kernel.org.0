Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296BC443D31
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhKCGbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhKCGa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:57 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D62C061220
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e10-20020a17090301ca00b00141fbe2569dso649155plh.14
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kNjTPzP2KLdpBZioWjSqQb8109nySN2BIgqc7hOB6qs=;
        b=AfpsRAPpSTvALsHZ0QnP5jU02J0/Z3dgKDvHgH5nClQw7JMedG9qWr0ZRMiobPmrAW
         0r+PYxsUEkUxjdxdJ6L556u0HVB/Zl5mq3QRWFXm8rgjLc7HTzh6VdKeU9MIgcZ/Zxml
         PVVe76BxFjMMsUwIcgVTvNqdrFG4LofekmP+iY8Ruvwdxe8ypsLG4ek6srsQcCs5DP3w
         uqjbxPp4oBvGERNCrd0lHsSx0gGRU628gRGZTlTuXm9EXjCnbiD4Qq9v2d72PNRiW/av
         S+s/UKR+NFVCAFmIm4FpXxK3gWC2freG//KY5OB1zKprirGGzArEsbaC69f7EAmeZg8i
         STFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kNjTPzP2KLdpBZioWjSqQb8109nySN2BIgqc7hOB6qs=;
        b=zfnHY8QrIF7ssBy1oYBGzdCCqT6ROArfTkq/A/V6sNjGajaWSbxCS912n7wlPntP1w
         t3Da35P7VSsQEwmjNkJGUXouuy4W0YOXF2V9Jiyt8+xQKwcmMOzDt7ZlohLCNQMOiEBj
         JEp/XIXNIR/cVCussCUGkDmrrqghLoeBZNz87VHdMc9q+Glu9Higs1Em5Fko9LMKnNLK
         3d29IzektHIxF1/j1jKIajh4D5iAx3O/oPrIpJGGJs2/+vYinuv6KV3uLAwal4F8thDu
         rHILKrlGLNX1T+DxqkH3dvYBAR4hIJ8PPSVXoF8CHXmTGol1gtaXBtM24V607Nm9P6vb
         1OMQ==
X-Gm-Message-State: AOAM531YxfWbx2WyLBnLml7pXZOqFzHDyNZfMbdgWhVW4yyqnqU1h1Mc
        0748bb3hBb3sh1MV/cyCBtr0h9cTBz0=
X-Google-Smtp-Source: ABdhPJzPkyz8U9fHsTJuHQswL3KaxgisjjocgibWzmnaPNs/FZMpFacvIrZvfkYMZMGH+/n999KUp7HLIcw=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:a503:: with SMTP id
 a3mr12433259pjq.122.1635920901217; Tue, 02 Nov 2021 23:28:21 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:08 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-17-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 16/28] KVM: arm64: Make ID registers without
 id_reg_info writable
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

Make ID registers that don't have id_reg_info writable.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 99dc2d622df2..1b4ffbf539a7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1836,16 +1836,12 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (err)
 		return err;
 
-	/* Don't allow to change the reg unless the reg has id_reg_info */
-	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
-		return -EINVAL;
-
 	/* Don't allow to change the reg after the first KVM_RUN. */
-	if (vcpu->arch.has_run_once)
+	if ((val != read_id_reg(vcpu, rd, raz)) && vcpu->arch.has_run_once)
 		return -EINVAL;
 
 	if (raz)
-		return 0;
+		return (val == 0) ? 0 : -EINVAL;
 
 	err = validate_id_reg(vcpu, rd, val);
 	if (err)
-- 
2.33.1.1089.g2158813163f-goog

