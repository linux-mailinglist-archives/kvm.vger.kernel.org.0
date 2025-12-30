Return-Path: <kvm+bounces-66845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 402DDCE9E78
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 15:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61142300B923
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 14:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246EC2248B0;
	Tue, 30 Dec 2025 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pN/KHZdH"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010070.outbound.protection.outlook.com [52.101.56.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6941515E97;
	Tue, 30 Dec 2025 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767104261; cv=fail; b=gp49HSJdx5XVgWayBAXRvF38YaeiH1DdQjhOyXe9zN7Mj/07N0HLEWdyiuacmpxaiZxQiS9qEYcmsukyP7QyryW1yLDANDhTsbxFF1EUvH1tvwSaEBoeQ0hp57srXRMe6PPqI/tG80oD6dqBPPATlMLOgWrNW9TJQnaCpddrIGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767104261; c=relaxed/simple;
	bh=y9HoW1PDHA4b+sUzqUFIEIfYrdieeoQZy1T20YoeCA0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TdM6MMWCGytowDvYEXkMn8GzFzU7AevB2BfWedMZGnWseXLKwc3oR4Nria5maOu+35Gu4prUuRTESruWG+H5JfYvJld0Cbr8IOUa7uWNKOrOQLkSTx7f2GsSmg/gL/hqVgNNmuYXa+WVUxG8Sbdy9QuoEuvt0LVUfaS0smvnR2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pN/KHZdH; arc=fail smtp.client-ip=52.101.56.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gBNYWYdd6TwM3h0TA+qttKpLN0LgzHkIGmcpzsBq5Fpupw3s6F9l9YNgtfdOqmzobKwPiuS0DRp85YyIO2XIeUVzn88c1T1+866oJOIlceQ30kfYRQvpl7rYe5f5UdMfMFPZjxlhMIFLurYc3I/+FA4Oc8HChM0QkinZhd5OsMRjdR6q9yjXtgpA8/c9DiPxwqQobNfb4R1SVK3SxQFlRtk8xCH0K6dcdQzwaKiyNkZOR/J9JjwUx0xweVCVmycWQPcS1TAnHRa5L7qVZ8lJwg6K0bR0QO7DzexgAFR4pxsk0iK0tLvX9IGj9ZGIke2XbJY5z2RBjRHZoGFLJdnjAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8K15ULZGKybjo9J0y+WB7ce+V0+qmEXo2zIXUiMwEw=;
 b=QfAVVE8qbYNepSxbtR/MEzoa6kykyAG6cXPpi9tWwMdIE6bnkY6BHxUGr9sOWTLkTC9BqyMQPYurqmECRT5hCEf7hBjr41EtZ9K2USiWpclgFka8sPuwDWPKZXpU0lkZwErZmSkJ2HMB/4j6VVEmSB0BtAtK3qANfUE8dFo/2WbydmVB2Cyi5Q4F5JOLckLXHaI2j3E6fTky76+fUToRz9EPUrvdOJy7MHoD8u4srIrvTfi0RvgqMN147V4YimeiLPNuN/glTma8q1ZRP947jhApY61WHtuHq4Dh0MZVuJxQ88Rmg21mbhTnUKri7x1wghqddDMBZEy/Bz0JlQiMDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8K15ULZGKybjo9J0y+WB7ce+V0+qmEXo2zIXUiMwEw=;
 b=pN/KHZdHug3gdzqrFqdseLJYtxN5tMePXTykwGv+Q1zOfoQ+YDRGMKH+hFSyypceHvAhZ80SXbRlN9IKQUwOg7xP72GIGLicDrEgqu0i79SV4eHXLmzUwn7xiSJjSX5e5QXiffRpoy/v20vZdSiXMvuijLYgm0zA+FOg9jYlq4E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by MN2PR12MB4454.namprd12.prod.outlook.com (2603:10b6:208:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 30 Dec
 2025 14:16:25 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277%5]) with mapi id 15.20.9456.013; Tue, 30 Dec 2025
 14:16:25 +0000
