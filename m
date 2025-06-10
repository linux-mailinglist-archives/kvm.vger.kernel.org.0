Return-Path: <kvm+bounces-48775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A63AD2C95
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 656803AC33A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 04:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A24425E449;
	Tue, 10 Jun 2025 04:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1MWPXJO2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48CC25DB15;
	Tue, 10 Jun 2025 04:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749529524; cv=fail; b=fp8UZT2dzPoaMXII6dpb7fqjpvVOqqSRQ+b/5J9Scbji8NVEZB/QJAJ3MTOESDiHiWCCzgsHlQTNvE5RQXYF9+TbzCAZyT67bu8er5V1WIylKhEAARtmSJgi2Ojatp/x7Fq+y38GQgZd8WyqyaPB1qUsK8AcirvcMMkuqmsTIxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749529524; c=relaxed/simple;
	bh=Rw5NujuakZbhJzpSRUq5GIBPMEpM021+v+NTwNaMpU4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uiWWZPaYI1xjCznCHOMtu9i3WEwIaFHa/ScO8L2cqrLURKpg/kkqdsqFOqFuAbm5Gye+9/w9jLwHPVTOHk+krkPdXecpC1YSUrqgNehF9GHeAMRd6MjuAkyV6JjBWsbt9fVnCHf/gDH1DobowOzfzxyv2s4FDgfvqy75RhVDYCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1MWPXJO2; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H01d4oL+8oGlPF7qbJglQrD44YbpZ1wMIZD60ZM0xYjfkGXmeYgDOcBJOK6jf+qlyovp0dB6tN7a9yHI4mP4Jmf/hn87KIzCJOKgbzA5h5/6GaGn7ytjTYWsHpLtDmckccj9Enrbc4/fEV39PN+BymVG7Xi6PpZVIHDdQiwpF1+DEGrvs/czEdrE0PPYyRyjVN6408abYv3KzYQUvFnZw8PHvdgB1+lGD2krKsJGzOdOIwKdoKXWNkgfE4OYiIqvqn5WNvyNLiB0B9G5Oq/p9idOMYh2DsUf3nWQH5DkgEtKjSq6PyOlQ2REVXD9CUY+RZu+zeAKn7BxFMj+9c3/JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pb3mbsjTx2MC03cujn4a9BzYe9Vfwh7Wvgow31uv+RI=;
 b=qtWM1P2kTVpoOGNLApJQ+FKKgeIEfoqi4FHBTZQOTfjV584KZZ7thg4aGrrdjrKkEd2DYEk0zfb5QYnOuLjm+cVLyk0FNTrZO1HBQgMVP1Zmv2kMdyMeHGf4gs+rayCJN4DW5SAtQRtRJI5A5cGtquWg8PNLfaZd6KetSvD28VqgUh7pHZKfv/90cA3JHxBeOzoESGPl7ICKzVVhWxfyXSwXm3HluTXmTsuGPwrJ28ii+0fCRKKauzKJThNhixK+W03VltuSuzCGRma50D+yZ1D765xfuNBKEaf5WmjBS4LD4RbZE8C0a9qrrXMkdCKvioJWlaCGhksYxTC9dKleMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb3mbsjTx2MC03cujn4a9BzYe9Vfwh7Wvgow31uv+RI=;
 b=1MWPXJO2fNkXxxu1I9G64KSOFArEi5pUjty6pvtgHv/+4y1bKH2wmOJf/SLfuR27XBuAXa1GrL61p9wWGDvC2OxfCTm0roi7o9MwNCSq60ojK7Q5ncfuzERCYylls/BNwG4TKDXG5/hE87VnLscADjgYjXi5eFLFZBJ+yM2yrFc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DM6PR12MB4090.namprd12.prod.outlook.com (2603:10b6:5:217::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.37; Tue, 10 Jun 2025 04:25:20 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8792.040; Tue, 10 Jun 2025
 04:25:19 +0000
Message-ID: <515a52f5-c7a9-44e3-b33b-dfb9939de099@amd.com>
Date: Tue, 10 Jun 2025 09:55:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 07/32] KVM: x86: apic_test_vector() to common code
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-8-Neeraj.Upadhyay@amd.com>
 <20250524121241.GKaDG3uWICZGPubp-k@fat_crate.local>
 <4dd45ddb-5faf-4766-b829-d7e10d3d805f@amd.com> <aEM3rBrlxHMk6Mct@google.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <aEM3rBrlxHMk6Mct@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0082.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26d::15) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DM6PR12MB4090:EE_
X-MS-Office365-Filtering-Correlation-Id: 75c80524-9adf-4c22-bbd2-08dda7d6ce0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0MvdVcwVTUrNUxIS0thaXI2VUFNWG4vMEJEaGxEYkZRbEN1a3d3Q09LQ1Zk?=
 =?utf-8?B?UURqejVZaUc4UkVnVEFLc2cxL1R1QTRQb0tGS0dIbXc5K2QvZm9QNlVLSm00?=
 =?utf-8?B?U0VqNmNxZVp5eE9McDVqMGdqUmNtWjNXMXl6YTREVlFEWkEyTGllcWxSWGtm?=
 =?utf-8?B?UXZIcFRyQXJjTWY2Y3g5OVpZazQyME41Wi9OTDJHTEVpWEh0NUtWTzZTWXFK?=
 =?utf-8?B?Y0xyZVA3VUdQa1NJUGdFZ1Vnc3BmUy9VNFovbzZIeDhGYzYyQnRoSzc2bkxz?=
 =?utf-8?B?Nkx2UTRJUWI0anVXTXRORi8yd3FGeEhQK1g0Q0htQUZEa3U1aUNpV1YySlJF?=
 =?utf-8?B?K2dvYVJxa2lmYXd5dXI0SXc5aHNDTTlKV2pCei9zZnR1SVdMU0JjRHVBY0p0?=
 =?utf-8?B?ZWg1NlFSLzVRRmZ1eldOazNjVkQ1Y2l2OHVnZ2xKbUtJTWR1THFvWnlycmJI?=
 =?utf-8?B?VXkwalNaVDhtTytUdmRZdWl3dXBCUjRocFVoSHVVSngxWUV0NmFWUUt6T3Jz?=
 =?utf-8?B?V1p3QWFQN29lRWVjL3ppa0NSbDArV05FTEZ0bzgwVlBGbUIzY0RhbHpPN1Fl?=
 =?utf-8?B?WTdVU1dwWFdpUWx3OGxscFZjcDFneUJzLzAxSjJJQ2p0SFhNalRFVlJZMWpM?=
 =?utf-8?B?OXF3aVV1K1U4UUE3Q2EyVWFmRzFzcktjWkNIa01WSFo2cHExWWxHY3lmNEVP?=
 =?utf-8?B?L0p0V2FHazNTbDA1YUtDRkc3R0dlb1VEMTdQUWJic3Rxcm9SNWhqNkMwaWly?=
 =?utf-8?B?OXRmRVFnUUdoRnNoaVJtTk5mMmx6T09jTll2MmlqLzVIZmZHV290ZWFoUkx5?=
 =?utf-8?B?bitLNXd1R3R0eHdwVzRwdGt4MW40WTVnZThGamt2a2c2VE5Sa25PRVFiWEZY?=
 =?utf-8?B?aUdTaVhVNjFCbXVvUWtrdEVsSmY5RVNuTUx3a3JQaXlad0tNN09sbkR3cTNr?=
 =?utf-8?B?OC9jZHR1UFhMVE1tK3pkOGUzSVJrcXB1cmFCTENPZnFwUS9tY2xGTkxFTG1I?=
 =?utf-8?B?Q1lLSGRJL3dZUEttU2toVFUwN1JNOUwxWEFRaW84SCtCWEl5Q0JLNFJ1WDNx?=
 =?utf-8?B?OFpzSUhyZFdkWGg5ejVrL2FpdzJtcGxkMlk4eEg0L29LWFc5YmMzWGZzYjBZ?=
 =?utf-8?B?TThLSDlYalBpcXM1SWU5Rm5IZ3FyeENaM1IzMjRWa2paUjUvUHZjbnN6OWtW?=
 =?utf-8?B?SjBNTFNiTXdvNTA5WU9ZMG5YaGRKMjdHRnFwYnBaQXNKbmdubGFCTzV5SzZa?=
 =?utf-8?B?eHJpUFg4eUkweFM3QkwyWWxRNnMyY3RyQjdwbTdzaWVZTnB4YTd0S3pxRnFu?=
 =?utf-8?B?YkZRa09nQnVYa05KTEphWXpLK1A5b3BDNC92Qk9LaFN6Z0Y4dU83ekJscCtq?=
 =?utf-8?B?d0trZHY0OXJ3THMzZ1pnRi9aeERnK3pVZndtSTlPZWcvOTdJbkFHN29hdzdi?=
 =?utf-8?B?OXFnbGRibXoyeUpoK2txaDgwZDJ2MEgyajVaQUw2cG9VemhkdmhLcVhGay9B?=
 =?utf-8?B?Y1hkRjNuc1M5Y2NMc05xQkpSTjFETldBMkg1LzNhRnJlT1BPOGI4RWhWYjNi?=
 =?utf-8?B?V3JkWjRjcWgzNW1BTXY3K1NrbE9wZmFuU3FXamxvMlJzKzhvT2ZzL0lJN2sz?=
 =?utf-8?B?emh3d2ZLK0VLNU5ITGdLRUVocmgzU2xUQTJhUmlmZkErdzNQMUFXYzlaN1pn?=
 =?utf-8?B?eWtjNmk1L0xueUZuV0x1dEloVFhJcEdweVJxNVoxTjlpRnFzZW9FM3FWQ3Zv?=
 =?utf-8?B?bDEvaURkQXRwb3JxNGdMRDdERWF6cDE1QUJSdmpaU3E4S1hFemRDOEhaSXlN?=
 =?utf-8?B?eTZLNFcwMTc4cElNOUYxOXRvbE9DMkFlZ25BSEJBdENoSUJWQmRWZTBXeFVa?=
 =?utf-8?B?WVRlNzhtd1BCL2RodmtuQ2tCUFJGVFVFZ0F5cklSQmlxN2F5b0VKZVcycFpJ?=
 =?utf-8?Q?TpZWg6apbt8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWQwWlo1U2p5dU9zbmF6dnZJV25Bd0R0ZnJRU2tuK0RzTVU3RnFVbWZkL3Nn?=
 =?utf-8?B?ZzJac3ZsckVqcHZPMmJmZlNFNm80eGFTcHpOV25xTWNpSzkzOWZRMHZzelE4?=
 =?utf-8?B?MkRQZ1hzcUNkNXBMcGJhL3JlcmtpcjJtK2Zmb1BRQkxsY0YxM0JuM0UrUi9X?=
 =?utf-8?B?dktNL1E5WFlKU1BwVCt0Z0FFL1o2RVVvMjIrTVdFbFNISDdGOXNOUWN0RGdx?=
 =?utf-8?B?Z3VIK2dhUitxV1ZPaEU0bUcyWVF2MWlzM1VFY05vQzVOMU5EY1ByS2lva0FX?=
 =?utf-8?B?VFpJVWl6NjdIcGNONFNzQTRSbXgxMlE2cnhqZGtVOVNrVDdXZk9CaUtFMHB1?=
 =?utf-8?B?Z1kyOWE2TllWWHBJSEhFajd0RFpBcVRXRWZqalY1d0M0Yy9RQ2xBVlFLd0lG?=
 =?utf-8?B?Z3hTdWgrbTJFdkErVHgvMUg4Wk83NXFCQlEydTM1NHVIdzRWVWhNQjQvcW1q?=
 =?utf-8?B?WHZnVjFQVEJYb1dwSXFuM3phREpKSDBncGJWMytsRi9mZjJoeEdsMUh0bS9r?=
 =?utf-8?B?RUlLRElUTGRJNVRVQ1lLekJKeW9iMnN3SGtLV3U1VnpwVTZKVWZydDZER2JT?=
 =?utf-8?B?U0JtaGlKa09CNzVoV3JiL1pGeTlqYVZ0eE9zMWlIQ3dRUDZJdkNxRXZWU3Zt?=
 =?utf-8?B?M3puWU40MitzZXZDMXdZZmlmZEVTb25UcW1EY294TjZ3d1lheTVoTHBjN3Y1?=
 =?utf-8?B?WHY4dU9BUXVmZGJMMGpSRFRzZ2JpZDRoV3lrSWs1Z2FYTU12TGxBNk03REVS?=
 =?utf-8?B?ZWJWamI1T284SmhMdW5IMEJoaVJlYytKcFBUeDRFYjYyL3FrVXhBZHJuWU5O?=
 =?utf-8?B?eEYxZXRsUDR3WDAxZzRqc1ZhejcxNDlLbkJLMk5hR1JzTG0xWWw4MVloVlkx?=
 =?utf-8?B?QnpRWnVOa3FjZkdHamRnMGRQdFg1aGNZdFlzSUVJSmtONmRWNnFkUVd6YWt0?=
 =?utf-8?B?R2YzNTZXR3ZtUkt1TytyRVZHWU9HdnZuWnJUL0FSNURJckJLbUwrS0tCQStk?=
 =?utf-8?B?a0VLcTc2YkhsL0lhRUpmYkJUaE9pZmNMTmpMVlpxZ0Y2cWo3cU94Ny8zZTN1?=
 =?utf-8?B?U0F6WjhCajhtMnVQRjF1V1BOTUpqSzVjOXp3aGpKL2Z1bGN6VFMrMDY0OHo3?=
 =?utf-8?B?NURoT1l5TzdwZzZJNWlzL255VE1aR0t2VWxaVlN5dXF0emhoOS9oWmp6TFk3?=
 =?utf-8?B?Z3pCaGVhaE9LV3JEdVlvZEtlVko0UXJRWGREbUIwMHgzYStCMVNzcE5JdFMv?=
 =?utf-8?B?SThVNUEwR0pEZm5rL3VLMktZamIyYWVTV0dnYjE2WXFlNTlVQ3dtODdWVWtr?=
 =?utf-8?B?RG9VaHlPTDFTc2ZLUkdvLzQ2SVRmRHVwT0pWTkdPU3Y1S1kram1MRmFVOURY?=
 =?utf-8?B?OWcrMEJmQjZZOXV2cnBaNFRlRWZjMUhheWx3bGhDclNLM3hrOEN1MFZpMzlT?=
 =?utf-8?B?YjlrVFdwbGpha04yM3FJZlI2RjBzRGxCUEtvUXd2ZWZIcDdyOFpvUG5uT3Qv?=
 =?utf-8?B?ODVFc0ZCenpvZ0NGOG9aTnFqTnhzS2lIeFVHRDQ0aVBZaXdjUXJ5OU5mRjIx?=
 =?utf-8?B?ZGhGUUxGZG5YMVpCQ1lrZytJTFd6T09ITmxBclNRRSt4UVA0RlZxcWRJK0hF?=
 =?utf-8?B?dnEvSUtMWEM1SFBDTEhBQk1hSVZtQUJOUUF4ZncwNm5BdjRxaTNXTnc4U1lP?=
 =?utf-8?B?T3FxYzdVVVVXczdVa3MyRTR0bDk0bjlWMVV3Z1ZOU1lGSTlaVUE1dkF3WWpX?=
 =?utf-8?B?TzdoekNRNVdsZWFKbk5HZk5ES3p5U2lqM0YrVTlRM2ZXU25TazZWRlJoU2lu?=
 =?utf-8?B?WlI2eWF2VXNDOUJGeFZzTVc5aGdybHFLU3hhM21KOGNrd3JQYWIrRDdXZUJt?=
 =?utf-8?B?NTR1UWtkaWJ6aTlNaGFFSFdXNHh5UGF4N00rZko4RmYwODNBc2VicnJRMzJS?=
 =?utf-8?B?dFlVYnhXTVh4cFNtZXNUTmRtWEYzTjRDazYrU2h1dk8xL1BJSzl2WnVIVVl4?=
 =?utf-8?B?c3hMdjNJci9uZ1hGVVdCUVdjb1VSS3ZhMVdEdXhqcGZ0MmtiZTg0TDFZWk9r?=
 =?utf-8?B?VDdEV3lZZDJhYW54MHdYdEw4a1NyenJwOEtMbTBwek10ZEFkOEpvMGc3cTlw?=
 =?utf-8?Q?d61mI8mQTq4kWI2xrc5rbCFqB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c80524-9adf-4c22-bbd2-08dda7d6ce0e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 04:25:19.2249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gTuwnahs3OtOqSdMQxne7rqH9aFxc1BNKp65f4uHj8wWOvHp/M2UVl1G7TUgzFQApSoQ127t3NZklD5PDKq/tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4090



On 6/7/2025 12:17 AM, Sean Christopherson wrote:
...

> 
>  1. Rename VEC_POS/REG_POS => APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET
>  2. Rename all of the KVM helpers you intend to move out of KVM.
>  3. Move all of the helpers out of KVM.
> 
> That way #1 and #2 are pure KVM changes, and the code review movement is easy to
> review because it'll be _just_ code movement.
> 

Thanks for providing guidance on patch structuring! I am working on this.


> Actually (redux), we should probably kill off __apic_test_and_set_vector() and
> __apic_test_and_clear_vector(), because the _only_ register that's safe to modify
> with a non-atomic operation is ISR, because KVM isn't running the vCPU, i.e.
> hardware can't service an IRQ or process an EOI for the relevant (virtual) APIC.
> 
> So this on top somewhere? (completely untested)
> 

Ok, makes sense. I will include this.


- Neeraj

> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 8ecc3e960121..95921e5c3eb2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -104,16 +104,6 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
>                 apic_test_vector(vector, apic->regs + APIC_IRR);
>  }
>  
> -static inline int __apic_test_and_set_vector(int vec, void *bitmap)
> -{
> -       return __test_and_set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> -}
> -
> -static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
> -{
> -       return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> -}
> -
>  __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
>  EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
>  
> @@ -706,9 +696,15 @@ void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec)
>  }
>  EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
>  
> +static void *apic_vector_to_isr(int vec, struct kvm_lapic *apic)
> +{
> +       return apic->regs + APIC_ISR + APIC_VECTOR_TO_REG_OFFSET(vec);
> +}
> +
>  static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
>  {
> -       if (__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
> +       if (__test_and_set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec),
> +                              apic_vector_to_isr(vec, apic)))
>                 return;
>  
>         /*
> @@ -751,7 +747,8 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
>  
>  static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>  {
> -       if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> +       if (!__test_and_clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec),
> +                                 apic_vector_to_isr(vec, apic)))
>                 return;
>  
>         /*
> 


