Return-Path: <kvm+bounces-32264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2FC69D4DC2
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 14:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39BDF1F220CE
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 13:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5B31D90C9;
	Thu, 21 Nov 2024 13:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rhBv4YFt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E311369B4;
	Thu, 21 Nov 2024 13:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732195703; cv=fail; b=F7gB/1/YtcFDyQJ9/hAJyAfeJwcvEKEDKigqzL+ujCXlft6EaWLtxYRmKWZXAP0mo5ZUHbQNFGAlqVVCHVhY+J7QrM1GiQGfJ79vaeu7EK+cxsT2mCvb9kdc+hq9PJaKa7EZO1ibznXzULQ2CcBUnELM871PM8XGHERMQtfxKV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732195703; c=relaxed/simple;
	bh=T4uKcQlFZKdmyhBCF442uqDF1S6RJ5mnYOO9NBNRXeA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jtQH1cX5iLf/83zll1Tcg80rMSmq1Uu2Hgv0PtVNSaxIxzWxKm+Ykdp7eXlk5dB4pxVEjOctbXnbus4oMMqL4HCrQWzuKhu8c9e9kbyS/PCrzCSBPtAIjXEviomaVXNwIbpq7mb301TpKJ10VvTK5eNSSGhc9PM3gCHwEt/w9JI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rhBv4YFt; arc=fail smtp.client-ip=40.107.244.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tYoopiDapOWN1T/xYfJqet4NOUwG9jS43H+j+tGRHJppvO5GuDDuqRtku1OQZAi9s28Ed/4f+67Iuasp2hWUEZDT36+KFP5aQbVaGIhr01/tomTjapF41JZG4tNZo2ZYLR42GeXIo1+m0tKACH4xbE6v4P2JWWJe8mt4u1AII7pOl6sbp56xRYoUDP6Qa7WBYayIkvjhWlMRx9rLolO8h89UXtfq3phShoWBW9KFZolUSsOIYxRI2gHnwEWYs3oO6UCSe6pC7eAd68e2KtxTACPFmTYKmEU3W4q/DgfN4Rb9LoL2YGgQoojNHabyQ/B6Qe8iQuVUNsk09oeHUF5S2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4uKcQlFZKdmyhBCF442uqDF1S6RJ5mnYOO9NBNRXeA=;
 b=uJcCD2CotOJKcTAWNuulmA2urS5yXbswpv1E3pWhNLu3geVIFUM1JTmSwoNDEFTDCtCHAqyxE6qB+TWCbTJcVDES6IQBNF3qiQ2vnnkcoAQYdh6GdJwizN1vxR22MAR8YxGV85903x0ZXZ/c/mP/kVrXDNH2hxvxPUg/wQiAmmJUWERsms/ytP4q/X4aVoXARTd9irtIFtpu8yqNSTyzYsVApsp9q20v8fTJbgkvEw7F4mPHbXcmFVzGjfYZfrhDE2YBRcgXx5fClfJAPEQaETWvQ34ft6fIWSm1yt5hh75h+hRoXNT4gy9InQu0XQd0d/OV/uEBOx0SNeeBvwZG2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4uKcQlFZKdmyhBCF442uqDF1S6RJ5mnYOO9NBNRXeA=;
 b=rhBv4YFtTCxlmfZooa7h1qhRAlG5n8o3zqp71Trdx9XPBXztkwa+fTQu15EXqrCs03iZ6ootQqomxftXgeDqDwuU6McHgQ8TscPzNb3pKEwUT9xyEKW2GNzr/DTgVeyzuyuoatW4adD2otGFNLY0XDTCg1dhiHS7D1f2n2TbWOI=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by PH7PR12MB5736.namprd12.prod.outlook.com (2603:10b6:510:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Thu, 21 Nov
 2024 13:28:19 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%5]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 13:28:19 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kai.huang@intel.com" <kai.huang@intel.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Phillips, Kim" <kim.phillips@amd.com>, "Das1,
 Sandipan" <Sandipan.Das@amd.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"amit@kernel.org" <amit@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"Kaplan, David" <David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86/bugs: Don't fill RSB on context switch with eIBRS
