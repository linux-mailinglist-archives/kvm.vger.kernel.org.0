Return-Path: <kvm+bounces-404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DC67DF6FA
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79665281C4E
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 15:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D951D532;
	Thu,  2 Nov 2023 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iHTUqJyi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E5F1CFB3
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 15:48:15 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0A8198;
	Thu,  2 Nov 2023 08:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698940091; x=1730476091;
  h=from:to:cc:subject:date:message-id;
  bh=6kHtkPKqEu3I8WjUy08A0Y89FfSYQOnlWiINqRFlQcA=;
  b=iHTUqJyifHBqOrBalWF2QmnadurwvLPqmn/7/BtE00nlkSuxqkGiwjrn
   bHSh24zSXssKWyUzAmuvTgCVw7CWdwwiuoD0weRXxvD0QmGn4X/FQ1NW+
   1GNWlHE9flsWQfuN0rxZlBuG5+XeZcIpkEe4yuhNXlJq8Jvldg8AcpOrN
   zc6ywx4thV6esx5FKf1fEZUvksTfvuoVwLxqb7rrnM4gtHfD9LCHUzI3A
   dhhy0sPB7K3r+tNKUPLMBb6a4HKAzhiYpBLRoUgGxUwJJYLIdIcVLPGr0
   mTmm6WijT2BiLUi8ilywNuvv0lZLqQpoReoRUZHIpbN6wvfwn3Z7rKU3n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="368088424"
X-IronPort-AV: E=Sophos;i="6.03,271,1694761200"; 
   d="scan'208";a="368088424"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 08:48:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="878295286"
X-IronPort-AV: E=Sophos;i="6.03,271,1694761200"; 
   d="scan'208";a="878295286"
Received: from pasangle-nuc10i7fnh.iind.intel.com ([10.223.107.83])
  by fmsmga002.fm.intel.com with ESMTP; 02 Nov 2023 08:48:09 -0700
From: Parshuram Sangle <parshuram.sangle@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org,
	jaishankar.rajendran@intel.com,
	parshuram.sangle@intel.com
Subject: [PATCH 0/2] KVM: enable halt poll shrink parameter
Date: Thu,  2 Nov 2023 21:16:26 +0530
Message-Id: <20231102154628.2120-1-parshuram.sangle@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

KVM halt polling interval growth and shrink behavior has evolved since its
inception. The current mechanism adjusts the polling interval based on whether
vcpu wakeup was received or not during polling interval using grow and shrink
parameter values. Though grow parameter is logically set to 2 by default,
shrink parameter is kept disabled (set to 0).

Disabled shrink has two issues:
1) Resets polling interval to 0 on every un-successful poll assuming it is
less likely to receive a vcpu wakeup in further shrunk intervals.
2) Even on successful poll, if total block time is greater or equal to current
poll_ns value, polling interval is reset to 0 instead shrinking gradually.

These aspects reduce the chances receiving valid wakeup during polling and
lose potential performance benefits for VM workloads.

Below is the summary of experiments conducted to assess performance and power
impact by enabling the halt_poll_ns_shrink parameter(value set to 2).

Performance Test Summary: (Higher is better)
--------------------------------------------
Platform Details: Chrome Brya platform
CPU - Alder Lake (12th Gen Intel CPU i7-1255U)
Host kernel version - 5.15.127-20371-g710a1611ad33

Android VM workload (Score)   Base      Shrink Enabled (value 2)    Delta
---------------------------------------------------------------------------
GeekBench Multi-core(CPU)     5754      5856                        2%
3D Mark Slingshot(CPU+GPU)    15486     15885                       3%
Stream (handopt)(Memory)      20566     21594                       5%
fio seq-read (Storage)        727       747                         3%
fio seq-write (Storage)       331       343                         3%
fio rand-read (Storage)       690       732                         6%
fio rand-write (Storage)      299       300                         1%

Steam Gaming VM (Avg FPS)     Base      Shrink Enabled (value 2)    Delta
---------------------------------------------------------------------------
Metro Redux (OpenGL)          54.80     59.60                       9%
Dota 2 (Open GL)              48.74     51.40                       5%
Dota 2 (Vulkan)               20.80     21.10                       1%
SpaceShip (Vulkan)            20.40     21.52                       6%

With Shrink enabled, majority of workloads show higher % of successful polling.
Reduced latency of returning control back to VM and avoided overhead of vm_exit
contribute to these performance gains.

Power Impact Assessment Summary: (Lower is better)
--------------------------------------------------
Method : DAQ measurements of CPU and Memory rails

CPU+Memory (Watt)             Base      Shrink Enabled (value 2)    Delta
---------------------------------------------------------------------------
Idle* (Host)                  0.636     0.631                       -0.8%
Video Playback (Host)         2.225     2.210                       -0.7%
Tomb Raider (VM)              17.261    17.175                      -0.5%
SpaceShip Benchmark(VM)       17.079    17.123                       0.3%

*Idle power - Idle system with no application running, Android and Borealis
VMs enabled running no workload. Duration 180 sec.

Power measurements done for Chrome idle scenario and active Gaming VM 
workload show negligible power overhead since additional polling creates
very short duration bursts which are less likely to have gone to a
complete idle CPU state.

NOTE: No tests are conducted on non-x86 platform with this changed config

The default values of grow and shrink parameters get commonly used by
various VM deployments unless specifically tuned for performance. Hence
referring to performance and power measurements results shown above, it is
recommended to have shrink enabled (with value 2) by default so that there
is no need to explicitly set this parameter through kernel cmdline or by
other means.

Parshuram Sangle (2):
  KVM: enable halt polling shrink parameter by default
  KVM: documentation update to halt polling

 Documentation/virt/kvm/halt-polling.rst | 26 +++++++++++++------------
 virt/kvm/kvm_main.c                     |  4 ++--
 2 files changed, 16 insertions(+), 14 deletions(-)


base-commit: 2b3f2325e71f09098723727d665e2e8003d455dc
-- 
2.17.1


