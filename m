Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC758640EB3
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbiLBTrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiLBTrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:47:10 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA6BF37F5
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:47:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwDC4yui1yyoJZAFjuh74yfdKpCK74/jpkl+SMWzP+YXx+F0+4JBPG7dyUr6kpbMLzkiyT+mCApFdl6vxoDFcWQ9otUcTi0s39fBR7ruqfDY+BM9DzgLAMgX1iHHnNjO3FnXSD74WPBql89sAxz0+M11Io9xxToPS49BJC9+VZeOW8oDrQTkU5A4iz87UfT/A9DXLvadk+CPHwrwh3L7dg3V+S0p9mcLl2YVnAFd0u71bKEf/bhJxIBU3w3iUJGycGXg3ozNxpoDbUcJ2ZmBYJn5gXZhmJsYbsWmTNkAUkVtO51AY38M8CzjtR7lSZ+bfp49IbU9sSiLBdnNNMf+7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XKGPxkedei1K92bCddX4TaJvojd6muF22rx3qF0GdE=;
 b=iOYfjyWNAxYp82P6LrujVH3xccQ45jj0hnBynFNHturVSiMNoJE3qYYJQBUt825d4GcwUgSt9+xYeCl4Pk6jEoFcMonhq5/qvn3Df5Hoq7Cn5xL+op2SVy8Q4TOCXE6mF8FSZCKm3wxySmP7pbNEYnellGGD+RM1uhES7Lbq4CjgugSx3wqQOsGW75NZcbCwnIFrzE405rhWkbBlM2qZs17sYoBrtF95kMUUWjoDt75bg9EFpynppNo3HfCfHgjavgd3BXFRaItd4gqFkhinmi+ZdacFHTeTjSleeJJgGPtj7OjwdEO6zvMIrlAIKTQsEaEuQlRqow24BwYokKPGEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XKGPxkedei1K92bCddX4TaJvojd6muF22rx3qF0GdE=;
 b=uEMBcTFd3fc1/i8ldnIKwrgwveVO8sYJ/g3yvq1yKTeRkm2y6/kyZmU40Rsm65L22ogsWkNd8ifCvSxNXS37w2jhNX3KJSWleYDhO5u1k6KcKZxAT8ttnL8M7gLJvqpocNJmfJ/6mpbSmay7M2Cogcn81kylgi0jm3sTQTj2bHk=
Received: from DM6PR02CA0122.namprd02.prod.outlook.com (2603:10b6:5:1b4::24)
 by IA0PR12MB8304.namprd12.prod.outlook.com (2603:10b6:208:3dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 19:47:08 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:5:1b4:cafe::c1) by DM6PR02CA0122.outlook.office365.com
 (2603:10b6:5:1b4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 19:47:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.11 via Frontend Transport; Fri, 2 Dec 2022 19:47:07 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 13:47:06 -0600
Subject: [PATCH 0/5] Update AMD EPYC CPU Models
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <qemu-devel@nongnu.org>, <michael.roth@amd.com>
Date:   Fri, 2 Dec 2022 13:47:05 -0600
Message-ID: <167001034454.62456.7111414518087569436.stgit@bmoger-ubuntu>
User-Agent: StGit/1.1.dev103+g5369f4c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EE:EE_|IA0PR12MB8304:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a9b36f0-799f-4ca1-488c-08dad49dfed4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QltA7UZ6WHdTiZcbiIfGGEMR2+no153V9e5sDbZ4bwVEkBvZ3eKJjUzRTwq208p6QpjQDSRcmoRVkRk0KQsl7BvQApVuMYw57yQE/jjJF+9KLJ36uWFKlecNepH5rRC0jnBbEY5Q1ezjsaW+lZQzsR/5AvUnStOMxaBBo+IUHBpXv6hL8CBhg6xf9NfaRuSL2mcAfxSPx2bkPCSQG842HrywxJUv8tQPSAL13oUg+ET21G07SUrCEUZU51Nz5AqFpOLSSK3vqWlz694Nee9S8pstE435Xf3bm1/5fAFf+KbyoX5QcXpIZd5ZdepCt+uUcAc/Oh0QoopbWE0LhaE8EsEOpfLaGFhqC8mNwLuqtooR/br9EyAE1tZR3t4SoAwWcYUUGMtcf0a8IcmAyNKSG5lrFloFRqgrih0e+ApGsQkCtn8zbi59m2iDQCqqRRHYavoP7IQ81UeZ5lKAUCTcRK2CiOjx2YWQyNPB7bZuzf2cBAa8b5cg7A4DprC2pLgVHY05QT7zSlWxzFU3hH9GGCJPb/JwZG3aMPDTUwmrIR+KS/KNe6mYDFeUbAbMcEKXOHRjmZgM0h5AZdiIyUUXqLZyUxp4z/jJ4x1M+SFZ2DD13dc/7FWyAsmx16aU2ni8vjrzyPXXaWLTj2WYIK5Q0oCXeVvcREnSbC5Xg03wTO/mAjjnfY8gSeNex5DnRkQSwo807qXJ3bvCgnHzg0iGm/N0L8dcrx4WE//tmfiC0K73IW8QwA3kTi89B/bBJJKy3z6CGHA1n+cwzELIZ703W44BX2FUsGSWFbNBFoof2Q0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(9686003)(40460700003)(86362001)(40480700001)(356005)(81166007)(6916009)(54906003)(316002)(103116003)(16576012)(8676002)(33716001)(41300700001)(5660300002)(4744005)(15650500001)(70206006)(70586007)(8936002)(7416002)(36860700001)(4326008)(2906002)(82740400003)(26005)(478600001)(83380400001)(186003)(426003)(47076005)(82310400005)(44832011)(336012)(16526019)(170073001)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 19:47:07.5531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a9b36f0-799f-4ca1-488c-08dad49dfed4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds following changes.=0A=
a. Allow versioned CPUs to specify new cache_info pointers.=0A=
b. Add EPYC-v4, EPYC-Rome-v3 and EPYC-Milan-v2 fixing the=0A=
   cache_info.complex_indexing.=0A=
c. Introduce EPYC-Milan-v2 by adding few missing feature bits.=0A=
---=0A=
=0A=
Babu Moger (3):=0A=
      target/i386: Add a couple of feature bits in 8000_0008_EBX=0A=
      target/i386: Add feature bits for CPUID_Fn80000021_EAX=0A=
      target/i386: Add missing feature bits in EPYC-Milan model=0A=
=0A=
Michael Roth (2):=0A=
      target/i386: allow versioned CPUs to specify new cache_info=0A=
      target/i386: Add new EPYC CPU versions with updated cache_info=0A=
=0A=
=0A=
 target/i386/cpu.c | 252 +++++++++++++++++++++++++++++++++++++++++++++-=0A=
 target/i386/cpu.h |  12 +++=0A=
 2 files changed, 259 insertions(+), 5 deletions(-)=0A=
=0A=
--=0A=

