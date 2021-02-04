Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF69630CAE9
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbhBBTFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:05:00 -0500
Received: from mail-mw2nam12hn2242.outbound.protection.outlook.com ([52.100.167.242]:26593
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239398AbhBBTCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:02:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RT3Kpnut13EWImlL+reOFF3ffo5bpr7wkYi9xJ1kflOybAA0pEcQa3iESi9qpZSi0VqpcSn1RM70s0R7cn2sHTslz2zaYd3Vdxi14qJwTwBBHUYYs7Zz3dskz/kSmeYUTTpJcKGX4hSwmxZF3TDPX1WUeo8q7OEnaM53JPUmK3qJvrcrlKq94SKzX389d4av/AjYCBGKPOaWaBTmMNgDHqjBSqirhYJv5X0EuJvG9eUkCDRW3HRDKDeclHnQYskD2lmb8tNoIR0kgT5gdxdl+uWqcO/G/KFMqzCHjDiQ1NBVUrLR0HKtJXaC41OIomxk+8eTiaZHLTp9V+Mtr0baTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tg4DLzk/v5vHwbO0FrMeFu/54LmErVdbGkbAaUud/2Q=;
 b=KXqukssISv+b3RAYpyk9zZMjrGGp/UicBg0l5T07hjCMpmB5nLcCQACyfUi6rr7NgJ9nL4Cr641/rDGHqPwitw8+txHDarsC0Y/O/bV57tkYXIO1t+Ae32l/eQIi9bvSHeWM2bhcLudep/sqwwe+QwTzpXwqQDIZ9WkhgRuawccRZ29OLzXYBH3Z7fOa5fxzdPGsHwUKBGO2SvvWCuxOSCcudZhmUITG7TZ5kXRX5STpZAI/PCS0mxuZXtchZ6W1RHvp5npQq/Fi8GEcuV+xQjyWmdHF+VWjlLgtP4dKbtq7U8oF2obzjmStLMeQE01e4qISaKVkvFgkToGqApiduw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tg4DLzk/v5vHwbO0FrMeFu/54LmErVdbGkbAaUud/2Q=;
 b=o6YL/mzqcSFml+yj0HaU812UVlU8Hjd7zcmAC504OSxwIil02VsZJJ00VEbI35QvNdJ1qX43bZq5LCh6dwsf4oHzl/oyUVgphbZa7XeF9vJsNm912IczGSOhdetjKxT45SlfOggKEt+SNk29jlU/FBtdrTaMDVhdR5km2uF+QVg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4264.namprd12.prod.outlook.com (2603:10b6:610:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Tue, 2 Feb
 2021 19:01:57 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 19:01:57 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] KVM: SVM: Refactor vcpu_load/put to use vmload/vmsave for host state
Date:   Tue,  2 Feb 2021 13:01:23 -0600
Message-Id: <20210202190126.2185715-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.78.25]
X-ClientProxiedBy: SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14)
 To CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.78.25) by SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Tue, 2 Feb 2021 19:01:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 902c6264-e04e-4990-e841-08d8c7ad03a3
