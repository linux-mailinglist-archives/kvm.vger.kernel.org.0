Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD30F454151
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhKQG4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbhKQG4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:19 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023FFC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:22 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id mv1-20020a17090b198100b001a67d5901d2so2618205pjb.7
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qC/eXS2nFGbe5LWPRqIYtTbFYtBHmQ7GJKQdVVP+A0A=;
        b=ghbQ96p4mvC9twAH0Tuj9lFaRHB0m+8uJQPFzZ/CIBytnHC1y3VVqa5GIPtE6fyT9m
         +nnTxOjPfBRykrURArKpX2lWueXwUYmbzzd1B19UzxxMpqE4r5tms+Hsh7VPek4W+Kh3
         w3pKoJUfdsAarCISRa5BiPct5PvoCMPMOX+U7d+0giU2WFUZ06dfLr+8kseGJABiQtfO
         uIN6ChXyDtLWyDwej87qXdsZippbWA6S84KHonLZMfYhMIK4+n/AZWFLeoAqSGsIDWoP
         OGFO9nIob2MxsERrirI2PCI8fIqEfdqOZGLzdc5U3v0awu3fxsk7lv4JAfnpteT3tp1Z
         CymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qC/eXS2nFGbe5LWPRqIYtTbFYtBHmQ7GJKQdVVP+A0A=;
        b=V8L9J3BpR8VFQGZgyVfFHGMTxIhojcYiU+mccwSAX1HjE1HhPFr7bKsH+6RC6fYKW0
         o6RYdLWOrhOskaCDX/2SEaX+pDApJlvzvp8bEzGkUJHxhoswhpSIs7x5N+5rGQ+IxoL/
         RvAi7IB5/kz8AvrPGtL9XjSIEgWiBpzz1OQxJ7l7kf5Nq8v41G4wVI8OKLk0uw2vmkaC
         L6Jmc1baxDuvauZZzISSU6bsN5goq9ahu3PSia2JjupKCner3ePqHrXDBklybyM6I4Sv
         L9AO52hGgXg1biWcbSwBwBVvjVWk9o/8vqboHtWMmUzPqydwISTpm+cPuW3Txf4DDbqb
         ZPzg==
X-Gm-Message-State: AOAM531R+ZuI8zmrsLf/n9TZLsA+8pNHJY01vseO6cE8SLtyHmiQIXMo
        kMOIMLPT4AYubVH0PkdkfoQpNMIgyUU=
X-Google-Smtp-Source: ABdhPJwC4wjg1VuToYTvSJudxfPpKWjHgt+8qmyxs2CKjFyvyU3SEzO1OSgLiJ1kbIUegF9tuwn3xYxJOOg=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:748c:b0:142:5f2f:1828 with SMTP id
 h12-20020a170902748c00b001425f2f1828mr52715009pll.4.1637132001549; Tue, 16
 Nov 2021 22:53:21 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:42 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-13-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 12/29] KVM: arm64: Make ID_DFR1_EL1 writable
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

This patch adds id_reg_info for ID_DFR1_EL1 to make it writable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fbd335ac5e6b..dda7001959f6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -859,6 +859,11 @@ static struct id_reg_info id_dfr0_el1_info = {
 	.get_reset_val = get_reset_id_dfr0_el1,
 };
 
+static struct id_reg_info id_dfr1_el1_info = {
+	.sys_reg = SYS_ID_DFR1_EL1,
+	.ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -869,6 +874,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.34.0.rc1.387.gb447b232ab-goog

