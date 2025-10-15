Return-Path: <kvm+bounces-60105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CEBBE0A7D
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 22:37:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 56971354F56
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D13330C341;
	Wed, 15 Oct 2025 20:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3PmwDGwm"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011014.outbound.protection.outlook.com [52.101.52.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B6A303A10;
	Wed, 15 Oct 2025 20:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760560650; cv=fail; b=vBt2T0HEc2kqex6B/T6KdEQIkZlcUK6u/PDCp6l1Bktcp5JNef2jXt0CsppJIA+y/DDJkvJwqD5Fa0FsIf854qxtIwsCk0ZvQiwj1i6/j8pAR2oEb9lDjXlH7ASYh1Tk2dxdTjqViiIfuHF/yoJPXWQIeeA19kZRP8Q+ysqFt8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760560650; c=relaxed/simple;
	bh=7kiqkaf27k93+gkzH2rCZxx+/8F1Sl+XSmtU75K9+gk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OjHbW0fJ9+cIXvoNL7Q1O060TGjZ8B5+jK70SA7rk3BTtwuJcqeabR5fVkVBdG5cditWonaxnf0+s0cYEfvGqTSF03x7qn4OwKyBDfSiFTyJ89KSU2FHUSACYfC02DOfaTPCz1rkKaANizKOWcx4j/ehzMiALIgNlTmBpAgZRvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3PmwDGwm; arc=fail smtp.client-ip=52.101.52.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A5xErMSQ4XPS0EgWtfSpK8+V/I6UK1TupiUD6ECF0XLTWHrQ4VASalu/zgzYJYo9gS1hSA8+ZhL4ZNgdhjYORwdTsKlp9tLGQyPP/m+mGMTxJwTZDm51MqJjDGe0BG8at7ci1lh6MBr4qLQIyY5drC/AYdKE00TeVBMUBC+6H5hI7rsSc2ARPJC6Hfrw7FIHAtCiG8y7DaphEMSOpNK7IQ+KLEiYSI36hzSFcFJ0W0CaWRJBhL1UOgi6Nnwdh7fQaw7+Bx+I/NgWFWIzGCxmv6I4+DfjjwbdrxQs0cc4uyOfTdvFdMVICbsAgETGHvu5JJH0spmWEVF1y4TaxDKJHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1GEgfpGEsB0pxBVOWCTcp623rHJxZs++BNltXNkIiA=;
 b=KyfKyKt1aJI5WF1itck52OOX/LZ946EV11fIVRGhpzGZGcQdjosV06R70ZxpmgR1G3Gqb09FdPaVr5LOm7IO/VCqWDOsB+fhieqreOK+fvLOn+K55v2r55fop943qklng5uV5oLiL80I7X9ATmLYDCzFxty7Ef2ms21YggBBcXfWp9OB5FhX+cLKN6q0qfGkLWG+WJ9NxKQpMx+IsbXNQym9LpmK4NOr4uZogf7DxtHMad1uVcyZxSwwcr1/dsrj/2LgBhjuAhxA2I+v9HC2QkDy3wF2RAsLa69hamKcMc2XW2WwLZv+YzxAN1HFyU1dqiTo873blVdgc61Z9AsFiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1GEgfpGEsB0pxBVOWCTcp623rHJxZs++BNltXNkIiA=;
 b=3PmwDGwmqlQsTTuYJV9kR0fEQGC3G+aUlisBJyuBQUaa6JhD+Jz6LZ3ttpamzkhoUdIufzVZv+6+nLl733F7Hrtt4OPXYCR4111/F7rdEO1LxOELT0nl9JL2+n9oWM2yCEQjPWxP1lf4lAzJYLHLFnMRHrl/2QgkkuCcHuyHlXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by BY5PR12MB4193.namprd12.prod.outlook.com
 (2603:10b6:a03:20c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 15 Oct
 2025 20:37:24 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9228.010; Wed, 15 Oct 2025
 20:37:24 +0000
Message-ID: <dcc64b09-117c-4d25-957d-e97ef49a8100@amd.com>
Date: Wed, 15 Oct 2025 15:37:19 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: Reinette Chatre <reinette.chatre@intel.com>, babu.moger@amd.com,
 tony.luck@intel.com, Dave.Martin@arm.com, james.morse@arm.com,
 dave.hansen@linux.intel.com, bp@alien8.de
Cc: kas@kernel.org, rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
 <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
 <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
 <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
 <3f3b4ca6-e11e-4258-b60c-48b823b7db4f@intel.com>
 <0e52d4fe-0ff7-415a-babd-acf3c39f9d30@amd.com>
 <7292333a-a4f1-4217-8c72-436812f29be8@amd.com>
 <a9472e2f-d4a2-484a-b9a9-63c317a2de82@intel.com>
 <a75b2fa6-409c-4b33-9142-7be02bf6d217@amd.com>
 <5163ce35-f843-41a3-abfc-5af91b7c68bc@intel.com>
 <a2961f11-705a-4d75-85ee-bf96c8091647@amd.com>
 <5645dec8-e344-44d3-82f7-327259a53906@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <5645dec8-e344-44d3-82f7-327259a53906@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0125.namprd11.prod.outlook.com
 (2603:10b6:806:131::10) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|BY5PR12MB4193:EE_
X-MS-Office365-Filtering-Correlation-Id: 6641fab7-73f8-4435-2d71-08de0c2aa5e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y3c2SkVWSUViTThKTVV5VEZFcUE4d0VUUkI0N2x5NUQzazVZdjVZdDdKN1hC?=
 =?utf-8?B?WWRIVTFCVDZ3czVHQXZwc2RGNVNZRk1DeUticU9seGw3eWFNTEp0VjBJSEdk?=
 =?utf-8?B?VURvNEp0WTIvUDIwQW5SeEIzK2t3c3luWHZSOXVoTEJ3T3FSMlRRVVdKdXIr?=
 =?utf-8?B?YWVwOEVqMjlUU1B2TnBPNnZ4MzQ0NGVyaDlTNU1ZU1gwVjNnbWpwZFJqbDls?=
 =?utf-8?B?dWMra05iamVlVFA3b0VmYXd5K01RczVpTDVZakZnbk1OTTBmOGRSWVdYcjVK?=
 =?utf-8?B?UU5iblgyVDYwc0pUSEVVTHhseCs2dWFKck5hT0tBRkRzbUZDMVl3RXY2QlUy?=
 =?utf-8?B?SnBmU0hFZEFrNHlvMmhhU29sTjJoUllKRDFmcFJIWVJHdVAwU3RGV05tVFhW?=
 =?utf-8?B?dzNxZjYyMldKWmdKS2J5WEhxTm5FazJZYUJtN244QzVtczJrMWxLVjBHUFRm?=
 =?utf-8?B?aWttUE1jMW41ZDdVZmZWVDNSL0N3eWZzZFlEU0lISjlKcnphS21UNEpFdzRj?=
 =?utf-8?B?SkFqbE5RY1oxM1I5czVQRStsTldSWXVrOXlHbHRkZmNvQWZySjdoWlVXMkg4?=
 =?utf-8?B?WlNiMVlkOVhUb01FQ01RdGRlUFluWHBTTmVPOC90Slc1cC8vY3BrdmVYTjVV?=
 =?utf-8?B?RCtkekY5UUtOcHViT1JhYkFLZHdPM284SnMxaVJwMzFKL0ZPVFlMa0ZzV01r?=
 =?utf-8?B?KzFTRklIYlE0QUhLd1dGemQ1a0pxeHVydWxjQ1FhdUJNbUNMeWtwSDN0dHB2?=
 =?utf-8?B?YmM1SUhwRGNsZXZxUGlLYllTQ3RCZGxiY01PeEZFRTg1cmt5bjd3VUxwQ1B3?=
 =?utf-8?B?L0szK014QkRObUVjYXMrY0p5ZUtBNGZkZk91dXYzSTFTZmVPVTZMbmJ6c21s?=
 =?utf-8?B?UE42NmxMWTVsQ0dmLytWWktVOTNhcDZmdldkendjRWRhSHp1RmxZMGtNWXlw?=
 =?utf-8?B?LzZVN2F4V29McVd0aTQ5UmNFbGZDNDdTZWxPdk5zNUJ2SVFvY2t1UjRqNy8v?=
 =?utf-8?B?WWo0MWdycTN4cjFQaFNlNE5TOTRRM1c4TVA3bGhnekgxVXVKN3FRNFIvNlJr?=
 =?utf-8?B?YlZTNlNVbWFEcjkyaTZzNmEyOWJvVmtXOVA4MDFIemQrUTAxL1JuWGNiemRV?=
 =?utf-8?B?b2tkRXBWT3RvQXhkeW55SDQ0eHdUZDhLUWNXVjVVbUpkS1Y1ZmtMVGRrc3dy?=
 =?utf-8?B?WUw1aStMbGlLaWdKdGJOVklnaWxsRWxOQVFaWWYwTHdlTDdPSHM3ZkZGZ1Zh?=
 =?utf-8?B?QzFiWXNvMFJ2cDF1RlpqVUsyS051ODJtdVlJNDRuZm5adFZyRmlPdzVNdzI3?=
 =?utf-8?B?QkRSWThXSlFGNFlJVjBTQVdkdzRBUytINjBpSndReXdRUlQ2R3hGYlkwVCtn?=
 =?utf-8?B?aVZMNENNQmJxSkV1SS9iYllydStadk11ajJDR1RMWmpkUnBrK3NtNllEN0g4?=
 =?utf-8?B?cTJwMTZzSFl5L0hNZ3FYdTN3cDhZMHByb3o2bThibFdNbzRGbU02OG1uRit3?=
 =?utf-8?B?RWdMa0ZoMFRjK2JpQWJZY29TOXNkbUN6RWZaRWZ2ZGFNUFlvOTRRbDMrMDh3?=
 =?utf-8?B?L1dsNTJiYStSbVBMV0gyTFp0ZG9LS0gxWmY2eXhUSVVCNW1QR2RVaWxjWUlG?=
 =?utf-8?B?YW1RZC85VmhSODFpeHNqOGVsdkNsQ2NxWkMxR1JTUHdBMHJyZTdjOHE4NU9O?=
 =?utf-8?B?Y1lFUzNiWXF1em00UjRpRVBjSFhiUUVYRnZnQ2J0V2taaGVHbzB6aThxdVJO?=
 =?utf-8?B?M1E0VENwUTF4aklrM0hRV0J1T1k4dXphVFFyOXlOUmd2Q2pycjE2ejVyL0R3?=
 =?utf-8?B?U243Rm9kV3VJRFRWQm9JeCtWcmN0ZXpKV0prOG1oR0ZPL1psQi95SlRtcWVE?=
 =?utf-8?B?N29CUG9La0orbnZRdjRTdnhGa2RpcjA5bkFmRDFKL2srRy9JU0Y3dHhNWkhT?=
 =?utf-8?Q?oa+iCLryFjvwPbFeyaALlpuSDKNs8qXz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1pFL0tiQWJQWWhOcnRMNndrWmZzRG9zZUpEQktBejJqVkkxK1ZwT0xaQmFu?=
 =?utf-8?B?MGgvdVVqZGh6U0pqbCtvbnZKN2dBcU1vOWxrNkJjZ0VOaFNyZHZiQjRybUxr?=
 =?utf-8?B?cjFEQWU4MGZqK2NoSkFFMVdWZmJOQkJINlMzTCtCMUtSRVB6cmFQMEZwRXMv?=
 =?utf-8?B?UGdPN1JxMUFxY0V5UGJqRjBOR3Q2SllaZEJJQ3hLRlVyQTltTmZzaUpPL1Ey?=
 =?utf-8?B?cmlqWlNkNy9mM08wVVhBUmMreUhjc0ZOYlRXaWFmK2hxbFdHS0VRL21KOWJm?=
 =?utf-8?B?OXhFYk1ZOTV2MUwvZ3duK01GaFAxUDF3ckF3Y05BY1A3N3g1MUIrR3RtQ3Zq?=
 =?utf-8?B?N1lRTUNVaXkzZHFCSlkrNXNhZjJLeEJ4NUFnKzlnZHN6dnBieHc0aFM3YVM5?=
 =?utf-8?B?cHpoQ3c0K212bzRyWHBFSnhUbHdzZnJXWTVXUnFsL2ZRU1pKaGozRnZMNXlK?=
 =?utf-8?B?d0xQT1pVN1VRSTRIaUNmMTBUVkRqOG1VbXpzSFlqbHpiMEhqQXNaa0xSNEc3?=
 =?utf-8?B?cGl3K3VRcHJKQU9nSVRqZmRuSDhmMjdjT3BzVkJqbXAwUlg2Wjh1UzdaL2lT?=
 =?utf-8?B?N256TVlreHdjV3dKakxHeU1YaHVGVEhUTG1LMWRvaTRXaVhxdkQrZWs3TGV5?=
 =?utf-8?B?cjhVTW5BejRHTk9Wcjd4T1hWTUV2eXZNUjlORFNBUCt4eS9ETXE2YTV4UUIw?=
 =?utf-8?B?NlRIV2NBNWw0MGtRNng3M1NRSTRFWGVDalB1Q3ZCMG9DTlgzU29RcXZSTmRD?=
 =?utf-8?B?ZjA0T0djTHY4WHM4MGFCM3AybVA0NUdkTDYvd3g3QmVjQkFrOVQ5RGxSNFA2?=
 =?utf-8?B?eThzU0NYckYyYVVRQk5CTXRjWUtQTEpxb05iZ0JleXltVUxHSEIyLzE1UXpr?=
 =?utf-8?B?Uk41eHYzQ3BOQThiZUFQNitGYmUydXhKNERXRXBMQ1V2Z0UvQURwVmVNMVND?=
 =?utf-8?B?K1FqeGtIcW5BZ1JRVkZVMG9pOGFhbHI5MXl4RkhsemdmZjRCZlRmRS9hb1lS?=
 =?utf-8?B?bm1nOEROdk5jSkFKUUtYT3VvUmI3QWpmMHluUmxsekFSVnpzMXBDY3ptZXZO?=
 =?utf-8?B?THQzMXUzSC9aRFgwNzIyOEhpNFlSYWY3MHhucWhoTG8zVm9lSFo1VlVURWVy?=
 =?utf-8?B?UExUblJEbXR1Y2RRR3h6RXY0TVRQWFEwOFY5d0FRYkY3dVNoSUUwQzFiczlp?=
 =?utf-8?B?NHVzaEJGK2NZVVZXK1R3VW8rY0J2Q3AzOWl1VlJsL1NNNHdLRUdvbzNmT242?=
 =?utf-8?B?SDVpN2pMU3dTcUZMWHBPUzM2ZFMyKzBLdlRWMVVjYlpqYzJETHB5T29TcHda?=
 =?utf-8?B?cnltZUpCbWIrd0NxYlozYXlHSmd1K0R6RVh4eDR5cnVJcnk2WlhsMWlmclZI?=
 =?utf-8?B?N042dEtGS1N3Rm05WVNIeUJ5WC9aL1FLalpoZzczTnhBYmk1bFJJbUtiUnFy?=
 =?utf-8?B?ZGZYRHdqdlN2UThmSnpHZFRCQ1lkZ2lyWGFDbDk5NHVxalFKVUJZWU1rUmxY?=
 =?utf-8?B?M1pXUjlhRklxQzM3MmFXakowR0pVSTJFdFNua3RKaktCQmI5eXd1ZmRHOWRP?=
 =?utf-8?B?YTFXSzAvQXdFeGNmSnJTVTA5eG5NRURRVitEWXd5OU9DTnZRWGlnYXlYalFa?=
 =?utf-8?B?VExBYzhoWlB4dzlJVEdaOTFIN2FMcTExb1A0WC9VVUNoMG5PSXhRWDFWSWRK?=
 =?utf-8?B?VnNDZS9aYmpNbEVXeXdXZWlGWVgyUEtoWndLeC81V1I5Smx3Lzg5N2xXNC94?=
 =?utf-8?B?d2FCandleEdVRkRLcWhxRmxyTkp2OEw5L3JubytMaEJvY25iNDhid29NaFVt?=
 =?utf-8?B?OGdNV1dYLzVWK21tVDE0eFlULzd2ellzcFh3aS9wWHZRdWNveXNDQWJaUDJn?=
 =?utf-8?B?TXJ4Yy9vSko1YnBidk1qTnVXVWZUOGpaWHF1ZUJpVWFFVm9IZTFjM2Vlc2Jp?=
 =?utf-8?B?bHZGNGx4Z29pL0FYejIvT3NHenp2OFludkxIb1lvY2tOQkNvUWc0L0JGSTRO?=
 =?utf-8?B?OGE1cnpnMUxrRGFGUThKSTRnbmxRRVBSZHAzbDhOUlN5b01Tc3lTREIrWEh2?=
 =?utf-8?B?cWpVSy8va20xYVUrMU5HWVROR3hGbnlxekxxMTRuVURuRmtlL1J0S1VFbWdJ?=
 =?utf-8?Q?NCaHJ6+NNzaGC8GFGb/crdDi8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6641fab7-73f8-4435-2d71-08de0c2aa5e0
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 20:37:24.5939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JtPjjr6gUzmFtxMHhfDP4oLlVHy7HVQaR4pxqgKAmTGTQLCGXGwXBZ6Zllgb4i4f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4193

Hi Reinette,

On 10/15/2025 2:56 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 10/15/25 7:55 AM, Moger, Babu wrote:
>> Hi Reinette,
>>
>> On 10/14/2025 6:09 PM, Reinette Chatre wrote:
>>> Hi Babu,
>>>
>>> On 10/14/25 3:45 PM, Moger, Babu wrote:
>>>> On 10/14/2025 3:57 PM, Reinette Chatre wrote:
>>>>> On 10/14/25 10:43 AM, Babu Moger wrote:
>>>
>>>
>>>>>>> Yes. I saw the issues. It fails to mount in my case with panic trace.
>>>>>
>>>>> (Just to ensure that there is not anything else going on) Could you please confirm if the panic is from
>>>>> mon_add_all_files()->mon_event_read()->mon_event_count()->__mon_event_count()->resctrl_arch_reset_rmid()
>>>>> that creates the MBM event files during mount and then does the initial read of RMID to determine the
>>>>> starting count?
>>>>
>>>> It happens just before that (at mbm_cntr_get). We have not allocated d->cntr_cfg for the counters.
>>>> ===================Panic trace =================================
>>>>
>>>> 349.330416] BUG: kernel NULL pointer dereference, address: 0000000000000008
>>>> [  349.338187] #PF: supervisor read access in kernel mode
>>>> [  349.343914] #PF: error_code(0x0000) - not-present page
>>>> [  349.349644] PGD 10419f067 P4D 0
>>>> [  349.353241] Oops: Oops: 0000 [#1] SMP NOPTI
>>>> [  349.357905] CPU: 45 UID: 0 PID: 3449 Comm: mount Not tainted 6.18.0-rc1+ #120 PREEMPT(voluntary)
>>>> [  349.367803] Hardware name: AMD Corporation PURICO/PURICO, BIOS RPUT1003E 12/11/2024
>>>> [  349.376334] RIP: 0010:mbm_cntr_get+0x56/0x90
>>>> [  349.381096] Code: 45 8d 41 fe 83 f8 01 77 3d 8b 7b 50 85 ff 7e 36 49 8b 84 24 f0 04 00 00 45 31 c0 eb 0d 41 83 c0 01 48 83 c0 10 44 39 c7 74 1c <48> 3b 50 08 75 ed 3b 08 75 e9 48 83 c4 10 44 89 c0 5b 41 5c 41 5d
>>>> [  349.402037] RSP: 0018:ff56bba58655f958 EFLAGS: 00010246
>>>> [  349.407861] RAX: 0000000000000000 RBX: ffffffff9525b900 RCX: 0000000000000002
>>>> [  349.415818] RDX: ffffffff95d526a0 RSI: ff1f5d52517c1800 RDI: 0000000000000020
>>>> [  349.423774] RBP: ff56bba58655f980 R08: 0000000000000000 R09: 0000000000000001
>>>> [  349.431730] R10: ff1f5d52c616a6f0 R11: fffc6a2f046c3980 R12: ff1f5d52517c1800
>>>> [  349.439687] R13: 0000000000000001 R14: ffffffff95d526a0 R15: ffffffff9525b968
>>>> [  349.447635] FS:  00007f17926b7800(0000) GS:ff1f5d59d45ff000(0000) knlGS:0000000000000000
>>>> [  349.456659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [  349.463064] CR2: 0000000000000008 CR3: 0000000147afe002 CR4: 0000000000771ef0
>>>> [  349.471022] PKRU: 55555554
>>>> [  349.474033] Call Trace:
>>>> [  349.476755]  <TASK>
>>>> [  349.479091]  ? kernfs_add_one+0x114/0x170
>>>> [  349.483560]  rdtgroup_assign_cntr_event+0x9b/0xd0
>>>> [  349.488795]  rdtgroup_assign_cntrs+0xab/0xb0
>>>> [  349.493553]  rdt_get_tree+0x4be/0x770
>>>> [  349.497623]  vfs_get_tree+0x2e/0xf0
>>>> [  349.501508]  fc_mount+0x18/0x90
>>>> [  349.505007]  path_mount+0x360/0xc50
>>>> [  349.508884]  ? putname+0x68/0x80
>>>> [  349.512479]  __x64_sys_mount+0x124/0x150
>>>> [  349.516848]  x64_sys_call+0x2133/0x2190
>>>> [  349.521123]  do_syscall_64+0x74/0x970
>>>>
>>>> ==================================================================
>>>
>>> Thank you for capturing this. This is a different trace but it confirms that it is the
>>> same root cause. Specifically, event is enabled after the state it depends on is (not) allocated
>>> during domain online.
>>>
>>
>> Yes. Thanks
>>
>> Here is the changelog.
>>
>> x86,fs/resctrl: Fix BUG with mbm_event mode when MBM events are disabled
>>
>> The following BUG is encountered when mounting the resctrl filesystem after booting a system with X86_FEATURE_ABMC support and the kernel parameter 'rdt=!mbmtotal,!mbmlocal'.
> 
> "booting a system with X86_FEATURE_ABMC" sounds like this is a feature enabled
> during boot?

Yea.

> 
>>   
>> ===========================================================================
>> [  349.330416] BUG: kernel NULL pointer dereference, address: 0000000000000008
>> [  349.338187] #PF: supervisor read access in kernel mode
>> [  349.343914] #PF: error_code(0x0000) - not-present page
>> [  349.349644] PGD 10419f067 P4D 0
>> [  349.353241] Oops: Oops: 0000 [#1] SMP NOPTI
>> [  349.357905] CPU: 45 UID: 0 PID: 3449 Comm: mount Not tainted
>>                     6.18.0-rc1+ #120 PREEMPT(voluntary)
>> [  349.367803] Hardware name: AMD Corporation
> 
> This backtrace needs to be trimmed. See "Backtraces in commit messages" in
> Documentation/process/submitting-patches.rst

Yes. Sure.

> 
>> [  349.376334] RIP: 0010:mbm_cntr_get+0x56/0x90
>> [  349.381096] Code: 45 8d 41 fe 83 f8 01 77 3d 8b 7b 50 85 ff 7e 36 49 8b 84 24 f0 04 00 00 45 31 c0 eb 0d 41 83 c0 01 48 83 c0 10 44 39 c7 74 1c <48> 3b 50 08 75 ed 3b 08 75 e9 48 83 c4 10 44 89 c0 5b 41 5c 41 5d
>> [  349.402037] RSP: 0018:ff56bba58655f958 EFLAGS: 00010246
>> [  349.407861] RAX: 0000000000000000 RBX: ffffffff9525b900 RCX: 0000000000000002
>> [  349.415818] RDX: ffffffff95d526a0 RSI: ff1f5d52517c1800 RDI: 0000000000000020
>> [  349.423774] RBP: ff56bba58655f980 R08: 0000000000000000 R09: 0000000000000001
>> [  349.431730] R10: ff1f5d52c616a6f0 R11: fffc6a2f046c3980 R12: ff1f5d52517c1800
>> [  349.439687] R13: 0000000000000001 R14: ffffffff95d526a0 R15: ffffffff9525b968
>> [  349.447635] FS:  00007f17926b7800(0000) GS:ff1f5d59d45ff000(0000)
>>                      knlGS:0000000000000000
>> [  349.456659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  349.463064] CR2: 0000000000000008 CR3: 0000000147afe002 CR4: 0000000000771ef0
>> [  349.471022] PKRU: 55555554
>> [  349.474033] Call Trace:
>> [  349.476755]  <TASK>
>> [  349.479091]  ? kernfs_add_one+0x114/0x170
>> [  349.483560]  rdtgroup_assign_cntr_event+0x9b/0xd0
>> [  349.488795]  rdtgroup_assign_cntrs+0xab/0xb0
>> [  349.493553]  rdt_get_tree+0x4be/0x770
>> [  349.497623]  vfs_get_tree+0x2e/0xf0
>> [  349.501508]  fc_mount+0x18/0x90
>> [  349.505007]  path_mount+0x360/0xc50
>> [  349.508884]  ? putname+0x68/0x80
>> [  349.512479]  __x64_sys_mount+0x124/0x150
>>
>> When mbm_event mode is enabled, it implicitly enables both MBM total and
>> local events. However, specifying the kernel parameter
>> "rdt=!mbmtotal,!mbmlocal" disables these events during resctrl initialization. As a result, related data structures, such as rdt_mon_domain::mbm_states, cntr_cfg, and rdt_hw_mon_domain::arch_mbm_states are not allocated. This
> 
> This may be a bit confusing with the jumps from "enabled" to "disabled" without noting the
> contexts (arch vs fs, early init vs late init).
> 
>> leads to a BUG when the user attempts to mount the resctrl filesystem,
>> which tries to access these un-allocated structures.
>>
>>
>> Fix the issue by adding a dependency on X86_FEATURE_CQM_MBM_TOTAL and
>> X86_FEATURE_CQM_MBM_LOCAL for X86_FEATURE_ABMC to be enabled. This is
>> acceptable for now, as X86_FEATURE_ABMC currently implies support for MBM total and local events. However, this dependency should be revisited and removed in the future to decouple feature handling more cleanly.
> 
> If I understand correctly the fix for the NULL pointer access is to remove
> the late event enabling from resctrl fs. The new dependency fixes a related but different
> issue that limits the scenarios in which mbm_event mode is enabled and when it may be possible
> to switch between modes.
> 
> I think the changelog can be made more specific with some adjustments. Here is an attempt
> at doing so but I think it can still be improved for flow.
> 
> 	x86,fs/resctrl: Fix NULL pointer dereference when events force disabled while in mbm_event mode
> 
> 	The following NULL pointer dereference is encountered on mount of resctrl fs after booting
> 	a system that support assignable counters with the "rdt=!mbmtotal,!mbmlocal" kernel parameters:
> 
> 	BUG: kernel NULL pointer dereference, address: 0000000000000008
> 	#PF: supervisor read access in kernel mode
> 	#PF: error_code(0x0000) - not-present page
> 	RIP: 0010:mbm_cntr_get
> 	Call Trace:
> 	rdtgroup_assign_cntr_event
> 	rdtgroup_assign_cntrs
> 	rdt_get_tree
> 
> 	Specifying the kernel parameter "rdt=!mbmtotal,!mbmlocal" effectively disables the legacy
> 	X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL features and thus the MBM events
> 	they represent. This results in the per-domain MBM event related data structures to not
> 	be allocated during resctrl early initialization.
> 
> 	resctrl fs initialization follows by implicitly enabling both MBM total and local
> 	events on a system that	supports assignable counters (mbm_event mode), but this enabling
> 	occurs after the per-domain data structures have been created.
> 
> 	During runtime resctrl fs assumes that an enabled event can access all its state.
> 	This results in NULL pointer dereference when resctrl attempts to access the
> 	un-allocated structures of an enabled event.
> 
> 	Remove the late MBM event enabling from resctrl fs.
> 
> 	This leaves a problem where the X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL
> 	features may be	disabled while assignable counter (mbm_event) mode is enabled without
> 	any events to support. Switching between the "default" and "mbm_event" mode without
> 	any events is not practical.
> 
> 	Create a dependency between the X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL
> 	and X86_FEATURE_ABMC (assignable counter) hardware features. An x86 system that supports
> 	assignable counters now requires support of X86_FEATURE_CQM_MBM_TOTAL or X86_FEATURE_CQM_MBM_LOCAL.
> 	This ensures all needed MBM related data structures are created before use and that it is
> 	only possible to switch	between "default" and "mbm_event" mode when the same events are
> 	available in both modes. This dependency does not exist in the hardware but this usage of
> 	these feature settings work for known systems.
> 	

Looks good to me.

thanks
Babu

