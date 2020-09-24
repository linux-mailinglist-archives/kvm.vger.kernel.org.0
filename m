Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FBD277893
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 20:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgIXSmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 14:42:22 -0400
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:53036
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727753AbgIXSmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 14:42:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExYTL9eTaWpX4TWksvwSbIMBRJPl3UUvc2Qn+pb0jKPIm0wcUluw/ww21xbskmTcZJZPkxtV8tVP+/O/u3hUy0QcWBvd2y1PdGD0eXyuRDRcWor/w0HqU1qcWzWYkD7/QjIiiFthCE8gDL+UXst4fQXV7dUWD+EUUyIMBxg6GESnmrYAS79jPqli5yfZZZwAarb4ctQ9eqJAhYscBv7mU4bgscyNMV2b8Dy+5fVVDxS2L8EZGoVeBz9GmwW9izBwiRmBSs/xSc3b46H5LyuLx9OyQ+Lidi7Jd7tZhnpad7wJlRBaG6gSMTnB457ZYut3zpAHn4HgS2hhGwgW6IIC+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lcm8HfIXgqeSNXSEypqoTkY498c1ADpLBsIAWg5qeds=;
 b=mb4UfTu8Weo3RY29VlMMTb/rCvaWiy0SYxDkg89XquNZSqfVNjRFiOZlBoZxsA53HlXHJ2xvESW1MxJD2FM9NE5/p5+yTo+gRhBssDh9z4Tz9uprfPjSOQfdbkGvFNHvfq778WCA/xiA4j/vGZhlEUcm6A8azr7ncN1tMill+SGdbr5TaPHrb00+xrXE40LPTrptB/UZv5nvOl2mwOb9tbyvO05K4XugA2qfLxBvgKaNyQZpo/lVK5c1LVRKRjjs3ii0H9lFnRJe5iAdluTzHiY655hG5c747O2+/WFpUJ8AKT5A4nEK4/Msfze8x8B5Mcud8fKricnWc/di0XCbwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lcm8HfIXgqeSNXSEypqoTkY498c1ADpLBsIAWg5qeds=;
 b=s8DvnKhyO+RNI+Llurl0ofpertoN9jIYPHhgZN/cyFeJsjEJ7+1I8+t5ZERE9y/ztO5RZqqbPKOqjNhoLZu4TaPWZyKJk4oa/hnTH7AKvHFARu/FqxW2+crLL/VW9YAxpZz03ABkxltoRjAZjpaiE7yfY2LrLB57ifo+7mVyMzo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.23; Thu, 24 Sep 2020 18:42:20 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Thu, 24 Sep 2020
 18:42:20 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 0/2] INVD intercept change to skip instruction
Date:   Thu, 24 Sep 2020 13:41:56 -0500
Message-Id: <cover.1600972918.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0057.namprd21.prod.outlook.com
 (2603:10b6:3:129::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR21CA0057.namprd21.prod.outlook.com (2603:10b6:3:129::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.2 via Frontend Transport; Thu, 24 Sep 2020 18:42:19 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5c51f53-83e9-449b-45d9-08d860b99174
X-MS-TrafficTypeDiagnostic: DM6PR12MB3082:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB308283D9FE4F99E2820198EEEC390@DM6PR12MB3082.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44C3SicwqDquHX6VSeFAP6NeY9I3ohr587dbTahz+TTzVlk2U/hz3Cy9RZl2njYKxgXBycCqUP0plxV5Gj8FrXNXpnSevbQMB8q1wu6XgXC7v2JrNWrjuG+h7K9+YT20CaygY0G8SOGXzXLQKppAbu906PKgKnoY2Yj6T0dBDsU2Mygs+8/eN4H5iNe9DiFgDIgALCchpMXa+XwaAxlxqKA5plOvCYjIQPO9bomAp19o++AubRGNK4/fc7elYSqMauCK0/yWWZkfD0QkgKGGvYsgvWTmt6fKhw3cJhRSmbDlfc8wOpGgSwW4gF1PT//9pWvMjX4vzd2Jl2ZcoKWWsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(7416002)(83380400001)(316002)(36756003)(2906002)(956004)(8676002)(8936002)(66556008)(26005)(66476007)(186003)(16526019)(54906003)(478600001)(52116002)(7696005)(2616005)(4744005)(6666004)(5660300002)(66946007)(4326008)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5pzVv+CYb5xXVmKiEe+ZNw1Na7FJd2vecnkF3cLcjlU+i1+5K3YWIkWn+cTdsn0UDJgWno5jNGmZLwSZYHoic/jBS+upfcYH/EVmZRTII+50r3vMRauRbVlJ04N+5tWCXooq9pdsA25+JnwvOoSsHQuN24njjk5XkIYxSVBONbx+gOZSaRyGbodCxXsraDMBT4LEo2waXviu0/Jw2PqAwcDe8fYldwyxdqxTKsm4u8Ayt04xG+9n7nsOytmiXj89bhupYjyyw6nkdCejg6t6oOTaoct9KrUEBp6GBS8+K5Ws9NDUzluo8Atsv+rXjXTGx7nF4VnVr2d2c0WeXWCpnAAuEsgmrKt3TG/+AIM0jnJ9FyM2MvvxRBfiat7FkU1YpvvWQhkiUe18WwYdCSbHEk8/iFwDhFvim0PuQA0d6ue9CBF14fVPMBwhY/coRE/eBrU/ONMJrsC4DogZD4ESVXNwmr0fGouR2BuBfldJ7sHGmpUcBWDpibPlUxWggkTYRRM4H8iGbz3tCU/syDgLYz5yLlfwLuAZMqdvFFqZqLTcFZtYCAagCixlxc6XMzezWesGAoa3bCPFpvBNOHIapB7XG6KWNE9pWnnbcnd7wABHtt9II6/L9eQfUHYsgBmWWBRHmuDjCGT8rD2FammBSw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c51f53-83e9-449b-45d9-08d860b99174
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 18:42:19.9787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wnmykPQSTd1S/aWTmCPV5pS3IGxcC38eOYaWEUhTy/gUUBRiWD606XmGvrCuo7MOL64ZG682fdfm+Rp7jh4igg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This series updates the INVD intercept support for both SVM and VMX to
skip the instruction rather than emulating it, since emulation of this
instruction is just a NOP.

For SVM, it requires creating a dedicated INVD intercept routine that
invokes kvm_skip_emulated_instruction(). The current support uses the
common emulate_on_interception() routine, which does not work for SEV
guests, and so a Fixes: tag is added.

For VMX, which already has a dedicated INVD intercept routine, it changes
kvm_emulate_instruction() into a call to kvm_skip_emulated_instruction().

Tom Lendacky (2):
  KVM: SVM: Add a dedicated INVD intercept routine
  KVM: VMX: Do not perform emulation for INVD intercept

 arch/x86/kvm/svm/svm.c | 8 +++++++-
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.28.0

