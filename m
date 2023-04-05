Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799AD6D84C5
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 19:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjDERV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 13:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjDERVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 13:21:54 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422BD5BBC
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 10:21:53 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h8-20020a654688000000b0050fa9ced8e3so10816813pgr.18
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 10:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680715312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YZXp0/8PJTGepliQmzk6iLCbVVbymsexrmTW0hRHL+M=;
        b=XTTnAPzj7kVG9899g25zsvj+9D1iNIV9d1Jo24v6C38NNXjhfEnP1e5H4cxXfhRBF7
         b7rLGulBObZJB/MfqN+xHVqqw/2r0vWFb8H5R4i4mXlTbJPSbAkEHel4edTJvIwiVJ99
         JfKmJ0+HYF8/0ZweRaMHpKJEf3JoRYzgxXM646JGYNU/m9uZp5tsCySc3V8zYN08yXLP
         5w1Fv417CX67t84VJAVtfeDe4XNaPwvD5EwBoZaNh73QAPb7DQaTc0Wrn7OYfqzt1FvO
         zX8M24I/sLOlrJF098SFySRjZfHN/Gjzx3H7Sx2UVEq97apuH77F3DQl31XemS9y2LK5
         mNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZXp0/8PJTGepliQmzk6iLCbVVbymsexrmTW0hRHL+M=;
        b=kKISFYdc42sVBsjje+BIQYuV/8DxfabaJniZ+bbkZn7b9gvePa7fWSSaDdHkTlgyw8
         LCjdIR7Ne3sqSrljrDqm3f5x6vjwt190BeRxJr90UNLZeKl97HsE3VQXZaFMDWNNaj8s
         MnA1QhN5z4+tV9c/aBMHKxg9WTQbXxdsvOK7dt27hGlpr094UqTFE7QFDoJ04Jwv1okq
         DMZPsz9FZJEqk+milQTrdoXr407u3gl/Ta9FQ2gotY5ztGH9/xXzT0Kr4ao8+ljkMehH
         dEE74WSHLDXZS7mMZs6zruUskWaRAi9OzqzulhNkru+eSZymsjzsz1ASMljZDwe2u/Ir
         M96w==
X-Gm-Message-State: AAQBX9cf93o/QnZgd6g91WV9X1wZbgimksRVgzqgFhNdJQzJBBXSfQ2d
        2gtiGL7raujf/5+GWDbvOG0Hv3Fw2T3yjy9I/jvIF9Rsrt1igSvXCYaTMWPK2tvG5kPZujZuc3g
        Xw+8P6pTMXIfUiryBmQA8dDru9hdwXI4mvgKjriZbyo/HVBSuPP7Mu6wJxuaQ2ZNvrQlo4RU=
X-Google-Smtp-Source: AKy350YdnT5o9wS/pjdMEe/6lo2FY/3iyGIJvao+boVENo2vwZJtJU3No7oL73mE/HePZMnaS9bLUg8gsy47ERuERw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:e09:b0:240:228:95bd with SMTP
 id ge9-20020a17090b0e0900b00240022895bdmr2634779pjb.5.1680715312476; Wed, 05
 Apr 2023 10:21:52 -0700 (PDT)
Date:   Wed,  5 Apr 2023 17:21:44 +0000
In-Reply-To: <20230405172146.297208-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230405172146.297208-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405172146.297208-3-jingzhangos@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: Enable writable for ID_DFR0_EL1
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All valid fields in ID_DFR0_EL1 are writable from usrespace with this
change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index ca26fdabcf66..11d3a1d46ee5 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -548,7 +548,7 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
-- 
2.40.0.348.gf938b09366-goog

