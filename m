Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6575B76EF8F
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbjHCQdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbjHCQd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:29 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EA130E5
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:28 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1bbb4bde76dso770441fac.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080407; x=1691685207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qX6uX+zjhMvlxZ1l4PideJKUAkuckmjO6QKloArzLfk=;
        b=R94Jg27ghBMe+8pXyv0yNEDs0bC953tVdWKPFV6vA4TGK6rzvTc09Y52RVPgfdp0mG
         /6RpDcjZJW5laVWp2iBMOuPs7dwUeHIQtpV5sa9d9dlTN46QrCnnjJj9ru1HkA4X352q
         yc/y/mPR/WIKSfMgrK8ovU1adcSD6tkSp40mcP9J7vrEGVnAmmhfkSZXzfXrwd3n7X/t
         gzrPj9TuiW6ucIgg4GJ1+QGG50bQEbJBTUPNS0y9nhC5FmNRMHevTeDy+1nHyRKbh9c1
         X0GCHHwVFuZUWQvVbYcCldacF/7YPRwWHAzsjpNDxUZ3pS2+6S61CZgDWf7oYL4Yb04h
         +SXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080407; x=1691685207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qX6uX+zjhMvlxZ1l4PideJKUAkuckmjO6QKloArzLfk=;
        b=hX05b0leb/lB0s5/kGNxYYl17muAW081L20K6wkWvr1vyC7DLLDfkI/YT6VDGESuqk
         PrEXmTbbEqNlNXZ5BGEYUDcOBftIUMFdEA8zz+t0cWMr4qJcTmnyu+5VM8345FmLN2Qg
         OS5SLiiassExc/LsOPr888dQZq5CWG+Y3xjKFENWy81d+4pzWb5wOkq0hiRU9DY7+HXe
         KO7w/AyYGkBt0UPB1oLGlLX/x13pgRfUVI8BKxA7+xAyTQz9vaFymK4KZuQ7LKzWBbfF
         2NwC/rmn6LwE4jUCyMeH1Hu14H+q65MovcQvdhH0DPsSP0Teq6hxRWSM3xL9kTSKR/yJ
         SatQ==
X-Gm-Message-State: ABy/qLbEitFrg/iMHQ+wDwT36E+lIF8E69OBsywZYGb/6JfL9dg18VAE
        zf5sSbTho6++gXYoqJ29q3Oorg==
X-Google-Smtp-Source: APBJJlF4UpvVSQIIhQhdxGLDKP5P6kayfkJ70CHnvKXEJ6xr3Aa4W68v/I+nOVn2bKwzsQK9klklyA==
X-Received: by 2002:a05:6870:f583:b0:1ba:f2eb:baa3 with SMTP id eh3-20020a056870f58300b001baf2ebbaa3mr21860578oab.3.1691080407296;
        Thu, 03 Aug 2023 09:33:27 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:26 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 07/10] RISC-V: KVM: avoid EBUSY when writing the same machine ID val
Date:   Thu,  3 Aug 2023 13:32:59 -0300
Message-ID: <20230803163302.445167-8-dbarboza@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803163302.445167-1-dbarboza@ventanamicro.com>
References: <20230803163302.445167-1-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now we do not allow any write in mvendorid/marchid/mimpid if the
vcpu already started, preventing these regs to be changed.

However, if userspace doesn't change them, an alternative is to consider
the reg write a no-op and avoid erroring out altogether. Userpace can
then be oblivious about KVM internals if no changes were intended in the
first place.

Allow the same form of 'lazy writing' that registers such as
zicbom/zicboz_block_size supports: avoid erroring out if userspace makes
no changes in mvendorid/marchid/mimpid during reg write.

Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index a0b0364b038f..81cb6b2784db 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -235,18 +235,24 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
+		if (reg_val == vcpu->arch.mvendorid)
+			break;
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.mvendorid = reg_val;
 		else
 			return -EBUSY;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(marchid):
+		if (reg_val == vcpu->arch.marchid)
+			break;
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.marchid = reg_val;
 		else
 			return -EBUSY;
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(mimpid):
+		if (reg_val == vcpu->arch.mimpid)
+			break;
 		if (!vcpu->arch.ran_atleast_once)
 			vcpu->arch.mimpid = reg_val;
 		else
-- 
2.41.0