X-MS-TrafficTypeDiagnostic: CH2PR12MB4264:
X-Microsoft-Antispam-PRVS: <CH2PR12MB426428A737A551BD7D24D03595B59@CH2PR12MB4264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?X95fdZM6c4oB0Cs9qOjGLFYjzgdDkrZu1JyIUDUXkq4EwMmU//F7jyI9xDtw?=
 =?us-ascii?Q?qBrWcIMJWjiKACRMGhw+YK7gAYH96xIey1KyAzXWt/xzDYNsU1ig7QgaiGg9?=
 =?us-ascii?Q?bzwN2cX9dY+Z9OrA9qLODSJAKn6j3zWyVh6VkY0nalcfp8X1vXwvC6ZazO1o?=
 =?us-ascii?Q?vFqFWVKYmUeclfCGbNVBC/oUtgrOckVp5IMN26SxL9K0CIfXD3DqyT9TNWEA?=
 =?us-ascii?Q?dVs6NBSjllQvw22sNcoOCw7GHkMSo6cBEfiXJaHY2d1BBrVA/+b3yJnYb0yl?=
 =?us-ascii?Q?mi8Mt5+VLPGE89SSjMTPG8C2DRxKxfhkK2CJDJMtTWXTQ4RLKkK4TGFGNt+Y?=
 =?us-ascii?Q?xx5TGsVge/Td5y9kAlKIfwWFGdQ8l3h1+RxWL2azsfz9p9htvWfynGMb/ZLu?=
 =?us-ascii?Q?M7yZBrlEg+9oTgB7zllYwtyrxi15vIXxftlr+IP4Wa2gUN30jPClJTonUyHF?=
 =?us-ascii?Q?O8jv55QsSxSahOfAPw2YyJ+rhL31L0E0H202HzK86a1VfSt9s4TLiQZXh3YA?=
 =?us-ascii?Q?CP6gaHnD3trT+VyyaSe6ksfGOP6PtRzox7AQzdphi6jai/7d/9ZA1C3cbVWX?=
 =?us-ascii?Q?16TkVLdTSuCv55QxSgFNbz/jMxESrQ3V01iMt5chg0awdFHO6tmXdoPqubd/?=
 =?us-ascii?Q?J7bRqTcn211Z0n5VckNWGumOiX+qmR3mn8AXRNE87sVAydzUoBxylvJ8o/vw?=
 =?us-ascii?Q?zBBViG0R+hK8mAyDF6Xt4kc8tg8YmfXFeh7DsYTycYE26+5hdQ4oN0FlOcAb?=
 =?us-ascii?Q?MQXXJkZILfUU4erYhsPbF7k7cS87AE88fycRgwVwUxyADRVx/bwbf/sUr1Bc?=
 =?us-ascii?Q?ewTjVgWDXRd9830lbabTpGJlpcUiXSs7/FDbQaaMm5mqoJ1GY7dNa84cteMq?=
 =?us-ascii?Q?lV6JSKqTiMsoBr2DwEcm16wmA4gfShwfIENK3tCANZNAQWP3aAdvYrwYTk3J?=
 =?us-ascii?Q?fkOmDV8A1TuJYAZoL732dQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(186003)(6666004)(16526019)(66476007)(66556008)(2616005)(956004)(36756003)(8936002)(44832011)(26005)(2906002)(54906003)(83380400001)(86362001)(478600001)(8676002)(966005)(6916009)(7416002)(1076003)(6486002)(52116002)(4326008)(5660300002)(66946007)(6496006)(316002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pNsf4GPWuVjbb58olpTLMKDoVJkh3Cn/SoMeSHb3Cq6G3/xzhatkTtY3/zbt?=
 =?us-ascii?Q?nNcNCRoGmDAgmtChx8u8A3dEEbvt3Aux4Ncn1oebOObof4YUB2IApoajrfMh?=
 =?us-ascii?Q?A3FeY55WQtSlW1kv2IaRIaPJAIfRyHccEjVQYBuGgdmG9K21f/H85hlekp/p?=
 =?us-ascii?Q?IWDmAv3DHFE7iKN1kmqNE3JUb/rTkZdKW6mqG+iYKXw0VVfY3Nou6aat09rr?=
 =?us-ascii?Q?hb/uJN0LGAVX9eQhimwdSb/ftx6lhPPa4h/MToKRusRQ1IR/HJbPBx2E1IXH?=
 =?us-ascii?Q?+3j76KeDNdEJJfZsFnDDBOUYkFg8r5K4ve6uo1DmNqNk8JE7y1K/2PREcPgv?=
 =?us-ascii?Q?zoFdfRGwReTvw1XmSEHe4h2FoddFSGuqsHeRJMn8Rw4qN8VXh5WoooBBGhxe?=
 =?us-ascii?Q?P2Erovu/bueoYHsr3E1wExXwv7GurUeqEFR6oDatPKpXJMRm2owqk0ta+hMU?=
 =?us-ascii?Q?iFx+h7183nWLnfFQuULeL/KYYsV5frCmdxUGHlqeSmTr0GLz7T8HmzJXqoLh?=
 =?us-ascii?Q?jv+chxyy1LY7y7NfLYIJmwEPE5szXVp4MVkPIbskLL4WqwmJrRijAyfvic/j?=
 =?us-ascii?Q?qdrPqTU8663hyabDYhEze1hoxC2Ar8ldM24uVOTVMkdNbCnhfs6u/ZMFlyfF?=
 =?us-ascii?Q?C+C/WvavP4DO1vM8LSPN8+Rqynh1sDTH1urDEQvg739hD93NtsQDztAwtI7j?=
 =?us-ascii?Q?45oALELP4qaA4uyCSxHa9R85kgn7feOVdHMa+yfPpnLg5ExUv+Cyi/HEZrvn?=
 =?us-ascii?Q?TtipX4j4hg0NIO4wRH9o4Fo9EvqgoZ/es6/XruEGuLvScQoLeAVKsLLKY1Xf?=
 =?us-ascii?Q?MT3lRgSomMSBMbIUO1Ml6NC20QZ0e75cGJ+wRTs6GC8Lp4nAbGKezFpZ+/Pq?=
 =?us-ascii?Q?/Ojc+i9Hg6tGcxA9+bdAh4jWXxuUtgMIuzxn1mwmEnXrfXXxtc1mK/9pGour?=
 =?us-ascii?Q?aiaCTTiA7Dy0spRtrtkACE7aR7I20pKBRcygh5ZJY7kg8SxqM2/imSt9n5eX?=
 =?us-ascii?Q?yLMZW1GDKz5RcEQjtAUkxTzr6vT9HA2oQ5WrR/4ieH78cKioecPNLchNKsha?=
 =?us-ascii?Q?rJ2yL8acWt3n/L9ADKFi36MB1HUq1gA+B+YTPXU7MGdgoyBjvG/qzTGxn7ba?=
 =?us-ascii?Q?mxv7WhJzwFZkR7yYaB6WUsoPo14cQ83SvQ46gNKi1vZW9MHY6tAc4fPmpd60?=
 =?us-ascii?Q?P3bIlcthrYHtsudx8IMoFt5i7okInRQADapw+l55mtjutMXjWTT3sHuRcOsE?=
 =?us-ascii?Q?Ec1nz84SJ44Ujgv9SNH/D+6IwYbxo92UsoGZ9s/BaGTa5ETTLZBLwWdFBEdg?=
 =?us-ascii?Q?Xq+rfusFYOLHEcjRVAdBB8hG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 902c6264-e04e-4990-e841-08d8c7ad03a3
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 19:01:57.8174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tht62JEYPw/S+MS/K/U2ulGlB8NCvOKByIaZzzvIQbyf6ZpzPkdkkV9FtDBN6m/CNCfV5HSVYuTgLBiXUszDeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4264
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean, Paolo,

Following up from previous v3 discussion:

  https://lore.kernel.org/kvm/X%2FSfw15OWarseivB@google.com/

I got bit in internal testing by a bug in v3 of this series that Sean had
already pointed out in v3 comments, so I thought it might be good to go
ahead and send a v4 with those fixes included. I also saw that Sean's vmsave
helpers are now in kvm/queue, so I've rebased these on top of those, and
made use of the new vmsave/vmload helpers:

  https://lore.kernel.org/kvm/8880fedc-14aa-1f14-b87b-118ebe0932a2@redhat.com/

Thanks!

-Mike

= Overview =

This series re-works the SVM KVM implementation to use vmload/vmsave to
handle saving/restoring additional host MSRs rather than explicit MSR
read/writes, resulting in a significant performance improvement for some
specific workloads and simplifying some of the save/load code (PATCH 1).

With those changes some commonalities emerge between SEV-ES and normal
vcpu_load/vcpu_put paths, which we then take advantage of to share more code,
as well as refactor them in a way that more closely aligns with the VMX
implementation (PATCH 2 and 3).

v4:
 - rebased on kvm/queue
 - use sme_page_pa() when accessing save area (Sean)
 - make sure vmload during host reboot is handled (Sean)
 - introduce vmload() helper like we have with vmsave(), use that instead
   of moving the introduce to ASM (Sean)

v3:
 - rebased on kvm-next
 - remove uneeded braces from host MSR save/load loops (Sean)
 - use page_to_phys() in place of page_to_pfn() and shifting (Sean)
 - use stack instead of struct field to cache host save area outside of
   per-cpu storage, and pass as an argument to __svm_vcpu_run() to
   handle the VMLOAD in ASM code rather than inlining ASM (Sean/Andy)
 - remove now-uneeded index/sev_es_restored fields from
   host_save_user_msrs list
 - move host-saving/guest-loading of registers to prepare_guest_switch(),
   and host-loading of registers to prepare_host_switch, for both normal
   and sev-es paths (Sean)

v2:
 - rebase on latest kvm/next
 - move VMLOAD to just after vmexit so we can use it to handle all FS/GS
   host state restoration and rather than relying on loadsegment() and
   explicit write to MSR_GS_BASE (Andy)
 - drop 'host' field from struct vcpu_svm since it is no longer needed
   for storing FS/GS/LDT state (Andy)

 arch/x86/kvm/svm/sev.c     |  30 +-----------------------------
 arch/x86/kvm/svm/svm.c     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------
 arch/x86/kvm/svm/svm.h     |  29 +++++------------------------
 arch/x86/kvm/svm/svm_ops.h |   5 +++++
 4 files changed, 67 insertions(+), 104 deletions(-)


