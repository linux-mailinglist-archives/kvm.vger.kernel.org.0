Return-Path: <kvm+bounces-52330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 184E1B03F3B
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 15:06:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3F80189EB69
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68AF24BD02;
	Mon, 14 Jul 2025 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mReNOxvD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB0F23497B
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752498382; cv=fail; b=daxEBW5lMdTo48J76ewgGn071PERWoXvFTr4cxiAENtOl681jEt0v7xZN2Zwc6MMMb4nrmbD+nV58VOa8aQY5dcucmxq91BZMIj9Q8ePmRwM14folj0t4YoFetEt3S4dIvPLWglAg+Auu0DRWH9kdnTQdNBk4avEnODa30PvaTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752498382; c=relaxed/simple;
	bh=pj8ImJNDxi0hfozzgtZTOKpQGD2+DYV0pFwcERsxyM0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jpKtjddNpjIyoM7IsJvmUcmlyIppP2cny7AYOSz5ceydiOLjff7y5DKcNFj3t7LaWJdesFrzxUSnjtmbB06C4fISS6u6Zvkk7LTWNsw2N1ZOFJBTJgUySNT3DvdkxU7Z1LVYIgpZJpXbldKXDs7mLZhXDCR1lVil2xS+t61ca+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mReNOxvD; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752498381; x=1784034381;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pj8ImJNDxi0hfozzgtZTOKpQGD2+DYV0pFwcERsxyM0=;
  b=mReNOxvDP4mgZCW9nO48lkLtP6pi5Wifs2V02GXjloSyRsgI/j5/Z6G+
   Xi0QGtdStJmuAiODi7Ayp/ZbSbLjJlQ15YqLDwRdJFLX2GA3O2LhL4lht
   ai+bTVkZrJb5mEKJULRagoagwgjxLhPNfZFErqRW+NmAXMkBVY5hcFuUs
   BjfBIQ2FkWA12bPkA2U8MhzGF45UoiidVUHJkFFN3HvnHmfAc2Zr9wa2A
   GlQaLgUVjomc3ZWWLj4ykQcPL6QwH81ZCYq4sUl7Ey0NNVnhfbKcyqj+6
   DqFuz+qgLzH2PK638+N3mt950VHFyxLbDD0A2rhk1i2Y6hjO1q24O8vhh
   Q==;
X-CSE-ConnectionGUID: G7HB+xB1Ql24ba7HzJRYCA==
X-CSE-MsgGUID: yZbpzKW5RWiuyo9ecRJYvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="58498095"
X-IronPort-AV: E=Sophos;i="6.16,311,1744095600"; 
   d="scan'208";a="58498095"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 06:06:20 -0700
X-CSE-ConnectionGUID: p/WzwQ0rTEiaoZhJWvw8Mg==
X-CSE-MsgGUID: RCgg8Ax3QqKmVudfd2PUuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,311,1744095600"; 
   d="scan'208";a="162596726"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 06:06:18 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 06:06:15 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 06:06:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 06:06:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GgJqzZ6R/XSMq0scZ4oMo3THxvchLAhcSt5aWs4Yt0rg3Q2ptPCvBpZfxChidP/q2CYYh8+14hk8KnpRVD+2/MFVnz+yDCLVGVpVH/XoCNcCJ3t5YMEkBJ+20HOMoTnQolg9S27CdblSZSAoFGPwZCAl1qNI5drfvhZ1AmntxJCUpvRXHm4mCcHCiX3+2Nc966J0MwxCeClwkqNGscZXbIQdt9C/fNS8lct8T19G2fKWc1z+dd5ZtYtv33xwUxloXS+2NjX2vBmWug0LnJ14zxyzECjaRQBzpDOK8D40q8wAVARvck6YIyXYH+Pb3NJOiEa85TDT2cT9W+ln7tBFMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qACwrOoRVOn//PK5GvrS0vV0MbeEuQnISG9VrA2j8Rs=;
 b=RaNrO1RpDxdLkcyJQKwA5A6i0tAGTfHydoMsosDmS0WKNIOGEnJqRk0gMF5xBZ73vAf7rsb0WAkLzEoyhhg1vsf2L9zpQzvyrkOB3zQmZNJ0vVGbq/IjZMzxwwLCtyBpcyZ39YHrtjikvhp8mfy89sUdsGaG5XfHejpKyHoFE23ZvQ3oxW5Uxx8FeGg+5X/vbECHcWCJ+oOi3mmsgzAonzGkAC0wmgfehjafVlphMwczBfZXjnQNguykEc7uVnuceR/jHDEfwfKBgUFdFPyQWO2by5+OnVl+JZ/B9yT4WVJBbnusXYOH2zLbSj3KD71i0LNRkw1Z9/3iUeBxYhaPGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7339.namprd11.prod.outlook.com (2603:10b6:930:9f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Mon, 14 Jul
 2025 13:06:11 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::1289:ce98:2865:68db]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::1289:ce98:2865:68db%3]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 13:06:11 +0000
