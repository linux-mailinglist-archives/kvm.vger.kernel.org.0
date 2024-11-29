Return-Path: <kvm+bounces-32766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C2B9DC02E
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 09:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 477D4B22D08
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 08:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E58A16EB7C;
	Fri, 29 Nov 2024 08:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UstauiNB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517D845C14;
	Fri, 29 Nov 2024 08:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732867227; cv=fail; b=IKfq3IyhHAGiVRpuvjNnHlLYdLf23VYUBhrzNc8nYNqKWu+FSklaAazTy5Jfhx8kB0LkIa82o69sSnmlJkI4WLn0TumqmGWSCp2FHFXVdCk3RZmZ+vheNC5w1QIcWHiOZFF/+zxAxHUd3bc94sX9CFPy7s3EMk5zHLYLI9Iz2Ww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732867227; c=relaxed/simple;
	bh=dOtJD/DlOVvzcqibVu9Tk5mHN4/AivsHzTGFH1aQJUo=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ya17xEBHcS/it4sUxCLonPtNXIZxVmqA8fcxnU5B+xXJqVukG7w+HzvdO8dRNToZdSZwrjp3bMcdq5OnQiIqNL9GP61/bXTgdxLsS7ui60r4F5RpYOKEd+bI6oTgaeDAQNy06SzoEIuN1tftGuHFX3De906/gYMREWtSJ3+JDjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UstauiNB; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732867225; x=1764403225;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=dOtJD/DlOVvzcqibVu9Tk5mHN4/AivsHzTGFH1aQJUo=;
  b=UstauiNBtvMkT0cXqX0QAaKytmcl3OvNIxGjSn2sKjiJMp/aNvx7mz8K
   +cKpCAlm3p6pLn3u+xGKl4fdIeP0DOgxXrjsdOBWG3hWyOSG/7CwTRNk5
   6x3rO1oKUnbjwStoZhL8eyISS0cNE017TvKncxYrOkuET9oduEwryDvPQ
   gsjYMmI05SrmzgiL5XibVPK/5rKrtXePiyr9CGFTu5/lduILW0PPhB4nT
   h6V8LhhejFfPXOQFA2GXUCwr+7urCgZ9EZhZuIfLdn3WaCgySLYv8OfaW
   xKgfu98xPyQeKmokfoFnp65txyP2wn7sD+5BzTHNr0J6/nxGlxQq0IGlS
   A==;
X-CSE-ConnectionGUID: r00IJ5msS7+PlwTOdOkTjg==
X-CSE-MsgGUID: oYeglwjZQrGEF1uvmMqPpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11270"; a="37032330"
X-IronPort-AV: E=Sophos;i="6.12,194,1728975600"; 
   d="scan'208";a="37032330"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2024 00:00:25 -0800
