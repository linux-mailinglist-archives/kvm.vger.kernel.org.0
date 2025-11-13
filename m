Return-Path: <kvm+bounces-63086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FF3C5A837
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4E923B45E8
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B26C32825E;
	Thu, 13 Nov 2025 23:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KUv34YSw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0803271F6;
	Thu, 13 Nov 2025 23:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075943; cv=fail; b=qMVFO3VUEIsDntkx+yQPbHlk0vzqZAA+DQkot818/h4xY0XkBY3dNWe/gx6r+R44PlJOsG9H9Bc5lMyKumOc52Wo1zS1VUqTDML++vxhPtI3RcmE7cSi72G1hE8osJVNcINxPghlNP1NOj1BAnDhkRMJjqEkNkdCjBHWcqM9tq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075943; c=relaxed/simple;
	bh=HorYOLbR3NfTGwfksucaucarmiCWv25XdmVHxqT6QG8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cXZDax7t4efELrAdex9L8iRm63qa2dUS9ru+NsJ+K4byDrKyUl6ODHzIa2ecVfeAFusEITNfkPYhnMtOoymLNAjweG3HjP6w1Lt0F0XW2jjVPOkZDQHkYB6E45+gE0dhBplCtXJOxFRBpeL8QQV4Fr2GwlQi7ZrETj6VJ6vyTVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KUv34YSw; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763075941; x=1794611941;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HorYOLbR3NfTGwfksucaucarmiCWv25XdmVHxqT6QG8=;
  b=KUv34YSwPiNysI5XCtEvIJVyrP+Ba2uncFU/TwTGg3amZQRe5+bpVYF7
   ieRVY+HbKquNPC3xxW/dXMskZrkfKTKG31vcY2ziHGWTmXZh2dt26n8k4
   GpDGiK0rZPVtvJfdxbzOpx7H5Zc+dMmC44o2cL5Y5z/dgWBS0qE78fRLb
   OZVouN2NgoH8C49BQWV4wGty/qvxOMOYrvzgiCnYkkhVS3h5WJhtmbhPn
   ADeKA8WS9ZIbPWXnwTGnm4xQaEXaWS+745Gm3uNRryTC8iLsP/tutUrkt
   AuAqzVEfi7cYoeEtj2w6L/xYxKOa6NmtwXq44GW2PddIAO3XeaKIX5Q1A
   g==;
