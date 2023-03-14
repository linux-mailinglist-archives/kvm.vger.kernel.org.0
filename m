Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AFC6B9F12
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 19:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCNSvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 14:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjCNSvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 14:51:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB052E835;
        Tue, 14 Mar 2023 11:51:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLSEDGW3uSAyMbWn6je0+e3mSb4XgkZkKz7gCwHbxBk/EeAmcHxtYVKYq6YiOvsID0/B6/+K80hpEykDaprxpPrWeVwbTLjM+j5pzyrG1RMRdyL1YPB9wrrRgfcPG5CM+WTH5HxkFv0Ibie3VLrWKnUt6TAe436MGmW4pgErYJrS0zz5LCoxKiByhi1bJ+2ZUSN8vruQiFa9sL8fpFM+b9iHpKScQdZ3LRWNnCdYlnpqn1SLz6pom6XITc9f9I2W1l3Izsvoi57OTofo/2SoK4Nwr9ohDXjAhLNg6vZY6tZDd/KDVvvKAII2bUY/Ws6MK+MtMeaLTMxqverQVdYglw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WpH4Wlw2HRL74ZMa+jdOPBPnx9kw1C6RXBFoPtyI5s=;
 b=ednbQPSK6C5D308gQ47WGd4ur76gyJu8FlTRNDZwWpAJC7A22VzN1znsRyFiyZiqswqdwEncH3u3J7T4VXOGGcjR0qIZj03x9p2Ch2mLh7jwT0kjNPlL9RxnmsdlXy3R4ODPPX9NlKOMgBuWPopfEzJVe0kR9fAEPdSFBjEg7xxXtE/FO7vpOdn0ShGdi9CtLNavrulrS06vsTOJ2ErhWw9m6jDrDLhG3ADkXpaekL/qA6SL6wGeqPL/QZoqG/M7DmVBrKTptgaT30Dl7CmtL7HWKZCz96E52uz2BwdtDNBWBka7S9dkq16sGtKvgKmtpM4nBN5AgNFqYqmq46B3ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WpH4Wlw2HRL74ZMa+jdOPBPnx9kw1C6RXBFoPtyI5s=;
 b=dML137yVeiqnfho4RK+y3Fr/Gjqr7QTCw9hgmXQEapYRDQNmZxi2GaxXlpDXElkirkMKxvNJhZP/tIiFbS0tA4sWS8jg9zw6H7Y1GX2K+m4/Kzy/fIXzsDEe7jNyUtoSXJZzP39quSJsrxruv8JnAOcYKABTeKQD6hJw1RYUrwL0Gs7T0Mww95b70NQAnGbxv6185yvN2mheClRyVCoFy8kPwBS3GybIRRALxjf/Gpkin/A8TGsMdkI2/ROsn+Zc1TbH/rwkMMkWq4IL3YCiWL6QZBFnUZhIz12nMt7iRCU3pK1VWeCxQOzkdMUZnj8o5em6G6OcBrHnKoPmKYctHQ==
