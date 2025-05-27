Return-Path: <kvm+bounces-47774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75BAEAC4B16
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AEBE3A82AE
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 09:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6DDD225D7;
	Tue, 27 May 2025 09:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ApUibfR/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75133248F5E
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 09:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748336807; cv=fail; b=MGYqGEIXOptYzSnCkhjHFhZno74ogSnzz3TpP39pVXESm+Qoa18/hitiF7tmsWzB7zI2m9TnBdvx/O8vYHGYT250zFOOrkQeAwCA6R7EuZyoy7v0jFMtsW8i6qZcl4Pc4lKT4O6iEvxubUeSvcx3ySNNH7zimUV+ppqzegRO7iA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748336807; c=relaxed/simple;
	bh=/eqPJ5W3driGDx9/JknblmEXs5pYU26TP9gHGVDUTYc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NWlyuvQH1dY/AKZhX5ndMrkdfo5WPocw99eGZ5Sk8tyrGe5iDvY7oWbzmtwgGMgkI9uw6+oZLlTnSA6TU+UQPsQ/juxKQI0BnCPEXiX5AS/sQ64UBsx4UnIa6P4EuyM7eB1NJZufcFOHC/CALBjdknTUxWQ88X6w704qCJgBztQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ApUibfR/; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748336805; x=1779872805;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/eqPJ5W3driGDx9/JknblmEXs5pYU26TP9gHGVDUTYc=;
  b=ApUibfR/Kd+crhR8KVdeUlhmA/vGFArEPlVT8JoZyyeIeL54hrlYAAMu
   PqVCXAYmVF2XmUU+7BBNTScAguFuhGoP6BPPbawRK44SiEMSTfsrVZ/X/
   AnTcaPsxJVtZweF2JMFpDZ2nc2hb5eSw4k70TYocu6MxjNvmu41jvIz5K
   tJOgHkdDrVPP2HQqT7+nzJClMnty4mtGsY4FBUP6bESdf9ogWIFs3U5gE
   ySFuhztg7T8YaLObRrlAfRz7eVqX8fbO/t+XDedALSaO7BTxA64b8VQW9
   GqvMkECLPg2CFj2aXd9mIA4f51q6SxwkQe+Wt7gAGbAViHldqcfvOfsYC
   A==;
