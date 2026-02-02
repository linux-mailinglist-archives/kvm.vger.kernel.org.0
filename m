Return-Path: <kvm+bounces-69850-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6A9JMs+rgGkFAQMAu9opvQ
	(envelope-from <kvm+bounces-69850-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:51:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 750CBCCF18
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:51:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA1F53002D41
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 13:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B3A36AB45;
	Mon,  2 Feb 2026 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="mDG0IrqO"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013006.outbound.protection.outlook.com [52.101.72.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC621C5F27;
	Mon,  2 Feb 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770040265; cv=fail; b=EBQnOhoxw9+D4DbtyvOPGVmVE9tSpx19oQ1I0xutV3QDLNk8hF/7K3LbDK88RXR1IV+x4Pl14vZBkLMaxV6HmOPoSXRQwYUUJ06GFK9R2BGuA9dL7l3nazQ+7bI4EcPggPu8LdHQlAlVR/H/ymYNxisZUmpCMO9J49BhtYxaUqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770040265; c=relaxed/simple;
	bh=xPI1kcjANk0ybnUUNDpnBxQ82d1E//60zOfrHrqTBLs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PPDVli4Vnk98LjthZFTLrw6Jd9WCnfGafiCrK9KQqSJTHPJ+4bAow8OjyIaX/1sWKgR3NAoVUw9pE/OhtDIaSUZ8BJ304kbdixKbIpDGWN50LV2yEerR/OO9Ru75FQPIfdzNWAdi8DGLvHAo7yVQzRv5xUWCrxuCrCKDavWrewo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=mDG0IrqO; arc=fail smtp.client-ip=52.101.72.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SvzxotOPprVwaSq7b27OICqbZZdMPWARxPeuhmYrLJWXZiMhEQ5+Wy+wVUCTqIbqOiWxNG4wAhOhCpZ4urTPjGLz0WkKRhxbqQU7xtvJxLRnoosEQw2foMIVHcKyLAlIWWjpsLgxFmCBPALROey3q8olRdelzKVjeIodt14rLv2IsY8qBOS019oL5/EwaN3RyfG2FUg8pSFDbYcut4sNQnVYG0l6DEDayUVXG4OKkXmIPKYkpjCoAuw3yxNfry3PuZjburgPZvOcc02wrJvRECnZMzIBANs7RZkPS5AFA27TfTLMhBjEfBxOixIWrZgR+him6CWUcoZzDgrBjVP4mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXATRkmSBS3hlr4oI8moLbEhZpRsYQ9uBsOirJST0lQ=;
 b=cTUqL4RbzNADMRVzSgcTcHuzG+myYU597xSfY4aI/Si9Fs3VTb6dIRAG0OATWnAj+zh6glcg2lAB0IT6xTGAiKbSKLzdlNOtRsVCTw0j6/qqbU/By0K4x0Ufw4qmUDukix9KSTvv4qtOUxxaSs0Oi70nOXvB3R37/Wqc7CQkvhGC4OzaBLqDgvqT5J//Qkpl3f2vE4pjaXbnaCrd2h9yg49Nn23uAP6aY3VGfeWH3wI9zFEEnf5z//f6StAwMtt+zGFXdJhZh/j8rRygc1hJn05VIV0rm+3uJy53ENmSzwbp/ZZGXOqZfQRHRPoc3AYQ2Y21XbOnSe3XqrvwDRG56A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXATRkmSBS3hlr4oI8moLbEhZpRsYQ9uBsOirJST0lQ=;
 b=mDG0IrqO6HmdZHzhnihMpT7hdntY7g8hfp81YomdL9B0P2+aWaauhQ8qfMTUxU5Z2DQTRBocMF46/iVgvmvCyK9DeekECuqj4dPiAZnHyXnmyTREwUkqum1+hWGZV7uORN9AmnbOEXiSrH83GXx1ivGNIAbQ/eBr6vuWH2PQ8Wc6wH+ERax90QYnPPBbBA2fhs3uHQ3tr7k4N85Tpo66dbcuPn74yAfuxZ1UkcJ1RplHVUfEUw/rGNk/j5TEZHOuKjj/KVIosnm2dPTxhMZrnM+Nm/FTBQziXkd+/Wpt+IEDtBfGYqZQFLSYGMTPRBBM2d8Whai4weDIlgW1nepjAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:588::19)
 by VI0PR10MB9380.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:2b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Mon, 2 Feb
 2026 13:50:59 +0000
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::be9f:e8ca:ee9:83e1]) by AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::be9f:e8ca:ee9:83e1%6]) with mapi id 15.20.9564.014; Mon, 2 Feb 2026
 13:50:59 +0000
