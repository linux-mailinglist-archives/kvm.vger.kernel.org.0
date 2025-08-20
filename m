Return-Path: <kvm+bounces-55109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97200B2D7F0
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 746883B141C
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49BFA2E11A8;
	Wed, 20 Aug 2025 09:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ulY2PjjA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2065.outbound.protection.outlook.com [40.107.95.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDE6296BA8;
	Wed, 20 Aug 2025 09:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755681159; cv=fail; b=eqtjT9/xBGkD5Sz1Y797WJu0dDgOGiMbiaXBJ91eTTH2jzbkpXBzuqeL8HBzSl6/SdLfMwTJgl3BLOOaMGWK4YnZansMEKHNlJiMdMf1vRlj+VTDiFDci5N2yERYLaCpHjaMMuO50ozurZgwLzFYMPbNtgN8SslTD965k+ys6bw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755681159; c=relaxed/simple;
	bh=ChkWpLVyKbHU8z7CiK0o11b2l6Rmb3ShIi9sQ8E861Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ckBv35St3bINCQ+Tdh/cTe5TEIKA1JHa1UKN7aHDBvNIxNp78BXEdNul/RGmf+A3vEClgkVNdakbWyNLa1JNCdMI1Chp62HgMduni1BVibmBvcG3ZkmiEfCQZHsnhpe1D8NFe2l92AkW6un1EvZGa/qwwBu5boOJONuqrqbs2Fo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ulY2PjjA; arc=fail smtp.client-ip=40.107.95.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n8UMvNGty1/zhvWViz9hnF9rqSKTycA4hj5Sis3d3hGtdWbwxfl27jO/SBZUuIZ1fkQbo2+IvL6ZfhdlyCglrkT5KnXkDhODaSpQL0mSgnqLn6I5Ht+rTvffgjEj4gMQYzvowzch0irXw9b3hvqzCbDd5cF/DMqsmYkBJuMv9UiJDbEu46GFo0VyQ/p98RgnMVqDVj16GdwfrTZG090kXacS3UOEDiA3fCOeRmzmFdh0WoWu/kOV2mtL1C4YdLKzXMYkGUBmx9FzD8wDwn1FnvOeKvyHJxxBEZI/4ChllZk1Xhq127VK/1sTAeJ02dhngfTG9k+SiQmEcOj0qlH83g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/jYPPuBkNW1jbi3srxz/b1E+QvQ9lYaZ3J+yVI6WG4=;
 b=kwAq3uwy07HeW8EM5W1zcTdLul12CmWYc3WRWpBc1h1MSTinZTlhjqywf8xWib2xEPgT8/89acrLTI1JREsOrIFC/jQ8pewrtbd7sgqL7gS0QJTvCpoK+6RUF8KoyN5QuuczdQRIoTmE7vJ/zYeBmb6/WyKqlb9SXnfJWNkBGr3ojsZ8inc77DsRjZCMDkKHNSais/oPi+b49lGtjx3u7f3ZmkoLtxstRsgpeJmEmGCxJwAak5jqNvLHvu/dsMTupQx1cxHN0x/s8q7l6nMYlnRyL70E5ONCS7zJhOk9dQRv8JN7v+99tSPfNJmbJNY6e0tZ52Q5NPU2xI9Dcfk9+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/jYPPuBkNW1jbi3srxz/b1E+QvQ9lYaZ3J+yVI6WG4=;
 b=ulY2PjjAbDy1xvk/Hyu8jrOLLylzVRSI0I4RvuD5/stMx66zqy92WPC5icAJo0mwxMZfLvCIFswvtx3NCCffNvAQU7CaD6/EA4n0/kDA9qDJK4sFMQUgaPvtcw9AQjHyNEr7h7kqX6EZDLPVw89Kek+z9Eq0q6I2UWP65/peFiA=
Received: from BN9PR03CA0201.namprd03.prod.outlook.com (2603:10b6:408:f9::26)
 by LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 09:12:32 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:408:f9:cafe::21) by BN9PR03CA0201.outlook.office365.com
 (2603:10b6:408:f9::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 09:12:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 09:12:32 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 04:12:32 -0500
Received: from [10.136.47.145] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 04:12:27 -0500
Message-ID: <97aace4c-921f-4037-b8f2-c4112b4a26a9@amd.com>
Date: Wed, 20 Aug 2025 14:42:26 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] x86/cpu/topology: Work around the nuances of
 virtualization on AMD/Hygon
