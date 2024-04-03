Return-Path: <kvm+bounces-13477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C24208974EF
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 18:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36FB91F271A1
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 16:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F1814E2ED;
	Wed,  3 Apr 2024 16:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cTLWYOuc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2102.outbound.protection.outlook.com [40.107.212.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660C014E2EC;
	Wed,  3 Apr 2024 16:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712160769; cv=fail; b=qLtpuwvNnsn2/yNiQz1RjslWkET8it1PtAsnom0w+MOymVSk2H1i2ubi6jaeVIzgJiC2rojQ3o/V5zfIGhcVt7qtsMnzIZLIrDiUEFRrsKCtVEWxeNUlSBdk+8O63EhtavX1wNhKhKSN6/Ycdbn+pO+QOMSAxEcTH/5Ix1R5B9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712160769; c=relaxed/simple;
	bh=LePUS8Yn1laMFi0izR0AvGQFcqVaYFB9l9sRwBGCz+o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uaiUJjq3497g838JbVSs83SYQTYVa8G0Tw77iL6ZgjLRBkX+zTikC8enKfrqcoCze9elCSmQOdT50AFl0Z3qJezVHAXT+DEoFdFqMKfry9C0p8L67dsGoBy2kkG1RB4Z2rXRJ9ER01FYz7haCFgmBBIQrEyrOaphmIl+2fmJedM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cTLWYOuc; arc=fail smtp.client-ip=40.107.212.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YP9xnmDAeH57tQsA8tCrJ1mE9kZxP9jL7P/LJBw/xTbaz6VtqLm4bLxad99D3REBps59j/TydyYkmhKxUBg//A0OJbgICx3icYLuZ/Zx5gqpNefmEklnENxX6WePIv1dvIgB6njX7D32ijSY7yT/FoTo3CFpUzCWfFCZPAs06zUZ/F439G+TLmcW/Gua+pRozKIoy9IbDoJTl2D09Yno4KH223EgshImFbDwbDiJi2cPlR3tK+YYdTi/Anj5kStKqMcGuMlGXg33xAlcs9BcguIBUG/NITkwAUuwWmLLrqHMCckD5tEreWllHkf+l28SzADIQ66iWgjua5U6OpQ5rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S052iUYj3RKxLpH4wlyODpwpvABnQAbYckq0pyk7Kt4=;
 b=L+cIDrfxgRshybUP1fq4uTi8TUTo4AhDBUz/4xIhEVLy4Qw/yhN28DGXq1/1xOhljQCYW3Vmt0pUCNQfP5Po2EJT59HrfzJij5EJ5dQNZV3+uwKW5LMnR+JdEyEh3RQ7S/ygw7uO37YyR6dDWASeJ9yDgcHq/OAJw1iz3YyZQccfKvVU0x9fUbIIdZTb69176ZiXihtFc6KWKTjzZYrIUFWQ9IHT97Cz2HCxdevekCBpi5PoJdohEsa68InG1jtabU9X1Qc/CIYMdBkLyu8cBV+AMxjZUkO+vhkLzfOJb13Pz4bZUlTNHs7VpLIIn/0uDU9J/m6fj0TDr1blH5bYQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S052iUYj3RKxLpH4wlyODpwpvABnQAbYckq0pyk7Kt4=;
 b=cTLWYOucxtMx6KsKn0+bgbObEjo7jxXrZxeUs9XeNVwsuay6ILSjELqltCr7F3jmtrPRmwaXkEyfM6nLA06vpO2+28x1jfsqNbQA3HDZHuMLA4gH+lKcc+C2Ugc8ZRIilgHGyesL/4i0GufTaBEIqOV9/YYia67qGu5o2fRrPUo=
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 MW6PR12MB7088.namprd12.prod.outlook.com (2603:10b6:303:238::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 3 Apr
 2024 16:12:44 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::2385:dab8:fddf:bcba]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::2385:dab8:fddf:bcba%6]) with mapi id 15.20.7409.042; Wed, 3 Apr 2024
 16:12:43 +0000
