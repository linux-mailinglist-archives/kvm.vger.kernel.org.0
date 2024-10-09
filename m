Return-Path: <kvm+bounces-28288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 247259971C2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D82F528163C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000ED1E32AE;
	Wed,  9 Oct 2024 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pPRnMjqF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C67149DFD;
	Wed,  9 Oct 2024 16:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491516; cv=fail; b=GoswBAfFFayBA93rW/831fOMufC/9kpbMH4CSXB1pEX0n/xv/j7jp6VKf+y+Zqp4h2hIvGa4/RsDNCa87WUjI0cicfc29WVSzk1M67q7rqdtdfEQdiA9tX1JCC+M8x+cQX1q5BgkgeLOp286OjSt/vHroKQmqsKUXbW7Qo+tppY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491516; c=relaxed/simple;
	bh=ilCmqmDsjZSwgIGmpPZtLUdKTw9GBEn+I4iy80UIMgE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e4h4MQwB6QmqaBD8FE0RFUaTxor6XYLA7oSH4KyZuxWdeO7kQF+1SD5Bb2RDt016g2TojOucLaGT86JNtgjvu44jqpkQRbla0SazblfnqROpdvTc9yAph/YnHbMereKEGXiJcjhFgFAkvZKrlRncZj6ow35koHTj8KksnV//yyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pPRnMjqF; arc=fail smtp.client-ip=40.107.244.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ma7YuR5LvDdTdXhd3KwfTcVhild7p1gP0kl9QoL3sYP/LiShnnQ3Tbv6ja6Jpv8KfnvTucHyj/bsJZpQ1kkBYX0/0d+5F42cMmI4jLTCaCCklRAZnBXvldIIEkbUckO4Omls5bX9PXUy+VsZh640DOspOX/yx8iWanh57RRU1Vgwbb+f/+tZA3we0VgyqLgrUPo7V/DsyyFbBbE/B98ZYEIi4a/QU0QkmXs4FumLZzF5fwi7lpDre3g6tyz1q+9MihU6Y9fRKgKz2ImYU0SldkD+gCneB77xXyNQDBAmxxdTzPTVKMAMGDU/Fk2J/pumnXDKGNNi/E8QZe9HShMf1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjU/DFKo2xQFkZCUejF2Cyp2067C1LHLg3nmCcWzwxo=;
 b=Ffp56NQ3Ux/mfOg9R9gCSqYhva1Ddrp226YQeAzXRDpzLkGaNUPIlOMX9zWQVD86XFIXnaQZR3flNiVHdv7hFsm+dDzTk7kftaglu6H2Z8oovhSGh0Duj0Rb2kJLznf9Hmw9fquh0moicRGoIHrVZFt8zdSIvaD6VqeCOMjTDlAxv2Q6CfbmirMjTerwvV+s2V2/knRHGf0wK5TxL+pLgN3wcjc28pawQVRobJuN+iHwgwMzPHnufU4auGN8NXFm6S/RiVQbrltkiMD4r4PTsa0Y0++EOmXCri9m8hAu+bb3nsmu9POkActQpKh+4BNLJOd0suVv/tAs5w5NmS0u2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjU/DFKo2xQFkZCUejF2Cyp2067C1LHLg3nmCcWzwxo=;
 b=pPRnMjqFOaato2lfJUxmdwzX0dC/MNtmFsGC9q8kDstEwWEkZYmmvmpsB457DYVFuc5RCzt6KB1msp/nrxwuTYkimKfu5A7l0aGIXNtlyevzUxIMlhk1SkkF0H9v2ZOE/VFIWQTd8QtsV/QaUevED/ot4r9wW7LTYFUgWfeeo3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.16; Wed, 9 Oct 2024 16:31:48 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8026.024; Wed, 9 Oct 2024
 16:31:48 +0000
