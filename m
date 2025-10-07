Return-Path: <kvm+bounces-59572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C260BBC17FD
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 15:32:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 091CD19A30D3
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 13:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CBE2E091B;
	Tue,  7 Oct 2025 13:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cZSc93OY"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013058.outbound.protection.outlook.com [40.93.196.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56192DF156
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 13:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759843920; cv=fail; b=LZZ/kJmu8FF2GXZ42oB5Eysoi/2F2vKINY70ei1ds2lld/LCLRJoO87ymOeMnvfEcOFuKE/Jk4XTqY+GCGvPiWt+bP52jU+KKBUtdlaJku1FnJlV1US0U/LyJfdYrW+kag8xYbesZ2D4cQltPcK47NAlQPRbTtR1+ZJdNItZ2WM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759843920; c=relaxed/simple;
	bh=b5q83wsHgggd7ja6kmXp6vjycOy38ODP3Zdat7sbl8U=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=js3qRBbBSfIeXgibx8VwqbS0c0TRBRAvT4lYAvV0oK2xQgi6FoCgAVxsPkI1PrA6VR08WwTGDodKZuHx526lCv1T/VLYhRzlWeHtUTPR4dL747o93oZqRh0WH3GZsx2fywB+5TEi6C74XvTB1oP9Y26oZrMQBgDVE4pQoMoxfnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cZSc93OY; arc=fail smtp.client-ip=40.93.196.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6oykIU+4SgHNmAvtdV3SULFLsvydxIkpBoeC5EorQWOJlBa/H9DbG4vZu9HmGca4EheAcUPp4KhyzQTE5N803cb4USHUMPXifmBecXfrJpX9jAMug7GuwOUu1WFKatqjYpsO6XSm3tOOV5Ms08LByuqZGDBRon5eMmQzk/R3i3cAWzmwUbCk+zYVcFxe3MVUuPVUDr36i5LcGCJ3uB89eqWvus4BYcZRkrucwQrLAnW0jfMHoXucizuUfV12+j7uWgc7WFFDck3h5kdmWl+H8SDeNQdWfVUnA3cw7RKhU0RN2BNs+H8WSRr2/aL0GlNKoZeNk/lqGTSMBQf5IKDiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6Z+nBlUjFA0ET6PKuo88pyKAg6K9gZroNFrWh2HDis=;
 b=dSK6ejPn7aQ2OMANx3lol2wTMLaKYleF2RVVJ3DdQGralNHHN+iDjm8RzZIsz/6i46kdkACLiU1sHUZ3dVDYOP/a54v+/XEXBnMGL1Z7bYH2U3QRWqPw2IeJ0BoLXWINKiBHRo4+LeL/81Ypv5+AL17KNj77RIml3pJtho+1D1uIdQBEKtqcE7bFNoANXaC+puGnb28xMsTqrplbecRbAlOHzUQfLlo2b/8nLZ/r8sY8zx8YZmrm/cgUNSTj1YggOwuvuF6OutgdkV8vGPT342AiEhpiX37EPiTNpL+qfbk/k2AgHvh2iacBDiUJcqz300bTj0D8OqQJqreH1zXbzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6Z+nBlUjFA0ET6PKuo88pyKAg6K9gZroNFrWh2HDis=;
 b=cZSc93OYZomDpBVSzSzUOjCvZ9qWd1E69ishaf6Ijqh09KI1hqnoiaUVkacQkTmWC2KyhLKanaTZEL9L8ggl+AcVo2ZgY0n7Fhh1Kz1q2mCwaWFuAwLsVUBJP1fwoucSwVrNoA9LUVFT7E+xK6TJ6SQLn/fU6VAxm65LfnB2XKA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS4PR12MB9635.namprd12.prod.outlook.com (2603:10b6:8:281::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.18; Tue, 7 Oct
 2025 13:31:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 13:31:49 +0000
Message-ID: <6a9ce7bb-5c69-ad8b-8bfd-638122619c71@amd.com>
Date: Tue, 7 Oct 2025 08:31:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 Nikunj A Dadhania <nikunj@amd.com>, "Daniel P. Berrange"
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758794556.git.naveen@kernel.org>
 <65400881e426aa0e412eb431099626dceb145ddd.1758794556.git.naveen@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 8/9] target/i386: SEV: Add support for setting TSC
 frequency for Secure TSC
