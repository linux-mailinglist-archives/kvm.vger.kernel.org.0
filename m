Return-Path: <kvm+bounces-11668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92835879595
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 15:04:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD8D0283455
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 14:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55097AE52;
	Tue, 12 Mar 2024 14:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NG000tOB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2B7A72C;
	Tue, 12 Mar 2024 14:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710252264; cv=fail; b=dM334Gz4p5h1Pn9x2F91D+zKB2tUnfD3P4xt17gZhjatJzNCmZnqFgp6i8leIZXI2doR4TLdrvIOGh8oJOElOf7ggINJlszHnZwCiXsycJw5vtVBbqrnhq2GStd/jbG0yvVRkqGIcm0HfhNHFFFRTWdnNkxmrF6PmkrzctqBMUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710252264; c=relaxed/simple;
	bh=NiAnTGhryo6F7FSyuocMQdkHzLLLPs1ZhNPR56IlhGQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nj8BAEPwJe9U6kFZBI0ZyL1F6BAbVg7z/YGz37TirXPSrVSoULepFmAIzeaUvYb7S9FbKcd+5I0incUqEtKsfvU6KsdBuuEOexFBHs/NOEPY0rJebOKlL2rDG1ws/jJwb5ymj1RWuQCL3PtA2Js5wfQaqwehPJX7L0BvWn9oMvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NG000tOB; arc=fail smtp.client-ip=40.107.220.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOx2/ZLyXAX0Dwirj5g8pufoA7tLIAqUXQS85fru38tZXOOXZW6LPeUNOyricHPZoyg2TfhHMIKEWEtWUpmu6B0OU5Eqpn9HHxnVuNlw5ng9GWyspJ7TJ+3rLoNc3m9qTCTNJUA6CqCsMvaY+hYKa4kylOKqibr8cjhdeFngBxsp9Tr0pAbM1uG2hWVte+x+wDT9oGNS4KvqXSaevbLMg99HrXsGgr9WLhVw0aUES0Kr+7rsPgHySdQQ3uCP+T/Ozr8RPO7ehkEOboLzvfRibpBaIVHl+YsWqKSSFxD2EzEqCySe9T5M2urcWmq9neyLOo20fOpim0wz8+HChCiJzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sAs0n1hGkbtM8H5DeQISTi2KQvvBuOUn1wFmrucRiO4=;
 b=Vfj6XAzSRB2HUV6dHmhyj/tdnZnrN7EoMQJShOBs1enJLNOggouEr4fgVwB2RPJgkh34GpQdvV8/LWUYpeDqXGeS9vjAZX+36rYtJZLZkouAol4g22/GwHJWaU+mkQwAR/xvkNkS61i+bYXVlN+Fu80YQT3iEOSoB/DNrIss1R2qotbvQYd50VDFiEEYS7HM+0NX/2RcPHnDB9saUp1RFde2Q6zzvqOkdDWZchaFp06gsa+y5oTi/P58YeJUT4tUcK53h4gQmXmR0uwxxLKfC/JOJCBGp/ZtExHEQP+V9PYEsjJmSnhGPMWP9FcTYseTZIt9nc6/YnBSoECfdRoGGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAs0n1hGkbtM8H5DeQISTi2KQvvBuOUn1wFmrucRiO4=;
 b=NG000tOBRNKrTGh5Ge+DIOzUtxToRVx76/30ctKCtL90Br0OxKYegN+KD+aErHQR7rpoGa++jel7m1nwWLrrxXDrUtdzjPw29LlDihCptDKG27jREzDhKuEqvMqbUtR69hL69c3TQaBAdzgcOawkecQIeCHS3HGXKa5sz0zanv0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH0PR12MB7815.namprd12.prod.outlook.com (2603:10b6:510:28a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Tue, 12 Mar
 2024 14:04:17 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e%7]) with mapi id 15.20.7362.035; Tue, 12 Mar 2024
 14:04:17 +0000
Message-ID: <c8c88a28-30be-4034-9fe7-9c9de5247c53@amd.com>
Date: Tue, 12 Mar 2024 09:04:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/9] x86/sev: KEXEC/KDUMP support for SEV-ES guests
Content-Language: en-US
To: Vasant k <vsntk18@gmail.com>
Cc: x86@kernel.org, joro@8bytes.org, cfir@google.com,
 dan.j.williams@intel.com, dave.hansen@linux.intel.com,
 ebiederm@xmission.com, erdemaktas@google.com, hpa@zytor.com,
 jgross@suse.com, jslaby@suse.cz, keescook@chromium.org,
 kexec@lists.infradead.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, luto@kernel.org, martin.b.radev@gmail.com,
 mhiramat@kernel.org, mstunes@vmware.com, nivedita@alum.mit.edu,
 peterz@infradead.org, rientjes@google.com, seanjc@google.com,
 stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
 Vasant Karasulli <vkarasulli@suse.de>
References: <20240311161727.14916-1-vsntk18@gmail.com>
 <f1ff678d-88fd-4893-b01a-04e1a60670ce@amd.com>
 <CAF2zH5qZKEmECy=9vG4sLmdDt5k7nC=MwjKvJLyVfPyFzt+0hA@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <CAF2zH5qZKEmECy=9vG4sLmdDt5k7nC=MwjKvJLyVfPyFzt+0hA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::28) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH0PR12MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: 60bbe057-c449-4b8c-1edd-08dc429d4e3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EhaLjkM5lXCLkJXZFkpQL9RSnc0DIsicQ4aYPr98Xv0T4CO4dk4vtiMxuVtEVJB4YgVo6F2WSnv2chazH2jjaHUmAsbZWhycO22h8YdTb3xTlYRuBiQyscjZ541H7hKSTU+fLEuhsqCRbREv3g5LCyuvR83pGzc7bMMdwZht9AStivtVuDp9Eb0C0eDrawFtPmMyUHg+TDjjx1FeLjWOIN171Visne2W/j0O0Q393AoW4HLHu+4is8ikoWrIrEVkD0yZstdVskJKH81uRMElYzfZqK/AZ8TGtsvwTwcjMFjxarnvnnIXb+b/ZJpbHJlE9OtKlSuT5sg4X9auhOeK1T5tE6VuUbA+r9fezHd2R74WycyNZ7/SwmET/R80vUW9p7/RfvdoxVFZhHzVj8JGVtEq0KTVsYtDw2p4Jg8Ve6kquzUl3b4o6z3+7ry2bOccznFpxiDhSf48V0yBSej3Ub/6OGE0RaOHhJevF4iilXOEAE+TIlwzi5cIGS76pAiWjEMFG9B1ke8mTOdLsmBg3qjwLQuan56TCfkppUaEI1t+MV/X03+rTWYcLoM/lJ793VDLBitRNBJx1ns5GDcJU0JrMG2izv1F9f6QmYYSRFCe3NDiXnubh/+5jLlx47+0h2lt5K8K/XSQYwzahm3sQuGuxw1FnvjnFlnIHHUug6M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3lZVFlyeFNMa1kyVnIxWlpJdFZjNEV0Q0ZTRWVmbDMzWWxMWUJpbHU0a2lh?=
 =?utf-8?B?Tmlvb1BLWThDWCtQU0g2aU80VFNsV3pTOE9EM0IrQTA3bUVhMzB0NWN1QUxh?=
 =?utf-8?B?V2p0cHNGSmVSMFJibHhheDJHL1pUQ2pMTkZkbkRPT1hVMTRvdlNCWllJcUpI?=
 =?utf-8?B?dkZSU2ZxcjRQUHJHNU9KMnlOMndUL0hHQmNNeHN4Rk96MWVNODZsaURXS1FQ?=
 =?utf-8?B?bUZMeHRVblA4ZzJBNjY5YUNaNjNUQVVDYkJJL1ZPVW0vYlkzM2l3bVdmWkVB?=
 =?utf-8?B?bk5qUHY4Y2k4YVNpME5McGg0WCt6UWZxaDUvVThWTndmOGljUTNZMFZmMUZq?=
 =?utf-8?B?Z0w5Rm1OWjJvTVQ5YklBZVpoRzJjdFgyamMrMDJVK0EvL01pYy9Zc3ZraW01?=
 =?utf-8?B?SG1uK1JpUzdnTlJiY2ZHbTZmWVljNEs0a0NaczlxYlJqYWRka3dLRFQyWi9H?=
 =?utf-8?B?TEtXYU1XSkZOV3BGcEY3dTNPMCtyOFlpMGY0Wml0THJCV3pEMVp0RXNtWWE4?=
 =?utf-8?B?R3IxRU1IRWxmNWtHQW5aclJXQ0ZLRW9XUjc5VDFzSDl5SFNscmtmY1hTb1lS?=
 =?utf-8?B?WXN6eWdBVHdveWZaOW0rcmN3eHlPTVF2R0lmMzRZV0ltQlFzZ3F0V3g3UmY5?=
 =?utf-8?B?MEpKZkxvdlV6MTNBQVJqT09ieXBtV0FMTGU0bzZWUWF6WHZPRXFHSXBncXhO?=
 =?utf-8?B?QUhobTRXNU4yOTVlUHpTLzlRSThIb0wvTHd6UUtaMFdhNk1ER2dlVHFhT2NH?=
 =?utf-8?B?Z0YwVVBEVTRuMm5XOWJvanNWRkVobHBNdGtlWEh6UU5mU2drUnlZRTF4SlJy?=
 =?utf-8?B?aWRTb29id0NTV3ZXQUVIWU9UQ2QxNktqNmRPUnR6cEl4MEk2cUp5QXRGSm5J?=
 =?utf-8?B?enUxTkw4RXB5TmcvRTU0WW9OR0dxTGpwZTlXRHV6c2hGdmhRYm5JY0NJNTBE?=
 =?utf-8?B?djBzMTNrZnp0NHZnTjl5TTl6aDRCaUhzbGZwd1RFeUNINDl5eW5FSDRhQnA4?=
 =?utf-8?B?emRLNTI4d1UzZko0bnhYOFlndjBKbHJqYU1rRFk4Y3dlZFpsVGlFR1h4Q1o3?=
 =?utf-8?B?MUFBTXorR2h5MFovdUpmOUhsWm9ucytPYnBBeXNWcE9pUnhJb24rUW5uZ1Bu?=
 =?utf-8?B?NGlEYjRJUFIzMTlaSlZUSlR5SVlPNnFOODdkZVlsck82VEdaY3dSSE5sZlhk?=
 =?utf-8?B?eCtxNnJiUUFYcEpRaW84WDFPUmVKQ2tzUlA4eFgzZWJrdmk0VUhscWh6NUJK?=
 =?utf-8?B?RkxpeEZIZ2Q5RHIra1RxMjc3ejE3bWhsc21tVEJHclpJdVUrNFQ0RVhVUnRW?=
 =?utf-8?B?eXEvUTF3TTRZdWpyd3NodUplQ2MySzJRYWRMWjlqaWVYRHRleEZIVkIrS3FW?=
 =?utf-8?B?Zzc3TE0wYWhlYVZYVU9wWjQrSGIzaUlKRDBDVlQvaC90ZjFpdlFhbGJDbTd4?=
 =?utf-8?B?T3NKd2JobDExMldiOWJ1T1J4eWZVTlFqM2VzUmhNVVhsZnZkNVNWK0lJWnh2?=
 =?utf-8?B?dENpcEl5NFJPREtKMjlVdWI3bi9YSTQwR2tad1V0YWlCa3pSWUs2bjhSUWs3?=
 =?utf-8?B?emIwUnQzeTZwS1ZWZnZBci9IOU01eDNFQXUzZEV5OFNpdkRXM0Jrb2NhVzJB?=
 =?utf-8?B?cmt0SWkwUUR4a3JMMUd0dHgyYWlrQ0t3by8wN3NrSm5tRjg2N0l4bllGNmlH?=
 =?utf-8?B?dldhamx6cld3aS9YUVJCVzlMSi9wNzVYNFdHMG12OTJvNk1kOStZdzhHNUNC?=
 =?utf-8?B?U2xyeE1ha3M2alY3Y2ZHd1RSWFM5cXBTUlRKZ2llNTRGOThBN2E2RmtQSDFR?=
 =?utf-8?B?RFo4VUExWG5WL1BWOEFDQW5BczNBUUpCODB4eFpuaDZGMkpLd0Y4WGRkTTBQ?=
 =?utf-8?B?SW9rVFdhYVE5TGFXaitYVEhZY1BhWDIraWFvNCtTZDU2N1FGK2V0QW5oSGpU?=
 =?utf-8?B?Yk1YcUo3Y0FPMXM1UzJUSzZ0ekhlaEpiOEJUQ1I3dXJWdmlJdTRpSkJtWnVJ?=
 =?utf-8?B?N2t3NDlVYllFR0tsVHhjTFBwUFVSYStyWW1sRmRVbE9EMmtsaldpZjBUQ1Nz?=
 =?utf-8?B?R09mZVhoRDZobFZYRlliMHNQUUg0RDlYTyttaGdNa3g5cjQyNUF4SGw3RFdB?=
 =?utf-8?Q?PoUl+l8Kdz+ILVssWZdpXdmvn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60bbe057-c449-4b8c-1edd-08dc429d4e3d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 14:04:17.2431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbQl671zEPSOMWEEzOn+AJtHQW7RbeAxLFAKBTFV5sFRtN+jSWa59veCAuw5XsreDHkQxBkhvZ/fz7xCyMwKPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7815

On 3/11/24 15:32, Vasant k wrote:
> Hi Tom,
> 
>         Right,  it just escaped my mind that the SNP uses the secrets page
> to hand over APs to the next stage.  I will correct that in the next

Not quite... The MADT table lists the APs and the GHCB AP Create NAE event 
is used to start the APs.

Thanks,
Tom

> version.  Please let me know if you have any corrections or improvement
> suggestions on the rest of the patchset.
> 
> Thanks,
> Vasant
> 

