Return-Path: <kvm+bounces-70689-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKq6CMyWimn2MAAAu9opvQ
	(envelope-from <kvm+bounces-70689-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 03:24:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 87CE611644D
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 03:24:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 81347302B836
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 02:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1EB62D9492;
	Tue, 10 Feb 2026 02:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wjij9fwZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4322D2491
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 02:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770690248; cv=none; b=QE3s5+mM2qlJ2/iUCY8OYUqukgUduC1HkxxUf+3ToOI1u6UmnVqRvOFAfdLcTqiGT1qrLgaulRfzJfhGnO5ALSOYlIWXotCRydZmsFjjAJLVXDhpddijJqrwESIaygqNo/Lm/zV6ko1aFbXIF/yp3ZBOJBNCc1K2qWtBBJvj5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770690248; c=relaxed/simple;
	bh=8u0aRpE6P0XGJ7yx9q1WxEzZYfIZkKKSZc0h91/Kd1I=;
	h=Date:From:To:Cc:Subject:Message-ID; b=DgTPOsxC2D5I0WY/y2cbfQXKvY8YFNAdbV7BW5VujQCkemshf+1yXH6jiLhFIWfyXKho4l8884vtc1qVZbmOBRXS9uCQRh1CruPtqMC14ICQgorkQDSYERHff8uz5h7GWgBPBsUzrEj79AzRPK9Vwx8G7dL3rgkEICcJVdL2K8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wjij9fwZ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770690246; x=1802226246;
  h=date:from:to:cc:subject:message-id;
  bh=8u0aRpE6P0XGJ7yx9q1WxEzZYfIZkKKSZc0h91/Kd1I=;
  b=Wjij9fwZdVYYMeDtHcz3851LJLhGVCYvgZNg5PwF2/5UAtmPh/gB3qVX
   K1hNDP1PjwJvExsVZjMCdWoicJy2iGgQ/uwtufdDzM/bUTnDDPYTysjG9
   CHkYajjyJsQ2TP5LbsNo0HC9FZcqbg2Xl6AGOjlyBlRmXxU6LtFKumBKY
   fPl363CW/gcB83DOrLylP23ALu9Lh9HEwjUF7n13/12c9sHMbR/20j1/y
   IVT7lfcAIABu8rMGB6mDpVMGkF162PHQT18q2QvmuNTmMHpKj+sWfPrRs
   K6I27dvKqGbvM7nCKvoVaHk7gNEBL0RJfviVEoscSCodRXU/0DtyCZCRu
   A==;
X-CSE-ConnectionGUID: Sbjyn7JkSiWq+8/6lBUH4Q==
X-CSE-MsgGUID: coynb8X0QVqgE5kkxaPWvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="83183460"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="83183460"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 18:24:06 -0800
X-CSE-ConnectionGUID: wrqey/0USwakfPSGxru9yQ==
X-CSE-MsgGUID: 6dE8JPeqQ6iO3wDalhBRPw==
X-ExtLoop1: 1
Received: from igk-lkp-server01.igk.intel.com (HELO e5404a91d123) ([10.211.93.152])
  by fmviesa003.fm.intel.com with ESMTP; 09 Feb 2026 18:24:03 -0800
Received: from kbuild by e5404a91d123 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpdQ1-000000000Y9-34HG;
	Tue, 10 Feb 2026 02:24:01 +0000
Date: Tue, 10 Feb 2026 03:23:22 +0100
From: kernel test robot <lkp@intel.com>
To: Anup Patel <anup@brainfault.org>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
 Farrah Chen <farrah.chen@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:queue 7/10] lib/kvm_util.c:362:19: error: 'struct
 kvm_vm' has no member named 'pgtable_levels'
Message-ID: <202602100341.7pRzdzX7-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70689-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email]
X-Rspamd-Queue-Id: 87CE611644D
X-Rspamd-Action: no action

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   91ba4fbddd62cf09807a8bf3f29e2e8a0290cfba
commit: 94bef3eab737a77ffa5a26f837e8f3f34dbcc60e [7/10] Merge tag 'kvm-riscv-6.20-1' of https://github.com/kvm-riscv/linux into HEAD
config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260210/202602100341.7pRzdzX7-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602100341.7pRzdzX7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602100341.7pRzdzX7-lkp@intel.com/

Note: the kvm/queue HEAD 91ba4fbddd62cf09807a8bf3f29e2e8a0290cfba builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   lib/kvm_util.c: In function '____vm_create':
>> lib/kvm_util.c:362:19: error: 'struct kvm_vm' has no member named 'pgtable_levels'
     362 |                 vm->pgtable_levels = 5;
         |                   ^~
   lib/kvm_util.c:367:19: error: 'struct kvm_vm' has no member named 'pgtable_levels'
     367 |                 vm->pgtable_levels = 4;
         |                   ^~
   lib/kvm_util.c:372:19: error: 'struct kvm_vm' has no member named 'pgtable_levels'
     372 |                 vm->pgtable_levels = 3;
         |                   ^~
   At top level:
   cc1: note: unrecognized command-line option '-Wno-gnu-variable-sized-type-not-at-end' may have been intended to silence earlier diagnostics

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

