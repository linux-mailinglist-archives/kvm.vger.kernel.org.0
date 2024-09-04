Return-Path: <kvm+bounces-25900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A73296C4A0
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 19:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ED071C24EFF
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 17:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A9FD1E130C;
	Wed,  4 Sep 2024 17:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XRbkBAyG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1C91E00BF;
	Wed,  4 Sep 2024 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725469248; cv=fail; b=dQPwBJ+zb8HSCjL8lwd/qqhnBvcCFo2vojOiWvm1hmhoS/KX3K0Xc2thSdgUd+Zv1fLmUTkfUu/BzIJ+JgzQ5kgsoKf0cWj3lInxIbOMly9T8PH0aOZfGglyvYJexDuIQo19dyVDNg30ak7rMvvXI6gWpsyzL8Z1x7rwIqQV/U4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725469248; c=relaxed/simple;
	bh=7TB2omnLqEzMgJU0Tf3hhiXNMy3htHvNeirCP6sx+gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BCYTPYsGy9WRRkXkFwr0dVkqKabvAPhNxfJky8eb6dyfp9rx2jRgO8PjfE9Yatkn8RknrwRqtPyPboNAjIfYVVNhHnjoC4kr7Ve6Buy7irn+Huzck2VkHce+SwiuJHNH8To454O03ja43yH8K/iuUWw2jyLROulRHNNX7MSoDJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XRbkBAyG; arc=fail smtp.client-ip=40.107.243.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXSJSqfsTzGKg+uGIKe8W5ZBwLRazCp1XTotqV2oxnJS93pBMh2H6JLIHOHeZmpdlpoU6omfmUFksIDDlW9hYhTt0Cpzk8TQ7+Jy0JCtZPMGX8OWTyW2WR/YG0bWCMb/HlfAZbsBM6rJdTPQoRYwZYu7z8EFsLoXf8SDkYBtOt6A9wb9tzc3vUm+khjRZSDg5DKEWd/pzaCfNMgxJnQ3Enk6A/m3WwzRNVdJTABMw0ZlaSnY7exwjxPY35+G7rwqbTjdQ/evxWnAaCU2ze4i9/3GRb7GMVO+XL/x58hD4I/AIjtBNPquIyElVCXhIqGecwC0pWya5vk85IhPEsMHGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMNwkBVTwANmVfo/V7ZlOn7P7dIdxcV2+nuGfeXHDbk=;
 b=u5e5ueMKv3VPGeBv9fl8zpdhiOGbUXWD1ZlR5cl5WQAX/QWYRCUer5fE2HCs5AK+qZGKAuScA5ZIoFuWTPbO/rtG3ydZ6DJRXWOu2oYKNX8Ookc5vLw9Zif0iSHbTQNJ7AQl5c8EwGQWThaxF+uI3IhfMudExJZZWxXqKEguI2LIHNJpzJgtlZ8EVM6bRN6k4iCNeegNRROLNqdks3sAZqDbi0vO9SN8/+I94T7y4VnUt/bSlWXzePCvvyjohHnwC726lq1H/8If7j5sFNZK0nkui6fIu7V+HzvQpPMlt/mKp1+2vp6+VFC4wCBawbhFzmkXye75scrSndh2QaBy4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMNwkBVTwANmVfo/V7ZlOn7P7dIdxcV2+nuGfeXHDbk=;
 b=XRbkBAyGUKkGNWzRWv8GBbehh2znd6rYBPjWo/fLA6SF5IFaw+IeS2XJ7JKf0obu6qVpAHHtHxCXhQbp/8V/FJWs8LL4K+CvhbwlfT2qpgAgIe7nTKJ5CpRVfDcdo2WtHPiNNEyFcm6jyBl4PvnlM3060i8Ctgy9qNkW8g0y7Cdw/cY+0qjLLtOBRIFSnMc9eHEBDdCkYzYCbDqLn95HzvBbFPzxHOCQzqkmj8kO/tUYDGzqAbM85QytOKjEosejECxVzI20gwmnxc3HokKBdo4tC0S9sxONksBJctk2bEF71f3EIEbwaJGKvg2jlNWuHh8ByH0Wlc3RmhAC7a4KgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 17:00:43 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 17:00:42 +0000
