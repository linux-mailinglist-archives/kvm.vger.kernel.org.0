Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1FC2F6ED2
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 00:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730705AbhANXNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 18:13:49 -0500
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:1122
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730612AbhANXNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 18:13:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeFJtDwSozk7CfFUcXjqPPWq6USUNiOC1srMgYADskb228TPa7aCT4HTfnN/BMzNY2YHTymqQ9+0TpHSCEC96XRKFsA2ctwwUsnM5ojQaV0HPmFlDtHL5Atbk1h8lYn4YZMUKlXfKx4Tlmw29c6BrmHENoEOAfpFNOLXSgu5/oLLyvy3mGfbBKiiA5h+Gjkmlst5F6KTZax69bVulmWkoy8UzUoLwhNiIPrJcD6QATjowvj/ndW7d4xNZkOVM/OQGsg995NBMn0OZYJDQP17DhqtMuLiYSC8EJ2bUtV2Qc2MiN+Dl1L+4rcMb9Mh8Ytj6le2mO7wDyqzHY/lBPNH3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lz5fiaGYZ0gKhXgobY+++B5QfpHjelVGky8cVvyGyYU=;
 b=TDsaqpszzu5J1StpUuYNY8avbR28ODKQ73fwDKgMFHUnlSrPDMttHG9W4rp/xPb0VzdNcsN7Ao7yBLQvHsVguGMrjzZfJ00d521ri0VDdpqBkhvj0HyVJ8fZ7+MTuY2eLyfaNgdQ4xjxr5K8I8Bg0hfsy3wAzkFHmo0Jg/iZ/+Adso5J97uZPjtN7E6yXzKhaf6SWad3DjshY0vcwTrI4WhcTSFBRre2WCbM63hBIik7pWyFK5bkfEvEjwjg/53/lB8Ua/mh3gtD2t+jMKbVVSjB2OAOHtB4sSXcvNgy7Gcvk/Upvglw6kfbWjpYWD0GvQE2bXUw6TDdgR98yy0s5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lz5fiaGYZ0gKhXgobY+++B5QfpHjelVGky8cVvyGyYU=;
 b=l7+WW0I3EWlHGpzeZJaHYsfVlpEFOq28IxrZeZLdbluJOxDgFWfdUCt4WgjN7aJpp7K7kUg2rzVWEy6Gc5Cs9k+AVvadvrHeNxVxUUBwcOBSuGefoR1v89jjzrbnPgqj68b9HrGQUghAbbuUaY5wx0tRRXI/D8fHzHBr3qAZhLA=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2503.namprd12.prod.outlook.com (2603:10b6:4:b2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 23:12:49 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 23:12:49 +0000
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
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v5 0/6] Qemu SEV-ES guest support
Date:   Thu, 14 Jan 2021 17:12:30 -0600
Message-Id: <cover.1610665956.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0096.namprd05.prod.outlook.com
 (2603:10b6:803:22::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0096.namprd05.prod.outlook.com (2603:10b6:803:22::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Thu, 14 Jan 2021 23:12:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed26286a-80da-47d6-0f33-08d8b8e1e96c
X-MS-TrafficTypeDiagnostic: DM5PR12MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB250357E4FD879031FC08A4CDECA80@DM5PR12MB2503.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bvf/g2QD4i7fWdBaCbmLw9OO8RTn7JrPEcBn9HjNQz9Ls/SwZBU4oQl8CTDE8uPCgU92E0of8N68XfgKqV+EotQegY6AhKZx1v2U8MzzjvWcfnSZ2UjzuMCVAfkmZZQ5kIG5t4sIdVpZIscUQcvcultkPPgJ0z048TeVshSMnCsw4EEOkxejcvkz0fwG50+vd0brYvbUPqcWqRJ8XNamvEakkEnQGNBbhUDYUBlCQOOL0piEuJZbAH94UeXNuXDVKHV1D/6uWHCJ5YcMPxwxXxB7uOwsYjSLCKoH2Eb2vE7xcR26VZmSOuQe3mjk89xxYu0UqQ/gPvJsQKAUcqxglLbiH6O7B7YSF/xd+A4HrjyKxDu8rgg831O58rkd+aPysOG93Xkw6o31qmjq7RfnnmKb+DADZAIyKw2aWvbp39zNmJ9qb6k1sbjvbB96meEjs+6cqmm3M8+R5laChqSsyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(8936002)(54906003)(186003)(6666004)(6486002)(16526019)(86362001)(7696005)(956004)(66476007)(66556008)(52116002)(316002)(5660300002)(7416002)(966005)(2616005)(4326008)(36756003)(26005)(478600001)(83380400001)(2906002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fQ7MnSfdcv3AirXNJ2nyfjKIVXWBBw8BlbGitRwgU9EmAgiGBJcHDeajP0j/?=
 =?us-ascii?Q?0C1xKS6LwDr8+FkaHPBSre9Y4YtYaj/CYf769zLSUNhdDMILkqaQIU23/UEg?=
 =?us-ascii?Q?tqAuSxpSrh0rXMldG2rMfkkx2x8vymWybWcSX7N1TBVhyEz173TC/q9HhfS+?=
 =?us-ascii?Q?ukzStKZ73bBP+gUelEYrGhyrxdJJNRA1LhKuYhR0BcQWWRv8fM1CgOaY57zQ?=
 =?us-ascii?Q?MSiJ0H5jIESE+S0lajVdZuMkGYpx/azXqEq2x8CKAH+4lLjLdZAyaI9iz2FX?=
 =?us-ascii?Q?prOWh4esnR5N0LFsJzwkgTWF8PVfcTMz76ZqWGI0xn5sYJWMWBPw/kBh3+GV?=
 =?us-ascii?Q?ah2R//HfNfhdU7SFjfyXVULS6M24ml6JyXjccN5JyVBvecWiJJjpUqOoLvsB?=
 =?us-ascii?Q?vOB6IPoAqrp6kTCcgK8GCPkmn6fIL+flZNhahyvxv5Fg7nS8DJq7XQuNda0T?=
 =?us-ascii?Q?fuAi1gRG7DdSbRGue/OAQOMGpEVQlxVvkN1y4FZnr6Nt6WMgP0tq1wi7Y73S?=
 =?us-ascii?Q?/t8gQ+XYWzDb73vSMmO6wvYWlGFAHym5OgKNznS1KFkeIf2xxtntZZmLWHYO?=
 =?us-ascii?Q?7DYtqVeI8HIRpjE6ueuBvKEwLnf/N0SV06S19n7sb55enHnT/q7G98+fzwlw?=
 =?us-ascii?Q?Vl6ggkQQd0F1v08oTkZcbPzh0WgqorMp3v4Ip0Et0nMySghec2I+90Z/kjyR?=
 =?us-ascii?Q?J4GX87RHRRnm25+fY0xYjJKVGN0B/eIg4GvehmgII9PhDTtGXKQLJIf7rAU7?=
 =?us-ascii?Q?LhqnCV/QFDlBMPTcbduQ35XDajyYdKa0retFqHksb9nFJVEWuipdj6K1RwVf?=
 =?us-ascii?Q?QAfaQjqlMe0KmiVkDaMLDtrL5L4QOjwW8vqh0lMhBPJBAcRc4kFoRGjDXGW5?=
 =?us-ascii?Q?1k1cIBhOgZc2NdN7v6Endr8RtyfVbQAl2g//S4HgeJsz6tE3BeHlKr/VjBnM?=
 =?us-ascii?Q?bNxAE8ytOv1WUjirku1PZ5Ym/93zhtdbNBDmBE5LWRKWmhHEjRvVHBilgPPT?=
 =?us-ascii?Q?3IaI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 23:12:49.4961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: ed26286a-80da-47d6-0f33-08d8b8e1e96c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Mrl/Un13Dqcb8DQ5ewO3/jJ62lqlJVS2wJ5tREnGVap74wKVA/R3J1XFN1smrkPbFMT27Ukag1u3YSBN5v4BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This patch series provides support for launching an SEV-ES guest.

Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
SEV support to protect the guest register state from the hypervisor. See
"AMD64 Architecture Programmer's Manual Volume 2: System Programming",
section "15.35 Encrypted State (SEV-ES)" [1].

In order to allow a hypervisor to perform functions on behalf of a guest,
there is architectural support for notifying a guest's operating system
when certain types of VMEXITs are about to occur. This allows the guest to
selectively share information with the hypervisor to satisfy the requested
function. The notification is performed using a new exception, the VMM
Communication exception (#VC). The information is shared through the
Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
The GHCB format and the protocol for using it is documented in "SEV-ES
Guest-Hypervisor Communication Block Standardization" [2].

The main areas of the Qemu code that are updated to support SEV-ES are
around the SEV guest launch process and AP booting in order to support
booting multiple vCPUs.

There are no new command line switches required. Instead, the desire for
SEV-ES is presented using the SEV policy object. Bit 2 of the SEV policy
object indicates that SEV-ES is required.

The SEV launch process is updated in two ways. The first is that a the
KVM_SEV_ES_INIT ioctl is used to initialize the guest instead of the
standard KVM_SEV_INIT ioctl. The second is that before the SEV launch
measurement is calculated, the LAUNCH_UPDATE_VMSA SEV API is invoked for
each vCPU that Qemu has created. Once the LAUNCH_UPDATE_VMSA API has been
invoked, no direct changes to the guest register state can be made.

AP booting poses some interesting challenges. The INIT-SIPI-SIPI sequence
is typically used to boot the APs. However, the hypervisor is not allowed
to update the guest registers. For the APs, the reset vector must be known
in advance. An OVMF method to provide a known reset vector address exists
by providing an SEV information block, identified by UUID, near the end of
the firmware [3]. OVMF will program the jump to the actual reset vector in
this area of memory. Since the memory location is known in advance, an AP
can be created with the known reset vector address as its starting CS:IP.
The GHCB document [2] talks about how SMP booting under SEV-ES is
performed. SEV-ES also requires the use of the in-kernel irqchip support
in order to minimize the changes required to Qemu to support AP booting.

[1] https://www.amd.com/system/files/TechDocs/24593.pdf
[2] https://developer.amd.com/wp-content/resources/56421.pdf
[3] 30937f2f98c4 ("OvmfPkg: Use the SEV-ES work area for the SEV-ES AP reset vector")
    https://github.com/tianocore/edk2/commit/30937f2f98c42496f2f143fe8374ae7f7e684847

Cc: Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
Cc: Aurelien Jarno <aurelien@aurel32.net>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Richard Henderson <richard.henderson@linaro.org>

---

These patches are based on commit:
7c79721606 ("Merge remote-tracking branch 'remotes/rth-gitlab/tags/pull-tcg-20210113' into staging")

Additionally, these patches pre-req the following patch series that has
not yet been accepted into the Qemu tree:

[PATCH v2 0/2] sev: enable secret injection to a self described area in OVMF
  https://lore.kernel.org/qemu-devel/20201214154429.11023-1-jejb@linux.ibm.com/

A version of the tree can be found at:
https://github.com/AMDESE/qemu/tree/sev-es-v13

Changes since v4:
- Add support for an updated Firmware GUID table implementation, that
  is now present in OVMF SEV-ES firmware, when searching for the reset
  vector information. The code will check for the new implementation
  first, followed by the original implementation to maintain backward
  compatibility.

Changes since v3:
- Use the QemuUUID structure for GUID definitions
- Use SEV-ES policy bit definition from target/i386/sev_i386.h
- Update SMM support to a per-VM check in order to check SMM capability
  at the VM level since SEV-ES guests don't currently support SMM
- Make the CPU resettable check an arch-specific check

Changes since v2:
- Add in-kernel irqchip requirement for SEV-ES guests

Changes since v1:
- Fixed checkpatch.pl errors/warnings

Tom Lendacky (6):
  sev/i386: Add initial support for SEV-ES
  sev/i386: Require in-kernel irqchip support for SEV-ES guests
  sev/i386: Allow AP booting under SEV-ES
  sev/i386: Don't allow a system reset under an SEV-ES guest
  kvm/i386: Use a per-VM check for SMM capability
  sev/i386: Enable an SEV-ES guest based on SEV policy

 accel/kvm/kvm-all.c       |  69 +++++++++++++++++++++
 accel/stubs/kvm-stub.c    |   5 ++
 hw/i386/pc_sysfw.c        |  10 ++-
 include/sysemu/cpus.h     |   2 +
 include/sysemu/hw_accel.h |   5 ++
 include/sysemu/kvm.h      |  26 ++++++++
 include/sysemu/sev.h      |   3 +
 softmmu/cpus.c            |   5 ++
 softmmu/runstate.c        |   7 ++-
 target/arm/kvm.c          |   5 ++
 target/i386/cpu.c         |   1 +
 target/i386/kvm/kvm.c     |  10 ++-
 target/i386/sev-stub.c    |   6 ++
 target/i386/sev.c         | 124 +++++++++++++++++++++++++++++++++++++-
 target/i386/sev_i386.h    |   1 +
 target/mips/kvm.c         |   5 ++
 target/ppc/kvm.c          |   5 ++
 target/s390x/kvm.c        |   5 ++
 18 files changed, 288 insertions(+), 6 deletions(-)

-- 
2.30.0

