Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B133411B954
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 17:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbfLKQ5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 11:57:08 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:58772 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730107AbfLKQ5H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 11:57:07 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1if5IN-00076q-Pr; Wed, 11 Dec 2019 17:57:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 0/3] KVM: arm/arm64: user_mem_abort() assorted fixes
Date:   Wed, 11 Dec 2019 16:56:47 +0000
Message-Id: <20191211165651.7889-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, Christoffer.Dall@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexandru recently reported an interesting issue with our handling
of device mapping in user_mem_abort(), which is sligtly less than
correct. The first patch of the series address this issue, and
is a stable candidate.

While I was looking at this code, I spotted what I think is a potential
issue when handling a poisoned page, where we can race with a VMA
being removed. This second patch is mostly a RFC, as this is not
my area of expertise.

Finally, the last patch is a cleanup removing an unnecessary console
output.

Marc Zyngier (3):
  KVM: arm/arm64: Properly handle faulting of device mappings
  KVM: arm/arm64: Re-check VMA on detecting a poisoned page
  KVM: arm/arm64: Drop spurious message when faulting on a non-existent
    mapping

 virt/kvm/arm/mmu.c | 47 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

-- 
2.20.1

