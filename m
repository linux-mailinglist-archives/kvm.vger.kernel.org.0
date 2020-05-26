Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2573C1C718B
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgEFNSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:18:38 -0400
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:6525
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728082AbgEFNSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:18:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0Byoi1YFrZlLtiOOhTxuToVEhHBu4DV/dHx24R+M6UfVXe508JZu+ReJYGwNduLD6H9WWaQJCmv0iI894QGn7QOj0ViDbujKHwy1SVjpNVMipqNwFtlO55rODEqQQ8d+Ct5ppaGha/nGzzZQOjCgBuz0P7ozDFSNgpdZTzSmmr8x6jNCwO6o5o4AOzXyGNN0w5D/XeLoaXLcFe2U5mK/TVGG3bgwKTKYEm9h7KeDhSpXpjtWM1OX+IRwlLCZE9fvpE5svo8O9+oPR/Rluh8CoT7eqQXvhBTtPh7KaOXbcYRvs8Z/RjX+1L7IkrOf2v/kabSnhQcSml7kNU0qjx8hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHKuqxcnGfkscwD9jFe/Y0HVKRgyHsMiTITckECT99Q=;
 b=gGX5al10LX4uP5x5zMWjuss06tWldtaJ6/MngMwYXxTMzXbi5ALZn6Xi9hrGKKAIspvC+N2ibTF5a1pO/Bu18JvVzu1HZ8rjCt4F/b42eO83BH5Ba9IYoBb+rfgxlAwe+LDXb/VbLZ8mFvORXszz0k6ToZC+xvSVPVmPtS8bzTs8F1fRFeWsqijR8UlszaA6ESjf825zlrhgdKALD1QoK85oJgx8SzEP/7EHntQ+39CmiXJOuWU397T9s7o3LJxojuXjOoUZoXesaSq8dQbDE8pZRCzOuN3AkpWovpJf7zefYaQoAKxVJvS+mfaiT+88hZa0/GK8lYFoGlrjJ2qqbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHKuqxcnGfkscwD9jFe/Y0HVKRgyHsMiTITckECT99Q=;
 b=XjGQZSODJ1WdJxhibH3gE706GWR5aJ3UcMmYssPCwnYBeCNM95fcoIy6tPoxQ0S/lzZH46jMFQI/YlRf/angONk8Vdxppa+vWpk6AQ2cE8QnMCr/XzfwJffhIspyCKHqRRCr3pYeFK0gO33Ww4vkzExhxeenjC1Qs4ub79x1N1U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1258.namprd12.prod.outlook.com (2603:10b6:3:79::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Wed, 6 May 2020 13:18:13 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 13:18:13 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        mlevitsk@redhat.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/4] KVM: SVM: Fix AVIC warning when enable irq window
