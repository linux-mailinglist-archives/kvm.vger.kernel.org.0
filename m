Return-Path: <kvm+bounces-71172-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLY7GjG4lGlmHQIAu9opvQ
	(envelope-from <kvm+bounces-71172-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:49:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D382D14F55D
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8185930649E1
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 18:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7CCF37472F;
	Tue, 17 Feb 2026 18:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LCr/gAhh"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012046.outbound.protection.outlook.com [40.107.200.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0458374197;
	Tue, 17 Feb 2026 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771353979; cv=fail; b=CoBFmmSp7OcbHHkm58LOhH1aHPr+fq5hk78E9LzNvZphTUpgPcb9WCN6WyQeOEhsT37OKIG6bGoOACsRPVSx0DzNTFR86/BvQHtpM0q9A97ZqDQFmv9uXjAcGzT0pEkaZMqc/SQXGRJtA1qAUhyH4Eun75hkhtdfGIiqlvLqc60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771353979; c=relaxed/simple;
	bh=Tl/Ud/A0gZ5tSg9ieA/I+rvL3T5FyuZr11j6U1YF6ds=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QqPpQ3iH65Fr6mHwjrJ/ukPkcjYY9es16eGCmCWwNl7oUITt6oLMGmCN7YGJ0pi3WXee7T0Tmzds30WZ/dSzhaqqB1oqvySrKsYUnrUwMlm18jFX+qGm6/ZcRMd/81N6/XZ9o6CjKp8onXklZcuNZKjUuIxn63jZy1fFRJVHsuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LCr/gAhh; arc=fail smtp.client-ip=40.107.200.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xzFPGCc1p6aOZNcXrLrjRunF6dyEylZKkxjsyD8DFPhuzpOsNjfo6fL/ebGXuv/WMVFGfhw9ZQ5PMPqqvqsC7PsuNAGfM+/qM5zmUu0uBaQxhkG2YYMcQQVOUyQPmn3C2ut8wQQ+M+nHuoW4Fq1FWxl8NebskTOcAMi8M3OgaxVUg8kYsvuI+V8IoQSvrweXAvTp1SvEnFgGQ6/kA4JC01cxZzIJvAl0K5O70Rs8S+/rAtQTDt2pnd+zvY1ved15QQqYtglG1fXQmr0Y112DV3aEeyQAbmoVJfjoAlK0CndISgTUYx21xcHwR8W1asFuEvK0jsONXw0czT+BEBOv7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOytkHjwN29OXPhglMPE0nH4G/fn2exYDQdWnTMUej0=;
 b=AdZx4qkQKasFfvSLu2YGM23poo3ZL2GGDmYDOoOCpASNWOAWPp2MiQVxdyFeuy1yvj4/9Y/2l3aW4EVYmqv069FFzAWDPIw3PkIgKz0pm6sreCvDl33R9ICrgRIjuIp6Rpi2/TH1OdvKuV9IScfoQcn3z9UPGwkOhAfHhtB7Wl3GPihrbh07Uj2Id6cfjX/9MnPqYVCVcCvnVHdUF7BUwI6kgaRWnepBgHOjk/mX2ktlbZpmR3MAbKDOIs5/VkJd9SZFmDqbVhXuaU9J7sj7ARE6VaQseuijvPlkMcwu0mUHJgWybaF6ek65BzeD7grpyYdPWA7I6qHanjG3CnzWPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOytkHjwN29OXPhglMPE0nH4G/fn2exYDQdWnTMUej0=;
 b=LCr/gAhh3lw5dv7QuRocroegFMcJ6mDjFCkKlOw9avjX+cX7Ju5Dy4Hkn5oKbZlYDVU7dEFVHs58Jkw15KK65Q9or7x5leIkB9qr2yOmePA3iDUnwH0qQMeg8DazA1Wf0UxzAVYu4xRPLb9jPAJaceCAY83tHimu/wKCUyL2qac=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6787.namprd12.prod.outlook.com (2603:10b6:510:1ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 18:46:12 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 18:46:12 +0000
Message-ID: <037084a1-2019-4bd2-b1ed-7f34f9128e37@amd.com>
Date: Tue, 17 Feb 2026 12:45:52 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: TDX: Allow userspace to return errors to
 guest for MAPGPA
To: Michael Roth <michael.roth@amd.com>, Sagi Shahar <sagis@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 Vishal Annapurve <vannapurve@google.com>
References: <20260206222829.3758171-1-sagis@google.com>
 <20260206222829.3758171-2-sagis@google.com>
 <20260217180511.rvgsx7y45xfmrxvz@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260217180511.rvgsx7y45xfmrxvz@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:805:66::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6787:EE_
X-MS-Office365-Filtering-Correlation-Id: 118b1685-22b9-4cb1-003f-08de6e54d279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UFJlK2Z0YWh5UnJ3U25jU3hGcFJqbWFQRG5IR2l0a2xicWxPU1ZoOEE2SEQ3?=
 =?utf-8?B?OGljc2lJMk52MEM0VFZqMENuV1NJNXEvbXpjaWd3VndPb21MVU96cXB1NEg0?=
 =?utf-8?B?TWs2SzlBZDVDbVdEOFpkd3QvVkFpRk92STl5dXI3WmdOK1hYMDVHenNmbXFh?=
 =?utf-8?B?eWdaMkpzVjY0RFRsUldtRGlEV3pkdVlyaVFNUUlwUWNaKzBXU1pRY2orNWp5?=
 =?utf-8?B?ZXlYV0JXaTdURUZLNzlobVYwRDlRN1JmMGxRT01KNzJmWElPZUhuWCsvM3Qw?=
 =?utf-8?B?a1h2ZjV3bURhZ1NKcFVja1BNcE0wMjVTTkluaEV2RWRYRVQ3L3hSandtRmRD?=
 =?utf-8?B?OGxERXVPQVdUdFF1cmdmQmFFYWh2dmJ1R1N4a0diZkxweWxGZDd1V0tMeHVm?=
 =?utf-8?B?RjJxV3BVbGs5MVhObnZkT0hnV3VxMlFEd0RSVStvMFBwK01Lckl2TVg4WTB1?=
 =?utf-8?B?bW1xcFQ1NHdkaktxbGRTZDhtei83TTFwbktjeFZpSVZ1V09nbDFuelNrNDNR?=
 =?utf-8?B?TWR6Vm9QVkZJWG96UkUyNVM4d3BJUHprQW1yamVGR3NLWEJzV2J5cStZenRo?=
 =?utf-8?B?dlkzSVpTd2REYi9HZGsrNWF5QUI4Yi90aEZHRGVLUThsZHhoN1U2ZlJaU2d5?=
 =?utf-8?B?V2NVdXIxakQ4VUtQUDNqOHpjUm9DdVdGNFdiVjdoUWlqeS9aeVFKczV4ZnRW?=
 =?utf-8?B?QUxsNEhIK2ZoeGdtTy9weVFUVU9VeEw2M3NlWGl1TzRaNFVMcHkweGFqZDhC?=
 =?utf-8?B?SEN0MzZnQkdsbnFBclFpY1ZQSjREL1EvU2tYMFo0Yklzb3loNFVyMkM1STdZ?=
 =?utf-8?B?U1YwakZab3hjZDNsemw2Wis1Uk1kaU55U0lyTys5a0lTbDNaQjM2T0JjUGFL?=
 =?utf-8?B?aEZwUktxaDlwdnhWUzYzTU9QSWQyQkcvb0xGWXVUU1NaUTl2dTVBUndxbkNr?=
 =?utf-8?B?QjhXd0h3OWtENSsvc24zcldNdzVCY1ozeGhMRmFUaXhDZXNnYkFkR20xYXdo?=
 =?utf-8?B?NHJ6dTlnT080bUExbWJlYkkwMURuSGVPSUgrWHpYYUFjWk84NUJ0cWxNV1dw?=
 =?utf-8?B?QTNxdFo4aThTU2ZMc2tuUlBFSGsxc3pkb3g1aklRT2VTSG1ubTQvcUFkL3JK?=
 =?utf-8?B?OU4vMmZaVVAxNHJidXpRYkFEWUl3Q3pyMFJrZFdJeTdyQmdvTVVqbHpFemxy?=
 =?utf-8?B?WllrWnFpblRHSHVMM2t5V2swSG5wSUlpdHdwNFFRdFRHZE8xL1Y3V1ZhYlJ0?=
 =?utf-8?B?VFJIR2dWTWFpS043S2loRHdFd3NTT3RvdkRWbWI4UHJOUjdBTUtQaUNjTFhN?=
 =?utf-8?B?OEFhRElGc0JwaHdZK09VVjFJbXdsNnVZeG9ZaDMrQnVTNzZrWUp5eXlOaU5E?=
 =?utf-8?B?SkVhck85WXp1SG0rbko3QzJHNkw0cVRFQjVyemJMVUV0akpjNE9pZmhjTkRL?=
 =?utf-8?B?cTJqSHZ0UDdKV0R3eXZGbHBtaFErVm5lTVZxK05Jb3ZaSmNWV3h6cTI2dVg4?=
 =?utf-8?B?c0sxOHlVK05rSEhoMkRlUjFsMFhwcjkyaXNQUmJaNHpySlNiSW1FczkvSEhN?=
 =?utf-8?B?TmZrcXNuK2ZXbWVKYmZZR3pXNUxydWd4QmF3Y0pQZTFTMzQyVUFYNm1JdTVZ?=
 =?utf-8?B?WHhyZVU5RWxXSWx6T3ZoNy80THE3N25jQVhEazBJUFFhei9QZmc5MEFHc2Nk?=
 =?utf-8?B?R21DeDdWUmNtYytNRzFjS2s1N3l0NHI5bDNNTVA1TENsSUJhR2xCMTBpNXpG?=
 =?utf-8?B?VUNuVnFrZHdMMkJQSnpMTGQ4Ky9ZUWpNZkdvbk1xcHgzenlUZjBSd1RUSW1Q?=
 =?utf-8?B?UWcwcUIrcGpuSU9EL3ZKd2NaZkw0N0hOUDY0S2dwVnA3SFo2aWt5RjdFdTlv?=
 =?utf-8?B?Y0o5dXd4dlFkMnY0Mm9jQ0wwRWdZZis3Q3FkeVRzNTd5NURpVjFoL2FHd1Ir?=
 =?utf-8?B?d2ZjZitBbldOQkJab0VuMGZDNFpTV0JGRlh3M1FsNkE3T0hsZ1cweGpIejlM?=
 =?utf-8?B?VjkvckxmbFdrZzVQMFlhMXF5ZTFTRDJSRGcvNm9kWldNWmpjc3BUNTBRSHJJ?=
 =?utf-8?B?VmM1NzFpMGR2UWZBSWJ2citxL1d4RTJ1dlNTNVBZZDcxeUd2Tm5vS2hmUC8v?=
 =?utf-8?Q?qguo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmN4SVdTVk50UXVTQnB5eXFDU1BGblVtam11T1p3di8xS1hHS0VXK1pyNFND?=
 =?utf-8?B?dHdhOTlRUXRIbFRGUnd3M2p1a0txVmZRbEVTMWIvb2E2clVxellUdzI5Z3cx?=
 =?utf-8?B?N0NKMk9yUzY1eFJkWVhoeFFMRFRaTnVmVW5vMjJDM1kvYUZsVmZESGdWSkQ1?=
 =?utf-8?B?U2hzTlh0cjVzNVYxVW12M2pVVXEvRVlTWVh6aklFSTRqUnVDVTYxdDlaRnpj?=
 =?utf-8?B?U0ZzVXJmd0p3MWxTK0hiREkyakVCOFUreGMxS0M0K01Ya2VOdHY3QnBDYkhF?=
 =?utf-8?B?NmY0bFI1RkRsS1B6WXNQT1lMaDErM3ZKamJQb0VrNkpRVVdwWTRNWkRqUEFF?=
 =?utf-8?B?L0labnMzZ0RGVG5vdm4xRmJmM0NwdE03NEc0aTZuelVLbGlkdStrbDdhN2pZ?=
 =?utf-8?B?Y0ZZRHpWc1hLdHlQZjRkSmIrZUhDdzMzdGZnR1A5SWZkRmZGL1VUcTBHdlhi?=
 =?utf-8?B?K3FTSG5jK0NUZmpGY1pscWJpTXgxWVNmMGFmaDdIMlErSmdja2Nlb3BLb0x3?=
 =?utf-8?B?RDdzcmpvSUtGUGo3SFN3bSsxOHA5eUc2d2MvNGdzRjU2TFJrajJQQmF1NGxk?=
 =?utf-8?B?TGcxc2pBMGkweUlZdFUwQ2VKbUlrSzljWUFmWGN6dWxZdGtWRFBNSlJDU084?=
 =?utf-8?B?SENVOHhkR0R3bjJ6aTFVL3hnSVQwUW9hZlN0KzBhcmdwckErMVlqU1Q3cUNK?=
 =?utf-8?B?dHZRNitmQlJtajNOemE3Tm9hZ0JFelpqeFB6NHR6M2ZwQ0xBc1NjajFmcGhH?=
 =?utf-8?B?dlBIb0VmczBZVUV6N09LTG0zTUpyTlI5UWhpdnR1WHluQ2RTWGRLTDJMZ2Fo?=
 =?utf-8?B?YzZLT1kzczNWRStWWUMxMFN4MngzMHY2UnNSNksyRUo3aXdCVzg3blpGdkdk?=
 =?utf-8?B?bmNQNkRFeW53YTN1ejFseU0zVzg2OEN4ckdCS2xCU09lTVBYVDNJcjYyNXB1?=
 =?utf-8?B?cFJtQWt5ZlhPeEpnVldjZFhHaTFITjg4QlJHUytlQzg3NWNwemNxdlQ1TkRx?=
 =?utf-8?B?RHNaekVzOURUaEQvRlVqRVBUMVg4anh5YlFNaTFiVy9pR092alVhSlE5Z3gy?=
 =?utf-8?B?MGhoZEk5bHhyYVVBcjNlcG5HbWRuVHdmaGM5RnNrMXNndVJ5dTJQWGl1NVZx?=
 =?utf-8?B?M2w4NnhtMnVCeDVMWndoYXoyYmYxMFBGNTQ3cll0c1lkUVNCS1pJa1NxaTZY?=
 =?utf-8?B?NEdGNHp5ODFQeithd1lwVytZdGl3Ym5aN01DakhFYUtnRWFFTWFqSUV3Z2Vz?=
 =?utf-8?B?OS8wY2UxR0hWV3hDNG1wbDJUMGFlYlJOWnFSQ3pqRlhoNU0ySFJKSlZLTy9w?=
 =?utf-8?B?ZmpjdisrbG0vMXpuOG5RZmtRN1dTdExPZElDaGYrUWRta05xa3VyVnM3NzF6?=
 =?utf-8?B?Tm5XVkNyTmF6UjZyck5pYitDeW1GS0JEZjZjTWxtZS8yU3V1RjlPZE5sMlhi?=
 =?utf-8?B?Q0dteldXTTE2NkhuV25FMWU0K2lVdnRHMlVNOW02YTNxZy90WG9ZOUlSdTFW?=
 =?utf-8?B?OXFFNGVUUjAwaGY4T2EveEsvdndWeHgvK2hUc0FCV0ptY0MzUjhrQk1mV2g3?=
 =?utf-8?B?QngwSitVemp6ZTZTL1U4TXZwcWJjM2lWM2hsM3V2anNTdFF3SUdVQWI4Wjlr?=
 =?utf-8?B?VkUrK0FGa2hsZVYyWEJQQ09vcjlSUWVDS2Z5VWp0WG15OEZEbFhvTTZQMkY2?=
 =?utf-8?B?SzJWYmE2L1RSM3dBTnVPRWUvQ1Y5cFdGVGkvWnU4Wi9TN1A2Nmh1TkE2ZGZk?=
 =?utf-8?B?R0RCOGE2cXpzUFY3ajZPYkhtOWxjbFFCRjVWdVRROXZQakNJR2p5cnVUSFZh?=
 =?utf-8?B?bjZ0SmtVT0ZRVnJZZk96V3lSczNicUE2S3BYOXp6bG5zd2Z2SE52SCtIWjlV?=
 =?utf-8?B?RDhySjcybEo5YUdsdllQb3hJUmZvSzRwMU81cmljOHNzZFl2OTZReWpnR2NE?=
 =?utf-8?B?NjBlTTNLU3A1c3Mxc2N6Nm1oTXMzSWlnRjU1alVtRWJ5ZWlZWkFDTDhFZGhn?=
 =?utf-8?B?UlV2MTlURCtRWHhKWm5uV3JTd3kxRTJIKzhqVVd4eFFnZkwzUUVkYy84Wjhp?=
 =?utf-8?B?WGhuMkZ2c3R3VEw1cS9FcjN6VnBYZGZrTm5YekxpdzM1WVBDcHFkRW1kRkJJ?=
 =?utf-8?B?Y1pDeEtRWlNkWmwvTDF3NjdwK0t0M2E3M2I1ZjNhVjRtOFVKVUVJeEJrSlRF?=
 =?utf-8?B?ajNxMjFvNkRYN2xmVVdudU13QXE4cDRLZkcxSkFuNFd1WDlBT2xoWVc4azVV?=
 =?utf-8?B?WHJ1UzduWUdBb0RsVnpDaW1BOTUxdlQvY0Z3S05ITXQ1elJCYzVWMTBrRmlI?=
 =?utf-8?Q?AH8/+J2eNW3DLo7mp9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 118b1685-22b9-4cb1-003f-08de6e54d279
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 18:46:12.2268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+5i2w/yCEEt1tjGbX49K35rD8Ndyh5N1LPkPYXsQP+cATBqez24wEX0RGRAIHAFrIqZKxEsmj/44IrcHhA5uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6787
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71172-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: D382D14F55D
X-Rspamd-Action: no action

On 2/17/26 12:05, Michael Roth wrote:
> On Fri, Feb 06, 2026 at 10:28:28PM +0000, Sagi Shahar wrote:
>> From: Vishal Annapurve <vannapurve@google.com>
>>
>> MAPGPA request from TDX VMs gets split into chunks by KVM using a loop
>> of userspace exits until the complete range is handled.
>>
>> In some cases userspace VMM might decide to break the MAPGPA operation
>> and continue it later. For example: in the case of intrahost migration
>> userspace might decide to continue the MAPGPA operation after the
>> migration is completed.
>>
>> Allow userspace to signal to TDX guests that the MAPGPA operation should
>> be retried the next time the guest is scheduled.
>>
>> This is potentially a breaking change since if userspace sets
>> hypercall.ret to a value other than EBUSY or EINVAL an EINVAL error code
>> will be returned to userspace. As of now QEMU never sets hypercall.ret
>> to a non-zero value after handling KVM_EXIT_HYPERCALL so this change
>> should be safe.
>>
>> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
>> Co-developed-by: Sagi Shahar <sagis@google.com>
>> Signed-off-by: Sagi Shahar <sagis@google.com>
>> ---
>>  Documentation/virt/kvm/api.rst |  3 +++
>>  arch/x86/kvm/vmx/tdx.c         | 15 +++++++++++++--
>>  arch/x86/kvm/x86.h             |  6 ++++++
>>  3 files changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 01a3abef8abb..9978cd9d897e 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -8679,6 +8679,9 @@ block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a
>>  
>>  This capability, if enabled, will cause KVM to exit to userspace
>>  with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
>> +Userspace may fail the hypercall by setting hypercall.ret to EINVAL
>> +or may request the hypercall to be retried the next time the guest run
>> +by setting hypercall.ret to EAGAIN.
>>  
>>  Calling KVM_CHECK_EXTENSION for this capability will return a bitmask
>>  of hypercalls that can be configured to exit to userspace.
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 2d7a4d52ccfb..056a44b9d78b 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1186,10 +1186,21 @@ static void __tdx_map_gpa(struct vcpu_tdx *tdx);
>>  
>>  static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>>  {
>> +	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
>>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
>>  
>> -	if (vcpu->run->hypercall.ret) {
>> -		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>> +	if (hypercall_ret) {
>> +		if (hypercall_ret == EAGAIN) {
>> +			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
>> +		} else if (vcpu->run->hypercall.ret == EINVAL) {
>> +			tdvmcall_set_return_code(
>> +				vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>> +		} else {
>> +			WARN_ON_ONCE(
>> +				kvm_is_valid_map_gpa_range_ret(hypercall_ret));
>> +			return -EINVAL;
>> +		}
>> +
>>  		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
>>  		return 1;
>>  	}
> 
> Maybe slightly more readable?
> 
>     switch (hypercall_ret) {
>     case EAGAIN:
>         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
>         /* fallthrough */

I think you want a break here, not a fallthrough, so that you don't set
the return code twice with the last one not being correct for EAGAIN.

Thanks,
Tom

>     case EINVAL:
>         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>         /* fallthrough */
>     case 0:
>         break;
>     case default:
>         WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
>         return -EINVAL;
>     }
> 
>     tdx->vp_enter_args.r11 = tdx->map_gpa_next;
>     return 1;
> 
> Either way:
> 
> Reviewed-by: Michael Roth <michael.roth@amd.com>
> 
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index fdab0ad49098..3d464d12423a 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -706,6 +706,12 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>>  			 unsigned int port, void *data,  unsigned int count,
>>  			 int in);
>>  
>> +static inline bool kvm_is_valid_map_gpa_range_ret(u64 hypercall_ret)
>> +{
>> +	return !hypercall_ret || hypercall_ret == EINVAL ||
>> +	       hypercall_ret == EAGAIN;
>> +}
>> +
>>  static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
>>  {
>>  	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
>> -- 
>> 2.53.0.rc2.204.g2597b5adb4-goog
>>


