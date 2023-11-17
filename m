Return-Path: <kvm+bounces-1894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8747EEA2C
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A2D91C20A5D
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5249F634;
	Fri, 17 Nov 2023 00:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zE2hymqt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C07EA;
	Thu, 16 Nov 2023 16:12:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nH2Pye8xEh+Iyux2PmC1jste1S7LNOxUhuD37DDjuHOT93qK+qNFup9Gw3oXU817UrJspX9sA0e1zhEUuYRw1IAfAmy2cV6qH40m+mzxCNtWW7Tzop8ajtXGjtRYnOVw/OzotAm4K1GlQH+g9JJEi5pXNoLzyNed7l75khAGWV8mK8wpYwt3OPVXahce3KSIBI6PCwDW9IxDaaafnlLsL3gtRFPqbru6peSOuDgkn2akbD7P2SdmdBny9rvWIWWJt3aiNVBnr+3UFAvmt6M5WwV2kwA05n5HlFcQj0kOdOFJZgr21tkPt5/OczWwpI7KhXTMIiIJX1gwJ2M1/xZhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTyoY2i8Xx9g2b+pqJcCalArIA38GvHGlgllY/9ujog=;
 b=C5FjB/PCFRBTBiHgTOkwyQU06oBmkJMduWiI3orE/8aBmKiylJtuGJPK8kqNEoVpZ/NKjnRopzBaDjYwuSrgKcrlttMgCjKzF6lC9QVhOSyptzPW0jKog3jQtimczCcQ2oIeZt8VNxs6msMdScupjeX2E3VBo5omt2Vb7tHn6uUhkKLzs/mRsoAmrpRkXYwCXw/9VdNPFaEtiGrpDGEJe+TGZrL4RSK6npx82SHwGwKPVd9umpjQ5Dz9XyBiyajn7v9L92Xtw3eVmO4IUUir8YDFHjrNo83XgEcdgs1eyNJJ3L9MRbm78rKxs5vyRAwJreevXgbi6JjAilmWApTz+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTyoY2i8Xx9g2b+pqJcCalArIA38GvHGlgllY/9ujog=;
 b=zE2hymqtPI4fYel4xmaGn7qlqp77ymB4MAzbMaT3L9TNGIPKjC7PeZmCOXv6oe6SzLcPxoyBH+lobXJYlSMqJxa3g25AN4PU/WqsTEkueUGwdLwx7xO07hhnauLRIFTEEdtF2BK5IbH/ByZy+CqrzxAdcRfHgtJgxv9nie0RfWw=
Received: from PA7P264CA0056.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:34a::8)
 by DS0PR12MB6560.namprd12.prod.outlook.com (2603:10b6:8:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Fri, 17 Nov
 2023 00:12:21 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10a6:102:34a:cafe::d4) by PA7P264CA0056.outlook.office365.com
 (2603:10a6:102:34a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.23 via Frontend
 Transport; Fri, 17 Nov 2023 00:12:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.20 via Frontend Transport; Fri, 17 Nov 2023 00:12:20 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Thu, 16 Nov
 2023 18:12:18 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v2 vfio 0/6] vfio/pds: Clean-ups and multi-region support
Date: Thu, 16 Nov 2023 16:12:01 -0800
Message-ID: <20231117001207.2793-1-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|DS0PR12MB6560:EE_
X-MS-Office365-Filtering-Correlation-Id: f3a163a8-d3f6-4c54-1847-08dbe701ddf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VfUiDLt+qGs0FYK3vqH4Ss11FqrNVxz72chBzuArSH2X1a80iggemPz/6QoiJENMn3J3aEJAmm/62x7+XpAgC1IaPAsqaL0Hs3vHo6Mu5XBFCnEC+6VYO48I9+M2IEEal+rQD3p9kOfXleE8yhD6q809XwejA+ZpKjbR0S6lFXFEpnPnjRkvwq04UPOw2Va0KlZjtZXoFTEj2b4wdrjz1b2DcZv7aKCmg0BSo2Fv/G+ciN4orW4wHpDShgESltJxE3LQp1RzGAnyLm+q/U2d8S3V2Xx4n2M7uDykz7Y3YfgnppB5bk+AHpa+2Q/+P3yRNHxnFyDp3fox9I2w1NJKEbagZnyQ7tqdNpQDPpJfBpg2TatA6MbmVydWkGsZn375OKwgZSu+kftpOFFu23Uz9LlPHfMxLGibam/d2nYWeSPpyq4VHN5aWO6ducNxwhMaqP9CNWMtjWFnGErLXFOGnkwpRwX/0choZ9MPv0KUCr+rzKzQteUavVwBdTDHAoBa8EwoaRBg7g4m46oGaws4rUVJCh8BvsGtienXTi1ZCSM3bkZOhyxxwU6PmnUgDxxQfjnsTu92rsWA+9f0KLmH5GXVTyBcMlJb7pCqgmd7VTrKSXuEPEyF+QtEF5iik6g2PwKylPlWoqLSSn7oc5nXl3mnkTmwU0OEOU1r+Aws0rwvx47C/jNoupLtUacVnaCYsSNN0kcb9/2gbUzquLeUiipdScnIdvJGORJEVtHWkuASo81OFisgSz9RhEXlBTGl
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(39860400002)(376002)(230922051799003)(186009)(82310400011)(1800799009)(64100799003)(451199024)(36840700001)(40470700004)(46966006)(36860700001)(81166007)(47076005)(356005)(83380400001)(82740400003)(426003)(336012)(1076003)(36756003)(26005)(16526019)(2616005)(6666004)(40480700001)(478600001)(966005)(86362001)(5660300002)(4326008)(70586007)(70206006)(110136005)(41300700001)(54906003)(316002)(8936002)(8676002)(40460700003)(44832011)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2023 00:12:20.7268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a163a8-d3f6-4c54-1847-08dbe701ddf3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6560

This series contains various clean-ups, improvements, and support
for multiple dirty tracking regions. The majority of clean-up and
improvements are in preparation for the last patch in the series,
which adds support for multiple dirty tracking regions.

Changes:

v2:
- Make use of BITS_PER_BYTE #define
- Use C99 style for loops
- Fix subject line to use vfio/pds instead of pds-vfio-pci
- Separate out some calculation fixes into another patch
  so it can be backported to 6.6-stable
- Fix bounds check in pds_vfio_get_region()

v1:
https://lore.kernel.org/kvm/20231114210129.34318-1-brett.creeley@amd.com/T/

Brett Creeley (6):
  vfio/pds: Fix calculations in pds_vfio_dirty_sync
  vfio/pds: Only use a single SGL for both seq and ack
  vfio/pds: Move and rename region specific info
  vfio/pds: Pass region info to relevant functions
  vfio/pds: Move seq/ack bitmaps into region struct
  vfio/pds: Add multi-region support

 drivers/vfio/pci/pds/dirty.c | 309 ++++++++++++++++++++++-------------
 drivers/vfio/pci/pds/dirty.h |  18 +-
 2 files changed, 204 insertions(+), 123 deletions(-)

-- 
2.17.1


