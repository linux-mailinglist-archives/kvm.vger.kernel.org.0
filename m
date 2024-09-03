Return-Path: <kvm+bounces-25721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51AE6969678
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 10:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B82B4B234F7
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5FA205E00;
	Tue,  3 Sep 2024 08:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DA/RMzv4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED34201273;
	Tue,  3 Sep 2024 08:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725350709; cv=fail; b=bUleDwgJBEqnlMYM/fjqOsk7KFpu/E/DNLrFgOPVZWzzMkw8uO8vhMS55KeLl5eUU1a5wLQZT2tu2wH/fG1XIgvI+PMqM/HPu5V5nenxH/xyQyqhlAlfer6Jhfqxss2m1oE7NSGccbyzoYK0xlVP32jEQiVkoH0M8Ye+WHjwsok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725350709; c=relaxed/simple;
	bh=R/B93AMEDzj1LoMUVG5Mh1CEHwB9MDt9wl9tq+yUXgk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RK8f21eGESrYSHucAECpJ9AWH/I1eoaMEvLw59PoxifENsL3wrTUGTS3le9+/1cy2HcZeOOR2yFrrfm+DcPWEbaviYXQe9dIaM+vN5Vr8anjpeVrXKnrAYMKX9EkbK2ecohVckvqhlAcbR6WXYERAm3hn9O25v8IbwG3G7Z+97w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DA/RMzv4; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725350706; x=1756886706;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R/B93AMEDzj1LoMUVG5Mh1CEHwB9MDt9wl9tq+yUXgk=;
  b=DA/RMzv4ngSlsAplTnxAB0JbcPe93fjBikg9vrpvo4ZhuerU2ApcmRoA
   6uqL453h4xGPZBBHj5BYPIfma4EoBgn36PwTUvLomVCyAKWqy4pjcOwpy
   0M1P0801Gqa+IS8WfiAajGbHbhS0Chs1LyhVPh6Ncvcyf842G7zLb4cuS
   1sYxwXrWR6ynlNF2T29R97cN2WKp4mYwEPj7M1fspI1wU7mAgpglzHteT
   KeIbhwBAiujVlScvQWMWnZ9hoULzazo1Ya8JlgJexsYQ5QHZ0xsxoY6rg
   XcjAnGubPpgFBGvdY7SH5INhYKdsvmFVI1I1Z71Jg7W/yMdO9KL2tdGa1
   g==;
