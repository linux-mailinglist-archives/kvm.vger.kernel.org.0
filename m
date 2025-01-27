Return-Path: <kvm+bounces-36686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99242A1DD21
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD07D7A2A3E
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD03D194A53;
	Mon, 27 Jan 2025 20:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zEwOJ2DA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2078.outbound.protection.outlook.com [40.107.96.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10849189F43;
	Mon, 27 Jan 2025 20:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738008230; cv=fail; b=VN1UImPBjgS0GlK3dDm5+KE3bvdeN0s0q9Vfj4GrQ+M3bA1rrzYa+uQ1G48L4otJVUQwOsPh8BiwFfgHYEaD2FUq6FkbUj4XelhhZgIY9FbcWVmMjpv/eUx8/tvfOUAFGfN0Eucl2D8rUSDSB+EcI+mmuTcaqP1J1siPvRGQ2FM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738008230; c=relaxed/simple;
	bh=Bgz08lgrflqmgrTfFkYrltSmAjrbb+CQLwapv0qsaAs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HEofeomTpHFN50buLSR46vyw6+yuIkoYBcHwk9BeWbhzr737ovzjQYib3ZF3ssGfsXotXokmpvlrrnx6pEWbSfkFE1esFIf1VB0vPmab1hlLsm512yzdVKWD5NCNcly9pCGb7bZLekLQIjf2LR0VNm5BFE/Ta8ugTvHH7nSK05I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zEwOJ2DA; arc=fail smtp.client-ip=40.107.96.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fEYXo/oY1kf2Y1tA3VyIe5cvhhE+unfJKbhWI9rz6AaPUmnXk861uHlKi/rjvmRVJpYCDDwBunNu/q6snI7qc7Jyb2Px8K7MKmrXHq07WpRqINEmr/5NRH6r5JVCFhGZfTYjHKi7jA7gXXZdLpGd4vDdg9YTf3TkVzy8a9KeUK6VSG8w60WymmOxeBgkxkt/AciiE3FjZ0G4mFohFb6NeDq7PO65l6E2L6rtQ/PHLddGAuVNFHlsDnzMHUZK52tdAaqBo3xtLtGccZOPEcwI8yVI/aVMfHyg+DuJbNoP7WsxTzbjgOFotQ5MqhGrcMphtaL8qr3mHRuU5vn18P/gVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81nKOSqHAfSF5e+H3yQi0JALUyGQA4NiTpPwQbQsKX8=;
 b=Ien4ggpAKlGPYIAakOUyxhqcwmlirUXf3wxVnslZx15bfbvXMjbqqmqjB1rg1/XL4gLHj4Eg9K12xORYJtYff0B24Zd+Nz5Jw+LQTDWk/xOuJyWDe5jlTNNc2fcOSAB4QpYIJmwgl5av/GyOxMx+dNTvI4C5ToHUkIv1hHT5S7s6ZR+UFtyBQe8lQYpTxU7L7e4yzGy1d0rju1RPAVUyFSGeZMmLAJi9+LuPS4YdXqsFSAFgwzaX6p8GDZLolB+9YSVK7/fr34aImpKK/VY3Z8U1tGyac0HMTExdCVi6Pp1mjnyzTfaVL4k/cCLTZOdPg+byKq4LXaDlf8U9fd+MWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81nKOSqHAfSF5e+H3yQi0JALUyGQA4NiTpPwQbQsKX8=;
 b=zEwOJ2DA/oYJKXHd4xmQbAfH21+1CA+QxtF8Xnam7XwExS3kwrqXIX8CT2qRjqpgRBnUjHGHtOSIzzJWlzs1IDENJOvdp6JA+zsWsAVPRmTkCk0ASifJrejCSOV4K8n07cb+YCu0RkUXNN/zHyvaiwRyydA5kFpouaE0tozKgHw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6417.namprd12.prod.outlook.com (2603:10b6:510:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Mon, 27 Jan
 2025 20:03:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 20:03:45 +0000
Message-ID: <97977198-ec6a-bc10-ad34-31448f5407d4@amd.com>
Date: Mon, 27 Jan 2025 14:03:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 3/3] KVM: SVM: Flush cache only on CPUs running SEV
 guest
To: Zheyun Shen <szy0127@sjtu.edu.cn>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, kevinloughlin@google.com,
 mingo@redhat.com, bp@alien8.de
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250126113640.3426-1-szy0127@sjtu.edu.cn>
 <20250126113640.3426-4-szy0127@sjtu.edu.cn>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250126113640.3426-4-szy0127@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0091.namprd11.prod.outlook.com
 (2603:10b6:806:d1::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6417:EE_
X-MS-Office365-Filtering-Correlation-Id: 3003df78-509c-4c2a-d554-08dd3f0db46f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2JOQ29rUXVidlcvN3NudjF6WGVGYU9zZVE3YlhGdWs0c0svTzAyaG1YY1Br?=
 =?utf-8?B?ODRqR09NSklBUERqS1F2SnBYK1RnemZRMjV5UjUxS2lPZzBNOEU2QnNldXFs?=
 =?utf-8?B?dnZjYVFPV24vT0ZvaVlvc0UxWXp1ZXRtWDJZZHNaZFpZeExmM20xb0xGOHIz?=
 =?utf-8?B?SmxwZnVMaERoNGp2NEp4VjVoVytKNU51UUNOK2s1eGw1VzZGRE1VM3hvM2cx?=
 =?utf-8?B?c2VyVTlWOE5RWUZzUzUxZHRLby9MWHg5Ymo2NG51aXB6bnA1OVZ3QW93S00y?=
 =?utf-8?B?eU1PZ1hnbzh0UTNLNWJHRkE4ZWxoOVVKcHN0c3Fia2M0dytQMkZUcDE5NWdr?=
 =?utf-8?B?NFo4L0JqOUZldWR0R1YrQ1VhRXJENWZEYmx3TTBSTmZicXFnUVpQMHV2ZDJD?=
 =?utf-8?B?SnRQY3dhUC92d29pYmpjTVEvcmpUMXM4RzVERU1wdzh6S3BMdUxybEliNEZV?=
 =?utf-8?B?ZHMyZEEyZmtrTHQ0MFZ6WmZ0TGk2cmlmRnp0WWpVODB5OFZVOENaMUIvMDV3?=
 =?utf-8?B?Y1Npd0diaVA3ZlFSR2NiSXgwdEpWbms2U0o5aU9JZGN1VFNnbUVmUlV1NVJX?=
 =?utf-8?B?aU1MTVVrVDJTeVlsT2ZqU09WMUROQXlUOTl2WHV3UGpjcUo3RUtyVDlPajZB?=
 =?utf-8?B?RklrdkJZVm4yUFVVeHJiNFFjcHVPeVhsZy9zcGdzNXB5K2lDTnJtVmlxdmpl?=
 =?utf-8?B?RzlWb2Zlb1hhbm10bkREelVWZW5MdjBtaHBtbUVtMVVWVUtIQmNWSnRvOWF1?=
 =?utf-8?B?R3p0eUd6d01xTUs3dzRrNTdjRVZDSDV5NGVFVXRpeFc1TTkxZ0Ntejkzd3ha?=
 =?utf-8?B?OGhOdmZWd1pYbGRLN1Q2QStBS3dmYlFjS3JFbndSTDNOa2pKaXEwbTMxMDQ0?=
 =?utf-8?B?RGYxbE0wOEdrNzhabGt6NnRLYzJmYTZaUFB4ZWUzYnRpeDZhNHd5VTdBbE1I?=
 =?utf-8?B?UmJQNnVQRUlHaGt6YkFqNWZJU0pVUlNBQ0xJVVhUQzMzRm85ZzhuWkZ3UXpQ?=
 =?utf-8?B?cU9BZ1A3amgwdEpIK2FQWENnZWIvMmxrbjBaMnlSUU0ySnNUTEorWE91ekh3?=
 =?utf-8?B?RVQwMmpZMEVlcFhUdWxmTXBScEMreWVJZjRjUGtYL0kyWlR3NUV0WFlqQnov?=
 =?utf-8?B?MTF6bW9xZVkrQWYxbXhKa0ZOY1JtSVprVy9wRFRPeElIc1dzTk9adXZjUFB2?=
 =?utf-8?B?OXVUZHRmMlh6dFVkdm5WY0QwcEQ5N1J4RkNZMHVkQ0FCMGxhNVd1NThpaUc4?=
 =?utf-8?B?c3Zpa3RDOURxQ2JWVi9SdDA1OXVOcStpcVdMbHNNTlJGbTZQQlZGaU55Vkd3?=
 =?utf-8?B?ekd2ZG1DSE5BNWJMU0xwdlpaK2NkVEdxVTNtN05EbHZFSDQxd0lyM3ArMjFz?=
 =?utf-8?B?dGNRT0p2cFl2R0FRdGw5RzRwajFQWDVUR2NSOVI2OU9mdVJseHZkVGE3WWNP?=
 =?utf-8?B?TmUrNzEyQjFpVlNFSzZLR1Yzd2svZlVHWFVmdVRDemlOYWJ2NlFRU0tDalZv?=
 =?utf-8?B?TTAxU2poRUtER0wwWXlVcTRNa0J4VU9PYTN6bTQzUXhaWndHWmJwQmZwUndK?=
 =?utf-8?B?eUxtK0FCU1F1dmtELytNeFQ0LzYraFFWZy9QZm9lSkpBOHppek1QcnFOc3Z3?=
 =?utf-8?B?ekZxODhodjV6WDRHMGdRMm1uOUxiVUpILzJPaVNrUlBESUpHOTgrNGovcCt1?=
 =?utf-8?B?ajdxbi94TjlKdGVNdkJKeGIzbGMvNjc2MFloQXdmZ1dPeU0ySFdUakN5Y0Ez?=
 =?utf-8?B?NDFsdkx0dzVxSm93Q0ZPVk1jN2ttU1JVWkRwZDhaTU5SNkZEK2xzWVY5V0E1?=
 =?utf-8?B?ejRpSzhUblVRVDVyZ1BuRnBZeVMzSEIxeDZwQ3ptM3YzMmtmQ1Z0cVJlUk1p?=
 =?utf-8?Q?8jR3sIJNPGxcq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1lKeHl5b1c4dmlMZW1DeTZDY0hHZC9Dcm9ncDk4b29NZ2trMHRBaU1QbHY5?=
 =?utf-8?B?Q1E0WithK3ZPZHduczZuVzMrNzVZZUtVWjJxUk5aa0JMU2hXUHU0MSt6ZjE0?=
 =?utf-8?B?OEhqTXA5VVlnbU8rakNKKzZ4TDdMNXZ2WEFQK2crZTA2eHZSYUlDMVBKS3No?=
 =?utf-8?B?SStvVXRIdjIzRmI1ZlA0amEzdUVEelFzbGsrY3dTTmh3aUR4RitSaW5QVFI0?=
 =?utf-8?B?YlRHQytJRWpGMXpnMi8vVUVKalJnekx3ZzErbFNrZ2xTQ0x6a29GRVUyNGFL?=
 =?utf-8?B?Y2x6bUk1YU50ODZYTDR2OFlaSXdIeGF0NHhUSnd1NDVHaEFudnpjMEtUaUw1?=
 =?utf-8?B?Y09sb0liVklJeGJ1ci9oRjZxSERFSjhNOEZ6OXAxbk10dnh5NGhRdUtCblhz?=
 =?utf-8?B?RDIvMlFiVFJEUWpFcWpEME16blJpV05jVFhYN293YkZMamNZZ0s5QS94b2ty?=
 =?utf-8?B?OVBRdENwSU43dTZ4bWpNRkZRNTE0ZUtKcG0rRjB6MmhKYnlsTDVZdlpnRFRS?=
 =?utf-8?B?UWhnUGZFakpuV0UrQng0MEFMSDgxSkQ5USs3cHpGSm1SZjVFWFBYTmwvbG5w?=
 =?utf-8?B?LzJyQVhEbmxpdlFDNVJNNlhrSXhSc24rSTJiWlFMZkFRVGJWZ01jUjZWMFhu?=
 =?utf-8?B?U2ZzZXJ4MytwVEpmN2F2MDFuYkNkTGtsOE1MYWlib3lESnRVWWVkQytvV2Uw?=
 =?utf-8?B?Rk83a3U4bkpTRm5TZGp2Y21KM2I4ZmgyMTFDZ01nZ2V0c1g4elZoSjJzM1dG?=
 =?utf-8?B?Kys1dUt0Mm5VVDVOdmVPaTh2Mjc5N3JDZUkwei9rbm1kWXZ6SjZIUUU2djE1?=
 =?utf-8?B?RngwNEMxVnJEOTBpOE5GdFhWcE1lZWExaGQ1cHd1dGlvT2FYYm9kNXk3cVE0?=
 =?utf-8?B?aFR3aklBRkJDTzJ5MkZ0ZlpFbVlNZ2dEbkY5Z0hKby9WUURMaHY0UWNmZEZG?=
 =?utf-8?B?VWR2cVNyejQ4Q0krYW9ja3JaVHYzdHFEeVpMbmRMQldOb2RzRVpINGdYZlZF?=
 =?utf-8?B?bXBLdE5oRm1JRkRNMlV3OVhzVisreVFFS2FCeXgvS1EvWGV6eWpHSE4rU0ZO?=
 =?utf-8?B?U2xVMUl2MHNhU2VjUFdSdUdyc3lDYVhjRWZoYlJMLzJmZHNlaDd1UFowS0hF?=
 =?utf-8?B?OExXMWFQNm9hWEdlejNubGNVQzBtcXFXaTluZjJHWFd4YjJuR0hzV3REK0JY?=
 =?utf-8?B?UVg3NmplVzdnak1HSlcydElDL01XV056STJqSWRHODZBS3k3Nm8xUzFJb0w2?=
 =?utf-8?B?S01OMGhnakY4QjRMVWhyaHJFSWxRRW4zU2R2dFZvRHVEYkprWkpFU3VsaUYr?=
 =?utf-8?B?bzZ3TFhmeGhBaWtFM3dJUDUwMWlVVitpU1pSbGhqRkU1RWhFTDNrN1dnY1Fx?=
 =?utf-8?B?eVp4dFZkQlZIdnhSMk1qS08yVmx0KzhCeVVSLzM4aXg1RENxV2NlSWt6SUZp?=
 =?utf-8?B?elQvaXZmM0lnTXZUellBZzd0ZWdaa3dmam8yUzltYWhTb1NleEtkRVI0TEt0?=
 =?utf-8?B?cUh2MCtOYW8xODB2Z2tTT25sMWtlVU1EeG4vZlVGcXlzU20yaWROZ3NvNkh4?=
 =?utf-8?B?VjYvdGpnYVZ2TnBjbEJCcEt0aHFrMmRPMThFSktVT0pWcENYMjd4bG9lYU54?=
 =?utf-8?B?dHlvK2xCTWJlbm53ekNvQVJYRFlZcWl1Q1pQSURpSkFKV1BHVFBkN2tBSGt1?=
 =?utf-8?B?enlhWS9hMTlqdVhMa2xYa1hSeDd5bkJ6L003T2Y2MlYvWGs2ZUttNVdDQXdl?=
 =?utf-8?B?YXJySWlqTnQ0ZVVkNll5eG5vOW82WXAzYUNoQTdkdG8xYWZ6YXBFSko5TEVP?=
 =?utf-8?B?bUVyK1pJK29vdHlld2xYeHBkeWRKYWJkaEVrM293UTN4L05aRUdIUld5RmxL?=
 =?utf-8?B?dE94L2ZINHpGdHZPSWJpaHUwNEdjS1UybnZnWHJPNGZhL05MdmVoQm5hVVls?=
 =?utf-8?B?MjBiQlF6a1dlZUtMTjNNTkdmVWJ0ZDNwUlRjajY5TFI5VklrRENqdTU5U1FH?=
 =?utf-8?B?QTF5bjJSOE5TY3FYUVJKQ0pkVG1QcTA4ZkJNRmVtQWtXcUlRbDZydGRVOEZ3?=
 =?utf-8?B?cEkrTGhwS21MZmNRdDlBZXpnOW5sdjd3aExDK0cvdGpVR294cWdxalJkTytI?=
 =?utf-8?Q?U4rBnq3GRZVys3gQWJVzbd8N/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3003df78-509c-4c2a-d554-08dd3f0db46f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 20:03:45.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqPh822fHSOYS79clFoiABTAIJBoSCfIpVRwP5Hpacb6EPX2S3F2JP4tbimVQosiGCW4GkIwgRoDBBVrqzrszw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6417

On 1/26/25 05:36, Zheyun Shen wrote:
> On AMD CPUs without ensuring cache consistency, each memory page
> reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
> thereby affecting the performance of other programs on the host.
> 
> Typically, an AMD server may have 128 cores or more, while the SEV guest
> might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
> to bind these 8 vCPUs to specific physical CPUs.
> 
> Therefore, keeping a record of the physical core numbers each time a vCPU
> runs can help avoid flushing the cache for all CPUs every time.
> 
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> ---
>  arch/x86/kvm/svm/sev.c | 30 +++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/svm/svm.h |  5 ++++-
>  3 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1ce67de9d..4b80ecbe7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -252,6 +252,27 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>  	sev->misc_cg = NULL;
>  }
>  
> +void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	/*
> +	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
> +	 * track physical CPUs that enter the guest for SEV VMs and thus can
> +	 * have encrypted, dirty data in the cache, and flush caches only for
> +	 * CPUs that have entered the guest.
> +	 */
> +	cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->wbinvd_dirty_mask);

