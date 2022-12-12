Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADCB64A777
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbiLLSru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiLLSqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:25 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBB8C1;
        Mon, 12 Dec 2022 10:46:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f98YTb0450eIwa5aDG3UOQJaRs7bY4Mk/Fw89t+NYRpMni1A3WBv8PgJgJEa76vmoVRtVIrmiwm1kgUKF7aEpgBvufxCZZrnp4WsH5gV3v2ek3o+iC819WVvKs20LtV9VUjqElpHw4gIsIikGqCpHIqnaWy4RDRwkMESyPbWNe/U92DumRc4AKc38kzPluMKigtBB5kU8keAXPnlr4mQ0Gy2+b1RhW0+KPTXHeXByWivR1NfAl4FV1O+OcwzRRCWEK/Nmgdl/gbV0Ua2tSj8s2X79uIB7pyWBclLXcqoltOoh7CBW9rqBR1Jhlg2ejLD6MPcnWv3vThOSb2oqCbDyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdlU5t5ROVHiX+sexpmytiLcd2RXj+fIMA8NeXnn0rw=;
 b=fK9Ev2AVwssHwahfDbSpEqA7+Wl4qlkksYdIEtVkz3BRICIkPh1ZYC6jvPJlxUliYXXaLjEAlsip7O/fME1neQPnMEN1kqRYyySqiYKHinBQyVwmuNFzIb7j4W9jss7FWW+8YroW3Ad/f0WZYcmNmaR53PSISbhWF/s4WjjTi6iNm25WF6y7fsgEMxkHdpw7S0ybPp2oybTFyawPYr37b576cizDMVgmbimcBxmfzR4QLuZ40dHo3s5txVmR1sDzO9yJ+sR+eJ9hsf6LHmXCFKd7DQy+poP5ybyJlyMw6Nh2Rm5DX9gIm9/8t5kVUk/5pJ5LxZDI4BtxoGaZyPRdKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdlU5t5ROVHiX+sexpmytiLcd2RXj+fIMA8NeXnn0rw=;
 b=eXLGf0RT9sV9R4QGgR7l3e/6Ag6kL5eqqndy8EgZeiLtX5P30LSvM+eydP3BHYfSlii2Ty7daW91IuuO4x3qR2YowL5xMe86HnRmLhGVxB/XbtJQp6WIV6dcz1jhyMgQSdTXi7uj23zsc+9+F/7xJOzHI9S5s5BinmLkjHNQ0pA7174w1DuMuFvFhC+6pySJ3UaJtCyvyzbJ/KZDCOU724LGxuewQRd+nDVEDnngqCbNt0EPH5+w0nXTiH/32BCLDrTqBTibkfmpdV+CXX20fCOd3y+DLnUkWdcw+/luWT8UVWDTsYJcjeqPCspjq7PMMn4zUVfJzsd9sXRHWqw/VQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v2 2/9] iommu: Add iommu_group_has_isolated_msi()
