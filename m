Return-Path: <kvm+bounces-12972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B72AD88F8E1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 08:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B9EA296180
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 07:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA176524CB;
	Thu, 28 Mar 2024 07:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L115JNtb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315295103C;
	Thu, 28 Mar 2024 07:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711611403; cv=fail; b=Q/fTPYI1PVAh6QYc2EXY1Tt370alLbdkxNGp3jZ1KHI3z0O2NEr3EITb6qQ+4BUxDpSR4vWklaYISu5mP06ebHjP36EAaP61g6EDnN+uCsICGTNgK+3AKFbA98Dqf5jOiNzDMOR6n0rIFN2GfoI/oLG3R97TVjEvF6UqSU7uTUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711611403; c=relaxed/simple;
	bh=d3DL3asyA33v3bCT0rERzfAG7yMV8uLGRuF49HloT2Q=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=b/IALsLfFUH3NNOijeKdGi+1O/P6idc56DuuVZBmq5NBlrR/wz5UIccWxo1e//YCJgS1NHoa/jS5vhG1KQL79FaTTkPSSBQQ2c68x1GNEJNW8aVQL/E2iOCsJknKnByZ1PX5JFjre880ABJ7JP1VLuL6IK5oX0q60RZ7W/XSyr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L115JNtb; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711611401; x=1743147401;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=d3DL3asyA33v3bCT0rERzfAG7yMV8uLGRuF49HloT2Q=;
  b=L115JNtbn4NOX/pcXbvdp+a/CT79l0FQIuLQ25S+3Q2UqDppwYLRb/Ac
   rSlQeeAcrvfb/Ou+DHGKCJOczSnHK8D5NhJLWiS673UzLhwQBfYPZBK/g
   psiyjURm6dwQTbxbiH2s4KGL4QD4QEc5z+9iBcBRhqSYYyefhv6Fg0HpW
   ZWpXJGUZb9o0LFLaVF1W1m4suSWsTxCPx3buGcmxcCHcL0C4d5OQqKpR+
   BTZCjUJyvSPGSRyKuCrI4TuM8kduCvbPP0QJzWaQv50+hiRF2f/aOZLQx
   NxwdVykEHA5bBQofzcqllHVnuy9+gi6Yp3q82eEaakU2pFxk55vii0n9k
   A==;
X-CSE-ConnectionGUID: AHgHi5ymQ0Cxco29xg3rbA==
X-CSE-MsgGUID: xAlQOgjNRsGA0Gz0dd8FPg==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6611351"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="6611351"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 00:36:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="39683654"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 00:36:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 00:36:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 00:36:40 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 00:36:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUKibiheXU7FwpdLB4Rd+SR78abfwKMdiJCgDAyigyOTxd+Bbsqs21isDhYVjwTvcEsV8PIyhA+0n/d3+ILehAuNp8+AJO0lWCckRUj4bfRgpjvSsoLkPfYoctwqW0gNH12lbDV8SGBgKdXNMMcNTJ0m04U/XonR7FDI9LjutSWqnifsEnNVN9eGY7Xq7IWVYnwnBBIdTpk5X3G43vZ2D6+cSvudI4xKlECGFGLWdW2/qAORmpulq8BBKuLpKqLUjdJ5rOkM5vFSIeA0Hjn6dsDpu/pCrq71b0MqGUPYZWkvIJDsVccnxzDZNFB93bpQPuPkc98xk8BJK0o4rVKWQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0k6gPis7t22ukp06rAKs9Xe8y5Qa5kUsrxGlhCZANw=;
 b=F6qTXTr8E+Y1PFwQfn17UI9iJAEL3SoNniUZT786bqGhKdRUD4hpuEkAJjPOcKW11g8ytQyDYau6452y0HJSNCJez47/+7ABcv6F08WuuO9Un3aYnMMDnYfzx1G2LAjFmj8miNiBRO7RqwkHTme7MnwKwwJJ+zAtpXcFualspiFXUjh1pnDsVDWuAEyVk4i6Io8BSyVP1k4nUAyxrmxq2YXcxg/g+cbSUurju1uiYzG+yufne+dBEygbiODVnhymQpJSrRiXrBsCwxJnVILOudDd4UGMrvhDj73jzZ4dU2XqKml02cTGG+Dd5fHfbRfMd6OpcGC8YEf5wgRx8vFoeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM4PR11MB6288.namprd11.prod.outlook.com (2603:10b6:8:a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 07:36:38 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::58dd:99ca:74a6:2e3e%3]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 07:36:37 +0000
