Return-Path: <kvm+bounces-40430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D040FA57334
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7BE77A719B
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B7E257AFA;
	Fri,  7 Mar 2025 20:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uamLPD7o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B1921B1A7;
	Fri,  7 Mar 2025 20:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741381075; cv=fail; b=OjJbqBfNLDGTqfoZaY/oYTBhgE9SIeppURlWBx/C/SkctAotcj/p4HFharld+BTquFKPuW6rfs0eh8sQlKdCS7IGg9teul2DDSM4aCK4eiKkX3q7Zl5TvssL6gt52zyk7ylvmHUJdMeBAZTAYyS7HlGW1Fy/9fCYGxrXDNcNlEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741381075; c=relaxed/simple;
	bh=7ipMt/kOx8UCxNn3DBM6PG0yS+538PSLaZTAFkSonSk=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cDojA+MkXhtWYHlip3wHDV/heBhGN3dSoFXbtV+RBofJC6RvFEOKukIhk/bG9v2U1PYjAkAh/Ap/bi8WT9jyPd3JJHnpa0eM7S4DF10AZhc0VcDjM8Ldu28C7Cd0FWOpcBaDe12TjdwqKN04aoO5jBe0gp0zqbHcEEsilWYQRvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uamLPD7o; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B/V6n0PhcuR0PVPk5fgxBoj/1HNJo+Oc1XVptWjyp0ARQGxPnyQfAsjCp74W5NR9Ul6Q/aqmzZk5EuUoFEb75ZUoiKTW1MSgYE4sfVqqTZLcUi1RHmcps5EElLLD3d2qvvpAvp3iuInTYCA+lZExRICuFcUJCZesD67S587HQOUDM4NlYbI/s/OX/41bZ+kKDG/iJL90qA8mx+aHC9/IOCrLUjsFZOUaPJQNXAP6dbrbhivBJpon8tB5/qN5X56FphZCTtUkh23qvIaSmHtfCTklXqz0KNoW8qO9oueUlDPKl10iKLkMWE0vnDc5X1du8KToJEE1dvJeb4y16jtOfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRw7nY3wRwDWMECfOWxxIkXOYTuGpMPzoAaSqaLLBmc=;
 b=XF3dZD9Ysca/FQ6pYqKCgmikFE3hsbuZBnP0YADdO+snghfxc01bw4r9Z3m0fVcuJiPqoGZTwJRE4NBlIwMirNnfDJBr8hz1NDSd0STDIlOZejFMvbjvyUqvs/F/YnFGT+Yi7uKpXiHx9OiXWh/gfXQBZB0bfBGQgu4z/SLtXVVcyUW/ZrONutP90YiAkBnlCCd7Y0o2Ex0WwU5wOR6Svb1kuhbVzYcrPdV2bQv8eUz6Z1nP5BDOF/aUe2LPQx1Z7pimg5iKeN5GkjlfZPhYdIEvMYN2XlJ2VNIZoZ/GUFcrxr191ULTgGrB+hLDVEZb4PKe25K0sc68K/L0j65Aaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRw7nY3wRwDWMECfOWxxIkXOYTuGpMPzoAaSqaLLBmc=;
 b=uamLPD7osBPTlho71tDbkgxD8gimTSEU+Wfdgs17yA44EbeRbB4LR4ROcylBrz1WbGNQnbu1Ra6fsumzDXATahmSBMWhj4qYNmMYDDE/kawmXdzRIjqfxPxDGIIKJTT4t0oQLVP+tnviN5POnSNjJUCXgOc2KsUZBjGWYhfT/9Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV2PR12MB5992.namprd12.prod.outlook.com (2603:10b6:408:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Fri, 7 Mar
 2025 20:57:50 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 20:57:50 +0000
Message-ID: <fefc1f1f-fc06-a69b-3820-0180a1e597ce@amd.com>
Date: Fri, 7 Mar 2025 14:57:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 1/8] crypto: ccp: Abort doing SEV INIT if SNP INIT
 fails
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1741300901.git.ashish.kalra@amd.com>
 <9d8cae623934489b46dc5abdf65a3034800351d9.1741300901.git.ashish.kalra@amd.com>
 <2cfbc885-f699-d434-2207-7772d203f455@amd.com>
