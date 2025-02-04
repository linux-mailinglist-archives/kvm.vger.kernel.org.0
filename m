Return-Path: <kvm+bounces-37247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 789E4A277B8
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F5881646AB
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DDDC21578C;
	Tue,  4 Feb 2025 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EGoHM64h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892651547E0;
	Tue,  4 Feb 2025 17:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738688433; cv=fail; b=rhge3ZXpbz7SSNNA0GzFx+TVc3lp2JDAsK9IURwZr8cwftWktq21EOOWRBkhvlQort2SJPjPDzPGyIJ18glxSZ+xaeilgweflJWXSM80Ep2naNDH8ofK/sdM0Uf5Izv1SqYojo0xpzAX78u8wnr4RLM5IbDruQ7nWrphJh+ZmDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738688433; c=relaxed/simple;
	bh=epbONCxnv4urskCcj2nkCt2GCgvwYrKg7u6Y2ylxpgQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a5IO+aCdF5NcnNFcxZc4rllA6CNXSN6NLAvqSo57cpVm1fa3gGgnmEK/7vIfkb3GU/mixk/BguQebT6aBhkWRBI5yjL7splrwvXQM/wd3DAOybO4o+xPtXGNrQarjCQDM/P9Nta6UsUxZvxjvTGIiLZ0UlfzU93om278CHyse3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EGoHM64h; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C4ffSYPumhku8YHQEC54z+rt0U6Gp7fBpuFej17Dsn3OREMIu81/H/WIT9fhXHpVMYgYzqnZvld1u/mmG8QjBP3QLP9pX9p7Cw+j6o9V9z5VtrBG8S06NOVQVh96ovtpnx4+yADhlrcMXsfXHhPFb6a7lf3BLntJ6+wVDTIcJfG3BagvBGomVABqa5wJhuxwBKVK59AzY3hmAQV4lB/iSd9wRnLNUrMBIdvm8MKpTTFp5cbDRd5HLerLGhFZN/9UCiY4nbpWWRqG8eEJX/2zdVnlbs3/UvlX3a9kpi+A3+doKRB53cflEXXZYOI4TCvFfV7sUmEmxDZqyaxoSzDAew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/eA8l7gUe6uv+x+5nHIsWi5/DAt997/MmPBJrXU/qI=;
 b=g4EfUYvi+wU+GPsonu8WOF04SuLivtEB2ARn4gi7qJAxEQuPFEO9xDrQjV9h5g2TtxEjRrHTkPiKcTp6pzYEoUdI5IqBDjTYVHlAMgr2B3umx8KrRZZdNtjNLnIysmOtJtzLeSJUdvu3s+8ir8KlV/9vkFhGN1M7ej0/qfRnwfhnRNZcuQsVXSsJrL8BHjtw1f4/Ied6syDse9LnLBJJbEBmM0johKep0qAJDNOq7saAaTbUrFDCs35bKHlUBZopvGDNBhKIvhQWv47oB1H+k1OjN+X+HJNClAjGnQLmagfyKptro/hwwjFK1JLy35c4qVfPP4pWvupzk8e1VosxEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/eA8l7gUe6uv+x+5nHIsWi5/DAt997/MmPBJrXU/qI=;
 b=EGoHM64hvE+I+FniGhOeiMVWnnopGR7pCszjOKWs1yG6Hsewu3P6UX0t9fsJ78DF8UEzbatVPCYdVRcgKGuF6DH4P426ialTURfXg9sMPvT37uNUAvcB8Upt+tfKc3azvk5HytqV/Mc1y93aqaIrxGD0qGiguV/1BkiOezNwqQ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB8418.namprd12.prod.outlook.com (2603:10b6:8:e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 17:00:28 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 17:00:28 +0000
Message-ID: <f3fee3a5-be41-77e9-5cfd-085fe127b7fe@amd.com>
Date: Tue, 4 Feb 2025 11:00:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
Content-Language: en-US
To: Kevin Loughlin <kevinloughlin@google.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, pbonzini@redhat.com, kirill.shutemov@linux.intel.com,
 kai.huang@intel.com, ubizjak@gmail.com, jgross@suse.com,
 kvm@vger.kernel.org, pgonda@google.com, sidtelang@google.com,
 mizhang@google.com, rientjes@google.com, manalinandan@google.com,
 szy0127@sjtu.edu.cn
References: <20250123002422.1632517-1-kevinloughlin@google.com>
 <20250201000259.3289143-1-kevinloughlin@google.com>
 <20250201000259.3289143-3-kevinloughlin@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250201000259.3289143-3-kevinloughlin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0172.namprd04.prod.outlook.com
 (2603:10b6:806:125::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: fb877e75-5934-460a-587c-08dd453d6d35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTZFUDR4WlZqd1oxNkwxVWpnWEVwTGkxT01hNXBLdlhSZ0NmM3oveEM1d094?=
 =?utf-8?B?TXFYVjY3TG5kWlJXRjl3cWpFS2ZUbU4rM3c3bCs1ZDRtV2JZRXp5RGdRcW1i?=
 =?utf-8?B?SFJBTkdSQWV4YjlseUJUV285ZVlJdzJtWVNRVzcvSGVvaEVjbFlGQWdCQ01R?=
 =?utf-8?B?S3VkdVRRcGMrSGVoK2tQc1VPSGRYNmJ0NDZjWk5FL2t0N1R5NDRNYVdpV0VN?=
 =?utf-8?B?L3Y0VzVxWmhzRlhtRkRpTDNzRjVBM25WMDBYSUFJQWZSS1F4emVTQjBmV0lZ?=
 =?utf-8?B?cUFYK1hJNGs4eEFEdzZrSG1aRVVhSit6eGRsN1RuWVF2WU1KLzN6cEV2QVU3?=
 =?utf-8?B?NEVJa3kwWG5TUSs1TDlxOFM3NllQd2pCaUE0UVF2V3hCUjNyUm1vTnAwdVZZ?=
 =?utf-8?B?YkN5WHhOT2VsQWhISTlhRGNzN1oreGxXZkpPNnlibGVLZWdvTUpmRUoxdVBl?=
 =?utf-8?B?ODc1c05MWGc2amVsY3FEVTFSMG9LaUlIeUZYQ3JTT3FIcUl1TjJmbU9Iait1?=
 =?utf-8?B?ZFVnZyt1ZXYrd3kvKzVHVkR1QnBhT1ZCc2xQODJkaHhrOVpYMkRQU0dpemJX?=
 =?utf-8?B?Ly9yZERJamlxb2NYS3k3a0ZEYnhiTi9nRTd6Um5jdWtMTWpzL2ZOV2ZWN0h4?=
 =?utf-8?B?T0NEU2NGbnpUN2JOUHk2cnJHR3J6NzlsYjdiTUI4UTlxZ29PaWZJK3lpWUVz?=
 =?utf-8?B?RWRzWE40blRGWU1PUXh2VllXNVNMc2lZTnNCRnJxaEJNM1ZWY3M0ZjZYS2JX?=
 =?utf-8?B?YXpZMXlkN3BXclJEam1RQXhKMXJmSUxPQk1OR3VmOVhub2IvMEhxQ1p6M2N2?=
 =?utf-8?B?SGx3V29IWTROOEo5ZkJKNEhUNmE0L0ZNSmphNGhia2tNUDB4dnBsR1RyTmY3?=
 =?utf-8?B?bEtxY2M1NGpzK25WVlJqM3FpdlNYNkU2WTA5NkxGRmRaQVNEMjg4TitSRTdH?=
 =?utf-8?B?QUp0R0ViYkEvOThsV0VqK1dTTHBuSms3L2hVNFBweURWbzZoWmJFeGs1QXB2?=
 =?utf-8?B?a21vVzBZbEFiYVNubFNFSTBLd3BJdmdtU1lFSWZTVEF5YjBrbGw1WUJOUWxK?=
 =?utf-8?B?NGtIaERma3RHQnM3aE91YUJyMStDNGMrWHZlMVBSdjJ2bWJQY2dQc0h0Tkwz?=
 =?utf-8?B?RmxkS1lHN214UDBSTEljS0VyMjlJaS9GMDZtUk5kUFBXZG10aUxxVWVsUmdp?=
 =?utf-8?B?ME5FSmpmUUJMdFRsbVZvVWY5NUZIcmEwc0NNd1J6TjROZjB6aXZoZVc2Rzdi?=
 =?utf-8?B?anJSM01xOS9CajZxOGRaY2JKV0pZdTlnVzJQekNxVzRUZTl6eGZDcmpyQzVQ?=
 =?utf-8?B?eUEwWTYrUkVKVS94OHpnRFM1dzFNdytFK0VtWHc3dUhpZTNNVVRva2J4eVJa?=
 =?utf-8?B?V2cyd2M4NWNKdXZpTXcwMnRZYlZ5M3BudHBGMkoyeVplcy9VM3RENE1aNFNU?=
 =?utf-8?B?Z0I5QldUd1plSy8zaXZ1OHhhTGxreXN5MTQrWFhWTjZGNjg0Z1hSQ1ZKVXBD?=
 =?utf-8?B?d1UwUW9FUlRRbkFYL21MMTdzdnBWSTA1MDhSVm83ZGNrUjdoZFFMR0hnNnA0?=
 =?utf-8?B?SHk0dVVnNGdxQ1IvcXlTeVIwSUl2ZUdjM1BUd0R2RmpGTlR2dm5GQk1FdjBX?=
 =?utf-8?B?cGVkQWo2ODVFSGIvamFXME9tR09oMTlnUWxlNC9GOWJUbUR0YXZHekdiL01p?=
 =?utf-8?B?VWtUMjE2VE5vZHowaTJ3aWxKdER2czRVbGRoUGZvZ2U5Tjhac3ZSL1V2Uzda?=
 =?utf-8?B?dG80SUtFUlA5MW11ai9YaTlFVFcxaWNhUUVQVkdYcjhXWWxHOWMveko1NWla?=
 =?utf-8?B?QmFRRHFYR3B5NEhzTDgrYjMxTm02UEVJbjRSenducUM5WXpJQXhuNEV2ZCtm?=
 =?utf-8?Q?Eoi63k2Js+QpR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnArSG9EU1NGa2JpTlFMa2dpeWk1M1A4N293V2JwQ2JpU1JVaVZPWUZtNndD?=
 =?utf-8?B?RmNUTzlRV0FiMmYxTXVORlF6MmNna2FRSDhiS2grZHMvc1B4SG13SENmRE9C?=
 =?utf-8?B?QXZIYnhuTHBCM0FmT3VKdEQ2d3hlNXdmakp6VkluVW5YVkpidmI1NmFTNklo?=
 =?utf-8?B?SzJjUDg0UmZiazc5YnpSWEtHVmNXUkxmaTRlM1U2Tm5IV1puUm9hS083czdn?=
 =?utf-8?B?dk50QnJUa25VaE1oQXVzTzVEczJzS2hVMHFQa0FlaVMzQ1RqL3EvWmhMdE9B?=
 =?utf-8?B?MWhadHM1YStDc2hGSllIQWhxL3JWQXdZRU9kb3MyVkVJVjdVejNrMXNkN1ow?=
 =?utf-8?B?cnVadmRuZFIzamNwcjlBNFdDcHI3WFR0QzQ4YU5BZlI0TmR6dUZCRk9TTTlQ?=
 =?utf-8?B?dmVFc0NzVXU4Zy9HcXY0aVgydGxMT2VFR1ZObGpuVk5xdnBwN2hRZTI2ZWZR?=
 =?utf-8?B?S3VQUEtMeDZHaTV6TFlsTzBBMGo3dytEemlnR0ppYUVPaTcwaHBvZlFaYmRI?=
 =?utf-8?B?RGMydm5WWlFCUlNOR29JcjFPeStkdW85T1E0bjEyTkw1c1BQSGpwbWFwZWk4?=
 =?utf-8?B?SEx5TVcxS1dUTGdUZzNnVzZBekk0TDYrM2h1NnpQUGM4MGd2cFc3b0szMkFi?=
 =?utf-8?B?USt0LzZyS1U1S3FsYmZCa1FydkxCNjFIOVk5NmkyUE05bVpDS2ZzRGRnbnlY?=
 =?utf-8?B?TUpPZjJid0tGaitUcm0xalVVVXUxamV6ZnZaK1VnMWovMTdyejBYa2U3a0d6?=
 =?utf-8?B?aVNHTWNBc09WMENmam4vSTlYbTJubndnZVN1elRGZ0lNdE5jSGdMZ2ZxL0RE?=
 =?utf-8?B?dHpjZ000MGZ4ekdOQ3R4ZTFRYlBEZWtSQjFZK2l4Q1UzSENWV0tmU1lDeDVC?=
 =?utf-8?B?VGNFMFFlNlhXVUVjUmcvUkNZY3g0eGZ4Rm5UZzFyRnk4L3RhSGc4MmgyWi9t?=
 =?utf-8?B?NnZiOGNIL0ZUZXhzTEpET0N0MTVVZ2dKS3ZQUDdCVUVIZlFXMDZCYmxLejZP?=
 =?utf-8?B?NUdINXVrYzMxRG1BYUpKdFpiTHp6NzJJTExjdDdrQlUwbmk5aFpHZU9NZEw5?=
 =?utf-8?B?T0doU1FuV3BEanRTMER0cmRpMmFzd1NzN2x0RzNBTm1rZzNHNW5RVmdJOGpF?=
 =?utf-8?B?UUFoRnU4WWdNZHdTV1NJRWZtTFZOSUJ2bWNOY3F0MTM5bjFnTXIwSkRWOHk0?=
 =?utf-8?B?alNwUDhMaHVWSnFITVMxYVFOa2kzaFpGbE1xTVEvMUppQi9pSFdpMlVRdzd1?=
 =?utf-8?B?L0Z2N3FEUlFVWVQ2OW50WVUrUTZFV1JDQWFSaVd6anpYWkR2WjVhWVRFY2E3?=
 =?utf-8?B?SVVlckJyNEhqZ0VoVGcyak5QRURmSlVDY2t0aTJiZDdPN1Qrbm1haWVhbHVK?=
 =?utf-8?B?WXYzL3J0aXlBY3g3RkRMZXJ2bk1DYWtIWmo2YzM5T2Z4WnowbDlRRGl2Qkt1?=
 =?utf-8?B?ZCsvenRpb29ZZlVGRjAvdVo5VEZEWkMzenlNV3JST0V0QVEwbjNqOHh3U3p6?=
 =?utf-8?B?NncwamdXbTZBR3FnM3JpajdqSnBtdTZGNzlsUWxCT3ErRENhSkt1N1hKb04y?=
 =?utf-8?B?N1RuY0Q4MDM4cmYra3JienYveklFMWJVZjQzZ2V3TFhNY3kxb3c2RlVBVFhT?=
 =?utf-8?B?V0JZUXZEdWlMdFZrbXRENm0zdGFwd0U3bWFaTUtHbkxFYllBa1UwdmhJVkp4?=
 =?utf-8?B?azV5MU9XMHNvRWRBK0FkeWFuYXFLNXpGNUluUVgwMVlqV1VsSFFHTHo2U3J0?=
 =?utf-8?B?M1NidzFhc1piUENTWHRmNHAvWlNIeC9EOEI0Ui9tSXhSNE1YYTBQalN2b25U?=
 =?utf-8?B?UXcvdm9PeExOVkJlY1ViVU1KZmpVTTJOUkl6Rng3b21jS213ZGNCZjlpT0dZ?=
 =?utf-8?B?MTN4R2N0emJmbUtMTnRRdEdmZWVZZVp5ME9YRm9YamtyZ3o5Umt0anZ5Nm1P?=
 =?utf-8?B?N0RNNENTSHBvV2dGSE56VTFFNzJUays2WkNoSDRLeFl0cFJLelBkc1g2Tmxy?=
 =?utf-8?B?WU1LK1Rsdnl3TWhPL2pTVWhBem50QUgvOTUwYjlEdXRjb2xYMGJ1eGpxNnFT?=
 =?utf-8?B?d0d2OGVPMDZ5WXpId0QwcTN2WWpTaFExTm5ZZ2tmcVpEMjlkb2ZFWjF2Lzk1?=
 =?utf-8?Q?he14HOgVqzJGx8F0T5kcXLbaE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb877e75-5934-460a-587c-08dd453d6d35
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 17:00:28.7537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r3K2FEygoZEXJnCdW4rpNSN19RikokpW9tj890CwWOhKqZl0TOMT0LGBSRDI0PbPn7vKtFselMR2AEtsoPy2Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8418

On 1/31/25 18:02, Kevin Loughlin wrote:
> AMD CPUs currently execute WBINVD in the host when unregistering SEV
> guest memory or when deactivating SEV guests. Such cache maintenance is
> performed to prevent data corruption, wherein the encrypted (C=1)
> version of a dirty cache line might otherwise only be written back
> after the memory is written in a different context (ex: C=0), yielding
> corruption. However, WBINVD is performance-costly, especially because
> it invalidates processor caches.
> 
> Strictly-speaking, unless the SEV ASID is being recycled (meaning the
> SNP firmware requires the use of WBINVD prior to DF_FLUSH), the cache
> invalidation triggered by WBINVD is unnecessary; only the writeback is
> needed to prevent data corruption in remaining scenarios.
> 
> To improve performance in these scenarios, use WBNOINVD when available
> instead of WBINVD. WBNOINVD still writes back all dirty lines
> (preventing host data corruption by SEV guests) but does *not*
> invalidate processor caches. Note that the implementation of wbnoinvd()
> ensures fall back to WBINVD if WBNOINVD is unavailable.
> 
> In anticipation of forthcoming optimizations to limit the WBNOINVD only
> to physical CPUs that have executed SEV guests, place the call to
> wbnoinvd_on_all_cpus() in a wrapper function sev_writeback_caches().
> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 41 +++++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index fe6cc763fd51..f10f1c53345e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -116,6 +116,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
>  	 */
>  	down_write(&sev_deactivate_lock);
>  
> +	/* SNP firmware requires use of WBINVD for ASID recycling. */
>  	wbinvd_on_all_cpus();
>  
>  	if (sev_snp_enabled)
> @@ -710,6 +711,16 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>  	}
>  }
>  
> +static inline void sev_writeback_caches(void)
> +{
> +	/*
> +	 * Ensure that all dirty guest tagged cache entries are written back
> +	 * before releasing the pages back to the system for use. CLFLUSH will
> +	 * not do this without SME_COHERENT, so issue a WBNOINVD.
> +	 */
> +	wbnoinvd_on_all_cpus();
> +}
> +
>  static unsigned long get_num_contig_pages(unsigned long idx,
>  				struct page **inpages, unsigned long npages)
>  {
> @@ -2773,12 +2784,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>  		goto failed;
>  	}
>  
> -	/*
> -	 * Ensure that all guest tagged cache entries are flushed before
> -	 * releasing the pages back to the system for use. CLFLUSH will
> -	 * not do this, so issue a WBINVD.
> -	 */
> -	wbinvd_on_all_cpus();
> +	sev_writeback_caches();
>  
>  	__unregister_enc_region_locked(kvm, region);
>  
> @@ -2899,12 +2905,7 @@ void sev_vm_destroy(struct kvm *kvm)
>  		return;
>  	}
>  
> -	/*
> -	 * Ensure that all guest tagged cache entries are flushed before
> -	 * releasing the pages back to the system for use. CLFLUSH will
> -	 * not do this, so issue a WBINVD.
> -	 */
> -	wbinvd_on_all_cpus();
> +	sev_writeback_caches();
>  
>  	/*
>  	 * if userspace was terminated before unregistering the memory regions
> @@ -3126,16 +3127,16 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>  
>  	/*
>  	 * VM Page Flush takes a host virtual address and a guest ASID.  Fall
> -	 * back to WBINVD if this faults so as not to make any problems worse
> +	 * back to WBNOINVD if this faults so as not to make any problems worse
>  	 * by leaving stale encrypted data in the cache.
>  	 */
>  	if (WARN_ON_ONCE(wrmsrl_safe(MSR_AMD64_VM_PAGE_FLUSH, addr | asid)))
> -		goto do_wbinvd;
> +		goto do_sev_writeback_caches;
>  
>  	return;
>  
> -do_wbinvd:
> -	wbinvd_on_all_cpus();
> +do_sev_writeback_caches:
> +	sev_writeback_caches();
>  }
>  
>  void sev_guest_memory_reclaimed(struct kvm *kvm)
> @@ -3144,12 +3145,12 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>  	 * With SNP+gmem, private/encrypted memory is unreachable via the
>  	 * hva-based mmu notifiers, so these events are only actually
>  	 * pertaining to shared pages where there is no need to perform
> -	 * the WBINVD to flush associated caches.
> +	 * the WBNOINVD to flush associated caches.
>  	 */
>  	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>  		return;
>  
> -	wbinvd_on_all_cpus();
> +	sev_writeback_caches();
>  }
>  
>  void sev_free_vcpu(struct kvm_vcpu *vcpu)
> @@ -3858,7 +3859,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
>  		 * guest-mapped page rather than the initial one allocated
>  		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
>  		 * could be free'd and cleaned up here, but that involves
> -		 * cleanups like wbinvd_on_all_cpus() which would ideally
> +		 * cleanups like sev_writeback_caches() which would ideally
>  		 * be handled during teardown rather than guest boot.
>  		 * Deferring that also allows the existing logic for SEV-ES
>  		 * VMSAs to be re-used with minimal SNP-specific changes.
> @@ -4910,7 +4911,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>  
>  		/*
>  		 * SEV-ES avoids host/guest cache coherency issues through
> -		 * WBINVD hooks issued via MMU notifiers during run-time, and
> +		 * WBNOINVD hooks issued via MMU notifiers during run-time, and
>  		 * KVM's VM destroy path at shutdown. Those MMU notifier events
>  		 * don't cover gmem since there is no requirement to map pages
>  		 * to a HVA in order to use them for a running guest. While the