Message-ID: <c6d18df5-d0b9-4716-b31a-8c12b0ea3739@siemens.com>
Date: Mon, 2 Feb 2026 14:50:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] x86/defconfig: add CONFIG_IRQ_REMAP
To: Andrew Cooper <andrew.cooper3@citrix.com>,
 Shashank Balaji <shashank.mahadasyam@sony.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Suresh Siddha <suresh.b.siddha@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>,
 Daniel Palmer <daniel.palmer@sony.com>, Tim Bird <tim.bird@sony.com>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-2-71c8f488a88b@sony.com>
 <a7d93306-42e5-4617-91df-23f7dd35aa1c@citrix.com>
 <f875676e-c878-4d3e-9eae-1f74f24cdedd@siemens.com>
 <7469ab46-94c9-48c8-b6e7-b500550768a9@citrix.com>
From: Jan Kiszka <jan.kiszka@siemens.com>
Content-Language: en-US
Autocrypt: addr=jan.kiszka@siemens.com; keydata=
 xsFNBGZY+hkBEACkdtFD81AUVtTVX+UEiUFs7ZQPQsdFpzVmr6R3D059f+lzr4Mlg6KKAcNZ
 uNUqthIkgLGWzKugodvkcCK8Wbyw+1vxcl4Lw56WezLsOTfu7oi7Z0vp1XkrLcM0tofTbClW
 xMA964mgUlBT2m/J/ybZd945D0wU57k/smGzDAxkpJgHBrYE/iJWcu46jkGZaLjK4xcMoBWB
 I6hW9Njxx3Ek0fpLO3876bszc8KjcHOulKreK+ezyJ01Hvbx85s68XWN6N2ulLGtk7E/sXlb
 79hylHy5QuU9mZdsRjjRGJb0H9Buzfuz0XrcwOTMJq7e7fbN0QakjivAXsmXim+s5dlKlZjr
 L3ILWte4ah7cGgqc06nFb5jOhnGnZwnKJlpuod3pc/BFaFGtVHvyoRgxJ9tmDZnjzMfu8YrA
 +MVv6muwbHnEAeh/f8e9O+oeouqTBzgcaWTq81IyS56/UD6U5GHet9Pz1MB15nnzVcyZXIoC
 roIhgCUkcl+5m2Z9G56bkiUcFq0IcACzjcRPWvwA09ZbRHXAK/ao/+vPAIMnU6OTx3ejsbHn
 oh6VpHD3tucIt+xA4/l3LlkZMt5FZjFdkZUuAVU6kBAwElNBCYcrrLYZBRkSGPGDGYZmXAW/
 VkNUVTJkRg6MGIeqZmpeoaV2xaIGHBSTDX8+b0c0hT/Bgzjv8QARAQABzSNKYW4gS2lzemth
 IDxqYW4ua2lzemthQHNpZW1lbnMuY29tPsLBlAQTAQoAPhYhBABMZH11cs99cr20+2mdhQqf
 QXvYBQJmWPvXAhsDBQkFo5qABQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEGmdhQqfQXvY
 zPAP/jGiVJ2VgPcRWt2P8FbByfrJJAPCsos+SZpncRi7tl9yTEpS+t57h7myEKPdB3L+kxzg
 K3dt1UhYp4FeIHA3jpJYaFvD7kNZJZ1cU55QXrJI3xu/xfB6VhCs+VAUlt7XhOsOmTQqCpH7
 pRcZ5juxZCOxXG2fTQTQo0gfF5+PQwQYUp0NdTbVox5PTx5RK3KfPqmAJsBKdwEaIkuY9FbM
 9lGg8XBNzD2R/13cCd4hRrZDtyegrtocpBAruVqOZhsMb/h7Wd0TGoJ/zJr3w3WnDM08c+RA
 5LHMbiA29MXq1KxlnsYDfWB8ts3HIJ3ROBvagA20mbOm26ddeFjLdGcBTrzbHbzCReEtN++s
 gZneKsYiueFDTxXjUOJgp8JDdVPM+++axSMo2js8TwVefTfCYt0oWMEqlQqSqgQwIuzpRO6I
 ik7HAFq8fssy2cY8Imofbj77uKz0BNZC/1nGG1OI9cU2jHrqsn1i95KaS6fPu4EN6XP/Gi/O
 0DxND+HEyzVqhUJkvXUhTsOzgzWAvW9BlkKRiVizKM6PLsVm/XmeapGs4ir/U8OzKI+SM3R8
 VMW8eovWgXNUQ9F2vS1dHO8eRn2UqDKBZSo+qCRWLRtsqNzmU4N0zuGqZSaDCvkMwF6kIRkD
 ZkDjjYQtoftPGchLBTUzeUa2gfOr1T4xSQUHhPL8zsFNBGZY+hkBEADb5quW4M0eaWPIjqY6
 aC/vHCmpELmS/HMa5zlA0dWlxCPEjkchN8W4PB+NMOXFEJuKLLFs6+s5/KlNok/kGKg4fITf
 Vcd+BQd/YRks3qFifckU+kxoXpTc2bksTtLuiPkcyFmjBph/BGms35mvOA0OaEO6fQbauiHa
 QnYrgUQM+YD4uFoQOLnWTPmBjccoPuiJDafzLxwj4r+JH4fA/4zzDa5OFbfVq3ieYGqiBrtj
 tBFv5epVvGK1zoQ+Rc+h5+dCWPwC2i3cXTUVf0woepF8mUXFcNhY+Eh8vvh1lxfD35z2CJeY
 txMcA44Lp06kArpWDjGJddd+OTmUkFWeYtAdaCpj/GItuJcQZkaaTeiHqPPrbvXM361rtvaw
 XFUzUlvoW1Sb7/SeE/BtWoxkeZOgsqouXPTjlFLapvLu5g9MPNimjkYqukASq/+e8MMKP+EE
 v3BAFVFGvNE3UlNRh+ppBqBUZiqkzg4q2hfeTjnivgChzXlvfTx9M6BJmuDnYAho4BA6vRh4
 Dr7LYTLIwGjguIuuQcP2ENN+l32nidy154zCEp5/Rv4K8SYdVegrQ7rWiULgDz9VQWo2zAjo
 TgFKg3AE3ujDy4V2VndtkMRYpwwuilCDQ+Bpb5ixfbFyZ4oVGs6F3jhtWN5Uu43FhHSCqUv8
 FCzl44AyGulVYU7hTQARAQABwsF8BBgBCgAmFiEEAExkfXVyz31yvbT7aZ2FCp9Be9gFAmZY
 +hkCGwwFCQWjmoAACgkQaZ2FCp9Be9hN3g/8CdNqlOfBZGCFNZ8Kf4tpRpeN3TGmekGRpohU
 bBMvHYiWW8SvmCgEuBokS+Lx3pyPJQCYZDXLCq47gsLdnhVcQ2ZKNCrr9yhrj6kHxe1Sqv1S
 MhxD8dBqW6CFe/mbiK9wEMDIqys7L0Xy/lgCFxZswlBW3eU2Zacdo0fDzLiJm9I0C9iPZzkJ
 gITjoqsiIi/5c3eCY2s2OENL9VPXiH1GPQfHZ23ouiMf+ojVZ7kycLjz+nFr5A14w/B7uHjz
 uL6tnA+AtGCredDne66LSK3HD0vC7569sZ/j8kGKjlUtC+zm0j03iPI6gi8YeCn9b4F8sLpB
 lBdlqo9BB+uqoM6F8zMfIfDsqjB0r/q7WeJaI8NKfFwNOGPuo93N+WUyBi2yYCXMOgBUifm0
 T6Hbf3SHQpbA56wcKPWJqAC2iFaxNDowcJij9LtEqOlToCMtDBekDwchRvqrWN1mDXLg+av8
 qH4kDzsqKX8zzTzfAWFxrkXA/kFpR3JsMzNmvextkN2kOLCCHkym0zz5Y3vxaYtbXG2wTrqJ
 8WpkWIE8STUhQa9AkezgucXN7r6uSrzW8IQXxBInZwFIyBgM0f/fzyNqzThFT15QMrYUqhhW
 ZffO4PeNJOUYfXdH13A6rbU0y6xE7Okuoa01EqNi9yqyLA8gPgg/DhOpGtK8KokCsdYsTbk=
