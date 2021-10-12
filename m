Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A04B429C9D
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhJLEix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhJLEil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:41 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E09C061767
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id a16-20020a63d410000000b00268ebc7f4faso8029955pgh.17
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1CPPpn8KI1TMZ7GOgYY97mtQvxGoDF5nzyvksmCa+Fo=;
        b=Aa/p3+3YZnA0JDS8zWOXEXRZ2ZxkPrOLUOlaX3VyAf7LudzDEdPB3CLJ1YVKMe7L9G
         Wb8CyupAqRRvvfXLbGdNalJb9N1cIo9LYCHTskPgOkE6h6lfDwn+y9/uxIl8ygZCkOUD
         CNPuFzpb9ztvN1IozmoW1sGZpIedv4EjEUpJDMCY/hS2AgqJE8x+CTgsRrNjDDZqbME8
         l90jqzqQhgg5JVyOWjLQ+mT6BS5zOh9zM/vLwhRCm0ZtrfpE4PF9CW58QdPjF02Dt0jz
         6HZjuCYbrZSCLV4LiEZqfciTJsA8zVhac0Rle06fMkXQhjS2DhUlWMc4fK9x5TOiAgvs
         bU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1CPPpn8KI1TMZ7GOgYY97mtQvxGoDF5nzyvksmCa+Fo=;
        b=sAgNDM1IiYdcF8kbJpMaMYDA+gmK1KiVgL6PDA7+tDtQlxq3o9O2dMpIxyRlSW3NB+
         Oo/45MuPXsrg5J2G33iecnrav495q7gQ159OiiWKr1H35iobNVs0JzKowZrymcDUnIWE
         FXxg06tS/i+kSCd/n79jJGrcoatzB2qZ2cnTinc5Hu2f9AvOusJA7urQAI/iC9Zpr3HQ
         AYrZ0P7AMwUlAnchC6ygK8N5PRdLyVzt9ys+EOsw7IyEv65Edpa13RFvCJwAreGNe/pS
         7f2SIPcxOstC4eaNGCKPOFZle2iQI71lEDwelJmfWNqNbYo2vUbmxVFQlhG3WgojkWns
         IZEg==
X-Gm-Message-State: AOAM530Gr8+06xaZGzOXaQtExLU91PIDue+LlfHwuhkZx3wVrV4um0Ze
        u9wFw6IlgPgyhj81WOe5Ow4ywo5xkhs=
X-Google-Smtp-Source: ABdhPJw94QBclZTr8KRoQua2KsoSUSz/7GaRlZ1blagFA4MtNarr7PzT8SqQ7pJ7+LRN050secmOa62Uv/c=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:984:b0:44c:e996:fc2d with SMTP id
 u4-20020a056a00098400b0044ce996fc2dmr20321105pfg.31.1634013398952; Mon, 11
 Oct 2021 21:36:38 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:23 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-14-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 13/25] KVM: arm64: Make ID registers without id_reg_info writable
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
 arch/arm64/kvm/sys_regs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 71cfd62f9c85..2c092136cdff 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1625,12 +1625,8 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
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
-- 
2.33.0.882.g93a45727a2-goog

