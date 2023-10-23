Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BFC7D40FA
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 22:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjJWUht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 16:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJWUht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 16:37:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B82D78
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 13:37:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUCLCB59+wR1wcsM+88LxnjPOQV26Y9KdchhaZRY+23xWHBOshNpE6+b6MQLklp2gVnVIRwLICy8Pp3ApFVuJ/vCTNEsNWBhvLCLl0uecgWqa8EX4Sl/4+oGgJrHKyDzTtwmEt299NlxgzumCzK+NnfFEk1U4u84vNX0KmKZ8+dWcDDp5YivqateXv/h8NtPQ+cbsMkMfFoXhZnV1UK1Rcq6TRB/0qmtTSh7plzuTilMLHLC2+mEYaCP6//dnQHykjYYwNrOxdl9guTP2q6OfL9tbmBD1CVNDmE96SlBI1zBUIEMD06UBiY6Ly9JejFipWCPk97TVNCJUZKHZwx+Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzsY5iDHvL8FIeG3B14lucIY/L9+/HGpaeCvrwFXoP0=;
 b=g3ILB5YYHKe4Emch5Tv5s+1eSvrZGn8uR/cUA/Uh1OkpdqZGhNlHHvSbXbABbqhe7kznHQ2/w92eawFd+le7m6iRlQO1pAF7YIFTYcm734mUMGDN0SG7q3Rd56gGc7PXUl9dgysW81QxgEST7dqt4dQhOXluFszIrkYY+CrOZBQzGZslndA0P7OQvwImaG0gbLKECr8Wfveatj53urOX1rSZuduggEY1aMD73J4t3vFDigHolcQja8eJWzZnc3U7CDi8QHFQornVL0ZBBD19MSN1k4n6rFJwEHJVPVZdt95PuhWskxwUWyb8bAZcRnGv9fT3L/slKL2vxJy5iIezsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzsY5iDHvL8FIeG3B14lucIY/L9+/HGpaeCvrwFXoP0=;
 b=sFkdpRe4UHg6uym2JpowkJ2/ubkV/I1Enbfqms7qPAYp6Wqvu14XRLgcMlBhO0UPcs/737c2fwN0DpsSBFgBPgUaKvr+rPTNAxb1DMhuj0VxfQtcGMhMmoK6haZx7ggdp8mD22yBBTytNsKy7GQjKr9A9JRhTEKhcMs0iXo6DizPrWD4rByIHZfuuU9vZj0AN1CvUkujL0LO616uvK7Cev1rpog4077dMFgWIURtruhK8s3z5XAODvwS1KjSvvb6F3ciIotTroCqY/mCs9n9VIeInaY3swr5SajdpHQYaQtTRU7QvHlNj6IM18HB50IkwZVwZj4oivHQNfQCBvO2UA==
