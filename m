Return-Path: <kvm+bounces-19013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE7E8FF017
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 17:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 282E51F222C0
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 15:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C05196D99;
	Thu,  6 Jun 2024 14:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G59l1F7d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6AA1A1865;
	Thu,  6 Jun 2024 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717685464; cv=fail; b=m+/rmwM26u2FuSgB0++uC+AYpPeRMFj4/1WXP+IUYyACit03f7YmNXiMpeUFQ9ltb+GUhU7xkkAtuQcsze9qtAtKwac1zc6P7muh2fh6Yb/dRfEKQHGLXUNsMbul4C+wzjtoD8h/O4XAns0C9t/6kB7VnoDxMu2A1YLGVx5J6ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717685464; c=relaxed/simple;
	bh=RwOEG+8akgbDuqKPvKklwEi6Uo//lWxjeBt6m9XiDmQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SVChlvfPVWsoetaBYcqt0t1Ynz5yVQp+aBbry8ZlamlYhA2EQ7Q9HcjK4yp7Ni8QJW4TZt52wZzT/LkKBkwuELqRHlyE3ddVgmwc/5iJDbXtuUaDd5Ovf5GVesGJY01m1lqqTixE8d3l6Q386j1YgWwrfGuV5qXRQNJJCLJ6rw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G59l1F7d; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyPKaXa86J+6uciq1QqHs21RcQ/DJr86r3EroLlf3W3t90rDWJtQO+N8kYy4CXxSk2Z7OOCNa1gafm2AvJ573S+GfHnYqzSTKMpnj5wZ8pcrIjJYyb3c+j9kZkbH/fbPJZnHiOYBzACvfYbmPVz8xy9yla894mjNc/yur3dwpTOdOAIyYalzcneoE+um0tmqQwwtX4M4c/LRpQOOnsjNJWkIEZ5viIt9PmfHKNNb0qPulhUslEwphfzBpP21boLJjZBCiQKdXhSfVzB+Zx68TPvj/Ille94U3lORCxUWU0On8qf8C3vbNQbhEgbbMiudDRfvQKqn+ZYBNFZ+e/dIkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4ArDr3sc8jCuo8SnGird6HvJL2POdKolUoqWfKQqn8=;
 b=hi3roauUjLsDs+jDgIgspRTpDGO2TE1ViBU+YOx/IBc3TD06vhYObQVvsK9koo0We1DdApCxUPXUlh4mgXIK/+zZndy70VqTQbP5119YP+0q9XPd82Pbv5IOL2PAuYtsjOV0u3rP2jEEaQNnsSxbaf5qRCyWIc+VAnBNDB/z7W8vxP4PS3lI1jv79kv9pbBHUvedzWzM+2pqy6zSxCJiCMYXwNLF8Di2qJtGvLn9CA4pXB0BxRPuJLadHPGFKYxw0GFjLeRNWCQsOic/AXjnRbp+4L5+Eqx30aKQnJmMosie5Tc633j81xGFQ2RM3jODO4V8+ZaNCvdueSsGYUMy4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4ArDr3sc8jCuo8SnGird6HvJL2POdKolUoqWfKQqn8=;
 b=G59l1F7dH5K2kqpcMAitUg6AdR9yWSO2HewFtuwNfN80NUU1WA8fwZfLaBBB4SpiFkJ0dILxjZtJ1gswZzkgtJgMF4UmMWHP3MRLPBKOjYGT8byJcC+uD8PsJ7jo4R9tO/vhZ/oNrtZeP65AyASsdtCdTZZmenYQni0PON7Eja0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MN2PR12MB4375.namprd12.prod.outlook.com (2603:10b6:208:24f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Thu, 6 Jun
 2024 14:50:59 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.7633.033; Thu, 6 Jun 2024
 14:50:59 +0000
Message-ID: <a66d481c-6d09-40f9-944e-148aed9eede1@amd.com>
Date: Thu, 6 Jun 2024 09:50:57 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH] KVM: Fix Undefined Behavior Sanitizer(UBSAN) error
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <98ad0dab3a2c66834e50e6d465dcae47dd80758b.1717436464.git.babu.moger@amd.com>
 <Zl4DQauIgkrjuBjg@google.com>
 <CABgObfY5athiQKdV8LQt3b=yKEgydOXRdfXeLz1C8Ho=ZrqOaQ@mail.gmail.com>
 <Zl4px2yauHdvDUbR@google.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <Zl4px2yauHdvDUbR@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:805:106::11) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|MN2PR12MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: 4822eb84-94c6-4e05-1d67-08dc86381425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFJYTzRJOWlZclNCdEJrd00yclVqQVVZMkNncHRXSWwrWFlleXIyQklPSEd4?=
 =?utf-8?B?S0dwUEFMQkJZWHc3UGU2bGJWalFENVRVbC9oeVdzclFvdjBmZ3hyRVN2cVhJ?=
 =?utf-8?B?Nm5MUzI0OUpTdHFaTVVjbWhlTnRlL3hXbCtsbzV2RUtqeHVzZkRkQXc3QUND?=
 =?utf-8?B?SjdNN01IL0NaeFdlc054djd0T09hbU1pd0x2RklKNWJJODJ3MU5SMk92VVVa?=
 =?utf-8?B?YjRTQzV6aHVIYzhXbER2S1FUNFk4RnExTnNLOU5IcjJoUXpDTXpobFNha3FM?=
 =?utf-8?B?azQxU0ZvcGU2azloS0RzR2IrNmsyanpvbHhRTHJoVFhKN2FXb3MwRy9MaWlo?=
 =?utf-8?B?TFB6aC9OZmhvZCtSQmRKaXc1WGliMy9iZ3U3L2xBNHdSSWoxOEJrTEZoc1Bm?=
 =?utf-8?B?WXVvODZxOGNBUnArdXo4SWFaOGxHT2JpVXRTc2taZUppTmYyb09HYklnYXM3?=
 =?utf-8?B?aWZsUGJXcHRuS2dYaTZqNG1RUXl6MnN6TGVHOU84YjBjalN3V2U1d09KVElN?=
 =?utf-8?B?bzJQWVp6VDlYb3ZBV2MvaTg3WXlFcHNwWExCSWlEZEtsc0V5S0w5eG1BS04z?=
 =?utf-8?B?NXFTR2xQS1BVVTNTT3l1SVU0eERoMGVqaXFGdDdHUURuVTBsL29ZTHE2NjR0?=
 =?utf-8?B?Nk9Sa1hkNXl6aWJ2ejhJdHZMQUtMeVBtMWZGL0g0RkcwcG1OSVA5Q3dkNU9L?=
 =?utf-8?B?T1daMkNBOWMyNFRVM291TE5rQ2FmS2dpczk2YTZFRWdNUjFEMUNBZ1JLRkxx?=
 =?utf-8?B?T3FHS0o2d0VPVVpvVU5GdFoyMmczSmlsOHlzUDdxTjk4WldXVGkwMWVzWWY4?=
 =?utf-8?B?b3BWVktnVFBMTlV6dGtlQlRWNGRzaVllN3Z3dW44TmE2YnZkMHErbldHcWhG?=
 =?utf-8?B?c3hBaFFrK2xMWDNLSHVpOGNsaFN5ODZoaC8rTEppcmZWZWRRWkdCVDNhNjlE?=
 =?utf-8?B?M0RkdFNlNUl4a25HYXhoMDl1OFo1ejZueGk1VXpCRGZMTmlMSXVQOVJxNTQx?=
 =?utf-8?B?RGhqK0c0c3k3c1RZUWI5TEF0YmF5V0c2dHE1bWJKbGlUek9IUXRTMy8yQXFa?=
 =?utf-8?B?dTBjakNJanZyNzNwcUcvUUdFN3RqMVM4aTVKOUlTbjlyTU5xcjJwL1VaK1JL?=
 =?utf-8?B?eFlyMlBrOTFmZG16Y2h6SCtHZ0hGNTNDcnVhN2FkRzFybzdDWHpUU3ltSjJP?=
 =?utf-8?B?U2dYVUxic1JPQXFManpuRm8vVlRqSFpiWEU3dmZyVUx6V2lXRDQ2ZTN1WE0v?=
 =?utf-8?B?KzIyZGVPTlViL3dqQnZUNEhiQ3FOdERoOHErQzRqUGdOTG1IZE9UUDVTNUZN?=
 =?utf-8?B?cFpNMVFFcVFWa1BEVGhEbWZUY0VoUU9tQmFRRXpBZ210UEJwT1ViY05KU2xW?=
 =?utf-8?B?Qzl4dGlNZUZjd1UxQUZsYVF0MTVvWkpaZFJKMHVsbUh3Uk1tNHA5QkQwR0pO?=
 =?utf-8?B?TU9DN0lQQktUWmZYc0lsNW9KYUwvUm0vTnYybktNNzFXdEkrcU1pVzZ0UENQ?=
 =?utf-8?B?MENQYUJIbkRQcHNWRkJ5ZnlPOW13QWVnREF0YXVIWkRkNUVKdVJJQjlMNFhZ?=
 =?utf-8?B?ci9nK2dXMHV5K3A2M3NJTTFQRWlCdlFZKzdFaWRGZlRMRkpYTTNjZzNlNUt0?=
 =?utf-8?B?MDB0NXowYm1ZNmZKQ0FFNDErbGd3Z1JldHVXNlJpZHZzSGtoN1NjK1dkSTlO?=
 =?utf-8?B?c0UxTldsWXU3SEd4NWtIRW1lOEV6TTBQa3I4MEFMN1BqTFBNMkFMUEEwN0d5?=
 =?utf-8?Q?mtDBEFhII+yhK8fFce7JkSg8myjtZuQUfhgTH2D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHhxb1FhWGNydzJCUERtOG9wcmlyN0Uwb3piR01UTzhOZzZDNDVyaHplaXR1?=
 =?utf-8?B?bmRyNXdzS215VXEwQkpQSDdZYjFMR1FOaTBGODJHdXhZRk9aZlFpZVEyQlFn?=
 =?utf-8?B?WXpiRFYyK3NpaVU4YmloSGhjcnJ5a1pHQVlVWGRtdGs5ZGg1SjZXa21tWW5w?=
 =?utf-8?B?Qm9lYXdmOVZuL1lka2hkM1R0YTNpems2RVZpdWcyanJMQXhXeWhTYTJlYnZx?=
 =?utf-8?B?TFIzZzdreUx2TzNJYmVCSzhOK09DZlpRWTh1alAybW56T2JhZXZPUmhBZ05v?=
 =?utf-8?B?NkQ1UGlwcTJiNWl6REZOa1hDYmxnYmQyQUpyV2hYaGdNSHczREowczFMbXBs?=
 =?utf-8?B?cDNRR3pQNDFHMEdSMjJhMW5nT0JMV3VLM3IzSXNyS2I2aTk2Q1M2WldvQ2lJ?=
 =?utf-8?B?NG9MMlhBdEV0N3dxOHZaeVR5VFY1YUV3cCt5WlpGVHdSQ1A4Q3VJNXkrbXhR?=
 =?utf-8?B?bjdiUWlFWG8zNTdsU2tWMnY0WFhNeXNQWFdKU3FReWtyMFZvMlc4bVZsY21O?=
 =?utf-8?B?cU5VNDlReTFFTjRqdkJTL08rWTFTUURvcUFNbzQyd290QnlEWTRQV1JPMEo2?=
 =?utf-8?B?NXV0amp3dHpFV3lPOEMrSXowbEhvcFplNnNtUE1QTVpUdFJKVTVSZVAxY3Va?=
 =?utf-8?B?ME55czM5OXNuTldoakw0cVRSajY2VWszdkJ2WDVtVXY0aE9MU01MZ2JDenlp?=
 =?utf-8?B?OU5MVHY2NVRCa2FldHhRSTJNSkRicFg4cU5jb3hLMjJCaXlqTnQ2TG1tK1By?=
 =?utf-8?B?UzQvOWRLN3NmSVhTTmgzb2tHSGk3ekx4Wkg0cXFCTWVTZUR2YlhUZCtPMDhO?=
 =?utf-8?B?eUQzc0tSUWJmYjFOREJINEY3djl3VGVJekMwV1NNclN5U2M2OTBtbURWVi82?=
 =?utf-8?B?bGQxMWEvcm1yMERLUnVzQWd3TGVXd0lNTno5cWxTNkRRYWZPbDZnUVBac0Uv?=
 =?utf-8?B?ZitIalUzUVFjZzRjRFZLK0VkNTQ5RmhsZUZieWlubmFTcXBibUQzeHRWb0Zr?=
 =?utf-8?B?NmRUbTdUL2lxWGhIeU9xaW5EdC9XWWJuMHVIeGh2aGlBOHNoMDdvUEg4SXVp?=
 =?utf-8?B?SU1vbTFMUGdGUEtBSnlFYUFmMG9oTmg3c05iQ09VL1N2YzFXNzh6cTdsN1V4?=
 =?utf-8?B?MTlpUzk0TTRFZ3Z1cUUxbFFSSFhnMituRkw3V0dpakU3cHo0eHAwTVJHejlS?=
 =?utf-8?B?NEIyemJJVWJMdnVzQ05DaldVekpzN1EwakZNb0FmTDYyblFGOVJtcWlDaHM4?=
 =?utf-8?B?ajZnTW9CR2g2bHMxamRvYjVaZjNmQlVrTkt0djdHc3RWM1FNTjNyUHByWEl0?=
 =?utf-8?B?MndTRjgvS0dOVWZPd0xYVGRybFJiNjZiU2FEUkZiSllIR3pzS0taekFaWjJV?=
 =?utf-8?B?SnJtTXZpYmFWakw5N002aUdJREJuOHl1dEJ4N0IyTGJ0M2dRRmppUlpkOW1q?=
 =?utf-8?B?K0JyRzlTblVUTTJsMXYrRGVmOHhRUXZ2bHZCM2dQM2UxcXpNT0JwTVdmcWll?=
 =?utf-8?B?RUx3NXk5cmpFZlhreDBuUStqZmRIdHV4SUR3NmY5cUxwcG1Oc3RWSG5IOWZX?=
 =?utf-8?B?bThLb2V3aGEyQWRZUzJ1a0YvOFFhaWVNeHBhUUZFdGRWY2s0ckw3bHV6bGlo?=
 =?utf-8?B?dnRhR3RWK2NGNE5mZVJHMkhnVFJPbzFERmNjR3ZUSnIwSW9QZVlNbWcxNmRh?=
 =?utf-8?B?SVNBYWpocVRvYlA0MnBZQjFjZnZhZDJVaTM5Z2xSWjBXUFBrODMyNGRRZm9X?=
 =?utf-8?B?djBpREkrZm11dkJaNmFMRExjcnFlTUh5YVdrais1Q2NtQ1ZZSUd6a2lGMDBB?=
 =?utf-8?B?UHZXbjBBOS9DWmU0aXRxVExBQ1FiYkx3a2hZSVJ6NnpESW9rMTQ4cWhWa3Z1?=
 =?utf-8?B?REp6azZwSkVuYVhLZVUwTDRseStMNVpFY2NOa2JkVGFpN3IyNG4vMm10ZHor?=
 =?utf-8?B?MjM1V3NwUEpWbk1LQWdBNTJyOHJXbUNTN05QbExpS2lKd0RHZFNsVGpzM1Y4?=
 =?utf-8?B?LzNSdFBtOFhwbWk5bkEwTktsbFVQdG1UV3RhNWgxY0hyOSs0T2JGNnB0Ynlq?=
 =?utf-8?B?cFNQa0JJRXdEZVZHbVVhTVNoVWd0MUtYdjVrREc3eGN3Z2tXRm5ub04yd1RZ?=
 =?utf-8?Q?2XUA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4822eb84-94c6-4e05-1d67-08dc86381425
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 14:50:59.5892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: anivabNH8w9id2EHQpdP1ciEwncgbksFgIEM+kI2i/hKqEpuYYvvUA3B+RT+C70Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4375



