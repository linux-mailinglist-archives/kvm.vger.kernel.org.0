Return-Path: <kvm+bounces-58524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 811E6B9569F
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 12:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39E792E4004
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 10:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EA432143A;
	Tue, 23 Sep 2025 10:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fus2nCGZ"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAC132129C;
	Tue, 23 Sep 2025 10:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758622665; cv=fail; b=sbaZa86HznuuOEYtsf8H6BHMnZdUvcRFaSmrxJXmFgcPas0opIgffZGeDA98Atbl+k/7fEKAelsdQ+qCEhPTQdw+ZUMI5SN1fbm1zdR0o5yHunHA2YdXRaKo6YW14alG2gw5i3SDhkI5GPguzAD/9JW0Xv3zzgbz0C2vk1Mfgzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758622665; c=relaxed/simple;
	bh=UZqkKZbqaaMSErVvXGnplcWECUt8ntQPt/Z1BY5Od0I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jMPoeC+bIIvlRr/BPPXLVtxErGWeYULK4MdD5plyXSwue2Ud/3y8500tfJg0oZuZ7gtR+igZCDdywJxrBfCdok+tsDH/+wwT5UiLScGblA5yid53+jyeFQwdkN1xhAHJMV1gLM3tx/iP7JV4KsLho/tAVqvgXOr8DuAljXuXzVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fus2nCGZ; arc=fail smtp.client-ip=40.107.200.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uy1W12vZPW3H4CUkslPtGWOsE3DGAiRjmhutN1arAH+AZ7d11ia7D6zrhQilEkeJvRmXJ/MfIZHvQHEF0cg6QZbNLnWRx/iifh9vwAcMQv8ZCQpFPHS2uNgE+J3BgcZk4za7mUT67ktvSKdA+PcbH/oZKW+FVpnT9znF2GioCGgZKIsWEm/O93isELLo3Yv67LFQcM6RQz29x6HO8QhVsiHWm7US6XZFrph/7H+Rf/jeWBSjloIjJkqKhBuBtEpqe0J8y+2zfH4fTM1mNXEZktgnOw5cwwutmXjWNBa0WnjEZJhmJhGHe/JYP9KcvMJT/M2I/zLQpXUtSQRusYTHTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVuxeUF/OweliClftfH41ZjR4gnljD5p2Odk9TOiZb8=;
 b=HZKXxyb9PWuy/e0ssd9gRbDrrvlX90KqbM/XNGtw8Pqh/hTb1TRXegLJE7Ict9SMjXRF3YOVmLYxDLBryjoO5yuMh1jZVSp2VvzGQR6xCdZ9RddSBse2nBPF4jee6rjlnngDR6aw6MS+qojk33P1ptTcktDnMYt+tEv47xZHISgkYMotiRwUhB6gyE3//xbpkr3Rffzp1YcSZc2fkJ5/CsQFBjmlQPdl1rFYMyrwLprHsCbZ0Wc8WnOPBxUaiwVB44ZCtz0OUqaz0U8A+4E/M+gOCuriQOPlXSogosAhUSelkNxkADYNXqtGGZGVkBAmaG6Z30fF2IzVVtQ3Kd5QrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVuxeUF/OweliClftfH41ZjR4gnljD5p2Odk9TOiZb8=;
 b=fus2nCGZua03rOJe6dEEIwVo07fZYmynaXG8zwUd/lPzogYBumgSrsRw/8BJfq17mvtRIbz57InixaiAkNXjDE3xFWeS2w9HN2feuitqxapL4rIgvrbbkMYEL55/jegvK5Wep6fmDeAnlYZjmaB3PUau1YA//z6IA6fG4q/kzog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 10:17:41 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 10:17:41 +0000
