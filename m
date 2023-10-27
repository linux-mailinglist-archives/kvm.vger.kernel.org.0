Return-Path: <kvm+bounces-2-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD987DA395
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 00:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CDDE1C21210
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E007405FA;
	Fri, 27 Oct 2023 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="siuBEOaT"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE8F405EA
	for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 22:37:09 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFB81A5;
	Fri, 27 Oct 2023 15:37:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxmEBNTop/0I2G/teClcSO54+Sy/77Q2px5PkI6vSfOVhmofmGx+KPu31jau/ZIUdbCfeiLpfe7jX3Y/0Laiz51qGi7gxr7wCY6Bkh1KSCVUeoPPbuezw2rkh3I/8Mh8TYPn4t2fPQtCA5GfMmMP9Qn9fnudDI9MkrVIcV8DPxZDgNZenws/y67teurkGPM9c8TDPiQxF356iymUVukvYh9alTyD/WfR7rWDfgabGsVzJ1WSIHHzeMig8GbZSlJ3gINd25CynXT3OnVWEwRnworlC1JoxBgCyw6KO4MZswmnJdis/XlPzx8NyildPBuFp4h1KjvCZC1BChjxbqPXzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0BqHflw6gvRp3mIlubCrQJK0lU+Nu+vtISWSgsOEHCA=;
 b=IfFPRRTXYNKRieiyuiifMzLd2Jn6GqxtCWdvr+1gGkfWni1f1T5I3AMbq4ESXs0L1tmnYeE3e89yNbO58vFrj87v7dFtem0ALqF1MzPAljXYnCbEI1baTwvIy6ofQFM6I6+INXj/BMm8BBqpRxtFtgX6aUgetJylnrUjwznbYQ5TjwcnRK5u7ddxcHfRTvUEE08a+5vRzaqCc5/RocK375+MAKBJTJILKujh9QTWpv+0mm73lQGgyCkaGSZGKXmhrtL5MCtFJFh8ks2q+Qi8Vy4bTNoggwSoc46O6hAy970lyTE1J/czGgxLF56s2lMa2jaLUhU9A9mD8vTCKEkrQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BqHflw6gvRp3mIlubCrQJK0lU+Nu+vtISWSgsOEHCA=;
 b=siuBEOaTi1Jwy11xJryAJL3ZTDZhb7pDPMDC7PSfawYcukaOIXNV9NDfH9ToSMYXLO8u/neR60AmJ2mrPTRh5r3BfbpHU8xOIE/K/0gXcKfJY8TUEh/XCo1vLQwv6CR0HUYEuA2j2NojmHF1S9e4LPHwBtZqchUTQ3wplv4W28Y=
Received: from MN2PR16CA0030.namprd16.prod.outlook.com (2603:10b6:208:134::43)
 by SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.24; Fri, 27 Oct
 2023 22:37:03 +0000
Received: from BL6PEPF0001AB50.namprd04.prod.outlook.com
 (2603:10b6:208:134:cafe::ec) by MN2PR16CA0030.outlook.office365.com
 (2603:10b6:208:134::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.27 via Frontend
 Transport; Fri, 27 Oct 2023 22:37:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB50.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.15 via Frontend Transport; Fri, 27 Oct 2023 22:37:03 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Fri, 27 Oct
 2023 17:37:02 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v3 vfio 0/3] pds/vfio: Fixes for locking bugs
Date: Fri, 27 Oct 2023 15:36:48 -0700
Message-ID: <20231027223651.36047-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB50:EE_|SA0PR12MB4447:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d1ce0a-7159-41ff-067e-08dbd73d3dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0tYqK7rjzsTzFcQ8ul70FZR86qVmQGPkwlAoJCwsHZFA1xYgDR2e8fyghq/2JQA31vLe2ESDWnOmKRp6W5eIfhFIG/2HoJBK8FXRJhE1oxniLXLPLfOjQBWWAGr0kOZk/ojlFCeVLZ02xS07UYxSTC0TUNTvnS49rFaditaYRYM7+iTQYPMoQujY4AAMdjX0JqEjThWoiFGhUZW9UDZKsMWvaobLhZpZnF/mUvNicvOSFYHN7q6RbOD5SBjCpSM07+3QLep9JhSXVWkUQ3wEmpyOEt0CAIzKnMWj3BvFgeUF2yIabcmHVLg/Vs8PnxFIRgnJ8lfvTvbsWM/9L5HH+fNdof0GIcNUGED1JHmwskMlzyJIxW3F+8QentDmAsvSsfDg6kMn9wf3MkuPFyXC+pdQJMXKZ+ZbITBOhBFftBPS08DeknOjaMeg1OJszwmhv6TwGjAInzh0UsHWk4zS6HrNpz72A8NxmZyRq793pFKY8cTuryeZp4NxZroLd/cRbNRuGjfC/1ZfFtIfnMmaZgZR1jcrQCiqXOl5JQZEbnCKfdLl737a+jcKY37KbbJv/+fJPARmTaS0RA1cVjxSaiP3KYMUX9ztc9mskH+qkf+xnFQlsZE3bYHMXCMaTW22FDxSZpFzud6yPWHKCaWfMUyMfEknTQS2O7QDGWUuQDm0qYr+YbeBgyI/s0D+yMyn2zBPw4vMHKgupPOhYO0mYybG7WEzEzMdrPg3Eeg+GMin0fbPD+jnxZZWORryEKErxqrKgQPRNVr7lEN7EQeiGanquYE5eMChsdWFYdHVcXf2dlwl0G/bt2HBD4C6YHpfhymsrq1eB51zjwGeljBCTg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(376002)(346002)(396003)(230922051799003)(230173577357003)(230273577357003)(1800799009)(186009)(82310400011)(64100799003)(451199024)(46966006)(40470700004)(36840700001)(47076005)(40480700001)(36860700001)(70206006)(70586007)(110136005)(966005)(478600001)(316002)(54906003)(8676002)(4326008)(8936002)(5660300002)(6666004)(2616005)(86362001)(44832011)(2906002)(82740400003)(41300700001)(40460700003)(336012)(26005)(426003)(16526019)(1076003)(356005)(81166007)(83380400001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2023 22:37:03.5426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d1ce0a-7159-41ff-067e-08dbd73d3dfb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB50.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4447

This series contains fixes for locking bugs in the recently introduced
pds-vfio-pci driver. There was an initial bug reported by Dan Carpenter
at:

https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/

However, more locking bugs were found when looking into the previously
mentioned issue. So, all fixes are included in this series.

v3:
- Change reset lock from spinlock to mutex

v2:
https://lore.kernel.org/kvm/20231011230115.35719-1-brett.creeley@amd.com/
- Trim the OOPs in the patch commit messages
- Rework patch 3/3 to only unlock the spinlock once
- Destroy the state_mutex in the driver specific vfio_device_ops.release
  callback

v1:
https://lore.kernel.org/kvm/20230914191540.54946-1-brett.creeley@amd.com/

Brett Creeley (3):
  pds/vfio: Fix spinlock bad magic BUG
  pds/vfio: Fix mutex lock->magic != lock warning
  pds/vfio: Fix possible sleep while in atomic context

 drivers/vfio/pci/pds/pci_drv.c  |  4 ++--
 drivers/vfio/pci/pds/vfio_dev.c | 30 +++++++++++++++++++++---------
 drivers/vfio/pci/pds/vfio_dev.h |  2 +-
 3 files changed, 24 insertions(+), 12 deletions(-)

-- 
2.17.1


