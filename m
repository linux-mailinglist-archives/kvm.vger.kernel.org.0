Return-Path: <kvm+bounces-41168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E08A1A6430A
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:12:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 338131680E0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 07:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347E821A931;
	Mon, 17 Mar 2025 07:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UlaUQNr0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A86118A6B5
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 07:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742195569; cv=fail; b=EAYxujSta4DDmtoj27R9gj2SSSU1oegBF7LCJQJWqqrD2Brp9xuwLnyx/JewFd5i0knk+gWoUlIbf7yOVZCjWNmWZnWGg0IZMm5HeK3spF1QreVxGntYi0kyhEPkdHXPoO1/vR4btB3dnM7H/L3sVFL5nIDU4rtCWJsb1WHhjK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742195569; c=relaxed/simple;
	bh=OZDyQF3yJ7ZeCKiqOy8pG+aUmM1wzHWVRrWdvJ3wScA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NE4jqA7fa5EHH57vwdqkuGlTUtqlHpOJxyD86y9LUzwqS57oZG/8bep3l4KIlJ6jBqIznxDZGW3/ORYovpOONcEVDZ3/8UOa3aUMxMF62tssn4zLYlAFWd/M3kWaCkxI/mcDIR17oSqlNvaIe4Xa/jcqZMrqCrenWPmej25cUuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UlaUQNr0; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742195567; x=1773731567;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OZDyQF3yJ7ZeCKiqOy8pG+aUmM1wzHWVRrWdvJ3wScA=;
  b=UlaUQNr0AfyXwtktGxwtMSGcLMhfJ90FJAHGnGFpE47VWDHPy0PG4oAt
   cAtQ32dfGjtVs4LNriLGloKIwlDhz+dW4QOdPrpgbGMPeEfSWc/krJTHT
   a+1MbGklfZ9f/zoW4nrXGuwL5PiyFi3v6jgIAFDMeC4/FkJH656oywQKq
   KYCzFl3wvxhPcli2JbAp54HosMj5iP/tpOKMdEmZZByXiVFGKwYXPnF5a
   Te45aKgIRDTKpbImbFVuDNwSEUBFcDS+7AHcYmyXd5U+fGxvtxPoc2L44
   RRLettxYClDi+ofJyglfkEN2nQfVw7JRVzGcEL2aajht9sw5rUpvuwHz5
   Q==;
X-CSE-ConnectionGUID: Hqr9iaQuRnC98PRin6j8gw==
X-CSE-MsgGUID: YIsNRq5KTmaTvin2jcZ0zA==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="47054588"
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="47054588"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 00:12:46 -0700
X-CSE-ConnectionGUID: ubbHSNzESuatcTaJhrja+w==
X-CSE-MsgGUID: n3JOVPLjSfCSoeXjF6Ky2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="152727621"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 00:12:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 17 Mar 2025 00:12:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 17 Mar 2025 00:12:46 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 17 Mar 2025 00:12:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EdeNknJeZuofDRCSa6FogCM1FQVlaAErBAfOF4/othqmkriIgrZfvWRYtLvsUciPOA32S5G8rxhoyGtUkE5VnMdiwP7hf++idiDdiUFgrY/Kcs1w4575LCwbLtCX03YPJPsj5BB5QAC4yEd0peUb++LOy+aMD67ljw91DF5xx+qnNP0i1QMXm3LBimr6hGh8oDuMeM1g3YqAfBe9S4P2fVohSW3riPER470h6MF+wnJWJSH5+MEp8bV4pUGSzrGEgyaNRe3gAuEEQaJfmsWRQozZnFDbfd/liCnh5PDKJVOKuwtqk0aQNmIHc2p+LmrmWtpkNyoZJUriI8AOsbUeKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kapbG/M5mZ4djQlfk9I0vBEYRn1RtgAztKgS/dMojyI=;
 b=Rm4WMGlONu7/sQm1eGgi9wmSdaHP4GXe20rUl0C8blIc0ktGTAO6MakYLNCqyJrgmy+ma6su3ys5429CGBsx70lOz4+Mkx0xt8O4GnqTc+oFyWwDBabWLzBsFcXFXpVIKyUTfX4KXIAiggO6/qVRWAfzf1clkf1dy8F4pm5DlwwQhB+NtZFFHLTR/xCr4JBDnV0udXxQxGFENwYflQaszc8CFtbCo7xRsqwMH570O9ST0FzCOstOhZFapnLUTZoQSH7aujplD/KVX8aXDapNbAMa3TDBtQaFLr8ofaHLkfSOmLppu5zze3qjaPcjEp+DhIqjsXeBQb2N9eW8QY4fyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB7104.namprd11.prod.outlook.com (2603:10b6:303:22e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 07:12:43 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 07:12:43 +0000
Message-ID: <684923e1-f0f9-48e4-9fa1-7729b56854ed@intel.com>
Date: Mon, 17 Mar 2025 15:18:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
To: <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>
CC: <jgg@nvidia.com>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<zhenzhong.duan@intel.com>, <willy@infradead.org>, <zhangfei.gao@linaro.org>,
	<vasant.hegde@amd.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20250313124753.185090-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0027.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::7) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW4PR11MB7104:EE_
