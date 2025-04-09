Return-Path: <kvm+bounces-43003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3BEA82178
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 11:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F89B8A700C
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 09:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A4325D55F;
	Wed,  9 Apr 2025 09:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GzotYsIG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0124525D536
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 09:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744192629; cv=fail; b=e0vrEqDHDfLI/eOlEbYcZr+dTdseEhAmMjIh4V/2jIZQq6GFKYgujUMKYLlpXkPIJX9QT+N3BbXSmmjD8iEs7/yL0d69C32vT/cB8n2dSzVSmLCE5o0kFlDp+X6Wbza7KgNY2QkUJuBrp0RBFf/Lfl3KNh14gu6nrl+XbFFHVbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744192629; c=relaxed/simple;
	bh=WIEY8UY1UCXemiPxYFXKzgCTJTtYjFYSCfGx1rvsRks=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K0SR4clQ0LJMafYKOG+HbfzZV8ptYoE4BtiJFF4KxxP58nz9loaBOCXNRMq0+dodFb9cxI+dredVCM/UCfJhUCjSeqrFgnxa0T5lQMbpdTJyBpZBq29SwIK785TVDt3GBRv5i9iyGuTtRJCBFy70Ise2MfwG3L3fZckqX3m3TTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GzotYsIG; arc=fail smtp.client-ip=40.107.244.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kAyhFH4aN3ammbagKCUFIQCCh/qK/P5lGDE2IrgoHH1OLWY7dJ4nYJmoHgecjS/QvFWhyfOxl9/5YqGrpuTY5lK0t9tIB9qYv1XrnJDYzcXCw4tzlZhVuQYrGr+iGaCedHMisCVK0bcp3O2jatLd7dWWj+3uUkSBKpS5qCoUs+OhSvAYC9CTFhOuayXlo23C85+Ab1633bEsKQOq3eh4lTJqok8upSjYUalKJdMkSqFuah9sU/jSsgExy7itBKuBwZfojbxnBgPSiRT3Fj3tTkEzZoXCy+53VwkTlB2TqAHdWTa+E5LqZ/vcd/ixur6u95qjoMOheGwUmO8TL5aMHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yb3Hfctm9bUDjQ3OyqlboNPe9C+Ng1A2OBFvFcwyYc=;
 b=dZElE+IV5RNkXayXZs/CYIS8eHsH9zSa52x/Y7d8P2I/1qttkkN9yFWDeLRLNqoAwwklhxdluYhXI1owUC9lA3dfSCIMJhMNThQZEQ64YlHJsTproCuw4Rv6le0pymRiYSk7HgcN+gtnN0MrYRrEVQvTAWpsqplHMk5kLPh7fMPagu6FkAGOOkZBmbKyc+GeoU13cqQmsnCvrEecR6RSBqNky/Ms0SDRAnxX6xrhd7GAoZgaFoFk8lrSHi2GaBSp3evcai9fgrcXmjVrb1ZrjawuraSNYhEi3+d/AkEd8E6IWtV/tfpR0Aq5I2KJLI1DILBo/02FgQ4ZIrmm/I3J8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yb3Hfctm9bUDjQ3OyqlboNPe9C+Ng1A2OBFvFcwyYc=;
 b=GzotYsIGLo5TdVNe0X3Fw2LuyI6FNB/IvKgrM+UmtnOXJe8IpFK0LAiPm+BgmJLpC5OySPZM3BXq9w9BmSuAbRS14tY+WuH1TQdzxxN5bQEI8e4//YoHUH+GDt+epa9S1hlqFyFuWE0jzyAoiapgLxESUl9SbrZhywgSfLyY+5Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB5951.namprd12.prod.outlook.com (2603:10b6:510:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.20; Wed, 9 Apr
 2025 09:57:05 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 09:57:05 +0000
Message-ID: <a72382ad-ae29-4e5e-b2e8-ebb378861e30@amd.com>
Date: Wed, 9 Apr 2025 19:56:56 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 05/13] memory: Introduce PrivateSharedManager Interface
 as child of GenericStateManager
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-6-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250407074939.18657-6-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVPR01CA0054.ausprd01.prod.outlook.com
 (2603:10c6:220:1fd::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: dc6eabd9-0f20-400a-b045-08dd774ce265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1puVDM2eVBySUJTeXl2MnRHTWNhcEsvNy93Rks4WmQ1ci9Td2pkZTQweHZY?=
 =?utf-8?B?ZlhUREQvUEZDRlBMb3MwaTlOU1JEUnY0NlFZbUt5aDB0Slg4N1VQKzFYTGdQ?=
 =?utf-8?B?SGhpUEw1Ny91cWlKd3NJaDk5ZjFKMGtKVy9CNnd4Nk00UmRoNVhiRWpLV29T?=
 =?utf-8?B?YlBYbkw5YlN5emh2UG8wbmVtRGY0aXZBMSsrb1YrVnNCL2Yxd3hHU1F0aEtj?=
 =?utf-8?B?blJQNWxuVE9BUERDdGozNGY3N2VITU5lM2Q2bjJqbXR1UU05K2pXUWVOSXJM?=
 =?utf-8?B?a2hUTnZtL0tUWEkvbDVmcTVRSGRiSm8rWFVISDhUQWhxc05IY3RYbXp0R2ZS?=
 =?utf-8?B?SFJhTmlRWmVrWUhRQ2hFNllNN3cydGFDK25hSkkvZnNFVStSVk5LZGdGRnNn?=
 =?utf-8?B?dGhLL1FrMVMwTlQvdXpmMXppVno1dEEwYmUyN3FyZEsvdnEvcFgvNkw5b0h4?=
 =?utf-8?B?am1DVm9FNSthSDdwRnU4NlMzR0NqN1B5eWoyMitNUEtLeWR6Q2tiWFg3NGFE?=
 =?utf-8?B?c2YvWXk5MnJFZUNTemhzcEx0TFVWY094ZDd4KzZRUXhqeFZGS0JEcUtyLzBC?=
 =?utf-8?B?djZROHZ5NGV3cER2d09Pbk03cXlRczhoVks0SE5CYUJSNncrL2k0QUYyVWhW?=
 =?utf-8?B?dmVYTXlwdTZKODF3aWNVS3JURm1WMXI0WnRZNjdKN3JRRUhqMkFySjdVODIv?=
 =?utf-8?B?SDJaVVphZGIyWVZ3alNDUTYyVWxRTTJNelpGK2w0MFRLdjZnYmg1b2FCdlhE?=
 =?utf-8?B?VmpkZFA0bG5waERUVmFkamRrdW8rTEdqbGZEN0pKa0Q3TFpjekFiQ25QNnY2?=
 =?utf-8?B?TWpKdmY5c2UyemtpMk5qRnRDd0NsVHRja3RaQWZSRkw2Y2JuYVRyUzFFc2JO?=
 =?utf-8?B?UlRWMCtNbVNULzV5N2p5UHNtRnA3dkM3Ynl3VG1aVjdIb1U4NnR4R05DdVVF?=
 =?utf-8?B?N2lNSVc2UVYyT0pCdnBtVzJBREwzOHM3Zms4VzNmWW1JU3ZkVnVGdStKaE8w?=
 =?utf-8?B?TjcyWjhsMFRwVDdxTkVsTXErUnB0dVdhWW1LNSszNy9vVWhuZm5ZeGhwT2xE?=
 =?utf-8?B?QmpvaWxDM1ZHQStwUW1pYzNFb0o1NWhRU3ZySHpIenNnckk4RVEwanNPdGFn?=
 =?utf-8?B?MHpzZ1hDVzBkSWhBYUowK0lIRW5wODZsdU1yQ0ZxQjMyUTNMUEYrOFhzUzY2?=
 =?utf-8?B?VXF0Ni9mYjZ3b3Rab05rekU1Q1A0T0xUOGxkUWYyYjFkbm4vVVc1OEU4UHZz?=
 =?utf-8?B?QnFYRC9wU2cycmJjRW53MnZKNFVPckIvQ0lTNXlWbWtBVzR2YzZVbDVTc3pQ?=
 =?utf-8?B?RFM3TTM1ZWNZK0pFMXZ6SGJ1cWQ4T09hTy9weXBpRVErRzRiT3NSZm9XUUFx?=
 =?utf-8?B?Y3NKWmtpUDFMUEJLTzVwcjVNcGFDK1VtMUdIYnlhc3BtS1ptSUdaMTIzU2Ey?=
 =?utf-8?B?aFI4bXpZcDI0cTg1ZjA3b2hkNExqZE5raHdSWi9yeE9DSHZvaHdHd2p5WXlI?=
 =?utf-8?B?UlpvNERlcHVRM0NyNDZTK0lYSUJYb2t5Ym9sU1E5UHlhejFtUnJnMEJrcnZB?=
 =?utf-8?B?ajZsYnM2VEVvTktpV1BtRXJRb2NmSGhoYzNuT2Y5cXpqcnJlSmVSZ3c0Qm5R?=
 =?utf-8?B?Y2kxOVdLbDN5YVVNOVlYVmhWMEdPZC9OdldRYktQbUtYai9yVUpLWHRyckZ4?=
 =?utf-8?B?a0VtUWJudDd6ckl0RkdOL3RDQXZtSVlxb1VSdWFzaTNaWktkTE4wTEI4b0w0?=
 =?utf-8?B?T2l0eklXLzlqQzA5akEwZWJKRVBoWGs0S05aU0FBYXVXV1V3b0NFaWljSzdo?=
 =?utf-8?B?QUdiaXZhVk1uNWIzejlUWWdXazZqQWY1QjUzNW5FZUxWSldmTGRvM1oyYVdY?=
 =?utf-8?B?aisrYkFvc01JcW5JOXdOSDJFTWhPZVZLS0VlZTdaQlBkQmJ4REt0M2MveVQw?=
 =?utf-8?Q?7t1PmxtpvMM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3pHMWdYT2FERUh2aEpuQzVNRTlvMmxwVnpFcmZOK3U1Z1R2b1JyaVRZUTZJ?=
 =?utf-8?B?ZVJGT0xJUHlPbm80cHhHbXhwU0xnVmppbURZTGEzUGt3b3F6eHUvaHlBbkVu?=
 =?utf-8?B?QlpJUTZHMEY3VFlQY2ZIZXJ0NG9qZCtpZVJQUk1WL01HRXlOUDhqTVI1VmJI?=
 =?utf-8?B?ZmllVy9Pa3pIQi9ta2plYlJ3cm9tK2IwL2JxL1NCdEoxVXZYK1RZd3ZtQTRE?=
 =?utf-8?B?TVV6SVZGMG1wVEZPOCtpelVIdVJaZldvaGpDUUxvUjlXTVRWWWhZeERJR1Zh?=
 =?utf-8?B?cU9GV2w2UFZDQ1N0eXlBaGFKam0yOG9qSzRTclQ0UkwyN0ttTkpvejVGUTVB?=
 =?utf-8?B?S0s4Tm4yaElKdHR4ZmlPZ3R5dG5yWERaSXhQSXd6MkM1Qk5WSjZwUUY3U0xG?=
 =?utf-8?B?MGlDem1JVitNRTBySGlNTEVxRHZQck44NFpUQUpjTE1uS2tEOTF1dlpVYVB4?=
 =?utf-8?B?OWJUZ01ucGJpOThqM24vWnA1QlRmSXBlYjJ1eXd0UEJjYnBlWUFneGZaMjli?=
 =?utf-8?B?b2lxWllGU2RBUVNWWUs3SWNJTmRIbU91TGxZNHlTVnFaVVZ2ZDg0QU4zOFRP?=
 =?utf-8?B?Y2hMd0gyVkRkYzAxRWdweWNKZXlIRlByeGtKZU9IZEFMaStIK1ZPK1NJNWho?=
 =?utf-8?B?K0VVYXoyYWUxdVBGbjNTN2E5dStGZWVaNW9kekhOV1RJb3BhK2tsK28wUjNR?=
 =?utf-8?B?bC9ldjBPNGRjaFIvQ21ZL2pJZEZNdFgxdnE5ZUd1d2dFb052UDUrN1pxRUxI?=
 =?utf-8?B?QWtOcFlQS2lYalJNeDRDcXJwRlU3dUpIVWxBY004M21kSjlsMWxGMmg2RHFD?=
 =?utf-8?B?cWhCT2l4T1BSNE1sMGs5blJPeUxZVkVJN0U4dnZSOFg1SlFTSmpTVEkrdU00?=
 =?utf-8?B?em1ndC9FMUpuTmk4aTB0ekhsdnFVbWhwWVdtRDdtS3VvaTkwU2pMNzZYYzhu?=
 =?utf-8?B?YTBpRU5WcEIxK0NsTUFIK2xOUU0yNUljMHMxR05nd005RktUWjRqMUo2VmUr?=
 =?utf-8?B?SW55a0QrWFE4b1VrN2s2UGJ1U2tJcW02U2ttVzUxUnJ2cDY4N2piU01TTDBn?=
 =?utf-8?B?NlE1MTI4Ymd5dWZGcWRuSzFNTTNBYkRQa2ptcEFzcUc3MWE2cFVJR2FyZ3Q3?=
 =?utf-8?B?bTV6NW9sYUczem1HY3RVelRvSFNzOFdUTXo5WEo5ZjViT25VOWR3L2xlNUJ0?=
 =?utf-8?B?RHFjWFcvQWJlRGsxSUgyUTRMaHRFVmZGb0VjZXYyQ1pXUCthajdhbTNyeHMz?=
 =?utf-8?B?by9tTjljRDBiVzI4TnkyWndUL0grR3hOeXNNdmtNaFVvRkJkQStpQldOS21h?=
 =?utf-8?B?aTR3N2F2K2VoTWg5UVFVd1F6d2xSdjExWDJVWUNkMHZJNUxsaDFsOUgzN1lO?=
 =?utf-8?B?TTRxMVVyMXRlQyswSHdNZHRyNG5KalBIVVRWQjUxYktPYkdZbmM1Ymxrd2Z3?=
 =?utf-8?B?L0dGWEpWemVrd0c3ZFZtTGM4NGkxL1JneEIvczloL3pzang1SmMyUDlLVUh1?=
 =?utf-8?B?Z2dWTHBmck9tcmJ5M2tNanFzTTFDVmJYeW9WU3AzYVdqMkJSQ2U2b1VYYXM4?=
 =?utf-8?B?TWYwcjNEcndzeEJvMWEzU2ZPUEMrYnVyaVFLbHh1NjhoZHVkYUJ6WVduN0N5?=
 =?utf-8?B?Vk5RYXhNY3p4d01majMxZStsZDNwNkpBSEpOeDNFTnpPa29lcjNqUGpuZkVR?=
 =?utf-8?B?OFI1SC9xbUxRbU5tekI0OTRUcGRFSUZlSFJrNDVZZWNtdmJsNUtyam52MXhk?=
 =?utf-8?B?VnpuMmJsSjJ3QzRlSk1OaGR1c0VVOFpXaDhDb3NCVWo4MGVRQXZkRUdUSFhR?=
 =?utf-8?B?T0Q5bzdkRUQ4aGVjN25aUkhOWi9MQU9DdjhkUXhtQ3lMTW9rU3NkU1VpQ09t?=
 =?utf-8?B?UGJHYXVSWDRoWkMwT2FyTDI0dU5zazVITE05ZkoxOTl5RHZaWlAxQzBiRHk1?=
 =?utf-8?B?QlV3Wnd6UXR2N0dGZU9neW5vQWVaVnNBb2RaNzZOR1RKZEZHWm55Tk93SHVJ?=
 =?utf-8?B?YUNjNzBFeng0UVhlaEY3eWtjWmVnWXo4ZzJEc2tkZ0lrbGRVcVFPcXBLNUZH?=
 =?utf-8?B?NXYyUjQrTkF0ZFg0NmlIaHdXZlhzWUlrVUd6WUp6ODBodGpHSXhiUHhERHpk?=
 =?utf-8?Q?9sDUNp34qbLUDH08b4rQ3lfad?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6eabd9-0f20-400a-b045-08dd774ce265
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 09:57:05.7129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nuwpLJIqTz6qgKjkeM6ns3IrWItOUGZLWjTZj+B9ejoHfNUizOAhBZhpXOaSqif9FaGzI8Miq6933TizGGEoBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951



On 7/4/25 17:49, Chenyi Qiang wrote:
> To manage the private and shared RAM states in confidential VMs,
> introduce a new class of PrivateShareManager as a child of

missing "d" in "PrivateShareManager"


> GenericStateManager, which inherits the six interface callbacks. With a
> different interface type, it can be distinguished from the
> RamDiscardManager object and provide the flexibility for addressing
> specific requirements of confidential VMs in the future.

This is still one bit per page, right? What does "set" mean here - 
private or shared? It is either RamPrivateManager or RamSharedManager imho.


> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v4:
>      - Newly added.
> ---
>   include/exec/memory.h | 44 +++++++++++++++++++++++++++++++++++++++++--
>   system/memory.c       | 17 +++++++++++++++++
>   2 files changed, 59 insertions(+), 2 deletions(-)
> 
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 30e5838d02..08f25e5e84 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -55,6 +55,12 @@ typedef struct RamDiscardManager RamDiscardManager;
>   DECLARE_OBJ_CHECKERS(RamDiscardManager, RamDiscardManagerClass,
>                        RAM_DISCARD_MANAGER, TYPE_RAM_DISCARD_MANAGER);
>   
> +#define TYPE_PRIVATE_SHARED_MANAGER "private-shared-manager"
> +typedef struct PrivateSharedManagerClass PrivateSharedManagerClass;
> +typedef struct PrivateSharedManager PrivateSharedManager;
> +DECLARE_OBJ_CHECKERS(PrivateSharedManager, PrivateSharedManagerClass,
> +                     PRIVATE_SHARED_MANAGER, TYPE_PRIVATE_SHARED_MANAGER)
> +
>   #ifdef CONFIG_FUZZ
>   void fuzz_dma_read_cb(size_t addr,
>                         size_t len,
> @@ -692,6 +698,14 @@ void generic_state_manager_register_listener(GenericStateManager *gsm,
>   void generic_state_manager_unregister_listener(GenericStateManager *gsm,
>                                                  StateChangeListener *scl);
>   
> +static inline void state_change_listener_init(StateChangeListener *scl,
> +                                              NotifyStateSet state_set_fn,
> +                                              NotifyStateClear state_clear_fn)

This belongs to 04/13 as there is nothing about PrivateSharedManager. 
Thanks,


> +{
> +    scl->notify_to_state_set = state_set_fn;
> +    scl->notify_to_state_clear = state_clear_fn;
> +}
> +
>   typedef struct RamDiscardListener RamDiscardListener;
>   
>   struct RamDiscardListener {
> @@ -713,8 +727,7 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
>                                                NotifyStateClear discard_fn,
>                                                bool double_discard_supported)
>   {
> -    rdl->scl.notify_to_state_set = populate_fn;
> -    rdl->scl.notify_to_state_clear = discard_fn;
> +    state_change_listener_init(&rdl->scl, populate_fn, discard_fn);
>       rdl->double_discard_supported = double_discard_supported;
>   }
>   
> @@ -757,6 +770,25 @@ struct RamDiscardManagerClass {
>       GenericStateManagerClass parent_class;
>   };
>   
> +typedef struct PrivateSharedListener PrivateSharedListener;
> +struct PrivateSharedListener {
> +    struct StateChangeListener scl;
> +
> +    QLIST_ENTRY(PrivateSharedListener) next;
> +};
> +
> +struct PrivateSharedManagerClass {
> +    /* private */
> +    GenericStateManagerClass parent_class;
> +};
> +
> +static inline void private_shared_listener_init(PrivateSharedListener *psl,
> +                                                NotifyStateSet populate_fn,
> +                                                NotifyStateClear discard_fn)
> +{
> +    state_change_listener_init(&psl->scl, populate_fn, discard_fn);
> +}
> +
>   /**
>    * memory_get_xlat_addr: Extract addresses from a TLB entry
>    *
> @@ -2521,6 +2553,14 @@ int memory_region_set_generic_state_manager(MemoryRegion *mr,
>    */
>   bool memory_region_has_ram_discard_manager(MemoryRegion *mr);
>   
> +/**
> + * memory_region_has_private_shared_manager: check whether a #MemoryRegion has a
> + * #PrivateSharedManager assigned
> + *
> + * @mr: the #MemoryRegion
> + */
> +bool memory_region_has_private_shared_manager(MemoryRegion *mr);
> +
>   /**
>    * memory_region_find: translate an address/size relative to a
>    * MemoryRegion into a #MemoryRegionSection.
> diff --git a/system/memory.c b/system/memory.c
> index 7b921c66a6..e6e944d9c0 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2137,6 +2137,16 @@ bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
>       return true;
>   }
>   
> +bool memory_region_has_private_shared_manager(MemoryRegion *mr)
> +{
> +    if (!memory_region_is_ram(mr) ||
> +        !object_dynamic_cast(OBJECT(mr->gsm), TYPE_PRIVATE_SHARED_MANAGER)) {
> +        return false;
> +    }
> +
> +    return true;
> +}
> +
>   uint64_t generic_state_manager_get_min_granularity(const GenericStateManager *gsm,
>                                                      const MemoryRegion *mr)
>   {
> @@ -3837,12 +3847,19 @@ static const TypeInfo ram_discard_manager_info = {
>       .class_size         = sizeof(RamDiscardManagerClass),
>   };
>   
> +static const TypeInfo private_shared_manager_info = {
> +    .parent             = TYPE_GENERIC_STATE_MANAGER,
> +    .name               = TYPE_PRIVATE_SHARED_MANAGER,
> +    .class_size         = sizeof(PrivateSharedManagerClass),
> +};
> +
>   static void memory_register_types(void)
>   {
>       type_register_static(&memory_region_info);
>       type_register_static(&iommu_memory_region_info);
>       type_register_static(&generic_state_manager_info);
>       type_register_static(&ram_discard_manager_info);
> +    type_register_static(&private_shared_manager_info);
>   }
>   
>   type_init(memory_register_types)

-- 
Alexey


