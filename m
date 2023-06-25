Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A6B73D2FC
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 20:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjFYS0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 14:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFYS0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 14:26:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C288138;
        Sun, 25 Jun 2023 11:26:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvAroJRlH2oJ88yRH9UwB6mOu+qcRPz3i4/UwxXrtBGFG7ikfbL5MFg/pzaME32VpKashjtmOWQF5wCPc0Ff8WxKXjxuluJmeCr3xBiy4m+RrV4G9WPS6uvm2Wcm6BuGH594KJKlcq1fE2EnOpymiRV6CknZdqNunLaUb1qQAIXQQqgMk9vZojb2aLEUDUSD/KbSbx5g5EyVZrTBoMbh3NFDp2xXM58PPp5IX2xIGrok7VI9wycWGR3EymL0Z0a82W5Y0CJckYqMTUjA6xCZQzYd1KtutL+gJhsC614ViifwA8rUM4wU5/uZD4X8bOmYihe4IaDUmMf7u3OEVY6uSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1t3tA2Yw5+S3c0+J79Vj23MunTI8fZ9uxj7AzecAaY=;
 b=O9h69WynlVu7cNOGE2ZML2rN0WoOkda89zNZmkqwOk1n/g9VFY7BSfPFfv4+fLLaISUPLZb8PsyUA2YcWKbcyqK1BrrR9IgwTAJtCCSunXSs3V8PGhel+Cs5QR+ZumEWdrjAwKO89fsfu0MdmTpH7TUDdgnd6g7LseYQzSYVHrSeGxB+C40mg0AntyWlX9WDo5gaNp7SODEoypg3yaC3nVBeco0QttLvYEx9QlKqjB2XhS3r5LOSLQRAX0YosQ8eXh5NMHYEwz2FxbYMbEAnb0SInBLbru8aTDTF6uA8zp62kYFb9VB3pPm4AVez1cIOYd9T7QuU2f579TxW1HfnDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1t3tA2Yw5+S3c0+J79Vj23MunTI8fZ9uxj7AzecAaY=;
 b=aqV5D76QNq8lKNfvxJQDQ8PkIEwcDaYJbJ2AGvK/MjiTbommCWNl7LA5xVMUR8S0i0w1cpAe5fil1CcWBcbl4fVGpaZkW7BPPwPq0p9WaHTPue4xbMMy64M0YjUk89VEotjmqYo4iicSY+vbXgD2bQl7ldQSBs1HKF9stzyS8ZFGJ10XdtX8FoDkdfPYFb0KdkM9uv6+8y5de6YPIugQNQLZikpx96/9eQgWjNgc825SouGp6ua6PUdM49gAOGN4IekENNGx34QUeAKoRLozDjoSeZee7M/NhWSoDFk4hzGYGUtydbxLtZ0vYHAN/p0++rymIEvNB1tVRPaBO8ccxw==
