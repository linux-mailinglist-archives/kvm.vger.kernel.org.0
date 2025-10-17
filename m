Return-Path: <kvm+bounces-60290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C041ABE7E4A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 99C564F72C6
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 09:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D69527E1D5;
	Fri, 17 Oct 2025 09:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4TXN7qWj"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084E320C48A;
	Fri, 17 Oct 2025 09:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760694709; cv=fail; b=hlUY1btzyKK2DJrA3vM3El28Gn751r94UE8RjNpNuQ6QhU/Zwsjp4QtgGkEWu4GOqxO83sdWvgi1x4j2jO34b6/DoQTOGA/xlqYxHbIn0vg82dL3I8YfEHJKKc5f0XsI2mR9tmG/akcLj/fZIZvvBi8H/497/vqtFgmU6/Lfl6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760694709; c=relaxed/simple;
	bh=/cJ8L02KM7uH9XfYpIdtpOLNr+YC79bK8IPeP+Vglew=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aaqWr9gl6Wma4+e/yJPpEuFXtc3sJ9iLuQaZY9DgYKS4iyFqLTaj3Dd7n4+ic3R9fyUpR3ozXe+NRr3yXVaanfaBQTlGXWAWzZunnNi+S1vMzTQaZwLm+M5rdKNhzC9PzLyaYhYI6wIfT/hTFDGoPVzpAijJ0E450LXYmi5bxNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4TXN7qWj; arc=fail smtp.client-ip=52.101.43.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b0Ia73YYejWJKvj2SeOGSM2G9kCpnXmF7X/XNR3EDbtbW0EomAQ7kclkiFFP0zvn/0I/oOyZ7CgnTqQNdTfa513LD5lS4WYoDhenrmD4fnYrV6EhmqZKaMECm2clUfWEN+GgmF3ZFlOu4DNAUKjH7Fgrd5XpcJoxZcxEbIeWD1nAwV6x7O1jkP7Cmo48Scm6wrrBA0gLZTKa94/Pds6OjX/dOmepWLgt6aej2rcQ21zOjxEAVnK61BtYut1fULFIXwRo+MQCCozRMWYHw5W9Loc3enuNQs9Ntma4ZMPnuINwFzkV27vpWE9DI4EAvTU5fzoJxsBYWPtuSlTqNFMrtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwoS2G1log6q/mf6Ox4kQ6OpfNHlw1PUU/4NeXxJC80=;
 b=U4jFOwI42BE/Ha9x9p3M90HHiWwal6g+G/j8YphL2xUdN50mn3pqrgQeWA8BmodkBj3FgUmW3HXFUCuXJz3eoMNW1RJnpqVLG5O5eLMmSNgKRBb0zTv/s1ZipuFWSWZ3kSZJVVq7M+5119SgfX2fi5zVTQDrccA0Wpj0EWKFXXx6CxX8HvbhZdy3rMpvzRdFp2en7JnZsd+0mxBlCgC1FJeHt7yNR8FDTWKcGx16Nf/6mY/iobMqVnecvQHCld/v2pxy9LQaSwWj/I5Rkvhp8aphRfeqhlp+rzcpAls/Q0n57L42BjnmdRZLTCz8eh+co5b5auTgL5yEo69Eut/t4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwoS2G1log6q/mf6Ox4kQ6OpfNHlw1PUU/4NeXxJC80=;
 b=4TXN7qWjIYDdLRCTfHDbAOb0iBwjGSPG8VHTkX74Jx7defknazytkjvnGPPKUPBFpdMqWxKESwfv2DWZT4nwX3w1aZHIiGawgdEvmEuz9JqRtKSWq7GJIw2I3YXuyzaIh8kMvjGiLA/eOeYVraTmga4MKUxA8yvQA/7Fqys9Rps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by DS5PPF6BCF148B6.namprd12.prod.outlook.com (2603:10b6:f:fc00::652) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 09:51:45 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:51:45 +0000
