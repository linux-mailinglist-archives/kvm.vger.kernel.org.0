Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959257A9664
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjIURA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjIURAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:00:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C527A19BC
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 09:59:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bn+eFOALIBbbkbao2+31Ux4T0Q/T0V3nugG20GavDnYFLhP2mABfl/5TI34xCVAbOTRCxVh4TOBdCHUpiNI6KJ4lt2J3JL8SEGBgwT9Org062tbeNywmluEwYDVpzGZ4VCJQVXRijY0nUqRWMe7uCsB5C4OG4UA3aJRhsOgM5DqJi17Qw4U4+nHrgkbjbwEzleI5WhSYQbjJbhS1emqryOqlkCLIJLKdxVSYrQYfCY+GBSqFn/9P5lqqBw05jJDqK5pVyO7K2WWD2Jewqv2U1CTUlZFpjg+PnBheZbs4Xp0HD3anuv8Cz7rQnXK/Xd5/enBa3ujuyrHpVk8xFRPBEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlzVA4CEhQ4RCs6/loHG32imZCx9/kddSclbprHtJWk=;
 b=PtDAd+08hj4CLpnyP6bJto61cMD0o4kYgRFB20onaT8+MPo3/1vEM354h1CzbPAxOYlO8LL8/zmQuiSVUBvYng4U9XiZ6VKZkdqO3vPGr+Fs5vxLvVV+RKq1eX/c6+qYNSTJh5PW1L6anN7rtEINhoAn5mYg64HX1TqHx2oB69wgS5P+VZCbUy2x8wDhFU36uAvKX7B1AnJb0zlhefrKwaBNMcPTgBbeGAefSETTFwZWPR3xWEbax1Q7RTRoYDL/TexptEWUW5JaYEpSihRRLxDOu4QSYc1WpwJD8zvC1gJKltDBw1tkQWb+Q4CGKzb50RUPNpdgc3M/SXo3o1kJbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlzVA4CEhQ4RCs6/loHG32imZCx9/kddSclbprHtJWk=;
 b=Uf2nwa8A+3s9PwCmR3eHymm6V937RNJIAMld2Z/XjY2tYLTNnF7aF29xMFuhZUD05II+iBfk5BQhfS4PqNMGJ5mZZ+P5IWTby/b+Ms8SHzYXIp5RqtPoXcUvu3txjQtBmmpi/uh3qY6aFeqQZxY9zxw6Oq0eM+13OCvChhIcYNwFwHZahdLF5xbtSBRWs/2aPBCj42hqFJk/ozpP1u+OUf0Rw3NnlSLG/eeXgm9mkCwNfZj3OCUcL6CCflUCeWOqR3Hr6K3KglisSN1s2OEZSMW50Q87hQJKuHQN6RT6qkstGFK7JaEsGYXpIr9XXNGVlSy+crbNUakC4JKskrhu4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7706.namprd12.prod.outlook.com (2603:10b6:930:85::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 16:41:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 16:41:40 +0000
Date:   Thu, 21 Sep 2023 13:41:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921164139.GP13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921101509-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: CH2PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:610:4c::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7706:EE_
X-MS-Office365-Filtering-Correlation-Id: e50ff71c-5af2-49a4-e4dd-08dbbac1a18e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNVeHrY53Q4p1XkSl23IuJ2pgQidD1n80RqlUzGK/XA2Ajrt1BX0fWd/jwb0td3ZulJJWGAaCR4NpKg0kMAEs6FqY2qoZREQLlNRRmEDsfMICUgyqirD9zZ7TNT1sFymnaZzc3NzDoKGiZjxBgSVgC3ar6c7V76W+Ws/6K9Dq+EE8LrxD32MsXUXQ+GgItzVPK5VT9kfRXfYiK5raUsGlmBrrIQo6rjrcdwZ1wj7Uix9inR1B/EQCnGeW2MIdwQFPpL9d+D2ug3jrn8RJcVYHgDSHVZs0YM4Ehp03j0OpLlZFhq6jc3xbmdeez22+n3NjKevxxuQLxXFBEX9aITYx9PUF754Hp7Ye1iADRlNcH1ZIei0Qp3rSOEck1sfsvqFSBQkaXoB7t5w75bGrol3ZDiy96E1WFRDPU+6qCmzmswnjeZvD4wiPAlL3ksRrro91JZOlcRx7cpZKD3OIVRmwxadai+vKPn0f5EEvxU2WdS6Q2hsUU6g2BxVoxKYSqEyTFl3Dtuav9L0dGG/ZxRllh4QBK/vKjz7ZLG+zyihXQA/aXnFJ6MVFgFKMpTfDi3F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(376002)(366004)(136003)(39860400002)(1800799009)(451199024)(186009)(41300700001)(5660300002)(107886003)(2616005)(26005)(2906002)(1076003)(4326008)(38100700002)(33656002)(36756003)(86362001)(8676002)(8936002)(478600001)(6506007)(6486002)(6512007)(6916009)(316002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H02EalORjQ56WJZEJDqYwRIaCo/Z2+5wOVZgXKeKvj82o9wrUjXWmQdjAgz9?=
 =?us-ascii?Q?6QkStwTpfSsfe1SAVRYz37o2/JrayOh8v9Y24yS58FSmpLYHiwPRFcwsJLE5?=
 =?us-ascii?Q?YW5Ueypf6EpIowZIOrg6JwE9OveTcrNpLhDa7T4o14Okx9hiFBVUe781wz69?=
 =?us-ascii?Q?TlRIAgr/Ud+oVUEX0P/487sh6UnQBKZ/AVkCw120djJlOtcF8adU0Tf858M0?=
 =?us-ascii?Q?/J2OL+r9ilBv2+0jWKW6j3YiJbCLy0yO8GNMSBSxntnpe227cJMXyBULn1B4?=
 =?us-ascii?Q?FpF0rRMGml26wBrMUCzdsiM+89cwpBICDiYsawKLhZvMtzvzie8thb0K5wxL?=
 =?us-ascii?Q?9FncODUmOaCaCQMXvxkSGHnBYXB+fglViRrBBQUccECy3WjTsRm+65R0OpLm?=
 =?us-ascii?Q?YlnDS57gji+pYTk427L27ZS9zvMEpuyZwwvADRM9lnFoqo/pkpBU8mzAqhMT?=
 =?us-ascii?Q?G5bIiEf0cXS2xBBRTWzj2RX5ogbCCPgizAVkzhU72KyZszhkk13pQsMPCOgo?=
 =?us-ascii?Q?DGkTXDFRuv5VIouxGVz8wxbJBzqCcWom0tOMlZGYxDafwH60WORZALt2PGvq?=
 =?us-ascii?Q?SqCqPx4LLsHV5yRuqBqELllXQaTIAzuz2A8ph1J7dZs/Pc4FGt4tRJXHgJLG?=
 =?us-ascii?Q?RIYRwJb41D/t4BxHQmdgheEDkec4ymn48OiHbj93ubFe8KONI12Zvskh5ny9?=
 =?us-ascii?Q?EWQaOjI62qo7mHiVlWX3JE9kVgZK2mAXMPU1Gyp+/WVbeZ3OZ+j61QRADdL3?=
 =?us-ascii?Q?2U+qqQLkBOHD9ADHidNwFzRgLl/mQCyu0yqgb36Op+u8/qzXcMlz3BIesQT/?=
 =?us-ascii?Q?XfKMN8w+JkIIxLegL0XiGMGNJNyfNuS/BazMMSgyD9diHeRIKlhPxakhS9VK?=
 =?us-ascii?Q?FKE1B/EYM7T6MDEW/vYAdWRNnqVJXmLXoybX5TCQIMbwgRhHfNPjDeYGnZde?=
 =?us-ascii?Q?OnPtDTYAm/ZpE6CUgc9ZKlOVwF6z6gKq2QBIoYL8DwZnrzWgi+JDzzkYV1cI?=
 =?us-ascii?Q?Cj7tayJfrxO+Du4PkZn95Jba487Xf+l/3PWT76jlD1oNxhQzr7KYDzboKRvr?=
 =?us-ascii?Q?VT4TGYxtKypaWs4bIxjIKFK//sZhtD7E6T8/Z75bdAa7qCTYkz+f7k7f2Gm6?=
 =?us-ascii?Q?guwAC6PFXwu/fkhxgV31On41UsCADTVD5pMOkNIOBAVVADn0GzcUxFtIDDdG?=
 =?us-ascii?Q?eqaR6d7jGpDhOzayEcZnwRstyNfxxud38rCCq4qX2pXZ1IxyFyw8H6aq1Yxz?=
 =?us-ascii?Q?FucYOOIQZkLfIgmOo7pYILlXtBKRh4d6Ap1uF0+CcVFEt/6f8v+PxJN0d+YV?=
 =?us-ascii?Q?8y3hJ+v6WiAOu0NsmMY2l6dpYJYvfL3I7l5URMVriUs0T75LYXS9L3xKlAqz?=
 =?us-ascii?Q?QrR0l7vTzOJXlUq2qtD69hQ6JYm9J5jBXK/yQIvxGzqrdOtW9sLtgcsUZmE4?=
 =?us-ascii?Q?sauXP0I6PSxQHTj22MNGlUucoXASd/zS0P8xgDRDYYgj0bSUJq84hOXAbFVF?=
 =?us-ascii?Q?Ro1v6ukKRTPQcyFxbkYOmpGhnF7O3+w5ZhwZxREymmWfrASvQnoFqnNb3nE1?=
 =?us-ascii?Q?TkvJ8xRCpkRcuhNNCYDs8GPEnKWJDBb4/XTDm7hZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50ff71c-5af2-49a4-e4dd-08dbbac1a18e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 16:41:40.6381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fT/75DJP75aT9nk+IrjZOvGBXteMsfHojbuZ7tl+i0GSEmbAneu/jsxfybmxGm3X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7706
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 10:16:04AM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 11:11:25AM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 21, 2023 at 09:16:21AM -0400, Michael S. Tsirkin wrote:
> > 
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index bf0f54c24f81..5098418c8389 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -22624,6 +22624,12 @@ L:	kvm@vger.kernel.org
> > > >  S:	Maintained
> > > >  F:	drivers/vfio/pci/mlx5/
> > > >  
> > > > +VFIO VIRTIO PCI DRIVER
> > > > +M:	Yishai Hadas <yishaih@nvidia.com>
> > > > +L:	kvm@vger.kernel.org
> > > > +S:	Maintained
> > > > +F:	drivers/vfio/pci/virtio
> > > > +
> > > >  VFIO PCI DEVICE SPECIFIC DRIVERS
> > > >  R:	Jason Gunthorpe <jgg@nvidia.com>
> > > >  R:	Yishai Hadas <yishaih@nvidia.com>
> > > 
> > > Tying two subsystems together like this is going to cause pain when
> > > merging. God forbid there's something e.g. virtio net specific
> > > (and there's going to be for sure) - now we are talking 3
> > > subsystems.
> > 
> > Cross subsystem stuff is normal in the kernel.
> 
> Yea. But it's completely spurious here - virtio has its own way
> to work with userspace which is vdpa and let's just use that.
> Keeps things nice and contained.

vdpa is not vfio, I don't know how you can suggest vdpa is a
replacement for a vfio driver. They are completely different
things.

Each side has its own strengths, and vfio especially is accelerating
in its capability in way that vpda is not. eg if an iommufd conversion
had been done by now for vdpa I might be more sympathetic. Asking for
someone else to do a huge amount of pointless work to improve vdpa
just to level of this vfio driver already is at is ridiculous.

vdpa is great for certain kinds of HW, let it focus on that, don't try
to paint it as an alternative to vfio. It isn't.

Jason
