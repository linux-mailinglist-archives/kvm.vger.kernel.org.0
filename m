Return-Path: <kvm+bounces-9042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 533D3859DDA
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 780421C21C8D
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7BE20B24;
	Mon, 19 Feb 2024 08:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KsmeSozB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E87120320
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 08:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708330285; cv=fail; b=D/ELOU897epU2r9zn3ZSd3yD5AoX+vQUCfTOzjzEDQPCdLPfcoP0heG2kcGDpmHq9n7Jp++HW1BtZrhiDk3USTOnx5RhcU4MJ33wBBRd3vOmyB5/QekM2NvibGfiJPI9Ui/9+SrT/oWbDVzeO1m9K3GXIbxQXbaCO/0ybTuLgCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708330285; c=relaxed/simple;
	bh=XpLshysnF6kMeVFvpXfF0B1Bwi4yR358fTa+qO1oAy8=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=RfU0qpafDlE04M4WG0HEEli6tkdr1eHRyw1yVo9ljPOHQ8WC2IER2oW3CDFE0jeyvXUA8foFYnhWjpODr+I/NKlXXRxW7MulQeMlqvfUJazjxX9SRf44wv2RCl/lvzYa/83kMohnwPkCEXMP/F2BBPeN6XRrili5Y8A0jjKyit8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KsmeSozB; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708330283; x=1739866283;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=XpLshysnF6kMeVFvpXfF0B1Bwi4yR358fTa+qO1oAy8=;
  b=KsmeSozBzAtEHOqXsH+e3TZqCiPoSS0QWyBHCuBT+OruAKQR14Dg/gA5
   YkdMagVvPJviI8JJ3QPiqwyVaoAB3tXHwGGCoaCfxSOtVT+trHv+uZheM
   bHhWilWorlDoGpdlxO/BvJJe+9SHXRrTvXuDZq9CJqPTYgHa6uUlpkRr5
   Jly9sF/1Z34BirqjlEiT9zYmpAc+lPJFFYJ+qyDpiNoxhwLVKlXI1oQX6
   SKiZrKXYO8Wao1EIvzeqzuxjIhTO+cIjXMio701WZZX0/7RC2mLI8Dmw9
   LJgquVO2bOi06FFmTSs7AWq8bQpduyONQBzRyOV/WeyDhfEnIcymsuIhs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2270068"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2270068"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 00:11:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="9030426"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Feb 2024 00:11:09 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 19 Feb 2024 00:11:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 19 Feb 2024 00:11:08 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 19 Feb 2024 00:11:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBan62KtJuuDLdFMZVuj+w6oLlCtfL7Vd53Tn2KnXYuDL023shsq1MnFtCGWmTnwgw855NpimTYNNo+hLW5E1EzmXohcnkUy9o9BAAaXCLfFIR5cceANMQTEDeMapXhdEHi4CUM5Ji5DYAfhXqKZH5QIkuLsqYWM7NrhZhKBpeVlOY6eQ4ChNA7e3uEszVHc8kgZwrMtNpxgcsXOwG8nuwa9tZT59/c/bpWF0ouV2vBbpZMxdtZHbwvhXYzqwydWP1qMVxdFmzBjIvqfYEGO6jvxZBPBhGEr8GajBQWV3ZjSPYrKmb6IY57agRkjd/Ta0iq8lZKWrzW8uvVeYV2R4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s11AkGAzYF0ZbSpXzJbQ4/VN2W40FVkLPbCvMG6qTY=;
 b=lxcYHZ5wCd11MgHrkPRWFD3Ru3c/AiTIT7HYdVPEdG0sbBRouefEBKj1dbpWsAHb1qx27ry5HlJilSxxVcxJBprlq2gItjUjAHd3ArRzK6BD+adY8SedfeDZpf5pEVnbYtVkDweHx6nSPg3GLrjDO8OptX7UbgmmVSYU5e3T7P9C65fTWI7msLs80mQW9k5C9njhLmf0hphzTR7de+VlqSWW8bjquvO3df0Nc+umSPQaBop1la6MxamgUauqCi7ApKQ2m1trSfngHtzx0OXZYAmLaeOu5gcyTIM0T08nWju1kjFYDMROLfRNXX+nITCKfPMHfbmqAIpMkoraWMDCrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ0PR11MB4863.namprd11.prod.outlook.com (2603:10b6:a03:2ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 08:11:06 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::a026:574d:dab0:dc8e]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::a026:574d:dab0:dc8e%3]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 08:11:05 +0000