Received: from CH0PR04CA0007.namprd04.prod.outlook.com (2603:10b6:610:76::12)
 by PH0PR12MB5466.namprd12.prod.outlook.com (2603:10b6:510:d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 20:37:44 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:610:76:cafe::ef) by CH0PR04CA0007.outlook.office365.com
 (2603:10b6:610:76::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33 via Frontend
 Transport; Mon, 23 Oct 2023 20:37:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.18 via Frontend Transport; Mon, 23 Oct 2023 20:37:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 23 Oct
 2023 13:37:30 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 23 Oct 2023 13:37:30 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 23 Oct 2023 13:37:29 -0700
Date:   Mon, 23 Oct 2023 13:37:28 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
CC:     <iommu@lists.linux.dev>, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Zhenzhong Duan" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 16/18] iommufd/selftest: Test
 IOMMU_HWPT_GET_DIRTY_BITMAP
Message-ID: <ZTbZiKhkrSaxpqNU@Asurada-Nvidia>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-17-joao.m.martins@oracle.com>
 <ZTbSx9mDWf7QwgjF@Asurada-Nvidia>
 <0a641e15-a6e4-4113-932d-ba2caa236653@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0a641e15-a6e4-4113-932d-ba2caa236653@oracle.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|PH0PR12MB5466:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aba6fbb-122d-40d6-e05a-08dbd407e8d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8kzsnnMBemn3HREf8merOQyq8NimMH9t8ap/GrpXOdcNH5Pq/m34e/tt+KQ+QL1hEwQwXsJ6psl8MQTxkNviWitHY35pyHjflZowvFteFX0JlyWjXXkmOF0So3GJzr0X1aCJEWUl2YabhSVlzLzP8vn3fSh2+NV1Ic9RF4BlJGj3gGSUwa0vWzlLVdFllB975II6yYaE3wh1dL1QeKQBE+ujcbCQ7U8YmYr3BJbkHbY7NWVArNoq50uTNscgDxhCQ84Hmsl4Q6wxDs+Ui+I80AbK/V/O582WL1I4cam6lr2XDivw/saVR9H9sIkTOS+eurmikn7wfOEteh39tpmLy25isZlJQoVRuaCRU14ykluFRita2QGHmoLdSLT58aNWBdJKxIYDd+ZL4C/jVsCbgKNk3qUJD3cpHYoP3pxviAR6TlDt89kEd8MLZpb90n2zjmFnlkTNtZtm2KiRfoeejzobx/+Dsr4tRGkZnzOBBTYM+JrcrkM44EsPWxsbxxChqeoOhKGlm22OmFH3RfVvQIVkwWWF0zSnZF5DqbIsoHO4DkbA+LD6vtAgAwFAFnf/PP/63Fh3APgbWjlW+f2fJ7QY8NVf27imuN1wYE6YvlhiNbdiRuQRCkyckMSl/7oqGZswLBTcDq5m6pZhF37A7rx2yjdpWB4Ylq88Vb403Anu6bjp6a72T6L1ALm0eJ2+Rg/GmbB7qruA+Nfg/vRASnWKxbtWwoA/hrXomwrFJxohNgxQObpTFD653gUGIjRqlC3+6xTeU6zpzp3AmUKNA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(396003)(346002)(39860400002)(230922051799003)(64100799003)(451199024)(82310400011)(1800799009)(186009)(40470700004)(46966006)(36840700001)(6916009)(478600001)(55016003)(40460700003)(2906002)(9686003)(53546011)(70586007)(82740400003)(86362001)(70206006)(33716001)(47076005)(36860700001)(26005)(336012)(83380400001)(356005)(7636003)(54906003)(7416002)(40480700001)(426003)(316002)(41300700001)(8936002)(8676002)(5660300002)(4326008)(14143004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 20:37:43.7906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aba6fbb-122d-40d6-e05a-08dbd407e8d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5466
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 09:15:32PM +0100, Joao Martins wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 23/10/2023 21:08, Nicolin Chen wrote:
> > On Fri, Oct 20, 2023 at 11:28:02PM +0100, Joao Martins wrote:
> >
> >> +static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
> >> +                             unsigned int mockpt_id, unsigned long iova,
> >> +                             size_t length, unsigned long page_size,
> >> +                             void __user *uptr, u32 flags)
> >> +{
> >> +       unsigned long i, max = length / page_size;
> >> +       struct iommu_test_cmd *cmd = ucmd->cmd;
> >> +       struct iommufd_hw_pagetable *hwpt;
> >> +       struct mock_iommu_domain *mock;
> >> +       int rc, count = 0;
> >> +
> >> +       if (iova % page_size || length % page_size ||
> >> +           (uintptr_t)uptr % page_size)
> >> +               return -EINVAL;
> >> +
> >> +       hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
> >> +       if (IS_ERR(hwpt))
> >> +               return PTR_ERR(hwpt);
> >> +
> >> +       if (!(mock->flags & MOCK_DIRTY_TRACK)) {
> >> +               rc = -EINVAL;
> >> +               goto out_put;
> >> +       }
> >> +
> >> +       for (i = 0; i < max; i++) {
> >> +               unsigned long cur = iova + i * page_size;
> >> +               void *ent, *old;
> >> +
> >> +               if (!test_bit(i, (unsigned long *) uptr))
> >> +                       continue;
> >
> > Is it okay to test_bit on a user pointer/page? Should we call
> > get_user_pages or so?
> >
> Arggh, let me fix that.
> 
> This is where it is failing the selftest for you?
> 
> If so, I should paste a snippet for you to test.

Yea, the crash seems to be caused by this. Possibly some memory
debugging feature that I turned on caught this?

I tried a test fix and the crash is gone (attaching at EOM).

However, I still see other failures:
# #  RUN           iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap ...
# # iommufd_utils.h:292:get_dirty_bitmap:Expected nr (32768) == out_dirty (13648)
# # get_dirty_bitmap: Test terminated by assertion
# #          FAIL  iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap
# not ok 147 iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap
# #  RUN           iommufd_dirty_tracking.domain_dirty256M.enforce_dirty ...
# #            OK  iommufd_dirty_tracking.domain_dirty256M.enforce_dirty
# ok 148 iommufd_dirty_tracking.domain_dirty256M.enforce_dirty
# #  RUN           iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking ...
# #            OK  iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking
# ok 149 iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking
# #  RUN           iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability ...
# #            OK  iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability
# ok 150 iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability
# #  RUN           iommufd_dirty_tracking.domain_dirty256M.get_dirty_bitmap ...
# # iommufd_utils.h:292:get_dirty_bitmap:Expected nr (65536) == out_dirty (8923)


Maybe page_size isn't the right size?

-------------attaching copy_from_user------------
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 8a2c7df85441..daa198809d61 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1103,8 +1103,9 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 	struct iommufd_hw_pagetable *hwpt;
 	struct mock_iommu_domain *mock;
 	int rc, count = 0;
+	void *tmp;
 
-	if (iova % page_size || length % page_size ||
+	if (iova % page_size || length % page_size || !uptr ||
 	    (uintptr_t)uptr % page_size)
 		return -EINVAL;
 
@@ -1117,11 +1118,22 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 		goto out_put;
 	}
 
+	tmp = kvzalloc(page_size, GFP_KERNEL_ACCOUNT);
+	if (!tmp) {
+		rc = -ENOMEM;
+		goto out_put;
+	}
+
 	for (i = 0; i < max; i++) {
 		unsigned long cur = iova + i * page_size;
 		void *ent, *old;
 
-		if (!test_bit(i, (unsigned long *)uptr))
+		if (copy_from_user(tmp, uptr, page_size)) {
+			rc = -EFAULT;
+			goto out_free;
+		}
+
+		if (!test_bit(i, (unsigned long *)tmp))
 			continue;
 
 		ent = xa_load(&mock->pfns, cur / page_size);
@@ -1138,6 +1150,8 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 
 	cmd->dirty.out_nr_dirty = count;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_free:
+	kvfree(tmp);
 out_put:
 	iommufd_put_object(&hwpt->obj);
 	return rc;
