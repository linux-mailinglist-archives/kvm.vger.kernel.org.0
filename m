Return-Path: <kvm+bounces-7789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F838466A0
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:50:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA2441C23BD7
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 03:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD39DF4C;
	Fri,  2 Feb 2024 03:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o5jHIWRJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B1DC8D2;
	Fri,  2 Feb 2024 03:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706845838; cv=fail; b=o5JQ9HiEP17aEM8CrhWYW3sZcW+2vxGK/leZAJLEWueeF5eKG/hCRs/T9ttiXYjjRsJXneg2z+wy6JpoZIpUqJXrpn7rarz0Zbm4s2DCFO6PiU1x7l81mAw2yAuDb7GoTfqfvvr7XFcHTjcZQmLS3YQxilfFFubV98V7/rHB/T8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706845838; c=relaxed/simple;
	bh=7sZmSc/Rri3edg3fUyF7K7TY+76ugzlcKHl5ze8jADc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xe5dzjo4y9UdyjBHQW/Qb7XCcs/x6RS3tLrRCSOZPQ2DRDwpIJq8ik5DWnJjU13T/oy5kyKSDgYPayzI/0DE8yG7WO8ODQ8Ru5C7d1eWZ9EsyuMiyE8ZYBJNH4mfrnpiugDIHorBYf169MzvvX8din9TBKAB13gX+GCYW5bMZhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o5jHIWRJ; arc=fail smtp.client-ip=40.107.244.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WleSPClVVNIGPlLbxfZ//xzpA0eNqUKBr4WGuXfbWlMnPYbA5lLdDyeOmwEBr4awnbmnLqsIBqxP6+v8kk7x7zePpyq259IyOAR3m3sKnbxSAJcKxbHZPWYAUUNvu9G2CnvJYnQOWlqEtgoHUaJoh3AAnkm9kk0CQG/NUiGuJOG3XwssGcM4Ab8wZW4SGcKoehnMCypBWNj728JFFmQYvi/lbIgtAZ6/wTxMYc/B21yONch+SRuO34iyDqtmDekTNaS88xUOH2GK9S/m7rj2ewGksiDmPI8bZDxUfzGYt3NnIaCZuew7ARO22qtiJ6RzCLJVwXkSZX+V2FHsJsTwTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0RbP8V5kOcyRf3OYPBB5nAp2zsysS2vWKysNiuihuA=;
 b=YIp2XxRMfJCmMkemz0zY0CnY//ifiKTnTKXj1PO3tHDT+zx1mqiPEpVGLyxzPcfKo6jlVVB47G1nc9vL6depVk0R1Yj6ELGNLbZ4F82tg+WkeZmMu5H9PZ+F7+i8zKYlRvYMYbpoQOXmyDs9yqLRN3eF66aqIbI1kTsc5QvP3fYXyuHPexkVdmi1qLYifbeg/cMOiwJsKcJlcMSyUvYsDqomUidvw5/+hR56u10BtotYiRyzxMTqxqZc4W2i5I382BR0U3IvTm//ikSlWrm80pFAzI4pWVpRGVa8ZMis88yxYByEqDJA9NHdR1vtn67XHiKlNSNrwmkXgto0xl6S+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0RbP8V5kOcyRf3OYPBB5nAp2zsysS2vWKysNiuihuA=;
 b=o5jHIWRJKa1Y+Gu2luk8pR/F8gRYAyvbBmaoi+zH9hZ5c4Bv561DaceEyxXiccaVrU2mMv2P3uoXzgNXlSdbBgbK0jocHscLCNcHI9G2J4+ztn+ywuZj++zm3cO4TWyoSUbyaIPYfSnHSC5ybv4td+W0stFV8x4UinyryuSCTpI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.8; Fri, 2 Feb
 2024 03:50:34 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7228.029; Fri, 2 Feb 2024
 03:50:34 +0000
Message-ID: <408e40b4-4428-4bef-bb96-8009194a9633@amd.com>
Date: Fri, 2 Feb 2024 09:20:22 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
 <03719b26-9b59-4e88-9e7e-60c6f2617565@amd.com>
 <20240201102946.GCZbtymsufm3j2KI85@fat_crate.local>
 <98b23de9-48e4-4599-9e7f-0736055893fc@amd.com>
 <20240201140727.GDZbuln8aOnCn1Hooz@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240201140727.GDZbuln8aOnCn1Hooz@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0006.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BY5PR12MB4130:EE_
