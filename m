Return-Path: <kvm+bounces-30456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 071929BAE67
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7F951F22B9E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53081AC453;
	Mon,  4 Nov 2024 08:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AzieHN0y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24681ABEA7;
	Mon,  4 Nov 2024 08:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730709846; cv=none; b=P2SElU+bngG55wn7sBwOUA7IluYV4IXmeMm/PCqsSQKAsCMcXAhD7/7d/h4yonT6wh2BSNFcKYm82bmPvzijSdV3bBikmpsugcW9aNsaB+t0iKepZIDYKqzaE7QGHaWpvhmlZ+qxeJSfCurM6TC6lwQ3tKBbzHsonJzT/dRgxA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730709846; c=relaxed/simple;
	bh=+ZBWWvleO7nfbEVKwH6/DC4gAC4hBEKkoCslvkfTEJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GW+qs1SFcTq0Z7+lrCqLLw63lEw68xT6Actw2C9BWD99YrCpPL5eXBR+NrdK+ZQZLkSdNBIl6oNQK9PAawVP6aYPvbU+ydio6eR30yY14jxnK/fc2Ob77N0jr3y4koFxbuNfmUZtmomxRBX3pBwuIju05ittj00B8/XsD6FL0Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AzieHN0y; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730709845; x=1762245845;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+ZBWWvleO7nfbEVKwH6/DC4gAC4hBEKkoCslvkfTEJA=;
  b=AzieHN0y1+SbW8QdEQZnPQmU/87w8MdyPITW6as3DdUa46KkUE9uFJBv
   hCI8NlnibWOi+xaPfuQ5dXAajOdio7gYir6twQhJkEDy0l2FibLIIh3Ux
   YqNpAwnW5V5xh/uRzFLkRFW/jHKbDz4LJiBxeJlkzgxEozOgeE4xg9qZJ
   GXihVbxIxZBGOLbAup1vZ4t8Zd5OJLgsEK9oyjAVLkJinygsUBt4Pz3CX
   NbkMjUJAmXSuj3+yL0kN3bPKlDPMKyDEHOlJFvlEzT+GLZOi3S+ZyTEPS
   KWjqZ8ViGMndNIhJF0Tx5eQ9gFpCaP9D+s97xnONcTaBr8tbUmQbtdYe3
   A==;
X-CSE-ConnectionGUID: roChPCJoRRCvoj48oIIqmQ==
X-CSE-MsgGUID: xL6AOO+NRbeS79fconzclg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41502703"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41502703"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:44:05 -0800
X-CSE-ConnectionGUID: jratMOzMT4Kz1CmhBa6qtQ==
X-CSE-MsgGUID: lCf8imRySVmTw5NmMSFl9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="88167743"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:44:02 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/2] RCU related fix based on kvm-coco-queue.
Date: Mon,  4 Nov 2024 16:41:37 +0800
Message-ID: <20241104084137.29855-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Paolo and Sean,

The two patches are fixups to RCU related issues reported by sparse.

Patch 1 was reported by kernel test robot related to dereference of
        mirrored sptep.

Patch 2 was a result of running sparse locally with error message:
        "error: incompatible types in comparison expression (different
        address spaces)" in kvm_gmem_get_file() and __kvm_gmem_get_pfn().

        Initially, I wanted to fix it by using rcu_access_pointer() to
        fetch the rcu-protected pointer slot->gmem.file.

        However, after further analysis, I think it's not necessary to
        rely on RCU to protect slot->gmem.file.

Please kindly take a look to see if they are appropriate.

Thanks
Yan


Rick Edgecombe (1):
  KVM: x86/tdp_mmu: Use rcu_dereference() to protect sptep for
    dereferencing

Yan Zhao (1):
  KVM: guest_memfd: Remove RCU-protected attribute from slot->gmem.file

 arch/x86/kvm/mmu/spte.h    |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c |  6 +++---
 include/linux/kvm_host.h   |  2 +-
 virt/kvm/guest_memfd.c     | 23 ++++++++++-------------
 4 files changed, 16 insertions(+), 19 deletions(-)


base-commit: 49c492a89914b02fa5011d9ea9848318c6c98dd9
-- 
2.43.2


