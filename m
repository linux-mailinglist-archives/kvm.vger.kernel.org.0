Return-Path: <kvm+bounces-23841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5745B94EBB4
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 780E11C2166A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 11:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F23E8175D36;
	Mon, 12 Aug 2024 11:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h6/HK8rr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1413A43AA1;
	Mon, 12 Aug 2024 11:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723461724; cv=fail; b=FmE42UH3b3YVVrenZESqygD6N4p+E3ila4xvJqRp+6NY9Ft9wCNbr6Es7oOi0Pngv+16at9UvXhtEHZrQvfK/Z4cLoJynF6U8ljH1yRD8ggtxoILEnqlRZqHvxSATDc5leyQRVErEAEjMLcMY8KLqEsxUZjdcoQK8znL7MPcKmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723461724; c=relaxed/simple;
	bh=x+XmdB3laKfSMJMuT9AHlKEPKodiwoS7Iz8IX4PPjvY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SHFccCHr29CvwuNZ6XHSvpCSi+lCRkkkJHFX4U49RnINjeaiqS/G2dQitqc+mHm6IUM/2Oag8QF+ZQuu2KnvdGD0p/QLTXMYGxwgMYNXgV8rRY4gagUI033ewA5HqNmDzsSLnvzWom+po7IL+NJcSulY9kbfZrhjXdxkRAAN4Ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h6/HK8rr; arc=fail smtp.client-ip=40.107.236.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hmi5GmYF7yfBdz2Wm5Bnt/Hye5GHXmHi3JFtmOoVxLLnJmmEz63xow1xm2RXsTGvtrn0BRiNUTfwKu7EVEpXtNviS8Ti1Gc3ThnWTtP7wu0LSgemjfEUnNNZf2JoND9x0oDzS+Wii1Oa2uIorZZO28MbrA0QB0PBAbvbbtGOaMjsM0JU92M0Wlgnk4UR3bGkAJyXMkaCxviw/Lz26/xGzI4qyQpI4Qrljca9uHuiTHpWatFN3x/UhfxMZgiV2+FUUvFXn21rnEH2zaVBM7QsUD5SlcEPKgweylzWBwpcXct9r9SGYnrWpsctLW6cII08aMhUFpxe5OTUn80Y/m47hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yL3D89ky7ULOfO2Qjcu+KYRcTVVdH47jsYBD/rH2q/I=;
 b=JmA+K/7wFuvGGTec3UNLtqAK8eAu6M7osSRL4ns+xiNX3Uv8toZUa/pk9ooTf45ZiinlXYtGU5XEl5puS02HKmEvC/8DNDMdDJIz8mZ9QGAd4KrfFoelds/KhRok+lCVCZ6b7Pe90bsOSi5iBYc7CNiQVSG3Dsr0ha2BTRw1ehiCoF4ol3Y2q5gg1+7S8fN/h+vQxsleCnee6iXh1MuBjLCGLW+zqSDKV8LUnGecvEkB/FmV0PalMK17/4al3aMmbxGz6LFh1VJc4PGx4TYadAX+5X+hfg0KNSXk4etkkdpLZUvXcAmf/G2LSWpQ08i+JL9s5yTSO12zudtmSFTiEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yL3D89ky7ULOfO2Qjcu+KYRcTVVdH47jsYBD/rH2q/I=;
 b=h6/HK8rr0A9hIHSW4rRS/GMhmz1k30LK36H8aOsmsRGW5R0CB2hpF9lnvP6vZMBm2cll2RTvZTYHZVFoEl1MsgyKZT2oyggh+cyXHvsD1J+pn6tyfTSJKQiroNEIRElWd/PCEAxjsLxGa33x5e4fCyAy1JaBERYnbX6U+Ike1nXEVFah+6I/rEhF6NFhqZMHUuANPFfNFemP2kHOcVXlwPuVax/4ymQpK5CYwaxdV5Q1FIR3kYdJIiTu0H6O4RvV6r2e76y6TZa+TuZw93bUaF9RCOxiPVgNgfiHCKO45qmiK5fOlpPBcHph6W4KEmlGRKnmzBBDNkeXeHhI8NPz8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by PH7PR12MB5595.namprd12.prod.outlook.com (2603:10b6:510:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Mon, 12 Aug
 2024 11:21:58 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%4]) with mapi id 15.20.7849.019; Mon, 12 Aug 2024
 11:21:58 +0000
Message-ID: <ede5a20f-0314-4281-9100-89a265ff6411@nvidia.com>
Date: Mon, 12 Aug 2024 13:21:54 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] vhost_vdpa: assign irq bypass producer token
 correctly
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, lingshan.zhu@intel.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240808082044.11356-1-jasowang@redhat.com>
 <9da68127-23d8-48a4-b56f-a3ff54fa213c@nvidia.com>
 <CACGkMEshq0=djGQ0gJe=AinZ2EHSpgE6CykspxRgLS_Ok55FKw@mail.gmail.com>
 <CACGkMEvAVM+KLpq7=+m8q1Wajs_FSSfftRGE+HN16OrFhqX=ow@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CACGkMEvAVM+KLpq7=+m8q1Wajs_FSSfftRGE+HN16OrFhqX=ow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::16) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|PH7PR12MB5595:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e54a3d1-af2c-4bbb-e09d-08dcbac0fadc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmFHNFJHdnc2OFpJUVlDcDdSbmp3dnd3UVRGSUwrT0U3cWlNNDVQRGpzVmZS?=
 =?utf-8?B?YWtSbTNuazlyRWxqam9UTkVHMlBTZDFMbG1oVnRwc0hnWm4vVEdpYlNRdVY3?=
 =?utf-8?B?TDd5TnNZbkFvY2owN01qa212ZUxDLzF0QkZvSGg4NE9XbkNsSG9TYml1V3g4?=
 =?utf-8?B?czRXZ3k1NENUTTJQc2ZydGtzaVc5bGVOV29zRURrLzFNYXZIbkVxTVRQMFJH?=
 =?utf-8?B?NlFZN0UzR2hvb3N1T28xWlBtWS8vRjI2ck5JcWNIc0NlWms0V0VnZE9NeHF2?=
 =?utf-8?B?ckl5dFowUUgvK2hlU21Za3dlUHVqQ040SU43L1kwejQ0aVlLcjE3ZjBKMUNq?=
 =?utf-8?B?YWRMaUtrTmJIVjZxcWJ1OGI4N0NpbU12a2FGY2FLQTZkc3pybjUvZ2t2Y2Q3?=
 =?utf-8?B?ZWY3cnh5MzVtMlo3UjNsOW1hREg4cHBLK3lwSm1neWZzcGFHUDUxZGNEenZS?=
 =?utf-8?B?VVBTM2hCamZaOFlkWVdDNVNWZ0ZYNjNaM2dyMk9aRkNTZm9EQ3VJUVlKa2xV?=
 =?utf-8?B?a0dOVzNqSTVjUU52QTBvaGFVL3labVdsVjgyNERHczVnU3ZwL1h4U3hWWFBD?=
 =?utf-8?B?NUdRaXhpMzVmMVZHRXBwV0grTjd6WE8zcEhlREhXWDJQOHltVXVqdXBhaGZv?=
 =?utf-8?B?bkhzS0xpV0xuMUFHV3REN2pNd3ZjcUJIbmFUZ3dTY1FQM2VIbFVjS2tSdGhY?=
 =?utf-8?B?MWNqLzRFTVlaeW5lVC9ZK0dBNGJseExFZ25TVFBOY08yd3VIV2lSQS9yWDUy?=
 =?utf-8?B?UW5INVhzanVoL0Z0QXZGWU9DRmw3NHhSeEVycjhkUUs5YS9vdGdTbkR1QjEy?=
 =?utf-8?B?MDJRdmxxaXRFaVhFL054Z0w4ZzU5OEVIa1RkbDBhQXVlZmJ2dlJWTVhNTEZY?=
 =?utf-8?B?UFJSNitjNFIxaGllTC9POTlvUmtUYnI4RlhOZXZTeklmTnAxSm1CSktoZmZk?=
 =?utf-8?B?VWJhcTlFczkwVnoveHpkU2g0QkhzZnZSTlpLdmFFUlh4SE9YUFRoU3J0OUl2?=
 =?utf-8?B?WXh2VWJIdmVyVDM4Sk1OTm01MVhvb1ZxVkNuTXc0dlVraVljNnB5d3J1eVAz?=
 =?utf-8?B?U0RkSnRESEtxREZ0akF6WTZma01MYmU0RWI2bmU0SEcxQmZja1JzM3JJdHll?=
 =?utf-8?B?UnNIei9OYjNRYVF6djR3cGp1S1diMndabWJra3Q0VkxlYWk1bSs2Rm9nRUd0?=
 =?utf-8?B?K1N3NnhRR2RCL29sMW5tRzcwUmthdzI1OE1SUnBuTG5hNzROeTE4R0lUQVJC?=
 =?utf-8?B?c1JrZ2hhRXpHaEZ4NmVNTGRVRkVIZFQrdUJDZTBKVXJDNlZGdXpva0VRR3lO?=
 =?utf-8?B?RkFRUEJnYjhlSytHQmZKeVlpMlhtQXZEQlpjVTFEZDJzUmNyQm5tc0k1VXlU?=
 =?utf-8?B?RXpzQ0lmOFNpamx5aFBPejYvWEhtbjVKcEJyWG85RXBIRHNWbGF2bU9Mb2No?=
 =?utf-8?B?b3BSU0pvOWZkdWNpTzVzNHZBSFNjUjBpMkZpQjREQnRJTTNrd016a1gxK2Fa?=
 =?utf-8?B?ZHdLU3YrbkF2N1Q4NlA3OGxMcWhBMjRrZzZNYXdSekdYNjFQRU96RUhOclhp?=
 =?utf-8?B?OWxIeHJVUlNKNE5pcE5JT0tFeElIam1RVzVBbFdVNUNTZzF5YmRYa1RzSWxY?=
 =?utf-8?B?ZUprUUVJWlUvRGZVZ1gxbGRlMkpReGlyLzNSRDZMVWpYSXN2WnVHcFhkd0ZP?=
 =?utf-8?B?amZtbUVDSXVNRWRQRSszV2hzNE5hbDVjRCswaVcxRC9qcWt4RDBOOXVEZmEy?=
 =?utf-8?B?WFVVREpxVnlyVk9VblRiVStXN0xWNTkzditOanlRSnQ3a2RoaEVaLzMvek95?=
 =?utf-8?B?V1k3TkRndXUySzYyeEZOZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWRBdVk3Mm92SU81UlUxcWhwSVZoUkRCN3BYM2w2RCs3S253UFRrbW9ONmFP?=
 =?utf-8?B?OHpKSkpJMVd2bDRsSXJ5cEJXWFJ1eWJTTXFHNlBHNHowNVRDSTlWcGlCODdD?=
 =?utf-8?B?bmsxQjZGc2ZiQ0dpS1JpUEI0T0dCN2x5Y2tSL0NWdzZ1K1NGUDZKUWx0S3RP?=
 =?utf-8?B?N3N4VUJveVBha1hKN2NTem15QlJQSkROREFaSUZvZ0NuUGZZZHV5bmkzbWk4?=
 =?utf-8?B?U3pBTW5ZVWZxTTk0VTQ0S21nZWFuMXZJbnlNZFAyTzB3S0VHYTJWRHhaSHYv?=
 =?utf-8?B?d3pobmE5MllYMDBQd1VxL2c5MytZblI1Wi9MU0RHSjZaa2ZvR0ZvV3hqbWxt?=
 =?utf-8?B?ZXQrMnZCYStqVG14OWlEOUs0VWd5WFExcXIvbVFGWXd2WEhRTTdKdFdSdWZq?=
 =?utf-8?B?Qmk5UkdXbHM0UERORnhjQjhyaUVZbnBTWTYyWE5RaEJXRkhlc2h5TmRGYnI3?=
 =?utf-8?B?Z1VkNks4c0pXYTd2L003ODFnSG00RnVwK0taTThmS3Bob1VMR3o4eS9veVBi?=
 =?utf-8?B?ejh6TmVhb254dHZrbForSEZZSGxLZGp2K3Z0NW5jQTJsTldwUzFaSkpmRkJJ?=
 =?utf-8?B?NUtDaCtsWFYzZ0tHMFE1bGRmMXZBMnFNbHBKMDRQSm1IdHpVbi9tZkxWcXJx?=
 =?utf-8?B?dCswbngwWGsvVDhiSk5iQXZuWWt2VzlJM05WNGEyVjFUeUN5YmtOU2huekh2?=
 =?utf-8?B?WUxhK2l1aUl4NFJ3OUpIV29GWGVLaW9ZOVpJRjRWVVpJSU1EdENJM042U3Br?=
 =?utf-8?B?S2lmcjdoVWFWNkNWS3djWnd5TVBWSG56ZExDQytKbTM3NmlkU2ZpTTNSSGN1?=
 =?utf-8?B?RkRRcG5vTnBiYWVWdU5xYldzOWRaR3haTnZ6Z2tzZUI0VFBOb2RjZDlUalpN?=
 =?utf-8?B?bUY3cXQwZk4yclRTeWV5Z2ErcVI5WXpaZVg0Z0xORjllbktrM0Z2WkFlUmxQ?=
 =?utf-8?B?OVRkSnFHbFM3dTB4K2VKMTF0R2N1THd6c1VIRy9oaXhmcWtiSXI2Q2pnWTdX?=
 =?utf-8?B?TzJOMk1rT2JxSDczcjVab01YVWMxTnBKditabHNmZ0tVa1VmRlIrMUNkUjkv?=
 =?utf-8?B?cmpnN1VBTkZ4WlVFZUg0NXBkMDg1WjFaTk5wdXV5bWhxWFFFN0dXQUdzcWI4?=
 =?utf-8?B?SG95UmRPZnkwekpnNUV6VG91c1BCWGgyTllNOTZOYVlwc2d0NFhsWUN4aFRl?=
 =?utf-8?B?ajdMMXBsaTBYKzFHRFZ4SWJKS2dpd1AvQlozQnBCSXUwaHFReFpXVkovTm5w?=
 =?utf-8?B?V0RzT2VVRnpSVWw0QXIvYkJCRkNzRXpGUjZ1TWtZRHIyUHdGRUhEUGdBT056?=
 =?utf-8?B?S3hQWkt3dmJaSmtZM3Z4bUVteE43YkZMeWpJaFU5YWxpeTVuZWVIeEdRc2Qz?=
 =?utf-8?B?UUlVa0UrZlhsSUFtV3pIM25NcS9nWERVQ2lucEtlWFFCMEZ6TnUxUVZLdFBm?=
 =?utf-8?B?S0xSaHQ4ZnFUMWd3eVM3aEYrQ1F4MElKajY2NlFZSzVPNFA2aVE4MXl4ZGpx?=
 =?utf-8?B?WmdBdVlQOFN6Rlg4bUVCYlIvNmRYVjg1NjloNURCbXJmUlQrQkxuYWl1OFVR?=
 =?utf-8?B?dWVhMGNqa1d4QW1ETHFzMnkwRkZ0Z2RIZWZMMlQ3V0Z3Mk5qclJTOEtZbmth?=
 =?utf-8?B?VlhzcUVMTVYxZ2N2dmRKVjBIOG5rNGl0UDVhZWNyVjNTd2tPOG9KS0dNZEFK?=
 =?utf-8?B?WXgyTEFGZ1FMMEZ5Umw4V2FZdlhjS0NlZGVGY3B6V0JyU3FST0prZFpTcnAr?=
 =?utf-8?B?eVlqajRwTG94aXltMTlQVzFYeHBQeDcrdzhlZlBzcXdQTDRSdE8reHhtTVFi?=
 =?utf-8?B?L1VpdEhVRzIxUGFTeVQvNHJxTjZZSkhyY2pjZTc3Q0UwTmU3NmtBeU4wNy9u?=
 =?utf-8?B?bGRLdzlvNUFPWnVTVi93ZkJVRVRva2hPeDhKRE1WWHVzWWF2R09Gb1dUaW9L?=
 =?utf-8?B?WSt6cnp1YzJ4U3lnV3BsZEtTSEJsbmdtd3U2a0twdFpkZ0dkU253eGRYOFlq?=
 =?utf-8?B?N3VWWi8vbGZjMTV2R2JkeUx5RkZ5TnMrcWlMNVczczVhd3UwRm9pSmd2VC8z?=
 =?utf-8?B?OFZrR3JNem9pZ2hmNjUxMHF1SlZBYVhnRDRWL0x4Q2xxM0wzSXRRL0E1NnNG?=
 =?utf-8?Q?trkxjOGh/bq/j1cc+QBA/apX+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e54a3d1-af2c-4bbb-e09d-08dcbac0fadc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 11:21:58.6979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDPA+NZUEi/cXHqDz8TnOio1bdtYgcT+Qk9VYsjBdj0acgkKtlBiVJ8sS289mSuxANEQLZ8eDClkEzCIS1Joeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5595



On 12.08.24 08:49, Jason Wang wrote:
> On Mon, Aug 12, 2024 at 1:47 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On Fri, Aug 9, 2024 at 2:04 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>
>>>
>>>
>>> On 08.08.24 10:20, Jason Wang wrote:
>>>> We used to call irq_bypass_unregister_producer() in
>>>> vhost_vdpa_setup_vq_irq() which is problematic as we don't know if the
>>>> token pointer is still valid or not.
>>>>
>>>> Actually, we use the eventfd_ctx as the token so the life cycle of the
>>>> token should be bound to the VHOST_SET_VRING_CALL instead of
>>>> vhost_vdpa_setup_vq_irq() which could be called by set_status().
>>>>
>>>> Fixing this by setting up  irq bypass producer's token when handling
>>>> VHOST_SET_VRING_CALL and un-registering the producer before calling
>>>> vhost_vring_ioctl() to prevent a possible use after free as eventfd
>>>> could have been released in vhost_vring_ioctl().
>>>>
>>>> Fixes: 2cf1ba9a4d15 ("vhost_vdpa: implement IRQ offloading in vhost_vdpa")
>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>> ---
>>>> Note for Dragos: Please check whether this fixes your issue. I
>>>> slightly test it with vp_vdpa in L2.
>>>> ---
>>>>  drivers/vhost/vdpa.c | 12 +++++++++---
>>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>> index e31ec9ebc4ce..388226a48bcc 100644
>>>> --- a/drivers/vhost/vdpa.c
>>>> +++ b/drivers/vhost/vdpa.c
>>>> @@ -209,11 +209,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>>>>       if (irq < 0)
>>>>               return;
>>>>
>>>> -     irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>>       if (!vq->call_ctx.ctx)
>>>>               return;
>>>>
>>>> -     vq->call_ctx.producer.token = vq->call_ctx.ctx;
>>>>       vq->call_ctx.producer.irq = irq;
>>>>       ret = irq_bypass_register_producer(&vq->call_ctx.producer);
>>>>       if (unlikely(ret))
>>>> @@ -709,6 +707,12 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>>>>                       vq->last_avail_idx = vq_state.split.avail_index;
>>>>               }
>>>>               break;
>>>> +     case VHOST_SET_VRING_CALL:
>>>> +             if (vq->call_ctx.ctx) {
>>>> +                     vhost_vdpa_unsetup_vq_irq(v, idx);
>>>> +                     vq->call_ctx.producer.token = NULL;
>>>> +             }
>>>> +             break;
>>>>       }
>>>>
>>>>       r = vhost_vring_ioctl(&v->vdev, cmd, argp);
>>>> @@ -747,13 +751,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>>>>                       cb.callback = vhost_vdpa_virtqueue_cb;
>>>>                       cb.private = vq;
>>>>                       cb.trigger = vq->call_ctx.ctx;
>>>> +                     vq->call_ctx.producer.token = vq->call_ctx.ctx;
>>>> +                     vhost_vdpa_setup_vq_irq(v, idx);
>>>>               } else {
>>>>                       cb.callback = NULL;
>>>>                       cb.private = NULL;
>>>>                       cb.trigger = NULL;
>>>>               }
>>>>               ops->set_vq_cb(vdpa, idx, &cb);
>>>> -             vhost_vdpa_setup_vq_irq(v, idx);
>>>>               break;
>>>>
>>>>       case VHOST_SET_VRING_NUM:
>>>> @@ -1419,6 +1424,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>>>>       for (i = 0; i < nvqs; i++) {
>>>>               vqs[i] = &v->vqs[i];
>>>>               vqs[i]->handle_kick = handle_vq_kick;
>>>> +             vqs[i]->call_ctx.ctx = NULL;
>>>>       }
>>>>       vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>>>>                      vhost_vdpa_process_iotlb_msg);
>>>
>>> No more crashes, but now getting a lot of:
>>>  vhost-vdpa-X: vq Y, irq bypass producer (token 00000000a66e28ab) registration fails, ret =  -16
>>>
>>> ... seems like the irq_bypass_unregister_producer() that was removed
>>> might still be needed somewhere?
>>
My statement above was not quite correct. The error comes from the
VQ irq being registered twice:

1) VHOST_SET_VRING_CALL ioctl gets called for vq 0. VQ irq is unregistered
   (vhost_vdpa_unsetup_vq_irq() and re-registered (vhost_vdpa_setup_vq_irq())
   successfully. So far so good.

2) set status !DRIVER_OK -> DRIVER_OK happens. VQ irq setup is done
   once again (vhost_vdpa_setup_vq_irq()). As the producer unregister
   was removed in this patch, the register will complain because the producer
   token already exists.


>> Probably, but I didn't see this when testing vp_vdpa.
>>
>> When did you meet those warnings? Is it during the boot or migration?
During boot, on the first 2 VQs only (so before the QPs are resized).
Traffic does work though when the VM is booted.

> 
> Btw, it would be helpful to check if mlx5_get_vq_irq() works
> correctly. I believe it should return an error if the virtqueue
> interrupt is not allocated. After a glance at the code, it seems not
> straightforward to me.
> 
I think we're good on that front:
mlx5_get_vq_irq() returns EOPNOTSUPP if the vq irq is not allocated.


Thanks,
Dragos

