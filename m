Return-Path: <kvm+bounces-29342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC2589A992D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 08:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDA631C22396
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 06:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FB01411C8;
	Tue, 22 Oct 2024 06:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T7vQcsha"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AC11E529
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 06:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729577002; cv=fail; b=EPnNz9IIZCr3bQYwJLsGAyzGXMZ+mMIMTD8i9VCLIjuy677UnT3Xzb16beuoe9elL9Hy+//jlqvzgp2812Jz0KJY/djNiI4pILUqQ+GSCBz6Sw3V6M3+U/hzYXKs3TSovXuER2+Ndh3EtlakVZBp7YgYAEI0rgwA89Ye8BFQy2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729577002; c=relaxed/simple;
	bh=GRQF0MtpTpZVBG/zVXKKGJaDQ/3q8y5yskRSosOMCYw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EAvXqp4nVmt5+vdbT0hY+mgxjYja8aEoZImLWIpWihXBdZiHRghuvKVII4qhOsaOEmZsWDbXfj39aGDpnuRflyIfaqDScfLQUV+OnY9Zuv18wh39KRa50WxUF+rRoq5nQz/XX2TF39t6XgCLEToOegYy8mEZiOgN7Z1HBJ2XCiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T7vQcsha; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729577001; x=1761113001;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GRQF0MtpTpZVBG/zVXKKGJaDQ/3q8y5yskRSosOMCYw=;
  b=T7vQcshaNkhsDGFu0rUujlf3nePvqQU8Y9s2r1jtn6Id4oqWnmgcJbaK
   nWaE/WT476Ck9Yx8E17m2ZuZqxcY6hE5NuLu5KLTjNfbz5H8KLbXPnMkq
   E93BlKB3eSiBREvArRuN1zMUuMUnF7aOM/qYlXT4gEKpSVcNu+kwJCts/
   OseQv0Xl6KyAYkh55rv90iVfXgWERbXOQIhf9Z9K9itqS1vtGTt0IBvlp
   3tp1pHeBSELP9G9iPnYZrmkYHzVPBWpmUDex8mB1tniRfEKBZrJP7B5UG
   raEZNrJcBr9E4V8kx1IkU6bxwgEcVE22oP2Ftn+bfaLgzidvO6ta/UlPD
   Q==;
X-CSE-ConnectionGUID: Ri3pmugkSwiTk9hDQnE51g==
X-CSE-MsgGUID: qjb94aEiRtuzm1EeXNsvbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46557137"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46557137"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 23:03:20 -0700
X-CSE-ConnectionGUID: hYzeeQYTQg+scEIOMiF1Vg==
X-CSE-MsgGUID: KLI8X9WKSLa4l5vsSr8CXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="117177653"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 23:03:20 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 23:03:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 23:03:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 23:03:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPBDRNVmZxHSfAt3zxmxMpXoH1SvZhm4oAEB6fHv6cbnxmEH/DHpHbooJ85TjvCeOHWMiqT5hTkSixvBAgxHBiTgbNMnLbs698opYya55V6wuWsfek2ScA6XOWn4hvCukQUHI/PksRVS/vyXhhKEGGGVadLsavpDAdP7k9Wl3z851ztf53K0i4XtRI+XXlOZyMJAugZCXnZjXsJmtFPl/WERTO8oGWVhTJ4R7fCA30WV1WYYsM3IMNJ9lGmIEdp0nMJYnKH60VEC4mKj0mM4vCwSf0nsxqjzPjRmj39gOe01khG09njQwCrFBTo8lonUdcT21HsEjlBw0JHpRzS/IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jneP6dWm9GoYMt2RQGcGMwW0XWz4RNJZSpkYoV//G4=;
 b=k8KbUlZFMHDobGh1SeJo7vlxl1uqMrtS1WvJ6AsAiR/af+aWiTSpv/Eh/8SoJOxhpIcOT94X2zFe71sDiMbpaV6UR0BhsZWynoCUYJr2mg0WMCoE5tIn/7eewtJna8B6i55cSC/5m76SsOZE/awkw9XCeNYaiMnX45XJk02iRzZVtIqmA1TCCyb9Mz0h74U2eDS32xgO4MwEiJEdvRGLfAMRHgFXmG3l18GPoffTNcZlRWAH3TfCcsLze3iQYDS26hKXwwsnmiY43lXH6ByswxqhNNb1v9ekYs54VyFcJwRYnBAJl9LxxvN5fLWcsKEogxMc7Y7+KFNduM4OWBjG/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6309.namprd11.prod.outlook.com (2603:10b6:8:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 06:03:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 06:03:12 +0000
Message-ID: <b7d51810-6a97-4188-9a9e-9ee80a00ee34@intel.com>
Date: Tue, 22 Oct 2024 14:07:48 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] iommu/arm-smmu-v3: Make set_dev_pasid() op support
 replace