X-CSE-ConnectionGUID: lMjt0GQtS3GcbrUarlWxnA==
X-CSE-MsgGUID: TasC5uzST+681FtLFdEGDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="26847545"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="26847545"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 01:05:05 -0700
X-CSE-ConnectionGUID: oMK9odgBTOCHlXRwUN9h6A==
X-CSE-MsgGUID: iV4pVPIETpKjsF70AALMag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="64867555"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 01:05:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 01:05:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 01:05:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 01:05:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 01:05:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihrNh1aEwgJD8iKgdBiUSusJ7OfMp6h0uvRSwSRZRyps2U/opWboq7AAwgV3b3topCoLMwkaDqkb9f2d1jfeA4Dl7/lH2tC5ZJJAamgrB4sp0v7jtrfH67eNkaZm6W2Me+Bd/PLK785ZTCc6eEtoju+rHxAXzG54u+XIuCP1MsgiVqY6c8wcmB4FSIVaUgrreLQm+nQM02cPbfTmUtiJZ0PEQcvRBFP9Sbe9Q6qDdn0shK6XAHQU5SqxYIXCPE3yWUuCPtxSzHoYwnCca0hTqCFcjQLyrGRYiZp0LCcHJ0cTjz7TSReCEq6WIW7GPKzB7AYcGhGAZLVzrGPoMZQTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8gEMiL3uWEV9ySpW2dDW1N5ozBAnCri9z6TytdQucec=;
 b=L4H3eRgDHsyrnlrCWVknVDZBCgJd52hK7HHptXueR0X5YhOMzVKGypJai8Q5hp2XSFlgCk+5HBt46kFe67y8wr41zq75OV+xg1qOSF7YCfrQaQf/E3wXWitecMnU/2IDqLE+GS73HqfW7actKMr/yGECdUcMLzd934KH1Y0EE89yWfIzt1n+vmcAFTUdZEsBt/f5G4ydZMKEpu4e/zgNmbAy4wxnmLAqwtC5vK0MTqQAFotmhLNDZjF6mHWz0HJO3oiVHRwJyP5yTi/J5IgTs372oCmwV712PVZiI/WTKxBf6TwXHc0cgLEzPbAtvp3eY6xTLZjYzZH9aILdhINkbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH3PR11MB8659.namprd11.prod.outlook.com (2603:10b6:610:1cf::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.24; Tue, 3 Sep 2024 08:04:55 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 08:04:55 +0000
Message-ID: <dd48cb68-1051-48ec-ae29-874c2a77f30f@intel.com>
Date: Tue, 3 Sep 2024 16:04:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
To: Tony Lindgren <tony.lindgren@linux.intel.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <kai.huang@intel.com>,
	<isaku.yamahata@gmail.com>, <xiaoyao.li@intel.com>,
	<linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
 <43a12ed3-90a7-4d44-aef9-e1ca61008bab@intel.com>
 <ZtaiNi09UQ1o-tPP@tlindgre-MOBL1>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <ZtaiNi09UQ1o-tPP@tlindgre-MOBL1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0199.apcprd06.prod.outlook.com (2603:1096:4:1::31)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH3PR11MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: 97ec51a4-1c43-45d2-2a4e-08dccbef18b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Sm02U2c0WEpUbFNJWnVzanJaYlozRkNNQTA3UVNzTWRNVWFha3crK3NKT1Ey?=
 =?utf-8?B?a2xzdTRjZ1FxaW1sNEpjbFltTnhPTkhlWDN5Y09DeDEvN2IxMEFVeXd3TFIz?=
 =?utf-8?B?YkRscy9lUFRWcDhqWEMydHZ2d2R5eXlwNk1naUJGd255TkxMNkl5TXRqTCtm?=
 =?utf-8?B?K2NibWhIclZEaG42WVlldGlFaTBvNmIrSmduOXU2TDNFcmlpeTVXVnp6Z0JJ?=
 =?utf-8?B?eVJmNGx0V3BteE1ZK3d6RDFtRmk3b09hN0dRWUJ3T29ETUVuU0NVWUpyYlZr?=
 =?utf-8?B?U1RBa2JlN25vdmVHb1lPWjdpemNrUVhGeEVnczRFU0hvdVpScjBtTTlLQVFN?=
 =?utf-8?B?OTN0R1k3dlZTMmFrVHA4Um5ZQnZWL2xHSzBwSE9jSkxHa0szMm1SdVhjZG5H?=
 =?utf-8?B?VkJiYTlyZFZPUU9VU1FMSm9SUFpSV3BQa3FjKzl3TVBKeFczUXdsc3I0R1I5?=
 =?utf-8?B?ZlVJTGJNOUpyK0l2Qmw0WlR4RWJWbXpMZFFXSitJUm5VR3hHOWo1Zi92Mkkx?=
 =?utf-8?B?Vng4NFdjS0ZyTUZvWC9QOG1xVlR5UTZFbktuVkNLQXNJNlIvRDA5WHVTZmcx?=
 =?utf-8?B?V2wxRFh0VU1pRDU3aktGUXhTOUdDK2VjcmxUOTI3ZnFNWXdLQXVWV1kxYTF1?=
 =?utf-8?B?dndWRGVWelBQUTJvb0YrUHc2cWNFRmQxNWhZa3ljUFNyWmJ1ci8ySzNEd01s?=
 =?utf-8?B?ZlM4b0JOT2Q2eFREQ0t2QzloZVFNMlpxQ0JPUnBYdzVTdHhSQkJxek5zZzZ5?=
 =?utf-8?B?dHBaeFVXU3kxM1lrTE1zOTVCWlhnQThpVDNGdzlLYllpektvWE5GUjZmZ0FL?=
 =?utf-8?B?TlQ1c1VJbFQrdkVLYXZlby9KdzJGREoreW9NNVBDT1FkanREakpqaDF5SVAz?=
 =?utf-8?B?OUtCWE52aklmTGs1blJXck9XQmorTVcxR1NRSnlLZG4rTVdjV2QrNS9lUGta?=
 =?utf-8?B?by9BUzVjbS9OQ0x5ZEZOaEVnVlNsL3RRUFJqRXQ3ZDBWWXZrTFVpRzVicito?=
 =?utf-8?B?NGFnZmIvd2ZyaG9WejNHVGRPVEp3NHMrM1p2QjAxOTJCWGVsdU54ZmFJL1JY?=
 =?utf-8?B?T2hzbXd1bUlqa0Y2TGJBbkNVeU5ITFNXUWtXR0FyaC9EMTRqdUR1M3ZCWFRB?=
 =?utf-8?B?N2JsUjBvemFEUFoxWTljcVFtcG9Td24wWnBRSEM0Z09zeFFURWZiN2tBTU81?=
 =?utf-8?B?T3NiR3lzSnNwTVBtblVXMHFsa3RNZjdXV04vckw3THpDVWVNczVXaThsYmFV?=
 =?utf-8?B?Wm5ORkRGZkhMK0pRTzNOUy9aNE5BeHAwaXdGYWRlNGplME1aWVNwclJKMkgx?=
 =?utf-8?B?L3V5ZStXM3hZeDBOajVxUEJOdjAySWtabjlEMml4dWEzdlhXZ0UxeXhQeWt6?=
 =?utf-8?B?MjBaZ3YybWJEZEZ3ZDJNSUFPS3lvM0ZlSzgxbXpvUzZNVlQ4aDJJUDJnUVZh?=
 =?utf-8?B?Q21FVnRBZ1lrVG1SNWJ0UFRQYSt0N3RWTDJyZk5ucWRkN2JGWHBtZDAxQjk5?=
 =?utf-8?B?bUZFbnZHb21KOWtzODJjQkFJcFBDbWJrdXdNdUhmRXluNmhkRWY0NGJidktL?=
 =?utf-8?B?bDRaUDlvK2krSGhLR0pzcmNPQ09rWmFtSitDYVpqTnc5K2RNSVQ5QlJsRUh4?=
 =?utf-8?B?T3RCVUt1bHNiSzVUMW9NN0tUMlcvSnExMkk4MWRoMWxGUHZMWmlwM08vQW1o?=
 =?utf-8?B?RktWMjBaU3JaQTdFWStXSEg5dkV4c3pSUGUvZExORkdrNExtKzJLbTByZXRQ?=
 =?utf-8?B?QS9kZFA3N0ZRaGhLSkYzbnZWbmRUNGl0WUNQL25UVHZlZjdKRWUwTGVlbnR1?=
 =?utf-8?B?dVBBaStyN0pmelpjeVZnQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDdKZW5DK0hmeFBvTkZRWUFWN2xBUmtzQ1YyT2NJTUJMTUMzM05YK0ZHOFRB?=
 =?utf-8?B?OGF1QUI2bWFnRU4xc1BvVWJtbzdEc2lLeTNhUkVzNUNCU0IycUtUaGQydE0r?=
 =?utf-8?B?KzRrL05lWWVBR1NVNlFuTkZCZFc0L2tRdytPcC9hTTJ1OHkwUXVadHhtdlVx?=
 =?utf-8?B?TWNGczJOUGlGMTlDK2ZrSVZjSkVoL3BQZDFWZCtIZVk2TWFOd3ZoNlVTUnp6?=
 =?utf-8?B?cUlrbXdKM3JrQ2QrRzJnVHpDcEo3ZEJXd0UwcUhzYlJKU3p3TnhCYndYTEh4?=
 =?utf-8?B?dndkL3EvNkc1S0srMTVUOVBaNVorbHYwZVlhTWdlZDlydWJ2NzBsQ1hHVVFW?=
 =?utf-8?B?QXZ5UGJoQkF1NE5WVm9pMWxyeExoUEs4cE5ORC9pdUV2aVFYQVhLdTZVdzF4?=
 =?utf-8?B?UHk2Qlp4ckw4UmdWTDIxVTJST2tOUUtFK24vRzJybkU0dEZBRTJ4QmthT3lk?=
 =?utf-8?B?Y3lIZUV0MWpiRWdzNExsVW9mM2tkaE1uUEQ5eWJMZXpYOVQrejNxNHRHYWFa?=
 =?utf-8?B?SkxFaE83ZGl5ckdhYkw3d0g2L0FCWEFpeFpOendWSmJreEdnSkxOay9PWDg5?=
 =?utf-8?B?bUlsaVMwbDB3Sit4dE4wVDljMjRvWTJuYnZjNk84YkdVVTBreU12SEc4Nk5S?=
 =?utf-8?B?N0hqMVpKRzIrOFd1TTJvTjBJV0hoU3B0cy80bTJoZ3ExYUdLZ0lXRzhoOXRp?=
 =?utf-8?B?OHNwWk1XYTZFc01JOXd4SGJZUVVTOWt4RzJ6QnFiOTA3Z0c1TFZsWHhuYU1r?=
 =?utf-8?B?TWRvZ2hIS1ZRQUI1TFdTSXpDRW9xUnlNUFluM0Z6azNFakx3Q25PVEszaHd2?=
 =?utf-8?B?dDR0bUFPSDFMdlNDSDFxRThUOWVhTGthVUZQd1NwOWZRcFNBTy82eHh5TCtn?=
 =?utf-8?B?blVDdlR3aGpkM0JkcXVSUU9wUm9XWnFvVC9FdWU5dDJVOU1zZlVYOTZrRnNj?=
 =?utf-8?B?NFgweC9hOEovT0x2dXNIMXZuLzBDTG9hWFRRRmU3d1RzbHRCZCtDa0lSbGpY?=
 =?utf-8?B?MEdwR3hrSk44d1lLVFJJaHdyaHFrVGpXUjFxWFhrTG9VZ0xOZFRhM2x1QW00?=
 =?utf-8?B?TXNQSSt3UjZ2WDVZNDhVMnBrYy9UQ3lKUWRzYS95bThGWHN6ZWxBRXlOK2Qr?=
 =?utf-8?B?eUtkcS9YQWNobldlcllCT0ZnV2E2UXlXbGt3T0NZY2QrQlJ2RTAvcHNYUGts?=
 =?utf-8?B?WUpvTjlvbDI1ZTM1NmJKVDMxOU1Fd2JtdXIyRkN2RjZSQVpHd3Q1ZHFINyt0?=
 =?utf-8?B?M21jZHJhenFYY00yOEFpaGtWbEVOTW1JT2o5M1pIQ2pXd1hldEYvNXVNQ2pV?=
 =?utf-8?B?dTRaZE92R0RQY0dhWUEwQndMSUc1SU1RcndhTXZ4bm5rLy9SYjJCMi9SLzRC?=
 =?utf-8?B?NzZIVnZoTEUxVk0zMjdza01JZlJ5ZW42TWJseFdtUkcxam9IOVFMeDdrZnpE?=
 =?utf-8?B?N3ZWY2RGbVZtUUkxVEtJcGNTZ3IwT0l2K21yTjJOVUlBM3Y5ajNoT3phZWNS?=
 =?utf-8?B?WlQzZ0FLb3dSQmgzNDl3eUR2dVJtS0hnUXoyaVloQ3NoUnYvNk5Yekt6ck5N?=
 =?utf-8?B?RXdIMjZPbmdtcUFlY1NiR3Vkd1NLVGNEbFgrbXZWd2VaNTFhZ1BxMjBLSU5a?=
 =?utf-8?B?Z1lEaDRPUDFKd3VtVzV3NUFsRUpVZGlZUjIxalp2UDFrQ3pFL2NKa2JJUnQ0?=
 =?utf-8?B?MmY4SXdXZnJJUzV0TmNjMWxaWG1UdmhlOEVsdkF1UmsrUEhpc0ovMUhvaitB?=
 =?utf-8?B?SVllVUJ5YldwTnVReWlkSVBwOEY0eXlzWWxPTXhNVlFaRlhCSTIrNnBmZDRU?=
 =?utf-8?B?MG13bGl2WWNIdjhIRjBORXlYSFJWK3BQLzBnbFNYYytwcFlzVmVFdFU3cndC?=
 =?utf-8?B?TWczd282M2hFU0lXWkNBT3NLdC9DRHB3bzFlQWNib1V5RnJxYjdoYzlKd1RE?=
 =?utf-8?B?SERHOWdjSndwcUs5R1hwWXRWU2JWTDRWVW1jaGwrdkRGY0VzNXBGVzVIVWF1?=
 =?utf-8?B?QTVxbW5vZEF2TDNxc2ljTnFDNVh0YVVjUUY1K2tQckJTbFdMUWhEOE42RUs4?=
 =?utf-8?B?WmMvNThNN2gyY0VJT0dQY05YRElaTy9wdlZwMXV3L3h6emx4bGo1bS9wbnhD?=
 =?utf-8?B?cWJTYVVpazAvWURwU0lkQXJSWlhkRjJGN2M0T2VodlRXSVFPNFFqREtyeUtI?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ec51a4-1c43-45d2-2a4e-08dccbef18b7
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:04:55.4955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtdrptfejSR1JgnGngeL0MBAwydCEkqz6AQ1VZj1goODlL0FhzGsH9f036QLV+Antq7QdTsoZS7m7QLG4P9nBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8659
X-OriginatorOrg: intel.com



On 9/3/2024 1:44 PM, Tony Lindgren wrote:
> On Tue, Sep 03, 2024 at 10:58:11AM +0800, Chenyi Qiang wrote:
>> On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>> @@ -543,10 +664,23 @@ static int __tdx_td_init(struct kvm *kvm)
>>>  		}
>>>  	}
>>>  
>>> -	/*
>>> -	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
>>> -	 * ioctl() to define the configure CPUID values for the TD.
>>> -	 */
>>> +	err = tdh_mng_init(kvm_tdx, __pa(td_params), &rcx);
>>> +	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
>>> +		/*
>>> +		 * Because a user gives operands, don't warn.
>>> +		 * Return a hint to the user because it's sometimes hard for the
>>> +		 * user to figure out which operand is invalid.  SEAMCALL status
>>> +		 * code includes which operand caused invalid operand error.
>>> +		 */
>>> +		*seamcall_err = err;
>>
>> I'm wondering if we could return or output more hint (i.e. the value of
>> rcx) in the case of invalid operand. For example, if seamcall returns
>> with INVALID_OPERAND_CPUID_CONFIG, rcx will contain the CPUID
>> leaf/sub-leaf info.
> 
> Printing a decriptive error here would be nice when things go wrong.
> Probably no need to return that information.
> 
> Sounds like you have a patch already in mind though :) Care to post a
> patch against the current kvm-coco branch? If not, I can do it after all
> the obvious comment changes are out of the way.

According to the comment above, this patch wants to return the hint to
user as the user gives operands. I'm still uncertain if we should follow
this to return value in some way or special-case the
INVALID_OPERAND_CPUID_CONFIG like:

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c00c73b2ad4c..dd6e3149ff5a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2476,8 +2476,14 @@ static int __tdx_td_init(struct kvm *kvm, struct
td_params *td_params,
                 * Return a hint to the user because it's sometimes hard
for the
                 * user to figure out which operand is invalid.
SEAMCALL status
                 * code includes which operand caused invalid operand error.
+                *
+                * TDX_OPERAND_INVALID_CPUID_CONFIG contains more info
+                * in rcx (i.e. leaf/sub-leaf), warn it to help figure
+                * out the invalid CPUID config.
                 */
                *seamcall_err = err;
+               if (err == (TDX_OPERAND_INVALID |
TDX_OPERAND_ID_CPUID_CONFIG))
+                       pr_tdx_error_1(TDH_MNG_INIT, err, rcx);
                ret = -EINVAL;
                goto teardown;
        } else if (WARN_ON_ONCE(err)) {
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index f9dbb3a065cc..311c3f03d398 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -30,6 +30,7 @@
  * detail information
  */
 #define TDX_OPERAND_ID_RCX                     0x01
+#define TDX_OPERAND_ID_CPUID_CONFIG            0x45
 #define TDX_OPERAND_ID_TDR                     0x80
 #define TDX_OPERAND_ID_SEPT                    0x92
 #define TDX_OPERAND_ID_TD_EPOCH                        0xa9

> 
> Regards,
> 
> Tony


