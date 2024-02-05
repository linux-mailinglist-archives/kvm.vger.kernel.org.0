Return-Path: <kvm+bounces-7964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C41849447
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:17:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C9341C22CFD
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 07:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5536A10A2A;
	Mon,  5 Feb 2024 07:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uPzpqUWl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FDE11183;
	Mon,  5 Feb 2024 07:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707117400; cv=fail; b=eqagH2JJXdLssgh0aKtVIS1sGF2qGIMW3ZQAGN/gFqlxE9oJhaULqmETpa9dEIWZ1c/o+W+3xKg9AmGGL8IhVXW8a4CKdW19iwUf3WrqgzkLgQvE5UllyRUtULgB++8UuYAHIFYuyutPgeMrwGjVATB2cLJS8lDQckhNmQPuZnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707117400; c=relaxed/simple;
	bh=XDUjT2RipXL+pN1Or9h24jRDmABMKXn8L9DnpthLwh4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V3vdGq3GOpdeWxPIh1OXBRHKLV9uaxXfsr7evY0hjVd22s2ME2k+ClmAsi3uq8pXvEwkk9mQ1/nB2jDTAbK1QApLIOVFFT5diR/x6W7ylB8X7BTRata+pbHKt4j839vJuBRFx/aVeYYqEOELZlAG+3SwFaMBrEvxK3za4Gy+eSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uPzpqUWl; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSmiGT1bCPkpO38FRdqVlADXqa1JUa6aYP4IaXeBy/z4f1seukAd+/SZEesydDRwYbJXqMzU5u7DnAfXFI7vFydj5ZKFHGsJflCl12j+HP9IusJBiHcfdLRRDDCFCbR+L1+nw20MhbyqQOKen2fou0uernjzxQKQJfPc8yrpQDOKVSR2FGQH63og33f5kKngkZFlT8EDYWLHTG2BPATdhylxUWU/XstNAk35Xv9MRPDX9fIIlrZLRxCtx0lWNEBfOTCM9shItw92uY5BbuF5PnNEhnJAkD9PXKaDecXQfK+w6PB9xV8KD7ciLstEyjqnsygMj9F2WNkjv3G7us1ZfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6ClfOSQjnDVDzAoSzJ0jYNUNtjoRbwMQLMdTOJIqU8=;
 b=IBVIp5WDf/KeUw+gkTp5XKi7SIOTCQ//DPBa9c9vwCe35tUGI9k0A9xzFksAaeemf+LO6MRLa3V1U4raQf2ONwfAd1PfqDN5zBJBBbKr0JEQ7vv7Nx+PVlfokfrQH70IAHTiY2Y/jXjv4M0AfLlHtSxHFueCHVaXz4WcE5DWEl5M6TUGa+1uYzrFvOgAgnrINurbL/DqcfSwHJ4j7ioTExsDx3Dwrn3Mnj/xudYs8Ta6PEU+PxNj/9LpePNvMmoMI0yo22WiNDui5/TFUDyXUx9JBOoeftdHoIB7OvbRfkabrO2Fxwq53xu5sMDxz+MZw6hWc+xxlXtyC8liDXW67A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6ClfOSQjnDVDzAoSzJ0jYNUNtjoRbwMQLMdTOJIqU8=;
 b=uPzpqUWlBZrSF5x+QmeD4ef70W0O/megQZg4xMppMjZrBHGCJSPnC52leHMvKY7wzRAsvE7wCHpSgIn3DtFEElex7+W2TBxCzNIlSuHam2bb5a33LbU2XW+0lotuB6hwJB8F0MaUpfrvATVu24XnFwrvmQgBhbTUOmJ9Am1RGm8=
