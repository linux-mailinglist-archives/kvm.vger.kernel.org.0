Return-Path: <kvm+bounces-44289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 537D9A9C4FF
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEB251BC182D
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE71239090;
	Fri, 25 Apr 2025 10:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zWX32rQV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417102367A1
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 10:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745576110; cv=fail; b=YpCZzwiX1oduMSucHI+YBKopaS2CdYos50r2Dfl/t0GnvAwNM/UOxwDitr8XhckK3rkdBq741v6dXjPA35rODhU1TZRi/0wiZFcIDD0ndQtO7R2poB7HywdNnBJKfbXC1RvpsYulMMELZs8W7reRRWXEPLxVBILE1QQNt/J1lgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745576110; c=relaxed/simple;
	bh=uWtP1419Nz8r+LovL21pY/3CJ4zYsx9F/jpCBBT3Z8w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y51uB4U6g9Qe9mjkrXHxMc11IDvAFhc+NveEg/mL06Z5L6JhQ0o7qzkr+0/qy2OX2Cx9dDDSyc2PSl44ykhY1WXKP+Lz5SDy1HlFqhVvSGjXqU1kH+FUikPSApc6cBI1i/6hXqpXrbI2w3xc+BTSOZlPW0fXeyhEjY6f+kNr6GM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zWX32rQV; arc=fail smtp.client-ip=40.107.244.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VvbRGTw1eLQulrLmEZRgYUw2+EjoNQgBQE0cLPIFbeb8syrHb8SBxECm+/wleu19JopyFnKjK85NZpQDptShonxYtPh9/f8QlkNr/GMXRmLgOifW4mfaX5oVVRvbadnBO37UJTmAj/PvO/JsG/gc+W5QNLt/Nd1xYX/M2B/0T88NI45SXjyOlHGfdnpg/gGtGIrDN+mn3IcSkX0v7U3o4yD1+urw44ByjBvOLzUuREyMuBpSQXC3kvqE0yXAJaLvMWRE0vOFRVnw19GqhUtRD5rzTr2IpgLokvepjZJJsqGnE9ijhYnpMFNKJzcMY5wDNbU0vHigrTG7GQm/TeoutQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UX2FNs5luK3UOi8SSpbtwZ5wYmm3RcOR+q+r1rPpaKg=;
 b=BYhT+pLecz78jghdvkaFq9zdB4E/5QRhMDuj7P2Q4LcJlK2eL+2A+F23mF6X3WjIr7OdvbVC1CXrRZVTOPUglAr+0/ZKANGdTGKsEGgIbbJzwK8aZgH8cOTxPnWXS6k7gk/ocDaR80s+9i3hfXWnIhP9bMxf5KxtHvt/pxzufqEdLHkmj0bvbebpNnbrtVhIZkcwjPhYqeQW3WG9PZa57CGzfJ2VCzT9Z3YPUxts5s6J/67EKHy60PCUKuDeo27c0mMrNuf6E1xtvP7cA6HhFP0YLAuxmqbB1/jskuoG2aPPyELUm5DmMiKyeguTx7AKI7fRhRpEV1IQ7kwL47Ap+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UX2FNs5luK3UOi8SSpbtwZ5wYmm3RcOR+q+r1rPpaKg=;
 b=zWX32rQVlXcJc+n/tqYH6mGXdc44eOaa5ri34Muat9dJIfXWMnw0wIc/KFjrRchiGtbW/vqfB8KWBYBWwU5MIfVAnttxhCGA+bSmD1Xk2Hk04LVgD2JzWQV/+Q348I+tLa1YxmGqYX1fjua1DjK9FjYF0Uz8zJQi1HbWayauCd8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by CH3PR12MB8188.namprd12.prod.outlook.com (2603:10b6:610:120::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Fri, 25 Apr
 2025 10:15:06 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 10:15:06 +0000
Message-ID: <8a723b11-76f3-46ab-b89e-54e14b8825a4@amd.com>
Date: Fri, 25 Apr 2025 15:44:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/11] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, qemu-arm@nongnu.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
 groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
 den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, peter.maydell@linaro.org,
 gaosong@loongson.cn, chenhuacai@kernel.org, philmd@linaro.org,
 aurelien@aurel32.net, jiaxun.yang@flygoat.com, arikalo@gmail.com,
 npiggin@gmail.com, danielhb413@gmail.com, palmer@dabbelt.com,
 alistair.francis@wdc.com, liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
 pasic@linux.ibm.com, borntraeger@linux.ibm.com,
 richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
 thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
 liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com,
 kraxel@redhat.com, berrange@redhat.com
