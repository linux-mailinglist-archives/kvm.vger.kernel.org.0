Return-Path: <kvm+bounces-25186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 586029614B4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 18:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D55A1C24178
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 16:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBE81D172C;
	Tue, 27 Aug 2024 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mHDV3Yrg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E391C9EC8;
	Tue, 27 Aug 2024 16:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724777705; cv=fail; b=E5qIoilSTvaWbY8RdfoW7D75SgjJ5wp1ogxZh4NrYizELjgJzboPPlH3ucwFUUBpMIoT6YYmvHkHJKQn7YN4zTenNomGMkazegjNt9Yry27lNADNx/k+3qsdVR+cBbk8GHxXMfNvAmbQJbuAuek880HzNVvWrBaU2Of1IjRgxiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724777705; c=relaxed/simple;
	bh=SdCrSuhZcgt2rEeujMcIRVK5AB/m+e97HqGhzilXMy0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kl1M11Ocod0l4LMzwdBW31UoBwmAtUO7JJxooVhQ3tHB3waN7V75pQEnryGYlujtk/8s9krvoFVAyCkLbtkBsBww6zuVap8fPTndBBkTdv5u9WLRB35M9orFLBoOLAJ5CN8bjLwR5409XDkcb4j2qtu7F1wVCc6d65MMzJZeUgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mHDV3Yrg; arc=fail smtp.client-ip=40.107.237.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KX1BWkdHp08vtNn3g2iIX3pz833DVCpsXPI3twhO87nbeLVYFWQSB4SKerH7ostDq7NaxkLOZ9qmDVDtEaKzINwW/6+IulE5GQb8Vp4E+ftnJKaAIPkWTjh7HtZWgBYiIE8tqHP4WxENwb03Pr2wRWA0k+n0pVLn3NEuD1ECo/k6AFMqeG31h3UcpRFGk4XWBzQlatRJvsFMXvKB1O1S0KdnTkO59M8+y7+EIAXseDWh1mDqb4f54w7QUMBwnIq8VhJ3GnnQ7UDHhoHesCshW+LXBiZx5UjYoR3PyUk7sri+0IynUJq/hWuPXSfFvVqOf7yCzTZImrq/mwr7iUTu9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmvezFKBz5zIlmZmarmX7jxTtlh+sDy6RrwndLeRKOA=;
 b=Sz4CXAo4TfXdaMiuch7ZtRzdLW/mDntbJpKzP55aHfUmwj1qd+EjLzPrY/mntcwq4DpBYmbQHdLdkz3sy9f6GnqluveYvCyZ2aHi6/7jc7TS1s5QNTzULjuQh9Ex4fBEL3yzGIKL0QPxeuNZWEfNmbJ5jfj2d9Rhsfs56kbBtSCEMZd0UzOjCv1YXLkQiRzH8QVnebc2GAUtsciVnzEqWNSnTpulsoFPt+eNPmHvxYHv4Tw42qWqKHC4JyPXs9mUNeeIOYrP67087gkEYQ/ul/X5wfcjM+4qzlrXDNfTlCemuoynzKKGoHixR30Y1hrFYw1Evx/SHCU/KMeWR1DDRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmvezFKBz5zIlmZmarmX7jxTtlh+sDy6RrwndLeRKOA=;
 b=mHDV3YrgRYE69uA3PyblRFO+Z1fg4D+LSGzWMBrULRZMFj+iskeh88GjEqiBM9tKnr3z4DY+03jpd0FkUEREcTHSlc6DTcoEalHPBdtOn/GABiHD8e3sevkBnh5ajJWwmjFEVPLGJiQJ6CuSJRua6NbcffkxTc9Dg/DXq5TBiJcEjSRrbE+WTPDkULODXZcUlNngejQ2WhC9X+td/YWQTuOHGbWANcfnv+2aH2UkBC2fipHtff+OV5UVvGHz/4hiwa2aD42Rf1+LOc2zz9IEM5hDHfBQ6YuFZKiVn4Ioelsf7wXr1E8Omi5WTS2++qzqMthcT3+c9cphdR7RPETuaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by MN0PR12MB6054.namprd12.prod.outlook.com (2603:10b6:208:3ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 16:54:59 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 16:54:58 +0000
Message-ID: <f7479a55-9eee-4dec-8e09-ca01fa933112@nvidia.com>
Date: Tue, 27 Aug 2024 18:54:54 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
To: Jason Wang <jasowang@redhat.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Carlos Bilbao <cbilbao@digitalocean.com>,
 mst@redhat.com, virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 eperezma@redhat.com, sashal@kernel.org, yuehaibing@huawei.com,
 steven.sistare@oracle.com
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
 <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com>
 <fd8ad1d9-81a0-4155-abf5-627ef08afa9e@lunn.ch>
 <24dbecec-d114-4150-87df-33dfbacaec54@nvidia.com>
 <CACGkMEsKSUs77biUTF14vENM+AfrLUOHMVe4nitd9CQ-obXuCA@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CACGkMEsKSUs77biUTF14vENM+AfrLUOHMVe4nitd9CQ-obXuCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::17) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|MN0PR12MB6054:EE_
