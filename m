Return-Path: <kvm+bounces-10748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F4686F9C9
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 07:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B6121F211D7
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 06:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C957C13D;
	Mon,  4 Mar 2024 06:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BvmLiitB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24E8BA2D;
	Mon,  4 Mar 2024 05:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709532003; cv=fail; b=C1mpe0YWuoM8UKTrn/CNxOgNLB9W+cfxkLSmTcRHlVJaHfXdw0CKDdnSpewCtgTV4T9A9D8Ss5HEMR9/FWlM+ClqLVz1veSHiZR3NpDfeTsXV7WFuxfHRTeZgygzRrL/nSQBmZZyHeU22NCJV8N03wk2ma7Sb3wZPWhhjYGKqH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709532003; c=relaxed/simple;
	bh=lT9MrCuFWj7m5SRSCPy3e8UodEncawyY5ALiRGTYc6g=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=MvB1nyL6m9VnLeLeu9XWmj+V8I/oHzc9a11iw3KKzb5mulu8ndInPtQsZoS9rPdhMpovjn8TM0lRdIeKq1PlOujTp151JMQ0VrWCvVK57KLQEHlXeTgMTAeXzRCvwsi7K8okeaJlNdOaJubsQm27Gki2flM2UtnLHsU6JAt6jhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BvmLiitB; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709532000; x=1741068000;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=lT9MrCuFWj7m5SRSCPy3e8UodEncawyY5ALiRGTYc6g=;
  b=BvmLiitBN3oi7nbar7fCU01AWsZmIxmDxCjXhVXULj2Xh7BYAjO2UmYd
   4vY8bjFBOP3ojWKMYBqJX0Ef2lQ4DvNBYtbcd6EhRmljEOkXm2Bp3G9yT
   9A2qnFg4NtqyCyQCbxHcFvWGDx5/FqvOOsscPbg1CatZcRz/wnsfl3FtX
   nlt4Np+2qzKgiOLfnqzT1LvlZvNAouPmCuYpN2E9Ne5etH7d0+qcsnY+T
   35cbUFoP1iQFEyiNMTzmW6MkMzo/jDYpaF7MYZxoGB+ebid5L+x5wP9zK
   Mew2coWogqhOsiOcsoMfNWT8W98U965KZ7dXquFBSsDl4nsP+v/W59emq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="14649326"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="14649326"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 21:59:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="13460279"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Mar 2024 21:59:57 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 3 Mar 2024 21:59:57 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 3 Mar 2024 21:59:56 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 3 Mar 2024 21:59:56 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 3 Mar 2024 21:59:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXCaf/W7Ev6Qf3YlQMng3zpuNjJpcasdBOvr+j/zIhMP2OCDiVQgbFBiB/Np4sU8PvWamj3r8wUHFT9qC+9NasYINf11I8b0LMrNQrcWPQjRJ4d1IHo6gFP0k4ziGvsmIJO6yWx8a1/orGqDePMNGc953nJUadqHMrI8G/Z7PgrqdofrmkxN7zlksvB8Ysms6rvElmkUl+xvmT7A3cQAPzZWbJ9q8owsWC1Bb8a1uGB8w+aYk5H/rFFXEtZNqc2ib7HJGqUgbuOWkFL95pXZ7srw6tSiT38yUgXzJOqMDBjLs08+9q+tOYWA9jOpf6kk6L25lkg7jSYAWoTk7hrB7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pk7uxGU0UhjdfSSn9Mn60qOHR/iYMG3wT1sK1giCvnw=;
 b=ek6yeWtoKC1J+W8VO7s6b8FgagdbonuCGS65aRpUFwDsSVGjTD3dn++BjUD75VRg/LxZijfTKBmxJcEzVH7pz2xYBTTmJ3CKPXCkHa+rasB65dbi50MPFUo0qyvXt4EcMtKqrO90TUSIkhkyT2SFlLQitFfA5K/Zo5SaG4ahs8CCgpAlCI1AcpV62ROUnbTR8DFOHLVS/EFytOnHq9jpobC6t2IAQN56Ehjvs8nvfqkLrXyE8yq3W7qjG7bjAZmD1Dwey4Co6DYJJINckfSl+90Uf2S7P7qJgVQP6LgBc2ljCfpGw+fT5NCTNb07zhU717jEPaICryu/taEUm/WHng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by CY5PR11MB6233.namprd11.prod.outlook.com (2603:10b6:930:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.22; Mon, 4 Mar
 2024 05:59:53 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::7118:c3d4:7001:cf9d]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::7118:c3d4:7001:cf9d%5]) with mapi id 15.20.7362.019; Mon, 4 Mar 2024
 05:59:53 +0000
Date: Mon, 4 Mar 2024 13:53:02 +0800
From: kernel test robot <yujie.liu@intel.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>,
	<ying.huang@intel.com>, <feng.tang@intel.com>, <fengwei.yin@intel.com>
Subject: [linus:master] [x86/bugs]  6613d82e61:  stress-ng.mutex.ops_per_sec
 -7.9% regression
Message-ID: <202403041300.a7fb1462-yujie.liu@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|CY5PR11MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bbe1aec-fb3a-4eed-7073-08dc3c104fa8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6XwDdfSfR9VUBoTgZk8s0aWUI3X+CoEBvsR3U12pIxVpncX8jm4xEfzsmy6O5tpjK3UIrZFJnLmIx7kC2aWkZedxyOQ6LazSsTsgTrX15vvc9vzw+Ydet3UMS4jQkaIy0nIU9Eoiv1qwd9yLJeqSX8lm19u1NoxTK+0Y1NyvKWtFa6fIiPxGlhlDRJO7Oj6HJ0FMJZLHuBXxNWDVIXHutDbX1jj7hsVVCXS9L/5PKQ426kki9ARwlobUy1rK9i3T9+qQJIz3r5dHOPcyppuUb7hxbSJqiotGHAwcm5hnLsfKe3xGlgA7FjXG+4uQZnQwC80dd7fqTB8tMjFnvxdWAI3iz6jUgpLlTtW49c7/K8oNqkKS30F3n3uD/HRFiq4oICVpwcKpyjo1FuI3VYTsjz0uh1PXOOojfW02pDc9jyRYKdfiKM4BM/s2T0rSm2QgUvJD75bMLmAJ01U/5PdRPKyOITk1JpQFD7JX6mXjgOhfh5HidigVui2trlEj/L95BpclYsDYJHilyaZrAkKSQ+JGNtSivMQl7NTcbi8Sndil52IYLZHNTLUgezI1QQ7s4iNNXYbT+kgBgkyu7LCQcnwnCnJNHJ1Re+Qd2ccFW5A57NeD207V8ayHAF8qryf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ZxzybVv9OpHgEZbofYY+ZeTI/JkQuxTKG7LJj/nBPBJL/DGSCsbKKHtaf+?=
 =?iso-8859-1?Q?iQTHknNrLFKoheOVS8aR4MARIBWHKVfjo30aqasPi+UDw8rro5Upk7mwi+?=
 =?iso-8859-1?Q?C6WHxA1CEg9z7arv4oB4yUy7JNu2M7L24KwJYmlDJNQ48qdbh3PppozBfP?=
 =?iso-8859-1?Q?wSoLDpXeIPiqKULm/XmlHAqwaywUlbJRn5dGLj737QF3s5LGKxPjUX8Q4p?=
 =?iso-8859-1?Q?Y0sm/9SseXTHlmA1idN/oaIW+qluUQwemYE2gN22xm2WC4EERHlELD6kkN?=
 =?iso-8859-1?Q?M1tuPU9MDRR6eHRHl9D6AilQniX/z9M8qN90lLEDHVI1AkWJiUXeJ26934?=
 =?iso-8859-1?Q?aR00vhlsBpHVkAzErszMo/fvpfVHa5OPqUc64jJIT8j9I5SZu/irCRhCeM?=
 =?iso-8859-1?Q?t8+v6EDyQvOESKCCHmeCtDDhudrVrlc4/8yYy0s97RmUDqxP0EkdokvI0N?=
 =?iso-8859-1?Q?rn+P9clUwhEYIpl2UrZ++B3921OX3pDvkazDsf9j3HaJBYZ9UnqsEdSXlj?=
 =?iso-8859-1?Q?xdKeQVI6y5/wF3IfQA3ZNZ9yY6c7ylYdykD5A7ObTVOkdo7ALmgAdaRrpG?=
 =?iso-8859-1?Q?kM3DPek12fWzYIMe0kSTS6Jt0wdShryzkupO6oE5DVcFOHSkYS7ig2Xt6w?=
 =?iso-8859-1?Q?KtXUDOKCU0n0f5kEvyjDzYjw5VPhGju0eG1a2AjyxRR3lLEMIFZOacUd6p?=
 =?iso-8859-1?Q?M1FGR5yxYQh46+PTJQpF0CqG6eOdKfEypLBppHcev4zDDJw8zjHoaHyzyY?=
 =?iso-8859-1?Q?SFtOVIDJCoAzNtePmDDW4yt6cOwafvBLDlHV1gv+ZurGQQoGXNwNO7acO/?=
 =?iso-8859-1?Q?hTOsAhXYv7gj/pL98XdFKg7kOwXtQmbTEzeq9F5hLw4y8HBfBjdJtnXuQQ?=
 =?iso-8859-1?Q?xHL5TFlcHAq1vyg6dVVAuP90ANcV4ytDjgeVoZBO36NndnqbmcxiHseCis?=
 =?iso-8859-1?Q?th+pN3CJRczecx6/hwTVwCQRw3PwVmwP2cq26axs+m8hOXDs/uL8FwRlM6?=
 =?iso-8859-1?Q?RsMQhXweSXogcPlqR8c9tj/LmYoGJMUq6Kr5clV7sIRjekifRdzHBDAz7o?=
 =?iso-8859-1?Q?BKKNJmJBCIrxTVo5xG1uBG77CvAQnfkS1Ra9ni1Zujf62zD9RNIHwwezfS?=
 =?iso-8859-1?Q?VXWJPMYxBKxpv/g68BYDN++3hJbubiSrtYpmbfqM+LjsAiMhBQQQ0HgF5G?=
 =?iso-8859-1?Q?jTCKTlZV+wzUegoUWKP2ckZltyNXZQjgivnEZVC8eQ08p/g+iE3KJNVgzI?=
 =?iso-8859-1?Q?cEmN6+6QiiwImlxxqyMZJolh96VgIe3u0K/eJG5h0kp+Dr5Lt+WVVGnzh2?=
 =?iso-8859-1?Q?XxmKAfIPRNdn5SATMA5p+QUoRY/SEju/nVdFVIypdU6qfpri/RyWcZ6POm?=
 =?iso-8859-1?Q?vrBMQZfUlHc7ERRcZPNnIXB95FlFQF2m3pDeubQKqsHoHVECJTldPwpM7x?=
 =?iso-8859-1?Q?s8yVLYBTp0SMlDJKFzrgexanHqsEOpIfC2/ktnEukG7fV21avJTXhimGHP?=
 =?iso-8859-1?Q?/r/t6uSoddKIhwy7hweGsc1GWEQNxa+fDj48KgjpaL3NvJV77zksSGuxA6?=
 =?iso-8859-1?Q?lRx6v4vpk636o0JtGuBS+XTYy+LIS6KVONSLE4j+OnktgPMcG+w+MQTg4s?=
 =?iso-8859-1?Q?xpnPgxyJI3zefJ9cZT84bhFawtnsqQIYbd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bbe1aec-fb3a-4eed-7073-08dc3c104fa8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 05:59:53.8142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pekhXcRRfe9IukE4aZquxQgWlk+3fHaEjrP6mygev4ODwCxu3sgukyOUT/WUJAOiPEoAWKFk3cbkIOkel12giw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6233
X-OriginatorOrg: intel.com

Hello,

kernel test robot noticed a -7.9% regression of stress-ng.mutex.ops_per_sec on:

commit: 6613d82e617dd7eb8b0c40b2fe3acea655b1d611 ("x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: stress-ng
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: mutex
	cpufreq_governor: performance


In addition to that, the commit also has impact on the following tests:

+------------------+-------------------------------------------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.ptrace.ops_per_sec -3.9% regression                                  |
| test machine     | 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory |
| test parameters  | cpufreq_governor=performance                                                              |
|                  | nr_threads=100%                                                                           |
|                  | test=ptrace                                                                               |
|                  | testtime=60s                                                                              |
+------------------+-------------------------------------------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.getdent.ops_per_sec 5.8% improvement                                 |
| test machine     | 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory |
| test parameters  | cpufreq_governor=performance                                                              |
|                  | disk=1HDD                                                                                 |
|                  | fs=btrfs                                                                                  |
|                  | nr_threads=100%                                                                           |
|                  | test=getdent                                                                              |
|                  | testtime=60s                                                                              |
+------------------+-------------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_thread_ops 4.0% improvement                              |
| test machine     | 104 threads 2 sockets (Skylake) with 192G memory                                          |
| test parameters  | cpufreq_governor=performance                                                              |
|                  | mode=thread                                                                               |
|                  | nr_task=100%                                                                              |
|                  | test=futex4                                                                               |
+------------------+-------------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops -2.1% regression                             |
| test machine     | 104 threads 2 sockets (Skylake) with 192G memory                                          |
| test parameters  | cpufreq_governor=performance                                                              |
|                  | mode=process                                                                              |
|                  | nr_task=100%                                                                              |
|                  | test=futex2                                                                               |
+------------------+-------------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops 3.7% improvement                             |
| test machine     | 104 threads 2 sockets (Skylake) with 192G memory                                          |
| test parameters  | cpufreq_governor=performance                                                              |
|                  | mode=process                                                                              |
|                  | nr_task=100%                                                                              |
|                  | test=futex3                                                                               |
+------------------+-------------------------------------------------------------------------------------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202403041300.a7fb1462-yujie.liu@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240304/202403041300.a7fb1462-yujie.liu@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-12/performance/x86_64-rhel-8.3/100%/debian-12-x86_64-20240206.cgz/lkp-icl-2sp7/mutex/stress-ng/60s

commit: 
  a0e2dab44d ("x86/entry_32: Add VERW just before userspace transition")
  6613d82e61 ("x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key")

a0e2dab44d22b913 6613d82e617dd7eb8b0c40b2fe3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     11556 ± 15%     -24.2%       8755 ± 10%  numa-meminfo.node0.Active
     11529 ± 15%     -24.5%       8702 ± 10%  numa-meminfo.node0.Active(anon)
    417861            -8.0%     384591        vmstat.system.cs
    287897            -5.2%     273070        vmstat.system.in
    182670            +9.0%     199032        stress-ng.mutex.nanosecs_per_mutex
  18139421            -7.9%   16702171        stress-ng.mutex.ops
    302318            -7.9%     278364        stress-ng.mutex.ops_per_sec
  12040142            -7.3%   11161921        stress-ng.time.involuntary_context_switches
   9424624            -7.6%    8707796        stress-ng.time.voluntary_context_switches
      1.36            -5.7%       1.28        perf-stat.i.MPKI
      0.31            -0.0        0.30        perf-stat.i.branch-miss-rate%
  11445088            -4.4%   10944702        perf-stat.i.branch-misses
  21081580            -6.7%   19679133        perf-stat.i.cache-misses
  57754062            -6.7%   53909365        perf-stat.i.cache-references
    429726            -7.6%     397018        perf-stat.i.context-switches
    120047            -7.3%     111272        perf-stat.i.cpu-migrations
      9063            +7.3%       9727        perf-stat.i.cycles-between-cache-misses
      8.62            -7.5%       7.97        perf-stat.i.metric.K/sec
      1.35            -5.9%       1.27        perf-stat.overall.MPKI
      0.31            -0.0        0.30        perf-stat.overall.branch-miss-rate%
      8893            +7.0%       9514        perf-stat.overall.cycles-between-cache-misses
  11240262            -4.4%   10751121        perf-stat.ps.branch-misses
  20680093            -6.7%   19302166        perf-stat.ps.cache-misses
  56715466            -6.7%   52937829        perf-stat.ps.cache-references
    422630            -7.6%     390583        perf-stat.ps.context-switches
    118070            -7.3%     109477        perf-stat.ps.cpu-migrations
     10.01            -0.5        9.54        perf-profile.calltrace.cycles-pp.find_lock_lowest_rq.push_rt_task.push_rt_tasks.finish_task_switch.__schedule
     20.36            -0.3       20.04        perf-profile.calltrace.cycles-pp.push_rt_task.push_rt_tasks.finish_task_switch.__schedule.schedule
     21.10            -0.3       20.84        perf-profile.calltrace.cycles-pp.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
     21.08            -0.3       20.83        perf-profile.calltrace.cycles-pp.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
     21.86            -0.3       21.60        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     21.85            -0.2       21.60        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     17.30            -0.2       17.07        perf-profile.calltrace.cycles-pp.__futex_wait.futex_wait.do_futex.__x64_sys_futex.do_syscall_64
     17.32            -0.2       17.09        perf-profile.calltrace.cycles-pp.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
     17.15            -0.2       16.93        perf-profile.calltrace.cycles-pp.futex_wait_queue.__futex_wait.futex_wait.do_futex.__x64_sys_futex
     17.11            -0.2       16.88        perf-profile.calltrace.cycles-pp.schedule.futex_wait_queue.__futex_wait.futex_wait.do_futex
     17.10            -0.2       16.88        perf-profile.calltrace.cycles-pp.__schedule.schedule.futex_wait_queue.__futex_wait.futex_wait
      4.16            -0.2        3.98        perf-profile.calltrace.cycles-pp.__sched_yield
      3.72            -0.2        3.54        perf-profile.calltrace.cycles-pp.__schedule.schedule.__x64_sys_sched_yield.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.73            -0.2        3.55        perf-profile.calltrace.cycles-pp.schedule.__x64_sys_sched_yield.do_syscall_64.entry_SYSCALL_64_after_hwframe.__sched_yield
      4.10            -0.2        3.92        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__sched_yield
      4.09            -0.2        3.91        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__sched_yield
      3.99            -0.2        3.81        perf-profile.calltrace.cycles-pp.__x64_sys_sched_yield.do_syscall_64.entry_SYSCALL_64_after_hwframe.__sched_yield
     15.61            -0.1       15.46        perf-profile.calltrace.cycles-pp.finish_task_switch.__schedule.schedule.futex_wait_queue.__futex_wait
      2.64            -0.1        2.50        perf-profile.calltrace.cycles-pp.push_rt_tasks.finish_task_switch.__schedule.schedule.__x64_sys_sched_yield
     14.86            -0.1       14.72        perf-profile.calltrace.cycles-pp.push_rt_tasks.finish_task_switch.__schedule.schedule.futex_wait_queue
      2.95            -0.1        2.81        perf-profile.calltrace.cycles-pp.finish_task_switch.__schedule.schedule.__x64_sys_sched_yield.do_syscall_64
      0.92 ±  3%      -0.1        0.82 ±  2%  perf-profile.calltrace.cycles-pp.cpupri_set.enqueue_task_rt.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler
      0.72 ±  4%      -0.1        0.65 ±  2%  perf-profile.calltrace.cycles-pp.cpupri_set.dequeue_rt_stack.dequeue_task_rt.__sched_setscheduler._sched_setscheduler
      0.74 ±  4%      -0.1        0.66 ±  2%  perf-profile.calltrace.cycles-pp.dequeue_rt_stack.dequeue_task_rt.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler
      1.07            -0.0        1.04        perf-profile.calltrace.cycles-pp.task_rq_lock.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler.__x64_sys_sched_setscheduler
      3.76            -0.0        3.73        perf-profile.calltrace.cycles-pp.futex_wake.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.01            -0.0        0.98        perf-profile.calltrace.cycles-pp._raw_spin_lock.task_rq_lock.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler
      0.59            +0.0        0.62        perf-profile.calltrace.cycles-pp.rt_mutex_adjust_pi.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler.__x64_sys_sched_setscheduler
      0.68            +0.0        0.71        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.__schedule.schedule_idle.do_idle
      0.69            +0.0        0.72        perf-profile.calltrace.cycles-pp._raw_spin_lock.__schedule.schedule_idle.do_idle.cpu_startup_entry
      5.78            +0.1        5.84        perf-profile.calltrace.cycles-pp.sysvec_call_function_single.asm_sysvec_call_function_single.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler
      5.86            +0.1        5.92        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function_single.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler.__x64_sys_sched_setscheduler
      5.78            +0.1        5.84        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function_single.sysvec_call_function_single.asm_sysvec_call_function_single.__sched_setscheduler
      5.78            +0.1        5.84        perf-profile.calltrace.cycles-pp.__sysvec_call_function_single.sysvec_call_function_single.asm_sysvec_call_function_single.__sched_setscheduler._sched_setscheduler
      6.87            +0.1        6.94        perf-profile.calltrace.cycles-pp.sched_ttwu_pending.__flush_smp_call_function_queue.__sysvec_call_function_single.sysvec_call_function_single.asm_sysvec_call_function_single
      2.26            +0.1        2.34        perf-profile.calltrace.cycles-pp._raw_spin_lock.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler.__x64_sys_sched_setscheduler
      2.26            +0.1        2.33        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler
      8.53            +0.1        8.61        perf-profile.calltrace.cycles-pp.secondary_startup_64_no_verify
      5.44            +0.1        5.52        perf-profile.calltrace.cycles-pp.activate_task.ttwu_do_activate.sched_ttwu_pending.__flush_smp_call_function_queue.__sysvec_call_function_single
      8.45            +0.1        8.58        perf-profile.calltrace.cycles-pp.enqueue_task_rt.activate_task.ttwu_do_activate.sched_ttwu_pending.__flush_smp_call_function_queue
      8.26            +0.1        8.39        perf-profile.calltrace.cycles-pp._raw_spin_lock.enqueue_task_rt.activate_task.ttwu_do_activate.sched_ttwu_pending
     10.00            +0.2       10.16        perf-profile.calltrace.cycles-pp.activate_task.push_rt_task.push_rt_tasks.finish_task_switch.__schedule
     10.11            +0.2       10.27        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.enqueue_task_rt.activate_task.ttwu_do_activate
      9.69            +0.2        9.86        perf-profile.calltrace.cycles-pp.enqueue_task_rt.activate_task.push_rt_task.push_rt_tasks.finish_task_switch
      9.30            +0.2        9.48        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.enqueue_task_rt.activate_task.push_rt_task
      9.38            +0.2        9.56        perf-profile.calltrace.cycles-pp._raw_spin_lock.enqueue_task_rt.activate_task.push_rt_task.push_rt_tasks
     47.73            +0.4       48.08        perf-profile.calltrace.cycles-pp.enqueue_task_rt.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler.__x64_sys_sched_setscheduler
     64.42            +0.4       64.78        perf-profile.calltrace.cycles-pp.__sched_setscheduler
     64.32            +0.4       64.68        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__sched_setscheduler
     64.31            +0.4       64.68        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__sched_setscheduler
     59.94            +0.4       60.35        perf-profile.calltrace.cycles-pp.__x64_sys_sched_setscheduler.do_syscall_64.entry_SYSCALL_64_after_hwframe.__sched_setscheduler
     59.94            +0.4       60.35        perf-profile.calltrace.cycles-pp.do_sched_setscheduler.__x64_sys_sched_setscheduler.do_syscall_64.entry_SYSCALL_64_after_hwframe.__sched_setscheduler
     59.64            +0.4       60.05        perf-profile.calltrace.cycles-pp.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler.__x64_sys_sched_setscheduler.do_syscall_64
     59.82            +0.4       60.24        perf-profile.calltrace.cycles-pp._sched_setscheduler.do_sched_setscheduler.__x64_sys_sched_setscheduler.do_syscall_64.entry_SYSCALL_64_after_hwframe
     46.02            +0.4       46.45        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.enqueue_task_rt.__sched_setscheduler._sched_setscheduler
     46.37            +0.4       46.82        perf-profile.calltrace.cycles-pp._raw_spin_lock.enqueue_task_rt.__sched_setscheduler._sched_setscheduler.do_sched_setscheduler
     11.13            -0.5       10.60        perf-profile.children.cycles-pp.find_lock_lowest_rq
     25.80            -0.4       25.37        perf-profile.children.cycles-pp.schedule
     27.01            -0.4       26.60        perf-profile.children.cycles-pp.__schedule
     22.66            -0.4       22.28        perf-profile.children.cycles-pp.push_rt_task
     22.81            -0.3       22.48        perf-profile.children.cycles-pp.finish_task_switch
     21.45            -0.3       21.13        perf-profile.children.cycles-pp.push_rt_tasks
     21.10            -0.3       20.84        perf-profile.children.cycles-pp.__x64_sys_futex
     21.08            -0.3       20.83        perf-profile.children.cycles-pp.do_futex
     17.30            -0.2       17.07        perf-profile.children.cycles-pp.__futex_wait
      2.20 ±  3%      -0.2        1.97 ±  2%  perf-profile.children.cycles-pp.cpupri_set
     17.32            -0.2       17.09        perf-profile.children.cycles-pp.futex_wait
     17.15            -0.2       16.93        perf-profile.children.cycles-pp.futex_wait_queue
      4.18            -0.2        3.99        perf-profile.children.cycles-pp.__sched_yield
      3.99            -0.2        3.81        perf-profile.children.cycles-pp.__x64_sys_sched_yield
      0.94 ±  4%      -0.1        0.85 ±  2%  perf-profile.children.cycles-pp.dequeue_rt_stack
      0.50 ±  5%      -0.1        0.43 ±  3%  perf-profile.children.cycles-pp.find_lowest_rq
      0.46 ±  5%      -0.1        0.40 ±  4%  perf-profile.children.cycles-pp.cpupri_find_fitness
      0.82            -0.0        0.78        perf-profile.children.cycles-pp.task_woken_rt
      0.32 ±  2%      -0.0        0.28 ±  3%  perf-profile.children.cycles-pp.pull_rt_task
      0.31 ±  2%      -0.0        0.28 ±  2%  perf-profile.children.cycles-pp.pick_next_task_rt
      0.58            -0.0        0.55        perf-profile.children.cycles-pp.enqueue_pushable_task
      3.76            -0.0        3.73        perf-profile.children.cycles-pp.futex_wake
      0.11 ±  4%      -0.0        0.10 ±  3%  perf-profile.children.cycles-pp.balance_rt
      0.43            -0.0        0.41        perf-profile.children.cycles-pp.rto_push_irq_work_func
      0.14 ±  2%      -0.0        0.13        perf-profile.children.cycles-pp.select_task_rq
      0.13 ±  2%      -0.0        0.12        perf-profile.children.cycles-pp.select_task_rq_rt
      0.07            -0.0        0.06        perf-profile.children.cycles-pp.update_rt_rq_load_avg
      0.26            +0.0        0.27        perf-profile.children.cycles-pp.irq_exit_rcu
      0.59            +0.0        0.62        perf-profile.children.cycles-pp.rt_mutex_adjust_pi
      0.49 ±  2%      +0.0        0.53        perf-profile.children.cycles-pp.scheduler_tick
      1.14            +0.0        1.18        perf-profile.children.cycles-pp.update_curr_rt
      0.58            +0.0        0.63        perf-profile.children.cycles-pp.tick_nohz_highres_handler
      0.58            +0.0        0.62        perf-profile.children.cycles-pp.update_process_times
      0.62            +0.0        0.68        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.60            +0.1        0.65        perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.58            +0.1        0.63        perf-profile.children.cycles-pp.tick_sched_handle
      0.62            +0.1        0.68        perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.87            +0.1        0.93        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.94            +0.1        1.00        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      8.53            +0.1        8.61        perf-profile.children.cycles-pp.cpu_startup_entry
      8.53            +0.1        8.61        perf-profile.children.cycles-pp.secondary_startup_64_no_verify
      8.53            +0.1        8.61        perf-profile.children.cycles-pp.do_idle
     14.31            +0.1       14.44        perf-profile.children.cycles-pp.sched_ttwu_pending
     13.62            +0.1       13.76        perf-profile.children.cycles-pp.ttwu_do_activate
     23.84            +0.3       24.19        perf-profile.children.cycles-pp.activate_task
     59.94            +0.4       60.36        perf-profile.children.cycles-pp.__x64_sys_sched_setscheduler
     59.94            +0.4       60.35        perf-profile.children.cycles-pp.do_sched_setscheduler
     59.82            +0.4       60.24        perf-profile.children.cycles-pp._sched_setscheduler
     88.70            +0.5       89.18        perf-profile.children.cycles-pp._raw_spin_lock
     87.93            +0.5       88.41        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     71.06            +0.7       71.77        perf-profile.children.cycles-pp.enqueue_task_rt
    124.24            +0.8      125.02        perf-profile.children.cycles-pp.__sched_setscheduler
      2.19 ±  3%      -0.2        1.96 ±  2%  perf-profile.self.cycles-pp.cpupri_set
      0.31 ±  6%      -0.0        0.27 ±  3%  perf-profile.self.cycles-pp.cpupri_find_fitness
      0.30 ±  3%      -0.0        0.27 ±  4%  perf-profile.self.cycles-pp.pull_rt_task
      0.26 ±  3%      -0.0        0.23 ±  3%  perf-profile.self.cycles-pp.pick_next_task_rt
      0.54            -0.0        0.52        perf-profile.self.cycles-pp.enqueue_pushable_task
      0.15            -0.0        0.14        perf-profile.self.cycles-pp.switch_mm_irqs_off
      0.65            +0.0        0.67        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      1.00            +0.0        1.04        perf-profile.self.cycles-pp.update_curr_rt
     87.92            +0.5       88.40        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath


***************************************************************************************************
lkp-icl-2sp7: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-12/performance/x86_64-rhel-8.3/100%/debian-12-x86_64-20240206.cgz/lkp-icl-2sp7/ptrace/stress-ng/60s

commit: 
  a0e2dab44d ("x86/entry_32: Add VERW just before userspace transition")
  6613d82e61 ("x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key")

a0e2dab44d22b913 6613d82e617dd7eb8b0c40b2fe3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   1476651            -3.9%    1418563        vmstat.system.cs
  46602054            -3.9%   44765510        stress-ng.ptrace.ops
    776688            -3.9%     746080        stress-ng.ptrace.ops_per_sec
  93178718            -3.9%   89501356        stress-ng.time.voluntary_context_switches
     41454 ± 26%     -69.0%      12835 ± 93%  proc-vmstat.numa_pages_migrated
    363994 ±  3%      -5.7%     343290 ±  3%  proc-vmstat.pgfree
     41454 ± 26%     -69.0%      12835 ± 93%  proc-vmstat.pgmigrate_success
     36755 ± 34%     -41.9%      21353 ± 30%  proc-vmstat.pgreuse
      0.70            +0.1        0.75 ±  2%  perf-stat.i.branch-miss-rate%
  44257013 ±  2%      +7.7%   47672895 ±  3%  perf-stat.i.branch-misses
   1534064            -4.0%    1472825        perf-stat.i.context-switches
     24.03            -4.0%      23.08        perf-stat.i.metric.K/sec
      0.68 ±  2%      +0.1        0.73 ±  2%  perf-stat.overall.branch-miss-rate%
  43429354 ±  2%      +7.7%   46789221 ±  2%  perf-stat.ps.branch-misses
   1506894            -3.9%    1447769        perf-stat.ps.context-switches
     45.76            -0.5       45.22        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.cgroup_enter_frozen.ptrace_stop.ptrace_do_notify
     45.99            -0.5       45.46        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.cgroup_enter_frozen.ptrace_stop.ptrace_do_notify.ptrace_notify
     23.04            -0.3       22.74        perf-profile.calltrace.cycles-pp.cgroup_enter_frozen.ptrace_stop.ptrace_do_notify.ptrace_notify.syscall_trace_enter
     23.04            -0.3       22.78        perf-profile.calltrace.cycles-pp.cgroup_enter_frozen.ptrace_stop.ptrace_do_notify.ptrace_notify.syscall_exit_to_user_mode_prepare
      7.91            -0.0        7.88        perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.getgid
      0.61            +0.0        0.64        perf-profile.calltrace.cycles-pp.__schedule.schedule.do_wait.kernel_wait4.__do_sys_wait4
      0.63            +0.0        0.66        perf-profile.calltrace.cycles-pp.schedule.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      1.80            +0.1        1.85        perf-profile.calltrace.cycles-pp.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.89            +0.1        1.94        perf-profile.calltrace.cycles-pp.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe.wait4
      1.92            +0.1        1.98        perf-profile.calltrace.cycles-pp.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe.wait4
      2.12            +0.1        2.19        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.wait4
      2.13            +0.1        2.20        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.wait4
      2.34            +0.1        2.42        perf-profile.calltrace.cycles-pp.wait4
      1.24            +0.1        1.34 ±  3%  perf-profile.calltrace.cycles-pp.__x64_sys_ptrace.do_syscall_64.entry_SYSCALL_64_after_hwframe.ptrace
      1.27            +0.1        1.36 ±  3%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.ptrace
      1.26            +0.1        1.36 ±  3%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.ptrace
      1.34            +0.1        1.44 ±  2%  perf-profile.calltrace.cycles-pp.ptrace
     22.52            +0.3       22.84        perf-profile.calltrace.cycles-pp.cgroup_leave_frozen.ptrace_stop.ptrace_do_notify.ptrace_notify.syscall_trace_enter
     44.96            +0.4       45.33        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.cgroup_leave_frozen.ptrace_stop.ptrace_do_notify
     45.31            +0.4       45.72        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.cgroup_leave_frozen.ptrace_stop.ptrace_do_notify.ptrace_notify
     46.10            -0.5       45.55        perf-profile.children.cycles-pp.cgroup_enter_frozen
     90.76            -0.2       90.57        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.25            +0.0        0.27        perf-profile.children.cycles-pp.switch_mm_irqs_off
      0.16 ±  2%      +0.0        0.17 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.60            +0.0        0.63 ±  2%  perf-profile.children.cycles-pp.ttwu_do_activate
      1.80            +0.1        1.85        perf-profile.children.cycles-pp.do_wait
      1.89            +0.1        1.95        perf-profile.children.cycles-pp.kernel_wait4
      1.92            +0.1        1.98        perf-profile.children.cycles-pp.__do_sys_wait4
      2.36            +0.1        2.44        perf-profile.children.cycles-pp.wait4
      1.47            +0.1        1.56        perf-profile.children.cycles-pp.__schedule
      1.50            +0.1        1.58        perf-profile.children.cycles-pp.schedule
      1.24            +0.1        1.34 ±  3%  perf-profile.children.cycles-pp.__x64_sys_ptrace
      1.36            +0.1        1.46 ±  2%  perf-profile.children.cycles-pp.ptrace
     45.42            +0.4       45.82        perf-profile.children.cycles-pp.cgroup_leave_frozen
     90.76            -0.2       90.57        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.38            -0.0        0.37        perf-profile.self.cycles-pp.ptrace_stop
      0.93            +0.1        1.02        perf-profile.self.cycles-pp._raw_spin_lock_irq



***************************************************************************************************
lkp-icl-2sp8: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
=========================================================================================
compiler/cpufreq_governor/disk/fs/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-12/performance/1HDD/btrfs/x86_64-rhel-8.3/100%/debian-12-x86_64-20240206.cgz/lkp-icl-2sp8/getdent/stress-ng/60s

commit: 
  a0e2dab44d ("x86/entry_32: Add VERW just before userspace transition")
  6613d82e61 ("x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key")

a0e2dab44d22b913 6613d82e617dd7eb8b0c40b2fe3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    317900 ±  4%     +51.9%     482822 ±  4%  cpuidle..usage
      3.05            +3.6%       3.15        iostat.cpu.user
      2.49 ±  4%      -0.1        2.38 ±  4%  mpstat.cpu.all.idle%
     15342 ±  3%     +56.1%      23954 ±  3%  vmstat.system.cs
    178479            +2.4%     182761        vmstat.system.in
      9197 ±  2%     +47.8%      13598 ±  3%  sched_debug.cpu.nr_switches.avg
     23944 ±  6%     +58.8%      38014 ±  6%  sched_debug.cpu.nr_switches.max
      5660 ± 12%     +72.0%       9736 ±  4%  sched_debug.cpu.nr_switches.stddev
  58917432 ±  4%     -40.0%   35337032        numa-numastat.node0.local_node
  58973202 ±  4%     -40.0%   35382357        numa-numastat.node0.numa_hit
  37066235           +76.6%   65448120        numa-numastat.node1.local_node
  37099580           +76.5%   65478720        numa-numastat.node1.numa_hit
    269394 ±  4%     -71.3%      77312 ± 28%  numa-meminfo.node0.KReclaimable
    269394 ±  4%     -71.3%      77312 ± 28%  numa-meminfo.node0.SReclaimable
    387028 ±  2%     -51.5%     187589 ± 12%  numa-meminfo.node0.Slab
     93129 ± 12%    +194.7%     274479 ±  8%  numa-meminfo.node1.KReclaimable
     93129 ± 12%    +194.7%     274479 ±  8%  numa-meminfo.node1.SReclaimable
    155845 ±  5%    +120.5%     343568 ±  7%  numa-meminfo.node1.Slab
     67916 ±  3%     -71.2%      19547 ± 28%  numa-vmstat.node0.nr_slab_reclaimable
  59072793 ±  4%     -40.0%   35463515        numa-vmstat.node0.numa_hit
  59017023 ±  4%     -40.0%   35418189        numa-vmstat.node0.numa_local
     23698 ± 13%    +192.1%      69229 ±  9%  numa-vmstat.node1.nr_slab_reclaimable
  37209604           +76.6%   65720661        numa-vmstat.node1.numa_hit
  37176256           +76.7%   65690060        numa-vmstat.node1.numa_local
      9705            -9.2%       8816        stress-ng.getdent.nanosecs_per_getdents_call
  1.17e+08            +5.8%  1.238e+08        stress-ng.getdent.ops
   1949907            +5.8%    2063349        stress-ng.getdent.ops_per_sec
     97203 ±  6%     +12.9%     109764        stress-ng.time.involuntary_context_switches
  85913623            +5.8%   90920658        stress-ng.time.minor_page_faults
     82.78 ±  2%      +6.7%      88.32        stress-ng.time.user_time
    372113 ±  7%     +74.4%     649143 ±  3%  stress-ng.time.voluntary_context_switches
     90376            -1.7%      88797        proc-vmstat.nr_slab_reclaimable
     19745 ± 31%     -26.3%      14551 ±  2%  proc-vmstat.numa_hint_faults
     11950 ± 41%     -36.7%       7560 ±  7%  proc-vmstat.numa_hint_faults_local
  96087443 ±  3%      +5.2%  1.011e+08        proc-vmstat.numa_hit
  95998301 ±  3%      +5.2%   1.01e+08        proc-vmstat.numa_local
 1.012e+08 ±  3%      +4.7%  1.059e+08        proc-vmstat.pgalloc_normal
  86033810            +5.9%   91111926        proc-vmstat.pgfault
 1.009e+08 ±  3%      +4.7%  1.057e+08        proc-vmstat.pgfree
     14992 ±  6%      -8.3%      13744        proc-vmstat.pgreuse
      3.29            -4.1%       3.15        perf-stat.i.MPKI
 1.031e+10            +5.0%  1.082e+10        perf-stat.i.branch-instructions
  77903770            +5.3%   82008784        perf-stat.i.branch-misses
     45.24            -2.3       42.98        perf-stat.i.cache-miss-rate%
 3.596e+08 ±  2%      +6.5%   3.83e+08        perf-stat.i.cache-references
     15896 ±  3%     +56.8%      24926 ±  3%  perf-stat.i.context-switches
      4.51            -5.2%       4.27        perf-stat.i.cpi
    339.16 ±  8%     +30.7%     443.20 ±  4%  perf-stat.i.cpu-migrations
 4.991e+10            +5.0%  5.243e+10        perf-stat.i.instructions
      0.24            +5.0%       0.25        perf-stat.i.ipc
     44.19            +5.9%      46.82        perf-stat.i.metric.K/sec
   1411214            +5.9%    1494386        perf-stat.i.minor-faults
   1411214            +5.9%    1494386        perf-stat.i.page-faults
      3.30            -3.7%       3.17        perf-stat.overall.MPKI
     45.68            -2.3       43.40        perf-stat.overall.cache-miss-rate%
      4.49            -4.6%       4.28        perf-stat.overall.cpi
      0.22            +4.8%       0.23        perf-stat.overall.ipc
 1.014e+10            +4.9%  1.063e+10        perf-stat.ps.branch-instructions
  76113957            +5.3%   80174083        perf-stat.ps.branch-misses
 3.541e+08 ±  2%      +6.3%  3.765e+08        perf-stat.ps.cache-references
     15523 ±  3%     +56.4%      24284 ±  3%  perf-stat.ps.context-switches
    331.55 ±  9%     +30.6%     433.03 ±  4%  perf-stat.ps.cpu-migrations
 4.907e+10            +4.9%  5.149e+10        perf-stat.ps.instructions
   1388739            +5.8%    1468698        perf-stat.ps.minor-faults
   1388739            +5.8%    1468698        perf-stat.ps.page-faults
 3.005e+12            +4.2%  3.133e+12        perf-stat.total.instructions
     59.17            -2.9       56.25        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     59.24            -2.9       56.31        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.syscall
     59.68            -2.9       56.79        perf-profile.calltrace.cycles-pp.syscall
     29.18            -1.5       27.70        perf-profile.calltrace.cycles-pp.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     28.64            -1.5       27.16        perf-profile.calltrace.cycles-pp.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     29.82            -1.5       28.37        perf-profile.calltrace.cycles-pp.__x64_sys_getdents.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     29.03            -1.4       27.58        perf-profile.calltrace.cycles-pp.iterate_dir.__x64_sys_getdents.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
      9.19 ±  3%      -1.1        8.13 ±  2%  perf-profile.calltrace.cycles-pp.proc_readdir_de.proc_tgid_net_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64
      9.24 ±  3%      -1.1        8.19 ±  2%  perf-profile.calltrace.cycles-pp.proc_tgid_net_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.17 ±  3%      -1.0        8.12 ±  2%  perf-profile.calltrace.cycles-pp.proc_readdir_de.proc_tgid_net_readdir.iterate_dir.__x64_sys_getdents.do_syscall_64
      9.25 ±  3%      -1.0        8.21 ±  2%  perf-profile.calltrace.cycles-pp.proc_tgid_net_readdir.iterate_dir.__x64_sys_getdents.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.51 ±  4%      -0.6        4.89 ±  2%  perf-profile.calltrace.cycles-pp.proc_readdir_de.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.49 ±  3%      -0.6        4.88 ±  2%  perf-profile.calltrace.cycles-pp.proc_readdir_de.iterate_dir.__x64_sys_getdents.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.22 ±  4%      -0.5        3.72 ±  2%  perf-profile.calltrace.cycles-pp._raw_read_lock.proc_readdir_de.proc_tgid_net_readdir.iterate_dir.__x64_sys_getdents64
      4.20 ±  4%      -0.5        3.71 ±  2%  perf-profile.calltrace.cycles-pp._raw_read_lock.proc_readdir_de.proc_tgid_net_readdir.iterate_dir.__x64_sys_getdents
      2.78 ±  4%      -0.3        2.47 ±  2%  perf-profile.calltrace.cycles-pp._raw_read_lock.proc_readdir_de.iterate_dir.__x64_sys_getdents64.do_syscall_64
      2.77 ±  3%      -0.3        2.47 ±  2%  perf-profile.calltrace.cycles-pp._raw_read_lock.proc_readdir_de.iterate_dir.__x64_sys_getdents.do_syscall_64
      0.90 ±  4%      -0.1        0.80 ±  2%  perf-profile.calltrace.cycles-pp._raw_read_lock.proc_lookup_de.proc_tgid_net_lookup.lookup_open.open_last_lookups
      0.56 ±  2%      +0.0        0.58        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.62 ±  2%      +0.0        0.64        perf-profile.calltrace.cycles-pp.vma_alloc_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.56            +0.0        0.59 ±  2%  perf-profile.calltrace.cycles-pp.d_alloc_parallel.lookup_open.open_last_lookups.path_openat.do_filp_open
      0.76 ±  3%      +0.1        0.81        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.new_inode.proc_get_inode.proc_lookup_de
      0.65 ±  3%      +0.1        0.71 ±  5%  perf-profile.calltrace.cycles-pp.apparmor_file_free_security.security_file_free.__fput.__x64_sys_close.do_syscall_64
      0.66 ±  3%      +0.1        0.72 ±  5%  perf-profile.calltrace.cycles-pp.security_file_free.__fput.__x64_sys_close.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.01 ±  2%      +0.1        1.08        perf-profile.calltrace.cycles-pp._raw_spin_lock.new_inode.proc_get_inode.proc_lookup_de.proc_tgid_net_lookup
      1.35            +0.1        1.43        perf-profile.calltrace.cycles-pp.new_inode.proc_get_inode.proc_lookup_de.proc_tgid_net_lookup.lookup_open
      1.40            +0.1        1.49        perf-profile.calltrace.cycles-pp.proc_get_inode.proc_lookup_de.proc_tgid_net_lookup.lookup_open.open_last_lookups
      0.73            +0.1        0.82        perf-profile.calltrace.cycles-pp.may_open.do_open.path_openat.do_filp_open.do_sys_openat2
      0.67            +0.1        0.75        perf-profile.calltrace.cycles-pp.inode_permission.may_open.do_open.path_openat.do_filp_open
      1.91 ±  3%      +0.1        2.03 ±  2%  perf-profile.calltrace.cycles-pp.evict.__dentry_kill.dput.__fput.__x64_sys_close
      0.81 ±  3%      +0.1        0.94 ±  4%  perf-profile.calltrace.cycles-pp.apparmor_file_alloc_security.security_file_alloc.init_file.alloc_empty_file.path_openat
      1.10 ±  3%      +0.1        1.23 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock.evict.__dentry_kill.dput.__fput
      1.13 ±  3%      +0.1        1.26 ±  3%  perf-profile.calltrace.cycles-pp.init_file.alloc_empty_file.path_openat.do_filp_open.do_sys_openat2
      0.85 ±  3%      +0.1        0.98 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.evict.__dentry_kill.dput
      0.89 ±  3%      +0.1        1.04 ±  3%  perf-profile.calltrace.cycles-pp.security_file_alloc.init_file.alloc_empty_file.path_openat.do_filp_open
      1.47 ±  3%      +0.1        1.61 ±  3%  perf-profile.calltrace.cycles-pp.alloc_empty_file.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
      0.66            +0.2        0.86 ± 22%  perf-profile.calltrace.cycles-pp.__legitimize_path.try_to_unlazy.link_path_walk.path_openat.do_filp_open
      0.67            +0.2        0.87 ± 22%  perf-profile.calltrace.cycles-pp.try_to_unlazy.link_path_walk.path_openat.do_filp_open.do_sys_openat2
      0.88 ±  8%      +0.2        1.10 ±  5%  perf-profile.calltrace.cycles-pp.up_read.kernfs_dop_revalidate.lookup_fast.walk_component.link_path_walk
      1.49            +0.2        1.73 ±  7%  perf-profile.calltrace.cycles-pp.lookup_fast.open_last_lookups.path_openat.do_filp_open.do_sys_openat2
      1.30 ±  5%      +0.3        1.56 ±  5%  perf-profile.calltrace.cycles-pp.apparmor_file_open.security_file_open.do_dentry_open.do_open.path_openat
      1.31 ±  4%      +0.3        1.57 ±  5%  perf-profile.calltrace.cycles-pp.security_file_open.do_dentry_open.do_open.path_openat.do_filp_open
      2.39 ±  3%      +0.3        2.65 ±  4%  perf-profile.calltrace.cycles-pp.do_dentry_open.do_open.path_openat.do_filp_open.do_sys_openat2
      1.49 ±  2%      +0.3        1.76 ±  5%  perf-profile.calltrace.cycles-pp.up_read.kernfs_iop_permission.inode_permission.link_path_walk.path_openat
      1.53 ±  5%      +0.3        1.81 ±  2%  perf-profile.calltrace.cycles-pp.down_read.kernfs_iop_permission.inode_permission.link_path_walk.path_openat
      1.09 ± 10%      +0.3        1.40 ±  2%  perf-profile.calltrace.cycles-pp.up_read.kernfs_fop_readdir.iterate_dir.__x64_sys_getdents.do_syscall_64
      1.08 ± 11%      +0.3        1.40 ±  2%  perf-profile.calltrace.cycles-pp.up_read.kernfs_fop_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64
      1.22 ±  9%      +0.3        1.56 ±  4%  perf-profile.calltrace.cycles-pp.down_read.kernfs_dop_revalidate.lookup_fast.walk_component.link_path_walk
      1.09 ±  2%      +0.3        1.44 ± 24%  perf-profile.calltrace.cycles-pp.dput.terminate_walk.path_openat.do_filp_open.do_sys_openat2
      1.13 ±  2%      +0.4        1.48 ± 23%  perf-profile.calltrace.cycles-pp.terminate_walk.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
      1.43 ±  9%      +0.4        1.81        perf-profile.calltrace.cycles-pp.down_read.kernfs_fop_readdir.iterate_dir.__x64_sys_getdents.do_syscall_64
      1.41 ±  9%      +0.4        1.81 ±  2%  perf-profile.calltrace.cycles-pp.down_read.kernfs_fop_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64
      0.17 ±141%      +0.4        0.58 ±  2%  perf-profile.calltrace.cycles-pp.kernfs_dop_revalidate.lookup_fast.open_last_lookups.path_openat.do_filp_open
      3.51 ±  2%      +0.4        3.93 ±  3%  perf-profile.calltrace.cycles-pp.do_open.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
      0.17 ±141%      +0.5        0.70 ± 28%  perf-profile.calltrace.cycles-pp.lockref_get_not_dead.__legitimize_path.try_to_unlazy.link_path_walk.path_openat
      0.00            +0.6        0.56        perf-profile.calltrace.cycles-pp.kernfs_iop_permission.inode_permission.may_open.do_open.path_openat
      2.14 ±  8%      +0.6        2.71 ±  4%  perf-profile.calltrace.cycles-pp.kernfs_dop_revalidate.lookup_fast.walk_component.link_path_walk.path_openat
      3.14 ±  3%      +0.6        3.71 ±  4%  perf-profile.calltrace.cycles-pp.kernfs_iop_permission.inode_permission.link_path_walk.path_openat.do_filp_open
      4.18 ±  2%      +0.6        4.77 ±  3%  perf-profile.calltrace.cycles-pp.inode_permission.link_path_walk.path_openat.do_filp_open.do_sys_openat2
      4.89 ±  4%      +0.6        5.50 ±  2%  perf-profile.calltrace.cycles-pp.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2
      3.29 ±  5%      +0.6        3.93 ±  3%  perf-profile.calltrace.cycles-pp.lookup_fast.walk_component.link_path_walk.path_openat.do_filp_open
      3.23 ±  7%      +0.7        3.96        perf-profile.calltrace.cycles-pp.kernfs_fop_readdir.iterate_dir.__x64_sys_getdents.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.22 ±  8%      +0.7        3.96 ±  2%  perf-profile.calltrace.cycles-pp.kernfs_fop_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe
     10.92 ±  2%      +1.4       12.34 ±  2%  perf-profile.calltrace.cycles-pp.link_path_walk.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
     24.85            +2.5       27.32        perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64
     24.92            +2.5       27.39        perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     26.02            +2.5       28.52        perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.open64
     26.05            +2.5       28.55        perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.open64
     26.11            +2.5       28.61        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.open64
     26.13            +2.5       28.63        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.open64
     26.32            +2.5       28.83        perf-profile.calltrace.cycles-pp.open64
     29.41 ±  3%      -3.3       26.07 ±  2%  perf-profile.children.cycles-pp.proc_readdir_de
     57.69            -2.9       54.77        perf-profile.children.cycles-pp.iterate_dir
     59.85            -2.9       56.97        perf-profile.children.cycles-pp.syscall
     18.49 ±  3%      -2.1       16.39 ±  2%  perf-profile.children.cycles-pp.proc_tgid_net_readdir
     15.47 ±  4%      -1.8       13.70 ±  2%  perf-profile.children.cycles-pp._raw_read_lock
     29.19            -1.5       27.70        perf-profile.children.cycles-pp.__x64_sys_getdents64
     29.83            -1.4       28.38        perf-profile.children.cycles-pp.__x64_sys_getdents
     94.11            -0.3       93.85        perf-profile.children.cycles-pp.do_syscall_64
     94.19            -0.3       93.94        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.89 ±  2%      -0.0        0.86 ±  3%  perf-profile.children.cycles-pp.proc_readfd_common
      0.08 ±  6%      -0.0        0.05        perf-profile.children.cycles-pp.main
      0.08 ±  6%      -0.0        0.05        perf-profile.children.cycles-pp.run_builtin
      0.07 ± 11%      -0.0        0.05        perf-profile.children.cycles-pp.__cmd_record
      0.07 ± 11%      -0.0        0.05        perf-profile.children.cycles-pp.cmd_record
      0.12 ±  4%      -0.0        0.10 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock_irq
      0.10            +0.0        0.11        perf-profile.children.cycles-pp.atime_needs_update
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.nd_jump_root
      0.09            +0.0        0.10        perf-profile.children.cycles-pp.__init_rwsem
      0.17            +0.0        0.18        perf-profile.children.cycles-pp.generic_permission
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.proc_pid_readdir
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.process_measurement
      0.12            +0.0        0.13        perf-profile.children.cycles-pp.uncharge_batch
      0.18            +0.0        0.19        perf-profile.children.cycles-pp.vsnprintf
      0.22 ±  2%      +0.0        0.24        perf-profile.children.cycles-pp.native_irq_return_iret
      0.19 ±  2%      +0.0        0.21 ±  2%  perf-profile.children.cycles-pp.stress_getdents_dir
      0.17            +0.0        0.18 ±  2%  perf-profile.children.cycles-pp.memchr
      0.08            +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.path_init
      0.08 ±  5%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.locks_remove_posix
      0.24            +0.0        0.25        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.38            +0.0        0.40        perf-profile.children.cycles-pp.getname_flags
      0.10            +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.page_counter_uncharge
      0.14 ±  3%      +0.0        0.16        perf-profile.children.cycles-pp.__mem_cgroup_uncharge_list
      0.10            +0.0        0.12        perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.19 ±  2%      +0.0        0.21 ±  2%  perf-profile.children.cycles-pp.inode_init_always
      0.20 ±  2%      +0.0        0.22 ±  2%  perf-profile.children.cycles-pp.mod_objcg_state
      0.33            +0.0        0.35        perf-profile.children.cycles-pp.__cond_resched
      0.18 ±  4%      +0.0        0.20 ±  2%  perf-profile.children.cycles-pp.strlcat
      0.56            +0.0        0.58        perf-profile.children.cycles-pp.alloc_inode
      0.52            +0.0        0.55 ±  2%  perf-profile.children.cycles-pp.d_alloc
      0.66            +0.0        0.69        perf-profile.children.cycles-pp.__slab_free
      0.12            +0.0        0.15 ± 18%  perf-profile.children.cycles-pp.try_to_unlazy_next
      0.31            +0.0        0.34        perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.70            +0.0        0.74        perf-profile.children.cycles-pp.d_alloc_parallel
      0.77            +0.0        0.81        perf-profile.children.cycles-pp.filldir64
      0.77            +0.0        0.82 ±  2%  perf-profile.children.cycles-pp.filldir
      0.11 ±  4%      +0.1        0.17 ±  7%  perf-profile.children.cycles-pp.security_current_getsecid_subj
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.cpu_startup_entry
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.do_idle
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.secondary_startup_64_no_verify
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.start_secondary
      0.10 ±  4%      +0.1        0.16 ±  7%  perf-profile.children.cycles-pp.apparmor_current_getsecid_subj
      1.04            +0.1        1.09        perf-profile.children.cycles-pp.rcu_do_batch
      1.04            +0.1        1.10        perf-profile.children.cycles-pp.rcu_core
      1.05            +0.1        1.11        perf-profile.children.cycles-pp.__do_softirq
      0.65 ±  4%      +0.1        0.71 ±  4%  perf-profile.children.cycles-pp.apparmor_file_free_security
      0.66 ±  3%      +0.1        0.72 ±  4%  perf-profile.children.cycles-pp.security_file_free
      0.19 ±  4%      +0.1        0.25 ±  6%  perf-profile.children.cycles-pp.ima_file_check
      1.19            +0.1        1.27        perf-profile.children.cycles-pp.kmem_cache_free
      0.43 ± 13%      +0.1        0.51 ±  5%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.44 ± 13%      +0.1        0.52 ±  5%  perf-profile.children.cycles-pp.kthread
      0.44 ± 13%      +0.1        0.52 ±  5%  perf-profile.children.cycles-pp.ret_from_fork
      0.44 ± 13%      +0.1        0.52 ±  5%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.42 ± 15%      +0.1        0.51 ±  5%  perf-profile.children.cycles-pp.run_ksoftirqd
      0.74            +0.1        0.83        perf-profile.children.cycles-pp.may_open
      1.92 ±  3%      +0.1        2.04 ±  2%  perf-profile.children.cycles-pp.evict
      1.14 ±  3%      +0.1        1.27 ±  3%  perf-profile.children.cycles-pp.init_file
      0.81 ±  3%      +0.1        0.95 ±  4%  perf-profile.children.cycles-pp.apparmor_file_alloc_security
      0.90 ±  2%      +0.1        1.04 ±  3%  perf-profile.children.cycles-pp.security_file_alloc
      1.47 ±  3%      +0.1        1.61 ±  3%  perf-profile.children.cycles-pp.alloc_empty_file
      2.19 ±  2%      +0.2        2.34        perf-profile.children.cycles-pp.new_inode
      2.26 ±  2%      +0.2        2.42        perf-profile.children.cycles-pp.proc_get_inode
      0.53 ±  4%      +0.2        0.70 ±  7%  perf-profile.children.cycles-pp.apparmor_file_permission
      0.55 ±  5%      +0.2        0.72 ±  6%  perf-profile.children.cycles-pp.security_file_permission
      1.30 ±  5%      +0.3        1.56 ±  5%  perf-profile.children.cycles-pp.apparmor_file_open
      1.32 ±  4%      +0.3        1.57 ±  5%  perf-profile.children.cycles-pp.security_file_open
      2.40 ±  4%      +0.3        2.66 ±  4%  perf-profile.children.cycles-pp.do_dentry_open
      1.35            +0.3        1.69 ± 19%  perf-profile.children.cycles-pp.try_to_unlazy
      1.14 ±  2%      +0.4        1.50 ± 23%  perf-profile.children.cycles-pp.terminate_walk
      1.40            +0.4        1.77 ± 20%  perf-profile.children.cycles-pp.__legitimize_path
      1.00 ±  2%      +0.4        1.39 ± 26%  perf-profile.children.cycles-pp.lockref_get_not_dead
      7.02 ±  3%      +0.4        7.42 ±  3%  perf-profile.children.cycles-pp.dput
      3.52 ±  2%      +0.4        3.94 ±  3%  perf-profile.children.cycles-pp.do_open
      4.91 ±  4%      +0.6        5.53 ±  2%  perf-profile.children.cycles-pp.walk_component
      3.62 ±  3%      +0.7        4.29 ±  3%  perf-profile.children.cycles-pp.kernfs_iop_permission
      4.87 ±  2%      +0.7        5.54 ±  2%  perf-profile.children.cycles-pp.inode_permission
      2.61 ±  8%      +0.7        3.30 ±  4%  perf-profile.children.cycles-pp.kernfs_dop_revalidate
      4.80 ±  4%      +0.9        5.69 ±  3%  perf-profile.children.cycles-pp.lookup_fast
      5.71 ±  6%      +1.2        6.89 ±  3%  perf-profile.children.cycles-pp.up_read
     10.94 ±  2%      +1.4       12.38 ±  2%  perf-profile.children.cycles-pp.link_path_walk
      6.48 ±  8%      +1.5        7.95 ±  2%  perf-profile.children.cycles-pp.kernfs_fop_readdir
      6.24 ±  7%      +1.5        7.75 ±  2%  perf-profile.children.cycles-pp.down_read
     24.88            +2.5       27.36        perf-profile.children.cycles-pp.path_openat
     24.94            +2.5       27.42        perf-profile.children.cycles-pp.do_filp_open
     26.06            +2.5       28.56        perf-profile.children.cycles-pp.do_sys_openat2
     26.07            +2.5       28.58        perf-profile.children.cycles-pp.__x64_sys_openat
     26.37            +2.5       28.88        perf-profile.children.cycles-pp.open64
     15.34 ±  4%      -1.8       13.59 ±  2%  perf-profile.self.cycles-pp._raw_read_lock
     13.66 ±  4%      -1.7       11.95 ±  2%  perf-profile.self.cycles-pp.proc_readdir_de
      1.61 ±  4%      -0.2        1.46 ±  2%  perf-profile.self.cycles-pp.proc_lookup_de
      0.12 ±  4%      -0.0        0.10 ±  4%  perf-profile.self.cycles-pp._raw_spin_lock_irq
      0.10            +0.0        0.11        perf-profile.self.cycles-pp.page_counter_uncharge
      0.10            +0.0        0.11        perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.05            +0.0        0.06        perf-profile.self.cycles-pp.refill_obj_stock
      0.08            +0.0        0.09        perf-profile.self.cycles-pp.number
      0.09            +0.0        0.10        perf-profile.self.cycles-pp.pid_revalidate
      0.19 ±  2%      +0.0        0.21 ±  2%  perf-profile.self.cycles-pp.__cond_resched
      0.26            +0.0        0.28        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.22 ±  2%      +0.0        0.24        perf-profile.self.cycles-pp.native_irq_return_iret
      0.12            +0.0        0.13 ±  3%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.13            +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.generic_permission
      0.08            +0.0        0.09 ±  5%  perf-profile.self.cycles-pp.locks_remove_posix
      0.09 ±  5%      +0.0        0.10        perf-profile.self.cycles-pp.__call_rcu_common
      0.18 ±  2%      +0.0        0.19        perf-profile.self.cycles-pp.proc_tgid_net_lookup
      0.17 ±  2%      +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.mod_objcg_state
      0.13 ±  3%      +0.0        0.15 ±  3%  perf-profile.self.cycles-pp.inode_init_always
      0.16 ±  3%      +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.do_syscall_64
      0.17 ±  2%      +0.0        0.19 ±  2%  perf-profile.self.cycles-pp.get_proc_task_net
      0.23 ±  2%      +0.0        0.25        perf-profile.self.cycles-pp.syscall
      0.65            +0.0        0.68        perf-profile.self.cycles-pp.__slab_free
      0.38 ±  2%      +0.0        0.41 ±  6%  perf-profile.self.cycles-pp.inode_permission
      0.56            +0.0        0.60        perf-profile.self.cycles-pp.filldir
      0.84 ±  2%      +0.0        0.89 ±  2%  perf-profile.self.cycles-pp.lockref_get_not_dead
      0.55            +0.0        0.60 ±  2%  perf-profile.self.cycles-pp.filldir64
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.proc_tgid_net_readdir
      0.10 ±  4%      +0.1        0.16 ±  7%  perf-profile.self.cycles-pp.apparmor_current_getsecid_subj
      0.65 ±  3%      +0.1        0.71 ±  5%  perf-profile.self.cycles-pp.apparmor_file_free_security
      0.80 ±  3%      +0.1        0.93 ±  4%  perf-profile.self.cycles-pp.apparmor_file_alloc_security
      0.49 ±  5%      +0.2        0.66 ±  6%  perf-profile.self.cycles-pp.apparmor_file_permission
      1.29 ±  4%      +0.3        1.54 ±  5%  perf-profile.self.cycles-pp.apparmor_file_open
      5.66 ±  6%      +1.2        6.84 ±  3%  perf-profile.self.cycles-pp.up_read
      6.15 ±  7%      +1.5        7.66 ±  2%  perf-profile.self.cycles-pp.down_read



***************************************************************************************************
lkp-skl-fpga01: 104 threads 2 sockets (Skylake) with 192G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-8.3/thread/100%/debian-12-x86_64-20240206.cgz/lkp-skl-fpga01/futex4/will-it-scale

commit: 
  a0e2dab44d ("x86/entry_32: Add VERW just before userspace transition")
  6613d82e61 ("x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key")

a0e2dab44d22b913 6613d82e617dd7eb8b0c40b2fe3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     33.61            +1.2%      34.01        boot-time.boot
      3130            +1.3%       3171        boot-time.idle
  70814196            +4.0%   73672365        will-it-scale.104.threads
    680905            +4.0%     708387        will-it-scale.per_thread_ops
  70814196            +4.0%   73672365        will-it-scale.workload
     89530            -1.7%      88005        proc-vmstat.nr_active_anon
     92711            -1.7%      91127        proc-vmstat.nr_shmem
     89530            -1.7%      88005        proc-vmstat.nr_zone_active_anon
     76969            -1.7%      75654        proc-vmstat.pgactivate
   1086126            -1.8%    1066713        proc-vmstat.pgalloc_normal
     40426 ±  3%     +10.6%      44714 ±  4%  proc-vmstat.pgreuse
     10727 ± 61%     +52.8%      16392 ±  5%  sched_debug.cfs_rq:/.load_avg.max
      0.07 ± 12%     -18.3%       0.06 ±  3%  sched_debug.cfs_rq:/.nr_running.stddev
      0.92 ± 74%    +383.2%       4.45 ± 30%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
      6.89 ± 72%    +161.3%      18.00 ± 17%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
      0.92 ± 74%    +383.1%       4.45 ± 30%  sched_debug.cfs_rq:/.removed.util_avg.avg
      6.89 ± 72%    +161.2%      17.99 ± 17%  sched_debug.cfs_rq:/.removed.util_avg.stddev
      1259 ±  2%     -17.5%       1039 ± 16%  sched_debug.cfs_rq:/.util_est.max
      3796 ±  3%     +29.1%       4902 ± 12%  sched_debug.cpu.max_idle_balance_cost.stddev
      0.00           +11.9%       0.00 ±  2%  sched_debug.cpu.next_balance.stddev
    876.78 ±  7%     +10.9%     972.39 ±  7%  sched_debug.cpu.nr_switches.min
      6.71 ±  8%     -16.5%       5.60 ±  4%  sched_debug.cpu.nr_uninterruptible.stddev
 6.114e+09            +4.3%  6.376e+09        perf-stat.i.branch-instructions
      1.35            +0.2        1.53        perf-stat.i.branch-miss-rate%
  81670984           +19.2%   97330429        perf-stat.i.branch-misses
      6.05            -3.3%       5.85        perf-stat.i.cpi
 4.754e+10            +4.0%  4.944e+10        perf-stat.i.instructions
      0.17            +2.9%       0.17        perf-stat.i.ipc
      1.34            +0.2        1.53        perf-stat.overall.branch-miss-rate%
      6.07            -3.5%       5.86        perf-stat.overall.cpi
      0.16            +3.6%       0.17        perf-stat.overall.ipc
 6.094e+09            +4.3%  6.354e+09        perf-stat.ps.branch-instructions
  81368878           +19.2%   96977141        perf-stat.ps.branch-misses
 4.738e+10            +4.0%  4.928e+10        perf-stat.ps.instructions
      0.03 ± 47%     +57.9%       0.05 ±  9%  perf-stat.ps.major-faults
 1.439e+13            +3.6%  1.491e+13        perf-stat.total.instructions
     44.04           -21.1       22.93        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     55.72           -19.2       36.49        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.syscall
     19.53           -18.4        1.17 ±  2%  perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     20.23            -6.0       14.24        perf-profile.calltrace.cycles-pp.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22.07            -5.9       16.15        perf-profile.calltrace.cycles-pp.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     20.74            -5.9       14.83        perf-profile.calltrace.cycles-pp.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
      6.35            -4.0        2.31 ±  2%  perf-profile.calltrace.cycles-pp.__get_user_nocheck_4.futex_get_value_locked.futex_wait_setup.__futex_wait.futex_wait
      6.88            -3.8        3.10        perf-profile.calltrace.cycles-pp.futex_get_value_locked.futex_wait_setup.__futex_wait.futex_wait.do_futex
     29.51            -2.6       26.91        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.syscall
     12.81            -2.6       10.22        perf-profile.calltrace.cycles-pp.futex_wait_setup.__futex_wait.futex_wait.do_futex.__x64_sys_futex
     13.99            -2.4       11.54        perf-profile.calltrace.cycles-pp.__futex_wait.futex_wait.do_futex.__x64_sys_futex.do_syscall_64
      0.64            +0.1        0.69        perf-profile.calltrace.cycles-pp.get_futex_key.futex_wait_setup.__futex_wait.futex_wait.do_futex
      0.76            +0.1        0.82        perf-profile.calltrace.cycles-pp.futex_q_unlock.futex_wait_setup.__futex_wait.futex_wait.do_futex
     99.58            +0.1       99.65        perf-profile.calltrace.cycles-pp.syscall
      0.97            +0.2        1.19        perf-profile.calltrace.cycles-pp.futex_hash.futex_q_lock.futex_wait_setup.__futex_wait.futex_wait
      8.56            +0.6        9.13        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.syscall
      1.21            +0.8        2.00        perf-profile.calltrace.cycles-pp._raw_spin_lock.futex_q_lock.futex_wait_setup.__futex_wait.futex_wait
      3.64            +0.9        4.58 ±  2%  perf-profile.calltrace.cycles-pp.futex_q_lock.futex_wait_setup.__futex_wait.futex_wait.do_futex
      7.91            +2.7       10.62        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_safe_stack.syscall
      0.00           +17.5       17.48        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.syscall
     44.20           -21.7       22.46        perf-profile.children.cycles-pp.do_syscall_64
     56.13           -18.9       37.23        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     19.74           -18.5        1.26 ±  2%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode
     20.38            -6.0       14.36        perf-profile.children.cycles-pp.futex_wait
     22.12            -5.9       16.21        perf-profile.children.cycles-pp.__x64_sys_futex
     20.80            -5.9       14.90        perf-profile.children.cycles-pp.do_futex
      6.53            -3.9        2.68 ±  2%  perf-profile.children.cycles-pp.__get_user_nocheck_4
      7.08            -3.8        3.29 ±  2%  perf-profile.children.cycles-pp.futex_get_value_locked
     29.66            -2.6       27.09        perf-profile.children.cycles-pp.syscall_return_via_sysret
     13.00            -2.5       10.47        perf-profile.children.cycles-pp.futex_wait_setup
     14.01            -2.4       11.58        perf-profile.children.cycles-pp.__futex_wait
      0.18 ±  2%      -0.1        0.13 ±  6%  perf-profile.children.cycles-pp.amd_clear_divider
      0.18 ±  2%      -0.0        0.13 ±  3%  perf-profile.children.cycles-pp.futex_setup_timer
      0.44            -0.0        0.41 ±  3%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode_prepare
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.syscall@plt
      0.13            +0.0        0.16 ±  3%  perf-profile.children.cycles-pp.testcase
      0.80            +0.1        0.86        perf-profile.children.cycles-pp.futex_q_unlock
      0.67            +0.1        0.72        perf-profile.children.cycles-pp.get_futex_key
      0.98            +0.2        1.21        perf-profile.children.cycles-pp.futex_hash
      1.26            +0.9        2.13        perf-profile.children.cycles-pp._raw_spin_lock
      3.76            +1.0        4.75 ±  2%  perf-profile.children.cycles-pp.futex_q_lock
      4.25            +1.4        5.62        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
     11.05            +1.9       12.94        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.26           +17.4       18.64        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
     19.27           -18.5        0.77        perf-profile.self.cycles-pp.syscall_exit_to_user_mode
      6.32            -3.8        2.51        perf-profile.self.cycles-pp.__get_user_nocheck_4
      6.23            -3.5        2.68        perf-profile.self.cycles-pp.futex_wait
     29.64            -2.6       27.05        perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.13            -0.0        0.10        perf-profile.self.cycles-pp.futex_setup_timer
      0.39 ±  2%      -0.0        0.36 ±  4%  perf-profile.self.cycles-pp.syscall_exit_to_user_mode_prepare
      0.06            +0.0        0.09 ±  5%  perf-profile.self.cycles-pp.amd_clear_divider
      0.58            +0.0        0.61        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.13 ±  3%      +0.0        0.16 ±  3%  perf-profile.self.cycles-pp.testcase
      0.65            +0.0        0.69        perf-profile.self.cycles-pp.get_futex_key
      0.78            +0.0        0.83        perf-profile.self.cycles-pp.futex_q_unlock
      0.96            +0.1        1.07        perf-profile.self.cycles-pp.__futex_wait
      0.44            +0.1        0.58        perf-profile.self.cycles-pp.do_futex
      0.85            +0.2        1.06        perf-profile.self.cycles-pp.futex_wait_setup
      0.93            +0.2        1.17        perf-profile.self.cycles-pp.futex_hash
      1.23            +0.9        2.09        perf-profile.self.cycles-pp._raw_spin_lock
      9.85            +1.9       11.73        perf-profile.self.cycles-pp.entry_SYSCALL_64
      2.11            +2.3        4.37        perf-profile.self.cycles-pp.syscall
      1.86            +2.3        4.19        perf-profile.self.cycles-pp.do_syscall_64
     12.24            +3.1       15.38        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      1.11           +17.4       18.46        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack



***************************************************************************************************
lkp-skl-fpga01: 104 threads 2 sockets (Skylake) with 192G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-8.3/process/100%/debian-11.1-x86_64-20220510.cgz/lkp-skl-fpga01/futex2/will-it-scale

commit: 
  a0e2dab44d ("x86/entry_32: Add VERW just before userspace transition")
  6613d82e61 ("x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key")

a0e2dab44d22b913 6613d82e617dd7eb8b0c40b2fe3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    228.17 ±  8%     -23.3%     175.00 ± 15%  perf-c2c.HITM.local
     25.31 ± 26%   +1883.0%     501.86 ±132%  sched_debug.cfs_rq:/.removed.load_avg.stddev
      5561 ± 52%     -43.3%       3154 ± 11%  turbostat.C1
     17507 ± 17%     +19.7%      20950 ±  4%  proc-vmstat.numa_hint_faults_local
     61472            +4.9%      64491 ±  2%  proc-vmstat.pgactivate
  66711960            -2.1%   65339777        will-it-scale.104.processes
    641460            -2.1%     628266        will-it-scale.per_process_ops
  66711960            -2.1%   65339777        will-it-scale.workload
      0.33 ± 21%     -31.2%       0.23 ± 18%  perf-sched.sch_delay.avg.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64
      0.09 ± 16%     +82.6%       0.16 ± 15%  perf-sched.wait_and_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown].[unknown]
    534.00 ±  4%     -10.5%     478.00 ±  3%  perf-sched.wait_and_delay.count.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
    187.33 ±  7%     -16.7%     156.00 ± 10%  perf-sched.wait_and_delay.count.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown].[unknown]
      0.09 ± 16%     +82.6%       0.16 ± 15%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown].[unknown]
 1.296e+10            -1.9%  1.271e+10        perf-stat.i.branch-instructions
      1.00            +0.1        1.06        perf-stat.i.branch-miss-rate%
 1.286e+08            +4.8%  1.348e+08        perf-stat.i.branch-misses
      3.34            +2.1%       3.41        perf-stat.i.cpi
  66597836            -1.9%   65315938        perf-stat.i.dTLB-load-misses
 1.946e+10            -1.9%  1.909e+10        perf-stat.i.dTLB-loads
      0.00 ± 59%      -0.0        0.00        perf-stat.i.dTLB-store-miss-rate%
     58479            -6.6%      54625        perf-stat.i.dTLB-store-misses
 1.439e+10            -1.9%  1.411e+10        perf-stat.i.dTLB-stores
  73446151            -8.8%   67017808 ±  4%  perf-stat.i.iTLB-load-misses
 8.619e+10            -2.0%  8.443e+10        perf-stat.i.instructions
      1175 ±  2%      +7.7%       1266 ±  4%  perf-stat.i.instructions-per-iTLB-miss
      0.30            -2.1%       0.29        perf-stat.i.ipc
    450.05            -1.9%     441.52        perf-stat.i.metric.M/sec
    192401 ±  5%      -6.8%     179259 ±  6%  perf-stat.i.node-load-misses
      0.99            +0.1        1.06        perf-stat.overall.branch-miss-rate%
      3.33            +2.2%       3.41        perf-stat.overall.cpi
      0.00            -0.0        0.00        perf-stat.overall.dTLB-store-miss-rate%
      1173 ±  2%      +7.6%       1262 ±  4%  perf-stat.overall.instructions-per-iTLB-miss
      0.30            -2.1%       0.29        perf-stat.overall.ipc
 1.292e+10            -1.9%  1.267e+10        perf-stat.ps.branch-instructions
 1.282e+08            +4.8%  1.344e+08        perf-stat.ps.branch-misses
  66375435            -1.9%   65097246        perf-stat.ps.dTLB-load-misses
  1.94e+10            -1.9%  1.903e+10        perf-stat.ps.dTLB-loads
     58320            -6.6%      54460        perf-stat.ps.dTLB-store-misses
 1.434e+10            -1.9%  1.407e+10        perf-stat.ps.dTLB-stores
  73202477            -8.8%   66790734 ±  4%  perf-stat.ps.iTLB-load-misses
  8.59e+10            -2.0%  8.415e+10        perf-stat.ps.instructions
    191780 ±  5%      -6.8%     178656 ±  6%  perf-stat.ps.node-load-misses
 2.598e+13            -2.2%  2.541e+13        perf-stat.total.instructions
     17.48           -16.6        0.83        perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     61.84           -10.1       51.77        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.syscall
     48.64            -5.8       42.84        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     13.22            -5.6        7.61        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_safe_stack.syscall
     21.25            -1.3       19.98        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.syscall
      7.92            -0.2        7.68        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.syscall
     99.68            +0.1       99.74        perf-profile.calltrace.cycles-pp.syscall
      1.04            +0.1        1.13        perf-profile.calltrace.cycles-pp.try_grab_folio.gup_pte_range.gup_pgd_range.lockless_pages_from_mm.internal_get_user_pages_fast
      0.61            +0.3        0.96        perf-profile.calltrace.cycles-pp.futex_hash.futex_q_lock.futex_wait_setup.__futex_wait.futex_wait
      0.89            +0.4        1.25        perf-profile.calltrace.cycles-pp._raw_spin_lock.futex_q_lock.futex_wait_setup.__futex_wait.futex_wait
      0.00            +0.9        0.87        perf-profile.calltrace.cycles-pp.__pte_offset_map.gup_pte_range.gup_pgd_range.lockless_pages_from_mm.internal_get_user_pages_fast
      2.36 ±  5%      +1.6        3.97        perf-profile.calltrace.cycles-pp.futex_q_lock.futex_wait_setup.__futex_wait.futex_wait.do_futex
      3.56            +1.9        5.43        perf-profile.calltrace.cycles-pp.gup_pte_range.gup_pgd_range.lockless_pages_from_mm.internal_get_user_pages_fast.get_user_pages_fast
      2.16 ±  2%      +2.3        4.47        perf-profile.calltrace.cycles-pp.__get_user_nocheck_4.futex_get_value_locked.futex_wait_setup.__futex_wait.futex_wait
      6.48            +3.3        9.79        perf-profile.calltrace.cycles-pp.gup_pgd_range.lockless_pages_from_mm.internal_get_user_pages_fast.get_user_pages_fast.get_futex_key
      2.49 ±  2%      +3.5        6.00        perf-profile.calltrace.cycles-pp.futex_get_value_locked.futex_wait_setup.__futex_wait.futex_wait.do_futex
      7.50            +3.9       11.39        perf-profile.calltrace.cycles-pp.lockless_pages_from_mm.internal_get_user_pages_fast.get_user_pages_fast.get_futex_key.futex_wait_setup
      8.30            +4.7       12.95        perf-profile.calltrace.cycles-pp.internal_get_user_pages_fast.get_user_pages_fast.get_futex_key.futex_wait_setup.__futex_wait
      9.10            +5.4       14.50        perf-profile.calltrace.cycles-pp.get_user_pages_fast.get_futex_key.futex_wait_setup.__futex_wait.futex_wait
     10.86            +6.8       17.64        perf-profile.calltrace.cycles-pp.get_futex_key.futex_wait_setup.__futex_wait.futex_wait.do_futex
     24.84            +7.9       32.70        perf-profile.calltrace.cycles-pp.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     23.47            +8.1       31.60        perf-profile.calltrace.cycles-pp.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     22.92            +8.1       31.06        perf-profile.calltrace.cycles-pp.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
     20.40            +9.2       29.60        perf-profile.calltrace.cycles-pp.__futex_wait.futex_wait.do_futex.__x64_sys_futex.do_syscall_64
     17.06           +11.5       28.57        perf-profile.calltrace.cycles-pp.futex_wait_setup.__futex_wait.futex_wait.do_futex.__x64_sys_futex
      0.00           +13.6       13.64        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.syscall
     17.67           -16.8        0.89        perf-profile.children.cycles-pp.syscall_exit_to_user_mode
     62.15            -9.3       52.89        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     48.78            -6.9       41.92        perf-profile.children.cycles-pp.do_syscall_64
     13.14            -3.0       10.14        perf-profile.children.cycles-pp.entry_SYSCALL_64
      6.90            -2.8        4.09        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
     21.41            -1.3       20.13        perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.78 ±  3%      -0.5        0.29        perf-profile.children.cycles-pp.syscall_exit_to_user_mode_prepare
      0.17 ±  2%      -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.amd_clear_divider
      0.34 ±  2%      +0.0        0.39 ±  2%  perf-profile.children.cycles-pp.is_valid_gup_args
      0.06 ±  9%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.pud_huge
      1.05            +0.1        1.13        perf-profile.children.cycles-pp.try_grab_folio
      0.07 ±  5%      +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.pmd_huge
      0.94            +0.4        1.30        perf-profile.children.cycles-pp._raw_spin_lock
      0.61            +0.4        0.98        perf-profile.children.cycles-pp.futex_hash
      0.45            +0.4        0.88        perf-profile.children.cycles-pp.__pte_offset_map
      2.48 ±  5%      +1.6        4.06        perf-profile.children.cycles-pp.futex_q_lock
      3.64            +1.9        5.52        perf-profile.children.cycles-pp.gup_pte_range
      2.28 ±  2%      +2.8        5.08        perf-profile.children.cycles-pp.__get_user_nocheck_4
      2.54 ±  2%      +2.9        5.49        perf-profile.children.cycles-pp.futex_get_value_locked
      6.56            +3.3        9.90        perf-profile.children.cycles-pp.gup_pgd_range
      7.54            +3.9       11.44        perf-profile.children.cycles-pp.lockless_pages_from_mm
      8.42            +4.7       13.12        perf-profile.children.cycles-pp.internal_get_user_pages_fast
      9.20            +5.5       14.70        perf-profile.children.cycles-pp.get_user_pages_fast
     10.90            +6.8       17.70        perf-profile.children.cycles-pp.get_futex_key
     24.90            +7.9       32.76        perf-profile.children.cycles-pp.__x64_sys_futex
     23.54            +8.1       31.67        perf-profile.children.cycles-pp.do_futex
     23.00            +8.2       31.16        perf-profile.children.cycles-pp.futex_wait
     20.42            +9.2       29.65        perf-profile.children.cycles-pp.__futex_wait
     17.15           +11.5       28.70        perf-profile.children.cycles-pp.futex_wait_setup
      1.24           +13.4       14.65        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
     16.85           -16.3        0.54        perf-profile.self.cycles-pp.syscall_exit_to_user_mode
     12.04            -3.0        9.08        perf-profile.self.cycles-pp.entry_SYSCALL_64
      3.22            -2.3        0.95        perf-profile.self.cycles-pp.__futex_wait
     13.61            -1.6       12.00        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
     21.39            -1.3       20.10        perf-profile.self.cycles-pp.syscall_return_via_sysret
      2.48            -1.0        1.43        perf-profile.self.cycles-pp.futex_wait
      0.74 ±  3%      -0.5        0.26        perf-profile.self.cycles-pp.syscall_exit_to_user_mode_prepare
      1.36 ±  3%      -0.3        1.07        perf-profile.self.cycles-pp.__x64_sys_futex
      0.09 ±  4%      -0.0        0.08        perf-profile.self.cycles-pp.futex_setup_timer
      0.05 ±  8%      +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.pud_huge
      0.31 ±  2%      +0.0        0.35 ±  2%  perf-profile.self.cycles-pp.is_valid_gup_args
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.syscall@plt
      1.03            +0.1        1.09        perf-profile.self.cycles-pp.try_grab_folio
      0.05 ±  7%      +0.1        0.13 ±  2%  perf-profile.self.cycles-pp.pmd_huge
      2.36            +0.1        2.46        perf-profile.self.cycles-pp.syscall
      0.27 ±  5%      +0.2        0.42 ±  5%  perf-profile.self.cycles-pp.futex_get_value_locked
      0.61 ±  2%      +0.2        0.84        perf-profile.self.cycles-pp.futex_wait_setup
      0.90            +0.4        1.26        perf-profile.self.cycles-pp._raw_spin_lock
      0.59            +0.4        0.95        perf-profile.self.cycles-pp.futex_hash
      0.44            +0.4        0.87        perf-profile.self.cycles-pp.__pte_offset_map
      0.90            +0.5        1.41        perf-profile.self.cycles-pp.lockless_pages_from_mm
      0.51 ±  2%      +0.7        1.24        perf-profile.self.cycles-pp.get_user_pages_fast
      0.90            +0.8        1.73        perf-profile.self.cycles-pp.internal_get_user_pages_fast
      0.96 ± 12%      +0.9        1.81 ±  2%  perf-profile.self.cycles-pp.futex_q_lock
      1.69            +1.3        2.98        perf-profile.self.cycles-pp.get_futex_key
      5.82            +1.3        7.13        perf-profile.self.cycles-pp.do_syscall_64
      2.81            +1.4        4.16        perf-profile.self.cycles-pp.gup_pgd_range
      2.06            +1.4        3.46        perf-profile.self.cycles-pp.gup_pte_range
      2.24 ±  2%      +2.8        5.01        perf-profile.self.cycles-pp.__get_user_nocheck_4
      1.08           +13.4       14.51        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack



***************************************************************************************************
lkp-skl-fpga01: 104 threads 2 sockets (Skylake) with 192G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-8.3/process/100%/debian-11.1-x86_64-20220510.cgz/lkp-skl-fpga01/futex3/will-it-scale

commit: 
  a0e2dab44d ("x86/entry_32: Add VERW just before userspace transition")
  6613d82e61 ("x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key")

a0e2dab44d22b913 6613d82e617dd7eb8b0c40b2fe3 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     13.83 ± 10%     +25.7%      17.39 ±  9%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
     13.66 ± 11%     +25.8%      17.19 ±  9%  sched_debug.cfs_rq:/.removed.util_avg.stddev
      0.44 ±  8%     -20.4%       0.35 ± 17%  perf-sched.wait_and_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
    283.50 ±  8%     +14.2%     323.67 ±  4%  perf-sched.wait_and_delay.count.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown].[unknown]
      0.44 ±  8%     -20.4%       0.35 ± 17%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
  76308359            +3.7%   79094461        will-it-scale.104.processes
    733733            +3.7%     760523        will-it-scale.per_process_ops
  76308359            +3.7%   79094461        will-it-scale.workload
     55603            -2.2%      54361        proc-vmstat.nr_active_anon
     58137            -2.3%      56792        proc-vmstat.nr_shmem
     55603            -2.2%      54361        proc-vmstat.nr_zone_active_anon
     57819 ±  2%      -3.5%      55794        proc-vmstat.pgactivate
 4.625e+09            +3.7%  4.793e+09        perf-stat.i.branch-instructions
      1.76            +0.3        2.10        perf-stat.i.branch-miss-rate%
  81504213           +23.8%  1.009e+08        perf-stat.i.branch-misses
      7.84            -3.1%       7.59        perf-stat.i.cpi
  76204495            +3.7%   79030797        perf-stat.i.dTLB-load-misses
 8.857e+09            +3.7%   9.18e+09        perf-stat.i.dTLB-loads
      0.00            -0.0        0.00        perf-stat.i.dTLB-store-miss-rate%
     74968            +2.1%      76523        perf-stat.i.dTLB-store-misses
  6.71e+09            +3.6%  6.954e+09        perf-stat.i.dTLB-stores
 3.674e+10            +3.3%  3.794e+10        perf-stat.i.instructions
      0.13            +3.2%       0.13        perf-stat.i.ipc
    194.14            +3.6%     201.22        perf-stat.i.metric.M/sec
     76.87            +1.3       78.12        perf-stat.i.node-store-miss-rate%
      1.76            +0.3        2.10        perf-stat.overall.branch-miss-rate%
      7.84            -3.1%       7.59        perf-stat.overall.cpi
      0.00            -0.0        0.00        perf-stat.overall.dTLB-store-miss-rate%
      0.13            +3.2%       0.13        perf-stat.overall.ipc
 4.609e+09            +3.6%  4.778e+09        perf-stat.ps.branch-instructions
  81226256           +23.8%  1.005e+08        perf-stat.ps.branch-misses
  75948753            +3.7%   78766248        perf-stat.ps.dTLB-load-misses
 8.827e+09            +3.7%   9.15e+09        perf-stat.ps.dTLB-loads
     74738            +2.1%      76323        perf-stat.ps.dTLB-store-misses
 6.688e+09            +3.6%  6.931e+09        perf-stat.ps.dTLB-stores
 3.662e+10            +3.3%  3.781e+10        perf-stat.ps.instructions
 1.106e+13            +3.2%  1.141e+13        perf-stat.total.instructions
     39.96           -26.1       13.91        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     52.30           -23.3       29.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.syscall
     21.46           -20.2        1.24        perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     15.92            -9.7        6.22        perf-profile.calltrace.cycles-pp.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     14.55            -9.7        4.85        perf-profile.calltrace.cycles-pp.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe.syscall
     13.86            -9.7        4.18        perf-profile.calltrace.cycles-pp.futex_wake.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.41            -4.2        1.17        perf-profile.calltrace.cycles-pp.get_futex_key.futex_wake.do_futex.__x64_sys_futex.do_syscall_64
      5.45            -4.1        1.31        perf-profile.calltrace.cycles-pp.futex_hash.futex_wake.do_futex.__x64_sys_futex.do_syscall_64
     32.42            -3.9       28.48        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.syscall
     99.16            -2.6       96.55        perf-profile.calltrace.cycles-pp.syscall
      8.66            -1.7        6.99        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_safe_stack.syscall
      8.99            +0.3        9.32        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.syscall
      0.58            +3.4        3.94 ±  7%  perf-profile.calltrace.cycles-pp.testcase
      0.00           +21.1       21.12        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.syscall
     40.10           -26.8       13.28        perf-profile.children.cycles-pp.do_syscall_64
     52.74           -22.8       29.91        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     21.67           -20.4        1.32        perf-profile.children.cycles-pp.syscall_exit_to_user_mode
     14.14            -9.8        4.32        perf-profile.children.cycles-pp.futex_wake
     14.61            -9.7        4.90        perf-profile.children.cycles-pp.do_futex
     15.97            -9.7        6.27        perf-profile.children.cycles-pp.__x64_sys_futex
      5.45            -4.3        1.20        perf-profile.children.cycles-pp.get_futex_key
      5.46            -4.1        1.32        perf-profile.children.cycles-pp.futex_hash
     32.59            -3.9       28.68        perf-profile.children.cycles-pp.syscall_return_via_sysret
     99.58            -2.3       97.28        perf-profile.children.cycles-pp.syscall
      4.64            -0.7        3.96        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
     11.74            -0.7       11.08        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.45 ±  5%      -0.1        0.36        perf-profile.children.cycles-pp.syscall_exit_to_user_mode_prepare
      0.18 ±  3%      -0.1        0.09 ±  4%  perf-profile.children.cycles-pp.amd_clear_divider
      0.05            +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.syscall@plt
      0.58            +2.7        3.30 ±  8%  perf-profile.children.cycles-pp.testcase
      1.35           +21.0       22.37        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
     21.18           -20.3        0.88        perf-profile.self.cycles-pp.syscall_exit_to_user_mode
      5.37            -4.2        1.16        perf-profile.self.cycles-pp.get_futex_key
      5.22            -4.0        1.23        perf-profile.self.cycles-pp.futex_hash
     32.55            -4.0       28.57        perf-profile.self.cycles-pp.syscall_return_via_sysret
      3.42            -1.5        1.87        perf-profile.self.cycles-pp.futex_wake
     10.45            -0.7        9.80        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.40 ±  6%      -0.1        0.32 ±  3%  perf-profile.self.cycles-pp.syscall_exit_to_user_mode_prepare
      0.05            +0.0        0.07 ±  5%  perf-profile.self.cycles-pp.amd_clear_divider
      0.05            +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.syscall@plt
      0.51            +0.1        0.62        perf-profile.self.cycles-pp.do_futex
      0.61            +0.3        0.91 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.34 ±  2%      +2.3        2.63 ±  9%  perf-profile.self.cycles-pp.testcase
      1.98            +2.8        4.80        perf-profile.self.cycles-pp.do_syscall_64
      1.65            +3.9        5.51 ±  3%  perf-profile.self.cycles-pp.syscall
     13.00            +4.4       17.39        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      1.19           +21.0       22.18        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