Received: from BN9PR03CA0589.namprd03.prod.outlook.com (2603:10b6:408:10d::24)
 by SN7PR12MB7883.namprd12.prod.outlook.com (2603:10b6:806:32b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.15; Mon, 5 Feb
 2024 07:16:36 +0000
Received: from BN2PEPF000044A8.namprd04.prod.outlook.com
 (2603:10b6:408:10d:cafe::22) by BN9PR03CA0589.outlook.office365.com
 (2603:10b6:408:10d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36 via Frontend
 Transport; Mon, 5 Feb 2024 07:16:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A8.mail.protection.outlook.com (10.167.243.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7249.19 via Frontend Transport; Mon, 5 Feb 2024 07:16:36 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Mon, 5 Feb
 2024 01:16:34 -0600
Received: from emily-Z10PA-U8-Series.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.34
 via Frontend Transport; Mon, 5 Feb 2024 01:16:31 -0600
From: Emily Deng <Emily.Deng@amd.com>
To: <bhelgaas@google.com>, <alex.williamson@redhat.com>,
	<linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <Jerry.Jiang@amd.com>, <Andy.Zhang@amd.com>, <HaiJun.Chang@amd.com>,
	<Monk.Liu@amd.com>, <Horace.Chen@amd.com>, <ZhenGuo.Yin@amd.com>, Emily Deng
	<Emily.Deng@amd.com>
Subject: [PATCH 2/2] VFIO/PCI: Add VF reset notification to PF's VFIO user mode driver
Date: Mon, 5 Feb 2024 15:15:38 +0800
Message-ID: <20240205071538.2665628-2-Emily.Deng@amd.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20240205071538.2665628-1-Emily.Deng@amd.com>
References: <20240205071538.2665628-1-Emily.Deng@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A8:EE_|SN7PR12MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cfb04df-c13d-4e66-1c18-08dc261a63c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ex3S5/IIg6TkFMk9WX2P7J2B6qn9wt5hw3uVxy3zraSBvbV75/V139k4J2rxpOly8OoSMt4NXLRLMqaURzQutyFo+18J2ykl8BmyFPfpzEygoQegx9gIFPBCYTxam2pvl8QSUbPCzm3kA69pDczNhfkLTboU3VN07PQcERKDz6GxI2ljPTWP+9xIaAa6fjSDkiFQWqFlfKJ2q0vRw73fy49JewxVnbu1dbVEVcg/N6E9V3e0dPDRh6juEUEe8164fg21wUm8svVRHv5W0LJ9ji4o1P6P9HjMpJJQbmiZxnt5mGpL6xfsU0f/MDduTCYrAUf/zaLryll/LBWXLNSVSc1ybz8sk1Ejrt498kandcTa7QstfWBeBze8/gV5VxtzggPqJw0qCV/KUjCMLGcKd+QOi4VsH+uQK0ALDpS9ImHiiKivGIYIlZj3NAh+/C0mwYZebyS/kDYgSd1wH3ntpjV+Dts3RFunpGB8jvRXpybZQMvIlEeAdvQJe+Hb/uUX+P2UjAnnlfPqONnejmlCgZkxs5nOOPLiZ+jm2ivFa6E6X+ZYT2CAPtSHeD0ftHHK/1mO/XaKRgLYU6wIQrYQ1Qp81SNWOwVH489z+bqtr/BHe9T0d2jijBLw/+4ZpHSRgkPhgyjy+dtXdo2hSZTsAWOf8W+Jpjut0Hsl9KazyVFLgLx2gKmfRrxzaFalak2I6VE8fl/RPVLSMLPkXBryJihOMrK2jqIfneGFwLnFqpAReBwobUB1hHy+qk0JK5F3/QOooX1l5CQD5B9RUiPJMaaY5zeCQG39Zw3wg0ooTKOZJ3MOwe6luQ/QuO9bxhVn
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(230922051799003)(1800799012)(82310400011)(186009)(451199024)(64100799003)(46966006)(40470700004)(36840700001)(2906002)(110136005)(8676002)(4326008)(8936002)(40480700001)(40460700003)(5660300002)(70586007)(70206006)(316002)(54906003)(47076005)(34020700004)(478600001)(26005)(7696005)(2616005)(1076003)(36756003)(356005)(81166007)(82740400003)(426003)(83380400001)(336012)(36860700001)(86362001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 07:16:36.3904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfb04df-c13d-4e66-1c18-08dc261a63c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7883

VF doesn't have the ability to reset itself completely which will cause the
hardware in unstable state. So notify PF driver when the VF has been reset
to let the PF resets the VF completely, and remove the VF out of schedule.

How to implement this?
Add the reset callback function in pci_driver

Implement the callback functin in VFIO_PCI driver.

Add the VF RESET IRQ for user mode driver to let the user mode driver
know the VF has been reset.

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
---
 drivers/vfio/pci/vfio_pci.c       | 14 ++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c  | 26 ++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_intrs.c | 30 ++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h     |  1 +
 include/uapi/linux/vfio.h         |  1 +
 5 files changed, 72 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 29091ee2e984..25b8d0a69532 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -185,6 +185,19 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	return vfio_pci_core_sriov_configure(vdev, nr_virtfn);
 }
 
+static void  vfio_pci_vf_reset_notification(struct pci_dev *pf, struct pci_dev *vf)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pf->dev);
+	int i = pci_iov_vf_id(vf);
+
+	mutex_lock(&vdev->igate);
+
+	if (pf->is_physfn && vdev->vf_reset_trigger && vdev->vf_reset_trigger[i])
+		eventfd_signal(vdev->vf_reset_trigger[i], 1);
+
+	mutex_unlock(&vdev->igate);
+}
+
 static const struct pci_device_id vfio_pci_table[] = {
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_ANY_ID, PCI_ANY_ID) }, /* match all by default */
 	{}
