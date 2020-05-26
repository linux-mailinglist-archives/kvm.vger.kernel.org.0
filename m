Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0501BA619
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 16:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgD0ORv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 10:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgD0ORv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 10:17:51 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63460206B6;
        Mon, 27 Apr 2020 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587997070;
        bh=CSSnDMC5PzLW9Ty/t6vNkRAXv5DRYOcczqebb1dCB8w=;
        h=From:To:Cc:Subject:Date:From;
        b=pzItXPTziBM5cfmNXO7kDO4LK36WFULj6A7TjQQnL4oRHAcho6MAGywU/VzBc2dPh
         4FQeR5lP2RXyYOKWneuAeGRzQaBrFaATmt9Eun8Qbn6OX0fADcX3ZpLeJbi9UEMRNu
         70GmJmp62lCh+0GfHqpNab9UNF1d11/vl78T4whA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jT4Zw-006kdf-Qq; Mon, 27 Apr 2020 15:17:48 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH][kvmtool] kvm: Request VM specific limits instead of system-wide ones
Date:   Mon, 27 Apr 2020 15:17:38 +0100
Message-Id: <20200427141738.285217-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, Andre.Przywara@arm.com, ardb@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On arm64, the maximum number of vcpus is constrained by the type
of interrupt controller that has been selected (GICv2 imposes a
limit of 8 vcpus, while GICv3 currently has a limit of 512).

It is thus important to request this limit on the VM file descriptor
rather than on the one that corresponds to /dev/kvm, as the latter
is likely to return something that doesn't take the constraints into
account.

Reported-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kvm.c b/kvm.c
index e327541..3d5173d 100644
--- a/kvm.c
+++ b/kvm.c
@@ -406,7 +406,7 @@ int kvm__recommended_cpus(struct kvm *kvm)
 {
 	int ret;
 
-	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_NR_VCPUS);
+	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_NR_VCPUS);
 	if (ret <= 0)
 		/*
 		 * api.txt states that if KVM_CAP_NR_VCPUS does not exist,
@@ -421,7 +421,7 @@ int kvm__max_cpus(struct kvm *kvm)
 {
 	int ret;
 
-	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_MAX_VCPUS);
+	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_MAX_VCPUS);
 	if (ret <= 0)
 		ret = kvm__recommended_cpus(kvm);
 
-- 
2.26.2

