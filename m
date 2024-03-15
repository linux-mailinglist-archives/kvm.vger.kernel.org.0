Return-Path: <kvm+bounces-11898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92FCC87CA50
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 10:00:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2767B28484A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 09:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C307175A5;
	Fri, 15 Mar 2024 09:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kWmVUjX2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F3917BA6
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710493219; cv=fail; b=eiCAB8eXeWt0Tbp/lyceLsZBISJYn4TlUuDG2UYeU10Oz6Yrx8qdDGL1QAv7VBoMZ6C9DUHUSpwFP6H/aj4JTlerkdkcs3OUNWI5AMGcAecLv4hBgvAWXndoJL8o7gsRoSpqFonbDDOzdSs4dGWeYiaSTXLNzWJ5lXTFFiVAAdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710493219; c=relaxed/simple;
	bh=2lHHWK4I1uovQ2K8WnYkXZDQKcNg166jzViQ/uL+X/8=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=qkhLAzakXPFsPyy4Z+Tzax3N4oiAoqIR3l47XuSnnu4cI6oJcw8WCddIHFUGf4gRk5mcDzBisJuwmay0src0zd74dUAo5VFBZzuVEkYDM5+WWaVzOJTM9V3TcDz9aRmkGxh+JIt5X4bCfGr1UacYe+7hc6GfgYzhrmGxLET2Rb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kWmVUjX2; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710493217; x=1742029217;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=2lHHWK4I1uovQ2K8WnYkXZDQKcNg166jzViQ/uL+X/8=;
  b=kWmVUjX2uVq2mZZJAgnr5u6FIIrwH4RYJS9WD2WitWpqWGhzTovXa0Y/
   baUMTbQceFrN+dpYaJp3sfph1Oaa/Mc76v6jYajYoAslAFDmofF719DVT
   7yceMgaLfRbTTJgcLLaD54ockblseG23HuTkoNsGUP5O6iXTcxtCbScSh
   QyIYGO7c6YhMXijyKUJ1NWE+Sd5Zo6N9aq05pKzfD4w8YGHzwJjuSMfn4
   wLJTeu0iuV5neuYXWH/tBcQQ5GoGWLfepW2z5kxEs0IV35S4886R5Zcb8
   OHLSQW8RTkrY70TLTezD9xmv1D95cyVpx9knPxjnh6G/70wfnOC7n7nng
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="22872057"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="22872057"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 02:00:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="12510261"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Mar 2024 02:00:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Mar 2024 02:00:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 15 Mar 2024 02:00:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 15 Mar 2024 02:00:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHHlU4jYDedBBICEs6Bxrk2xQBoOXGw5V0v5eMYKTwQtOyLC5Pl47UESDOQkoB5Fpr0HlbBbqM0OcJ+UcbK4JEKY0zCiHFqkoXsJeqCsnJ01SCqFiMfwLawQq5TsqtFIIOsLXxvgaDZ6WYRO+HCzlqEMmb2ORZP60oN2Y80iVOcJFJnd+WSbgaQlCBfoDu1lzOpk9UcnaTThHwYFCSqIaCpvyPvx8mLYamhQAaDazOuuM0KoS3xFUqAlcXpJrtPXGCkqo/r9BL4+E2fkbvZ1+kkWZe2WmJpAUL/n+cENRYZQWZzyWwJT63/JBtr2wGnxnDAWS5dEFO89SGLlo8JyhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFqprftVao3hq0R0Nw7HhtMV95LNL7fFu0n45dlw0FI=;
 b=njTZ5NUl1AkJE/4mv9ZnRsemYSwHLUL7Yud1soZpRyMhF+E7Q0ebqG5FvYFi4L9T6QDfNidvccWPBRogCKE7YEskGVp3fNxBm4mcGHVM/zC0TXn8KrXp2iyeQqIrq3l6n/Isqdb+isL3NorAzNhtrr8/+Nw/XQ7leAVGSJ0yhcy9cV0eDQnI506gu4LIfmu1jR4M0LiTOM2rmKwGL9QbDYxBLLn2aIalbfQHpxNUv6nEXYqhZQ2x6cLW+xIhKRsh7uziMWiKjNwaf1zKo/ZqT4m7FA3fk6ngy5IQ60MATXssKjvfNQgQnrpqsuUNjHvRKVhBThuAf5T9leMjS2Spag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by LV8PR11MB8559.namprd11.prod.outlook.com (2603:10b6:408:1e6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.20; Fri, 15 Mar
 2024 09:00:07 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e%3]) with mapi id 15.20.7386.017; Fri, 15 Mar 2024
 09:00:07 +0000