References: <20250416215306.32426-1-dongli.zhang@oracle.com>
 <20250416215306.32426-10-dongli.zhang@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250416215306.32426-10-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0122.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::8) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|CH3PR12MB8188:EE_
X-MS-Office365-Filtering-Correlation-Id: fc8ecd18-ecaa-4ac4-66fd-08dd83e20cc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTFZeVZHLzJidWVhS2kxcnBkV2xrVG1WYmdSNEZSK3hNS2w1bkY1Qzl5cnhh?=
 =?utf-8?B?OWxjaXdWZkdXOVYzRkJmYnZodWdocFhoM2NPOWFyN1pKK1FoZElTWE1VbVkx?=
 =?utf-8?B?QzhwSWhqbFo1djZQQmVydFZDa2N2dkhGdzdXY3ZEYXJicEhZOFk1NmoyTlFx?=
 =?utf-8?B?MFVlbGNNTkxzWUtpeWNyTFJ2YXlsL2tnWlZJdUwxL3ZvWnEzU1k4TklSc0dG?=
 =?utf-8?B?K2dpS1piQitnZHBzbGptT1ViMUQ1YkFGTEZuTjk2MVV3WlRscGQrZWRIbE5C?=
 =?utf-8?B?YytIdzFrZGtaR25OTkJDWlFibFduaEpBYWJER0lxb0w0K1Z3TkJBS001NzJI?=
 =?utf-8?B?bW5wM1cxTVJxbXFkWDNhaUcvUlI0U3FpOFVLNDc4eGU1bE9TWW9Hc1JyZXpo?=
 =?utf-8?B?UkNoTXhNTmhJMlNhZ243NVFNU0dkQWxsdW1JM3d1OXRHckhReTREUHM5WWE2?=
 =?utf-8?B?VTVqRWluVVJGR2dSVWNJdEcxd3d0WWFjc3Yyb2JQTFc1RDF1RHpzWVkzQ20v?=
 =?utf-8?B?cnlKZmJCVmhjM1RnOE43SVN2UUpBdVhqcGlmc3RKd2w0NGFhazNEeVdQNHF5?=
 =?utf-8?B?NUxySmkvUlRhMUVpS21NdExEYzIxbE96Q3RaMGFETldxaUJ1OHRnV2FXSmZ5?=
 =?utf-8?B?WkJHOUVwNFc5bXJyQ0dWK203U1RrdWlOUWsrM29LdWhkalZTUGR1ODRPTFVs?=
 =?utf-8?B?cXFPWHllbE1sRzBHaGN1Z2drRi9QTU9mNlo3dVh6K1RiNVAycU1QTGVDa2g0?=
 =?utf-8?B?clEwbmlkU2NqMTRkZWhKUE1pcXZxRFBFb3A0VzN2R1F3eUg0VTlSaGZEL1JU?=
 =?utf-8?B?NlNPdlZPVzM4OEF6WXpKK2pNeVVxTENQSTRneUZtc1daV1NROW5BekNNWDA1?=
 =?utf-8?B?SWJyY0ZLTGFoL25JYTdwZ2phVFdpYUsvdUlsbmgvRit6NjVONmh5WU0zQU43?=
 =?utf-8?B?Q0QzVTk5bnRBNWFWODF6UHBiOGxtRXArbTZLVXNDTHdvSkN6Y2ZOZ0J4eWVZ?=
 =?utf-8?B?Nnh0UWVUc1pxRVdZZ00rZmNxNHNqQUU0UHpNMkc2K1ZHY2o0SGZVbkFuaEdB?=
 =?utf-8?B?NGtmRHRSTU1rY2ZOUW9rK0taQzRuVmdyamVLZ0NVTk1OOXJPTll3NWR3QkZR?=
 =?utf-8?B?SjB5REpYRTRPNnUzYUw5YjFlMXNJckgvMzd6UU8rL0FCcFRCVzhwclQ2SnZx?=
 =?utf-8?B?SmFVNlZPMEkrM2RGMDdnZXhhQVBzOEh1TEhJU0RzeDVVaWE2Qm8wRU9vajRF?=
 =?utf-8?B?Y0plVU1TeXN4UVludEp1dHlQOEJ5ejI3Y24yN1lSN2Q4ZDlmeWlWTXNXWGRs?=
 =?utf-8?B?MTJ2Yk11SW9mSEwvTjZDM3ZHa1QwNXVKYUp6K0xIQ1N2OHBtdTRqRTN4c3ZC?=
 =?utf-8?B?MjM1ZWlDRXlLeXlpZ0ZtMTFGdFBVdk1VbEMwUTRUdHNLNkUwckxBajlnWU9l?=
 =?utf-8?B?Y0JyckVCZHVNdG1sWTJhUmhYYU1LQlhvLzM3MVJCenJEbzFtNlVHV3ErM0pT?=
 =?utf-8?B?cElWWnZSSzczaFBRUGQvYXlETTlpUzFSMXZUbUUwbmsyUWsra1N3bWs2SHA0?=
 =?utf-8?B?aFlQM3IySzJrdmRpQ1hzUW1LbVFhRThhUDNiMkRoTHFTVE91Nk9qNkFSMmds?=
 =?utf-8?B?NTF0cEdIWEQ0TGR6UVJhYzFTL21WNFp6cFZScVovR2krTXRTWXdUS2E2VGV0?=
 =?utf-8?B?RkVzazlhKzdDaU9hVTlmYVFrU3pvdUw2ZnRVU2pRMGsvMExEdlVTcTRDWmxW?=
 =?utf-8?B?N0I0Z2JtV2hzaDNPZkVTc3dORWw2YzdleGY0WUtWNVpvZVVSY2FwZ2lJbW9P?=
 =?utf-8?B?aklXWkhpc3pEN3luWHdzeWsyMUMxQTBVREVWbFFEQ0ZHVHh1bjFwQmlUTWlC?=
 =?utf-8?B?QUxSSDFqMHJTcnZPbmN3Ti9NS3NLMUcwV2xaTk5JMGErc3VscnhZWS9xdVMy?=
 =?utf-8?Q?39xqwrS3VpA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NE0xUjd4TndtMVorUW8rY1F5bDNaMUFTZWV1dnpLdFRBN2c2WXN3dmZXZVZn?=
 =?utf-8?B?b1Z1VnNybW5qWHlPUUN2OFRLZ1MyeHA5Sm0wbXZWSUpFM3BwYVBJT0RqM1Nu?=
 =?utf-8?B?cDVta2ZuaVJCWTJ6c2pNaU0vRnZ5M09tY0VrNTk3T0ZDMEpMTG0yK1FBc1lC?=
 =?utf-8?B?bVNlZG1SV3Z3MDVXbW4xanZQcEdVSXhoa1YwY1FNem1tU3VodmdWZ3hjL0pN?=
 =?utf-8?B?cVhEdUxheGFyaWQyb0tBUTdBWmRHK2FuVVlQeGx3cjhWWmxybExMaFpyZ3I0?=
 =?utf-8?B?NWxacVN2Mkd3Ni90dHZUaEJ3RlhNQTVsRGZXU1p5MkdBOGxROGJ3VUdBcXRK?=
 =?utf-8?B?OEdQWThHTWlDdjEvakZhUTNQK2w3UzBFdzF2SGRweXF5b1BwWXhidS80MHA5?=
 =?utf-8?B?V1Q1QTJiWUJQZ3FESW5RVDBkQTJ0ZlVleVlPRGhackl4LytKVTcvamhZMlZs?=
 =?utf-8?B?TEhmK0xPc1R2WGpRSWtaVFIyOUg3OHVrN1VWUGRFamFmaE5BTU94cTVleENH?=
 =?utf-8?B?VC9hZzRvMlpJMHNtbFpkcUlWTCtxYUlpc0lNU0pyU2wvU2ZUVHN2Mng5Qm95?=
 =?utf-8?B?WS83alBWQ2NHalNOZUd5Q1NTWnpGRG9PTUVYbUVDSXRzSnd3L3p2emRtRVhh?=
 =?utf-8?B?TjRLN3VlSUdjMFJvNWpXOUpDbm5YMGNETjArV0VydWs3eXJZbXVHRUh0NFNy?=
 =?utf-8?B?eFk0dVdsMmFMdzBSQkNSM1NUaDIzcU5GekU0NVp1UzNMaTZHV3psNTUwQnhJ?=
 =?utf-8?B?NEp0Q0w2Uk9aK0FiZGNLL21yZTdDSXRFZjl1SVo1M1hndUlaRUk2OWcvVjFC?=
 =?utf-8?B?NkpzVm96L0x6RWxobWhTTDBBKy90bHdOZnd1TzZLMG5GRk5GdzNxOGROQnlT?=
 =?utf-8?B?by9tdndhNFdHUW9NRTZ0YlZGUVQyNWRvelJOTE1uRjdHdVN5MEMwVi9BZHBr?=
 =?utf-8?B?K3VGVFJQSVR6dzRlN0JKelFRUG1zVzB6L2FjenVxWForZ2l5L0U0aEdQRmlE?=
 =?utf-8?B?akM3Rmxyam5QNXBhY0NxQ2ZQcG40TWtJUWg3SVpOSXpOK3RodG16c3lvdkFm?=
 =?utf-8?B?Y2dMMXZMY09neHJKUlZDTmNWTkx2QlNBclovdlVCaWxWeUdNV1pXN1BQekdI?=
 =?utf-8?B?MjBQNDJaL0phZ2oycG1hS0xDM0RWR3B6UzRqQVlaTTlKV1RadXFqQzQzSGNl?=
 =?utf-8?B?ci9nME4vcmlHYWxsVXRYN1lpOFdBczV0aTFPdGJ3OWwvdDFCQWtFZDN2SEIw?=
 =?utf-8?B?aUZiQUtobmh0Q2NSNS95eXBMVVp3TnVNOHFra1FHMWx6MXhCODlnb3lzb3Ru?=
 =?utf-8?B?TmpLWUQrWDNkTy9YVTI5YkdWMlFNMXFGRU1Uc1plMmM0TTFzVU9lK2c5R0pJ?=
 =?utf-8?B?Qk1IOHZGOFY3Z1gwdjU3ZWlPcWd2ZDN4LzJNd3pPK3dKdmFIV3hmelpZT1I5?=
 =?utf-8?B?RGRHTTMyNjVLb20xbU1qeEQ1cnBXeWxsQ1dBYXlSL1FhNTNPRUUrOWxRZU82?=
 =?utf-8?B?aFl3alR6NFE1T0c5YUdzV3pWczhvT3Y0OTBNWjlxU1U0L3RMRnNMVHNPYjkv?=
 =?utf-8?B?WVlvUGFSVVN2cHYyVmErREVjYlNGaXc4cWdQVjlsL1k2djYzR0JuT3RlREx1?=
 =?utf-8?B?RVVTOEVqS1dGWnBUOUhmeThDNXZNT0ZydkJmcXptdmlGTFFweWtXMWpOMUxH?=
 =?utf-8?B?TitHYzhNcXl4TGswNXhqWVdHYm5ycENwNm5RVWc5ZE1vd1hsellZSFFMTHhv?=
 =?utf-8?B?MWQwR3l1RmRpTExoMTg0bmdzUXZkblJCZkJzOG9YaEJ2UGJhVjd3MzhVZE5t?=
 =?utf-8?B?ZG96aTdaZS90SnhxUEwxalFSMHJ2dXhQeDA5L2x6N1g3eTd0R285NGdKUEUr?=
 =?utf-8?B?RXdhLzBkcFFYNlBneW5STno3WjErSGt6aDV3bTYyU3Y3Yk52ODEyWE1BRVYr?=
 =?utf-8?B?U0NvOUZ4eDRXeDVKVzhESVY4QUNhU2o5STAxcjgyYkpMaU81TmRpb3Y3RDdl?=
 =?utf-8?B?Z0I0RVAraUM5TG1QNWlqNkdlWnRtRWFHV0hEbURHU2lXSldzVHpHQXZEMU9i?=
 =?utf-8?B?NlJOTXFoVlBHL3l0OXdhSGR4NWhyV0tRdkY2YjVNbXp5TzNkNHdWZFJmWHY2?=
 =?utf-8?Q?FP31fi5cGMhdnmSQqUK9K9GmW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8ecd18-ecaa-4ac4-66fd-08dd83e20cc0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 10:15:06.0303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9U5wcmkOPLzkIpxG8j5vca44fz4ZeWajF+gwy/k6pbusRazRFiKp85Pyqfq85Kjj9LsRMSv0LgCFrt0JjqkUFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8188

