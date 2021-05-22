Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36F238D681
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 18:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhEVQpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 May 2021 12:45:41 -0400
Received: from mail-bn8nam11on2075.outbound.protection.outlook.com ([40.107.236.75]:34528
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231299AbhEVQpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 May 2021 12:45:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XndiCgAUsUBSsnPzAHq43FP26A4ozdDi4SVBoYptkqtLjbGuVg9pStvSNEdbL4te4LDfFaAZ4tdCrX3aMQ7t3K6rhPthv3YySfu+vV0AD0De+z0TZ8H0kSngWMNuEtEMJkXAC6IZea08boU5f9FsP2CJXG/nSF4JFhXTtf/nrNYbSaIntE/xhKULDiq1TDskyBOOU3R/vvHJzEk/tEvOolMM98sW3rSvRTZiAu3luj3U4TCro3nWeGipKaexJteGPRzFpgnQwlDhMmgQL7SK2gFl59uDKZmyMa1J/C/mmbdwrv+5YchyUiQHL9nTcEEj36OBKo2mRygLDdVj89NPRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boFbrmeMMrEjdn11+jSzXZrzQcrbqpzGV3mI1dXQVI4=;
 b=nDMgDpXCaRGoQEZ0/A/mkIpfHP99VU1MRq+ZPXn8Jezsf8Njsvmad+tQ+O6EUvPSVAa3mopYQXaEWAf0fpFm60iZ2l1zTj8h1SMtgajOEyk5f7XixHVLvkP5MVhz+jzFhlvtlitTpkvkjcp6fTg77yDuTt/TY/W3rZZmimgoWNzwKiZE/Nm3lZMee7ymUVuUBa6HzD1Cegd09qcj1odWSLuC7n4LzHSPoTZpuwc9zYiNhQv1osFP9YOx2wmokMn8WE+rYzxT5ypZQAJzj7f1vn7YsRAA+78XXCuoXjbFyIA0bo9arl4v2rkbrgbQpmrD/jCS9yO7h2hYyMZNwWW6pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boFbrmeMMrEjdn11+jSzXZrzQcrbqpzGV3mI1dXQVI4=;
 b=NHXF2gVlQFhs3s1UdN19/x5RhA1qgKKnMOoh0roFfPLrnbjvVOdYjJmSL7Ht9sGqM1CXf2yJIgww87YtZ0n/dc29TM6GwY2jXNJVhMT0vCLvsejZMl7ihbQyerLeECr7/o0bH7WR3utb4iVaGggKci48p8PFBII1xo+g/ofNiAs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2828.namprd12.prod.outlook.com (2603:10b6:5:77::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.27; Sat, 22 May 2021 16:44:11 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4150.026; Sat, 22 May
 2021 16:44:11 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with protected state
Date:   Sat, 22 May 2021 11:43:58 -0500
Message-Id: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::23) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Sat, 22 May 2021 16:44:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4fe34ac-51dc-4576-9988-08d91d40d365
X-MS-TrafficTypeDiagnostic: DM6PR12MB2828:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB282811AB102083CD10026CA6EC289@DM6PR12MB2828.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FoKZVu8fxmjYoPHEKNXjH674wr83y/IKjYx3i+fF1jTtx420L2Eg1OSOtlg5rNRCU7mctE9Do0KwgUVhrnN5E2J6XPiqvLfIq/lBxrtChFuogYcU3WWvbDFn1zjny+9u1X0J9TI/cDT5X/5wVgGbWEAwJUHybaMMKqqacONV6ms75qWsyXnFJA1UBhthbcRqBZdVOL9cFdjFvTxkGlIocnPy3JDjCN13C6EiibXwdfuwRI4MzCt4okuA5iriwVRtijxD2ZxEZ4JBC5ea7jJgMTGrBhqQhY/KNJJHGFJ44RoUixCY++AN7B0UQfD6Y2Hd8fJQ+ZSwq8e1jKztYqm1XpSIzPCWYyEHjevnQuMdMeydEf4WVN7y/BGaC7/wTIg6RA+YitBEZydKpcqhVXVihp+kZ5zDV2Bv6sC8d2aTvXn5R/h7Pkqe1sjyUD0aPwxf2VMGmy5GCUizjXef0Q29zPVNK1LLdzKztsb94oGGKJ/HXxiPEG2P3udbH86QZrN9Mim8AanosLz71enAL071hiJbBe12vsFUk9ScE++mQpXS8lanoyq+6SjGtWgL1nZJDEsEMG8goGdPCTwqqBUKuJ8CyAqTn2W8IW6K7coNJ6/KMJvh8qr7X8OWzAzv+1aX5HoOllnMxsObTWBp5n+WslKHwAbsvt1gBQKn2HSjUUM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(8676002)(38100700002)(38350700002)(86362001)(2616005)(956004)(8936002)(66556008)(66946007)(186003)(36756003)(7416002)(7696005)(52116002)(66476007)(16526019)(4326008)(6486002)(316002)(54906003)(478600001)(5660300002)(6666004)(2906002)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wv/9zHw3tB8YfnPvD0FoppnSRezia95Q2yQFH+B5wmaBB7OqFUvaIJQUdDtN?=
 =?us-ascii?Q?UEuuVyEBHHbnltaHkgJ5tL7elOseZcCHdcR5OnUk8l/kIbwRMOrD8KVLV4p6?=
 =?us-ascii?Q?STxVssDRPHp2hKdWZIMnc5tQQFOkw34MXBZEjQexbbq53WveL/iyF5Y5MKCy?=
 =?us-ascii?Q?J0RyQOKxk9OfgJ8oM0mNKDYzdFuZWZVWNn2uUZ2jGAQKPGq4z9adR4LFoB9R?=
 =?us-ascii?Q?O/dHztycPU0o6vgNXuFJHnp5CArxKmrc4ja6ZMpXkuwb6u+r4rD7Xe+dpn9a?=
 =?us-ascii?Q?CS6edQNIlAM0oSeuTCw93wsuiEGdwxiPrlZxfUcyRbtRHNAkHt7U2F/4YtOR?=
 =?us-ascii?Q?ve0HKB4CQkn4HHVRHGCKh/X/QGF8AbKHH4Nnxt8FDD0x1OXZRevXDbwGFNob?=
 =?us-ascii?Q?sALo89odEjO/X5/wvafKp7haecRBokPML+k1uGajhyUyDTW5g7CEj1nuPUi2?=
 =?us-ascii?Q?XDiaR6z0Id7qK07V9XPbi4thbZKOKbxKt6arTvtataa3wOd/y2/tNaGJkkh5?=
 =?us-ascii?Q?1teMcVirrVfrM9ENDnUyYialuWE5qE6i1rtXrLPkiBas72pFh0iUXE+u+asB?=
 =?us-ascii?Q?DXxMwyX16oehH0Ik13kf9DUDegv+dKOb7VlhbIwuEjoG2em44QRhT96JwuUj?=
 =?us-ascii?Q?ROcBfQ2QDSpRZjMrpbtu2PtDxmKlZ7EG+zG6VJzFTpnUcVcKUC02p2r9X5Nh?=
 =?us-ascii?Q?u+9IbGWtO0Sy6R+daVm72aJUh78kynFKpLen68v8J7Y84R5CHyFrLRDgfNld?=
 =?us-ascii?Q?fpBgUzXph4NkZwly4KdyavOwIQgY1Hi8kC1EgtdnampBiP9eOI2U4p/QMcCD?=
 =?us-ascii?Q?O2Z2GZBg2zFYlM0RiqUr1qIHGdDcfp9wbZDpXkuX7sN5cNSJTcUCaSWTxcN0?=
 =?us-ascii?Q?7YT7HJt7menxbd0J/sC2P4yqW8rF7K0zDYadPjEF3V//H/NTJumB42Gw+JJI?=
 =?us-ascii?Q?Df8BRTG2Tv8Ldx5q2ieSGsJfOfJ2MtJECKCmdnbzBZyRYvBx00JRzgMME1y4?=
 =?us-ascii?Q?rgYFiUHv3hQ8BldONq3aoCWTOzsran/+xUhS4GS7M0JZXP5IUGPDmiZW/olE?=
 =?us-ascii?Q?Ay7h/tBb1HH9Yua+RCWGhcE5BPM8JvYa+NKXP+T3Z+aZ2XwQo3S7QP6wbcUR?=
 =?us-ascii?Q?sUYOI31lU0W7ySNaOCNO94h+BFeOaJ/RF/eeWZuOr2TJaOfu/d6mktivemPV?=
 =?us-ascii?Q?HaLEmDTgz9Obw56uM9uNj7DUipSPsE3WKRKVmbw8xbfb2QAoJQUnp7NWr40k?=
 =?us-ascii?Q?feccZqsHrEmI4YM2AyvmE8UNFVQTViqS4k4mUzERZkHHFILJDU/RPFmXe3sE?=
 =?us-ascii?Q?QMeXnDzQO33z/GChKXMS5Uug?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4fe34ac-51dc-4576-9988-08d91d40d365
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 16:44:11.3358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nuylqWyV+Fvf02RUTeWYSLoh/p6jNPSraB/MJOuEVycGQgxNhgNjIU7tBb7GCooAfIVOgKky97FQuDh5D0U8JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2828
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When processing a hypercall for a guest with protected state, currently
SEV-ES guests, the guest CS segment register can't be checked to
determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
expected that communication between the guest and the hypervisor is
performed to shared memory using the GHCB. In order to use the GHCB, the
guest must have been in long mode, otherwise writes by the guest to the
GHCB would be encrypted and not be able to be comprehended by the
hypervisor. Given that, assume that the guest is in 64-bit mode when
processing a hypercall from a guest with protected state.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..e715c69bb882 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8403,7 +8403,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
-	op_64_bit = is_64_bit_mode(vcpu);
+	/*
+	 * If running with protected guest state, the CS register is not
+	 * accessible. The hypercall register values will have had to been
+	 * provided in 64-bit mode, so assume the guest is in 64-bit.
+	 */
+	op_64_bit = is_64_bit_mode(vcpu) || vcpu->arch.guest_state_protected;
 	if (!op_64_bit) {
 		nr &= 0xFFFFFFFF;
 		a0 &= 0xFFFFFFFF;
-- 
2.31.0

