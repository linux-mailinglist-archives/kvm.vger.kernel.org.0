Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EBD485FBF
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiAFE2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiAFE2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:28:51 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F094EC061201
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:28:50 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id n8-20020a17090a73c800b001b341acb723so461382pjk.9
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=I40ndIQTy7x9VMBHQBZhGGkXME+bWi7SZ7wOPZ0TfR4=;
        b=kP8CfJs9IxAq5ufVq3mYZTyrh7u2l9HtOCw6kwveWBv509zUrkSsovsuKAqt+u71EX
         eVHnTj9zR51B7lJHWuabmWxQCCoGNMzW8a/YIHZ4VMK9AM+WGrhRhLnwP44BJxUFVp4u
         +WK0WGoRvwlHJZC7Tv3lZD9nLuEFoLqZAZK46XoG9U8b6cu0M0kKthBSoVKErqL9JCWg
         X9eIhMWHtrRZe454eJ78Eqh+Wbg/JlscAVNB6BjqFmbNzgickZYsejggXV9cTmHF8tua
         3yUk8wHoawv7IXl83ByuDzOSlnR4glUj0P5p1L6Olbi1h4J0407ccHrKsx1JJcRLci+0
         Fxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=I40ndIQTy7x9VMBHQBZhGGkXME+bWi7SZ7wOPZ0TfR4=;
        b=P6kxLQY7+Uv+QfdFQnF2HBIsNHBqxkxB2RfVJsHRhJLJ09E9LXmKLdLamypYUyc1NX
         sFyeMvuLJ1G56C90/fUsj6xad8Eg91h4ckV7+rPIYNlMvg2JpgR35thHKDpPvRDFFQP4
         MVlPxGp32ZmtjpyqwGBzYCSryt086/nEcCRPFZehyQPDhk42yWqi/5rwZlsDCovxDdid
         10UrJqcw1447XVdOScKeUatk3LCZLS7IGjp/0Q/NLjv/0CbOuRfg2XSRf51wOuTnTW5X
         Fk7vveTuWz2elbtUOl+pSaskcNw8YnnQ/W/lNebiDYFeW0+IZIJFzCBNtY2c6Fe6ldyP
         XodA==
X-Gm-Message-State: AOAM532bEAsKUN9lfla1sNE7Dq0LPysTHy9UHMao9A78D9LiH99IoUkd
        bfpoHPOLf95eymvhk+/O62GvOUAu2K0=
X-Google-Smtp-Source: ABdhPJz13ECz2/kMTHML2IdEfb9myPi6iTkJL3R7KtM4n8E3Zqigfsh8FnU2U9ys6rXGLm8n3QTpkNKaReM=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:aa7:9a0a:0:b0:4bc:79bb:dcd0 with SMTP id
 w10-20020aa79a0a000000b004bc79bbdcd0mr23775052pfj.70.1641443330495; Wed, 05
 Jan 2022 20:28:50 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:26:55 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-14-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 13/26] KVM: arm64: Make ID registers without
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
 arch/arm64/kvm/sys_regs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1c18a19c5785..ddbeefc3881c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1859,11 +1859,8 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 		/* The value is same as the current value. Nothing to do. */
 		return 0;
 
-	/*
-	 * Don't allow to modify the register's value if the register is raz,
-	 * or the reg doesn't have the id_reg_info.
-	 */
-	if (raz || !GET_ID_REG_INFO(encoding))
+	/* Don't allow to modify the register's value if the register is raz. */
+	if (raz)
 		return -EINVAL;
 
 	/*
-- 
2.34.1.448.ga2b2bfdf31-goog