Date: Fri, 15 Mar 2024 16:59:57 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Like Xu
	<like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, Zhenyu Wang
	<zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan
	<zhiyuan.lv@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>, Jim Mattson
	<jmattson@google.com>, <kvm@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [sean-jc:x86/disable_adaptive_pebs] [KVM]  ade86174dc:
 kvm-unit-tests.pmu_pebs.fail
Message-ID: <202403151639.371a9400-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SG2PR03CA0117.apcprd03.prod.outlook.com
 (2603:1096:4:91::21) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|LV8PR11MB8559:EE_
X-MS-Office365-Filtering-Correlation-Id: 97700e82-27ab-425f-6c68-08dc44ce4fa2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tS88gYU2yeHkad6Tjf//gBWhHFULJV2eAH9O5VFPaGPThtayeONFPILf35xzTtUSrkpQsm/FX8v6ZKM05XFX5fFXbeDArgKxw0VgNRLWv9/GbcD0T012aPgtInRO33fgpvK/ru50FZckc0ugsXYl4oytHa5Us3so2zCYU3CTqRsdIN0ajr7wtuqaiV4kHCm1mqfyPv5PuVWhf9aolM9SL132oamsfC9mgqliaOBZF2MImN+ry3v8Nk9CahLFPRk8tuA0lzjDpMuc/0KU/TqoRIgV1cE7CfJAu/n/n4hc4P5H/WC6csls4ZbLMfBW27P3uWTKyXwKIp4iRRv/+KMQFENXmQ1aDsl4BJ2vgwpIIDiIBY3zET9PXo36vywcOLN7/3vJqc07uSlJHUnnWKWdTeEoo8t765O8vD4UiIOKLedEnG+6lR5U+SLk9XQDPtHHGfuPEw/k2qDnAZrJnk2EnUAkSp38qYQXGiQ0/+yhDFelIYOpZYPT9Px4iaNFlNj5JKKvFR2WxXeCKPc4XGiO76qxV/qUb9SgGEGUUwN7thCSNuWApCkne7ElqML53XWx7+B6J5za22mKbrbKGjmRhN1/ZVtEMqtVJ+Uid5AKnMLmBpLpARkmR7aHHA99iMpo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ijgNrw8ivc6d4pNLUqPuxoT1CqVyb5Hqp6VpkYS2KbtsOaMXp3LZr4Jgc9OI?=
 =?us-ascii?Q?8iPdR0bSQxFgr1nkMp111zmod+gudLzYKur8VEonqdugObMNgdz0xO8IJ82N?=
 =?us-ascii?Q?fkw0DyRtFSvHgg9sGy4uS9wHdxXkzpmnbmu4RLe0gqqoP99v2KbPVFPyIWU0?=
 =?us-ascii?Q?F4UzMe57cEo++yUL0XhzzZyvUy3M9fdLY7c8hJRstbTPcY3G1qHb9QV2bEDX?=
 =?us-ascii?Q?HwHOg7s51FsaOGZs/zqJgiYxXmrvm/Imck0G/lTJ4l3pVHQPZC3S4aXtOYPn?=
 =?us-ascii?Q?N61HDO2LsZfmRnKPNOu5b+kx/PVzLcVWv+nbs5+NEthyCXhssgCC4EpLnAQn?=
 =?us-ascii?Q?c+HvmFh/qE7w8yIwoA+8CDZhEGxhlEZnw5qqg/kvV1wJN4jJ6UNUsiiQpN9b?=
 =?us-ascii?Q?PD119HG6WDRI/eUdQ7jWxe+eKv/ggTV3zLHA8WveenMeXRIcl0J6SO0Cpw+Y?=
 =?us-ascii?Q?v6p1kuQzdaRrqlDwmOzea6obtQRj9QSRHJFeTVf9QduEA5wmnas1hXAchVdG?=
 =?us-ascii?Q?FsKuFJ2zKzZFmBKvIRCMM+rYEV8d43WpLL+VrqPl2IhVCh9GwWsDfOfidRLd?=
 =?us-ascii?Q?OfV6UL0Rl8Bqf6CmlJlDr+iDzqMm66+rAGSixbUod1DjJTD4Px9j13P3csvx?=
 =?us-ascii?Q?6rnZm8k6JATMK96hhu8gt79OBZjcyceCfmNUTTgoo9gu5veZRvs2SB8WV8x2?=
 =?us-ascii?Q?e1vWTz7NO+FiURLcFLeg4eIemPfdGOx21kYjEoMTXi9z6O64vRennaT1pxdZ?=
 =?us-ascii?Q?wz+1m7GvuYItUyu61MYwvNjBm1R5Jvd0MqdUs8hBhGWssFuTFgw9E9OzBEZR?=
 =?us-ascii?Q?gnpwzz+274+UU1iKJk5fzimUIkPb8+zxTT3vK2RvRmdX7Sm3ElLa6SdA3OEx?=
 =?us-ascii?Q?RiMnv8DE3Vgjkwe2ZEy0M3ydPC+pwkrBhH8M2qUEcXkYAQF3+XreyAOEB32V?=
 =?us-ascii?Q?MsFvum7fuxNH8KKc4qnpTZNLA2+yEVhM06q1Iv9fzx0BiRWBmQSI347LbgKz?=
 =?us-ascii?Q?whOjE82BoggCUwVj2UzTQ/HAbtOOXDSuHsmLzIBpZOdzK/fvQ8QIa59hxjVt?=
 =?us-ascii?Q?xGguUHGwxCtIhufHiOTVk4VO3rpArEuv//Jcc/Y6fm72eCeJPGRBkkOiT1vi?=
 =?us-ascii?Q?wFhqmpCO8+FMlK/nXPo10+AGHOybVqsSdkZQ8lLre8r/YQ9IqslYFKrfZ9OF?=
 =?us-ascii?Q?nlaPmt0jaWS+ipfS+tSW3I5hXkRQoCSznT+GHvoY2869DQMnXgKqiwc3E/X1?=
 =?us-ascii?Q?fsSwso2aSF9+UwgudmABFVYxY54xeglx0OSpnqIXJaaQUAqapWNNdOUlmXgC?=
 =?us-ascii?Q?M5RomgPR7qlqyNUtt+t9qAyrqLmIyx+qKcm4/gGaEcTk3XTkPdMATe5iCgrd?=
 =?us-ascii?Q?n09S5QLiPLzRzANkAWym48EsgwYvShN4qbNpCT3Okv85MXtL6jYvqWDli4ct?=
 =?us-ascii?Q?n1T6suNJcvZoJUDecoXFF/MaKIRjT1CM2t133+2pnbxYfIv6LoarQYpnvMih?=
 =?us-ascii?Q?Hh5h9pidZUlVymtJGRUj6fkHk+MjW3o4HLtGzJhE6ABNPMDkkymdnbiolkJ5?=
 =?us-ascii?Q?81qO7pzmDs3iPpsWdOgyiE6clrXDGg7FMQuvTmWdHD59crBCkRTV6awEbxTh?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97700e82-27ab-425f-6c68-08dc44ce4fa2
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 09:00:07.2959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdPFvp/GekE+pcT/ooeuFmJB/klKf077WVjVe8BVA9HMyKI3WZtUUZO+BRQAJQGwCiaPgRlHzbuCgJrzZnYMeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8559
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "kvm-unit-tests.pmu_pebs.fail" on:

commit: ade86174dc69254b50a67f836b2b8ac2c5644e11 ("KVM: x86/pmu: Disable su=
pport for adaptive PEBS")
https://github.com/sean-jc/linux x86/disable_adaptive_pebs

in testcase: kvm-unit-tests
version: kvm-unit-tests-x86_64-023002d-1_20230714
with following parameters:




compiler: gcc-12
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480+ (Sapphi=
re Rapids) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202403151639.371a9400-oliver.sang@=
intel.com

QEMU emulator version 5.2.0 (Debian 1:5.2+dfsg-11+deb11u2)
Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
2024-03-14 13:54:36 ./run_tests.sh
=1B[32mPASS=1B[0m apic-split (56 tests)
=1B[32mPASS=1B[0m ioapic-split (19 tests)
=1B[32mPASS=1B[0m x2apic (56 tests)
=1B[32mPASS=1B[0m xapic (45 tests, 1 skipped)
=1B[32mPASS=1B[0m ioapic (26 tests)
=1B[33mSKIP=1B[0m cmpxchg8b (i386 only)
=1B[32mPASS=1B[0m smptest (1 tests)
=1B[32mPASS=1B[0m smptest3 (1 tests)
=1B[32mPASS=1B[0m vmexit_cpuid=20
=1B[32mPASS=1B[0m vmexit_vmcall=20
=1B[32mPASS=1B[0m vmexit_mov_from_cr8=20
=1B[32mPASS=1B[0m vmexit_mov_to_cr8=20
=1B[32mPASS=1B[0m vmexit_inl_pmtimer=20
=1B[32mPASS=1B[0m vmexit_ipi=20
=1B[32mPASS=1B[0m vmexit_ipi_halt=20
=1B[32mPASS=1B[0m vmexit_ple_round_robin=20
=1B[32mPASS=1B[0m vmexit_tscdeadline=20
=1B[32mPASS=1B[0m vmexit_tscdeadline_immed=20
=1B[32mPASS=1B[0m vmexit_cr0_wp=20
=1B[32mPASS=1B[0m vmexit_cr4_pge=20
=1B[32mPASS=1B[0m access (2 tests)
=1B[33mSKIP=1B[0m access_fep (test marked as manual run only)
=1B[32mPASS=1B[0m access-reduced-maxphyaddr (1 tests)
=1B[32mPASS=1B[0m smap (18 tests)
=1B[32mPASS=1B[0m pku (7 tests)
=1B[33mSKIP=1B[0m pks (0 tests)
=1B[33mSKIP=1B[0m asyncpf (0 tests)
=1B[32mPASS=1B[0m emulator (136 tests, 2 skipped)
=1B[32mPASS=1B[0m eventinj (13 tests)
=1B[32mPASS=1B[0m hypercall (2 tests)
=1B[32mPASS=1B[0m idt_test (4 tests)
=1B[32mPASS=1B[0m memory (7 tests, 1 skipped)
=1B[32mPASS=1B[0m msr (1899 tests)
=1B[32mPASS=1B[0m pmu (251 tests, 22 skipped)
=1B[33mSKIP=1B[0m pmu_lbr (1 tests, 1 skipped)
=1B[31mFAIL=1B[0m pmu_pebs                           <---------------------=
--------
=1B[32mPASS=1B[0m vmware_backdoors (11 tests)
=1B[32mPASS=1B[0m realmode=20
=1B[32mPASS=1B[0m s3=20
=1B[32mPASS=1B[0m setjmp (10 tests)
=1B[32mPASS=1B[0m sieve=20
=1B[32mPASS=1B[0m syscall (2 tests)
=1B[32mPASS=1B[0m tsc (6 tests)
=1B[32mPASS=1B[0m tsc_adjust (6 tests)
=1B[32mPASS=1B[0m xsave (17 tests)
=1B[32mPASS=1B[0m rmap_chain=20
=1B[33mSKIP=1B[0m svm (0 tests)
=1B[33mSKIP=1B[0m svm_pause_filter (0 tests)
=1B[33mSKIP=1B[0m svm_npt (0 tests)
=1B[33mSKIP=1B[0m taskswitch (i386 only)
=1B[33mSKIP=1B[0m taskswitch2 (i386 only)
=1B[32mPASS=1B[0m kvmclock_test=20
=1B[32mPASS=1B[0m pcid-enabled (2 tests)
=1B[32mPASS=1B[0m pcid-disabled (2 tests)
=1B[32mPASS=1B[0m pcid-asymmetric (2 tests)
=1B[32mPASS=1B[0m rdpru (1 tests)
=1B[32mPASS=1B[0m umip (21 tests)
=1B[33mSKIP=1B[0m la57 (i386 only)
=1B[31mFAIL=1B[0m vmx (430177 tests, 1 unexpected failures, 2 expected fail=
ures, 5 skipped)
=1B[32mPASS=1B[0m ept (6564 tests)
=1B[32mPASS=1B[0m vmx_eoi_bitmap_ioapic_scan (7 tests)
=1B[32mPASS=1B[0m vmx_hlt_with_rvi_test (7 tests)
=1B[32mPASS=1B[0m vmx_apicv_test (9239 tests)
=1B[32mPASS=1B[0m vmx_apic_passthrough_thread (8 tests)
=1B[32mPASS=1B[0m vmx_init_signal_test (11 tests)
=1B[32mPASS=1B[0m vmx_sipi_signal_test (12 tests)
=1B[32mPASS=1B[0m vmx_apic_passthrough_tpr_threshold_test (6 tests)
=1B[32mPASS=1B[0m vmx_vmcs_shadow_test (142173 tests)
=1B[32mPASS=1B[0m vmx_pf_exception_test (75 tests)
=1B[33mSKIP=1B[0m vmx_pf_exception_test_fep (test marked as manual run only=
)
=1B[33mSKIP=1B[0m vmx_pf_vpid_test (test marked as manual run only)
=1B[33mSKIP=1B[0m vmx_pf_invvpid_test (test marked as manual run only)
=1B[33mSKIP=1B[0m vmx_pf_no_vpid_test (test marked as manual run only)
=1B[32mPASS=1B[0m vmx_pf_exception_test_reduced_maxphyaddr (67 tests)
=1B[32mPASS=1B[0m debug (22 tests)
=1B[32mPASS=1B[0m hyperv_synic (1 tests)
=1B[32mPASS=1B[0m hyperv_connections (7 tests)
=1B[32mPASS=1B[0m hyperv_stimer (12 tests)
=1B[32mPASS=1B[0m hyperv_clock=20
=1B[32mPASS=1B[0m intel_iommu (11 tests)
=1B[32mPASS=1B[0m tsx-ctrl (7 tests)
=1B[33mSKIP=1B[0m intel_cet (0 tests)



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240315/202403151639.371a9400-oliv=
er.sang@intel.com



--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