In-Reply-To: <2cfbc885-f699-d434-2207-7772d203f455@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0141.namprd11.prod.outlook.com
 (2603:10b6:806:131::26) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV2PR12MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d00bd19-10a7-45e8-e71c-08dd5dbab8df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?endOdEFiVHZ1UlhJQThMMDdMRCtPVHYyZFNBY0x6TVhDVVBhOGIrT3NQZzZp?=
 =?utf-8?B?cGdVbjRncS9QUFU1M1BlWUw0bmd2dDFqMTg4MUtEbkQyaHF5WEQ1MDNLbWpM?=
 =?utf-8?B?eFFqZGpHcUNISjREWnhGdlFWYkV1U0FEd1h2NTFDUDNzWFhqM3FjRGd3ODND?=
 =?utf-8?B?MGEzekRLb0ZXaERNZFViSXFQdFZTYXczZEgyaXVoRS9ra0xRRER5SmFFU21G?=
 =?utf-8?B?V3B4V28rc1RjN20yS2FNWFEvd0s4R2V5cXA4M3BTbDVKalZTYkd2SzBOdUM5?=
 =?utf-8?B?ajRZSkR5dlk1VFo3RHNFVTBXd0JaeXZ3Z1FuV1o1ZjUrVysxNmY4TWJ5c3BP?=
 =?utf-8?B?dVBoRHAxKzZIdW41YUcvYWNIN2FOcW1yRCtJKzVYazFMbXJCOCtoSTBFT2JV?=
 =?utf-8?B?L25ZOFdNS3cvcXlzVGpYNkhzaFY4ZTlXN0FWWHdlbnYzcm1LbG5qaFJRczM4?=
 =?utf-8?B?RnVWTGltdXZBcEpEQjkzVFNqbDU3MzFvVURWVHNpbC83MExwWk9LcjhzQlhr?=
 =?utf-8?B?eWRjbDB4aldOSktVamdid2I3WU1QSEw0K2VBd1BMTkVxbE8vQmNNZTlvcnJV?=
 =?utf-8?B?Q0tpcHorYktxQm9rTW9WTUVCTE9wMjNUcmlSSXU5d1VlRlZVUWxML3ZNRG0r?=
 =?utf-8?B?TDlyV1lreXlaYU5BYkxMa1hiTjR4YzdRL0RML2ZPL0R0QTk0SUhFWStUdFVO?=
 =?utf-8?B?cVhlSVRCeVM2Yks0eTZVZ0Q4Y3ZMODg3bFYyYkxvTmdQRkF5aFJXTVdEQ3gx?=
 =?utf-8?B?WVBIWTZYMlQ1SExrZjNkTVdBbVkwRmNpdUJlZ0lWSWx6YlU4dkp6c0Q1MlBq?=
 =?utf-8?B?ZXY3UFlRT0xRMGU0eWlSSzVsSGJCOUZ0Zm1KbytsQkhzM2xtM0ZSaTk0a3Yw?=
 =?utf-8?B?d0xOcHNmVEdXcnQ2R1hMMjNVM2R3NHNPYm83N3RERE15cXhRVFI1TGxmamVY?=
 =?utf-8?B?V3drZ1UwSmVjN21Vc0U0WXZWU1hDV2l6OFNWdVVoTGp2TGpvK3JkVlNHekp0?=
 =?utf-8?B?enlPRDFSWDRrbGVFUG51enBaRmNDdmpHa1ZPdERkZUM3U05MS01nMVdzRC9y?=
 =?utf-8?B?a293a1l2KzZaMWdYUXluUjF4OENGOG40TlJtNTFsOFFUVzhKNGZOSTV4Um43?=
 =?utf-8?B?SXVRUXhJSXAzNnZkNHk3NWU2V2dsOXFiVVFyaFRNWDdvTDlKbE9SMGEzS1pT?=
 =?utf-8?B?MkxLc3dXUjNkSE1pZVRJcmtEdks4SEVJQk9McGx1Ry8ydFZmSTNXcmhHcXpP?=
 =?utf-8?B?cytKOWlJQ1ZQdWRKdkt4YThkRzZXOVRmSlVBTldYNzYxSTBNQWpzNzZnRVlH?=
 =?utf-8?B?TnpPbm5nU3JYc0NPM2dNL1A3QS9heFFja0lyY3pwd1hGc0lUVlhiMGlWRHRN?=
 =?utf-8?B?ZFhKOXNmV2czUXdEV083L2xhL2xiR1diNm1OWjA0dFV6M3FLV29OVG1ra3Yz?=
 =?utf-8?B?TTd0cUp1ZDlqZzUxMGF1OWQyWGl5NVNvb1JlZzBKZ1RSS2tFZk5PdFFCbmNs?=
 =?utf-8?B?UzJqNEt2U3k1dlZKYUI4ZmdnTHFHU20rc04yTU5uZnM2eDV2bm5maUFZNUty?=
 =?utf-8?B?TmZLQVlmaTBjYlE2d0FGY1pkRFp2UDlZY1FLSHVwV0hTWFd6TFUzMmlCdWV0?=
 =?utf-8?B?MjY3YVp4MUVYOVFkZU1zN05xdm1abWlySHJvV1hxcXdFeWV0WjQvQ3pSMDJC?=
 =?utf-8?B?UkZMOEQxOHl3NHVNTDllWmUrN01WNGNLcTFyNkFTQWhodUxaNGxlVzZxSWQ3?=
 =?utf-8?B?ZDU0eFR2bjNuUFBiVEp2MFM2dDg1Vkw3T29TMGIrNDRza2s1ak4rUU1UTkZV?=
 =?utf-8?B?cWN4VFY1ZHNMTG15TU01WGNMYXU0bCtsNjFwQmxJUDhFdG9Yd2hYZURQR2pP?=
 =?utf-8?B?VGRnK0dxVnp3MHBZc3ArdGw3UkpBWTJ0Q0ltd1JEMmF5clJ3L1oyV1prWDgx?=
 =?utf-8?Q?P3lnv7U+CoE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THZvNE1rK0FET3hvclkxSGpTdjFaTGRQTHpjY2JacHZLenJFSFl3K2dyQWVV?=
 =?utf-8?B?N01iODVidTZ4QjdtUmFpY1o0NDU1M28wRWNPd3h2bWZFVm4waWFQNm5RQ1Vw?=
 =?utf-8?B?aWY4dm5wRm5iS01ld3FKUGswaWY2bEQ1bEl4U0tJRjBlOFN3bmtKaTBCaW1a?=
 =?utf-8?B?cFBFVnl0Rm1YbnY5QnAreXM4aTUrb3V0OUt0bElzdngrNDZaeHJGKzZYd2hs?=
 =?utf-8?B?TU5DVS9UT2luV2xXTFdVeWxTRnJWL1VZaVEwZlFiaURvRExBeFNWbnV5TGJ4?=
 =?utf-8?B?SGZuY05tWGZ2Q3lvYjg2Znp2VE85bmx6L3hXL0VjQlpIYkYvWnRhOFNhYXMv?=
 =?utf-8?B?UEU5QlBhS1lSTHp0WlpPTWhWdGpZREdyRXhQMjBTV05YUFgyQlAraDQxQytw?=
 =?utf-8?B?RmVSREc2OE1ENVdsWTJCL0JyUytNT2dMYTJORytia1EvbHZNUnlyaEsvcHpK?=
 =?utf-8?B?ZERIWlJRMUxTcW1WS0Q5QkhWVklnMjJxemNOc2lXa2tsNmVvNkY3SkRaZ3ZC?=
 =?utf-8?B?RTNvL0QzR3hDRUZySDM0bTcrQktKVmZYYXEzSGk1UjI0dm4xZFRjR2ljQTdI?=
 =?utf-8?B?Y1ZySUtTbUUvcS9HNlBBVlZHSlRwelRxMmwxb0RuOXJEUWNnWVdBbEE0LzBS?=
 =?utf-8?B?dmd2L01TREhLRkFvOUhzU1FwYytyYlBjS094RU9sL0lCa2NsRTN4SDNzclhn?=
 =?utf-8?B?ZjJMUGV5dGxVYVJBRjVhaEx5ZFFGUFFWSWZCb2ViUnlFZFZLQlFseUtaRmhs?=
 =?utf-8?B?WU83L05JK0paRmI4OEkvU0loandrcEFUK3pIU1llOVZ4RWt0dG9ncnpGWlVv?=
 =?utf-8?B?dWlYODhHaEdCV2gyQkNFV214a2pWZVRPWVJXaGpTempIWXlNSXlkelMwMGR3?=
 =?utf-8?B?ZHgxRHBWMmU2bXRuYmEwOC9WOWd6UUtmWXdab1BTMUMwQ2krdTlrRnZsSzBB?=
 =?utf-8?B?MXJ3QmY5Y1FYWlFDeE9ab252dWpQcStFNUt1WnpyY2U2cVBrQTFKUExyaWMw?=
 =?utf-8?B?QTdWYnpvUThLSUJ4aFhKeGdWNVQ4Uzd0SmliaFE2RVIzNmJpb3lkOHhkcXFk?=
 =?utf-8?B?Umcwck5PUUM4bVJxNjdUSWV3ZjdqUGk5WllEQUZsbmRPTTNLSCtQaXNEM3do?=
 =?utf-8?B?UUw1bzNjbHdZTkxsQzduN2RnUnZPK0JONEliYkJrT0tIYnQyWExqNGM3dnJl?=
 =?utf-8?B?ZGpLbWZSdmQrcW1mNG13b1VNNk5hQ28xajdDbjVkSEVWbyt1VVVvUTRHY0tL?=
 =?utf-8?B?anhmUi9DYUdjUXhXMUxyYW9VZUx2TkRsMkZ1Y3ZKY25FZkp3amJCVmpkUVV6?=
 =?utf-8?B?UlpNZEJmaUljdytyVjlZNHZpeE1xM2pDbTZFQXFTV3oyTzJWbEhXa2RGajBs?=
 =?utf-8?B?bjNlMXpjL1ZRb3JVN1pMa3NDQ1pPTlErZVR4SVh6QmR0YzAwT0IrenZOMFFv?=
 =?utf-8?B?dGkvd1AxRXN5MkpDdVVLUEZ6eGlET2xETUxyUnNtRUcwRytCNVVVRk4yNDhq?=
 =?utf-8?B?Tlo4bTdwZ0VtSGdGOUNNeG1PQmZ6bmt2ZjlFMTR2bTRMQVg1QzVGdTV0V1lE?=
 =?utf-8?B?dERVZWRYMVNJNXFhYkhpQjVFR2RtaERaVmRLTklVU1V4RFhuOHYyYU5iNTNm?=
 =?utf-8?B?RE5zV2ZLcjlKV2J3VGpVdUhnbzBmajk1Y2dXc21PV2lUYzhUZUdQbG1rUm16?=
 =?utf-8?B?cmVncUN0YTlJdjhNUXJac3o5SFJLVHBreDVYdy9lU3dHM21zWjlQYVp4OGw5?=
 =?utf-8?B?Y2ZlV29QZ0NwUDlEc0RBcCt0cHNKZERaRUpZL2JONGczbWdDKzY4NmRSbmRN?=
 =?utf-8?B?d2ZxeXlkbmN3MHJhSjVDSWVCOFhlRjZPY29wSDhhUjhWdmlwdS81MnZxTEdZ?=
 =?utf-8?B?Q3lQNzg5ZHEvN2QwNytHNnJIcG1QUGJWNTd5SE9nVGkrUHpiclVFbTB3Q25P?=
 =?utf-8?B?NVFGUUxMeDErbGo0Ui9aYi8xNEtPcncwbFpaTlRhQ2tlMzRPTW1FcXJqcGNV?=
 =?utf-8?B?cjVQb1FUa1lIYUlONkl0ZzVxb25JUjJwU1VtdHAycXRYTXpXQkk0emVpRUJS?=
 =?utf-8?B?VmljSG9Vb3NjNGFPVWxSREhmblh5RmliNjJJRC9GTGR6L1BoM2NFcG1yRkZp?=
 =?utf-8?Q?Snikc/i/NkhOrhFyrAzZbx497?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d00bd19-10a7-45e8-e71c-08dd5dbab8df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 20:57:50.4898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +meMqQayDHuYbooSEPwTURRZBLzp4/Eut/qZrwi+ojNA+7POUn2fKkzUgYTsFOvaJV3GCMq7xz8HoIqDiz0cNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5992