X-CSE-ConnectionGUID: I2b2CxJ4R+OOK+D7FC4jrw==
X-CSE-MsgGUID: pMJJUH/yT4yqBNi66difgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="50474238"
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="50474238"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 02:06:44 -0700
X-CSE-ConnectionGUID: cPSySQlLSWisOMKrG1P4DQ==
X-CSE-MsgGUID: 5N7flrwNSLi3XuFQQb0aqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="142648309"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 02:06:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 02:06:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 02:06:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.65)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 02:06:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tPN1Spoi5NSKakicTO+4Q8NFhaSeC3Tddjb1vw0He0HPOtN4ONY3nFugVXUtjjcRXYVR4/3wLsqJQZE7edbdH+OT9EDEWMOuU50gFLgXGVqU+jvgqOjPJYahqPoGKcJygt1p0niRmrZN22JMsFCRoAQ/xK1Dz2sUyqrOldSGbuZmBDw+ma+ZMYTVeVQj+CtokA7OBBBiA4JkLYpLM96SdilXYr6aoPf2gTbfER6tU9s3blOi+UUZSEy/3ybCqjQiRf078Y24N8WD0sCY0M8+VTlUw+kmwEJHAPXlS9cWc0vb8QUifl0FJUeBP08aqawEAaKCN2EAgMD3T26+Iwtjbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuMADNwUxSWaiioPT5VHoBebRiugP9HFARephC65jR0=;
 b=ciPYrW78aFYdD1UBqwHQd6lkeyWI1JT5UKjVqar6EqM4cTsKxRX/RlzXoUhAzrOLkm1X4NHQi3DJ8S9UWxhb4z69kqEQUoD5jmmqRCp5gS7oPjsermwRXlq/LpgK6R0tWkxY0IUFlkp/LKpYX5VRMf6d58xrhaWXsbQClSzxoPGXfIrUh+d6JMfwCbsvRM/lDnU3EFuHXp5Nh6ZPXXZqZVhv1daKEPnLztttsYYPVLPMGsu1F2X6TdBOPGwyzvWQu9igB8iX56U4JQbcIdpY/xFy5fpdXG845RF+dCSGLT3eYR/GCrimtqCqcIgBTrjtprBR+96vIMnBI/j/RFWAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DM6PR11MB4529.namprd11.prod.outlook.com (2603:10b6:5:2ae::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.26; Tue, 27 May 2025 09:06:42 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 09:06:40 +0000
Message-ID: <e2ad3d45-68db-41fe-be1d-cefe0484d52e@intel.com>
Date: Tue, 27 May 2025 17:06:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/10] ram-block-attribute: Introduce a helper to
 notify shared/private state changes
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-6-chenyi.qiang@intel.com>
 <952ff8ef-815e-484f-a319-3416dd3c03e8@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <952ff8ef-815e-484f-a319-3416dd3c03e8@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0239.apcprd06.prod.outlook.com
 (2603:1096:4:ac::23) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DM6PR11MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: 38285d52-0d31-426e-61a5-08dd9cfdcaf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Mjh2WDRscUZRNzRrY0UvUkppajl0cWlHUmhxNGlLQlRyYUYzUVhXUFZuSjRO?=
 =?utf-8?B?ZENZKytzZTZPMlhQZ1BwYks3aEFlZG9iTUdvVStyejROTVo1N0kwREJiRDFR?=
 =?utf-8?B?andEQURqYVdMcThjV3hZQzZJZDAwMThVZkNsb3pQTHJnZmpVQ3c1Q3NRTmVv?=
 =?utf-8?B?VVdzNEUzdkJPaDMyeVByT2E5bHVEaVBBdGN1NkZ6ay9PTkxLSUo5c3UySDZp?=
 =?utf-8?B?RVNCelJiVnREclVXZ3ZFa2tTUlRYVFdwOUx0Y0pYL29aU3lGdFUyZGFkaFQy?=
 =?utf-8?B?ZjJ4QlBmYWwyV0ZoMStWZVF4UVhIVnkvOVNCVXZoRXNkVG1PbmlPc21zTEJV?=
 =?utf-8?B?WVJUSVg5SFRSREw5aEQ1OUVUdVA0RGlyR2hFWS8rK2szWiszbWtoWndqYW45?=
 =?utf-8?B?WGVYY0lOWDBsai9wUk0vNk5OdWlQYWVZaEVLRzhYNEFEQ3FHbnJKK2hCb0JO?=
 =?utf-8?B?L1FQZEdPTnA0ZVFnaTBWT2tGMU1ZeHNCQmh6VVE3ZXdsSS9HVGttcHZRaVk4?=
 =?utf-8?B?RnNFODY2c09pcE5ud3hxUnpRdVFHOFhMY3ZyQ3lwSTFZVjdvYXdKRU9RMEFo?=
 =?utf-8?B?YlNRQ3lNQVgyL3lkR0xvNVh1YmFHb0FEL00zMExxLzNPaWRFNDVIb0RUTk4z?=
 =?utf-8?B?UHlya2ZhdTljV0lRQjRJRTE1M25WR3JTa0FQNzhpZkJVMHg5L1c0Y090UXFO?=
 =?utf-8?B?WmYvNW9PNjRaN0wyK2hrOW9qR1lTUHZLd2dKajdOeUc1TUN3cXkzMEFOSGRZ?=
 =?utf-8?B?VStOcVRZdVZNbHpyVUhxbkNiUGh5aEk0VHROUkxvZ291bE1aOG5EdEZSNEFF?=
 =?utf-8?B?Qks3SlhTMXhpMWsvK2JDTldsV2NBdzNFZWN3WUFoRHhSSkRnN0FUTWVZWnY3?=
 =?utf-8?B?QllMNEl3MXBlZjdEU3FkVDBaUk1SM1V6UGEwc2NIR2NxQmdxSkRGYXU1TWd0?=
 =?utf-8?B?WTloU0NjallEcnJOZDJ6c0c3WnlYdGNsaWgxVzlVdk5wWGFqRlFSa0dqQWVh?=
 =?utf-8?B?OCtNY2hIWFZWbW5mbDVYK1pENGpCelpueTBuVmtyRzZ3Z1VvamFrejFBMktZ?=
 =?utf-8?B?QVYxVmxlcG40WjZra3Vnd1ROQnhxUFljNWN3K012VndlSjZERmJjK1A2Vkhx?=
 =?utf-8?B?UERyVzYrd2h5cmUxc1NKSVlUYndtT3NoRUw1MEtVQzBGTHVpMjg1VEVWc3Nr?=
 =?utf-8?B?YUdscVZCTVlWaStHR1R1aU9hTnZ6K0szVldrRTVqKzhOV0xQY0RPblBzdU5p?=
 =?utf-8?B?WHgydUtNblNMdXlwZk1IMnRzMUdlWVlpbGRxc0wwK2YzSk9vRmJaWDJtcXBU?=
 =?utf-8?B?eDBUNm5Pdk92akJLZW03MU1MWk1hQjN1NHpCSU9Mc2h5aDFKdmRTT3BXTUJ6?=
 =?utf-8?B?Sll3d1BLcWNmT2F5K0pyZ1UyTGZlYmZwczE5bjYrMzMrY3VTMlBYb2J4WkJH?=
 =?utf-8?B?MW8rVUErYlpxN2lZNnNzbXNEb0FWWGlhSHhxZzhKdjlTZmdJZXRWZCtGSDhD?=
 =?utf-8?B?OHZQcHZkQ2pac3ExZUk3bDAwS1doaXAwRVgxWlN1Vno0L2M1VEdLNkM4bnlW?=
 =?utf-8?B?WThNTWFlb2I3L2o0ZVIvcmR4VndZSC91RnVJUjZTRXdUMnpVNWlnYmUyWi8v?=
 =?utf-8?B?WWNRa0ZjUWw4VVd6ZHJkYnpueG8xeDFXMnYwaDRiUW0rOG9lRWFHSnoyM053?=
 =?utf-8?B?dGVKUGVDOTh6OEwvV1d3cy84T1JXWHRVTWJWWFNPc2tsK2c1TGI4SHEzcUoy?=
 =?utf-8?B?Q1hXQlkrdU5xbXpvS3M2YUN4aGE2MEJYVzQ2MUUvcG1vRlc3Qy9VeGpUbFdv?=
 =?utf-8?B?S2VDNnZWNlNGcW84MTVMNHdyZ3NRZ0hPN0YvV3hWZFM3YmF2OExPVU1UdlQ4?=
 =?utf-8?B?NURTbWN4dzFSR2RpUFp2TiswRlNkblR2cHE5dTJDWmZLRmNSR3NMOGlEelk1?=
 =?utf-8?Q?KZOAhDd5zon/h/XjC3nIYpcrB3xrWQ7q?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUx5QlkzOStJRGphSkZWeXB4Wk1WMGhZUzB2MjFZTE1jVHRLRWVZU1psay9F?=
 =?utf-8?B?SWZhVkZtWnNzdGpEL0VFMUhtZEhtdEdjNmJGeC9EcEhSem85cXVnbU1tMUU4?=
 =?utf-8?B?bWV3Nmdsbmt3QkUwVnhJOXoyQ01QL3FvMDkvVlBQZFRSdEhoMzZTOGNHbHR4?=
 =?utf-8?B?Um9Ta3h2N1E4aGsxN2s3MGVxb292QU1ZRnVuQ3p0ZjZTRGx1TTZSVkpsdFhN?=
 =?utf-8?B?b1ZDNTJ1K3VvTml3cDVhOFZ0dzNDeExrNzlkWlJlTzVXSDZZTTBMZlIzS3ZD?=
 =?utf-8?B?cXJPMnA4a1ltRkdKMUVUazdUUnFVMHd4THRhRktubXhCeS9YWWZqZ1pCTXNO?=
 =?utf-8?B?eWJUeUtBdmdjYjBPd2o2UmpuejFLb0JJb3ZuWVBZVDZHK1FHWUJKbGZTRnQr?=
 =?utf-8?B?bk5qWXBkNUNiMGZsTURlbGlNVVFFeHNJdlBRNWNuRFIrUCtPY2RHUFAwT3lJ?=
 =?utf-8?B?cFpocUl3dUhXQjZqcTlWWU11aVlNOHVORFhGUHgxOXpOMlJZNXJsdzl6K3h1?=
 =?utf-8?B?eGtrS2JrTFZDTW1heUV4SzBnTldvNjE5cjk4azVLTEhQQU5HZE85SlduWnBH?=
 =?utf-8?B?ZzFHVGNlY1FwSWZpOWkvMEpXeFVaK2FNbHJBZlVqM3lScTdwUE02aktCODVp?=
 =?utf-8?B?Wk5xQVBWQVAxdy9oR01oWlg2MVp0YXZCVGgwWnlwcTIzS0NVTW1KSUc5THk2?=
 =?utf-8?B?M1RRRzQ1SEp3RDlLRWFqbTk2Y0gwUTdEM2w4b1dWaFk4TDdmWndYTTZXL0dD?=
 =?utf-8?B?a0dqcTZIR2hsVHcxb2NxM0RNUmpsa0Y1RnhBTU91SWc1VXRxK1ZOdk80c3Js?=
 =?utf-8?B?WkJjSUFONzNxQUNXNEVoMUc5MkU2VHN3OHFqWXdJdmdlT1loZWU0ZWc3MVlF?=
 =?utf-8?B?eVFTNnNwZ2s4eGgyOHg0MXFvYk0xUSt4dTRTU3h6VE9oc3dhbDRtQWJ4RUN2?=
 =?utf-8?B?dDNUQUlmZkt2a25YZ0o1clFSSFN0Nms4T2x4bGlmRHR3UXNMdnZialYyYUZ2?=
 =?utf-8?B?SjZla3ZMNnN5UmZTdG9aWnBzblZKeS9zRlozcnJ5aWJYSGhlaTNNOTlrcEt2?=
 =?utf-8?B?Ym5PVUwvUzAzK3pPNGdBWXE5dXBIZHZRak80K0t3L21TSUZGNi81YjZhUWpp?=
 =?utf-8?B?Ni81RmZqUVNDOWpuUHQzQVRoVEdNK0dTRHZNdmhwVzQweThvR3F0cStVM2N1?=
 =?utf-8?B?MERESTVRZWVzb0lhVG1neUhPUXZMeVNyNXArUTZ1U3J4Y2ZsNVdTbUdXa1Ax?=
 =?utf-8?B?QTRlU3oxaGFnN2lSa3BRZ2FPOVpFbHovWnpwQlE1TlcvS2wyZmd6RStiVzQr?=
 =?utf-8?B?M1llUTM0cUFFajVGMW02TmlwMVp3bXFmZDU4TW1obFhIQTFkV21aVGozTTRX?=
 =?utf-8?B?Q3dEcjNDUytFZUN6dEkybFV6YUpFdldxaHBabGNyTndRTVZJMmxLSmJXUGFX?=
 =?utf-8?B?QW04ZlpLYk12ZGtubHdLUzdoNXlxc21VbGZIemM5c29rZVM1R1JFdDloZEVP?=
 =?utf-8?B?dC9oY2lJczdzYVNCZ3R0WHNmTG9oeGVPYWg4aUFrM055eHBqdGtiaHowdUhj?=
 =?utf-8?B?WmNSNzhoMHoyM0NMcHhUTmpEajNNZWF4eG51WHl1ZFpaQTBXVmN3RmFaaCtn?=
 =?utf-8?B?d2h2eVUyU28vbEJTWlFoV09lZzhTMER1VjlYSkFTaERFdlRYTHlUN3Q0SXlY?=
 =?utf-8?B?UmV6MkZmWllCdHR5YWZkckN5Tks0ZzJVZ0NFTnVFZU40WEMwdXUyRWVVVjA0?=
 =?utf-8?B?eTZyVWFXYUZMVWlnWFpDOUlDSk5CRlBhSndUcW95N2NRNXE4cTlqZTJtTmFz?=
 =?utf-8?B?V0NpLzczUEJIVFhwa2JLbElUWnZ6cnJ5VnBZeTdPUlNVQWlMeXFvS2JGb281?=
 =?utf-8?B?WU8yWFRBczNpNzhUSk1ZRW9JbERQNlRBdllmRVBjQUs1S2kydlFLLzZyVEhz?=
 =?utf-8?B?N1BuUVNKTFY3bG9qa1hhQWdiWGJROCtWazVPdEdYNGZZcFRJWVF2WEQ5cDZN?=
 =?utf-8?B?RTNjYzN1d2tNQlhtNjFGQ2FPMjF5aDY0cnQwRjBGTlBmZGNOeEtERjU1OFAv?=
 =?utf-8?B?S015bVNhMnVMZTY0U0g3ZmZwdUZwcjFOS29JbU5BaTJYZEtkcFRreXNTblVP?=
 =?utf-8?B?SHNDcE5wQ0YweThEdkk5VXpNRHpWczJERFZsWGhMc1k1S3ZXcmllV0pRZ0Rl?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38285d52-0d31-426e-61a5-08dd9cfdcaf8
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 09:06:40.5524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksPgjc57Mnk8YRJRH5c0CYcEH8+cVi7PqmkXppgDGiiTxbD0WEBKY6aYFMuJK3L+xj6LziSfd17WOqFOYy4YBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4529
X-OriginatorOrg: intel.com



