Return-Path: <kvm+bounces-31626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28AF79C5C8E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB019280F52
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 15:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7AD42038B7;
	Tue, 12 Nov 2024 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WbdGbMke"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2067.outbound.protection.outlook.com [40.107.100.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FC2203705;
	Tue, 12 Nov 2024 15:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731427008; cv=fail; b=RT2hGyho8UR0Fai1ityLvGs0eqwfFnSyW1YWgapAKG2se3fUoqifLTc6WzHe+6tFtBUM1Qg2ysgZiM0zExMbD/8wo8G/esqkJbhcxehif8ffQ56jkq8etTwsBjOu+vuCMIh2rBzXhtElybLf60yikm7y2yBl3DfiIUvQ5W0uHnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731427008; c=relaxed/simple;
	bh=vGt204ulQFduFzzlDSpOK8702Jbong6RLufN+taIKu0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Bp5Dv1yJfIOWHS08Ws7621wXjgd7oXHmCd3UP1NmBvsLE4fQZh/bA4lcW9n7YEqBkvjaN06dKLYdWDPqETSQ1HjMAg6YGDzlO2cVEm3ZkNQ62cWUSGUOaOdv8LwYHsBhZHTNI0RWP3DT47UAXFvMMO98aAIGnl+NwHZ+5qmO5eU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WbdGbMke; arc=fail smtp.client-ip=40.107.100.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UpSxgBFEgJeN9EoMEbevTXe5pKS5VnmGZ92dLvs+EM4mkIV1UzoyPg9vaOOQZ/gbKiOb2TiHxhaNFZXiLr7I+w4Noo9eDODDR0zLZT7xPQ8iHeZ62nGHc1t5NvRf9wI/ZdzRmhnSM+kmUH1VdKCGcxxxENb2wxXy0I2LEpE8HWFMBsQAUXzXonDsbH0ioXkXVl5M5DKt4E8uHoM5Oz//WYx+WjecwPvkoGOd4ILJKA/gNAZMIdbrwVdNTYLg6AG9KSO72+kCIs5Uc8FvFHIcVupk4eoC9B3oqgHV+oGpq07C2pDrB1E9VjdBeiljsebOh0Ede0X3PQLkXnYGOOJYmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhPXk1J7hBS52kQ/5H/Ier+2IV1qmIZ/WE8poUji9EI=;
 b=Xqdgzvme8siYNey0qVBwv9imrhqBSJ4+6pmxoa7l5qncmhhDLx2kMjxhSe/4gpUDbKvSzzVVKkczvojKMH4C3PE7hwKqWNvIcdyoqgOipXLJHwzAoE1BE4s0uSCs9ZuDD/YRnZyB6Zfovq2Tc0qt2etyx2GI2tEUQLy6qyseC69KHKwAbK4ZW5nDz/T4kp3mXw3nZ9zjnFQt7EEAmZxWH2T11kDB87DDXDyjQRC2GOsx6R+IurLT3Wka4zDhVnrKTEtP3515Oy5OEgFxCYjOY7qIG1DfmzIwV92POX+FXo8xDOCChI/3u4WtPEXqdzTb5kWfRNxzfQkJC4Symb2jlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhPXk1J7hBS52kQ/5H/Ier+2IV1qmIZ/WE8poUji9EI=;
 b=WbdGbMkerZjDEH6t7Ci0ZNkKDCFVGUZYsgJ7b2MRGP/qOU4D7AzsyninUgHzrOvnJiOZpvjZuT43L4qJu7g0KdIBR/KdE0bBvmjl9AtgUjG1rIAnttA6g8k9MWEEco8znClbP706CmIewu4jHWjnyHifUVQWwhdmAUr1k3wARBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW4PR12MB7143.namprd12.prod.outlook.com (2603:10b6:303:222::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 15:56:40 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 15:56:40 +0000
Message-ID: <35b35091-1787-19b4-176e-79cd616d7dd5@amd.com>
Date: Tue, 12 Nov 2024 09:56:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 10/10] KVM: SVM: Delay legacy platform initialization
 on SNP
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-coco@lists.linux.dev, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Michael Roth
 <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 kvm@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-11-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241107232457.4059785-11-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0001.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW4PR12MB7143:EE_
