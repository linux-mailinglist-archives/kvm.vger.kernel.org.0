Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97FC4C7A75
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiB1UaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiB1UaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:30:11 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AB95BE60;
        Mon, 28 Feb 2022 12:29:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qk9AkDM8aKRDpgn29Hz/ZTGNdSpZpo1eij4JyDQ4tDXreXR/fwkBDkrOjXsgXy4n4eDt7ZU6nmHv+hv6cA6XJnYXD3iEPIHlZFl64tXqs+SnGc1n/O2HT7O4tyUfPS4eimuDrdATN+h4s+qwY+Rl/kY1uVvWHhz0SdS029hYRjwsOqUHvCBu2Gp9mVFYNM0AIWJNpSsfnlMOVkGb3f2PbtFXtiX69jlYwY9mcKLku378qaCkZyLU/u2EOVedRPwBUkiP2DrUfKhAEnbVkKQZ672oPldc0bs4aqNBOoS5Xu6wjF9A6N/RAxRq3r8AuuS+PTDGVCmoOOlxCGTfpLWSnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QbwQRZnGgfgXQr4YbOGx8Xle2Y6rhU6fUOHakOw+rq0=;
 b=YDiOYuyi4XLxHZebwll+qns9r8dSFEUV/LhrM86aeaR4TufT4kOBvQRvq43cLPo9h1Cb7afVFNeOPfJagmtSmAIJnJZrHrWUeH8X5Cao5G3D6TB04MhHRDFNXxKLuTHU9RaXAM2sUrg9RikeIAgExx8cYHzYGQiPN2G1FQJ+sbS9H5rS4E7TrSpSLFj8HWQr2sFfDoOll8EBC44LKGyX2cgLBac9hQMi+geIo1SXqRpLoEHF+zKGjyuspevwi0ZL8UmcbTAKy6/YofWaIhOdeSBxeWsdSO+ZbI9ALa9LCijjg2PwVujvYuPatEAMViJWQVUt8bCQkl+yANYguTehmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbwQRZnGgfgXQr4YbOGx8Xle2Y6rhU6fUOHakOw+rq0=;
 b=mjDAUJtbJpwxp5zw/P1olca9g+z+6VSLxvO9o1vGMi6U/61A6BgxQ0XvotdsE37tK/Scf6q8VMQ6dFnFabJEqlVgKsIYAV3DVJLpMdYKZGG97aFpyztpHJRO0HsgcY/d0YoaOEdb+VSpybJgPkrm0UTFezGNPthixcbnMzKYPs+YmcF7FVWCT2+65lIL7cmnvbxSbKfIA7pIudTm4oFLqA/SfKa35OmHf7DVynTLelGr3A6Gbtfvk1+WJsLfJB5Rbbj7p2XHTL5KRd9UN1DzLXxb1a6tjJKOZ7s48IeYoHj8U2G6f2wZy+PZwn8/vnQXEYldHfEbxDrDKRDVYNtlow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4794.namprd12.prod.outlook.com (2603:10b6:5:163::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 20:29:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 20:29:20 +0000
Date:   Mon, 28 Feb 2022 16:29:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220228202919.GP219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
 <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
 <20220228145731.GH219866@nvidia.com>
 <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
 <20220228180520.GO219866@nvidia.com>
 <20220228131614.27ad37dc.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228131614.27ad37dc.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a490fe72-9a02-4f79-6a34-08d9faf8ffc9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4794:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4794771839A8BBE88ACB7556C2019@DM6PR12MB4794.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4wBL2XubB6j/rLsvvx6BD/lFQxmBglkbN7c2vy5WhvdwTWGjkK0l9zbOVHUA9GsgQwnVeklkWnZPu74PQgfQLrqcEnN7tF8qwV1tJtCOQFGbWxXMiou1PEyjbVY6pby//AVlLCOyP23ccs5RvDN8O/SBsHiGj7NzMpnf+M5NzhzHBb9NPzN3ZGUXYsaC8BEpWB2Odwq+KjB3KOzNA9ahdRnGV1pi+EPDWzzhMgD2NSkUcWmb+K5Lc5DC+Txtc4YufL/DXizMau4wsir13mYSwc9qtcodVKl3Mci6Q9yXt0Y7N/hW+YkaTSfBOVay+T6m1rO5i4yEPkCPbR7CHOlb8J8UUl7OmFISfI70YAqQ2rjN0/BpEtMocW/2mwCerVE5R8PpiiFJgcPcZUerBs43LYrF8vC7uqLVLVfdL0gftFQ1cIHAUcFcxZlNA/zfPDrgJQiozUTi486n8UtOWVHnckCfrpb3ZChz/0haX9Ox26fFv598am4TIh6VqBJyNU2AWfSVx+a0Ow/Wel/JBgK/oeAX+4PGwpH31cFHQ96uCWd26U6Z5oKhrhl366V525vh3fQnNxdidnMd5clIPt4mQ1CdcH8FE0SsCXWLy0I4cy9utbsMnSdSOL+e4rh8TkWOH1wyHYUIYiOfp2yHqIaf66yczV6ubeu6V6FM87WMP6mFvo8Y1foWCCyHpDqE68gV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(33656002)(6916009)(36756003)(83380400001)(316002)(86362001)(66946007)(66556008)(54906003)(8676002)(186003)(26005)(6506007)(4326008)(1076003)(7416002)(6512007)(5660300002)(38100700002)(2906002)(508600001)(2616005)(8936002)(66476007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f6bFixtUFS63SaZZbLww0FXp+XfKZZfudHv2u7/4w8PhvoqZ6OwZAk7F/NJW?=
 =?us-ascii?Q?RVSHuWfUP7igfv2+Sf9MgXPBWUz2rY4FGGH+ASIvoCK8IzGe/Bxk9kGH1Bte?=
 =?us-ascii?Q?qe4jPkZNNbxGcfi3Iw7gdsfNShVErEj0Nnv9FI+xfKXMHFMSYRLMguDe9W+/?=
 =?us-ascii?Q?Mg6nqx8BDiyTIE8Lu6W1+RZrIn5cGfqaSEGYfOnZHBQeAeV7+WjZUnxgsVr/?=
 =?us-ascii?Q?GbllCXCvX0N6dHDZ4Sfva0onXpM63AztPkMDDj1oHo41CQJMK85IZW9er8EF?=
 =?us-ascii?Q?5h1LyN+wktCJZZq20b+lNzlXcIzrMLYTUH2hEI4vEboLIyWGE8pjMxWLVzVK?=
 =?us-ascii?Q?8smwqIhp5eRnrALSQmQzN3JN74sVnrn886lDLYEBNju23EHHsnmJgoCqa1bB?=
 =?us-ascii?Q?FqbvQIxtGvzGf+GsPjoj0xX0yoNk7sFtdD940q+Z0vHkdGcScIdnyCcY2fNc?=
 =?us-ascii?Q?6uJlm3bj0aCjuK0Q5p1O2Mvu2/4vf3JmItz4+0hIQDQqxSr5o2mmPlNi+uiu?=
 =?us-ascii?Q?bg+e9mQO8tEC7QLuvfs/HhmxiisSP/Pz4YlOwOyjMQK9kFVugW9NNbWcbvpg?=
 =?us-ascii?Q?1nmK8oimgSHtgETTTd0uoFvYxUlaBdcgOVIewnJZCEHAxjqWxeJ2GBAcLHse?=
 =?us-ascii?Q?2F9AVXQM9UMIeTYPe1LVuG/xXl1PqVvWV+rMEpBapJpqiJv4HwZAMhg9UWRr?=
 =?us-ascii?Q?NXkvgjJCC08L9Nw73K5a9IbLvuGNZR24mbAXSupozryH7E40mR0gMfZV1Q56?=
 =?us-ascii?Q?vJKJ+EY7r6BuRpidGHlcUPEsZI0rR7vcmjAkoUZ9FpHDrGsz4oekC9h1LBLw?=
 =?us-ascii?Q?aOgA4JT39n2A7IhHaM3toRR5hz7/l7yqjxI3YlpKgiAijCQcO5bFRlQC62Pm?=
 =?us-ascii?Q?liJ4Ig2J2TlqftqpE/pQEIWwYp10AMfjvPOVoP/ixTlqo7FBsSN8kglAQKST?=
 =?us-ascii?Q?Z6sljo4euqlWHHhYwtW/GwB5MVd/E07jCvr3cI+EE0zDBe3sT2hR0eS3eERF?=
 =?us-ascii?Q?npTM2RnR8kPrin2HyjZJ/jV94/22h1pbcnYd1feK/HnICWajFR+SKqWIDxbr?=
 =?us-ascii?Q?eri5bMg7KB40Dnk4BVUPZlHcWx9O1wIjjE3+4XfoAHLC58AWaKY8GE7z+3f8?=
 =?us-ascii?Q?gmXyTKN+eZ6qAM/huZyUH1UthzGX/xkVUK9yx2AJ5niUPrdnnL/gj0Hdy8lX?=
 =?us-ascii?Q?DPS+XpdZ9n6vHvJxzYOv/zLC0WjzrS+yQnuiR5ovny7hmb8Y6z6s8gFe0TqM?=
 =?us-ascii?Q?8LVJkDyigF6UuGmOZAPc1vFTF6VsdA05mx+qsDuWDMZlRSGYAN3bqLnYJhBz?=
 =?us-ascii?Q?kIQ91iWiOhd7m5+m/KzbQiJ5eTToXVxrNdL3n7dXwtkPiyDSEYyadZYhCJXg?=
 =?us-ascii?Q?/0cmIwLRTrK0oejq/wgSf+yr7I1HxCicQA+DDon+vQWKzWyTJOzJGfgufjXy?=
 =?us-ascii?Q?t1zRw2Fkp1uyqR02X3v971Rs8spor1KiY24FwbwMdtFFkC54/QQAyahqJ5Vv?=
 =?us-ascii?Q?cAvpIEOAs6JJTc/lkr0ZBbVoi72goLaMSVclENJGoTQjHDdZ4P5oIuvQ2Dyq?=
 =?us-ascii?Q?NFTR5omz12aIcY7BFA4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a490fe72-9a02-4f79-6a34-08d9faf8ffc9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 20:29:20.1733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shyVIwSj6yq7CKr5LAJ/jkgUjZHaO6Jj29s4QqYyc2GzKxrJPPhU1rXw+xbBOW/5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4794
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 01:16:14PM -0700, Alex Williamson wrote:
> On Mon, 28 Feb 2022 14:05:20 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Feb 28, 2022 at 06:01:44PM +0000, Shameerali Kolothum Thodi wrote:
> > 
> > > +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> > > +                                      unsigned int cmd, unsigned long arg)
> > > +{
> > > +       struct hisi_acc_vf_migration_file *migf = filp->private_data;
> > > +       loff_t *pos = &filp->f_pos;
> > > +       struct vfio_device_mig_precopy precopy;
> > > +       unsigned long minsz;
> > > +
> > > +       if (cmd != VFIO_DEVICE_MIG_PRECOPY)
> > > +               return -EINVAL;  
> > 
> > ENOTTY
> > 
> > > +
> > > +       minsz = offsetofend(struct vfio_device_mig_precopy, dirty_bytes);
> > > +
> > > +       if (copy_from_user(&precopy, (void __user *)arg, minsz))
> > > +               return -EFAULT;
> > > +       if (precopy.argsz < minsz)
> > > +               return -EINVAL;
> > > +
> > > +       mutex_lock(&migf->lock);
> > > +       if (*pos > migf->total_length) {
> > > +               mutex_unlock(&migf->lock);
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       precopy.dirty_bytes = 0;
> > > +       precopy.initial_bytes = migf->total_length - *pos;
> > > +       mutex_unlock(&migf->lock);
> > > +       return copy_to_user((void __user *)arg, &precopy, minsz) ? -EFAULT : 0;
> > > +}  
> > 
> > Yes
> > 
> > And I noticed this didn't include the ENOMSG handling, read() should
> > return ENOMSG when it reaches EOS for the pre-copy:
> > 
> > + * During pre-copy the migration data FD has a temporary "end of stream" that is
> > + * reached when both initial_bytes and dirty_byte are zero. For instance, this
> > + * may indicate that the device is idle and not currently dirtying any internal
> > + * state. When read() is done on this temporary end of stream the kernel driver
> > + * should return ENOMSG from read(). Userspace can wait for more data (which may
> > + * never come) by using poll.
> 
> I'm confused by your previous reply that the use of curr_state should
> be eliminated, isn't this ioctl only valid while the device is in the
> PRE_COPY or PRE_COPY_P2P states?  Otherwise the STOP_COPY state would
> have some expectation to be able to use this ioctl for devices
> supporting PRE_COPY.  

I think it is fine to keep working on stop copy, though the
implementation here isn't quite right for that..

if (migf->total_length > QM_MATCH_SIZE)
   precopy.dirty_bytes = migf->total_length - QM_MATCH_SIZE - *pos;
else
   precopy.dity_bytes = 0;

if (*pos < QM_MATCH_SIZE)
    precopy.initial_bytes = QM_MATCH_SIZE - *pos;
else
    precopy.initial_Bytes = 0;

Unless you think we should block it.

> I'd like to see the uapi clarify exactly what states allow this
> ioctl and define the behavior of the ioctl when transitioning out of
> those states with an open data_fd, ie. is it defined to return an
> -errno once in STOP_COPY?  Thanks,

The ioctl is on the data_fd, so it should follow all the normal rules
of the data_fd just like read() - ie all ioctls/read/write fails when
teh state is moved outside one where the data_fd is valid.

That looks like another issue with the above, it doesn't chck
migf->disabled.

Should we add another sentence about this?

Jason