X-CSE-ConnectionGUID: j/35NI4cSbSNr2CTeyf3oQ==
X-CSE-MsgGUID: n65uk/79RQyClz2l9+daLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="67769734"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="67769734"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:19:01 -0800
X-CSE-ConnectionGUID: EPXr2qbKQASptiVdAg016g==
X-CSE-MsgGUID: Cqe0hJsxRB2WB5389OuuFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="220477508"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:19:00 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:18:59 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:18:59 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.34) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:18:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/nSzfgn81zxJOEFItMk9k4IKkfnUirsLGg/H/EiXCpHnoSok2CuxYb+BxYPLyv+I7u1FyYOrTXPnGffvtCdyZMD8mbkgwy1MYGREJ0L9v+AM2jvRrNwkDIuSlry4x3NsaqLBD7vFSzl3nLtKStDHIoZR9T+63FkPWaOz+x+qGdcXQthkDrQ2TiGHtDELA6JULlVNE776+Pd8oVi9pnW3py/byt7HGv2sV6SExvt/IM7DbVOnhC2SFsLJrYh5NGusG/jvVTKPQ4Tc09eWpmHEdOiawaVpxtRlifMRSA47sFpKy87yBf49N4ZhFyod2YepXo7RWDlLuYHBiALk5zfhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNmcRhItJa7q7t1fu7hzSIUGGstwOJhrqWgPD1M+pAc=;
 b=wElhvPeew88TmJifdicnZkviFSO4sDHoUQ3YXft5WUO9vGaC9qd5kcqlr9tUDCs0EeS+HxiO6nLk22EZQ2XDenDS/aOYjPPBA1XgsxApfOhgh6EHhf1DsbdYQkJZm7q75fyFwF0zq8wn4c6XwGO8YxkTw+2GTqy03QLNUpEcNLU2ghfHYFRt1nfBLxw5Mt2ZLZk0nOmbJM/9jfxV0OeZzh/1NEMqmWzOg3vlxyjPsER3T3PXJtDlTtv+Sp4edOVbdhtm9Z9WH7dmHP7wbcQODlh2wRH6BKFkz2Ys9Sdh1LUCbrTP1INajrOta2qsDT4bKk1nKEoK+a/bw9jcC+WNmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH7PR11MB5887.namprd11.prod.outlook.com (2603:10b6:510:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 23:18:51 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:18:51 +0000
Message-ID: <e8e88eba-33ef-4ae7-a5bd-7958031bbbce@intel.com>
Date: Thu, 13 Nov 2025 15:18:49 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 02/20] KVM: x86: Refactor GPR accessors to
 differentiate register access types
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-3-chang.seok.bae@intel.com>
 <33eacd6f-5598-49cb-bb11-ca3a47bfb111@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <33eacd6f-5598-49cb-bb11-ca3a47bfb111@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0205.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::30) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH7PR11MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: b930d279-b141-4f15-d495-08de230b01ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a2VyelJDMSt5UmJaS1YrMXdpTW1OK0FnVlZ3cG8zWUIxMFo4L3NGNG5zS2Vp?=
 =?utf-8?B?dmVHSy9CRnhJSGgwT1pkNGlHL1dYdzdiQXZxTSsvMVJMTkxaelBkZ3J5aytz?=
 =?utf-8?B?eWgwNEtFMGg1R2h1MStUTHcvbjZwQ0Q2Z1ZlOFJLWFY0eE5hSmNFTlMwWjVl?=
 =?utf-8?B?K05URldjdUk1T2RVVVlRVytMc3o3bkRSaWhIRFNCeE4xL0FXWGJ1ZVRsb1Er?=
 =?utf-8?B?a3cwZmwxWENkU3RtSHU3Y3VOd2twVTJSUm9YZjErNVJlRWxvL3VMVk5mdElX?=
 =?utf-8?B?S082VjFyWUs3Nmhlbzl5SUdxWHRYazFocVRjRFgvS0phcUVFeVluWjFiSlJ2?=
 =?utf-8?B?eExvanRwQ053NjZkVkRXY0M5L3M5RHZCcE1QYVJsYTFCNFRzQm56N2gzVStP?=
 =?utf-8?B?a3R4OTU0TU9DY0JvUXowVlVac3Y4UUxacDc2cVp4Nlh1NEZkaG5uSStRSGxs?=
 =?utf-8?B?UWwyeFFSVTJ3NCtDc0pPTlc2bi9lS201K2Q3MGxpd3N5K3VuaFBISlg5V2lh?=
 =?utf-8?B?eThYdGpLSnBtOWtJR0pqenJQci8zQUhtRWxXWkpHN3BPODFFNjljZ1Z6MVc0?=
 =?utf-8?B?RE9KV3ZMSklZRGNKL0xJb25aK2dxUEZCSjNlSDdNc1ZLenFQZzQwZk1kUUZv?=
 =?utf-8?B?VFByTGRIVHRtb0JHblBXelJEb25wTDdBK3ZPS241dGpXSnFPWU1JRTVJK3Bv?=
 =?utf-8?B?K1RjaWtVLy9CVjZ3R05TK2s0SFdaWm5ndlNHRllHQ2lOeVFFL2hXTGNYcWZa?=
 =?utf-8?B?MVlGeWM3NDZQYW52WTNzWjMzbXZmQ0FqNkJMNlJFSXhramxJTXlDTVJqY28x?=
 =?utf-8?B?ZVF2V3ZBU0ppL01BMTBVYjFUWi9GRUFkYkdoMFpWcXpHU2xqRVRUZGEwS29Q?=
 =?utf-8?B?VjJRMnVPaVF6eXhXdHBlTnhmaHRKd09TeVZ5Vlh2MTM3aGp0dlEyS3E0RGE2?=
 =?utf-8?B?N3pNelpIWDMvQUZzdUN6TTFnbVFET0t0Y1FHdXZkZFFKdzFiRy9NK3hHNXFw?=
 =?utf-8?B?WndGU2UydFZ3RXRYQ0hTQU91YnNjMjhqNmZoVXdBMVFkUklyWVQ5Q0JFa0VO?=
 =?utf-8?B?ZDdSTnlLQTIvWHZabWpCdElvQXlSNFNtMUVDTjlDOWEyNmkzNHp4WDhQVHFk?=
 =?utf-8?B?NkUyc0ZuMExrbGJTZzZkelJjaC9SajFvVU1pUy9PYm05MktPZlAxanMrSytG?=
 =?utf-8?B?ZUpaZ3RldVlSOHdObkNIeG9nazFwSDJobEEzM1NGQmU5Z2pnZVgzWXp6NWZS?=
 =?utf-8?B?c2w1LzdCaTd2SHhGYzlnOTRpMkpsdDc4Z0ZVcmc3b0ZiWWdCTmZjTC96TklX?=
 =?utf-8?B?enFFU0V1UUd4QkJMdHRvc2FRbVVPeG9uK21VbkZoaFVuQmp6STFYS3Y1STh1?=
 =?utf-8?B?THRtM3VUbFZVdnZLWkZkbExDUXllZTh0SWtFek1mTlNMQkdKQ1RYejJJN0tQ?=
 =?utf-8?B?TmN6ZHFVakRHYnpwSCtBanhpU2NTRStLTC8zbG5jZVhUTUhIR1FqNlI4VDVv?=
 =?utf-8?B?UmxqaDlSK3lvYmNhL2VRMGpTODJrTkNUOUtWYWZ2RkViMFJWNFVQMHdZNi9y?=
 =?utf-8?B?NEU1U2NCN2F5dkh2L1dFTU1FWGxFMVJCbjdhWGFGOFZ1SFdDWjI5U3lXSVQv?=
 =?utf-8?B?STJxT21xL3Nwc3ZLUFBWS0ZUUVlWSThxK2EzaWp6cis3THIwdzZ5bFBNS09j?=
 =?utf-8?B?aWdIZHdRNFI0cGpzSzRiWmZxMGJBeVM1SmhQcDRyVXIvTWtGbWsrajkxYW9P?=
 =?utf-8?B?QmNYcG90eTdRN3lncTF3ZjZLbE9rckdlVnV0Nm44TlJ4aGs4VkRpTldtTGZn?=
 =?utf-8?B?K0ZQZGdVc3Q4aE1NeXlVazhiNWYvTno3RnpDc2NYWElCUWZvd3pSQXBNZkw1?=
 =?utf-8?B?MnJGd1d6Snk4MWxpZnlsTFVFTkVJK0NyN3FzWWRxWFExZGYzdk5Cb0F0Y0JQ?=
 =?utf-8?Q?QgLAK/gPiA9cmO5TM/2caRvcavn17tPI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3J0WDl3WXJSUmhmczViUE9aZ1lUaXZpVHNXQTRtNXN5SkJ1RWsrMjJ4dnFm?=
 =?utf-8?B?QjlSTHRERmVZRitYYXkwQ0c1d25wQk1IQktmc2YrYVo0RGZaTVJwVy82MFc5?=
 =?utf-8?B?dDh5bnMxQWlXSVBNSUdncWdidWlUc3R6UndrdmFPazFIbFVkNUFNR2wyTEo3?=
 =?utf-8?B?Q2g1R0hicFg0S3pXNTBqNVZnbXM1a1kzTHMzMGJzUU5sN1RhOHJxbGI3cFZT?=
 =?utf-8?B?N1FIWHFzNWVPMmNLQVlBVlAxcXI2MWN5a0dwMnhLR3pPTG9BRTNycEs5OUNY?=
 =?utf-8?B?aDR2QVNBMmxROXNLV2YvWmpHUmpnZ3RTSUR1aVFiTkppMlY0OEZ0Tlh3c0hy?=
 =?utf-8?B?RnNmd2RLQ05sSUtuekZmaUZGdytFZGxVU3ZxYzU3M2RKZWUwMjNiYnNWaDNW?=
 =?utf-8?B?Y3p6dGlWeXRjS1hGdytadGRuM0MwdzR2L0FrTDlaMFVJTHFVd2NFRWxWaDdQ?=
 =?utf-8?B?WG5FYWZDdUNmamZRRTQxbTVBNWNDbDYyRmZMR24zYy9PZkxnNVdmcHprcWdZ?=
 =?utf-8?B?ZmtDZTJwc1pHOGEyaGpnTW5jMFBrZFJ2VUUwTzFIQWM1bU42MVg2ZDdUc1lQ?=
 =?utf-8?B?K254M25nNUlsaUUvYmI0YjVOMGNBM1Q2N1c2TkFjaHhmQXR5aGgrZHYxUmQ0?=
 =?utf-8?B?YnZ4TXlEZUp3RjhqUElsTEpwVHNpVXc2cHVPWmx6VWp5UjJmTXowaWJNUzdL?=
 =?utf-8?B?cm1mMWJoQWdqZVVmN0phUDBhL1Ntb0RxaWk5VVpTMVJOdFNRM2lEdVpaQUdq?=
 =?utf-8?B?RHFucWY4V3p4bUpjSm5kdkNtSmlHenZkMFY5V1g2R3p5YXoxdVJibDFTWUJM?=
 =?utf-8?B?YVNYbWlzWC9LeW9OWW5pV2tWM0ZOejJEM2E2SlNGdms5Y3VVeDFnc1VUMzRO?=
 =?utf-8?B?SWVBcVAvZDNaUWFZK2tpalA4eVdJd1BNWEFjbzNTRFB1OTNWTjhFcG1LcjAy?=
 =?utf-8?B?L2N6NnJxU2c4S09hUE1lOFFVQUVaUWtKUDdQNU9SampveDh3S1JVc0phZVho?=
 =?utf-8?B?MUZyekFxcnNEY0lUY1NOYUxyZk9vL1MxT2lsTlhLOXdwTFVyZ2xRNXhrZjJR?=
 =?utf-8?B?a2VPbjVMRm5UUjhJU0lTU3dqUi9WZlE1cURhdjNaN0g4RVFDZFlIWlhKVzRi?=
 =?utf-8?B?emM4Ti81ZDFucHlPS04yME16bUtIRUluVEZvM1NzVU1xY3hnUDArbW90RXIv?=
 =?utf-8?B?VjB4VmpEZDdjUmNyb1pJaW9wMk9TdC8yb3JJM1Zsa3FkVnRVV1MwVG95RHVt?=
 =?utf-8?B?b1prRWFZMm5kUUwxNVlCRVJIZ0ZwMTJSRUJGaFV4aGxGL0QzRjRCL1MyMkRp?=
 =?utf-8?B?cGgyVUYyekNPNHNlZjFOSnRVMnN2SG9TNXlncDhHMDA4U0lnZlpKWDQvclU0?=
 =?utf-8?B?MGtNQnZsVXlJRXlmVGpyTHl5TEd3NWFqeDA2NGU5NWVlQkMwWTlkWHBmc2tQ?=
 =?utf-8?B?c1loQThFd3ZrejJoZGN6NEVpS1lWc2pTTlBJVjQ2YXE1WE9XOHpzUTd5MUhs?=
 =?utf-8?B?YTI1cGdTS2YzWmdiSDRzTk5pMVo1SW44bjhaZXV6V1VudDNNOGpQbW9QSlJ3?=
 =?utf-8?B?MnBWZVBOcTVwWXF6ajg3U0Q4dUlsSW0vbHplNEdsYlZQQnd4RHhIZi9HbDg5?=
 =?utf-8?B?LzZWMlhCd0dyQldrMUdNTlBmS2FRYTR6QmVGamtmWFhSTFE3YXVnY1EwdWph?=
 =?utf-8?B?cEFtSFRaR3FRRFhtZVA4WGNZZEJnNjBtSUFMUVBZWjhIbzgwQjErZTIyWFgw?=
 =?utf-8?B?RVpsNW5KUWJVUlNZQjJGNXJLQitaYlFuTE0rMlRUNFRUK3RMVXM0b2dsTHox?=
 =?utf-8?B?TGZvTEZOcGZSRzA5NEV2NHRlMWw5K2NkMFB1Q1UrUklwdHNOUTdkQ2h1b3Q5?=
 =?utf-8?B?bkViS2hkcStHY0NNMUJNOXUyWGlUYVd6dVE0VjJqUFl0VkhZQXIwL2lCaEVm?=
 =?utf-8?B?QnlHdEhKRkFzcmRaOFROWmZLNW44S3QrR3JYVlNrTjg1ejZYV0JTRXBqaVND?=
 =?utf-8?B?Tm9tNFZFbWhvb0pLdUdmaDVEcW5idzNBT0JEdktpN0JnSG81S0poWVozVHdh?=
 =?utf-8?B?RUJsRVNqM3hJTDJqZEk2T256VWxpVUorZ0FFV1h0TUNraUtiN2NiR0QvcWJW?=
 =?utf-8?B?bDlSeTNoOTdlcGNRM2xhcXBXcko5NDlUcExmNU9MRStsdHluajNCSTlqbTd6?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b930d279-b141-4f15-d495-08de230b01ac
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:18:51.6083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cmMkDaZv9vFGs8aM941FFJfQydpOO9TG+cDvSj4X2ArxrI0KENMov9beJKmipT7g30lv4XtyRZEdSzjp+VwFzjWVNmRe5990kgmGRIVqMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5887
X-OriginatorOrg: intel.com

On 11/11/2025 10:11 AM, Paolo Bonzini wrote:
> 
> Please leave these as kvm_gpr_{read,write}_raw.  It's easier to review 
> than the leading underscore.  (It's not hard to undo if you use "git 
> format-patch --stdout", do a mass replace on the resulting patch file, 
> and then reapply the patch with "git am").

Thanks for the tip. Yeah, I saw that naming convention. Fixed.

