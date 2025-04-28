Return-Path: <kvm+bounces-44564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20255A9F01B
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 14:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 174AB166936
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 11:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D84926AA89;
	Mon, 28 Apr 2025 11:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDpBua/M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D99626A0B7
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 11:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745841474; cv=none; b=FnFRhJntL2dO8z1cathWiZhqE7KqBaccJ7HxZ8US2qWb/A9P199ZiHkKcQL020Ir8JskUcdLP3/75p/d2U9CiKyAqI6p6fBYfHm5fOJADlrSH7/MmgmZRlccqKTQpgm170IqP1Pf599t8dUdM0C1cJ6uu213Lcn7XlwbloCb3K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745841474; c=relaxed/simple;
	bh=3cXDLitBN0T9f+5qWPvbJCjiS5apAVq/Z+2h4g/z1/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P1yANn7u9Bkj7jWtx3InTU38tk+gotJyORGUKftjBa2lXcY4NCyFcwx3q+yeA07a7IMJFrbaUb+HMWfL8vrurwNDPExH9LGnqzc6JeZTDtNDKz0E9QPtT75UXLR5us6nbxLg2ILBI1kZBc6NlhT/Jpd8Z3LIWYnuKpYpMYi59qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDpBua/M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9691C4CEF8;
	Mon, 28 Apr 2025 11:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745841474;
	bh=3cXDLitBN0T9f+5qWPvbJCjiS5apAVq/Z+2h4g/z1/s=;
	h=From:To:Cc:Subject:Date:From;
	b=SDpBua/MoXT7PBEMsEVYvhPCFHBCszX77iIa4bTLajDSX/mmnjh2ZayPCI1RhOcTe
	 ypSKPhYAmhl+LOAdWxhF7ODPNEPOmwvJP4Nr/+GYCc6Ct14eOWZHjrn6Nhw3rhCug3
	 XuX/PJyRrqPLWZdRij0dLPnml3YNXUr4H3+2E5mh9rZrevK7+w+yJ4mlYsGY/4s8v/
	 BU+aJ/+PW5lI2hnCPWf/jGPGt4eAiVofxZRHG9ZCcBFEy5GGykxZlmQLDJiU/gIX9z
	 mrAlF4QJh2gApNVYxxmU19o91BUFxfwAdilNLWW9MDjaHs7gySqavgg6DYeiD6wzlk
	 VGt3Asbej+8Xw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH kvmtool v3 0/3] cpu: vmexit: KVM_RUN ioctl error handling fixes
Date: Mon, 28 Apr 2025 17:27:42 +0530
Message-ID: <20250428115745.70832-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes from v2:
* Fix smp boot failure on x86.

Aneesh Kumar K.V (Arm) (3):
  cpu: vmexit: Handle KVM_EXIT_MEMORY_FAULT in KVM_RUN ioctl return
  cpu: vmexit: Retry KVM_RUN ioctl on EINTR and EAGAIN
  cpu: vmexit: Handle KVM_EXIT_UNKNOWN exit reason correctly

 include/kvm/kvm-cpu.h |  2 +-
 kvm-cpu.c             | 30 ++++++++++++++++++++++++------
 kvm.c                 |  1 +
 3 files changed, 26 insertions(+), 7 deletions(-)


base-commit: d410d9a16f91458ae2b912cc088015396f22dfad
-- 
2.43.0


