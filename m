Return-Path: <kvm+bounces-49232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E50BAD6933
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 09:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DE971BC2F8E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 07:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5475E21CA02;
	Thu, 12 Jun 2025 07:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iUFjKKkn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2080.outbound.protection.outlook.com [40.107.212.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AF321B9C8;
	Thu, 12 Jun 2025 07:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749713744; cv=fail; b=cTB1YSvfbQDIng6uqvI2yvYkKTrmT1pihUgaMcRaOvt2gGq+fuwfTqWNJ5C8T3OOSEYW7qq+V/z31JdmeEepqcciXY6EqV0p4jfZBO1vC3MEFo1hU/WH5vf34FqtNuKSEqexbMmMlG35wOkvg50bstYyfkggehA02vA40OG1Y9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749713744; c=relaxed/simple;
	bh=j7clAkJMnC4QbevRJgESZyzE8AGQf9G+tePeBVF+TqY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tUW8prskVZ4ZBdKVVbxiN0qVEv18SLfDi8xhEKjBXf+eOuhe9463EAh5QRxEVRLqBtxJgWJrcfkEyDZTmCUlZA0KdfE9rBoWdM8dHL2tGBcEx29jMlpTWETKkMKbfnTjlGtGZzamPYzsqIqMwgniDrcnur4F4Yno2yvzoBHzTIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iUFjKKkn; arc=fail smtp.client-ip=40.107.212.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BteAE6LJz3Uil+0U5eVFFYmKQQBMUfwKeuXG0sivGQWnQuo6h/+QM/BeZtBJCUWbcqSVoocT3WI2ciXZWbuzo/eaU4w9Ke8mfKMFbcgDqmbNsDLLsZEhbI/Jrtp6SoQm7NE7LvilNSh4xcu8qRAgUefrUvqYYgvryInhEuHSSc9vy3qSfJNSLYmjnR/Y60XUmv5/glEZABW1paDFiC26U7XpxcuqEhBnujDi+sZQKSyfDJ76gTWT9jT7GzC0zz7vqpnbBuFb7I11N/vDTuIyIX7YOyCJFPSZFAs4f+q038q4S25k+zCNDVi/qfq2riUsSSiPa7/hPZC828AK1sg/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esW5B0vNeaxIAGsj9hJRsYU0TjPpKUUZe6qZj92tFaQ=;
 b=H9dEXqR+OuvNfge0XpcOGtbAO98or0k4TkhEvnDy7CYc6ssyXJ4n4nZEgY0dJiBorCycIF/TIZnFzdjr5dVcapuQVFNZMvAF7j7Y4NE3+W6lYDBNHSb4cRYl/Xi4wRd7+N2q5x/qerS55H7XUCW/838iOqLuA1WZkId1WeT/shkfTjBzD8+pokC0eWoicdXHERNzCW9dPQQ3TiuMS3tC9JYRQY4OxNOTK+cF5pP50g7tifRG8C1iLeWzwzx8Qh0haKjLe81zNadSfsIYZxWfxCz0ktvqgqMymlQrHKOmSxDGEOEefBK4jfxNhMjz/KXuG2vut4LEiYUKeLUdwd864g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esW5B0vNeaxIAGsj9hJRsYU0TjPpKUUZe6qZj92tFaQ=;
 b=iUFjKKkn8Lh4U91nWsPZIshxkil3LQze1ZsFAksP842yATl9qyE1dfmDenWVt+j9ocounxsJ504ybAtY8dz8bWbj+jc7aG9SDf1NCwVWcsnEx8rpn6fmT69zhmOtlLS7L/pMLkQom1jLuY0tQKeHvGoKWLvWaA/CiHChbwk+gI4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by PH8PR12MB8606.namprd12.prod.outlook.com (2603:10b6:510:1ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Thu, 12 Jun
 2025 07:35:39 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 07:35:38 +0000
Message-ID: <d00a02f8-2ebe-4952-8dc8-abf722f2af65@amd.com>
Date: Thu, 12 Jun 2025 13:05:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Verify all available GP counters
 in check_counters_many()
To: Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>,
 Zide Chen <zide.chen@intel.com>, Shukla Manali <Manali.Shukla@amd.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20250611075842.20959-1-dapeng1.mi@linux.intel.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250611075842.20959-1-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ac::8) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|PH8PR12MB8606:EE_
X-MS-Office365-Filtering-Correlation-Id: 80d6e28f-8436-4e6a-12f3-08dda983b9bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c1Rma3NpS2pQSnJGS1h0elFOTDFTdUJVd1RhN2NkekZreUtXMXZINlE3bXR0?=
 =?utf-8?B?ZnJkQWREUzI1Y0dpaGkrUE5wUlFuUEpaSHFCcFc5enJtNXp1ZExFVmdEZzVB?=
 =?utf-8?B?dzNHRWE2eCt5UjBFa08zcVFWd2RnanprSTZ1RXhIR1hKYjA1SlQ2eS9WM1Y2?=
 =?utf-8?B?clBvSW9mK3F1Sm9OOVdKTlU1VWsvVDMvdmhwMVMyWmt6eHRvb0VzVlNLQksv?=
 =?utf-8?B?djltRDRBbWtpVGxXVEpHRVNidjUxb2EzZUIrNzkyNUlyY2xkMVhTdDZRK1l5?=
 =?utf-8?B?MHo4U2IrcTh1dnFEZXhBOThXUHdJS2E1ZDBXbGM1NG94UUNFV01zSURWa3NF?=
 =?utf-8?B?UGs5T3JRcHNTc0YrYi9PSXZZK0ZGY3YxQkh6eURLblJZTnR2TWFidHBNSGtM?=
 =?utf-8?B?Z3V1elJIVnhqTTBRWkxFVjJmOHNpbW1nN3pJVVJUTlhHWWpEeGJOb002R2ZI?=
 =?utf-8?B?dmRXdFJmTDFzcWk2dDliQnZ5R1l4SmpCZHgrWG5KVnI4VmdMeXFhWW1SeWkx?=
 =?utf-8?B?WXN0bjNvV2F1Q0krYVR1Vm4rNGdZQTVGaGI4cE54S243U1VqTzMyczdRWlVB?=
 =?utf-8?B?aHA5a2RSSSt3SHNHcnZSREFCZ1dzQkpGSi9vK3RHN3d0eFpqUDRxL2tlSWRG?=
 =?utf-8?B?d2ZKVE55NE1yVzhOUm9PM295cnV4RVhDdG5HeVowcDBWNWh5T0Y1VXBhM1lT?=
 =?utf-8?B?bmtMNmtNdVpEUWREeGU5ZGlFaGI2KzA1S2hQTXkzR0QrcnBzekUxVjM0YTRL?=
 =?utf-8?B?Ny9YRlM5NTZXeWJJWDBFb2FnRmh5V09vWDZxeVo5cjBVdW4wem1mUll0Snli?=
 =?utf-8?B?MVhkS081ZWc0eTQyc1Y2WGlESkNCVUZPY0RYMDZ0RTZUOFVWTXdDZHNEQ2tK?=
 =?utf-8?B?NzRrRGFXdzY5Q3psdzA4Um5WWnBjcnRNS2tCU2lVZDk4andBc3ZqV1VvQU1J?=
 =?utf-8?B?KzErOWJaanNLZ2ZKMUx1NmVYYldXYnNLc1hYcDhjbU9hTkFDdi9aUGs3d2ZI?=
 =?utf-8?B?N09rSFJjb3RSZHBtVlZyOEwxcldIRTVDVTNBWFBmZE44UVY3eDhScU01Ukpi?=
 =?utf-8?B?cnNKVUJsL0xueGdoanZ6cVpjN3E1TC8va1UyUzNJc0t6WElQTHp3Kyt4aTk3?=
 =?utf-8?B?czFSazRPRm0rSWV4elZyWFVVZEo2K2ExV29ra3VmaW9mTC9RMmw4V3BTYnNq?=
 =?utf-8?B?Q1h1ajlNLzBjZ2RUL3ZJVFRMSzNyS0ZJNm9DMEFBTDc4V1l0UUdjMGNuZ3cr?=
 =?utf-8?B?UGRPQlNSMDBZd2pXRmtuUUZkcUc4TlhNYTNlbWJvREZFcFZXdDJpang3OGc4?=
 =?utf-8?B?VkJVM2pyMTgwY2xPaFVHQ0tmem8wZHY4V3pWOVAvSDM2dnkxRlZIZW9kSkxE?=
 =?utf-8?B?NldNMEpDa2h3Z0YwV1NycGhuYnlvT3FqZm1yZUVmTEl1cEJRbzhWZFZJMUJ4?=
 =?utf-8?B?a0JWRHFpSW5PYkhncEROeHZISVNVUThxMzZnTUZyNEJCZlJRbGpoN0VBMEl1?=
 =?utf-8?B?K3J1MHFyUmJvcHNISzgxZHJRSkltU2dYMXNOVGNieCtRUmNUcUJlNy9OZTZ6?=
 =?utf-8?B?YnRXNGFpcGtTdlZKZm02cXpXZ05POWg3a0plUnIwajJjallmTE5ERzNpU09m?=
 =?utf-8?B?WFVjNFJPa1BsWHJSSTh2N3pVbnRhV3JydG1qQVUzZGxDUDJqeHdLaW82TERK?=
 =?utf-8?B?VEp0VmRHRVRQUTZ2ckNrNWxjb1ZLUUNuVUdpVDl0ZExYQ04xMnZjMzFPZG0x?=
 =?utf-8?B?SFFudFBSKzZFNHFLSzFod0VzWDlMYVl4dVFhSGRsYURTNTdGYmxEMHFIZkZM?=
 =?utf-8?B?aDdFQ3ozK1k5TFVUTi9QYU9qZXR3aXFVWHpmbEZCRjRWYjhCY0E3Q2FpSUhN?=
 =?utf-8?B?ajlJU2lZeW1qMktZUW4wa0FNdlA4Q0oxWDJENDgyV1N6YVhTTmVyQVVXaE1j?=
 =?utf-8?Q?QslxjtV7UcU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3RNeXdxMUZLTHdIMjYwMHN2WDRLL1RhbXNLdkRrUmUvTHpzRCtnazRnb2F0?=
 =?utf-8?B?MEVlbkQzUGhOU3lNS2NnbXBJc2x0T0FEWjNwNlFRc1ZaamlJVFVtenNOK1dw?=
 =?utf-8?B?VWJqY1ljOXYyRTNCa244Rzhnb0NrR3VSaEJxMXNuMXJRL0RvdWhQQ0FXd0Zy?=
 =?utf-8?B?Tk1KQmtvc1lXd1ZQdlpIMzRCaVMwRlBELzBMOWxBaTVzcEpFS2liK2l2dFY5?=
 =?utf-8?B?OWwySnErUnhHaWYzbjJLdFpJeklhZVlaSWtOUzk3V21pMzBsQVk4YXFiajkx?=
 =?utf-8?B?aDFsNmdSbGh2WWJEcTc1dEk1RHBjQWVqLzBEYzZwK3owMVhla254L1NTb2Iv?=
 =?utf-8?B?cXhaaUZxSlAvSW85aW5aQ1NrWVBJOTUrTUtKR1cxTVRpRW02bFNoUE8yRElo?=
 =?utf-8?B?T0hvaWhTeW1ZSHVTblIvZnVoUWtsZ212d3NLNit3NGFMd1Vsb3lyVVJUVlRP?=
 =?utf-8?B?bmsvbmIwcUVONGgrK2VpdkliSUM1MmZQbW1hMTY2cllJTm1zenBNbTlYYnE2?=
 =?utf-8?B?eUZOcEdsTzVIZWxjSzI1Y2w3ZlpGL2s0cDBnb3FxbUQxRmYwLzVJR2NDSHox?=
 =?utf-8?B?WXMvSFpVSVNsZWluQ3JPMzF2emtiV3JqZnA1d0hHTjBsRlZ5cERnRkZMc2pL?=
 =?utf-8?B?dXk0eEgzY0dLZmNPZzZmcUszSFZzbytkZENPa2lmRWRRTGFXODNHMXpQSTNN?=
 =?utf-8?B?QWNSYVhwY0hDcFRBVVpSSHFtNkpwdGN6Uk0vcXVJbzhoMVJjNlE3bG04b21J?=
 =?utf-8?B?ZkVSMjVNOFJCeFY1SjlBOWpadnpDRm4vaStWR1NQbm41MVBkaTNlcVpRZmo5?=
 =?utf-8?B?MldDVUZ1UHdMaTh2NW5rN3VFQnhvU1lhYmhYVHh2b2tzcGV6Ym9wMkNJTlpi?=
 =?utf-8?B?WGVEVHBzYVJ4bXErRzB4RUVkOHpZemV1UXRGN1Y3ampYNEc2aHIrS1RJcFBZ?=
 =?utf-8?B?NnJkdjYxQUgyWk5oV2JxcW1oUjZic2hKcUtmazZKREM5eEFHU255a1cwQm02?=
 =?utf-8?B?UEZtTGlkZkFDQkhYSEtTSGN2SzMwWDhrWmxDcEtVbE13YWI0RmVKeXpxSVZl?=
 =?utf-8?B?Y0xEeE80cTZWbkpxeEdaclF6WFgxa1JTYWhOU0hUbDdaeEQ4RHcyZXZNNW1M?=
 =?utf-8?B?b216Q3NKNWpMZXNzRWIrWHpudnZ2VjJxUG5ZKzVpeFpKRUxzYUlkVUlNeWhh?=
 =?utf-8?B?MTdpY2NNVTZjdmhMZ1NBT0o1dDdxQ2hFclFWYUMxN3FpUEdrT3dNVWxjRWpY?=
 =?utf-8?B?T054YlRHWTZJUklSbVc4MmpRcTZnNnpWYnBiSllCSnFpRkR2MVY4NWZ3ZlRN?=
 =?utf-8?B?SWVVb0FCditpS1R5eGV1LzZTUmdaV0cyR080UGRMalZMVjFwcnl4Qnh5N3FE?=
 =?utf-8?B?aWhsTjRjOXV0SHdxS0VnNDNHUXNyOUFFZjUzamZrY3dWRkhRZEcxeU51SFA5?=
 =?utf-8?B?MEQ0eEdvNjhEbkpIc0ZWb1lUdzlzczZ2anR0NDNMRVRIV25SS1BxeWFIL0Jm?=
 =?utf-8?B?QlFremJrR3AvZGp0ZzhvMzVCMXhUaWRFMWtrbkJHK09OMHNsQzVCWUFiMFlN?=
 =?utf-8?B?eUJuQjJBc2FYWlpqNEY2VmtMOFNaemR3eEVrTTE2aHN1YVFZclIyNSs4aE1s?=
 =?utf-8?B?ajRBSGZnWDRINnV1Zzk1SmpyVWR6bG9ONnI1N2U4Rng3ZFpIaUpRc2hsU1Ja?=
 =?utf-8?B?M0IrWXBNaFZzQzVoWG9hQjNzMGhSN29manJuUG05TUorZUFaL0xCdHhVYm5T?=
 =?utf-8?B?RzArdDhuQ2lsOTZMeU1Yc3dDNTU1REY2YzVCVTRPMWtQSEdRVmRxdE01Qlln?=
 =?utf-8?B?WTVRZnFyaTFHbVdKME42dDVjMEhIWSt3SXBQcXFmbkZLRk50SC9waTJ5MklD?=
 =?utf-8?B?dWhwcnUrVkdPdXFVUmF0QU5sVFoxWGJqL3phcVI4R1AxaTNNcXVtSjVMdjA4?=
 =?utf-8?B?dkcwRW5HNnlXVlBndzZMU1FBMldyN3I3OEdZNmR6cDRvdzVXNGxSYUF0YjVj?=
 =?utf-8?B?MWMzZ3dWY2NWTlZ1ZzlYbUdwYm00R1l4WjhkcmoxRWNTbEpxRGFpaUNkQkFi?=
 =?utf-8?B?eWVqd3VJSzh3a2RkODBEOXlhNUFKSGNQbFhaeTlRNjM4SEt4QmhnMnFXMmli?=
 =?utf-8?Q?Qyi4bJILzJdKbkz4CLOSJ0PSd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80d6e28f-8436-4e6a-12f3-08dda983b9bb
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 07:35:38.3228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFmyVeyk1VK0hIyIpGAVConW7Asj0RF0Z2VAgmzdPFgFpJIvw+qP2dyE4iwiVpAQXNUUt0hWIuEWITbLja8Beg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8606

On 6/11/2025 1:28 PM, Dapeng Mi wrote:
> The intent of check_counters_many() is to verify all available counters
> can count correctly at the same time. So an alternative event should be
> picked to verify the avaialbe GP counter instead of skiping the counter
> if the initial event is not available.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
> Please notice this patch is based on Sean's "x86: Add CPUID properties,
>  clean up related code" v2 patchset (https://lore.kernel.org/all/20250610195415.115404-1-seanjc@google.com/).
> 
>  x86/pmu.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 

For AMD processors
Tested-by: Sandipan Das <sandipan.das@amd.com>

> diff --git a/x86/pmu.c b/x86/pmu.c
> index 3987311c..a6b0cfcc 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -457,18 +457,34 @@ static void check_fixed_counters(void)
>  	}
>  }
>  
> +static struct pmu_event *get_one_event(int idx)
> +{
> +	int i;
> +
> +	if (pmu_arch_event_is_available(idx))
> +		return &gp_events[idx % gp_events_size];
> +
> +	for (i = 0; i < gp_events_size; i++) {
> +		if (pmu_arch_event_is_available(i))
> +			return &gp_events[i];
> +	}
> +
> +	return NULL;
> +}
> +
>  static void check_counters_many(void)
>  {
> +	struct pmu_event *evt;
>  	pmu_counter_t cnt[48];
>  	int i, n;
>  
>  	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
> -		if (!pmu_arch_event_is_available(i))
> +		evt = get_one_event(i);
> +		if (!evt)
>  			continue;
>  
>  		cnt[n].ctr = MSR_GP_COUNTERx(n);
> -		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
> -			gp_events[i % gp_events_size].unit_sel;
> +		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR | evt->unit_sel;
>  		n++;
>  	}
>  	for (i = 0; i < fixed_counters_num; i++) {


