Return-Path: <kvm+bounces-48585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33677ACF7AC
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:15:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EE8F3A81F5
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC6CC27AC24;
	Thu,  5 Jun 2025 19:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5av7PG1v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC794400;
	Thu,  5 Jun 2025 19:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749150944; cv=fail; b=twtjhgdziDYwqctXCkTY0Vst45XJQfmVQf2hvU2AiUbD1beHZ6nB0tPBWzgHUxx5JdNMAT5P/r3ew72GbEIv+AfmAa2Y5uBdsdz0N7LIHnHw+fTTFgnwoVa81/he+O5wt3b8QBBGruoG9QUmh363VDd9WDQXxVaGuW9z7vX9RP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749150944; c=relaxed/simple;
	bh=5wB0n68dWpb9344Fl+t/lYrNbrS9IJ4ve2ksuv9/jXs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J40WEo1deMdT+3371LiYjaZD7bwuHkR9Sn7aiEiS+zFQVAuAUJ5Z7C5jG45hUo3hcgOZicj5j2jcSGGbe3zG+JWP348GKrgxb5s3uBY+C9XI58ZlufECi5sxGT5oFjGCfeeSWF4f60jdtxCvM9oZtevLXLigCJ4OQV0QIRzVLXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5av7PG1v; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VhbIZHGTcekp+gxdaWWCY1TXcv7EX4eJDHBuQpHS0ciMWULs+cGfUX3ZeSR6VXbAMHLZv4bksEXj6QVM2Q57foo53ur4FiOEgz4xQc9DtpBy4OhaCGH2wRrDboYsBoaVIVUD+qYELk5iKZuIFHx8TtNruzLVhVSX7PKQN2Hinla2WLN1HqC2XA+NDAknLRCV2J4zm8sy9tk2kzrMK40lOsz8nOmqXgyPBShoLGG/VtsLj7uXUWS4PMd+WbiUUzh1r0k+mcvW44GRuBrVX90uGn2ZRvoCCz3qmXMPZ8ADP+ceR/bmtI5jRP5xZuHuEnMTjuBRkOts/TVBK091g3OEgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2aDjspd09XbT5K3oL6YqhehqcUptAZ5omyNjcxNpIs=;
 b=yhxPRenhP/e+wUnHFzx8j9moMt4nN5lqpOyBRA7/lJ+BtnOIpj9jjRUANLTvnm963aL2h5J08DUwSFpZI3UN6liLDNAF0FM9+hGkr3D9npjg01aL2ky+gqPgYg0NZlHBfB4pZzx+E85KLz8kViIIDQyftvHPLAhNc/ZTOLG21KZOjGv3HYucLPDoENttay81pm76Io7evDH6HPck4RJH1QXFHwB3DOZRVWmUCzKZBifOUaObjgO9Th758j0rj1OSSRhsDHl0BmnQiWdhwfM2FCWRQP+FjaDoapFwMgCt5lZ92HLhvw4ZUzvftl9rd911vwyXKLvb5YXoy+Cgu05tFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2aDjspd09XbT5K3oL6YqhehqcUptAZ5omyNjcxNpIs=;
 b=5av7PG1vDcm69SMgyVfRE9KtulkkkGOwgHUyFI1BB2/sDGp44kXa7CEvRmQPRRFG4cho4nfFquJ6PJpY7+UG662b8N3vzrYaUBuwdIaz6XcRQRSpPCPHlHaAxUP1czw3/GoAUkmNquXImCpmRLJbwTW5ZgChBvALyDXExdM8qqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4275.namprd12.prod.outlook.com (2603:10b6:a03:20a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 19:15:40 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 19:15:40 +0000
Message-ID: <b6b9b935-c5fa-dec6-ec82-56015b5dc733@amd.com>
Date: Thu, 5 Jun 2025 14:15:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 2/2] kvm: sev: If ccp is busy, report busy to guest
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>,
 Borislav Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>
References: <20250605150236.3775954-1-dionnaglaze@google.com>
 <20250605150236.3775954-3-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250605150236.3775954-3-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::21) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4275:EE_
