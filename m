Return-Path: <kvm+bounces-34412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C5A9FE755
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 15:54:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE7F8188226E
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2024 14:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1DBF1A8412;
	Mon, 30 Dec 2024 14:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lcgPwwIh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2049.outbound.protection.outlook.com [40.107.212.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236D07DA88;
	Mon, 30 Dec 2024 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735570486; cv=fail; b=R6SB4lbkIqJ1Tv0bOA8EAUkm5l5Wf5tcCU+yMMpudWA41JB+AChsbmO9tn/gBy3khGSYSsWQScDmL++Mq+6ohIDxLKqNMDW4GsoIJtAnLr2Sl63MyXQh2BosMg8KuAwV4bkewyMNdQRZgaQ4qGg5CFQLaToLBzx2pshStBjVVXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735570486; c=relaxed/simple;
	bh=NPnr8XDl9W00blLcvbenR2FoJUwwSbtKcJPW/MNS9TU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J/MO0oPcOrcmR5hCtiPBTpVXC5Pk7wUAdlyRjILUBUvBfjdvrL+3OXry22sEla7RlS/9IEQFdmmUnMzQNpOWrh7KlQF4zPj2FLipL9DvTa8CuRjwvg3wFGA2BSBz00p80D0T/ypxDqyk7MKyPF9t1vRAvmMRvaKQmfppWhKQp1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lcgPwwIh; arc=fail smtp.client-ip=40.107.212.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ILN6D4Q/aJxIsaiZe9E/vYxZZZQdrrtU0FB+sThRKCk3bB+vvhpU06XIDQqh5YNs1rI3Be8xp9wLl/Os3z3nLKBQ7JL5LOFo6TMOI0bXnbaTmdOqMtcTk70AKsStqTR9RKpWSxPEUTXt6UTEXTbXB1AIM5Z/3/CWkM2H7LfyrOp+rC5BxwavhOe4FX0OFTM3Y4UK0iHlEYuzoCHa21I6os/Gi7fqBR1ONMU2kUnYdpLv8Zo42Piiguy7qibNETDSb0QnbrzkayLEBhyJsfBiiXmkMb8+z2tNciPphJjHCtrbdKkuRfKWoowVNCJYiuSxbQ1b0dr/KBmLBGZAi/kKFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPnr8XDl9W00blLcvbenR2FoJUwwSbtKcJPW/MNS9TU=;
 b=i99cUZ3GIIp8jNGHZKGh4PTqmLWT690qDV8DrNNew4b7glgrRLOGu4n4i7ZnwCQQq1XU45NyKycv8G4MUQuKGS4F5f7exmC6HBD7YsoUwBSc/0Nk7GkujoQOZ//aJKmebsjxcZ+PStXkGvU6KU6JsM9kAt1wm5zkQPK13aM+1oWwCizmkVYllT7bmpTkyrtqSvyuvDSFxenGBcr4sQjg7XWUeADB2rrnSgqCBIkF3eXREot4REivuE+AkZxoFM+pb/6cJsc+6LULzR2R9RIrWTNbU4pcy4IDcrXbl0tlYVMTsBd5DEopKVTCvuQtjqDNxJNYrsjaU/klWBczLPyi4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPnr8XDl9W00blLcvbenR2FoJUwwSbtKcJPW/MNS9TU=;
 b=lcgPwwIhRwOWZ6lxho7yklMH07v5qyQ7bglNR7qWQgxidBAN19SPdAbmFA9C+26i1TcQpC/EqFkkshFrwm9nErYgIPl2tPUNUxYHxc8hAcXdRvPkldk/heA+Zd0lgMQWZt+bQ7fPOsSEhoTZWUwkkF0zEPFmDdrrO3XIYM3itrE=
Received: from PH8PR12MB6938.namprd12.prod.outlook.com (2603:10b6:510:1bd::8)
 by SA1PR12MB8144.namprd12.prod.outlook.com (2603:10b6:806:337::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Mon, 30 Dec
 2024 14:54:38 +0000
Received: from PH8PR12MB6938.namprd12.prod.outlook.com
 ([fe80::16e0:b570:3abe:e708]) by PH8PR12MB6938.namprd12.prod.outlook.com
 ([fe80::16e0:b570:3abe:e708%4]) with mapi id 15.20.8293.000; Mon, 30 Dec 2024
 14:54:37 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>, "x86@kernel.org"
	<x86@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"Kaplan, David" <David.Kaplan@amd.com>
Subject: Re: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Thread-Topic: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Thread-Index: AQHbPFEFmhn1AaOfa0iqMfWlRJj4srLYY1aAgAAWbACAAXNgAIAlL7eA
Date: Mon, 30 Dec 2024 14:54:37 +0000
Message-ID: <52473a9873b542f290cc1e07dae9acec00f061e3.camel@amd.com>
References: <cover.1732219175.git.jpoimboe@kernel.org>
	 <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>
	 <20241205233245.4xaicvusl5tfp2oi@jpoimboe>
	 <20241206005300.b4uzyhtaabrrhrlx@jpoimboe>
	 <20241206230212.whcnkib4icz4aabx@jpoimboe>
In-Reply-To: <20241206230212.whcnkib4icz4aabx@jpoimboe>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH8PR12MB6938:EE_|SA1PR12MB8144:EE_
x-ms-office365-filtering-correlation-id: 56d9fe1a-1902-40b3-5994-08dd28e1e1e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?U2djMGtOOWhUTmgrTVNwNzk0NkpqT2Mwb3o1WnhJaW9YQUZzTzZVSDJYTVhs?=
 =?utf-8?B?dW11cnJRZkhZS3BNdTk5L1FVbkZWcS8xT3BqaVZMMko3bWhibGJ1SGl4VlpR?=
 =?utf-8?B?WTdyN1V6ekhUM3lUNEV2SUtjM2pTK3ZyaWZhYkVjSzBvZTlrTCtqbXliSlEy?=
 =?utf-8?B?NnBHNlhleVlLOGJTcVNNTEllcFladWRqaldjakdKS2VJRUZlUUx6V2o4WmU0?=
 =?utf-8?B?RXBsNWtETm5IdTU0akpTaGNJY081NE9pajNrY2dPcUtEc3E1eVNCUVM0YkNq?=
 =?utf-8?B?WHR2QXcvbGxxM0hpQ3cxOUtLOU9EdlBYbWwxTUE1MnAxcGxLYVFwaURDZmpk?=
 =?utf-8?B?N2JObUMzQXYyR0hHNjFISWJPZmNEbVJZeUE3dSs1WSszemZrbHVwQ0YrWUNp?=
 =?utf-8?B?NDUyV3FpWUhuYSsyMDFkU1lJRFdXMXVOazJaMnhSdmpLVkFIem84NFpPQi9s?=
 =?utf-8?B?TG5xb28vaUlxc3plZnAwT1EvZ0hlL29idklCOGZzLzlaUnVtVTBFRlBxU05X?=
 =?utf-8?B?VzYrTVVZcHV3WS9Jb3Mxem9KZ0hIOFpPdGxZQmhFYW9CdzVKVWpWNmpUY2Nv?=
 =?utf-8?B?LzIyOHVqN3lKQVM2TFlTYnVyVGlyMldtVU5Yb3F5SGZJb2lrcW5pL2w5MGEw?=
 =?utf-8?B?OHdzSUwrakdjS0xiMG5FTDZLenVRNFIrdFI2NGwxcnQwSGgxZWVnc1h1OHNS?=
 =?utf-8?B?VmlvamdBdThHbkNSbE1Ua3BBTU03NWc5RnpwN1FYTlBRREFIeUcvMlJFYzJ4?=
 =?utf-8?B?ZVkxNFNDNlJydHFMMXR3b1lFYlBPeXlLeERXUjJPbjRsY2ZMWk5wbkZTcXFQ?=
 =?utf-8?B?K3NLTEVtVCtiNENMaDJ1RFZhbkNvY0ZWMmowbjZaT1NGY3MzTklSUWRaK2tN?=
 =?utf-8?B?MWF5b3BtUktDTnRlUWllM1dPOExxK1BHRTlJRU5EQmdGRXkyOGhSQjZTc1NQ?=
 =?utf-8?B?a1UyU2RxWUlwQTg4V2ZGc016REhKL00wVDhKL1V4QTAzZ3o3WFlMaHlYRTBD?=
 =?utf-8?B?M01SdWZnQm1QazRCVkNJQXZJbktPWGU4SXJyRWdCcHFuWittMjhreGFGTzFZ?=
 =?utf-8?B?QmFCKzU5RTFtWlRTVGFTYU9qeCt2SGlwMzNFSXdqVjBmNUkwT3Z5dFEvK1pJ?=
 =?utf-8?B?T1RqdEN3WE5ISEJCdURvcmNQU3FjUHpKcjVLR0xZanArUUlWazRtQmdqekFw?=
 =?utf-8?B?bnlzdXZFZ1Uzei9FWWhaRXlWRlJYSG9kTFR1WThUSlBJbThFbEgvN0l0aGpv?=
 =?utf-8?B?cEFobEh5TzR5c1g4VWNLZWhtc2U2NzNqaXhoWEd2VmVHeXVIN1RwNUdDOTNn?=
 =?utf-8?B?QmE3cFlHYTNSdHI3dTA2a1krZ1piRHVyQVB4NDkxZ0RDOEFLNE1tNEp2Vld6?=
 =?utf-8?B?WUhMTGk3MDRlVTVVTjlZZG9PMTJFd0lMVlNLWWpBN2JQaWpEeHpiZjlEd1JQ?=
 =?utf-8?B?bXVPUXBtMEZjTk9nZDRWVSswOUloUVdaT0hnazQzamJYVVFBM0tqdXlROVU1?=
 =?utf-8?B?bUU3TEw2ZTluZVV5dVRyRTBtOUxPTmVkNmljbHRiVllsYnh5TDhTd2FxZSta?=
 =?utf-8?B?SHJRMmg1cjkzWUtCTmxhMEtPUWJYRGVkRUFjTlQ1YUJxSlVxcUcvdVp6cklu?=
 =?utf-8?B?bGQ0Y3hxdnhmamFVNXkwRUxZNkVidjRPTGpQOU90a2hjQWJmcHlwMUNIdzgy?=
 =?utf-8?B?b0xhU0s0ME53K3orS2lIemNhc2JoTGVoWlFGTVN2RGRscjZWejY3V1RTcTVF?=
 =?utf-8?B?b3RVWVBTY1UrV1QzZFJ5dW9vMTVRWlNHTnpndk83bzYyUVc3Wm9HOWY4Njhr?=
 =?utf-8?B?dXRNNmZhNXVUV3lzbUdzZ2owbXluREFmR1BIcGU4MFZtUzFsKzgzK1pFbzlj?=
 =?utf-8?B?WitSeUZYNHdCKzZ4YmZUYUF0T2tOdGYwbGhtZGdxZTR3VHdMS1U4ejUxSE9j?=
 =?utf-8?Q?SNKkgaNuxCEGY5gC7tzEVw5aGtRp8kcs?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB6938.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eG9wQkNNUDRhK01MRFhwUHNHRGdzcE9lSWNHMEcxU29RVVN0a2lnbUgvRXh3?=
 =?utf-8?B?WEFZV3VyOXZBazYzcnNKbnRaOWIyb25jMVBVaHc4WUxxT2N5REpBa21zRUp5?=
 =?utf-8?B?RldOc2dSeWEvNC9pa1VTSjU2MytXTGgveDNCeWVzTjJVZi9uQUNJUkoxWVpQ?=
 =?utf-8?B?THU2NUFvQWdObjVWSmNleVRqV1RnZG5rS21Dam9sY2JoZ3pGUm1JTjhsbWlp?=
 =?utf-8?B?M1AxaWxlNHNUVjZMMFNuZGpWcFE4cXF1ajRJVDg2ZFFDUCswU21WNFIvSDdV?=
 =?utf-8?B?RHhqUUZJZDdsM2RoM1VuOGYvZUU5QnAvdXM1UmZ0OS9ac0lFOVUrRnV1TVM2?=
 =?utf-8?B?SDlzekV6SUNsWDBTbXlTOFVZU0JhQWpUdEFBUnhub3ZUYXpzQ0ZzYk1HMFIz?=
 =?utf-8?B?R2FDakhhREFEejVMd24yZGJZb3lIMEVDZUIzSW1KS0tUSU9ZeWxQVWpDcXJI?=
 =?utf-8?B?VWxnU0tLYlpSbDBtcVBWY1FQNUxuK0tiNnNGOS9jaXVTN1FCeUVlVUxta21S?=
 =?utf-8?B?dllQMW9iYk9KeG42TUJpYzg0QU05dUJCT2hPM3NPNVBlczA3S0FlVWRGK213?=
 =?utf-8?B?QnJnWnJ2dWFNL0xyQnJWMHl4NEF1a0g5WDZZT1ZIS245elVDNUp0OVhFbGxU?=
 =?utf-8?B?UytDMmNuTVM3bERKdDVrODZhK3NaalpMUVBCK05oQ0w5WVN0OFRpdFFqZzdC?=
 =?utf-8?B?WDhSZDE0OVZNRzBwUmw3Mm1USGhFd2d3c2oreHkrS2J4VHA3K3VLQnBMWE5P?=
 =?utf-8?B?ZmZMckZJYW1rM0NzaE9xNHhTdnNrYU9ZczNyWkdCMWd0WmlyM2FLdytVQnB4?=
 =?utf-8?B?V1hYdmRONHAwZjJjSkNDOW05S1EvaUNCR3BKWklyMEZwUVoyQlVvalc4aGs1?=
 =?utf-8?B?TC9jYW44RGhOZkx5Vzk0NW9DaXdTQy9HOWJDWkZ4S0VNeUZlc3JwN3NUa2VQ?=
 =?utf-8?B?bmRDSVAzaDdNVmJkUUhJc0oxZVlIZW8vQTZYSjlFd2JwdERnby9nSFhFM1U2?=
 =?utf-8?B?OGxkOHpLSE13VGl6a1FjR1llcW9UUDFBekFrdjBjdEFRdlIrempOUkc2Rkpv?=
 =?utf-8?B?aUVPYmJWWm5KTWdmdUYxME5pZXZHNjA5OWxVMnNWenlEcGxqdzU4aHpqRjU0?=
 =?utf-8?B?L2x4VzlDTHdtY2ZZNGJjN0VyaVJzaVg0UkhNbGlPK0RaRUYyTThxK2dyc2Fv?=
 =?utf-8?B?VkdLMUFwMHR3Tkg5bXFDSTBlZnRQcWVaWEZkZG5lWDZPM1B2aTc2RlZoQ2M1?=
 =?utf-8?B?elJUSCszbnpGeGJJdmpudUhpdE90RW1UQVlDc29NMmJ1UHptbXlzNGtkZXR1?=
 =?utf-8?B?dkk5TFVBVldMWC8wZmlqaFE3RkVXbkdrNzJhRzRVTGl2d0t0OUZWYkpUVVFB?=
 =?utf-8?B?TkRWOWtlZWhaM2JYL01zZjFGNmRtY0p4Rzc2TjhDQ2p5alFoOUU3Q0dzMEx1?=
 =?utf-8?B?eUFacmdwRDNrTVFMdUkwYS9QclJyRHJ1cGhyNEo4RG81b0hNTEtmM0dsQ1R6?=
 =?utf-8?B?VjZaYWRoMGx4b3dPNXF2Ti8xRFZOcExQbDF5RXgzSXcyaXlneTNhREJDM200?=
 =?utf-8?B?dGN5R1ZpV1E3L0VDbUluSGhnVmh5bDU3a1o4UGxyUS9pcVRFTXd1OTEwOFVt?=
 =?utf-8?B?N0d5MlZ2NFNXOTQxSm5hYzFUTUtkNzd2Z09SWUFtMHgvNmkyYkoyZnlnY2cy?=
 =?utf-8?B?WTVub1Q1bzdSSTNpV2w4OStISHQxS1oxdzhKUThjRm5oNmZVM0pCVFQwWEtw?=
 =?utf-8?B?V0ErU3J0TTJPK0JoNlRnbFpLcFpyNHFaQUg1OG1wY1VFLy9OUWtqWW1nM0ov?=
 =?utf-8?B?SUN0K3ZaeXBselE2bmFXVEhKaU9EbmIwZHBvR25RVkI3OWpTZVJZdkF1ZWJU?=
 =?utf-8?B?M050bUxQZDA2NW1EVFBYQSszNklBcVMyeFVobkROMmhBY09CWlB3L0ttaXp5?=
 =?utf-8?B?eEtUU3JEcEd3TmRucXJ5NURyNUVvQUNHWlFVWWZiRE5vS0JBT1B1RGtvTkdz?=
 =?utf-8?B?SHJyT2MrOU9DVEdjVWJ6YjNiQ3Q3MjBCMFRrMTBmK2FlZDdkRTJOVEczRjNi?=
 =?utf-8?B?YXdKUm1hSnA2VTNFaHZnL3JlRUs1b0NseWZndFp4cjFpRXBuWTJmem4rQjRv?=
 =?utf-8?Q?GWWFOdSE64ypWq+pL7t1TkGlT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D776801733275345B9BA4E2F63E01A2D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB6938.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d9fe1a-1902-40b3-5994-08dd28e1e1e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2024 14:54:37.8980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I8T6oShyXligbh0DUHlyoOoZO/LuDvpcY38XFvgvzbBWHkSaJ18q4L/0taVTMmayr5PeIZDSYk5xrD2MpsXUXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8144

T24gRnJpLCAyMDI0LTEyLTA2IGF0IDE1OjAyIC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gVGh1LCBEZWMgMDUsIDIwMjQgYXQgMDQ6NTM6MDNQTSAtMDgwMCwgSm9zaCBQb2ltYm9l
dWYgd3JvdGU6DQo+ID4gT24gVGh1LCBEZWMgMDUsIDIwMjQgYXQgMDM6MzI6NDdQTSAtMDgwMCwg
Sm9zaCBQb2ltYm9ldWYgd3JvdGU6DQo+ID4gPiBPbiBUaHUsIE5vdiAyMSwgMjAyNCBhdCAxMjow
NzoxOVBNIC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToNCj4gPiA+ID4gVXNlci0+dXNlciBT
cGVjdHJlIHYyIGF0dGFja3MgKGluY2x1ZGluZyBSU0IpIGFjcm9zcyBjb250ZXh0DQo+ID4gPiA+
IHN3aXRjaGVzDQo+ID4gPiA+IGFyZSBhbHJlYWR5IG1pdGlnYXRlZCBieSBJQlBCIGluIGNvbmRf
bWl0aWdhdGlvbigpLCBpZiBlbmFibGVkDQo+ID4gPiA+IGdsb2JhbGx5DQo+ID4gPiA+IG9yIGlm
IGVpdGhlciB0aGUgcHJldiBvciB0aGUgbmV4dCB0YXNrIGhhcyBvcHRlZCBpbiB0bw0KPiA+ID4g
PiBwcm90ZWN0aW9uLsKgIFJTQg0KPiA+ID4gPiBmaWxsaW5nIHdpdGhvdXQgSUJQQiBzZXJ2ZXMg
bm8gcHVycG9zZSBmb3IgcHJvdGVjdGluZyB1c2VyDQo+ID4gPiA+IHNwYWNlLCBhcw0KPiA+ID4g
PiBpbmRpcmVjdCBicmFuY2hlcyBhcmUgc3RpbGwgdnVsbmVyYWJsZS4NCj4gPiA+IA0KPiA+ID4g
UXVlc3Rpb24gZm9yIEludGVsL0FNRCBmb2xrczogd2hlcmUgaXMgaXQgZG9jdW1lbnRlZCB0aGF0
IElCUEINCj4gPiA+IGNsZWFycw0KPiA+ID4gdGhlIFJTQj/CoCBJIHRob3VnaHQgSSdkIHNlZW4g
dGhpcyBzb21ld2hlcmUgYnV0IEkgY2FuJ3Qgc2VlbSB0bw0KPiA+ID4gZmluZCBpdC4NCj4gPiAN
Cj4gPiBGb3IgSW50ZWwsIEkgZm91bmQgdGhpczoNCj4gPiANCj4gPiDCoA0KPiA+IGh0dHBzOi8v
d3d3LmludGVsLmNvbS9jb250ZW50L3d3dy91cy9lbi9kZXZlbG9wZXIvYXJ0aWNsZXMvdGVjaG5p
Y2FsL3NvZnR3YXJlLXNlY3VyaXR5LWd1aWRhbmNlL2Fkdmlzb3J5LWd1aWRhbmNlL3Bvc3QtYmFy
cmllci1yZXR1cm4tc3RhY2stYnVmZmVyLXByZWRpY3Rpb25zLmh0bWwNCj4gPiANCj4gPiDCoCAi
U29mdHdhcmUgdGhhdCBleGVjdXRlZCBiZWZvcmUgdGhlIElCUEIgY29tbWFuZCBjYW5ub3QgY29u
dHJvbA0KPiA+IHRoZQ0KPiA+IMKgIHByZWRpY3RlZCB0YXJnZXRzIG9mIGluZGlyZWN0IGJyYW5j
aGVzIGV4ZWN1dGVkIGFmdGVyIHRoZSBjb21tYW5kDQo+ID4gb24NCj4gPiDCoCB0aGUgc2FtZSBs
b2dpY2FsIHByb2Nlc3Nvci4gVGhlIHRlcm0gaW5kaXJlY3QgYnJhbmNoIGluIHRoaXMNCj4gPiBj
b250ZXh0DQo+ID4gwqAgaW5jbHVkZXMgbmVhciByZXR1cm4gaW5zdHJ1Y3Rpb25zLCBzbyB0aGVz
ZSBwcmVkaWN0ZWQgdGFyZ2V0cyBtYXkNCj4gPiBjb21lDQo+ID4gwqAgZnJvbSB0aGUgUlNCLg0K
PiA+IA0KPiA+IMKgIFRoaXMgYXJ0aWNsZSB1c2VzIHRoZSB0ZXJtIFJTQi1iYXJyaWVyIHRvIHJl
ZmVyIHRvIGVpdGhlciBhbiBJQlBCDQo+ID4gwqAgY29tbWFuZCBldmVudCwgb3IgKG9uIHByb2Nl
c3NvcnMgd2hpY2ggc3VwcG9ydCBlbmhhbmNlZCBJQlJTKQ0KPiA+IGVpdGhlciBhDQo+ID4gwqAg
Vk0gZXhpdCB3aXRoIElCUlMgc2V0IHRvIDEgb3Igc2V0dGluZyBJQlJTIHRvIDEgYWZ0ZXIgYSBW
TSBleGl0LiINCj4gPiANCj4gPiBJIGhhdmVuJ3Qgc2VlbiBhbnl0aGluZyB0aGF0IGV4cGxpY2l0
IGZvciBBTUQuDQo+IA0KPiBGb3VuZCBpdC7CoCBBcyBBbmRyZXcgbWVudGlvbmVkIGVhcmxpZXIs
IEFNRCBJQlBCIG9ubHkgY2xlYXJzIFJTQiBpZg0KPiB0aGUNCj4gSUJQQl9SRVQgQ1BVSUQgYml0
IGlzIHNldC7CoCBGcm9tIEFQTSB2b2wgMzoNCj4gDQo+IENQVUlEIEZuODAwMF8wMDA4X0VCWCBF
eHRlbmRlZCBGZWF0dXJlIElkZW50aWZpZXJzOg0KPiANCj4gMzAJSUJQQl9SRVQJVGhlIHByb2Nl
c3NvciBjbGVhcnMgdGhlIHJldHVybiBhZGRyZXNzDQo+IAkJCXByZWRpY3RvciB3aGVuIE1TUiBQ
UkVEX0NNRC5JQlBCIGlzIHdyaXR0ZW4NCj4gdG8gMS4NCj4gDQo+IFdlIGNoZWNrIHRoYXQgYWxy
ZWFkeSBmb3IgdGhlIElCUEIgZW50cnkgbWl0aWdhdGlvbiwgYnV0IG5vdyB3ZSdsbA0KPiBhbHNv
DQo+IG5lZWQgdG8gZG8gc28gZm9yIHRoZSBjb250ZXh0IHN3aXRjaCBJQlBCLg0KPiANCj4gUXVl
c3Rpb24gZm9yIEFNRCwgZG9lcyBTQlBCIGJlaGF2ZSB0aGUgc2FtZSB3YXksIGkuZS4gZG9lcyBp
dCBjbGVhcg0KPiBSU0INCj4gaWYgSUJQQl9SRVQ/DQoNCkknbSBub3Qgc3VyZSBhYm91dCB0aGlz
LiAgSSdsbCBhc2sgYXJvdW5kIGludGVybmFsbHkuDQoNCg0KCQlBbWl0DQo=