Date: Mon, 19 Feb 2024 16:10:57 +0800
From: kernel test robot <oliver.sang@intel.com>
To: David Woodhouse <dwmw@amazon.co.uk>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <kvm@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [dwmw2:pfncache] [KVM]  cc69506d19:
 WARNING:bad_unlock_balance_detected
Message-ID: <202402191553.bd17cf2a-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2P153CA0039.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::8)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ0PR11MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: b8fca41b-4ece-4ef0-0130-08dc312251e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dD9J0lZb5iTfctpbC+0L6gHk+ZHYBHiCzH4UChuUNRfSD3UTD8YSjBPuIim8mEU1KATA7+g8lj6ydaQeJzY6/whxQGPA/GKREyrlkiUt2qV5yL8sV5uUyu/fb+B0jxbkObGIQa/FzvbpwwKOavIhjj8N0Ln5Jw7Ix2zUvsCRvt68p//8PHKUk9AIc39ig1h18ZOs0u7S43DQb2FhM2FUke5AoGT8UuVV+DAP4d6b9hOjaoUh7eMp2SxRpeZJIOlBwCtKkxupo6dTKvwH9ps7X2tdmrPdx/tGmXQJpXg/HA9pieQfdiqG+hGpp5ZKJTL9OTgSSLSE9tWVZfQnN3Gy+3ZLUlyazkEf3wncxmTPtY+ZOUGcdVK7jfT8BH+aFqXsdWqrTF6OM8Gp9YBkGPGmQ/XSOKOCPfoQbkIsVdgKWgK0EZdMTMkN13EQoQ840HmBTsjDfebv280hoPZwclFq7LhMlHRT0AFXqfCuwP7sKxsqyeJpOeq6XMnpo0dIjWmd2ZzTtRn+HlBVuMtr+6XHMxM//drsLH6fU79bco/HGo9ItL4o0yo1MNLzW2rtYeYh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(366004)(136003)(346002)(230922051799003)(230273577357003)(451199024)(1800799012)(186009)(64100799003)(5660300002)(2906002)(82960400001)(6506007)(83380400001)(478600001)(966005)(6486002)(6512007)(6666004)(26005)(36756003)(107886003)(2616005)(1076003)(8936002)(4326008)(6916009)(8676002)(66556008)(66476007)(86362001)(66946007)(41300700001)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aQhWF0bEMuZl+QCWU8CW6bC+TTSGAoAV6zKG1YaHXFrfF5dEdrhDGcZiN8Vu?=
 =?us-ascii?Q?HhwSdy3hd7Jkcf0P6UgISiX0hELcJtNqRS5lvXOEvnKk2juoOhSEWJR+gRQP?=
 =?us-ascii?Q?X2QIsmKpUuKAuUyMwZfnvyPiCbppBAStF9xbeJU0xNhESQcBcc1V4e+TIjl2?=
 =?us-ascii?Q?R80k0IO1/Iqn+seNysaQsOaqqL3+7ZzMG9HX7zvrbZYKKYXYz+XtvITziZKT?=
 =?us-ascii?Q?mCDzjYh6FGBe9m1aaJbSa0RBFGb1kvH2L+xh93g9eNyJw8cPZcBf2Kq4t+jO?=
 =?us-ascii?Q?xEfvx9ZTQoJiLqJQXlrH/G1SCXNmZU07Uq+FtCMn1wljPXT/gf/dX8Te+irZ?=
 =?us-ascii?Q?4mRefgDenBIy1/Wk7c4sT1c0Q04CfLpqUr6K4/zCLYvWnX5QTvvxEWo+l1Cy?=
 =?us-ascii?Q?ZL/fyt0bA3yvdeNQaSzE72LtOD3xK17TcBtI34/logmoVUNgdSysQ9IE8kUY?=
 =?us-ascii?Q?/bKKsGEviwNvqXWsG+42tP4SJr71bkAb5AlW2d2AEeCzl8i+Su51oZacFukr?=
 =?us-ascii?Q?i4JtL0AvMPcqRrY8zcLTcmwAuA0SsnZ7Syo5d8MSH1+3QgQfWXS9cLbkik8h?=
 =?us-ascii?Q?yccs8/7WsovGqsBSvRXZtl2GJTkGRpRcpIdAcC0Xc44fth5AT6XnnU0dh5qp?=
 =?us-ascii?Q?t+QGb0ywvbh972xnTlF70ipT0FAhmnROgSwY9BOfUEx+dvHUgAFCrzslScok?=
 =?us-ascii?Q?1W3Cl+5GqIEcmjNihxkDgZOvgjXs+WknEucp5lACWqMSHaFvDXBbUm74Zs0c?=
 =?us-ascii?Q?g2tgEgRpgOs/HTWSFQ2hprPjERA6VCFCmTpN9+3+K1pZaJ723e0S2Gcskcxe?=
 =?us-ascii?Q?A3mrAKG1aoyDTYG52JTN1hAxmp7utq8Coz755qkETbPrXbk2XjUatjEGDhlx?=
 =?us-ascii?Q?lvdrDJjRjFAGlvxkJgxBeh63LojABuG2134Fg1XjQU7IKOIk+H+MxTYtpch5?=
 =?us-ascii?Q?LJ6f8qFm2+CyCArrfreR6XpXeD4bFSoGYf6pbpXKTkfdFJeP5bgSxXpMUKCT?=
 =?us-ascii?Q?ArAdAuRbfIeoyy6g3VaA1sXfYuFBKGfFJsz1K00F5GPS6zwb2eHRTO0AVmiX?=
 =?us-ascii?Q?G5IgugBM8CPQ/j6iQmxIyM5WESu1ldaUYYG3HqCD3YnTJQZ3yoLtbW3uKfJE?=
 =?us-ascii?Q?p44Sc5dXlTN1lWugoEkCRz9OwelNgiy+fLK0gEBe5W/Ve23nMPvg+ZVAXUmr?=
 =?us-ascii?Q?UbUtmycW7hRC4t+VBIy8YlXL2Af7/iobNe+VMHXuRIKWXrhBnze3qzbqvuEJ?=
 =?us-ascii?Q?tS6HNC3u8FzNPMbA87jdCqSNmUcL2Chq+gua3JO4K7gMEMHys7pnVYFPcKhZ?=
 =?us-ascii?Q?3mj1braVXVlwzR68Msgug1ZV8BDSfFYU8zW8+Ly4pdIYBAdpYSGgoaqrKHWh?=
 =?us-ascii?Q?YOZYQ+EGfe4Wpt3lUNyDSVd+yzQY3JkJHBuhNsKhi3+3tZRs/SDyoC5JypIz?=
 =?us-ascii?Q?0RP0mH0ZeirY5/Qrms5n7kUMkoJ+kpV+3Qc2G759PSKzEy9rmq+ytzXCfWvq?=
 =?us-ascii?Q?r8I1dhqRWBsfmVTzSuFZTJG/eHa/gctUCfaQjWJ8+g4/Gz2328v2peCih1Cs?=
 =?us-ascii?Q?Wi1da0iX0rrckXKbsyE70svr2GCQOvla7ONFByMT+coz8m63BGcEY5vFEHl+?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8fca41b-4ece-4ef0-0130-08dc312251e8
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 08:11:05.5063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxGhodhWmzWsbIZaabsaYyCrmONIvVki8PpuDZ+0HrwC6h/XMPCD2wyANbLWTDF+2kIjinybYAVcUw/4uQ7YKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4863
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:bad_unlock_balance_detected" on:

