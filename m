Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173F519B46F
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732994AbgDAQ6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 12:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732241AbgDAQ6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 12:58:31 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADA822063A;
        Wed,  1 Apr 2020 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585760310;
        bh=CBZKD+m/KX3im6HA1XqrNu2FJtS3v/4jycpmEZoi/q4=;
        h=From:To:Cc:Subject:Date:From;
        b=j1gug4YUthSAfCSHVZmmWwy70QFl6X5tQUOrJ5xDx3OPiLRJpn6FOp3RTBHtjjKwZ
         YQNyuXzfKl14Oq3ixq8UltLEJVl0TulMcTzLckPULcjx3SpoaQySvVZtUrzN+s4Xlb
         G7oTZPpkbKeLfB0hIzIqMNzT4uOhrY7Yn9u5ln6k=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jJghA-00Haev-ND; Wed, 01 Apr 2020 17:58:28 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/2] KVM: arm64: PSCI fixes
Date:   Wed,  1 Apr 2020 17:58:14 +0100
Message-Id: <20200401165816.530281-1-maz@kernel.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer.Dall@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christoffer recently pointed out that we don't narrow the arguments to
SMC32 PSCI functions called by a 64bit guest. This could result in a
guest failing to boot its secondary CPUs if it had junk in the upper
32bits. Yes, this is silly, but the guest is allowed to do that. Duh.

Whist I was looking at this, it became apparent that we allow a 32bit
guest to call 64bit functions, which the spec explicitly forbids. Oh
well, another patch.

This has been lightly tested, but I feel that we could do with a new
set of PSCI corner cases in KVM-unit-tests (hint, nudge... ;-).

Marc Zyngier (2):
  KVM: arm64: PSCI: Narrow input registers when using 32bit functions
  KVM: arm64: PSCI: Forbid 64bit functions for 32bit guests

 virt/kvm/arm/psci.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

-- 
2.25.0