Message-ID: <4298b9e1-b60f-4b1c-876d-7ac71ca14f70@amd.com>
Date: Wed, 9 Oct 2024 22:01:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
 <9b943722-c722-4a38-ab17-f07ef6d5c8c6@intel.com>
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <9b943722-c722-4a38-ab17-f07ef6d5c8c6@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN1PEPF000067F2.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::33) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SJ1PR12MB6075:EE_
X-MS-Office365-Filtering-Correlation-Id: ee02c34b-8b83-49a3-3fff-08dce87fdeda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0FDOXpXUkE4Vm1CKzBwZElFaytzb3hVUW9Sckh5ZFdtaFVlUDVNVHJpcDg5?=
 =?utf-8?B?UXhTYzVQcC8yV21nb1RQclQxR3hQMmJwaHJLTmdqS0dtNTcxY2RIVWluWVVB?=
 =?utf-8?B?UVNQdjAzeG9KbVFoeDJxVm4wQXE3VTYvZ05LNWtOSStSbnZhSWRXaGMyTlFQ?=
 =?utf-8?B?ODFCVnEwbTlGYXcvM2Yvdk5aWFk2TmRudGxPQ24wNTJOTUxCRHp2Tk1vaGRL?=
 =?utf-8?B?M0xUOW5sTEtrRHVLQmJIZFI3c2dDb2Uveld6U1hWMmpxdGI0VmpKOXZaUmVs?=
 =?utf-8?B?UDVEMnlXUXhVS0EyT05MNUNmSnRuRWFZUG02akJSVnVLRXNOM0ExdVZLUWZQ?=
 =?utf-8?B?R3JLTzdKeWJwMVN0Q003U2M2VWJXZUtmUk9qOUFzMlFldFEzMFRNbGt1MGw3?=
 =?utf-8?B?cFNIVlZwTXZqdWhkeDdLdCs4T3MwQkp5R01nL2w1TlczOGYyZ1drTjZKbC9t?=
 =?utf-8?B?TFpsNnRlRExTSU92YVgwRi9jNGxyZ0RMazJNRHBYSzJROGFudldoWEg0QkJP?=
 =?utf-8?B?c0RBWW5MR3lvR3d5b1kyd0dQTmFGVFdkOVFEeFUvQnlCWk5wT3JGZlJlZFhq?=
 =?utf-8?B?b040ZmFEQ3B2T1dvbzRSYnRETUR0L3dWVkQwWUdJZXk4Y3RIS0V5RjF3TEdw?=
 =?utf-8?B?eDJFTkEzRWVJM09HVFlONjdaR0s0OHJ0THArVGhWL3dBd2FzbUdYbXZ1VE1Y?=
 =?utf-8?B?bTVET2RaSTcyVHo5ZFZSL0JZUmk5Qm5xeXVXZUc0blJUNjRmVjhVVDBkeWto?=
 =?utf-8?B?ejB2Q0tqS0UvRHM4cS8zZS9wMFNoQTNBM1pUKzM4WE5VTWFVc2IrWm4yekI5?=
 =?utf-8?B?TmZtUEpRV0NwY1RUVHFGeGR2VHJNUi80RWhMa2NqcnkxNjYzVVVPSEg3UFd4?=
 =?utf-8?B?bjNvNVhCZEpHek5PUmV1czdkdlM3ZjlxcmZIU1hOaVBsMUZMUVpGLzQvanZX?=
 =?utf-8?B?cVg3YlRSVTZHbGZxK2p4ZVhEaW92Y2NBbTZXRksrSnEwaTVYUEE3bjMrem9n?=
 =?utf-8?B?R2JJZ1ZWSjFkdkJlVitVQXN0QUd2N3pWL3NVa1VjUWt2andVVkdVYVJlei9i?=
 =?utf-8?B?Ym00WE0zN0ZsdUkwcjBsODVuZEtBdjhqZ1FNZWFRMjQ3WGU2SHdHa1ZHYktZ?=
 =?utf-8?B?ajZ6WWRRV1VCVm9VcnoxRk5FTE1WdmJwc3lhYjNUcm93SmpwOUczVWJwSEZs?=
 =?utf-8?B?M05uUnI5b0JkZWw4VXhmMDJFM2syd29YckpRQUpDSzJZTitFTm9LYTMyckln?=
 =?utf-8?B?bkM4YlVjTWVhVU1LSHJ0dWZwWWFKNVA0Mlk5VUVZL1Zld2htc0dKU2N4b0VW?=
 =?utf-8?B?Yy85RFkzTm81OHFCQUgwL0ZqUjFLQ3Y5WDJNMnk4T2NDREc2ZTlFR2piYktD?=
 =?utf-8?B?ZjlyT29Zbi9GcjdLU3lnSmtWSUN4a2R5cHpDWFpNZnVBTUh4TW5DWTdvVTE2?=
 =?utf-8?B?NFV6cXhGdEFBdjVyRGNBWU9XNzFVRXFCUnF5Y1hreERGNnViTnhSQ2V1TGxv?=
 =?utf-8?B?U21ncTkwVUtPZVcyK2hQN3F1aVdXQmVXZUU2WmxuWUZyeldpZE41cXMrdzNT?=
 =?utf-8?B?SXQ5RXk3cXNKWG5KUjRJSUNtbkp3WmM0VGt5cG9lMGVpSkNLOGFLR2FkKzRm?=
 =?utf-8?B?QzNqRWdnUUFWR2R2Zkhqd2JiazAvZGx1cGNHLzRnTXU4Smc2UkpqV0dRU2ov?=
 =?utf-8?B?SEtGMlloVWo4cVF6NVBnb1R2bEp3aUJ5bG1XdlBqM2U0cTRqVDNrYlZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUI1VzBTWms2NUEzK3V0TTliWlh6SmpBbXNPZFNzbDlEbzArZEpEM3NyWEN4?=
 =?utf-8?B?bENuTnJHMFNCUE45bmljdFNvdnVXS2hvY25LR2NvK1B2bVRGOExuSGlxd0o3?=
 =?utf-8?B?VVljUndQbE1xaFhWTENvREdXcVBVMnNyTlB4bE9vQnNjS3htQWcwcWFkazZs?=
 =?utf-8?B?QU54ZEVNZEVSRzAxN09DRm1IZm56YUM3VDhqSnRwc2ZnZTlmVVV2Z0pkSHFC?=
 =?utf-8?B?cGtzOWUzNkkrcUpMbHo2YUE4MU5HU0QxWXN6ZnJ0eHExUE9taEtZZWRDcXZI?=
 =?utf-8?B?RWxzY3ROOFhUd2FkakMzeHJOUTRDTEczTzlKOWI3U2NmRytwbTR2YzBXMVQr?=
 =?utf-8?B?WEM2UWFpTGc5L1hOU1NKVXplb0VzOU1uY1B0alhyaVpHZitQQUNGck5IdE1U?=
 =?utf-8?B?QzVkT25WSFVIWUZuekp1UGcvSkdzaDM5ZEV2cGMzMmRSQlJmVTh4UndjLzIx?=
 =?utf-8?B?bi9FR0VjOGpQVXV3VW9EWCtIK2RUS3RDd3R1NERHRkdTSG5zSStpemxBRitI?=
 =?utf-8?B?SHNiQ2V2Z1BrbmJaYit3SkJsbGVnT1NZUlp4eG5LOUtZY1JmZEI0dDV5b0Qy?=
 =?utf-8?B?ZWRFQUt5cTN4QVFGMkt4MGNyKy8vUksxZWRFeDdDMEhySUFhOGZEekVnaWsy?=
 =?utf-8?B?bzR3S2w1a0cwQ3FXYTZWRlg3aCs1U0ZIOXc2QW9XL0w5cW9PTG1abmlNVTNu?=
 =?utf-8?B?N0pFOURaUDFqTmVlaFFUQXZmL0NoU0ZsRkQxeUE3Ti9Ka0VjQTc4NTVCZzNO?=
 =?utf-8?B?cHl0NEtPc0s0dmJZTHNUVTB1dURnMnNpQmk4aU0xaWZQMWhBTGIyOUhIRHhw?=
 =?utf-8?B?bDJua0lHRDdJUnBGRHJueU1lQWVHOVFvMk5kMmhkYTFWOWhjb1BDSEZYSzRt?=
 =?utf-8?B?SGFQL1ZqZnBySUFDM1Z3YWNFeHRGNmVxVk0yeGI4cjhaYUIwTnlubUhnNCtQ?=
 =?utf-8?B?cTN2Wm8zd0RQSThUVVFhZlhoaHhRdEsxWDNNYnZNMlI3U1BKTGhGdHRaY24w?=
 =?utf-8?B?amt5KzFKRkRHOXE5bS9LRkpLZ2REdHNvK05UR3pmVENkZEJqaThDVGk0eklG?=
 =?utf-8?B?SnYxc1hRVHFhWitUcys1bElnYlpGYnNuSFlzbVMwWDhzYjhHYlFIOHhaQzMz?=
 =?utf-8?B?NTVVejhxZ1dDUGJVeTFINmwvZHRNcXNQR0hCRjM2UkRTaW9qcEk0djBqZExs?=
 =?utf-8?B?R1hWQ29ZaFo1Ti9NU0Q3N0t4anNQY1Flek5RbnczZXZVbGpVR3JvUVRkMTUz?=
 =?utf-8?B?MDM5Q2M4QXBrbnZTNlY5WWh0Wkd3NDhDU2pjTlRRemZLNnY4dVp2Rm1PckhN?=
 =?utf-8?B?aFRsek5HM1lsVERUVHN6UmQyeTB2TlRYQTNUTXk1WEV6MGp4L3FKTnZuRXQ5?=
 =?utf-8?B?Q1JFbW5JSVBXMlZjQlBDbmk3WlNtUlhvY3J6OTFVeW5yQUthSFIwb0xMeXd6?=
 =?utf-8?B?WjBVV09YRlZmQnlUZkcxejNOZVdiMzFxelZRRVh0b0pOVkpXWDdUcXUveWl1?=
 =?utf-8?B?UkhabkVCTkhOb0oydWRpbFRRRnVLS0VuYVlFRkxmRDh5c0ZwWk00Zk9hVHpG?=
 =?utf-8?B?ZEN1UzVLL1JIKzNrTEhPd2xZK0hlSkVBalBPbzhRVXZ4RGpSWVZSa3Uvcno3?=
 =?utf-8?B?ZU43aXl0Wk9JaUFVRGFwYnZvdXgyRG9sOWhwSm1hVldMZEd5QXhyYkxXSEo1?=
 =?utf-8?B?cndjNUhoUE94NFA4SjlHdFpBbXNOa3lOMWZNNWFRWnUzY1FBN29HRGJXanJY?=
 =?utf-8?B?TmgxYU5RSjRuanZsbGZJL2NhQldVTVJ3NXhXcEIxVG84TkhTd0ZhSU45a1lN?=
 =?utf-8?B?OTlkczNDQ2t4N0hRWVkxSC9ndytDVlYzUWxSYVg2YWxqVlRnQlo4cE5TdFZX?=
 =?utf-8?B?Ymo3K1ZVck1OQVZzSi9yY2hnT1U1R0F6SVRQUUFyc0JQQUlVYUl1djRWeDlJ?=
 =?utf-8?B?OHhGTUc5dC82ODQ3OGR6MWdFM3hORHJRUDdaaU1rMCs4amNUQnJBWmplQlVV?=
 =?utf-8?B?Mm91TkhwMmFQRlpRRjlPSmpUWS9nV0lsUHBiRWN0d2l4QUcrWHJrTEFCMGlp?=
 =?utf-8?B?bTZCbG9lcWp4VUFMNGlGWDNYbDRPUXphaStkMGZVc2NoQkJPR0NnRExzTi9O?=
 =?utf-8?Q?8ZlBz11lhSNuIxrgrpnHdX92f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee02c34b-8b83-49a3-3fff-08dce87fdeda
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:31:48.0371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wOlqNHoxjPBocr9OhTWf/S9l1RcO7eweFk6urpEMnIe0QBRi1eP1dVWCuiKzo3w+iqscOke5adAy/orJVmPxzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6075



