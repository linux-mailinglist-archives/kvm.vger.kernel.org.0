Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C441498818
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 19:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245149AbiAXSRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 13:17:41 -0500
Received: from mail-dm6nam12on2055.outbound.protection.outlook.com ([40.107.243.55]:40672
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235979AbiAXSRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 13:17:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0iVqeY9PvAa4CpMKsDLw59XWiSky43vT0iN6KgeTdF0QCumVzKEAsowGoJEsQS+kFFWDGurDZiC+zxwUwSUc29z5q7T5WjMOAJBqrCNsd+nKaFCf851yvpm9zWmOtxo/z+rKA57ZXn/mZ4HiBncgMqElK+yZwlt8gCY3VvvQPdA9joFQ72NBvSyX9in5nQprnNmooaZmfMbWG9uPxGTLklfUxZt8DBFe+zGfVwhGkJGf+rEsWXOJEK7VRQ8ti6pvPQoYW4sr0LGvawkvdujqxpi/VSAMNntCJy1gL2yjEecNZrV27n7zBplGmb9UXKmikMGbg1iGufH9pUU5fEgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01DImWNiDwd0MhYLnLrJZz5zwgfsp7vtPfRqWTwdSYM=;
 b=RrM6c5aqLSXrfV8pQJphx21ZzU8eIbTo6LWLQxLZNQMvhip8vMv1IlKzOLCRSRWyajWdm1374/7mFyRRFoBbcIPuEIoMtpDjSf8uLrs0S/ovo56slIBajabWH+2O0rKTTT1vC+UxDWiXjhX12K8/zOWeiBpLwo1+vbfAvyh3xzWYiN2vD1uraV4H/AM2emTdAfIh0JmN72QV98dgoO6IxUBZ83WA5vb+YtZqf2fzzdGLwbHjRVXNoNIcRwzSc6yIpPwgS0566kMX6Ev7WtyIrUhorztNapGav+GFkvihC882NFcg17GyrU+5g6QEYK8IpoXdXt3Is67nqO4LsrM+ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01DImWNiDwd0MhYLnLrJZz5zwgfsp7vtPfRqWTwdSYM=;
 b=QrsZSZN3SQ5KZvq3IuvbVRfZKnknblOUoS0f+vLvGU5KqO53HeJQ4K7Xcj+7fzo1W1nJeSmHammoc4KzxlQbdebHoo8+mCTTqef0/WftrqqK5RXxM9rxMn1xMNLBS5X3YpzTffQq2vUftaCZ+PVnKkJf4oAYc9VNAY6hVZUhX7l4SE4txU/rVZdT14jol10+seFf5kosiZbvajBpYurV9Jc/iydCk1zJ9rZyB2VSoFMKHRILrh5eisYahhYN9LaPQ/YpiExzVWOfWkCvKUxnQ8dHvmaTjz7k4PhMRA7D0Hg+gwt01IhPeZOfhBNYfP54quOlGbzUmwLj85jn5QU4YQ==
Received: from DM6PR03CA0021.namprd03.prod.outlook.com (2603:10b6:5:40::34) by
 SJ0PR12MB5633.namprd12.prod.outlook.com (2603:10b6:a03:428::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.13; Mon, 24 Jan 2022 18:17:38 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::62) by DM6PR03CA0021.outlook.office365.com
 (2603:10b6:5:40::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10 via Frontend
 Transport; Mon, 24 Jan 2022 18:17:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 18:17:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 18:17:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 10:17:37 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.13) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 24 Jan 2022 10:17:34 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC PATCH v2 0/5] vfio/pci: Enable runtime power management support