In-Reply-To: <7469ab46-94c9-48c8-b6e7-b500550768a9@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0206.namprd03.prod.outlook.com
 (2603:10b6:610:e4::31) To AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:588::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR10MB6181:EE_|VI0PR10MB9380:EE_
X-MS-Office365-Filtering-Correlation-Id: 65549c61-fc37-4108-c9ef-08de62621886
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDU1V1hHdWw5MlV4dGhLUGZlM2p6OFJ0ZG11M0V5alhGUVc4QUlzaUp4S1pO?=
 =?utf-8?B?eTRxVDVGUE52a3g3b09RTlVYdXZ6bGRnMjhxL2ZidmZVRjVNMGtadWhBdlVL?=
 =?utf-8?B?bDYrMmc4MHd3SWQrelRobWdPdjQwTlg2RmMxN2dHT1lUdEJadzN1cllFYU5T?=
 =?utf-8?B?bjJsRUI2akR2NDl6WlhoSHd0eHZDZ2h5UzhyQjA0cWRQaE5TMXVoZDAvTCth?=
 =?utf-8?B?Q3MrZjlmZjhmdzh4SmgzQzJucWJQWlkyMnkzSTZQZXE3WVRONnR2TllVUExZ?=
 =?utf-8?B?RG9tS3hKcUJSNHRrSnJyK3JGTmRsMjUvRlI2RStXZzF4dm9NU05aQU5POVlo?=
 =?utf-8?B?T1BnRVJOaDVRaGNDLy9sZ1lBdmJUR3g4Vnc5WkpTelh1T3h4S0V6bEZpT0Q1?=
 =?utf-8?B?c00wNytSOFptcXZFN3c2ZDJhR0VBaWtTQ01HZGNKb1oyTy93QXVycW9zZWFw?=
 =?utf-8?B?eFpaRTM1SW83Rkc4QXhmRk9IWDJBYUFXamlBYzhZK0J2M1FwWlRsQXFZUEpo?=
 =?utf-8?B?VWwxY3FVSEdabkFYaGR1ZEdnQnUwY2syT1hGZlpHK1dxKzA5MjhxOVJzclQ5?=
 =?utf-8?B?TE1mOS9ZWUNvMlp5Nk1NVjdWZmZySFp4MkxkSzFhbVBLNm1hSXJtOGdOR2dl?=
 =?utf-8?B?cDEyRkJpdkREZUxTSXdGWTRJSEI3RDhHa0dmY3J6TmdwVkRYTkE0SXZTRzE4?=
 =?utf-8?B?bUFtTG5wejNTZ000WTlvdytDbjVWZkRIN0VsMjVHQXdOWndJRmlqMkt6U2xP?=
 =?utf-8?B?c2RMNlBva2gwbFN0REpXOEdKME51ak0xWXJnTGEydFFkenVxNzFna0ZPam50?=
 =?utf-8?B?Y3M2dXFOR3ZjdGZQelBxazd1NjVhUW9YNzhzc01TL3p0Z1FIaFZBemU2ZlZW?=
 =?utf-8?B?d2NOUUZZQmhaZnU5WlF4QVFQVFZhbysyZVV2cUJhVEdZOWRmcjliek9IZFNL?=
 =?utf-8?B?S2dPK3RKQTZ2eTZ2cHFSL1gxdmYrcGNHQmRNNmVjZlJmMkJIYktQT1ZyeDNk?=
 =?utf-8?B?N2xISmlZUG1NM1lpcUxRVXpYdVlnU0I0QVF5VE5LQ0tuVDBwWFMvcWpKd2oz?=
 =?utf-8?B?ZUN5NFdBVGRmNmNqOENERy8zTWZnc1pjSjd1SlR6ck5BQkxNQnhEeWVOWFU1?=
 =?utf-8?B?MWw2MTVMYzMwQWU0dGl6S25CTitJRy9nOUhqZVZndER3S3cwRTA5WUhMQU9I?=
 =?utf-8?B?K2pWQS9WZklMYXg5Q2E0VEVCSGRuNUNqR3BoaUc4dDhqOTV4UWFqRTZFUno2?=
 =?utf-8?B?a3V6aDFLbmhVYTF2TitZaStpVVg0VGxCdlV5b1l2Y3VyeG44cG1zajN6WE1a?=
 =?utf-8?B?ZmZ0SmhPWnozS1ljbVRMQnVnV0M1WDF4Q1hKMEswZ3RRQXhrTFlDQ1Y1anpU?=
 =?utf-8?B?bDdHLyt1dWJsTlRJUHArTk1wdm5VUkhhbWlXOUR2a2lhVUpIYTU1eU5LN1FJ?=
 =?utf-8?B?RnFvbk85b0NtMDl6MldibjZGNmRlTWd2Y0wxVlhOTldQOE1SWkhIOU1ZYXBN?=
 =?utf-8?B?YWM1OGpXbE9KOEZXUTE0eEM4anA5dFRPK1U1VUlCWjVwbDZEL1g0Y2RrSE0w?=
 =?utf-8?B?VWVpQS9DU2Q4bWxmb2E3SlJ3aHdzTEtmOXdkWUdNZXZJVVFSTHZTSEFTNkQr?=
 =?utf-8?B?TzIrMjJaUnJLalFFYVRFdUxlZys5Zmh2WWlFQnlGZE80SENnMXpMU0tjUjR5?=
 =?utf-8?B?Nm9hVElnN2liZWNpeXMrSXViek9taTRzUUo3QzVNQ21LN0JiZVBHdWVtQVRl?=
 =?utf-8?B?M01ROU9rT08wVmZwZUJTd3E2aG5qclQ1QXhlVXpZUzdxUVdVeFNreFhFTWJL?=
 =?utf-8?B?aDJIU2xIMFNRVGtqZ2pnSGxBNHl2a2VMRDc2ZnZmbm1sSTFrTjkwdDB0cVlN?=
 =?utf-8?B?VWJFR3BsLzJqcWpmQ0lGTG4rNkpTV2JIdjZMSXZlemdiR3N4ZGZ4S29hZkN0?=
 =?utf-8?B?Y3hRcEw0VHZuVkw4VGVzaW90cCtZOXBwc2ZnTStWejVmZW1NMDZoSW9xaGJP?=
 =?utf-8?B?alZQNFRWbU80WVJsQmt2WUlhRDdoWm1FM2tMRjB0c2dxUllMUkpqaGZtMjl2?=
 =?utf-8?B?T0Q3cjNrOHZVYTZpWHJtdkNiYVd2TE9RQVAyc3hiTGtJOFVCWTRVUjlKVFZz?=
 =?utf-8?B?ek9Vc1ZKOFZnT1NzMGpIVHVGYStMalZVVDcwdnE3eFlkNmdDbmNseE94WUw3?=
 =?utf-8?B?enc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bks5N3ZQdVhMWnFlRXpMaEJNbnVKSU1lclFFdk8vd0wrTDdzRThZWEVyOHFx?=
 =?utf-8?B?UE92OXhyZTNPeXBZZWRvSmhMVm5IQmthODEwRlJGOWhUaE9STTRwcXRldEFI?=
 =?utf-8?B?SkZIQ0x4cFlEYmY1Q2g5T05uMzZhR28yT2R1d2ErR0IrL2ZHQ3AyeE82eWZN?=
 =?utf-8?B?ajRkQ1hkaUJ5L1RmNWoySVZDWW5aR3hzU2w5RGdYM2krNEdwMmhXa1VyRmo5?=
 =?utf-8?B?bHUySEdsL2ExVHRHRjBkajIxWnVXYUo0SUxIOXFCY3NlcVg5SWZhbEFEZWt0?=
 =?utf-8?B?d0JENXZlTzZVa3pHMERqWWJndGhjdmJWMGlJSENGT2NjWEhxQVA2UWliK3dE?=
 =?utf-8?B?MS9zbXZpb3J2a2FzclRSWlRjM3o0aG5wMThYWFdqWnBpem1zTUd4Y2UyRlJL?=
 =?utf-8?B?VHZFdUxJUDM0VzE2SW9OU2RnZTV5dGI1UVBrUnlSaGQzTTRFcU9IeG1UTWV2?=
 =?utf-8?B?clltUGFyQ0lzSTMyQnhOdU1rVEVuaVpPMGkrbEYvelp3ak5UUlMveFROdDFN?=
 =?utf-8?B?QnNPZjhyUVpEelo3K1lZRlh6RHI3R0hTeUtaOEc4cStFTVp5UEVDcDlUaFFv?=
 =?utf-8?B?bE13aTdVaU5iRFFzWDduWjFNWnQ3WVI1c2tpRWNydUVSZDFKT2QvUHJlL2NX?=
 =?utf-8?B?MVBRK3hxSm5pWGdQVWFxbSsrVmxTYXhBb3pLNk1oUG9OR1ExaEJhMmZkK2lY?=
 =?utf-8?B?bjJvaDJGUSsyalNRbHlkUE5NMWZ4akQrd3k1UzI1Z1pVNEZNQWFtSkQ1bmNT?=
 =?utf-8?B?TXUvYmU3WDY3bk5oL2dxSDdBZnZVUWdCek1wci8wZkxwR1FXR1RoL2dWejY2?=
 =?utf-8?B?V3F1WWJ2YW14Q3ZFOFJlUTZSQk9paVZSMk1xaG5Jbll0NWxHNG15bHZUN2hB?=
 =?utf-8?B?ZXg1LzBXR1VuUmJ5VGJuQjBOYVFicHRRcEVBNy9ZdlNXNUJKa1pDcnVNYmRw?=
 =?utf-8?B?ODhyeCt5MmZLRlFUVFVhOXdRMFdvMnh2SkxqWGxZbTh0dTRqTkdVUFVXbXlp?=
 =?utf-8?B?bTJrMnA0YmY1enR1bnViMXJHS0RWSE5qT3JGS2RSai9zamNoNFJOcEpYaHVv?=
 =?utf-8?B?VDR2bndISTdZRXJTZHIxYnJVUElwZ1lkYkMyNC9MUGc0SFFtVUQzYzA5WVhG?=
 =?utf-8?B?MTJJMTM1OXAwM3l4dWJEN1gwS01yWVc5eWpuNVduUTBBNnRaWkZ3QytlMlhB?=
 =?utf-8?B?MFIvOUwydjZaTWZON1dITWh2NHkzMyt4ZHNZODVSZkovdzlUVHc3dTVJd2Fq?=
 =?utf-8?B?SThwcmFNcG85ZHFJUzdIb2JDR0IySlBOVFltbnduaFQ4NU5QK2ZjdFlUTDRF?=
 =?utf-8?B?MlRKb0NBaWp6NEdPQ3huZ3BqYllDd3lhRFpnTTloc2VwWWVOSkxURi9iZmVp?=
 =?utf-8?B?RWlKTUIwTFRBcGltRGR0blFWdjYwZVBmN3Mrd3ZwaWF4QVh1YWtwcGR0bTZD?=
 =?utf-8?B?Rm5GTGx1c0hNQ1BBYThQNE9JYk5rV1BHRGF6RVFUa0Q5b3Vhd3pGS1VRc205?=
 =?utf-8?B?LzdpaEZjWVU2MHl2UTAzN0NNbERyTDFSemxqMXBmTG9oYmdRTTN0WUQvb3U0?=
 =?utf-8?B?c1pnc0pHbkVsT2R3d3RjT3RGZjlkbHl2ajFNMk1Gb1ZNT244QkJqUG94V1F1?=
 =?utf-8?B?ZzRUaDNMdDZjU3lCWTJ0djhvSGxwcUlOZGpjcVF2aWYzdHc5b1JHTEtBTHdi?=
 =?utf-8?B?bFNqb04xUTdmMFdwMllhcDRSVU9yUFRlL1J1L3JHRVNRYWRKTVM1VWpaaDBE?=
 =?utf-8?B?SDErMHZLTGZ6NnJ5LzQ3eVV4aks5THRsZjZpWTM4djUxSEdUYnpOTlFmaHJt?=
 =?utf-8?B?U0RFSmFPcE1ib0cvTGhhNFY5UjNVM1BLbjVncUlqT1JIK0ZzU1ljV1NsdUd6?=
 =?utf-8?B?aVhqOWZIOUI0cGpoenB4RWQ1MUNaQWhSY09kOWFrZUViTFZ1a3EwV01xVjc1?=
 =?utf-8?B?UUZ1TWpQK1lHeDdadzVTMG5LRXZreEhCZkE4NS9ub2E1K1BzVkh6U21rbGV5?=
 =?utf-8?B?dFRTWWYyR3VYVDZXOXVZN3ZrMDVINHR5WHJxT0pmUXVQT05UQWZ2bDRUcHh0?=
 =?utf-8?B?MUo2djBPTDlOWUtJWTlSWGlGKzU3U1VSRmRpa09KM01WaVZ0NUxwblpDYThs?=
 =?utf-8?B?ajlYbjEwdGJRdGo5bU5NSlNjRTZ4dFdKRk90YnpWeVlEd3dHWUNQR21JQWoz?=
 =?utf-8?B?MlVLMTlCL3BhdjNvUlFuazBvWE00dzNVRW5IQ1FYbnBLSi84T2RXS255Mkd5?=
 =?utf-8?B?UCtjWjBIZkdQY3QyOUJsVmZhTGtyOEI0VXBIRzloU0IrclhWOHNrU2hneSs2?=
 =?utf-8?B?cWQvQis3bHB5T2JpM215WnBtYUZpTytuYVpVYUphOWZRaXg4YjlWZz09?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65549c61-fc37-4108-c9ef-08de62621886
