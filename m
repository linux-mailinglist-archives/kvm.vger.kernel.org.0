Return-Path: <kvm+bounces-62984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 75D42C55ED1
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6012A4E35C5
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAB7320CBC;
	Thu, 13 Nov 2025 06:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gIs+yoBP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07700320A0B
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 06:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763015434; cv=fail; b=JZFPSHcHY8p3GEpeJVtOxATpLjIcgR87jOBQFkfAFwVSwyHKGbeadh/76h4W5Zuty30E3Xmq3kuGRDULXDY5Jv9As50/hVuEhbulY3hIXzXrbDUDzF6mfgLd3BaKqtK129SErfNRHtLND5W+lwOn/v8cl82K8jhWn0GatCaa59k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763015434; c=relaxed/simple;
	bh=AgP5eckfl6yZqSWozHE5wl8KYCKaDQBpMGDmRsjx4Po=;
	h=Message-ID:Date:Subject:To:References:CC:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lT32k+0pT2L6LtAzWCTiiURbrOvg1npcjXU+OaHKOa8477hywDkaKDr0lUs/lhQ9sIhrug+BE4+q3fgpzE6krAJd6GAZ6h4lGBb4LCoZpbmwZ/U8przap5SIkUn/iCWvQFz4/i48ijGBevQdNAnsahCTtoqjwewtV0nECakaXYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gIs+yoBP; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763015433; x=1794551433;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AgP5eckfl6yZqSWozHE5wl8KYCKaDQBpMGDmRsjx4Po=;
  b=gIs+yoBPqjlW1+bzKZOwr3+pbToGAVqS7WCIIpLMLh5odSi0MHZ8oCCX
   aGtRxL2Mx+9va6Uxd+fprom+AtmTcYaf2yOya4Fg0D5PkFvyqbEcjJy4u
   oZIVDKYZ38YleqO8JLecI8NHYkUE/xFP5VgRzgrSxkoQIcoGA2J/3Hq8G
   +OvIS6cRefO+7Y3b/r4BY6HbQBGWmYNgssn2OLp1J78IJJH9psfIiTWmt
   Lga9odFj4yqLyYBIifffFI+6xk1x2oOKpVBZIKHY4ftwWhLIC1MOb84sA
   O9udE5Pl5cGtgidEeTRlk1TwBJq49pz8GjVCMY+WoeoeYmH2KZnjEyZaB
   Q==;