X-MS-Office365-Filtering-Correlation-Id: 49076ddf-9070-4c05-d1c1-08dd65231c7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NHlCZkRUM3ZMLzNCaDNaSWJabW9tUEoybEdRQkMwSTg5eW5tY0xOVXhYdXBL?=
 =?utf-8?B?MElxSmFjV0hzRnVNbFNUd1pDc21wUTdiUkw2M0gzSndJUXVjVlNZZmYvSHg4?=
 =?utf-8?B?SXF6YzZtUXdLdXZ4TklvejV6WVQ1Vmowb29jelNaVjV1eU00VGh3bWdkMlQ5?=
 =?utf-8?B?TzBEejNuZUhSaTFqS2xSYi8wenE2YUtSaWxSMnp0NmxPdFl2Q3k2ZlBDdmN3?=
 =?utf-8?B?aEdNRndwN2VWOVFRSW1WWnFWVDlVZ2FFcHBiZjhhSDhWdlVWSUVJLy9tSnlQ?=
 =?utf-8?B?WlkrTXZHOEI0dUxTTDhsbzB2L3NXRTV2REpTRHBycHYwd2M5Q1E2WTl1djMy?=
 =?utf-8?B?NTN6R0hpdG9NenA2eFdTeVk3NU1WS25wRmtCNXpVdDdsd3RPYUZaQmZEUUhX?=
 =?utf-8?B?ay9CTy95dXNaWkdxZ0lQcVFCTklMQS83U2tKUVNLOTJlNk9sOGZVRGsrSk92?=
 =?utf-8?B?NjhmS0Zna05uM3NSbTdZalBrZGFVNkVIR0o4eE8rcUVTb0xGNDJmY3l4Nll6?=
 =?utf-8?B?YnBwejMwRk1HRFpabldZS1BmSm1JSEtXR1ZVdk8rZVlHM0RLQTBBV2hvOXNp?=
 =?utf-8?B?enArT1JrUXdsVW9GVTBqdVloOVl1eUhDS3NRZytKUUw0cGx1Nm1oQzlKMnEy?=
 =?utf-8?B?bFcyTGNQZkViZGZ5aXBZU1E4YnFZY2NwOU15TDNyTFFsamhTdzFTbU9HT0hI?=
 =?utf-8?B?Z0dJQytqUkJGeG0xZzhHa1RNWXpLNk9saTNJbW1IQ084UktMeDNVZTZwK2FS?=
 =?utf-8?B?NGh4UkFxc2FnWGRJOWFXWlAwckpBb1dQeGJtSXhOT3lQNVIzditWQS9vdy8r?=
 =?utf-8?B?bTRMU2lwZW1DcWxYb3VocE8vczNYZGNOdTBhNzlobUdVWGJBWjFDMm5Ld3NG?=
 =?utf-8?B?SnZXRjRRak5GSEtadDcrU1RVQ3Y2RU9EV1Bob3hBb1ZRSy9wQU9wYVpORUR0?=
 =?utf-8?B?NDRRa3huU1VaWE1SSXNVb29XeUEweitiT1Q3ZVVnOFdqS3lTbHVqcCtVVjZC?=
 =?utf-8?B?UU5PRWxFN2swNk5EWjJuZmVId2JGREgvUWpHWSswbGFIMEtQS1JPOWtETkc5?=
 =?utf-8?B?TjhCZGRJc09aZ1lzbjZNaXJ0c1BoTzFZZGlnZ1d3dGdNOFRRajBJNWNBekRx?=
 =?utf-8?B?M1k2RGJVbTY1VnpVbDlteTV4dGRoZFRQam5JWFU2aThzYUkvNXMyQmtPclM3?=
 =?utf-8?B?SmRXRENBV2ZFTVhBM2YwQlVoUzBPdGZZS3dHaHVQZU51T2ZtRWJ4RjlJNjV4?=
 =?utf-8?B?dGxjN2tpTEc2SkpXOG9NL0JZUkVLOVJMWFhqRVJsOUdUbFhCVm1tL1o1SlBq?=
 =?utf-8?B?K0RraWNTTHliVEpoM0Q1NFU2SXdRN1EvcU8xRVFnejFsOFFuWFdidjFNQmNl?=
 =?utf-8?B?N0lrV3RhZENRY01GYXRySTdkU2M1WUtGUUw2Q0ZJMkhmdW5IeU42NmRwVDNl?=
 =?utf-8?B?cXo2N3RDaDFiUTJRVzFhS0Yvb0lYaytBMUxKR1YyTGtPY0VCNlVHRFlwa2FN?=
 =?utf-8?B?TTdxWDF2L2NGdEszZHpRc0NWSG9YOGcreEdKcUxlRENqeGZPaFhyRzhuRFA1?=
 =?utf-8?B?ZDR4eEdxQWlmb05IOFVQNXNtbUp3MzVnR3EvcW5zcEdzL1h5SDFrNDdUL0l0?=
 =?utf-8?B?TVdycmtiNTlDS0M2UEJ5YzJUSVJHWUM4L0U5YkdCcEF4UG1LWGpkbExzZzVX?=
 =?utf-8?B?N3lZMWpMZWJNQUsrZzdPMzBZcEx4dGRNMUFnVUxYRUtEOFk0VmNwYlhEWUdH?=
 =?utf-8?B?RVVtdzczUlRQaFdxV2ZzZG51ZzRCZUc4ZWlId085UFRmcEtRSHYycE5PZnR3?=
 =?utf-8?B?TXliSlhaMkdxaDlNOU1KTnpBZnZ5N0lrNDBEazV4K1M1ZXh1Z0s1aWZhRVNQ?=
 =?utf-8?Q?uDbIOmrJtmGIU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enljWXhnTkNvazFGYlFVNElQM1puelA5b3VQckFtVUgvTEZENVhRczFYdllu?=
 =?utf-8?B?b1VvaU5HUFZIR1VIb2l6TEQwN0YxclFwV1h0cXVscUNNa2o0Z21ONXZmbWlt?=
 =?utf-8?B?L3ZncVdOUzV6bjlrQURJNVNVVTdWMlpXUGUzZHVtbVYvSUlicUw3U2w4K2dY?=
 =?utf-8?B?WmdNa2FTTG85V01nZUYrUFV3bEVNTFNIclFpU3BrUkdrVklsV0M2MU9PWGo1?=
 =?utf-8?B?cWovc3Z6MVQvZy9rR1VFbXNLNE5aQXFaaTBlMTd5ZnNTUE1aQUFTZ05qQjJF?=
 =?utf-8?B?TlpLMWUxU00wQ2hldlY0aEhTWEVTc1dES2V1M29RNWpxWXRPdVRXQkdGd1Y5?=
 =?utf-8?B?QTlFTHFtMkUydmJLQ2ZqYUZxM1RQbFA5OWNqaDdpL3VQYUV1UVY4bExDUGdp?=
 =?utf-8?B?Wm1XbXBXYlVnOGdjZjRUbW1YYnBxWTNORnB0eUhScW01dzA1d096MDU2R1Zr?=
 =?utf-8?B?ZnJIT25rbTRaUVF3azRZUjJCTGN2dmRXK0JVNlMxNkFnOFR6NnNYSm94ZXpu?=
 =?utf-8?B?dU9FLzRKMlNDUkRqczB5VDJzSGV0MFZqcHZYYVI5TUx5aFN1SzlqZDhiVEtP?=
 =?utf-8?B?UmNmbXV3cmp2Vjl1WWhsMnRHZ1BDbUZpVEp4MUhPam9JczRRSGdFNkx6YVRo?=
 =?utf-8?B?alk1Q0o0L2NOaVJsY0RCaEdYRHQ3SzdHeUYxUGtHNE00M2o2M1BBYnlQVUdS?=
 =?utf-8?B?RjArSmxkSFdmeCtUNmZob0pNZnF0NmpPMDZvZGtidGxlSVc5WnRxc09HZi95?=
 =?utf-8?B?NGhVcmpUNFlpSmpjczlUNzlXTEU0STQzdjcyN05yTi9oVmkzZmtKT29lc2Y4?=
 =?utf-8?B?K2Zzd0x2cHhpNWJLSlVyZTNRZzJRcHRjcnNzMVhzdCtkTnhwcGtkRWl3VHox?=
 =?utf-8?B?QXZ5a3cvektZNE1TcG8rUEV4Y2YwenY2U2h6b1NkQWpFdUFwZzV5ZjVjMHJD?=
 =?utf-8?B?RFFpOXFUS3lLZThIa3puV0UxMkQ2WjlBYmVCaUl4Ry9ETEtJZWh4UkcxeGJw?=
 =?utf-8?B?QUpxQ3Q4SnNVd3cwV3FiazZ4V0d5QWVRTURIazBDcDZLaUVuU3hBKytPSkt3?=
 =?utf-8?B?VCtROTZVMFN2Q1pheEpZdnkyNkJrMUtOR2wxZ0RIL2dzc1pncGhRUmNvRDBL?=
 =?utf-8?B?SG11dkpIMWZleFRwWWkyZWhLdzZGYTl4cmVueldnNnJMMVYwU1VSYjFTdUJJ?=
 =?utf-8?B?ZkhTMzdOZjZnWFdibCtpYnJZaEllcEQvb3VBQ3NIcis3SVVMQVBCczdPU0Ny?=
 =?utf-8?B?UHFjU01XMjJtZHlLdmcvNFFOcXRJd0hhdGl0SlJRQ0NwOFNsMEJMTXdVOVdr?=
 =?utf-8?B?L1BUY083Yk9GN3ZhdWhGTXhCTzkvRUF4Q1kwT25wdTVlS3lRZVZkTC9mVDc2?=
 =?utf-8?B?SEQ1enB1VS9hNldqS2EvRUE2TEcrTURsY3V5K1NjZXp1dzBzUkc5RzBTZVAx?=
 =?utf-8?B?eG9YYkVvaTUrMFE1TEpQS0gzWWdxV29IbUk0V0pTL1N0d0Vrb05TWnNCNlEw?=
 =?utf-8?B?VTVtYyszbldkbEtHNXFTV2RhUVBDcFRzbnRtN1BHbWtzQ0NXVnIxUjVuejNn?=
 =?utf-8?B?Wm1vT1ljSno2M3JTc1RjRGFCcEw5V0o0cE9KL3l4K1M0dTFyOU0wWjlacWRE?=
 =?utf-8?B?MjdiMnRGMWdYNWpJb2M5dUhCVFh4dXQ4TFVSRTNuQmJQeFhUZHZGU0w2N05j?=
 =?utf-8?B?KzNmbTMvQUNUVEppYW1FelR5bWNUdEU1YkppeVlpOUtoQUVqbWZ2MzZzRzQ0?=
 =?utf-8?B?enBtZTBxemwxbFFYSTYwTFBGaHVEOUcyU01wSUExSjdUZWU1OVhNN2RvQUZ3?=
 =?utf-8?B?UGRaOGlwL0U1Mm1rVlBwRGhaZThOdlNpY1dOckVWV0twcFh0eEI2UlROVEtU?=
 =?utf-8?B?ZjNHQ3Y2eGF3MDRBdFFxR2MvWndvNGg1aUdRWjJnS2ZXakx0Wjg1cHgyV1J3?=
 =?utf-8?B?Qk5rczNLN1hRY3A1RE5vMXZzeGprRldtc1F6V0FXUzh5TmgxMmVJR0svb2Y4?=
 =?utf-8?B?dnExYjNhR0JCM3ljcjh6bEpnQllRMjYyYmNFejRQdFcyMHlJWkVXbnEvRmQw?=
 =?utf-8?B?cTFFcUV1Uzc3MGRCMWtuRzN5a0RWQndmNGt6WUtIQWRRTVBvZlFRMk1xS0o4?=
 =?utf-8?Q?8PnEYnAJQ8uyB9OaKeA9Wibow?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49076ddf-9070-4c05-d1c1-08dd65231c7a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 07:12:43.6064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMdu0FldMaHqiFe0xwPl88gAK7rxMpj5rPrqt6z8g95puFDxZNMDSFmXapEgL4/3LPzRC8Upu2zBeDsU2EHOUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7104
X-OriginatorOrg: intel.com

Loop Bjorn for the PCI part change.

On 2025/3/13 20:47, Yi Liu wrote:
> PASID usage requires PASID support in both device and IOMMU. Since the
> iommu drivers always enable the PASID capability for the device if it
> is supported, this extends the IOMMU_GET_HW_INFO to report the PASID
> capability to userspace. Also, enhances the selftest accordingly.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org> #aarch64 platform
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>   drivers/iommu/iommufd/device.c | 35 +++++++++++++++++++++++++++++++++-
>   drivers/pci/ats.c              | 33 ++++++++++++++++++++++++++++++++
>   include/linux/pci-ats.h        |  3 +++
>   include/uapi/linux/iommufd.h   | 14 +++++++++++++-
>   4 files changed, 83 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 70da39f5e227..1f3bec61bcf9 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -3,6 +3,8 @@
>    */
>   #include <linux/iommu.h>
>   #include <linux/iommufd.h>
> +#include <linux/pci.h>
> +#include <linux/pci-ats.h>
>   #include <linux/slab.h>
>   #include <uapi/linux/iommufd.h>
>   #include <linux/msi.h>
> @@ -1535,7 +1537,8 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
>   	void *data;
>   	int rc;
>   
> -	if (cmd->flags || cmd->__reserved)
> +	if (cmd->flags || cmd->__reserved[0] || cmd->__reserved[1] ||
> +	    cmd->__reserved[2])
>   		return -EOPNOTSUPP;
>   
>   	idev = iommufd_get_device(ucmd, cmd->dev_id);
> @@ -1592,6 +1595,36 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
>   	if (device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY_TRACKING))
>   		cmd->out_capabilities |= IOMMU_HW_CAP_DIRTY_TRACKING;
>   
> +	cmd->out_max_pasid_log2 = 0;
> +	/*
> +	 * Currently, all iommu drivers enable PASID in the probe_device()
> +	 * op if iommu and device supports it. So the max_pasids stored in
> +	 * dev->iommu indicates both PASID support and enable status. A
> +	 * non-zero dev->iommu->max_pasids means PASID is supported and
> +	 * enabled. The iommufd only reports PASID capability to userspace
> +	 * if it's enabled.
> +	 */
> +	if (idev->dev->iommu->max_pasids) {
> +		cmd->out_max_pasid_log2 = ilog2(idev->dev->iommu->max_pasids);
> +
> +		if (dev_is_pci(idev->dev)) {
> +			struct pci_dev *pdev = to_pci_dev(idev->dev);
> +			int ctrl;
> +
> +			ctrl = pci_pasid_status(pdev);
> +
> +			WARN_ON_ONCE(ctrl < 0 ||
> +				     !(ctrl & PCI_PASID_CTRL_ENABLE));
> +
> +			if (ctrl & PCI_PASID_CTRL_EXEC)
> +				cmd->out_capabilities |=
> +						IOMMU_HW_CAP_PCI_PASID_EXEC;
> +			if (ctrl & PCI_PASID_CTRL_PRIV)
> +				cmd->out_capabilities |=
> +						IOMMU_HW_CAP_PCI_PASID_PRIV;
> +		}
> +	}
> +
>   	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
>   out_free:
>   	kfree(data);
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
> index c6b266c772c8..ec6c8dbdc5e9 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -538,4 +538,37 @@ int pci_max_pasids(struct pci_dev *pdev)
>   	return (1 << FIELD_GET(PCI_PASID_CAP_WIDTH, supported));
>   }
>   EXPORT_SYMBOL_GPL(pci_max_pasids);
> +
> +/**
> + * pci_pasid_status - Check the PASID status
> + * @pdev: PCI device structure
> + *
> + * Returns a negative value when no PASID capability is present.
> + * Otherwise the value of the control register is returned.
> + * Status reported are:
> + *
> + * PCI_PASID_CTRL_ENABLE - PASID enabled
> + * PCI_PASID_CTRL_EXEC - Execute permission enabled
> + * PCI_PASID_CTRL_PRIV - Privileged mode enabled
> + */
> +int pci_pasid_status(struct pci_dev *pdev)
> +{
> +	int pasid;
> +	u16 ctrl;
> +
> +	if (pdev->is_virtfn)
> +		pdev = pci_physfn(pdev);
> +
> +	pasid = pdev->pasid_cap;
> +	if (!pasid)
> +		return -EINVAL;
> +
> +	pci_read_config_word(pdev, pasid + PCI_PASID_CTRL, &ctrl);
> +
> +	ctrl &= PCI_PASID_CTRL_ENABLE | PCI_PASID_CTRL_EXEC |
> +		PCI_PASID_CTRL_PRIV;
> +
> +	return ctrl;
> +}
> +EXPORT_SYMBOL_GPL(pci_pasid_status);
>   #endif /* CONFIG_PCI_PASID */
> diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
> index 0e8b74e63767..75c6c86cf09d 100644
> --- a/include/linux/pci-ats.h
> +++ b/include/linux/pci-ats.h
> @@ -42,6 +42,7 @@ int pci_enable_pasid(struct pci_dev *pdev, int features);
>   void pci_disable_pasid(struct pci_dev *pdev);
>   int pci_pasid_features(struct pci_dev *pdev);
>   int pci_max_pasids(struct pci_dev *pdev);
> +int pci_pasid_status(struct pci_dev *pdev);
>   #else /* CONFIG_PCI_PASID */
>   static inline int pci_enable_pasid(struct pci_dev *pdev, int features)
>   { return -EINVAL; }
> @@ -50,6 +51,8 @@ static inline int pci_pasid_features(struct pci_dev *pdev)
>   { return -EINVAL; }
>   static inline int pci_max_pasids(struct pci_dev *pdev)
>   { return -EINVAL; }
> +static inline int pci_pasid_status(struct pci_dev *pdev)
> +{ return -EINVAL; }
>   #endif /* CONFIG_PCI_PASID */
>   
>   #endif /* LINUX_PCI_ATS_H */
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 75905f59b87f..ac9469576b51 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -611,9 +611,17 @@ enum iommu_hw_info_type {
>    *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
>    *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
>    *
> + * @IOMMU_HW_CAP_PASID_EXEC: Execute Permission Supported, user ignores it
> + *                           when the struct iommu_hw_info::out_max_pasid_log2
> + *                           is zero.
> + * @IOMMU_HW_CAP_PASID_PRIV: Privileged Mode Supported, user ignores it
> + *                           when the struct iommu_hw_info::out_max_pasid_log2
> + *                           is zero.
>    */
>   enum iommufd_hw_capabilities {
>   	IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
> +	IOMMU_HW_CAP_PCI_PASID_EXEC = 1 << 1,
> +	IOMMU_HW_CAP_PCI_PASID_PRIV = 1 << 2,
>   };
>   
>   /**
> @@ -629,6 +637,9 @@ enum iommufd_hw_capabilities {
>    *                 iommu_hw_info_type.
>    * @out_capabilities: Output the generic iommu capability info type as defined
>    *                    in the enum iommu_hw_capabilities.
> + * @out_max_pasid_log2: Output the width of PASIDs. 0 means no PASID support.
> + *                      PCI devices turn to out_capabilities to check if the
> + *                      specific capabilities is supported or not.
>    * @__reserved: Must be 0
>    *
>    * Query an iommu type specific hardware information data from an iommu behind
> @@ -652,7 +663,8 @@ struct iommu_hw_info {
>   	__u32 data_len;
>   	__aligned_u64 data_uptr;
>   	__u32 out_data_type;
> -	__u32 __reserved;
> +	__u8 out_max_pasid_log2;
> +	__u8 __reserved[3];
>   	__aligned_u64 out_capabilities;
>   };
>   #define IOMMU_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_GET_HW_INFO)

-- 
Regards,
Yi Liu