On 4/17/2025 3:22 AM, Dongli Zhang wrote:
> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
> and kvm_put_msrs() to restore them to KVM. However, there is no support for
> AMD PMU registers. Currently, pmu_version and num_pmu_gp_counters are
> initialized based on cpuid(0xa), which does not apply to AMD processors.
> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
> is determined based on the CPU version.
> 
> To address this issue, we need to add support for AMD PMU registers.
> Without this support, the following problems can arise:
> 
> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
> 
> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
> 
> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
> 
> 4. After a reboot, the VM kernel may report the following error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Modify "MSR_K7_EVNTSEL0 + 3" and "MSR_K7_PERFCTR0 + 3" by using
>     AMD64_NUM_COUNTERS (suggested by Sandipan Das).
>   - Use "AMD64_NUM_COUNTERS_CORE * 2 - 1", not "MSR_F15H_PERF_CTL0 + 0xb".
>     (suggested by Sandipan Das).
>   - Switch back to "-pmu" instead of using a global "pmu-cap-disabled".
>   - Don't initialize PMU info if kvm.enable_pmu=N.
> Changed since v2:
>   - Remove 'static' from host_cpuid_vendorX.
>   - Change has_pmu_version to pmu_version.
>   - Use object_property_get_int() to get CPU family.
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Send error log when host and guest are from different vendors.
>   - Move "if (!cpu->enable_pmu)" to begin of function. Add comments to
>     reminder developers.
>   - Add support to Zhaoxin. Change is_same_vendor() to
>     is_host_compat_vendor().
>   - Didn't add Reviewed-by from Sandipan because the change isn't minor.
> Changed since v3:
>   - Use host_cpu_vendor_fms() from Zhao's patch.
>   - Check AMD directly makes the "compat" rule clear.
>   - Add comment to MAX_GP_COUNTERS.
>   - Skip PMU info initialization if !kvm_pmu_disabled.
> 
>  target/i386/cpu.h     |  12 +++
>  target/i386/kvm/kvm.c | 175 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 183 insertions(+), 4 deletions(-)
> 

Reviewed-by: Sandipan Das <sandipan.das@amd.com>