On 10/9/2024 8:57 PM, Dave Hansen wrote:
> On 9/13/24 04:36, Neeraj Upadhyay wrote:
>> +	sz = ALIGN(num_possible_cpus() * SZ_4K, SZ_2M);
>> +	backing_pages = kzalloc(sz, GFP_ATOMIC);
>> +	if (!backing_pages)
>> +		snp_abort();
> 
> Is this in an atomic context?  If not, why the GFP_ATOMIC?
> 

No. I think GFP_ATOMIC is not required. I will change it to GFP_KERNEL.


> Second, this looks to be allocating a potentially large physically
> contiguous chunk of memory, then handing it out 4k at a time.  The loop is:
> 
> 	buf = alloc(NR_CPUS * PAGE_SIZE);
> 	for (i = 0; i < NR_CPUS; i++)
> 		foo[i] = buf + i * PAGE_SIZE;
> 
> but could be:
> 
> 	for (i = 0; i < NR_CPUS; i++)
> 		foo[i] = alloc(PAGE_SIZE);
> 
> right?

Single contiguous allocation is done here to avoid TLB impact due to backing page
accesses (e.g. sending ipi requires writing to target CPU's backing page).
I can change it to allocation in chunks of size 2M instead of one big allocation.
Is that fine? Also, as described in commit message, reserving entire 2M chunk
for backing pages also prevents splitting of NPT entries into individual 4K entries.
This can happen if part of a 2M page is not allocated for backing pages by guest
and page state change (from private to shared) is done for that part.


- Neeraj