X-CSE-ConnectionGUID: Nc2E7YIYTsCF6dM+7RIEiQ==
X-CSE-MsgGUID: /oP0kFyqRr+8gnKYs1t3nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="64993534"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="64993534"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 22:30:32 -0800
X-CSE-ConnectionGUID: hls/Vz18S/2qBk+vKKwSBQ==
X-CSE-MsgGUID: CbcYBZfDSrqa5XG4X8gOtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="189840513"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 22:30:32 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 22:30:31 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 22:30:31 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.22) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 22:30:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U8d2nJ92hP2Sdot5iCsHpX8pKmU/0Szzto7/3P7z7GIWa2H8YlUcJP+rAJV0CtM0NjpFqfXYk8VkJoCdT7bLNmdxTTzovAqUWIB7ygKE8s+K9mI18l2WETBfRF/1kyOLz6/x8q1WWXg/aVTG8XMBHKPs4Fh/wXsuy8h9NAV2C2RLUcg1ae+k5jj78FFiKOOjZFeqbHZH/3vk/cL+7jqxCDV+V6RctTz2VY/nm6PNpXrGY0uioMs9Tnns8yW/hBQyW/8HfHgB0PLNjgXBBdYjSLn6evAc4h4Bgl6OA1/BxyTioP2wgPRdcS42ZCeZXFEvZznpD2cXqDCEMnVGC4zdcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIBtMPz++U5yinCtrZI86cAR8agxYx/dvWeV/rf/mdY=;
 b=VTu6u5O4M8GL/kS+vLzlx8JrEQ5poipR4em66iY4I73iqNwKwu1hvIAztahhwW3cmg4YZLNox+0dAZFwx2TxAClsYr6O1LgYvhD6ccK3ZZUFEprYxXUI+cexhqi1zultQZ3yu7bAALMhdB3LMfcR02IP/EQzoe/xCDuLyxg4+3dRi5YA2A3pCJD1KHd8NAQav4QQ16xS10ALf5XS8vvKLNFohy17ZEXg5rozlEE9UNiUq28ZRg/oJ24eUSrVl5TC94nddaaeRk5ReRr9aOVPHiLs0d2Hbm3QNE5/DGt4oZxHIIkVayW0iQ/eiTPTHFveiBFFUAnN+fjDEfGc4U933w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18)
 by DM4PR11MB6240.namprd11.prod.outlook.com (2603:10b6:8:a6::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 06:30:29 +0000
Received: from PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288]) by PH0PR11MB7494.namprd11.prod.outlook.com
 ([fe80::353f:c8a8:2933:d288%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 06:30:28 +0000
Message-ID: <2158b002-c567-4890-bf20-ecda5b520008@intel.com>
Date: Thu, 13 Nov 2025 14:30:22 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 220776] When passthrough device to KVM guest with
 iommufd+hugepage, more hugepage are used than assigned, and DMAR error
 reported from host dmesg
To: <steven.sistare@oracle.com>
References: <bug-220776-28872@https.bugzilla.kernel.org/>
 <bug-220776-28872-BlSJOmrKdb@https.bugzilla.kernel.org/>
Content-Language: en-US
CC: <bugzilla-daemon@kernel.org>, <kvm@vger.kernel.org>
From: "Chen, Farrah" <farrah.chen@intel.com>
In-Reply-To: <bug-220776-28872-BlSJOmrKdb@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::7) To PH0PR11MB7494.namprd11.prod.outlook.com
 (2603:10b6:510:283::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7494:EE_|DM4PR11MB6240:EE_
X-MS-Office365-Filtering-Correlation-Id: 0de7ddc4-591f-4f6b-1a38-08de227e232f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RmZ6WkdlR2NUOHRac0Y4cVgrL3pGQXBGeDIvK3FqS1o2LzFUWkdiR2huV29y?=
 =?utf-8?B?VE5ndllpS2ZmSHFyMGJjcVNDUzZtalRsbVIxdHBZazNoRlpsVWdSR2RveWlq?=
 =?utf-8?B?Qnk1Zk5XNHNvVzJkMTVPTEkvZ2FFdCtFUnJORkxTa0MxTnN1eXJHZmg5MjJ5?=
 =?utf-8?B?OC9ZaEw2M2FDMGFIS0pUYzNKMC80QWpZNTF6Mm9zczEweHhid3FJcU00cjVT?=
 =?utf-8?B?aWRIeXFMS1RxZ0o5c1VHNXZVZ3NjZWlCd3VLMElQTWRJWHY4U1ZnbEFXd1g0?=
 =?utf-8?B?aDdYelRWMkhPT01HS3lkbnpEWTBKYjFUclp4TklXYXRHbWNsNm1qWjV6Q2pO?=
 =?utf-8?B?bXlJMGlHdlh0c2FrQ28vYkdnKzI4b2N0ZFFzaHZYMUhMMFR5OVl2WFJkaGVk?=
 =?utf-8?B?SWYrMlhnVHl5MDVSbi9XZ0xUR3I2ampIK2dPYjgzVFFPSHk1OGlFQkE5M3VU?=
 =?utf-8?B?K2F1c0V0ZUZrNmREdUUraExaR1hyRGoxZkx2aEFxWUl2OFVPK0VCM1NEM0RR?=
 =?utf-8?B?L3UrRDVwQlM1c3F2WkxvMTkzem1ZVFlGcFppRGNQSCtoSFZKRkh1VlJzaGdV?=
 =?utf-8?B?Z0I2djB3eFl2RGloYWxCblpLeVpyd0cvdlZtU0tncGg0b0hYeEpzcmYvQ2Iw?=
 =?utf-8?B?Qm9CcFNHUXJSa1FXakE0b2dtVk0rcVRtNXhiSEhrTGp5Ym9mbE82Y3lqZW1J?=
 =?utf-8?B?RDNoN1R0R1JHc1VyYW9qeFMwWEIzOTlIcEJiOFRQeWl0NlVQNkJQYmQ1UXBZ?=
 =?utf-8?B?M0FveGs1VGZEUU1TMC8yUyt5bmtEbkI1cEg5eXVncm9KTFN0OWRCVTBVYlFS?=
 =?utf-8?B?d2UyMFhEY1pLaDZFSlVDUkdldzd5S0FHS29TczJRMWJybTlBMklMSFdUbTRF?=
 =?utf-8?B?Qml4VVRSR00xcWx3U3QwSlZab0YyeTNtZXkwTjNzMVkzZitGRVloa0F1TnIz?=
 =?utf-8?B?SHlxMGg2V2dlaEN1TnlyS0V5aTg2blNoazRkQzN1aVFlSkI1OFFUK0RFbEZV?=
 =?utf-8?B?SVhtSlJ2RGRiT0x6cUhpenViQ2NsR3plbFJ0cFRBWjZCM04vczlwaWZydzRH?=
 =?utf-8?B?WDBpcnBVdHV0dUx1cTBBZ3hRZU12NXZoenZ5NFE0M2J6S29iS21JZk1pZm91?=
 =?utf-8?B?cnJZTHE0UVRlMjRWZ2J5VHBMWGxnN21rbnNSUzBUdnpwTkoyMDBxbHNRbnRY?=
 =?utf-8?B?SmtsOHpLQVpEWk9nb0lySU5zUXNZUkV2Zzh5SHhPVUdzUk9ubWlFVHdzV1hq?=
 =?utf-8?B?NnRlSUpRa2ZnTG9CaDJ5VktUbmRWaitueFU4aFMrUzcxVmpYK00wTmt5Ymlu?=
 =?utf-8?B?VVlEdExpeityVjZKTVMxOFhqQW8yK3JNRTI2alkwdmw0WEF5d09hVlBtM083?=
 =?utf-8?B?UG1RVmF1anVGR0pDck9KQ3YwT0xucjRXUjBpaWF6NHViZ0xhNmduYk5Qbmdo?=
 =?utf-8?B?ZEl5ZEZUV0xSUWJMUi9LdGtSbGZNTkV2bzZTR3d4cGNFRDh4OFVFS25ybXRX?=
 =?utf-8?B?RHFIaHIrajU0TDdWTVpNRjFVbUYwUk1UTURaWVROdHZjWW83SUlhTFlNMjFh?=
 =?utf-8?B?SVpqVzRUNGNtVE5sK2FudnlteFlzQm8rTVFwamJPb1RzSEtVKzNVVDV2RnE0?=
 =?utf-8?B?dzRtTTk5NkZWUmxVdU9uZTdUVVFUc0dwOE04OTIwcnJhKzBVZ1d1TzVyQ0Jz?=
 =?utf-8?B?SDVYNDJST0VaaHREdjJ6YXk3djhLQ2dNb2ZwdVVBWGxON0diVnZVQ1RuN0dK?=
 =?utf-8?B?TnFXN2pMcW1PNm9GYmh3Nkx2MXNvb2VrTURES1JQbEpVTGRxamxKTU9mOXB5?=
 =?utf-8?B?TWYxRmZLNkp4U1lNWHBsTHVqVGtYYU5RK3hERFcwQlQ3VVlSWDFhYVJKV2xT?=
 =?utf-8?B?aXQ0SzJlaDh4a2F0aVplakVRN2lld3B0Z3Q0TzErbHlyQkxuVEI1OTRWamFo?=
 =?utf-8?B?MTR2Z0lQa3lYT2hhalppdVhMMXpmUUhzUnU4a2NkMGJDbTNJRjB4bmJQa1JV?=
 =?utf-8?B?U1BXVDNmclF3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7494.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0IzeWE1Q0dHUWlzOHlxcGVmRkN6anZOK3dHUVd2MEpKc3BMZ3pUMTU3ZWh5?=
 =?utf-8?B?cWVHTWlIMHpTend3Y3lDOC8waDlGZmRtNHFKRXNBck9VaW5kQm9Yd0FoRTVn?=
 =?utf-8?B?bTI2a0pxZFMwVXB5dHJvaE0zWGx3UXNCZFBzWFlUdUhLaUxwWU1WcHZGa3o5?=
 =?utf-8?B?MDMybWdmQW9vSmU2ankyaGU5blZzZ1AzWWNJcmxLQk5xMm14YWZSVjRNS2hZ?=
 =?utf-8?B?dmg5R2RjMXN3bEVyWEtGMlNpQWdicnpXeUx1dnJMQW5pWnVJL3Zld0VxeGlV?=
 =?utf-8?B?REFHbmVLK0cwS2dObEIySlk2U2srVmJheGtUelUvNU1pUjVON0xvVm81RHF6?=
 =?utf-8?B?UTJFZG9hTnhjaWFzMy82RDFZQVk1SXViejJ3WVl2elpHbndHbDBJd0xsem95?=
 =?utf-8?B?V25zL3dBcFJaeU5RSDMyVUQzTW9RVlRNVUdvSUNkcFhXQ1Y1ZXFUY2FROFBD?=
 =?utf-8?B?eWljQUVITzFQcXk3N1N4ZnFSRWRLZ0ZhZEZZOG1IeEw4TTNER0w3RWxMaUpK?=
 =?utf-8?B?akJCVU9JZlJ4M2UwNjVWSDlmTWYra0pOUGxCUjNUa2kyQ0Q5QjNmVUQzN09Y?=
 =?utf-8?B?VzhnaWQ2Mk1FSE12RmZsNERWWmc4RkIvZ212cEEyWktWM05XZi9NMW1KV3Jj?=
 =?utf-8?B?SFdUSkxkZVdEVTl0NFRlR2ZHaU5OYVVwVFFoTUp3UUM0eEtiNG9jNmd3NnNI?=
 =?utf-8?B?UUVOcjZPV3kxRjdMNWdOM3ZKQTdaZ1hoSkt0ZHpIMWl4ZHRqeXRmWnpTV3FN?=
 =?utf-8?B?QS9VRFNPN3dBRmlKaWo1R2dvM3BpNUR6NFJnY1FVQlZaMTJoRmI2dUxKN05z?=
 =?utf-8?B?QWNxaTlibmJUZHhqdFRObHdoSVZEbzd6TzB0eDlrL3J5Ri9PNEQzbzdwOHds?=
 =?utf-8?B?eU5Uc2Z1VU9HZDQ1Z00waEhlYWxsRFU2Ulkray9rZ28waEpsVkpEY2E1ZTdZ?=
 =?utf-8?B?bXhaT2orSkx5UmNsa2NmSDhCaGt6YzBkc0RlN1pBckM0aCtKWmVmYzIxUFFi?=
 =?utf-8?B?aFU2cXRFVG1ER3N0WDlkYktscFN0YnJhVDNUbjJzM0FzekJXQ0VCdW16aExC?=
 =?utf-8?B?eTBUZzhvTDMxZ0JPaVp1c01jTGlJTFlGa3NXdS9BZWNuT3RUT1ByNXg5bm81?=
 =?utf-8?B?NU1pR1U4ZWRKU2lMNEJORDE5enRkUDdLTHk1U2UyeDJNb1FyOUtuUExhOWk1?=
 =?utf-8?B?Z0orR25LYWFmWCtFTklqT0NEdEU3QmdnaysvTHJOZUE5dWd2Q1JFSmJsVzk1?=
 =?utf-8?B?dHV0Z2p1ajY4WjNRWWNzcTRkQVdQNytpczF6UC9qUW9tSEk2bVFGU3lXQXUz?=
 =?utf-8?B?VWRwcEtaWVZNcXliQ0QyWHJ2ekFXbHNNTUxtMHJ1eUdHbmpPMXZ5UWtpT2tH?=
 =?utf-8?B?YjVZdDJtRU95U2tYYXh6S1pGNUNXOURVNmRFTnpFM2JnOHlzMWxsZldzbklT?=
 =?utf-8?B?YUZiMjk2ckhSNjBuYXBXRWVUZktkWXJ1NzJpbnhoODdTTGtGMFFSNDdGQ2lX?=
 =?utf-8?B?UERkNHQ2Rm5NNFpBR24zUmJYeFVPVE11VzQxTHNJemFmLzlZNDFUTlRteFRn?=
 =?utf-8?B?V1hRWWJKYWZIc2loamRGdFlTZXlhVGVGWEVmYVV4bU5Jb3B3d0ZGRUd0L05P?=
 =?utf-8?B?eFA1aGxrUU8zT21vM3VKMm93U04xU3NTaTRWUENQYldrN3RuUDNKV01JWW1t?=
 =?utf-8?B?VzNVdXZCd3VJZUh2VmpBUjdwQzh4Z0d5UkVCZFR3aHdTc0JNVGdpei8vN3g4?=
 =?utf-8?B?RFhDOWdUamEvZ05YVGdiTnNLSXRPS3A4K0p4TkpiS0JJdnZMdDFYdDc4dXdT?=
 =?utf-8?B?TTg2cFFqamhHTVhwUjdDRjBCSW1VV3N6bDhtNkpLK1QzLzU3UjY5cjFFR1Vu?=
 =?utf-8?B?L3FueGwrODgyTXZjODdEZk0vYlFUbllBUjEzMVN5akMrc0YwMVg4TjNUZDJn?=
 =?utf-8?B?VXM5cjVCTVJvWnJBQ2dTbjVHNDRKcTJRcXlPNlMxNEZMcHdXWlZJQU11REMz?=
 =?utf-8?B?bVkwQTEvUk8vS3NQWEJKdUdXT3YvanRRbnFnaWYzbzVnZUVLbWdBc3RybVRX?=
 =?utf-8?B?elh5dVhQNENaOUZCakZicXBHUmtlK21IdkxuYWZZSzRvZ25NU2NNMUdlVzla?=
 =?utf-8?Q?bjUQJgsAMRjuHMN9DBnCVrPJM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0de7ddc4-591f-4f6b-1a38-08de227e232f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7494.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 06:30:28.7991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jSsFCoP1ib/J+WiV4o49nZemOunMx/MMYz+ySFT+czRcQXEB3xcBjWfGnuW4HMD1nCgkXNHTj6raJseqWClqlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6240
X-OriginatorOrg: intel.com


Involve the author steven.sistare@oracle.com of related patches to take 
a look.

Thanks,
Fan

On 11/11/2025 5:01 PM, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=220776
> 
> chenyi.qiang@intel.com changed:
> 
>             What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                   CC|                            |chenyi.qiang@intel.com
> 
> --- Comment #1 from chenyi.qiang@intel.com ---
> After some bisect, it is found that this issue is introduced by the support of
> dma_map_file in iommufd [1][2]. With hugetlbfs as backend, it will go to the
> path of IOMMU_IOAS_MAP_FILE ioctl. If we fallback to the IOMMU_IOAS_MAP ioctl,
> there's no such problem.
> 
> [1]
> https://lore.kernel.org/qemu-devel/1751493538-202042-9-git-send-email-steven.sistare@oracle.com/
> [2]
> https://lore.kernel.org/all/1729861919-234514-1-git-send-email-steven.sistare@oracle.com/
> 