On 5/27/2025 3:35 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 20/5/25 20:28, Chenyi Qiang wrote:
>> A new state_change() helper is introduced for RamBlockAttribute
>> to efficiently notify all registered RamDiscardListeners, including
>> VFIO listeners, about memory conversion events in guest_memfd. The VFIO
>> listener can dynamically DMA map/unmap shared pages based on conversion
>> types:
>> - For conversions from shared to private, the VFIO system ensures the
>>    discarding of shared mapping from the IOMMU.
>> - For conversions from private to shared, it triggers the population of
>>    the shared mapping into the IOMMU.
>>
>> Currently, memory conversion failures cause QEMU to quit instead of
>> resuming the guest or retrying the operation. It would be a future work
>> to add more error handling or rollback mechanisms once conversion
>> failures are allowed. For example, in-place conversion of guest_memfd
>> could retry the unmap operation during the conversion from shared to
>> private. However, for now, keep the complex error handling out of the
>> picture as it is not required:
>>
>> - If a conversion request is made for a page already in the desired
>>    state, the helper simply returns success.
>> - For requests involving a range partially in the desired state, there
>>    is no such scenario in practice at present. Simply return error.
>> - If a conversion request is declined by other systems, such as a
>>    failure from VFIO during notify_to_populated(), the failure is
>>    returned directly. As for notify_to_discard(), VFIO cannot fail
>>    unmap/unpin, so no error is returned.
>>
>> Note that the bitmap status is updated before callbacks, allowing
>> listeners to handle memory based on the latest status.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Change in v5:
>>      - Move the state_change() back to a helper instead of a callback of
>>        the class since there's no child for the RamBlockAttributeClass.
>>      - Remove the error handling and move them to an individual patch for
>>        simple management.
>>
>> Changes in v4:
>>      - Add the state_change() callback in PrivateSharedManagerClass
>>        instead of the RamBlockAttribute.
>>
>> Changes in v3:
>>      - Move the bitmap update before notifier callbacks.
>>      - Call the notifier callbacks directly in notify_discard/populate()
>>        with the expectation that the request memory range is in the
>>        desired attribute.
>>      - For the case that only partial range in the desire status, handle
>>        the range with block_size granularity for ease of rollback
>>        (https://lore.kernel.org/qemu-devel/812768d7-a02d-4b29-95f3-
>> fb7a125cf54e@redhat.com/)
>>
>> Changes in v2:
>>      - Do the alignment changes due to the rename to
>> MemoryAttributeManager
>>      - Move the state_change() helper definition in this patch.
>> ---
>>   include/system/ramblock.h    |   2 +
>>   system/ram-block-attribute.c | 134 +++++++++++++++++++++++++++++++++++
>>   2 files changed, 136 insertions(+)
>>
>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>> index 09255e8495..270dffb2f3 100644
>> --- a/include/system/ramblock.h
>> +++ b/include/system/ramblock.h
>> @@ -108,6 +108,8 @@ struct RamBlockAttribute {
>>       QLIST_HEAD(, RamDiscardListener) rdl_list;
>>   };
>>   +int ram_block_attribute_state_change(RamBlockAttribute *attr,
>> uint64_t offset,
>> +                                     uint64_t size, bool to_private);
> 
> Not sure about the "to_private" name. I'd think private/shared is
> something KVM operates with and here, in RamBlock, it is discarded/
> populated.