X-MS-Office365-Filtering-Correlation-Id: 0299e580-eeb1-4418-7f5a-08dcc6b8fc31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ck1oODNJMGo2M2lpcmR3Um13R0hkRGJkRTVjcENSUitxaHBsaTByTDNNTmY4?=
 =?utf-8?B?MVhLVXJHQ2NHOUYyekRZbGVnK0tMYkF1TDRlUm5QOUdnSTUyMzUzT2hwZFVo?=
 =?utf-8?B?amNQMTk1RnR1YSs2c0IvMUFGbkdRRmh4RGFtZDhrSHR6anBBQ25rd1JVQm9n?=
 =?utf-8?B?aytQQzM3Q0ovVy9PSGwxd1NtZ3N2UGZ3aVBkYVBVSUc0VmhMWWx3UUlDWU1p?=
 =?utf-8?B?K3YydHhyTk5wcldwbTVqZXp6STB0UnJnRHZGODhvTU9YcS9rbXN1b3JYUy9P?=
 =?utf-8?B?eUJxN2lrM01jRnBnN21Ma2xQeGtpTThWUWdRbml1UG5RV3FMd2Z2ZEE2eDNP?=
 =?utf-8?B?c3MvWFhaK3BiL1FwVnV6Qmx5NmRmQ01DZ1U3T0lrK1hEU0lBTjVnZFJES0ly?=
 =?utf-8?B?SmE1YzVGR1FCQk8xQnphKzcxM1AzZXhSK09mR0xLemZsQ3pZcTVnaTlQYVJI?=
 =?utf-8?B?WkF5cUdoS0NPZG1IU0dNV1QvQXU2MG5jc1NDRTBra0lMbFRRRUVQeDFwaWV4?=
 =?utf-8?B?bEJJY3pJamdZL0ZURW9XNkJXTHNnaVIwTlVvREZoTTVXRWwxcVRtYkJZL2Q4?=
 =?utf-8?B?eXI2SnZvbmlJQ0RxWnpKd0tjU1dIUERmSy9pU0t1My82cjRVN2xzTVJ3YWQz?=
 =?utf-8?B?Y0RITSt1QTRmTWQ5VWp0Tk5YNG1zMVV1ZndTUmlGcFduTUNuMFR6UXpxQ05u?=
 =?utf-8?B?TzVUV0hMREpKeWtwZzlSOGIxTWRDYUJOUXByb0xnODZNQ0FvaC9VbGc4NDU1?=
 =?utf-8?B?Q1hvdXczUVhoSVJwMVhwWDhoTXJkUWR4dWJoVm9VTWdMdWN3M0NNQzEwTEJv?=
 =?utf-8?B?MnI5V1dNTkl5MCtZZFJjc2tlMmZKZ05BdDVMNDloenJwbFNFYVdzeVRFSmFH?=
 =?utf-8?B?MnFRVzhNYTFjT0J2YnlETXBQaGJyZEg4d3BQY244bmlQNm9DOXUvTDkydUxZ?=
 =?utf-8?B?K00rWVVaVnZ6WktJN2lIeDYzUG5sSjB3dnJIUXJkc1JHR3dwZDM3QlBiZkJ0?=
 =?utf-8?B?VUlzRnd4WmNNWWJ4dlBERFN1WVptYTd6SG1NS2pkK1lMaXVEV0Q3MXYyWXI5?=
 =?utf-8?B?Y3VXN1VvQWNiS2ZORVhEdTEzeGQ0RTdDemNERitybmhjOFd1Z1R2QVhHYTVE?=
 =?utf-8?B?R2hPWUNHUkF1ZUtQUllCamo5d0Q2YStPMHdkT3JtSGlzcmFnV3Avek0vcVRj?=
 =?utf-8?B?NGlGaWNtUFJwbE9BdEl3RTlYNkdZZ1RSVmwzeStGSTRsbUp3eEc5aG5nTXJN?=
 =?utf-8?B?WGNLRGJNWmI2MW11ZUVwR3hHM0JvWnZKS0pxa0VwODA0elFjY1RKTTR5cFpW?=
 =?utf-8?B?djV0akE1V1M0aVkyR0ptN2xQMVcrK2NCUVFnbnlscE51aEpwZjBwNDNmejdG?=
 =?utf-8?B?dWh0YXMxTW1Lb1BNVG9sWUZJdVRRUzVKZTdkRjF2NVU0amdYY1FGZTJVUEhL?=
 =?utf-8?B?YnpzcFRZZTk0Rk82bjlzd2RIdWpCU2NtNmswRUl2bVlJbGZ0S2hweC83S3Ji?=
 =?utf-8?B?Zi9maEk3ODRpdU9SLzc0NFhyeE9vR0wzbE44ekp4dG9vZ3J3Nm5ZTDhvWHR0?=
 =?utf-8?B?NlJQdi84dDkwNGlEVXFOcEwyV0pnOExwaWFCQkozNzVKTkdqb0N3ZEhibGx1?=
 =?utf-8?B?Ni9DcmRKdkpyeWVub1BsRndQTFN5YVBPWGhEY05HNE81YkFJa3pMblZVbmsw?=
 =?utf-8?B?dE1yMnBBRDNRV3RxUC91ZXVqeElPTlFUMDl5WGJHZXdRbzhpNXVLU0M4b1Nw?=
 =?utf-8?B?UnNMWW95bWthN1JoZCsyWWZRaTFrQ1pnSlJTZTY5ZTlMdVk5bUNsYlMrdjF0?=
 =?utf-8?B?OVp6QmtFdCtnNXRuYVpiQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTN1SHJLODU1Slp2K3dKaldVYXZ2Ync4djBXR3hJemRMVWdiVlBwRkRUYlF1?=
 =?utf-8?B?ZmV6aWhlQXN4V2VndXRUWGhpZ0taMVNhZzRnZXRIWURZZWJZUnU3akcrV0hu?=
 =?utf-8?B?U2pKVFdCa2tZWGI2eHM4eC9NdktwU1pZTGJpRUw0alVKYnNhTGRWVUtVaVZL?=
 =?utf-8?B?UlF5VHBpTURyeGdvd2k4MHNycExIK1AxMktSc0loZEgwcmVUNlp4eHZmM3Yy?=
 =?utf-8?B?dkJCMnF3TXpjS2t1WlQySllINnAzQWE5VE1EUkM2QWJOSGtxYzdneFFRbW5z?=
 =?utf-8?B?L0JmRzVXc213dHBjQ01XUzdPTU5CeFRRUEtUem16enVCS3hUbWFBcnRCTGxM?=
 =?utf-8?B?SWRGM00rUGV5blFSeDBRSC91eXg3U2ZLK1ZDVWJsVkJUOHpZbjBMMGpkV1R2?=
 =?utf-8?B?ZmpnVFlGSnp5MFpvK3QwU1ZJaDQzTURhRG9xekJuZkFuUGQxM1kwcG0rdFdE?=
 =?utf-8?B?V1pLKzVlM1lpdEdqTTFvYmJGRXJQNjRNTlNFTFhiSEdGblp4aTdlQjR6UW45?=
 =?utf-8?B?UEtYREM1SXExQWh0ZFBSZ2ptYm50bFpsd1FWaDBWUEdzVmMxV2M1b2RUM2Nn?=
 =?utf-8?B?NVdnbTJPZUlzTEd5ZkhlN2J0T0FURm8zck0vVTRQNXZBdnk2clVXK1ZjWDZ6?=
 =?utf-8?B?ZUIxWDhmRnkrdk91Y3YvbW1xNjZrWFJLekU5aHRHWEUvNTRseis0VHJzYytm?=
 =?utf-8?B?VWlUNTNWZExqZnViSExYdlFxS1ZpaVF5VHljWXpCVXRmcWtSamdMcUMyNDVH?=
 =?utf-8?B?U1VMclJYNlpjMCt1YXdNdE5MalNaMkhIRnQwZkJ4elMrNGFNMWJQUDdPaElG?=
 =?utf-8?B?czBlV3pFd05xRnpkb2Y3NjlhemwrZkkwR05Ea3lnbG5EUzJQdzRDOENQaUpM?=
 =?utf-8?B?cFB1VkhvL2xRbHg3bTZLM0pDS2t1dldXMTByaFloTHNWL3FaMTRTVENMZVIw?=
 =?utf-8?B?cm5VNmIrV25Rb3dkN3RlOWMyWGh2dklrcFdtRG5qQ0Y3eUFsUDYzU3lXcFRP?=
 =?utf-8?B?WGdLV3NIaXJtZGlPRHlMZmhnQURtRzZZQzZZaVN6aTZUSmF3WXEvM2FuS09I?=
 =?utf-8?B?MTFkMndBS3dBY3RDRndwNkozM2tOK3llY3hvTVlxMW8zNnhuN2E2aUN6SklG?=
 =?utf-8?B?eW5DaG9lOXp4RkRNSmMrZFNUdEtSUDladnB5UDNPSHdScGpZNzBadVovcGxt?=
 =?utf-8?B?Z0JnQS92TW9UcUNKNUJXRWJ0TDAyVGdON3VqdHZBaXVSNW1WVnBRODNSeVJz?=
 =?utf-8?B?cG5PbWNZdWs0UENhY2VwM0tkaC8raWNvN1U4Q3Yza3FhK0hTUVBTNkVrVXRN?=
 =?utf-8?B?aU5tTENuN2VYcGppKzFpS0JBRWYvOGNLd1dXUHdwYlV3STZPb2k0QmplbkxH?=
 =?utf-8?B?cjB3SnMwQU1yUFdXVVpNR1hvdzJpVEFCQWRhK1hqS0hwUk5NOCtscmZ4ZHF5?=
 =?utf-8?B?c1c3V1E5M25lZGwvMkRJT2ZvK2ZBRlh4d2tqRGh4M3crT200cVBDcE15aFRp?=
 =?utf-8?B?bnNkT0RYeWdLUDJNY2pjTEVpNHBOWUlaTm5aeVhvUW80Y09UZlJ3ZHlBem43?=
 =?utf-8?B?S1hER1lqKyswT2l0RDNyQm5EVWJsSDhvVVJCL0QxMzNSUUlSOXpkVkkyb2Vu?=
 =?utf-8?B?R1ByMDdnMGszTGMzeDlHbWk1Q0dMQzQ5UlBLelBFNGU1TUlCdXB6dmNFZ1I2?=
 =?utf-8?B?NFZheU5BMHhEQXhXbStoRGZsam8wRGpFNkRFa0U2b2FQRlNTMmZFNkpZVE9p?=
 =?utf-8?B?NlMybjFhYXNWeTZ1NmE1cE9iUEdqRFNhZkFvbi9mZjJLRnlXN1N0aCt1d2N0?=
 =?utf-8?B?OTB4QXFZNUZETHV1OWRUUUtvUXBmcjRKK2l3aGswSkNzNWRsTlVveU1oQUNM?=
 =?utf-8?B?bTZ2dHFOS0dRd21aTncyVjQrTWJ2TXk1YVRUbjFCdGhpbDY1bjBEZ0w4SGFC?=
 =?utf-8?B?cnBLY25JdDVpWG5uYU1ZNHd5Rm1jcDVGR0NoUXRUMHFPTStUdTVJNGlkbWE3?=
 =?utf-8?B?QndIcG4wbUJrcjl6UEUxV215L0xTNXlEbkFUYytVUzNCRnhJN0pNTTk5d3Q5?=
 =?utf-8?B?OWx4bTlkVHJSdGx4Yy9tajZoVDhtaXB5c2ROc2V2c3pBNnZZNXhsVlk1M3Bz?=
 =?utf-8?Q?uT+Abh1oCfaGiJS5tv57fUs5v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0299e580-eeb1-4418-7f5a-08dcc6b8fc31
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 16:54:58.9449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3d/r6tGNInfqBRf0NUb/LlTXEpxeOg9Jv9HYx2MYkatTCVRVaUeik83adr1FHyc/7CBalaccTLiinY32taZqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6054