X-MS-Office365-Filtering-Correlation-Id: 007d12d4-6b62-445c-17b7-08dd0332988d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUlRU0cxRmRTb00wTTdid0NyNFV4TW1KR1NSODJqbGdXeWwzbkJQZlNPYzJs?=
 =?utf-8?B?UWlxNUwyMnB2SlBCVVNDWjZzOXB6S3JQQ01qcG1Yb0NBNlg5a3EwMkEvVTRP?=
 =?utf-8?B?MmN2Z1hCWmVFWFNDdjRHOUNDOEZ2VG04SW1LY1RKdDk2RFc1dmRmOEtPS2hP?=
 =?utf-8?B?Vm51d3hKWXBTRmNLR3crL0JaUDJBQ0RNUkNTc3NuV1B5d1JaR3hibDlIVDNy?=
 =?utf-8?B?YXRHeVFmTjZGb01FL3Zya1JmbFJqZlhmaDZ3bTlQdllQWVZCRElKc0l6NHIv?=
 =?utf-8?B?ZTltK1U0ZitHWVIxemlLc3ZPOWk2MlkyOEdGcVdJVkRsNk5WY3VBdVJmOU1v?=
 =?utf-8?B?NUhPdCtoU1gzZ0RZU1lsZjZwdnJISzNXYk9IZ0RvQitRcm5mWkZVbTJkNGsx?=
 =?utf-8?B?YldidmpadG4yOHZnMlVRcFBUS1hQMEhYRHlzeFBxU0RlTEtnYU5oOUg4eTNa?=
 =?utf-8?B?bG10bjVPZXpGQnVxc1NRK0RPWGhaWE1rblkrQzRFNzdVd2g3RGlrVS9yR2pw?=
 =?utf-8?B?YWJuMm1qd3A1L0FFcUZ0VnlPQkcrRGZvSDYvZGhhNm5mZjV6TkFXc3g2aXh3?=
 =?utf-8?B?OU9Tdkd6ZkRUUXVGWUJCYitmaFQyQVJTTVErRjEwNHVHN3Q2WmZ4TDhtUkxN?=
 =?utf-8?B?dWM1VDBPVFFUa0x3ZW9QYmNlVlVFM25VRlJuQ0YxWWYwSnRhbFVLYkgvVTZC?=
 =?utf-8?B?RnhaRnYwSHcrd1R5OVFJUWRmVGZZdytQdTc1K2VXZkNXaHBCVW9iWXRSRk4x?=
 =?utf-8?B?QkdaY2NPdUdVbzNQY0lvZkRlL2tueWJZNzhPUjRlR1lOWUZrTnZZdVZsTW5j?=
 =?utf-8?B?cS9xYmdwbmcvSmgwUGFVaVQxQWlXZVFvU0ZvUDJOdFBzNkdCWFZTYzdQQWY5?=
 =?utf-8?B?NDJzWXBMRmNaclEyelRKbEpIQXRGcTNrQzJuUHBIZGMwTWFHSzBMakIzRWFJ?=
 =?utf-8?B?cUsxMEk1Z21SUHBodGdkQTZuSUExVDRUNHpUdEpraWc1VDgyTGFrZWdiWllX?=
 =?utf-8?B?K05ibFVqQ1ZUQkh3R2FsWkd5YkxTMC81dndDbkoyN1ptUlJlamRTUDB5bGZa?=
 =?utf-8?B?Q3QxNDZvNS9CbDllSEhpcGd2cStrNll6WVI1MkZLdHJPZENtOW5NRUtiVStM?=
 =?utf-8?B?Nks3M0pKL1NiTURzb2Zld0FzaTRFTVZIOTB2SGlUZ0h0TjgyZi9KbzJNKzgr?=
 =?utf-8?B?THVjMUVQWDlhWjRKZnNPTFdTMXBJN25BMGxHSVVXY3h3ZStHOVpTYzhKdHJn?=
 =?utf-8?B?V00rWVBFWjMxNUhYSEg3MkQ1ZEZNUVJpYUxCRTVBcC9aRGxiU0cxZFp0NFYr?=
 =?utf-8?B?eTdoUEdCYWpzQ0d0TUhFVGJMWGFsalNuZFYva2VFK2MrRGZBU0dhSnlnOTl2?=
 =?utf-8?B?Y0lUUlV1VjdkQzdXTmU0ZFlwa1hhcGVGWndyQjk1Q3ZMaUwweXQzOG5oM21x?=
 =?utf-8?B?OFpocklDNkdUNVhOSnJISi92Ym5VcllLQ1lHaTBIOWdZRENFbFFMeUxGV2I5?=
 =?utf-8?B?d3hkb1hTZGhMUjljWHlEaStYVEV6RGE2dGRua1I5U3J6QnQrcG5lZGtSd0VL?=
 =?utf-8?B?NjhicnJGajRsQVFGaXpMQlB6RmppbjMwbi8zS1RwcmozZkY1NFBHd2ZsQzJM?=
 =?utf-8?B?eUhIRkp4YXN4MFlVYkc5NzQ5Y1dMcTRPWVVsR0RtMjh1MDRZSlJiaWVVTTl5?=
 =?utf-8?B?cnc2MWJhd0dvT3cvVzNETG9NVllUd1ZENWU4WnRneWdXZ1lSY2hhOWNVaDla?=
 =?utf-8?B?SXpaaDNDMnJwSDBxL1ZTUk1nMlVRWldVNSt0M0kxU3FUNEN0RjRaU05qcC9O?=
 =?utf-8?Q?iY5nEx5U0m08x77r6kBHPvbnqa4SJUSJjRYgc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3VUUDJXZUVxRExIQ3MySVB2dnk1MXNCWmxkaTNDVGh3MEpmSjIzOG1sN2xt?=
 =?utf-8?B?QkhxOHFRMmpzM3Ard0RnOXpTaEhMN2ZEc3NqZ09uSEE4R3lUWlR3azJhSURF?=
 =?utf-8?B?NVNLbHZZWnZMZUhaMU1BbXMwUmRMdlZFNUNKZ1R5TEpiR0gzOUo3eVI1SFhD?=
 =?utf-8?B?aTd1VHN2NFpXa0VXdXlsUERoZDlPc3QwSTZzTXkwOUdhbUhPRk1admQwb3dm?=
 =?utf-8?B?ZUozbHlEODhJRm1qditGeEFXaEZBbWxZSjNYcWVmZllyWXgvN3liWkJGOWpn?=
 =?utf-8?B?REdrbGpEa1hHU3VXSEkxN241OWpTRnptYStjeVUzeXc1bDlVdWxWRjFvVTBR?=
 =?utf-8?B?TnQ5eURoVTNMSmY1cGN4bEpENzdYVTQvdUowNE51M2FGTkdFVmdMQjJVL1Ny?=
 =?utf-8?B?NW5ETmlOTFVBcG5kdHlDZkMvSVhqNEJsTHJEN3V4ajBremhoRzhnRmhaV0Fs?=
 =?utf-8?B?MUM2YXJDakJuN25uMFZGa1RBRWlKN2w0VnhEdGVmOEtJeG9SS3hWaTlTZjlO?=
 =?utf-8?B?TDNPZ1hJMjlQbWNFZEpNK3U5b0U2S3I3UWlnTlBTMko4bmJYSGF1L01GQlJK?=
 =?utf-8?B?QitrVGxTZE5TeDRKYnAzejRMelZjbEZEdlBEZnNtcmtjL1MvOGYrMzg1RTVC?=
 =?utf-8?B?dnQzMHBQdEpHSm41T0RKbkdtdGdULytNUDlQZTFoRGQ2bUhpVDNkc2xvcFBY?=
 =?utf-8?B?eGVFaDhnTGlhU3R6cVNadkx3MzF6dUhZcVRueldiWHA5Vko0MVZTbTJFV3M5?=
 =?utf-8?B?UUp5Z0FkU1pLTDB3N1ZwTWtmMzBDbWxocGViNU4yQzlpa0NESzYwWFVST2FE?=
 =?utf-8?B?OTNHWCtqMTE0c2tCbVFWYXZManpCaWs2SFFYMVh3Y2V3a0xpMzZndWpJRWNs?=
 =?utf-8?B?UzVSaUZYUGdYNGgrd2lkYmVLU2N1Z0pLaHhORy9mRW5DOFM2REZUN1kyQ2Fn?=
 =?utf-8?B?SVhQUVZlU3JsclpXZ1FqSWRabWNzejVjMzJ0R2VHSnBBbkFpN0t3c0FKUHFB?=
 =?utf-8?B?V3lrdUgxL0FKNGUvQTBLcGlJLy81UkFyVTFNZ3VqVVR2MnQ1K20xS1pkTXYw?=
 =?utf-8?B?b3lTbk1taTc5SzcxVFMxQ293b0x6aWs5WWdnTUNHbW85NmE3emxyRC8xUWxi?=
 =?utf-8?B?eDE4Z1RDaloxbUZNSVRoR3BLNEtVQ0VsZXlpcVI1NmMrLzYvUnUyeE1acC9h?=
 =?utf-8?B?dVhUbXlWcjlNeXhxVG9EVWMySEdBckNKYmZucDg0cnh3UW0weDk4U0lBdUxr?=
 =?utf-8?B?SElueTZOaEsrRjluRVpnbEV2b2h6cXJ5QXduYVg2aExxOVBMeVJyMnRwRnBx?=
 =?utf-8?B?SzRTaW1Md0NJU3RBOC9TSm1oK1d1dTlYSWg3SE1QZlJXczgwSUlzYk9SYzkz?=
 =?utf-8?B?SU1WTmpFTFl1VWVDcTFYSk13QlRUend4eTFmNVp3RENvNmp2WW5maUNlY1pB?=
 =?utf-8?B?OGpNVnhyYkR4VnU2UWpvWHNnTjJiWnR1ZTlzVTNCQ3E3REp3eXd2cDJ2QWM1?=
 =?utf-8?B?QVZUcitEZ2VibEdUMkdXMUVpYXh4RnNRTWRzQjZTRXQ2bzZmN3FTT1BMUFNS?=
 =?utf-8?B?c0NCaG1GOGVpN0xRdzFvczRHdTNKMUlnSVNVR25zY1UrenE5UTRPVS9TUWQ4?=
 =?utf-8?B?N1BFYk50Y2lDQlN6SUJpTWY3bXlSdUlyRlBNYVhNT1RNNVpoUG02NlFLazB6?=
 =?utf-8?B?Tks3Vkltd25odVAxSzNTTitid2pEMTlxUFVqWGZvcGdKSld1aU50eEh1UmZq?=
 =?utf-8?B?YjZ3c0I3VGhYWHVNQkVic2l2UFo3WjlsWkw4aGkxSHB2eUIwRGY2RTlqbklC?=
 =?utf-8?B?OWEyNFQ0UWxzbFFWdUg4RWlWWHB2R1BFZVlSb0JEL2g2Tm95UzkxWmJ2M0tJ?=
 =?utf-8?B?MElxU1RJUlFrbUpka2tka0NDcVcxdFQwQzdENjNkcXU5YSsyTSt4NFZnd1I0?=
 =?utf-8?B?RFdLRHRFa3d3bHorTVI2bUZEVWJhZHZabTFERWJubkhqNmQ3UmlsZEFHL3pK?=
 =?utf-8?B?WWRwRVRuZGsyZDFaTVVzeWlSb3loZzg0dzIxdTJTZi9wbWZsTVN1RE53dVRz?=
 =?utf-8?B?ZGVITEJuNmwvQTVLVlFNeXlVRnhIa1J5ZE9JRmZFUnA5MzJvYnlCUmlJaVEv?=
 =?utf-8?Q?cnChcUVwdijQNyberh3imMJ9u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 007d12d4-6b62-445c-17b7-08dd0332988d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 15:56:40.1401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOWj9gfHMX1s0G+EbnqykQve5VOkI0yPIo1NKgNTkoGv9twg6+iDnyVZh8sUpRI7dL5fRdpSTg7MHpad0xFYoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7143

On 11/7/24 17:24, Dionna Glaze wrote:
> When no SEV or SEV-ES guests are active, then the firmware can be
> updated while (SEV-SNP) VM guests are active.
> 
> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Luis Chamberlain <mcgrof@kernel.org>
> CC: Russ Weight <russ.weight@linux.dev>
> CC: Danilo Krummrich <dakr@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "Rafael J. Wysocki" <rafael@kernel.org>
> CC: Tianfei zhang <tianfei.zhang@intel.com>
> CC: Alexey Kardashevskiy <aik@amd.com>
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d7cef84750b33..0d57a0a6b30fc 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -444,7 +444,11 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	if (ret)
>  		goto e_no_asid;
>  
> -	init_args.probe = false;
> +	/*
> +	 * Probe will skip SEV/SEV-ES platform initialization in order for

s/Probe/Setting probe/
s/in order/for an SEV-SNP guest in order/

> +	 * SNP firmware hotloading to be available when SEV-SNP VMs are running.

s/when/when only/

Thanks,
Tom

> +	 */
> +	init_args.probe = vm_type != KVM_X86_SEV_VM && vm_type != KVM_X86_SEV_ES_VM;
>  	ret = sev_platform_init(&init_args);
>  	if (ret)
>  		goto e_free;

