Return-Path: <kvm+bounces-60295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F1ECFBE8150
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 12:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B7E2E4F721B
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 10:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EADC2D8398;
	Fri, 17 Oct 2025 10:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TMoC/yE+"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8991BC3F;
	Fri, 17 Oct 2025 10:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760697361; cv=fail; b=fYjcFWtVjrAL2R0/9VhUBjFgaJMVHgn/tL1LzEwfGy9mRblf9XvDxZOMigzjXVraDhtFq3VHyNqNTkR57aoCFFzFp+ev9YJtVZNR142rKzq2DCcZWZALaVuNs3q9cT8dkiVmT3t2JhP5YZiNaqbr0cDEN3vg7vpjzi9tcpWy/hU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760697361; c=relaxed/simple;
	bh=0INH/c3+UtQV+uUid9HA4nvQpVrYidb/dKK1ZXgG82I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JlovOKylwGbEhzfPBO1ei2EJENETUAfWnUKkkfLkwhnxuQKLgUcJQ79lF8XxwBl0+pmtHCygCyVRZJEsfbVr0zEr6M5+JnMwEaGZdKQaA/BiRyb7li3jb2KOle6muUDlt/kuwpymq8cRc2hJ2DbVUjSmhSRMQPwUWUYXH4fnuSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TMoC/yE+; arc=fail smtp.client-ip=40.107.209.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xl83T9hAKuFzfay0ILoAwTlc3U0zlw1QThnqDO3R92i4/rBC0uCuYCZ8GCBjvaA58vI86y9vW8QENzHk+F0/vcuF93nEYyXBBaKxVkolkEmv+TYoaRIlAQM8M4C7V3Bfrh/NnGF2ncfoCmLBx6N8b/jye/z73EU3gTvopie239TBjf1Mcd28XN6NBVpyaIfCBznbXzd5kbEUsjfLsnmKivqX2HD5NIHPyAyFiqgXslya8/C8U+kaRqK3/TP5V4H/LDbfVwkUGVs+iiBnI3j8V+8lu3hIH9ucYfwmlBE16JGzvBlmRzffBF36S5e9mT1eY/9rc/4PEOrFzpAaAeXpYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcRVitWow8zzuo5H3VITvuxVFD7TePhwJzEzDvCylbk=;
 b=Sar3hCUTC/2cVdcXlh+73rmfNq1/QXexjpcAOu7HxgEhwuLPBFki5HrT5jJEvI/EVXbC6bQOTZnm9wt0bcqGKXq++JKF4OxVSKzyfMWIb//l2KpVUxdpeAXcaY/iHwOMHcyYEB1IGzOi8IPe0QtZBUUFF+8FTsKmqpFRkoPr8PFLQn6f3myd0RML5HV7ILR/70sf+WCC0Nzm15pnppt4t/j/Nrz3lPJ4KWszUULEqU4B9U9qjCb1SCHWlTGQTapjV5EPCHVDpQPFydbnXmO29QG8Mss7HdWSP5XHRy2/1D3E92nmefQnBOMXWjGsM2SVK9Ia/I/iXlPVyiXjWgwzSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcRVitWow8zzuo5H3VITvuxVFD7TePhwJzEzDvCylbk=;
 b=TMoC/yE+N+YUD+CcjBa7s68/Fp8BPykkiWWikK43FXpVsw1i0Ef8wHiDbDeb9QG0+E/eJDf+iqLxcv4S8jRiDXQJmLTGr5eVGjk6JrGrW0CPrA1DAxYUhMlB+/0b4SK31I/ATKchYpzxhm3HlPtQsKvxBZE6xKiNpt8gmtnFAL4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by MN0PR12MB6199.namprd12.prod.outlook.com (2603:10b6:208:3c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 10:35:56 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 10:35:56 +0000
Message-ID: <5303684f-3acf-402a-8154-a02a2194ce34@amd.com>
Date: Fri, 17 Oct 2025 16:05:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 09/12] KVM: selftests: Use proper uAPI headers to pick
 up mempolicy.h definitions
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251016172853.52451-1-seanjc@google.com>
 <20251016172853.52451-10-seanjc@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251016172853.52451-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0056.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:274::17) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|MN0PR12MB6199:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a325c7a-69af-4711-1d98-08de0d68f47b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGVoS0JGMGhDTlpmWjRPOXhkZ0tNTHRiamozejVDN1QzMngrNzBlSGFES3pa?=
 =?utf-8?B?V2dGTW9qdWFNaEtTVWxTV3lyODNpa1hMVnA4cVE2OGdJeWhZMkVoZWxBWVV2?=
 =?utf-8?B?QktXQmlTNncwZ0prak1WZFk1dTlsZE1jN0tlYlptRjF6T0VNM3BSSGRKZDBL?=
 =?utf-8?B?STJYaFRSQ09Hc1dqTkVIYkg1ek9vVnpDbm9VTnpnY0hRVFRwaVlGd3ZxZkZr?=
 =?utf-8?B?akFYUStEaVFidm1iclFlMWZYeVdSaXMrVVBOY0FXUFQxc29ZOHNmTUxvd3lJ?=
 =?utf-8?B?Nm1sUjgwMFFtejd0SnJQaHVtTnIxODhFNEwvd2puMnJVQ0MzWEZ5OHJoV3hJ?=
 =?utf-8?B?ZTlScElBN044SzdjV1dnZUZ4M3crK3lQQXJjWFlGUW55Qk41TGZheVloczZn?=
 =?utf-8?B?NTcyaWF3Ly9ZM0E0N0tlWGVKTGdUK2cvSkU2bU4rOFVQUmxBSnUrMzhnUW54?=
 =?utf-8?B?MFJEM1ZjZFF6dW4wcHI5WEh6ZDZndGZFOWZ5V3I4UXkzWTBQclJzN1FLelox?=
 =?utf-8?B?L25IdkExTnQzblZrVjRxOCsxMXZVOEp1a0VFb3VnM1Y4c0RYWm9OUHdoUzNo?=
 =?utf-8?B?em9IRzNDZVRCYndiWVY5cHZXOHl0c1owWUt5V3BBVFh2MlZmZ0JPUXk2ZUh4?=
 =?utf-8?B?bk5CSDNSRHl1Wk42S3B1RHdIVnNnZmROSlNjWHYwb1p3aFk5QVF4Vk1SeW9V?=
 =?utf-8?B?WU13OWY1bTlmV3daak81QU5URVhDVzJkQTZZdW1NR3ZramVPeCtMMFRsSGZo?=
 =?utf-8?B?MENtU0hraVhMMjFpZ1pibDUrY1dMMjdIV29ZRlZOL3RDUEVQcDZ5Mm9iZFpT?=
 =?utf-8?B?Q0RyUkRuQVM2ak5tTjQvSEt2a2l5N0t4M0xQVjFkYUluaHJyOUdZOUZ3NDRT?=
 =?utf-8?B?a3MyWTYvMW1CRy9FM2k2ci9oOTZUaE45aUtZMm83VkQyTU5OWFJDVHFjNjVz?=
 =?utf-8?B?V0U1NFpxZktCYUxwVG5iVzNsWHNwd3hBWUQ4c1BVTDU5bXFTcDJHdVNvZEUw?=
 =?utf-8?B?RTJVY0prSUVaYU9UbDNZMEszdllkUm1leFI2bXFHUnh4NGsxU1BRYW9wcFl3?=
 =?utf-8?B?SVV1K2oxNmViMjFpUnJYcEJpTGlxVXlhWUhubGRQenp3ekl2dWtBZ3JVUm40?=
 =?utf-8?B?WnUxMTBUV2VBUGRUMWhjZE9GdmZ5bUpoUEJEcGpMNjF4K0c4YU9CRHBodkZV?=
 =?utf-8?B?Z1JyOWphL3lrQVlPb1hhV1FuUit5L2d6NFcyMGJVak9WR3NxYlhNYkxZSmFm?=
 =?utf-8?B?VGVJNTk0RHlPNHZ0QnlJQWRMRUF5NmxzVi9QOFViSVpZOGNWQmJ2ZFJIUWlT?=
 =?utf-8?B?aG5NWXg5NG5aVFNCWlBwY2dPdjhEUHZ4OGJkYXcyQVhnQnF6UG00dFZ5akpT?=
 =?utf-8?B?OEcvVnVBbXJQckdINjl1dHI4aThnaEZTM2tOQ2FFVFNNcUVObnhpbkt0VEQz?=
 =?utf-8?B?Z3JRR2w0K3BmRVo0bnVLbmI1QWVhbGllWWVPK0VKMk14TFpCTEtJWWFyT3B0?=
 =?utf-8?B?My9XcGVCc3hzd3IxVXh0UXh6YnVuSkR5ZTNlUzUwVmEzSFBsSVR2RWJMR1NK?=
 =?utf-8?B?QzVqNE9ydm5MaDB3T09XbFY3d1QyVTR4UjdTZngvQUt3ZnIwU0dCQmlrMFJj?=
 =?utf-8?B?RnNCTlV3U1ZIaTZnektWWFdPQk1QR2lDNGJkUkNrMVF4WUlMSEpXRk9aYmtT?=
 =?utf-8?B?N2NLUStyUU1idXJBME1LK25XTTM1Zm9QUzNRRW9FQ0pyV3FLQk54Tm4zVU5U?=
 =?utf-8?B?RGZOK0dRVS9EZHlVd2NjYnpPSm5heTNVekFaRFUrWk5mUktQY0p0em1pekxW?=
 =?utf-8?B?R2pVR2tOZ2xhTXNnaG1MZVUzVEpRWnZHKzRucFlYRWNrUFFtcURLdXdxVlJE?=
 =?utf-8?B?M01MWnV6RmVmSFZZejlCSVZXaHF1SEpRYlhsdWxRTC9qZXkxSlp0d3JVMG9i?=
 =?utf-8?Q?K2V95/aaanoQ/Y5zfW7HFJ7OAs8PBmTP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUNESnR3ejRwemliR2tveml5Si9TRjU5WWc4TXZseGhQVEozdDVDOVAyR3JL?=
 =?utf-8?B?b3BFWTcxNmFEbUZPMElMTWZWbmR0ZFdob0x6M3dBaVc1Q0x5Rktmd0J6bnlN?=
 =?utf-8?B?dmJiK1ZqSUpicHhpUEFjYTdJM3lMZmRDMUdzY1dla0N2cWYyUVB6UW5TcG44?=
 =?utf-8?B?Z1lhMkJRWnNDdTI0b1RkVTVtMy9wUkdDL2o4d3F4L0VoNFpSa3FBK1VYYzd3?=
 =?utf-8?B?TnlHcWtLcy9EWWVVUnloOVJlM09sR0RNbnhLdDhERU5Tc1pzV2VkVzh3RG80?=
 =?utf-8?B?dTk3bDJUMkdCSjZxcVovZlB4dWE2VU1UWFFUdE5pSWZMNVc0dERrR0NZMkFL?=
 =?utf-8?B?RHRWdGxCdUMwdVdYWEhWVmZ2OHRsRHhoZW9rejlGK2dNRzd4eXNWTHVHaU1v?=
 =?utf-8?B?ajZYM0NGNmRTTGk4eFVIREM3ZStObDI0N2hsRW9kOTVkV1BsWGV1Um13NGhj?=
 =?utf-8?B?MUlPaWhFZzU2RHlqNXdlRHRjYVZZZDBsQVhzMWx0d0g1UENyRDFhemJjOXIw?=
 =?utf-8?B?MVhoZFp4dGRmaWNBdWFKZkNVYXMwQUtZdEhDZUJQVUJLUHd0OUdBTUhQOU5i?=
 =?utf-8?B?cmpYSE5teHFhdnlwMlRCdWkxMWFFQUQ4MmZDd3VxUlNwL0ljbW93emRudUQ3?=
 =?utf-8?B?ZXQzS1h2eHViMlR3RGJXb2w5QlAzMFFhU3JWVE5WYytqeFRFcmhDTlA4RlIw?=
 =?utf-8?B?OHhSUjZqZGNiUklOVGJZcVZSdXU1aDh5V25wWlZzczBqeHljVkpyenlVTktM?=
 =?utf-8?B?Zk1idCtpM1ljYUo2aHhpSTcxcU11ZTlkd1B1QTAxTlhoSjdMRmFoUm1Lc2VF?=
 =?utf-8?B?MEFoZXdJMHlNbEtqdXNpV2tWTkhCR1JaSHJKQmhsWDZwZzFnNjJiaEhSTzJQ?=
 =?utf-8?B?Vmdwa2dJOEthdURsRGM4RkMxTDQwdjRXM0hwSFJIeGdlNUZLRmp0UEw1UTlB?=
 =?utf-8?B?b0YyZ0xSZ01TSFBwdG1sRm53UDBqY0cwSlRJeTlHcjVEczc0NSt0MldmZEo5?=
 =?utf-8?B?cHdGU1BaRFR2c3NOWjMyckwxQWdpbmVGTzNHSUtXMlM5cURJVDBIYWxVNExI?=
 =?utf-8?B?L3pjNzhuRkR3Y2RnaXJsUlluNW5URGZ3WVJEOWsrRG1RWVNYdndJdXhtbGF5?=
 =?utf-8?B?Z2Z4cUE2MDVyV2dhRS9DbWNCRlcxNUh4N0dYU2Q0clVvTTJSV2x6OG9xcUpP?=
 =?utf-8?B?RDJRSFhKMWxkWGFjNGJvdVpVbEE3anIrR05SL2lvSDNIN2JMejdRL01ITzlo?=
 =?utf-8?B?Zld2QmZsVVVvbEJWbExVUGxYZCtQNWRDSzlxV2plV3plbElJRTJmMndIdU9X?=
 =?utf-8?B?clhGOTJXbVlSZDhsOC9sMDlHc2pZNzhWRUhybXMwZlJYZWc4TmhsTGpXT084?=
 =?utf-8?B?djBkWEk1Q0VZQlREVnlmRXpWU29NN2hYcVFPa1ZJR3c5b3lnSVBmbURrSTJk?=
 =?utf-8?B?TmZ3c2RZcDl6c1lEWFcyS3hvQTE1Y3Qxb2NDdG50QWhwM1g3LzlTOFRSU0F1?=
 =?utf-8?B?NHBDall4SHF1NFNOdFllZllPa0dBRmhYcHZzUUtkRVRlSTY2bzRIMzhHbCtP?=
 =?utf-8?B?eXRrMmJQVnBCT1oxUzZkc1BWckFZUVBZajZzSDV5RmdEVGNpS1BaOCtoSXlO?=
 =?utf-8?B?MFhrenc5azdzMGMyWUdDejBtdmNaNXdOZ2hTNmVHeE5hVEFVUUFWcmxrVjdi?=
 =?utf-8?B?clhvaXJqU0ltZnNNZ3NtYS9lYXhFWlZnRklseWxZNmNsRjlFNjNQWWsrNFFH?=
 =?utf-8?B?UHF0QU14V1JnN1h2UEpRNkY0R0czelg5R0FRMkR1UUR2bWorVVV3Y2g2dXZ5?=
 =?utf-8?B?SVEwY1hmeEdVSllrWkptcEprdFJWQU9uRjB3MHZxQlJTN1B6cEtJa0FYcVBO?=
 =?utf-8?B?bWcrbitzeGhxbEV3L2pWeGl5ZDJCdnVBS1BCMzBkNDMza0crdDJmUXlSMXho?=
 =?utf-8?B?ZDEvNGZIdllpbDd3UTdhUnJwbDZzT1NKWHVBa1IzMmNoYURQTlo3WDdSNnlZ?=
 =?utf-8?B?WnVBaGRCVnBHdDR0enBKMTZ1UngzZW85ellXUW5sNWtlaXlJRnNpbnZsdCtZ?=
 =?utf-8?B?MVVDenpudDhyNG9jZEpJRVRNN0VOQ3VmZGM2ZU9hb2JxN3hFVEsyRFlTbXZP?=
 =?utf-8?Q?dVt6CCRGRDqQT/nBfD6f+EjDW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a325c7a-69af-4711-1d98-08de0d68f47b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 10:35:56.6874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPFa4syaK4t+wqlZDckY+nEzvU0b6uZHd+xl+WlwlIFY4YbXMRym7DBIyoZrEZ94Dayb3byhYghdE2zF3nTo+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6199