Received: from BL1PR13CA0169.namprd13.prod.outlook.com (2603:10b6:208:2bd::24)
 by MW4PR12MB6899.namprd12.prod.outlook.com (2603:10b6:303:208::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 18:51:03 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:2bd:cafe::52) by BL1PR13CA0169.outlook.office365.com
 (2603:10b6:208:2bd::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25 via Frontend
 Transport; Tue, 14 Mar 2023 18:51:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Tue, 14 Mar 2023 18:51:03 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 14 Mar 2023
 11:50:51 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 14 Mar 2023 11:50:51 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Tue, 14 Mar 2023 11:50:50 -0700
Date:   Tue, 14 Mar 2023 11:50:49 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBDCCYLJn32Yk/eI@Asurada-Nvidia>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <BN9PR11MB52766F9DA462F5C7BC23654F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766F9DA462F5C7BC23654F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|MW4PR12MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 51ddc20c-ae7d-4098-72db-08db24bd0f9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PzDR1Oo6fDpHKXvVuyVCeY3k0zoDif+UJGHziAPxUHHabpW9t3oLgx6QM4wwOypJ5Gq+XrrAr1ACeQd4xSq8PtFm5Jdt0U7zltgjeQA6l1k/IDRIcoOnC3MxgyNL8kng6PhZ4FZsF217L/yPBuQLDkjhgUTqsyWhdlue1YgTBOwC9ZiCeOm7B8Csas6zaa2JGB5Nv4BMEENFjYeemLk+lUFL0rHSD9RNG6PmP6SmTI6aLvvJykbYGTdF1dHmcRCzFTRBn7H1ay+2npG5iFixha3SS9W1Z6ZVm8B7UUxD6P2uOBcifTU69axW+1qZaZG6NsIWhAYs6hEEDhBBCQw6PPVx8e926E9bQIIwpVOkAMqpocbs/15dAhFfdJNFqFyqxmJ1ynUfEf127tgIsiWtevQ9NzMgJNdKTuN3g6o8EMKTAE9Hj283fv4V15/H6gI+5lfjhgt+mW9MMzWMlInVz4gE89h6JkP02iJ4iEZpFcXm/HhpnAq+j5f278iROpIi/6V6AbAOqxrcFyXOQFSwiI8eWwfd3/FxXO46Hai11KobBvhKSc9S1nKeh/55tUJI82bUIyZuLysD3nrcLdRhUzhOQLJrH0mGKmkoWhoSX8g7FiaLwe3XLVMGWRdvkDOvXsRN2b2940uAp54hEFBlT2SMEKtnO9a1aaoIVautQPJySaM1R7JWzb6U1VsxkM881Ag34PXn7J1tpSrYkEu7DJ0LdYIMXHMVa8w1PPXo8KAUVk+Qke96kViYnDPX63S7
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199018)(46966006)(36840700001)(40470700004)(86362001)(356005)(36860700001)(82740400003)(7636003)(41300700001)(2906002)(7416002)(8936002)(5660300002)(55016003)(40460700003)(33716001)(82310400005)(4326008)(40480700001)(9686003)(26005)(186003)(83380400001)(47076005)(54906003)(336012)(426003)(316002)(8676002)(70586007)(70206006)(478600001)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 18:51:03.0421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51ddc20c-ae7d-4098-72db-08db24bd0f9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6899
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 02:08:15AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, March 8, 2023 9:14 PM
> >
> > @@ -449,33 +450,18 @@ iommufd_access_create(struct iommufd_ctx *ictx,
> > u32 ioas_id,
> >       access->data = data;
> >       access->ops = ops;
> >
> > -     obj = iommufd_get_object(ictx, ioas_id, IOMMUFD_OBJ_IOAS);
> > -     if (IS_ERR(obj)) {
> > -             rc = PTR_ERR(obj);
> > -             goto out_abort;
> > -     }
> > -     access->ioas = container_of(obj, struct iommufd_ioas, obj);
> > -     iommufd_ref_to_users(obj);
> > -
> >       if (ops->needs_pin_pages)
> >               access->iova_alignment = PAGE_SIZE;
> >       else
> >               access->iova_alignment = 1;
> > -     rc = iopt_add_access(&access->ioas->iopt, access);
> > -     if (rc)
> > -             goto out_put_ioas;
> >
> >       /* The calling driver is a user until iommufd_access_destroy() */
> >       refcount_inc(&access->obj.users);
> > +     mutex_init(&access->ioas_lock);
> >       access->ictx = ictx;
> >       iommufd_ctx_get(ictx);
> 
> this refcnt get should be moved to the start given next patch
> removes the reference in the caller side.

I don't feel quite convincing to justify for moving it in this
patch. Perhaps we should do that in the following patch, where
it needs this? Or another individual patch moving this alone?

Thanks
Nic
