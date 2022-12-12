Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D4264A784
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiLLSsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiLLSq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:27 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4941109B;
        Mon, 12 Dec 2022 10:46:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gew03cTpWhyE4yUbcv99zQJ8PzZwfntrb5OxuPTktBYQMyxGGcJlAYt3hYw1yWsDDIrHDZSgGor4r1JgRSD5s2HQR+Gvgh03sX+h5iRdebaw7FiwxJzlhwrJQqQsvUImBw0HRupKtDEJ3BnL4zW2aDwj9loSMVutykvbrzkvPLuQfP0c0tyc2cnd50GtwFNL4z7kqEnzM9nrSYZYkVaw3dVTsX5/i1rdzZGUCWmiRLb7V/Lwb7zc5QjxFJVeihbPpsSpTb765ESzwBbpACdd0UPry2U36B1bu4SylJLq8/++RpKq6an/L0S1dk3B569fG/kjXueE+nyk3t4u03b0TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLUh9X/SnrWsXSmE7ZXssRUd+/cFtgHH1Ch57qlPSx4=;
 b=Ntv4ofxmoQlC08n+wi8Ecn1vroa/OxJjXNqpYbj1LRmuht/j4gpOn6cW3g7/iAbNCqCbT7ejB1Dgi0ZPQSXsD90TjpjJXDlNcm8mF7aDCWhdJGxV+0UWUQ7eY399La6OO13kTlWISYnaNUatmKCYHW7ZlZAmU/M+2ipUX2f2m0KHa8elC8Un04HCjd2hDeYLPCWNP51UDCgqEnxBioAdsqRZ+fnSyRpM2oVwws42xzxmYK1ha5TlNIII4/RFwkW/+j469/X3lov4816O3EbbHPGTG9UNdo6I4OzD5yzG/vFeCSnSNiDGbNabcMYl/sd4V8jWO1v2EZKCeQib/wFY1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLUh9X/SnrWsXSmE7ZXssRUd+/cFtgHH1Ch57qlPSx4=;
 b=Gg1unIk504QcA8LFMsBVlMs8SU95WfyVpS1dB3BkxO0tjEJQKNpiMUmvg+Az67EKn7+3qEoygHocUDwcLHOqXs8Anvb/+cpRWQ3dz2B/EE9iTx9bXXd/LBw7C2IvF+mePBTE0vsdo1/a43CPPOesdbZEEeoFc9NCjcKzRNsK9Ea1NASl0ldksJYI2pSeWNJaakGhsOG1TwAz6+f3jaFui9Z6NiHXCk7t1gc+ZSbGMCahhZ9GU4J1SMHzgZIdOFNRl05CML7ao7T9Turyj+jaaPUTvRnO63v3x0cuWdS80bAlp4eUNpgdiu6BoIFaDO/RLeMot1Y6GjmTDENgM4zphQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:09 +0000
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
Subject: [PATCH iommufd v2 6/9] irq: Rename IRQ_DOMAIN_MSI_REMAP to IRQ_DOMAIN_ISOLATED_MSI
Date:   Mon, 12 Dec 2022 14:46:00 -0400
Message-Id: <6-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:23a::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 04e1f4ab-2b11-4078-fdf8-08dadc7120b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OVZI1p7zLlsLmRyMdsbyUpHuBRoLS7pKGANmIXPuC60ewMDSILDwo2k20tu9/xfkLbV9ZEB9XTRZH/1rV9kAVTVKGRg72i0m9ANEYaPd9wQblmlwHMc67e2NmV/eWTGUTVHD3Ko4QbxyeOWuK5wW3q6cTOb4WKcQyRAFKMjQHWV2QFeaRd2/qmqt5aUet9JIAjFdsHln8Y4TEl9eRab7QZUsuvdDuOyRYJZv+wsToMRcJruGQJo5dxyJbBLsXpZk1As7vKe9ZLGy8g/srDRxDSYz3sLt/D4OF9HdajcEYqyB4RuLJ5BLNgiWhkJwq6XtC6ZD3rL73wZDXyj/qZti1iCVBx4MhdzmcerNIuElDxqxg8/+tN2xtBZFjUNIXG7hfcyP/62I0Eq5FRgsrjmIdxaFyqp2U5COpmXa9FVR6ktSAzI5PqtfnrvA1uXqJxGjKyF3VTEMsi30vWkvM9SeH77tN5rbDVJuVCp0MjtDhDXwt0YVsjVUpWBH5cfJAWVO4p7fPtOSaume21na9O/XSX8RhMTFl4reFmtHXlo6a23pfLmjr7JndNsuYEz9WRW4uMBmhdUBmP2VQ7IvS5/SOgt2PrBc90Ut/U3Si/tUg+YYAxS3/cJuAnHfC58AQUmcFKNkWuoSTTRcT/ZRjvmmvj1NkpFX7n4RTF2VLuGx4RtasPbaXdXELbHfzIAB1tXxoCm3fzqpKWAtp8GVTatsIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(921005)(2906002)(38100700002)(41300700001)(4326008)(26005)(36756003)(86362001)(6506007)(6666004)(66946007)(54906003)(8936002)(7416002)(316002)(110136005)(5660300002)(66556008)(66476007)(478600001)(6486002)(6512007)(186003)(8676002)(83380400001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f76T03qT5pLC8KD854GGb6uG68bLR193IclTesE+b/JnmGNeW6fLwhf4OkgO?=
 =?us-ascii?Q?4bwfGjkFcoR2cfJCIbOExjk8s8ZEpnNrtsR+zR3q7a0q6OMKOownPv5tjpQF?=
 =?us-ascii?Q?9c3GOhBf9kUpVihdXE7uy8HeJMt/sOiQQgMwPS/qL0BggFg8mCzL5qI3nN2x?=
 =?us-ascii?Q?hhCn1A+XrU6G0hMA/g85phf0+hE9O2Ywp3pB8ocSUwpTC/3Czg5sDjnJBtBG?=
 =?us-ascii?Q?wujVvT7ilpJr7WM+PlqXvRBSunwbfCoGSq4jUp5J8Ld47LWN/nhDXslwuLwL?=
 =?us-ascii?Q?ELnK2t2uIv/IBW8pBvWCHh3EFmEtQ6ZRhEQzFFhMAPr/R9p+2+EFTTGC92Kr?=
 =?us-ascii?Q?XHkWAEGUEBvZggyVM/oZBjByD7bBC7/47hCT4iWXgzELxpDNzaocqACRrUn3?=
 =?us-ascii?Q?wViwsv/3PYX9qYjm1YzZkhT/et3wGALmOFHKrCcJMENz3TBeKzz6CY7MyJiu?=
 =?us-ascii?Q?dtmRF9JNlQNylS+/ynIML4iFCZ3D+qkKWUfobufuWJ1tFvjZWe4H+OucpT0I?=
 =?us-ascii?Q?GzvD92jhz1vVAHcQlZCCQwIijRzwl7uynva7dmwh2Xf/aWSNKPu0AhTDGh9Q?=
 =?us-ascii?Q?iu1pzjpYbf48yiP4eG68omojchpQPEjzD/8Vtmk8nVOAJ1ZFErntkJGsQuuG?=
 =?us-ascii?Q?zbTZdAcgOQqnIN3WWJR85UYPJBd3zqchdsf0T6ZAsGv7K+AMwHy9CyoYnLwF?=
 =?us-ascii?Q?F7j5cMmLo6WeGLLMK5uidDcwL0UE0af+zEXE7A2sTr6EmFPQd/uNv0GlK2FW?=
 =?us-ascii?Q?JD3v3cyqgRudxq5RJpDTmfuy+Szsl7L6vjWDvav0aJ7pak+6qXRleWjoM47z?=
 =?us-ascii?Q?Vp/++9M0sLJw9reqQB3WR0C3c8tfyDyeE2xfcYusxT9Rqw4uuG0eBMwAiePk?=
 =?us-ascii?Q?EmIh5TUe9XbXlTmO36OFoJYCciZjjzhRM7tjUwrbqWXN4Wsly2t1ujIj3vrV?=
 =?us-ascii?Q?iXKMhaUo3VoqjDx25bjGwf3ws9cRRZMvAVDKo270r9B2dxhT9rZmuxlRaWEa?=
 =?us-ascii?Q?e86DrVRXfYeP1iPkrQcUVVKHZ6B9BFAYfJY0P5XlZkpNTR1XuU7NDhkebgPw?=
 =?us-ascii?Q?hAZFALz4uNfZfLa61eIUddvC1S7Yn5Pnk5VzRxEQuWnfF8ehytxaWbg2n4Hu?=
 =?us-ascii?Q?c52alIIuTpDLCHY20XWuQIxRTTjrHtnyQsiYt9XlDy8sb/k12DKK5Nngie41?=
 =?us-ascii?Q?SJgetY/qIrGTx7LwvZPGJmWUjAoz8et69e1BFIyMbKDcjGORpjMwdkzoAgA7?=
 =?us-ascii?Q?TAfeWICRRmcgz0P19Q8NpD5ZgJD1g5fNns7qIsZlvZlJwJGGeYoPLG81tbCd?=
 =?us-ascii?Q?/YJryRYw/cnqigy4Fl1JCqNH+7DDZaoGO+WMYO0DQIMa+rBHVATau+Xbw01Z?=
 =?us-ascii?Q?pc3wys1aYvaS2lt35NUn557orQbbRkFiYvdqRCFCtkcG+NeLLPVHUwf4jhRF?=
 =?us-ascii?Q?4efBTWiTD7N22RGpxBQx8FJFNFbjGwTnoGOWWVMKI77Hs+8q1afVl/wIaErc?=
 =?us-ascii?Q?Q1KdmCM3I4T7RwqoLjd8+p4fU51LqKb3RyBgvkCP2u5/37QtY6obBP72sFL4?=
 =?us-ascii?Q?3vKQw1HYg0LYu1vZzMBo5ZxptVXLAOvf4XAUCQ3J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e1f4ab-2b11-4078-fdf8-08dadc7120b5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:06.6278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o04GRqHcPpPIu7yaPeDxo32hmi/74xgal70T9V3CiN2g93u9826QOkhjr+hgfazu
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

What x86 calls "interrupt remapping" is one way to achieve isolated MSI,
make it clear this is talking about isolated MSI, no matter how it is
achieved. This matches the new driver facing API name of
msi_device_has_isolated_msi()

No functional change.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 ++--
 include/linux/irqdomain.h        | 6 ++++--
 kernel/irq/msi.c                 | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 973ede0197e36f..b4069f825a9b73 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4692,7 +4692,7 @@ static bool __maybe_unused its_enable_quirk_socionext_synquacer(void *data)
 		}
 
 		/* the pre-ITS breaks isolation, so disable MSI remapping */
