Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EBB2792FC
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgIYVIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbgIYVIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:08:35 -0400
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on0601.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFFCC0613D8
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 12:13:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX3un2RtJP7Gb74ciOXW4hsLYTVmdriAtf4Gywj1TN9OEXKWbmE+A/G9EBjKvbz81jwXEdFP3m3bZKyiNf1hFcKdj5KJT+mkYh/gDG/ay/W6BlzXvc9KBzJx+KY+5SM486n/4pc9gpWibOLfWRjZPMM1k2jf4KIANrnrK92fUSmAh4I1IOYCdKF93LpvWEfPou86tEmP9aMxMqR7CqYj7V2C3qap5O1Z743Q8qkJbZdMEAoYi64Nf30SPAClS6tHS9FVf8n1BRjRbl6qtKkDcQJg5z3EquVT8PINU5PIprVA0tygCrBfABhPXkqNEm57i9tY/z4ojKvQQAQfDd4WiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26Ajkwk8ZfNw+2As1OoFJ83ryAYsNiVQVxADN5aVOYU=;
 b=aBVANmqdbBUcvizH5LfpGzrXGF7X+Zq1r35c7u3sKb/AmxIzgAw0MjpcNhSbFJfgbeCHP7AydiX+ViZ3OWLU7OoyR6DWDqAabxUHt/9Pk0zezyCFuBog1Bc+ST61QIp6eCRXpVYRKj4sCvOvlRdd6TN/OCE8wyJZj0GPskwIyF8SHZMt89NxvocoN+GRmjPxsnZ1T8euksvKP5e+M+InE9wJLZIa0q4qGGwJrIY1JLjCo0FXORUSZTujPzE6HpU6t22nBYQTr3+whhrswejlKYUD+A6hkY0hiXimyxpZRnwNqV4TieFybyFMIBcFZdsvKDSG0d4uYHn7KxXSQgGr/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26Ajkwk8ZfNw+2As1OoFJ83ryAYsNiVQVxADN5aVOYU=;
 b=OdrBuQW5DvdhaN8lH8sT4lNkW/KfeHdpnjDrIV6vul6Rrr4n18Dm0fwCRBPhA7gj6LPZx+3yX1WK1BLxwMLsR+aXXT46GMFYEEQdqQ+gFgouIDV3LBnQlH18olkM9X9S22TEkxMUHrx5hwXIyJ3IA2bQc8dRtRu8f2Pjtx0aiUg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1835.namprd12.prod.outlook.com (2603:10b6:3:10c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.15; Fri, 25 Sep 2020 19:08:06 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Fri, 25 Sep 2020
 19:08:06 +0000
Subject: Re: [PATCH v4 0/6] Qemu SEV-ES guest support
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
Message-ID: <8632340c-f48f-bea4-39d8-101090c865a4@amd.com>
Date:   Fri, 25 Sep 2020 14:08:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <cover.1601060620.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0033.namprd08.prod.outlook.com
 (2603:10b6:805:66::46) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR08CA0033.namprd08.prod.outlook.com (2603:10b6:805:66::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.20 via Frontend Transport; Fri, 25 Sep 2020 19:08:05 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: acc314df-435c-45ef-4628-08d8618655aa
X-MS-TrafficTypeDiagnostic: DM5PR12MB1835:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18357BE05044F277B6149359EC360@DM5PR12MB1835.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Inl2z4EN1LgOos65TeIjJcn6o5x8HM/JIEaz/qVDhUWYJq0i6gY7FiJInu+A2C1bRQ5nV4Dm6qUeOJpF/zxrpslF23MElInLJv0pLHRj2U8wbSz1X2Efg2IAIDPnxsdDaF8w4pCGQHAI/eZ9U2VnZa3m+Cdlrf2Mms9VE+jkkD2JBGm3lGxN5eMhqcwbuveAp9Pz/Volzt5P7AmNFfvN+oeJXIcDvK3QrFzixwz8QgIerzjRwdxmUPsKVSzHBOsKwlsuqtNq/zB9sndjLO6uj42BwnQaiioTXendQBin2ykpjHsmNlQX9vTP4/DYGhz0wRotPmQ8CcCObjDU/nZzjdZ3v8Apyjyi80vvmrc/T5Briu8Ruxh3NQURuLf+JB1/7UfzA7Jc8ARRQszUDT3JsiA8SBS7fG0a+tI0031uS7mp5SC+2vRf7Z3iFcqGhFmR6t3fA8zUpVeKOASFLh7exBlY30y5JGxQzNCKGB5gg6wzcbe/Fj8X0P2LjJ1J1Qme
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(31686004)(26005)(4326008)(54906003)(8676002)(16526019)(66556008)(66476007)(53546011)(5660300002)(966005)(66946007)(186003)(52116002)(6506007)(8936002)(86362001)(956004)(316002)(31696002)(2616005)(36756003)(478600001)(2906002)(6486002)(7416002)(83380400001)(6512007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pN/nBNa6AG07sEl0ATpF85jbH5xVwdpnCuHHzblrE02tR3Iu1NXJCUYFUs+S0QIJTUCiVm4Ac6FX5COYHW1xcPsIfoCjAHtorU7K5b6/XDyXWiWif02lQPA6Gr05Thh6wS6fuPWV1AYekLqf8IR4Q7SPwPUVpGVI9Qy/wQ14g4Y+HyzYV7M7c1umFx4gXxRsGBgomrOzDf2BfvcVS6/EuHPxS7syMNQn5bBNFq5eydlHwx3HyseD5E9qLfChc69aKBZt12wNHNLJGw6QeWFABoJQVpEX5syhj45RGtH0Pt7nefQLJqZ5vh3tpSrea2OFuIGu3cj6ZTlIqLwKC8o3rQhwx63KuAiVMgxlrQOmlix1ixbb5HDn+TEXK718Rz/NsZrEMz5UAo8eTAUnNXOHNItKL5aJwmji4vkRUOPhqOER7h6/dJ00krDP7zihJpl6id03LKcey7pbuDAK0dXsMEizq0CBIWHbTVw2VnR7i7trMJKulu25WXMNTjcmNAfEGX141svfaz6srCUztkgKgRrMZ5QLwzvZO5JNwLqsNjBLV1sTipWWUoHSHAQyta9GLNeSDwWr048aiQyze5jDyGUQuvrAXc/WrDJxVllN6WbP19N5hiH8bOLk+fRCfOStHocM+ojNxps/C1+KJEG1KQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc314df-435c-45ef-4628-08d8618655aa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 19:08:06.6778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WdyaGLo3RxVZIux3wfN+PHvkaz+ltdUfLBueUGgnbeiA9xA9UVO3MZaQJ+kgC4W8UF6qs716ZBHGJ27KinzAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1835
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/25/20 2:03 PM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> This patch series provides support for launching an SEV-ES guest.
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
> performed. SEV-ES also requires the use of the in-kernel irqchip support
> in order to minimize the changes required to Qemu to support AP booting.
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

Sorry, forgot to update this part...

These patches are based on commit:
1bd5556f66 ("Merge remote-tracking branch 'remotes/kraxel/tags/audio-20200923-pull-request' into staging")

Thanks,
Tom

> 
> A version of the tree can be found at:
> https://github.com/AMDESE/qemu/tree/sev-es-v12
> 
> Changes since v3:
> - Use the QemuUUID structure for GUID definitions
> - Use SEV-ES policy bit definition from target/i386/sev_i386.h
> - Update SMM support to a per-VM check in order to check SMM capability
>    at the VM level since SEV-ES guests don't currently support SMM
> - Make the CPU resettable check an arch-specific check
> 
> Changes since v2:
> - Add in-kernel irqchip requirement for SEV-ES guests
> 
> Changes since v1:
> - Fixed checkpatch.pl errors/warnings
> 
> Tom Lendacky (6):
>    sev/i386: Add initial support for SEV-ES
>    sev/i386: Require in-kernel irqchip support for SEV-ES guests
>    sev/i386: Allow AP booting under SEV-ES
>    sev/i386: Don't allow a system reset under an SEV-ES guest
>    kvm/i386: Use a per-VM check for SMM capability
>    sev/i386: Enable an SEV-ES guest based on SEV policy
> 
>   accel/kvm/kvm-all.c       |  69 ++++++++++++++++++++++++
>   accel/stubs/kvm-stub.c    |   5 ++
>   hw/i386/pc_sysfw.c        |  10 +++-
>   include/sysemu/cpus.h     |   2 +
>   include/sysemu/hw_accel.h |   5 ++
>   include/sysemu/kvm.h      |  26 +++++++++
>   include/sysemu/sev.h      |   3 ++
>   softmmu/cpus.c            |   5 ++
>   softmmu/vl.c              |   5 +-
>   target/arm/kvm.c          |   5 ++
>   target/i386/cpu.c         |   1 +
>   target/i386/kvm.c         |  10 +++-
>   target/i386/sev-stub.c    |   5 ++
>   target/i386/sev.c         | 109 +++++++++++++++++++++++++++++++++++++-
>   target/i386/sev_i386.h    |   1 +
>   target/mips/kvm.c         |   5 ++
>   target/ppc/kvm.c          |   5 ++
>   target/s390x/kvm.c        |   5 ++
>   18 files changed, 271 insertions(+), 5 deletions(-)
> 
