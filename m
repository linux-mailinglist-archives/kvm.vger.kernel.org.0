Return-Path: <kvm+bounces-57581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E915B57F8B
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C7E0177101
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4890342CBC;
	Mon, 15 Sep 2025 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HcCE648S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965FE342C93
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757947785; cv=none; b=FhoeuYL9E7es8Xidl5aBxQHcYyjD2QguJv7/aMwRIH8Sl5j5usjYOcjw1gHvvUaVNOkRXlQqzM/Z8D0Ki5WQS73h9i9AEb/g1jGLbLkJvriVym3RtbjMHJoc9T++ot74jLBim3BX+7B8gSlcJbUc/XV33wLLQvdmdqOYb1lufNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757947785; c=relaxed/simple;
	bh=CKk3kknMuDJ0slrmVyO5RIXTXX3tdNJmw9vcal1x+XI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kFGdxfJclaSaAi2Gibci7Heby1X9/z0KI7qc5SPpjtLgiqdwsh+hXHASlkkonOnbuvivu6vemjeMEbqXyvcpTC/ddNly0/nHcGnmpWHA21X2aWsOPGmCyIQjB0Sz1to6oUqf3/lXNwjkrsUrKfd7FzUC2rCj6toSY9Z3/xTTA/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HcCE648S; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757947784; x=1789483784;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CKk3kknMuDJ0slrmVyO5RIXTXX3tdNJmw9vcal1x+XI=;
  b=HcCE648S0leOFbBzrsmu/XqoqYgEkOq7vEmyLK4kn+j3UmdoiOiqe8R2
   n67oTzZ6I+d8aoo5sGf6THJRlwHXbjrCNXxpL4VvXaO4OmvhMT7qPg8Rp
   Fze6ZzrttXcB/+1QAuda+wjuYGwj/REOgLW6YmgNvXmyOMorihwlneb8l
   ljmpuBXY/ybLIV5F9IPZZeCs8w1SMkRI9XiXSRdgbyUSMXtWouxs6+FxF
   V0gbTAkDyUNAfIyoh7Ma0Z3iTh7g66mAntMRXR2jqYUxA1Omo/xru1gwZ
   fJZfic4TwODJYhpCldNI3yz/jIYGALApqKgFGV5DLOnzAcoGeTi80QnMQ
   w==;
X-CSE-ConnectionGUID: YgplQM1US6q4FoLgLvhSow==
X-CSE-MsgGUID: ycf2akQ1Q7it/XlnmGoc2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="59247129"
X-IronPort-AV: E=Sophos;i="6.18,266,1751266800"; 
   d="scan'208";a="59247129"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 07:49:43 -0700
X-CSE-ConnectionGUID: lWCu0UowTSagFB5LVnEM1Q==
X-CSE-MsgGUID: WNAsIE3vTvG0s/aosOlv8w==
X-ExtLoop1: 1
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 07:49:43 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH 0/2] Fix triple fault in eventinj test
Date: Mon, 15 Sep 2025 07:49:34 -0700
Message-ID: <20250915144936.113996-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As reported in [1], the eventinj test can cause a triple fault due to an
invalid RSP after IRET. Fix this by pushing a valid stack pointer to the
crafted IRET frame in do_iret(), ensuring RSP is restored to a valid
stack in 64-bit mode.

[1]: https://lore.kernel.org/kvm/aMahfvF1r39Xq6zK@intel.com/

Chao Gao (2):
  x86/eventinj: Use global asm label for nested NMI IP address
    verification
  x86/eventinj: Push SP to IRET frame

 x86/eventinj.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
2.47.3


