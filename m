Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043182E1050
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 23:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgLVWcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 17:32:23 -0500
Received: from mail-bn8nam08on2053.outbound.protection.outlook.com ([40.107.100.53]:4961
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728107AbgLVWcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 17:32:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkzy+SUttUwmMB6gQt9OX4EIKLuxBs/ox8/xtl1AhjwccM5k5bPedFgGjnUoF1j9GhdNJX53zUTkgQaNT0zSB91T0e1RJqvSjY0TjNRGD8Y5bmBYIaFLc3gRKZkE1TmPqSPXtK4oZ6A4eYA6CK7heqohiIA41DsvHkrI5j5t6l3S4lX6ezDOpPr0lxzAT+UrQhLumUgyxvfk7+Y9PQXdBwHbSIFFlO67HjjTtvHwfO8MD1xOpna3zpNjh4RvftvKYi4aSBr2Y1788HFtgdSSGEQNL1RpT4MLMIqFhzQ2kd11EKrqUS24DdhoDtyJtBLPA+QCzyXChi59AhzUV3J5dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qYrX56Hz+pCEzPspCsNmO5uEZXRwWohviujneZgWnE=;
 b=Av9b6lXWnvsIVPxbdVotpQYUFSAColuLO+7j46zlwaKSUoekLy8YIOo0z/5li9G2xPxypGuJgwj4UrvzT9IWaaYVE2PClfv8AWO/6IpqY7Qm5o4KeasDpU367avD8oyE3aOkCKEYWtxFu3DEsNvghcKOiFbRLgRbQQCikMZyZYDsU6Wfe63d+8QAEWQhfwExZB/I/+WIAJkjMQq4dQOy9miydwAPGxqzK8k0JQbYexM+p2NH859Bg23FMotFjJuSr/itJyZBFenAQcV4Z3Xru4lnxFRHM30WgOq8OkADESk4xnpruMMkSHGebZV0MfaHSi1cAZ5no1RVMFMkUM/trg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qYrX56Hz+pCEzPspCsNmO5uEZXRwWohviujneZgWnE=;
 b=Ei8H1NtBp1wy9wSRroDNM1k0EGA5L8Eih8tSKLWqE4TN7RYKOevWtDOEqGats8wt0v6nJ126Ma23fTRp5uKeAnJlob5j9WsbY0p+fXH4antnXtsNgK0JcwV3/Jjya1DUP8IjhioBZ8qY9yzuVDTgXXwIyOQZ755zvHYqtf4MwTQ=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Tue, 22 Dec
 2020 22:31:27 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 22:31:27 +0000
Subject: [PATCH v2 0/2] x86: Add the feature Virtual SPEC_CTRL
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de
Cc:     fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, thomas.lendacky@amd.com, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com,
        jmattson@google.com
Date:   Tue, 22 Dec 2020 16:31:26 -0600
Message-ID: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0154.namprd05.prod.outlook.com
 (2603:10b6:803:2c::32) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0501CA0154.namprd05.prod.outlook.com (2603:10b6:803:2c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.13 via Frontend Transport; Tue, 22 Dec 2020 22:31:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b3a1e841-00bc-49cb-f9c5-08d8a6c95291
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB238180FB02B9050C5AA0F4FE95DF0@SN1PR12MB2381.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iw6Qc/kjqqhOdJV0dmMVRGGLhwC4phSLkoX9dKOW5nZ2XvFH/32IKg6vqmuQ2unyylDFSxD2NM4J3gpRlNnDj8arCklACb4H89omdIKBScyZixeLjx2U0vJJ37a8SN2xPgf5lXgGGDGcGWjcIeYJC5alz5HY539qO/20E5OXHM2OScMlRxtqqNKTv6a4WaOsg1FwFe7mh0Q9yWVB/DjDm9OrMcirly+3z1+nnL6YrOi2nfFAdhWNV86hVbCHibgquCv9904l4wpkdo04X3qDRBHrKKsUbQ+KrA5VEVBXBU3irHS93YJs/1ksbl9ninlQQoezPWuhe1nj44q0qbJhJyKOzHva39hjR7C3jqeysGcTEeGqRQqpL9QH5VZYwLdHEq0+o4MYIgEB87dE37EuH8IaeTwbl60ji1RMYDFjxoTZA9xg94FKCMMe+sAWzu6M1yyfuvF+LSWd3ih68kov9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(376002)(136003)(39840400004)(396003)(366004)(16526019)(66476007)(26005)(186003)(83380400001)(66946007)(4326008)(103116003)(5660300002)(7416002)(9686003)(66556008)(478600001)(966005)(33716001)(956004)(8676002)(6486002)(86362001)(316002)(2906002)(8936002)(52116002)(44832011)(16576012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z2pPMENhNUVGNVAwRjhuYnpsM09hellBdE1GN1ZLMG90ZjRFdy9CRGpXMkI0?=
 =?utf-8?B?SE5vamxpNDVjSjRudUpPdlU1VUcwQkg1dGxsSjk2b0pOWGpBejlob2pJVXF3?=
 =?utf-8?B?ZXY0ancwMXk3Y1JPZEkzTHgzZFp1U1QyVVNNdFlYNGpSUXlJd2w0TlZEV0FM?=
 =?utf-8?B?M2J4MmhkSUVIajZ6K2lrNXlxbDRWbEhUeGEwM3Z4QXFpVHN2SlBTVi8vcmds?=
 =?utf-8?B?akdqRUp3dE0xdU5FbnB5OEdrWlZUYXRkM0hlSDZmVmZ4Z3R2NVdhTUtaVWNP?=
 =?utf-8?B?MGEyUEhadHN1VDhvTmFPWWFrMVpZL0hpMUFjMFl2SUpmWDJ2NzJGZkdqMjJE?=
 =?utf-8?B?U3N4d2FoU3JrT0MrbFpsM0o2b21kMFEyUm1JU1VvOWx4YUl0NjNhUG11MmFn?=
 =?utf-8?B?S2VBOWZId21oSnhhaXpjNTZjU0VTYjJUdEFnVlFZd2ZhUFBEM0ZTZzIvVGlK?=
 =?utf-8?B?N1JKbmt6VW5LNUVNSFhvYnp5d1Erak85MVZMUFpubVJhK2VhQ1h0ZEEzUDZM?=
 =?utf-8?B?blhVTXdJTGlRZUpoSHpFZ0JrUGdTU2syTGtvZlBrM2pWbytrOVlSekJvS0Jl?=
 =?utf-8?B?ZEhLV1ZkWEo1Skk5V3pwL1dtbTRwNFJQWXlaeFA3UStRWVRiMVNhOGZ2MFVX?=
 =?utf-8?B?dE9MRmJmZ25iNGg0KzdSb21kQWhwcGx2OFZpT29vTm5abnNoMXhkQjV1cjNp?=
 =?utf-8?B?cFh1NSswQ3k3Z0ZxbDNGY3l6MEFoTUFmcjBHaTJkMHozNU1oNWFWZk1YeFRa?=
 =?utf-8?B?Ti9OZ0VSaDBKOXkyNUc3Um02ZlNSdXhXOUdJQ0o1UTRpdUtCVGgvZlJLV1hI?=
 =?utf-8?B?R09WbndORVM2TEFMcHk2b3BtL2tFckRKeHh0dHJ4L20rQVJJVWpZa2ljdjd3?=
 =?utf-8?B?WjZLUWRVNUlFcUhiN1RqbjZWV2R3REhFckVYRUE3TVpzdkdNVU1CaTJOeTVK?=
 =?utf-8?B?ZCtuSUM0WTZTZFU5NUVlUDcvZ04rV2NwZitYS2phYXIrajg4S3U5VkJ3UXov?=
 =?utf-8?B?R0labUQ1MFpGaDZwRkh0UmU3ZmFyVUZaMHd5RjBIUWY3YWJSSHFyRitqOGU3?=
 =?utf-8?B?ME9HM0dZLzMvUHFFTGFsOWU5SVdhemFvNGZKMjNCMHZrbUF5VjJkUVE3ZUFo?=
 =?utf-8?B?OVp3OENuYjI1Mi9Kb1A1cHllY1hhT1cyZ1dBUElsUksvYjRBRTJHZFppQ1pk?=
 =?utf-8?B?cFF0d3FWTjIvaCs2M2JaTVQvME9aT1pjYTRBRmVnbnh1a3FwZk5hRFYvWWhM?=
 =?utf-8?B?TlFNYU9lMytvMUxzaXpvSjEzTC9tb1hqdDdZVkRYWVRPNlhqSFF6SCtXRVFM?=
 =?utf-8?Q?QRohOV1vrbzn5iLJMhEEVGxkEfjvRMUnQ5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 22:31:27.5131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a1e841-00bc-49cb-f9c5-08d8a6c95291
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rx7iKQ3Sq3cGPQCG6ybybuiLtCWxq0WKPhPl2SbXgsvPtxwzvHiEde/GeCIlQK0L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2381
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR on the guest. The series adds the feature support
and enables the feature on SVM.
---
v2:
  NOTE: This is not final yet. Sending out the patches to make
  sure I captured all the comments correctly.

  1. Most of the changes are related to Jim and Sean's feedback.
  2. Improved the description of patch #2.
  3. Updated the vmcb save area's guest spec_ctrl value(offset 0x2E0)
     properly. Initialized during init_vmcb and svm_set_msr and
     returned the value from save area for svm_get_msr.
  4. As Jim commented, transferred the value into the VMCB prior
     to VMRUN and out of the VMCB after #VMEXIT.
  5. Added kvm-unit-test to detect the SPEC CTRL feature.
     https://lore.kernel.org/kvm/160865324865.19910.5159218511905134908.stgit@bmoger-ubuntu/
  6. Sean mantioned of renaming MSR_AMD64_VIRT_SPEC_CTRL. But, it might
     create even more confusion, so dropped the idea for now.

v1:
https://lore.kernel.org/kvm/160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu/

---

Babu Moger (2):
      x86/cpufeatures: Add the Virtual SPEC_CTRL feature
      KVM: SVM: Add support for Virtual SPEC_CTRL


 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/include/asm/svm.h         |    4 +++-
 arch/x86/kvm/svm/svm.c             |   29 +++++++++++++++++++++++++----
 3 files changed, 29 insertions(+), 5 deletions(-)

--
