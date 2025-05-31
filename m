Return-Path: <kvm+bounces-48133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6085DAC9C67
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 21:05:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 074947A881F
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 19:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A7E1A238E;
	Sat, 31 May 2025 19:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g/t1lo4O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2772907;
	Sat, 31 May 2025 19:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748718338; cv=fail; b=gd3k3BYD5SDY2PjuC2F/3rNuVrC3+1C4BxBlaxnfvxA8fHGpejqTKM/1eGSP8grbeR379j2sT5jTp5eQwEHaX+ezIfgjAhVJjBPpD7hirZdeRVcz68YBsBxO+JVbFuwhhfnaCtYK6LRauw9ERB8QPk5zpgOr50h2E9EpUAAFTxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748718338; c=relaxed/simple;
	bh=yfjTOpxPAqefnVuAF9K4XWgzNMmi7HYl8MTbJshjgAc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cA9YUN9xnL3AUCD+aEJNfGfdVzcLs/uk/6xcvuZ/wRN58xKUrOZoqUWhBotrkKVmPW/aLjFTV+i62jSkViHkdujVTfvAqrxKaCkXHothmbPpYO/yBX9pQ4XEOEqihYK0+UaYLsA6bC39RwfwvFR2AKLISW2//HsMHGT+4hVGbPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g/t1lo4O; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTZSZNgtmNvmPj5F38J45AYFPaYEyePhgU/fkYzGvtN2jVdfzCO09M/31ywopZP2eBTbUGiWuqAeOGi4heJNJSykLhhmuFTmmGB3svazQKN4y8Rk0SNZqx5yTmAdYQKWkjScdWt8AsaWlWl+20lDXrmAYtNRlxfMMKcsMmVHQODnKFch8qR74vit63YT8tFVBTV1dRZiVTj2phAKzGrOeQo4A+uhCB/UUSo+mgAGagRxd2VhQBVnZkcVc2oZ0cHHNVZWxnJKFkmUU6VH1FyUh1SLtPxb9S7lke9ZgRsoKUMQddQKTcSFge/7h+Z1nvFvSXbMBixWV4itMPh/Jr5x1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+Ptn27jpAdVXSX1/aSCB2f6M7W7Lo43DW5sChvznsw=;
 b=qOUFiZ3hKmr4qKrw76OjvN8JxUfBYt3temuloDmf0Cs/LXYGWvYD5U8qTsroBCTo02/MuLUCNBtD/iRXtMWfvpBfW0Wx/DDllun0uaHN8h9bHEmwa4wEpAbJsh4r3fcUPeWDjj5ihiciVnTDVJyO8mp9YrZqtsh9ugFXuFw0hXwyeLRvABUWr3z8EeYq6Un3F939V8r0zKuVzpGYN2bsyDe13H6+nTBPEweiQL9aX47SQXx7NBWDUsMwOTuBQ6dOAkJ6AxQlEyW/s7IFI4//M559hEEwzYnkuIcTl3p2pAiwKbMy9Ii/bz9uYFO2/BBor+NXGzXwLLLKko0yPj2+cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+Ptn27jpAdVXSX1/aSCB2f6M7W7Lo43DW5sChvznsw=;
 b=g/t1lo4OGTlZi+eTp9YDJ8Y8miE0ZctQ3OTA8kqRLvJB0RCTVJ7S6RYe8cOzigubSiu1xaO0wDsS6AQdBlQ9FrIgTnrE9GgX40vpw/iysiwwKHEG+bZBibiGdUBKVy3MoromhMyzqspa8SHP9pwUsrB5CDvAhqk8Dh/lgDIsXss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Sat, 31 May
 2025 19:05:31 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8769.033; Sat, 31 May 2025
 19:05:30 +0000