-		its->msi_domain_flags &= ~IRQ_DOMAIN_FLAG_MSI_REMAP;
+		its->msi_domain_flags &= ~IRQ_DOMAIN_FLAG_ISOLATED_MSI;
 		return true;
 	}
 	return false;
@@ -5074,7 +5074,7 @@ static int __init its_probe_one(struct resource *res,
 	its->cmd_write = its->cmd_base;
 	its->fwnode_handle = handle;
 	its->get_msi_base = its_irq_get_msi_base;
-	its->msi_domain_flags = IRQ_DOMAIN_FLAG_MSI_REMAP;
+	its->msi_domain_flags = IRQ_DOMAIN_FLAG_ISOLATED_MSI;
 
 	its_enable_quirks(its);
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index b04ce03d3bb69f..0a3e974b7288d0 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -192,8 +192,10 @@ enum {
 	/* Irq domain implements MSIs */
 	IRQ_DOMAIN_FLAG_MSI		= (1 << 4),
 
-	/* Irq domain implements MSI remapping */
-	IRQ_DOMAIN_FLAG_MSI_REMAP	= (1 << 5),
+	/*
+	 * Irq domain implements isolated MSI, see msi_device_has_isolated_msi()
+	 */
+	IRQ_DOMAIN_FLAG_ISOLATED_MSI	= (1 << 5),
 
 	/* Irq domain doesn't translate anything */
 	IRQ_DOMAIN_FLAG_NO_MAP		= (1 << 6),
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 1c6811e145f170..7c5579d3ea4f79 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1644,7 +1644,7 @@ bool msi_device_has_isolated_msi(struct device *dev)
 	struct irq_domain *domain = dev_get_msi_domain(dev);
 
 	for (; domain; domain = domain->parent)
-		if (domain->flags & IRQ_DOMAIN_FLAG_MSI_REMAP)
+		if (domain->flags & IRQ_DOMAIN_FLAG_ISOLATED_MSI)
 			return true;
 	return false;
 }
-- 
2.38.1