Date:   Mon, 24 Jan 2022 23:47:21 +0530
Message-ID: <20220124181726.19174-1-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8da6f9db-c00e-4ecc-73cd-08d9df65cd9c
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5633:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5633D76F8A84C46B95D295F7CC5E9@SJ0PR12MB5633.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 60TLniBI+84p5eEX0QWTadggpw9onyamaELjBkmNgUZAgUovMDAAO3N5y/4FMCKhX/PRiDdWkcGBtFloC+AsbNSvyiwtFK63rvOWthUnMb6DSPijBrtj19/PltJ4MnyKFppDpGN/fqSR8nCqlmtzs/tQYmOLXGnVOrKzr6lRUuzE0a7vGFiyLAaRUSQxpB2E8K4koMn1w0j25bAEzA4Akx1RgyLQ2zvXSVYslLnj2tty1lb0OPYXQ9/aQQ77YIxP8muLIHAvJmxLW99GQRyjDrmeL0lRylca9b6XXdUooMB1U7bbAyajilhRSNPpNtVoExIH7nJARj8/8GzOyT3ESMmuBg06bCNDw4HDOZEhPCLFYI9dAdWX/Uu9RRu+yBJ1Co2kr1113sWUqBqdFVOuRmXGXBSL9jmMIjZDLRkzBCzGlX6HESNSJ+72XmB+BQ1GpGcp4kuDOMDgkF8t3QZtXztdid/J6SG8eufGWAny7m45qxRYgojmN4bwj2ejy/g4jh+F8oS+6YC1ZBGQZp2c6KzAsN1hHQidQ6Pdk6sL4ubA0TjbiWVzB8ubtS3yazLLtH8O5xMpQTLsWBebXvRyRE2KT/04eHZ67yj3mkSWWyje7+Kavy73y3LS0BtKYoSRuWGOhMXfd2UfpcwZz+to5L9k2+bqX3f3qRoDrA3OKHQpyWUcA35hwpiD/oYRPeF75iihxyvWEQCe2+Ld69X57BCVLlj8I8pO9kIRKK+nWRt43IM09/aJcTPU3wIk8ioGOqL68n1TXRDhA1efA2JzgUo0qh00DPj1SgR0QbUT9qs=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700004)(6666004)(8676002)(2906002)(40460700003)(54906003)(5660300002)(8936002)(86362001)(7696005)(70206006)(110136005)(82310400004)(36756003)(1076003)(47076005)(83380400001)(316002)(107886003)(356005)(70586007)(36860700001)(508600001)(4326008)(186003)(336012)(2616005)(26005)(81166007)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 18:17:38.2659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da6f9db-c00e-4ecc-73cd-08d9df65cd9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5633
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, there is very limited power management support available
in the upstream vfio-pci driver. If there is no user of vfio-pci device,
then it will be moved into D3Hot state. Similarly, if we enable the
runtime power management for vfio-pci device in the guest OS, then the
device is being runtime suspended (for linux guest OS) and the PCI
device will be put into D3hot state (in function
vfio_pm_config_write()). If the D3cold state can be used instead of
D3hot, then it will help in saving maximum power. The D3cold state can't
be possible with native PCI PM. It requires interaction with platform
firmware which is system-specific. To go into low power states
(including D3cold), the runtime PM framework can be used which
internally interacts with PCI and platform firmware and puts the device
into the lowest possible D-States. This patch series registers the
vfio-pci driver with runtime PM framework and uses the same for moving
the physical PCI device to go into the low power state.

The current PM support was added with commit 6eb7018705de ("vfio-pci:
Move idle devices to D3hot power state") where the following point was
mentioned regarding D3cold state.

 "It's tempting to try to use D3cold, but we have no reason to inhibit
  hotplug of idle devices and we might get into a loop of having the
  device disappear before we have a chance to try to use it."

With the runtime PM, if the user want to prevent going into D3cold then
/sys/bus/pci/devices/.../d3cold_allowed can be set to 0 for the
devices where the above functionality is required instead of
disallowing the D3cold state for all the cases.

Since D3cold state can't be achieved by writing PCI standard PM
config registers, so a new IOCTL has been added, which change the PCI
device from D3hot to D3cold state and then D3cold to D0 state.
The hypervisors can implement virtual ACPI methods. For example,
in guest linux OS if PCI device ACPI node has _PR3 and _PR0 power
resources with _ON/_OFF method, then guest linux OS makes the _OFF call
during D3cold transition and then _ON during D0 transition. The
hypervisor can tap these virtual ACPI calls and then do the D3cold
related IOCTL in vfio driver.

The BAR access needs to be disabled if device is in D3hot state.
Also, there should not be any config access if device is in D3cold
state. This patch series added this support also.

Also, during testing one use case has been identified where the memory
taken for PCI state saving is not getting freed. So fixed that also.

* Changes in v2

- Rebased patches on v5.17-rc1.
- Included the patch to handle BAR access in D3cold.
- Included the patch to fix memory leak.
- Made a separate IOCTL that can be used to change the power state from
  D3hot to D3cold and D3cold to D0.
- Addressed the review comments given in v1.

Abhishek Sahu (5):
  vfio/pci: register vfio-pci driver with runtime PM framework
  vfio/pci: virtualize PME related registers bits and initialize to zero
  vfio/pci: fix memory leak during D3hot to D0 tranistion
  vfio/pci: Invalidate mmaps and block the access in D3hot power state
  vfio/pci: add the support for PCI D3cold state

 drivers/vfio/pci/vfio_pci.c        |   4 +-
 drivers/vfio/pci/vfio_pci_config.c |  44 +++-
 drivers/vfio/pci/vfio_pci_core.c   | 363 ++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_rdwr.c   |  20 +-
 include/linux/vfio_pci_core.h      |   6 +
 include/uapi/linux/vfio.h          |  21 ++
 6 files changed, 411 insertions(+), 47 deletions(-)

-- 
2.17.1