Thread-Topic: [PATCH 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Thread-Index: AQHbOx29CotvqvmvmkqNyViPxCRbzrK/92sAgABi0ACAAWH6AA==
Date: Thu, 21 Nov 2024 13:28:18 +0000
Message-ID: <a3242e93ab2b38fb3279af01472c14bcdf9766d8.camel@amd.com>
References: <cover.1732087270.git.jpoimboe@kernel.org>
	 <9792424a4fe23ccc1f7ebbef121bfdd31e696d5d.1732087270.git.jpoimboe@kernel.org>
	 <b2c639694a390208807999873c8b42a674d1ffa2.camel@amd.com>
	 <20241120162120.z6zteeespf4cir4s@jpoimboe>
In-Reply-To: <20241120162120.z6zteeespf4cir4s@jpoimboe>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|PH7PR12MB5736:EE_
x-ms-office365-filtering-correlation-id: 04addb9a-cd31-4ca8-f38b-08dd0a305ce2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VG4zUkhLRkxmaG40b2JvSnJQUE9RZjNxOUJmakxndUUxRWQ3Z3F4UGs0M0RW?=
 =?utf-8?B?R2V6VUVDald5QkwwMGsvdnpjVTdwNkNkYTVmdlVsZUQ4ZXVQNXlrTGlFamRH?=
 =?utf-8?B?c1Rob1JPOVRKSFR2Q2t5NmcyY1RLWVdGRFNMTjBIdU1PaGIyd2dtVTBlZFVO?=
 =?utf-8?B?cEgvd1NLcGNxbzBSUTlaSWorL09wZm9lOGlLdEJQK25YUWFHYzF3UkVPN1Ja?=
 =?utf-8?B?WE5uUmJYSjY3SXBRMzJsUGRpWW1PcnRMckVDVldvQU50ekVYdGYrY1Z2enB0?=
 =?utf-8?B?RkRha0dOMHZHeVdwZTk2bnBPak0rUmxNalpWV2ZvTDlYSWZEalgvNW5SaEJu?=
 =?utf-8?B?Wkk1b1o2TGxISS9ZSUhMZWFvY1MxdktzL2hLWmd3Szk4MGwxOW9tdG1uem1w?=
 =?utf-8?B?dCtSSFFMZWdMRURlcVByd3hyZ1UrMjlBS3hpaVRlVE9mRitXYkJ3MWsrR2lH?=
 =?utf-8?B?amQ2UzZLYWF6dDhzblB6VEJsV2FDZlk4ZlMxdUhvM1cxVUU5R3JSSDlPU3NK?=
 =?utf-8?B?bXdLaGJWdGJSWjd0VE92bGRTQW9SdTRyUUc5NW5FaHRhdW1FeUFCdlBXVEc2?=
 =?utf-8?B?d3A5dUszdEd1RllXVUZhWWwrZ3VJVEwzWm10STI3b2pSVmpXVkl3QU5YOThR?=
 =?utf-8?B?K0pUNVo5WUZSVmptdXplSkluWm93V2lhN1BwTXFKSFNGQlpOckRDd210S3Nx?=
 =?utf-8?B?RWdGRE9ENVhJY2hEMm5OUXdPYXMvc3hBejU3UkJRcGNOSGtONVJLcmVvalZH?=
 =?utf-8?B?cHhLdWdyQnkyZWphVDhkbTh1MkkvQTkrZm1tcFdTaXpoQXFXN3loQjZOeUxD?=
 =?utf-8?B?S1JyN1hsL0xtSDhLYWVMT0FmQmpSSnFuNVlhbUc4VW1CZEp2aTFQcWozeTlQ?=
 =?utf-8?B?SUJhdHpiS3lxajhHZktEc1JmZTdIMW1mZHJkbkVWR3pQK1NydW1QODhoR1E5?=
 =?utf-8?B?cDlWZFFSWE03TExPUkdNNUt2K1gzZ3lPN3A2aWdBWnRuSzV3YnQ2dDVWamF4?=
 =?utf-8?B?ejVpOTUzZFJZVmRwd0p5QkRlZ1BTMHdBTlRDUjhWMEtZSklCYzVZQkdRajVv?=
 =?utf-8?B?QmwvMktvUVdCU2dSaGhHZ2VqL1dCQlRjRVBvL2tkRjhxS005dUJjT25aRUV6?=
 =?utf-8?B?UVIzVTNoaXk3T3UrZ1FHREFVaXRWdmxRSUw2bmRDMG94aHRzcUdVZmt0SkFp?=
 =?utf-8?B?TVlYK240N0RLRnZiYnN6RS96SGRsSXRMYmFXZlR6Vk11ekx3VWp3R0ErSHR3?=
 =?utf-8?B?aUFBT2FXdmprZGovc3ZtcHFFOTFxS2lNbGVsMGNUSTdiRmZnK1VyRFN2VFJ1?=
 =?utf-8?B?enIxYWdTdnVqa2ZpTnpuT0lxTWJkTVVwLy9NZWhiYWpvWldEYno2S0d0aVV1?=
 =?utf-8?B?cWZLd1JkaURMSkZ6TlFQRzgzbWtHMU1jRWdQNVJZUU54TlViSEhJSFRwcy9Z?=
 =?utf-8?B?eVVLYjlucGxCOGVxem1JSXdBOWRyaDN0VW5nalNLUzY1T2ttMlEyWW14QzBv?=
 =?utf-8?B?dW1tOTAvSVVERHN3eEtBMlY5TkdsR2E4VmdaS2hoTkRpTldqMGN5NFNKYzhD?=
 =?utf-8?B?bHBMa2k1NVpOUFpSSXBtTmJoUm5jUHpaN1JEaWJkalZ5QTI4U05OUEZMT0xT?=
 =?utf-8?B?SGZ2amFXSHNzQ1NicS9qVzNHeERVM1RxRW0zWGZlUmZJb1BGK1ZBWGpibURk?=
 =?utf-8?B?ZkEyOFMya3NQWFYrV0djbFF6a1o1cDlkeHorMENiajkwKzBTOE1GTExuUVc0?=
 =?utf-8?B?cDRUM3FGOXJOVlc1Zm1UUCtxT3htZSt4R0RaKzlzSkx1aUZjZGJIL0hZb1Ba?=
 =?utf-8?Q?IuDvAu+tfYLzDF5CjP4OG+e8+CCrckHfDPsiU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OW9LREV6Njlna09RdFFpaHFlN0tzNEZUdWExNmdHUllsUUcyem9peGt6WGJJ?=
 =?utf-8?B?eS80QjZRODFucWp4cVg0dlZ4ZGxkbXlwNmhGOHZiQmlSUTVSMFYvNy9wVUoy?=
 =?utf-8?B?K3g1R3VTT0M4RmhlanQ5ZjZwRGdoKzlxaGwxRmNaMlFOTDUwb3dFd2tSUGNp?=
 =?utf-8?B?ZXh1Sk9WekZoeTZIUEFEVVRPa3FuMEpHMjUvVTJneURoZnRBem5mTGg4MmFF?=
 =?utf-8?B?V0FBRytHWm51bjdHTmhpd0V1WlhpOFVpL1U1S21YQVpCb2FrTUxhb0x6eWdG?=
 =?utf-8?B?dmZMc2o4VUZRNEprb0xPdzNRaGhReUZ1dzFwNVgwTzI3VTd4SnMzQTBnWHQ0?=
 =?utf-8?B?UThSYXBIbjZnUjlnSmh4Zy9DbFI5QXc4LzYrRGo5WHdSd05hcDFoZmFOSXJM?=
 =?utf-8?B?Q051VlNkYldhL1BkT0RIS1hoRldWcVFSaXJObWRCeDJvdlNjQjk2Uyt0YkxD?=
 =?utf-8?B?NWt0cGZyUndwTU5wYVRKSlVabGswd3FxWkNWUHNwRHpzWjNXUFVyUC9Nb3ho?=
 =?utf-8?B?TlhnS0M0R09pdVBjMjZmdzU5Q1NtT2Y1V0k1bGw5ZzhiakRhcFlkSzdsSGlQ?=
 =?utf-8?B?akNPcnZ2T25wT0dNOWFGYjNKYit4bkJGSVIyN3BhOWtaVjgxUWFSU3JNUGd0?=
 =?utf-8?B?SXcreEM0VVRmYiszSEMwWTR6bHdkSTIxTmpsV2RrdG1OQ2duUGRGNjB6U0Ex?=
 =?utf-8?B?bVdJeCtxOHA3RnpvSmpWUHh6NHBmdHNtZUFTSFZMSmI4U1JVRmgxN2ZuNE5W?=
 =?utf-8?B?b0RUL1lxTjJKNDFacWFRR3BFMGROcDlEakx6bi9nVktvdzJ2RFRXaS9GY2F6?=
 =?utf-8?B?eU5kb1lIL3REVEpBTi9Pby83T0hwUFB3MU9wYUxnSDBFeGtsY0JSSWdYY3ZG?=
 =?utf-8?B?cGszcUFacHBXNHRwOVhzc0VBM2gvTnNYSUxvOGEwWG52YlQweXlvQVBzSnpG?=
 =?utf-8?B?LzNXWnFJWWJjQm5ZYmNZbUdyQ3NyTm54V05FR3ZQcCtqS24zbjZHV3hFU000?=
 =?utf-8?B?L0lIZDVoYjBiTWRoejQ3d1dGZTNRZm1rc2RIMndCQkoxWmg2Q2Nia3BUZXYw?=
 =?utf-8?B?NC9IWmd3TkxpTzJ2WFhaSHlvSkt5RUt5UEcxWFhGZ1FTUmFkaTliQlpNSHVW?=
 =?utf-8?B?M2F5YldLbXhlMU5XUTEyNkJPczQyZ1dINVhlelJ3Nmo3cFBOOEtMZ2NMWTlQ?=
 =?utf-8?B?a1JrTmFvWlA1YVJsbnZDYmhwMWt0Rzh2b0l0ckIzTU45Z2lodHdKZkJpMm1F?=
 =?utf-8?B?U0lZbURPaEIwbGlsVXdUME9ZSXBMUmh2WXc3YzJ5NjZLMlRpZi9DV0lBR2tk?=
 =?utf-8?B?VC9vekFBeDZlQWxiZmVLWmROSGZQQTBNSmczYkVqZGVqbEpQSVVZZ1Y3Rno4?=
 =?utf-8?B?eVF4ZDBsUlV2UGZobXo4KzdCc2xPUllwck8rYjdoMThqNVQ3TW10emFxeTJp?=
 =?utf-8?B?aWNRUCtaU09LN1djV090ZkRacXRuOG8xOXBoSm9kMEVaUWdXZk1SbE5WZ0Fo?=
 =?utf-8?B?U05LZGRMM0FnU1RKWWJJZ2JCSFBsZi9UV0xzY3JicHAzSS80aW4xZ0pnVE82?=
 =?utf-8?B?Uy9tWEhwcE9tR0V3alVFNy9ZMWpTN1RySktFdXkzbVNjaXNCWk14K01VbkFI?=
 =?utf-8?B?ZVlpYVRaV2lXWXVnQ3FrVVdub0pyVUZBekVqMG1mOG5vRFMyZTdtMzg4SDlX?=
 =?utf-8?B?N3BFVmJzaG51Wk5DeWNnYnlOTWROUEJTdkFia2NkeDZvS2RZVUF3MTlBMXZz?=
 =?utf-8?B?U1BPbVBKS3ZQanYxeVhqc1dkb1IzVkRKUWNkQUxIaTl4NVNtSXpyTWhHWUx0?=
 =?utf-8?B?UWdHMERHaGc3SnMvT0JKMTBNWHQ0WnJCVTdKd0VJTFdpWjV4M3ZiV0ljaHox?=
 =?utf-8?B?WUQrRHZNV0gxYncwRmU0OWxWY1AxWkJJM2hMV2c1MHlBUVk1UFNCb21kclNx?=
 =?utf-8?B?bE0ycU9CbDZPeVdDUTRscEpMVWtrVE9qeG8rTmg2b24vakhxVFBHTDNUcW45?=
 =?utf-8?B?OHM0eFVCbGQrZEF0Nk5jbmFET3Zqd1RWSGd6YVB4ZVJ3NU9oWnV1ZlV3dno0?=
 =?utf-8?B?NlUzVE5vU3dmK1hCY2kzaUdraS95eXY4UzlnL3J0MlNJNUtRYWNvbFRxWHNY?=
 =?utf-8?Q?N/qAWNOGp5XqPeOIM27dju3Yi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4C98E6309BF364084BFE91F407B6001@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04addb9a-cd31-4ca8-f38b-08dd0a305ce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2024 13:28:18.9286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uv6tC6ZO0VExyNRSJmkxECYLM63b/J8fM/Fyu/3Vr3aTVbtehy/4cJJzNeI4nMk8hyA7F5xrRGnDggbsTTgYNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5736

T24gV2VkLCAyMDI0LTExLTIwIGF0IDA4OjIxIC0wODAwLCBqcG9pbWJvZUBrZXJuZWwub3JnIHdy
b3RlOg0KPiBPbiBXZWQsIE5vdiAyMCwgMjAyNCBhdCAxMDoyNzo0MkFNICswMDAwLCBTaGFoLCBB
bWl0IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyNC0xMS0xOSBhdCAyMzoyNyAtMDgwMCwgSm9zaCBQ
b2ltYm9ldWYgd3JvdGU6DQo+ID4gPiBVc2VyLT51c2VyIFNwZWN0cmUgdjIgYXR0YWNrcyAoaW5j
bHVkaW5nIFJTQikgYWNyb3NzIGNvbnRleHQNCj4gPiA+IHN3aXRjaGVzDQo+ID4gPiBhcmUgYWxy
ZWFkeSBtaXRpZ2F0ZWQgYnkgSUJQQiBpbiBjb25kX21pdGlnYXRpb24oKSwgaWYgZW5hYmxlZA0K
PiA+ID4gZ2xvYmFsbHkNCj4gPiA+IG9yIGlmIGF0IGxlYXN0IG9uZSBvZiB0aGUgdGFza3MgaGFz
IG9wdGVkIGluIHRvIHByb3RlY3Rpb24uwqAgUlNCDQo+ID4gPiBmaWxsaW5nDQo+ID4gPiB3aXRo
b3V0IElCUEIgc2VydmVzIG5vIHB1cnBvc2UgZm9yIHByb3RlY3RpbmcgdXNlciBzcGFjZSwgYXMN
Cj4gPiA+IGluZGlyZWN0DQo+ID4gPiBicmFuY2hlcyBhcmUgc3RpbGwgdnVsbmVyYWJsZS4NCj4g
PiA+IA0KPiA+ID4gVXNlci0+a2VybmVsIFJTQiBhdHRhY2tzIGFyZSBtaXRpZ2F0ZWQgYnkgZUlC
UlMuwqAgSW4gd2hpY2ggY2FzZQ0KPiA+ID4gdGhlDQo+ID4gPiBSU0INCj4gPiA+IGZpbGxpbmcg
b24gY29udGV4dCBzd2l0Y2ggaXNuJ3QgbmVlZGVkLsKgIEZpeCB0aGF0Lg0KPiA+ID4gDQo+ID4g
PiBXaGlsZSBhdCBpdCwgdXBkYXRlIGFuZCBjb2FsZXNjZSB0aGUgY29tbWVudHMgZGVzY3JpYmlu
ZyB0aGUNCj4gPiA+IHZhcmlvdXMNCj4gPiA+IFJTQg0KPiA+ID4gbWl0aWdhdGlvbnMuDQo+ID4g
DQo+ID4gTG9va3MgZ29vZCBmcm9tIGZpcnN0IGltcHJlc3Npb25zIC0gYnV0IHRoZXJlJ3Mgc29t
ZXRoaW5nIHRoYXQNCj4gPiBuZWVkcw0KPiA+IHNvbWUgZGVlcGVyIGFuYWx5c2lzOiBBTUQncyBB
dXRvbWF0aWMgSUJSUyBwaWdneWJhY2tzIG9uIGVJQlJTLCBhbmQNCj4gPiBoYXMNCj4gPiBzb21l
IHNwZWNpYWwgY2FzZXMuwqAgQWRkaW5nIEtpbSB0byBDQyB0byBjaGVjayBhbmQgY29uZmlybSBp
Zg0KPiA+IGV2ZXJ5dGhpbmcncyBzdGlsbCBhcyBleHBlY3RlZC4NCj4gDQo+IEZXSVcsIHNvICJU
ZWNobmljYWwgR3VpZGFuY2UgZm9yIE1pdGlnYXRpbmcgQnJhbmNoIFR5cGUgQ29uZnVzaW9uIg0K
PiBoYXMNCj4gdGhlIGZvbGxvd2luZzoNCj4gDQo+IMKgIEZpbmFsbHksIGJyYW5jaGVzIHRoYXQg
YXJlIHByZWRpY3RlZCBhcyDigJhyZXTigJkgaW5zdHJ1Y3Rpb25zIGdldA0KPiB0aGVpcg0KPiDC
oCBwcmVkaWN0ZWQgdGFyZ2V0cyBmcm9tIHRoZSBSZXR1cm4gQWRkcmVzcyBQcmVkaWN0b3IgKFJB
UCkuIEFNRA0KPiDCoCByZWNvbW1lbmRzIHNvZnR3YXJlIHVzZSBhIFJBUCBzdHVmZmluZyBzZXF1
ZW5jZSAobWl0aWdhdGlvbiBWMi0zIGluDQo+IMKgIFsyXSkgYW5kL29yIFN1cGVydmlzb3IgTW9k
ZSBFeGVjdXRpb24gUHJvdGVjdGlvbiAoU01FUCkgdG8gZW5zdXJlDQo+IHRoYXQNCj4gwqAgdGhl
IGFkZHJlc3NlcyBpbiB0aGUgUkFQIGFyZSBzYWZlIGZvciBzcGVjdWxhdGlvbi4gQ29sbGVjdGl2
ZWx5LCB3ZQ0KPiDCoCByZWZlciB0byB0aGVzZSBtaXRpZ2F0aW9ucyBhcyDigJxSQVAgUHJvdGVj
dGlvbuKAnS4NCj4gDQo+IFNvIGl0IHNvdW5kcyBsaWtlIHVzZXItPmtlcm5lbCBSQVAgcG9pc29u
aW5nIGlzIG1pdGlnYXRlZCBieSBTTUVQIG9uDQo+IEFNRC4NCg0KSXQgaW5kZWVkIGlzLiBJJ20g
anVzdCBhc2tpbmcgS2ltIHRvIGNvbmZpcm0gd2hldGhlciB0aGUgQXV0b0lCUlMNCndvcmtmbG93
IGNhbiBiZSB1cGRhdGVkIGJhc2VkIG9uIHRoaXMgcmV3b3JrIC0tIGVzcCB3aXRoIGRpc2FibGlu
ZyBpdA0KZm9yIFNFVi1TTlAgaG9zdHMuICBJIGp1c3Qgd2VudCB0aHJvdWdoIHRob3NlIHBhdGNo
ZXMsIGFuZCBpdCBkb2Vzbid0DQpsb29rIGxpa2UgYW55dGhpbmcgbmVlZHMgY2hhbmdpbmcuDQoN
CgkJQW1pdA0KDQoNCg0K

