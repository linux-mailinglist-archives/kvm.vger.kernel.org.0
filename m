Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B5A7A0DEB
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 21:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbjINTQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 15:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbjINTP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 15:15:59 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC2D26B2;
        Thu, 14 Sep 2023 12:15:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZM8rmgLi/0F1wPJ8BPD4NOMvbjIhBi7Gb2HZeWAAXKMoAecXafTx/+vuvfkaA7tj9WDgYe0eOHQft9hjSwJhXxSQHJz089VJR5xtfiRbkX8MVxzOaCpe7ULVyTMhpImxikJglzXqGpZQ/oSJj1UwjhGh6DMM11kuHXJQj9W2qjcgK/+m5Fg25bQOKzh2H3TObm45OougiIjNhO1oOwnyiax4zMlDbjcP+9k0uKZqnKPJ31ioh/2ArrtNOZAlU6tK487HOcK97qsdzQPVLQl1WrgBvtmsPolKzEx5xMPtIP6UpUIDo8Dozzy11FFeow55CafpMH9e0xgEwjKf+DjtZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpGY4mX3sYfcbli+YvyyUGxQylw2BaNO79x9i5zt+TI=;
 b=Yczc99Wy48Ktd6EWkG6gMosI6mG1NKmpPsAkmJC587wfPyeTCpc5TtXwoesk3I9D7N1pdkhHi0IMUinqyvnuR/EfvSHRPkef1HalMDlnFLKtwmxfO/z6tGhdNf0AP5bmSDvrgyv/bsVsIsbXfGEb2I52/YXZrpzCe4ZCAtWRbHP6JxZ5NuLZRc4/2agtrrODghqgHSTL32m/anbAUpy1gWgs13bZ8ysnKrRhTOB3Ol86lmYImEcDwRttR/lFH4HHgNnFqlgfLLHDI0Nw69KQZNHY+nExCIinkhC92FQfAdfqaV4srZh1BIOfjt5jpZeBMWLvzufmP3X5slVQZp6PMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpGY4mX3sYfcbli+YvyyUGxQylw2BaNO79x9i5zt+TI=;
 b=mgKFx6ukLkALHOfb3g0TzwxG2piUT8O8I4z5sUMe+cpB1CCuFoSIdnSlraKPTY5+pMe0kd6BwhoJrcyPVnUK7JMdJr3AWG7yOodEpTKpK8fxN4/dqVSTuzvmnge4p3db9cny6Qdc7JgiWxWnRJBhKGxay9YZe/xIpuT9fHg3guY=
Received: from SN6PR05CA0032.namprd05.prod.outlook.com (2603:10b6:805:de::45)
 by PH7PR12MB6786.namprd12.prod.outlook.com (2603:10b6:510:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Thu, 14 Sep
 2023 19:15:52 +0000
Received: from SN1PEPF00026367.namprd02.prod.outlook.com
 (2603:10b6:805:de:cafe::48) by SN6PR05CA0032.outlook.office365.com
 (2603:10b6:805:de::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20 via Frontend
 Transport; Thu, 14 Sep 2023 19:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026367.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Thu, 14 Sep 2023 19:15:51 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 14 Sep
 2023 14:15:50 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH vfio 0/3] pds/vfio: Fixes for locking bugs
Date:   Thu, 14 Sep 2023 12:15:37 -0700
Message-ID: <20230914191540.54946-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026367:EE_|PH7PR12MB6786:EE_
X-MS-Office365-Filtering-Correlation-Id: ad563476-c442-417e-77e2-08dbb5570300
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VS+p2tRn3yIE03hI+FeILsgpbhG5f8s6HTSQ3rZDYGpP+du9VH4SRzeUOZdRZkH7OI7JlcZkCVgVSWCTuDAACoowweJmrWbVBxa5TYQMsEp2PBprcguDpgRkTjJEVHTs5lvTgRGJNsqgRwP/cR0WZRejA6r652CB/CNGcqhxHpTIPeXmqiNP6LuNaJ+nvHy+N6kWTJlkSLX69PFGylGsqzWZ4vr5mNQHnFtujkbIfryBD4UEFCsDVp8Z+Ze6po8TNjvyKlwe2TW/GKezTv3jJpzJUlZczEpzlnVLebw1FEjPdIQwy4NuKxMDlYRTIq3eUdmp5j20B4ieDPpZqJiHKwoUIexIMFPH2dSkAwp8hlzo90INAOmFNlxShW6gL0x99CoHeJsXwD5DNXRA6aonQDdBHaHHq4g9V2AR1AfEirgsnw/t3jYvgdvCe0nHdw+gpa2NS44jlOLs60XsQNGGRFU5KZQt4JNlEJ1XRAi1hLtfTYfw/MWUVdb4ubdJDyxXmCR65wajxQEoD8mFTJZy20HjNH5qu9mtQNe28/Yv2aXGfdI5sTmQuqrxOdfic+XUYf1xlX9hTJu2QVLgEehFj5nh7vbFlljdml9iO2iF4dlSyDBYraYGwvdQ3s1wl/DOc+Ov+unUDad9LTB52grKCVS918Gj8ZaUXYKQwfqlvWA2V1B9O0QLhpW0VLD0QSnYf+8z9ylxpanct9OT5EXCMAthyMgE+tt/uaa247f8Jt6bDqjqjAjvUd1xPoRlMKstylAYnqBYS2UCr29Bz6NlBQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(136003)(376002)(1800799009)(82310400011)(186009)(451199024)(36840700001)(46966006)(40470700004)(41300700001)(40460700003)(86362001)(2906002)(110136005)(356005)(36756003)(316002)(4744005)(82740400003)(478600001)(966005)(54906003)(70206006)(70586007)(6666004)(40480700001)(83380400001)(2616005)(81166007)(5660300002)(1076003)(47076005)(8936002)(26005)(16526019)(8676002)(44832011)(36860700001)(426003)(4326008)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 19:15:51.9576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad563476-c442-417e-77e2-08dbb5570300
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6786
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series contains fixes for locking bugs in the recently introduced
pds-vfio-pci driver. There was an initial bug reported by Dan Carpenter
at:

https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/

However, more locking bugs were found when looking into the previously
mentioned issue. So, all fixes are included in this series.

Brett Creeley (3):
  pds/vfio: Fix spinlock bad magic BUG
  pds/vfio: Fix mutex lock->magic != lock warning
  pds/vfio: Fix possible sleep while in atomic context

 drivers/vfio/pci/pds/vfio_dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.17.1

