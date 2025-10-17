Return-Path: <kvm+bounces-60289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E11C2BE7CBE
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 648C835C449
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 09:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248963128C6;
	Fri, 17 Oct 2025 09:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3m75F0/4"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012035.outbound.protection.outlook.com [52.101.53.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968A31282D;
	Fri, 17 Oct 2025 09:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760693662; cv=fail; b=I7wsb2fLFgfzKpJuztao07OkAyuLMDBUV0OS+DXdo++4e+TAEuF24sRoawZJBZ6+sHRZBpC8ce32xlEpxFwSL8lVJ8VFptHXHIxtDQJ+NA/PCR6GPo9vX1O1a1DmQTN2YXbtSRugaP+xCfXYxdvZVOf5TmuGT9Wl/uavHJF5KCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760693662; c=relaxed/simple;
	bh=GDTk2ynrS43n1iOtfwxVqOv+QyozfAxOBPQSf+s3w90=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=izQOWO/L6XQYkNkUwe1jssZur1x70XpovMJfHAjxXGiAeRuBzFiDEJqJC3r8iq0yUefPUQeOtVToAerd8UA8qidkw/SyIbS65GRZrfy5CmfdobUN/KIQjg5SQLopdgwKkpjg2G2Svh7qhaCC0KxT8v6CASmiz4Oo+ROmpSiotdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3m75F0/4; arc=fail smtp.client-ip=52.101.53.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnWY25u9PreydOhtuMohHXaOgNKflICyOsDIObEqwzc9SXFD2sxTSviLMH41UOr7+xKmJ4qqpNU3aN8dq+jWdAJYMAsVO+WdwigRbX/N2Pv13+jsxf96+HC9LiqY+9o1CRx4BPxKv1kNpl8t4+lVIxKw2SBZqNLv0tuec472TOrWDvo/JxnhEo5Y6rfzuGFDBhVDeBzYs6LzmGrO8c++T/6GK5GU8dX4NES+it1lPrDF0zxN9yDzW3A4LbULZ6X70/hFlmAYCD1d1S2v0vP+Ozo7uV0UU+2+O+ouhy/AKjpK1ASeQjZ326ye+1W5fTZgttK0a91sKVmBosX0yWenCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTT8w6oG7luGso1wNdsJw+/8Qel2/Q5qfqaTTWppO0c=;
 b=hfvOKyzKVJ/OMqJeFj1h7yiXAttDBxpvvNAMdtg7V7x6pkQhVsYWDn7WGpOmPJ29aXAUIvGzqpp4eC6j9mPYFxJUVH7nVcg4DHOwOs00M+/fqBSiI92tCz89HRRfsigW1C1IUzBalT07Sn2HNqy9t1k9udzuuthq+5M/SFa3UcVxQAaPoWDRZghgfmDvlg1iWZo8xmq3kc+/GbbvLOuf+cYI6EvhqS9EmIrHn5xZSUfuOABqpdORZGfd7APLZW+/qRmCBi8u14NEvP4QiGdIL1Qm2TfakZHSh0UXc431lsZPjX5LZ+zPdsxxpLUOvfEqsLkaxegH3dBhiJTHuC4fcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTT8w6oG7luGso1wNdsJw+/8Qel2/Q5qfqaTTWppO0c=;
 b=3m75F0/41Fu+7sdz+mW2qzDGWKrv6vGh9CFq0OFJre2y2G6baNYoD5aGwU9y1N1OBMYCMp6fpU1YL9OKw0NmR291wY07QT153NhWOgAj5dRQwjEmazOgDXArfa4mPvtW1hFWLvopZLg20F740Sa3R006CQXLcJXq9C4Wfi21z/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by PH0PR12MB7471.namprd12.prod.outlook.com (2603:10b6:510:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 09:34:17 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:34:17 +0000
Message-ID: <53979b56-a366-4f61-85bf-f8a612d48dc0@amd.com>
Date: Fri, 17 Oct 2025 15:04:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 02/12] KVM: guest_memfd: Add macro to iterate over
 gmem_files for a mapping/inode
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251016172853.52451-1-seanjc@google.com>
 <20251016172853.52451-3-seanjc@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251016172853.52451-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0240.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b1::6) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|PH0PR12MB7471:EE_