Date:   Mon, 12 Dec 2022 14:45:56 -0400
Message-Id: <2-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:c0::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 269f7f40-0593-4045-dd56-08dadc712070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RjfN/JpJZ2fPbuj5jyVgnHfzLVbYRdtcnhyp2YSMgSckE6EqvZcj23mr9b3yerfNxuQ4e6cFMSFqVPkuBm/VvkcRAl5k1XsTjpW1FwjNgMxzrGvF/L0sfWX9aMgD3TPTULkaU83V2MKoBPs85St7kjmSckyx5U1o9R5g3fKTx0fzT2YIFZKbOLyhSUx0AgOV71fpzD2apntjq+QhTc9RQqRpeGDadrwfyUpiwD7oZPsGlxNtcwPrGHH6ISK3Yj+g8OVGOSoy5s6yoQLDnY4kZCpKg4FN0ynIMTiCn0SnEt/N0SQQX2G7FnNdHGGiNyMSUwwi2bGQ6COh3sbrFkF3HB56N49cnq15uBO/fLfHS8FJXJuEUUtfC7A/2wkMMTmlgSMIDMmOsAEr9W1rynFXM77zKuJPqd9OPxDO1I6EOpHg5/yWpB1xZhe5dPSkXAmF2lRBwva1DcVFQ+E9u1VKlaHAxkuSbckX/eFhjLFyhBIvx/9NKhlw8Uc6gZdvf5EAdziO/d/hBIT6OzR6Wgvk+fu+YyUwj385+62C4Vc6AjOjksHDA0d0tuwhcwkV2rTzuVapk8yduS3um+erZ1PF3lpCe+jeZc/i3mzyDOwq4NoWf7plQWMPjvjIzKAlePV1tvVIyXVE21o0E+PVC3kaaJBci8I9zO7Jg3Ajz9314fTX9Y6mkH9vgv3YAKTfwG3pnndDx+o9kVoZAM+vNP83zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(921005)(2906002)(38100700002)(41300700001)(4326008)(26005)(36756003)(86362001)(6506007)(6666004)(66946007)(54906003)(8936002)(7416002)(316002)(110136005)(5660300002)(66556008)(66476007)(478600001)(6486002)(6512007)(186003)(8676002)(83380400001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q2LUzG5GoHU/s1ePTptp77NqaipacG1i0Cju9r6X34tO8oUgJreSjFFzipnY?=
 =?us-ascii?Q?9oLh5sPA+DIJ4NZzbXVR1Sgd7kyf0xVqhVPn/ZTqKBAlRh5l9e0sgPfR3Mov?=
 =?us-ascii?Q?wLI7NfKS7QvrZKSUQ+4ISDh+KGjAVTUIQdDTrHrF+mmUFqw/c/T7OEnfsX7F?=
 =?us-ascii?Q?R9CH+cD+bi7XFC7JoHiuTsLVu4ymCl35GhcnsRwp/uy5q0nqqn2Go8v9DEdc?=
 =?us-ascii?Q?M4JZKzBNWPeUTIgV0wU1SUMmFuI/X0peTfair12R8KzJcOWcDrF2MwC9DpRL?=
 =?us-ascii?Q?hz+OvrV66FSnN6HhZqhxGR5tf4UJirZz87y72MjYOx5SCd8P+lsexmfnj5Ws?=
 =?us-ascii?Q?aPI+1iLWRXSBzQEZdBstpkU1ui6+1NIU7ZLQViNmGZMEXNdNYa0HwaD8HwIz?=
 =?us-ascii?Q?oV83Lw+lLRnnHVXan17c6CMVugMKThv/b/9Ku1kcVA0iw4LBuLXxXMgT49dH?=
 =?us-ascii?Q?LtNL2XnC5tsX6wL5pvatSQyoV2cOaAHvk/sO8Q0lHNwKP4j+Mk+nkmsLaW1W?=
 =?us-ascii?Q?Ekn7MAIeV/ehPyFbxvqLUoiIydVHbCO7TZ0REiNlJnolIMS6VE0jH10dJcOD?=
 =?us-ascii?Q?MtyXmgYJ/f4QVKN+TouDNDQKlQVPcwiZaq4yyQJdrrc5mcUAJSKlfoKDs218?=
 =?us-ascii?Q?GhtG6K+7pEhW2p3Nw6RF5xbf89bIAqdtpkJyOeS6dwPCULmP4x95VZ5tCePl?=
 =?us-ascii?Q?i50mxt3qIiNJLhEte+yW/acTgrkHskK5XN2AyDuP7Y2/Yq4NKJ52VaG2U+qg?=
 =?us-ascii?Q?xwUC9HYKFcQsXmE79lcxjj4YHepp9etMabqLPPj6o23xI0mn2P+HHFSjSZ3m?=
 =?us-ascii?Q?I2WXnoIb6PtXhR8P+dAFlzKUnNwRtN3PnYMFLqpdAh4KBCizrz0pc/3xVXER?=
 =?us-ascii?Q?jkPzEDZqEdHkL/fSBNRa5OFav2Uo5CN9KEbDuYU8PByfpH869KyOe0QAZ3eT?=
 =?us-ascii?Q?BR3C4MvQe+hICPGlvM6YGNKiUXrA9ArZKH5Bp2ORDVV6JTONP1v64Ab3UfaZ?=
 =?us-ascii?Q?4SN9sVl3NSqEYwIcc4r0Pju6xV/3d5pZbutSw99s3X3lMvyg4yJ9MUs8Znq7?=
 =?us-ascii?Q?gNZhcb2k3/4rW1w6wp1c3+fimYh+uIRdkSIjEjX27KO3AfsPtkp1BjBFjOww?=
 =?us-ascii?Q?g6VCRSBL3YOor21GGdffvP5iuw7eBXYmNVcJeS9xUaxZtg1v8sM1Gazxi24b?=
 =?us-ascii?Q?mezIQKlCETtRMZBjSR10gZBhkvLoYyNWaymZ/j47uFlS3gSlu/du7IvWNdFg?=
 =?us-ascii?Q?9GJ4/RHOD193MV1xWMv2OR2HqtETVnrPoIxs8JhdKga4T/kEsH3aAsQukzDv?=
 =?us-ascii?Q?wwicUwwYfHm+Bc971lOv7tfBcChmvr6BO0AmetK7OWPvRlIilQ9Wp7lkYVJ6?=
 =?us-ascii?Q?+M5qz815O/aCAVYovcN/auaM285DRPutyiKuA5ZZXenNVuBtcSvoFFnqp91R?=
 =?us-ascii?Q?EmnO/IeCqbnyskoV2xHuKLOiFnSHBqoTsnwSNb34mqj6T/3Q2NmZXi+38FBf?=
 =?us-ascii?Q?ORMZujuRGXVW7ct/KzbU3wS9e4GYU8X+00w9P1d+TQg0Ui+rsZy46OG0VYQL?=
 =?us-ascii?Q?0riiF7uGrqMlyOBhSMnoWm83Niqr8BAdZWpYZln6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 269f7f40-0593-4045-dd56-08dadc712070
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:06.2216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vDALB+Qo339ym21va9uA2AE3HTq9fL2QuXHUxHK38LdPQws7ljWhhtHo1Wlg1GH9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5748
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compute the isolated_msi over all the devices in the IOMMU group because
iommufd and vfio both need to know that the entire group is isolated
before granting access to it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 25 +++++++++++++++++++++++++
 include/linux/iommu.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d69ebba81bebd8..adb3f655bf5709 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1881,6 +1881,31 @@ bool device_iommu_capable(struct device *dev, enum iommu_cap cap)
 }
 EXPORT_SYMBOL_GPL(device_iommu_capable);
 