Date: Wed, 4 Sep 2024 14:00:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>, ankita@nvidia.com
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Message-ID: <20240904170041.GR3915968@nvidia.com>
References: <Zs5Z0Y8kiAEe3tSE@x1n>
 <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <20240828142422.GU3773488@nvidia.com>
 <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
 <20240828234958.GE3773488@nvidia.com>
 <CACw3F52dyiAyo1ijKfLUGLbh+kquwoUhGMwg4-RObSDvqxreJw@mail.gmail.com>
 <20240904155203.GJ3915968@nvidia.com>
 <CACw3F52qyX-Ea99zV4c8NjyWKgtqAKtNc8GP0JTcLOCOjnEajg@mail.gmail.com>
 <20240904164324.GO3915968@nvidia.com>
 <CACw3F53ojc+m9Xq_2go3Fdn8aVumxwmBvPgiUJgmrQP3ExdT-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F53ojc+m9Xq_2go3Fdn8aVumxwmBvPgiUJgmrQP3ExdT-g@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0302.namprd03.prod.outlook.com
 (2603:10b6:408:112::7) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MW3PR12MB4441:EE_
X-MS-Office365-Filtering-Correlation-Id: 463dea9c-1559-4dc9-230a-08dccd031c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHM2QVEyWmRSQU9VTFNKSHhkeGh3SFphRnpGOExHSk9xY1FIeDhoVWpaZmg2?=
 =?utf-8?B?MWVHTXgrVnNQcGpqejFtdk1tR0Uwdm1XRjgydUw2TGhSRWp2N1c3Qm8xQWVs?=
 =?utf-8?B?VjF5Y3hTV05FZHpRM0pCNjdtaWVjc1hid3BaaEN5RmxhTlNNYzREeXdJdlhD?=
 =?utf-8?B?eXBqQ3pnSlQxY203Smx2NEFWV0wwYm50QWZTZTVwVURLTTF6eWczcTF1N044?=
 =?utf-8?B?cENXUEpHRnNnTjUyMmdNQzF0MWNVUlFhcnBEeENQVWFiZCsvOVR5c1liK2ow?=
 =?utf-8?B?RVE2U2RvTk90Z1AxQkVOa3Jndjc4K3hyWW05YlBiajhTSmdmZ0hwRVoxTzYr?=
 =?utf-8?B?R2VrTFpDY1N3QWJmcXlyOHpQVk5GbWIyb1VOeit4SldTUExUOThZc3BWY0cz?=
 =?utf-8?B?RjIvdThrOTBTbllNb215ekhkTTAxMHNBQ3o3c0liR2xSemhLV1YzL1ZHWkxw?=
 =?utf-8?B?T21odXBkZUZnaEZzK0xNRUNCZ01tVmZjaExvaElQWTEzQ1R6aTNCQVNCcXJY?=
 =?utf-8?B?aTBHaDdnWDJjSUlaSDdBOU5KamM1L3JLMG1FM3N4T3duYXFJdTIvR3kybTFH?=
 =?utf-8?B?ZlRoYmpFeFBCa21qVW1jbWd4QTlMaTdrdUttWUp1ZzdiakJoZnlpNDhyR1Jn?=
 =?utf-8?B?TTFyenYrWGdOM1l3eE1ncVdTU041ckgvR01QSU14eHdlcE9pSEJEZjB5cm10?=
 =?utf-8?B?QUllL2FFZVNMdkRxcHhtS1N4bUhQRVcyakVxN1pBdDViTFN0RDR3KzlJVjNh?=
 =?utf-8?B?MlBRTGZaYU9qelExRVdPRHpwcVNnN2ZKenA4NnJ3dDdXUWJJK25ZTENZZlV3?=
 =?utf-8?B?UkpvQUl6bHZpUFF2ZDlJT3ZYYld6b3Zsc0hjSVFRK3I5T1RObXVFekd0dDI4?=
 =?utf-8?B?ellLb2Y2bDllZEJuNG1tcEI5OTk2QjdhcWJEV2k4TUM1N0ZmcHVkV0pjWC80?=
 =?utf-8?B?ZFJNZUZ5Um1oRVd5NFhqd3NCZG9ad0xPaFIvSkd2ZEo4QndueXQ4MWlJbXBD?=
 =?utf-8?B?cUcwWEhVb0h6K2JPSVRlVWtnTTI0U3p2eFRkUno5dmFVTE9WMElsTE0zdzZM?=
 =?utf-8?B?VkZiTC9hc1d2Vkl6QTkrZkhJbGF3dkNDNXhYR0tjenIwSzlPMTJCNENLZWIy?=
 =?utf-8?B?OGhNcGRkTCtpR0NQbll6eWFBc1Nva2E3VTNwckZxV09MTktwOURNZDdKWWxZ?=
 =?utf-8?B?aDJ1NSt2ZkNZdUFTWXMwOGF5KzdXSVV4T2dpdE9YOXVCeS9Sblo3b1ZyazFN?=
 =?utf-8?B?dFJMdkdJaXpRU1FTUWVNRU5kTldVelJicWVzT0M2NHZBSjAwR1NYaTBXaFdJ?=
 =?utf-8?B?WWxhK1R4QXVsYTdNWGZsZFZKN25HdjVEQnptamNwODcrZHVrM0VrOHdCQ2Vq?=
 =?utf-8?B?UDVIWUppdjlIejVaaE1HcVJQSStPdU1FVW53S2VNSXFZeTdNV3JrOVJ2Uzhx?=
 =?utf-8?B?VjVER3ZKdmVVWXNneGRmamxZcG9adHBtbDgrMStKVEJwK0IreHVwZGUzNzRk?=
 =?utf-8?B?NDZDd1JlSmRjNW44RythUUxvMjlqWCtKNXMybmEzQ3lDaUxTb3FCeDFMYWxt?=
 =?utf-8?B?a1FRZFFNQXlRb2k3RUh6SytzUm1COXpZUzhIa2x3djV2M1FVUVFpZVd3bXIz?=
 =?utf-8?B?OTJmT1pCK0ZtOGlCTll6UlYweElaeEVwRk5HcFpUQWNHaUJpcXViZmhqQzZ5?=
 =?utf-8?B?bitYdy9FUTVVTUJOYUsxWlBiNDVvdmJxeGFaUTBmcXFlQjhYUm9UOE1QbGgx?=
 =?utf-8?B?OUdzdW00NlhEN0FmYmtyQWt4K1NUV2FqbVRCKzN5cWphQlIvTHpxeUJ2amEr?=
 =?utf-8?B?Mzc4K2JZeFJua0RobTNWdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0d3L1pHNWgyaEhLaXRWYU9ObHJqRWlaSWlLZit5VDdQOUU3RW9QZWRtV0l2?=
 =?utf-8?B?MkRrMnNxdERkV0pjZytwNEFYVFNndVNwcE1CU2xPaG11QjUyRlRLVENOSVE2?=
 =?utf-8?B?eVZ1YzRrRGJXK0YzQWJhdFpNdStPSm5EaHEvMks0b1hwbnRGcm1vWnYybHVo?=
 =?utf-8?B?aklIeFdhUDZ3QTlhZ2JNbm90V215SDlHQUJvV0RTTW1rZHdQUUplWUlhbHBr?=
 =?utf-8?B?Vkd3cGViSVVoTitITDVVVTlWOEsrcS9NR0JZbHJVM1M0cTQzTFlMUUJMU3pp?=
 =?utf-8?B?MlhWUTd6eFc0TXpza3VPYUxPZDJGbmFobU9hZ2lWMjliMWhxNkRDendSQnFp?=
 =?utf-8?B?ZzBLWEh1WkxyZVBnNTA3eWhCZFpBN1FjamY5U3l0V0lyT0dZZm84OEVjOFNT?=
 =?utf-8?B?c3JLbVc4N1paN01qTytqb09yOHJzN2hMdzNheHNrZEEzR2lnZ1I5Z2hFeUVV?=
 =?utf-8?B?TFJGdHQwbWlHLzk0djJER05RaFh4Rkc2UVBqNG9XQmhMbVRYNWFQWXA1Y2xZ?=
 =?utf-8?B?UGNJU3NSckNxbjhqZWhUYW1LSW9ZUFJuNUZQSU0xK0pKeWhDcW1RTkZSbHZ2?=
 =?utf-8?B?UzBkZzZJcW4zc05ucXVWVGdsOXdCVVczWVRpRUNRWlJBeEJsNE4yTFZ1bUVy?=
 =?utf-8?B?MEZqYjhQMjI5ZUxxRzNNUitDR3RaWkxkSnIyOGMxYnlkeUNwQ1kzWHVpaW5S?=
 =?utf-8?B?Qjl0WXdGTWpmOStDWVFReHZnNUN6cHFnVllWU1MzTURaTzlldVRUVmEwYTRR?=
 =?utf-8?B?SUNjeUsvcSt5SllvQXNlVmprNkwzRVFRQnV4dktjOU5BbHIxNW1wVHpQRG1C?=
 =?utf-8?B?dTlVUlpOeUhiZnVLNFZJdWN6d0tidUlQbngyZ1p2V2pIMkU3T2RHL2VGK2pW?=
 =?utf-8?B?UUpkVVpGM2Q4MVdrTEZ5QmNLdEZTdElSVUNLdmhKRy9HdEg3QmE1ZlFrSTcy?=
 =?utf-8?B?Z1VLZU1IR0Y1dlZMeEI3bGlDdDRSVzczUDBWWVNzNHM3WFNGWVpON0xNZkQ5?=
 =?utf-8?B?aGQyeXBLYWZoMkFCUy80Rnp6M1JiZFN0ZnBrTXpzSXVNS1V3YjBjVzIrQXdH?=
 =?utf-8?B?N3ZaRVhtaUxaQ1lVamhwTVBiSGhlQ2FOOG1wd21QVWZCYUc5Y1pZeHRpODBC?=
 =?utf-8?B?K1Y3ZUhxNVpNcWFFNnBtTVgxMW4rWjdMQjhYMGRUdE01bERadE4vMU5HSGVK?=
 =?utf-8?B?Wk5IVCtjL1VGck14R0ZSdGczVmg3OHl6SVZsQ3huRGlhMWN0czg3TWdpd1Ri?=
 =?utf-8?B?dWVnUCtEVFJUVzFiNVRtVzJhOUNqVWZ0MFVldlQ4bzlGazVNZ2p2aitjdSt1?=
 =?utf-8?B?bWpqZmpBZWVOMnlZQ0tJc0hpQTJGbHZMeS9INUl5M1JOZ0o5dTIweDRreXNm?=
 =?utf-8?B?YXNNbTFIR1c5elQ1NXZzVks1NmJwZnZ6eS9wNjJvc2U3MEY3d0NZTFJjL0dM?=
 =?utf-8?B?eWxOeUVodCtVT2QyZi9uU3phWlg4cytjYkdqZTRBMStiRjlpcUJOMVYySHpx?=
 =?utf-8?B?Q3NyVGhPRlJza0N2MmFncGNXaDJaN3VYOTZFWGIyb2Y5VWpYWWc3T0NoaEoy?=
 =?utf-8?B?K3hsWDRtdS93SGZaaHNBM0J1NWh1UGlpTTg5eStpckt5YXJBdURkK2d5cjRo?=
 =?utf-8?B?MWRZbG9mcHhyRGJTd3lKTUNNRE0zY0RyZVNLbW1UckxiK2xyTVNFQWpKVktj?=
 =?utf-8?B?S2xFVzJvTTZ3VjFVLzhkc2tlOFVZNDIwc1Noc1lmZFFabElIYlE4UDV4d1pG?=
 =?utf-8?B?anNlR1l5dUEvb2xvR2tndUdvY2J6RnJWMXc5eEliZjk4UTA2OFJMYlJIMTZT?=
 =?utf-8?B?NHA5TFA3bVdBSFRPUmVZcUdrSWhxZXUyUU9xaUNGNGZ6cVo0N05XeWpDRHJ3?=
 =?utf-8?B?TTBiTGZCQnh6NWhsTGg5Z2UrRG5yVWNYcnhrZng3dEdab3hMMDNpZmFsRzlK?=
 =?utf-8?B?WnhFZ1RWajZaRlN4ZUNNTHVzUjVrVjZmRTJPWTUvOXpqRkVVWFkzWkVOc2ZG?=
 =?utf-8?B?QXZWOVM0Q3cyamhWb2JYMkFyZlE0THBrMEZKTW14azRJaXJ3ajJ6bUVnNjZF?=
 =?utf-8?B?dVZIQklPSkx4TzUrT3Z0MUM5NnFGNUtkcTRVbEVxSVFuSEpuQ2NYZVJ3dnlj?=
 =?utf-8?Q?XDQl8jBNvQyz0yPTaJH8eFXCA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 463dea9c-1559-4dc9-230a-08dccd031c7b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 17:00:42.7608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F//XSWoKptPGyUb8cIKqf3frMHOXAKv9/4tDdhAQKIRj5Gza6mH5jl2nH8VXqOE9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441

