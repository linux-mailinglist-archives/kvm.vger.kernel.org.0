Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF286BC5E3
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 06:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjCPF4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 01:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCPF43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 01:56:29 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2044.outbound.protection.outlook.com [40.107.212.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEC529E09;
        Wed, 15 Mar 2023 22:56:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8nAKv9OM9fKK0g/En+TgfiOJ9ASipAwWhxsSP26ogN4l598JeBJZ50u8kQ8uVrx5fLlnVOGJF4JbK9H9UJjdB5GG0qJrKfVESzPwZZOqxFJYq2tszgPBj4H93V1goDmiLwGVFKAaK/vkUli0B7cp7UJAKp+ulzhaZPgzMqWUXyfGr6QpL2aNGYtf9no2ftRLerGKYunoOxqttlSeEFgTmYDbyTB2iBsjd3aksWFBrXrvDNgBFOIDGi7XvF5ywoz2MwFU3HvFY/Fy1Nt4Y33Etbs0Wqzzc4meGwfc4TckmZLDzYWkqb4SNot6Pkqfk+QViXZ0Ln6q/O4/YpJ9xTzGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16O5dsiPgo/c9wFJEuMYcfYfOfhY3jM4bMKhZagwiNA=;
 b=FyhPkYyyGGujRDNg7EDfCN5P/zm6V755zSJuODIT3YJX9Sones21xFr/lmU/EiZ9MM1zrvahgYAX7AEe7HlIaGMYL5rUb1YbDiXtdmY5uA962Wa4hUEr7tKNcmK9NE5CYgpoGmnAv5WVzCOZCyGUVRBrdLddVExQb9+0h3o+OFl6afhBXUE8CFpz1JP6CGaLv3w8nDgS7oSia3VG0v1UdFoojDvvm07roYGVBnxlRTIyIDpvhticCG2ILpENr33vS3r1PivOmP8Hr+iTbYQg/Rqr+vTep7SM59Dsgn/hX42SR+rhhaJ5UciXx7HZ9iHWdSI+pvpEMlehqALC23v3XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16O5dsiPgo/c9wFJEuMYcfYfOfhY3jM4bMKhZagwiNA=;
 b=oVJZE0SqkbeLK4oxvQQjuZHx7AM+hOTRbc7DaeCyRA5hhCC8LF/+Afd4BFngH5Dk+jxuJXkBLpfDx72VKXunXWdxvwCkO4hQjtYg1jMhxyKd4xZVF46v5gCZIbnVHUV1EWmo/IqlKdfUbMy+yZn+rCMr0itPw2pW/Lj1YQzP6Iy1zfSBDraH0teHLkXE2UrLDfzT9XbYgJhYTTZpuPHQqwDjWDnOz69J544N7UsXOK01tepCRhg6rKJHTaJ1G8IrMF5uu9ycCo+wiWRvPsTVXSQ+gRLoz1rXXAIC1n5hB+WSscNrQg0P3bFqMGeFvndjGPgwfySwiuDZh69eqzd2mQ==
Received: from BLAPR03CA0114.namprd03.prod.outlook.com (2603:10b6:208:32a::29)
 by CH0PR12MB5315.namprd12.prod.outlook.com (2603:10b6:610:d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 05:56:26 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:208:32a:cafe::9b) by BLAPR03CA0114.outlook.office365.com
 (2603:10b6:208:32a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31 via Frontend
 Transport; Thu, 16 Mar 2023 05:56:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.12 via Frontend Transport; Thu, 16 Mar 2023 05:56:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 15 Mar 2023
 22:56:14 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 15 Mar 2023 22:56:14 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Wed, 15 Mar 2023 22:56:13 -0700
Date:   Wed, 15 Mar 2023 22:56:11 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBKvezoPJozs9lmG@Asurada-Nvidia>
References: <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
 <BL1PR11MB52710B5DCB08214EF4542D098CBC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <ZBKp9BXwX3+txIEC@Asurada-Nvidia>
 <BN9PR11MB5276EDB7E88E9AE5F059C8948CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBKsldu+EKT5jd98@Asurada-Nvidia>
 <BN9PR11MB5276229F63C9BE37CC8542868CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276229F63C9BE37CC8542868CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|CH0PR12MB5315:EE_
X-MS-Office365-Filtering-Correlation-Id: 2124abeb-513c-49a5-c9c2-08db25e32df7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVJZ+ksPoHZZqlvkWXLQi3RsD/xhKRE5qF7P+2IYN7jJRG3az/H27BGR1rsnsxhDJgJ+KcsNNuCzcNMV1Q0M6z2L15abxOwpCYE6zWu3vZmilSPlgh7mASchGE2QDnAk7RSwKIloLd3/9S7yScuEVxKQRYp6SOi8LfLUh6draX/nuaviwpGBaIaZGlryZvMjjViVg5BJCxMHYTCM5fPR5611MKooxlB1YNA6KNjMtiiaW6sD5NTtS/uCuBzmZ9CraWGf08hmeBD0OLq6QRc6DtHep203vzvc3Zbw1KZ671mo73Ggb2R3zhdmY5X1wGIRxNnzJMFydZbN4XYkn1FkFMpCh/C/YHjLX7ToUVdctoJ2s1oqK0rc9sIETQNOuwJmsI0sAT+d3OpGfHVsoZb68I1Sx0NuYMMgbDiGClSWuh55hQcluPlnPQwyuguU7UZpSHA+rGwcSO4LBfdeVAtPabnZ7ZOFs8watINX4p9xrC9sJ09qs/gy3qxLefQpiLsM9hsUaUREX4uheGa6FwM2FgGZFrYzFyVhWt7iLfZHf8Yfh3/2VlvM07Ut6Swr9HFyaU5rqZiUyNYK3lMDLIzyqYS/lCbULrGxWrtNcSnjjShoL/FGcOjCUTH2P3PC4dL+3J4Q0eSZaq9ib1X4+rbOqgiCKTr4sQxQkfB+hpT3GE80GiPANSBNGNI/Dc2i2li2cjxmX/5XZXqyHaCBtaQATa899ewoI3METAWLluQ/8ARbobRO6cwBcUDVj4NBJUU1m3SNEiXY1li7uZ177ySM4lqxLnv2bzEFLZPxplc74FQ=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199018)(46966006)(40470700004)(36840700001)(9686003)(26005)(426003)(47076005)(316002)(86362001)(82740400003)(7636003)(55016003)(82310400005)(40480700001)(356005)(36860700001)(478600001)(966005)(54906003)(83380400001)(41300700001)(40460700003)(2906002)(4326008)(6916009)(70206006)(8676002)(70586007)(33716001)(8936002)(186003)(5660300002)(7416002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 05:56:25.9418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2124abeb-513c-49a5-c9c2-08db25e32df7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5315
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 05:49:20AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Nicolin Chen
> > Sent: Thursday, March 16, 2023 1:44 PM
> >
> > On Thu, Mar 16, 2023 at 05:38:41AM +0000, Tian, Kevin wrote:
> > > External email: Use caution opening links or attachments
> > >
> > >
> > > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > > Sent: Thursday, March 16, 2023 1:33 PM
> > > >
> > > > Hi Kevin,
> > > >
> > > > I've fixed the other two commits. Here is the one that I am
> > > > not sure about:
> > > >
> > > > On Thu, Mar 16, 2023 at 02:53:50AM +0000, Tian, Kevin wrote:
> > > >
> > > > > > [2] This adds iommufd_access_detach() in the cdev series:
> > > > > >     "iommufd/device: Add iommufd_access_detach() API"
> > > > > >
> > > > > >
> > > >
> > https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a
> > > > > > 097e2c9d9e26af4
> > > > >
> > > > > also add a check if old_ioas exists it must equal to the new_ioas in
> > attach.
> > > >
> > > > This is the commit adding detach(). And there's a check in it:
> > > >       if (WARN_ON(!access->ioas))
> > > >
> > > > Do you mean having an "if (access->ioas) return -EBUSY;" line
> > > > in the commit adding attach()?
> > >
> > > if (access->ioas && access->ioas != new_ioas)
> > >         return -EBUSY;
> > >
> > > yes this is for attach.
> >
> > OK. For attach(), the access->ioas shouldn't be !NULL, I think.
> > At the point of adding attach(), the uAPI doesn't support the
> > replacement use case yet. And later we have a separate API for
> > that.
> 
> what about user calling attach twice in cdev?
> 
> >
> > So I think it'd be just:
> >       if (access->ioas)
> >               return -EBUSY;
> >
> > The reason why I didn't add it is actually because the caller
> > vfio_iommufd_emulated_attach_ioas() has a check of "attached"
> > already. Yet, it doesn't hurt to have one more in the API.
> >
> 
> but here the slight difference is that in physical path we allow
> attach twice to the same hwpt. they should be consistent:
> 
>         if (idev->igroup->hwpt != NULL && idev->igroup->hwpt != hwpt)
>                 return -EINVAL;

I see. The point is to support duplicated calls:
	ATTACH (pt_id = ioas1)
	ATTACH (pt_id = ioas1)

Then I will add this to keep the consistency:
	if (access->ioas != NULL && access->ioas != new_ioas)
		return -EINVAL;

Thanks
Nic