Message-ID: <ea119c29-d559-49f7-9a50-95a0497643ee@amd.com>
Date: Fri, 17 Oct 2025 15:21:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 06/12] KVM: selftests: Define wrappers for common
 syscalls to assert success
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251016172853.52451-1-seanjc@google.com>
 <20251016172853.52451-7-seanjc@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251016172853.52451-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0006.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::11) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|DS5PPF6BCF148B6:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cb697a1-391d-4ad7-f417-08de0d62c809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjIvb21iSWUzRkMwcW0xYURYdm1ONWlOcUdCeXRkL0pSSjNrOUpvNDUrcUh3?=
 =?utf-8?B?MDhqOWFETWVYdzFlMDYzalZCMFVGU29tNTdpL3RHQzFKV0JGQVJpRUhHalBt?=
 =?utf-8?B?eEdhMXh3VEVCMVN2VFp0VGkyYjJFY29VRUg4d1E4QUkySVZhMWFjQVpPaEhh?=
 =?utf-8?B?eFdxVGQ0ZVROOTVIR1JibXAwTWxaU012VGJHbUdrbEUrU042TUgrdTdoRWtQ?=
 =?utf-8?B?emhZZUIyYkJBbXhIRkxQRitqeVNKVXVsN2haVG80YVhsL09hWUgvVFViTUJB?=
 =?utf-8?B?ZFpjbHZ4aERkU1Z0MXBGTUVXWGQ4TVA2YkVIc2pTdnljZmk1bnpMbmdiT2Fu?=
 =?utf-8?B?ckgrTWJlbmd4Q3VKOVE3eVVHUk9sUW45ZTVxRWRnVWJEOFptd292ejMzY3hl?=
 =?utf-8?B?WmJxRUIrV0VqeEZQeFRYOHc3SEJsRDBsOFpLTFp3Ym5sd2pueFJFTGkrT0cv?=
 =?utf-8?B?dyt2ZUl3T1l5U3h5VE5LNUdISEJmejJWTW1uTWluZTBDT3doL0RvRXkyVUs2?=
 =?utf-8?B?M29hbk5OVDZmZU5YZ24yUEsxZnZzWU1BbHJaemI1djdsODhRazNidUp4TVRt?=
 =?utf-8?B?Vk9KS0tYeENjWDQ4VlZLVXJNL2g2cUxRUVMxZXBlb3ZPMlRwZzR0Vy83ODZh?=
 =?utf-8?B?dFpnT0NPTzhNdzBsSThxZk51YXRBQkI3dm5WUjNYOXNCZ2tLQkFPTFlzWEFt?=
 =?utf-8?B?OXo0dk9XbDc2WW92VmJ6em1wUHRTMkZ5aFFVWGtXdW5oSElNU05QaFEvUTlE?=
 =?utf-8?B?WVFQRUltemo1U213R1E2OGwwVWpqcVJ5QXFuRnp6WnJleVpDSTgxMzJLM3Rn?=
 =?utf-8?B?WVlKUmZWVWl4RVFnNmU0dE0rS2FNSk40SkR5MHNIYXEwdzNaVHlaMmpsRkI2?=
 =?utf-8?B?MVBFL2I4UXIzYmdtNTRJdGhheUw0SENXSkpsU2NnSndjcjRvaFVaaUFleThs?=
 =?utf-8?B?WEFoaWw5ZDFmR0lkKzA1a3dzY2tOamwybHA5UW5aOGREb3hYWHhUZHk4dzZa?=
 =?utf-8?B?d0hNVjF4K1dLeDFzREhWWUF4WXcyWHFBMjl4S1VsdGNlczR6dnpUTG9NZkNH?=
 =?utf-8?B?WWh4OEFkcW14a0R6UzhxMWZTb2VYbWljRkVNNVdDR1RLcEdsNm1lMGFwTnFE?=
 =?utf-8?B?bEYxUkxGM0RQMVZzaW9iQ2xZNUJZbnpOSU5yWklkMUs4NHVoYkJ2ZFd1Umc0?=
 =?utf-8?B?TU93RUVtUzlsM1J6Nm01SEl2Q3hLMWxRMlVYUENIQlZuOS9VSzRsRjA2VXVM?=
 =?utf-8?B?VkZQRGJTZEZTc2UwZ0NhWUY4M1FkTGJWOFFBRThqRUp5OEdtaGpxVkIyemZH?=
 =?utf-8?B?R29aNVEydzFMYUQzYVVqbWJTdjQxbDVXRUQvckVxelBrbks4d1BVbm5aaWFM?=
 =?utf-8?B?NXNmMVRPZU8xL1lYd3NlQXlrT01DL3F3TFhvdk5yalY0bzVoVGMwdlZRbXlk?=
 =?utf-8?B?Z3J1U1NpeCtJRnZVak9Ta0RIelI5REFSOWpPTE1Cc29CL1E4cGJTNkZFcHhC?=
 =?utf-8?B?bGx2ZWlaMlg1Tit5TmRKSHd4Z1o1T3F6RldyWEpZczkzZjVDS2RGUUYyY0dP?=
 =?utf-8?B?TEMwQll6M1BvVDdJVlVOUE9RVnFGU095eWR1ZFd0Y2dndGNPaDZ1dVlrVHZo?=
 =?utf-8?B?M3cyeHNKRUpuMXRUVFZoWnF5RDlNdUErOWY2Ymc1YnU1Y2pabUJiUWxFM3pa?=
 =?utf-8?B?a25UTDZucHBYOG8xWmt6YTRHRzdmQXd0aDQrcjlhZ01xMmdBeVM3Qll2QjFY?=
 =?utf-8?B?SDFIeS9rbUVxQVhyMEY1akJiMWQzdGZpN3lPMzg4OHluTFpQM21Laldwdnhn?=
 =?utf-8?B?RmFBQjBWV1c5U0l0MlRrOFBqdlV6VnlRUUVrNjNDNnNUSVd3dUxwblNxckYr?=
 =?utf-8?B?TEhRKy90Y3Z6TXVrcHNvNGFOMlh3UE9GNGh1MklITTVyU1hreTh1Y1IrOHlo?=
 =?utf-8?Q?cUmbw1x+1XHLQN0Kef0Su2kMh01HqxH8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVprYnVUczFoNm4rNndvWTl2WlByak9Zc29XdkVHc1IwNHZNdFJMTUhlaDVl?=
 =?utf-8?B?R3Yya2s2K2NpTnR1a09saFN6V1FPMjNXYitNMkZ6YmdjZll0L1JYcmgxK0c3?=
 =?utf-8?B?OGt0SWVXdWVmOWZBUDExUHd3cG9nVVVURnhodFFNbE83emZvRUJjWStMbEJL?=
 =?utf-8?B?WHRGRnBhcFFETGhMd2N4RjdmUFdvOFNVZlNBTTdWZ2VaY2E2WW5tV1p0NlNp?=
 =?utf-8?B?dkx2b2RCTzFsY2x5NGgxNngxQ000K3lkcy9rMTF1cU1BVnBzTDRVVVBvMkJp?=
 =?utf-8?B?Uit5a0VoM3IvWTlrUWJUY1RMZ1lVOFlab0RBelpqYmwxVk0vbWJNNzFzc1dJ?=
 =?utf-8?B?Z28wRWtPbGYzY2d4Wlp3UGIyZUt0LzZMb3RvTUQwN1U3Y1VFeUF5TWZycS92?=
 =?utf-8?B?SEpqR2xiamhBblNHZHdzM2RiMVpBSWtRMGlNd0tCMVBvQmpBV0FiVXhubVNh?=
 =?utf-8?B?dElBRHRVbTd4K0dyOUpYK3lrU0JDYmsrTnVmT2tibUJxK0hoTHU2Q2k3d1J4?=
 =?utf-8?B?S28xU01yUllwU1g2SzQwM3ZoT0JrMXUyeTc4QTNac1kxTXdBYTBFM25LYkdQ?=
 =?utf-8?B?anR6MWo2ZlViTDB6cVhMazQzcy82YzF5TnFkYzI0dWdmKzJ4QXNSNTNZU3hH?=
 =?utf-8?B?bVB3czNVSzUvdlVpSkZiZmt2a1dEWTR2NzFka2EyRXV1cTYyTTJ3VlB3c01G?=
 =?utf-8?B?MG1GUGVSNkZKSzFKeUNzMVlMR3Z3UldqNXE3UWtSMHNDSUpVV0dpVXZqZjYz?=
 =?utf-8?B?WlhHWVFZRHBOM2ZmbXRScFZTelZxVHpFdkloMThMN2xnb3N1WTNCcWNXekE2?=
 =?utf-8?B?aWhIUi9SQlRqZ0ptZXkwOEVkeTBxOXN4dEhCd3p1b3RhUHlQZmo2NHFtZjM1?=
 =?utf-8?B?cmFFRElOOTFCRlM0MGs2bWp4WHFrbDE3eU5MRExsVmp3OCs5TFV1NEd0bXh5?=
 =?utf-8?B?MnQ4eEZ0RUxtSmQ2OGphWStaUUZnNllqc3JoaHVkWW5oSUJmamVneDFza0hZ?=
 =?utf-8?B?NW1uNHhwdzJqOE00MUJ2RURFK1llVDAxdm5abVo5N2FrRVBaaXZhbXVRVEF1?=
 =?utf-8?B?d1lDTFEzanc4Y2FZVkhKWmNFZEJyMjBpS2c3V2RPejBYRkxQRzcvWDhIYmJq?=
 =?utf-8?B?TWdOWHdRbmc4NUU5OFVYekNWUjdjaW9EaUE0UDJtRzB2enlkUVpKZTBpZ3kw?=
 =?utf-8?B?dXNHajViT2VwejZYZk9MdDdVcUJabjNjQ3VDRks3Umo3MmZCWHZZU0R0UFpi?=
 =?utf-8?B?a01kdHlmVUZMZ3ZZME04QmdlSHR1cVBQeDhEYU9hRHJoT0o3d2JuUU4wckNr?=
 =?utf-8?B?MjJwcGxzcU13SngyckFBZ0Z0b1AwWXZudGxrWHRmSGplWkFIY0gzVnlZV2xz?=
 =?utf-8?B?QXVOTVFjdjRuR3F2RjJCVWdEZndiNCt4UStzNEwrVS9Cbk0xL01uYkxyclli?=
 =?utf-8?B?L3JyQ0RKLzZqSUNrV3V6ckpCRE5rOUNvWTZ6OHV1REpsWU9XKzVEd2MxTW5o?=
 =?utf-8?B?c3Ntay9yUWxtOHNqby9laExiRFlWMGtkMFJiV1ZUWHhlUkdoWnpCM3B0bG9l?=
 =?utf-8?B?bUV6VVJqbkJmVktuLzROQmlaNE94T3p1R213SnBBaXQ0MGFwMDZGMXpPMUgv?=
 =?utf-8?B?ZWhwelhDRGJUNjZBMTM5enZobU1NdHNIZHBJN01jeGVnYXU5VnBVMTdaREFS?=
 =?utf-8?B?eEJQOHlHZ1c1bVZCUmJsb0FrYXBRUjc0cVFxcTY2N3ZnVW5GT25aU3ptODMv?=
 =?utf-8?B?VTR0bVp5K0tobGdJOEVjblpZaExiaDVBeFhTYTU3Z0FLN2FVcFRxR2lSTXhV?=
 =?utf-8?B?NnRyNEI4OEJhN0NIdHVUZHZJL3BtOWxxQVA0L1ZLOTRtZExzS3BISXIwTzV1?=
 =?utf-8?B?UGVHc1ZRb0lyU1lvQWhsc1hCOEZOMjdPbUhzSTZzdEFZSWF4cUVud1dCREUx?=
 =?utf-8?B?aEFRR1VUWFNhWlpOSm5KOEJENS9XVjRmd01UNThFUkk0TjI5aTdpL3Z6QStn?=
 =?utf-8?B?VzJMZjJ6aDY0WmRENHZvYWo3TFhYQTQ4STROOUFVc3VhcGxOTUkrQ3V6MXNH?=
 =?utf-8?B?SFRaWWJkY2xXdmhBTURvQ3JlZkRMLzFoZ3Fhd1p2MlYrK1hVaGdMQURYZUlP?=
 =?utf-8?Q?l+JQ8TXSLnfZ4ft5jeBnAPor+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb697a1-391d-4ad7-f417-08de0d62c809
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:51:45.2338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijtHlBPhNdakRRRXNKLFg0QlCsJc5UDwH3o2KnFVH9uLu4PS/BnD1W6cJxkLKi4UcfXFensAeleQA9FT0yLC0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF6BCF148B6