On 27.08.24 04:03, Jason Wang wrote:
> On Tue, Aug 27, 2024 at 12:11 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>>
>> On 26.08.24 16:24, Andrew Lunn wrote:
>>> On Mon, Aug 26, 2024 at 11:06:09AM +0200, Dragos Tatulea wrote:
>>>>
>>>>
>>>> On 23.08.24 18:54, Carlos Bilbao wrote:
>>>>> Hello,
>>>>>
>>>>> I'm debugging my vDPA setup, and when using ioctl to retrieve the
>>>>> configuration, I noticed that it's running in half duplex mode:
>>>>>
>>>>> Configuration data (24 bytes):
>>>>>   MAC address: (Mac address)
>>>>>   Status: 0x0001
>>>>>   Max virtqueue pairs: 8
>>>>>   MTU: 1500
>>>>>   Speed: 0 Mb
>>>>>   Duplex: Half Duplex
>>>>>   RSS max key size: 0
>>>>>   RSS max indirection table length: 0
>>>>>   Supported hash types: 0x00000000
>>>>>
>>>>> I believe this might be contributing to the underperformance of vDPA.
>>>> mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPEED_DUPLEX
>>>> feature which reports speed and duplex. You can check the state on the
>>>> PF.
>>>
>>> Then it should probably report DUPLEX_UNKNOWN.
>>>
>>> The speed of 0 also suggests SPEED_UNKNOWN is not being returned. So
>>> this just looks buggy in general.
>>>
>> The virtio spec doesn't mention what those values should be when
>> VIRTIO_NET_F_SPEED_DUPLEX is not supported.
>>
>> Jason, should vdpa_dev_net_config_fill() initialize the speed/duplex
>> fields to SPEED/DUPLEX_UNKNOWN instead of 0?
> 
> Spec said
> 
> """
> The following two fields, speed and duplex, only exist if
> VIRTIO_NET_F_SPEED_DUPLEX is set.
> """
> 
> So my understanding is that it is undefined behaviour, and those
> fields seems useless before feature negotiation. For safety, it might
> be better to initialize them as UNKOWN.
> 
After a closer look my statement doesn't make sense: the device will copy
the virtio_net_config bytes on top.

The solution is to initialize these fields to UNKNOWN in the driver. Will send
a patch to fix this.

Thanks,
Dragos