+/**
+ * iommu_group_has_isolated_msi() - Compute msi_device_has_isolated_msi()
+ *       for a group
+ * @group: Group to query
+ *
+ * IOMMU groups should not have differing values of
+ * msi_device_has_isolated_msi() for devices in a group. However nothing
+ * directly prevents this, so ensure mistakes don't result in isolation failures
+ * by checking that all the devices are the same.
+ */
+bool iommu_group_has_isolated_msi(struct iommu_group *group)
+{
+	struct group_device *group_dev;
+	bool ret = true;
+
+	mutex_lock(&group->mutex);
+	list_for_each_entry(group_dev, &group->devices, list)
+		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
+		       device_iommu_capable(group_dev->dev,
+					    IOMMU_CAP_INTR_REMAP);
+	mutex_unlock(&group->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_group_has_isolated_msi);
+
 /**
  * iommu_set_fault_handler() - set a fault handler for an iommu domain
  * @domain: iommu domain
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1690c334e51631..1753e819a63250 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -455,6 +455,7 @@ static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
 extern int bus_iommu_probe(struct bus_type *bus);
 extern bool iommu_present(struct bus_type *bus);
 extern bool device_iommu_capable(struct device *dev, enum iommu_cap cap);
+extern bool iommu_group_has_isolated_msi(struct iommu_group *group);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
 extern struct iommu_group *iommu_group_get_by_id(int id);
 extern void iommu_domain_free(struct iommu_domain *domain);
-- 
2.38.1