This causes a build failure since kvm is undeclared.

Thanks,
Tom

> +}
> +
> +static void sev_do_wbinvd(struct kvm *kvm)
> +{
> +	/*
> +	 * TODO: Clear CPUs from the bitmap prior to flushing.  Doing so
> +	 * requires serializing multiple calls and having CPUs mark themselves
> +	 * "dirty" if they are currently running a vCPU for the VM.
> +	 */
> +	wbinvd_on_many_cpus(to_kvm_sev_info(kvm)->wbinvd_dirty_mask);
> +}
> +
>  static void sev_decommission(unsigned int handle)
>  {
>  	struct sev_data_decommission decommission;
> @@ -448,6 +469,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	ret = sev_platform_init(&init_args);
>  	if (ret)
>  		goto e_free;
> +	if (!zalloc_cpumask_var(&sev->wbinvd_dirty_mask, GFP_KERNEL_ACCOUNT))
> +		goto e_free;
>  
>  	/* This needs to happen after SEV/SNP firmware initialization. */
>  	if (vm_type == KVM_X86_SNP_VM) {
> @@ -2778,7 +2801,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>  	 * releasing the pages back to the system for use. CLFLUSH will
>  	 * not do this, so issue a WBINVD.
>  	 */
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(kvm);
>  
>  	__unregister_enc_region_locked(kvm, region);
>  
> @@ -2926,6 +2949,7 @@ void sev_vm_destroy(struct kvm *kvm)
>  	}
>  
>  	sev_asid_free(sev);
> +	free_cpumask_var(sev->wbinvd_dirty_mask);
>  }
>  
>  void __init sev_set_cpu_caps(void)
> @@ -3129,7 +3153,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>  	return;
>  
>  do_wbinvd:
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(vcpu->kvm);
>  }
>  
>  void sev_guest_memory_reclaimed(struct kvm *kvm)
> @@ -3143,7 +3167,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>  	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>  		return;
>  
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(kvm);
>  }
>  
>  void sev_free_vcpu(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd15cc635..f3b03b0d8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1565,6 +1565,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	}
>  	if (kvm_vcpu_apicv_active(vcpu))
>  		avic_vcpu_load(vcpu, cpu);
> +	if (sev_guest(vcpu->kvm))
> +		sev_vcpu_load(vcpu, cpu);
>  }
>  
>  static void svm_vcpu_put(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 43fa6a16e..82ec80cf4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -112,6 +112,8 @@ struct kvm_sev_info {
>  	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
>  	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
>  	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
> +	/* CPUs invoked VMRUN call wbinvd after guest memory is reclaimed */
> +	struct cpumask *wbinvd_dirty_mask;
>  };
>  
>  struct kvm_svm {
> @@ -763,6 +765,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>  int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>  #else
>  static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
>  {
> @@ -793,7 +796,7 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>  	return 0;
>  }
> -
> +static inline void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
>  #endif
>  
>  /* vmenter.S */

