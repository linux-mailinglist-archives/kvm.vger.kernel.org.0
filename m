Return-Path: <kvm+bounces-49996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 941EBAE0F80
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 00:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C11217B292
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 22:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE7123C517;
	Thu, 19 Jun 2025 22:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HtAe1MvP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE3A219E8D;
	Thu, 19 Jun 2025 22:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750371330; cv=fail; b=ZRhMjWGjExchXgT3HM20hM3ifPM/YRYcHyxnBFKit9r0lrfI1yC4eqGmfoMmpAOC98lJp0/agsfm1f7Q+jVxTbzEhA5shjpbCbbclR3TcQ4e4WduBJEMLPdCNE5tiVwng5wCtbJ/6cTW4ZmlzoyW393xVBXKYZFF3XyKs6uiEDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750371330; c=relaxed/simple;
	bh=H90RLRtmuWnGp1tYLMxw6DQ09zPFsOMPf798WRyTv78=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Wx1DUrlwmm4tfns8Lnh0Ljx9HnoUvvUiFKLUOBbUIqOis1ZU6M307bM3ZqNGxPc896Eg3wh1Qn9EF66n7kGL6shPs2ecaC1jNhqSNRC2QO7FXUJzgNtqcJ0ey5W5rm6hjQ6KidsomghbEmQCM0vkedGNT2PYWIjQDqou3+pt+WA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HtAe1MvP; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750371329; x=1781907329;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H90RLRtmuWnGp1tYLMxw6DQ09zPFsOMPf798WRyTv78=;
  b=HtAe1MvPeOTQaho7iUFB22gpaosmJwxcHoA7W0CB0s963IFGEhYs0ncK
   F23YAqNfavErYX6+SGNJr9m6RSu4T44CyV09rxHw2VXWigDvto+r96gBW
   iEz/JIehKdYkHxRU7tFrDQVmTqz6pIQnjO7kJ3ESc/dwfpiBEtSYN5B88
   LUKNGVCQ9Gc95n1KjSdCaA9DULQGMrp07Ddlcz1LZJdKKv1GJNbCoD98K
   +ziDikYwzwvkEIcwJRtOAtRVMDhRNqu6OsU/I26bySjC5YrFRZ4WtEr7u
   ngTu7bWR9hehgoYbeTvyk9Ksrt9UBPzev2rxsQ2t4nMhTrSSnbB7isvac
   g==;
X-CSE-ConnectionGUID: TdbiOnj8RwOPieYFMmiyqw==
X-CSE-MsgGUID: 3azofb+4SYa8QVOftX4Khg==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="78039670"
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="78039670"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 15:15:28 -0700
X-CSE-ConnectionGUID: ibKO3JhbSnOS2pbRq7fAdQ==
X-CSE-MsgGUID: /Z97jcW/QRadmpDB7iy5cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="174366609"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 15:15:27 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 15:15:26 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 15:15:26 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.53)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 15:15:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bDI7dttasHJ6cxbtieGFQGNxt5P6STB9Ai1PnWqWSK2XmaVuVaCFxpmp/EU/9Mo6ZkuS8sRbrY84VE8ZBO0NXLDq0Bg8+/oKhnjzsbEXEAQylLHKVxBwLX4I+GvOdexCyZXqnx4o6UF5g7FHbiuJ4XPAEaE5l87+u9z5Emq9UW320/oZ/IBDvwDv+BLfnrKOIwCpji5BUVqXiQ/uQ9nXNxMYnelMWvmiRfW5UfVrFNr8hnVbF5HxPN5LOeWpu6gCkHJeg8EavsYPmMdy3Lt27M84uS0bcggvpUQNDL1PjFcvammA1P5BwJ2UD5rP0V7rN4GRFcagusktBuhwib2ELQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REvgUvRnZ4WpxiyXIahrxU2NonNggfhXRmlZQPwRdYw=;
 b=ZPsU+VD4QzqCQb29QKGZN1KdyOSth+akfu1gBLl7kSoNBPAOaQMuq6T2LDCuL7G3yPMrz7dMjDH2+9yzo4aUsA1OjS0OlpnioGujSFRmBQGEc5VPX8kYbUNWbvnZ3M6VTbxSF8kH39rmXk2fOJF39Pl6VpmL8U1KBntxaU0AzceXduwqcnQPidcG1zpPonZice2kzgep50hL5urRIP7xUEtzJAOxRge+eQJta1Ku7BJCL0KyvE/Cvl3xxXUl05N35cB4zQrsv6WU9GdWEFca2SOcJ+JpG7qCemYrmJbTIJGOf14BOt7eCb+GJZ7jAQfIA2l8hAHyuvmt6MgBYP6chw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by BL3PR11MB6531.namprd11.prod.outlook.com (2603:10b6:208:38e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Thu, 19 Jun
 2025 22:15:24 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 22:15:24 +0000
Message-ID: <3281866f-2593-464d-a77e-5893b5e7014f@intel.com>
Date: Thu, 19 Jun 2025 15:15:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
Content-Language: en-US
To: Xin Li <xin@zytor.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson
	<seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Kan Liang
	<kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Zhang Rui
	<rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-3-sohil.mehta@intel.com>
 <7525af7f-a817-47d5-91f7-d7702380c85f@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <7525af7f-a817-47d5-91f7-d7702380c85f@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::26) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|BL3PR11MB6531:EE_
