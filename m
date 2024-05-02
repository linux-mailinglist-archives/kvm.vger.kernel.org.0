Return-Path: <kvm+bounces-16420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8F38B9DAE
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 17:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0C0A1C22216
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 15:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B8015B963;
	Thu,  2 May 2024 15:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAmkZP57"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA45813C697;
	Thu,  2 May 2024 15:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664573; cv=none; b=uI2e/i5Ukqw1jyCNF5YN4gmHjIRxjj64p8P9K0E/3Ee+oZwRr3XAF+LDKNTq901Z8Rz6C78nON295kNg+5V/8d6KsK9fOJle4ng7Guuct5Wx5vLwvxBsNxOLbxRjqgHLO51acX5CAqT40pzPdKk0ugUSW60WlvN4ZcPdCAuw35s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664573; c=relaxed/simple;
	bh=5eBUBmndAeMIzU7wiDmFwOIDIxcvQl+iymkpM5oAR3s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HucXjR7cmVqJwBQwKRje+0DFDtSVXsAMc10gGiGT/wcvWv047TLPwg4qtNPiCTPukJ/yoWDFhOyufnW9wfW7bO2q6G75PzaH3ZfwWf+Yx3zuJnlyT09zV65o6FgcjdAHax2hiMjTgAp193F7rQieyA3gsG8+5c+eAm8CDFz2JiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAmkZP57; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59033C113CC;
	Thu,  2 May 2024 15:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714664573;
	bh=5eBUBmndAeMIzU7wiDmFwOIDIxcvQl+iymkpM5oAR3s=;
	h=From:To:Cc:Subject:Date:From;
	b=YAmkZP57/0kGevam+PC9104D2BNGobDFZ8Cfv56oz11o696OkPqCKQWRoQtfsOhWs
	 DNaDPyAm2EpXpMyS+UqaoIkYFbLwmAW7CDXl/yksGZ67C1x1lINGrY4CL4P+GZmaBl
	 p1js6etzAgeRI2ZRw78fjr314MpwEupgdmLpHPhvjaGMPXA8MruLPloXMWG6KLQ01w
	 EoCjiMQbmT1a9dhp2VypHXRwbP++Kn00KbenuI9cJ9ybedVVrvkB6RfQh7h8l6mexj
	 IvlbHfHiOWYNI8FyE/26huBJ05FGM/RXs1WDkLQXVKhm1EnBVWWUwUgdzmhXP0btQd
	 e8YF+pivrtq9Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2YaB-00A2mi-3W;
	Thu, 02 May 2024 16:42:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Convert kvm_mpidr_index() to bitmap_gather()
Date: Thu,  2 May 2024 16:42:47 +0100
Message-Id: <20240502154247.3012042-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Linux 6.9 has introduced new bitmap manipulation helpers, with
bitmap_gather() being of special interest, as it does exactly
what kvm_mpidr_index() is already doing.

Make the latter a wrapper around the former.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 23a117cb3e50..fe94e96dced8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -221,20 +221,10 @@ struct kvm_mpidr_data {
 
 static inline u16 kvm_mpidr_index(struct kvm_mpidr_data *data, u64 mpidr)
 {
-	unsigned long mask = data->mpidr_mask;
-	u64 aff = mpidr & MPIDR_HWID_BITMASK;
-	int nbits, bit, bit_idx = 0;
-	u16 index = 0;
+	unsigned long index = 0, mask = data->mpidr_mask;
+	unsigned long aff = mpidr & MPIDR_HWID_BITMASK;
 
-	/*
-	 * If this looks like RISC-V's BEXT or x86's PEXT
-	 * instructions, it isn't by accident.
-	 */
-	nbits = fls(mask);
-	for_each_set_bit(bit, &mask, nbits) {
-		index |= (aff & BIT(bit)) >> (bit - bit_idx);
-		bit_idx++;
-	}
+	bitmap_gather(&index, &aff, &mask, fls(mask));
 
 	return index;
 }
-- 
2.39.2


