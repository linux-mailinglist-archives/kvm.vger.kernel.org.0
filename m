Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5A6AA87D
	for <lists+kvm@lfdr.de>; Sat,  4 Mar 2023 08:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjCDHBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Mar 2023 02:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCDHBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Mar 2023 02:01:10 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B47C3C796;
        Fri,  3 Mar 2023 23:01:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXQoQBsu9nzi4bVCv7Fq4L+RcdYJHJTvnllzZAGmlfQkCWNEmL5i7YEQahFEFjZwi0izZuqnfM5146n/IdEDUnXd9Nu2LSzYWCl0lOT4Y+TbOT5WhGSJE5vsEeHuXJRhoUQwuDeI4dKFKIfaPfw+vtlNMI7gu2Q7lPnHL7Y9Deon+wb06BZQ47NhWB0cRiSVjozlwthENY5K65lYADIFnwVHDu5wtq0kd5ZxYekmOKZPCJin2KLcNUyVjbZdybJxInKfaB34hRuMaDqh2pRLxhvNcq2lLIfwUX9qYz5/X4Rr46vILRrDjvWx/94Ltx5KOZh/xu6v024NhfwZJxfZqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h05/N5nUOvvJ1R9LIJPn+dfhuOS/kQ58HacyhdRrT0c=;
 b=Pq2tJ/OXuZkOl/kGrVzHa6VYgOP77xitIFLEVndzK9JX6YyNRKyqgr1VFM21QbuXqdySwdeb5V8KVqbF19Hv0Nnrh4k8gUw/cGrM9cL5GBTW5ChrOzpkGxNmiqS/i7LpnImBtH/O6Gm6P58l0bsYlg9ZeShSmWkPvKpzgGsx0C+Lbo/xplw2oCTOq+rwEpbkTJ1MV2VjP87ibsRFRii5aGmmzNekCTwLrhN83Tefo+ZMTz8qSccsDpyT3wUgQUMsxdLzaTyWeusx8HL+5lFapNf7nfr36MaKDgnjIX6/WimAHs57C9vHbnXcf4BG+Hh5yn6mvGX1CiiIaJmfFb73PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h05/N5nUOvvJ1R9LIJPn+dfhuOS/kQ58HacyhdRrT0c=;
 b=TxFqheA/KGO5FuTGGOjxKnhuGEM+wvr/wt1TB8Ny7N7rAa2x1k8beBbv5lVZG3nHlh7Fdid2hjhcagl2DqpMZFnuS9qOfAKm1e4ojdsP7Qke5abgaloOqsLqrIq/3eywCgV2c/P3280PytaaBe7/nnn2DgPeBWEF+IELMZ9IJcvaLQxOAhQFw5Mor/Z+3vIQfRBV+OAp1cbXRZxfzzQGvn5gWYgGxkk12nyPwixKfTSldFRS26gg7jZz8LBKxd2V4vOtkzQSBBpBf82UFjOtDB+T4ds4rnEUBM4jBKUhaLeJfaFa3oYZyDbuhZndePSakfQ1toyzYK9x74w+W4fb0A==
