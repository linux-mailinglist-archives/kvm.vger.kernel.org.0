Return-Path: <kvm+bounces-53075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A035B0D16C
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C3E17B0B80
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0036328EA5A;
	Tue, 22 Jul 2025 05:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XbgYwlTM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C89228D859;
	Tue, 22 Jul 2025 05:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753163446; cv=fail; b=PuyOksvKjhsdbReBS1jxYfqH/P4DWHSfJ+D8Zt5Dh+2Ii+71QYInXB2teDYLeZxLnW4go2jsQxEH2pHweyULsAwohQPoKJtcVdLU4shbDXsA3ictL+xhMnz7nmASLoXs0lJLJB67EWKrO3Fz8SNMeTN3FRYXVeuJoktzAL6f/+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753163446; c=relaxed/simple;
	bh=SRiTlk7K53UyGsMpYgsnRxOAQib0kcyORYl75LYWqAE=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=LqXhbo4MUz8s5UIEKxdGZSq8OmHx0t/DTjPWQVuG7Jqehw5NiG59PJAtfKyD6E8xqcMrs4VApLS6DiuOjfekS8TQQshOTbgyhFG09kU7bP3L7t2nxC0lyEva2kCuA3mRTvFcIiJPWgLUokUspk+MZJ9yX0TZtG8+xz32J7pH45w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XbgYwlTM; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753163444; x=1784699444;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=SRiTlk7K53UyGsMpYgsnRxOAQib0kcyORYl75LYWqAE=;
  b=XbgYwlTMuLlkovvNLAYVFuij/MaM6CuZ7ySGOGpETxrUUCUOTglmhNWa
   nVE5dh7UAs1WBSH6XezkuGB7HYRySAHDwfqFbTJi43axunUF9Cqd/rhz6
   lfBGZb0qNp8hlk+3dcJXAFxSN+Im8YJXwycvFCoRgbtJmub9KD6SBS8p+
   L6qX3KHV0IawK9G2Z3KmYYa4YMiPPYqaoGCmFoKFo4CcQeUzs4hGzbq9l
   sCZ7qC/RmYKJMoGwHkqMWyDPKHozsZ1MaAvnDu/88AmW6CNzNuj3zrUus
   ATokeqWDIAjl7Kod2a5g1AdIMzL0CAYiGtfe5Y/WOm6Y430k8gdnsz2GP
   Q==;
