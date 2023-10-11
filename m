Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB057C60C5
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 01:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbjJKXBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 19:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbjJKXBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 19:01:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE8DB7;
        Wed, 11 Oct 2023 16:01:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyfMrjF0ybbB1Dl7pLwWAlA/6IAmgTXIM9NOP1qX3+huX1YfOYpY/229JOuz0u8AcIWcS1NFfipBN83NYagy4xROxzhu0yGhGe+33sctZSGvu22XoiBneFJiPOCGQRxJxaJusRlrDXq5kFjEop+svr/dRVr7MonlmMQJZRxQ239eW7hCP7zEo4KlDUC+CiC4TOc9457HQPSkvPMiECNUCc1nsgFIhUdxv2vm7CaQ7xYZLWj84bswl+F0A2vT2MBtgROLvMAsn8RxIA8/1cCwCjf9zKv/21gJDXeTif0lb0hl5rPb7H9G3FpbXhcCgmArSFMH6hpf6vPyibjhUhHvPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3EMIeSZ6SknopGTnl0tmQFjYbXhdxo1b/cS1ntssI0=;
 b=JYJoRJHBPszPH88tewAGLrB8ik88ehIn2I9eEw5J9la1EV6ZQf9wJRp6JdmtE1+tLOeH63BBCIwKQ4Gbg9XgisoBCWPSI1y5Q3NFzVk0jmHIlNYIsxMk5U5ypKD48RCSau3z7+EQ/prqZVNoaanUNIOgTYgbbigw3MRzB/+NbhrTDThucNTkISACHkndqfEDHBD8DeFtqDPT3Xv63KNpir9h3kkPy8X/J8o6X23C/0/uJVo/hG6v1URdFrouuSbkOkTGKHiH+EqWYDc/P5Bioc9Ip3JHTlJw2xr13bk+TpuOag3AEPw4BKFsjfHJUVl7D/p+WFGgHACceYaLjwgDkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3EMIeSZ6SknopGTnl0tmQFjYbXhdxo1b/cS1ntssI0=;
 b=mp7sDo1FwaTe5F7gkawX+kEK356QOLgPfh+38jm2weK+AQAWEHNlZlhg9oQ/mr5KLG+rGUdv4mX66iLldIr+/ibJFatIh76zIHULd1OUEF6QqftYJfqq8CpKm1nwAsRg8tbAGR36ZLAhej0/bS8U9BKY/5vHcPzKe/75Z2iwyAs=
Received: from DM6PR08CA0056.namprd08.prod.outlook.com (2603:10b6:5:1e0::30)
 by SA1PR12MB7200.namprd12.prod.outlook.com (2603:10b6:806:2bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Wed, 11 Oct
 2023 23:01:27 +0000
Received: from CY4PEPF0000EDD1.namprd03.prod.outlook.com
 (2603:10b6:5:1e0:cafe::12) by DM6PR08CA0056.outlook.office365.com
 (2603:10b6:5:1e0::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38 via Frontend
 Transport; Wed, 11 Oct 2023 23:01:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD1.mail.protection.outlook.com (10.167.241.205) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Wed, 11 Oct 2023 23:01:27 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 11 Oct
 2023 18:01:25 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v2 vfio 0/3] pds/vfio: Fixes for locking bugs
Date:   Wed, 11 Oct 2023 16:01:12 -0700
Message-ID: <20231011230115.35719-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD1:EE_|SA1PR12MB7200:EE_
X-MS-Office365-Filtering-Correlation-Id: ddfb046b-f248-4c22-0a83-08dbcaadffd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSrJ64bxTUdnLvugGGNGqjQtOil7gsCkNkivk4gIhn+ybAWjMIXhOmgSqCOH2INHbNWcNKo5MrVM8XnvSQL0mX5n+gJwUFlilf5uy+dDBng6y8CQ6vzDjz477u7EECe3/Bv+nzwPGCUCmJSH1pePOniJfbqzFDMN7qzzXCS0+Ut2CcG3BEm2BtFBppmltmjnzCE9AvzjHcf2XrbJfyPKYHid4Nz7NBJcfHhjR8l6LxYgZhMeSStqju78sXWY6vUyfEq4+sUgKYTmUvQfNjY0Vuild8d/CRQQAatJ7hW1uZvsnJ8EbkuZEP73T/GmKNdQv5i/w1xwwQMvIzLb05Xs2aleR3KqBNwM2YNf65OOwesJcov2P9O8fchdbbxBF6vZ9SwNRKPQvZOLRL6E7A2rhOg9iwDa+IGj+cbQ46P6646fpzewvraGCXbg+Hik3guT0G28xu35v35PqImiTWgXKCXjI41B3cFUoTQFGbjDxeSz2WSINSaYDeEl23D5ya+1eCYua01K/Z5Xz+vTeLElG5B8nuoNbJFYskGiAzIpxf295lnqAWf/WKm6baWK/JeFt39Qa8H/dhMCeNSri9EdU+SEYRruifqusDOF/cnFTZIWeX2P5umedBsqYvOBpzmObj6LdSFR8EtStBXJhhKJrnvzUGTgMmRBpnPaHmUjWaMqYDLfbsZyk42eYb4ggRJXwPLn/FZ66/WKrJ8MRdIlj1Dq5YhpQdDAyJP/cZ0ZLY3QVp/de+s1GZhP/dhUrg74Z7vWS5Ux/0iSO0qIsOH+kkWtAjliCU2NoOh76ye233s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(82310400011)(36840700001)(46966006)(40470700004)(6666004)(356005)(86362001)(36756003)(81166007)(40480700001)(4744005)(478600001)(2906002)(41300700001)(82740400003)(4326008)(5660300002)(966005)(44832011)(1076003)(336012)(83380400001)(426003)(316002)(47076005)(8936002)(40460700003)(110136005)(70206006)(26005)(8676002)(70586007)(36860700001)(2616005)(16526019)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 23:01:27.2464
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddfb046b-f248-4c22-0a83-08dbcaadffd8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7200
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series contains fixes for locking bugs in the recently introduced
pds-vfio-pci driver. There was an initial bug reported by Dan Carpenter
at:

https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/

However, more locking bugs were found when looking into the previously
mentioned issue. So, all fixes are included in this series.

v2:
https://lore.kernel.org/kvm/20230914191540.54946-1-brett.creeley@amd.com/
- Trim the OOPs in the patch commit messages
- Rework patch 3/3 to only unlock the spinlock once
- Destroy the state_mutex in the driver specific vfio_device_ops.release
  callback

Brett Creeley (3):
  pds/vfio: Fix spinlock bad magic BUG
  pds/vfio: Fix mutex lock->magic != lock warning
  pds/vfio: Fix possible sleep while in atomic context

 drivers/vfio/pci/pds/vfio_dev.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

-- 
2.17.1