X-MS-Office365-Filtering-Correlation-Id: ab8bb3ca-92d4-4c97-6f64-08dda4655c04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlUrajFnMHExcmVXNUlCNEpEcSszV012b2tSdkF0RFJKZHpCL2Z0bVlUeXJl?=
 =?utf-8?B?VzRrVnE4L0pDaW5KUVMxMzdRWHFINUF4cnJKSXludjdZc3JDMGZyR0ZCaEFC?=
 =?utf-8?B?c2pzOVdkUVMvMGlVeXhtUm9Hd3Voa1pHWnM3Q3dEVDJwa3AreEh2Vms1dUFs?=
 =?utf-8?B?WmY1TDJpU2pjTnNTeDZIUmczMjN3YjVCK24vY0xnc0dRelUyQmo0YWcvQlNL?=
 =?utf-8?B?dytkcWxMN0xjTXEvVnZIV2pzeUpqb2ZoSHhJODNsUnR4N2c2bDRoVXlYMHJR?=
 =?utf-8?B?R2FqZjFORFlIMjVIVFlDREk3L04wUzRKRlNkMkZHNXBpcHdwelZhUHNTTkh1?=
 =?utf-8?B?SFc1YkE4V2NFK0NpR25QM3pWdStOWFg1WkZMV2xlektDMTlrV3dySkY3QXg4?=
 =?utf-8?B?RFg4Y0hITTVJUGlROXJKUDV1Y0tyRVlnMWxkMk00MndSMkZZbzA4ZkRSNG01?=
 =?utf-8?B?eTFHYk4rUE9LOUNuYTVmRlBkc3ltMnU1ZnZmRTloZEowc2N4K1NSdW5HWTZQ?=
 =?utf-8?B?VlpyMUJiQ25rVnBTS3gvNk5jQXFiNVlTYTBzRGZJN3MxT2MzRStXVkFPcjgx?=
 =?utf-8?B?U0o3MTNhYjRXU0I4MlFDUWsydk56cDZYbFdvNWt6WmIzcHNCLzJaSGZSK2Ew?=
 =?utf-8?B?c3BGbEQvdmdGMnRrVng0MFBIcXpYQmdZR3ozKytjVm9LajN1UkZpTHVCaFZl?=
 =?utf-8?B?QWN0TWJLQ1Z3aDcwREpkMzl6Q3Uzc3pmRmp4YWVYYlJtcUdOeG5HOHlPSXEr?=
 =?utf-8?B?dkhHSWZvQys3V2dlc0JaMVgrajlFQTdHZ0dRbWxkVko5Q0QzYUVmc2RIWUNh?=
 =?utf-8?B?Y0RBRVlDamxTbm12S3N1MVRManpkdG5LYThNUndEVXdWSWlkTG82Z1Z1U2VD?=
 =?utf-8?B?eVRCMWE4RGRtOENURHVpb1RDUjI2YVRiRTRZbFI3UFZ0R2tjS0huNzNJZTZQ?=
 =?utf-8?B?VyttdzY4T3BQRHZqVitXOE1IdlY2WUt3YUdTL0ZEZ1BFNWFYR3k4UzNVb3BL?=
 =?utf-8?B?OEhIclpnL0NMclA0UFRZeHdDdTNuYUhXNzhrTmdyUGhhTkU0bGRGaVpxNVd1?=
 =?utf-8?B?dnRQMkJUVXFYdU5PUi9vY00vai8ra1VOb0tIRHh5aGh2WVBhRVJnZ1crRTNB?=
 =?utf-8?B?VDdRYUFFUEQzbmE0V3kyaUdWM0tWNTlEL1RZOHlyZDVOK2laT2dFNFZqelF5?=
 =?utf-8?B?RFB0a0JhdXJ5NHlVYnhSTFFmcWFmUmZNR1lHaU1kUXYzNG4xWDNLQmhSV3p1?=
 =?utf-8?B?WGVZSG1FcDVBVS9id1Y1V05NYmtuK1Z1K1hvV01iQzllM240VlhtK3Z2VkNz?=
 =?utf-8?B?aDlxQkpnLzVyUEhkakk5RDg2T3JnUzluWVh0dmJJYVRuVkVRNzJsNm1pN2RC?=
 =?utf-8?B?dEtjU0tHa2tjYUtpUFB2NU84ZnQrM2hpUkJhZjhBeGxVSWtTV2VhdXhCZkVS?=
 =?utf-8?B?d0taY2JPbWtrMHJMT0dWdWtUd3c2OHRUUk4vbHlpaUFSUzdQYjFyN3BzWkk0?=
 =?utf-8?B?V0lIQzJXdVArSHhZL1hMQnROY28va3lxd1lrSFpSVFQvaVZIdjZycEpmYXZo?=
 =?utf-8?B?OXBwZis2WUdRQnVIUnRlekFwZ2VjaWV2SVFIT1FkbW9EalMrRzlVYThJYVdu?=
 =?utf-8?B?QXFFRUVqNjJNbUVzTkYxL0lsL0tqWDJnVUE3MjZnaEJQZHBEVzNxNk5aZFpF?=
 =?utf-8?B?ck5QYmJ0dE5WN3JhOGdBWXNab3hId1BJTUMxdnRmc05WWmJhL2MrZFp4RE9F?=
 =?utf-8?B?WGt3NnpFcG9FK3hOK0dJLzQvV3ZYQTZWYS9pbmYwT0tEdkpsWHJndG9BYlRr?=
 =?utf-8?B?Q2dJNCtxalk0NGNSSWJMOUkwcWdTSlUxWWFSKzZ5YmJ1UUpqZ2NwRFhmU1Rr?=
 =?utf-8?B?UEp2cVg0bjhJcndwTzZnbmgycGw5Ty9FQXZlKzhOVjVNdmVnajM1aVpBTWo1?=
 =?utf-8?Q?SnOuxKPPz50=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHFiL1Z1d3BJSk1yOGZsb3ljQ2xJSzQ2ZDRVT0VyV2FnS0tJOHBuL1hrajFj?=
 =?utf-8?B?K1VReFhsS0JtVXkxZEh4QlJLSmNPOTZZQlR3Ync4OG8zaVZSUU14Skd0NWlO?=
 =?utf-8?B?aUV3TjdZSE9sNVV1ZUxSd1ZybE1iamJsamRwOE5uMThKSlh0K1dydWJEeVhM?=
 =?utf-8?B?NWNOZWFpVTI5SDd1ZFhpYldFRi9oY053UzlKRHdFY29uc2RlWWJJdzVzd2tn?=
 =?utf-8?B?b0lNVjhVdEswdVJ1cXlKTDVWU2xzUHcrZ0xVVEIxZ1ZwZWpUSTNEWElDNERK?=
 =?utf-8?B?YWM1aGJCbFQ0MW5TaUFZRW9zRUU2dC9NWWpRWEh6YXFndDBtNkRFZWxJTDlS?=
 =?utf-8?B?RWhlMHhqb3V1NnR5dnRGZTVqQmJXcGtneVV3cXZCYWJJVnkxanJMN1YxUEwv?=
 =?utf-8?B?a1NtSlgwUk5oRnMwb3VqUVJNTEMySGYwUUYvZmlLMGhYd2JHQjlJVVRVMlFJ?=
 =?utf-8?B?ek8yQnBLbHdobWNuZUJyZzRCb1VCRTFWYmNuTHEzck9KWUNablVQc0VCM1JJ?=
 =?utf-8?B?Vk5nWEh2Rjd0dFZsMENuZmhKeEFEUHBVMkRaazNCWTkxaHdjckc5UytNd1Vx?=
 =?utf-8?B?L0JwalJVR1o1L3ZBNFVQSWluZjBES1ZmbmhzaW1uRXBBTi9meitTTzFLemJP?=
 =?utf-8?B?VTFES1RNbTczRXBJclJvUHFhU2IxeWpJcWJkc3paci9xT2Z0dnR0N2NUM2tT?=
 =?utf-8?B?OHZVV1JKYzNUZitrYTZwRmJLc2pWMWJYQVRBRjRGUXc2RytuT1BRdHlJdmx0?=
 =?utf-8?B?OC8yRnpMbUZkbFRzY0NkZlFBbzhCSVEwU2dwbXRwT2MxbTkvVDZzM1RKdERH?=
 =?utf-8?B?R3YxOU14bHhzRXc1TG5BUFBvRGtqUXlFU1ppazRobGFzYUVWQjVxQ0FVd3JJ?=
 =?utf-8?B?NVlhN0hDcC9JZ0tLZUJjQ0M4NHZhcVhkeVVsNk05TU9ERkVSU0UrYktWMHdY?=
 =?utf-8?B?d0pNeSt6NWh2UERSWFdyOCtPZkdOaktlUWF4K2srN0NydmlxZnpkNkdSbG9Q?=
 =?utf-8?B?dDdGNElaanRHVXBHa3g5TnhvcmFwWFZDaDZLVkF1YitPK0pvdzZoNmJlekxD?=
 =?utf-8?B?VU05S2IxNEZOb2ErMk0vektsTjgwQmdrNXh1am1uMFM1UHlaaU5jdDZFNlRG?=
 =?utf-8?B?WnNzQlVsbTdTSDF3b2JyaG5WWjBNd1kyOU5aa2NqYVZLN25Hcmo0Tjh1ek0w?=
 =?utf-8?B?WUJwOHZCZGttTnBOVnpleWtrZWVuQ1N0MWE0NU1ZU0dZSkNoNUNsMW5NOHpG?=
 =?utf-8?B?WlpKQXd0RDJJR0pabVVMZGVqMUtiS3ZneU00cUVhaHdEb3o4T1hQREMwZnlL?=
 =?utf-8?B?MENKL0FzbmNvOGxIbEhMeTZhYlhROFRNS2ZDWGNScHhvOUxQemh4NGMzNUlG?=
 =?utf-8?B?M1NzQW12VkRnczkzdGhEMUVtM205YTNLWFgrd2J2RGxzYmdqTmlORDRsT1Bw?=
 =?utf-8?B?blVXZXpNWE9DVmhZVmR0YWUrY01tN3lwRzYxN1NsWmRLUExDRzJkWUtraHdu?=
 =?utf-8?B?NXVLWmxaNjUwRlhudFI3M01KRDBJeFEvRGdaUmxKV2ROdVorR1FmbTllU0Rj?=
 =?utf-8?B?Wlg2aWF6VXc1OE5qSVYzR0JmUGFsaEt1SGVBNUtVUVdvTHVhWHdCcWxJbUV5?=
 =?utf-8?B?elNwWXF6MXhad0tuVGxYYWsyRWtxNVJwUGU4S1lxcVNuTEtCVzQ4NGNLN1VB?=
 =?utf-8?B?bzcvZ2x6LzV1bEdQMUkyUHowTzBVaVhuV2VVRWlyVVM5cWVXS1ZiaFNGQTIr?=
 =?utf-8?B?Qm10S3d1T2kwTkh0aktZZ29wOUVTZk9QRWlWSnBZWVNwNzBVREN4RW1IK3Qx?=
 =?utf-8?B?MlBFa2NOSDZ6aUthMXMrTmFra2RXK3U4QTBuOEErS0Q5TjMrQmRnTU1ZRnZQ?=
 =?utf-8?B?TC9lRll5enE3OXdiL1JUcUxad1VZdUd5TTRqS29MQTR1ZzBVNENOSFJSeVBk?=
 =?utf-8?B?SjgyZC81c2Fmb09Sem15bXRnZ01Nd1NUbjAzQngwRDByZU1pcmhnSEVPMEo3?=
 =?utf-8?B?YXJVZlFMQk84NUFvYVlFL3Z2SXRpaHpOMUF1c1BWaFNnNmNFMjEzM2puTXVZ?=
 =?utf-8?B?U2R0b0VNaTFDRmd1WjVmanh5RFN2UWxXWG5nU1dxWldBTU8xY0VIUVFYa0hj?=
 =?utf-8?Q?9MW+5XYO89cmTpbYbq2yVvWo4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8bb3ca-92d4-4c97-6f64-08dda4655c04
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 19:15:40.0755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8fvibHeBvq4TUGBpdqd3nSgMn3eI2GczfCJ27KrHuR+121bDkZm/u/XNth3LKhiqCnE470ZsjBe0AwGR2XVKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4275

On 6/5/25 10:02, Dionna Glaze wrote:
> The ccp driver can be overloaded even with guest request rate limits.
> The return value of -EBUSY means that there is no firmware error to
> report back to user space, so the guest VM would see this as
> exitinfo2 = 0. The false success can trick the guest to update its
> message sequence number when it shouldn't have.

-EBUSY from the CCP driver is an error, not a throttling condition. Either
the driver has marked the ASP/PSP as dead or there are no command buffers
available, which is an error situation. There is no throttling support in
the CCP driver. A mutex is used to serialize requests, but all requests
proceed at some point. So there should not be a special check for -EBUSY.

Thanks,
Tom

> 
> Instead, when ccp returns -EBUSY, that is reported to userspace as the
> throttling return value.
> 
> Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Sean Christopherson <seanjc@google.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e45f0cfae2bd..0ceb7e83a98d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4060,6 +4060,11 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
>  	 * the PSP is dead and commands are timing out.
>  	 */
>  	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
> +	if (ret == -EBUSY) {
> +		svm_vmgexit_no_action(svm, SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, fw_err));
> +		ret = 1;
> +		goto out_unlock;
> +	}
>  	if (ret && !fw_err)
>  		goto out_unlock;
>  