X-MS-Exchange-CrossTenant-AuthSource: AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 13:50:59.3310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z1T6xcS+yFPWwMhyV7E89b40MzeUNoePMqGD3p3/tkoRyhlgM4UirFDK23/RvtEPJtLOuVIPgoocK+hP+sz8xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR10MB9380
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[siemens.com,reject];
	R_DKIM_ALLOW(-0.20)[siemens.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69850-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	DKIM_TRACE(0.00)[siemens.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jan.kiszka@siemens.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,siemens.com:mid,siemens.com:dkim]
X-Rspamd-Queue-Id: 750CBCCF18
X-Rspamd-Action: no action

On 02.02.26 13:12, Andrew Cooper wrote:
> On 02/02/2026 11:54 am, Jan Kiszka wrote:
>> On 02.02.26 12:35, Andrew Cooper wrote:
>>> On 02/02/2026 9:51 am, Shashank Balaji wrote:
>>>> Interrupt remapping is an architectural dependency of x2apic, which is already
>>>> enabled in the defconfig.
>>> There is no such dependency.  VMs for example commonly have x2APIC and
>>> no IOMMU, and even native system with fewer than 254 CPUs does not need
>>> interrupt remapping for IO-APIC interrupts to function correctly.
>>>
>> It is theoretically possible with less than 254 CPUs, and that is why
>> virtualization uses it, but the Intel SDM clearly states:
>>
>> "Routing of device interrupts to local APIC units operating in x2APIC
>> mode requires use of the interrupt-remapping architecture specified in
>> the Intel® Virtualization Technology for Directed I/O (Revision 1.3
>> and/or later versions)."
> 
> This statement is misleading and has been argued over before.  It's
> missing the key word "all".
> 
> What IR gets you in this case is the ability to target CPU 255 and higher.
> 
> The OS-side access mechanism (xAPIC MMIO vs x2APIC MSRs) has no baring
> on how external interrupts are handled in the fabric.
> 
> There are plenty of good reasons to have Interrupt Remapping enabled
> when available, but it is not a hard requirement architecturally.
> 

If that is true, then this patch is the wrong one to blame because it
only reacts on existing kernel logic and repeats the arguments that are
in the code and even provided to kernel users. If you have hard proof
that the existing code is wrong (some confirmation from Intel folks
would be "nice" I guess), then propose a patch to change that logic.

Jan

-- 
Siemens AG, Foundational Technologies
Linux Expert Center

