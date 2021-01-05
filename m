Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0612EAD78
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 15:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbhAEOjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 09:39:41 -0500
Received: from mail-dm6nam11hn2228.outbound.protection.outlook.com ([52.100.172.228]:6314
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725817AbhAEOjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 09:39:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ibax0GGSojuBDFWf/o84QaX/ivjkWU2np9f1CZiXCPItHBbJAYArUfq+9Mx/asYyjbG8Kr3lK59AfAGM6HLWWnZW0/rE74Ntvd3ujk4E22vGFqiQmZb1QUlEWgb8AP1toPaWb++grCrOdBuJiDotFC2wxmY4QVwky+SyOy8dohqed2ho1To0Nh0ncj5Mtphz5nZdw8Mmd7CetNRG4GvSCYcyKd/7J+1Nuz4zrluHlXFqhhbvYctDPGs4K3ykeLEQj6gcBg3uK0Ft64DaixT/5XWTnoN8oq10EWlNzfahjbshwkTk7tojDz7ec2fjZSC84l8deUWvbYbN2UnuKFuCxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehNs1Cd0ppuCZL394Qu1frD2rY8V/+cptk01PCn1Oa8=;
 b=GkMsO7bEmheK83wlXVSIXa6L2lgSaSjwzEhQtZmO35f8DbhmPF5dGYA+j8gLtalMiS8StvuUBLW/d5wXkgCPDihZNNYjib4Mamw3lqO8oL5tXZI1ZP6IFNP7sx91AT9F2hygZIIEb6yWcGpjib7Vcpsh2Qx4rRL71FRY3NkJTmZLnAwAG+k5ydXnobqFdSr8iGQTv80vCqzb2HgIoLwFBzSCyx6UkVnCfd1aODneMUj949XCZuy2MCrb52AVkEE3vmvSvIz80d+ldEr29HUguY1ixe7HfFItS5rPZdyUFILYy9I/3eKq1zkPFIOamgnma/sb3eFH1YJ+TSqQrfPYHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehNs1Cd0ppuCZL394Qu1frD2rY8V/+cptk01PCn1Oa8=;
 b=Xs2rWdfqIqmWK6j65jRwmLdGe9NBRp80TwcR8DQ4aSPZcvNJlKlTLxA/jeSTC4/TRqQy+hiV13cyPc9flLaavPwhPN/J1ljhiQEG7vIo0YhSAi3i3cgYr5Y5vnD+bXb9cQ1lL4bz7zzxlSzor6rn4PHzG2d8dwUi6Obg7LW4QUU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3957.namprd12.prod.outlook.com (2603:10b6:610:2c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 14:38:49 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 14:38:49 +0000
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
Subject: [PATCH 0/3] KVM: SVM: Refactor vcpu_load/put to use vmload/vmsave for host state
Date:   Tue,  5 Jan 2021 08:37:47 -0600
Message-Id: <20210105143749.557054-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.54.211]
X-ClientProxiedBy: YT1PR01CA0069.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::8) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.54.211) by YT1PR01CA0069.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 5 Jan 2021 14:38:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c23e8fa-a579-43c0-3b8b-08d8b1879da3
X-MS-TrafficTypeDiagnostic: CH2PR12MB3957:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3957FD06D89AB0F4974193B495D10@CH2PR12MB3957.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HGoUkm9KMS8+s0FW2CeZnUFZjmR6UXOHhh5RO100MzGeu1IeIqftPmFhS723KxqJLX/R5lBeDweosNuRgD3rBKSD6xa3C36tD5sxU7Mi5P9V6UpIUgG3ulgN2DCmy8Atp9iUboPhJ4UCzOg2SUdMLaSFLycJgKkB+jdtKsmCnwRf3v3B9i6JjDgPfrn32dk+aQf6go8Ypb7IeRrPipM2B4+CT4ND81kaTXWcOmoEp94wUOf08owFi+dtl4VddVhubASRFN+WwcyE23MPYv3phoxuMQ+ccv1KSkplzJyBHFiVXiy/IdP+F/nOK3aPgHXfK2K9+MGvaUwGzloTZdKEFmh8vJ/lM+G2Xm3r7fVldXRl85RiKFNY1P53YkeJnrJEg5p3YNrpwJOeFTAIQlb4cQRuzAtMwArZrCbSOoB5kjc0wl/fCjXbrmsbVSeNU8TPbfHCRUqmVZuO8UV9AfsW5AmE3N859Gp/o7OG67htNJyYVASQTq6yfmBxL931XzJfLv6OGX3LEwpEvJyVk3ep3feGF1olntAahtztFuX0r8/0iJ0A7aJnUYK6y5itQ8ELYCFj+LCkfRW00w+f/IxJp5yy1HtZRWExUkI17TBNABYta5FK3saPXWwyuhDOhN1A34Jt+V8aXhhnY4jDogvzg2qzHGjlxHwvyaN26gPDzUrYGCC0/uOkI1oxYi2oqorfcyyx0n39SsqAj4WDiJhOgVG3A2YrHPrw8QUeiSQlzWAHY4kQumE23z1Gacu9V2lh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(83380400001)(2906002)(26005)(4326008)(52116002)(8936002)(8676002)(956004)(2616005)(44832011)(186003)(86362001)(16526019)(66476007)(66556008)(6486002)(5660300002)(66946007)(6496006)(36756003)(478600001)(7416002)(316002)(6916009)(1076003)(54906003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?B0hsSTyYCQwSm7aGzw3MTeVozQOlEOObbf+fqMu7mo7vJTATdDI/IujR8hTL?=
 =?us-ascii?Q?BVJGxUR7tJRzJFXiYvQb9ZgmL4aLD09Wh2BcDZg6cPQJJ7JfU70iMJ01TgBf?=
 =?us-ascii?Q?D6pGW07KEKAi1tt/8Qfqdf/V8htUeNjIhDgRfD3QSQRg6PacDMjx+XLuPNYL?=
 =?us-ascii?Q?vF1+z9R6DDB58WPlvO9JukMV7q7Tr2+XjZW27HA8RP7L/sQYW7lD4RS3M9Ca?=
 =?us-ascii?Q?jMIhYWJYZopU6/ZdirchqNj/fnkrpHnLMsRuTmj5KS34iwfqxl9A8PbRFvvD?=
 =?us-ascii?Q?+PlMGVAzuNphXSbUTXJZqfj/KiRrsI3Eqo+GhbSYM4VVo6D7qCUw7GshdTan?=
 =?us-ascii?Q?rEgEZooKO22FvJVeZY/OHJkfmVemQSZgR2e8lD/sEQtG6xPg9SuPhmVIOU77?=
 =?us-ascii?Q?Cpixjn9wrDRrV3jklNuTG92NYea/Uuw9crqkaTvysQsdg2voq9Twm0Hta0Gs?=
 =?us-ascii?Q?RsuUj4ne9K9OU6ir0xhPTY1mCOsFgKRuA9p6fefvscnJ3xb1UMH/ZRY+okg8?=
 =?us-ascii?Q?W5F/zXTLxB8R5z7rmxOefQcVUzfIGlkVIQ15AfqJa39KYKF7wz0XjzVxsQYa?=
 =?us-ascii?Q?qKwLWyYds8l2maRAY5mtiGejAfULvHexZaXuw8S1pfpLIJQky4gCwdUAsXqs?=
 =?us-ascii?Q?L3RuR8IFPxQ6W/3yQ9sILFDDKeqxfU1KWlfCtiKo/vbmMV3UfZmGN5T//1H/?=
 =?us-ascii?Q?hz+g5/zDkrHYGdVuG8xJvcbHOWXF7n7xwkZvQbaO5I989xQ3IkTeThXI7Flh?=
 =?us-ascii?Q?1w2RpamqUVKS0xKPd7pElG6ZEnqolzNb4CbX7zgtvMJ2Old1S7wA+YbzE2sk?=
 =?us-ascii?Q?eSUusR8AwIEMWriMv2EDBYvd6nU40UqozDKYZKgHR02E+RUK7ypTxtawXbTR?=
 =?us-ascii?Q?lNE83zI98WOM4Ng4jUCTw99yYHiDQDRBL2+6ahlrjyLkIKVRC1BLIXP3n4zN?=
 =?us-ascii?Q?m9LGKeTWtgeHX+m63yJnocp5VrzspJ8pqxFx/FdPQa33AWCVGDpBCPbIT7pc?=
 =?us-ascii?Q?Kn+6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 14:38:49.5421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c23e8fa-a579-43c0-3b8b-08d8b1879da3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fwu8px4ZhjOUSoEUgAF97UYHQrV1U+eeBMQdUxtcx7BHqpbwSrWSN8k5SGDCd6sOve2qKpDKa0EuLiZUG586xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3957
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series re-works the SVM KVM implementation to use vmload/vmsave to
handle saving/restoring additional host MSRs rather than explicit MSR
read/writes, resulting in a significant performance improvement for some
specific workloads and simplifying some of the save/load code (PATCH 1).

With those changes some commonalities emerge between SEV-ES and normal
vcpu_load/vcpu_put paths, which we then take advantage of to share more code,
as well as refactor them in a way that more closely aligns with the VMX
implementation (PATCH 2 and 3).

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
 arch/x86/kvm/svm/svm.c     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------
 arch/x86/kvm/svm/svm.h     |  31 ++++++-------------------------
 arch/x86/kvm/svm/vmenter.S |  10 ++++++++++
 4 files changed, 75 insertions(+), 108 deletions(-)


