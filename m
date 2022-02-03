Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B794A8A5A
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352975AbiBCRmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241501AbiBCRmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:42:04 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1375C061714
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 09:42:04 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e130-20020a255088000000b006126feb051eso7221527ybb.18
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 09:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=x5tD24Fm1rwvMTOsASLM22AFSW2OawoOEHLwGQ9pDuc=;
        b=VqO8XHbAyLJ2tZ/5GGV07Lv8+Otgp2b4HXEJpAWIswlWiwrdoqvi8vWs6wFL2jgD0n
         1Vej2KnZwNkNolZRflQhj+s0T1pg1WdwwIG+rGLP4BTyf/T08T7yN7C4SIaEdslOEPoI
         KKf+gUUGANaBn05ZhcDUO5b6rLCjXe/hkWpQtHlL1Aibo1be2J3Z8aHKvtJvw/TqstNU
         90SNgQ/dORslJNj3zwhSpWq3eer+0sllJSQ0Pfcu13cOXXr0Ps6siAOA/t65GUPkRzMX
         h0LgAjLbVvmwKg0CIovvOg5CKRhNrja/c3DzkWvXZDDY+pDaV3lqb36AM28U9Nx04Tdp
         XSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=x5tD24Fm1rwvMTOsASLM22AFSW2OawoOEHLwGQ9pDuc=;
        b=UwHqzoMKBCeaLaydWfDCwfxEcxkCX6ACtVP373JjoSykkd45YtdOOTnipVC4a03DRk
         wPhsUaa4y0e9raHxZhu4/etOJLAbcX7tWxeaKQRDO0oJBdS/XlUST3d4w6GJ6ml9c9PW
         9XO9mx3k2IKeEPXHSi+JQ9MJCt84YTqGipOxv9g/I7Ci7dzMl76Oew8t6SvGUFFGjR1h
         eW7xaMtVPdCpXRha5mYMDhiP4O7mmonyakc4ev65UiVXuz5spZxSQxQfkGwDN2xg0sTf
         QP+eKQnWsJFKOTW1e8h4ZvJXsa5A3aRoNPZMRTEWa3aYc/HxRMuzxj0tnYNy/oh+YWwl
         09wQ==
X-Gm-Message-State: AOAM530XIln5OmqGCK3PBNvIjtLHyx3y/CcazZwYbywbYCQJUKeuqAd/
        l5sMIuoxyq2Ojpxt6huYD75YwElmDi8=
X-Google-Smtp-Source: ABdhPJzjipG+LZdF5GKOtsltb9S8zXEjr6pV/0RmHZ+YGaUkd3Q7Jy3LB0RxNWMlPEsYdiA5+sBM+SojxyY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0d:c7c6:: with SMTP id j189mr5174886ywd.395.1643910123903;
 Thu, 03 Feb 2022 09:42:03 -0800 (PST)
Date:   Thu,  3 Feb 2022 17:41:54 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-2-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Writes to OSLSR_EL1 are UNDEFINED and should never trap from EL1 to
EL2, but the kvm trap handler for OSLSR_EL1 handles writes via
ignore_write(). This is confusing to readers of code, but should have
no functional impact.

For clarity, use write_to_read_only() rather than ignore_write(). If a
trap is unexpectedly taken to EL2 in violation of the architecture, this
will WARN_ONCE() and inject an undef into the guest.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
[adopted Mark's changelog suggestion, thanks!]
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4dc2fba316ff..85208acd273d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -292,7 +292,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
-		return ignore_write(vcpu, p);
+		return write_to_read_only(vcpu, p, r);
 	} else {
 		p->regval = (1 << 3);
 		return true;
-- 
2.35.0.263.gb82422642f-goog

