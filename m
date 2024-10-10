Return-Path: <kvm+bounces-28362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A6A997C6E
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 07:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 830991C2195B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 05:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F7719E836;
	Thu, 10 Oct 2024 05:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jse889ON"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2052.outbound.protection.outlook.com [40.107.101.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F373D66;
	Thu, 10 Oct 2024 05:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728538291; cv=fail; b=Od5Za9cer7IRgnX8ewvgRzHFUigo2Iq276CCefK9dg6e5Iaf3YZntTej7czA034ftklt3ZDNPvjEmMEf7fBpMsHB2Zfa3V3l9VwL5CCLdp4DBWmUtXbqBOPaV6S9RlUEH7UPX8PuCFUXj7pS9KSjFC5YCjv+pYDc/yr8GE+mDlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728538291; c=relaxed/simple;
	bh=MSE9uiWDElVrqn8Max0CEswe+IV0j1OuxekiHaE3lQI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YtoYCmJQ6Qyw8dMYEfPc4gfxcRelyO0CXHvn1hG4iI/4rnqSEbU2KBuR8BfvA1XxmtrhIGn8LF35AxLWgZiWE7XGhWKVZMN/CBZbvz70n5XQXVYJ7D8e+fy5D3oSFCuLlS8P4ttIL6WpU6+TUa6qUV914U8XqrxJQwxZm7FoNMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jse889ON; arc=fail smtp.client-ip=40.107.101.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wV+aWlJ3pJbQuNl02bfs2UcFAQaCDqawVj2TV65VAntoMh+zdYWdEZzuo22GYFkHHJbe1Nc9GMxtWYOxS8HlyvDJa7H8QOY9phsc2gOQg3goHin7/lq52HWqJ9021w3z7RPb03+r8aeapxXsqhNDmaRLxmA2a4l/yYn8Zok0K501ZYWJU6eZhe5AtzWMgeEa1czoKVnnlhWlmNimUzrGBOqpdZ1ATLb6SHe07WpUhAYAvvBm5Kc4qKois2VUyHa4IvJbWHzEou99jzmIeMO/G7m1Z0qupjOzp+9VuDUT/1hpU/BhZzG9cnPgADtF3rCDvLyUWfm8SLxSVs7NNgC7xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2wGRnyYTNIUco1dbMHfZRLgp7WhR+8JJzlNMiUtgks=;
 b=VwtgBaw98V/iMruGqfGoqoceQ+s31SB9zPVFWY5+nKYpCl0l1Kjv+3xRKOzRhWKo+8VBa0RyoguNCICvDcRi7n3hLfz1Vd8snUGV9ORALawkYQ7i/MbNMZh6WzK5KtGAKshTWV6wcRrfXAdUX2z/iw88pMWfGrAFO/LqZ+/dKbc8HK3/2nUze08Zm4LYfLF9F60onnUI8X8mbhARaFI9/p7WYfhGub4Zs3r2n6qW5ap/EF6Lc9+j0fj9ApVSdcSp3TartUbEhnNa9s4np7mMBCQ2dBbCmeK4P+0UgO3UhO6+7Dt5kFBXZEFEdlA/1jG8eGHkzrun8Y1xxNwTaMvolw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2wGRnyYTNIUco1dbMHfZRLgp7WhR+8JJzlNMiUtgks=;
 b=jse889ON69llTe+0Sa9kF7UqZk3Aq1kV0QDZzWhg4b00pBBEJt7/14qbHuE34i6lu5xGgRKpUYmfdKrBQJY5zgRUgX8VPNQdH7USua9GyDB2Nae/O3tYTNoscuw6L5uysPpp597ANtCN9OocvMePZjBSs4iKVhuqMXEmVGh+PCk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB8200.namprd12.prod.outlook.com (2603:10b6:8:f5::16) by
 SJ0PR12MB8092.namprd12.prod.outlook.com (2603:10b6:a03:4ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 10 Oct
 2024 05:31:26 +0000
Received: from DS0PR12MB8200.namprd12.prod.outlook.com
 ([fe80::e3c2:e833:6995:bd28]) by DS0PR12MB8200.namprd12.prod.outlook.com
 ([fe80::e3c2:e833:6995:bd28%7]) with mapi id 15.20.8048.017; Thu, 10 Oct 2024
 05:31:26 +0000
Message-ID: <cf2aabe2-7339-740a-6145-17e458302979@amd.com>
Date: Thu, 10 Oct 2024 07:31:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/6] KVM: Explicitly verify target vCPU is online in
 kvm_get_vcpu()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>,
 Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
References: <20241009150455.1057573-1-seanjc@google.com>
 <20241009150455.1057573-2-seanjc@google.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20241009150455.1057573-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To CH3PR12MB8186.namprd12.prod.outlook.com
 (2603:10b6:610:129::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB8200:EE_|SJ0PR12MB8092:EE_
X-MS-Office365-Filtering-Correlation-Id: a5504cd1-d3c3-4e5b-d737-08dce8ecc8ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWRuV1FLSFVMTkRUUlg1N3kyaW1FdmVJNzdubnFUdHAzQkVaV0NoTHZSSGd4?=
 =?utf-8?B?dG5iV1c4TWdZamRuazhYWG4zOXZSWWxBYkVEL2gzWm9XUmlQdnRvSHVpZDhR?=
 =?utf-8?B?eTBEZmR0azVpeUFGUFp5K1hTTmlndHRJYUtjL3ZVNUNjZGo0QWhQRHVKRXhW?=
 =?utf-8?B?ZFBzMEswVS9VNU50MGZGVnpYMktyQUl0dDE5dzNnMVBnLzRobHVYODE1OHJu?=
 =?utf-8?B?Z1NyZG94d2hiSis5QkVSalM5eUR5M0dNME9aODRKdmV6ZExyS3BUc0xrL0pv?=
 =?utf-8?B?ZzFPK1lBRlRPKzQvc1FiTGU1NGYwNHA0UXUyTGswMEJPYVU3TXNNWUVWeWpk?=
 =?utf-8?B?NmhZOVNoelVrWTJVOVptTmNXdTNwVk5uZ2tRbEp2UW1JZzFLeEF3bVdJUHFq?=
 =?utf-8?B?czZiZzlZbUNUNmJ3OVRSMTVnT29uOWNIK2UzUE9GZFN5dS9vVXlpcW5Mb0c1?=
 =?utf-8?B?bTdMNURBclNpVUxrZlBxUHM1OTdTV1lmVVp5UGZwWXFJMHBZRGt2OUVHOVAv?=
 =?utf-8?B?U0VIUHdwWGFpRmowVUdHbHF4NHJWdE1ubVB2T2RNK281M2U5TnMyQURST1J0?=
 =?utf-8?B?WGw5Y05YQW9NenZFSnI4cVViN2pYcEp5cFNYd0xneXk4MnV4SWFpUW4reGRH?=
 =?utf-8?B?WG5pQ3VEMHMraENNV05ZWjBTVEhyTlZPTkticFkybWVZYkNuSzRJTjFzWjNz?=
 =?utf-8?B?M0NNVnZ3azB0UzEyK1VFK1JTbHVMYnZ3ZGdQdVBxdDBiQ2RtVXByVWtDVFRp?=
 =?utf-8?B?ZW1mTXprNEJ5RGVDVkQwdFBQeTU3K0dXTHlxVmJPVXlBWTFBUjRnc0FEaWkr?=
 =?utf-8?B?dGI4Q3hrdmtKNDJpcUtKS2p0dlB3VkYzclJFN0wxRjZPMkVXdnFVVFdCVnFT?=
 =?utf-8?B?ZFloS3FQaWhmcTFIS2l5UEQyMTc1WElMZnFrSTRWZmV0VXNJblBRSGxYT3BJ?=
 =?utf-8?B?RXR1Qjk2N3Jvalo5MjZRZk81a091SzRrVjNxQ1FONTNBYXBFRmVxS0liODlX?=
 =?utf-8?B?VzgwZy9EcCtSTjlKRTg2YW04bGZZUHFpTUs1dmdCQ2dwODF2S0RBVnE4Yk9U?=
 =?utf-8?B?c0htQ0dCUUQzWUZZOG5VUzBSd0pZWk56YSs2RGdFbkkzYWlFclFkZG1xekFo?=
 =?utf-8?B?by9NNEY4ZHNWUUF0WisyQkZOWUkxVHo5a2JsZ3RTcTlWSDUwVFFXYzFRNSsx?=
 =?utf-8?B?ODFiZU5UT2doTVNISlNsTzhBd2luV2N1MmViVFJXYnF4MDdTT1IrU1JFY21p?=
 =?utf-8?B?VjlwajdFL1dzS29kaHk3eG1wKzU3VWNjY1NHeGtrbVZkR01SQUZsUTNtM3Yw?=
 =?utf-8?B?REJsNHpUV0dRSi8wUzR3aGpWWUJJZ3V5ZDA1aS8zdVpLejdxR2pHV09INHdN?=
 =?utf-8?B?RStCZllERStzY2ZWeW9BSFduRkcvaFlOMHd4dkNMY2crZnkzR21lT3Nhazcz?=
 =?utf-8?B?WVhtZlp0bHZ1R0d1TFNENitsMVBFVXl6emtNakZJZUF3aWtvRmM0L1ZsWnRE?=
 =?utf-8?B?REhtRW0zcjVzbEJUaUkwUGtKSDgzeGpiM0dsWnFkTjZZVE0wdGhpUjJOYnVk?=
 =?utf-8?B?REFTWUFzeVRGMTh0VGdIWTFoS3laUEhyTHlJRWtNWTA5NUdXMWkzdkZwZ25B?=
 =?utf-8?B?TTZwZ0JoT0ZtWEVNRnp0Z0FMSWdlWDNCWFFtdHA0YWpiUGtkU2pFZVRUWGJP?=
 =?utf-8?B?L3RoYXZHNW9UVWxESG5qOE9oNWErYURhNFdGVWljWEw5ZTJ1UDdzL0F3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8200.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmVlVzlFS281d2FCVUgrTFpldHFYL0w0S29xL1AyajF2dTBuTVd3SkpQRnNT?=
 =?utf-8?B?UTh6ODhIU29ibUoxRzBneVl0RVZidUV1bzVnMm9rMm0yZm5UcmtBMWZoZ0Np?=
 =?utf-8?B?bHpuNHBHbWpDV0xKNFpZM3lMbHBCdktyeEE5VEFBc2w0QlpKdnp6MXNxYVU3?=
 =?utf-8?B?WGhXWUdGczNTMTlRcDk2VllwdCtoVGRCTkJINFRwMXVacXRBOGNIRlZiTUN6?=
 =?utf-8?B?eW44dDQrUXFLeVFoT1lQK0RRbmR2eUJRTHh1WVMxeVB1aFpZRE5PS0dSNWc4?=
 =?utf-8?B?S1h6ck5ybFRqc08yNkQzZFBTUmU1dkVlcXdrNUUrUlpBdWhQTngyZ2pKdXFS?=
 =?utf-8?B?NHMrZHJKSDJGcjlCRXpsa1JNUFJTWW9abjBLY2xJV0xZNnAyVkd1c2RLVkdq?=
 =?utf-8?B?cUdxOTE5M1ZJS2VsN3huNzdtVFpIdXg5d05PYSt2TWFHME5UWVo0TDduM0Yy?=
 =?utf-8?B?V3MvbERKT0I4cnhjRnpnb1JyMEtRRFpPamVTaUpBeWNIT1NBb0RtOWNhdXZL?=
 =?utf-8?B?OEExNUVVbDlmVWgydHFnWGdsK2o5eEEwWkxsYTEvczVwTWZkWUdFNkx4YmVI?=
 =?utf-8?B?Yk5qRWlvMmVUaytJc3JyKzVZODJURDV5eVlaYkREUzhPNXIzQnl0QTV1cENw?=
 =?utf-8?B?T2ZzY1Vzcm9HSTZXaCtteCtpQUJJbDBaNCtiT0N2eWtKZXRYWncyaUg3cEhL?=
 =?utf-8?B?YisycjhFelB4STU3WjYva1lOUkVHZ2w4Z203ZTZGWG9pTUdhOENjUitUeEpQ?=
 =?utf-8?B?VUVPa01KVXdWcDlFVWdpeDNwam5VaXBraXhKbUFhRm04UU1ZQkJlQVBtTjhy?=
 =?utf-8?B?QUlUZ3UxTndMSUxLUmQ0QUc4engwdDE2ZVo0RUloZlNab05BVzZYSEFYZCtZ?=
 =?utf-8?B?TjJKQWE5QktjUHFCNHFMdnAxbXNwYTN4RXZXOTNRQlg0bStnK2pTTTJwSG16?=
 =?utf-8?B?dW00MkdJa2ZZZk05SVB6ZDZVUmlsZ3liWlpSY3lLUVpZWmpNNlozb2xtWmZn?=
 =?utf-8?B?WkxWZ3pQbDFTSkE5b0ZQNTB5OWphb1h5cEpwY1hHeWl2YzBFd0k4Q0Y5Nnpx?=
 =?utf-8?B?b1pvL3F0dmptemcrbGxEN3JaOWRhUmIvaVBUK3BqLytMVkhSQi9nTENWU0tL?=
 =?utf-8?B?NGNGb1J3MUFkbzBUZ09SeVBBWTk2S0l2UEZlWVFYdDNPTDM1cDFML3B4Z0N5?=
 =?utf-8?B?Z0NFZDl5T29jVkNaczlleHBsRlc0blZFRGRrdG5udWJKMWVLbjZNMkx4dFc4?=
 =?utf-8?B?Qnlhc0hYYkszN2F5Z3pwdWlzK21Ya3cwdTZpbWo0QnhSK2hzaVFnNG41RE9O?=
 =?utf-8?B?UXhabWlvMzBUR2JNbFA2QVNCUzRKa1BDQUZPZjdHVldOeFo2QnY2TXJmb3pR?=
 =?utf-8?B?azRsWEtUZ1N6bzZaM3d3a2dPeWlqWFpQVFJyc2ppZzJZMjFaT1k0Tm1Tbmk5?=
 =?utf-8?B?VXV3cFZ2aG1tVFlGa1JPbG9nNDFNczc2NTBKRFh5SURBSnozc244QnN1ZEdp?=
 =?utf-8?B?bHd1TGVKNHpXSlp3S2pGZ3AzeklRbHlFb29UYXF2S0ZORG0yRmtnRkx6cGVF?=
 =?utf-8?B?MDVWVXpiMjAxOERqT3FXamZadDJ6dGp4MGFmcFQ4NXBWcWRrankrNmsxWFEr?=
 =?utf-8?B?NzNaN0tlWGZLV1hLei9wbTdLU3ZnSE4yR0trWSsrQWJ3U0loU1JVZTFiRldW?=
 =?utf-8?B?LzVRS1hnMWJkWUVrQld4emNRQXQ1ZDBOUnFrWGczTUFQSWxUejJOYVI2VWNl?=
 =?utf-8?B?VElNRDRxd0VncDlKS3NrOTRibDlyQzJzZUh4MWQzRDRWNndhY2lQWU5rTDIy?=
 =?utf-8?B?UkFBNWowdW5XZE5kRHlDSk9lZ3RNOVBocEs3VGZLUkFNT2xqeGhEYUlvZGl5?=
 =?utf-8?B?WThmZlBucWd2S1l3SmhwR3VJK0RrYUhMd2tHcjlrOGFjTmgvOGNDYzFKYmVC?=
 =?utf-8?B?MUhBam9LblBpaEpSa3N1N3RyT2hWVzJzdXF3Nm5oREdiWHVuNmowZnFJOGNY?=
 =?utf-8?B?YWY3WHFoZzJJRGl5RlpvZ2NsTHlBakx2TWVYMDY4Q01NWTMwQTZ1R0xXakpR?=
 =?utf-8?B?eWo0em9OQ3FNWTU1amd5WmZRU2IzRmYvOWNReGxvanNYUzVZdlpJQ1JxSC9O?=
 =?utf-8?Q?r2s5h6PaRJjRZXQGc4JT6ENxe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5504cd1-d3c3-4e5b-d737-08dce8ecc8ef
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8186.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 05:31:26.6765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1mDpJjSLa4q3RNl59xYCY3Exm5/5irRsUx4nCmoiK3xg4AxZnN88YuN/u3h5lyBEf/6LcFnfMvMv2YWAD42dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8092

On 10/9/2024 5:04 PM, Sean Christopherson wrote:
> Explicitly verify the target vCPU is fully online _prior_ to clamping the
> index in kvm_get_vcpu().  If the index is "bad", the nospec clamping will
> generate '0', i.e. KVM will return vCPU0 instead of NULL.
> 
> In practice, the bug is unlikely to cause problems, as it will only come
> into play if userspace or the guest is buggy or misbehaving, e.g. KVM may
> send interrupts to vCPU0 instead of dropping them on the floor.
> 
> However, returning vCPU0 when it shouldn't exist per online_vcpus is
> problematic now that KVM uses an xarray for the vCPUs array, as KVM needs
> to insert into the xarray before publishing the vCPU to userspace (see
> commit c5b077549136 ("KVM: Convert the kvm->vcpus array to a xarray")),
> i.e. before vCPU creation is guaranteed to succeed.
> 
> As a result, incorrectly providing access to vCPU0 will trigger a
> use-after-free if vCPU0 is dereferenced and kvm_vm_ioctl_create_vcpu()
> bails out of vCPU creation due to an error and frees vCPU0.  Commit
> afb2acb2e3a3 ("KVM: Fix vcpu_array[0] races") papered over that issue, but
> in doing so introduced an unsolvable teardown conundrum.  Preventing
> accesses to vCPU0 before it's fully online will allow reverting commit
> afb2acb2e3a3, without re-introducing the vcpu_array[0] UAF race.

I think I have observed this (the cause, not the effect on teardown) 
accidentally when creating a vCPU for an overflowing vcpu_id.

> 
> Fixes: 1d487e9bf8ba ("KVM: fix spectrev1 gadgets")
> Cc: stable@vger.kernel.org
> Cc: Will Deacon <will@kernel.org>
> Cc: Michal Luczaj <mhal@rbox.co>
> Signed-off-by: Sean Christopherson <seanjc@google.com > ---
>   include/linux/kvm_host.h | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index db567d26f7b9..450dd0444a92 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -969,6 +969,15 @@ static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
>   static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>   {
>   	int num_vcpus = atomic_read(&kvm->online_vcpus);
> +
> +	/*
> +	 * Explicitly verify the target vCPU is online, as the anti-speculation
> +	 * logic only limits the CPU's ability to speculate, e.g. given a "bad"
> +	 * index, clamping the index to 0 would return vCPU0, not NULL.
> +	 */
> +	if (i >= num_vcpus)
> +		return NULL;

Would sev.c needs a NULL check for?

sev_migrate_from()
...
src_vcpu = kvm_get_vcpu(src_kvm, i);
src_svm = to_svm(src_vcpu);
...

Apart from the above comment, this looks good to me:

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>


> +
>   	i = array_index_nospec(i, num_vcpus);
>   
>   	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu.  */