On 10/16/2025 10:58 PM, Sean Christopherson wrote:
> Drop the KVM's re-definitions of MPOL_xxx flags in numaif.h as they are
> defined by the already-included, kernel-provided mempolicy.h.  The only
> reason the duplicate definitions don't cause compiler warnings is because
> they are identical, but only on x86-64!  The syscall numbers in particular
> are subtly x86_64-specific, i.e. will cause problems if/when numaif.h is
> used outsize of x86.
> 
> Opportunistically clean up the file comment as the license information is
> covered by the SPDX header, the path is superfluous, and as above the
> comment about the contents is flat out wrong.
> 
> Fixes: 346b59f220a2 ("KVM: selftests: Add missing header file needed by xAPIC IPI tests")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/numaif.h | 32 +-------------------
>  1 file changed, 1 insertion(+), 31 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
> index aaa4ac174890..1554003c40a1 100644
> --- a/tools/testing/selftests/kvm/include/numaif.h
> +++ b/tools/testing/selftests/kvm/include/numaif.h
> @@ -1,14 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * tools/testing/selftests/kvm/include/numaif.h
> - *
> - * Copyright (C) 2020, Google LLC.
> - *
> - * This work is licensed under the terms of the GNU GPL, version 2.
> - *
> - * Header file that provides access to NUMA API functions not explicitly
> - * exported to user space.
> - */
> +/* Copyright (C) 2020, Google LLC. */