X-CSE-ConnectionGUID: JD83V9XLQx2DPHvfX9I4iA==
X-CSE-MsgGUID: cjA2X2eJSWiZ6yv99W6z0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="80839604"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="80839604"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:50:44 -0700
X-CSE-ConnectionGUID: ZiNZeCOLSxahVa99Ttl96Q==
X-CSE-MsgGUID: 6GTJsky/Sf2p2WUfzXBeZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="163090965"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:50:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 22:50:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 22:50:43 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.83) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 22:50:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pHYFNVR5hhQowp2VfvztAZviB8G/BXbQ36sshrll81MAoluVbwXdU6CdTt4oLO3Vs6qEvelLFijHY41a8sM8vfblTG69hXrJ4kmwP2CDgU0chBCg1L9fUxASthGncQfc4G+68z5WyW1orij3tHnrJA4xCXPaLUO5CYsFhWxXASR7JwJtaUTJoZk2LtGEbEsucYTqhp4VUme+VzI2YIxWm433fA/1M2odto1FVvcNR/07KoDll29Y1hXFiZ3O0Ye/7OezlTREpPLw/D7lHbpBLXGdR3A8doTbRYlqOT6pePC+33G69A0lkhuyicBImcGgvZxJvHn57I9SFx73Knl4yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=scD8at3w3voXNh/OYIrK4c0qG7iEbVkDEKe6JfzXCqY=;
 b=jxrdnP9S5j6fqJH3ic9K1wgya/Ekvb0hl320gKAKFnAmCPPoabITpjrRRy1QJ88FkB45JJDVU3evhvDN6Z18SGAlWw5j1VAAmaK43CPSfBjTruKfDIf2VenLZl+umM+ruO24lFU6ua7fkd9JC/d2sAXWtGjrachp/obAKVrjMfJcEIzwOR/L7x3yzmUi0PAgrgbJ9U7WQX+S9am5Zv1ZSBEVM5FuBNnprbXGd7akKN8fpDn78byndq7IgWYiN9iHmQphkbOoO6YYbNY25OusHjIJyTpLENyLvIsImqXV/+UoF7/ZJmFYx3weXMJNwuKeooeDrJ1fyBjzvNsyHQEtDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by LV8PR11MB8533.namprd11.prod.outlook.com (2603:10b6:408:1e5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 05:49:55 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 05:49:55 +0000
Date: Tue, 22 Jul 2025 13:49:46 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<xudong.hao@intel.com>, <oliver.sang@intel.com>
Subject: [linus:master] [KVM]  7803339fa9:
 kernel-selftests.kvm.pmu_counters_test.fail
Message-ID: <202507220727.f2cbbd0a-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR02CA0069.apcprd02.prod.outlook.com
 (2603:1096:4:54::33) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|LV8PR11MB8533:EE_
X-MS-Office365-Filtering-Correlation-Id: cc5af91c-064f-42f0-a067-08ddc8e395c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4i4YwKlYu6LQm5vX5TB+/MOOIvQzRTxZaBB/2z4S1Pp4Mc9CTIIyl73zc+Bw?=
 =?us-ascii?Q?l5+VRQdAlFMH28mRGKXlXAeGKSbm449dbjMl8HpSNlhLZ9tLSyUj1wjo3G2G?=
 =?us-ascii?Q?q3FPfoVCbsqc3ct/0uvMQmGI0Qjpp3dc5UirxqzfSz+pc/qhzRAbZbbIszlK?=
 =?us-ascii?Q?dOlahvkuZ5PtTmG5ZdhBwlVz3uwtA4ldX2o1B+TclQmYVTvOzPM+mm1a07fg?=
 =?us-ascii?Q?t3519YXlmbas/FOmkjsXhy2vh6ZO4KtCLUmKkTDlI4fLq9O/i7ajXmUpZqwL?=
 =?us-ascii?Q?2uskuyK4Ef1bJYbNBSq30WB9RzxLvOlkXLfsNo6+uELUnXM8PHKGHHK/mRd8?=
 =?us-ascii?Q?ApmKf6F6nc/MOBe2ECMkB+yX6i3q73pzHcqs5nf5qy7x3whZE7Wvqbcl7NJC?=
 =?us-ascii?Q?RUUEu6Tjbl7J68RkUavKcODj8XTx+geaa5tzSQmlR87dShdv4VJX8NFIQiVD?=
 =?us-ascii?Q?VQKB00n6sJpt8NchtlCwWCHEwC9es/pJDR4EuiWgGQ6erpq89kVC6hNKPfZA?=
 =?us-ascii?Q?BrKIbWDpDNp8htA1UXWHMLR9XJ3S3BEHoI2ItHxYhpynrD9hjx/Fww2r0ftL?=
 =?us-ascii?Q?RPUx//L7FyfqVFF5lmO0eZxbPXyroEKJA90SmkFr4dY70dlSbed347ZSlc7d?=
 =?us-ascii?Q?JnQQwyxNr65yWhVtLZo3+GeztOYbPL4tO21eD4sDZ9fejybsCXFLgDtaSzhZ?=
 =?us-ascii?Q?LdIZ1Jca25hFDrzdBbebVr9olo03Sr25KGMPjZ2xaAjqf3hglAc53sRx05fN?=
 =?us-ascii?Q?VnQWSYlqH5KosTNdDLrx9sN7U5OPt60+x1VGEKKKtIzTLimH3TPdGGgHslcR?=
 =?us-ascii?Q?bv0bDp3LiPrY4R/IGJcdbU1vrkR5JobZ7kq0g9xVKvk4ED/yepD1QHyjaeIi?=
 =?us-ascii?Q?HJcNYz/fd4eAND2orRzRQCLhyZHCn+FzcRPDfQ+mxvd1BgHf0T/vGtpVpr3j?=
 =?us-ascii?Q?5A0nRZd3wnMxzc7z5kTt8OVBUSJfoaDP6opFMibsxwM0lcSTZP/Lyo5U8EXe?=
 =?us-ascii?Q?sH+bcTzP0gzOPK40L4fcqUmYoyK2M0otuNSnAlbpGBtUIUTyBisELnB2FdfA?=
 =?us-ascii?Q?9aFcfRLvNzz+NnOF2syIh+6QzTUl99X8k2elZuUd3m75rCWORQDzLQtZ41UX?=
 =?us-ascii?Q?Jz1PQ7CZFLsTm+xCiVMeD++BWgURqMfKHwRBytK9XoGtrzDlbZOMau1twbVs?=
 =?us-ascii?Q?lfh4JPxzPQFB/kEhMl6hfD/oWdStNuD+kxq8WD8aDrC69/eprM0NUPdJg0aY?=
 =?us-ascii?Q?vB2HHiBGBClMWD98vAPhPcrURyy+e2Rp4gZzVbnHNt+0z9vTGs7fGNY0PzNK?=
 =?us-ascii?Q?huf+K4HWvo/28x+n7kniYr67JW6ERKiQhweMwhaKKn561x724gJ8hVq1M6ts?=
 =?us-ascii?Q?eNrPuBHVAa0Yb4YGJ9fYXNM1Y66B?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tGoR61ONY+lOR56UWjJLKO2weOZSG9gHXlL26ijqIClc32/TAOuyi0rsFHRA?=
 =?us-ascii?Q?lxP5ojYm/NZVkyWmEYOBLFQfwx/dVeG6E6ljiX4u34Tp1qfDaiWm0XcNTA62?=
 =?us-ascii?Q?uOvGxWAYrZz/r9JvozlZxmvpJ3vjA6mysCnxrAevFsFVegaUMg1GPFo2vq7C?=
 =?us-ascii?Q?VcKCVkUXseKJRzp0zDq3lBNbHaNgFxydFGgfV5sBblZFf/y6YnG7Ws9KN+rW?=
 =?us-ascii?Q?ziB+mQnyffmxah/kkXmKy+sBddvjELhZ6ZUQigvd0zKhnyzed7/ADBzMgMu0?=
 =?us-ascii?Q?X8XuDn/aHhm7apbqBRoqn3x8377LRhK0DZu9LoXKToEfL+fcGkxsLpPpL3Xz?=
 =?us-ascii?Q?kggD3rdY0Dy6igA5yI4Ci16mDKjg8vU9r0fdYR+bLEcab3cLxCTEItmhq9ov?=
 =?us-ascii?Q?JywJUXFNv4CKMNKgxApsR0emSNiJNKcPgqx1fvCF2TDIRxJrS2fYfCwLza/V?=
 =?us-ascii?Q?fiQzvQ5n62B3vNyZjvpP9HhjcqBy5OJrmBQRcPmzdIUTXxirgTIaq06MYnAp?=
 =?us-ascii?Q?Q/NPPrji/uKcZkFl52Lt/bztyAoT6TCazgw6YUyUPQTcg3WsPqdHNwEcyo20?=
 =?us-ascii?Q?9Tb6HaIuuVazl13+MHe5YtgN8VluY5bnPepxC+3U8mLe6IbcZU6nGlfSTDli?=
 =?us-ascii?Q?HC8gtnZQCBV8doDBr8DT+asoah5Zfzj7dm6fmNJZ1Mx2yUgOEBl1fNjuqvoj?=
 =?us-ascii?Q?rxTBafR8tH66bjo2r34kHKFWu96kZCduin/qG2cgP+2bNKT6zJuo2gMmvEuF?=
 =?us-ascii?Q?JSugRb02ES4Ac884eKeWLSeSSl7AeP8Vjgnx3Ux7crBMtLj4n0Ei7spdSTx6?=
 =?us-ascii?Q?lTwVxQgkMKPv2IlGApITSG16DOhxrQT3qpG5JTT61I7+hgzXCHPfJiobBqD5?=
 =?us-ascii?Q?8RiiB5okDec5JA+oYhBYumKWBke4RzPq55tI0ZpVkRTc6mt7gkX4USLIB7PR?=
 =?us-ascii?Q?8Gv0ePiNOvg0ckinMWIaY5HjTmH3PjfZVJk6OUJTOVf882U35HTQt9tMjqAf?=
 =?us-ascii?Q?AyvDDkE95OOeiSV3tHLk46cwyhCoVcHoBh+aVYG5bPVXGX2t4MjZH1rUaIke?=
 =?us-ascii?Q?OOxQJKDIJ3UrlFH1FxiGUDI9KSdChlw5kzSgO6oA8TCCM4SbgU0o/x4F1mk2?=
 =?us-ascii?Q?yVwIIrPh4kIwi39g1uHKUDzw1GYob5SpeVn/ESTptFlLBRnJMCLsjbbi5WJL?=
 =?us-ascii?Q?qXEV1+SGzY+xTyEj527GWyTSgSk47pEt/HNltaizoA2KX3V4+smWwR24ZdBT?=
 =?us-ascii?Q?xi6I726G6FXvnl2ZeQR4YgYkJWIg1lXzBYL3bYnbHi7rYSQgyhEuUqiETFNM?=
 =?us-ascii?Q?mKX37gGD6+NKmZjy5N+g/n9eNqfwzYPCTLDIFoBXSWU0eGZI832170CjGVYr?=
 =?us-ascii?Q?RW8qg/EifgHyjvO5m7hmOT3XNVFE5zR0RoITRrbfRrPn/NekSsN15A13tAHW?=
 =?us-ascii?Q?SXZ+ywvy1c3fAJDj/SX6FOPPBx8kFP/lAKdz/zgITcT1KkD+CRu4yaAD5Vry?=
 =?us-ascii?Q?QCw2xtgf92odWiVKN1ooNmkRwFMxMXxJ0ZilckggCpHzCHDW125R7ugeK6Xh?=
 =?us-ascii?Q?K1a+72EnHrMo+Nfc296Tlri/SDTidIwr2kSe8p5mV9l2N/vivC808QapPJ+0?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc5af91c-064f-42f0-a067-08ddc8e395c8
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 05:49:55.3657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kjfykk8Q9Cv2MeWS4Pn2MswpfH2ZG5b6Stn10XQm/RvZSM3DvnNutdPnLUeVm+UDm9cHmAkiSHq7Aa8GoehoOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8533
X-OriginatorOrg: intel.com


Hello,


we reported
"[linux-next:master] [KVM]  7803339fa9: kernel-selftests.kvm.pmu_counters_test.fail"
in
https://lore.kernel.org/all/202501141009.30c629b4-lkp@intel.com/

we noticed there are some discussion there about the issue and fix.

this commit is in mainline now, and we captured the same issue again on a
Ice Lake platform. another thing is we found the issue is random. as below,
2 times failure out of 6 runs for 7803339fa9. for parent, all 9 runs pass.

so we make out this report for this commit again FYI.


=========================================================================================
tbox_group/testcase/rootfs/kconfig/compiler/group:
  lkp-icl-2sp9/kernel-selftests/debian-12-x86_64-20240206.cgz/x86_64-rhel-9.4-kselftests/gcc-12/kvm

bd7791078ac223f5 7803339fa929387bbc66479532a
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :9           22%           2:6     kernel-selftests.kvm.pmu_counters_test.fail



kernel test robot noticed "kernel-selftests.kvm.pmu_counters_test.fail" on:

commit: 7803339fa929387bbc66479532afbaf8cbebb41b ("KVM: selftests: Use data load to trigger LLC references/misses in Intel PMU")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master      6832a9317eee280117cd695fa885b2b7a7a38daf]
[test failed on linux-next/master d086c886ceb9f59dea6c3a9dae7eb89e780a20c9]

