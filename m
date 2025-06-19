Return-Path: <kvm+bounces-49931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AF7ADFB9F
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 05:09:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D9023B42B8
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 03:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC6E236A7C;
	Thu, 19 Jun 2025 03:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oIktgxkr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD9C2AF11
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 03:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750302586; cv=fail; b=f4LUw0A14v/crlvWbqIr62FGhL3Jg9jzUdeethPlyqjJ6NTk7Cyxjh59DJI4iBW791Cvnro9lhIJJZXCfqU807TSuiPDRlZjTo4jcG20RMOPjLaiJEqRF4ANsx20F0U3KuFw9QVmZpazteDsAr9yvZ/VM9RtmwOPmTMWemAtCdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750302586; c=relaxed/simple;
	bh=g+GJteDG0DPgONV7WHTizGyC0a/6tPj+5L0eiQefKCM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UnFd9yX23qShpVUdhsxIWwxQ8CtkehXKjxMACDMl9fOAAijeh7auGjuMBf8axXByDiRntz2CCn9FEz0prUTXFosvTdtOqOpS+omYRbRSeSHxKpWYyNXcZWNDtEobzCGDT+a9oG3s3gNjVDVwPVsq+UPxCLMPAWgMEWJnjA9kwFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oIktgxkr; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750302585; x=1781838585;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g+GJteDG0DPgONV7WHTizGyC0a/6tPj+5L0eiQefKCM=;
  b=oIktgxkr1iRsmW8dd9TBwI1P1z4GlK4foHRHXXJYSDKPNHvASzI364Uz
   U+jBJv0Op7GQ0OkdYpFnF/LlDJHnod3RPYkbRQt/cYsys83fcc1bZAfb/
   Xlw93XpA79txFokoZ30c73tC/k5KqaaPPGhH5zDhdjQbd7B5XKbCPjTJc
   7jVHDBoEaeb550TuGnEPm85k5ab6j0kRO2M26C88ljBK2llFi5y3E3ySY
   cSV69oGrnz+TJ/ROsqT1hhs72YsV/STkCQAu1MMRFz+55Z+pBdDtLQf1z
   CK/Ye3wZsQrCqi+s60KjkBHojyLtEKh8MpPQSSG2U/sGdEirEAH4T9Shm
   w==;
X-CSE-ConnectionGUID: af5gTxNxS/Kg4FdOUqhxDA==
X-CSE-MsgGUID: Bwxc1O3hS+GBe683tHd+Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52516198"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="52516198"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 20:09:43 -0700
X-CSE-ConnectionGUID: iN//8twZSkS3W694hyXYOQ==
X-CSE-MsgGUID: BQYAozILQGi5fdy4PsWmCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="155936035"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 20:09:42 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 20:09:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 20:09:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.55)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 20:09:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LgB1FDyMqK5YyH1QPjErNTRFC0gg46dbBnyUnq5DWLPLR2xyi/YmqiWxzaAvu7z/Er1Bghc/q2qzrndKf8tgs/xpwPKnmLMyhU8oXVNHUABqx4mXgJFGzkt0oCA9eUljKGaXkjGr1qXtrz9Um2OWkookCOxQ/4qc/KpvZ6BJGLuCKAjXbqLDf9s+z+AZ31oxs9oWZoZER6//DbSwtu6SVcH4vzKvHXvnZtkVfdTyjCe53FpMShIup4oCtjJA1ZyxTY46B6umJ3zlCiSDuLKmgGKx7+at48n6giqc1jBS1pEccd9olebHhkHCB9OeM52U4rKw6E61or0WTfXBBpufoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDnLk0B+W9oNPanM2LktIMVwwv92zv/BqJ2MiIZ3mag=;
 b=MQwxJOR4dq+Z1pefG5kcxXWgEnF01h2S3JjBTczUGCfNpHo9M1NJeVxIf9/6Gg6x9616zN8I+2mS1Y3ZAaUxTRF/L0Ota6cUvCiwn8+0jMqHw+C8ChBueUPA5D2I3AamKwqBFhZ8mYg83/vQvBhC2HU5JaiC4I+meyWxPdiJDW2pwzPncjNntmhVEnV4DICZd4dMPChEA+pEeEviH9/4N+EvYXRdK8cUXH0hTBgLs6xYoqwn6UtwK1rhn/iDCEvCXSr1WqKR2Jy1IeUhRx4Ld/U7L5zW29i8vb3CrLrwvTPXstSLljKcZsKseoeqPfQbZRfCp9XmCHLvX3rS75v+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS7PR11MB7857.namprd11.prod.outlook.com (2603:10b6:8:da::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.28; Thu, 19 Jun 2025 03:09:25 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8835.034; Thu, 19 Jun 2025
 03:09:25 +0000
Message-ID: <0ead4f55-31b1-4a66-afc0-f39239c2c660@intel.com>
Date: Thu, 19 Jun 2025 11:09:15 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/5] Enable shared device assignment
To: Peter Xu <peterx@redhat.com>
CC: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Alex Williamson
	<alex.williamson@redhat.com>
