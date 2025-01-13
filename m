Return-Path: <kvm+bounces-35301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4482A0BD80
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 17:30:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E03C188BB65
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D0720AF91;
	Mon, 13 Jan 2025 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lnYtyPpA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C58F20AF8A;
	Mon, 13 Jan 2025 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736785684; cv=fail; b=cTTxgicV3jWv6dR7EVz5v/Qj7YIzc9AcFIUDq2xF5ZI/ss1s6iFx9H9vEBvXwR8tIPRPbyHssdvbc2U1bITjTvsH16CXqLeRYeSi6XU3uCnHh7lYHjffpsVyu3ha8VzjekexPZhUxhu9YyJkz69bh1Hg4IOzFjwwreaMyATKkQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736785684; c=relaxed/simple;
	bh=2Doli23YhbkXR8apuSR+NAft5ZBzfJunLLKf9TWy6CE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bVSWwN0gwMy2u3EcFP7YDXkQ4XXg6hHqjUuycU2xOSuZ73LVmig47RvbCOpRXKMY5ivPNvE0qMp1N4lwb0Co2IXAK38wzc85ERWOQ1AYy0LO2/pRaEjnMtL+wGyLH5x5wRIo1syLpSENOpIWWgIOq/edbOtJlpd8D0zxxvB9ty0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lnYtyPpA; arc=fail smtp.client-ip=40.107.236.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZdPUPK49RTAkXinD4JKyg+TvDhJA7RG5wkXWdCKUYEStTdfezwjuUuEoM8NYnfZQmHYInuPpV7av4UgY3RHUm0nIy5ly628UM2gTLIuYDmS9Vqd0bh0DUxFwpcx3PtQsXo+HRLlN9Tal0k6t9mjtBmP13TPIYWk4bfSULar9NBgXPk4wf97LhlzWbsf488CB8hB4Uz2JtFONa46RAefKfVcsNFSlt65eoBkFTC6GXbjNyWOUeasNNG8a/3M1Z8DXg0rs2bwrL+fu+/X3Psuj4K2SOf1nlgCiRgtzK+MCNAfjeBx6gsow2QkF6+dj9A0w90P5+SiKgZ7uy8Zw8S/tYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WvfZ3h8+szCVcOn35ZDnjPKfsYYFTE1k+wvzZq8p9PM=;
 b=hseHr7bGHcaXX1R7O+DHNMf+6aTzSxifNdDxBZ8X1Jy9CtOGuYAZX+vIo2ip6aHZuURDGUPlymciFIme4kkk0RY3bxyln7BKcgfJF1yebEsARf1pK2A+DEkDbrAsvNnvGEouCSQm2MH7Do7muDebwDHrT8EmNmw7QnDHSrU76GM3wenpwYazLoO4QUX0tJEniYyHQhTHSkh9ru4RptFVX67zr+7QQMv3ULY8PmtbcibZ7nHJQtCU5lKddrwYx5bNKsJQuCpOwcxAEFzZQwf9tIEo93DHYDsMVy00KzR1u8bRb8SRdgusD/Kz5dg4kq61hYtMZAKC6l1BFm7aFh9aSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvfZ3h8+szCVcOn35ZDnjPKfsYYFTE1k+wvzZq8p9PM=;
 b=lnYtyPpAVKPQC4RVtIRy+PvCAy2NvFdFaX2we/pQXzVJ2PLZTrd9Yl2cGZvWgWvrrzjwGk73jcFRpV8YZOSkhSRU+IwqWhUCT8znLmLWbS+dydBI69MGIZeCk43C0TVSyz8pgiS7nY7BmfOXWiPFTLAP81lWimESt1hiFpA5SaAFxIoybvyeHHNNjrwZ5beFIsE91rWybo/EMwzMrCgnBP5Gmv3mMDPSTxMdxC6yduP49oMAVjquramv/IzUpHuOpN+AoVri6fvoEBMND8oRE5NqH48yuHp1xm7VL6aThK3QiHo7c81mIgxsghJd0T9pfCIDO2FplB4lRZaFo1VmdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB7173.namprd12.prod.outlook.com (2603:10b6:806:2b4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Mon, 13 Jan
 2025 16:27:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8314.022; Mon, 13 Jan 2025
 16:27:58 +0000
Date: Mon, 13 Jan 2025 12:27:49 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250113162749.GN5556@nvidia.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
 <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
X-ClientProxiedBy: BN9PR03CA0768.namprd03.prod.outlook.com
 (2603:10b6:408:13a::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB7173:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a3d80e-d18e-4b4c-c263-08dd33ef3d89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVBtY1JoYXhCaXZiUVdpZ0dDYWJIbkxJazQyWkdxZDBtcXg3ditoN2xXNG1z?=
 =?utf-8?B?STNVVUVSRlRyWXVSeUNNenVKUk9lMVFUQ2RjQms4Ui82dTQvSGhvKzZER2l5?=
 =?utf-8?B?MXBWUStzVnV5bldvM1Faa2c4K25tc1ZtWExGcGs4dFVzb01UOFMvSFY4ZGxN?=
 =?utf-8?B?WitKWHI2UW5nNEF5Y2Z0YUYrN0laa0VjK203TjRCWWp2NkVIRVVIL3dFQzVn?=
 =?utf-8?B?ZzlDek5oNDZMNWtVRzJZeUV2blhWckpNb003cWRQTmxtTWIrdEd1VnNySUow?=
 =?utf-8?B?UU5WMlRpMmNOWllDekdYS0w5WUpTSXQyV1pKZ2N5RlVySjg1T3FHU0QybUVj?=
 =?utf-8?B?Q2tISmEyOG9IdXRjaGRiTVQxaU5qaTh6eWdsL3dIUGNPSHJvNVNXejFseGhN?=
 =?utf-8?B?ZW5PRVZ2NDQxdTNUWmVuNUR3MDkzTmE0UnV1NEVwenJCb3pWVlNaTkRaNytZ?=
 =?utf-8?B?ZkhBUG1Zd1kwK0MyT0hxbjViWlZyaDFUbjU5RThMRUxoVlo5OUs5RkRtSmVC?=
 =?utf-8?B?TC9HVUw1RWt0QzM2OGJ4YlJ0ZXRLSWdYUngyUUo1QUJIZktFWjZ5dWFpc2xt?=
 =?utf-8?B?dm0zK1VsYzZKcHh6NGNESVRpU09YSlZTVWxHdlMrVmY2UUkxMWdFQWRqL3F2?=
 =?utf-8?B?SmNxcHhRbVN4Umk2Q0tpUDJ6YjYxWDZGaHhNd1FtNWpHaHhRMDdJRVlid1Zp?=
 =?utf-8?B?WXp4bHdndkFUcmN2c2Zhem9Rc2ZNejFmSm0yOEgxR1NidmNHOEpVcDZibzFV?=
 =?utf-8?B?bkdvTThMR0xtV2VpOEI3QzZBRmRyZnhmVjg3dUIzaGkvTDRFUnk0RlNSZk1N?=
 =?utf-8?B?bzkwVXV5TWs3UmZHWit5OU9kQ3JvOXNwcmtaOEQ3UmtYa3FRbGFpUjRNUHRX?=
 =?utf-8?B?VTY1MmlFV3M4MlZtM0tBNkNnblp1RDNKZkw4SHpxcGN0cHZ6OUN1MDVhczFF?=
 =?utf-8?B?K0wwbFFHMnJraXNGTmlSVFhJdnpLejB2MVVwZit6NXU2VlE0cFliQ3pHYVBi?=
 =?utf-8?B?V1F2eUg3RFJNdVpQTEV2dkpGKzRycDdNYUsyUFpOTnArQ1FxcVI4NWIrc0lx?=
 =?utf-8?B?TTh5b2FRRHdzNE5LV0hDVi83TjRibS8rUlBNTmQ3THRackMvdDdwZmYyYTV4?=
 =?utf-8?B?UEZSeGhobzhWRUJuTjI2S0YrR21jcEtJMjZ0UnlsZmhWaUYwcU5XUURSZ2Zw?=
 =?utf-8?B?KzVVbm5yUGZsZHcvc2RTdVRzRXdyZzlLdmEzSDY5SXJxV3F6V0F3RWd0NUE2?=
 =?utf-8?B?aVdEc29YR3REa3hWVGlOYnAwMnQyU040Y2FlTjE0bmlodDhXV0JOUWM5YnJn?=
 =?utf-8?B?bzNyeWgwYTBiajk4cVNBWDRDZm4rY3QwcmVKVHVZYU12Y3VCM0xrN2xJU0sw?=
 =?utf-8?B?aFN0NldYdkxZOFFxQWNOZFV1aDFXVy9KK2FjZWN0bFkvdDNUeTg0b3ZEb2N6?=
 =?utf-8?B?R1k1aktrd29zYVVyWTZ3Tk0zTGVueHloeGZSelJCRHFNdmhub0FnRGdhejU1?=
 =?utf-8?B?U3FUWVlEQkNLOFRZTDU4Tjhmbitnb01nUGYzTVV1aUxHdk5qVUZpV2JSZHZ6?=
 =?utf-8?B?YWJhVU96Z0tEdmVVS2lpL3VzQ2wzYkxqSUtaaGlnMG1TcEI4M2JxRUZFQ09Z?=
 =?utf-8?B?a0xZVXNncGJqckhXQ0tPNFM2SFQrMzBocWdNOTY2a2ZWWXJobk41V1JxS0J0?=
 =?utf-8?B?UzVGUVorQVlLakk2QWFzSGY5SDBZU0tOeFdJRVZScUtSbW1kdEZ0ZXJnV2gz?=
 =?utf-8?B?OGswTTdLS3dsQVB5V0pscVN1ZG80RkhNemtEc2FQb1ZUQUhnYkhOdDZjS2Fz?=
 =?utf-8?B?TlF6dHRuaGs1UXRnV2pSYmpjUVdJazk2bDhJT2dUcnAxV0dDTTI1N1ZLcFc2?=
 =?utf-8?Q?heLRY9NNYfHob?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXlZenRubnZqLzdkUXlleVFxT1NvdUFPN0dENDBWQ3oxaER6UmJUWVluVWs4?=
 =?utf-8?B?WU03dmoxazI0bzdhNHlZK3BraFBNRktOWkVlNmJ5bEV3WlVUdTNpTlM4VE44?=
 =?utf-8?B?M3VsVFBHU29OdnVKT05NR0ZEZUZIRFBKbkVBUURraHdsRHhlLzhYYlVPNlhN?=
 =?utf-8?B?TDNTekZUTml3QWdwdnoxTzhDUkhKQkc4TExncmN6b1ZmS083ejh2c08ralhx?=
 =?utf-8?B?K2Z6dzJZSURHd1VLUkc2SnBJUG1jM3JaMllEUWpubzBqK2JLQ0IxckxZOEg2?=
 =?utf-8?B?S0pPQ3RRR0JWN3FLUUQrTWoyd1lPdE1lMDB3eTMxN0ppakdlQkw1bWpPZkt3?=
 =?utf-8?B?UlN4RHJua09hbFZRTldJZ092YUtvQnF0UGxKZTR3ZTYrN04yeUJPODMva2o1?=
 =?utf-8?B?WXQrUXRVY2RQQklFcDF5azJ1UWk0UCtKVWFyckV6MmdNWUhObnpOVnZYVXMx?=
 =?utf-8?B?eTZuWEt4bk1Dai9HYnRrcGhtcDRnRGcrRG4rTDI2ZWc2blZDRkFjZnJ0UnRH?=
 =?utf-8?B?V2kvYXBSVC9pOU1mTjU1dHZERXJveEVMM0xUaUJWYXNXVkN3cVp3SDR1M3Ey?=
 =?utf-8?B?WTRtWlpVaTZLY3FPbUd6OGJET1JkOXl1dEFkNEpKRkhDWHNrRFhuMTM1RnlY?=
 =?utf-8?B?ZW9WeW5ZSFk3QWFlZDI5cGVMN3VwZGtmbHRNZTVOdWZPdTdnRUNrL1VKZE1C?=
 =?utf-8?B?MXBHalBoT08razVUZWNOSHphOThaT2NNZHVTNWFBcmxjQjhveWxxakR0VEZB?=
 =?utf-8?B?dEppVWczSlR2bTRTSld2SkEzYkVydllVZlY4MU9MNGp6MVdMQW1LL1U3NVkw?=
 =?utf-8?B?aWVFY3lETEREcmhlMGlIVnVYM0p4Y1JsK1puYlBwYUR3TnF5bFJUYkY1aXBP?=
 =?utf-8?B?bnU1WDN3ZGdzcGJUam9IQi9uTEVwRE5jRVp1UmxOWVU4cTF5bHYvRHdPK1o3?=
 =?utf-8?B?NGJxYWpaOFpXNXFyTk01dEEvNDhyYmxBbE12eXp0b2J5Tytsd0N5c2ZGZko0?=
 =?utf-8?B?a3daYXNZeUVOUmZLZ3NPeFJNNTdJTlpFS24zODdKam54dXoycGpUSXUxT01u?=
 =?utf-8?B?VG8rQXhKVnF2bDkrSUJDVGltRmNSblpwc21xUnNTdlN1Rmh1RVVWMUQ1QW41?=
 =?utf-8?B?MXp1aFIwczI5M1M4QnRWbWZYanpqNXMvUkRZT0cvMG9uVllvWUowVVIrZElL?=
 =?utf-8?B?dFNxWkdLeEtGbWVCYmluWDdLM0xqMmdOU2dxUTVMRGFFRStaTHMvVEN6TktN?=
 =?utf-8?B?dndUVitsVW5vUHdRdW1xS3pkNVhha1ZIQmNjV0crV3cwZllmcHI3UnJwUHYr?=
 =?utf-8?B?aklRb1dvVjRobWhuKzhDdFNBWVJUdGgxekU1a0QvTjJDekx2c2ROYjFIYVJk?=
 =?utf-8?B?Q3pCa0hpT201ZWV1SHZpd2YrZGEyUUU2a01xNmdnbEZJTFh3aXJCZTlpZTdz?=
 =?utf-8?B?djZTWHJSZjNxSFc4SUY0b0x4WmJzY2tBZ1ZyK0JXTk0wQWNpL1pNbHA5ZDFr?=
 =?utf-8?B?QmV0bzlTV3ZycXRHWDlKeXhmcGlTbzlvRGMxTXBXbkNWWmRQdWFsT2hpczdI?=
 =?utf-8?B?MXhoQkVSeWZtaDZqRFc4cUxZVFJsQVdKdGRoNWREdHltUjh5TVo3VFVmV1RO?=
 =?utf-8?B?RkhBRDhPalNUWUdJcTJ4RnNvdTY5eWNYVmFRVVVXSHh0Z1N3M0xIMkpaR3M3?=
 =?utf-8?B?VDlZbnJicUcvMkQvVTVSazdyaVZHRWNmRHhHdkhZbHpSc3Z1RlBJMkk3SS9P?=
 =?utf-8?B?OTUrd3I3eElSVW5jc25NSVQ3SlNkQ1RONXhwSlFmYUdzVjh4RmZOUHNWcXBX?=
 =?utf-8?B?RWh1bTFtOVFyZmNRdXI4UEhmTlVqR3NEKzdHMUZjRTRFVGlXL2hycXNMcFFn?=
 =?utf-8?B?QlpEREYrMnlPN1NVSzh6VUxIakxRc2VSbzR6NXlMV2RCSno5Y3EvVWlGL3hZ?=
 =?utf-8?B?ais3N1c1QkxqQWNnWC9WWVhBNjA3dnFDdjFGV2Q0ZjBpaFRWY0hvSWo3bVFh?=
 =?utf-8?B?TUhyN0FRcGlLRzZzZXExYmhOcDBZby83SXZPRVd2MHF0Zy9icEZIc3NseDBY?=
 =?utf-8?B?SHhwWXFSVktBWXQydmF4ODA3N2hYYU52RThJQlBPeERUd1NHQ21qOHE4TWNX?=
 =?utf-8?Q?E7Pk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a3d80e-d18e-4b4c-c263-08dd33ef3d89
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 16:27:58.1662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PISG5tFR+oh2hXR8UKaW9Ga6OoIrqdm1kLQk2fiibLbAQG0jIfPUIxhB48DEpLsU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7173

On Fri, Jan 10, 2025 at 09:15:53PM +0000, Ankit Agrawal wrote:
> >>>> This patch solves the problems where it is possible for the kernel to
> >>>> have VMAs pointing at cachable memory without causing
> >>>> pfn_is_map_memory() to be true, eg DAX memremap cases and CXL/pre-CXL
> >>>> devices. This memory is now properly marked as cachable in KVM.
> >>>
> >>> Does this only imply in worse performance, or does this also affect
> >>> correctness? I suspect performance is the problem, correct?
> >>
> >> Correctness. Things like atomics don't work on non-cachable mappings.
> >
> > Hah! This needs to be highlighted in the patch description. And maybe
> > this even implies Fixes: etc?
> 
> Understood. I'll put that in the patch description.
> 
> >>> Likely you assume to never end up with COW VM_PFNMAP -- I think it's
> >>> possible when doing a MAP_PRIVATE /dev/mem mapping on systems that allow
> >>> for mapping /dev/mem. Maybe one could just reject such cases (if KVM PFN
> >>> lookup code not already rejects them, which might just be that case IIRC).
> >>
> >> At least VFIO enforces SHARED or it won't create the VMA.
> >>
> >> drivers/vfio/pci/vfio_pci_core.c:       if ((vma->vm_flags & VM_SHARED) == 0)
> >
> > That makes a lot of sense for VFIO.
> 
> So, I suppose we don't need to check this? Specially if we only extend the
> changes to the following case:
> - type is VM_PFNMAP &&
> - user mapping is cacheable (MT_NORMAL or MT_NORMAL_TAGGED) &&
> - The suggested VM_FORCE_CACHED is set.

Do we really want another weirdly defined VMA flag? I'd really like to
avoid this.. How is the VFIO going to know any better if it should set
the flag when the questions seem to be around things like MTE that
have nothing to do with VFIO?

Jason