To: Borislav Petkov <bp@alien8.de>, Naveen N Rao <naveen@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Dave Hansen" <dave.hansen@linux.intel.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, <x86@kernel.org>,
	Sairaj Kodilkar <sarunkod@amd.com>, "H. Peter Anvin" <hpa@zytor.com>, "Peter
 Zijlstra (Intel)" <peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Mario Limonciello
	<mario.limonciello@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>
 <mcclyouhgeqzkhljovu7euzvowyqrtf5q4madh3f32yeb7ubnk@xdtbsvi2m7en>
 <20250820085935.GBaKWOd5Wk3plH0h1l@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20250820085935.GBaKWOd5Wk3plH0h1l@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: kprateek.nayak@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: a609cd54-27b9-4684-155a-08dddfc9b250
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnhLYnJ4c21ub2luUk1xV1dURTh2NE5DelpZMmJMcXBPTzhwRy9SdnhNbEV2?=
 =?utf-8?B?bWNvYkFPODJkejlob2I0TWM2QkdHbzN3NUV0NE1BT1p3QXZWL0dsVk5pZDVJ?=
 =?utf-8?B?V2JsWGFLeHdzK0NRZTBJREJJS2hPU0F2RC9IUSttRm5vVGFGY0dDbFZOWVJk?=
 =?utf-8?B?N2lrMHYvVnI2ZFJmaEg0MjZnUEZJRS95ZTYrVjZSRGFNRXBuMGNaUW9BMXFx?=
 =?utf-8?B?aWJYaTRJeThuNkl5OWgyTVd6S1FaZlVvZ2pnTFMyS3lwSm4xQ2ZBUWM3WUg3?=
 =?utf-8?B?L1V6RzY3QXRjSXlVV2haNXlVTC9pRWFhSTdMaW5FeWd0NmRON1ZzWnJ2eXJU?=
 =?utf-8?B?a2pWc0loLzVCb1UwdklKNDFwUWFEYXZZdHBKM0dOVUN6R2xvbEI2NGg4WXVL?=
 =?utf-8?B?MmRFVjlDenRaSjJYNkpXRlZtczUxTjZEVGhwanpZaXNTZFZjZU55VXlaUGRo?=
 =?utf-8?B?WUVnZWMyV0NRWGJrS0pYdGVIZkUybkJGSkREaW13THF3SE1BN0NGYzMxTE1J?=
 =?utf-8?B?UTJURi8rMFJPVlJrQlVzSmg2NEpncjNGYUplRTZXZm9SbGhkZENQMTlLN0tl?=
 =?utf-8?B?d20rOTBFdVVTQ0EraUI2WlhNbWswQkZWNjJzWHBBNEFwM0VTMVBQVWFXcjRz?=
 =?utf-8?B?WWZyendHUUlER2dyQjAwTy8wYkdaczFMNXh0RlZ2Mk5VNGkvNm9VMEtnbkZP?=
 =?utf-8?B?UjlhVm95V2IycThqKzlpdTlFWGlsTHAxbm1XcU9GSE5YZDZSd0ZhRXhwdEU4?=
 =?utf-8?B?Q2tRTG5BOXhtUnBVU1ZUVjBHVWFXUnkrVi9VV3hBaVJXNTF3K25qdHZJYk9G?=
 =?utf-8?B?MkxnSENPcVp2UDNhTkUzUTdHTWcvTFhWeHV0K29IelhmcXQ5ZHZZM1lrc3lT?=
 =?utf-8?B?Zm9yeHRJcGtFNzdpYkRGN09nNC9ZSkdyRWxYcHhnWGtOTG1rN0RVL1VqYnpq?=
 =?utf-8?B?N0VrckNUQjFvQ3Q2MFlTcVV0SkkyZTZvak1jbjFNSHpuckx0dkFhdE5SVERh?=
 =?utf-8?B?U1JnbUQ2dHRUbFYrRng5ek5PdDE0eE9HdnkydmJoNmp4ZEZJUjFBZXdkVGhl?=
 =?utf-8?B?UDhtNlIrRmV6YjMvamlOcmxwVnNTRkVLdW1OOVdMcUlIOU1BTlVCWDN3d0NS?=
 =?utf-8?B?ZTVTME5zRDdDU0gxNURSbG9JMWkwRE8vY2UvY2hPVlVHM0FwZXhyZkNldDh4?=
 =?utf-8?B?dDJHT2l1QlFxZXJhNzdWaXZvTlBNelpKblFtQTBWeW41N215LzNMN2J2L2k0?=
 =?utf-8?B?L2dseTA4cTh5dGhCU1hKUGdKcW9kMVIyaVJYOUI3RFk1b0Y3OGlwRHBVSGFk?=
 =?utf-8?B?NTkxQnVKK0ZJVkU5TnVNdmdLVFFCaXdleEx0TTdsb1g3UVp6c29HU1YzZHdE?=
 =?utf-8?B?WEYvamNNaHd2VEFiSkcyU3Vac2U1UDBiVXZCaTMyWmIwR2ZHcVpaTHJTU2dO?=
 =?utf-8?B?ekZLd0xXd0tRYmJTTE5zSHhoNE41VUVxYkxvMnY4SCtJTUdudjRXV2d6K1RB?=
 =?utf-8?B?M1V5bjZTU0dnbTBoZUM3d1o5dnBIQXB0NlJqckJOcWpsS2pGRklPaUQyUmNG?=
 =?utf-8?B?MERsSTFEWk15SmNINzdXaUlOSVptU0pMYTUxTUl6cnU4czhzeVhlWUVCMTJG?=
 =?utf-8?B?UGVKWmhnMitJc3BTb2pXV3VmSWlDTkNaWWxqaXhEbFFGY21CQUFjaEFQNmxw?=
 =?utf-8?B?WjBUbG55N1dQYk9VM1pNRVJTaml4VUdXaUdhOVplQUpqY2JRQTJlRWNUcFQv?=
 =?utf-8?B?UklzTXYyaGduNUZjcGpHOWVHbEE4dVNDWk15djZIK3hEOHduTzB5ejZCMWtI?=
 =?utf-8?B?YjRqODB5VUZtd3NmYUw5b2VwMFZ3YVpUam9aUGdTUlVqdG9ieTA2QWc2VGlm?=
 =?utf-8?B?bzJYMHBvb1RmZUdrSUJabFJEZUQvdno0Wm9lVDROVCtuSkdCUzVGUnd4a0tj?=
 =?utf-8?B?TVUzZmdiSUR5dm9GMVI3ajdDV3ZUcnlDZksxajBrNTV4S1AvMk9mTThTRU43?=
 =?utf-8?B?QnJ5TWNJaEVlMGR2aWRWZUQwcHN0dFpSTVVmUzZXYm9VM3FZYTRWK1ZKaFBK?=
 =?utf-8?Q?eUGnWr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 09:12:32.9053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a609cd54-27b9-4684-155a-08dddfc9b250
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782