Message-ID: <a8484641-34d9-40bf-af8a-e472afdab0cc@intel.com>
Date: Mon, 14 Jul 2025 21:12:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
To: Jason Gunthorpe <jgg@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
	"Brett Creeley" <brett.creeley@amd.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, Kevin Tian <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, Longfang Liu <liulongfang@huawei.com>,
	<qat-linux@intel.com>, <virtualization@lists.linux.dev>, Xin Zeng
	<xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, Nicolin Chen <nicolinc@nvidia.com>,
	<patches@lists.linux.dev>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Terrence Xu <terrence.xu@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>, Zhenzhong Duan
	<zhenzhong.duan@intel.com>
References: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0048.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::17)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 06b0975c-3337-4a9b-464d-08ddc2d7346e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|42112799006|376014|7416014|921020|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWR5M1ZvZUlSc3didWdzSXRSMnBLdlRmdUx6TndPNGtFaDB4cmFublFXSkNE?=
 =?utf-8?B?UVZjRklsSGJRZUFWNGFGMVZ5WWNQc0lGUlhhcUd3dkNtaFVwOGphSHdZRVZi?=
 =?utf-8?B?Nm9SQmRCQmgxZDF2RUNpVXNvT05MM3NqRHliNWU5NkNid0xqbmhydlJlc0Z0?=
 =?utf-8?B?S3BsZEtMb1gwbXFqLzBBT1k5OEZGUWVXcDRYVCtpeGViSThLZ3FoZTFoVGpH?=
 =?utf-8?B?RmJEUHJ2SWxmc2lDZHZHRmRlY01CYUphUFFrNE9jNkc1YVFMTnRxaDNZOWMw?=
 =?utf-8?B?eGdaRVVDMmpRK1dKQXNkWmhzNjVRdDd2M2hvODlCWkRPN3h1cVpyV1lFL0kx?=
 =?utf-8?B?UnFCcW5yZHk1dHBZOHFIdUZYcDEwRHg2cFF3RjBzU3F2QVUvR0kzYkRZUHpY?=
 =?utf-8?B?K0JzS29uMVFVS2dZVm1zd2xpQ3VtSUhndkJrME5PbTRBbWJlYnZRWFY3ekQ5?=
 =?utf-8?B?M2JjVjBuUlRPVkV5S25RaStyVjBhT04wOWZPd2tKd3RGcjBNVjA3elROZGVW?=
 =?utf-8?B?MFNZaEVxRWhpR3Q2U0VyV1VGdUxPY0N5Y09QckJodnNKTVlPQTd6d1lYRmRW?=
 =?utf-8?B?M2MyZy9RSm9zdysycmsrOFZlL2VnVmtGaU9heXJQcEVUK09LdUk3WWhxSEV4?=
 =?utf-8?B?cjlQM2RYUTJoeW5rTjd1MGxwVTc0VHJlVDRMTUN2NXFXUURUdGtYS1huRHZR?=
 =?utf-8?B?enVoS01oMm5rUy9xNEU2QmpKUWwvR3g4S2J0MGVWUWVNanh0YjFKYWtSbkpi?=
 =?utf-8?B?ZzdUclppSzNsWHNla3pycS9janVnSVN6TFNqcXN2NGRsV0dxY1BEdnJlSGhC?=
 =?utf-8?B?OGVqS0xQK2pmd2hSRzUwU3E3aHhjL2dQTlA2MzFuNWpxQlFNbjBGdEQ5azlN?=
 =?utf-8?B?cXMzMXF3SjFSSW0vWWlaKzVLL09GR1VydE1jd084WkZ0TUs2dUVzVitXTjRM?=
 =?utf-8?B?ZE0zRkhraVBNbko4LzQ3VXlzSXQ5TTllS1YvRFNWTkFYQnZ2d2wzRXowT3Mz?=
 =?utf-8?B?NlV5Qy9TcWJiQnd5VTc5ZUIzbzdxZnk0aHBsdmhXMU1jTkx1THBpbHJXaG9E?=
 =?utf-8?B?ZTNjL1crdDBVZkxZYVBwSTlRTytxdzg5RWZzNzdxMmpUZy8wa0RsS1BodzJx?=
 =?utf-8?B?amdHZlhLZlFxWllselNhRWlwdWVHaXY2WUNWNldKQlpYSzA5SEtkL3FsU1du?=
 =?utf-8?B?KzZhN1lVekY4VzFmMDU2cXFZT0laNHhaby9PdWlZZzE2REFkdUhYeittSWhy?=
 =?utf-8?B?UWtUMlFRczM5UGkyQVNUQ2dId2U2elhjRm4wdHcrRGdDZVNROXYybFJvdU9U?=
 =?utf-8?B?R2tNQnpFMVlrYkR3ZHVaczRHbUhSWmZ4NE5tYzdoMTVuMTFTK3pVUWp5U3BC?=
 =?utf-8?B?eHFoVmRvR0o1U1hSWmdQWW9TM2RJSU5TeDRLVGRWYTIyOGRVMG1aOGZrZmpP?=
 =?utf-8?B?MVJBQ3NBRGVQRFd6ZElCUFRRYkVmakdsZndLK240UnM0eEx0WkFaaHg5QlZz?=
 =?utf-8?B?SDR4eEptZHRjTXlJdWZ6UFl6U3ZkZ2NDR3hDeUpVQ0h3clZsUUNnZ0F6SzNo?=
 =?utf-8?B?QUNVZ1owbFlVL2xzaXNnZG0zNStaMnBWeXdmVWdmdzFKK3B0SmMxcENQN0dK?=
 =?utf-8?B?cWVTWDN4cmJvSmc2ZDJxZWozU3dWOEZzaVVkQjlsSXhjcmlkMjFPVWt0MHRL?=
 =?utf-8?B?eDBmNjlYemovSjZpeGQ3dGNkWGVKSVBSK3hWTERLVHB1TjFGdHpwb21pd1Fo?=
 =?utf-8?B?emwxdFhtV2tsdnBLZy8vamdkbzQxR2lMYzBjMlhEVGd4YW5QNStaV0FkQ3dT?=
 =?utf-8?B?Um9aNGNIdi9Ha0w3eGJFMlplbXAyYjVPWko3RkhoTTBMVC92bmx6Vkg5RjJ3?=
 =?utf-8?B?bW5RSCtSZit4U2tyaTJ3Z1FaMnpjZWU2bFdlVkNuRURMSjI4c3VmR1I5SHVQ?=
 =?utf-8?Q?UC6Uk6MF83k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(42112799006)(376014)(7416014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFYxcGgyVDVlbDhOMXpMZVpySUprM2xXbDNsaWF5MVI2dkVxeVNFQjdWb3ly?=
 =?utf-8?B?ZXlrWFc4MHdwbVRDWHFsbE8zMHlBNDVNRXE2bHFLRCtYc3dmZ0RzUlJWSThN?=
 =?utf-8?B?UFdGRnZnQTZ4Sk9tV2NsVkZrZDk1NWdSZEZaRGlkSi9MUU5GbDlxN3VKN0xT?=
 =?utf-8?B?VWxNSjFwbWhmLzljWEhNWjBHWjRnUEdIdEYxS1dFSVI1TFJGc0NJUzBFdmZz?=
 =?utf-8?B?WXlqc0pVNmk4OTN6b1dqeGhZS1VLNWg5WGdCUkNFUVhNSEFzWFU3bVBaVXpG?=
 =?utf-8?B?M3h1L2Fja3k1TmJPV204WGlNeUpKNnUyNEtIZjVKQXZERzFBNmdkNi9Mc1lG?=
 =?utf-8?B?TUI4YXBXY2xmeUtFby80blRwZzllMnhnbDVSYURuR0NHQlJRQy9IVk9KSnpW?=
 =?utf-8?B?b0N5bXJWYktZeEdiSlcwL3NmVi8zSmhjdmpXT2VJNkVQRjNueERIZXQxZ3dE?=
 =?utf-8?B?d2pjSmhZMWNXb2ZuVFJxeDlKTzQzcjgzWTM5VnJ2MGJRdFI2YUJGemhnbWoz?=
 =?utf-8?B?OXFVZ216U1RodTJ5Znk2dk52VjJkbkFUSmVkcWg4VGlMZkF5bmZ4eTFlVnZD?=
 =?utf-8?B?RStOVlpUR2I0eXdQSWZEbzRDWUpMbWRUa01zdm9yQTlyQVFhZkszRE8wU1RN?=
 =?utf-8?B?S0liVlpZSU4wNVI3UWhDN1duQjZVOHRVVk9sbDJTcjlzSzJPSURUQXFqd3BU?=
 =?utf-8?B?OHh0a2RSeFhLNEJSQUFtSzNxSXZ6NVhNR1ZMZ2M3K21zMTNDS2N6UmNFYW1F?=
 =?utf-8?B?dHNmcVgydFdLSHd0M2FWK0ZwZms2OWRIajZEb05EYTMwd1dnYWRoUXpIMUk2?=
 =?utf-8?B?bFNsaTY2QWRLQmxGeGh3Z0NheS9KeTZoOVlGMWVBNXlsVWlRRitVMjhtekxr?=
 =?utf-8?B?akJ5SytHbzVTNytLM2E5Z0twdkdMQkorNWxJVHA2N2FIY3NSUU5MenNkcU9Z?=
 =?utf-8?B?SDdVZUlNS2gwWEZrWDJwWDhNNnJCMkt3SlltY2wvdWtmVjdDdUY2cXlYcGlK?=
 =?utf-8?B?SlBOR2xEdmlxKzBObUlJSEdySnNpWVhxbUxQVEhwQTFoLy9ZditsVVhYNmI0?=
 =?utf-8?B?a2RlTWhleUltUWZSTW0zZkUyQjl0LzVFZG5aT1cvcEJyZVFxeUNLaUI3Zjdu?=
 =?utf-8?B?V2RqY3gvRUFhMjZuSm4vNmNTbHhOV0k5dm53OWhhUVc0NU04L0dtM2J2YVMx?=
 =?utf-8?B?MkxEcVRsTURYaHBBUUVVenhaM1MvbStPeW1IZUNBMDFVdlZXTFFtck5ZZElB?=
 =?utf-8?B?L25vTHJLYVhPb1JkQ1M0Q1hJdTdyZWFqMXV4aWpPTHBicDZ4T1pDUWRjV0ZR?=
 =?utf-8?B?cUpoZGMvTy9HbkRaeVEyTklmQUhjeDEzTTFSWW5BZFU1cks2S2k4Yzd6TlVj?=
 =?utf-8?B?VXA4Q1Q5R0FUV2VKUVBRZjVNYi80a2xoQ1p1bVhadjdXMkhuTnZxSlBKY3JO?=
 =?utf-8?B?M1VSdWNTQW1Pa3R0UjlLMC92RFhxRW51UlBRRHV0VVpsMWVGd0ZXeitsK1M1?=
 =?utf-8?B?YUdEVTJWRnFPajdMWkpnQS9vNWdPdFVMVHpMWHBYakhmWlc0UnpiWG9XTG9m?=
 =?utf-8?B?U3FYM2d4cVlETzRkS0d6YmI3RlV3b1R0ZWxJS3hXenRwUTB6b3MvY3JqbTVI?=
 =?utf-8?B?MnltK3UyUWdncW5YMUJBZW9JQzRpZFRRbnNubUErWjZxZUR1Yk9ZUGdORHhu?=
 =?utf-8?B?VCtNeXdjVVd4T2RjUlYxb0Q5NUI1cFZCN0NIeXNtYVQ5OWRmaU8weXhiOSt5?=
 =?utf-8?B?OHZJYTZCSythUUR2SVdPcUV4TmZESExZYWpZbEE4RDExcjc4QlFoYkJKUTdQ?=
 =?utf-8?B?MmJLNmlUNUlKbE5pdG9tNnFaSFpvenRSVWxLSUwxcEJDbDFIM2hMQjAxdGx0?=
 =?utf-8?B?VnhhN2JhQkNMNHNRYk54VmN1bnNqRU5POVkvcmpndE9vbkF4ektRYXVPbmV0?=
 =?utf-8?B?SVBaZ3FrM0o5dURnVGw0cVFCMFk1dlY1cWx2RDFDTnhhbm0rNDlJVzlDMy92?=
 =?utf-8?B?bWZwcmlHcW5JdVF6c1MxTXVtSUdNd3hFN0s1SUR3ODhvU0NCZ1V0dXJEczhp?=
 =?utf-8?B?dUppRFNHN0s2Wkl1aGtndGNGZXlpUVkwZlJIWXRoYkR5azVKMjZOTk80TVln?=
 =?utf-8?Q?VbEnvd9RAZQIW7FEQR04VE5JX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b0975c-3337-4a9b-464d-08ddc2d7346e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 13:06:11.2461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+9Ul6Gis945SGQazxow4dVheqkFh187gwW2gIZo8DX9BsAI9QWfs1gRk0giWOj+8toDUhCBot0e2iRIyS2Ucg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7339
X-OriginatorOrg: intel.com

On 2025/7/10 23:30, Jason Gunthorpe wrote:
> This was missed during the initial implementation. The VFIO PCI encodes
> the vf_token inside the device name when opening the device from the group
> FD, something like:
> 
>    "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> 
> This is used to control access to a VF unless there is co-ordination with
> the owner of the PF.
> 
> Since we no longer have a device name, pass the token directly through
> VFIO_DEVICE_BIND_IOMMUFD using an optional field indicated by
> VFIO_DEVICE_BIND_TOKEN.

two nits though I think the code is clear enough :)