Date: Thu, 28 Mar 2024 15:36:28 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [x86/bugs]  6613d82e61: general_protection_fault:#[##]
Message-ID: <202403281553.79f5a16f-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR06CA0191.apcprd06.prod.outlook.com (2603:1096:4:1::23)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM4PR11MB6288:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c39f09d-cb6b-49fe-c041-08dc4ef9ccec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: enr3wOmcJ2bGpasL564abBSBTMkYxlZJysNPKkC1LLocHTM6fxm8n9C3o+refe0oJAqpAOGsMdxiJZf3orttYrxhqC7SBQ2ThfFqm50N/jB3hOLBYT1ZPhza+940GAFuS44SzDaN9k5PxSjwL9HoPDG9W1Cvf9/jglAaw+hDFXrDaosrNuAA8Inbmnpvl07R9uUEG+FJqhcY9yAHjTqM61HV8Q5IQkAN4nz3mYvgbGmL72Ix9N5n6s1LXYxSt9Uclr2RnR8wUVjOlvJbDQPZxsuju9UmQpKBCE8srQNHT+fhAoz39xJZdgfJ4lq7YVrWsVxAvUbaFheVbq04GtZha99aakaKtJvUsFBJYkjCLkhwRsfj1Y7/LdEt3DJDCsDBE6z/M3BgRKuFm9lArOP4Z/s82K1D4nldpR2tl6g+G5HmcFUMANBTEAbXrx0mwOX2UhsOc/OE5HB0GvJQTbhN0ONppk3S/zNqs1inZbCFLUnXiD5a0xATckHm81oap+iLIJWsscJhPMObCMIginyudMRiF4PDQ5yI5TTIrbWVdw4EJcVAbpBseyZb5z9HcJlXTcp1T3XJnjaauOnQk6lGWKw+6gEBcpRYlbPJTpSPkMFLZmJvJxo/8mjaVjMO01Xo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7siRCbEOmZiZaRzq1CHZg5WiHfytsXQpNnkoL8s792muJQPuJlfaTJHGZRvX?=
 =?us-ascii?Q?yPndZWZhJ27Y78AQ6XZ7wXn5WVUCdFhRCaP2fd62kWhcgNmcQnI2wE+xF6HB?=
 =?us-ascii?Q?aVPoBrzByHi9f9CoP3DLMT6nygrutklCH9Tll518PUK1J5uIrDmjNJ0E/qr5?=
 =?us-ascii?Q?pJQbTMZxJ6dTcP9NpOXMH88RAl8ASFLCoVoZKvz3rHvYt5UeuA3V3ibU5dS0?=
 =?us-ascii?Q?cjIa3vZoCUfScyia/S3aaAvXTNHAysX+oZ0UhDAfRj656K7oZ1p3gVDWRRUE?=
 =?us-ascii?Q?3EJJ8yBOV+bcNEbbVV7WgZ4i6pgkW6yW0pLHi5WIaSnBRELbenUDoOoFQ3ye?=
 =?us-ascii?Q?as9iKvhwcRutR3AGWYrNQXhZyuu3uHgoNZDbPlxCLyfimgxPrlWMyzARujUH?=
 =?us-ascii?Q?McDQHRdQ9BlWdJjybIkkh1nmq70I+Y3xYaGCq0Bp/T1xCu6RQhEni0ntUlpQ?=
 =?us-ascii?Q?jQy5Be+o85IPQc2vbtxQM/PHDLKgU7QNPC0Nlt0Foi56J6oDx4sThcyyfi2F?=
 =?us-ascii?Q?R2ZVGHrqXNK1mInu0EnMlKFhsPWSwqmDAXnQ1dWGOIKxR6MwCbtaHv45pFH2?=
 =?us-ascii?Q?S09vA5tcs/z/sO7gQkSeSR9KpSZq1cdlXKvrCxLt8q28eE3GUM7MRIKUVW0h?=
 =?us-ascii?Q?PnmfX1eXXeZkgrg+nsgfAuLOt7ytOWDY9KU3dmuCAIDwcbPxpV0RfsM36HFK?=
 =?us-ascii?Q?CWMeyfG4zLFVGkIrtl+j2yxP2/thagR4+NsIF61wkZOafSb7W3qNPmlVSK7H?=
 =?us-ascii?Q?vOva3KmNiduF/dBqA9pxHQSoll+Nax5PCAOp2EoPVYDsY28z2tp4EH/jOpuI?=
 =?us-ascii?Q?boWh1+3tR95bB9iaPKdSCXng0WhJGj4V+KN+NTV8suwN4MGuvlZVNp7zwokK?=
 =?us-ascii?Q?5EVbJvIqMTPBoOzDZXdWKQeak38wPcKtlj4/fjyOoeBGF2rqLBavd17ia8iE?=
 =?us-ascii?Q?y6vvNPOSzioEyn3+Kg9beRFL0znXtp6iy7oBd++oCEz0iYFpK0uxgdl+BAJT?=
 =?us-ascii?Q?9DWISuiDeoqxxXUFgeI30kQAlhkZk7hP2wSRMdQ6W3z9/w8KEb2KUH8TM6no?=
 =?us-ascii?Q?F1mT7VRoByDNcDvGz3auXO4+IFwzNCamwWK3/O3l7mk1t8LnPXI1M6x1F1Fw?=
 =?us-ascii?Q?8HAZ7oKUBuFXLEIxFHWt3GhwjtBr+SZIlra0ETigNFxz3/fZhGaP8ZBGYsFh?=
 =?us-ascii?Q?roA8/F+HONCsTja5L61ZqkPHWOUcjIhtzvQxzjy3Mosig83tM0uzVFqQ3PC7?=
 =?us-ascii?Q?pE0Zw7PDHNW954scTJKr32HX84cvOOLKPWz/uqsIxJu/SHiSZDUVib+8cqJX?=
 =?us-ascii?Q?hnpIHJsBxU2n+C/0o1NeUC7pnrxVxtwYnO6qVB2NHfxeNbRGQwRFq2BMxjEP?=
 =?us-ascii?Q?7ueoPr3OYYXfmt9oze8MjP3OALxXjklhHM2PiFJ6I+pD3mirsObogVrIH2zB?=
 =?us-ascii?Q?WEc776Ke382d6vo4HE9wIGnqG/O4/wlPGUcRVsvhJxLy7CTWQiT8hMEsisKu?=
 =?us-ascii?Q?Ojy4jckdhV7UQG+0n3cfzYP6OsEUsHh7CiLtGRGPOBtpALm8tg5bkBuILSAG?=
 =?us-ascii?Q?yr2yBzvMPVxUQdde/oC184SmexXP04/s644tVfKtlp8y9a61LcKPtco37hvk?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c39f09d-cb6b-49fe-c041-08dc4ef9ccec
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 07:36:37.4717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPfBFIEXlw+sHC0VyS1+nrV1JA5a9WqlncIk5ARl9CZECI9KJnKKeAtCZ50C0swUpSR1RwCwjh4kwa8ZP1FEcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6288
X-OriginatorOrg: intel.com



