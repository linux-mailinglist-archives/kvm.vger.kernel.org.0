Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D941F6CC72F
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 17:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjC1PzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 11:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjC1PzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 11:55:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F26C187;
        Tue, 28 Mar 2023 08:55:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYg1tKrm4a9Mflyammj7GHKAsIApx/X69bZeEKGHNCIBaXGOLX10exa+5crNneA11txu+dnbe54H61ShtDm4SdAJzgPE8rGRGoqxEbXddoztpYL+y+GA41/JjAeM2Y+38eas66H+PpGzgu7I8QVlUjdVd0BxRQ14/YEgUS15AcE4QVno7JQMA4s0c82OKvQysYiasIBKfXSihQ92AYOFWKOIQP9RmHj5+gLAG0S/XU/lGsdcdsxKjUMjOnMUqwyDsW3F24nk+ZFU4zV5aymdZYhaGyRBgm/YZSnl8gAM7LeYkMBzB/RTSkqLhVEvxdGp2sz7hR850cXY6khCbIUgKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXLb5b/cMJrkIR4iCRJYZ45E9TXyuB6I1RHDRJqPp7A=;
 b=i8cHJaQPL34ioxoUCo8ph3Io9iGD/RVOfh3sB0SbYZV2oq60C/chh0f+g5qucyB4qFpdt9MOGTQZwI03TBfQn4cGwEuwfYYJAzxzkWVKEoK46DnzCV0DyJZ3581LknQPTsreM/f/jn4TMeYcdjWj0JrXtmnsVmy5PAXxA1Fj8PBHyTgBXcnKxUW0SrLbDzGByzOWm+WpgFp9FxalEcMUKxPQ2E/TCy1Ghh+/YrXEaNtPx0aKVZyhrR4vP1CVkELJXqWlhDlDGEbMYoAQk0J5oCaK07d4wz1pXdUMBkhh9qTSZ5yJ8QViCX/QfiqpwX27sV0PN45koEGuULSS1XjtOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXLb5b/cMJrkIR4iCRJYZ45E9TXyuB6I1RHDRJqPp7A=;
 b=BLyvQaw/KocwrYQ81CYSLa/JtnS6Au3mljptsMzEPl7WLRQj2OMgLwunFCzSgM19uKracpVLiv/9o+fQeXM0Nn9hfpYRMgA8YOslasOgF/Wc6YwcQDu3HpTRztF+4xQKgILqsr6frMTgqMm2cAAmj1wR8r9UvyXaXntvlfDyepz4MP18lvI8q0F2RcN5ECwo7pLYtmpeLn11JdODaTl8mbk6IIPjQCEzaJIS91kTZiBlmjmUcGkaVwf2wej8yPlzbEHwvOQN9xbG66GLNVvWLaR2GGB0dwf0vA5HYW0+CrcRXblbYu2J4KYcATjW0BXjLnSfTBUcHsA3a6xs1yLKpw==
