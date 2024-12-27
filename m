Return-Path: <kvm+bounces-34390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D25029FD268
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 10:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 586641883943
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 09:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13E6156228;
	Fri, 27 Dec 2024 09:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4ngDvjU7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2055.outbound.protection.outlook.com [40.107.212.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B1812A177;
	Fri, 27 Dec 2024 09:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735290475; cv=fail; b=Eu5FC++XhX+MDLcOhTDzy5brA2D54dtar/xg83Dx1uczf4OY3ZoveICKZqhRiXAWqWmCHgzoHRcG99UN0pDVCcOjozY3LW0ao46f92WANb0xiI65RGACIOJwRRdrSXKj/etmhStSAbrnyqI4jobtP4vzvV+3pirXE77GfNrrwws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735290475; c=relaxed/simple;
	bh=E4mKCPvudJD/uANulVlU6nuOqvVoRwLc+RiEBWO8LWU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LEGW9lPikvqaQh1HZyVnvhXubcOgY9PymjbshAjcVtfqVbBotm4+UjKJnHv4QKYkv9xfkBegRQTfw20OqAexzkLt+Y6XPRiBoT6gTtvrJg4agPr/4JO9vY+FPb8EgNWMPeFijLGhfAfg+0YFvl+W2ZNjyU/4npKP/Aq6WWse6IU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4ngDvjU7; arc=fail smtp.client-ip=40.107.212.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UFQIWQOofZWKym2GhT4Xk+kXEe0xL7sD7/a/VQo0DZpSQaHczlMVSTo9G1QE2SEtCtAQkDn/xVgrfDg/xKbE2mXXciOqVXkY6cNubH95elzb56MgJayR/2qZgGEkfFMV2Bg6HbNVTCwYQ2Ez/4/4RbhoySrkuwwFcAsKIW8dddHJ/YIg9fQCvtC/eadve9lk16sXpV1bCRJxKReAUYkBgfmYbguuge0ekyLf5e/g51D2FFeuKBHynNEDB+E+wuDJJPmC1y3ZElpf2MEpRTd1Hlbpnx9wRC7eSHiLhhQHD8sXn9Ht3nmv4AOUt/svAdh6H4VrgIrBTM+5EHebM5ODfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKOCMgqm8ihYj5b9Ha8ncjJ+H3EWCHDCQwKBn71M+RM=;
 b=rINMea89Br4qTRZAURoRmagPo2TsRBvbajLg80M4/bV5xjokXG3ZdlY+HauQ+JySYTBhREChhbHdO+nhco3zlTs3cWnR30O3P8wXcrbPmRsQyPNqmHDv3NsA+dhdR0MGhtoTeOvOAOGSaQHXCgaX13Ll64qt7Scvsj0ZvAVj4jhyz51aUItQsdVr46GpOf3LHuOftjj/cq0kYkma3X78iEHSXBAmgLBDTgIXQ/mmtkGaOXxcutfrT57CgR0CeNhBeOJlzK+3zC0cImMnK/f6sJiTbIitT5PQwEJo9Xi7413rm2fhW62qt40PBY7sZH79lK8NOv/IapXPf6O1tQw/Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKOCMgqm8ihYj5b9Ha8ncjJ+H3EWCHDCQwKBn71M+RM=;
 b=4ngDvjU7BuWXo3KMecMWavEdwajCFKI77b+GD9kcqDVfUmQUWN97vMbvLxkoUTS+9kmOhgaPeMNrsthAIH0SrA3TEW8MMxiqcLDMktX3P0NiCKkmhe7/N/aJvHWv2JCyGfABZY6rUjEnPFJenBltRH/Lb34ZiZSepZlidiqbqk4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by IA1PR12MB6233.namprd12.prod.outlook.com (2603:10b6:208:3e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 09:07:47 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 09:07:46 +0000
Message-ID: <433dc629-a84b-470a-8c2f-9bb531a23185@amd.com>
Date: Fri, 27 Dec 2024 20:07:37 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 3/9] crypto: ccp: Reset TMR size at SNP Shutdown
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <3169b517645a1dea2926f71bcd1ad6ad447531af.1734392473.git.ashish.kalra@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <3169b517645a1dea2926f71bcd1ad6ad447531af.1734392473.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0009.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::11) To LV3PR12MB9213.namprd12.prod.outlook.com
 (2603:10b6:408:1a6::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|IA1PR12MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f6cbac1-50e7-412d-8e83-08dd2655edd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZzVxOVM1Wlp6ZXpodGtSa1pzZWY1NlUreG9aZWhmSS9ZZ1pqdS96SzhQK2hu?=
 =?utf-8?B?Q293YUZMZzVCUTRJcWVIRTVYTGQ5SzF4YnFES0tXcSsyMlVoSXVvUitPdzBy?=
 =?utf-8?B?QUxYYTZXcWk3d1ZIZXpqTitkVU5Ick0xem42MlhXbk0rYk0wWUJFUVl1OWIr?=
 =?utf-8?B?VzFsUHRqYk5QZ1ZtRWIxR1BlUmZMWmVQZFhIMWdkVEpKTVpaN3BhN2dHbkU2?=
 =?utf-8?B?cHlmaGl0QTVkakozTng0N3BVZm9qZUJ6emMyTU5HWi8rbTN4Tm1ZQzJML2RH?=
 =?utf-8?B?UzkrMkdrQkM4a0I4b1lJblV0b3VkTjZxa3NITmY3bjcvbEJ3L0FtRjhTV3Ny?=
 =?utf-8?B?cmFPL3RKaTFDTWcvZVgxVDhYTDBtR2VvRTRVV1lvVTBBTEZYdXNtRW8yMnNt?=
 =?utf-8?B?OWVmTnhPU1ZHTDZzQnN3WEt2b3ZuaWF5OWJJMC83WmtUZ3BQeS9XQURXYVNP?=
 =?utf-8?B?b2tLdzhyTnE4WTMrQnI2VjdQdi9sMG44QjAwSnh6cVhQeVliZjNoSW9hcTVw?=
 =?utf-8?B?UzVWdEYzaGFRMzE2cm5HM01PbHpxZjh6ZENzMlFRbDYwWURmRVhZQ0dHUGNa?=
 =?utf-8?B?eFhNbTg3cWlhS1ppYXNzaCtkNXVVVWZVQmNuQll5UFpMWTh2VVlnVVVXcWV3?=
 =?utf-8?B?dU0zazl0RzVValBHQlNVWmVWeiszVzNIWG9HR0tGWE11c1JnVVVvY0RFNzVW?=
 =?utf-8?B?M0ZGNGRQS2V3MCs4a1IvWWJzSGZlekNrV0VtS05KcnFPVnBhL0NXSjZnVDd0?=
 =?utf-8?B?L0E0STNuZU1KWWNYQXVxUGxmVVdvQXRGMnh1dllUWXRDYVdManZtMjdwZUU5?=
 =?utf-8?B?NUlqMklTaFR3Y0JtS3J3byt2N0REWXlvN3gxOWptMHJYUS9WK3Z0dWppSTh0?=
 =?utf-8?B?ZVhqWk9JWTQwbnVkemVEamY2NGpzS1Rpb3ZoOENEUXJlZDMvUUVlQldnampq?=
 =?utf-8?B?cURjbFl1V0dvMG05d29VWEpLVjEyWFpFVUlTc3gxRmVSZWtlc0FWam5hWHFR?=
 =?utf-8?B?dG1Nbzg4Uml5dnFudCtFZTd5UFFpU1pLd3laZkhYaEt6UVRNWTN5bldVSitQ?=
 =?utf-8?B?bjQzRzJ6Q2FxR01sTk12WkhxaDAwaE9XT3FoZ05MRTRrc2Q4Qm41bkpTelMr?=
 =?utf-8?B?K29zNE93cTJVemYyT3kySm53U2dkdEp6dkFMakl5SldDSGkvWFNNREw1RkhU?=
 =?utf-8?B?dmdnbk9mMUJyWUJ0TjhGVGZ4Rk85aFRyNG8yNWxsRzdtN1dnT1Rnazk4RVZa?=
 =?utf-8?B?L0FtRERORDJnMTJKbmN6dzFnQ1ZoaFpUcWlJdHZ6aEc4QVEzbnl1eDYyaSt4?=
 =?utf-8?B?WHh6M1NZWDZUYmRONDBOT3hFakZzZERaM1FiRVEwaStDcXh3RzNQZzFTck5I?=
 =?utf-8?B?a2xOQ1JSZldOdVpQU3FocFZhZHlqV09VUXJNYnBEQ0JyR3BjMjRsOFl0Q21w?=
 =?utf-8?B?dk5kVEtPcUkyNEZBc21aOFFneEVHNEZPWEFWaEJhL0c0c1QwRkhIL1R1dC9u?=
 =?utf-8?B?NStYaGpoejBic3N1VnQwcWg4dkxsdEhxZnpwRDZPOUlkMGdwZHRZQ1krQ3J4?=
 =?utf-8?B?RFNGVHc0aVdoemJvd0dZQndCZ2Y0M1RuWXgrV2J6dlF5MmthRGdMaEZRdS9o?=
 =?utf-8?B?cnZVNVZNMHdSOXJWSVd6U3owdkFmRnBxSnFONlZoOG9GVG1xV2tGZzdaVVZS?=
 =?utf-8?B?TjV2d1Era2JML0EzNCtBNVpvMUE0bHBrNzRjMEk2d29nZEF5dGZTdnhRTzdT?=
 =?utf-8?B?cTVIa0NrN1hPK3NTZVh5Rkd1KzhNNnBFbVNkeGVvaVpHRVNCd1RWQ0lHQldZ?=
 =?utf-8?B?d2tYL2lIRmVXOEx1L1FjSndNSWZ6RVdrK0U3SndhdXcwcmhWYkdBMVJ1ckJH?=
 =?utf-8?B?K0t3SFk4L0tUZ1FveFRLVmdMZ3VTakNKTFg3elNJMm5FL1BPeVpwZHhzRWZS?=
 =?utf-8?Q?g+b3EFe9Kn0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REkxQmhycHRpaVh4bTBvZE1QRGdvRWt4akJucVJWNjU2bFdNRytHeiswTkhU?=
 =?utf-8?B?OHFoTXdRYTk2VGMreW5SVVVxSHZ0OUdaclpaem9qak9ISzNvY1pHalJzMDNX?=
 =?utf-8?B?Njl6YmMwTUJrdG9CZVJRekdCNFBlMjV3L0didk93cU9zNE1BTm1WbnpSaGd2?=
 =?utf-8?B?Ly9Edm95ZUcxVC9XVkJoSTlrNFNOL3YyNDlyZ0QxZUVsRk0vV2JSaXhGOWN3?=
 =?utf-8?B?c0VwYVQzajgzQkFDZGVBUnE1OU40aDA3Yy9xNFByVVRvamZIcm1DK0tMd0xq?=
 =?utf-8?B?SFY3azNpRkJFdVFnb0llZDRWcTM2SEZ0ZEhKU2VlOUUrWDhYYU9BRzh0ZGp0?=
 =?utf-8?B?alRLY2tHNEkyUWFuMGZJQU0xdmYra3Y1UFJsZWxaSWZnTkJyQkN4L3ljUHhN?=
 =?utf-8?B?UG1qU1Fnb1lQYmFaNFIzLzVDNTRYVnpBT3RxTnJWYWIramxtWGZsM3k2TnJu?=
 =?utf-8?B?RXZwWU9sdWRjVmg2cGJ4bXVoVlNITUYxbzFJRVpwMnBxWXNidEJ0ZXZRNWxt?=
 =?utf-8?B?QXNRLzg2V0JXUVV1MC9uTUJUViszU3duQnlrSEcwY0V1Tk1WN1paTDl4ZTBX?=
 =?utf-8?B?VDFUOEc4SnNnakQrR2F6VCs1YUtYQUx4MzBuT2R0SFJNKzRYM05OeWpySWJO?=
 =?utf-8?B?M1EvZEtOc01kenUxTWhoWkdGZ0pPUzU5ZjVrWVRQaWZ2Z0J1RjlwS0NGbXZm?=
 =?utf-8?B?b3JkYXhiYkx1OEU2bVRFR2FvRE1MNndUWGx4Z0h2NE9UU0gyRW1yL0xXZS9j?=
 =?utf-8?B?WUZlTjdyckVJSFlGUnZGOUtaU0E3aC9PcGJ6Z1NkdG1DU1EyQTZxZ2hTWlZO?=
 =?utf-8?B?eHdwSlR5VlBOSjUrU3FYQzdGUWpoYnJyMk1FL1lCNm9GTFlhNVZ1a3lHck9K?=
 =?utf-8?B?UUl3dmZvTkxjWllySkE5RVpsSEYwRHd1WFUzVGRTcHNwaUlXOUtlSnZhSm9D?=
 =?utf-8?B?NVp1bm5PRytpYStWdW9OQlQ3UGtLRjJNQzI4c0dyN0NxTUI0aDl3b2pqdlBw?=
 =?utf-8?B?aWhXdldtV0NsOGh5SlJNMEl3d3J3em41WVpHeW1VZEVxdkp2dWtXVjdQTkkx?=
 =?utf-8?B?VlV3SE03bHI4cE5nWWh0RUcwemNaeDAvK0JJSE5yVGdwM3orZ2NiOUNrZ0Vt?=
 =?utf-8?B?STQrUzZnTkVQZUhmZERORkxmYWZPdVJxTHNEM0pZeEtOYW5oR2ZxbVZwNmk3?=
 =?utf-8?B?TFE0aW01WFJlRXFkNEt2L2wycjFzdmYyUW5QdjJuSlZyRisyenVUdFpqV1Zv?=
 =?utf-8?B?RGxBS2xWa2ZaQXY4bEdrTHJET3l4K0NlcXgwam1XT0d2RG1iY2Y3VWZVOVNZ?=
 =?utf-8?B?R29EdXV5SUt5Q29IMmxvdlVMZlBUUWNURXBUNzl2Tm9lRDZuVnRvWTNlM1Ro?=
 =?utf-8?B?bGRFcEtLQ2FQVDZVMXdWZ1JaTWhHZHpRK0FraUVaQUo5bmM4VlRBOWg1bS83?=
 =?utf-8?B?VldXVm5JVE1wc0VzTHczZkpkODBLem05dlBUMjRIN25DM1lIQVVwU0tHaWJD?=
 =?utf-8?B?dFhMY011aEo3WEFSK25WQVF0MmJ0b2laRC9sZTBOVmNlSE84K28vTit2UHRl?=
 =?utf-8?B?a2VjbjQ5dzBVUTcyYThpSGsyaVhYVlFRekFVNVBJU1JLUDNDeHo0dFMyMDJU?=
 =?utf-8?B?M0hwNFdPTkZBTTlTYWpmS0wzNHEzL1ZtWnJZSUhGeTQxZU1wMThRTEFMVE1M?=
 =?utf-8?B?RExDU1RBKzh3RWhRTXpWb0xsNGhtNW1OVEhucGRvZ2hDU2sxSkdENm02UWlM?=
 =?utf-8?B?QWhMWXJSeHBKQnMzenJzUFFwTHI0UGw5anIwZDdhTEhxZzRFMEEzek9lamZ5?=
 =?utf-8?B?OWlKd1h2dnQxNzh0NHdsQ0YvZUpneXllUVFwZmNYVmR0VXZNL09qajBWbzQv?=
 =?utf-8?B?ZURKQkR1dS9GcHI4dWZhMHVZdjZjOFNvTnFzUFA4UUg0SEFVU003bklNd2oz?=
 =?utf-8?B?TFdjWlZ2Wk9VUGVTekFqNGpSamYrVzljMlREbWFqYnZFYjNVNmZDVmsxbVJN?=
 =?utf-8?B?VTlzTXhvMTBwVXBvOEt1TnFsZzdiYzhxbUtCeFJ3N3hCK24wdzE0bEZIVkpU?=
 =?utf-8?B?L05SZmxLcXVKSU03WlVDcjNwMmNIUDhpb2kxMDVNUGVRb0cvMHFHUFB2bGdy?=
 =?utf-8?Q?IkF0aQ2cNQ6iHHsPRrpuOPWqQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6cbac1-50e7-412d-8e83-08dd2655edd9
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 09:07:46.8983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WhPEOiEw5P5WIwqBFnu7pAHcN7e2/bLavd7ZhUQvomjFh0BMAyo+7sxCC8RbwWrkm1vVKAur0yhQ+Bkshveb6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6233

On 17/12/24 10:58, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
> ensure that TMR size is reset back to default when SNP is shutdown as
> SNP initialization and shutdown as part of some SNP ioctls may leave
> TMR size modified and cause subsequent SEV only initialization to fail.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 0ec2e8191583..9632a9a5c92e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1751,6 +1751,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>   	sev->snp_initialized = false;
>   	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>   
> +	/* Reset TMR size back to default */
> +	sev_es_tmr_size = SEV_TMR_SIZE;


It is declared as:

static size_t sev_es_tmr_size = SEV_TMR_SIZE;

and then re-assigned again in __sev_snp_init_locked() to the same value 
of SNP_TMR_SIZE. When can sev_es_tmr_size become something else than 
SEV_TMR_SIZE? I did grep 10b2c8a67c4b (kvm/next) and 85ef1ac03941 
(AMDESE/snp-host-latest) but could not find it. Stale code may be? Thanks,


> +
>   	return ret;
>   }
>   

-- 
Alexey