In-Reply-To: <65400881e426aa0e412eb431099626dceb145ddd.1758794556.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0041.namprd13.prod.outlook.com
 (2603:10b6:806:22::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS4PR12MB9635:EE_
X-MS-Office365-Filtering-Correlation-Id: 749803c5-4f8c-40fd-0678-08de05a5de75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RC93a0l3N0pFTDAxQkQyZlpzdElUdjRaOTR1cHFUcGh3ay84TjY1Ty9RNWlm?=
 =?utf-8?B?Q2hUZU9nOXNyNmNUK3ZJUTRmdktyakVPRVRwV3JzcDA0ZmNTRDdscVRjTm81?=
 =?utf-8?B?MjYvb005S0dRaWJObWt4UDhmSUJYOG9aanBta1dyTklScW5oV2Z1cVlDUEpw?=
 =?utf-8?B?Ly9HUHBTeTJ6OXFrK0tLNk9CQ2J0Uit2d1puZ3VlNnhOaFFUYk5MRUZnWExp?=
 =?utf-8?B?RDRqZjAvUlZKOXBteFhqc0ZvazFUQ29WWTdXQUhDM0ZlMlZ5VTNYMTZNem9T?=
 =?utf-8?B?NmFlS2kxSUZrM1l5WkFFd3VGVkVidDFITE9VRUloSm9ZdGI5VzdDQXo4NDBz?=
 =?utf-8?B?NUFuWHNTZmhpZUFxZHZXZkIxSFJkQ3RtU3NvZk9TbFpVS2NsZFlGSW1sbDZw?=
 =?utf-8?B?c1dSQitGNXE5M0pScVdFYkZPMmlXQjV1aW53eTdac2tKLzYzTGszMlNlT21i?=
 =?utf-8?B?T1F0NzJvZlRpOUxhQ2JGRE5sQnBiR2RYVkhHY2tZOFZabTkxUnBjVzduMEYr?=
 =?utf-8?B?cEZicTVkTVFwQWFFUnBVUzRuV1lEYUtRc296bWQ1RVl6NUtxS2plWEtURU8v?=
 =?utf-8?B?ZCs0eXBUZlBZMWJ6SGxibnhDYm1YWGFjblVhc3lNZkNiRmMrZ1lvU3hWazJW?=
 =?utf-8?B?Tm1BWHFBQUxRZ3BheFZ4WkxmOHJMVExNWTlTWThzNHJkN05pdjlBUU5hUkZ6?=
 =?utf-8?B?U3pEZHdRaGRCU0ZOK1Z2UzhPU2JaREpyQjlONXVxbHJ1Y1VjS1Z4Y01ERmU3?=
 =?utf-8?B?SmxVTzBkTEVuMzkwdWZVV1JvZzI5Z1RnTlljcDhTNkhoaWw1MWV4VHY2TzB3?=
 =?utf-8?B?U0NoQTlMMWtvZTRZcUhSY3BGWElsb0Rwb1FGd3pMMzhITm13ZjY5UEFKeWJa?=
 =?utf-8?B?RmhuVjhidFZud0ZFcG83YWk5M3hSUnJNc0J1blVnZ21seThIakxHbmR5UGoy?=
 =?utf-8?B?UDZxUXIyUjdKSzFDeVdPb2c1a0dwZ3hLTGVNanJNcXRFV1JtL2FNTWg5bDlG?=
 =?utf-8?B?NVlpQTdWa25iWUQ0N0NXT2FUS1ZBZEVGdXdHeDZTT2U1WExYNmt5eTk4elAv?=
 =?utf-8?B?TzkxNnhVVlNEVFNNSkdYZUI5dlZkMGgxMkhBVE5RTUd5YVc1R0N0YURVSEtz?=
 =?utf-8?B?UmtuRlN4VnU2Q1czRVZkb05oNS9Sd2FCenQzUWRIemlqWmhqNHNFcVNJbTBi?=
 =?utf-8?B?SVZTQlAyUVZNeitabWMyNFhlZFMvcUFkc2NwOWNtVHdMcTN3cVVNc2IwT1pE?=
 =?utf-8?B?d0M1YjZycjNmNTFUWlYyYTdLQjhVN0xMcDg3T2JiRWVFSWxYdFk2Q2REUVFq?=
 =?utf-8?B?bWQvY2UzRjU1bFk0ZFI1ZEY2R0JUQnpSR1c2VGh4OTZudGg4VG4wR0FMWStL?=
 =?utf-8?B?a0tPdGhBbHgyNGNEb3pvRms4L3QvK2R0ZlpNS0EwdjQzSnphRllnWVQyNTlT?=
 =?utf-8?B?WXdZTjF0OTVxcUV3ZkRuUlVrV2dtRXpuZ0l6VklyVmxxa0tCMEZZcWcvWTdW?=
 =?utf-8?B?Q1RpdWwyZnhYcEptbUxuY3V1eGRhU1FZYmhzdytEeVExOVBuQ3k2N1AyNjhO?=
 =?utf-8?B?dENscmlaN05TSTRFbytlcSt2OWpHS25KeTVhTVZnbHBCWmgwYUR4SlpRYkVO?=
 =?utf-8?B?QlZ2SEZXVEo2QTlRL1J6N1UyYWN2T3dyN3dGbXFxSy9lZG5GMEovTy91UjBE?=
 =?utf-8?B?eWtxK2lhckF1ZkJGZHEyeWNPUHY2QzNQMG9Tc3Z0S3V1WDI5ZDJXZVBsSmVY?=
 =?utf-8?B?eWdISG94SXo5RXJYRnZzQ3llS2ZZVDRQQnY5b09ZcTVWbnFUZXF3K05veDh0?=
 =?utf-8?B?Qm1nUW9ta3E3VE9yNzBITmNIRGllUnh0enIrTkJVNVJmb0VMOGJvdCtkU1NR?=
 =?utf-8?B?WGUvOTBSYkVpL3B0bjNjYlpnL3h0c2hybk1saGx2eXRsem5xdWJYRkNTenBE?=
 =?utf-8?Q?f+nT7oldupKPd7bJlwoyLYf4BmVWZ1GC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RE94ZHZlZlpsUGphK0xQUURNQzU4dllZT1NTc2ZZZ2lBVFZCakJDNFBCMkVM?=
 =?utf-8?B?UEVSZFlNZFRyMmRxTVBvczFmNlJ2LzRwQWJYWDZyemtoZEQ1Qkc3Vm1WTU5o?=
 =?utf-8?B?UXZUZ2FQdGxMbUxiRGFIMzZVNTZialZxWVZmdlR2VVVUVGRFT3BkbHhPMjhQ?=
 =?utf-8?B?MGV6RG0xNmhIbXV6N3JSbkhHeVJEL2drT0M0TVRsY3Y4RGo2ZFFjM0ZLMjVp?=
 =?utf-8?B?MW8zT2c2TGJ5ZGErWWdtc2ZyR0NuKytRZWQ5RnRXcG1CTThmQ0RwcnZScG94?=
 =?utf-8?B?RmRyeVhPa1JoNUFnWGtXQW9MM2xNMFhTKzMzb0ZKOGJQd3BNaE1GVDRWNE5p?=
 =?utf-8?B?bjVwRWlOU05QbUJ3b2RVTEI0RDdWdVZaNUFXcEJSazZRZXRsT25xWFV3WDdJ?=
 =?utf-8?B?MXBYWjNOUG5KYjBGSzBkTEFzMURycHNPcVF6bndtd1ZDeFVHeUI0MlFmbHRk?=
 =?utf-8?B?UnVoVVhqRG0yZ0NER09TTlNtR0w2Z09CWU5aN1lPL2JiZG1MY2tGdXhHNlJL?=
 =?utf-8?B?TUhXQkE3ZzFKQ0hTbzQ1NjJFZmVnWGZGUDFMMkxwK2ZWbWZaRXBlUm9YOUZk?=
 =?utf-8?B?RndSbU9pTk9ZaG5wUC9GME9yMExISDRrcHVYVVNuTExmem1LSHhGb0tlS29R?=
 =?utf-8?B?OWNDcnRQRk80QmpHeTdqS0NHTnJLd294UHVpc2pTNFY3MWpneHlXcEV6NktD?=
 =?utf-8?B?c0pQM2p2UVpESFlBZFZZTkVLbmJUbllIOEs0VGVnRFFuNkt0YUkzTlpuZGZN?=
 =?utf-8?B?bmc4c1BuN09XT0NKclpYN1NDcjJ6Y3JVR3FEb0tRSndnT2hrMGxZMG9DLzVK?=
 =?utf-8?B?Tkxsb0ZCbjZEYmNBNm1sWWlnZlFzOUM5ZC9hMG5OOVp3OGxWaS91OU1KSndy?=
 =?utf-8?B?RGVnZGFSenp5WmR3aEN4YWNaNGwrclhxMm55dTNlRm9pTEJQQ0NTeDcwQXdu?=
 =?utf-8?B?RFM5VFUyNTA1UzUxV1R3MU5VV0pwMTZmRTFqMnVVdlROczVqL3o1a2lJekRo?=
 =?utf-8?B?Z3A4WUNmd01kYWFma2UrT1RuMXZuVzNMTldUZUh1UVVVOVVaZ0FBajg2OW9k?=
 =?utf-8?B?QzdxR01UOGxZZktWdm9pSGNwRVY2STdDaE4xWUFpalhLMllYSk5RWWZRaTJP?=
 =?utf-8?B?Y1JqSjZMd0ZWN2xHanBiaUpNRmxVVGhHWEIxOTFFT1VjSTFLaE1GN01qK29V?=
 =?utf-8?B?NWsxL2ZFemkyRlExUldWNXIxN0JvYTdDU2NPMDBFa3crU0gvQlRoVHpWNEhv?=
 =?utf-8?B?NElRVUdHNkN1QmpSNDdaaXZPc1M5V3UzWXNSQmJybTZhNjJ5ekUvQ2toOEpX?=
 =?utf-8?B?UlNiNTFlT0lINGtNNU1HQW1HTGVmR2R5cHVicGJOUCtuWS81RDhoWlR3eHQz?=
 =?utf-8?B?Z1h1Qk1XczYwUmgyL0NiQlFRZ0Z2Ty9VbmRsRFhpT0U5bVBzZExHOExmR3VZ?=
 =?utf-8?B?M2hOU2NYZmRLWkRreU00cy94NDRkUkNCSHdRckgxTjk5aUNNWDZrQldyMHYy?=
 =?utf-8?B?K1gwSm1TaWVzZTVmRW5MWVcrTDhhN2doQVRFb0l3MlQ1Vit0QlNjLzdmaS8x?=
 =?utf-8?B?dzBjdmtpVjZRTStPNzB2ODZqWGZIbW45Ry9Ca3BPYjNPNmlRRjd6M3dkbmpB?=
 =?utf-8?B?OW9KOEgxMkpwRGJ1b2JLclpNTnR5d1BrNzdSbHdxSFVnWnVWRU5yc3czdDdz?=
 =?utf-8?B?TkpHMUxremhFbXUrZWVCRGlWWkRSSHVtRm1DWGN3VE1YVDV5Tlo5ZFlHMGxE?=
 =?utf-8?B?Y1h1b3diNFpGWldHNXVGT2I2cGdRLzFFcm5PU1p3TWgvd1FqTjRsM2RybVFY?=
 =?utf-8?B?UkMyQTVhS0QzQ0VGamc4a2VCWERaUjk0VS9TVjhyTE9Bc1BQdDEvT0MrTm0w?=
 =?utf-8?B?d0RXcUdhNnZ6QjNQdjQ5bEc1MXlOUmVaeTFzdHBSMTdWR1JlNi9LV01WU3lM?=
 =?utf-8?B?RHNNMDkyNlovMnFiZ2kxOFcyd3BJeFpPeUhSRTE1SlcrdWltVGNmM1Y0TVUv?=
 =?utf-8?B?ZTVoRXhRN3p2bU8yMkVXZ1EvVlV6Y3N1Q0NlaGZDVjRlWVBGQ2JFWWtYcUNT?=
 =?utf-8?B?NVo5bjJGdDZQTTZzZC9OazU2dEhWYUpOWG9Velc3WUc4aytqZFhvSmZWSXFL?=
 =?utf-8?Q?ZktObRzeuQju7nskix+lWkM0b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 749803c5-4f8c-40fd-0678-08de05a5de75
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 13:31:49.4792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SK2V8eW7jm2m6Z955VwzO6vdobDMqFgwXIkrLoEnqtkMRfq40XKhCbDQrQ6uI1mKI6q/bL8L4yjFmqxNmurSYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9635

On 9/25/25 05:17, Naveen N Rao (AMD) wrote:
> Add support for configuring the TSC frequency when Secure TSC is enabled
> in SEV-SNP guests through a new "tsc-frequency" property on SEV-SNP
> guest objects, similar to the vCPU-specific property used by regular
> guests and TDX. A new property is needed since SEV-SNP guests require
> the TSC frequency to be specified during early SNP_LAUNCH_START command
> before any vCPUs are created.
> 
> The user-provided TSC frequency is set through KVM_SET_TSC_KHZ before
> issuing KVM_SEV_SNP_LAUNCH_START.
> 
> Sample command-line:
>   -machine q35,confidential-guest-support=sev0 \
>   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,tsc-frequency=2500000000
> 
> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  target/i386/sev.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  qapi/qom.json     |  6 +++++-
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 68d193402de3..8bb9faaa7779 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -178,6 +178,7 @@ struct SevSnpGuestState {
>      char *id_auth_base64;
>      uint8_t *id_auth;
>      char *host_data;
> +    uint32_t tsc_khz;
>  
>      struct kvm_sev_snp_launch_start kvm_start_conf;
>      struct kvm_sev_snp_launch_finish kvm_finish_conf;
> @@ -536,6 +537,13 @@ static int check_sev_features(SevCommonState *sev_common, uint64_t sev_features,
>                     __func__, sev_features, sev_common->supported_sev_features);
>          return -1;
>      }
> +    if (sev_snp_enabled() && SEV_SNP_GUEST(sev_common)->tsc_khz &&
> +        !(sev_features & SVM_SEV_FEAT_SECURE_TSC)) {
> +        error_setg(errp,
> +                   "%s: TSC frequency can only be set if Secure TSC is enabled",
> +                   __func__);
> +        return -1;
> +    }
>      return 0;
>  }
>  
> @@ -1085,6 +1093,19 @@ sev_snp_launch_start(SevCommonState *sev_common)
>              return 1;
>      }
>  
> +    if (is_sev_feature_set(sev_common, SVM_SEV_FEAT_SECURE_TSC) &&
> +        sev_snp_guest->tsc_khz) {
> +        rc = -EINVAL;
> +        if (kvm_check_extension(kvm_state, KVM_CAP_VM_TSC_CONTROL)) {
> +            rc = kvm_vm_ioctl(kvm_state, KVM_SET_TSC_KHZ, sev_snp_guest->tsc_khz);
> +        }
> +        if (rc < 0) {
> +            error_report("%s: Unable to set Secure TSC frequency to %u kHz ret=%d",
> +                         __func__, sev_snp_guest->tsc_khz, rc);
> +            return 1;
> +        }
> +    }
> +
>      rc = sev_ioctl(sev_common->sev_fd, KVM_SEV_SNP_LAUNCH_START,
>                     start, &fw_error);
>      if (rc < 0) {
> @@ -3131,6 +3152,28 @@ static void sev_snp_guest_set_secure_tsc(Object *obj, bool value, Error **errp)
>      sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC, value);
>  }
>  
> +static void
> +sev_snp_guest_get_tsc_frequency(Object *obj, Visitor *v, const char *name,
> +                                void *opaque, Error **errp)
> +{
> +    uint32_t value = SEV_SNP_GUEST(obj)->tsc_khz * 1000;
> +
> +    visit_type_uint32(v, name, &value, errp);
> +}
> +
> +static void
> +sev_snp_guest_set_tsc_frequency(Object *obj, Visitor *v, const char *name,
> +                                void *opaque, Error **errp)
> +{
> +    uint32_t value;
> +
> +    if (!visit_type_uint32(v, name, &value, errp)) {
> +        return;
> +    }
> +
> +    SEV_SNP_GUEST(obj)->tsc_khz = value / 1000;

This will cause a value that isn't evenly divisible by 1000 to be
rounded down, e.g.: tsc-frequency=2500000999. Should this name instead
just be tsc-khz or secure-tsc-khz (to show it is truly associated with
Secure TSC)?

Also, I think there is already a "tsc-freq" parameter for the -cpu
parameter (?), should there be some kind of error message if both of
these are set? Or a warning saying it is being ignored? Or ...?

Thanks,
Tom

> +}
> +
>  static void
>  sev_snp_guest_class_init(ObjectClass *oc, const void *data)
>  {
> @@ -3169,6 +3212,9 @@ sev_snp_guest_class_init(ObjectClass *oc, const void *data)
>      object_class_property_add_bool(oc, "secure-tsc",
>                                    sev_snp_guest_get_secure_tsc,
>                                    sev_snp_guest_set_secure_tsc);
> +    object_class_property_add(oc, "tsc-frequency", "uint32",
> +                              sev_snp_guest_get_tsc_frequency,
> +                              sev_snp_guest_set_tsc_frequency, NULL, NULL);
>  }
>  
>  static void
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 52c23e85e349..c01ae70dd43d 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1103,6 +1103,9 @@
>  # @secure-tsc: enable Secure TSC
>  #     (default: false) (since 10.2)
>  #
> +# @tsc-frequency: set secure TSC frequency.  Only valid if Secure TSC
> +#     is enabled (default: zero) (since 10.2)
> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevSnpGuestProperties',
> @@ -1115,7 +1118,8 @@
>              '*author-key-enabled': 'bool',
>              '*host-data': 'str',
>              '*vcek-disabled': 'bool',
> -            '*secure-tsc': 'bool' } }
> +            '*secure-tsc': 'bool',
> +            '*tsc-frequency': 'uint32' } }
>  
>  ##
>  # @TdxGuestProperties:

