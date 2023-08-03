Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5634376EF8B
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbjHCQd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbjHCQdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:33:24 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E453930E5
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:33:22 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-55b8f1c930eso764283eaf.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691080402; x=1691685202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JEYaOjRkNiCc5Arsd3SH+zFXne751CxcbC3uwvEPq2E=;
        b=nDqgSReQn24+I/TOy7vw45dSl5z0FFfSL4cVqGNwP0d0zlHKuSGsFLdlXng8abhd7q
         J/hIudebRlWXVsf5f0chJQEScgO6UFi5gVeNqlnnZiv2ktY3ija7neMd+GJvW0qGS1Jb
         DN/Lkjj+so6bSseF3VG9x1Iv5wSJBqV+r3vRnBaSLqTlALDqRIrv/SE7nwNjFfVks0le
         MlS1wKRpXnFKpEXXvZGPXh19Q5Z/jg4quL0E7sJ78ZvGrILu4tBaq1VWB52uM6PC8OR5
         0+S6IpNYUS9AuCti4m7DjFcI+0YMKAxr4QchZW+qSPitKjCVCr6b19wKbYHvRzS8qPk/
         x1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080402; x=1691685202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEYaOjRkNiCc5Arsd3SH+zFXne751CxcbC3uwvEPq2E=;
        b=Xbpbhss36F2w91L5au4cHdPGI/4bwtPi/rWqr8kxaon0hhvQYhVVaZJzD02XbWyPwU
         RwIuM9KChVJdFZNlq84M15SCXQhKoRdT2NO9xQtRckruZaPTWfjEt3o45GTiRDkAuLFj
         CpYyAOgf1B2S0SRJHwUvVZJqNDZ+qCJ2e3N8tHImSWI4yTLBXx9cUDiaio0dUKP/1rN9
         RpJ/6/afrb8L6vpkn85e7Kmn8F1WfH3hYrcZkAoil+RfXn8gJiMekQwNLL6jvpf0iXwP
         t2mfooN5GkRkVGigzP3Hh8FxrQ8oCu9hjildV3bHYsy1cj24BjE9CEIS55pU1YB8IpOW
         HQug==
X-Gm-Message-State: ABy/qLZnObQ7UK0KVN7pBSTJEh/iE5+F5nDMmd+kifSv9wwOAudWM9V4
        z0cLO1/kmHE85uehs29SZ3IKmg==
X-Google-Smtp-Source: APBJJlGKhxjt9ppMdXXgRQCK3rogM/kWokH5xOaV/O6CG2pZlKZm+depQdkRXmyceKMNzwj0pPo86Q==
X-Received: by 2002:a05:6808:1144:b0:3a7:4cf6:f0cb with SMTP id u4-20020a056808114400b003a74cf6f0cbmr10603918oiu.21.1691080402043;
        Thu, 03 Aug 2023 09:33:22 -0700 (PDT)
Received: from grind.. ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y5-20020a056870428500b001bb71264dccsm152929oah.8.2023.08.03.09.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 09:33:21 -0700 (PDT)
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org,
        ajones@ventanamicro.com,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH v4 05/10] RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
Date:   Thu,  3 Aug 2023 13:32:57 -0300
Message-ID: <20230803163302.445167-6-dbarboza@ventanamicro.com>
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

vcpu_set_reg_config() and vcpu_set_reg_isa_ext() is throwing an
EOPNOTSUPP error when !vcpu->arch.ran_atleast_once. In similar cases
we're throwing an EBUSY error, like in mvendorid/marchid/mimpid
set_reg().

EOPNOTSUPP has a conotation of finality. EBUSY is more adequate in this
case since its a condition/error related to the vcpu lifecycle.

Change these EOPNOTSUPP instances to EBUSY.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index e06256dd8d24..971a2eb83180 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -212,7 +212,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			vcpu->arch.isa[0] = reg_val;
 			kvm_riscv_vcpu_fp_reset(vcpu);
 		} else {
-			return -EOPNOTSUPP;
+			return -EBUSY;
 		}
 		break;
 	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
@@ -484,7 +484,7 @@ static int riscv_vcpu_set_isa_ext_single(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 		kvm_riscv_vcpu_fp_reset(vcpu);
 	} else {
-		return -EOPNOTSUPP;
+		return -EBUSY;
 	}
 
 	return 0;
-- 
2.41.0

