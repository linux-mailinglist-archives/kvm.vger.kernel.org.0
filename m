Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8B6304C5E
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbhAZWkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:40:00 -0500
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:3264
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731409AbhAZRkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:40:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhdQGfKWwjShXtY/eHYRQqevGJlNn4e74kK+y7E6z2YImauvIfkCY5FTrG2KifQIFB8wx4picobM+HY4QhNjU3Y6D56HnngNW/8US48ACoTfe9sdUc57BcqyYJtID3jP2afzaTaxIrO5q9hOxVNw22OOzVmTPnRqHdvUO5CHozN6tpTGaShrz9oeFDge33SjkHsQziw3EaM3AuXL5zwNiSJBz31EwXkhDxLVssLn+HIy9ctabxHyU0mVCNVNdDAzcVHsYWwZ8/wh/G4L3wO+fbGo8gq4+q0tRT/xI6L+pATxlcJWhvisL2pabFKUQAxdMLyGr0VVG11/1vqH0c/YGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7yg6pbXOjy6pWpK7qw208nKUA0YEOXcTqQdNTJlFaU=;
 b=bIfuL6SaYz9K83EQGRHG3BeFNg3MYsKIVGAse8b2ROYA67wqjg2RnBOIezGxypnsqsETvYl/fyxsfiVDK7iDKr9EpvkV96447DudzzUf6W6e7d17nI2XqI+9Qvo2ICxfrXL12FQKOtCVEOKMaVdPGoy0hi2XwakIXkjgQR2gJGTLoPRRaErsH7H334QNG5CA7MYFuFZ/NgVcAXBDK9cc7owGWDb4TgZ+LxaU3jNvPfe9Db/LnfocDn6vYOpPtL2EX46X9QyidGXnXytu+Pklab6ser+ourhlOrDbaB2hvMsne7G8BDhqvSzp3W7NUeEWQjJDojUsmNKDJId+l+ajhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7yg6pbXOjy6pWpK7qw208nKUA0YEOXcTqQdNTJlFaU=;
 b=KAAUsqf9G0MAw+MV/9y4tVA3tGLRpZiMVQjJKDRQ/uCbb0g0VT5p9Lvsm0FPA7RF0bVlqqTEzynhCCBV1Gwnlr4GKBS4Ut6yH/9dUGtn4M0MiP90dHZ4xy29FdidFsIy8VcRXer7j8tLytfMqvoXtTQ+sZ59gMk0u5/I15tWU3w=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Tue, 26 Jan 2021 17:39:14 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 17:39:14 +0000
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
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v6 6/6] sev/i386: Enable an SEV-ES guest based on SEV policy
Date:   Tue, 26 Jan 2021 11:36:49 -0600
Message-Id: <c69f81c6029f31fc4c52a9f35f1bd704362476a5.1611682609.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1611682609.git.thomas.lendacky@amd.com>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:610:4c::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0002.namprd10.prod.outlook.com (2603:10b6:610:4c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 17:39:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a33a47c9-4a22-4be1-b574-08d8c2214c67
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4153D8DEF5A65F3EC2B864CAECBC9@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqXp4gUmnUzwedlbxkHFNbBe2t0wyXcpMBZ2paB0R+5EK1Kuq5oqiN1+gCDV4ujfA+NwYYSvtsnZVSL33SJfixZtXFpKLhjnqkfciZjzHJZKsXxq9261Wyf0y36TfEdu/LU8UE5f2KlPEupgTpdQXjjeGkQb7MEmkPtrZGoe8q0tCCv2o2kqNicRqdYUrWoVz+e3e38ZsbHhufZXo6A9WqLsmBp69gGHTUTEWCmTWLjHjj+4+9YDKCnc8KHqWUHdcKxtiKy137OGHQd9/FuEM52fFkmTExW3p+4YCMLFogthpXtMMS8d7SPXHXEtDCyfxCrtQEgT13ip0OyTAhGSyIhxgKS9D5hTvUm8OBlrZpEQWGo4pW6gsSiN7f9lFTbh/9UDDap6NlkQDEbGGhbnCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(8676002)(7696005)(52116002)(478600001)(6666004)(7416002)(4326008)(2906002)(4744005)(66476007)(316002)(54906003)(5660300002)(26005)(2616005)(956004)(86362001)(83380400001)(36756003)(186003)(16526019)(6486002)(66946007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NIKoCjFgZMV397EHj9Y9vTC88ncpV2QTR8Z633axwBCzJ7VGQCFKZSC0X6bK?=
 =?us-ascii?Q?JiyVKv91MxnNDXP1flHJbNksFxfC1cG3cxefV44mXr4TqxH0lyq6/Znsuspe?=
 =?us-ascii?Q?XVsHbW9ToEXKtDzsiwCPosDOGeeFp+E2zAMqxu5CXvSc+etpffUG/8wAGzR/?=
 =?us-ascii?Q?BzYV7XGI1I+jaVZmu5UKRG6gY9Vr2iQd1UbD+VrAD+xdvrkRgbd9zQTUtb2i?=
 =?us-ascii?Q?bmg0gYa12e1ud/r/HNgHAnY4bm+r+2h6CAPk+p1OPMfOjPGaE6kfV4GE2o1j?=
 =?us-ascii?Q?2kTy2XHXYgg5fiJ5/vfovi5hgqltPlwq0dUIV4RAua580Dd4nRRQx9P1aszA?=
 =?us-ascii?Q?TDzDVIyKArPMfuMIqrseIQiIa3DP3a9hltRuq22E4NAcxQCVS9sOVlOgDVOS?=
 =?us-ascii?Q?F2B98Eqa6VryMQvhJkAVmuKZwinCGUR5dYA5jRMRTBI/MCBYskX2IhxK2/Nr?=
 =?us-ascii?Q?nWPAzFYTL0y6tsgpDJVu+4odVtIEXi/EhCBSDRHR/ILmKLm/oXu+3In5wSWx?=
 =?us-ascii?Q?+weVCDNRAJ4r6jzEjKyNNuvTXC8wQenLJEKR6dJNARq/k0A7Z0XyK/skdyNr?=
 =?us-ascii?Q?hpdd0sbSmAKduYMpsmvM68C1iGVdT6IRibVZNtbvWWRnDbmnlLq453+p38N3?=
 =?us-ascii?Q?o5Pr2tEdDtoUwqdbYAPN2czT84+H2otWHEoAaItOF/esjSJCkIUvN7OYf+EP?=
 =?us-ascii?Q?nXcP/URb2TY7e+3+2eyJ74m1oEKORfmHtbw5TQz6PB5oHYIsjd4XlBkFL6i2?=
 =?us-ascii?Q?Uohcr3hf8u9NgU07grOICLxPbWRXrof4XhnlEfjtZS+ZHwStEiKT+1w4TZzr?=
 =?us-ascii?Q?VKS7jN2zVFXPv1Opmhm0NEWrWss+tTFl2y+laF74dDoolepVDPSOR8MluZHx?=
 =?us-ascii?Q?N2sDfH94ok7//HITKXnsSdVhRrfWOtsP57Ju7H+2GxqbTe4svS2gWml96EZM?=
 =?us-ascii?Q?mRUsJyWDJoY9PIwz5Fx43G88nhW5JZAG3sG6yPBnHtv6L/1qxwGEgAqa/iUe?=
 =?us-ascii?Q?DmitMbovLEMuG/KPEvSgoTVNfE4oGhEmTXgzE6KAEqEGQ2gjGrKktpfNXOhk?=
 =?us-ascii?Q?gO8ozqV8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33a47c9-4a22-4be1-b574-08d8c2214c67
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 17:39:14.5998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NINDInyFVg1sSbriq2EKCGMNxsNirkD+U1vPovIL8i5JsfnVAfOr7HOfA5PgfTwJCYuvYaKWU4kQb2yEUqlHOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Update the sev_es_enabled() function return value to be based on the SEV
policy that has been specified. SEV-ES is enabled if SEV is enabled and
the SEV-ES policy bit is set in the policy object.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index badc141554..62ecc28cf6 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -371,7 +371,7 @@ sev_enabled(void)
 bool
 sev_es_enabled(void)
 {
-    return false;
+    return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
 }
 
 uint64_t
-- 
2.30.0