X-CSE-ConnectionGUID: zF7YjYnrQ12BWxgxsYDgsQ==
X-CSE-MsgGUID: iqoMZTYBSH+RES7b4JI8qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,194,1728975600"; 
   d="scan'208";a="115705521"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Nov 2024 00:00:25 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 29 Nov 2024 00:00:24 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 29 Nov 2024 00:00:24 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 29 Nov 2024 00:00:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elUe1SCWegrt/1HXuL8HqNiXPC0BvO9fE0Qml17KBklOT+xf9Yppu2e0BdWmblQUCfiodIBLz0uu/wd6Lz3FdK3TBKmt7tvmo7W1hw9bw2fgPiDo+n+cqrzcXKg8V1Hga1WcHpeUN4RJtALnBe/I5oS0A+EfJOZCgdz6sFGsUtoBHjff1eCwOxKEqrJjAV1qYDV5X+mKVQgmjiYCAmum4LBUeTVbmMaV6Qp2lzuXmAKy9YzezO+NeNgEjzRwcTAlMRJ5+jY2wUnlJJGd9ZSaV+v2BBhoH4TOL1EeTLSTyLHUryQyNhC2MxGZMN7ffbBFjRXMKMb1On1uYz3Rb/0KOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AcuqJo0PJIyuxFLtHaD876w+HlgTnObF4ctzhsiA/0k=;
 b=mrXErn2h4M4cHBytm7yIT6birbukZb+wozI1n/5mBIV4KkV8dDMToLpeA4oNK89W6Ua0toNoKI3d3Eim1yV3+EmM+kSAKFrIcR+nvO0dZ0JUefak3JTSlDfLS5ZVdwblRiXJhqFMWjJ980rPWrg0BI4JMDuolYVEoYTZC9y9r3rvXTMHR+cLnF5Wg1aFGlVL7l42SpmAh1jwWl22BO8kC8s0nRZvxxNZzDKSPKyd6iLMS5mohFyenAaGIybsefUDMcPseTHCZ8AYy4k8UE95XPaW3oKgoTIuSb2QQia4hAazmJ2WgJ+HnV9IORENu1V8MY6+XUzcLX0BfFIhEV62Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB5765.namprd11.prod.outlook.com (2603:10b6:510:139::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Fri, 29 Nov
 2024 08:00:19 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8207.010; Fri, 29 Nov 2024
 08:00:19 +0000
Message-ID: <5b2b0211-81d9-4ec9-98d5-b39a84581ac0@intel.com>
Date: Fri, 29 Nov 2024 16:05:18 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: Deadlock during PCIe hot remove and SPDK exit
To: fengnan chang <fengnanchang@gmail.com>, <linux-pci@vger.kernel.org>,
	<lukas@wunner.de>, <kvm@vger.kernel.org>, <alex.williamson@redhat.com>,
	<bhelgaas@google.com>
References: <D0B37524-9444-423B-9E48-406CF9A29A6A@gmail.com>
 <A8CD6F73-CDBC-45D1-A8DF-CB583962DB8C@gmail.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <A8CD6F73-CDBC-45D1-A8DF-CB583962DB8C@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0191.apcprd04.prod.outlook.com
 (2603:1096:4:14::29) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB5765:EE_
X-MS-Office365-Filtering-Correlation-Id: 7abf1e60-8b6f-4f77-9741-08dd104bde0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eHNWcUpJOEJsMk5aZFVPbmE2WU54eVZTRjJYSldNMi83TGZqS0M4SHIxR2VJ?=
 =?utf-8?B?b0dzM1RxZnFIekRlV2Nnc0Z6b2VPZUZaN1M1Y3RhK3NNenlzQ0xEWFBISUJz?=
 =?utf-8?B?S1l6b0JsNDR3ZFU5QW1oMmtOdGhwS29UUjZZNkhES3MydEZqTVBTa2RpYW9i?=
 =?utf-8?B?ZzBUY1RJMjdsd0xQYVM0disxYWJPWEhLeUN1bjEvV29FcVdiNnhQVFh3a2x1?=
 =?utf-8?B?Q3p2RDMrb3JSQWQrYjVodkg5cmtHa2JnQ1BDZ2l4ZWk0MkQvS1Z3VDEzU1Rx?=
 =?utf-8?B?UlNNQlNxakNjRE44VTB3SFI2WVc3MnlLUHk3L1RGMTBWb0ZyRkNOWTFWNTJu?=
 =?utf-8?B?N3doMHowWUFTZjBqaHRLcFduMllSYlRMRklTK29xU1lDMXVIbWtETXZjTVVy?=
 =?utf-8?B?ZC9JK2w4R2NYMUhHOGZWR1hrdzhIaXJVNkRCV1hrb0tMaGg4ZGEwN09lNUpS?=
 =?utf-8?B?NlVBVXlBNmMwWmUxdUFIQU44R29ZWUJEWjFDdUFWSE5JNUsvMW5mcWNXczFW?=
 =?utf-8?B?aWlwR1llTXJhSnA2U0tsWmZVV2J0QTJWVDdjdVBKeVE2SFFmSDZsMVVQVEtQ?=
 =?utf-8?B?QS9iSk1lODVmaXlxOTkyRFZrdG1JWng5Y3Q2cEVOUldqcXhNek1UeGF2ZWgw?=
 =?utf-8?B?ZHczV01PeHg5RzBOT1RYeTNYUnkrcmQ2YzZySHJRRnBHdnVvTXFYM2pIa2I1?=
 =?utf-8?B?cG1SbTlqdWN4NDl3Z2JSS2F6TDh6dWM1WDNkNEZleTA5Z0hTdzhocGRWYkRL?=
 =?utf-8?B?TTlydG5mUUJieG5ZOHM5LzhITko3WjUzcVNHdVdOdlBHWUdkSnhCUGJQRmQ3?=
 =?utf-8?B?cWlHUHAwd1ptOVoxdkZRdldLOUh1OWtiSE8weFNrZTJUZHJoWmM0SWY4aXpQ?=
 =?utf-8?B?QU5idFI1QmlibWxJV3ZacDV0THZHWkU3ZkJuVUZ0ZkpEcVZrSW1aTEFRb3NU?=
 =?utf-8?B?OXFyai9KSEYzY21IbGVua0xHSDB3bnVEeHFHeFpuRGd1R0pGRTBGbTFRQkY4?=
 =?utf-8?B?RVQ2MDl6UjFEdUVmemVFbzI3eGxWOVA2K0JoWGFVTkVEeXZXckV1YUp3VXBa?=
 =?utf-8?B?ZENSRytTS2lWeE5PR0huRHF3dFg3T1RMNkpBRVE0R0NWZlllL3pLUzVlT3hi?=
 =?utf-8?B?eHU3OXFDWWJ4R1J5RFY2TkZLRFF4VWJhK1M4SVRoRXZydkRydkh1Qmx6clI1?=
 =?utf-8?B?bHNIVDlmeDRwQjl3YXJUVEhTNkd3Z280a21URnFLQnFhM0s0NzFZRWQxV2o1?=
 =?utf-8?B?VURLVnlwZm1UYmNzOWdSaDk4WnkxeHBrZEhRQ2VISGpWVDBzOVdmaXBtRzBZ?=
 =?utf-8?B?S1JmTXpBMDduOEE2OGpWa3NUTXBhWUdNV2FHd2ZKRFlpdS9mclNqZzdlMFN6?=
 =?utf-8?B?L0FTYmJHZk5PSU1XR0JCQ1lUbW42ZHpPQTJEUVMvRENwTW5EUTArSHZXTWhR?=
 =?utf-8?B?Nkt3RTJUNlVTZGpkRVdrTEx4MzFTVUV2NjZ4UXIvQ0dPODQ5Z3VDOEZWbE5x?=
 =?utf-8?B?YUhJM3EzNnZIektnTCtoTFBHS0hvRlBBRHB2SHZIb2EzdzV1cDd2ZW5WdHg2?=
 =?utf-8?B?UFBLYzI5cWZGbTFEL09qVGtUcUgwMG9iYkM2eUNaWmxNdmFuaWtnYlQxK2Ja?=
 =?utf-8?B?QUVPVjVFQXhZeFdPSDFoL0EzUmpmclBkVjZneU41ZzhCd0dVcUdVcHRNZGV0?=
 =?utf-8?B?TXAwNjFBYTAxZlRJS1FETkFrOTk4aXhkVGE3SlBCMjV1dXlCQXl0czhOVDJO?=
 =?utf-8?Q?+lU6yq19eh9uojs0RI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2NsNHB1MHh3M2xjdzBRYW13OXhBNmk1eElsL1B4d0Z6RUtHa2p0cHM2T3FG?=
 =?utf-8?B?cGR4V09NVTlTZVRqQWxkWDVnNzM5M3hMK2xDazRld2tHaUtlak92QmZnKy8v?=
 =?utf-8?B?VWZES2FoL3JFT2VrRGRjYUxIT1R3MkcwOUNrcUEyU0JLZlJiYmtjS3ZXYmc0?=
 =?utf-8?B?ekVQYlJXS1BHd0hOZWd1eEhPa05Udk5jejdKZnBieWNpUmFhRGNTYXZQZzhK?=
 =?utf-8?B?TXAxQjIvVXZaZzlZa0hTVzFBSk4rck9ZalBxVGlmajdJajNyVkpZWHVkUHlk?=
 =?utf-8?B?dThKdjJtQVRYeVVWZ1Y0VWNRSUZkeWxmWnA3cWdCL0xGbnpPZU1mSG5BZ3Zl?=
 =?utf-8?B?SFhnNjZ4RmljUCs0RUQ0U3dmdGN5ZkQ0UWM5WFgrYjFxWVlhdnhpczkzL2Ey?=
 =?utf-8?B?TXh3UFZOK0R2SWVrQVhWOGlRVTZKcVU5U1ZHQTVFL1RzR1lmeXo2OVJUVjB2?=
 =?utf-8?B?RFhxTGxoaDJZcXVNYjdZWW93QTRmN1pTVlErVHdyVDNxVXFJWWwxbFRpQWVD?=
 =?utf-8?B?NDBaZWhJMWFFVEluSExvdlEzbWl1N0NmOVBDUFlHUXFhbCtHY3Y0ZW9VSVRS?=
 =?utf-8?B?eERGVm85SFhDeVFZL2t3NVUwQ3h5bENvS05UMGpKQ2VNNUNJTjE0cTQvOTNZ?=
 =?utf-8?B?OWkwSElCZ0IxNEZVOERNZDdROGhKR0NySk9qckFmam80ZzcwN2ZPWmdOMVlh?=
 =?utf-8?B?UzBGaTdpMzhLMHZkWnZobXVuWW5TanRRSk5nWGR4SHFMbnhnNFFXSWJlUEZZ?=
 =?utf-8?B?Q2FpQytYUnl4R3FWRCtUR3NkcEdTbXNKa2pJNlljUW9FeWlUb2FpRVMzQTF3?=
 =?utf-8?B?bnFueEpOb2tMc1FiU3cxSWEyTXZFRXRqSDU4T2V1Ym8yRkNQY0M2Ui9mcVhM?=
 =?utf-8?B?dzVrb241NmhsbVJnZk8rNmdhd01vYVZxQ3B3VXJ1WkxNb0RISC9MeGhTampi?=
 =?utf-8?B?dWJHMDgrdm94dUlVSFBKaWF1NWlQUVd3NCt1alZZVW1UcFlSQ0FxZy9zZGFF?=
 =?utf-8?B?ZFdNOWpETXlLQmRPVWFuTXBsb05aaVFzU09jTTNibVZmajJKZ3pKUzN5UlZt?=
 =?utf-8?B?NGQxb1FNdVM4ZWF1cnA1VHFmeEhQYkdVNkVLYmllM2dUQzdqeW9aSnI4endp?=
 =?utf-8?B?Tm1BUWFWSjduVUNXWEFEeE5iZEErdkFqY1NreG50RDN0bDVhMzJ0d3Z4WHI5?=
 =?utf-8?B?YmRBRS85WlBNTnBWWHp0cEFRT0FOaG51TnRaaDlGSWJkSWdHMGZEcXdwRUtx?=
 =?utf-8?B?OTZxbmJubFlWWFo2RWdUVUlhTWNyN0NOTTJIbXNSQTlMZGVIZU51Y0hhaks3?=
 =?utf-8?B?cU5zRzFDNk1uTVd3ZThDK2RvR1M2eW9Gc1pvWTFJb0Ura2NoM0swQjdMSHB4?=
 =?utf-8?B?UHlzVVBERHhkbGpMZXltc0JrU3FMS2tUNDQ5THVrZVN0ZlRFNHdsVzY3N3FQ?=
 =?utf-8?B?aGp6Q0xLSk1sYVFWTWJ3QUNkdkZCKzdrODN5TE1zbE1iN0RvRFlQamdVVVNN?=
 =?utf-8?B?cXc4dUZVaUF6QVdtNi9WL0pVUGM0L2F5ZTlzdi9UcnZRVk5rRk41L0VsYmlM?=
 =?utf-8?B?c0M1aFNrZlYyWXVDWHUwdjVNQzBUTmVrTG1wdVZueDBTVVlYd2dPSURiWnNJ?=
 =?utf-8?B?STdqZnJsRFNNdnRiUFp5MWlWMDlQdVJIdVd0L0tSdlBNVWM1N0kyb3pDWlFo?=
 =?utf-8?B?dnNqNms3T29IYmxtTDZGeGZYRkdWOVZ0VHl3c0JBTXgvK1NUSkIzMG1QanNj?=
 =?utf-8?B?R0cxQ1JWN25pbWppamNlUzZwSWJ4MnN6VWJFa0hKellJbDNmZU5JWHAweCtJ?=
 =?utf-8?B?THFPOXUwbHhxc201c0hGM3h4cGVEUWxLNFdkRnRzVW0yNGs3MjUvZytCekdy?=
 =?utf-8?B?cWY1RlZsR25PTlN5UlA5bXlvclh0cTNhM3QxKzZPWittOUNrRHFzMTVsWGJ6?=
 =?utf-8?B?Nk9WOGlEMHh1c0RpckpxUk9NbStTbS9ZdWI1ZXB2NldQbUVxejJOM0pKOG1J?=
 =?utf-8?B?R3k1UWhyN3dmaUZsc29MY3d2WVcxQmlaYklPQW1kYzBaUFpHbytWc0hPZHlE?=
 =?utf-8?B?SE4rNTFKdFVrWWNQc0JvZEZpVW9McFlOYlhmaWlnK2xSaitzVWowclg5TXpq?=
 =?utf-8?Q?KlwD1EXOGWMeED30XOR4Y/0vA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7abf1e60-8b6f-4f77-9741-08dd104bde0d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2024 08:00:19.3531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S6MwmSVVEhWjsKfLLE7jzK+0e3EWnUnuBcWaGEs2nZB7a23Igs3AMc3/33wU7CFGpEMAugT6hG4kJH0GpiNK2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5765
X-OriginatorOrg: intel.com

On 2024/11/28 11:50, fengnan chang wrote:
> 
> 
>> 2024年11月27日 14:56，fengnan chang <fengnanchang@gmail.com> 写道：
>>
>> Dear PCI maintainers:
>>    I'm having a deadlock issue, somewhat similar to a previous one https://lore.kernel.org/linux-pci/CS1PR8401MB0728FC6FDAB8A35C22BD90EC95F10@CS1PR8401MB0728.NAMPRD84.PROD.OUTLOOK.COM/#t， but my kernel (6.6.40) already included the fix f5eff55.

The previous bug was solved by the below commit.

commit f5eff5591b8f9c5effd25c92c758a127765f74c1
Author: Lukas Wunner <lukas@wunner.de>
Date:   Tue Apr 11 08:21:02 2023 +0200

     PCI: pciehp: Fix AB-BA deadlock between reset_lock and device_lock

     In 2013, commits

       2e35afaefe64 ("PCI: pciehp: Add reset_slot() method")
       608c388122c7 ("PCI: Add slot reset option to pci_dev_reset()")

     amended PCIe hotplug to mask Presence Detect Changed events during a
     Secondary Bus Reset.  The reset thus no longer causes gratuitous slot
     bringdown and bringup.

     However the commits neglected to serialize reset with code paths reading
     slot registers.  For instance, a slot bringup due to an earlier hotplug
     event may see the Presence Detect State bit cleared during a concurrent
     Secondary Bus Reset.

     In 2018, commit

       5b3f7b7d062b ("PCI: pciehp: Avoid slot access during reset")

     retrofitted the missing locking.  It introduced a reset_lock which
     serializes a Secondary Bus Reset with other parts of pciehp.

     Unfortunately the locking turns out to be overzealous:  reset_lock is
     held for the entire enumeration and de-enumeration of hotplugged devices,
     including driver binding and unbinding.

     Driver binding and unbinding acquires device_lock while the reset_lock
     of the ancestral hotplug port is held.  A concurrent Secondary Bus Reset
     acquires the ancestral reset_lock while already holding the device_lock.
     The asymmetric locking order in the two code paths can lead to AB-BA
     deadlocks.

     Michael Haeuptle reports such deadlocks on simultaneous hot-removal and
     vfio release (the latter implies a Secondary Bus Reset):

       pciehp_ist()                                    # down_read(reset_lock)
         pciehp_handle_presence_or_link_change()
           pciehp_disable_slot()
             __pciehp_disable_slot()
               remove_board()
                 pciehp_unconfigure_device()
                   pci_stop_and_remove_bus_device()
                     pci_stop_bus_device()
                       pci_stop_dev()
                         device_release_driver()
                           device_release_driver_internal()
                             __device_driver_lock()    # device_lock()

       SYS_munmap()
         vfio_device_fops_release()
           vfio_device_group_close()
             vfio_device_close()
               vfio_device_last_close()


>>    Here is my test process, I’m running kernel with 6.6.40 and SPDK v22.05:
>>    1. SPDK use vfio driver to takeover two nvme disks, running some io in nvme.
>>    2. pull out two nvme disks
>>    3. Try to kill -9 SPDK process.
>>    Then deadlock issue happened. For now I can 100% reproduce this problem. I’m not an export in PCI, but I did a brief analysis:
>>    irq 149 thread take pci_rescan_remove_lock mutex lock, and wait for SPDK to release vfio.
>>    irq 148 thread take reset_lock of ctrl A, and wait for psi_rescan_remove_lock
>>    SPDK process try to release vfio driver, but wait for reset_lock of ctrl A.
>>
>>
>> irq/149-pciehp stack, cat /proc/514/stack,
>> [<0>] pciehp_unconfigure_device+0x48/0x160 // wait for pci_rescan_remove_lock
>> [<0>] pciehp_disable_slot+0x6b/0x130       // hold reset_lock of ctrl A
>> [<0>] pciehp_handle_presence_or_link_change+0x7d/0x4d0
>> [<0>] pciehp_ist+0x236/0x260
>> [<0>] irq_thread_fn+0x1b/0x60
>> [<0>] irq_thread+0xed/0x190
>> [<0>] kthread+0xe4/0x110
>> [<0>] ret_from_fork+0x2d/0x50
>> [<0>] ret_from_fork_asm+0x11/0x20
>>
>>
>> irq/148-pciehp stack, cat /proc/513/stack
>> [<0>] vfio_unregister_group_dev+0x97/0xe0 [vfio]     //wait for
> 
> My mistake, this is wait for SPDK to release vfio device. This problem can reproduce in 6.12.
> Besides, My college give me an idea, we can make vfio_device_fops_release be async, so when we close fd, it
> won’t block, and when we close another fd, it will release  vfio device, this stack will not block too, then the deadlock disappears.
> 

In the hotplug path, vfio needs to notify userspace to stop the usage of
this device and release reference on the vfio_device. When the last
refcount is released, the wait in the vfio_unregister_group_dev() will be
unblocked. It is the vfio_device_fops_release() either userspace exits or
userspace explicitly close the vfio device fd. Your below test patch moves
the majority of the vfio_device_fops_release() out of the existing path.
I don't see a reason why it can work so far.

As the locking issue has been solved in the above commit, seems there is
no deadlock with the reset_lock and device_lock. Can you confirm if the
scenario can be reproduced with one device? Also, even with two devices,
does killing the process matters or not?

> Here is my test patch, cc some vfio guys:
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 50128da18bca..4ebe154a4ae5 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -19,6 +19,7 @@ struct vfio_container;
>   struct vfio_device_file {
>          struct vfio_device *device;
>          struct vfio_group *group;
> +       struct work_struct      release_work;
> 
>          u8 access_granted;
>          u32 devid; /* only valid when iommufd is valid */
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index a5a62d9d963f..47e3e3f73d70 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -487,6 +487,22 @@ static bool vfio_assert_device_open(struct vfio_device *device)
>          return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
>   }
> 
> +static void vfio_fops_release_work(struct work_struct *work)
> +{
> +       struct vfio_device_file *df =
> +               container_of(work, struct vfio_device_file, release_work);
> +       struct vfio_device *device = df->device;
> +
> +       if (df->group)
> +               vfio_df_group_close(df);
> +       else
> +               vfio_df_unbind_iommufd(df);
> +
> +       vfio_device_put_registration(device);
> +
> +       kfree(df);
> +}
> +
>   struct vfio_device_file *
>   vfio_allocate_device_file(struct vfio_device *device)
>   {
> @@ -497,6 +513,7 @@ vfio_allocate_device_file(struct vfio_device *device)
>                  return ERR_PTR(-ENOMEM);
> 
>          df->device = device;
> +       INIT_WORK(&df->release_work, vfio_fops_release_work);
>          spin_lock_init(&df->kvm_ref_lock);
> 
>          return df;
> @@ -628,16 +645,8 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
>   static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>   {
>          struct vfio_device_file *df = filep->private_data;
> -       struct vfio_device *device = df->device;
> 
> -       if (df->group)
> -               vfio_df_group_close(df);
> -       else
> -               vfio_df_unbind_iommufd(df);
> -
> -       vfio_device_put_registration(device);
> -
> -       kfree(df);
> +       schedule_work(&df->release_work);
> 
>          return 0;
>   }
> 
> 
>> [<0>] vfio_pci_core_unregister_device+0x19/0x80 [vfio_pci_core]
>> [<0>] vfio_pci_remove+0x15/0x20 [vfio_pci]
>> [<0>] pci_device_remove+0x39/0xb0
>> [<0>] device_release_driver_internal+0xad/0x120
>> [<0>] pci_stop_bus_device+0x5d/0x80
>> [<0>] pci_stop_and_remove_bus_device+0xe/0x20
>> [<0>] pciehp_unconfigure_device+0x91/0x160   //hold pci_rescan_remove_lock, release reset_lock of ctrl B
>> [<0>] pciehp_disable_slot+0x6b/0x130
>> [<0>] pciehp_handle_presence_or_link_change+0x7d/0x4d0
>> [<0>] pciehp_ist+0x236/0x260             //hold reset_lock of ctrl B
>> [<0>] irq_thread_fn+0x1b/0x60
>> [<0>] irq_thread+0xed/0x190
>> [<0>] kthread+0xe4/0x110
>> [<0>] ret_from_fork+0x2d/0x50
>> [<0>] ret_from_fork_asm+0x11/0x20
>>
>>
>> SPDK stack, cat /proc/166634/task/167181/stack
>> [<0>] down_write_nested+0x1b7/0x1c0            //wait for reset_lock of ctrl A.
>> [<0>] pciehp_reset_slot+0x58/0x160
>> [<0>] pci_reset_hotplug_slot+0x3b/0x60
>> [<0>] pci_reset_bus_function+0x3b/0xb0
>> [<0>] __pci_reset_function_locked+0x3e/0x60
>> [<0>] vfio_pci_core_disable+0x3ce/0x400 [vfio_pci_core]
>> [<0>] vfio_pci_core_close_device+0x67/0xc0 [vfio_pci_core]
>> [<0>] vfio_df_close+0x79/0xd0 [vfio]
>> [<0>] vfio_df_group_close+0x36/0x70 [vfio]
>> [<0>] vfio_device_fops_release+0x20/0x40 [vfio]
>> [<0>] __fput+0xec/0x290
>> [<0>] task_work_run+0x61/0x90
>> [<0>] do_exit+0x39c/0xc40
>> [<0>] do_group_exit+0x33/0xa0
>> [<0>] get_signal+0xd84/0xd90
>> [<0>] arch_do_signal_or_restart+0x2a/0x260
>> [<0>] exit_to_user_mode_prepare+0x1c7/0x240
>> [<0>] syscall_exit_to_user_mode+0x2a/0x60
>> [<0>] do_syscall_64+0x3e/0x90
>>
> 
> 

-- 
Regards,
Yi Liu

