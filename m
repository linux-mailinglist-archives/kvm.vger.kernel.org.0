Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67042549EA
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 17:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgH0PxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 11:53:20 -0400
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:2401
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbgH0PxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 11:53:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4L7Dpz+wCu6jnDwkYgrxjhcL2XBdsn5v6BXnO78vJzB0UXYrRq9tASKEpMAwC72vzV5geF43SJ3TsyUdRar4kS3j2CErY2azVzFjghRPc7jhjyGq/CdbMG55mIXRyng1+X69uQHonfkAAKyf0sMfLyfdqjKNQ45bxMv9aiIFZrYuBFFGIuKvoKsJmYaxbjbJahChz7xlvrB92VES3+kWj+CAX9507DoJHB37Ejb2QaGbBRe4j0T1moCNDkzCUr2uyH3JGBD3Eqt8hIiBIuN0mCL52cyDL5a0Y1mGv4LExEH2Q0DniaK5+5ugGGlLKAw/iRZT2zMbHf0mYok+yvXSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmX5UKo4Sh5d3rsLlCaDrFwq6J5U68wIG+U3QNRBYZU=;
 b=jWUZsoZKOwmBiL+tJnqxr5AK+dEKC1d5mgcDBPMZNoITnEYQd9xLC/BXo/ntC9F0f7nBmygmUdc0lXJkVPzTkXBguNaDFhiubJA704O0xUtdBIkbarRwnFAuJX5rmPiUL4IVE49LIs0LFXvpYpHReBa4KvJwbWBpb5C1Eel/s0wm/IndEH03gxyxjj/yS/Eqzyr/LOD6sGrKweuyEFWw1hV5TYh17jEWOGtRy4KsmrMaxdzul49exWPQ2pvJjkL869LmnSck82Hl6adwpPCidUOzv5VFEYMRw7tXhpvXqNOt5ZSgDW/X/PFRlB4MwIdRUp3dpFpJoU+P1BejzsKVwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmX5UKo4Sh5d3rsLlCaDrFwq6J5U68wIG+U3QNRBYZU=;
 b=GROkznrgYWwfCDvgpuZRA3mrFC24mAWGejogCbv5GngpumrING2x9Ex/YxfSKrS2uH74SBW+c7Yod1O0XnLs3hSmW0Wpvuy3yA+iWSMF92TvBKY7tSOEQMcphWuDpwpHjuq68ZfgFsGbdNWZVcDJX+qV0fphldbm2MmpD1k02t4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19; Thu, 27 Aug 2020 15:53:15 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 15:53:15 +0000
