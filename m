Return-Path: <kvm+bounces-11588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6947B8788B8
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 20:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B8531C20B22
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 19:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE3854FA9;
	Mon, 11 Mar 2024 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t5TpIGzK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B9F54BCC;
	Mon, 11 Mar 2024 19:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710184781; cv=fail; b=WV17u5qBixqZjJPbWO/uCCXlzt3mU9Brl1PC088Zb1JdaVYoJQAn20JZYhXIrqw5VfIA0B34DACkKT+DdJset2ENQg9lNcH4swbXq0hj+KrS3SvninPhldrATpFZSAQ6jpYClpzD1RRMPGx1XeMEeVYkQJJMaUlbI4AioNdPNFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710184781; c=relaxed/simple;
	bh=Pw4GeRH1ZzaVbhvyTQDa2GtDRwTYSgaUJEBzlFFtl4E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D+Yil7s9gr190FNB2t9VXgCkMrlMxKRZyRzFNpOSbGM/41v3zIVSqZ+IEcsZFYuGt2dHVxUbtWc+zYtM7gni/nUbJAGGImgwI6Oqw9MRq4vh1XPlaWjsKgY6PTS2Vp2FyKWqFfOa57ijykaYNeAzyHDq94wzq8agetoYHGjxoic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t5TpIGzK; arc=fail smtp.client-ip=40.107.95.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqIzZ45Lqj8NspVmdZTiYMs4Ar8NhLGUqW060UGRRtPlev+sBJTB06Wi/5KX3TjLS6a8FN2U/7ufO5W7DdZlUe9GGvegSiY9sgjhtCO6GenHWuh5rYmmTHYG31NgFNjg8cRGb1jbKV3X7DSlnVt+aLgr00bEN1aDSdGHW0UH8tKYFhlNsPgq8LVpwciiuWgZhKno1Iq73PYe/ThSVl3KLT3VBd/fvyWbTS189Pe8YH0hkTWIpfVYwmSOoMZaLPoFs+hqBR2mieIy3V7+bNCAjyOAWRqj5r7io0B+juGOIrpIjy8ubzF/mZxZ2iAeeT8ZhPUXPTaHjCH8NqcEpIfePQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcDoGlzQXYUNxb/Cb/Rb0AeS0zKfv2LYAy2qSjxqYGs=;
 b=UEc8mUOOxfO0mT3XXnJxYPVfYDX5WQudCWij5Wh1dPd0opsMAzKkPRP3a/VIjAP9NrUhH17W2glbtEuU2+0TXProHLUE9Zeuupvp+vAHdqKzt6X7SKNa9miXSxWoYwXreNbcevTkh9IH+dbyUI2/KyojnQR17/VFykeczNC0gfmVv1pjl54CnRk8HsUZBcz55thsPVtjTOC0UG8oGhCmKFgDDYmZsVqDjCikSU3GBXoXkl9Per6obVVKCT/j4fdRB4DB+Crqqa/O6X9UNrbQHdn7YhOQqsBsN90XLt1WuEFWuY76yzI8jz6pxQFyVejy8Xo0REfbQb3Nv9nIYMkblw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcDoGlzQXYUNxb/Cb/Rb0AeS0zKfv2LYAy2qSjxqYGs=;
 b=t5TpIGzK31voXWNw8IKjmS1l+7FV65fAhcjGT2j9TPnB/3EYDXiHRzQnn8pcetbx5/jb3GHg8hxG7QpozYX3tCJ2Sf7xAbeyaXMQNv9b2F1ge37772dCWWpvNRcID+HDFaOdrUhKF2Wgjo3JpfI18UzZE1znzcKfk/Nx2+dVwes=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SJ2PR12MB7919.namprd12.prod.outlook.com (2603:10b6:a03:4cc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.34; Mon, 11 Mar
 2024 19:19:37 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e%7]) with mapi id 15.20.7362.035; Mon, 11 Mar 2024
 19:19:37 +0000