X-MS-Office365-Filtering-Correlation-Id: dce80d28-0d94-4e5a-a887-08ddaf7ec9a8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L1ZaZ0FScXZHbEJueHpsSGlzVVRBaDZndjJrVE9keWNPRjNRWVJJU1dNNURl?=
 =?utf-8?B?QzF5c25BRXdSMTMyMG5wb3NxdGY2RnBTZXJTNkcyak15bTJpOWgxNnJCYzM4?=
 =?utf-8?B?ZGdULyttdSs5Ri9JZFBRd09qa0xqK3FjdURHRS8yalRmemZDRGxrZEZOVnI4?=
 =?utf-8?B?TUJOVlE1QUNqM3BLTTlValJFMXBoa3hUQUlhVGlDR2hYQU42MFBDU1hrM0Fo?=
 =?utf-8?B?VWNnZzh0cmx1SDZWVm9hVENDdjJQMG4rWm1mY1ladGxpL3JocHNFS29wSkIy?=
 =?utf-8?B?aHM1UEtuR3l3amhaVURMRjVabUZ0NEk3MFF6cHVmaWVLZUZMVlhvQWxwY0R1?=
 =?utf-8?B?ampFa0ZGQXR0RkN3RTdpelcxemJsc0VaVDRpWFlBdG1rcm14bElrdEZrOE45?=
 =?utf-8?B?RFRDTDNCVGJnNWU0ODl6Zk5vbzdSWFRBU2tmbnpwWjUyT2lNR01DcncyQ3kw?=
 =?utf-8?B?SUszRVhnRm12amxhMkV4ang1WUdVYklzQkthUTQ1aHpSRmhFUzFoSzNaVi9R?=
 =?utf-8?B?eTlFelBCelVOYkE5VVlnWHVXcVVmZ3cxWis4N3owQU9ENFBHRUhiR3JGam5a?=
 =?utf-8?B?dXc2TTNaaGVPVkU1bnVnY1BLZkZWNWNRbWtTaUVSSHFkcCt6bjl1Z3pFRWtU?=
 =?utf-8?B?ZnIyb2RFR1dyQVdjbERxV2c5Y2lGV0M5Y2hyY2l0RmJnVGZYdDNZV04rV3FU?=
 =?utf-8?B?eS9Pc0FtMWI2TTh2MjFYZ2RYZUEvN21zUEZBZURXbjN5cE0rWjJobXF3c3p5?=
 =?utf-8?B?SHpMWmRoZkJid01OcCt6VWFkSmpUeEJ6eTRLU25xRHNLSzBJK0E4NGI5RzA4?=
 =?utf-8?B?SHU0V1Evc3l3R0pwTVNvU2U0cVIwRTlZUmNIMzRQVlN2cUVPcUkzd2JRRTlh?=
 =?utf-8?B?TDlIOHJYSkJaeXdTbVkyVU1Pbm8wRlpOSTB6eFg3MGFqbndqRGY4ZGxseGRD?=
 =?utf-8?B?WjRlckFXVmdyc2hDR2JBL2xjcFJ2SmZrdnVSWitRWUphUzE0NkUydzJ1NFBo?=
 =?utf-8?B?WFR2TmdvQWc4YlpLRzMrMm5KUmNVWUpnQU8xNzU2ekQ2VWtBb3pBZjU4TERS?=
 =?utf-8?B?U21pWWFmSVJhL3U3UzU3MnY1bndNOFFyeDNTUkc4alFTbmNrd09oNVgxRFJp?=
 =?utf-8?B?NkJMZEcyZnY3Nk5uR3p0enNpNExKbjBKSy9QTkl4STBseDZ5aFdjUC9YOUYw?=
 =?utf-8?B?Ti95VE9RVFBPdmtJa01Va0Nnb3JiTGp3K2NuMWl6a056cnBaUGQ2VExObVJX?=
 =?utf-8?B?RXFLdXY2T0RWanpzQWVlcTB1NWNJRkRNaThqampGU0Z4MENORklwTVA3RUNi?=
 =?utf-8?B?cXNpR01CVDBSUWtyZndOUm51bFFYcWxpVFkyVWZ3Y2VYTjBQTWZTK09heUdl?=
 =?utf-8?B?VUluT2dWeHR3YThaY1pZMG1KeE5LWGc5VWtTUWJoeGZLc1BPRkZuVTBieDZL?=
 =?utf-8?B?QkxFTXJSRnlDNER2WTdaM20wWVNieEEyWm1YSDViQjBrajFib3ZEZ0hCUlN0?=
 =?utf-8?B?dDBWVUk3YjE5OUgwbTNReC9VRlYrNGNuVDA3VTdlbnN1dkkxQ0VaRHN4Vmgw?=
 =?utf-8?B?dmlpMG9OS3ArWUlFWkMzSWQ5VGxNbVhRd2tTaUdXeWNFZE9oNm5XSVh3NWh2?=
 =?utf-8?B?NDM4R3Z4TjNZUjFRUTBjeVJZSGVGa09vTEowMGVCNmhLTUtMeWFvN0pVRDQx?=
 =?utf-8?B?QVFqTnZQSWJxMFF1bWo2d1pEZWhJQ09uQms1NzlKUUxuZFB4RGJTc0wwYk53?=
 =?utf-8?B?U0d6dDdsZkVKZWdFNUowM3NQTWxaUFhqdnN0NllMMXh1UFBiRCtZc25LNlpo?=
 =?utf-8?B?T0ZkdUtYeHorTVF4aWJValROR2ZONFowbXMzYi9qcTZDSGFpZlVnNWFzUmdH?=
 =?utf-8?B?TVpvdm1tR214ZDhLVjkrZ1NtY09hVXBGVUkwRThuRnFoNmc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVd2VlFPVTVTcUY0WERRVmErWU50OGROSi81ODFKSEsxMjhJWkI5NUJxUlJM?=
 =?utf-8?B?cmNMNktJYzVKSGZ2dS9zQXBJK1JreHhPRGF3TWhUUVEyYXF3TkJJbm5KV3JU?=
 =?utf-8?B?bnJZc2xKanBtZWtDUnEvSSt1VWdrQVo5N21yVWs0YmZsbXpCVUpyaDVDbm52?=
 =?utf-8?B?d1dqVjF2TWlzTEFaNHE0djRtRVRuYVNwYitNa0VLTjZROXE3Y2hMZHhVV3dR?=
 =?utf-8?B?cDBFaE1VY1RJbXNYK2l5R1lML1MxaFEwRUpKdVhWY29QQjVqU0JnVVd6L3Fy?=
 =?utf-8?B?dW4vVGZ1OTBQZHlKa0RDVlhlb0l4UWNjWG5aajloWDlkMDZMcGlDY1ErMExm?=
 =?utf-8?B?SXZENmszUGdqWldlK3NQejFKd2N3WTc3ZzRVRlFxR1BqUXZMUU94RnkxaXUz?=
 =?utf-8?B?eXRxRzhHcENxOG1WMzNHRWZWMUhkZEcwZG1nZFpxOTNGUGtOelprbHBMRWJG?=
 =?utf-8?B?dEVFeXRYUmhkTUk3QVdkemVGdE9rRzZCY2JnMDExN1kwTERjT1JnOXRIRmx4?=
 =?utf-8?B?N2ZjVjlxRGpGV2F3V3diVE9GZGdqMUVtMlJ0OTdGL1B0WkJkNU85bFU3V2VD?=
 =?utf-8?B?TTNQSUZ4cnlkU0FMSnpEUUg2OVR3eVJxK2ZtbFVRcEhZdElwTDdJRUc3Qzc5?=
 =?utf-8?B?ZEFzMUtWNm5MaFhIMklEeHZIei9OZHQwU3UrVkNaR2hFZjVQVHhZRDFjR3Er?=
 =?utf-8?B?QkZCcEY3K2tDZEY0WFk1RkNCMTF6U2ozblhrZHRSenRuSmNHV2sxVnN4WVc4?=
 =?utf-8?B?Z216MzVwMVgyOHV1akVhdDczMlFPeEc2SGpJMDM1bFJreVBiN3hJdmlXRjhz?=
 =?utf-8?B?YUxvYlFFdU9kaXRrWVZ6bG1QL3dydkhQbTFyNEJSUzhiMFJOWDAwd3poZlJ4?=
 =?utf-8?B?Sy8rNjZFVzVyd2RvWXRHckUxRkhSSEpTcndDaHVJQmNlV1ZzWHdDbFRubFR0?=
 =?utf-8?B?MG9BUGxQMGk2UllUV3ZuK2lEOEhrdjlyc0NrOVQ3dTN4VHpiNWwvd0Ryb2Jw?=
 =?utf-8?B?SjZzbkFzWk9GUXp4dy9IR0h5emZZRWFsYi9FTWthZHFjT0FnYkw0Q1VEa2p4?=
 =?utf-8?B?bEFybDdMZEd1dnoxQmVvdXpOOEVTK2l6STZJaWVic0t5YnRoV1czMC94c092?=
 =?utf-8?B?djZ4VG4xaU83b2FqazVGZm1yeGZRSnhiZTFwa3FXRzRsbWFDL0xnSWlXWlBR?=
 =?utf-8?B?MXAxSTlDMy93ZHd1SmNoMWlsL0tUVXFXMXJqYzYyS3YzaXM4UklDQkpJa2Jq?=
 =?utf-8?B?VHlYWkZ4RXJTeHZ5WVVwQkJNcFNwMStlM3UvSi9lenYrcmNrUVh3dEt1ekhr?=
 =?utf-8?B?MlJtMTI2UlpUazlhWC85SHBBeXRjYUtublBvMC8xMFdickQ5YWQyTlFUVHBV?=
 =?utf-8?B?MnRCa0J3VlNJNTZGZjFyYS95SEFmUFJGODVubWs5Qkh3a0tPTUJoSUl3OWtk?=
 =?utf-8?B?NWhZc1BYWnpXTTA1VlZDcnhmbXNNZ0s3clBmZk9hSExtQzBzS1F2UWJmbGlW?=
 =?utf-8?B?Slp1SGlHRjRUdWlXeWM4UkFwdGVEaGVRbloxdVM3UWlRSDhuWDJxYUJabjFj?=
 =?utf-8?B?aWl2aDljQkordUcvVzY5NFQ3MEI2MmlWY29JaStJY2c1Tk5hR2hWZmd0NzI1?=
 =?utf-8?B?cGdMK1RnSEtkWWR0WENPcGZnSHdCWC9Xd3NFTzVBVXFHN0RpYVJROFdwNUlZ?=
 =?utf-8?B?emppVjNyVkIwUnZXdXJVazFUVUZWNmY3N0l1SytEQnZGMEduVVRNQ2p4YWJN?=
 =?utf-8?B?Y3FUbjhCZ1VYc1l2VmhXMVpVUDl4L0Y4YjR0M3BVVmZTZ1RSdHdnSTlEZ1Rv?=
 =?utf-8?B?c3dycThyZm1EcVJCWlJhcjhiaUhhZDFkU2N6T0IralhLdDlPVUdINkh5akRN?=
 =?utf-8?B?MlhVRmJtUmdnKzJXNHkwL0JtclJsdEtyQkdmTTFINjNjdVdmcy8rU1ZHVXhO?=
 =?utf-8?B?WEZtSHBjWnd2S2daSGdWZEd6UnZOeWpxbEFOcWE5d1dmd1hVU2ZaUHpJejdJ?=
 =?utf-8?B?Vk9nVXJmOGlYQUJHM3JSalRlejdqc0VOSkIxQzUvR2tpeHhERWVTdVZtVFg3?=
 =?utf-8?B?R1ZBdmszaW1rcGpzc3M1SHhGVC93NXplaTNTNlR1WXY1OGp0c0wwT084b0NN?=
 =?utf-8?Q?r2pPhvKGuyg9L0REZcziJW900?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dce80d28-0d94-4e5a-a887-08ddaf7ec9a8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 22:15:24.1774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRtQr8gYX/3TtEuqyCVsHEy3WVMHgNF1rPdrSlf7Tlzf9RuN5iWLi1chJPYq+mZ813DoWigjYNJXAD+W9htmAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6531