Subject: Re: [PATCH 0/4] SEV-ES guest support
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
Message-ID: <4a529793-5448-458e-d9a8-31a8aa39f67c@amd.com>
Date:   Thu, 27 Aug 2020 10:53:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <cover.1598382343.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0128.namprd05.prod.outlook.com
 (2603:10b6:803:42::45) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN4PR0501CA0128.namprd05.prod.outlook.com (2603:10b6:803:42::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Thu, 27 Aug 2020 15:53:14 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d9366339-f740-49f6-0102-08d84aa14ef6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3082:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3082BA0F1F57149437EB15E0EC550@DM6PR12MB3082.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4HR5gJNRBl8EEAckCBu1CGHGVE8JaY0nv4+EK2GYL9TNQpg9pcDdwZxFLuGvAgm9Rfu+4dV1sA/QbkljiOmM7s2Cx7RXDuGcsHqTyyD6EdWnzH1baWf6UZOOBHAQ9vCzcWcam3ZqW3KhkKdZOPS5SFQRyAdPhaM/IN+pYwGDHJuADKz4ZNwmNd9gptpe4zk5njSYmKrZQqeUeEMCknp7Db2+zFsqSA/shGd1iHrldc+NMv1h9b7SDA9fBXCbLEnUbf8iBOBTNX7ADRTmN7BrjtnNfu5zPXRqZb/uZepPUa+gduhQ/DKL7SuBydjZFE8KktdyeEhkRjswXDmc89oky0h2ijIdrTgYFzUYMkV/mhu9vLzrax1Fm5ub1Uq6b7YvqMfqs1XHupfGKMLGP/KsEccKbAOW0yCMS+mUyb6ZmXrEPCqrFhnj9a6x4uEKQVddwlKry4ceI+yWPbjG1WsghA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(2906002)(5660300002)(6486002)(54906003)(36756003)(966005)(478600001)(31686004)(53546011)(186003)(83380400001)(52116002)(26005)(4326008)(8936002)(2616005)(8676002)(956004)(66556008)(7416002)(316002)(86362001)(16576012)(66946007)(31696002)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OTfGjScodq1nlHOiQ2ESv0QY0fcl+sS1OIrSRIkdxLKrzm5N3Ec804v950hiMmP+4w2VThstEpESClqFj3YtsulzE293xbog6cECUe7Lkpuxf18JZX7vwlRvyWnHfTbFnq4z3J3YWtGWtRh+Bdh9DuHkqkYoA4D03/QJcPW5G1h3cATdSqKoEh6hF12cK2vfiSBwL5AtOEs5YXNH50fnJXA/RAInisKmlVT4zHEiPPuhkp44eU0u/xW3yuvxBc9GQn/Im5QDIc/IeMsu1EGE0B91BHcFREizJ6PpBAuxmtNz1BONQtn7/7dmNRL49xdo2Uf2X74HUPw0a+ybK2QOXtp26C84BDRF5Mm7BYlqpEGMiJhUpnGV0hcyefwpqK9pVsVvXcQOxrb7wHpo51hYij+hV5e57MPyvktTxlTmUe+7g5G4FwngwFBNA29BiRIk5W5SJ1EVQZ3ZATprcc6gz59N76dZWw/lur4yB1zM2c9wWZAASgtw/exMINfg9zqE6+5jMRB7eWxeOfqynF3RLaFKNZiSbI8xEyJlrPZXuLI7CwqBlyawh7GHqRVlv4V+oB4aMm6ip2MLl4RfDCxGfrgo1gzdLtYzHCw1ddGYLmHNHbu7PT32eWH57d0VWP98utfADxE2gEQMNbmZ4vrm9Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9366339-f740-49f6-0102-08d84aa14ef6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 15:53:15.0850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWgjoN21iZTkyW5ibepV1eIGphzwFzq8Pb793CUYox6KQej2Gkda94Ukcm5iRb2DCtMLiXt/kMaq6QRk4uXEnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/20 2:05 PM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> This patch series provides support for launching an SEV-ES guest.

I've made the changes associated with the checkpatch script output. I'll 
wait a few more days for other feedback before submitting a v2.

Sorry about the miss in regards to running checkpatch.

Thanks,
Tom

> 
> Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
> SEV support to protect the guest register state from the hypervisor. See
> "AMD64 Architecture Programmer's Manual Volume 2: System Programming",
> section "15.35 Encrypted State (SEV-ES)" [1].
> 
> In order to allow a hypervisor to perform functions on behalf of a guest,
> there is architectural support for notifying a guest's operating system
> when certain types of VMEXITs are about to occur. This allows the guest to
> selectively share information with the hypervisor to satisfy the requested
> function. The notification is performed using a new exception, the VMM
> Communication exception (#VC). The information is shared through the
> Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
> The GHCB format and the protocol for using it is documented in "SEV-ES
> Guest-Hypervisor Communication Block Standardization" [2].
> 
> The main areas of the Qemu code that are updated to support SEV-ES are
> around the SEV guest launch process and AP booting in order to support
> booting multiple vCPUs.
> 
> There are no new command line switches required. Instead, the desire for
> SEV-ES is presented using the SEV policy object. Bit 2 of the SEV policy
> object indicates that SEV-ES is required.
> 
> The SEV launch process is updated in two ways. The first is that a the
> KVM_SEV_ES_INIT ioctl is used to initialize the guest instead of the
> standard KVM_SEV_INIT ioctl. The second is that before the SEV launch
> measurement is calculated, the LAUNCH_UPDATE_VMSA SEV API is invoked for
> each vCPU that Qemu has created. Once the LAUNCH_UPDATE_VMSA API has been
> invoked, no direct changes to the guest register state can be made.
> 
> AP booting poses some interesting challenges. The INIT-SIPI-SIPI sequence
> is typically used to boot the APs. However, the hypervisor is not allowed
> to update the guest registers. For the APs, the reset vector must be known
> in advance. An OVMF method to provide a known reset vector address exists
> by providing an SEV information block, identified by UUID, near the end of
> the firmware [3]. OVMF will program the jump to the actual reset vector in
> this area of memory. Since the memory location is known in advance, an AP
> can be created with the known reset vector address as its starting CS:IP.
> The GHCB document [2] talks about how SMP booting under SEV-ES is
> performed.
> 
> [1] https://www.amd.com/system/files/TechDocs/24593.pdf
> [2] https://developer.amd.com/wp-content/resources/56421.pdf
> [3] 30937f2f98c4 ("OvmfPkg: Use the SEV-ES work area for the SEV-ES AP reset vector")
>      https://github.com/tianocore/edk2/commit/30937f2f98c42496f2f143fe8374ae7f7e684847
> 
> ---
> 
> These patches are based on commit:
> d0ed6a69d3 ("Update version for v5.1.0 release")
> 
> (I tried basing on the latest Qemu commit, but I was having build issues
> that level)
> 
> A version of the tree can be found at:
> https://github.com/AMDESE/qemu/tree/sev-es-v9
> 
> Tom Lendacky (4):
>    sev/i386: Add initial support for SEV-ES
>    sev/i386: Allow AP booting under SEV-ES
>    sev/i386: Don't allow a system reset under an SEV-ES guest
>    sev/i386: Enable an SEV-ES guest based on SEV policy
> 
>   accel/kvm/kvm-all.c       | 68 ++++++++++++++++++++++++++++
>   accel/stubs/kvm-stub.c    |  5 +++
>   hw/i386/pc_sysfw.c        | 10 ++++-
>   include/sysemu/cpus.h     |  2 +
>   include/sysemu/hw_accel.h |  4 ++
>   include/sysemu/kvm.h      | 18 ++++++++
>   include/sysemu/sev.h      |  2 +
>   softmmu/cpus.c            |  5 +++
>   softmmu/vl.c              |  5 ++-
>   target/i386/cpu.c         |  1 +
>   target/i386/kvm.c         |  2 +
>   target/i386/sev-stub.c    |  5 +++
>   target/i386/sev.c         | 95 ++++++++++++++++++++++++++++++++++++++-
>   target/i386/sev_i386.h    |  1 +
>   14 files changed, 219 insertions(+), 4 deletions(-)
> 