commit: cc69506d19ada63803c37c09ff910217004db1e8 ("KVM: pfncache: simplify locking and make more self-contained")
git://git.infradead.org/users/dwmw2/linux pfncache

in testcase: kernel-selftests
version: kernel-selftests-x86_64-60acb023-1_20230329
with following parameters:

	group: kvm



compiler: gcc-12
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480+ (Sapphire Rapids) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202402191553.bd17cf2a-oliver.sang@intel.com


[  124.479929][ T5856] WARNING: bad unlock balance detected!
[  124.487408][ T5856] 6.7.0-rc7-00250-gcc69506d19ad #1 Not tainted
[  124.495550][ T5856] -------------------------------------
[  124.503030][ T5856] kvm_clock_test/5856 is trying to release lock (&gpc->refresh_lock) at:
[ 124.513736][ T5856] __kvm_gpc_activate (arch/x86/kvm/../../../virt/kvm/pfncache.c:384) kvm
[  124.523274][ T5856] but there are no more locks to release!
[  124.531003][ T5856]
[  124.531003][ T5856] other info that might help us debug this:
[  124.542656][ T5856] 2 locks held by kvm_clock_test/5856:
[ 124.550015][ T5856] #0: ff1100406be92470 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4418) kvm
[ 124.562285][ T5856] #1: ffa000003456af10 (&kvm->srcu){.+.+}-{0:0}, at: vcpu_enter_guest+0x19b8/0x3770 kvm
[  124.575935][ T5856]
[  124.575935][ T5856] stack backtrace:
[  124.584919][ T5856] CPU: 207 PID: 5856 Comm: kvm_clock_test Not tainted 6.7.0-rc7-00250-gcc69506d19ad #1
[  124.596895][ T5856] Call Trace:
[  124.601723][ T5856]  <TASK>
[ 124.606141][ T5856] dump_stack_lvl (lib/dump_stack.c:108) 
[ 124.612299][ T5856] __lock_release+0x2eb/0x440 
[ 124.619377][ T5856] ? __kvm_gpc_activate (arch/x86/kvm/../../../virt/kvm/pfncache.c:384) kvm
[ 124.626988][ T5856] ? reacquire_held_locks (kernel/locking/lockdep.c:5405) 
[ 124.634156][ T5856] ? __mutex_unlock_slowpath (arch/x86/include/asm/atomic64_64.h:109 include/linux/atomic/atomic-arch-fallback.h:4308 include/linux/atomic/atomic-long.h:1499 include/linux/atomic/atomic-instrumented.h:4446 kernel/locking/mutex.c:924) 
[ 124.641629][ T5856] ? bit_wait_timeout (kernel/locking/mutex.c:902) 
[ 124.648418][ T5856] ? __kvm_gpc_activate (arch/x86/kvm/../../../virt/kvm/pfncache.c:384) kvm
[ 124.656056][ T5856] lock_release (kernel/locking/lockdep.c:467 kernel/locking/lockdep.c:5776) 
[ 124.662187][ T5856] __mutex_unlock_slowpath (include/linux/instrumented.h:68 include/linux/atomic/atomic-instrumented.h:3160 kernel/locking/mutex.c:916) 
[ 124.669408][ T5856] ? bit_wait_timeout (kernel/locking/mutex.c:902) 
[ 124.676233][ T5856] ? __kvm_gpc_refresh (arch/x86/kvm/../../../virt/kvm/pfncache.c:97 arch/x86/kvm/../../../virt/kvm/pfncache.c:328) kvm
[ 124.683867][ T5856] ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4566) 
[ 124.692378][ T5856] __kvm_gpc_activate (arch/x86/kvm/../../../virt/kvm/pfncache.c:384) kvm
[ 124.699751][ T5856] kvm_set_msr_common (arch/x86/kvm/x86.c:4043 arch/x86/kvm/x86.c:4210) kvm
[ 124.707296][ T5856] ? kvm_write_wall_clock+0x180/0x180 kvm
[ 124.716209][ T5856] ? __lock_release+0x111/0x440 
[ 124.723338][ T5856] ? kvm_msr_allowed (include/linux/srcu.h:122 include/linux/srcu.h:287 arch/x86/kvm/x86.c:1831) kvm
[ 124.730488][ T5856] vmx_set_msr (arch/x86/kvm/vmx/vmx.c:2448) kvm_intel
[ 124.737687][ T5856] __kvm_set_msr (arch/x86/kvm/x86.c:1845) kvm
[ 124.744439][ T5856] ? kvm_msr_allowed (include/linux/srcu.h:122 include/linux/srcu.h:287 arch/x86/kvm/x86.c:1831) kvm
[ 124.751591][ T5856] ? kvm_emulate_monitor (arch/x86/kvm/x86.c:1845) kvm
[ 124.758933][ T5856] ? lock_release (kernel/locking/lockdep.c:467 kernel/locking/lockdep.c:5776) 
[ 124.765024][ T5856] ? kvm_msr_allowed (include/linux/srcu.h:288 arch/x86/kvm/x86.c:1831) kvm
[ 124.772168][ T5856] kvm_emulate_wrmsr (arch/x86/kvm/x86.c:1908 arch/x86/kvm/x86.c:1976 arch/x86/kvm/x86.c:1972 arch/x86/kvm/x86.c:2086) kvm
[ 124.779208][ T5856] vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:6589) kvm_intel
[ 124.786608][ T5856] vcpu_enter_guest+0x1ab2/0x3770 kvm
[ 124.795030][ T5856] ? kvm_check_and_inject_events (arch/x86/kvm/x86.c:10778) kvm
[ 124.803528][ T5856] ? lock_acquire (include/trace/events/lock.h:24 kernel/locking/lockdep.c:5725) 
[ 124.809634][ T5856] ? kvm_arch_vcpu_ioctl_run (include/linux/srcu.h:116 include/linux/srcu.h:215 include/linux/kvm_host.h:927 arch/x86/kvm/x86.c:11395) kvm
[ 124.817682][ T5856] ? lock_sync (kernel/locking/lockdep.c:5722) 
[ 124.823629][ T5856] ? mark_held_locks (kernel/locking/lockdep.c:4274) 
[ 124.829965][ T5856] ? vcpu_run (arch/x86/kvm/x86.c:11258) kvm
[ 124.836441][ T5856] vcpu_run (arch/x86/kvm/x86.c:11258) kvm
[ 124.842720][ T5856] kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:11484) kvm
[ 124.850583][ T5856] ? lock_release (kernel/locking/lockdep.c:467 kernel/locking/lockdep.c:5776) 
[ 124.856744][ T5856] kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4442) kvm
[ 124.863640][ T5856] ? kvm_vcpu_kick (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4397) kvm
[ 124.870633][ T5856] __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:871 fs/ioctl.c:857 fs/ioctl.c:857) 
[ 124.877002][ T5856] do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83) 
[ 124.882981][ T5856] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:129) 
[  124.890633][ T5856] RIP: 0033:0x7f1046845b5b
[ 124.896609][ T5856] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
All code
========
   0:	00 48 89             	add    %cl,-0x77(%rax)
   3:	44 24 18             	rex.R and $0x18,%al
   6:	31 c0                	xor    %eax,%eax
   8:	48 8d 44 24 60       	lea    0x60(%rsp),%rax
   d:	c7 04 24 10 00 00 00 	movl   $0x10,(%rsp)
  14:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  19:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  1e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  23:	b8 10 00 00 00       	mov    $0x10,%eax
  28:	0f 05                	syscall 
  2a:*	89 c2                	mov    %eax,%edx		<-- trapping instruction
  2c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  31:	77 1c                	ja     0x4f
  33:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  38:	64                   	fs
  39:	48                   	rex.W
  3a:	2b                   	.byte 0x2b
  3b:	04 25                	add    $0x25,%al
  3d:	28 00                	sub    %al,(%rax)
	...

Code starting with the faulting instruction
===========================================
   0:	89 c2                	mov    %eax,%edx
   2:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
   7:	77 1c                	ja     0x25
   9:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   e:	64                   	fs
   f:	48                   	rex.W
  10:	2b                   	.byte 0x2b
  11:	04 25                	add    $0x25,%al
  13:	28 00                	sub    %al,(%rax)
	...
[  124.919748][ T5856] RSP: 002b:00007ffed26c1d10 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  124.930292][ T5856] RAX: ffffffffffffffda RBX: 00007f10467456c0 RCX: 00007f1046845b5b
[  124.940347][ T5856] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
[  124.950360][ T5856] RBP: 00000000019c2a70 R08: 00007ffed26c1e40 R09: 0000000000000002
[  124.960375][ T5856] R10: 8c1ed6746cba2bb1 R11: 0000000000000246 R12: 0000000000427220
[  124.970373][ T5856] R13: 0000000000000000 R14: 00000000019c0490 R15: 000000008030ae7c
[  124.980364][ T5856]  </TASK>



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240219/202402191553.bd17cf2a-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


