Return-Path: <kvm+bounces-1698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB21F7EB817
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 22:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46B40B20B91
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 21:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF052FC3F;
	Tue, 14 Nov 2023 21:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QWk2O0d+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA7B2FC29
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 21:01:48 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2F7A1;
	Tue, 14 Nov 2023 13:01:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rn/ecIAw77oUpZ+xoORQGac7vxXJH3c2DkKMSIcbXZHvfYZVVH7ko7H+AgAzrS6dhGJHyaWYclm42Qq2kN6+V/lufBZazZVTlxadMyl7O1dtv50WDW3UdAuUckrocCAo54GDtYVxwuLF0xlmlteuq1paEsGx393PA6a23YoI8P38eeHHYn0H1RVO7aCahRXt0VY3P7rYfj7DVFZXO/+acmjxpHJhUZbMyLJMYq6Ravwn9aROzU0G8EiyCmMzK83YiQWHl1/YFuFPc5Y909cIpAf72QjOVthjFZYn2/b9WzmD0VGX20xbk9suAaLUmlTEM9SLOiTnzZYHDeRpIVJpNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jbeUg+HJ8fRTpw2rXxXdvCrsrLiJlw16RhTyzKnevc=;
 b=dxDx0ZCX64YHyqRXoFYUEn0L1gMAUvFY2DZGluh6MwXnmMukG8v9CalmyZ75yFVnwFyFs3DBIDLI+YAYAqdrsWQKtsvPHLkR+lXcj+BBF9BtEOc7k2L71W2ypDya7rid9M7NJI3Sy7lf9irKfjaP4dLDOeV4vUsotgaW/xW3YGpiHwvQo3eOgjOnItja9nZ7kXx9ndP/xXBvGDdbXjP7A/c33iZL2Ko1lYoejIIP4vlPKbp+XdzHa6+yIWJO6f52n1QaFB8IeL7ANNufE280gXpkhyQpVa1MfVXFqDegnnQYv+L184inyv1kK+EO4zoByHIpwfciA+ZlGwZyeu0YmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jbeUg+HJ8fRTpw2rXxXdvCrsrLiJlw16RhTyzKnevc=;
 b=QWk2O0d+lSoCOHw7dhFSugtr3FG11Gds7ntHrqsqLt9RQdZu+lIgk3kqoN0cXu7ePIYju5F6kej2/B5Owt9BWGdaywSKSE8p5r3zA26paH5OfNh9XeO49vo3q3iCc6ETX8UniaNEOUxljTEYDegSFnFaUgNq2sCGbDdQP1+78Yk=
Received: from BLAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:208:36e::8)
 by SJ0PR12MB8613.namprd12.prod.outlook.com (2603:10b6:a03:44d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Tue, 14 Nov
 2023 21:01:44 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::2d) by BLAPR05CA0004.outlook.office365.com
 (2603:10b6:208:36e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17 via Frontend
 Transport; Tue, 14 Nov 2023 21:01:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7002.14 via Frontend Transport; Tue, 14 Nov 2023 21:01:43 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Tue, 14 Nov
 2023 15:01:41 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 0/5] pds-vfio-pci: Clean-ups and multi-region support
Date: Tue, 14 Nov 2023 13:01:24 -0800
Message-ID: <20231114210129.34318-1-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|SJ0PR12MB8613:EE_
X-MS-Office365-Filtering-Correlation-Id: 26cff021-2572-4949-12fb-08dbe554e7f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	at87GNbC/cqeEov95IQvW3jYI9WGpDXFXmhC5qbxT6/OKKnTlZAuSrUfY1YBsXB6bnMqAE4DdTNmNrpJ8SPirt3Ps60d9A3Q51MYGgIybXhS3auefwoZZVLh7GrRnMoHuPoFsGIKGQdH++ti10iPPN4VYFBQZO13v5jNvZ9UB71XHIse6gxXqjIw/eZoMwEGcAzlKLUo0GsIAsK61rl0cVEy/tHs1XxjH4gXjphjOQo7pXNPG6UkwFu7tazfHX+UaD74MHBkYoH1flzX5hWbX0geG3bNHc8hAUlvVuBePK6qoZNUOcdVkS3w62SZy9A/YPgrMGDkPPHbAiZIeKB26d2ktnUozf9TwTC2RP8UvQm1i/X97WO0du6pTZAYZ6oEhQ2IsaTPxzJ5FEXIfXXCoAwXA15PiXY5rTq18PmxsM94hvggwWrrjspsF8gFsSErpHcah253OVdPHIXn5aebVSLLWh18OqyxffxxFfCpVegN24bMEWuBk1sAg2+VHCglgG+UhN+GGtJe9kTfEZPpDmRXxPKP9vM0O4/c9kvSUJrhg2Q4uDMd5oX+xLC3Mh35pl+DQIKagKjnSHSpLhggcU6SzX+t09SRVZU8vzzRzQp4Ll0jV78MuGlRgKS5F0T3g0v6IrZOa33Jd37JmtghKyzKCtHuT6RxmKwSbw25uJU2K4LUIgaHjfrmeXJSvy7K4n5Jdrp7YsY3ASi0KuZorSZdxiul+W4GB+DcMOjsuq1aMYrrErh6GxDFWDYuPVkKAuHGbkxhZqg71kQh7Y8GTQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(82310400011)(64100799003)(451199024)(186009)(1800799009)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(86362001)(2906002)(1076003)(2616005)(5660300002)(4744005)(41300700001)(36756003)(44832011)(82740400003)(356005)(36860700001)(8936002)(70586007)(81166007)(4326008)(47076005)(8676002)(336012)(16526019)(26005)(83380400001)(70206006)(316002)(6666004)(54906003)(478600001)(426003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 21:01:43.3171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26cff021-2572-4949-12fb-08dbe554e7f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8613

This series contains various clean-ups, improvements, and support
for multiple dirty tracking regions. The majority of clean-up and
improvements are in preparation for patch 5/5, which adds support
for multiple dirty tracking regions.

Brett Creeley (5):
  pds-vfio-pci: Only use a single SGL for both seq and ack
  pds-vfio-pci: Move and rename region specific info
  pds-vfio-pci: Pass region info to relevant functions
  pds-vfio-pci: Move seq/ack bitmaps into region struct
  pds-vfio-pci: Add multi-region support

 drivers/vfio/pci/pds/dirty.c | 311 ++++++++++++++++++++++-------------
 drivers/vfio/pci/pds/dirty.h |  18 +-
 2 files changed, 207 insertions(+), 122 deletions(-)

-- 
2.17.1


