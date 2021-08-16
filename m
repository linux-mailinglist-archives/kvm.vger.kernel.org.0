Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134333ED74A
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbhHPNat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:30:49 -0400
Received: from mail-dm3nam07on2077.outbound.protection.outlook.com ([40.107.95.77]:57472
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240474AbhHPN0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:26:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUQczqWGxXhExENzQbGuq7JrkdbbF2yH6kO0AlLs4YcgFteVRHhOogKhyuSmMgZCMN47a91ml6T+9/0db0OruuWiMC+8bAtG58grwDX99UeYaa7fRbEmXvQ4s8YuDnnoy7Pn6L5Z5UXqCK8NhryxCr3JKh/7d73tU/GDeruQJyX0OWU6SUW4bqa/4jlR6AAr6C/cVZYvvk018hRb3X8jX84ErrZk0ho3Uv53i+i5LmmJfwMWFSdDTeGi63UgwbFrL2OYI3UdlA3xdGUIemy+lIIYeJbcgJa8yY+qJWpRi76AagRzdU5DqtLzOPKQI/Zi+DkQ8j7EwQC0rKJPnXZjfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPsE+CAJ8BpubbRHi4IHFilhxdQ6OFF47jM4PPFPZRs=;
 b=TDhwazkbVjpjYCXtXaIdLt8tFUJSZ93K3yZ+WqvP8AeRdBmFzPJj7VoTL9zXoH6nhDSFkyfGV/cNH0WnLzr2Avv9dKIslAsjrbVJ68R/spfYdvJog27teGkOE6ES0YacJ6z5zy1laaK7g08PeWhWpPTQ9MxbXM6JwhowHgHR9ALrj1ZjgHue9lu6xMXBFNHwRuiNsEHZVSRCSbTNpQSbNR96F4WKnJfxj6lvB2PqxYHPCflCLkNJNwVwRQx3Ku5eMV2taJJYzO2/55RUc1/dRKI4MAxP1Xab7o8QlZlMxZJsXTYTBozuxuUte1h5BqT2M+ps2FNGx9Qaw00Qk830dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPsE+CAJ8BpubbRHi4IHFilhxdQ6OFF47jM4PPFPZRs=;
 b=ui0UAmKQUzyvucA2U+4xqFADAQFCVdQaDQ+TD1goMLOYsPHmCtNLBw1WLWw74I/oOyEul05dAdsN1gPOnnk2hSSvty0HFQMEAab56r2EfrMCICM0gK4jIGrsPRrTDQK7Kshqntu/bRQ1NEYtv7gqszaQWsHtMwOQGrpnj96UASE=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 13:25:52 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:25:52 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 00/13] Add support for Mirror VM.