Message-ID: <f469ecae-7b6a-43de-954d-488eef69c24d@amd.com>
Date: Sun, 1 Jun 2025 00:35:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/16] KVM: Rename CONFIG_KVM_PRIVATE_MEM to
 CONFIG_KVM_GMEM
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-2-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250527180245.1413463-2-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0019.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::30) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|PH0PR12MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: 52294d12-11b2-49ee-4c2b-08dda0761ca1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGI5QlU5TXVGeUhTekMzUzBjT3FNMlRqMmJnbXBVa2tZUGRqb3UzcGFHQm11?=
 =?utf-8?B?cU9VYUhPZmplc1NwVDViNXYxQjQ5N052aWVKTUF4S25KNENTNEtoc3p5NmlR?=
 =?utf-8?B?OXZmd0pDOEhoVWFXQU5Za0t1Z25DeGtyaWlXTUJib2RRaFZINHF2RTUvSjB3?=
 =?utf-8?B?SU4zdk42K3lncVJIblpBRVBVREhCWEp2SjRlbkNndWJQaklqVFV4QmEreUM3?=
 =?utf-8?B?WTFjSC9sY3NNWVRvMlJDcWJtVkhMYkNQLzBFc3dPcVFhYmhnc0gyRm93M0FB?=
 =?utf-8?B?TWNHZDJiM3UvdWE1dU9rUkhsaHlFR3ZHbklQcXgwNVFtZW9RRUVsenFMUldQ?=
 =?utf-8?B?MVhhWWxZSUtIejErV25PMUc2eVJWc3piQmQ5eEtncTAxV3Y0UUxHNXB4N243?=
 =?utf-8?B?czR2ZmpESGpTZjBWcDJjODh4ZWU4RkNKcWl2dVFFcFUvOERtYlFsOHVuRDFw?=
 =?utf-8?B?OVRqQWp6b2JRcUlnU2hyR24zak5tNDFvZmxPM0dRZ3BneVRrUXZXQktGZ1hy?=
 =?utf-8?B?aEpTMUdJOTVVa1d0K1gzUkc2WlRrYUlWQjBldDQyaEFJTDQwNkRxcXVRWkNl?=
 =?utf-8?B?bkFnbzA5T3dBS0NjSHdMUHViQk9nTlBIV2tjVjI4UVZUdzlOVTYvakpFaTB1?=
 =?utf-8?B?a3doYXhVTlFrVFhySHhFMUVuL3JiN1ZiTVpXQmhnbXIydVNUU25PcFE1Rldk?=
 =?utf-8?B?TW9MTnllMlpJaW5RZG9pN1YxZ0h4MXRseFJSb21Gd2dCanhFOVF3Nm5NRTd1?=
 =?utf-8?B?YlhHVWNlTVNiMUExdTFWSm9nalQyb3JRTlhqMW9YSHhOYjNGeGE1YXpLZDc2?=
 =?utf-8?B?T1dwTE1LMnJFLzUzVDg1SHF2UUtTcHZQQUZDQ29xNTZ2cExiWWFHUFp5ZGxB?=
 =?utf-8?B?M2pNNFRMamZ6OHFEc0lCMmEydzhsZi9LbWdPdlFpR1FZTE41S2Mya2dldmlD?=
 =?utf-8?B?OGl4R2R5c3ljYjJCMFY4NWtVdGMvVjhqN1k2Uk5BS2hXKy91dGtONmMxcHVJ?=
 =?utf-8?B?Z2J1T21kdVVxK042TW4xK25DRlJXQytJSkJRZ0RoYm4vV2xNdStKWklyNDVt?=
 =?utf-8?B?cjhIRFkrTXRPMHJBWVFDeHM4ZlViN2Z3aUJpU0NoZXBqelhqUERhOC9IOGt2?=
 =?utf-8?B?UkNyRlZTQ21RTjJlSFdDVSt1aHI5cVlQKzFGWE5yNitwK0U4bGRxR1VhV3RE?=
 =?utf-8?B?WGdtZU1XK3ExNVRPWll4Wmx5T084dzVGK2pTVTlmNGg1NnJLRER4SHdJaHkr?=
 =?utf-8?B?cHRYcUNZRVRGQTVpZmwyZzJvUEkyVTB0akR5TEh2bzIvNUt5OGorZTIxNjAr?=
 =?utf-8?B?MWxNaHVubmdxV2dFemlsMmREQWFmS21jRm1rcWpNcGxFVk53alBSK3ptY0NZ?=
 =?utf-8?B?RzhqaGJMTnFLbHRlMStvWndCYk9uVjE3MGZTTk5lOVdHbEFTelZnVE1xZ1dY?=
 =?utf-8?B?YzNTaGhUTWdsRnFWSENZRnFHeWpEaUFpcTRSN3p6SEpuVURTbnpEZGZUUFpw?=
 =?utf-8?B?YWh5aEk4L29Nb1hjQ2U0WjRkdEwyTHM2Q2xuWkVoQ0I4VTdwZEtoN09OVmNj?=
 =?utf-8?B?TnNDVHlQRFoxdE5xdzlySVA3TW9XeEhlY24rblAzb092US9WNnp0c3FGWk5Z?=
 =?utf-8?B?VTYvSS9jSE11ZDJmbDhEdE5PbzROMjB4VTY2ZFVxRThYb0FkL3hLVnpMZ01G?=
 =?utf-8?B?eDJnK3NSb1NJa0ZmVnAwTURjbVlMNktrQklDWnU0bDJJeXFPUmJjeEJONENX?=
 =?utf-8?B?cnpUZzM3WTlBVnpteVlHT1MzLzlOd1Q5QVFuQk5GVm14dUhVTS9yZnFkZDVq?=
 =?utf-8?B?eUI0bUJ2ZW50K3kxRUpIaGFsdWVDb3FJTCt0ZUM3LzNSc3BkRlVMQ0dNaXQr?=
 =?utf-8?B?enFyZkhlVG80Y212UEhTVWlPM1JnTUxnVjI0NUdjeDFLWDMxQ2pRcFNWTm5E?=
 =?utf-8?Q?C+G16SmXUdQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWRyTkRMa29VVHVXWlVuUDkzRW1uNTJ3amNkSnNjTFpLUDVtZFV3MDRoUkxo?=
 =?utf-8?B?RE9kVGFwcU8zeVFlVVZHQ3ZVbXVSenlRaTN3UW1SSU9EaU0zMVJTK0UrSzNq?=
 =?utf-8?B?WUROd3p0alBQRFg0Y1BFWDNpZUliK2ZPZmVpbVhkenFBYm5QWnY4eGRpKzBh?=
 =?utf-8?B?Q25hVEsrVGU2SUhhb3NqZmd1eG9jb2w4bGY0OGtIa1UzNVlLODQ5VzkwVWpa?=
 =?utf-8?B?WUd5V2lZbWhUYjNaWFU1T0lhbFRSM1kyNWkreGltV2JDSnV2VEJEeXhEdWMz?=
 =?utf-8?B?NGdnYXBmZEFqa2Y0aXJRY3pqSFRBZWI3dThDVlBlZVVZcGdsbStFdDRIejdP?=
 =?utf-8?B?Vy9LcTc4WVM1SVJ4ODE5aVhtN2UrMzFQemR1akYwU0M5YjhRYlhTK2RmMWNF?=
 =?utf-8?B?NnBwNmNYT3dkcUtEZGl4dDMyUHdjS2p4YU5nU3d0eUd5NDQ4c2M0emNVY2FQ?=
 =?utf-8?B?NTlMVzZlOVR2V2YvS3RGRTRoWjRoN2s1emN6T3lOdGRQSEhaR0MzYy9BM3Jp?=
 =?utf-8?B?NGVTL0FyYWlhUTlFNjk4QWFIV0k1NVlMRk5TUUtETThzUGJjWkFPR1BvbVpi?=
 =?utf-8?B?RkY1R3NKcHpjRnF6dytvV0JDcmlqSlh4eXZ3ZDh6SmVOMFFRcTkvTmtpQzU0?=
 =?utf-8?B?M3FWaUd0TGxTM3FidENvWlhkU1VDU3N2UzJYdG9MSDJ4YTJKaEhjdHFZTmhY?=
 =?utf-8?B?d2lVcFgrN3YwWTZkRTB0TTF1RVg4ZG9CbFZYeGthZkZVUktEQWhETzd5S2N1?=
 =?utf-8?B?Y0E5ektQa3lqdDBERVNuQ1ZVVURzSjBYaUNiTk5KUy81VnhmTWFGcFZrUEEy?=
 =?utf-8?B?ZmFlVlBvRUFBbnBPc0dRZFdESnpTSktKRmltRTVKd3N2YTJ1cHlHbHlyeWcy?=
 =?utf-8?B?ekNhcEhiZHZOQnZQc0kvTU5LL2xxMjZTKzgrOERGUjZ3NzR2RWZUTmZiNUw5?=
 =?utf-8?B?Q25qUGVNSkErTnRJYlRFcGJsUDJ1QVhhaG44U0M4TnIwMXE0Vlh5TGQ0QXhV?=
 =?utf-8?B?TDg3cExjV3lNU0Vod2dwY3VXTlhhZXgvY041TDI1Z0d6d0VyQmZiRG5ESWhJ?=
 =?utf-8?B?aXJjUFFZV3FSazg3ZzQ5NGRITlNCRmVMSjJNanhEclcvR3BEM3pZN1NScjNr?=
 =?utf-8?B?MnVQS3BUNk9INW5oSmdBb2UxQ3o0cVp4VDNId3dwajMrSzJiNVNhUmlnNVo3?=
 =?utf-8?B?M0EyVFdaQWlKL3JRNHI3bzE3elZ0Y1VJTDQ2cW1LWmVieVpwcXpFZTZCVE9p?=
 =?utf-8?B?cHh0d1ZwK2RwN0JHVWc3S0M3NnIyRFJBOUVheGhLQWx3aXhhc1RJRTZWZmla?=
 =?utf-8?B?emtPdnFSS2twcTQ1RzIwYUJrWnRKeTNvRTh2dFl1cjFCV2VOWWZ3aEFvUlhN?=
 =?utf-8?B?Skw4NHp1WXVIcXVKbWxPbTZzekJVSFdpZkwxVzE3YVp4aFdPSllITmptbnF0?=
 =?utf-8?B?czZwNWxFSDBrbWU5WllGM0E1M2tWcmJjVTA1OENMOHUwSm8wc2dpcEFVSG0r?=
 =?utf-8?B?TTlmK2RPRGpkT3FPclFBd2hSVURyTkt0bDdMblJxUERwcU9nVDNKbnpvaTlZ?=
 =?utf-8?B?Q054bGJNSFRFZmtXSU5jNno4RjlxQWovc0pqcUFSSFRPb2t2dVlEemlVZkFN?=
 =?utf-8?B?d3EzTHp3LzNEaGpEeUFzZEEwY1VueHFLS3c1dGV2endYeUYvQndMU1Z1LzhD?=
 =?utf-8?B?enNpU0NVM1F5Z3dwMHhvY2tHS1hZdUJBdm1MM1ZEcnhER2IvWnJCS2VGNDRp?=
 =?utf-8?B?eUozc2lzTThpVXI2VTBLVTZ5dENrb05JZkFWeTNZalFSNHVUaGY2OSttZjkr?=
 =?utf-8?B?L0NmbjJ2TFp0RmZFNkxqU0U0WFhHS2pYcGRkbGI2ekNGSVZPQXFGNE1INzVO?=
 =?utf-8?B?VzVGaUJWdmJseVE5VEVteXFocU5JZUd1T05pTkFQd3ZCQ0RjYy9veUp2WUd6?=
 =?utf-8?B?dzV6NXFGU21mWDhXTzBsQU01M2JSb3BUOG9DcSt1eU9uSWhVcmlLTHdqYU5J?=
 =?utf-8?B?dzErZ21tQUxxZm5PMW1WNWxPM0ZXMUJUcWJXbDNyeWh0R0xCWHkyTlVWS3c2?=
 =?utf-8?B?aG8xSFc4WVlhQTFJeERuWjZSYzUxMjB1MTBNd3o1YmpWRldiZ2FnYTM3ZG1m?=
 =?utf-8?Q?hWCiX34XolwFzZC1xLrO8A6qX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52294d12-11b2-49ee-4c2b-08dda0761ca1
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2025 19:05:30.7898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2a117Q+pc7cDLm1nukDC5QQ+ug/TBpAUpV+cR/xFgjVH87ODogvOVtfa8TjWyAf2YOBC2MsYe0gMxPWZxgK7lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605