Message-ID: <aefdae17-d5ad-4749-8b7b-e253d68f86cc@amd.com>
Date: Tue, 23 Sep 2025 15:47:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: AMD: Add Secure AVIC KVM Support
To: syzbot ci <syzbot+ci3162984bece220f0@syzkaller.appspotmail.com>,
 bp@alien8.de, david.kaplan@amd.com, huibo.wang@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, naveen.rao@amd.com, nikunj@amd.com,
 pbonzini@redhat.com, santosh.shukla@amd.com, seanjc@google.com,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com, tiala@microsoft.com,
 vasant.hegde@amd.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68d27033.a70a0220.1b52b.02a8.GAE@google.com>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <68d27033.a70a0220.1b52b.02a8.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::9) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|MN2PR12MB4358:EE_
X-MS-Office365-Filtering-Correlation-Id: 269f5397-e96e-421b-f03a-08ddfa8a6d7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cnVQVUJxQjlqN0p5dVlVbkNNeHJvREhJcU40Yk56cXQrdnBPdnpUUHpTNGxy?=
 =?utf-8?B?cTRoOWpOMDRlZUk2VEpoK1d2ckZGYnhRM1VyK1pNTzJ1L3ZodzFtNXNHTFVt?=
 =?utf-8?B?ME9MT0FiQ3lyL2MyVnVSenhmajZQMy8xejhtWnhlRzI0TVpndDR1ZHdhKzMy?=
 =?utf-8?B?ZEMrbnVTQUowMEUvR0Fpc21pYnlzQzIyUUdLWWFnNEdhMGkwUkxuMzBQekpC?=
 =?utf-8?B?UG9MYnlQNVVQVEFQSHRsQjZnclhIMFBtVEZ6Q2FWY052ZGt6Um5TcVlKaEp2?=
 =?utf-8?B?SDExa2J6ZXZrMi9keWNKS1BhNmhBUEtvaDlBMmp6Y3RtdWsvNy8wdzZxNWZN?=
 =?utf-8?B?OCtBdzBFakY1SkJFR2JsVHBycXRZM01aS2dDTDZvRTVBYkN3RjJFM1RVemFC?=
 =?utf-8?B?aCtVTXQyYlpsSGtBNUlwV2V6QmVyeEpvM0RjR1NYSzZsOEJzOWZsVFdtV0Jx?=
 =?utf-8?B?R1RaOSsxb1NEUmtWd2pRYVlyRlErc2VPVm0wb2F5K25pMHhjeUNCTHBwTXEx?=
 =?utf-8?B?cWlINzhRNWNyb1lEOVpqbFk4cUVlTDgzQnpRVDRoT3VnVEhhQW16OEN0WHRw?=
 =?utf-8?B?UEZkR1orYXgwNDNrWjRBU2h3dFlrRzJlTFB6KzhPWkVBT292QTdTTFZjazlN?=
 =?utf-8?B?TXdwR3ZRUThoZGxqM2syWHpmbjNldks2V1dzQjM5eEpWSWdJZCtqdjl0YUN0?=
 =?utf-8?B?NUZ1ckJhTkxVWlRySmJDd0NMdzVhNWpTR0lqVnR6N21LbXYzWWVUUHJDTExm?=
 =?utf-8?B?NjlQRXFwYWl5Tk14cE01Y1JXNXpHNEpZRDk3ZHdpK0krYnhpZ0Voc0YwMWpq?=
 =?utf-8?B?bkpacGJyUVRMYWhPVUtqZXl4M2dEb2NCaC9UaVg0MVYvODdhdjFoaHJ1dkZC?=
 =?utf-8?B?YUoxUWNoYUNibGl4TCtVTFBSMnFyaUZEeFFKK0UwaXlQQmliWWp6bm5VQ3g0?=
 =?utf-8?B?eWdBV2J5N2dtcEdMVTVDQXlaSnlwbnZFYzdZT1A3bFVQdGRFQ0krUG9ZejdB?=
 =?utf-8?B?WTBCN2Y4QXdUdFdUUUNrRWVGeC81VHB1K3ZHRXpEYWl2TGJEYnZRMUoxN2t2?=
 =?utf-8?B?SGtQNUxEb0Q4bTZJUnFFdFY5dis1cmVsQ0x3clNOSlFBcFEzRGtFdGU5aHRy?=
 =?utf-8?B?R3JINDFpL2x4cWtURzVXMXFEdVFaTDJEUGtPbVdpZndkU2tSdW5ScURtTk1O?=
 =?utf-8?B?bkFsOFVCdzVST2hKcHVVY1kwVDYraTBCQVQweERjbndNdnBPd2RSU1dPeHNY?=
 =?utf-8?B?dmpYNTBXMVFiU0RKdG94aHpVazZ1SmhUUzZTMUVkUHIyVkhYUk5mTmpOenNk?=
 =?utf-8?B?cmtqWGhmblV6TDlHdTYzWkJhVHVKR0lLWEJWYW1OZ1hBamRYWmV2cU1vZ2hH?=
 =?utf-8?B?L1IyenkxajJtYUtRcVVmNjB4cmpFYnMyWWVWWDhFSitSeVBSSnN1Ykw0eHEv?=
 =?utf-8?B?NFJVRzNqdGpPeFVFUWczcEhZbE5OYzd2RWxiUk54N2xUOU1xM1g4aEhDZ0hh?=
 =?utf-8?B?dlV4ZmtZUGFOQjh4UlY2ZEpNVWhIdzRCZzdCNGE0dUJMQTVibFV3YmtPM1Qy?=
 =?utf-8?B?UnZ4eTFJRkNBMWw4ZTdwUmNHTVFNU2ZVYTgzSm5Gc2VHUzlEZDNBNjJtUXhV?=
 =?utf-8?B?MEpNUnBJRXpiZFFVT09RQjFrUUIycXB4ZVptZGlQc1AxNEJzN1RKN21UNWFs?=
 =?utf-8?B?T2NDV05GV2hONWhhOXlwN1lYRmJqSExWOTMvVFJON21LdUdhTUhJQkRVbjZh?=
 =?utf-8?B?REoxR3hRR1lCYWRHYWRrQjRyU3NJdlFpZElqaWIxZTRNS2JoYjJycnRnRTFU?=
 =?utf-8?B?SE5wbjBOdTRxQTNncExwZnFoQWJQTlRlYVdDMVhCUXBUTy80N256cnpFNk5s?=
 =?utf-8?B?eUlCV2pRZWpUWmRNVmR3SDIwM0NqYStKdHpLSi9lVjltM3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODJ2YklrNkMyWXJRRG5qRXpiT3VSMURvVjVnODFubk5FZytJR28vU1crUjVX?=
 =?utf-8?B?T0wyejMrNGNYem10TVlKb3lWbTh4cVVrVkdOaUs1bGNOZHhleEtKNVN0bkpp?=
 =?utf-8?B?U3FXdW1CUjB4QmNPY3h0VFRoVHVZUy9USjJlNHcxRmdUS1NCVCtTOHlUZ3hF?=
 =?utf-8?B?REFrL3NDeTkzNnAvZUFIWjFsWGQ1TExTQ28rWUVjQ3Y5UFQ1UU5Xd1YwaFZ2?=
 =?utf-8?B?Um53Um4xUVo1eDFabVFtaS9OZzRpb1o2U2VHd2UvUW5JRVE2REsrbWZoNmZl?=
 =?utf-8?B?dWRTY05rdEpDVEFwME9XdGVXZDdIYkYydlM1cUkvZXpUOEw0dExtNVhEWlQr?=
 =?utf-8?B?RDcwNFZtWGk2MUJ6R215VXBYcjI2ZEpvd05xVjErTWZBOXdpRzJROTJVdkR1?=
 =?utf-8?B?SzFHWlhxb3JvaHI0SGhzU1FNcHFzTUxOUE1nSjBtM1llcnJoVXFKNk1oYWRz?=
 =?utf-8?B?M2ZXOE02blRpMk1UTlg3MW5lQ29pV2dBT2NIODdBa0RlUTM4eTY1WTl0enFo?=
 =?utf-8?B?OUN1T3ZHNzlPMmFUYjMyOWNQMHVGNHRNaER0cDRTVFBrZTRxMU9jRVAwYTM1?=
 =?utf-8?B?Sk1vSElCdzNKRjRjeWdSaitCMHo3QVc5MnR1R3B4QTFMZ0h5KytrWGFuQ3lL?=
 =?utf-8?B?TjViZjRpWkk1WXBXazlNeGxYeFB0dWFpT0kzYUdSbElMbGlGYTgzVlRwbkE3?=
 =?utf-8?B?QU1kV3U3RnhZVGEvcHcxMUExM01oZkpVNlZqQTNmUTB2Mnl4UGVINjMyODZK?=
 =?utf-8?B?MXhuQkttNkZVUEhXVzQwYjJzdm5WZ0k3Q2ovd3FkclVqTVhlRkNzTWx3dDVx?=
 =?utf-8?B?WnlvK1dJaytMSW1UZlNVTU1VaTcza2lxU3VCS0ZRWE4vRXlOYkpVMWFwdDEx?=
 =?utf-8?B?ZXBZN2lxODVXNWJKTnZzTDZ6NVBFa2QyU0MrM2U4NnhtREFUVndiOUQ3bzNm?=
 =?utf-8?B?OTV4eVJkNUdxaUxDSEthZ3N6eEFGZlQ5RmlmMkJYNTN0N2lpYkhxVm1pM0pq?=
 =?utf-8?B?RTB0WVV2ZDlaNGdWbmdhR3dLaVpTSGV2VmMvK3NtWnVRdEhjUng5WnZjMVpz?=
 =?utf-8?B?bkdncXF5WTZla3NLakZFWFVva29DcytyeXlRSjlqWDM5OHFqT0gvR0dRd2Q1?=
 =?utf-8?B?U0hjMFpxQkJ0NnFDZndiZlczcXdxZzdZSHo3OHdPV3Y1WDN3Q0lsSElxMFRX?=
 =?utf-8?B?ckVtdW92OHp0d3JXODFOaU9BVC9FV01QWE1ORTg5QUpYdlVNQXY4K1lnaW0y?=
 =?utf-8?B?aEhYTzdsSFgzZmtoOVh3SXEwSmgwZVlHVTFFYWY0bzVwcFFwSlBCY1psVlNa?=
 =?utf-8?B?YkswQVdaUGlYejJzSmlobmtOQTd0b29HQnRCUmdJa1JlTHNVaDZNYXJvd3I4?=
 =?utf-8?B?dEw0N2Z3YjhVNFdmbkZYenZFVm9KdUNhYlZxbGZaRzlRRnZnSjluSFlWdEs1?=
 =?utf-8?B?QzRiM2RhUDR3VHptTy8xVFJmY1VVSzExTUJXc0xwaW5UUTNkUHFYK1YzM2ZK?=
 =?utf-8?B?a2x0UDdaN29LMDJ1UnUxdEloUEFNR2FlVmxIckJjZlN2YUFCb1hBcnZwSzdy?=
 =?utf-8?B?ck1mYUVQQTNoUThkbk94d212UWpoN0lqSm5CQ3o1RTArTW5FWTYrUHhvVnJ5?=
 =?utf-8?B?Tk80TFlHMkJIb0N0Lzk3Mll4VVlXSVdORXVVZ2EyMTRKMjVoOHJ4ajl5aFhS?=
 =?utf-8?B?K3hXVkppdmY1Mks1YlZDZmZTMXJ6ZVYrd0c2a0pTY0RjZXlxRjhRZ0k2QTI2?=
 =?utf-8?B?QXFsUy9iZFBmY1JBVUwvczNjT2w4c1ZpRmQ3cy9sUEVSQ282MkdwOS91RFpt?=
 =?utf-8?B?aW1OWkVQeVlCQklQV0ZSSEtaeEJhSEUzSU9ETjJ3Q1BBVmpVMzkzSlp3ZTdG?=
 =?utf-8?B?RktVMTdzQUJ2bXJBc0FycGtKUVJ0c3ptN0VxKzN5MGZYZFMzNVYzYjFvQUk2?=
 =?utf-8?B?RGVJTzN0V3czWjFqWmxpdjBGRSs2Y2lYeGlmamFiRG9tK0lpM0M3Z1crM0dw?=
 =?utf-8?B?TmMyS0Vwd1EzcEtYM2xIVEM4c1hZcTNHREVpdE5uMTlyb0dBSGtCeVdXektm?=
 =?utf-8?B?S1A1WVR2R3pIR2hTSjdOVEROTERTeG54UlBFRVFPVUV2OTcrV2I3WmJnZTFS?=
 =?utf-8?Q?LM9oEfxfYVQAdnjjf0o4d1+ro?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 269f5397-e96e-421b-f03a-08ddfa8a6d7a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 10:17:41.0643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qh2dYZfNDhnNovgPKbY8RYLqmqJpQQ3SsYi1LeIQhttQeJVRzS+EOEYtjtCH6Pz+9s+CSTSLdJgZ8W2vQvq2sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4358



