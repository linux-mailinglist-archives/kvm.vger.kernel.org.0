Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CA012522B
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 20:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfLRTqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 14:46:02 -0500
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:1696
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbfLRTqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 14:46:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaKPSLHHdOEjgF92ZsOF/iejUXz8fudf8NbtloxDDbz2RoLp1HP4qiWoE4OnH1/aGXs3wWH1E9ZdV3S4mIRCzC3akNj5YHGEIdn+y3gYJ2sG12ixs4eWR2XAGfOi8opynr/xxYE6/RLFmTnmFYuyBNDeP6FYblmrW+2a+6scI5WFQEEhtklam6A73xBVUPFe5eAU4nGnMma16gNIxaolz3Z1aIOqu2KtCrZcZ8UFwshe9f8EumtfeGZgerjYRC5A2dLz3Q9zLRW0eE2J6BXWkE06daepJMn8uzRI+YIZrB7a3nIJjKmcXK9xv7SFRT8IT6y774rYp2y9v2zclQXkhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS+wd211c5GVgPTI+LzvYI11OAw8vaK7Oez/K1s08lE=;
 b=jPz+T1zGgSxoyGM4QFzisFI9x137SMldqaCZc8h+O5Fu3TnV8sLj5m/PvwH9XRcpLqMDB6X5sbP5dFP/F8bNDjAhDvthIcn4phU3GdsSl28kwosKYTgVZYbrO0gyeejKle3KjnSrNTZ5jsrVWZp2bHnbYyvfeo6Y8STpdCAUTzeA8QWmOtFMrVtnTuUp+dDqG0Bzs0gXMEMHJcRPs8UhHD3hYBUVZMbzA/v0OUsapPy8iUUasnTHUXBs52BxWGNKbcdpoSnzTY/+tB1H0mRsPqf/EDxFQTw2zK/5NLeXW3pOH2D0bAKD6jBftlzkN8BbVDuRfCIuqIVXi5z3/J9+tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS+wd211c5GVgPTI+LzvYI11OAw8vaK7Oez/K1s08lE=;
 b=sL1fbY+jxRVinSN84mkWd62KNRD5zPkyECzGIjipHGRXuQfTOsuvzToKbLSqaPGEIa+Ke0PSGDFzrXhDzGXEArMYbyYhFX/y/yz9ZnthhdihMLT1JnmFjKBp8SEePYD9UdqdT0qAdX/lPmaKODAlQvm+O1ShcKmkKac/tohbQe4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB2876.namprd12.prod.outlook.com (20.179.71.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 19:46:00 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 19:45:59 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 0/2] MMIO mask fix for AMD memory encryption support
Date:   Wed, 18 Dec 2019 13:45:45 -0600
Message-Id: <cover.1576698347.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0007.namprd21.prod.outlook.com
 (2603:10b6:5:174::17) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dbc974ea-6371-42d4-e631-08d783f2e80d
X-MS-TrafficTypeDiagnostic: DM6PR12MB2876:|DM6PR12MB2876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB287694F5BE2052A70D22CB00EC530@DM6PR12MB2876.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:203;
X-Forefront-PRVS: 0255DF69B9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(189003)(199004)(478600001)(5660300002)(81156014)(66946007)(81166006)(6486002)(6512007)(186003)(52116002)(54906003)(36756003)(86362001)(6666004)(4326008)(8676002)(66476007)(8936002)(4744005)(66556008)(2616005)(966005)(6506007)(2906002)(26005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2876;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m38ao21HFNkExqLhnmzcqELXjFMk3YYT+u1jZ4Bmyqc/5woQ/wD7KO2747fBlMeWZPYiqAqr+u8MpETNgaXA4aOtfFKBPL8V2qfPsoy1ihvg5BX8ymJnHMVWB8R7o+5lZXmZIZvwRASdLt6Dbf/RF6ldMMAO1yuFC568NHviT2mkXRGfihS8tBwKVc5OKF5fMsT5raYfjbNs2QbZFUy1xPIy/WkF2My+GuNzJB7gW1ZIZ17O5rKMD5DgXWfXwrs6/F0D3Jdx2wsS/fBbtFvjGRW/9zDVzdeFFaFLNtjixx1G/G5WnXZl37CTQlheZMcL04pkGmscO/1WS0yepeM99hJepdhsh8AMhvZGENPIwsZ5pO//NJm4TAx1E/VCOUyWOXxDfATt3FxDN0Onp/11TVIZAwy9hY/wru23FsH1FCWBRTCn9mg89hq8cGwJom4ljzWCacccNhdmKSiPEqnOfi7/1Np1pnIi957Q92CpmkM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc974ea-6371-42d4-e631-08d783f2e80d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2019 19:45:59.7392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nke1CMjiGZRQPYgxxaexU2yOwN0qjWBJgSPIBGf/FQrv9rqxrSjcbIW7dkoaaI2SnobPPRXCPPeoHc5W+SIkOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2876
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series ensures that a valid MMIO SPTE mask can be generated
under SVM when memory encryption is enabled.

The patchset includes:
- Add an optional callback to return a reserved bit(s) mask
- Implement the callback in SVM

---

Patches based on https://git.kernel.org/pub/scm/virt/kvm/kvm.git next
commit:
  7d73710d9ca2 ("kvm: vmx: Stop wasting a page for guest_msrs")

Tom Lendacky (2):
  KVM: x86/mmu: Allow for overriding MMIO SPTE mask
  KVM: SVM: Implement reserved bit callback to set MMIO SPTE mask

 arch/x86/include/asm/kvm_host.h |  4 ++-
 arch/x86/kvm/mmu/mmu.c          | 54 +++++++++++++++++++++------------
 arch/x86/kvm/svm.c              | 42 +++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  2 +-
 4 files changed, 80 insertions(+), 22 deletions(-)

-- 
2.17.1