Received: from MW4P221CA0001.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::6) by
 IA1PR12MB6188.namprd12.prod.outlook.com (2603:10b6:208:3e4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.19; Sat, 4 Mar 2023 07:01:07 +0000
Received: from CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::ba) by MW4P221CA0001.outlook.office365.com
 (2603:10b6:303:8b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23 via Frontend
 Transport; Sat, 4 Mar 2023 07:01:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT087.mail.protection.outlook.com (10.13.174.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.11 via Frontend Transport; Sat, 4 Mar 2023 07:01:05 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 3 Mar 2023
 23:00:55 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 3 Mar 2023 23:00:55 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Fri, 3 Mar 2023 23:00:54 -0800
Date:   Fri, 3 Mar 2023 23:00:52 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
CC:     "Xu, Terrence" <terrence.xu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Message-ID: <ZALspPvvLGFuK96F@Asurada-Nvidia>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <Y/0Cr/tcNCzzIAhi@nvidia.com>
 <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <SA1PR11MB5873479F73CFBAA170717624F0AC9@SA1PR11MB5873.namprd11.prod.outlook.com>
 <Y/64ejbhMiV77uUA@Asurada-Nvidia>
 <b7c1f9d5b4b647f0b0686c3b99f3d006@huawei.com>
 <ZAE2J0I1LiBjWUnm@Asurada-Nvidia>
 <d59a0262d5bf423c9e49ad4ac6015296@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d59a0262d5bf423c9e49ad4ac6015296@huawei.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT087:EE_|IA1PR12MB6188:EE_
X-MS-Office365-Filtering-Correlation-Id: 294a8e3c-55b7-4194-cd02-08db1c7e39a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOQwIWj0SFK68mDDNUisaZ2BFGlcNImC+RmvfXFB972b9q8rwRh4sy2OLcJYbQJ7MDAsoAVUKsEZrd3OrJuwOA9ynAfaYjF0lzX/dgK1MHAz4G/B1LT/8tAU/g03N77SR0Gmd1xMPbqPmqcC6+zkz9i8aBARm5YhbgvLNW8b9zh+0yhTxNvCnC2kYy3OjBOzV9J345y4J7BpEWDnsTL82U6/8DTB2DqSseHlsX2Fa1mEpljaHtSgODzjNzeJaHy6Yv/x5mFbo8eCq1SuNcHohArvlnmlgS0zQichbSx4wpxBhu5iJ2+K+35C4SDqBB8//vqXisUlSQ29Ndh/JGvF3LSUsPK/W6lJKQcEp1pHLmkAIf5S3TT54AhSSCciAQyO33b8Mf0CSRj5T8pU6Io/0hBBqHA+a/wRJ+ltqfrYIEzthtSRKvtoNWArw6GS+uEhGbtCN7/M6aGYjjgxETLpt8b5npQk1+HFT7dD2Js0QHq3f4oWwNGJiWE6krufqyezEG5oFcnPLJSz43hEZwm1nOEjXTx1OISrdGqnClxNQhiulUXCiPIZl0q0Ve70eryImRxQczShcupxeEw5NGAeLZPddx7CVnKN2RqEi55GtaktArUrfbmb8smE1T54I8kacTsPI9plmY27OB20gvIr+5lThEtHdZfX1VPDAAW8phb6pO3LXRlEMjXz6wkfBB7NNtcJM1+ppE6sdNjPwE+am+G4kCiZ34HyHUg80Ae5uvM0qh/5Do7HLM3jeif+lap3
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(186003)(2906002)(82740400003)(7636003)(356005)(9686003)(33716001)(26005)(53546011)(7416002)(5660300002)(36860700001)(8936002)(41300700001)(40460700003)(336012)(966005)(316002)(86362001)(70586007)(4326008)(70206006)(8676002)(82310400005)(40480700001)(55016003)(6916009)(426003)(83380400001)(478600001)(54906003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2023 07:01:05.8516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 294a8e3c-55b7-4194-cd02-08db1c7e39a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6188
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 03, 2023 at 03:01:03PM +0000, Shameerali Kolothum Thodi wrote:
> External email: Use caution opening links or attachments
> 
> 
> > -----Original Message-----
> > From: Nicolin Chen [mailto:nicolinc@nvidia.com]
> > Sent: 02 March 2023 23:51
> > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> > Cc: Xu, Terrence <terrence.xu@intel.com>; Liu, Yi L <yi.l.liu@intel.com>;
> > Jason Gunthorpe <jgg@nvidia.com>; alex.williamson@redhat.com; Tian,
> > Kevin <kevin.tian@intel.com>; joro@8bytes.org; robin.murphy@arm.com;
> > cohuck@redhat.com; eric.auger@redhat.com; kvm@vger.kernel.org;
> > mjrosato@linux.ibm.com; chao.p.peng@linux.intel.com;
> > yi.y.sun@linux.intel.com; peterx@redhat.com; jasowang@redhat.com;
> > lulu@redhat.com; suravee.suthikulpanit@amd.com;
> > intel-gvt-dev@lists.freedesktop.org; intel-gfx@lists.freedesktop.org;
> > linux-s390@vger.kernel.org; Hao, Xudong <xudong.hao@intel.com>; Zhao,
> > Yan Y <yan.y.zhao@intel.com>
> > Subject: Re: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
> >
> > On Thu, Mar 02, 2023 at 09:43:00AM +0000, Shameerali Kolothum Thodi
> > wrote:
> >
> > > Hi Nicolin,
> > >
> > > Thanks for the latest ARM64 branch. Do you have a working Qemu branch
> > corresponding to the
> > > above one?
> > >
> > > I tried the
> > https://github.com/nicolinc/qemu/tree/wip/iommufd_rfcv3%2Bnesting%2B
> > smmuv3
> > > but for some reason not able to launch the Guest.
> > >
> > > Please let me know.
> >
> > I do use that branch. It might not be that robust though as it
> > went through a big rebase.
> 
> Ok. The issue seems to be quite random in nature and only happens when there
> are multiple vCPUs. Also doesn't look like related to VFIO device assignment
> as I can reproduce Guest hang without it by only having nested-smmuv3 and
> iommufd object.
> 
> ./qemu-system-aarch64-iommuf -machine virt,gic-version=3,iommu=nested-smmuv3,iommufd=iommufd0 \
> -enable-kvm -cpu host -m 1G -smp cpus=8,maxcpus=8 \
> -object iommufd,id=iommufd0 \
> -bios QEMU_EFI.fd \
> -kernel Image-6.2-iommufd \
> -initrd rootfs-iperf.cpio \
> -net none \
> -nographic \
> -append "rdinit=init console=ttyAMA0 root=/dev/vda rw earlycon=pl011,0x9000000" \
> -trace events=events \
> -D trace_iommufd
> 
> When the issue happens, no output on terminal as if Qemu is in a locked state.
> 
>  Can you try with the followings?
> >
> > --trace "iommufd*" --trace "smmu*" --trace "vfio_*" --trace "pci_*" --trace
> > "msi_*" --trace "nvme_*"
> 
> The only trace events with above are this,
> 
> iommufd_backend_connect fd=22 owned=1 users=1 (0)
> smmu_add_mr smmuv3-iommu-memory-region-0-0
> 
> I haven't debugged this further. Please let me know if issue is reproducible
> with multiple vCPUs at your end. For now will focus on VFIO dev specific tests.

Oh. My test environment has been a single-core vCPU. So that
doesn't happen to me. Can you try a vanilla QEMU branch that
our nesting branch is rebased on? I took a branch from Yi as
the baseline, while he might take from Eric for the rfcv3.

I am guessing that it might be an issue in the common tree.

Thanks
Nicolin