s/Since we no longer have a device name/Since we no longer have a device 
name in the device cdev path/

s/VFIO_DEVICE_BIND_TOKEN/VFIO_DEVICE_BIND_FLAG_TOKEN/

> 
> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")

thanks for fixing it. With the enhance spotted by Thodi,

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/device_cdev.c                    | 38 +++++++++++++++++--
>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  1 +
>   drivers/vfio/pci/mlx5/main.c                  |  1 +
>   drivers/vfio/pci/nvgrace-gpu/main.c           |  2 +
>   drivers/vfio/pci/pds/vfio_dev.c               |  1 +
>   drivers/vfio/pci/qat/main.c                   |  1 +
>   drivers/vfio/pci/vfio_pci.c                   |  1 +
>   drivers/vfio/pci/vfio_pci_core.c              | 22 +++++++----
>   drivers/vfio/pci/virtio/main.c                |  3 ++
>   include/linux/vfio.h                          |  4 ++
>   include/linux/vfio_pci_core.h                 |  2 +
>   include/uapi/linux/vfio.h                     | 12 +++++-
>   12 files changed, 76 insertions(+), 12 deletions(-)
> 
> v2:
>   - Revise VFIO_DEVICE_BIND_TOKEN -> VFIO_DEVICE_BIND_FLAG_TOKEN
>   - Call the match_token_uuid through ops instead of directly
>   - update comments/style
> v1: https://patch.msgid.link/r/0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 281a8dc3ed4974..1c96d3627be24b 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -60,22 +60,50 @@ static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
>   	spin_unlock(&df->kvm_ref_lock);
>   }
>   
> +static int vfio_df_check_token(struct vfio_device *device,
> +			       const struct vfio_device_bind_iommufd *bind)
> +{
> +	uuid_t uuid;
> +
> +	if (!device->ops->match_token_uuid) {
> +		if (bind->flags & VFIO_DEVICE_BIND_FLAG_TOKEN)
> +			return -EINVAL;
> +		return 0;
> +	}
> +
> +	if (!(bind->flags & VFIO_DEVICE_BIND_FLAG_TOKEN))
> +		return device->ops->match_token_uuid(device, NULL);
> +
> +	if (copy_from_user(&uuid, u64_to_user_ptr(bind->token_uuid_ptr),
> +			   sizeof(uuid)))
> +		return -EFAULT;
> +	return device->ops->match_token_uuid(device, &uuid);
> +}
> +
>   long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>   				struct vfio_device_bind_iommufd __user *arg)
>   {
> +	const u32 VALID_FLAGS = VFIO_DEVICE_BIND_FLAG_TOKEN;
>   	struct vfio_device *device = df->device;
>   	struct vfio_device_bind_iommufd bind;
>   	unsigned long minsz;
> +	u32 user_size;
>   	int ret;
>   
>   	static_assert(__same_type(arg->out_devid, df->devid));
>   
>   	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
>   
> -	if (copy_from_user(&bind, arg, minsz))
> -		return -EFAULT;
> +	ret = get_user(user_size, &arg->argsz);
> +	if (ret)
> +		return ret;
> +	if (bind.argsz < minsz)
> +		return -EINVAL;
> +	ret = copy_struct_from_user(&bind, minsz, arg, user_size);
> +	if (ret)
> +		return ret;
>   
> -	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
> +	if (bind.iommufd < 0 || bind.flags & ~VALID_FLAGS)
>   		return -EINVAL;
>   
>   	/* BIND_IOMMUFD only allowed for cdev fds */
> @@ -93,6 +121,10 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>   		goto out_unlock;
>   	}
>   
> +	ret = vfio_df_check_token(device, &bind);
> +	if (ret)
> +		return ret;
> +
>   	df->iommufd = iommufd_ctx_from_fd(bind.iommufd);
>   	if (IS_ERR(df->iommufd)) {
>   		ret = PTR_ERR(df->iommufd);
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 2149f49aeec7f8..397f5e44513639 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1583,6 +1583,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>   	.mmap = vfio_pci_core_mmap,
>   	.request = vfio_pci_core_request,
>   	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd = vfio_iommufd_physical_bind,
>   	.unbind_iommufd = vfio_iommufd_physical_unbind,
>   	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 93f894fe60d221..7ec47e736a8e5a 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -1372,6 +1372,7 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
>   	.mmap = vfio_pci_core_mmap,
>   	.request = vfio_pci_core_request,
>   	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd = vfio_iommufd_physical_bind,
>   	.unbind_iommufd = vfio_iommufd_physical_unbind,
>   	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index e5ac39c4cc6b6f..d95761dcdd58c4 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -696,6 +696,7 @@ static const struct vfio_device_ops nvgrace_gpu_pci_ops = {
>   	.mmap		= nvgrace_gpu_mmap,
>   	.request	= vfio_pci_core_request,
>   	.match		= vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd	= vfio_iommufd_physical_bind,
>   	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>   	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> @@ -715,6 +716,7 @@ static const struct vfio_device_ops nvgrace_gpu_pci_core_ops = {
>   	.mmap		= vfio_pci_core_mmap,
>   	.request	= vfio_pci_core_request,
>   	.match		= vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd	= vfio_iommufd_physical_bind,
>   	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>   	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index 76a80ae7087b51..5731e6856deaf1 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -201,6 +201,7 @@ static const struct vfio_device_ops pds_vfio_ops = {
>   	.mmap = vfio_pci_core_mmap,
>   	.request = vfio_pci_core_request,
>   	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd = vfio_iommufd_physical_bind,
>   	.unbind_iommufd = vfio_iommufd_physical_unbind,
>   	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
> index 845ed15b67718c..5cce6b0b8d2f3e 100644
> --- a/drivers/vfio/pci/qat/main.c
> +++ b/drivers/vfio/pci/qat/main.c
> @@ -614,6 +614,7 @@ static const struct vfio_device_ops qat_vf_pci_ops = {
>   	.mmap = vfio_pci_core_mmap,
>   	.request = vfio_pci_core_request,
>   	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd = vfio_iommufd_physical_bind,
>   	.unbind_iommufd = vfio_iommufd_physical_unbind,
>   	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 5ba39f7623bb76..ac10f14417f2f3 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -138,6 +138,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
>   	.mmap		= vfio_pci_core_mmap,
>   	.request	= vfio_pci_core_request,
>   	.match		= vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd	= vfio_iommufd_physical_bind,
>   	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>   	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 6328c3a05bcdd4..d39b0201d910fd 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1821,9 +1821,13 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
>   }
>   EXPORT_SYMBOL_GPL(vfio_pci_core_request);
>   
> -static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
> -				      bool vf_token, uuid_t *uuid)
> +int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
> +				   const uuid_t *uuid)
> +
>   {
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +
>   	/*
>   	 * There's always some degree of trust or collaboration between SR-IOV
>   	 * PF and VFs, even if just that the PF hosts the SR-IOV capability and
> @@ -1854,7 +1858,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>   		bool match;
>   
>   		if (!pf_vdev) {
> -			if (!vf_token)
> +			if (!uuid)
>   				return 0; /* PF is not vfio-pci, no VF token */
>   
>   			pci_info_ratelimited(vdev->pdev,
> @@ -1862,7 +1866,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>   			return -EINVAL;
>   		}
>   
> -		if (!vf_token) {
> +		if (!uuid) {
>   			pci_info_ratelimited(vdev->pdev,
>   				"VF token required to access device\n");
>   			return -EACCES;
> @@ -1880,7 +1884,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>   	} else if (vdev->vf_token) {
>   		mutex_lock(&vdev->vf_token->lock);
>   		if (vdev->vf_token->users) {
> -			if (!vf_token) {
> +			if (!uuid) {
>   				mutex_unlock(&vdev->vf_token->lock);
>   				pci_info_ratelimited(vdev->pdev,
>   					"VF token required to access device\n");
> @@ -1893,12 +1897,12 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>   					"Incorrect VF token provided for device\n");
>   				return -EACCES;
>   			}
> -		} else if (vf_token) {
> +		} else if (uuid) {
>   			uuid_copy(&vdev->vf_token->uuid, uuid);
>   		}
>   
>   		mutex_unlock(&vdev->vf_token->lock);
> -	} else if (vf_token) {
> +	} else if (uuid) {
>   		pci_info_ratelimited(vdev->pdev,
>   			"VF token incorrectly provided, not a PF or VF\n");
>   		return -EINVAL;
> @@ -1906,6 +1910,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>   
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(vfio_pci_core_match_token_uuid);
>   
>   #define VF_TOKEN_ARG "vf_token="
>   
> @@ -1952,7 +1957,8 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
>   		}
>   	}
>   
> -	ret = vfio_pci_validate_vf_token(vdev, vf_token, &uuid);
> +	ret = core_vdev->ops->match_token_uuid(core_vdev,
> +					       vf_token ? &uuid : NULL);
>   	if (ret)
>   		return ret;
>   
> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
> index 515fe1b9f94d80..8084f3e36a9f70 100644
> --- a/drivers/vfio/pci/virtio/main.c
> +++ b/drivers/vfio/pci/virtio/main.c
> @@ -94,6 +94,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_lm_ops = {
>   	.mmap = vfio_pci_core_mmap,
>   	.request = vfio_pci_core_request,
>   	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd = vfio_iommufd_physical_bind,
>   	.unbind_iommufd = vfio_iommufd_physical_unbind,
>   	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> @@ -114,6 +115,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_tran_lm_ops = {
>   	.mmap = vfio_pci_core_mmap,
>   	.request = vfio_pci_core_request,
>   	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd = vfio_iommufd_physical_bind,
>   	.unbind_iommufd = vfio_iommufd_physical_unbind,
>   	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> @@ -134,6 +136,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
>   	.mmap = vfio_pci_core_mmap,
>   	.request = vfio_pci_core_request,
>   	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>   	.bind_iommufd = vfio_iommufd_physical_bind,
>   	.unbind_iommufd = vfio_iommufd_physical_unbind,
>   	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 707b00772ce1ff..eb563f538dee51 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -105,6 +105,9 @@ struct vfio_device {
>    * @match: Optional device name match callback (return: 0 for no-match, >0 for
>    *         match, -errno for abort (ex. match with insufficient or incorrect
>    *         additional args)
> + * @match_token_uuid: Optional device token match/validation. Return 0
> + *         if the uuid is valid for the device, -errno otherwise. uuid is NULL
> + *         if none was provided.
>    * @dma_unmap: Called when userspace unmaps IOVA from the container
>    *             this device is attached to.
>    * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
> @@ -132,6 +135,7 @@ struct vfio_device_ops {
>   	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
>   	void	(*request)(struct vfio_device *vdev, unsigned int count);
>   	int	(*match)(struct vfio_device *vdev, char *buf);
> +	int	(*match_token_uuid)(struct vfio_device *vdev, const uuid_t *uuid);
>   	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
>   	int	(*device_feature)(struct vfio_device *device, u32 flags,
>   				  void __user *arg, size_t argsz);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index fbb472dd99b361..f541044e42a2ad 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -122,6 +122,8 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
>   int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
>   void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
>   int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
> +int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
> +				   const uuid_t *uuid);
>   int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
>   void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
>   void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 5764f315137f99..75100bf009baf5 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -905,10 +905,12 @@ struct vfio_device_feature {
>    * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
>    *				   struct vfio_device_bind_iommufd)
>    * @argsz:	 User filled size of this data.
> - * @flags:	 Must be 0.
> + * @flags:	 Must be 0 or a bit flags of VFIO_DEVICE_BIND_*
>    * @iommufd:	 iommufd to bind.
>    * @out_devid:	 The device id generated by this bind. devid is a handle for
>    *		 this device/iommufd bond and can be used in IOMMUFD commands.
> + * @token_uuid_ptr: Valid if VFIO_DEVICE_BIND_FLAG_TOKEN. Points to a 16 byte
> + *                  UUID in the same format as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN.
>    *
>    * Bind a vfio_device to the specified iommufd.
>    *
> @@ -917,13 +919,21 @@ struct vfio_device_feature {
>    *
>    * Unbind is automatically conducted when device fd is closed.
>    *
> + * A token is sometimes required to open the device, unless this is known to be
> + * needed VFIO_DEVICE_BIND_FLAG_TOKEN should not be set and token_uuid_ptr is
> + * ignored. The only case today is a PF/VF relationship where the VF bind must
> + * be provided the same token as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN provided to
> + * the PF.
> + *
>    * Return: 0 on success, -errno on failure.
>    */
>   struct vfio_device_bind_iommufd {
>   	__u32		argsz;
>   	__u32		flags;
> +#define VFIO_DEVICE_BIND_FLAG_TOKEN (1 << 0)
>   	__s32		iommufd;
>   	__u32		out_devid;
> +	__aligned_u64	token_uuid_ptr;
>   };
>   
>   #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)
> 
> base-commit: 3e2a9811f6a9cefd310cc33cab73d5435b4a4caa

-- 
Regards,
Yi Liu

