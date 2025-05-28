Return-Path: <kvm+bounces-47838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92508AC5EF0
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 03:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 573024A34EF
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 01:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96BD1B0F33;
	Wed, 28 May 2025 01:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IiPN2W+W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A5818FDDB
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 01:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748397508; cv=fail; b=ZOv3TLucXgiS31xcCohHLsq7SBOpZnOcVT7lUane32zLQtyG9X1V+eoEmdsVwknOj5lfkDzc1zHKpRSZIF5fwVYhB6GWvLviF/E5cmxjSGBp4eEdWpJAyN4l3KspMS038aJgqkcDIp06iOOlPe+jJ0h0dI1+5i6OMMyyTy9ZCNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748397508; c=relaxed/simple;
	bh=IaqTnES1I+BPvQ6DqPiIAOFSUIRH5wCRfPJsEaO7mDE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rnsyHpwBZ4Svw77DyKEOtkQXCSvMGqBbg5o7gha+H1S0GPxqaD0AJYaZMEPMWz1yc7AoRtUpMu+4oVw5+LtQmz+5jZSdoJkHMdT0l7lODAPwDT7J8NRf/I5GiZbtq+nTFBqn9uREFgcr4rSX7TDVTdXzddkVJKMnszynUndCD8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IiPN2W+W; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748397506; x=1779933506;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IaqTnES1I+BPvQ6DqPiIAOFSUIRH5wCRfPJsEaO7mDE=;
  b=IiPN2W+WOxu6Tg0Mbra/14NtIcBP0FRSmYxt3+/nUphle8vcp1mWJH+1
   2m+zcfpUF5QfuFI0YF+jVesYsfSKIjVbNHEamKYPI2dHxTGEd/QuLldG4
   twKuZ/pv5+fP1t7RSgMQGemXbpQwOxj+kgPp1O5+m6uvYuduvZCIyT4Cn
   J5PwJjC2w66V8TaHD+JHX+kWq+zAE4AjhNNUxNWSMOCYSKvve8LsUmYeh
   AgpXszguSEZL7qv42fO2utAziIsBTAQ5J9uB6sdDfO05GuOV3V2FsBfL8
   3lifI8sIJ+u+Vi/jR392SWTyh8qpF5U1JrMVH7MR050eEzMBeVO8W447o
   g==;