in testcase: kernel-selftests
version: kernel-selftests-x86_64-7ff71e6d9239-1_20250215
with following parameters:

	group: kvm



config: x86_64-rhel-9.4-kselftests
compiler: gcc-12
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202507220727.f2cbbd0a-lkp@intel.com


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250722/202507220727.f2cbbd0a-lkp@intel.com


# timeout set to 120
# selftests: kvm: pmu_counters_test
# Random seed: 0x6b8b4567
# Testing arch events, PMU version 0, perf_caps = 0
# Testing GP counters, PMU version 0, perf_caps = 0
# Testing fixed counters, PMU version 0, perf_caps = 0
# Testing arch events, PMU version 0, perf_caps = 2000
# Testing GP counters, PMU version 0, perf_caps = 2000
# Testing fixed counters, PMU version 0, perf_caps = 2000
# Testing arch events, PMU version 1, perf_caps = 0
# Testing GP counters, PMU version 1, perf_caps = 0
# Testing fixed counters, PMU version 1, perf_caps = 0
# Testing arch events, PMU version 1, perf_caps = 2000
# Testing GP counters, PMU version 1, perf_caps = 2000
# Testing fixed counters, PMU version 1, perf_caps = 2000
# Testing arch events, PMU version 2, perf_caps = 0
# ==== Test Assertion Failure ====
#   x86/pmu_counters_test.c:126: count != 0
#   pid=11038 tid=11038 errno=4 - Interrupted system call
#      1        0x0000000000411281: assert_on_unhandled_exception at processor.c:625
#      2        0x00000000004075d4: _vcpu_run at kvm_util.c:1652
#      3         (inlined by) vcpu_run at kvm_util.c:1663
#      4        0x0000000000402c5e: run_vcpu at pmu_counters_test.c:62
#      5        0x0000000000402e4d: test_arch_events at pmu_counters_test.c:315
#      6        0x000000000040283e: test_arch_events at pmu_counters_test.c:599
#      7         (inlined by) test_intel_counters at pmu_counters_test.c:599
#      8         (inlined by) main at pmu_counters_test.c:642
#      9        0x00007fb974a65249: ?? ??:0
#     10        0x00007fb974a65304: ?? ??:0
#     11        0x0000000000402900: _start at ??:?
#   0x0 == 0x0 (count == 0)
not ok 21 selftests: kvm: pmu_counters_test # exit=254


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