On Wed, Sep 04, 2024 at 09:58:54AM -0700, Jiaqi Yan wrote:
> On Wed, Sep 4, 2024 at 9:43 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Wed, Sep 04, 2024 at 09:38:22AM -0700, Jiaqi Yan wrote:
> > > On Wed, Sep 4, 2024 at 8:52 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >
> > > > On Thu, Aug 29, 2024 at 12:21:39PM -0700, Jiaqi Yan wrote:
> > > >
> > > > > I think we still want to attempt to SIGBUS userspace, regardless of
> > > > > doing unmap_mapping_range or not.
> > > >
> > > > IMHO we need to eliminate this path if we actually want to keep things
> > > > mapped.
> > > >
> > > > There is no way to generate the SIGBUS without poking a 4k hole in the
> > > > 1G page, as only that 4k should get SIGBUS, every other byte of the 1G
> > > > is clean.
> > >
> > > Ah, sorry I wasn't clear. The SIGBUS will be only for poisoned PFN;
> > > clean PFNs under the same PUD/PMD for sure don't need any SIGBUS,
> > > which is the whole purpose of not unmapping.
> >
> > You can't get a SIGBUS if the things are still mapped. This is why the
> > SIGBUS flow requires poking a non-present hole around the poisoned
> > memory.
> >
> > So keeping things mapped at 1G also means giving up on SIGBUS.
> 
> SIGBUS during page fault is definitely impossible when memory is still
> mapped, but the platform still MCE or SEA in case of poison
> consumption, right? So I wanted to propose new code to SIGBUS (either
> BUS_MCEERR_AR or BUS_OBJERR) as long as the platform notifies the
> kernel in the synchronous poison consumption context, e.g. MCE on X86
> and SEA on ARM64.

So you want a SIGBUS that is delivered asynchronously instead of via
the page fault handler? Something like that is sort of what I ment by
"eliminate this path", though I didn't think keeping an async SIGBUS
was an option?

Jason