Message-ID: <f1ff678d-88fd-4893-b01a-04e1a60670ce@amd.com>
Date: Mon, 11 Mar 2024 14:19:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/9] x86/sev: KEXEC/KDUMP support for SEV-ES guests
Content-Language: en-US
To: Vasant Karasulli <vsntk18@gmail.com>, x86@kernel.org
Cc: joro@8bytes.org, cfir@google.com, dan.j.williams@intel.com,
 dave.hansen@linux.intel.com, ebiederm@xmission.com, erdemaktas@google.com,
 hpa@zytor.com, jgross@suse.com, jslaby@suse.cz, keescook@chromium.org,
 kexec@lists.infradead.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, luto@kernel.org, martin.b.radev@gmail.com,
 mhiramat@kernel.org, mstunes@vmware.com, nivedita@alum.mit.edu,
 peterz@infradead.org, rientjes@google.com, seanjc@google.com,
 stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
 Vasant Karasulli <vkarasulli@suse.de>
References: <20240311161727.14916-1-vsntk18@gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240311161727.14916-1-vsntk18@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::28) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SJ2PR12MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: 9837f965-735d-46cd-d327-08dc420030ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1Np6pxJwahNxOAuMJARhstN2BLbHRv+vuJBTKAs9Dc9aojvv4Ln0+XtiowlCKFnCb56Nnu0nUhjpPiMnEN32ELqbbxCRhgDr8ZCcHoxfD/1q+VN6VLOHeawNx+IiD/YuQajt98+YPzSQH01IHwDf1aqB0Yw5XCM1CbPtO2GJj/3Rthd3yzUnyHrNE697luz/R5JsOuLBL3e/G0n906U5Y8CRnxVseX2VKdNNBUy+UgjVnJfVtBcnwHxIddCWhMwJwFdW4FliEGLNezA+QVVdMUd6EUuk17n1VdGJQ/sFTXmxKT/nGxn/4vk4mdKn0seJ3eoenCpLfOc4kP9i0H4ni/h4r4U5ZdTcm/LGKJlatIzcHFZz1eaWl2cuQneFL0nSNyoJX25FMKsWY23UWkNjX4JSD76zKo05+aE8DdfeHxIOa7nsqbSr13gdY34nD+wloN6g5dUiVqjPyUAYwZSU/KBRAl7+HzcAemdssVxhXANsU6ZOGD1WiDI3EOrBv8i1WW4Nfl+1YulOTMkW5bk98djgEQUXVJEHDDC6uFLZuhHPXXEQgUdyYF7PCbxnBv9bnfCcZT+vBPrNFuXtJT+WJ/RLTVookh/8fZGDs7ryvns=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUYxdEZ6MzNIdSsyMGdaaWppcEJYWnpFNUVHNHlLSzBWdnZIU2h1eksyN1Vo?=
 =?utf-8?B?OTVhYzhWZnE2YmhRdHBISk9aWCs4QjAyT1NmQWt3RlFOQ1oyNFpjOFFzWXZr?=
 =?utf-8?B?THdsbVpVQ3lTc0JTa1VIb09hcG1IUDY1TWN6eXpYM2xIMjEvYW15dWhyQ21U?=
 =?utf-8?B?SEhjQkJRN0k5RnFvMXNsUmM1Z0gyTXhqL0hVMllZRVJIdGwrZG1RV2NDbmxG?=
 =?utf-8?B?QkYrcmwxZGNaM0tNekJUWXFHNjFhUHEzUGF2Z29PQ3lDN2RJRWo0YkpxdStn?=
 =?utf-8?B?TE9POFB3OUs3bEFzR25vNlhnLzJTM0ZHZ01ua3VBcGxWbjJKQzBlZkEvemJu?=
 =?utf-8?B?d2dRUHZieGNxYzB0dGxqeExTSWdURHNJS2pxTWc2aitEcnBsTkhZMENqMU5O?=
 =?utf-8?B?cmh0aFcvL1NzT2hWa1lpa3MveVVpbzc2RTZsSlJJclJXbkJqSWI0UU9Hd3BU?=
 =?utf-8?B?eUl4eUNDVnBJTE9MYnVRc1FSV3dHMUEvOXlBWmtBb1RFV09rNEFPRVh5QVdL?=
 =?utf-8?B?OXdHVkxnOGxNV2ZHWmZwcitQd2JSTE12REJuRUcrQnhUUEVkU2owODh6MEJO?=
 =?utf-8?B?ZVpJQmRhNWprTmYzV0ptSXhuSVZIaHM2bXpqYXpGb0lTbHNwYll0Mm1NcFNH?=
 =?utf-8?B?MEJLWjFzRjVmZ0JqYzV0NVJVckN1dFI3bTNEVWs3MGsyUDRtbitkeWpENTZm?=
 =?utf-8?B?QzF2akdMRzNqNjRUVW55eEJZeUQvZUNmeXJBK01oREdFZnNQMlcyL0xaUEVp?=
 =?utf-8?B?dGR2cWlGTHNRTnh5RjY3NTlXR21YSmNwK3EwUjFuVEcrdTRWbDZtb2g4VG4w?=
 =?utf-8?B?dlZsbURTSDhtbnloMTZBNEJQdCtIQ2tCSGVCWFQrYWdrYVgvMlVuaGhWR2xo?=
 =?utf-8?B?T1p5QzQzUnVSUGx6MlMrdko3Ni9YMjIwZmc0M0VNMFNscWpwRXUvQ09NSSsr?=
 =?utf-8?B?V2xlTzJQbXNNUVEzdWZaL2lrVWNiK1VSNHBGYmlZVDFacmZnbkIwekFaNG8z?=
 =?utf-8?B?U3czZDI1a2NkYTFSU2pDWDFBWGNCZXk1aGhJaTNBNDVDb2hHN2F5bEtCcndQ?=
 =?utf-8?B?L2RnOEMwdzZEZEMrVWtMd3J3NXJKRlRTbXBaWFdmNUFVWlJYcG5OckFLR0R0?=
 =?utf-8?B?NjN4VGxveDcyUzRpN0dJbVQ5NUNUaWdNVXM1dll5dmpxaDZVbzljQWk0VHBr?=
 =?utf-8?B?YlNYMDd1UEQzTTNQbFd4MW9taU9JTERFeWpOVmNkOVU1TWVDZ2J2d2dYVEF4?=
 =?utf-8?B?N2x0aU9DbTQzUXNUczkraEd3MWZoQjlvTUJkU2d1N3JCS2R0bVQwSGwyWGpS?=
 =?utf-8?B?a2ZnZFpMcFlhSjNrYkZPaURTamN2aVFzZDJMNE82OTFaYzlISzAxcndYNVNP?=
 =?utf-8?B?bElxeW8zbTd3cEdhc0xhbWtUNWtnU2JmUTZFTWdqK3dvWWVpVGwxdFBjT1dY?=
 =?utf-8?B?SGVHRVVCOVhDUVVtamQ1dXlMVzlJK3BWZENGSmU1MEtUY2FvQU1XQWFyQlpS?=
 =?utf-8?B?MW5jUnFPSHN6S0ZuOWtST1BscHFlOHYrUzJTbHhmblVWUVdvNlNRanpZb0VM?=
 =?utf-8?B?ZEJzT1c1M0pRRHZMUGI4aFZpRGlPT0gzRXNoWWpUV201UUtmWXp2UVRBY05l?=
 =?utf-8?B?RVVSREJid0IwajBTaWRYcHdoeTRpdEdmRUhWU1lueUdzRVRBY0ZYTUJzNlZ6?=
 =?utf-8?B?NllSRW1nQWFBdnhQQkxGaTdKUUxzU2Z6eFo5dS8zNTBhdEVYNkV4cjBGOGhx?=
 =?utf-8?B?R2FuVXFpd0lXQVRxcGJpcms4U20rcCtqVXZYZWZ1akIwUnRsTnJPWUEzQUZy?=
 =?utf-8?B?UmoxaWNCdDI5dWNXMW1TclJ5UjMzcE1mUnJjMkZka2NBOEpMS0lFQm93bHlF?=
 =?utf-8?B?ZVAyK1QwTDlWZXlEK3ozdlNlRk5JbkdhRGJYRlhnZHIxV20zcVZ1eFkwbkJC?=
 =?utf-8?B?MktxYWFDNVU0MVhnTGNmMjFsWWZySW1CbGg4bEhBaitsTlNuVzF4enNtM0lv?=
 =?utf-8?B?dWpsMkVqRjVtditaamhYS1kySmxBNm84a3Z4aUV4Vis5cGJwR0MzTEQxTmVO?=
 =?utf-8?B?b0lLRG9SUXcreGpUSkZFcDlPN1FHZWNWTW13U1A2cjVVaFhsbVNDQjBPRVJR?=
 =?utf-8?Q?CxsgmH/MrX1HJ6uZCXehCSLYY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9837f965-735d-46cd-d327-08dc420030ed
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 19:19:36.9800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJg0Ix0IF5mW98S0EDmgFE6FmazR00GIMvtUK3ZedR+0jHwAPQMvKng3yhNAadPJqKhBPz4PK71RetWlpSZAZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7919

