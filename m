Return-Path: <kvm+bounces-32847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 618C19E0B61
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 19:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21773282B10
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0541DE3AD;
	Mon,  2 Dec 2024 18:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oOS5Np2s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691B270800;
	Mon,  2 Dec 2024 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733165886; cv=fail; b=vAm2gc6DhtrgAmO1Lv1vmQCdIwJpWKRFY4hobfFeLjTBQDJkQic5P/qJiZyfcqDENCasQ50eZeMFp967rXIAxVL2leC6/KxFtxEpi+vNCiNUfblgtpoA7yY+4kCCH5Fc68eEvAUuqcWUyV2g+mUAE6E+qet385vAPE8Ng0ikhik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733165886; c=relaxed/simple;
	bh=YhFrR5AsRsaG99bmW9XLrPcJn+5Xe38Zbr3oBOHbZys=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jGzbptbI2nQ93/rzdFuokzQGeaSvXfqE3DCZkp+2+kz7oeU1GbDNNztGA57NaVZKdo6MztJgKRDzSdauZtZxodN3Vuq1JfenhMUR2o2sGiamkX9pAx8Dhv8rkxIgQFr2RaafXSTmQU5r8MI8fq33oGY34htkmhjZ+7hzEnHT9yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oOS5Np2s; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LeDq5w5vFmG6PUDix1tBjjQuy0ti2+lDAfVi7Ys4lWP54+Ubh+s6llULwksxla1dOjV7y+8aCCVE43Yo0Voih9p2yNQt2eLBIIlJQurpGkdwzAhwQ/iSCUGyKgfw8p1T1OKiInXwJIlSsf6huK2zMt6xcACNJbDdiF264db/KVjFeR1jhx2Dvhs0zKa8xcWxvtdYJu6PC7BBsn6pLDHX+gV5deYLe7yYvpGTxEFMnjE8GyIt+7uDrkfZ4zArLf/fW86YsL1jP/jwD1rBADxHRWiFYZjCA0kFeeQW8lUTLRiuQrDy9E0QLxhiBXDWdCoc73tQkqDr+Qt0Zf3cnmSyUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erllmAcjkNmqg1JmpE3ZRq+8BlpkQGio+wcvcRzzqkY=;
 b=EO7/bwIgleJa4JTl5p9MbQQUe+cATGs7PMpsswnCbN0a2gAcvAoNtSQFvx/OPYjFe+zchCyUHZnyv3Pua+Q2OjwP0ywwEH9BiWGx5yyuqjuLgLuVkLLIush7YotQtkP+6cB5gUT6bitg27xlV6i7+SaTqIWR7AURF/oqww9+dq4e0OJmBsAOmmOdfygQMHA3f+g50o7Wb/woQU1ZuIggoHjgzKA3i2DJy+PqOvHKlroKZAwXqMMwGfO1iYGMFdo8EH8lnhYOnOZXfEKiHNHWf6wG49mGJSplGLW73e2HPm5C6EuutZT6/TTiMUuTbmEKsx+3CuHq99wETG+4FXx7lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erllmAcjkNmqg1JmpE3ZRq+8BlpkQGio+wcvcRzzqkY=;
 b=oOS5Np2sz8gej0s32KdK0YikLBmAkE5cYiCM7Ug5lI/Pu8jIYRaKW0boeprBLKWkDA97abZRfF1/+3hyOLpIE0EEA4cE9twuz8e2UgQgqt5pA9ntjLXXSixh7APIY905TLnRhn5HxGF3V2T/bgiLN3wpOZtL5iZcwXn9O3lB3bE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH2PR12MB9517.namprd12.prod.outlook.com (2603:10b6:610:27f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Mon, 2 Dec
 2024 18:57:59 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 18:57:59 +0000
Message-ID: <83c7a5e4-398c-4610-1412-74e4309aea27@amd.com>
Date: Mon, 2 Dec 2024 12:57:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 2/6] KVM: x86: Add a helper to check for user
 interception of KVM hypercalls
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-3-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241128004344.4072099-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0040.namprd16.prod.outlook.com
 (2603:10b6:805:ca::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH2PR12MB9517:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cdd18a9-2991-4c87-897f-08dd13033d8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGpPcS9lbndhTGR0dVRCeFNEbDFSN09tcXdhZ09hVE1ZYzJKcFRBUEh6RlVv?=
 =?utf-8?B?NnNxaW5Vc0JWY2RIbTdLUklQeFI1M1J3T3o2WDI5RWRpcXluOXV4eFVBTVVm?=
 =?utf-8?B?V3FyUHU2SkUxNVpKNlErU3NRWXpqMkRtajlZaUoydk9Hb2Z5dHduV1doWXE2?=
 =?utf-8?B?VDEwS2tNTE94TXJMOVUxQmpZVFhUNFBLZGg2KzBQdlJScktyRlFFcHAvc0lT?=
 =?utf-8?B?VFV6d1ZRN3Z3TmJGY1RJZ2o3M0dTZnovd3hZYkM0SndFTTJTT1Vkbk9rNkJO?=
 =?utf-8?B?a21VZGJKaDhsSXRBS21MeEh4Y0ttQ0FwWGdzL25hUDZLTHRyOGx5QklOTE9B?=
 =?utf-8?B?dS84Vy9hb2ZscC93ZUJHMFM0RzM5eFZZNSszRHRjVVYreUc5WWs0Rkd4VVRO?=
 =?utf-8?B?Um5SV05EOW9UMWt3aXYrZmZ1N1JETlZWb2VPbEFnSGNBSUNIanZiY0FmUTVM?=
 =?utf-8?B?UnhPNHpDVHRCcXR5ZmU0VkJibEhOemdKcWxEMnVTdnNLRU4xMFpsQXE0aXBQ?=
 =?utf-8?B?TCtUWlNGS0swalA1VklNOEJEQnBObldBVC9VNkthS0t4QU5EVjFBcU9oZkZv?=
 =?utf-8?B?OU9nWDhmc3RySC8veE5NbmV1NDN1RkJPakoyL1BCMnFLbUZIVUhlM1dVUm5o?=
 =?utf-8?B?UElzUkFVd1kwRUlvTllzdGRGbVNBZVkxajBUWW9vakY1V1gya0VKY1hHSXM0?=
 =?utf-8?B?VE9oazRzTjhOMjJIc1pDMGYrSUpZZmQvUVpIUXFEQi9mSXd0bDh2a2VraWI3?=
 =?utf-8?B?L1BrVTZ6YWUvSXNVcXAwWFFFSDZ2Nm5qTEJhcE5ZQW80cUdMZ0gwM05pVXdB?=
 =?utf-8?B?MldOaE1zNE5jWWRhblNtVHRSZDN0b0lGdnR5UERLaHdJQVIrZ0w1SnlXRXRk?=
 =?utf-8?B?amFFUDV0RFB1SmsxMVFBZGxGaFk2Uko5UEdHa3ZXdVlWY2VadXJ6TCtHSVdz?=
 =?utf-8?B?YlFPL25KWjJ3VW9JNmlVQXBZMjJ5b2pwMWdOR2ZZRjRzUlgralpTTkUzaC9j?=
 =?utf-8?B?b2IxdkRzdUpyNW1HVTZEYVFoOTQ5c0pSc2RkUnpudWk4MGZybGdPeVIwaGRH?=
 =?utf-8?B?azFxN3kyeTZZY2czUDN3bm52bmpTeG5seFhEUjROQnkvRE5QVHdVMUFGdkF3?=
 =?utf-8?B?dEtDbW9lWjMrWGUwQjhIWTdJUFZ6NFR0WmtxWHBzTEpQR1o1OWRFQjhtUmdM?=
 =?utf-8?B?YSszbWtudVRwQ2dDTHArR2JSYjZ6amlpYk5DeGJPbDVhQmVrRmh0REtkSExm?=
 =?utf-8?B?anF4MmtXYmY0Vndvc3RQOEptR0xVdXFoQlZSWFIyZU9EUkt6RzdCOURmalVF?=
 =?utf-8?B?VFFPdFVCM3FLMDhtK2paQm5QNUZpazdZKzY1L2Y2QW83TTM5aXE2UGkwZWRp?=
 =?utf-8?B?WnZBMmJYS2g5N3dYWHp6V0lvNThacDdpbmdvemV5OSswZmhaRkhOTUt5YWJN?=
 =?utf-8?B?c0RXNk1ndmhKeXE3ODd6M2trZU1CVnk1a1pNV1FScEhqZmlGR0llQUpnRGQ3?=
 =?utf-8?B?NFB1OHRtSDhKMnI3czZBWUhKeU5hSG8zQm1tQWVXQXU3Q1hqY1liRE1ETFpP?=
 =?utf-8?B?dkxUK2EvdEt3OEFQS0dBUTlsS2gxRCtsek1zNWRXZ3Rlb3BLd3pkSDRVWVpB?=
 =?utf-8?B?YzlTSW42ckx0MkNCNkhtZE9qUy9JWDJmZFp0RDlqbHBZM2xmaWE2cUlVa2RT?=
 =?utf-8?B?YTZWWnB4cHMrWlM4Ymdqc0RzcWo1ak95ZUN4OVo2TmRhVkZCT2h1VmYzMC92?=
 =?utf-8?B?aTZsUTJpTzBsR1hiaUNQaHlvN1FXRkxaZjhabnJvQm0wektzQk5vMlo1QTEz?=
 =?utf-8?B?M1c2ZitaWU5HOWE0cTJiUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2hWeEtTUnVDelhicm1NcUExTVNRS0NXR1dFY2pubEExY0ZrRzJMekRWNmlE?=
 =?utf-8?B?Y1ZnMkYzRWdaaWcxM3hGUStBbWFuUlVzTUpqOS92UGo5U1BKRXZaaUxnNklL?=
 =?utf-8?B?Qkt0UzZuTzdNVno2TnlnMzVIYVRQSHJnTHFEc0h4eWtRS2tIblJadWp6S2xK?=
 =?utf-8?B?b3IxeS9KVkpvQkloNmVINzZpQjhoOVdXdnJHT0VadVBkUmtsSjRTeHEyNjB1?=
 =?utf-8?B?TW9WQW1LNkJlNDRRTTBJTDd5Ymc1VWlHbWt5cnVhYmxsV0tNcWdodEw5L0Fn?=
 =?utf-8?B?QWhNdWlRVk56RGdxVk82eDB5dUhnaWp6OEdJRlpHRkN2TXBHYnROYTdqZVNx?=
 =?utf-8?B?MGVXM2ZtTS9oTnpjWHpTdkM1eFZLaUNsMWVyUEpqV0VWZmpSNzdzcWYybkxR?=
 =?utf-8?B?b2hqWVE4d1dSRnRXcCsySG9RVnNZdjY0UHRKbjd1aVdiSTNJSXh3aTJ1Nndu?=
 =?utf-8?B?Z3JndFBOTWFwOWF0TWk4Um1CSVRkcFNZLzZYTEYxY0d4bDZ1clEvQTBKTHll?=
 =?utf-8?B?M3ZUUU1JRXczb0tGRlZKeWtaU1FsK3E4ZU1FNVFNam00SVFvQUl4TEdnQlBN?=
 =?utf-8?B?WklrMTZWNS9DVmdjaTVwUUR1aUc3RExhUXdBUDgycUdrYnl5dk8ydjkyQjRr?=
 =?utf-8?B?ZXlLeERadDhHek5vZTd6S1kyS3g0SWVJc3R1dGlTUTlqeHlmWjdlNjVEa2NY?=
 =?utf-8?B?dVlZZ3dPa3d2T1RoMzlBekN0TFI2U21zNWVKeUdqWVEweEYwRkZXRFpOVldi?=
 =?utf-8?B?L3FmUHFFTm9oTnlrQU95anBWV1ZlMjNhM0FFOXhpeVdjd09vZUxxWXFwTFJK?=
 =?utf-8?B?Y2VvcnMxWmxYQ2xnUVhjZzFuYURTVFZyRStHWjlDN3Q1S2R0SU1pWDhwWFZU?=
 =?utf-8?B?WW1JVGsvNWlCNTl2dW5xbHFRSXY5YXY4bkw5TlN1enVUaEhQVGZEVG5DclNW?=
 =?utf-8?B?UlRQK2RRNFB4a2hhcU1DdUgzWTZ0TFl4d011ZG5FNDcrT3lrZ3MveklucFha?=
 =?utf-8?B?RXdDYlFiQzBIVUFPVVdrTnJiU3BWTG1yM1I1YTh4amdXeTBNKzlITCtONDBI?=
 =?utf-8?B?SlJzbDNWUzFCdmdPMTRmclQ3T2NOYVhMNDZrbjBTL3FPS1lxTDhGM1JPVEhH?=
 =?utf-8?B?M21IbUlLaG1RSTFOT1JjcS91SmU4c25yTnpESjFSRDdaYVNHd3A3bVBRY09U?=
 =?utf-8?B?VG9uY01TZXJTNWxLMFh3ODBqNEpLbWd0VFBxekpRdTlIdEVMSjhjc3RFTzR4?=
 =?utf-8?B?WkFKRTkyMTcyU2VsaUxmOE0rMEVodjN6TE9JQk50Zmo2SGlWaEZ0clZjK1FV?=
 =?utf-8?B?SXpzVDNrL3BqRklua2tuVjdKTnRsR3NoUTg3b1ZmUDYxZU40ajF1NUczQlV5?=
 =?utf-8?B?OFhDYVZoQmp6U1pzdmR2SGgrM0Vjem1NMUVkTEpKMnFFbFB3MGV6YXVGRmNJ?=
 =?utf-8?B?RGV0RCtsTU0vZDVYb3NFYTd2d3piZ2hocVVrcE5KS1dhUW8yc0xPdVlhQzZO?=
 =?utf-8?B?QXRxbEM4VURGZzVuZDlVWHFvZGpWU0w4S3k2TkpnNkdTY2JZMU5tcS8wdU5x?=
 =?utf-8?B?QlRrc3hDMEEweXQ5QjlhVzhTNU9BNFVsNXVlektOOFduczdBc3hpTjk5dk9H?=
 =?utf-8?B?azNYUzdWdlN5MmZRSUlSUy83L3BETFNKN0lvdWxPcXZ2d2YwbmhTRWNVSmVO?=
 =?utf-8?B?S1hnUFQ1T3czZDJLTERlcDZBUHhMT3U2S25QdG1EUGk1RlpaUVhzb3FsMFVi?=
 =?utf-8?B?N3RuUit0aDNPeVFTcFQzUTlsaWM1K2x4VlFQNVpJZ3dsL1lQRi96c0pxTzl5?=
 =?utf-8?B?ZGlVMG5ydjhiS2hQajdQZTJGdEk5ZHB6ZHMzN2tZem9pOTZVTmdDbnFCamI4?=
 =?utf-8?B?czBEZjVzTUYxZVRQTS9Gamc1UTNYdVNRUk84dWdBTUxobzhVZWluNWtSYWtN?=
 =?utf-8?B?bmsyUHFuU2sxaExRSGM5SUlKSUQwSC9OaEg1TTJYcUNnK25LVTVPQnMxQnJU?=
 =?utf-8?B?bXV1dUxObkkwT0lkdENIc0IrKythcHNtUy83K0FLVjRyM2dsWHQrdDlJaUFV?=
 =?utf-8?B?WFNqdWRrbjY0QjVCTVFhQWRsSTUwT3NGdTM4cExIcG9wZFA2YW4xY0RGRm5a?=
 =?utf-8?Q?s4lW+v9BY41yBckaQIxU0Tzl9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdd18a9-2991-4c87-897f-08dd13033d8b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 18:57:59.6538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lt2mG+NSrEDxkAy8A6gm0hBQo9eQuAM8ksi5m3mwWCIRoSxuLBMWGEhzU3CrmemPSIGD2DgZJDP5BR9vqkltYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9517

On 11/27/24 18:43, Sean Christopherson wrote:
> From: Binbin Wu <binbin.wu@linux.intel.com>
> 
> Add and use user_exit_on_hypercall() to check if userspace wants to handle
> a KVM hypercall instead of open-coding the logic everywhere.
> 
> No functional change intended.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> [sean: squash into one patch, keep explicit KVM_HC_MAP_GPA_RANGE check]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 4 ++--
>  arch/x86/kvm/x86.c     | 2 +-
>  arch/x86/kvm/x86.h     | 5 +++++
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 72674b8825c4..6ac6312c4d57 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3640,7 +3640,7 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
>  		return 1; /* resume guest */
>  	}
>  
> -	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
> +	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>  		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
>  		return 1; /* resume guest */
>  	}
> @@ -3723,7 +3723,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
>  	bool huge;
>  	u64 gfn;
>  
> -	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
> +	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>  		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
>  		return 1;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0b2fe4aa04a2..13fe5d6eb8f3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10041,7 +10041,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  		u64 gpa = a0, npages = a1, attrs = a2;
>  
>  		ret = -KVM_ENOSYS;
> -		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE)))
> +		if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
>  			break;
>  
>  		if (!PAGE_ALIGNED(gpa) || !npages ||
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index ec623d23d13d..45dd53284dbd 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -612,4 +612,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
>  
> +static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
> +{
> +	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
> +}
> +
>  #endif