X-OriginatorOrg: intel.com

On 6/18/2025 10:02 PM, Xin Li wrote:
>> diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
>> index 29c5c32c16c3..1c9c6e036233 100644
>> --- a/arch/x86/entry/entry_64_fred.S
>> +++ b/arch/x86/entry/entry_64_fred.S
>> @@ -93,7 +93,7 @@ SYM_FUNC_START(asm_fred_entry_from_kvm)
>>   	 * +--------+-----------------+
>>   	 */
>>   	push $0				/* Reserved, must be 0 */
>> -	push $0				/* Event data, 0 for IRQ/NMI */
>> +	push %rsi			/* Event data for NMI */
> 
> Maybe a bit more accurate?
> 

Actually, I am wondering if it might be better to make it less precise
than it is right now. How about

/* Event data passed in by the caller */

The problem with having precise comments for a generic implementation is
that the caller might get updated, but we would forget to update this
comment since nothing in this function needs to change.

> /* Event data, NMI-source bitmap only so far */
> 
>>   	push %rdi			/* fred_ss handed in by the caller */
>>   	push %rbp
>>   	pushf

...

>>   /* Must be called from noinstr code, thus __always_inline */
>> -static __always_inline void fred_nmi_from_kvm(void)
>> +static __always_inline void fred_nmi_from_kvm(unsigned long edata)
>>   {
>>   	struct fred_ss ss = {
>>   		.ss	= __KERNEL_DS,
>> @@ -83,7 +83,7 @@ static __always_inline void fred_nmi_from_kvm(void)
>>   		.lm	= 1,
>>   	};
>>   
>> -	asm_fred_entry_from_kvm(ss);
>> +	asm_fred_entry_from_kvm(ss, edata);
>>   }
>>   
>>   static inline void fred_irq_from_kvm(unsigned int vector)
>> @@ -95,7 +95,8 @@ static inline void fred_irq_from_kvm(unsigned int vector)
>>   		.lm	= 1,
>>   	};
>>   
>> -	asm_fred_entry_from_kvm(ss);
>> +	/* Event data is always zero for IRQ */
> 
> /* Event data not used for IRQ thus 0 */

Event data "not used" might imply that the architecture provides
something, but the kernel is choosing to not use it. There is no event
data for IRQ, right?

I want to say that the event data for IRQ has to be zero until the
architecture changes — Similar to the /* Reserved, must be 0 */ comment
in asm_fred_entry_from_kvm().