@@ -198,6 +211,7 @@ static struct pci_driver vfio_pci_driver = {
 	.probe			= vfio_pci_probe,
 	.remove			= vfio_pci_remove,
 	.sriov_configure	= vfio_pci_sriov_configure,
+	.sriov_vf_reset_notification = vfio_pci_vf_reset_notification,
 	.err_handler		= &vfio_pci_core_err_handlers,
 	.driver_managed_dma	= true,
 };
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 20d7b69ea6ff..1740d41231c9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -686,6 +686,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int i;
 
 	if (vdev->sriov_pf_core_dev) {
 		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
@@ -707,6 +708,17 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 		eventfd_ctx_put(vdev->req_trigger);
 		vdev->req_trigger = NULL;
 	}
+
+	if (vdev->pdev->is_physfn) {
+		for (i = 0; i < pci_sriov_get_totalvfs(vdev->pdev); i++) {
+			if (vdev->vf_reset_trigger && vdev->vf_reset_trigger[i]) {
+				eventfd_ctx_put(vdev->vf_reset_trigger[i]);
+				vdev->vf_reset_trigger[i] = NULL;
+			}
+		}
+		if (vdev->vf_reset_trigger)
+			kfree(vdev->vf_reset_trigger);
+	}
 	mutex_unlock(&vdev->igate);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
@@ -718,6 +730,13 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 	eeh_dev_open(vdev->pdev);
 #endif
 
+	if (vdev->pdev->is_physfn) {
+		vdev->vf_reset_trigger = kzalloc(pci_sriov_get_totalvfs(vdev->pdev) *
+			sizeof(*vdev->vf_reset_trigger), GFP_KERNEL);
+		if (!vdev->vf_reset_trigger)
+			pci_info(vdev->pdev, "%s: couldn't enable vf reset interrupt\n", __func__);
+	}
+
 	if (vdev->sriov_pf_core_dev) {
 		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
 		vdev->sriov_pf_core_dev->vf_token->users++;
@@ -764,6 +783,9 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
 			return 1;
 	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
 		return 1;
+	} else if (irq_type == VFIO_PCI_VF_RESET_IRQ_INDEX) {
+		if (vdev->pdev->is_physfn)
+			return pci_sriov_get_totalvfs(vdev->pdev);
 	}
 
 	return 0;
@@ -1141,6 +1163,10 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 		if (pci_is_pcie(vdev->pdev))
 			break;
 		fallthrough;
+	case VFIO_PCI_VF_RESET_IRQ_INDEX:
+		if (vdev->pdev->is_physfn)
+			break;
+		fallthrough;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index cbb4bcbfbf83..afca7eb1aa3a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -776,6 +776,28 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 					       count, flags, data);
 }
 
+static int vfio_pci_vf_reset_trigger(struct vfio_pci_core_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count, uint32_t flags, void *data)
+{
+	int i;
+	int ret;
+	int *fd = data;
+
+	if (!vdev->vf_reset_trigger || index != VFIO_PCI_VF_RESET_IRQ_INDEX ||
+		start != 0 || count > pci_sriov_get_totalvfs(vdev->pdev))
+		return -EINVAL;
+
+	for (i = start; i < count; i++) {
+		ret = vfio_pci_set_ctx_trigger_single(&vdev->vf_reset_trigger[i],
+					       1, flags, &fd[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
@@ -825,6 +847,14 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			break;
 		}
 		break;
+	case VFIO_PCI_VF_RESET_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			if (vdev->pdev->is_physfn)
+				func = vfio_pci_vf_reset_trigger;
+			break;
+		}
+		break;
 	}
 
 	if (!func)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..f188c99dd82f 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -85,6 +85,7 @@ struct vfio_pci_core_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	struct eventfd_ctx	**vf_reset_trigger;
 	struct eventfd_ctx	*pm_wake_eventfd_ctx;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 20c804bdc09c..e2504182b34d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -643,6 +643,7 @@ enum {
 	VFIO_PCI_MSIX_IRQ_INDEX,
 	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_REQ_IRQ_INDEX,
+	VFIO_PCI_VF_RESET_IRQ_INDEX,
 	VFIO_PCI_NUM_IRQS
 };
 
-- 
2.36.1