To: Nicolin Chen <nicolinc@nvidia.com>
CC: <joro@8bytes.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-9-yi.l.liu@intel.com> <Zxc3NqwiGau+2Ad9@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Zxc3NqwiGau+2Ad9@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0111.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM4PR11MB6309:EE_
X-MS-Office365-Filtering-Correlation-Id: accfb03d-0128-4fb7-0c98-08dcf25f35c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?enA2elpZMjd0ZkcwRy9nQll3QTFrRU82YlZ4NzJJZlEyYm83UXRaK05CUUFY?=
 =?utf-8?B?c0M4RWRUbkRUcUs0SHJ1Uk1kVkszRFVOdVZ3V3hIZU9TbUI0SGk1dTlYODZ5?=
 =?utf-8?B?Wlp3SGlDYldPKzd6bTJQN1BLT21rYzhueXVIWTRGUjJYdmxSTEY5WVpkVXcy?=
 =?utf-8?B?MGJsaSt2VXAyMmlISzgxQmEvcVhnYlpqOVE1WVZXYWY5WDV6UDFGOG1SVnBD?=
 =?utf-8?B?a3VhNTVBaWhvTlhDY0FpY1FrbXNmYjJRNitKU2pmdDFlN0YyWE9YQ2RYUzZK?=
 =?utf-8?B?NVpvYnlzdkwzMTkrbzZRWnlXUW5jelRkMnhkT0VYVnMvUFVIdEd0YkY1VTNu?=
 =?utf-8?B?MkNneE5ndGJ4Rk5EdlErYUwrcUpLUU5QV0VXQ09vZnlqMEdYUm9WQkd0TS9x?=
 =?utf-8?B?b1NaM3A0dVl2aHkxQVFmbEdsWGQzNFVaS3dGaE1Wbml4SmtrMW5WMjkxVTZZ?=
 =?utf-8?B?bzA2VjBmdlF6dElCSGwzRDE3NGlYcTFjZXE0aTR4dWFQb1V6ZGY1TmVUNzJa?=
 =?utf-8?B?RmQ3UGxmTENacGdSaWJ0am4zYmtjRVgvVFFOYmE1WXFJZHRqbW5aaS9qc3lr?=
 =?utf-8?B?T3JoTXdTdG9WZmI0UFdGN0Q2S3MzemJHSi9nai9nMElZNi9lSW13czQ4Mito?=
 =?utf-8?B?K1RXNENnU2QwWU8wR1BORHZJYjhlM2dmUm8vdk11NWVtMi9USGZvVXB6QXJD?=
 =?utf-8?B?c0xiaDdGalZFMklHRjkzOEIwOS9xWXdIdEhGMmE2eXBzS0E2ZUs4ayt4N0FY?=
 =?utf-8?B?Yk9Fd3lkNVo2S0ZyYVJiSjJRUGNPanZzVCtPZlZYckxRRHZvbFR4RjhjQUZC?=
 =?utf-8?B?VDNQUTRvT3NhVjlNMDMvWDJHT0hNZlRVaERXcUVqV2J3UW5BMGdxNlBIc1RR?=
 =?utf-8?B?THdXcFRFZk11TDFjV1Vwa3VkUkw2eDdWTDlKZzVyK0lBRTZkSHpiQ0VHekEv?=
 =?utf-8?B?aGdQOGxMc1BpMGhuVFVOTnNYeFhiY2trN1UxSXVoOE8zUHE1TWJiWSswcWpm?=
 =?utf-8?B?OTBFMGxDaGFRSFZtYUQ4WFUxMGo5VUVISWVOdEk1M3VtRkUzNTBjYjM5QjZB?=
 =?utf-8?B?NWhYUkZQVnNqRzl2U0tYR1BMYjBJam14ZHJydVRDcGxvckxQZkxZSXczMUI5?=
 =?utf-8?B?bTZNYjgxMEg2NzMyeFlKZ2hhMGRiSW43S0ZaeUxnOHA5UFVyYU9SUXlJZ3cw?=
 =?utf-8?B?YnZKM3VSOHhjZzRLWXI0Y2pEL0NjQkY2Q2xCRnUxek9LWWVKbTNESkg0aHJJ?=
 =?utf-8?B?UHc1bDZaTGNZRlBBbDQ5MTF5OU9LZjNBdDNHdG1ReEQ5bUs4aVlpNEcvVUVt?=
 =?utf-8?B?cFBCRUNib3lWdTljUjczOWhVeEc5ZUZWOENPeklWQ2RIOEZQUG5nbkRad24x?=
 =?utf-8?B?WWZxVVFLaTdqZmRzcEpVTkdUWG1xVXZyemtEbzVxZksrV3NEMDhMUFJPWXNY?=
 =?utf-8?B?UDNiS3pXSG5wRnYwalB2RHl0YlJMaGUyNlgyTjdWbkVaREhpMmxEZ3dHcDYx?=
 =?utf-8?B?VnJ6aWdXdVZpVWJyYUhJRk8zbk9HZzNnOGdwamtDTytCQWpuZll3bW1EKzE3?=
 =?utf-8?B?M2xaMEIzZzVvVkhseVVaNytXRTFJSTZMUnVTN2JiSThSOGhoNXRRUnVlWW1R?=
 =?utf-8?B?ZWxoeVZjcTZXM3l6Y0kxakF2T1FEdzEwc2dlZWlXaFM3UC9tZzVteEtVeGM0?=
 =?utf-8?B?K2NOdExxSjc5dG1Cb3YzaFhXdms3ajBzM29Ddmpzc3kyemZOL2pLcHBpOXRG?=
 =?utf-8?Q?kUk5GCucAgO6DpavRc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RE1sMFkreDY4NG9QVEtGa2lPdWRub0xCQW9HU3RvWFlkaU9xcmNlQXBjSFV1?=
 =?utf-8?B?WGthTHNxeDlZUnl0REtLWk1rOEpKWitVeVhQa3dNVGUrUmhDNGpJUXdEbGxI?=
 =?utf-8?B?VTZCOEVWN1VTdTRkamRJbVg4T2ZBYXNua0s4VjFaN1ZhOVJ5Z0ZTZnJIRmZQ?=
 =?utf-8?B?Mkt1Zm5UeFo2UWxrWEJjNk9pVTYzakM3eW9jTTUweTUxVDExWUh4RDBiaWhs?=
 =?utf-8?B?cWNES2FvbEtTS3BoVkpHQ0tCUjNOZVJOUGZRc1ZpODdWbU9IeFpPVEpMMnJk?=
 =?utf-8?B?UFZ1YUhkQ3NzWHJDVk51TmUrNHhxUGtNV3hBSmFLQ1laL09BK3ZiOHF3am1I?=
 =?utf-8?B?MnE2YXRpZkZGTm5zbFo4ZEgwY3JNcEtZZHBzeVl1dmprd2FiRGFWMUo0RjBX?=
 =?utf-8?B?My90Y1Y2RWYwd0tYbVN0SG1YQklUdSt6endrWUFWMDFod2loaXRuN0N0YUZ1?=
 =?utf-8?B?WFZGWDhkTksrT0h5R1lRWEpXaXVObVNoZFFZQUE4QlA4VWZZU0Nlc0dWczlG?=
 =?utf-8?B?MllleVNPKzlSQXVKdXQvQy9hZG50ejlVYmR5bkU3TWJVbWtTa1d1Mzc3YmRv?=
 =?utf-8?B?YVRRVDA0VURUWjVteHAwUGE5dmxWVk05bjhSUmVnQUJiMFp6M0tTTnBMb3k0?=
 =?utf-8?B?VVhsMmkweXNJbEFiaHVwS3NKc3Z1K0NFcks5dml2VjZMTlJaSlg4ODVJTnNQ?=
 =?utf-8?B?ZmNuVWNBN0dNSkxJZEE4eUlOak8wVFJCWHRGa2tBdHlicUFva2RJTW1RMUJS?=
 =?utf-8?B?UUNPUUFwSzlPZ1FOaThXaThrSWFQR0piVXRVTGViTDlzaXZlS3RwL2ZQWE5h?=
 =?utf-8?B?WXo3dkRXdVRHNG5pZDBLYkV4N29VNWVBNkFNc3ZIb1NTbzJNRjRwK0J3YXZv?=
 =?utf-8?B?c3Fia1V0T2VYbmNSTXZ5QWVmYndDSmVwVkk4VTB3Q1Z0YlplRnJ6SGV2Z3dV?=
 =?utf-8?B?cmEwK05ZODhjZTA4YmVUeGo2b002WnJzMWNLY2h5dFA3Y0NHT2JoMGp4WW5M?=
 =?utf-8?B?cFU4WlFwRWhrTThOUjhhYUxGZmdlWVNxeHVaUGExUHowbWoyNlJVZlJ0eHBK?=
 =?utf-8?B?MVFjMnUwUkg5NUhYSXlzMXB0YW83Q3loOVBvMUd6N0FwcVh0Z0JIUkJtZko3?=
 =?utf-8?B?TVBhMENNU3hVaTM0eWVJMEJnaWM2UklLRHBMNEp2YlVDeG5McStLTlBjaDRo?=
 =?utf-8?B?a3lYVEc4ZWh0RUhOaGltcTV0YzF1YVQ5bzdiWWNBaHdrZUxpbnZsdjdZOUlj?=
 =?utf-8?B?bFB4RTBTRUx2bG1MT1lQT2Y2cGtGdWowL3dDMHY3NFJnek1jYnlQVU5DOVpL?=
 =?utf-8?B?RVBYL3ZBTkZXcEFKRzlMNVg5cGN0ZzFXWFRpZHk5dUpHN3BiNHVEMGFOa3A4?=
 =?utf-8?B?OFpaQ09nTDlGVmRHNUxaMjhRSm9CQ3NlSGsvTVNTWHJZRVlWMUx2ZEtYY2xG?=
 =?utf-8?B?aXhoWndVcTYvK0tMOCtla1A3cVdvM3BqejBma0pKVFM2Um5PSXl2cmNnM09S?=
 =?utf-8?B?cnFRY3dsOUVSalJRYTdiU1pub2V1dXZpTVkwM3ozOEFNV01DOFpjZGp4eVYx?=
 =?utf-8?B?RjZPZm5ocXZab3FpNVpWS0Q1REJLeDBFQVM3dUhHTWlpQ1kzMnFwMG14VVIr?=
 =?utf-8?B?SWl1YzVFenMxb29JN1hvLzI1WHZjTEw3bGpseHZ6djh2N1dVdDJRV1drQUtt?=
 =?utf-8?B?NnNPRFYxR0RTRE5jcWFIMHVCZ1hEcDM0cmtUMjBwNnFwRUlpUGJjRVNEMHA4?=
 =?utf-8?B?M2dZcWtHWmFjQzdDNUZ4MkVQM3ZDU0xDQ1B3VXErUGV1a1pKY1J4RTZHM2Zn?=
 =?utf-8?B?R210cEx6ZmZJTTFtcXpsczJpQ0VRNDRMWTk1RzNsL01CUnRkNTg3TXZRVyt6?=
 =?utf-8?B?MW90T2xjdmg2MzVJVHAybXhxdmlIM1VITEMwQy9yZzZtcmNlMk1wNVlKaHND?=
 =?utf-8?B?aDZFYVBwbmhzYVRnbTBFQkx5ald2Y2Izblg0OTNWQ0dzVmF1MitzNHVVUjNr?=
 =?utf-8?B?TklldnpuOWNneEpVUi9kTGV6S1JVNmF5U3FWNjgwM3lNa3NyMjZ0V2g5UGcr?=
 =?utf-8?B?eFFTYS9WZzRLam9IU1FBVXNyWklNN3ZDL2dza05vVEJQcTNyNWNLODd5ZUx5?=
 =?utf-8?Q?Do+QbznGdHndXXboV5HY7YtRO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: accfb03d-0128-4fb7-0c98-08dcf25f35c3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 06:03:12.0670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13NVCTQTVCEAGr/+6O9AKlpO5QIeGeYPEHsOcaUv+HFSzBeOO3L3mSSM8MgA0GupIqlntrvCaAM0jLJnOYmAjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6309
X-OriginatorOrg: intel.com

On 2024/10/22 13:25, Nicolin Chen wrote:
> On Thu, Oct 17, 2024 at 10:54:01PM -0700, Yi Liu wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>>
>> set_dev_pasid() op is going to be enhanced to support domain replacement
>> of a pasid. This prepares for this op definition.
>>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> With one thing:
> 
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 737c5b882355..f70165f544df 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -2856,7 +2856,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>>   }
>>
>>   static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
>> -                                     struct device *dev, ioasid_t id)
>> +                                    struct device *dev, ioasid_t id,
>> +                                    struct iommu_domain *old)
> 
> Seems that this should be squashed to PATCH-1. This function is
> another set_dev_pasid op for the default domain, while the one
> in the PATCH-1 is for sva domains.

you are right, let me fix it. :)

-- 
Regards,
Yi Liu