X-CSE-ConnectionGUID: DprdSw3ARqaiVBI7RY9VXg==
X-CSE-MsgGUID: UAE6kyOARw+wJTWgvENxAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="50333474"
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="50333474"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 18:58:25 -0700
X-CSE-ConnectionGUID: 01lN4l1MTr2DbLiRlXdoFw==
X-CSE-MsgGUID: G1BAPWT2Q0iJlHLpAUqCPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="144035282"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 18:58:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 18:58:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 18:58:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.71) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 18:58:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sNQmV3q4SEQMQLiriVn5cbNXDBj9aKm4xUMEvrES4cp/4YoGI7IBZbikz3vXYcaWc+Kn+F4p+teZvoeerMt31ovj0Ma40dkD8iSqjC0V+PLyzdUZI4GlanVTW7xNWZHS286+EtI+iijGbcDfWNwU+OwoQMHhfGK0zLc7lZj+uNLq3VRzhnA3hu67E70EyMCXQOuKGhWHIwtYpgM38mXDhRMoFfSkVVrT4iV72esYsrjDTUnsCD8MtDqNeQ80iIAS0b8kj7ToDhNtKQBmcPXE5BdQVzPrEC3uxuShUC3+CXj/yfdZvIOlm/rJVEGomyKZV2ouHl9/Q8+VBqI68A68SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/TgVXlDMVdX+9/DaQtKauZ2VmtNstbxiJip6ozKfTY=;
 b=EKKzKZc2FbN1lD2WxNn2ADQzVe081gVM0kfnbOlV4lRzUUW6edUzf9kpwtopjIWNBmmxGoWeSMXfsC3BD+/H+zI39Nt3S3WHS74353WbDy4VQ+g+9h1l9dEseOVxjr4okZrtSjufCxY8ZmmtpWHwGNt0bsB7QYJW1XtijIJdPLKDEY+QY7oMb/rhR+/WR4DITxlSi64IEgtctctgiuKIYJUktt2gUZLP75EtqG25gPfGMZLzzSAE1UlHX38pr+a41WogTiws496BWKWNme28KIal0MM3lPE5UJTLTKuTKBkDxzXBjZQeyrYqvFrJ0DQTe3o0wwgApCu+jFBggtNAYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ0PR11MB5939.namprd11.prod.outlook.com (2603:10b6:a03:42e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Wed, 28 May
 2025 01:57:35 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.022; Wed, 28 May 2025
 01:57:35 +0000
Message-ID: <9b00f0f1-c558-456e-bcf3-d3fe960378ef@intel.com>
Date: Wed, 28 May 2025 09:57:25 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/10] RAMBlock: Make guest_memfd require coordinate
 discard
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-8-chenyi.qiang@intel.com>
 <7af3f5c9-7385-432f-aad6-7c25db2fafe2@redhat.com>
 <cf9a8d77-c80f-459f-8a4b-d8b015418b98@intel.com>
 <e187cd31-09b4-48da-88ea-20582023e5d8@redhat.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <e187cd31-09b4-48da-88ea-20582023e5d8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ0PR11MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a04c8a-e24f-43cd-360d-08dd9d8b0401
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZVZoVjNFakdmV043cWZiZnNweXhkekFObDVPMjg3WWdlV0twemd2RitGT3NO?=
 =?utf-8?B?ckEzL1B6THhlTWlZV1BYSmtOTUdiR21jRG5mYUlLeVNKZHFIZEhvWE15aitx?=
 =?utf-8?B?bSszaWhSYzBQa2plZm11c2gxamo3VW9xYUxWLy9BYm5KeVBqV3kxbGI0UjZG?=
 =?utf-8?B?S281NzJTbkw0bHRFNnZBbEt6YkVtOGNLRXJCRG56NkRKTVJuYktDQTcrM2lO?=
 =?utf-8?B?RmI2ZklkTXpUVUJ5QlVUbHVQLzBLaGwrSUNKUlo0cTZqV2JBbE9menMvZUZX?=
 =?utf-8?B?SlFrbTgxWDlFV0tja3pwTzdZajZRTTdQZ21yTkZLajM5L1Rmc2xMTS9ZOGpo?=
 =?utf-8?B?WHRaUGZNcmtodzR3bTgxS3Y4OWtteDh4SDBYVXU4OXpScm96ZklvTTRmWVdu?=
 =?utf-8?B?ZHNXQlM2ZkNtbjhyZjZvZS9wZXQrUitIL28yUVRmVXNkaXh1TEg2bXJzc3ZJ?=
 =?utf-8?B?MWdMd1FIMWRHTkRLQXBjZU1mMUJXZWhaWG5oN0loTGFlbFRTaThrS215MnN0?=
 =?utf-8?B?YVR4S2lDbmRlWDdyaFRSTFdIdmx1MUV1L1puYlh6bHliMENoMnhubm1CYUR0?=
 =?utf-8?B?Wm1SamJlODByMVM4NjBJYldkN1cxVmF2QkdreUQvV3NoZURjWkxnY1JYWGMv?=
 =?utf-8?B?S1J2WVNEYVUwM0MzaUpuUHBHYnMweUM3VlN4UVBJUjVnWEpwTS9CZVdULzlZ?=
 =?utf-8?B?ano2b2h5SXNkcThYVVVCYVYycDRwbUtIZWE0YVhFcjZleE5COU1XRHU5bXp3?=
 =?utf-8?B?REJ3QUFNUGFVR0llbFF3Y1FaR0s1OGZ4cmk4Vy90bWtVVkhoUzA3YnhiZmox?=
 =?utf-8?B?dTZpOU5mWnlrWUEydEs3SVZ0MEgxRFo2c0pVSDVMaG00QzdPREE2MTl2N3Rv?=
 =?utf-8?B?emlnZENuQU15R3YwYVlzUVpMZmRHRjRWY3JiSmlLb1R1QlEwYkxyNGJwdEcv?=
 =?utf-8?B?MForb0N0dW9WQ3dZRmJoZE1qNUR3VXpYUklPQm9KN3FXdGhEL1RMUDFJaTY5?=
 =?utf-8?B?ZkxEaDA1QThzTTVoblRMV3BzR0oyYlA2Sk16QUxVNGpXOWs4elB0cUMxaTRx?=
 =?utf-8?B?WGprS1lqSEpqNFJYVXRUNUhwa2VBZXk3V2xJWUF3cHcyZEgwMFF1ZzUzVStO?=
 =?utf-8?B?UHA4TmQwWUxsSEFwMDVPTFQrTjdkL1VpbTgyNEJTT09JdU4xOUw2U0VqbW1w?=
 =?utf-8?B?ZTNaZE9YU3JMMDJzbE9zOFpOTFIwMkpoWllVa3g1NDJYTVZlUWVlcmkwaW5t?=
 =?utf-8?B?aHBJS09yWEZTYTM1VkxlZ29pSGpUVnJXZ2JjeC9nTzgrRzJkeW1WcUFpWWVk?=
 =?utf-8?B?WjNEYnduSmppRkI1dkhkc0xtSkJudDh6aG1mVDdsSkxsRSs0R0MzNTdYNUVJ?=
 =?utf-8?B?ay9paDlzcy80NVU5Z0I5RUFqMVFRcGw3dkJUTFhIQWozQkRaelVrdS9aK0JQ?=
 =?utf-8?B?eGZwRW1jNFBUQUlENlh2YXEvMnNEL3NwdTJKSzNhUUx0TFhOQXJFYzFmOHJF?=
 =?utf-8?B?eEJtQm1zOWR5cnVVZC85VnJoeVJ3RjRNNDFVRk1uTC8yeDNKT2lBNkhKeTky?=
 =?utf-8?B?NTYxWHZFN1V5akJRNnFBWGxhdk5LVGVCQktlR3o4ZGdQTGNmSUh5WUs0dUJz?=
 =?utf-8?B?UkNzUTFoSldSTzBWaml1SGY0OEI5cGI2VFRjSEIvNmlaWWJmZm10QnUxUThm?=
 =?utf-8?B?aHVtMDh2V1BDek56WUl3Z1lQZlp0ck8xVzQ3T3REa05yYWltaGhJTC9pMkgv?=
 =?utf-8?B?c1YySkNzcFd5U2NOaWMvc0Rjc3M1amlYNG5XWTgwazNOeElhMi8xaGpuVk4y?=
 =?utf-8?B?M3lGNi9kL3ltZmQrbklZQVJoNU9LZThhWWZCR3p5UGI4VkxiUnhCREpPNEw4?=
 =?utf-8?B?ZjFsYnV6czg2YmdrWlRNc0xldXRVV000RXRWbWZqdlpHUG5zakVVcHNEcFNk?=
 =?utf-8?Q?QMw6xkLvTkU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFlBSmtRaWttejdxazA1RVQwcGVLdHZRL0RTVTBNQ1hhKzJUOURWUklXZFVP?=
 =?utf-8?B?VDRSTHlRSnI3RnJwQ3dhSzJLcjdwU2tSUnV0Y0tKb1dVZ1ExK1FiK1VSamRB?=
 =?utf-8?B?RmRFbHhuK05TdFd6K1FaSDMrN3RtMGJwSmNxK0ZjZXNLSmNiRmtMV1dmS3VF?=
 =?utf-8?B?dEk3L3RoMzdZSDJTM2dtZk56b3Zlcm9pWUFtWjY2SmtqRjNYNnhETUFud29V?=
 =?utf-8?B?WkovM25SYnUyU09weDQ5SUJGMDlMSlpDelB0NFc2UlhZc2wyMFBWRXNCT1pW?=
 =?utf-8?B?WlVvL3kzSUhEem5PbkxOMDVocUtrdG55bVBlZkxjVkJEZEo5NFZuZUJXbEpu?=
 =?utf-8?B?ODdCWnBkM0x0b3dhbFgrNjNBZTk0bGVXL3dGRW1XdlBEcTJzcks5NmErUGJJ?=
 =?utf-8?B?MWFCQlFZVjY2d2J0WURON0huUXAzbGE3Q0d4OFQ2aE1ORm80eW1yQWlwS282?=
 =?utf-8?B?c09kZ01CNlhUa3JvUUdFblAzTUd1bk9hNzQ2TjlielphcjA3WUdCdG81OEE3?=
 =?utf-8?B?L0F6Z1owbTRVVHdjdDJ5OUt6dUxYTk9SUHREZ05tTERkQXZWZ1NDM3VWOEpT?=
 =?utf-8?B?TlljTG9LYTFhQW90UGx4MEtZUWRSRDE5RENyRmNNRlZjZ3hmSlFwMXpUSnVY?=
 =?utf-8?B?YUcyNDRvNU03alRjeXRGVHlFMlA3bHhMWGgrT3RFdFNIQVdLYUlPWWh0UE1O?=
 =?utf-8?B?bkpuSXRmODRPNER5YVVZemg1eEcrVEsxbGFlUGNsVmUxaVpkK2hFUnhRNkVC?=
 =?utf-8?B?d24yNjVITGpDdHZrZlNxTWk3T1c0WHJYU0g5dEE0M3ltVW9lOFJNVVVocXMx?=
 =?utf-8?B?RGRLOUswRDcrYzNUVm1FVkdKejcxbUVscHF1QmhnWi95bFYvN2hXQnhEdHhL?=
 =?utf-8?B?RjV0WmpMN2luK1I4L2JSVnp6WkphdTNLYTlWMFJDU3dEZUJady9JeWJzTjJ3?=
 =?utf-8?B?Yks4ckthMjY1QVIxemZENXlDdWxwS0tEWXdQWTdpdmpoNExXQ1ZhK05WZWp2?=
 =?utf-8?B?ZnNhNUdOYnNVOW5ZRkVHU3dNdmtmWUczV1c0bXlsSzRqK3NqQXZZL2hleTFZ?=
 =?utf-8?B?WWlwT3h2MStqbEh6eUhRblB2S3BZUEtxWXRsb2lNamNYT1c4N3ovYUo2UWhs?=
 =?utf-8?B?YTJvZmNDUVozVGhJdXNiYUprdldrR3dCK1FkWFFKR0R4aWtUL0tSMXFhQ05W?=
 =?utf-8?B?V0RxaTVzSEg5cEtXNk9XdEY5NEhObDkvbmdGVWRNZzJIWEI1UTU0YWplbXNZ?=
 =?utf-8?B?SExKTmtreVFMcjJoNmVlM0lYa2RscGRYZjFCN3lla3FRazhVbnBDV1BKc1Ev?=
 =?utf-8?B?S3lvdXdiVXBtRENlaU83a2NiTG5RU3R3dnN5bkFJNUVsaG9vRmFDMFRWd3Fn?=
 =?utf-8?B?SkdRS1FXYTREZjhnSWFNZWxoNzFQcmdEY0xaUWk0cHZsNy9QRDR0V2c2R1V0?=
 =?utf-8?B?bURMaFlXQnZoazRWTVpNenFINDJKcDFuaytlaEdCcGI0M1dWdFhrKzdRVy8x?=
 =?utf-8?B?RUFCTVVnYVZvQ3BLZjhRMEsyZTZvaWdLZ3J0aUcxNDh1eXNLcFpYV1BLOVhN?=
 =?utf-8?B?dS9Ya3owaDNvbXgyMU8rNGd4OEtQb1A2SWFxTXh3S1RjcE5lRFlBT0MzdUFm?=
 =?utf-8?B?R2hQMTdVbjhwS1gzK1FhNmU1V21ETHR2WjdQWGtUVHJkcW1BOHVYbHJQMVdX?=
 =?utf-8?B?NUJkL01aNFNsVlZyM0tJTm1XaXEvRUh5K0pqV2F4VyszaVp3bUtEcGNxR2dl?=
 =?utf-8?B?UC82YXoyQ0VMTGZwVHh5MEtmMVowNWtSS296VmlTNlZpeUJqdVJNQlNmMXlK?=
 =?utf-8?B?UE1BVlVhY25qRExYZTJqREtCRXR2azE4cERvVVdyOEozUlZ1NmVQSDBYTkQy?=
 =?utf-8?B?bnlNQjZJc1Y5TXQzNFRnQUtrbmxvalJhQVMzdUh6TWJPMVVKN01jSTRBMFR2?=
 =?utf-8?B?eFV4N3hFUGN5L1JKU1pPRmhqa2NTQlJBcERDa092MDZCQ1RwYVhwQ205NHNq?=
 =?utf-8?B?d3NPeUZlL1U0dGR3TDNKT1QwNVkzb1lXTERmMDNyaGY1ZDBraUZsQk0zRHlK?=
 =?utf-8?B?a0hoUEdvMVBkd3prT0UwUFpZU1FIUUdibFViSWhmTkFBRk01WVFGZWJLdVZ5?=
 =?utf-8?B?ZE5qNHhKUWllM3JTdGJrTEthN3ZsSDhJQ01ZTTdHYi9NZnJSWi94ejJKSEFx?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a04c8a-e24f-43cd-360d-08dd9d8b0401
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 01:57:35.3685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFXw4DbpRS6b6/rfFvfD2ijonXy9wLcN4FdQeGcRbPQu7SjgIIWEQ/jxvx3K0WxKGdlPYi7Gx2xcaMeLdhsQqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5939
X-OriginatorOrg: intel.com