Received: from MW4PR04CA0234.namprd04.prod.outlook.com (2603:10b6:303:87::29)
 by CYYPR12MB9016.namprd12.prod.outlook.com (2603:10b6:930:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Sun, 25 Jun
 2023 18:26:46 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::13) by MW4PR04CA0234.outlook.office365.com
 (2603:10b6:303:87::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.33 via Frontend
 Transport; Sun, 25 Jun 2023 18:26:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.47 via Frontend Transport; Sun, 25 Jun 2023 18:26:46 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 25 Jun 2023
 11:26:43 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 25 Jun 2023 11:26:43 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Sun, 25 Jun 2023 11:26:42 -0700
Date:   Sun, 25 Jun 2023 11:26:35 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Yi Liu <yi.l.liu@intel.com>, <alex.williamson@redhat.com>,
        <kevin.tian@intel.com>, <joro@8bytes.org>, <robin.murphy@arm.com>,
        <cohuck@redhat.com>, <eric.auger@redhat.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <peterx@redhat.com>, <jasowang@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>, <lulu@redhat.com>,
        <suravee.suthikulpanit@amd.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-s390@vger.kernel.org>,
        <xudong.hao@intel.com>, <yan.y.zhao@intel.com>,
        <terrence.xu@intel.com>, <yanting.jiang@intel.com>,
        <zhenzhong.duan@intel.com>, <clegoate@redhat.com>
Subject: Re: [PATCH v12 14/24] iommufd/device: Add iommufd_access_detach() API
Message-ID: <ZJiE6uvcKNYp2Sl3@Asurada-Nvidia>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-15-yi.l.liu@intel.com>
 <ZJWpDFRuG/HCXjHN@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJWpDFRuG/HCXjHN@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT014:EE_|CYYPR12MB9016:EE_
X-MS-Office365-Filtering-Correlation-Id: ca4c0a4d-c21a-4290-1c27-08db75a9bbd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XUQVFAY1Hjzh8x/FTEv0kfPViKDT11iA78kWLE6XJ8Z7CnQrxdKxVabr4UJ3yr6FPXmj/C6fTj8UzXd4yK3wrX6bWorrktDoRoxSGp8XcOmsFavLhoRDV27EhKV5/xkDUii3Crkmh25QuRFeWISnc9Qyr37ouHlGmOZFlg5SghPMKNKeGtKdrdbvzt1K0+hWodikmwvSzLd6vwYlaSxBI/MtWGdsgm9H2hC/Ui57/QWj4sPhQagJHM2Zj9fORSyZMBq0iVlYwo1hPysrFv/t8HQpVh4eoaJB1aGN/9GbU8iIBKovabjF/p8dcG/7CTDpN6zilumSBbYhFLtXf9Pw4zh6e54nnTFDNxc8ghGIOY48dBMavPujDAGZtdGYAhfyZcuKw2aHvRU6+AOtzKoPZKkRsCjlyiu9oip1jyDbgvYYJJEtEkg7u2qaap1CBZ9FOguwGpGNPPz5kPt1vybgVP3caQVlobozME3NbNFYE1vGRBMecBqlaz7GKuCh6nw+tE0ss+OCxIevSv7m4RVOXbcpIZ02fa/JCaf/9nlXwscCZIQGlIm6pN2rGr4eUd2iIGKH3qxdjGdXtDFtJY53gXjtQ17AlF6HyBmcNLPORJuVe00wdUrTA0YWG8meH+2UKe56k+0NVa+JsA8QwbUm9xRfu/UHXUNvADbQNcWp+SAsmFuvhxO4Geinin8HOnR7rcn8GkxgEhmaLnEgmoyxbS1jxjcBq+rHmzOguE8zYFI=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199021)(46966006)(40470700004)(36840700001)(82310400005)(36860700001)(40460700003)(70206006)(356005)(5660300002)(7416002)(6862004)(33716001)(55016003)(8936002)(8676002)(41300700001)(86362001)(6636002)(40480700001)(4326008)(316002)(7636003)(70586007)(82740400003)(47076005)(9686003)(26005)(2906002)(186003)(478600001)(6666004)(83380400001)(336012)(426003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2023 18:26:46.2864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4c0a4d-c21a-4290-1c27-08db75a9bbd0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9016
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 11:15:40AM -0300, Jason Gunthorpe wrote:

> > +static void __iommufd_access_detach(struct iommufd_access *access)
> > +{
> > +	struct iommufd_ioas *cur_ioas = access->ioas;
> > +
> > +	lockdep_assert_held(&access->ioas_lock);
> > +	/*
> > +	 * Set ioas to NULL to block any further iommufd_access_pin_pages().
> > +	 * iommufd_access_unpin_pages() can continue using access->ioas_unpin.
> > +	 */
> > +	access->ioas = NULL;
> > +
> > +	if (access->ops->unmap) {
> > +		mutex_unlock(&access->ioas_lock);
> > +		access->ops->unmap(access->data, 0, ULONG_MAX);
> > +		mutex_lock(&access->ioas_lock);
> > +	}
> > +	iopt_remove_access(&cur_ioas->iopt, access);
> > +	refcount_dec(&cur_ioas->obj.users);
> > +}
> > +
> > +void iommufd_access_detach(struct iommufd_access *access)
> > +{
> > +	mutex_lock(&access->ioas_lock);
> > +	if (WARN_ON(!access->ioas))
> > +		goto out;
> > +	__iommufd_access_detach(access);
> > +out:
> > +	access->ioas_unpin = NULL;
> > +	mutex_unlock(&access->ioas_lock);
> > +}
> > +EXPORT_SYMBOL_NS_GPL(iommufd_access_detach, IOMMUFD);
> 
> There is not really any benefit to make this two functions

The __iommufd_access_detach() will be used by replace() in the
following series. Yet, let's merge them here then. And I'll add
__iommufd_access_detach() back in the replace series.

> > int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
> > {
> [..]
> > 	if (access->ioas) {
> 
> if (access->ioas || access->ioas_unpin) {

Ack.

> But I wonder if it should be a WARN_ON? Does VFIO protect against
> the userspace racing detach and attach, or do we expect to do it here?

VFIO has a vdev->iommufd_attached flag to prevent a double call
of this function. And detach and attach there also have a mutex
protection. So it should be a WARN_ON here, I think.

> > @@ -579,8 +620,8 @@ void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
> >  void iommufd_access_unpin_pages(struct iommufd_access *access,
> >  				unsigned long iova, unsigned long length)
> >  {
> > -	struct io_pagetable *iopt = &access->ioas->iopt;
> >  	struct iopt_area_contig_iter iter;
> > +	struct io_pagetable *iopt;
> >  	unsigned long last_iova;
> >  	struct iopt_area *area;
> >  
> > @@ -588,6 +629,13 @@ void iommufd_access_unpin_pages(struct iommufd_access *access,
> >  	    WARN_ON(check_add_overflow(iova, length - 1, &last_iova)))
> >  		return;
> >  
> > +	mutex_lock(&access->ioas_lock);
> > +	if (!access->ioas_unpin) {
> 
> This should be WARN_ON(), the driver has done something wrong if we
> call this after the access has been detached.

Ack. Also adding a line of comments for that:
+       /*
+        * The driver must be doing something wrong if it calls this before an
+        * iommufd_access_attach() or after an iommufd_access_detach().
+        */
+       if (WARN_ON(!access->ioas_unpin)) {

Thanks
Nic