Hello,


we reported a performance issue for this commit in
https://lore.kernel.org/all/202403041300.a7fb1462-yujie.liu@intel.com/

now we noticed a persistent crash issue:

a0e2dab44d22b913 6613d82e617dd7eb8b0c40b2fe3
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :100         99%          100:100   dmesg.EIP:restore_all_switch_stack
           :100         99%          100:100   dmesg.Kernel_panic-not_syncing:Fatal_exception
           :100         99%          100:100   dmesg.general_protection_fault:#[##]


below details FYI.


kernel test robot noticed "general_protection_fault:#[##]" on:

commit: 6613d82e617dd7eb8b0c40b2fe3acea655b1d611 ("x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master 70293240c5ce675a67bfc48f419b093023b862b3]
[test failed on linux-next/master 13ee4a7161b6fd938aef6688ff43b163f6d83e37]

in testcase: trinity
version: 
with following parameters:

	runtime: 600s



compiler: clang-17
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202403281553.79f5a16f-lkp@intel.com


[   25.175767][  T670] VFS: Warning: trinity-c2 using old stat() call. Recompile your binary.
[   25.245597][  T669] general protection fault: 0000 [#1] PREEMPT SMP
[   25.246417][  T669] CPU: 1 PID: 669 Comm: trinity-c1 Not tainted 6.8.0-rc5-00004-g6613d82e617d #1 85a4928d2e6b42899c3861e57e26bdc646c4c5f9
[   25.247743][  T669] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 25.248865][ T669] EIP: restore_all_switch_stack (kbuild/src/consumer/arch/x86/entry/entry_32.S:957) 
[ 25.249510][ T669] Code: 4c 24 10 36 89 48 fc 8b 4c 24 0c 81 e1 ff ff 00 00 36 89 48 f8 8b 4c 24 08 36 89 48 f4 8b 4c 24 04 36 89 48 f0 59 8d 60 f0 58 <0f> 00 2d 00 94 d5 c1 cf 6a 00 68 88 6b d4 c1 eb 00 fc 0f a0 50 b8
All code
========
   0:	4c 24 10             	rex.WR and $0x10,%al
   3:	36 89 48 fc          	ss mov %ecx,-0x4(%rax)
   7:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
   b:	81 e1 ff ff 00 00    	and    $0xffff,%ecx
  11:	36 89 48 f8          	ss mov %ecx,-0x8(%rax)
  15:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  19:	36 89 48 f4          	ss mov %ecx,-0xc(%rax)
  1d:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
  21:	36 89 48 f0          	ss mov %ecx,-0x10(%rax)
  25:	59                   	pop    %rcx
  26:	8d 60 f0             	lea    -0x10(%rax),%esp
  29:	58                   	pop    %rax
  2a:*	0f 00 2d 00 94 d5 c1 	verw   -0x3e2a6c00(%rip)        # 0xffffffffc1d59431		<-- trapping instruction
  31:	cf                   	iret
  32:	6a 00                	push   $0x0
  34:	68 88 6b d4 c1       	push   $0xffffffffc1d46b88
  39:	eb 00                	jmp    0x3b
  3b:	fc                   	cld
  3c:	0f a0                	push   %fs
  3e:	50                   	push   %rax
  3f:	b8                   	.byte 0xb8

Code starting with the faulting instruction
===========================================
   0:	0f 00 2d 00 94 d5 c1 	verw   -0x3e2a6c00(%rip)        # 0xffffffffc1d59407
   7:	cf                   	iret
   8:	6a 00                	push   $0x0
   a:	68 88 6b d4 c1       	push   $0xffffffffc1d46b88
   f:	eb 00                	jmp    0x11
  11:	fc                   	cld
  12:	0f a0                	push   %fs
  14:	50                   	push   %rax
  15:	b8                   	.byte 0xb8
[   25.251494][  T669] EAX: 00000000 EBX: 000001a0 ECX: 000001a1 EDX: 00000000
[   25.252271][  T669] ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: ffa2efdc
[   25.253037][  T669] DS: 0000 ES: 0000 FS: 0000 GS: 0033 SS: 0068 EFLAGS: 00010046
[   25.253892][  T669] CR0: 80050033 CR2: b7dabd6e CR3: 2cc341c0 CR4: 000406b0
[   25.254655][  T669] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   25.255413][  T669] DR6: fffe0ff0 DR7: 00000400
[   25.255952][  T669] Call Trace:
[ 25.256376][ T669] ? __die_body (kbuild/src/consumer/arch/x86/kernel/dumpstack.c:478 kbuild/src/consumer/arch/x86/kernel/dumpstack.c:420) 
[ 25.256907][ T669] ? die_addr (kbuild/src/consumer/arch/x86/kernel/dumpstack.c:?) 
[ 25.257411][ T669] ? exc_general_protection (kbuild/src/consumer/arch/x86/kernel/traps.c:698) 
[ 25.258067][ T669] ? __entry_text_start (??:?) 
[ 25.258691][ T669] ? irqentry_exit_to_user_mode (kbuild/src/consumer/kernel/entry/common.c:228) 


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240328/202403281553.79f5a16f-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