On 5/27/2025 7:20 PM, David Hildenbrand wrote:
> On 27.05.25 07:47, Chenyi Qiang wrote:
>>
>>
>> On 5/26/2025 5:08 PM, David Hildenbrand wrote:
>>> On 20.05.25 12:28, Chenyi Qiang wrote:
>>>> As guest_memfd is now managed by RamBlockAttribute with
>>>> RamDiscardManager, only block uncoordinated discard.
>>>>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> ---
>>>> Changes in v5:
>>>>       - Revert to use RamDiscardManager.
>>>>
>>>> Changes in v4:
>>>>       - Modify commit message (RamDiscardManager-
>>>> >PrivateSharedManager).
>>>>
>>>> Changes in v3:
>>>>       - No change.
>>>>
>>>> Changes in v2:
>>>>       - Change the ram_block_discard_require(false) to
>>>>         ram_block_coordinated_discard_require(false).
>>>> ---
>>>>    system/physmem.c | 6 +++---
>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>> index f05f7ff09a..58b7614660 100644
>>>> --- a/system/physmem.c
>>>> +++ b/system/physmem.c
>>>> @@ -1916,7 +1916,7 @@ static void ram_block_add(RAMBlock *new_block,
>>>> Error **errp)
>>>>            }
>>>>            assert(new_block->guest_memfd < 0);
>>>>    -        ret = ram_block_discard_require(true);
>>>> +        ret = ram_block_coordinated_discard_require(true);
>>>>            if (ret < 0) {
>>>>                error_setg_errno(errp, -ret,
>>>>                                 "cannot set up private guest memory:
>>>> discard currently blocked");
>>>> @@ -1939,7 +1939,7 @@ static void ram_block_add(RAMBlock *new_block,
>>>> Error **errp)
>>>>                 * ever develops a need to check for errors.
>>>>                 */
>>>>                close(new_block->guest_memfd);
>>>> -            ram_block_discard_require(false);
>>>> +            ram_block_coordinated_discard_require(false);
>>>>                qemu_mutex_unlock_ramlist();
>>>>                goto out_free;
>>>>            }
>>>> @@ -2302,7 +2302,7 @@ static void reclaim_ramblock(RAMBlock *block)
>>>>        if (block->guest_memfd >= 0) {
>>>>            ram_block_attribute_destroy(block->ram_shared);
>>>>            close(block->guest_memfd);
>>>> -        ram_block_discard_require(false);
>>>> +        ram_block_coordinated_discard_require(false);
>>>>        }
>>>>          g_free(block);
>>>
>>>
>>> I think this patch should be squashed into the previous one, then the
>>> story in that single patch is consistent.
>>
>> I think this patch is a gate to allow device assignment with guest_memfd
>> and want to make it separately. Can we instead add some commit message
>> in previous one? like:
>>
>> "Using guest_memfd with vfio is still blocked via
>> ram_block_discard_disable()/ram_block_discard_require()."
> 
> For the title it should probably be something like:
> 
> "physmem: support coordinated discarding of RAM with guest_memdfd"
> 
> Then explain how we install the RAMDiscardManager that will notify
> listeners (esp. vfio).

Make sense. Will do the squash and change the title. Thanks!

> 