On 10/16/2025 10:58 PM, Sean Christopherson wrote:
> Add kvm_<sycall> wrappers for munmap(), close(), fallocate(), and
> ftruncate() to cut down on boilerplate code when a sycall is expected
> to succeed, and to make it easier for developers to remember to assert
> success.
> 
> Implement and use a macro framework similar to the kernel's SYSCALL_DEFINE
> infrastructure to further cut down on boilerplate code, and to drastically
> reduce the probability of typos as the kernel's syscall definitions can be
> copy+paste almost verbatim.
> 
> Provide macros to build the raw <sycall>() wrappers as well, e.g. to
> replace hand-coded wrappers (NUMA) or pure open-coded calls.
> 
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Tested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/arm64/vgic_irq.c  |  2 +-
>  .../selftests/kvm/include/kvm_syscalls.h      | 81 +++++++++++++++++++
>  .../testing/selftests/kvm/include/kvm_util.h  | 29 +------
>  .../selftests/kvm/kvm_binary_stats_test.c     |  4 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 31 ++-----
>  .../kvm/x86/private_mem_conversions_test.c    |  9 +--
>  6 files changed, 96 insertions(+), 60 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h
> 

Reviewed-by: Shivank Garg <shivankg@amd.com>
Tested-by: Shivank Garg <shivankg@amd.com>