Message-ID: <f32d4746-0e8a-0c94-1266-9b73f76eb389@amd.com>
Date: Wed, 3 Apr 2024 18:12:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2024
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, David Stevens <stevensd@chromium.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Anup Patel <anup@brainfault.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Xiaoyao Li
 <xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 Jim Mattson <jmattson@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Maxim Levitsky <mlevitsk@redhat.com>, Anish Moorthy <amoorthy@google.com>,
 David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Edgecombe@google.com,
 Rick P <rick.p.edgecombe@intel.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
 <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerley Tng <ackerleytng@google.com>,
 Maciej Szmigiero <mail@maciej.szmigiero.name>,
 Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>,
 Wei Wang <wei.w.wang@intel.com>, Liam Merwick <liam.merwick@oracle.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Kirill Shutemov <kirill.shutemov@linux.intel.com>,
 Lai Jiangshan <jiangshan.ljs@antgroup.com>,
 Hou Wenlong <houwenlong.hwl@antgroup.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Jinrong Liang <ljr.kernel@gmail.com>, Like Xu <like.xu.linux@gmail.com>,
 Mingwei Zhang <mizhang@google.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>
References: <20240402190652.310373-1-seanjc@google.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20240402190652.310373-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0192.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::16) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|MW6PR12MB7088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uuqtaDnTomSirP4Rh0UCg9KfRIO7RRgjCR2LRXa+7tVHmrWr3AdaBaIk4wehd19PwrOqSZZkyj5cHwcbw5o+6CBpUaHIt4wqTVnFIanZQQpwq83TEDxhZRioCh5dtyRECq6hCNKb/Hde5an8BpjB8AD7RRYqH8QN7HN6fpzEtk09XjIimaUmVV4zAL4R0MORX6DoT2VAv4Qj5Ui59h2J3xHq0UF8iGIuNaKaUvyo1u38pYOmzbjutqdnuK7EwjfHTHOFWLguTKZt6JN/0eJ8pEbopSxqrcentNGGEG2UMWMf6YY18C0SQGRAWwMYO/Ut86mvvxhAq44IuUhAI2xR417wAxEtk0tMZPi37ZWrokHhljn0Wk1j3rnPMZppH2sw8A2jscH7qp93qVLPHPPrEszbkXVxrvZdhylY1J0qIehBg1NuwDHi2RFab2Fzu0z3MgEg4gLf+gmPYxpdzf3eFkEtMrMLesr2kHHk4eDegg/sHfrc5xiDgUvFt8mBlxOxPrA+2rzY3xNcylc8A0AvPJh3Cfetweup8LrYKzKHsfnQKiVbdseiWchqq4B1GEyhx9OUwm2gun5LcGDAQ7HqUCTTjl2+3m1/Fd+o1nQZOZPuqG/aMHg4eIU2knOfKQMb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGF3c0hUc3laTll3RDV2ejVSTUdjMFluYzNSdjVUdkV0ZWo5NU9TNGtRS2hr?=
 =?utf-8?B?N3pkZWxhM0M0Kzh2RzQxZ3hlci9ZbXYwQUt1Q0VZc1JkbG01bnZlUVFVeDZv?=
 =?utf-8?B?cUp0ZkRoZ3dIbW5pSjJwSmY3NFdFbVgxL1ZoZ0UxaEozS1BCMjJZS0gwZXcv?=
 =?utf-8?B?YjE1L1p5ejlEMVFsUW56VTNtQ3l3VGVUVDRJT3F4ZlhDdER5YldlZk5lVCtF?=
 =?utf-8?B?dHZhbWVJUzdDc0FrZG9kR2NJb0IzTlVxTlYxWTRHck01aUxkNW51WjBYOGlW?=
 =?utf-8?B?a2xheDFpS3V2d3dvTWRMRkp5WmdjaHZobTRWRHNNcnl0MUR0SDZMZjh2aDFU?=
 =?utf-8?B?WGliQlZpU2xyQmNPK25VNTBtTjViWVpnT2RheE1GbW1GWHpyWGk2RUR2MVVi?=
 =?utf-8?B?MVFPZ0FDSGRWc0ZOU2hmMmJyVXVZSnRLbU90bFU2Q1I2MXR0L0FMS1ozQVY1?=
 =?utf-8?B?ZXhPVHhwS2RzZlRka0NYVXlBRnF4ZCtWczlCbld1cVBXazZnUDNxSWNvSmgv?=
 =?utf-8?B?UmNac1BrZkk0T2dvVGRnQXpVSHRzTk1FMTNwUFpoYXpZcDc5NWViRTk5RWl6?=
 =?utf-8?B?VXU3YlNoN0J2UVlaZTJNWjdQWHJIK25kZFBsdW1tZG95V2Zvb2FBWW0yMnIy?=
 =?utf-8?B?dHdCdWszMkRKOU5rWWtSMlZhdkhRSk1Fb1ZRN3RBK1hZQ2pFcTBOMmZWSEVM?=
 =?utf-8?B?ZXRycWtQaStJblJvbE8yR2JZbzBZY3pQV3lTS2FpMUhGdlpYQ0xvRk5oR3Nj?=
 =?utf-8?B?djAvTjBSZXhaRnlYVlBVVDE0b3dPeG0rUllIVlByWW5oV2Rhb3BYZitWM3dJ?=
 =?utf-8?B?cUl3bVVGK091TWd1aHVrK2tVZlY0aUE2OEdnSHpDbDI1VytxZDlzWTFhb0ZJ?=
 =?utf-8?B?d3pZRFMxZ25tS1lTOFliN21rL3hSRm9xbm9YMjBUZ1FKa0N6OERoZ0x2UXd3?=
 =?utf-8?B?S1pzS2d1MmxLeFp0MmtCOXRiWFEwNTFoOGFuNjI1OENyYUpWRFU0c0svQm5x?=
 =?utf-8?B?Mk1BSk43bzU5K3NIbG5XY3BHUy9rSDlGTnh0dUxYVG1kbHBPUlJBaVE0czht?=
 =?utf-8?B?b0x6cEM1L1ZsV3RVZDRORUdyVERMTFMzeFRIdFJUeUtPdm1CWWswZjJNYjJN?=
 =?utf-8?B?WnYwbnF3Y2swNm5jQTVCL292TXZBaWNoVzd2WWFMeVlNSFlMWDEwUXJicFU3?=
 =?utf-8?B?dDhheVMvR1JEWEMrOTNxaFlzc3JXUU9SVkREVmJlRHZJd2RKTHFZNGhtWlRI?=
 =?utf-8?B?UCt1Ui82a2lQcXJBYUZub3NPM1QrRHJzY0htNVJhU21lQTU2OFZ6aERYOFRS?=
 =?utf-8?B?bXdBZEpCZWNOMm5Cak90YkhDRUdvTEZId0xNRHZPTi9hRjQrU1ZJNjkvbXpD?=
 =?utf-8?B?OXN0VVJrMGFzRnUwUTZiQkNFQ29PYzRmQTZ2UGFQL1J5c0d0Rnk5OURNTWJR?=
 =?utf-8?B?Qy90dzdleGNnSjdKVWxwejhBQmRtNTdSMkJvU0ppcnR4eEQvNGM5NHVuYWVw?=
 =?utf-8?B?WjIxSVdzZjAzdG1ZVW91UXUva1JuSnhtblhud0Q4bVFYaTYrMU5PKzBib09G?=
 =?utf-8?B?cGVpSDlwekh3SnNUdU1QbE50Z0JVc2xXRzdWV29ESEk4U3RBWFZVQVhyRW1q?=
 =?utf-8?B?dUZrU1FTVEQ4aUlyeVBIS25na3Fjby90Q09rSEtZV2xHajcrU1g4azZ4c2lv?=
 =?utf-8?B?RzF2Kyt5SDRNOC9aSDFDN2hBQ0VZSXJOQ25ZT2F3cTlRbXVIL29uNWV4N2ZZ?=
 =?utf-8?B?eWlCRXZVUUhXRFF5YXV2TDFCdXFFWUZnS1FNWEdXTXFsa3psSDdXVE0rM09S?=
 =?utf-8?B?YVRreUZzbGJidXZUYUF6WjlrdXI4T09Idkc2czlDQmdaZnU4ejRNR29Bb290?=
 =?utf-8?B?cnZyQ2M1ejBYWXBTS1IvYzNnWGZwWHBud1RPc051M09QQ3dmcERiZXRHaml3?=
 =?utf-8?B?MVdmaG5GODVTQkp1cFlmVHFPT2tVUXhBY05tY1BTRXdwMi94VmVUNXlyOWpi?=
 =?utf-8?B?U1QyUWJTTVhzOHRaMFdiSHdmVHcvNGJvS3pjS2FTZHY2WEhERjB6Z0FDS1Q5?=
 =?utf-8?B?M0JxZGdCZmdSZWJjeHNTckc5aC84Zjh0V2xxM2dTampCVkMvWTBCQ2ZyUFd6?=
 =?utf-8?Q?ZHjA5HO8NZWPjCdH//fqkDuyG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39ce4ea8-6169-4adf-bc83-08dc53f8e491
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 16:12:43.6894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jeOjXiT5k4xEBPQoHSm1SiUlJhfmwdXEav8taNSBRVWIMA+GEsHB8q1xrqbveq7DGMSq8MaFX4Q147q6relGKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7088

Hi Sean,

> We are planning on submitting a CFP to host a second annual KVM Microconference
> at Linux Plumbers Conference 2024 (https://lpc.events/event/18).  To help make
> our submission as strong as possible, please respond if you will likely attend,
> and/or have a potential topic that you would like to include in the proposal.
> The tentative submission is below.
> 
> Note!  This is extremely time sensitive, as the deadline for submitting is
> April 4th (yeah, we completely missed the initial announcement).
> 
> Sorry for the super short notice. :-(
> 
> P.S. The Cc list is very ad hoc, please forward at will.
> 
> ===================
> KVM Microconference
> ===================
> 
> KVM (Kernel-based Virtual Machine) enables the use of hardware features to
> improve the efficiency, performance, and security of virtual machines (VMs)
> created and managed by userspace.  KVM was originally developed to accelerate
> VMs running a traditional kernel and operating system, in a world where the
> host kernel and userspace are part of the VM's trusted computing base (TCB).
> 
> KVM has long since expanded to cover a wide (and growing) array of use cases,
> e.g. sandboxing untrusted workloads, deprivileging third party code, reducing
> the TCB of security sensitive workloads, etc.  The expectations placed on KVM
> have also matured accordingly, e.g. functionality that once was "good enough"
> no longer meets the needs and demands of KVM users.
> 
> The KVM Microconference will focus on how to evolve KVM and adjacent subsystems
> in order to satisfy new and upcoming requirements.  Of particular interest is
> extending and enhancing guest_memfd, a guest-first memory API that was heavily
> discussed at the 2023 KVM Microconference, and merged in v6.8.
> 
> Potential Topics:
>     - Removing guest memory from the host kernel's direct map[1]
>     - Mapping guest_memfd into host userspace[2]
>     - Hugepage support for guest_memfd[3]
>     - Eliminating "struct page" for guest_memfd
>     - Passthrough/mediated PMU virtualization[4]
>     - Pagetable-based Virtual Machine (PVM)[5]
>     - Optimizing/hardening KVM usage of GUP[6][7]
>     - Defining KVM requirements for hardware vendors
>     - Utilizing "fault" injection to increase test coverage of edge cases

Want to discuss the 'guest_memfd support for mirror VM'.

For SEV SNP live migration support, migration helper would run as a 
mirror VM. The mirror VM would use the existing KVM API's to copy the 
KVM context and populate the NPT page tables at page fault time. For 
designing the guest_memfd API's for mirror VM, want to consider the post 
copy use case as well so that the copying of paged-in memory in mirror 
VM would have a separate memory view.

Would like to attend and discuss with the community suggestions on the 
mirror VM with guestmem_fd implementation ideas to cater the use-cases.


Thanks,
Pankaj


> 
> [1] https://lore.kernel.org/all/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
> [2] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com
> [3] https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com
> [4] https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com
> [5] https://lore.kernel.org/all/20240226143630.33643-1-jiangshanlai@gmail.com
> [6] https://lore.kernel.org/all/CABgObfZCay5-zaZd9mCYGMeS106L055CxsdOWWvRTUk2TPYycg@mail.gmail.com
> [7] https://lore.kernel.org/all/20240320005024.3216282-1-seanjc@google.com
> 