Given this file got a complete overhaul in this series, Should the copyright be 2020, 2025?
Not entirely sure what the rules are for this.

LGTM!

Reviewed-by: Shivank Garg <shivankg@amd.com>
Tested-by: Shivank Garg <shivankg@amd.com>
>  
>  #ifndef SELFTEST_KVM_NUMAIF_H
>  #define SELFTEST_KVM_NUMAIF_H
> @@ -37,25 +28,4 @@ KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
>  		   const unsigned long *, nodemask, unsigned long, maxnode,
>  		   unsigned int, flags);
>  
> -/* Policies */
> -#define MPOL_DEFAULT	 0
> -#define MPOL_PREFERRED	 1
> -#define MPOL_BIND	 2
> -#define MPOL_INTERLEAVE	 3
> -
> -#define MPOL_MAX MPOL_INTERLEAVE
> -
> -/* Flags for get_mem_policy */
> -#define MPOL_F_NODE	    (1<<0)  /* return next il node or node of address */
> -				    /* Warning: MPOL_F_NODE is unsupported and
> -				     * subject to change. Don't use.
> -				     */
> -#define MPOL_F_ADDR	    (1<<1)  /* look up vma using address */
> -#define MPOL_F_MEMS_ALLOWED (1<<2)  /* query nodes allowed in cpuset */
> -
> -/* Flags for mbind */
> -#define MPOL_MF_STRICT	     (1<<0) /* Verify existing pages in the mapping */
> -#define MPOL_MF_MOVE	     (1<<1) /* Move pages owned by this process to conform to mapping */
> -#define MPOL_MF_MOVE_ALL     (1<<2) /* Move every page to conform to mapping */
> -
>  #endif /* SELFTEST_KVM_NUMAIF_H */


