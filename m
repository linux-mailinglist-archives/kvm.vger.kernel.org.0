Return-Path: <kvm+bounces-36094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E66A179B4
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 10:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0ADD3A25F9
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 09:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7941B87E7;
	Tue, 21 Jan 2025 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q279mqoO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB82714D711
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 09:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737450066; cv=fail; b=XB7V+eGRP6fHP5M9RxILT3P/cSh/EvJB2Sl0DrDuH8U8erZ8fJZDAut11NgFy00jpTvxYdx+QRxR6c1wAMmTQqm6+Yqc3S094Fy293RN4dqRYoqdlRlsw617blK5iZNKYn+ui811b3kKnilB1gqe8ld77OSnPSbl9TrQ3eQqLZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737450066; c=relaxed/simple;
	bh=DBvfedv0fq+CFN44KMXQJagR52YoKSCJzzqy3ntwOIc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m8plrZV4qzy5lHuZ5pskMGq7yy3J2WaQmNjBJvvsIx5XXuCySj2XhsotLm7Q9E9Zdcu/zVu03tJovPbCUN0tHTuxELiFvZJkleWgTmUPjxyPpWodG+thjfEqeGmumBRRmUso5iKQPGj5eojINITNKGQOdqyfiyeATmCK4hsclbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q279mqoO; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737450065; x=1768986065;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DBvfedv0fq+CFN44KMXQJagR52YoKSCJzzqy3ntwOIc=;
  b=Q279mqoOrJMQKyeQMNiKvdNWZ0V//tZM4k/ZIlGa/2kus4JnbpFFa4zE
   1442Fv2HBdpjPBjHnUyh0wWJzBCr/bRyoSIIrKV8cpZJPWbWGhZObo8e4
   TCISHfkY8xkdD8XL8HT49fAQa8c6//KDEfXC8pK3FXhnaLBpq4nd9lJNc
   pyXim1qBNjygo79SLjvQXVtJJRK599R1laO9L0xgUnQCh95TJf768UE9r
   NQC2eiwGq97hN0zX5a+K5orowkqthU/n7Us2mpAWP/63/mMYwV58DTgYb
   1dnxRYme/pAzuoz3hP8+qq2cSBQzuheazFWZMQfnEqQ4QeHnWyj0KHzsy
   A==;
X-CSE-ConnectionGUID: O0yclRdFTby6T8sB94PA0Q==
X-CSE-MsgGUID: WPTpBQ1+THCx5cvv2W0V8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11321"; a="55260473"
X-IronPort-AV: E=Sophos;i="6.13,221,1732608000"; 
   d="scan'208";a="55260473"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 01:01:04 -0800
X-CSE-ConnectionGUID: 5TXA9MucQ9SI0N06DlNGwA==
X-CSE-MsgGUID: S3wptk8gSwWF9W4TZsKkYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="107178823"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jan 2025 01:01:01 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 21 Jan 2025 01:01:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 21 Jan 2025 01:01:01 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 21 Jan 2025 01:01:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zq5wuKuWdxDP2XoT73cXRRGK5qOReszs8gvDPkBa842oiiZSx/WSPAQG/3+/4YVsb7qvvIz5lr4me8u/4jrp2DkwShEtrnbwbTzoT1OLw/xXf57zmWDqLmrZhKnt0hruQdFG2uZd/8Fn6oHHwSBFVcxpiwChdT7eXAf+Uc8pbzs6XBIgkC49y/ETY/uvr6tyB8KxNvM0BIQ/KjGFrADGd0dS0AFp6sYFLBJnL9jOfeFl8cuKNPhanoDsyLefTmBv0Lby2KYxlrx/k5obNVpm0BbFKj4g6oQ0U+k1mE/JxkeakcyNpNauNT9g2y4EsO+CY6Y0y18D2hCxaR8alisuAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WP+UajFFpcU331TkgKKtES2LtCk/b2m+NueOX9Uo140=;
 b=Ttwlc7SV8MDR+FRY8dvWaVTX6yvXolu5c9Lp2c8CC7QDqVPEREXprlEUZVM5r1S9C7WzPApeM2XE+w5e48TCzV8oMyIsF8dC8feEhwrlT+N7/+HvzYPQoYnduTnEzT/zBgHusPJAjDnw3R5207a4dh1EpkHdTHfMuhs25xffQrOZXjumJcyCoozqjQQehtutVpGFaIiRUqkidDN2NLL9X6Wq+d+7xkqeaY3VbDFUutlSeU+mVA99anw7isHL2271DTqg1XQe2cGnldcEGTNTV4l6hCsMraz80yuLJHTNw/iLxvx7nbVfiZa7a/KaEH9yx3qAgdnbAD77vQZdTJTrvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ2PR11MB7670.namprd11.prod.outlook.com (2603:10b6:a03:4c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Tue, 21 Jan
 2025 09:00:53 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 09:00:53 +0000
Message-ID: <a55048ec-c02d-4845-8595-cc79b7a5e340@intel.com>
Date: Tue, 21 Jan 2025 17:00:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Peter Xu <peterx@redhat.com>
CC: David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	Williams Dan J <dan.j.williams@intel.com>, Peng Chao P
	<chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com> <Z46RT__q02nhz3dc@x1n>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <Z46RT__q02nhz3dc@x1n>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::16) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ2PR11MB7670:EE_
X-MS-Office365-Filtering-Correlation-Id: 77e2e8e3-b832-4eb3-e636-08dd39fa1bea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MHI3UDdUMklPa2NjQzhyRXpMK01aVUVlTVBzV3hyQXlkL2V0WXF6RnM0RXZY?=
 =?utf-8?B?Z3ZGcm9BTTlLOFBoZ3ZlTm5kVHVBVklnNEZoNnNIYUhHNHZPanFnRVZ0RVV1?=
 =?utf-8?B?akZoVFI4dkFyaFBjMDRBTGdPQnovbnVHbnM4L2xsU29rRVdhdWFCeGtlaGRt?=
 =?utf-8?B?VkY3ZXVKL0RqUmx1cU45K1NxSjJXVFBYTkdIU1ZUMi9tSlZqNXQwcXNVN2xH?=
 =?utf-8?B?UHEvZm5EZHFxd09wTXd4dFhudm54bDZxNXBNRlJ2VVVBMVRURGdPMHdNeTVH?=
 =?utf-8?B?cjFmUENzQXBFdkZ1TE1QLzNvM29vcUdZNS9PWW1YMHl5elZMWkhvYWRRdDR4?=
 =?utf-8?B?ZCt3aGpIOEQ5OHpGQjFYdEpaQUd3Q1lQSnlQTUxrMEl1QXFxcm5Zb3EwbWlQ?=
 =?utf-8?B?WXR1cmkzbExVV3Q5azYwMzhyeGdNaFZFTEduTVlqL1grREhKa0FWZVlCUGFx?=
 =?utf-8?B?bWVQTXdrUkZGZU5PUkl1NGpxVWRrTU1NMUFITVlWTUJFaEpMVklpN0JJQ3A3?=
 =?utf-8?B?WWpDSko5cU5FcUFLNFpvRDVTeUpGT2RtaUNSL2Jab0ZLR3N5emxrSnByNHNk?=
 =?utf-8?B?a3RmbkRxL2JNZDhLYWRsU3pSQjhpcktkTWhuK0oydjVydFlmbG5OYXBBcUZT?=
 =?utf-8?B?aCs2aDFGejhjWkYzRWJuU0Z3ZUo2dkM5ZzNKU0NCV1oxVXdNNDBFZDMxQXR2?=
 =?utf-8?B?eEFwdmh3VnFESEs1ejFIQVdDMkF4UEZVc2JKZFkvYVcveE9UVTlrM2JLL2t4?=
 =?utf-8?B?OVRwdGxIVWpOZ2FGVTYvU1VEUmZnQ3c4QnJQc2RaM0YvcTNQRDFaL0xPNGNu?=
 =?utf-8?B?ZktCWUJ2TGRYU0RaWkg0NlpOTm1VM3B4VmZhKzhLbzd2WnpJS1NoOGxpY1Nk?=
 =?utf-8?B?VGVPRjg2VG96ZUdBenZTSWdITlFPTXR4V0ErOFpWSmpCUGkzNTdITm5ySFU0?=
 =?utf-8?B?Y1J4Z2J1L0dKcGE5d2J2cENZNmthZ0VPbmVTSzhzQVdnYzVtYVZaQlVKbnR3?=
 =?utf-8?B?UGhQSlpsRmYvOUVCZ1kyL1ZwSStRbVl5d2NRaGI4WXp4djVyekZ6WGJPVUJ4?=
 =?utf-8?B?TVZCRWZZQnVxMTkwNGtKQllINm1xYkt1TWd5a2d4cHNtM1pmMkMvZjIrb040?=
 =?utf-8?B?a1ZNMlExQStjMlM0bk8vbzRDSEw1eGdyTHc5Z2xYRG9FdzJGR0NqZ2NqL0F0?=
 =?utf-8?B?TUh2RkpaWjhxMFBUZjlINVpxY0Z5d215U295SlZjMHYzRkZTWVREVGh2b3A0?=
 =?utf-8?B?VFlEd0hJMHZnRnRtMWlXbjVzMXBuNmJ0Z0F4NTlxWUtCaHNNdWJMSkttRG5z?=
 =?utf-8?B?bEYrWk4zcTA3bVVCQ2pRT2NBcDRFdHVuZFpZa3g3N0lWL3lKWE1KakdIb1hG?=
 =?utf-8?B?Q3hCRUhPdklmdWJiTXp2V05uUGN5ZWo1WlNRUWVOdFkrem8vdUhmWWVPMHdG?=
 =?utf-8?B?d2ZLbEkwOUJLVklOUVBPTjA4WW1HVU5ya1pWYnJiNHBBRmdidUttSkRTL2Yv?=
 =?utf-8?B?SzgwVTRWL2ZvT2htcjBpdWUvdko0bzZZMWRmRDdyRFpsbVVydUtDV1lhQVc2?=
 =?utf-8?B?bDB6a01kellENnlMeEJkb0F2VzZ5OTlFRS9FREVKekN3M0RFTm96Rk50TWNN?=
 =?utf-8?B?SDMvbWFyVlhYaWRGQ0hpc0JRdTVja0dqR2VyQnJES1dnYm9FRUhqVEVzN1pn?=
 =?utf-8?B?SldmM1J4emVPVXR4RklmbnF1U01HZjZlc3R2QVh3bkRsZW11ZFVTUTVIaXZj?=
 =?utf-8?B?WGVjQUNUck1veDVZcTRiektLOE9aZmQ3MzM3VnVrWGdleDBUdExjbmZuTjNi?=
 =?utf-8?B?d3hsVnNGWTlzcFlDNENDVmQ4bmt2eE5ITjNKN3VCYzk0WWprSTdzMTR0VHZl?=
 =?utf-8?Q?cbbFvXUzelYk7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tno4L2d4azFyL2xxbHdBSndoZzA3SGVVbEZjVWVaYVJzcG9aenZtanhqL1Fq?=
 =?utf-8?B?bHIrUkU1S3lHdWxpY2N6MnhxUGpvano4S0h2bCtQMEh0MVB0WWFsa1U1U2ow?=
 =?utf-8?B?WXRneUxnQW51UU1GZ2poUi9LTFJuRUZVVWVqU2haZk8yL0ovRG1Md0ZRMEVx?=
 =?utf-8?B?aXZMVTlmMy81VFpUMm4wUkZoZDNUUHRzcE1XN0RSMHNzK0pwcC9JU2xDQzd3?=
 =?utf-8?B?UFJ1TVJSV0JLWm9Cb3owZVpVUmRETXBLZHltMkIrcTRleEo3TktPTEhWS081?=
 =?utf-8?B?VXZZZ3pzMDh1RmQ2SUozNEVIMFpkSUR4Tm5NMWFOcjZaWENpUno3K29VbzFP?=
 =?utf-8?B?Uk5GYllHTURzWkRmbkFYWDhiakxPajVObFRObGJWcnp2bUlySGg4b2NGa1V4?=
 =?utf-8?B?Q2VaU2FoaGhnOHVQUjgybVFjQWdHM3hYWlhld1dGeVU5bWFNRnJsZkwwYjJN?=
 =?utf-8?B?d0tEYVVtOUxzWHJia1ZiVm1SNFlFQkdPNE55b29PZUdBbmtkVDNpSytlTUtJ?=
 =?utf-8?B?bnlyOC9HV0JHZVRabmg3VlEzUS9FYUF0Nlo3RFJ3MUpVUE45Slk4SDRGcGNq?=
 =?utf-8?B?a0dmL0NvYUUrdEp1alhsdGpsbExSTzJYb05OQURkaU9neXhIdXBrb2VrdGNC?=
 =?utf-8?B?SGQ2b2lKc1VBcENLTm9ueWJFZWxHMXJWWmU1WXNiUTNMUmFWMTdmN0VYOWV2?=
 =?utf-8?B?WEYvcTFKTlJISllVR3NIeWxtWnBiSDVxSzVpK0VNRjAyLzV3MCtsZ0ZKbXdK?=
 =?utf-8?B?Z2xmMy9UVnZvVGpsOFprTEpxK082WFJGYlJPTHZDNTRkSEhnNGJsMkh3dlo4?=
 =?utf-8?B?VVdBTCtIc1BkVldRTzhIVkR1WHVmTVAzWTBuQ2Q5UHN1MmdPTWxQbFNlWDJ3?=
 =?utf-8?B?ZEp0UnA0cXdkR0YwajlJcWhKK01vNmhINlpxZGlhbkdQT1ZIQXJJVk5HRldi?=
 =?utf-8?B?Y29zWVU0U3ExSllCVHU0SGtxL0FsN1gxWFdpTEFmcDFIVGo1dlBkY0ZvRlFn?=
 =?utf-8?B?L3hFczZ5U1FPUm1nM0xLeDl6ZVFiVEErZm1MQ09xR21ES0pURnhrM2dXOUlV?=
 =?utf-8?B?L1M0OGJ2aUJUSXNjYnhFUmVJRXIwQ0lmcFV4RFZrRUpzMUNkMHN4ZmJFSnRZ?=
 =?utf-8?B?VEx6YWY4Q3VXQlhzN0liNmF2UUNRSERBRFZHRWxiUzFYMnZ1bWRydGpVMFQr?=
 =?utf-8?B?RzN3UXdybjVRdG1salNMOE04WFdJRENrenFreTI4b0JOSUpIVjlUZ3ptY2Mz?=
 =?utf-8?B?eE5uTUtuSkxOejI0dVo3ZnlKZ3BGQ0xSZWRMdmVKd1VIcmNIbVc5aGh2REYr?=
 =?utf-8?B?b0xBSEF6akNscGNrN3YyWXNGOUZqdUNlYjdraEZqbE9JQkNVbERDNDBoMG5K?=
 =?utf-8?B?QUNtS2lnVXZTOENqT2F1aTFsTXNHWTlydmc3M0FQMHlpWHRWaXd0c0lNdE5w?=
 =?utf-8?B?R3dFOU8xeFk5Y2xyeHRaNkVrRlFSZXJzWkE4UjVwelMrVDdBUm93WVBqeG4y?=
 =?utf-8?B?R0M0UnM5UlRaM0JLa2VnS3VVbldITUUwYk5GMVpXTzU4ejRCcWNJNVBtZjNC?=
 =?utf-8?B?L3NRM3FhVGsybVpOTkdGZGhVRThNWERnWmp6QjNuRUkxN1h3dzk4UHNyVC9h?=
 =?utf-8?B?NTg1Q3FZQXYwYUg2bjRhWWhkQXBveGZqZzBJeHRWeWFyaFU5ZktoVENFT0JR?=
 =?utf-8?B?RURIbjVLK1VMaGpSdVRlWFVqeWR2VEJLbzF0T0V1NFkwVlI1RE9jVjVpYUF2?=
 =?utf-8?B?cmJ6aW5PSk1qSmlKWUR5S25Bbmx5ZGVveGNlaWpKQmJ3M0tpc2Rzc1BobXd0?=
 =?utf-8?B?QnA4OW52Q1gwai90ZHg0N0R3VHorK0tjZFhoWEZXM1c2dXJpMytUWDNINGZB?=
 =?utf-8?B?M3g1M2FZVUZIWjNYdGhmNGR6U3R1QWJrQmx0ei90QkNkKzA4Zm5QMERXajF3?=
 =?utf-8?B?SkFkVG1qN2hzTzlqR0tSZlBnWU1WVXlkclAwS0s5TU82SVgvRjRaYjJUaDRL?=
 =?utf-8?B?dnZVekNteU9mSGhYVE5jYldnNGhwZ0liampITXA1bml3SE5NMXBtRlR6K240?=
 =?utf-8?B?OVNYRzE4dnptd0F2MWpCRTVDeHJsQTREZnJQNU43Uy9ld3J6THZqTS8wTTY0?=
 =?utf-8?B?TlVmNldDd1c5c0I1MHVEanZHeDY5Rnl5T1p3WHZyQ0NmZzdkenN0NTNaUWlG?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e2e8e3-b832-4eb3-e636-08dd39fa1bea
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 09:00:53.2800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CDrqPA87mDXymMeEMItPrj4r1zEltZGNZqUkEkPU5izhEou2P9jlQEm3UcGM/pgYh0eirfwPx1+JuxRYrrhog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7670
X-OriginatorOrg: intel.com

Thanks Peter for your review!

On 1/21/2025 2:09 AM, Peter Xu wrote:
> Two trivial comments I spot:
> 
> On Fri, Dec 13, 2024 at 03:08:44PM +0800, Chenyi Qiang wrote:
>> +struct GuestMemfdManager {
>> +    Object parent;
>> +
>> +    /* Managed memory region. */
>> +    MemoryRegion *mr;
>> +
>> +    /*
>> +     * 1-setting of the bit represents the memory is populated (shared).
>> +     */
>> +    int32_t bitmap_size;
>> +    unsigned long *bitmap;
> 
> Might be clearer to name the bitmap directly as what it represents.  E.g.,
> shared_bitmap?

Make sense.

> 
>> +
>> +    /* block size and alignment */
>> +    uint64_t block_size;
> 
> Can we always fetch it from the MR/ramblock? If this is needed, better add
> some comment explaining why.

The block_size is the granularity used to track the private/shared
attribute in the bitmap. It is currently hardcoded to 4K as guest_memfd
may manipulate the page conversion in at least 4K size and alignment.
I think It is somewhat a variable to cache the size and can avoid many
getpagesize() calls.

> 
>> +
>> +    /* listeners to notify on populate/discard activity. */
>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>> +};
> 