References: <20250612082747.51539-1-chenyi.qiang@intel.com>
 <aFM8D7mE2PrVTcnl@x1.local>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <aFM8D7mE2PrVTcnl@x1.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0014.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::26)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS7PR11MB7857:EE_
X-MS-Office365-Filtering-Correlation-Id: 927382c9-4cd6-4a81-e5e3-08ddaedeb248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cjFYOHJsajlJQ0E0NWJQRWcxZUlvY1pLckg1T3NoSVN2cGZ0eW1xY005cXo0?=
 =?utf-8?B?MzdjMFlmRXB5Q0JodWh1R1RlRS92VDFOT1dVVHErSllRQmZjT25sN2twdmgz?=
 =?utf-8?B?MzdIQndoc0RaS2NLTGdUbm1RUzc4L254MnJMRjZ5VENHdm5OVFVVVzJzTW1B?=
 =?utf-8?B?UGNMa3VaenZqZ2dJN0JSSE5XbWFacy9UZExLMWkrYnorNmJNc2Z3cDVQazNG?=
 =?utf-8?B?dlVpd2o4YUVqdUF3Um05d2RGekIwZ3kvaWFCbWpsTjI0NWRLSllFTitNZ0dQ?=
 =?utf-8?B?cVVaVnBoZVNNem5iMzI4UlZPVytZOXp4RzIrRDVQTnhrMnlsdlVHU0pUUFh3?=
 =?utf-8?B?VTl3K3ZkelNNNGdlVEZJaFI1U0FuNXRKOTNvNmNZUllqMEJOWk5mbXdNa2Vw?=
 =?utf-8?B?eGpGSm5zU0d2ZHU3bDU5UVJOcUpFQ3JubmU1RTRNSE85YWJYOG4xVjBmVkha?=
 =?utf-8?B?YVNpNmtqZEk5V1ZaMXdXbjM0TjdtL1QwY2VOYk9DWTdTNHg5THFGMU1YNGRx?=
 =?utf-8?B?K1RGcWNLbzdoVDJIWVhXL04wSW1hK2M5enlKRE9rdDBTMTVBLzBETnVvam9l?=
 =?utf-8?B?VmhUWlJndGZQNG1UTkhxaWplT1JxTHhaS0pRM3Zud3JveHNrZkdzY2RJVWpY?=
 =?utf-8?B?d1hodGdwTFRUNElhL2ZHVzR5d01TYW5oUGJJNWRyUlo4V2w0TEdvTVd3QmlN?=
 =?utf-8?B?aU56ZlNpbzQwUHk2NUVrelpoVkY0Rmp5ek5ZclAwT2RtcUVoWFQ4blF4b1lv?=
 =?utf-8?B?UUN5cWwvV2NFUmRwVGhabUwzYlBOM3U4WnFjN1c3RWQvdGJsMHdHK0FlMzJi?=
 =?utf-8?B?MXRhTXVFWjZGRFdzWVVFc2NhTnpvV08wcUdBWENJNE1GbzhuSWo4UzBYSlBS?=
 =?utf-8?B?VkNyODlIQWFpMkdKVXQ5WjV2NENMczlYRXgyM1BqdHVYeXVNRldzL0xIL0hE?=
 =?utf-8?B?bEZDVlhOUFVGR3hBNVA1bk95VWlIWFY1UHk3aU56d0VYTnZXem1seFdsRk93?=
 =?utf-8?B?RW9kbEJ4eHptOEJLaFdBV01ZWEVVSDZwcVhtR2lpY3pIL2hnZGJrLytkdktu?=
 =?utf-8?B?UG41YWY1S0FVemV2ZlAxOTFaeUxjb0RWQlhRQmplZnBxRXpNOTNvSDkvU1hw?=
 =?utf-8?B?eWpsaWw1MDBFbk9ncGtUeTZEMXpOdjM1Q2ZpOFY1WVllVk93V0tzdXNXUGhS?=
 =?utf-8?B?MlNUVTFvZUk1Z2QrU29GWWpFbkdjQ1Bub25IVkpZa0pMVmgyb1F4MVBaWjB5?=
 =?utf-8?B?WTNNNVg4L2ZWNUJTY2taOVJiczJuTnRYL1Fhell2QTlNYnEwTHNyQzF3ZWpV?=
 =?utf-8?B?VVBtdExrVktCRXBkT1Y5ZTROekRmV1pRVlNhNEJzKzM3a043YkpmRTVVcFdH?=
 =?utf-8?B?TEh5OXpwQzhJZkd0UGlXMW04ZUxncC9nV08ybEc1b1R3MzZNSFd0OFJXT2xX?=
 =?utf-8?B?bHNUQlhzMVBsUzJMRWwzR2ZjVW5YODNzdERENElqRlFUV1phdGtUTlNKS3py?=
 =?utf-8?B?OHM3Tk1OVXpRelhiU2h1ME5KVXcvWVE5ZmxWVGVWYTFSV0U3Qk4yWG5BcEd0?=
 =?utf-8?B?YjVZUlNUMi9WaktyZm84aXdWYlZYa0FWT3dVUi9MdGJDb3loNkQ0bDEranBR?=
 =?utf-8?B?dEJoejZsWHJaNk5ZZkMzUVJQdE80Y3NQbVNCM2trSnkwN2R0UGdXZDNBelM5?=
 =?utf-8?B?T1V6aU16aVZwSEc0b2o1TUFSSTVLOFZDc1NhK1h6RUhqc2FhVzM1Q012TjZK?=
 =?utf-8?B?Y0JMY2U1OUZQeXBlVTYvMVRQeU5TMEc5NDdTRHB3MStkSDlWTUtjSlRXOUt3?=
 =?utf-8?B?YVdKclBQOGQyekNSL3RHQlE3TFBBMDFIb3lPTmpPOHhQQnMwRWY4czBjOW4v?=
 =?utf-8?B?RE9wMmZrRDQyUHhrVHl6T3cwZVlFeGZHSEd1UzNQd3JLd2hJdHFDcTlYaTZF?=
 =?utf-8?Q?vn5hdYhZnJg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjVjQlk5WGc5RzdzcTdyOFJPWlhsdlVaeGhYeGtzTmZDcjUwQ0lJUnNZYkxU?=
 =?utf-8?B?enVIMHBCbHc3dEp5YXkzZG96b2tlZHJmeWNuWWVRYi9rN0pPTlpBMXhCZHhB?=
 =?utf-8?B?clJuTHp3enFjV01wMEN4NHJ5MWJpYTV1cERSN2o1eE5rOFI3dm1ETzJUamor?=
 =?utf-8?B?VzZRK2duZGpDQ0VwWW9aUGQ0cnQ1MFBCcjQ3TDBBV1h1ZW5QRXpHVWFQODlt?=
 =?utf-8?B?RjhlTTBkTnNGQ1FlYUNGN1VrRTl4OXlsRUl6cDdKQ1drYVN0VkZaNnZQS09K?=
 =?utf-8?B?NVlZMTM5VHpCODhCR2N3TU5vRjNHYmRqZTFPVE5nUUlhdkhkMnB5RW5xc2RF?=
 =?utf-8?B?MVoyMnUvczF2bVlkbG5GRU5JZUZyL0RGb08zN0QvcXZkNUNkWnBpR0VCU1E4?=
 =?utf-8?B?MDB3NnR6RW85MlhMVmF2YUM5QUVlNkJGM29NN01xNFdVRUZCK2ZjQnFVQkpy?=
 =?utf-8?B?TS9nMEluZ3E5T3hzbG9pL1FaRG15SGxqbS9uZHdKeVV5bGh6a1dXM0srMWQ5?=
 =?utf-8?B?NWVITXo2dmp3M3QwWmJaN2ROYmhNQ21UQWZJNGhBSzdxQ04xOS9jdytteFNX?=
 =?utf-8?B?bXlla1B2L01ETGhWbytWWEpmQUdZdHlnN1VQOGcxaG5qTFUvaVpFam5tOHpC?=
 =?utf-8?B?cVRoRWZCamh4WGVkQWlEaU9UU1N3SUtSWWkwU2ZYQXJwa0dxTkFmRmpqOGVp?=
 =?utf-8?B?SDE0L21LT2xJM2oycWhBcVFldmVxWWtCYWQ1UEQwdHdDMVZtNUFtOVRRbmdi?=
 =?utf-8?B?NE5xVm4wOGdjcXBLaUJFSWl5dmtUMzFydzRqM1dBQTJ2WVUzOEt3bHVqZkR4?=
 =?utf-8?B?SWcyVUsxd1pObEFadlhZQnBVT2xKMmZjdTFBMUg2K2VKOVVsNjgrZFRGZWlW?=
 =?utf-8?B?Y2d1WVF2UVl4OFloTG1UT1FkdUVEcGNlQXFMZHQrbVV2bXNQZ3JoNDJvVVVU?=
 =?utf-8?B?QjhEM2VhcFNxcjV2NTdDeWMrZWYxRTZTZmVSekdHL2lrQ3Z1ODBLcTN3czF5?=
 =?utf-8?B?OHhadk0rZmZONmdNTzVHRGRDVzZIeE1vZG9YWUtpY0toQU91VzJpOGR2RWht?=
 =?utf-8?B?ZDVVYkdlZ1p2aExzd2ZWVmt2V3BpQ0tPUmdKZ0MzZ3lxN240a2ppVnZlTFd3?=
 =?utf-8?B?Q3VKRVlpSDhFNXdsY1lKbzgzZythS2RUL3F0U1gxY0F3TTNrb2JOZkRIRDV2?=
 =?utf-8?B?dDMrejRNVm5yR0N2bFg2djZaR3BodXBNWGJabVErSklMa1lJSkxoZDJ5Skw5?=
 =?utf-8?B?Tk9acG5xU2praHN0UUNiMm4vSjRLTFBCUmg2TTBlZkZ1VnVJS29nSXhsOG1s?=
 =?utf-8?B?TVdUSGV4ZFlETEFaWFo2ZStYZ0J5bGlnd3BQTGt3Ym1hazNianMyMm1HMEZk?=
 =?utf-8?B?dWhoM1VqV2JiVGhnWnk0aWsyNnl1eld6Y0ZmVVNVNGkrUVR0Y0tuWStTSnJt?=
 =?utf-8?B?S1Q1eDlXbElDdk1lZlhRYS96K0xCTlAvV1p1Sk5uWGM4Z3FuNE1JajZ4dnBi?=
 =?utf-8?B?QnV2REgyQUd5cTFsZllZL3NHY1B4NUZJMEU0ZytqYWJDS1ljRGUrWFV2T0c5?=
 =?utf-8?B?M0RUczRyaWdlZUxYZVM1eHBvYUhMdUtYcXpCNUt0c1ZKZmw4T2hyMUxaQWhI?=
 =?utf-8?B?L0UzZko4OFkrRDNkaVZuN1MzZ1pEaklYWWE0VFczaFEyYzVWTXJ4TzlFNFZK?=
 =?utf-8?B?RU9YN1JvRWozMkhCbzJpV1BTVENYOWhHWGEvaDU2OEdDMVJXSmJ5TmVyYkpi?=
 =?utf-8?B?ZG1tSlhHRTVoUnptYStSNmZ2STIrWXBlRE5nTkdBV1lGTnBvcXlHNkkxSWkx?=
 =?utf-8?B?VkMyRGpwS1V5SU54K3NTYStDd3lqelBlMng1N0grQ3JDTG5qSXFCUGZrbEI4?=
 =?utf-8?B?cHRoMnN6SjJTK2NtQkYxdm5LVGlUYzF5bHZZU244V1hCWnYvN3Rod01mRDBV?=
 =?utf-8?B?a1R6cXZvNmJwa09MOFNRYkdrbk9xVjExL3dtelE2YUcwZnBtUUNicmdWQ20y?=
 =?utf-8?B?RVBVMXlOclJubXpKM2MwbUZPWXo2OGZ0MWhka2YxRDBRbk1Qd28rclFwNjdq?=
 =?utf-8?B?cG9XeUUwWWRKYWtwVUxDdHhOUXFJU0xsYmFOVmQ2a25WaDM3NDNHSmQwVmor?=
 =?utf-8?B?UXhlTkE4M3ZneEVlMWZhMWtvYlJZSitxdUFxajNOajZkOG5wSHAyWkZvbXJW?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 927382c9-4cd6-4a81-e5e3-08ddaedeb248
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 03:09:25.7301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwjLDTszTIzyy5zybnBev5GpeJdO6GGqfT9qK2SGdxODW6WVW70mPtwLkZu/fm6lq0poI/sedzvKcEKzmxv7YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7857
X-OriginatorOrg: intel.com



On 6/19/2025 6:22 AM, Peter Xu wrote:
> On Thu, Jun 12, 2025 at 04:27:41PM +0800, Chenyi Qiang wrote:
>> This is the v7 series of the shared device assignment support.
> 
> Building doc fails, see:
> 
>   https://gitlab.com/peterx/qemu/-/jobs/10396029551
> 
> You should be able to reproduce with --enable-docs.  I think you need to
> follow the rest with kernel-doc format.
> 
> If you want, you can provide "git --fixup" appended to the reply (one fixup
> for each patch that needs fixing) to avoid a full repost.

Thanks to point it out. I missed to build with --enable-docs. I have replied the
related fixup in patch #3.

> 
> Thanks,
> 


