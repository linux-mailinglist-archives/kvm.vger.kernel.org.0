Return-Path: <kvm+bounces-25020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9601495E6A9
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 04:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2343CB20CF2
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 02:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E96EBA3F;
	Mon, 26 Aug 2024 02:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SfQvVbhq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E3C46BA;
	Mon, 26 Aug 2024 02:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724638873; cv=none; b=V0wnJSULd9KeY0L8BTjZISycLnxSM94JLYktu1BpIROCDYADDQQCyhmNbv4jTe40aE7LkIcKOPbFs2xIShBe1a5XkeuVbHmuC9h6xYcMAY4bkXgekdgd8czMC5L1Fk+7O4nXkBqaHU6lmlTvLEXJsAS5UXzF5iQ+rOh7ae5Rct8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724638873; c=relaxed/simple;
	bh=6O1qoaTatCZtheGJjV8GMaqY8U/zq7K57iM9RrvLajQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q4RVl0jQmea2a4n2SLaVVPvw+O/wL74pVrK7JiTr+3vE2DwmVXnZV5NyeMNzCsjReqIgEqFhJueCL6vlvZZhFWZe1IdLC9gdWG+zNQHu/kTUbdf7EmuTyt+hI4BTp0XIxv2JClovpFqBjs4YOFQA9XjMlBVDlc5acp3mLTKQrvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SfQvVbhq; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724638872; x=1756174872;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6O1qoaTatCZtheGJjV8GMaqY8U/zq7K57iM9RrvLajQ=;
  b=SfQvVbhqbm45GEhlZl4OHslkJ6Xvs7mmUTgQY58m+3OonBGd4EjWzlWo
   T1y1oWsP1SfO+K8vM+45kpxT5viSsy5eKQ8NfADm983M3mOO/wFeiL4kv
   We6kqrB5sS6lbk74XLWBfEP1kPVk58kJ9+GQ2mxda7IkgUEFzHmpmP8W/
   yQAHe42ZCckr+NAtk1BYgRKVuQlf+C270THV0S2rbe+8mP6TPJPHRBujz
   8MOdTTT8HDUcwDoI+GTqBhFJ7Puyr7SL96X3Fb4jxB5PLnyQB5d5jsfZt
   c66UEycYYVOkbEaVhQ0afDJ1HnQlQf1LAx+ydEy8iNHaGSZ3sgYOFQGQQ
   A==;
X-CSE-ConnectionGUID: 0w1bplJ8TCu48IpS/bsNYA==
X-CSE-MsgGUID: Ta95WZsgRMSaujT77SzpNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11175"; a="23207984"
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="23207984"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 19:21:11 -0700
X-CSE-ConnectionGUID: GpPeuhT2StGXdD8zl2QUqQ==
X-CSE-MsgGUID: cfCcZZUXRLCX17sa/by0VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="62336541"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 19:21:08 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	yuan.yao@linux.intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 0/2] KVM: x86: Check hypercall's exit to userspace generically
Date: Mon, 26 Aug 2024 10:22:53 +0800
Message-ID: <20240826022255.361406-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently in kvm_emulate_hypercall, KVM_HC_MAP_GPA_RANGE is checked
specifically to decide whether a KVM hypercall needs to exit to userspace
or not.  Do the check based on the hypercall_exit_enabled field of
struct kvm_arch.

Also use the API user_exit_on_hypercall() to replace the opencode.

---
v3:
- Rename is_kvm_hc_exit_enabled() to user_exit_on_hypercall(). (Sean)
- Remove the WARN_ON_ONCE(). (Isaku, Sean)
- Use BIT(hc_nr) instead of (1 << nr) (Yuan)
- Added a comment to explain why check the !ret first. (Kai)
- Add Kai and Isaku's Reviewed-by.

v2:
- Check the return value of __kvm_emulate_hypercall() before checking
  hypercall_exit_enabled to avoid an invalid KVM hypercall nr.
  https://lore.kernel.org/kvm/184d90a8-14a0-494a-9112-365417245911@linux.intel.com/
- Add a warning if a hypercall nr out of the range of hypercall_exit_enabled
  can express.

Binbin Wu (2):
  KVM: x86: Check hypercall's exit to userspace generically
  KVM: x86: Use user_exit_on_hypercall() instead of opencode

 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/x86.c     | 7 ++++---
 arch/x86/kvm/x86.h     | 4 ++++
 3 files changed, 10 insertions(+), 5 deletions(-)


base-commit: a1206bc992c3cd3f758a9b46117dfc7e59e8c10f
-- 
2.46.0