Date:   Wed,  6 May 2020 08:17:52 -0500
Message-Id: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: DM5PR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:3:103::33) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by DM5PR12CA0071.namprd12.prod.outlook.com (2603:10b6:3:103::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 13:18:13 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa30d1ed-7187-432f-1d25-08d7f1bfee41
X-MS-TrafficTypeDiagnostic: DM5PR12MB1258:|DM5PR12MB1258:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1258C7AB76E7CD2F1627CBBAF3A40@DM5PR12MB1258.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: woCpf5rMpKquxVwBPccdASWdqALHeDcrZV469u/YUg16pPmZDHl+XbT7P/qxsGixC2PL9rVxyM+G9MMjl/8RsqapDyiYaiZ+UziM710FS5bGuILSHrrhwhAIz3WXHLad2LVjC9bDENIYQYYpWjA+usRGIp6NRUIg7NZpdQcw/FTagg+U1VWRM4X7ZYGedddaxZ+WCynqiDf8sesQsXrOjjybK7g6FxccjHHQ6fumVs3cGhoXPM/IE2p2hjpR1Wss2mJlwvK3aASKHXXkyBU1QJ8G78JI3XHdBtw1FkMD+lSduicSX8pVJeJ23cZ4SBnrNiZkU0JUp98d//4mi/tySwtSVVyID0vUvLXz1EPBhI1xBLlwHzpt8FBVWVUay+v5xn871HWjMJ80xkFi+ENagmh7J7kdmRwNbaVCTw3aC2g2HWAFSfyMShmaUCsXAUG0chu/lkGS0OJg6WD3QJiEpMArQOg/V5XlHpTPAheBY1TEndYO8g47fKAvBXrX1JDsehQ16osm1chnaLJpcAtvhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(33430700001)(4744005)(5660300002)(66556008)(66476007)(66946007)(7696005)(52116002)(8676002)(478600001)(8936002)(44832011)(6666004)(2906002)(2616005)(956004)(6486002)(86362001)(316002)(33440700001)(26005)(16526019)(186003)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FmCoi+XAtpKOKCUgBSPYUkKicDaDzGU6ybCYrb7303KCho29MsVEE/EmG6CDNlt09fJOM5sTY1HR5YxDMOhXmgfpxpj0B7KyU1slO00lZmeu1upHf1oLyvuDR8TqXukbblI9VrJALNt3R4YZDu3VZNTxPn51G9OgsnvVezZwSDl8KKLR1GuGr979Img1DI4B52+okNLF3OYvFqOJK1wMxRg8O8h1uPQTTl6+APBEPzBRr4DYQU8AD2440Iv7bPnktwoHV/CPzLXT7W5/KCfVpzHYDrChF8ro9E9BqrfS7zAT0woON99K5bkazcYAWeQttRdXTRzV5X6q6HGC1ZIMFEPYSa0uHV1P0tVd6g46pZ+uGUCvTZFBcbybrVn0PyylWzUer88fLlCo7UMpslYjk35T+yUAcVwLJvADiqa4dy3t5/rCTnoVYjktB84QGIV8cCW5V5u7ueIgvg0fnuihVsPXE7UeXQ34XU9ibHUuOjBXTtPoo4ryIpPehki8zVqAscuHNMmrmL0GFVwuhr+AXAWSdADFnOU4bblXM+bLQZGludkpyTlZPWS3Zs/VJvlctGVsXbk00IuvjxtAZ/9PD56/My1MKWqmryoFeD/sCwygi1jzm3Xnly53mJBRbQwLsJKLCILAEs+hzDhnLWdfduY8B7XeT5J4O6rgFa+SHBSSbElWQolB9RHv2JPMyVGwtu5LPCyHUpMwHmARD45rgcqX0suy/CkumxGMnXm/zlbQc0GDznpL1Tu9Bk7nly5EaipW+YfHVr27slw30UhGds6gsR9NYMONV6GeGa7pZfo=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa30d1ed-7187-432f-1d25-08d7f1bfee41
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 13:18:13.7765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FqR3QiAgo2gfaI9LfQg3YpL4VPjArgrBaWYKDYwF5jn8ToWytaR4p0U2BiYnSuRs23a8owCAf4LZjFUn44JmVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1258
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce kvm_make_all_cpus_request_except(), which is used
in the subsequent patch 2 to fix AVIC warning.

Also include miscelleneous clean ups.

Thanks,
Suravee

Suravee Suthikulpanit (4):
  KVM: Introduce kvm_make_all_cpus_request_except()
  KVM: SVM: Fixes setting V_IRQ while AVIC is still enabled
  KVM: SVM: Merge svm_enable_vintr into svm_set_vintr
  KVM: SVM: Remove unnecessary V_IRQ unsetting

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/hyperv.c           |  6 ++++--
 arch/x86/kvm/i8254.c            |  4 ++--
 arch/x86/kvm/svm/avic.c         |  2 +-
 arch/x86/kvm/svm/svm.c          | 18 ++++++------------
 arch/x86/kvm/x86.c              | 16 +++++++++++++---
 include/linux/kvm_host.h        |  3 +++
 virt/kvm/kvm_main.c             | 14 +++++++++++---
 8 files changed, 41 insertions(+), 24 deletions(-)

-- 
1.8.3.1