Date:   Mon, 16 Aug 2021 13:25:38 +0000
Message-Id: <cover.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0069.namprd16.prod.outlook.com
 (2603:10b6:805:ca::46) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0069.namprd16.prod.outlook.com (2603:10b6:805:ca::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Mon, 16 Aug 2021 13:25:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2bf5e84-31f8-47d5-3e50-08d960b95e50
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44468F1FB589BC82EEEEB0788EFD9@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+vmgym34LKFs7GUor9U6jWdkivIzYiN5dYINZJ8oOm5FgtU3KZoB6AB6m15cpeYoJ52jGdqyVL0gedw8gNDZYoE3fIVLT0ckKYs9xzXszCxonF4NEraAX/S8ByGbY6BN1xnkKDnqR8TN77ZkWmLGkNQ/SX5J0NRHl502Yrr0rlRa/jSNe+dtdrR5JAqToqrEgoaSLI4imccl8LA7vimI8TBGiK+HUUUSbC7ivPHDz5DQKrQ6/QAKu5AWknJhvgnJpTGFRW1b4hfa6PlBUxe+4xfuEOkRg551T8SrzoRfEl6zWMTkhj17HjKQBcQxlF9Y7/xoCk5VcSABIeUpl+2PJrocY5dO+quAN3kuqRg4LQzX+f59xfWwqs2tunGoPzk/9S5Ujc1OP/q+poXPO5adOnno9gObo71ZP583A/caBHgoZLiD0AELbmMu15eMGCoCl8sV5x49pTSIAvO8Y5r2aTF26L1Nfh6uuFzsYP61g88muFlDNmerbBsotLvFnm5QPquFiRMR4CuFlPdWkSMmcDyQ3AhJJCcAwY5SbmWIwojCL5T3Ug0yi8S33yTVzeXds6AxBY0wvuHXGFvMFD0KVoBmQGLX5KMxBuAJUtuOjPKoKPPYPOq54b8HZkFexxPk/r7d/EDclmnKcEAChX1qnWQUWQy5u/Uw6CdZnH7r9BPCirNYt5xY0idqWlQvky/1fj+j7apZMdIhiqgaFHj9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(66476007)(6666004)(66946007)(86362001)(7696005)(52116002)(316002)(66556008)(4326008)(83380400001)(956004)(186003)(2616005)(478600001)(36756003)(26005)(7416002)(8936002)(6486002)(38350700002)(38100700002)(6916009)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wG+IJqtooep3VhaZXfCxOV8ZMtl0O8bjXi/2R8T6sD0W0fMoEFa+wPsxiu7Y?=
 =?us-ascii?Q?/yNZ/s2+SSo+W2LNf4ZzL40lPZ4FvveAj8OqMA6S63kZnRiL0AU3rKhYU3VH?=
 =?us-ascii?Q?jPLyUGCqYfUlPrUNq6vQ/lrFXB0Y5jRJg+TUOXjRVkFrQxgb35ZtbVCdSbto?=
 =?us-ascii?Q?3XUR7Zzvf9aqbSqAp+Z7uCCUTyIf2ARD9I9t5PxaMomYyEaZ4CuvuT3xCSqT?=
 =?us-ascii?Q?Mgv5zbiCBtzGoRlnQujm61qLkXAYtgVVx9QfFSxJDHeNYhfyr1Sls69kia+V?=
 =?us-ascii?Q?Y+MgQqXkhgnnDFlrUeH+y57Jv5eMwYpKeyjAp7TFaIDbO1XYK0yjU48ZKogu?=
 =?us-ascii?Q?jzQHAusPN2qWq3fvcXjq31U3JcW3MHEXukata3SCl+aU/8F7FWJ1D2k33UXh?=
 =?us-ascii?Q?t13a7KfE+YqhIzCid2Q4JyvFL8evsSNPVutzMgAvbUydCiXGalUv+ZQitJRO?=
 =?us-ascii?Q?9fxydPlYDxdgWrsISHcQxN+AQXtW+vTHJQxDI2B2Xth7MvgCDBMAG49rXqWz?=
 =?us-ascii?Q?rZwMIptYPeI2eG31Pz11TsQdp+jPPFK3SxlUUhVaTm05ZQlL6XHfqt5VLjJM?=
 =?us-ascii?Q?I5tuwedgw8nE9BxTfdTByg/fAZNc5jJQ0rJls2JTXx5NJ+g79WKWTRNPq7+b?=
 =?us-ascii?Q?W3P0afLpViDeIja80jvowNpx334htks7xQA67h5WsDvolpVRdwq94IN9iyf1?=
 =?us-ascii?Q?w8rM4B0Gh8Ocy+guzlOy1/0fGOLwy+BPMeIxh47VIxczvMYNxeHLnIwAHp5n?=
 =?us-ascii?Q?gYFuI6+rLup8OCu2FsCFqKOh4yQBg+MKzv2R0aO5gQhSgwWULfGytfmNemSR?=
 =?us-ascii?Q?9/IwMwh8w9YjcF9zcgrJ5sIcEc79Ui7JOR+AzuioS1mUrN6q4rwyr9CggS7t?=
 =?us-ascii?Q?97BeKZzTWZLbLHCV2q0uIvn9oeVAxor+/GrZXHbDrm4UGWgnqhBk6DJOziVW?=
 =?us-ascii?Q?Hc2283QMtj92Ct48tLBda0zEUK1ewJA0aLSYfoUNw5ugz4xfQVxqmoVZahep?=
 =?us-ascii?Q?Do97waunH9TojJ82GnVGMqU5N9cFo8RNMsNVSXtr5PNIHXWZqCenpkBrBg+x?=
 =?us-ascii?Q?6DKnij0o/aya4KdHBkTlai1lKK5hZ/ByqhXVOBY27Y6wVCzMkjljKTAavErN?=
 =?us-ascii?Q?MU5XX7C7b/GOetHcDTpe1ym40EJNZhP/raV7+cFh8H4WZJ/jzOReAO9/cCxw?=
 =?us-ascii?Q?ELlkEpQOcCQQK+IwuwNKvdRkDB8QdQW0lRFgtrY6f71AOjm1zeLKv06rbI6E?=
 =?us-ascii?Q?8XAp9l8njpL1w+WUAzEQ7ozbUJssHGl9HUE48rLgZ9GFe2xPkJe/iHBUC6Kq?=
 =?us-ascii?Q?sBZfgz+LrVZvgsNegS41hzTJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2bf5e84-31f8-47d5-3e50-08d960b95e50
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:25:51.9008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLrp5mjbXkgT+Jo1ZrIKiFelOreoVYATrCIN2ewQqsIJOesIDAmxlt/HisrfBp9IFXZpXyin8K5LJZ1H97AjnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

This is an RFC series for Mirror VM support that are 
essentially secondary VMs sharing the encryption context 
(ASID) with a primary VM. The patch-set creates a new 
VM and shares the primary VM's encryption context
with it using the KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability.
The mirror VM uses a separate pair of VM + vCPU file 
descriptors and also uses a simplified KVM run loop, 
for example, it does not support any interrupt vmexit's. etc.
Currently the mirror VM shares the address space of the
primary VM. 

The mirror VM can be used for running an in-guest migration 
helper (MH). It also might have future uses for other in-guest
operations.

The mirror VM support is enabled by adding a mirrorvcpus=N
suboption to -smp, which also designates a few vcpus (normally 1)
to the mirror VM.

Example usage for starting a 4-vcpu guest, of which 1 vcpu is marked as
mirror vcpu.

    qemu-system-x86_64 -smp 4,mirrorvcpus=1 ...

Ashish Kalra (7):
  kvm: Add Mirror VM ioctl and enable cap interfaces.
  kvm: Add Mirror VM support.
  kvm: create Mirror VM and share primary VM's encryption context.
  softmmu/cpu: Skip mirror vcpu's for pause, resume and synchronization.
  kvm/apic: Disable in-kernel APIC support for mirror vcpu's.
  hw/acpi: disable modern CPU hotplug interface for mirror vcpu's
  hw/i386/pc: reduce fw_cfg boot cpu count taking into account mirror
    vcpu's.

Dov Murik (5):
  machine: Add mirrorvcpus=N suboption to -smp
  hw/boards: Add mirror_vcpu flag to CPUArchId
  hw/i386: Mark mirror vcpus in possible_cpus
  cpu: Add boolean mirror_vcpu field to CPUState
  hw/i386: Set CPUState.mirror_vcpu=true for mirror vcpus

Tobin Feldman-Fitzthum (1):
  hw/acpi: Don't include mirror vcpus in ACPI tables

 accel/kvm/kvm-accel-ops.c |  45 ++++++-
 accel/kvm/kvm-all.c       | 244 +++++++++++++++++++++++++++++++++++++-
 accel/kvm/kvm-cpus.h      |   2 +
 hw/acpi/cpu.c             |  21 +++-
 hw/core/cpu-common.c      |   1 +
 hw/core/machine.c         |   7 ++
 hw/i386/acpi-build.c      |   5 +
 hw/i386/acpi-common.c     |   5 +
 hw/i386/kvm/apic.c        |  15 +++
 hw/i386/pc.c              |  10 ++
 hw/i386/x86.c             |  11 +-
 include/hw/acpi/cpu.h     |   1 +
 include/hw/boards.h       |   3 +
 include/hw/core/cpu.h     |   3 +
 include/hw/i386/x86.h     |   3 +-
 include/sysemu/kvm.h      |  15 +++
 qapi/machine.json         |   5 +-
 softmmu/cpus.c            |  27 +++++
 softmmu/vl.c              |   3 +
 target/i386/kvm/kvm.c     |  42 +++++++
 20 files changed, 459 insertions(+), 9 deletions(-)

-- 
2.17.1