Message-ID: <62eeafba-f953-454f-b696-8be1cc35be2a@amd.com>
Date: Tue, 30 Dec 2025 15:16:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] KVM: SEV: use mutex guard in sev_mem_enc_ioctl()
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 linux-kernel@vger.kernel.org
References: <20251219114238.3797364-1-clopez@suse.de>
 <20251219114238.3797364-3-clopez@suse.de>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20251219114238.3797364-3-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::17) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|MN2PR12MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0c6b00-dc84-4276-3d1b-08de47ae03ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WU5seS90Q2hJcFRMWTdvenNQc1FOaitOYkZwSmx3dGMyVmJ5a3ZTMXc3VGRa?=
 =?utf-8?B?aGo1dldzUGp4SkxQcHlSZE5lMjRhSzA4Q2UyRXlKalZmZEtnRDBTV2ZEeGc0?=
 =?utf-8?B?VldpYUtESkpUeU1WekU1Mnh5eTJrNXk3aDk5R2NHNTBxbkpNTnJCQ3ovaCtU?=
 =?utf-8?B?RUNxS2lwNjdOSHI1NDNZMUo3NkRNTXllL3ZJQWJzc2E1R1dWV1pPZWQ1MUlj?=
 =?utf-8?B?RzhJWTZMWFlCU2hnUEhwWFpFRy9YWXJQWDRCZ0F1TU1GTkl2QmRmZ1JiYklJ?=
 =?utf-8?B?MHVKZ3MrYmRiNUlRY2RyaHFlWEhEN3ZwOGlYZUpSb0I0V0dZQkhMWFJBbDFL?=
 =?utf-8?B?UFJmbkdrOUxNd2xienBkVG5ZMWZpM3A4UnBZNEg2TXNlN2FrWExhT1ZVa3Vv?=
 =?utf-8?B?TzJVVWRHSkp5K2diTGFkdFM2SU02QS9ySjNJWGlFajhVWGRGb3BxdzYzcFpE?=
 =?utf-8?B?YWhoK1BFVjFHaGljd1dqWDRPU3J3Tmt3QXJPWUJmVmFsRHppZ0o1OUVCNzJO?=
 =?utf-8?B?amh5dWtIM2FRbm1XcFBFSGJ3RmxuNjk0R3gyVStudm1EYUhZRE1FYTZSak05?=
 =?utf-8?B?Sm9nOXRuN2Nvb1lvdUVrNWtoV2wyNmQ1eXVBdVRWWmpvNjVzZ0xYSDBQRDVL?=
 =?utf-8?B?VkIwRmJhSGZhaWFyRG9mTmxkVlBEdXhTalBIUFNtZlBnSWNlZWRSOVlmOFNH?=
 =?utf-8?B?bEFNTXBvZXN6L3UwSXVOWTlJeVVqTnpmUURVa3o3NjloSGEyN0hnb0xjdW02?=
 =?utf-8?B?Qnk2Z1Z3ZUI0RDY3VlBNdm1Id3UwdnhBaWduQmlpaGhWS1Mzc2hBc3FmRnRl?=
 =?utf-8?B?V21UUjJ4alZHckhUNGtweXZkTTNNdzVBRjdDRVdqVXdMQXhNMWR3Uk1XcTFq?=
 =?utf-8?B?SmRCd2VLTHoxQ3ZLYkxlQ254NHZZT1owNndJZWo5UVBMcm1oaUQxM3RRbjM0?=
 =?utf-8?B?MmQ2ZzV5RnZVWTgwUWVGQlJtWjQzVkJhcnRKYmlpQ214VUVVOVBiZ3hKWktU?=
 =?utf-8?B?dEhWTTc2UzZkMi91cHpvTjZoeW9BRW9oY1FvMHh0aEpEY2V4V1daZUlObEFW?=
 =?utf-8?B?ZlZHa25ieWo1aDFvRytnTDZRZm8vOE9JUkFkd0xsa0lyWlFJRFFRQ2p2UnlS?=
 =?utf-8?B?cCtNMUVHVGpsdzE3dC8xWlZtZE5DTnhjekpEa2ZOQXRPbENkSDdBREwyRE5H?=
 =?utf-8?B?czE5UUNzNS9pVGZoVHV6ekx1eXRTZjdDUTJUMG8yaDNXV3VuZldVY1FOb0ZZ?=
 =?utf-8?B?c2FNVTBSQ0ZRMzJvWENzbmpaUm15VE1jUW01aVphK1duVWp6SVhOSDl0eFRJ?=
 =?utf-8?B?a21LVEJwUTdCazFpUGVtSVl2bnA5YXBKU2pObDFNZTFya0FESzB0MjNJenF5?=
 =?utf-8?B?eUtMYmI5MG9VVnhyVTcwWlJENVRmKzl1Kzh3bGRwTUJCa0RwbFlLRGVvcm4x?=
 =?utf-8?B?emJHVUo5M2pRZjBZaEJ6N21wR2QvMWwzMFhWcCtNWTBrRzNWNSszRVN0djBj?=
 =?utf-8?B?ZktIb3ExK0J0eWpGRHA4U2gwelc1RFZvR0s4TDZxMW5WUTFQYklWZWpTYkNJ?=
 =?utf-8?B?K2FlRmpIRkRaeExyMWZ3YUpwcDFmdXRCclIvTjAzUjI1bVYxRHZUL3VJYWRI?=
 =?utf-8?B?UnFoOXQ2UW1HRWM2NHVTNmU5ZDdneWUzYWRGd3BTMmJXckkvWk1BNHM0amo1?=
 =?utf-8?B?a1BaUEVMUzBqNDZKVU14ay82eEE1dGlpaUQrbjJwZ0lHRFhpRTNzTmQxUW02?=
 =?utf-8?B?NnhFb0NaN0R4TFg1ZU1pNFpLQXJZQnQ3Nk5rY3BKNEdDT0kyMWhNTjRBQkZG?=
 =?utf-8?B?dkY2b2dYYXpKZ3VPUm5wblk2bzJaYTFwM2xidFJjVE4veXIydmY2STIvenNR?=
 =?utf-8?B?Y1dRQlRQNmVETjlnWjRqVDZBVTIxRDliazZkc0VOSFd6bHpIRmZLSVJnY1lG?=
 =?utf-8?Q?/lCynnfjy8nn9x+BuXXLb23Ghc2sH/sd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDdod0FTZzkvODU0aHkzVHptQnU3K2VKM3RXbUxaTjR2RmVuRG5UbE9JU1Vi?=
 =?utf-8?B?cktSTU1TZGFGVCthbUtsZGZDRzY4VTc2QkR3bHZFYnVaN014RFVvNDhaaFF4?=
 =?utf-8?B?TEp3S1R0MUNyM0tqZFA4aWdQRy9aTUFsZTVnVFJEQjVRNEc1RTFGS1pLdElK?=
 =?utf-8?B?NUFkdlVLNWdabVBLRWNSM2c2R2VPUGNGS1VDaTd6OElJNjhsNHM1bnQ5MFFq?=
 =?utf-8?B?K1k3N3Fqdlo1ZUJVRkRwbHZxOENXVVd1Vnl3Ti9IV2VHemxlMU1DbG5vWmh5?=
 =?utf-8?B?RXBLL3FyT2MyU3lyMkhxQ3pvWUJjVUE2RmQycG5hSjdoM2lQSWFXUXZpZkVP?=
 =?utf-8?B?Z21vS3E3YjdwSGRMeGh5Y1BmZWJOSFg0emRFUnExUDd6Nm45eUNaZWFTaHlZ?=
 =?utf-8?B?dStpWXl2VmxYUGRKNllZeWhsV0tpNHpINjNxTWdPME1DNEhTdlpnak81SU4v?=
 =?utf-8?B?Um84eHE5UllyKzFOQkFpVVZrK2IvaEdqZEJjYXFuM2p3RU8wbHgrbmxMNWlT?=
 =?utf-8?B?NCt0UHNDMHJ1aHowMENZSWlJMC8rejROck1GZEFyc0poSk80YW5lUDRqcXBH?=
 =?utf-8?B?TGh4Z0E5S3A2MVZ6R1djR2JIVlZmVUxUSHFQM3Nub1hiNDljVUNyYnNLK25h?=
 =?utf-8?B?VmJvQ244Q0NmdWtLcjNQNS82V24vR0wyR3ZXZHFLZGFCZk1qa01JN2FsM2t6?=
 =?utf-8?B?aTJwL1NBdzVqVUQwWWpIL3d6QWEzUER0ZkNFeXFwRld2WEgrUUQyZlZkN2Vr?=
 =?utf-8?B?ZGwwY05aT0lnRlFSUFV6aDFablpOM3ViUDEydi9SZGw5WlpPU1dzQ0IrYU9x?=
 =?utf-8?B?ZnJCbTcyY3lXdGZGbHBHTmZPdTd0U2p1Zk1LMXVja3VraE80WmI1TUhQQ2tX?=
 =?utf-8?B?Vjh2OHBYTHlhT1RNV2swbTUvMW9mK01ZTU1odVNEOGRzTTBSTlBXVEM0R3p6?=
 =?utf-8?B?cVozZHpIUlpPMEV3NEtJVDVEcjVzZlQ0VENCNE5vWWd4em5wbE1ZekZOUmVI?=
 =?utf-8?B?RGdpVVBOdE03cExDRk1EZFhDQ2p4a240Z2U3SUpITlNMNkpacFhhMlNCd0I1?=
 =?utf-8?B?NzZidHY3eWN6dEE4a2M5VElEZFNJbThLQXVoVk51M2hlN0VXZWpWeFJVL3h6?=
 =?utf-8?B?ZjNZMUtoR05EZnhTbkVSYmY0MDA1Z1hlVm5odlV0d1NmZmk1YjlISE1aR0ds?=
 =?utf-8?B?dWJadm5DcjZsRWUxZFQ4OGtzZXAzVlMxbm9LS05MdU1yb1JHcUI2UlM3UVV4?=
 =?utf-8?B?YWowQm9lbkl0NWUwK2wxc3VteXpveWZqUm85TkJzZzJtR3lvRmR2UlBHQ0JW?=
 =?utf-8?B?OVRCczVBMGZDVWt3NlZuZzJvMDB0cW1FenNhME8wTWtvalFXWjE2cm5raDR3?=
 =?utf-8?B?L0loL0QxUXFmbDNETmZwbFJ6R1Bna0R3MDlwUHg3cGJrWjRoVE9uWHo2UVJ3?=
 =?utf-8?B?c0lEa3FqUFpGY1hyZ3h6RG9VYVBJaEwveC9OalhpYVRNajNncWw5ODBtOHBW?=
 =?utf-8?B?eHo5UXJoMytteVF1Y2FtM25zMVhLUDl1SUIwN291NlA2WnF4TldLUTc0V3RL?=
 =?utf-8?B?UldEamZDb1hDWXdSL3kvM3lFMDZPZkFPeDJsMGdTc01NTDYva0YxRTlZb0J0?=
 =?utf-8?B?ZS9lQWQzMXZpeHM5dlZKTmVPNi9scVpkNnYweHZzMkZHKzR0SU13amVtMjBY?=
 =?utf-8?B?bmpuUXhGUnh2RDNTWitaTVp6QklDbnRZSC9nTjl0NUF1SnIvZGVUeXd6cFIv?=
 =?utf-8?B?ZDNHNjBwMmdobU5jSTY2RVR4cjNyRWZXQ1IyQ04za2VzaGNveTZPaEpXWmRn?=
 =?utf-8?B?anBCWlUwVHpEb29yT2pHS0w3OEszRTdjcTk0cVNUU014YTNuVUd4OFd1YlRO?=
 =?utf-8?B?UTVoaERpNzVIOFlkQU9xcjQyTHFZMWptVzBmME5mY09ZaXdUZzU3RjVRbGZL?=
 =?utf-8?B?NUUyY3E0QnFZTkRSaVhUaUhTNGVGTXFyMUVTVjVRdSs4THFFTng3ZWtBd3Jh?=
 =?utf-8?B?Qlh6dlU1L2dsY3pFdmNLOHQ4dk1ZRmJkZWl6cFVMOXVlaUw2TG44aVpDWnRZ?=
 =?utf-8?B?SmNaY1J4UTV6TnVjUXRodkN6eVgzNnE5U050US8xMExGOFZXNG9Nd0dCa0w1?=
 =?utf-8?B?U0QvM2pqY0pyWVNsQWlJRlh5Vk04R2hiN0h2NzgzaCtFU0YvZ0dEMlZQZElk?=
 =?utf-8?B?QmtSeEVzdjlIdTRjaTBkeDRhc2g3Z0x3OHcxWHVIWHRDTmtCOHh2TWg3MXFu?=
 =?utf-8?B?OU5NRm1xM1N1SUhCd2ljZjhGNzZtK083UVA3OEpDMXZmSWg5RW42OXR6ZGp6?=
 =?utf-8?Q?9lmnCkZHtoMXsRffxG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0c6b00-dc84-4276-3d1b-08de47ae03ee
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2025 14:16:25.2291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTUq4H8P8yHYi+tjC6uyBJbNygiwu6ctTQgpxZVH/sDjs17eMQEQ1xZXQCZ1tmWO8GhNmsQXa3Fqn/RW+0AdOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4454


On 12/19/2025 12:41 PM, Carlos López wrote:
> Simplify the error paths in sev_mem_enc_ioctl() by using a mutex guard,
> allowing early return instead of using gotos.
>
> Signed-off-by: Carlos López <clopez@suse.de>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 25 ++++++++-----------------
>   1 file changed, 8 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1b325ae61d15..0ee1b77aeec5 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2575,30 +2575,24 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
>   		return -EFAULT;
>   
> -	mutex_lock(&kvm->lock);
> +	guard(mutex)(&kvm->lock);
>   
>   	/* Only the enc_context_owner handles some memory enc operations. */
>   	if (is_mirroring_enc_context(kvm) &&
> -	    !is_cmd_allowed_from_mirror(sev_cmd.id)) {
> -		r = -EINVAL;
> -		goto out;
> -	}
> +	    !is_cmd_allowed_from_mirror(sev_cmd.id))
> +		return -EINVAL;
>   
>   	/*
>   	 * Once KVM_SEV_INIT2 initializes a KVM instance as an SNP guest, only
>   	 * allow the use of SNP-specific commands.
>   	 */
> -	if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START) {
> -		r = -EPERM;
> -		goto out;
> -	}
> +	if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START)
> +		return -EPERM;
>   
>   	switch (sev_cmd.id) {
>   	case KVM_SEV_ES_INIT:
> -		if (!sev_es_enabled) {
> -			r = -ENOTTY;
> -			goto out;
> -		}
> +		if (!sev_es_enabled)
> +			return -ENOTTY;
>   		fallthrough;
>   	case KVM_SEV_INIT:
>   		r = sev_guest_init(kvm, &sev_cmd);
> @@ -2667,15 +2661,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   		r = snp_launch_finish(kvm, &sev_cmd);
>   		break;
>   	default:
> -		r = -EINVAL;
> -		goto out;
> +		return -EINVAL;
>   	}
>   
>   	if (copy_to_user(argp, &sev_cmd, sizeof(struct kvm_sev_cmd)))
>   		r = -EFAULT;
>   
> -out:
> -	mutex_unlock(&kvm->lock);
>   	return r;
>   }
>   

