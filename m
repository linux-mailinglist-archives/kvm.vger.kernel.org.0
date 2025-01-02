Return-Path: <kvm+bounces-34472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA679FF6ED
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 09:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7CDD3A2870
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 08:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D4AF1957E2;
	Thu,  2 Jan 2025 08:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EE09BL0/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5D3A95E;
	Thu,  2 Jan 2025 08:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735806796; cv=fail; b=EcuKQa7EODpnFzFjwtIgpRBUomApixUadkSLLYKKYAxesB6wE306hQmJIzwuwe2WO3a1Dmeaje89S7JqBx1ufNq+MZ+m0QeAY/bzWqnLXpIFOKfnQiaLvFn43p34HM8tTomCB0viuYCMpGgJ+eITtXg5oXrxJquMUTbMgi6pXlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735806796; c=relaxed/simple;
	bh=/NsPUU48lK7CZMIAZQbg2TChpdDaGLebsTExfVNthAo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jBZcbkipRXQ19u29/HOAbS9qtB77Dnn0Y2TZU4SzXrBJe0uYOaRZ85Q16yJHcJXmNvegFMfqDTvrxTS57vhjnh8FW8DapBaVzud64HUmQuKR88Ijl5Lw/Gd8GXhV7NJPeHxtgsM2D56ckVSB9EJ2vE8hH1pKRBDGdd+vp2univQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EE09BL0/; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qK5KbmfTt/HrvWeep5qfVNTHQgokZkk04N8jQyFmun6ym51aU83kZpxQSQb+vStLVxVYZe/rzQYGBoCoS0nedWZ+Ckl52FHukyyqUtnr98lcpvNBbpbcUu6EQbNRpSmVjinRH0IFqLnBPG6DTWKsdg6ntR2rFixxS7ZDnN9Ls0lniaRQj6umMBpu1HU805EIyjTfvBuUW/cvuKSzztk6g2CBaH2pZ3wQH4Rj6/z25kzUcJLLyKNbSczT0QpwgveWEschoqYe+zbxp71Blx5u51NgIyjV1DL1+y/8S7AJ1QcmiyAn6oN/YOtAyPBDAzAeaUkPqArvhy1gl8eUIrdTeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8I8aWhOhv2Gqc57T4RC4dDSMQ0A6VIxcZLmFN6ZYEE=;
 b=uQGloZ7XpVtxJCZ6YAQGLy1HXFxy5e1raUg0i/dzo+Sly0BDz4FWu9XUU2dRuZCAf6rJgc1eUpYKVIaGqTOk3/geZz7VvWDFmMGsJbmj1PNViG1jI5mRJUOhHDbHigem9/i5lKCKssj3d24uhxJ8+J575ZotGIkYSdB0Yzi2hrOKi2cVbf7RPqHxGDkbc+OJrSEYlgUiDSQYWhlkLjjaQrNZHGaXELRKoPpNrtsSpWKbOnEHNMCKJeBRQ5GuPrDz2wY/ft6C8eYwW7Dd/fK3FZIJrnHtsR1VRCvrHwVZJERjnU6oo7L+L1VsoZExMLPib1vu0rvJZVo0/rOg5i3xzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8I8aWhOhv2Gqc57T4RC4dDSMQ0A6VIxcZLmFN6ZYEE=;
 b=EE09BL0/GVCNTlyGwUNramPdg4mDrmwSan56lstb9G0rXdwcCfSVKkhW1bqiF9L3td5aGepkEpshFTqf4dTnb+2FEiIFtz4gs4gU5iwNMJHFZd8tP0mkcvEMUGWWh4udGmsoXety6z60fPMPS0hkF2xtsyaQwaU+02AHPaw0ZzA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH8PR12MB7025.namprd12.prod.outlook.com (2603:10b6:510:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 08:33:08 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 08:33:08 +0000
Message-ID: <6a769aff-b01b-412b-af01-85ae210a30f5@amd.com>
Date: Thu, 2 Jan 2025 14:02:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Use str_enabled_disabled() helper in
 sev_hardware_setup()
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241227094450.674104-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <20241227094450.674104-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0127.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH8PR12MB7025:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f2f8870-5995-47cb-a738-08dd2b0815bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QkJvS3R6ZkJodDZGeW0yQ2NTaVY4YjdwM1VOYnZ0U3phZm5DRzlDb3l2VHcv?=
 =?utf-8?B?U1RHclZSZ3BpcFd3WXRmcHh1K0p2WFJUT1ZDK1QvSzZzL0psZUJ1b0g4b1VX?=
 =?utf-8?B?b0hkM1l2ekp4b3ROVTBneTByWFhQREVBTnJzU010bTlIZ0FjaC93eWZ0azhU?=
 =?utf-8?B?alpyZTFNby8wRnBlbWRWLzFJY2o2VURGTHB6Um5tWWk3NmxXeHFUcS9JaEdO?=
 =?utf-8?B?am9KUXRWdjhYa3JaeEM0SEl0Rkw3R0NpVlJQSGdSTS8ybVRDQmxNckIrWEZX?=
 =?utf-8?B?S0RVNDU2TDdtc1YySEh6YVd3YjQ1b0tEbG9VbDNjY3dGOTJ6T2NkS1JtZFpm?=
 =?utf-8?B?WE53c0xvQzEyZHNCZXlVaS81OEs1TWsvcnlCUlZ2QWxkZk5xVlB0eG9xQmVK?=
 =?utf-8?B?b0Q2QXNQUm1LVURiYVpxK0JMRjJxOGxEb1QvU3psOFRTNzg5VlJNZDNaVGhX?=
 =?utf-8?B?Vnp0cSsvM2FsSlRVSmpqZXErWDgvcTEwNWRRdkFSWHpFU2YrK2thMUZCS2R5?=
 =?utf-8?B?MW5qZThIb1U4NC9Bb2J4S1JyUHFOdG9la1RPUUV3dWxOUXdMT3dMTUtNNEJs?=
 =?utf-8?B?OUtQeFB5RjZFbXAyMW9oMW9QUXF5cDdOOUtFNWQ3R04rUFJybDFCV0Fxb0V3?=
 =?utf-8?B?Q1RGcWp3cFpiWms4M0FmRTFtbHl3WXRZWm5iMUJEQkV2MHM1Zk9OOVc5Y09O?=
 =?utf-8?B?SG1XNTZHUzRBQlFaSWxKakpGaHlNTTMvdVlPK2JmNHMwdDg3SlFDUTNPUS9u?=
 =?utf-8?B?WHNLUjRxaUE2OSt3bzdhU0NrdHJkUStRRmtsRFBhWHRvUEdNNm9KMWtZMlND?=
 =?utf-8?B?cHVBQ1J4eG9LV2ZTcjI1TlhKdjdWVTVLMVNiWDNrM0ExNzB6U015RHdGZG9n?=
 =?utf-8?B?RFBENTdzSzkrMkd4NVYvNmwvTlZ1TDNnaWpmaHVhVFJnL0xZM0h4Zlk2RXlj?=
 =?utf-8?B?K09kb0E2d0o0UzdMMndrcUdNOVBtN2g3NzFNYmhQUDJ5TkxTeDJzUTZZQUhs?=
 =?utf-8?B?dmNNSmQvaXNpRDNMWERvamF0QmRhckJmMDBjSk8vNVJHcm0vZ05zRHVmaE5r?=
 =?utf-8?B?ZCtVc1hrTlNHZm9VZGw5UVdlZTVHTmFSSEl1ZzBiYkhQTXEzaklrNTArcDcv?=
 =?utf-8?B?ald0dDJta0Q4dFM0UEptNWdROG5pUmlHQklHWEozcXN1WmVPdndhV2lkcitS?=
 =?utf-8?B?dUJpclRVNXNMUkNQd1ZDblpsME8wazBQSHJYRllCQytuckxLSHd4Z2pKbmli?=
 =?utf-8?B?ZUxQemlZUjFiVUt3QjB5QjdoMDZudE4zdXBIUmxXaElWMVlhU21kTDJrSFp1?=
 =?utf-8?B?b1V2cUdjZlRiTnVQd1NsekducWhIdURvZUF3SGVqalZuR0tscXB6UVUydlJR?=
 =?utf-8?B?Mm5uR2R2dkRPc0EvZUg1QzNhRDVNaGNNQy90UEpiY1lUSEd6RzduTVdxWDRw?=
 =?utf-8?B?L2liTWlKdDU2QUhXQ2VUOVFIUis1Qk5GTWEzV0xLR1BpZzd6UTM5ZFBwdWEy?=
 =?utf-8?B?NlRDQUhEOG83S3hPMC9xY2NMcHJ2amhYVmFoWXREN3JSNi9hUUdlK1JyeFhH?=
 =?utf-8?B?YWhjcy84UVg3STdhUFc5bTN6SERxcTJWYUpYeEVkL1FueC81dndlZkdReVE0?=
 =?utf-8?B?cklZU2k1YjhZNkdqUWNQV0syZUUrRTJTRUphaGkvOVdVS3FKYkNxU21FWlhu?=
 =?utf-8?B?cUhLQWh2ZWlGL1g5dXh3V29RTlhHYkZCNnRuUnI5YmYwR25oZjdJYkpJK1Rn?=
 =?utf-8?B?dk0zcWQwTmY1MjVyb2pjTGk4NDkxSkNjZUp5SlhWUlM1YlNQK2lTVE03MmpP?=
 =?utf-8?B?Mk53R1dKTWw1bDU1VXR5RG9MQk9aT3p6a29tekljTTE1d2h6Yk1hdXhsM0FC?=
 =?utf-8?Q?/BfwEu4UiRimu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUEzcTVuSFZLSTEvYlcwTzhmeEdHdzh5WkV5VFp0aFZtYnRNYW83c3dvTVlO?=
 =?utf-8?B?dXhzNnM0OXdWbG40eTVYZmlkVHI4alM4N3JRUDNPb3pKMFBXRXg5cGw2OHJS?=
 =?utf-8?B?WFJ4UFNXV1FVY085T21xL3hIMG5wU1VZT1k5N3hUNmYwZ2JDb25iU3pLU25o?=
 =?utf-8?B?cEZkemxWcHNhL3V1ZVVTWnZDREdBT3laQmZFeVdGR280YWZVWktEemxqSHdn?=
 =?utf-8?B?bmtqU2t0WFk1OE4rYnlEZitpVURDdEpyei9HMUY3dERvNktVRDFqMS8wMkpG?=
 =?utf-8?B?aVVacGpkVlpBVVcya240eTVZVHQxMmR0eG9ES3Z3K2tJV0pnS1lSNGRjcTJ2?=
 =?utf-8?B?L1daMW8rK2ZpR0ZzQ3dIcEhZcy9GWFNVS2ZqeVBNWXFqendob1Z5V1R3SFo0?=
 =?utf-8?B?dmczK0xlMnpYcXFtUmVQOVZwS1UvNnBVNVVSczh2K0V4Q3A5MkpFd2ZXdXF2?=
 =?utf-8?B?U25oa2thNml0Snl3MjUyekZvbGxMamllejRLekcyUTE5bHBsekw3b1ZkMUFv?=
 =?utf-8?B?UC9kL1d1RlRlMlQyTkhiNlZTU2N1V3lhemt3K1NLOHB4YXhFWlZ2dUgxa0RS?=
 =?utf-8?B?dmdNYm8zWExaSE0xM1ZNMzhwbWJNeWpMUnJSR3UrcU5UNkhiMmFaZno0ZS9I?=
 =?utf-8?B?UDBUam9hc3lFVmsxa1NlRnR6MEZ6VlRTVHJjTVF5Y0pVNWx5b1pXczZiVVRL?=
 =?utf-8?B?bUkyZ1NNVXhwbnlneGUrRU1EY3ZkU3dVZFYvT214Y0VSeVBQRUVGZ3hqUFgx?=
 =?utf-8?B?bkJUTXJleWlYb2lPZGZMaUdOUmRaT3F3QzZwTnlLMVlEcEQ0NC9DSENSemZF?=
 =?utf-8?B?T3hjbkVnYnFNdGRZSmJNUnJpejNDZlVrWXVqdVRJVmdQaFpvYUhNa1VFMitW?=
 =?utf-8?B?ZnNKc0hqZ1hGUFp5VnE5VlY0MEpUMzhBY1k4djVtMnovSEdFRzJJUXhRRjhp?=
 =?utf-8?B?bU9JRFVXVjNpNWJTTS9jV2dxY0FxTmRKYjQzSUhOSUVxOG1ERHZBTFRmbnh6?=
 =?utf-8?B?QjRabHQ3N0NyZDZ6U1djSlpoZW4xNlN3ekdCOUtFK0VRQ3dhSEJVYk9DaWQv?=
 =?utf-8?B?RmRMTkt2UlFXeGg5QXBSYk5ZQ2lSWDNhcmlxRzRuaFlSTGRGbFY4blpOaXNG?=
 =?utf-8?B?bFFTZXN3TUFTTWhWejcrRE43azUrUFNiYzJGRTBoT3FOYVVjTEdyeTZSRVJy?=
 =?utf-8?B?cGNmUE5WSmpJd2d3U0ZTMHVvc1o3VENLVW1BWHRJelhGZFB4Umk3ZXdDY1Yx?=
 =?utf-8?B?ZUI2WkZrWS94Nk16ZVR6andHblRwLzlTaFI3WElpSGhERTJPZFlpaC9JakVX?=
 =?utf-8?B?QzNFOVlhekJBcDg3ZEhmSisvWVg4bXRRaFRPaFFHYmVCcVBibTVzRkFqNU9w?=
 =?utf-8?B?dnN5L3pDT3F2QkR5SHh1MmpUWVE2NERvNi9HT2lHNS95VU1SMnlRTmgvVS9H?=
 =?utf-8?B?alhUb2RoYlVmL085YmlwaGEreXE5QnJyV3BhNEI3ZmtoMVRHWWY0cVlFNFFK?=
 =?utf-8?B?ZkQ3eXg2M2xaTGdvTmxLT0M4b3NZOU80NmVieXljM0Y3Z2xiOVdvRnJKWCtX?=
 =?utf-8?B?V25MOVlRc0lDcjdqZWdRcDN1eUJnWWc5dDhqa21TMGJ2Y3JHcGorQjl3a2pj?=
 =?utf-8?B?SFd2ZWFiVWlhRUgwMXBxQ2h5emp1NFhZbHRUNEgxWCt6c2QyeXBiQlB5NmNk?=
 =?utf-8?B?cC9tZWVVNzMxWkxjWDYxTGRBQlBmZXdEYVF3c3YvUTI0TU5zN2l1RVJmZ3Mw?=
 =?utf-8?B?QmdmVGMzWjBmT2ZZM0VRMFhoSjB4T2txNGxCbWMyRVVoTTgwWlN2RzFwTS9t?=
 =?utf-8?B?MGNpbHJVdnlyK1NGUkhDa214dFFOR2VCbnpRS0VpcVpvUVJyUUowdzNyTTgr?=
 =?utf-8?B?cXp1TFNscHdmSWphN3kwOWhIOHgwTnRzMFpnSFlFblQwY1huWUV1ZG9SZjI4?=
 =?utf-8?B?OEZmR3NsRjZ4Z1N2V1dGL0Evcm1qZzluSUFoS3g1Rk9HWDZKaXVJSURxeEcz?=
 =?utf-8?B?dVpwSnJlVjZiMThPZEZFa1JEdm5HVHFleGNLMmM4cmFiQnMyOEJ1OW01S2tn?=
 =?utf-8?B?TkJVOGRmYkFQdjhDbTZtMStMWVJOVks2cldMc2lRYW1VeU5qMjAvUkdXd1hO?=
 =?utf-8?Q?k7enPdPgHEUTmuTkTpmXJLcOs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f2f8870-5995-47cb-a738-08dd2b0815bf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 08:33:08.4995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aufVbbrgS5mqna9z9pMtYHGuC+zs64TCqgtBQaS/b0I/UIOFV8O+hKub6zD/Z7uqo0zbjp7IKRoX72UOKsFJ3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7025

On 12/27/2024 3:14 PM, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_enabled_disabled() helper
> function.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Looks good to me.

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd074a5d3..87ed8cde68a7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3051,11 +3051,11 @@ void __init sev_hardware_setup(void)
>  			min_sev_asid, max_sev_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> -			sev_es_supported ? "enabled" : "disabled",
> +			str_enabled_disabled(sev_es_supported),
>  			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
> -			sev_snp_supported ? "enabled" : "disabled",
> +			str_enabled_disabled(sev_snp_supported),
>  			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>  
>  	sev_enabled = sev_supported;


