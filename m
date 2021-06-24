Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BCD3B33F6
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 18:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhFXQdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 12:33:18 -0400
Received: from mail-sn1anam02on2071.outbound.protection.outlook.com ([40.107.96.71]:28692
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229445AbhFXQdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 12:33:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCGfd9DI3sUSbOsOC4kWKsTpBsoK264dHMI0t2z60QfPkDxRrzv6khVlyw9yDfQn4jn3XqMF8UqbBJ/9kPRF01ySR4Qiwu+5Fd+sfWPGlTFHl88w7PN1jAnQ25ujGeQoCZci8evB0K56xYY0x86ZruSSFNw60A0I5FPv5eOV4gP5Squew1YyOArw8656panv4RmjL8pAOo61VOE95llR6SOe69oDZ4H3j1O5UOipaU540n4WeH5M4m1wMMT8SXiXV80DQdyQvUfK4xktmN2ZQQyaymIxCZx0+fJAB66gHeB70agiRrz7UDbAUr/qlapahUCChFgJoV6PLH2sdM+KDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+fi6WDTFAV/6Skt3aki+ksjOV8ivyNaB1OhoqW96Z8=;
 b=DEbm1fxNWBJM38gVqU1Q4Ypi7RGN9x+6kmSy7Yk7MaBerJiZa/PbKQ17lvSEUxvTw05dThwn/yr0SWXJsPa4qI6jZIEyT23Jk+9CYK0Jl8bIoJRxIUUFoL3ZCGsXmBaOb3/kNbinDp9T7c8beyg5dP1iQtmWqXVcxBw5nROjgj/+3SG0Q1IDY/CLHPOc0Gi2fE1xhScu4yp8SQKh249NqCOMKBKxFk0qM3E7XgV+O3LMEca5yVKm8s1Wkxe5FOD5Ch13xab3YsnXRy3er7PUIYbLywcSA4O0XY+geAIPSrtS3lKtaWhxH/bfnX2ol/ehzuigJUkEzInkVSdB4ExyMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+fi6WDTFAV/6Skt3aki+ksjOV8ivyNaB1OhoqW96Z8=;
 b=nxyCy5ti7yplJu+9aZUgaGNq+S31cCUGQ38/vEvdME9OKRduM+fOv1ljh8kLOlAoS7xfm3LJyzriZx58TooJv6CovCBvIInQ34bqOuHe7Nf7KZ+rFnfeySumLcANMZUIjpngKkAVJ+Tg5vnubf/DT4/2vQOWlBJsAWAvb++jOJ0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4092.namprd12.prod.outlook.com (2603:10b6:5:214::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.19; Thu, 24 Jun 2021 16:30:57 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4242.024; Thu, 24 Jun
 2021 16:30:57 +0000
Subject: Re: [PATCH 0/7] KVM: x86: guest MAXPHYADDR and C-bit fixes
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210623230552.4027702-1-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com>
Date:   Thu, 24 Jun 2021 11:30:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210623230552.4027702-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:806:120::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN7PR04CA0047.namprd04.prod.outlook.com (2603:10b6:806:120::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Thu, 24 Jun 2021 16:30:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ef05dc1-dd98-40d4-f898-08d9372d71c7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB409281D78C9884C44F71A3F0EC079@DM6PR12MB4092.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dqYvPv3BQ1QLF56lVuAi93EzfCuzN8SY2WT410DQwvP/gGCaxdJGdtUxTaY11WKWndcDm2czXgt4L8Sg2fChKmXueVpTM+ENim0osSD+8D7IyXCAxrRCCeRHbc4/FOR+RDmyCPNOjCsgPPiOZhTys6IVGJ1b0Tb/q69tjAOPOxJCyv48jGnIqMTb30zZfue8SoRjJ+ZDMoDLrKkGLM6Proro8+rKLs7x1Ab5SElFA+0mYWaaMcACOYJiHzPY6aZNHTfFiXODoZuFQuUszuF2iWwQbYiQF9QjSyalbMWCMsxA//taH0HNodG751a1KTIInWCl1dXrBHERjOG3kiDecPFzVQqeodGdYdlJcyEDznYk3LlvAADreqnFIyDCSBSDGuY0r3emYx3yZuNvMgKz2eCRTEyoYc2i86okxMRqXqcVBdCaId/9inM16PdTrGfMIz5s+t2xPgwlsIfJ2XeQcrtACRoGMQTRRObaBRB3Yq92QrQErH04c6/k9GFpKR4qxjHWU+m3QN+6rD19CWaj8LPscgIdzw+2pNPZBpapoIx94PnZ0hct8kGIg4bIa+sYRt3yqxS9qJ2yf9/Lvrzi2h/7F+Y8ERiAgyRw3KxVwIc64Aw5SB1qTISh3WN35rXVnv/CO0UdW69Wgg1sEiNy+H7Iy29o5mAEp5t4k4sbv/yjH7SUvC7x503ttJ5mb0Spd3xPc2gfHd4FjNHvdE8KUifh5c1HBLSXIQ4guYPrXyAUBi5q+uFfHaC9rM4voUMv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(83380400001)(2906002)(31696002)(66556008)(66476007)(2616005)(956004)(86362001)(31686004)(66946007)(53546011)(6506007)(26005)(36756003)(110136005)(316002)(8936002)(8676002)(6486002)(5660300002)(54906003)(4326008)(38100700002)(186003)(16526019)(6512007)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ri9QZm5jZTNHWWZDZStOdVJBV3B3eGZKVy9maUdBY1FjYjAvcEdzcWN6YzBa?=
 =?utf-8?B?Z2FoT29rT09jT2E5NSswemExMGRZUGw1cWw2TGUrd01vYTkxZE1pd1R2UDV3?=
 =?utf-8?B?YklRaTljRUloYTZ0S2RhQTRlb1RQejVOdW9VVVlWQzFHNjd6V3Qwc1hqYWRB?=
 =?utf-8?B?QldXUW91cDlwb0ladlg0N0h0VVcrMzI0TFNXajlIa01OdGlKMnJTVHRBVjNT?=
 =?utf-8?B?T1FiMUMyOEdLdENTQ3BTaENrdUk5Y0RuMXJDVm5NUm1vQlgrb2dlTy9xM2NB?=
 =?utf-8?B?MDB6Tmk0dFI4eE8zcEQzNzNaZHIxWUNOa2kvME1nQXhMRVBzNGs0NVNJWlBP?=
 =?utf-8?B?MDZOd0xXRmhKclZtS2lkb0h2djBKS0NoZThJamk4Z2NsNm92cmxOVEg3QkxR?=
 =?utf-8?B?NDl0UWVpQTllSUY0cE1RRGRpSkVOR3F1OTJKQ1YwUFEyZTk3dE9iOFZwd3FI?=
 =?utf-8?B?L1FOOXNmUVFGS3c3MjdRQ2ZsRjlZOGhYNlZ6bmhieUpiYzZmLy93SzlkQ1hp?=
 =?utf-8?B?TTdiRGhDemRtZWtkd0NuaXFldm10bEhvbzJYcGd2WmZKSkRYeWtIY1RBMm4y?=
 =?utf-8?B?Zi9rOUJpZXV0b0QySWhQYW9yZHc2Vit4anJTK3U3N1o4M2RKMEN1WmRuUWlG?=
 =?utf-8?B?RE11bUxmOFlTeDhhQXh4OUM3NEJNSFRFMHZxajUzdDVDZENRYkM0R1BhU2V3?=
 =?utf-8?B?SHpOR1ZULzdleGtCSll0NVJnNG5CeXUwbE01Y2xsSDNoYTJmTlloRDZRK1l4?=
 =?utf-8?B?STdNYk96Mm96cUJFUWV4OFF3R1pxWVJXdTFBWElQMXVRNVhPSDc0Y1k4U2Mx?=
 =?utf-8?B?eDk1bDFTQlVaQzRXbEI3MDJDdk5IdHFoVUxqK0FvbVJYaVJZVkFpaVlkUmN5?=
 =?utf-8?B?Z2RUMmkvM21aa1pkWmtoSEYydzNaRzBod0REbXRUbEVoa1pGNHgvYm05aDM3?=
 =?utf-8?B?dCtYUEJGUk14NlF3WHZsbkRiRjF4MjB3WHhyRjN2N3VJdVFVR2JiR0FUU0ky?=
 =?utf-8?B?TVdiVG9uMStEWkg0aU1xa1J4YzNmcC90NXBaYXlxd05PRDNjWE5ZSVVGUEJz?=
 =?utf-8?B?dXhzbUs3RENqUUJyNlZzeGpJbXdIdFZFeitldjBtZEFicmxOVkxJVlVxMUNy?=
 =?utf-8?B?bWJpRlZndTVRZC9tZkErVHVjbWJDWTlvZDNLV2VLQjk5VnFLc2NMTEw2eDZv?=
 =?utf-8?B?ZDNQOVlKQWZlU2J5eU1FU3FvN0NGMFBMd05YVGtSNjg4cXdURWltUVk2U05X?=
 =?utf-8?B?OFA5QlRvcVhxVWNzY0grV285RGszZHFMeCtRSWpFQXZsKzUzeFZ1OEV0QW0z?=
 =?utf-8?B?Z2VMNFRKNXFrTjdyOXdrSm4rQzJDYUkrQ1lTQkRDaGp2dnM0SkZ6bnFnNnZH?=
 =?utf-8?B?ZWpLcnh0Mm16Z0tjR1Q5QzE4MS9vSnNYRVpTbmhoaE16VmxGSDRBU3MzSmg4?=
 =?utf-8?B?NGxsYU9pN0IrbTNoTEhoeWN0Qnh2bXZYbitJNkZUcTlrZWk5a1VXeTlObTNI?=
 =?utf-8?B?QVovYndKVjVzWmVjY0d0bzdqdmdzV2JGOERyS3Y2Y284Q2RyVngyZS80Uys5?=
 =?utf-8?B?VzdsR3hXMXNEZndpOW9VOWJlOTVNc2d4MC9nZGUyVFNkQ3RVblBLTzZLbHBu?=
 =?utf-8?B?SlVaK2gyUDFCT1JidzRRU1NmWDh3TmxITTd1QUJ2ZVZXNHRZY2FZSEdiNm1Y?=
 =?utf-8?B?N1ZjeFVnYjJqSDRoTFdtVFBmQjZydHBpUjB4ZWpxQUJhMUhwVzA3alk4SDhj?=
 =?utf-8?Q?IG0DkZOK4E5x4Cplmeb7Pih8bdoTt1/uRfpm2Nt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef05dc1-dd98-40d4-f898-08d9372d71c7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 16:30:57.3651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FnwudI7jaYIABtCGt+7ePGWY8kdeEkpI51Q3Rs8pryvciIrSXEKu3rWPDFVaS47Sx9UzV11aSXU10H6m9JKynA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/21 6:05 PM, Sean Christopherson wrote:
> A few fixes centered around enumerating guest MAXPHYADDR and handling the
> C-bit in KVM.
> 
> DISCLAIMER: I have no idea if patch 04, "Truncate reported guest
> MAXPHYADDR to C-bit if SEV is" is architecturally correct.  The APM says
> the following about the C-bit in the context of SEV, but I can't for the
> life of me find anything in the APM that clarifies whether "effectively
> reduced" is supposed to apply to _only_ SEV guests, or any guest on an
> SEV enabled platform.
> 
>   Note that because guest physical addresses are always translated through
>   the nested page tables, the size of the guest physical address space is
>   not impacted by any physical address space reduction indicated in
>   CPUID 8000_001F[EBX]. If the C-bit is a physical address bit however,
>   the guest physical address space is effectively reduced by 1 bit.
> 
> In practice, I have observed that Rome CPUs treat the C-bit as reserved for
> non-SEV guests (another disclaimer on this below).  Long story short, commit
> ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
> exposed the issue by inadvertantly causing selftests to start using GPAs
> with bit 47 set.
> 
> That said, regardless of whether or not the behavior is intended, it needs
> to be addressed by KVM.  I think the only difference is whether this is
> KVM's _only_ behavior, or whether it's gated by an erratum flag.
> 
> The second disclaimer is that I haven't tested with memory encryption
> disabled in hardware.  I wrote the patch assuming/hoping that only CPUs
> that report SEV=1 treat the C-bit as reserved, but I haven't actually
> tested the SEV=0 case on e.g. CPUs with only SME (we might have these
> platforms, but I've no idea how to access/find them), or CPUs with SME/SEV
> disabled in BIOS (again, I've no idea how to do this with our BIOS).

Here's an explanation of the physical address reduction for bare-metal and
guest.

With MSR 0xC001_0010[SMEE] = 0:
  No reduction in host or guest max physical address.

With MSR 0xC001_0010[SMEE] = 1:
- Reduction in the host is enumerated by CPUID 0x8000_001F_EBX[11:6],
  regardless of whether SME is enabled in the host or not. So, for example
  on EPYC generation 2 (Rome) you would see a reduction from 48 to 43.
- There is no reduction in physical address in a legacy guest (non-SEV
  guest), so the guest can use a 48-bit physical address
- There is a reduction of only the encryption bit in an SEV guest, so
  the guest can use up to a 47-bit physical address. This is why the
  Qemu command line sev-guest option uses a value of 1 for the
  "reduced-phys-bits" parameter.

Thanks,
Tom

> 
> Sean Christopherson (7):
>   KVM: x86: Use guest MAXPHYADDR from CPUID.0x8000_0008 iff TDP is
>     enabled
>   KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR
>   KVM: x86: Truncate reported guest MAXPHYADDR to C-bit if SEV is
>     supported
>   KVM: x86/mmu: Do not apply HPA (memory encryption) mask to GPAs
>   KVM: VMX: Refactor 32-bit PSE PT creation to avoid using MMU macro
>   KVM: x86/mmu: Bury 32-bit PSE paging helpers in paging_tmpl.h
>   KVM: x86/mmu: Use separate namespaces for guest PTEs and shadow PTEs
> 
>  arch/x86/kvm/cpuid.c            | 38 +++++++++++++++++---
>  arch/x86/kvm/mmu.h              | 11 ++----
>  arch/x86/kvm/mmu/mmu.c          | 63 ++++++++-------------------------
>  arch/x86/kvm/mmu/mmu_audit.c    |  6 ++--
>  arch/x86/kvm/mmu/mmu_internal.h | 14 ++++++++
>  arch/x86/kvm/mmu/paging_tmpl.h  | 52 ++++++++++++++++++++++++++-
>  arch/x86/kvm/mmu/spte.c         |  2 +-
>  arch/x86/kvm/mmu/spte.h         | 34 +++++++-----------
>  arch/x86/kvm/mmu/tdp_iter.c     |  6 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>  arch/x86/kvm/svm/svm.c          | 37 ++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.c          |  2 +-
>  arch/x86/kvm/x86.c              |  3 ++
>  arch/x86/kvm/x86.h              |  1 +
>  14 files changed, 170 insertions(+), 101 deletions(-)
> 