X-MS-Office365-Filtering-Correlation-Id: c6fa2c7a-88bf-4ee4-fe8b-08de0d60579c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emlTSSt6ZmpVdHdrU2E3U0JuTXR2TmNIa0NlQStNR1E1RHc5Si9yYUJ6Qm04?=
 =?utf-8?B?WWlBcGZFOTRnV0NPRDMyQnhnUllFM2F2TFk2YWl2ZDlmc0E0WVBaQmxQVU8r?=
 =?utf-8?B?c21Pa29xTnJlT0V3ZkhzWDY4V1JyU2Ztc1dpbVc0S3BJZFRlQlYxTUp0ZDNj?=
 =?utf-8?B?SnorMkM4MWNwdFQ0ckNqTXNJazJlNUNjSXV3MGRWaHBkeFd3MjF3NGFVY3NI?=
 =?utf-8?B?Ym0rVXZxTGduNzVObk5kMHhoeFBQVVdQNCtCcHIzWUNnVGhCMjFRZm9RWTRF?=
 =?utf-8?B?d1BwbVYzcHJpYVNQdXBkTFN4WFJoYmx6U0RsWFhsOW9mOUxwNDVYbGdEUmdW?=
 =?utf-8?B?cGRiVjRIT1Y5Z0V0TmxySzA2ZmpFV3AwemJFMXoybEM5UDJqSm5RcmFDYjRD?=
 =?utf-8?B?UDB4eWN2RmtGS2x6VUxlcVd5aG5Wbjg5SFRrd0h1SERUSUVuTnFaOFQ5TGRU?=
 =?utf-8?B?WFNYazJnVGRNK2tBaUowK0d5cUhoRzVpWndIOFNrOXNFY1VhOWp5UkduSzJX?=
 =?utf-8?B?dzI4Y24rajJTNDB3ZFhYeStqSHBkQURmejlqeEdXVmxPbDhmd2JQQnVqRGd0?=
 =?utf-8?B?bCtSZlR3b0RPY0g4L0R0anVjL2h3RDE1a0E3QnRxVDB2amRnT29PTTcxaDR3?=
 =?utf-8?B?K1FLUmVJUW5LSmJYSlRIdnhVNjdqQkRpRlVqeVRXUVJmbHNHaUVWT0c5OXdH?=
 =?utf-8?B?aG16RXhFd0Vwa1VGMkZtcFduREpVUXUrcTBDaTZFWElCc2FrMjVwZ1FneUFG?=
 =?utf-8?B?S0U0T1JiUHZiYndjQXBWd1JkNktXQ1BINEZJZGd1aXVnaEhpL283QzFvNVZ2?=
 =?utf-8?B?VTJYU1E2eGdtVC9ZUVFudlpaR2t1RmtKYzU1c1Vud3grWkMyVVE0QVcyNE5Q?=
 =?utf-8?B?Y2FPU2ErakI4RVZKeU5Zc0llbS9EZjF2azRTaU5ncU4rN3E1T1NqNE5obDQ4?=
 =?utf-8?B?WmZCSUc3QW1MV29hWWs5YWJFUmQ2WGNIbHprMk5mZHdOSUdRTFBEWGVkdnow?=
 =?utf-8?B?UjZzaUE3eHdXNUFIRWtHdmR2STRoWk5Md3lFQy9nVUVJWjcwVk15MXdhVm4v?=
 =?utf-8?B?Q2JjbXRBZWUxaDh3Yi95ZWpYeWpoeCtIc0x3aHh5cnpUTktKT0V3U2pEeHB0?=
 =?utf-8?B?Qm1qUHFRa1hiYnd5YmdnK2xIeUdOd0t6UkdMNHdaWklobUVxNHNqWmlLSzY3?=
 =?utf-8?B?S0JtdDVSTWRWVC9sZEFsakZKbE5zTDRYajdVa3M4N1Brb0FuK1BZR1NOV3V5?=
 =?utf-8?B?cDFvNlJadkt5WlZwRlZHdVZxWDdFTzdWOFFIZjUrV0JPRXE2V0dmd2h2cmEz?=
 =?utf-8?B?Q2p6TVhUVTUwdlE0RTNIVnhreFVhRHNyZi82bFhyMTlMTWFqNEZqUmFObUdn?=
 =?utf-8?B?UnlPRkVyV1E4SGVhcWNHa1VneGI5L0lDd3N5eW53MmRIM1lXemY0N0dHRGZI?=
 =?utf-8?B?cFhXaURRSzBzcFl2UzgyVnEzTFRmcWZSWlRSWnJqVkNhckc3WnJwcGUzQ1BS?=
 =?utf-8?B?bm04K0RESElQaW02Z1libXQwYTBnRkRTVFdBUjgvR2RmdndBNjkrdTlSdWJ3?=
 =?utf-8?B?cGJDL0ZGbmFDRUNpckdNdGQ4cFc1Ujk4Wnc5VTBRSWtCclJJSDNEaU82SXNR?=
 =?utf-8?B?L3FjTmJYR1ZhYmh4OXdFd005TEdyYlBUQ2VkNmRqRWRJQVZkMllqVU5sUERn?=
 =?utf-8?B?VFpSRk13bzk0Rld3M0ZEV0wvblNHYndHM1lNMjE5YTRCMXgxdEcvZUdDdWpn?=
 =?utf-8?B?b2l2UmYrTDhhb2p2dzVFbEtQQXBzTEo0aHRMci81WUlYYW0zM0ZCbWRkNDRi?=
 =?utf-8?B?cXBjUDE3NC9qVkl1bURrRWV1ekdOWjBxSEp3RlZTRCtOa0RrSGxuc3lleTlr?=
 =?utf-8?B?M0NuemlLZHJ0L0VLSmhhR2lTSi96Z2IrTTlySGp1dFNGR3QrVndqZFp1Qk4x?=
 =?utf-8?Q?eV+832gTLne+F8AzzUJK/6RTAdet9Qvm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b01HM3l1ZzlsUU9oK3l0OGVCM0d2SnVqYThKaXZzK1pZQk93cnk4dzNENTBJ?=
 =?utf-8?B?THN0K2pna0VTdm92MThETVVkM2R0UHQxUmE4d0ZQMnNBMkR3RFJBb1AwbFFl?=
 =?utf-8?B?R3JlY2xMYXJrUnBoN0Y5c2svc2VPVGNhVTBGczZoeGFpTXYwbTAydnhwc0ha?=
 =?utf-8?B?U2J1MmVodTM0QmNTUWRxNmlTOVpEaVplZ0ppR2VkWUREc2pVUG56STJMNmpr?=
 =?utf-8?B?THRka3hnZEVtLy9Kc2VNMVNITEw2dGNsc0t4NGt0cWE4QUtnRFRNRGx1c2xV?=
 =?utf-8?B?dkZFdTlhUG9GbWIrLzJaSkhFVUR4SnozQWtLYytXUFg4NE9OaVY3Uzc2S3J5?=
 =?utf-8?B?TjhQNXRGTGFjWFVXcHQ3MEJlaXRnb01qekNJQTFlbWZNankwNE1pd3pEZmlt?=
 =?utf-8?B?RXh5NXpDUFgvSGJIZXhKeHMwL1Y4Mm40RU5MUmJzUFZLUzUzZUpNUXMrRVBv?=
 =?utf-8?B?Q0Y1dGxIVy9hSGJTNnhNTFZPckErQnlidERTbkpnM3JHTVV4NlJYTVY5aFo2?=
 =?utf-8?B?NDZkaS9CUmJ3Vi9rVXk3d0JMN3RQTUlQTHpsbGJTRDBVaDNUd1BqeEpNWDBK?=
 =?utf-8?B?ZFM5djRIb21MTGlJSnZlQXJNamVzT1Z5SjRSdzFtdGtwWjlkYkJldzVIcnlN?=
 =?utf-8?B?RjdxVkpIVC9LRTdCb1hyWG5pd3kwK2lDMW8vVGdzNUtuTjIvcDJhRDFsU0Q4?=
 =?utf-8?B?WHk1V0JOUVR2Unh0RDgrcHczYWx3Z0ppQ0dndXJ1eEtoMjB3Vkd6YzNpVEF5?=
 =?utf-8?B?T0tzV0xuNFlsY0JwUWUvOGFTOTNnRmxUb2N4ZERhVzAwQ2JGalhOYWdWZUN2?=
 =?utf-8?B?VFhBWVpwb2NGWkRXeUF5K3ExTkNzSjRYOVdRcUk3NTVoSTdGMVNsZnZ2ZWZj?=
 =?utf-8?B?Rk1LYUpwSXRqQUxhbDJLOVN1cnVOa3JMWG53OU8rdkZXRUdRS0ZYS1RUMHp4?=
 =?utf-8?B?c3lyMXdzOWtUYnFNZHdFSXdXdDNpaHAzQi9WN2VJWVRubC9DTVJ5V2xGaHpE?=
 =?utf-8?B?amxtaXFFTHBUYVl5QXRKczdiMWZINVJtZlU0NFpNTDlxcUNNTzVUYlpKTW9B?=
 =?utf-8?B?RllsbFBEazcvQzBoV2FvQU1sS1hCVCtDS0M4NFN6cUxIMjJHNVZRNFVJVzRr?=
 =?utf-8?B?cTRFYlNETktZckMyQmxEUWFFcmphekRmRnFwcGZCdnlDZkxpU3hCWHluYzRk?=
 =?utf-8?B?cWFUd2pGUndSZWcxK3BQNzlQUnByQUd0V0dLQWdWSU9kOWRncmJDMitwTmts?=
 =?utf-8?B?L3hLdnVVWUdTdkdlSmNGUng4cWJubkpKa09uVXMweDFXUjA3b0VKQXdPaHJi?=
 =?utf-8?B?bmpnYzE5ZmxWdEwwZ0JUY2FpZFBEYy9mcnU5eXA2OWZVUUVmSlAxdDJSYytH?=
 =?utf-8?B?eUZUMHlzcjF6V3AzVC9pWUpQUjZnM2g3NVlBWkh5ZUpSamNiVFE1c3NRZi9n?=
 =?utf-8?B?eW5qTjRBNkJ0c09pQkt3dFlBNU95NVdBZ0lMcTBHenYvcmNZYmV2SDZEUXdj?=
 =?utf-8?B?b0dSL2NtdjNBODNZbTFhblk1SDQ2eVB5OXlpS2QrNmdTbmZYeXJYVGRkNmVC?=
 =?utf-8?B?VUE2VzVDZ29pVm1WWGxWSUxwZU9pUTRFRWtJWDRVV1ZUUHJSRkNKOFd0bTdN?=
 =?utf-8?B?U01zYXU0VUtJMXlKTml3QS9RQVdnb3VRbXEzcnM3bzcwVFZsSkhuOXJKc1pV?=
 =?utf-8?B?N1FPYVFrNXM3dzRIWmtXTnBESkxjU1pDVEUzTWVSN1ZCUnNMMGdJQU9JVXlG?=
 =?utf-8?B?dHM5MnpLUTZyR0c4cEhaUVJ6dkZLcFBBWGptYW1mMWpQdWtpdFFDRjUzSEtl?=
 =?utf-8?B?NGlEMU1mM3JrM3NCWFRVL1AwNG16Wm1DL1I3VitCSm1wN0FLTXJEMEVoT3lP?=
 =?utf-8?B?UjhYVzRtQUsrRGpNUldLSWVSdE5CNUJwTmhsdzVsMXgzRlNMS2ZiRS9Va0NE?=
 =?utf-8?B?MlZaRGk1QnRJRVM0aDdOUjZKS1JYM0pXZ2hybXlvMG5qMm9SdDlSZ2R0SFB0?=
 =?utf-8?B?RFczSml6dHFlVnRkb1N2MDFvQVJqZE9QUE4yMUhBcUUwUmQ4M2RNMG1XL0Vj?=
 =?utf-8?B?Mk1iNnRERFlTNklqMTNQYmE1ay9EOVliRVZPWnR3anBhRDk3WHI0MHY3NEZP?=
 =?utf-8?Q?EWT1rQ4/jOJBqKVWsecpKSP6e?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fa2c7a-88bf-4ee4-fe8b-08de0d60579c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:34:17.4769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FKzCq5ndx3y1+ov/RpfQt1LiL0Kl3WZzeF9LhL3tCfIjcKQlkHmWbGalyS/JqsVLtPkmXE1e3spAUBBABmkagA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7471



On 10/16/2025 10:58 PM, Sean Christopherson wrote:
> Add a kvm_gmem_for_each_file() to make it more obvious that KVM is
> iterating over guest_memfd _files_, not guest_memfd instances, as could
> be assumed given the name "gmem_list".
> 
> No functional change intended.
> 
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Tested-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .clang-format          | 1 +
>  virt/kvm/guest_memfd.c | 9 +++++----
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 

Tested-by: Shivank Garg <shivankg@amd.com>


