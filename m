Return-Path: <kvm+bounces-29934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 161469B45BF
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 10:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 390C51C21DBA
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 049F21DFE03;
	Tue, 29 Oct 2024 09:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y/tS/23F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB4F1DE3C5
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 09:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730194232; cv=fail; b=kd527DwTJ1LSgZRxW1fWQ3LyzNnCfuNvyveyHp6mon0asXEydot3fAVmXUO8kyYvKTScqhw+t7qum5UucsAmX2L8fSUVaVqc6DNtJNLz1dgyCZXRGvlzwB8TdQEJe+kwoEPcw3O5nshzO2wKGxav/y58AnaiYS26S5q0kcXjJvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730194232; c=relaxed/simple;
	bh=hMXWgOmLjT64WVbbf4i8qYi7mLqOnsi7W43KM29CSeI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RC4k/X+tKpymbRORFbgU2KwTuwVPbKzWBTVfo1EN1RVEbPxf1fC0L7E7hx0R3ez59jxp7mTP2bkd0LtGcZssrG6ijbZmPB/bPpTSPe6+4+vkHqXmqpCrI2gbEMPQXCsBNXwWr3oMLzRDm9rR9+0jmYbbNXwDUwGeU6rm/wn6jSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y/tS/23F; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730194230; x=1761730230;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hMXWgOmLjT64WVbbf4i8qYi7mLqOnsi7W43KM29CSeI=;
  b=Y/tS/23FKohLkPxn2A5Q720UbrKmpfYBop6hwKeOIuO/Z0fB1+GdUlxz
   two3mF97Vs/clqYT9XM+uATAxYJHKflsjfQqUXobPj2iklRyHykWoHSAy
   3QB18aqMtm5uEeHU1xuvEBmsOb4XKEZr/WP3y5c9hKpDN556zVny81Fd1
   mpNOkEynGKEmX/9ox4rFcWqYByby0dPTqKiFpocA7Kl3y2BiF0rg2jZ4G
   rHGVqmEC2K4QAgyiVDz/Y7quQolGF3svI8z6kKL+CbMaYDGHsy75nYLAp
   Wl/NNsInmtbwyzj31UZ/5hENovF92qosDjMyBzuxUdzRw33hCOvQ4kseo
   Q==;