Received: from MW4PR02CA0019.namprd02.prod.outlook.com (2603:10b6:303:16d::23)
 by DS0PR12MB7852.namprd12.prod.outlook.com (2603:10b6:8:147::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 15:55:08 +0000
Received: from CO1NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::76) by MW4PR02CA0019.outlook.office365.com
 (2603:10b6:303:16d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Tue, 28 Mar 2023 15:55:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT079.mail.protection.outlook.com (10.13.175.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.17 via Frontend Transport; Tue, 28 Mar 2023 15:55:08 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 28 Mar 2023
 08:54:55 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 28 Mar 2023 08:54:54 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Tue, 28 Mar 2023 08:54:53 -0700
Date:   Tue, 28 Mar 2023 08:54:52 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <yi.l.liu@intel.com>, Jon Pan-Doh <pandoh@google.com>
CC:     <alex.williamson@redhat.com>, <chao.p.peng@linux.intel.com>,
        <cohuck@redhat.com>, <eric.auger@redhat.com>,
        <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>, <jasowang@redhat.com>,
        <jgg@nvidia.com>, <joro@8bytes.org>, <kevin.tian@intel.com>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <lulu@redhat.com>, <mjrosato@linux.ibm.com>, <peterx@redhat.com>,
        <robin.murphy@arm.com>, <shameerali.kolothum.thodi@huawei.com>,
        <suravee.suthikulpanit@amd.com>, <terrence.xu@intel.com>,
        <xudong.hao@intel.com>, <yan.y.zhao@intel.com>,
        <yanting.jiang@intel.com>, <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v8 16/24] iommufd/device: Add iommufd_access_detach() API
Message-ID: <ZCMNzMV0DTOQEdgH@Asurada-Nvidia>
References: <20230327094047.47215-17-yi.l.liu@intel.com>
 <20230328022357.2268961-1-pandoh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230328022357.2268961-1-pandoh@google.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT079:EE_|DS0PR12MB7852:EE_
X-MS-Office365-Filtering-Correlation-Id: 81fe0650-ac72-4ffa-1055-08db2fa4ce26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cqn9DUSOJforz+Omefp4f6HN0oCZm//RUDcsvzHLsJF9wrQH0Bo8OnYMkArr9fRtaKDcHC0u/gYVrR+HVe1ynKkuYB6kvuuwT78EhcCLyIH/wFlJb+l49CRir1Outx9JIww8Eopb/IQ6r+dDn0kbvHcccBqePMB22aztUhQ0ilrG52+sWb5RMQLRAecKUZsSsmugjLuMj0cpK0eqqmaUXDTXRXHUBccLlSv6rFMh5mTR/q0Ij1UCBin+AdtzUuU7mp5iC5uu+MODHR2cYaJMWhM/oschuFyNrMWhwUlATMs6aQTPwotvK3b7U6IDyl8ii7S5aXCfYzrX52BM6sqpy+pK4tytX9WXmh0as0d7SIUe/s5DKs6BBgUrKtQO4yItfTJJpjw1+CiSLuOJPc8OHLujKt4mgYBmejrS8NgWDevGICPOhQz2wX/7TacNlExEbgw2gyqkg73y31vAF/IIjimfFdAhMbgoAxHi8H8zOd53KB9c0memmqW9XSOw3gUR8/UmBLYDeYNYfm27Lc+vEADAkDAA3uvpZQLo54HjPjU2cLO7T5zWzlh2/n6lMIdZY4/kN1YUnOpyPASG0z9rQTx7oKy7T4ifQmRhiUFIOFA6J2suIXV2IWWoVFGdgnPXBUR/Du2d/CcFYiz5Gh3h19EFOmGSS2nJbmpX5cyhe3Hec6aI2XEtCxFzpnWEtNxGwBpNy9+Q5VHVC8R0SORUEiRu7M+q+uSszl3A82qWK7VLzneucspRuX1DVGMbYXhF2aBe4Q43AXr/NXMPeDnGGg==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(84040400005)(451199021)(40470700004)(36840700001)(46966006)(40480700001)(55016003)(4326008)(41300700001)(36860700001)(40460700003)(70586007)(70206006)(316002)(34020700004)(110136005)(478600001)(8676002)(54906003)(2906002)(53546011)(83380400001)(7416002)(5660300002)(82310400005)(186003)(336012)(426003)(33716001)(86362001)(47076005)(9686003)(82740400003)(26005)(8936002)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 15:55:08.1862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81fe0650-ac72-4ffa-1055-08db2fa4ce26
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7852
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 07:23:57PM -0700, Jon Pan-Doh wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 2023/3/27 02:40, Yi Liu wrote:
> > diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> > index 2e6e8e217cce..ec2ce3ef187d 100644
> > --- a/drivers/iommu/iommufd/iommufd_private.h
> > +++ b/drivers/iommu/iommufd/iommufd_private.h
> > @@ -263,6 +263,8 @@ struct iommufd_access {
> >       struct iommufd_object obj;
> >       struct iommufd_ctx *ictx;
> >       struct iommufd_ioas *ioas;
> > +     struct iommufd_ioas *ioas_unpin;
> > +     struct mutex ioas_lock;
> >       const struct iommufd_access_ops *ops;
> >       void *data;
> >       unsigned long iova_alignment;
> 
> I think you may need to initialize ioas_lock. I got lockdep warnings running
> iommufd selftests against this patch. Those went away when I added mutex_init().
> 
> ---
>  drivers/iommu/iommufd/device.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index f0522d80919d..0eaae60f3537 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -474,6 +474,7 @@ iommufd_access_create(struct iommufd_ctx *ictx,
>         iommufd_ctx_get(ictx);
>         iommufd_object_finalize(ictx, &access->obj);
>         *id = access->obj.id;
> +       mutex_init(&access->ioas_lock);
>         return access;
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_access_create, IOMMUFD);
> --
> 2.40.0.348.gf938b09366-goog

Yes... I think I lost that when splitting the changes.

Yi, can you help add this in the next version? 

Thanks!
Nicolin