Hello Boris,

On 8/20/2025 2:29 PM, Borislav Petkov wrote:
> On Wed, Aug 20, 2025 at 01:41:28PM +0530, Naveen N Rao wrote:
>> That suggests use of leaf 0xb for the initial x2APIC ID especially 
>> during early init.  I'm not sure why leaf 0x8000001e was preferred over 
>> leaf 0xb in commit c749ce393b8f ("x86/cpu: Use common topology code for 
>> AMD") though.
> 
> Well, I see parse_topology_amd() calling cpu_parse_topology_ext() if you have
> TOPOEXT - which all AMD hw does - which then does cpu_parse_topology_ext() and
> that one tries 0x80000026 and then falls back to 0xb and *only* *then* to
> 0x8000001e.
> 
> So, it looks like it DTRT to me...

But parse_8000_001e() then unconditionally overwrites the
"initial_apicid" with the value in 0x8000001E EAX despite it being
populated from cpu_parse_topology_ext().

The flow is as follows:

  parse_topology_amd()
    if (X86_FEATURE_TOPOEXT) /* True */
      has_topoext = cpu_parse_topology_ext(); /* Populates "initial_apicid", returns True */

    /* parse_8000_0008() is never called since has_topoext is true */
    
    parse_8000_001e()
      if (!X86_FEATURE_TOPOEXT) /* False */
        return;

      /* Proceeds here */
      cpuid_leaf(0x8000001e, &leaf);
      tscan->c->topo.initial_apicid = leaf.ext_apic_id; /*** Overwritten here ***/

-- 
Thanks and Regards,
Prateek