X-CSE-ConnectionGUID: 49LKcb4bRcud7iIPncFlRg==
X-CSE-MsgGUID: 3JImrADLRP6GhnSQdUtw/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="29254807"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="29254807"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 02:30:29 -0700
X-CSE-ConnectionGUID: Rn6IFltHTk+KegKwv4tD4A==
X-CSE-MsgGUID: ve7e0ylXRQaoLOh/d/me5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="81520851"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Oct 2024 02:30:28 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Oct 2024 02:30:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 29 Oct 2024 02:30:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 29 Oct 2024 02:30:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K8vtg2ijIxcu1z235so3R7GVLnkbYtjoB9iWR/CpH1UOZZviFkRulhTUOrJNqvUFKTCkDZRmZLjxpm/HZbzkXS1kMzL1ldbduCCOvIZPPlXg6kb1sNLi6X8s8Jae8AKPlhJTTVGnxvAlfYnPPFZR5eSvTfZTEdSERKfd/vKiqjvoLvF7fIsmyC23yfycjnwcbLeMmkQgz9SHyw2oKszUat2CwCmgGfU/tLnJjID3nbMai9IL/Hbj2F0eDlMrYgCwZxXwevvdCAdbZkecD0RPCY5UUJ9ug2DHbMeuNC5ipHfSJyagmlZfW17WlsvTi7yJ1HA+vW/LiJtjlm5LUwCqpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzq/dc/3GZ/Rb4Xcvd3ZeFkjvCM5fz2wqwesRJZqHpc=;
 b=MRpAAUXsIHvLTqXhZ648AFq+Sqdl86dbek+WsmFt5Rlckma3oJTRnXopadnWfUEEC72hHLrpp2v6sLKTOfSaTWrQoVuhCaORP25RMIVomEUehCWTCtp5s3J1UNiX/Wgu0+cJR93vp0JguS45WjKIU6m3aeoKFWXylEtVZ7jlxvulNMQ3qQHpxUDDw37S5IOcCGkSJE/WZPbANKYhvhMUYy733HjwZZ2tcmDpaAsfkvqwpVAh91hPGWxao0iGkqz6uq8taRFfqsv9h+tIo0/ClpPTPjKagU1J53G4O6huabhJW3RvuWnQar6Qldg8oXuJcEWd17j2LuSeuZ0Xe9AswQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5029.namprd11.prod.outlook.com (2603:10b6:510:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Tue, 29 Oct
 2024 09:30:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 09:30:21 +0000
Message-ID: <af8b699f-7e79-4787-ba0c-0c998b75d164@intel.com>
Date: Tue, 29 Oct 2024 17:34:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
To: Zhangfei Gao <zhangfei.gao@linaro.org>
CC: Joao Martins <joao.m.martins@oracle.com>, <iommu@lists.linux.dev>, "Jason
 Gunthorpe" <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, "Shameerali
 Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Yi Y Sun <yi.y.sun@intel.com>, Nicolin Chen
	<nicolinc@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Zhenzhong Duan <zhenzhong.duan@intel.com>, "Alex
 Williamson" <alex.williamson@redhat.com>, <kvm@vger.kernel.org>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
 <CABQgh9HN4VnL04EbadWh9cQf+YpTzvscvXBdHY8nte6CW8RVvg@mail.gmail.com>
 <b7f79653-4bfd-42f6-a641-479d2973190f@intel.com>
 <CABQgh9H8LJstiwDon3=e2uMruVwCS9AyGutcct6WyMODSo5=AA@mail.gmail.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <CABQgh9H8LJstiwDon3=e2uMruVwCS9AyGutcct6WyMODSo5=AA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0209.apcprd04.prod.outlook.com
 (2603:1096:4:187::12) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB5029:EE_
X-MS-Office365-Filtering-Correlation-Id: 16123d92-e449-4a9c-1318-08dcf7fc4ee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MW1qRWg3RTJXa3hxVXJJb2UzTHNoOVg5U0lwQ2FXYzQ4TEtGUnVlMUtHZmlF?=
 =?utf-8?B?VUFZUTdmNHd4bmw0Q3JFbTRrby9Pb05XTXRSZEtFN1hoK2lhQSsySmJKcVJR?=
 =?utf-8?B?Q1dZMC84RDFpWDRLU2tTK2o1eXJNUlcxWk9XOFJ1eDNhNkhtR3E1THNNVVFo?=
 =?utf-8?B?OHRiWnV4V01jZGoySmowNDhPUUVJLzY2MFQxM3BSOFcwdGdnUjVmMzhYOU1q?=
 =?utf-8?B?MDNOVkVkT1g5YnBIS3pEOEUxdzZkSGl4MHNGenhPUElUMlZCdkJ1WmFtZUdT?=
 =?utf-8?B?K1pQVXlDeWhZcUFQYTJkbXdNK3NMTTNPVWRWMTd6TjRobW9EeGZHMkZSMFpz?=
 =?utf-8?B?SXFhbzk3d3Z1MW5MSjdwdjBWZU1HYTJqaW42QTZVUUZkYWNWUkl1SDd6REVm?=
 =?utf-8?B?RHdBdXRJL05qR2NyWlVORkszWXpKTCtmbXcyY2lZMGwzOWFiZjdWM3pYTjFT?=
 =?utf-8?B?QWp5UTJPSTJIZFJpWStSS08zaFZPVWxWRGFCYmNRMmRPWDI4dEthRWtUdUxH?=
 =?utf-8?B?VnpWSkhYNk02WDN6bjlIYjFiY3hpQklEcFhHNTdvSjZhVS9GKzU2WE9CR1ZU?=
 =?utf-8?B?MTJSeHJyakkwaTZGOU1jT0NWdW54UXJpWk1JNkNpcEhyS0xBTGo1Qm1zeHpZ?=
 =?utf-8?B?S3lvSGVlWU9RZmhsaG5lVW1BcHVSak51VG1DKzBJOTBObVJoZGlEeWRkT3Bq?=
 =?utf-8?B?diszVkhxUzRBaWNxeHlQRmFqZmIvT1F4VVdJZk1EUHVDaFAreDNwQ2ZaaWFP?=
 =?utf-8?B?K3JYVEZjWS8xWU9PYUxVbnpYelppeVFXOEVXWndlQnphaXlpWFROenNPNzhM?=
 =?utf-8?B?bUZJc1hXU09ZSXVZcStoZ1ZzSkxrSUoxMnoxSWVkS2VLelltODdMU3k4d0hv?=
 =?utf-8?B?citoTXFZYlc0TFBwUWNySGJuZE4xWXpTR0J1ZDR5VnloRmdPaU4rS1BzV3B6?=
 =?utf-8?B?alk1akphbmprZ1kzenA5OFhqVlhQMlZwNTB4Y3Mvb2RUK1JTNytMeTdOSmhY?=
 =?utf-8?B?cHh6YkZlRjJSVWZ2WWtndlU2Qlc5NFdpanpESjNDT2R6RFgrcjd5SkRPbWlj?=
 =?utf-8?B?MGRpZGlsUnNFeDNraWttYldaZ0RNOWJMUUVHM0RBb2o2NU1BRWJCRDdMeEJi?=
 =?utf-8?B?VlZVVzdnaWYvSFpxVERTbmpHeXlVQ0xqd011WGIrYnNjby9USkFrV3BHTXMr?=
 =?utf-8?B?akRyR2d5RVlucTB4dVh6Q3BjNjRCOXFLTTBGMitwYUd5a0pUa2xHdUx0QkJV?=
 =?utf-8?B?RGhHTHdLL2krcUR4eUk0cUU5MGo1Y2pISGo4VkZyWjMrSlE2U2RGT25RL2Fi?=
 =?utf-8?B?TlBSSkdmUFNxS3puOHQ4WWwrS1NaWmthaWxNa21nN09kaEUzemhnSGJ1V3Ra?=
 =?utf-8?B?UldURng4czh6NFlBZE1zNS9OWUdaRlU1cXcrWlNURGNkV1VHYXoxU0FZZld1?=
 =?utf-8?B?WlV1VVdhSmxMcVNJS1ptUDdYaXhsZUdpRktuZ3hiSFVldWxYZG5NbFpIeVVy?=
 =?utf-8?B?QzZ6K0Y5SElJeS9CUElDaksrRjVtZGhMY0prSUp2OWlKcXR5ZVFmZW55Z3pF?=
 =?utf-8?B?V2UrUVFWWVlxblRGOE1TOHB4SlNSSXZuZVU1WnFQSGQ0M0JNemFySy9SaHNk?=
 =?utf-8?B?d3VRMTREN25xamo0bXZTOWY5K1Z3RVpIam9sNVFRNkJ2clNGS2VkeU9pQStH?=
 =?utf-8?B?TGhsQnVmNS8yd2FVcVlSMURpcUlYWEZpZHMwRWswNlpNYXZhVHE0TzE0TEhZ?=
 =?utf-8?Q?uN/1yuxoV3ph28YdVQap6URjEQqb/I+eQCLSSQZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFgza3lnZWc2bnAyVmMyMlpDVFZhbDdYeU9LYngwMWNsMTRmOWc3OVQ0YytD?=
 =?utf-8?B?ZDltTEVZUTlMVFI3RitUTndjWEpadnBOVzJzQXZZYzlBQzAzRG96NE9GN2pz?=
 =?utf-8?B?V0Y5SHlnVjdVcEh3U25SelF3OG41QXRNaGM0aDNMaSszZzlaR3gxY1lpUVY0?=
 =?utf-8?B?WkFhSWFhNkR0SkZhZm1vcjMwV3hwcXRnVERWWTdacHRQK1doK1hmUHJjOUha?=
 =?utf-8?B?Ti9uQWJVRHpHY3U0TmZLRGZyZXB0cDNHMERYTmNKNm80UkE4Mmo1MDl1UDB2?=
 =?utf-8?B?TnZmV2Z4dm1GZEd2OGxJdS8yQXJJbDF2amRUN3NYOEVwaW1EOEx0a2ZINjdU?=
 =?utf-8?B?ejJGSEpLdG1kbjNuTDB0bUNTQ2k5bUQzL0haZVhkV256U0dpYmlDdXFOS1Rq?=
 =?utf-8?B?bk5DWHlIa1hvdUJ2V201TXBVUVdIV2F5alhkQ3IxRFRRZWUyVXNGUlFUUEY4?=
 =?utf-8?B?ekFPQ3FCbis4cHBvQTFvUFdJbG96cDJsRzJrZzI2aW5kcjI4S1JLbUhiS0tj?=
 =?utf-8?B?WXo3MTRrMUowdEp0OHB3RnBhN1A2ak5iQzRhYjA3djlBZ3BneUIzZ211cUVF?=
 =?utf-8?B?QTJLTlM5TUtCby9zSFZWaEhQeW5DRmZrZytQZm1WREFRM0ROc1NUcWVEVTBw?=
 =?utf-8?B?U1Uwc2JlMXlPM08yRVBIOXdjSVlpalF3aFhFdTRERlZYc3ZodlZsNHIrTVpa?=
 =?utf-8?B?OGZFVThxaUI5NHNhVk44ZVVpWXpKU1kxVDhCb2RPU201TllFTWlhdys5Q25l?=
 =?utf-8?B?S0hza2xoNEF0cVEzTlFzMDF3bTJKZWVzVGcyL0l3WkNRS0VqSHIzbFJ0TlBk?=
 =?utf-8?B?V29PU08zZ0JMRXdjakRNMU5RWmxPSVB5dHVyZTYxalpwdFB3dGRBWk5VUlZ5?=
 =?utf-8?B?cVhmOGJMTldiMUM3SWhjNFpTaVgrZU81VWQvdlBTR29PVngyQ1JEWnNjc0xP?=
 =?utf-8?B?WkdUT1FCK3VNRU1sUUZkQWxpbmRYSjJ6NzFIUEo5U0pDNjdJc2huR0N0WlpW?=
 =?utf-8?B?K2dJVVE0cnE1U3owblJ2dWdYQndmc3NSRTF4VWtRenM3Rno5aHpFY1RnZzZi?=
 =?utf-8?B?YmUxcWUxcFpmOEx2aHZoZjJ0bUw1QkhQWGgzTlh4Uk5TQnNhOVBFWkFVRTM2?=
 =?utf-8?B?cnFDSkJhWWxic1pLZUE2cXBkWFpXWXRoZC9Zc2d4MG8rWCtNcGc3ZkcrYlor?=
 =?utf-8?B?dUtJcm5kazZjZDJSL1lrbVd1Mnk4b0VGV2J6WlVWQnY0OTd1d0pJUmlFZE1Z?=
 =?utf-8?B?Z1VCb1hjNzVzY1ZRUTNQVEthZnRPTllvdUduNk4ydGJvWWtaRStsRkNEdEZ5?=
 =?utf-8?B?ZDBYTHVpdis0UWh6OFNGMEdDbUQxZnE2bVdqU1pJdUduQS9VKzNWSVoyYlNi?=
 =?utf-8?B?ZWw1aWtCSm52R0NoUHM3RWZ3ZFVoakNXSEJ6aGV4UjdqVFZtTVBJdCtuWitk?=
 =?utf-8?B?VHRMZDJPWnlyYzU4KzBLWk9NMmNyUnNoQXNpcW1CTDJWVURNbUFtWEpNWDBN?=
 =?utf-8?B?dzdncTVWZHp2M2xDR3ljeUdNS29wNmZqNC84SUQvT2E4Y0hUOHJUU1h3d1Bq?=
 =?utf-8?B?RzdDVnhLOFF1RjBaSDN3RkRXY3JYZkpQYjRtL1RpV05HSTBOWjVNQ1YxbTZW?=
 =?utf-8?B?VFd1T3ltMlluMmU1UDhpckJnNVZnL1lINHpFcUhnNkRXTXh1SDVLY0RpUHRu?=
 =?utf-8?B?WkNQVEZwbWxOUEZNMVZuZHpDNDlxYndnR0NCZ096UUZmZ2RXZkhLWU96UC8x?=
 =?utf-8?B?Unp3TzM2OThmTnNiVTFKUEtTT2xnemJuSmZIT2NkQkkzYitZTE5HeUIrR0NC?=
 =?utf-8?B?bUhZQ0I1UU04ZjFuZm5sUFVHWjJNL0thcmpCY1JQMHQrQUFva3lDU1o5dTA3?=
 =?utf-8?B?NHJDUlptejV6aUE5Y2RvaVcwMTA3blM4cllYMlJTRFBZNUxXWDdpMG8xd25x?=
 =?utf-8?B?LzZHVnBmNUUwRUg1OWtvVGEwMkdHSUpkNFJveHJ3MUU0WjhhSHl1N0tHRnNI?=
 =?utf-8?B?TWJWeHJXOVRIS0k1YnRUZWw5bU04elJLYjFLb0pzdHBVVEhHUStSbUhKd0RZ?=
 =?utf-8?B?VjU3dlFqTmhvUXBGZWszditKd3IrQ3J6ZjVlYVBZVkVzUXNMendCRVpzaTl5?=
 =?utf-8?Q?Loq66ay5ILqg7c2Hfv86GZ+p8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16123d92-e449-4a9c-1318-08dcf7fc4ee5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 09:30:21.0282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmZxxD/2aceGZsG+sTFG0UYy9haIAP4XWJtsIGIw29VhUUCn2gMGTZXz6/8HNKOxrPbhj03FC/ocEFgk/aEduA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5029
X-OriginatorOrg: intel.com

On 2024/10/29 16:05, Zhangfei Gao wrote:
> On Tue, 29 Oct 2024 at 10:48, Yi Liu <yi.l.liu@intel.com> wrote:
>>
>> On 2024/10/29 10:35, Zhangfei Gao wrote:
>>> VFIO migration is not supported in kernel
>>
>> do you have a vfio-pci-xxx driver that suits your device? Looks
>> like your case failed when checking the VFIO_DEVICE_FEATURE_GET |
>> VFIO_DEVICE_FEATURE_MIGRATION via VFIO_DEVICE_FEATURE.
> 
> Thanks Yi for the guidance.
> 
> Yes,
> ioctl VFIO_DEVICE_FEATURE  with VFIO_DEVICE_FEATURE_MIGRATION fails.
> Since
> if (!device->mig_ops)
>      return -ENOTTY;
> 
> Now drivers/vfio/pci/vfio_pci.c is used, without mig_ops.
> Looks like I have to use other devices like
> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c, still in check.

indeed. You need to bind your device to a variant driver named vfio-pci-xxx
which will provide the mig_ops and even dirty logging feature. Good luck.

-- 
Regards,
Yi Liu