On 9/23/2025 3:32 PM, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v2] AMD: Add Secure AVIC KVM Support
> https://lore.kernel.org/all/20250923050317.205482-1-Neeraj.Upadhyay@amd.com
> * [RFC PATCH v2 01/17] KVM: x86/lapic: Differentiate protected APIC interrupt mechanisms
> * [RFC PATCH v2 02/17] x86/cpufeatures: Add Secure AVIC CPU feature
> * [RFC PATCH v2 03/17] KVM: SVM: Add support for Secure AVIC capability in KVM
> * [RFC PATCH v2 04/17] KVM: SVM: Set guest APIC protection flags for Secure AVIC
> * [RFC PATCH v2 05/17] KVM: SVM: Do not intercept SECURE_AVIC_CONTROL MSR for SAVIC guests
> * [RFC PATCH v2 06/17] KVM: SVM: Implement interrupt injection for Secure AVIC
> * [RFC PATCH v2 07/17] KVM: SVM: Add IPI Delivery Support for Secure AVIC
> * [RFC PATCH v2 08/17] KVM: SVM: Do not inject exception for Secure AVIC
> * [RFC PATCH v2 09/17] KVM: SVM: Do not intercept exceptions for Secure AVIC guests
> * [RFC PATCH v2 10/17] KVM: SVM: Set VGIF in VMSA area for Secure AVIC guests
> * [RFC PATCH v2 11/17] KVM: SVM: Enable NMI support for Secure AVIC guests
> * [RFC PATCH v2 12/17] KVM: SVM: Add VMGEXIT handler for Secure AVIC backing page
> * [RFC PATCH v2 13/17] KVM: SVM: Add IOAPIC EOI support for Secure AVIC guests
> * [RFC PATCH v2 14/17] KVM: x86/ioapic: Disable RTC EOI tracking for protected APIC guests
> * [RFC PATCH v2 15/17] KVM: SVM: Check injected timers for Secure AVIC guests
> * [RFC PATCH v2 16/17] KVM: x86/cpuid: Disable paravirt APIC features for protected APIC
> * [RFC PATCH v2 17/17] KVM: SVM: Advertise Secure AVIC support for SNP guests
> 
> and found the following issue:
> general protection fault in kvm_apply_cpuid_pv_features_quirk
> 
> Full report is available here:
> https://ci.syzbot.org/series/887b895e-0315-498c-99e5-966704f16fb5
> 
> ***
> 
> general protection fault in kvm_apply_cpuid_pv_features_quirk
> 

Thanks for the report. I will update the check to below:

       if (lapic_in_kernel(vcpu) && vcpu->arch.apic->guest_apic_protected)
               best->eax &= ~((1 << KVM_FEATURE_PV_EOI) |
                              (1 << KVM_FEATURE_PV_SEND_IPI));


- Neeraj