On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> The option KVM_PRIVATE_MEM enables guest_memfd in general. Subsequent
> patches add shared memory support to guest_memfd. Therefore, rename it
> to KVM_GMEM to make its purpose clearer.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  include/linux/kvm_host.h        | 10 +++++-----
>  virt/kvm/Kconfig                |  8 ++++----
>  virt/kvm/Makefile.kvm           |  2 +-
>  virt/kvm/kvm_main.c             |  4 ++--
>  virt/kvm/kvm_mm.h               |  4 ++--
>  6 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7bc174a1f1cb..52f6f6d08558 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2253,7 +2253,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  		       int tdp_max_root_level, int tdp_huge_page_level);
>  
>  
> -#ifdef CONFIG_KVM_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GMEM
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #else
>  #define kvm_arch_has_private_mem(kvm) false
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 291d49b9bf05..d6900995725d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -601,7 +601,7 @@ struct kvm_memory_slot {
>  	short id;
>  	u16 as_id;
>  
> -#ifdef CONFIG_KVM_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GMEM
>  	struct {
>  		/*
>  		 * Writes protected by kvm->slots_lock.  Acquiring a
> @@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>   * Arch code must define kvm_arch_has_private_mem if support for private memory
>   * is enabled.
>   */
> -#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> +#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
>  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  {
>  	return false;
> @@ -2504,7 +2504,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> -	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
> +	return IS_ENABLED(CONFIG_KVM_GMEM) &&
>  	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  }
>  #else
> @@ -2514,7 +2514,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  }
>  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
>  
> -#ifdef CONFIG_KVM_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GMEM
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>  		     int *max_order);
> @@ -2527,7 +2527,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  	KVM_BUG_ON(1, kvm);
>  	return -EIO;
>  }
> -#endif /* CONFIG_KVM_PRIVATE_MEM */
> +#endif /* CONFIG_KVM_GMEM */
>  
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
>  int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 727b542074e7..49df4e32bff7 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -112,19 +112,19 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
>         depends on KVM_GENERIC_MMU_NOTIFIER
>         bool
>  
> -config KVM_PRIVATE_MEM
> +config KVM_GMEM
>         select XARRAY_MULTI
>         bool
>  
>  config KVM_GENERIC_PRIVATE_MEM
>         select KVM_GENERIC_MEMORY_ATTRIBUTES
> -       select KVM_PRIVATE_MEM
> +       select KVM_GMEM
>         bool
>  
>  config HAVE_KVM_ARCH_GMEM_PREPARE
>         bool
> -       depends on KVM_PRIVATE_MEM
> +       depends on KVM_GMEM
>  
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
> -       depends on KVM_PRIVATE_MEM
> +       depends on KVM_GMEM
> diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
> index 724c89af78af..8d00918d4c8b 100644
> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -12,4 +12,4 @@ kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
>  kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>  kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
>  kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
> -kvm-$(CONFIG_KVM_PRIVATE_MEM) += $(KVM)/guest_memfd.o
> +kvm-$(CONFIG_KVM_GMEM) += $(KVM)/guest_memfd.o
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e85b33a92624..4996cac41a8f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4842,7 +4842,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  	case KVM_CAP_MEMORY_ATTRIBUTES:
>  		return kvm_supported_mem_attributes(kvm);
>  #endif
> -#ifdef CONFIG_KVM_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GMEM
>  	case KVM_CAP_GUEST_MEMFD:
>  		return !kvm || kvm_arch_has_private_mem(kvm);
>  #endif
> @@ -5276,7 +5276,7 @@ static long kvm_vm_ioctl(struct file *filp,
>  	case KVM_GET_STATS_FD:
>  		r = kvm_vm_ioctl_get_stats_fd(kvm);
>  		break;
> -#ifdef CONFIG_KVM_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GMEM
>  	case KVM_CREATE_GUEST_MEMFD: {
>  		struct kvm_create_guest_memfd guest_memfd;
>  
> diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
> index acef3f5c582a..ec311c0d6718 100644
> --- a/virt/kvm/kvm_mm.h
> +++ b/virt/kvm/kvm_mm.h
> @@ -67,7 +67,7 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
>  }
>  #endif /* HAVE_KVM_PFNCACHE */
>  
> -#ifdef CONFIG_KVM_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GMEM
>  void kvm_gmem_init(struct module *module);
>  int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
>  int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> @@ -91,6 +91,6 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  {
>  	WARN_ON_ONCE(1);
>  }
> -#endif /* CONFIG_KVM_PRIVATE_MEM */
> +#endif /* CONFIG_KVM_GMEM */
>  
>  #endif /* __KVM_MM_H__ */

Reviewed-by: Shivank Garg <shivankg@amd.com>


