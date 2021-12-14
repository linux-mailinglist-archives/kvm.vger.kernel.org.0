Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E598E474967
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 18:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbhLNR2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 12:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236437AbhLNR2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 12:28:18 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999F9C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:28:18 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id u8-20020a056e021a4800b002a1ec0f08afso18356061ilv.7
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EylPoIwJHu5cp6KovczhslrKEkEYeADu9LS/s52w9YE=;
        b=WptfY3NUSXg/+ge/bSycAdDXNGBatjC9Ty3fRvRO/naZtajLtOnCel1J92sJl+ffyB
         gn+26lozgkVnDFQXpBa6gsCcYi+iyY4OuU7RAGOitBJmuO5NpueNu8HQNe2wJsQlV6mb
         s7HQwUbg5T382xCMHMjdkKxRgEijgNNkXxlDoC+ukK9aQYxusDSDlIbvu7hlEhqY3DzV
         PXKES3uS5RaC0dZXWqfEbw+aUVIHfHv1KsCCPV6Bv9GfSPLPIO74l8okr9dVLvECSxr6
         aLA1+JI2wnVQl0R+IFRqmZ5wRbK2MPHwT1vTHXV+IlorXhALZmCfzJ++Gt7rw6BYo9I0
         i7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EylPoIwJHu5cp6KovczhslrKEkEYeADu9LS/s52w9YE=;
        b=CbZiAC9V/bpjpX+zdLFvjvLvwNs1Yjr0aY0OHADTFU8Px6liHw7zDHxOso8JB3ikvW
         hcWk3yToNT9sbDbg1PKBBVr9I3nBYx3CxX500FyM6N+GbvOpc5BSP1yssFNupbqOKXUN
         isfhKriqYiSS2laykCrQpvzld/CCumqd7KdK5ayFMcPGeYu9IZ3dbOo80Pn6oq/UdOGM
         n9h3xUgdQG9jYNvHyggAdoNUR89qozkKQqNm09EwyRPZrHp53tXojuLw72SmcMT0HO9D
         J49d3bAzr2IKRkK8bhJD/DDRYeX2PdxovVzL9L2I+66q7Igd5Oms30QFRnWKQKEFNw2l
         ZDZw==
X-Gm-Message-State: AOAM530Te/JGqeYoukChR+/icLfgkE39WbeIhOr5NPA9g2igQOhEAcbm
        5uRJ3Ce9zXk/0W8zd/MDhJsMGLZonrE=
X-Google-Smtp-Source: ABdhPJxlHuYVYQeqSWOyzJfDt70mmril4aeZVLx8iWFQhBCjg4s0ijgzuxjSVPZcN3dObuSd5rcGMlUpWSY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2d84:: with SMTP id
 k4mr4567077iow.168.1639502898040; Tue, 14 Dec 2021 09:28:18 -0800 (PST)
Date:   Tue, 14 Dec 2021 17:28:07 +0000
In-Reply-To: <20211214172812.2894560-1-oupton@google.com>
Message-Id: <20211214172812.2894560-2-oupton@google.com>
Mime-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
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
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Any valid implementation of the architecture should generate an
undefined exception for writes to a read-only register, such as
OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
behavior.

Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
write ever traps to EL2, inject an undef into the guest and print a
warning.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3ec1a44f94d..11b4212c2036 100644
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
2.34.1.173.g76aa8bc2d0-goog