On 3/7/25 14:54, Tom Lendacky wrote:
> On 3/6/25 17:09, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> If SNP host support (SYSCFG.SNPEn) is set, then RMP table must be
> 
> s/RMP/the RMP/
> 
>> initialized up before calling SEV INIT.
> 
> s/up//
> 
>>
>> In other words, if SNP_INIT(_EX) is not issued or fails then
>> SEV INIT will fail once SNP host support (SYSCFG.SNPEn) is enabled.
> 
> s/once/if/
> 
>>
>> Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 2e87ca0e292a..a0e3de94704e 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
>>  	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>>  		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>>  			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
>> -		return 0;
>> +		return -EOPNOTSUPP;
>>  	}
>>  
>>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>> @@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>  	 */
>>  	rc = __sev_snp_init_locked(&args->error);
>>  	if (rc && rc != -ENODEV) {
> 
> Can we get ride of this extra -ENODEV check? It can only be returned
> because of the same check that is made earlier in this function so it
> doesn't really serve any purpose from what I can tell.
> 
> Just make this "if (rc) {"

My bad... -ENODEV is returned if cc_platform_has(CC_ATTR_HOST_SEV_SNP) is
false, never mind.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>> -		/*
>> -		 * Don't abort the probe if SNP INIT failed,
>> -		 * continue to initialize the legacy SEV firmware.
>> -		 */
>>  		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>>  			rc, args->error);
>> +		return rc;
>>  	}
>>  
>>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */

