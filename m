Return-Path: <kvm+bounces-13454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BC0896E32
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 13:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9824B2C219
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 11:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF43142E87;
	Wed,  3 Apr 2024 11:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="46vgHhBU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2138.outbound.protection.outlook.com [40.107.94.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E9E1420A2;
	Wed,  3 Apr 2024 11:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712143433; cv=fail; b=bZ7MYZZVAVIgkydRQukLDRHU0HiirWhRNiisw4chTpOo3O5PlJgm0QW5JjnpUoClDbi7bObS2PM5s5TbAu6I8jTLCNtJezb1WZYAeyuVf4C+9AuUQJyCbs5rCP7fIuz4v866vbCtD91z99ln69vd1msEZtjG/W11oQMwecD52f8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712143433; c=relaxed/simple;
	bh=hxD34zKLjIiVIRqwtZUlx1q3wpHBNl14lbS1hwx7Wkg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Cp2qOw9RNV42sFkjPRVlM67VCEyU6aCaAi/xrub8YXYQ8f0LpsC1B/O/dd+76azrysqc/WDlyrBmBKt2GD6k/IEZ6yU6BEtI/X0oY4VmhXs6rbkJ/SgnJXvxJjbA5rsccj/dOJuF+HZ0drUmpL2dNRA/9vST/lWa+Fy4mZ+mXOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=46vgHhBU; arc=fail smtp.client-ip=40.107.94.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeHGarDbVX+KN3sRI9MgWAt60ri4fh8hHoEQaYBGYvtnWpA/tTVfw7tr1sopv9r8aPfdujATy/L19lZDGey9c+Viz9NoCZs9GrOV+QnAF43WHMRI+V/JpsFDRcCjCSJUjGueQVC9BZ59dsudjamyGpN8JNhMVxFQlz5QnkZMsKxEkdeBgUumdRpOt/cpRZ6thtfIZQrdQ4P61TjSXtIhJ3K9bnC7pPzy36osxv/+PkIjWyOnqNUtBp4HyvNg5FgmTjT47rLVbvKvtXZRr4azAeaPsvf9LWEze5Hn9r6uGPQaP2mLO5MgEkVDg1zCcWeMjRMT65NCMZrmfPU0jtBS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fgvsnc5OusXfNA97HCFSb+TUbCOF68MQIQ9e9MkxceQ=;
 b=DJRczAZpn9FpUJAOb2QPI3x+CYSp02Bl0uZfK04xOSfJXJGe5UdXoifRVzhB77jNtEZFL6lgBi36AqO+evwKP3EwydU7J7O26DhQOOFIsem9LaJI32zzqw0W4yCs30knj4maLzMXDDFnfbFTxOX/uC7qsTmxP0SRWU271knbMgKCJWhlwNFw8TcfFMbkID8h/4sm0yPW0LTOML9ZEuRKwmugdxpjrRxUNYD8+MKzJkfAOyrpmZ3tCwbA9ssnDA0XQ/ABosf3DzWewij7eUReLiJfo2aQLYtGpE1X0eu5zXTY+YZTvh1jbrt1DiK+ljeoGjNCGBpgteWY5szbHxhUTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fgvsnc5OusXfNA97HCFSb+TUbCOF68MQIQ9e9MkxceQ=;
 b=46vgHhBUIJwOntDDlTgmEQiAyuj4h92QiH/dF0XaQSU3SxfjRK/H859DAe4UGNrHJCBK/zsDs5ZcW7n23N1QC+UaRyaXn/j9gn0BeVTJtsD0RNesQUBGaSYDB9yhruR0BCgrcvt83s6fhFORwq4QWi2hd28RsJhPHwK/kGfII4g=
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by IA1PR12MB9062.namprd12.prod.outlook.com (2603:10b6:208:3aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 3 Apr
 2024 11:23:49 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2716:d557:4236:8f0f]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2716:d557:4236:8f0f%6]) with mapi id 15.20.7409.042; Wed, 3 Apr 2024
 11:23:48 +0000
Message-ID: <8d1c178c-476e-4713-8efb-9d9f8b143af5@amd.com>
Date: Wed, 3 Apr 2024 16:53:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2024
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
 Rick P <rick.p.edgecombe@intel.com>, =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?=
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
 Manali Shukla <manali.shukla@amd.com>
References: <20240402190652.310373-1-seanjc@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20240402190652.310373-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::20) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|IA1PR12MB9062:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/Dcm8M+cQfwGeRBbQEI+FYHHmT/49YkywFZ1YCv/zjQo73HjNWSxt83pB8P5/sdxNGzvXsyOpjD2MxKDgDAHqd9FdsaSrOn1pMqgqrAVHv2QXqN5O629BnpEB9d1iGEpUt/gGl+ivRk3wbJ45BB/qHV9lCpWJhV4QOleNqV6TczLfGxTUzHfj3EzTe8uCZzk4O4JNcGoAIPNpbIn4oW1ddQO8Pr68QW478WvbLsxju3cu+8WzKewEA9nbOZJBX0L0wt+u3ZCHnf5LUQiT/S8Z5Lczh45sGyLBx/uWvTdt7+WUDLH7DvL7szdUgdYDaKPRvpdL9G0Vkf57JvmChXCnZCW2nHMyBGyTaMqS+xxW8DAVIzxy1mFAqgMuTQsTzHJ6e8KiaPuVzXk2W5ptm6TDXloD9SQUn/KmzWHplillY+QvQoXq8jeL9XilNIpg1bTe6Hlc/V+5amcUvtvNFAO4tsjkoUC3GoTvfYY6MBLP5ZTi8DV9fiRh58t96R7oF9IX72JcEjYVwaF/bqwOGVkyDSyxM38FFc7vVAfqJAF7tq0V2kD2+NYhZCk1/4WeR3P1AlhnQhTwlVFCPQYuuqwt00HaZXZcGIJhJBrYzBXfDWZiCcLmEEXPND/9Y4wz5r7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXlHZ281RVZORWNQU09Sa24wU1Y3ekl1VVc5N2xLR2oxMlo1VHoxNytONUZm?=
 =?utf-8?B?V3lmUk1jbmNkTElmaTJJVGxhemZ0TzV6VWRKeDdXZG5ROTJvcU4weW5Yd3E3?=
 =?utf-8?B?UkRwdTlkUzIwUUZlZHliL0YwZW5QZGUrUEY1TzJvNWFBWlJpcVk5cmR6SE92?=
 =?utf-8?B?VG9zQmxBVDlJOGxXbERSaEJaV1plVmFMQlVEbmpDRGptMlo5ay9kMldZejhP?=
 =?utf-8?B?T3lQSWtKR1IxbS8vaExCelMxSFpMUXA3cnhId0J6ZzZnT2YvcTVNTWwyM1ll?=
 =?utf-8?B?TUhFR1Rid1FESzNPL2dtY1laZ1pDL1AzUmJGdHdVUnROMk8zdHVzSDA1MTda?=
 =?utf-8?B?Mm5tdlVGTUtWTFY0YlYxbExnQUhRZ0FZdG4rWVVRTGEwd1AvWUJVR1RMV2dR?=
 =?utf-8?B?anBOZnJPQmkyNXFlZzhKbnZzc01nc2JOYzQyajAzRjlRWUExRTlmSHdVSmw0?=
 =?utf-8?B?QjV6dTBYNXc4clhlc3hmQVhFN0VqQ1JJTW5EUVUrR2hkU25ucnFaeStpUFlr?=
 =?utf-8?B?bUZ5Vm1ST2p5NStBU21VWjBDZGFPcndFeFZSOXoydjlxOEV2VXJVdUF3cUJH?=
 =?utf-8?B?M1NudW5yYXJkam5WTVNDTnhnMStYZHEwS2lnNUtmUWVZWGd2OTNieDZRc3I4?=
 =?utf-8?B?SEdUTnFUK2k1b25yN0xDWGJtRFdYcldZKzV6cTdDaGo2a3dIZk9QMDYzcjZW?=
 =?utf-8?B?SEJlSUR3K3NLUmRMRWFsVyszaVg4QnFxUHJDRGpiWXFtOVJNRmdvVG9SSHFU?=
 =?utf-8?B?QS9Pb0FTZ2w3VGhRMnprcStnVHE0Zzc4K2J3KzVzNUJPQ1FsSktiQm1nSUdO?=
 =?utf-8?B?amhpd1lvVWIyWkJtOXRFTEVCNmNlNmxTNVllQisrZXhzNmhKTEFma2ZwMzZS?=
 =?utf-8?B?QXdSYVJZNVFZb2psT2I0eGMwZmlPcy9WYnRwWm1aT0NraWFmelEyLzZoVElZ?=
 =?utf-8?B?OHcyNmlXaUJ4dmtuK1hOZ0N2OXJ3Zm9kcmpkVzFkM0llU3NpYkRidEVPVmdX?=
 =?utf-8?B?eGhka2Fya0QxRkVyaW1SeVoyRDRKeEptQ1I5NWhzUDhMcEZnckZLYzNzSUdw?=
 =?utf-8?B?NElZU0JscVFrYUpUbGdJNitnTVJuaUF0V1JDejJCbnBubHJvc04xVHdHV0J4?=
 =?utf-8?B?dm80aldPbkxRbi9Yb0g3SDlJdTZONFBJOFpxUHlRV3FTNXVtOFNSZEwyOTVo?=
 =?utf-8?B?ZStnY2g3Y0ZvV0tlaVZVdVZ2WFJUOVNLQ0dGSEZUbFhjeEVnc3I1UExmbk9Z?=
 =?utf-8?B?dmNiUXNrQ3NzaHpNWVB5akIyQldDTkgySHBHaGErR2xZN0ZJL080WjhZYVVO?=
 =?utf-8?B?aUd5clcwL1Mya0dZbzZjSm00cTUxdEs1cDBiVWRtaGhaRG9tb3J5UFo0RzBO?=
 =?utf-8?B?L0hzTFZNSGpZTlk0SmxEZzdCR0tGcncybG90MWtzQXVFSVhTcSswUlRlbTlL?=
 =?utf-8?B?THVlMis4VEpHMHJDNzMya1llU0sxWVJOS1lJSmRhR0cvRnQzdWN4N2pDdGw0?=
 =?utf-8?B?M2Fjd3U1UHUxanhNdnJISzhZK251b09TcjJHT1NSb2trQjFyd1RWQTZXckRn?=
 =?utf-8?B?eE1Fczd2dkQwVytFNXRhNGxqWGcveEd2U0R5UHVGNm1kc1U5emVOQ3hvUWdu?=
 =?utf-8?B?QTRLQjhHSUo1ekVtRTBLWFljK2htNnpDcnk3NGxVc1NFQ3FXOGRIUzFNWGxq?=
 =?utf-8?B?eDVGQ0ZRQS84bWhtQ1E1SWNHTkQ5UGhZNzlzL1FrdkYyM1hVeUtIL1dRRU4v?=
 =?utf-8?B?RFI5SHJiclVQa2JZNmVpUENoN1UzaElaK01pVmU5Sm1yMDNoQWFvR1kyOWtY?=
 =?utf-8?B?N2ptVG9pcTJHd2swMWwxYzc0cVF6YkM2eEdHTXdxQ2UySEdTODFXNkJmeURD?=
 =?utf-8?B?b3dYaEVpZU1Jd3lMaVQ3QVZvZi9wSTJEbk5BT0NCeUY3dFdlVXJoY1owdnpP?=
 =?utf-8?B?SnJNdE4wS0E1RGhuVEtEVHA3dWlrMWpsd05jOFkxZTJEZ1pWRzR0dXpyWlh6?=
 =?utf-8?B?UGZkVnBXV05yUEFONVpFUlRac3FSNUNZRVh4MDdLTzcrZHpHTW1UanIzQjhW?=
 =?utf-8?B?ajFYc2NId1prN2VsNGJvQlY1blltZnJlRnE2YjBMdTlRdlY3VEtqb1hERnRC?=
 =?utf-8?Q?xbNcd4JTnUdebyCEQDBYYGGDl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6085076-d425-45a9-811d-08dc53d0881f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 11:23:48.5961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHF8qPYqIXAEN3t8usYeXWK5JwIy8NYsnhYCI0MLZVLGBSx879IC3Jav3prhHDXs9kCtxl9qvNNK1kzuW0+MtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

On 4/3/2024 12:36 AM, Sean Christopherson wrote:
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
>    - Removing guest memory from the host kernel's direct map[1]
>    - Mapping guest_memfd into host userspace[2]
>    - Hugepage support for guest_memfd[3]
>    - Eliminating "struct page" for guest_memfd
>    - Passthrough/mediated PMU virtualization[4]
>    - Pagetable-based Virtual Machine (PVM)[5]
>    - Optimizing/hardening KVM usage of GUP[6][7]
>    - Defining KVM requirements for hardware vendors
>    - Utilizing "fault" injection to increase test coverage of edge cases
> 
> [1] https://lore.kernel.org/all/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
> [2] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com
> [3] https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com
> [4] https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com
> [5] https://lore.kernel.org/all/20240226143630.33643-1-jiangshanlai@gmail.com
> [6] https://lore.kernel.org/all/CABgObfZCay5-zaZd9mCYGMeS106L055CxsdOWWvRTUk2TPYycg@mail.gmail.com
> [7] https://lore.kernel.org/all/20240320005024.3216282-1-seanjc@google.com

Passthrough PMU lays the foundation for enabling some current and upcoming PMU
virtualization features on AMD processors. Manali and I have been working on them
and would like to participate in the discussion.

- Sandipan