X-MS-Office365-Filtering-Correlation-Id: 858f93f9-01bc-4fee-1e4d-08dc23a21bcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NLa++nvPLwFybpzGuPADCZPfXI2eirTUe03PhUDfgAopQbZgXQgZdicvW4UpFmxf8BKOcYUhDhWSrXQ2CG77e10QEr1Ft6kTKo/SlgoLFFqwfYEGdqX9FdMZOY2YpRkKzqPcLUPklevR+icFT553mMk/vkD+p2oB9dOmqcw3VZCBOTZHakhndQXoCGn5PxcUkFSZgHD0msqsT7deMYsGJr71NgtC7/Pf+Mbqb9BscNl0JihMUUBa3oplS3MTqZ60QPM8kZkTb+867mhIvr2MKsm+FpmxLGSArD82Z7rOdAsQXvFoC7FMypw7k+o50FAUef4BjTAq07osMe4Lu4qq++RC1SPUgM6LBJBQXlBqzAjMPlV8AVig2heSQWGClEuFcRHbwzqqeUb/p1kV6U24kU6Lc8ivqjbe0yMsG50UzP4c84kyhpFfEe1XRcfDnOgWSjLhJxKY/yCZqylyOLDbc8oCq+QgD61EsZqJDfnJzPqhR1Nxpw3BW9MtKZwvHwYZ1tC+hIZWMd+PIMw44hnb905+fDCnMMu9AYyGRBe4BmYjTenzyh3q1m4jVPtLnsXp9wk/8AggQHrYPyWoOtIQR+hLOWYskJdyN01M5oWEWfQWX7PqArh38bpiXPXRBHWKymS8Ne7cFIt0fKAMTKBr+w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(39850400004)(396003)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(6916009)(66946007)(7416002)(8936002)(4326008)(2906002)(5660300002)(31696002)(8676002)(3450700001)(4744005)(53546011)(316002)(66476007)(66556008)(38100700002)(36756003)(478600001)(6506007)(6666004)(6486002)(6512007)(83380400001)(966005)(26005)(31686004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHE4K1M4MUdFTlRYNzRlQXRSU1VxS3RBYkR4M3JkRHk5ZXBTWmlCT1F3L09U?=
 =?utf-8?B?RXFTS1FSRnp1T09SMWRIOGVIVWJNZlV4Y1ZVR3BJZ0dMcGtFaTQ3L3dTRFFS?=
 =?utf-8?B?SzRZL3VSWHdYZ00vMk1ES2w3V3NZZFU5OG9adUVjZ1ZHek5mdGl4SkdJSnlw?=
 =?utf-8?B?UncvR3lFeGVLLzc4d0NiVURMSW8xK0JkUG5jd1RVMWFWQWFJeDNwdWxlZ0pv?=
 =?utf-8?B?SDlpZkhwQnhCeUFTVnMwWnZlVE1ya1FwMEh2RE81VCtzNUFhN0JBWGtnZzRj?=
 =?utf-8?B?U0xDSzFjUkhSQ0RTQUQwajYxUi95Z3phWGpCbU8rNDA5dHNpU2llSUpYUGJ2?=
 =?utf-8?B?dUN5TGxHSHJPczNKSnFCa3VUWnBubU5RaXdYenpkV0NWR1ZaaHNYZmYzY2Ju?=
 =?utf-8?B?bUo4OEh3MWFyazFnOW1FTjJ5aFlTTmg3MnNQUlpvUW1USjdSMjNnV0Qzczgv?=
 =?utf-8?B?SVJNVmxVNHk1a2Y0QXlSc2NNYW9aR1lPVWg0R25NMzAycitJU3FyWTBqRHhy?=
 =?utf-8?B?NDRjenlRQkNldGJEWjgrWmJKdjZLdjZ0NnNFcGJ0NWlrK2ZKQnJHbmxkL1pk?=
 =?utf-8?B?SHZGbjdLQnpRVmM3WEtZVUJFK3BoUzc2SVVvWFhPU0NERGs3OHNCSFRWenJs?=
 =?utf-8?B?NUtqbUwxUGI4b0crUVNhQ0k1bFFBVFhNcWVJRU43dTJ6NloweEg0UTMrUUhm?=
 =?utf-8?B?Q2xQR0pQNEJFWVNpWDVHTFdYM25OaWhVdkpac1VhK0x6NlMyOE9OMm5Ralln?=
 =?utf-8?B?czgyeG8vWTlnTGF1bk9iRDN2cUpoSHFXWUJtaXg5UE42RFNLN2tsblBUcEdR?=
 =?utf-8?B?dk1wOEJrbXVDT0o3WXluN08wL2tnV0ZXRlc2NzdsYTh2Qld6T29vdkVSVzcz?=
 =?utf-8?B?NTE4RUJoa3BXdkVyMEVVNTJtbjRZUEtWSUpCc21WcGRkc1NEM2pvT3licXhn?=
 =?utf-8?B?aTZ3OStLYmtxSjlOQm1LTEh3Rlh1QmhSYmlISkdyUHZWZXlTWjhIOG53RE9J?=
 =?utf-8?B?SmNSZk9tV0FtblJPUnBkYTlwdHFuai9mMlNnZnZNRHB6TmZwUzRacE1ySlh6?=
 =?utf-8?B?K2J3di9ZVTRTNUJybjVabkc5amp5akd3cWdIQ1ZoM3hWU01NWVBlY2QrZ3VZ?=
 =?utf-8?B?R1VobVh0ZW1wTFpHV01xakxLRmhROWF6NlZic1c0dnZwemx1ZWcxUnFoTHYv?=
 =?utf-8?B?bThra1VWMGF0ZE5ibGZwZlRyTHlmSW8ydzJOQXZCL290TmtRcGc1OFY0WUtW?=
 =?utf-8?B?UXNsb2NVSjZzM0Z3QkllZ2l0NVF6TFVMMGxHSExSUndUei8remdtZS9aem1w?=
 =?utf-8?B?UGoyTVlMTW9nbVhpSkVuNUxqK0NVellPVlRPZjB1VzBPU2pSaFVzMEZYc3FU?=
 =?utf-8?B?NnYzQ0NndHM1VEFYM0IreHdkWm9QRm1DZ2M1bElvc0xDREJaVlI3aG91V1dL?=
 =?utf-8?B?R1AzL3F4MVcrRTVJUUI1YTNBaml2Y1dmaEhVbmx1QXkxTURxOVgxbWZlRFlp?=
 =?utf-8?B?Z2FKTVozaXdpM2hKWlpsV2VGRGx5c0pvVi90Szd0U1pDQXQ5cUM3dFJyMDV3?=
 =?utf-8?B?YkZJZzJVc3p4VmJtZUYwbmNUcWg1NXBadmd1VzI0UjlkSk5vck9vb1FoRVpP?=
 =?utf-8?B?bllhcGpPNG5YVzRXQmZ2K05JeklNSUMrWWRCZHFVR2t2OTJFbXFQQW0vcjQ0?=
 =?utf-8?B?L09HV3Q0akVSMkpUNTRRbGRNeFFSQ2h0Qkk1MWI2a0M4STFQVGxUSzA1bTNq?=
 =?utf-8?B?d2lNZHZ2Umd2OUtqTGFaUVJyZ0ZZZWdSZDk4Rkdtalc3ei8rSyt6VTNQU1No?=
 =?utf-8?B?b0RWeFQwVDRWcmRxUUJrR2RqaUIxZGVvKzhOMFpwckRDcW0xYkxvUnVMenZR?=
 =?utf-8?B?UGZ0a2lOUW03T1NMQ3FIWjBkUXlNTjZnMVlhYzFiSit6WjRyaWg0M01UQnB3?=
 =?utf-8?B?VHZYemVMajMybG9xVzl6Q2J0MWU3aXRNSlk3Q21OdU4vU2hVenJ0Q1IwTWQ2?=
 =?utf-8?B?NnI1dHdCSU1mSHdEUUlQdzJOZzBHNVV2VDdiNjdxVnNpdjVvZmVsU0FEV01k?=
 =?utf-8?B?a0ZHSitGNi9oMTEvU0xYUDZHUCtpWHNYeW9tMzR2ZWFiWVdmZ2hMc21jRmhC?=
 =?utf-8?Q?LaUdAtRX0WgjujyWiHy7s/pYz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 858f93f9-01bc-4fee-1e4d-08dc23a21bcb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2024 03:50:34.1524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bh0wINpUKRLwYvxwlzroMWlCQh9uNVjAjnrejQzRcJXmLUKKMrvuk1pKz2adNvVXe52U3f5lmAReRJX98pyn/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4130

On 2/1/2024 7:37 PM, Borislav Petkov wrote:
> On Thu, Feb 01, 2024 at 04:40:10PM +0530, Nikunj A. Dadhania wrote:
>> I will move it to arch/x86/coco/sev, do we need a separate "include" directory ?
> 
> I still don't understand why you need to move it at all?
> 

To support Secure TSC, SNP guest messages need to be used during the early boot.
Most of the guest messaging code is currently part of sev-guest driver
and header. I have opportunistically moved the header in this patch as I was adding 
guest request structure. Movement of rest of the functions implementation 
from sev-guest.c => kernel/sev.c is done in patch 7/16.

As per https://lore.kernel.org/all/Yg5nh1RknPRwIrb8@zn.tnic/, I can move the snp 
guest messaging code implementation to arch/x86/coco/sev/guest-msg.[ch]

Regards
Nikunj