On 6/3/24 15:38, Sean Christopherson wrote:
> On Mon, Jun 03, 2024, Paolo Bonzini wrote:
>> On Mon, Jun 3, 2024 at 7:54 PM Sean Christopherson <seanjc@google.com> wrote:
>>>> However, VM boots up fine without any issues and operational.
>>
>> Yes, the caller uses kvm_handle_hva_range() as if it returned void.
>>
>>> Ah, the "break" will only break out of the memslot loop, it won't break out of
>>> the address space loop.  Stupid SMM.
>>>
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index b312d0cbe60b..70f5a39f8302 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -651,7 +651,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>>>                                         range->on_lock(kvm);
>>>
>>>                                 if (IS_KVM_NULL_FN(range->handler))
>>> -                                       break;
>>> +                                       goto mmu_unlock;
>>>                         }
>>>                         r.ret |= range->handler(kvm, &gfn_range);
>>>                 }
>>> @@ -660,6 +660,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>>>         if (range->flush_on_ret && r.ret)
>>>                 kvm_flush_remote_tlbs(kvm);
>>>
>>> +mmu_unlock:
>>>         if (r.found_memslot)
>>>                 KVM_MMU_UNLOCK(kvm);
>>
>> Yep. If you want to just reply with Signed-off-by I'll mix the
>> original commit message and your patch.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks Sean, Paolo.

I will send v2 with Sean's patch.
-- 
Thanks
Babu Moger