On 3/11/24 11:17, Vasant Karasulli wrote:
> From: Vasant Karasulli <vkarasulli@suse.de>
> 
> Hi,

Hi Vasant,

The SNP guest support has been incorporated in the kernel since this 
patchset was originally presented. SNP also is considered a guest with 
encrypted state (CC_ATTR_GUEST_STATE_ENCRYPT will return true), but does 
not use the AP jump table. So this series need adjusted so that the AP 
jump table is only used for SEV-ES guests.

Thanks,
Tom

> 
> here are changes to enable kexec/kdump in SEV-ES guests. The biggest
> problem for supporting kexec/kdump under SEV-ES is to find a way to
> hand the non-boot CPUs (APs) from one kernel to another.
> 
> Without SEV-ES the first kernel parks the CPUs in a HLT loop until
> they get reset by the kexec'ed kernel via an INIT-SIPI-SIPI sequence.
> For virtual machines the CPU reset is emulated by the hypervisor,
> which sets the vCPU registers back to reset state.
> 
> This does not work under SEV-ES, because the hypervisor has no access
> to the vCPU registers and can't make modifications to them. So an
> SEV-ES guest needs to reset the vCPU itself and park it using the
> AP-reset-hold protocol. Upon wakeup the guest needs to jump to
> real-mode and to the reset-vector configured in the AP-Jump-Table.
> 
> The code to do this is the main part of this patch-set. It works by
> placing code on the AP Jump-Table page itself to park the vCPU and for
> jumping to the reset vector upon wakeup. The code on the AP Jump Table
> runs in 16-bit protected mode with segment base set to the beginning
> of the page. The AP Jump-Table is usually not within the first 1MB of
> memory, so the code can't run in real-mode.
> 
> The AP Jump-Table is the best place to put the parking code, because
> the memory is owned, but read-only by the firmware and writeable by
> the OS. Only the first 4 bytes are used for the reset-vector, leaving
> the rest of the page for code/data/stack to park a vCPU. The code
> can't be in kernel memory because by the time the vCPU wakes up the
> memory will be owned by the new kernel, which might have overwritten it
> already.
> 
> The other patches add initial GHCB Version 2 protocol support, because
> kexec/kdump need the MSR-based (without a GHCB) AP-reset-hold VMGEXIT,
> which is a GHCB protocol version 2 feature.
> 
> The kexec'ed kernel is also entered via the decompressor and needs
> MMIO support there, so this patch-set also adds MMIO #VC support to
> the decompressor and support for handling CLFLUSH instructions.
> 
> Finally there is also code to disable kexec/kdump support at runtime
> when the environment does not support it (e.g. no GHCB protocol
> version 2 support or AP Jump Table over 4GB).
> 
> The diffstat looks big, but most of it is moving code for MMIO #VC
> support around to make it available to the decompressor.
> 
> The previous version of this patch-set can be found here:
> 
> 	https://lore.kernel.org/lkml/20220127101044.13803-1-joro@8bytes.org/
> 
> Please review.
> 
> Thanks,
>     Vasant
> 
> Changes v3->v4:
>          - Rebased to v6.8 kernel
> 	- Applied review comments by Sean Christopherson
> 	- Combined sev_es_setup_ap_jump_table() and sev_setup_ap_jump_table()
>            into a single function which makes caching jump table address
>            unnecessary
>          - annotated struct sev_ap_jump_table_header with __packed attribute
> 	- added code to set up real mode data segment at boot time instead of
>            hardcoding the value.
> 
> Changes v2->v3:
> 
> 	- Rebased to v5.17-rc1
> 	- Applied most review comments by Boris
> 	- Use the name 'AP jump table' consistently
> 	- Make kexec-disabling for unsupported guests x86-specific
> 	- Cleanup and consolidate patches to detect GHCB v2 protocol
> 	  support
> 
> Joerg Roedel (9):
>    x86/kexec/64: Disable kexec when SEV-ES is active
>    x86/sev: Save and print negotiated GHCB protocol version
>    x86/sev: Set GHCB data structure version
>    x86/sev: Setup code to park APs in the AP Jump Table
>    x86/sev: Park APs on AP Jump Table with GHCB protocol version 2
>    x86/sev: Use AP Jump Table blob to stop CPU
>    x86/sev: Add MMIO handling support to boot/compressed/ code
>    x86/sev: Handle CLFLUSH MMIO events
>    x86/kexec/64: Support kexec under SEV-ES with AP Jump Table Blob
> 
>   arch/x86/boot/compressed/sev.c          |  45 +-
>   arch/x86/include/asm/insn-eval.h        |   1 +
>   arch/x86/include/asm/realmode.h         |   5 +
>   arch/x86/include/asm/sev-ap-jumptable.h |  30 +
>   arch/x86/include/asm/sev.h              |   7 +
>   arch/x86/kernel/machine_kexec_64.c      |  12 +
>   arch/x86/kernel/process.c               |   8 +
>   arch/x86/kernel/sev-shared.c            | 234 +++++-
>   arch/x86/kernel/sev.c                   | 372 +++++-----
>   arch/x86/lib/insn-eval-shared.c         | 912 ++++++++++++++++++++++++
>   arch/x86/lib/insn-eval.c                | 911 +----------------------
>   arch/x86/realmode/Makefile              |   9 +-
>   arch/x86/realmode/rm/Makefile           |  11 +-
>   arch/x86/realmode/rm/header.S           |   3 +
>   arch/x86/realmode/rm/sev.S              |  85 +++
>   arch/x86/realmode/rmpiggy.S             |   6 +
>   arch/x86/realmode/sev/Makefile          |  33 +
>   arch/x86/realmode/sev/ap_jump_table.S   | 131 ++++
>   arch/x86/realmode/sev/ap_jump_table.lds |  24 +
>   19 files changed, 1695 insertions(+), 1144 deletions(-)
>   create mode 100644 arch/x86/include/asm/sev-ap-jumptable.h
>   create mode 100644 arch/x86/lib/insn-eval-shared.c
>   create mode 100644 arch/x86/realmode/rm/sev.S
>   create mode 100644 arch/x86/realmode/sev/Makefile
>   create mode 100644 arch/x86/realmode/sev/ap_jump_table.S
>   create mode 100644 arch/x86/realmode/sev/ap_jump_table.lds
> 
> 
> base-commit: e8f897f4afef0031fe618a8e94127a0934896aba
> --
> 2.34.1
> 

