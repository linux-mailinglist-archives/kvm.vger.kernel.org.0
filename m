Return-Path: <kvm+bounces-42999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBEBA82008
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 10:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCDA41B6678E
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 08:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4830925D214;
	Wed,  9 Apr 2025 08:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dsKznonU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2A4BE49;
	Wed,  9 Apr 2025 08:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744187436; cv=fail; b=Poccjij2ddyM+iK0zvU4yvLdfpksCYPPOwO+Db4rZCw3Ja0R6BqKnRC9J86cSfGvxK2j4T+kioYXsR1x4cXeyMbvfIZDcAguhrJ9VMJXdMWlUyP2x2vE4RyGZJiIljqPGHLIv6f6uWqZ4qhOmnP7igG3MeBJDzM7u2jDfbc7zAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744187436; c=relaxed/simple;
	bh=v+PH/cvizEgNFAyK2g7ObTqsFLe9IFF7sb0ARGyP9Nc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K/gF0Oj33o9hg36i6tQ718wt54UA08rUJV2rVeAIPWCiQDaNLTKzsaA7AAaxS6H6Khv75+Ml1oGDP9M7Au/NeF5fj52Kd04IuYiuIsMHrw9b8F7LNfa+jPLuzjK4EDVebEb2rp3S5QZrEOSkxRQOxqpu50w9cWuHDnN6Mo/gV3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dsKznonU; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VDSlud1BByqk3ht0j1Yal8/EePRMZraadkKXEWg8s6/sDTxHhxvJ0BHhxuGd34h0zOFhjCBeV0MAkpw03gsJqznDBh1q5Nc47FKHCmJDdGvWLdaLBNvh260i6ugQCQN6x6nlzXwlbk4MjdOrudhLPvbKSSqeqBJH8E4xfKYFYr+mUQTuJPSLmZ5imn+tYh07C9LS+u1v1JKb59AEko488Iz6Y5YO3tVntpKMC7xxKZ2NZJKVgJCi2OLG5c+9PslBfcPoCl/ThOAiU2MzIkiGRx4Krv4eC3uHkopSBj7sSs05KmfjiTxhBpUiL29mVEdUvH/Y4AofIXc8oSsRnNB9XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXj8DNmHRMDWH13SqX8pobhox1lmTbho4vZxoYr43DE=;
 b=xByHbljLQ7zOm9TWpNUwYm2FOAk2Y0g/DrQdqLqK5mW9KQliXLXxRLv3DBVmgW0A+z9V6R5bXd6BQDB3VSwm2OPiAPN0kfnUfN33bwgEaIh4nRgLCWFBECerVhQ1zSFS8tm+3NEt2TKeHGa7yE+Mv9LoSEGFcQA+L6EOvbZ2+vn41A+xVVnSqD0AisDle/lgJlIZ9IyDWZq+RP/GOzv6edqwGNRp/QN6QDlGzYy6eLCUVG24KuRG0waLIHcMfkAay796YkjBwHN7all1wEs/0xAcAgHPPmBGY45ZpsWZRQDVurmGzVW/hA/MYSYnt82F6K8zHD5mxD1n//AwJZUppw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXj8DNmHRMDWH13SqX8pobhox1lmTbho4vZxoYr43DE=;
 b=dsKznonUlRBFAEQKqQfIj6PFt5UPMklarsgheMGWIfYPI+bc7bNLPmp3amxgwCvJc3NUqSI6CnWED7ewfCAsiL9oVTMhEZP+uQyk+Y7d0zVpgJdARhuDCOjaKink3b5RUKFqw3dAFLsetQiibrnd/xzKaDlOaLnvqu0LNgFn/xE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH7PR12MB5620.namprd12.prod.outlook.com (2603:10b6:510:137::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.31; Wed, 9 Apr 2025 08:30:32 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8606.033; Wed, 9 Apr 2025
 08:30:32 +0000
Message-ID: <805ef636-99c2-4d77-9e2d-e4b6ec257e20@amd.com>
Date: Wed, 9 Apr 2025 14:00:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/67] KVM: iommu: Overhaul device posted IRQs support
To: Joerg Roedel <joro@8bytes.org>, Sean Christopherson <seanjc@google.com>,
 suravee.suthikulpanit@amd.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <Z_UaJzhtmIv4rAox@8bytes.org>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <Z_UaJzhtmIv4rAox@8bytes.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0148.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::33) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH7PR12MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: 873b753a-15fc-4c61-dac5-08dd7740ca9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rk9NZWM3Rjl0L2lkaE1kaVpwcGdrZUgyNVdkZlZiK21hV2pWNkYrNXlKK0N5?=
 =?utf-8?B?SW9FYitBekJMOEVGSmdPL3FqUWZBL0Jkc0ErY3o1Q09zT1gyWHBsT2ZmTFYx?=
 =?utf-8?B?YklrVTRscC9qUmZPU2xKMngzVklyVFB0Q2lmWDdoaHl6R0plT2QxeVFpdnF3?=
 =?utf-8?B?SkFHQXY1T0I0Y1RnMUpqKzRSdm8wM3FQNHNGWWJWU21IWS85OUgvaUNsbzI4?=
 =?utf-8?B?c1N3SER5cTF1ajlDUk5hR01tZHd5bGt4RXR2L05KL1lnWWl0Q01CVjlYdnNG?=
 =?utf-8?B?TDVsUEl5azlLaS9BLzVmNHAyd0RmRzQ3MGw2a01CZXdzOXJQMjhpNW9Xbk9U?=
 =?utf-8?B?KzBtS1dRaHBZU0IyeDhPck9PZ0NwQ09wakR6MWo0eTBYY2ZOSXFaNHIwbDE4?=
 =?utf-8?B?eWxDU0VRVzdWbEw1TEJ4L0ZrNm5RMDVtQy8ranJJOU8zbXVYRTh5Qk0wZm1W?=
 =?utf-8?B?OEFsaG1aMnkvNzJ0eFo3clpZbGp4cDFCWnVHdmdhTnJQNlh4T29xaTJDdmJX?=
 =?utf-8?B?bkh6dkxpN01ZYnYwQjZtMytMNEN1UXphbC9ncWU2Y0Y4Tk5nZEV6WnJpYnhn?=
 =?utf-8?B?T0lMVkJaWTFrVmpuVW5IVEdvWTBTa1lPdHZCN240bzkzWWRMQ1p2bFFmUXFS?=
 =?utf-8?B?UU5qS1lhalAvRWIwdTBaWi9Bb0YxZVlvMTBkL252cnpuaXJ0bnI0SjN4cnY2?=
 =?utf-8?B?STcrRVBnT1Z5RW1OOVZ4dFFtcU91YzdZSDZSSXIxcDBLQ3BKL00wVVNpeUVT?=
 =?utf-8?B?Ly9aTnpxYWpvRkNxSFFLeXo5SVBYeXpZVFlSQkFibmpGNjkxZVorckFVL25X?=
 =?utf-8?B?aUVZb3FQN0Z0RExNQXVZM09KelltemRYZGptUlFVQkpOR0R2OXB6M1doNU9P?=
 =?utf-8?B?QlN4YWswcUVFTlhIL1BhRzBMOUc4anpMdzEzdXFmMmlmcmhIMCtyUzVUR1Nr?=
 =?utf-8?B?VmY1VzRPYzVFUnRVa2Y1cXlpL2xNYTdpWmFiZEVJRjJxanNaSm1BU2RMaEFn?=
 =?utf-8?B?ZjNGTWNCcVlFVHVOYmRNZ29YWWJmRWZ3U1B3djBuMGw4cjZFMkVxN1hRcS9G?=
 =?utf-8?B?OW1Hand5RkkyT3VlQk9SMGFwQzFpRkpjSVRsMGJTM3FhZnFraG41NkptTitX?=
 =?utf-8?B?ekMyV0xZZmY2THQ4RHhCZkZaUjQyc1lBZ2RIalVIWHVOa2Q3Q2dZQS9YdGcx?=
 =?utf-8?B?MHJVZW9FdGFDeFRlNFRQVHRZd3NWVnVmQWxlWU9waSsyM3ZSWW1pL2w5aEZF?=
 =?utf-8?B?MGNmcktqdHhEQTh4ZVBMY0kzYno0eFZxMTE0dDJzZ1daQnBqWmc1MVVkK0d3?=
 =?utf-8?B?QUxVaGVQcWM0M1JCR0xvWG80czc1bGQwUzJpeUZJbFZMNnZZejJGQzBDYmZa?=
 =?utf-8?B?cEIwci9ablg1dFhUOVN0Y3k4NmlvVm9xK1JtR0w1UjQzSk9pYVhNSkxzYUdG?=
 =?utf-8?B?SGhwckhHL1A4cFZveUhtQU9VT0pneFFkSm5CTENxeUo3d215aFBhVVR1azYw?=
 =?utf-8?B?cGkwSEppeW84eEJlNDRBQkdIeTByOCtiRlZHaXYrRE56M05tWFVvcTR5VlUv?=
 =?utf-8?B?TEJycDJZREU3ZmFoTURNczdZOWVOb0pZdUJpZEszOVNoZDRwZ1YxT29TMEs0?=
 =?utf-8?B?V1E4MmtSdUVJM0hERFcySW1YTHdtQjFHSVZ1QnhYU0hLUmFaUFRRbnpWSlF5?=
 =?utf-8?B?NC9Cd214QzJXUWpCdGtWRlk3b0dyZyt3Zkl4a0R2ZHVhSjJ1YUM1U2NwVjJP?=
 =?utf-8?B?c2taNlpsNUlQaFB4YkxvUTNHdm4zZlRTMkFQajdQN2padGtLeGl4OUxYZ1Z5?=
 =?utf-8?B?K1ZYbTd1L0l4L09ITGlEVW5FQmNTeVZIWXJDa0dOVjBKYWRweDNpemZndjFT?=
 =?utf-8?B?eVUvT1Q5eDlOM0RMYlZpYVlCcmZYdnA1SVoyNm1jay92SUg4bmJKcTdYR2c4?=
 =?utf-8?Q?yN/TYoePghA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0VpbVNZUmYzbzFsNXJacGVHbXllaE83dEFmbGw3VWwwamVHdjFqVVNXeTFa?=
 =?utf-8?B?YXRRdjJtWWZ1b2c4YzBvYm90NS9pK0FQNk43YjZHUFRUSnVSQkVSVFJvSkJF?=
 =?utf-8?B?NjIvUUFEYXJuYVh2MWhwZUNFUjNKYmJoeHlSN1dtSnNVaVZLcGhBSXVTYjBp?=
 =?utf-8?B?cTBWUGhrWFNlZzMxZ1RLRVIwZHpRVDF1NnFRYlplL3dSb0Z3TTI2dDlXemVl?=
 =?utf-8?B?SmlQS0FBa3EyT1h3NCtydHhBZ29GM3A0eDBTNm9jZGlDWktYczRkSXJtME8x?=
 =?utf-8?B?NnNtVGx0aXFBWlptZFMxQnprcUtPOEQxTUlxTlpkcUJvTkdBc0E1d09Uc2tJ?=
 =?utf-8?B?RVNxaUptVmVRKzJMcSsrR1JxZDFXcmhOQzk5cmpyUWtVSFlNZCsxbUh1RTlL?=
 =?utf-8?B?ZUF5cXR2a25PNHVMTjE2Q0g5N1hXZ05wSCtSV1BBZ09FSVhRRlVlTnpMamVC?=
 =?utf-8?B?SG9lRGRwYVBaUGZqRmdwS0tuK1hQcFdzaGdkSkZyWGI1N3d3V0krWS9BQUVn?=
 =?utf-8?B?RUdHRlV3c1Myb1ZQTEZTcm00NEhMZ05RdENxMUR0WVhyTTJnZ1lFZmM1NHlD?=
 =?utf-8?B?QzZhdmsrRnJ6cjE3bTAwRzhqZlhQeThlR1FVc1F6aTFydStBQWxuaFkyamFX?=
 =?utf-8?B?Q0xUdjdVQ25kS092TmNzQ3hSRW5UVmNiS3RBMnE0MFgrZ2hScENlU0plN0Iw?=
 =?utf-8?B?NlpWNFZUeGFIMDlBblZNSE1kRUdqdDZUN3lhczllcldGVjIydEJuay9vVHlm?=
 =?utf-8?B?N0g4bTNOSTJwcFBlUVYwRHU3aXVBWFpvL1Q3WXFoc0pYQmRSZ2Fvbk4wM3cz?=
 =?utf-8?B?d3FEQSt3M2pkTThFSmxWZHhCTlRTcXlma0wyOS9vdHFIY1MxSXdqSXZTakI4?=
 =?utf-8?B?RUNJaHM4MGROeVpOQ0ZYMlpjWHA2S0R0TFUxeFVtdGJGaUZjVXBRNVo5dWFn?=
 =?utf-8?B?MEFoTTdwTUJqS0YrSWNYZ2JVenFYQ2dGTkJaalA1elMyc3cyTFFEcnFET3B1?=
 =?utf-8?B?TEF4cjZjZ2JIZGJhVC9VSUpxU0FuclJwQ0RnV2NPMzdxaGdRNnpyNk4yY1pX?=
 =?utf-8?B?K3pyOEZWcUdaZElXUlFheXIydmJTVTFNaVdmMkZaakRUWGNRazBkOWZsalk5?=
 =?utf-8?B?VWJtVFNnVUxub0NPRm5tczAvdXdMUUNOM0YrVjFoUmI1VVNxa2ZIUitCV0dQ?=
 =?utf-8?B?QXd4QmdZTDB2cC9MK1VXaktSeWNqSlR0YWsrWVVjREpmUnB2eGVDYTA1NERz?=
 =?utf-8?B?Um1SYmUybThpUnZidU5FV1l0K3ZHRXArVVUyN0w4TDBNeXhCd3ZlR0VFTkJv?=
 =?utf-8?B?N0sxUWNISEtzRDlJam5HU29PazJRRkdnM1ZBQ090OVQrMG9sRHNSSVlKOERI?=
 =?utf-8?B?UzFMa3FlRFpyV0JPWm9UZ0JzMVpBM1Z0RVNOUmkzaEl6OTlwTHFmdHNYYjQ0?=
 =?utf-8?B?VHA2UHJSK3hCRnZQZEVMeGRKcmhUdW9CdnQ0SU9vTTE4bnF5dlNCaHlqc2py?=
 =?utf-8?B?a0Rxc2tZUVoyaTg3MHp4QTIvOG8yUXJCd0FoQnY1SjlpaXRDamVCVnVuTWtK?=
 =?utf-8?B?TnVtd3g0czY2czBNRS81SXIyOFlBSGxYTzhSYnI5Z3ZXamgxRkJta2h5M2xv?=
 =?utf-8?B?NWc3Q1N5Z1MxdXlvSEV2VzhpbnY0c0I0cStHNjNnNkE0RHJvc1Y4ell6M2tk?=
 =?utf-8?B?aUhxYkJKbFhVYWpFSnNFamNkay9GdGMrN3ZLY3NOODhjeDMrMWRQSzd6bkY0?=
 =?utf-8?B?R0FFbkdTSTR5bmIyWVVzVTBua1Z1ZG5PbXYyTVlCbDh4UUtSOUE0Y1RwMnlF?=
 =?utf-8?B?NEppQlZSZm5JSUlocElYc2FnckM5OW9EQUUzeVJMeFRRWGpsU2xwMFU5aVRm?=
 =?utf-8?B?YUVpdmQ5SjdsMGdodkRzQmhtbmZ2QzFra0R1V2llK1hyMXdXK1pvSkx6bDM1?=
 =?utf-8?B?dFNYYWZ6N3huVkpuaHMrd3VxYXpnNGhpc2VRcFpqY0IwNENXWEJlZkUvREt6?=
 =?utf-8?B?RW9YWFgxU3RCRnBmUVNlbEpVV3d5dUpIVU9vMldYdU1sSDN4aWFaK0pWY0xN?=
 =?utf-8?B?UUVDMTFITWtRVUlBMlAwNVNxbVVQcHplTUE2NlpHL2JMdVp6dU9VdFMxRWNa?=
 =?utf-8?Q?GZQjuCJwy7GR3YFPs1ywhe+4Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873b753a-15fc-4c61-dac5-08dd7740ca9e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:30:32.1250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmJ23o3bYCce0D/db5IK7XrU9KzqszM3DxCJiYY3Y0MF6oogrbz6NBGuytD8d2Ak70wUX7J5mGuilqet8tQEAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5620

Joerg,


On 4/8/2025 6:14 PM, Joerg Roedel wrote:
> Hey Sean,
> 
> On Fri, Apr 04, 2025 at 12:38:15PM -0700, Sean Christopherson wrote:
>> TL;DR: Overhaul device posted interrupts in KVM and IOMMU, and AVIC in
>>        general.  This needs more testing on AMD with device posted IRQs.
> 
> Thanks for posting this, it fixes quite some issues in the posted IRQ
> implemention. I skimmed through the AMD IOMMU changes and besides some
> small things didn't spot anything worrisome.
> 
> Adding Suravee and Vasant from AMD to this thread for deeper review
> (also of the KVM parts) and testing.

Sure. We will try to review it soon and will run some tests.

-Vasant