Make sense. To keep consistent, I will rename it as to_discard.

> 
>>   RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr);
>>   void ram_block_attribute_destroy(RamBlockAttribute *attr);
>>   diff --git a/system/ram-block-attribute.c b/system/ram-block-
>> attribute.c
>> index 8d4a24738c..f12dd4b881 100644
>> --- a/system/ram-block-attribute.c
>> +++ b/system/ram-block-attribute.c
>> @@ -253,6 +253,140 @@ ram_block_attribute_rdm_replay_discard(const
>> RamDiscardManager *rdm,
>>                                              
>> ram_block_attribute_rdm_replay_cb);
>>   }
>>   +static bool ram_block_attribute_is_valid_range(RamBlockAttribute
>> *attr,
>> +                                               uint64_t offset,
>> uint64_t size)
>> +{
>> +    MemoryRegion *mr = attr->mr;
>> +
>> +    g_assert(mr);
>> +
>> +    uint64_t region_size = memory_region_size(mr);
>> +    int block_size = ram_block_attribute_get_block_size(attr);
> 
> It is size_t, not int.

Fixed this and all below. Thanks!

> 
>> +
>> +    if (!QEMU_IS_ALIGNED(offset, block_size)) {
> 
> Does not the @size have to be aligned too?

Yes. Actually, the "start" and "size" are already do the alignment check
in kvm_convert_memory(). I doubt if we still need it here. Anyway, in
case of other users in the future, I'll add it.

> 
>> +        return false;
>> +    }
>> +    if (offset + size < offset || !size) {
> 
> This could be just (offset + size <= offset).
> (these overflow checks always blow up my little brain)

Modified.

> 
>> +        return false;
>> +    }
>> +    if (offset >= region_size || offset + size > region_size) {
> 
> Just (offset + size > region_size) should do.

Ditto.

> 
>> +        return false;
>> +    }
>> +    return true;
>> +}
>> +
>> +static void ram_block_attribute_notify_to_discard(RamBlockAttribute
>> *attr,
>> +                                                  uint64_t offset,
>> +                                                  uint64_t size)
>> +{
>> +    RamDiscardListener *rdl;
>> +
>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>> +        MemoryRegionSection tmp = *rdl->section;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            continue;
>> +        }
>> +        rdl->notify_discard(rdl, &tmp);
>> +    }
>> +}
>> +
>> +static int
>> +ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
>> +                                        uint64_t offset, uint64_t size)
>> +{
>> +    RamDiscardListener *rdl;
>> +    int ret = 0;
>> +
>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>> +        MemoryRegionSection tmp = *rdl->section;
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            continue;
>> +        }
>> +        ret = rdl->notify_populate(rdl, &tmp);
>> +        if (ret) {
>> +            break;
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static bool ram_block_attribute_is_range_populated(RamBlockAttribute
>> *attr,
>> +                                                   uint64_t offset,
>> +                                                   uint64_t size)
>> +{
>> +    const int block_size = ram_block_attribute_get_block_size(attr);
> 
> size_t.
> 
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>> +    unsigned long found_bit;
>> +
>> +    /* We fake a shorter bitmap to avoid searching too far. */
> 
> What is "fake" about it? We truthfully check here that every bit in
> [first_bit, last_bit] is set.

Aha, you ask this question again :)
(https://lore.kernel.org/qemu-devel/7131b4a3-a836-4efd-bcfc-982a0112ef05@intel.com/)

If it is really confusing, let me remove this comment in next version.

> 
>> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>> +                                   first_bit);
>> +    return found_bit > last_bit;
>> +}
>> +
>> +static bool
>> +ram_block_attribute_is_range_discard(RamBlockAttribute *attr,
>> +                                     uint64_t offset, uint64_t size)
>> +{
>> +    const int block_size = ram_block_attribute_get_block_size(attr);
> 
> size_t.
> 
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>> +    unsigned long found_bit;
>> +
>> +    /* We fake a shorter bitmap to avoid searching too far. */
>> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
>> +    return found_bit > last_bit;
>> +}
>> +
>> +int ram_block_attribute_state_change(RamBlockAttribute *attr,
>> uint64_t offset,
>> +                                     uint64_t size, bool to_private)
>> +{
>> +    const int block_size = ram_block_attribute_get_block_size(attr);
> 
> size_t.
> 
>> +    const unsigned long first_bit = offset / block_size;
>> +    const unsigned long nbits = size / block_size;
>> +    int ret = 0;
>> +
>> +    if (!ram_block_attribute_is_valid_range(attr, offset, size)) {
>> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
>> +                     __func__, offset, size);
>> +        return -1;
> 
> May be -EINVAL?

Modified.

> 
>> +    }
>> +
>> +    /* Already discard/populated */
>> +    if ((ram_block_attribute_is_range_discard(attr, offset, size) &&
>> +         to_private) ||
>> +        (ram_block_attribute_is_range_populated(attr, offset, size) &&
>> +         !to_private)) {
> 
> A tracepoint would be useful here imho.

[...]

> 
>> +        return 0;
>> +    }
>> +
>> +    /* Unexpected mixture */
>> +    if ((!ram_block_attribute_is_range_populated(attr, offset, size) &&
>> +         to_private) ||
>> +        (!ram_block_attribute_is_range_discard(attr, offset, size) &&
>> +         !to_private)) {
>> +        error_report("%s, the range is not all in the desired state: "
>> +                     "(offset 0x%lx, size 0x%lx), %s",
>> +                     __func__, offset, size,
>> +                     to_private ? "private" : "shared");
>> +        return -1;
> 
> -EBUSY?

Maybe also -EINVAL since it is due to the invalid provided mixture
range? But Anyway, according to the discussion in patch #10, I'll add
the support for this mixture scenario. No need to return the error.

> 
>> +    }
>> +
>> +    if (to_private) {
>> +        bitmap_clear(attr->bitmap, first_bit, nbits);
>> +        ram_block_attribute_notify_to_discard(attr, offset, size);
>> +    } else {
>> +        bitmap_set(attr->bitmap, first_bit, nbits);
>> +        ret = ram_block_attribute_notify_to_populated(attr, offset,
>> size);
>> +    }
> 
> and a successful tracepoint here may be?

Good suggestion! I'll add tracepoint in next version.

> 
>> +
>> +    return ret;
>> +}
>> +
>>   RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr)
>>   {
>>       uint64_t bitmap_size;
> 


