Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FA45149CF
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 14:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359388AbiD2MwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 08:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237696AbiD2MwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 08:52:03 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2045.outbound.protection.outlook.com [40.107.212.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEDDC9B6E
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 05:48:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDkvqelloDf09e5/LD6zq+uOxgEjxAm50SJSqBx1Plqm1wyVucLfs87Tp8EInp10sAIQ7B1hx2QTPWX2KCCaCIO5QF7gNeasdCTYgPWnZD641K5KvfrHXOjgp+GPqA/F1bsOa0zGIP1V/7fbjTwSheuJECc5pVIKP3C5IIV8bMKZqaakUBnTQgTkIWfvAAtFeFuLGTtF2xWoGJ4qlos59/P8eYL/J36XLBTBM0SLFwpynV3QHu4NTgUXsnGKZsoS7qTxh2NT8f2jn/aMylt9bozalbK2LqCpyFo0xjW1TfWG44fCQTUjNZycEENUQe99ZzcVWnnumaFPr1/D9Tq4sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9UV/oVHI1nu0YmP2XworWeN5xgR8iMzZ/CJH2M6eHY=;
 b=iRflM88CEyFJ6IQ+7QaV4Q8LQcbS4IBiEtpPh/H3WNbhA94KExbEHTWcSyVRONuf+0rGDEOaoxH9Hf8XMvx0wOdTo5yKw8biHayTueb90s9zhJjLm4tGOam2pPkRAbsyPCl1AJSkgxJ7DW7MCZPHcUcry1I5Ohtce7WhGDa9wdqsVqVNmXsCG5lPo+fRK1LfGVwta50xMCUHdDeWIuRZ9AF+1jZSxCDHi81od9iwgBxGZbTbsHXXGn823RUDoVIPY3C1Kl/6SQtdyOSMm6s1E35GNVueO9wwPZVBG3V6ucrOb+pv5w7FnJ0k/HamDI6+V913PT40WeNGxvSMljiHLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9UV/oVHI1nu0YmP2XworWeN5xgR8iMzZ/CJH2M6eHY=;
 b=fecEfdGtmJdg/SQLEcJwkuhEuYmo23xc1TgKSX2iP7K8oIuRnAG/pLGXEOO5PL/rmBd9jD6rAk6LK5juI2EcyKsRvo8sNCwa8Gg46bt1qaVZbdEnpAwb+pfIuclc2QfKw051OGM5NUZ6CMNSlhGWbbiUG8ygrdQwS3X58YPwHrAfqv1kq+7429yziwPT3AdE/WmrIm5203ggTyJTy9vWCs2Z4dRJNNqOltmDx357cbf9ny6rd8Ljxj1csN6Mi8aNkGCNEhB2k0cLCU8qFkB6f3wDt2M4FuZoP0R1VZasYaSclT2ICvIuBOmv944RcnYLMEca9n2TONQEtIY495/VeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1906.namprd12.prod.outlook.com (2603:10b6:404:108::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 12:48:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 12:48:39 +0000
Date:   Fri, 29 Apr 2022 09:48:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <20220429124838.GW8364@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <YmuDtPMksOj7NOEh@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmuDtPMksOj7NOEh@yekko>
X-ClientProxiedBy: BLAPR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:208:329::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2329f29-3ece-4829-6536-08da29de957c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1906:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1906210DF5C252387948DEE2C2FC9@BN6PR12MB1906.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hRs+LOblVRomW+FIwUB4hIzWJIm9BQ1r0gb/bZjkHGQVDa/OuHmjmtTG5TvrN6wvDdgG2zVD1XtLYgbJLMPS9zZI0P9jniGtwQwrYlaIQvp5Dk1T0umAdBbHHLCJSoequjqVA1Ng68ruLIKdC12Rjb9G7P5IH6jIohbuOVkvImCLK+xN2+xnvfH0GN110NFkAwbIngukuhv3mWhnUo68qU2RYZCN3tEPYNm+UmueGqxYiZDU3w6Ci5xWLIKvnp1HEvsNJIvV2+khGLAJndAxeYytm0XwkcB0BGxjLsjIlt0zNuDftUg7nXPd7Z99/C1rRYGB0QA20Uts7EKPXm5p2H1ZLUBCAhrIoTevUgmHyJnwLSquBwVt0HhpPHfksJ56gZ/j0dP3gnTCYisOQJKa4hvj6yKujxonpDD2SGdMo9ervKmSbtv/PNTKJvPUpP9J01HRYt+O5XO0Tt5VRMCEQwsHWHCQ+1wDZIT9yckybA2m59KXa/YVs/tZaIBDNg0vhCYSHGDRxUBO+KVAxY73aVjKmZUEIJaUUPEIc/Yn7ydbXfiMwMwFgRF5xkPc8PPVDHizwDCh+N2IF9gss7ihMqJU6EZM+B745kwOgy9xzuZ7SFvQbO7ieZQwfxE7ViMfpQ7IHdSl6emOkF5FHdAv1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(508600001)(2906002)(6486002)(66476007)(66556008)(33656002)(38100700002)(54906003)(66946007)(316002)(6916009)(26005)(6512007)(6506007)(7416002)(8936002)(5660300002)(4326008)(8676002)(1076003)(2616005)(36756003)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mPU8nrR5iRul6Cv7wR9ENh8KKdFvkvWR2ZIw07ilBz06NnAmMhfbphqcPJQr?=
 =?us-ascii?Q?L19VlcrBCGJ9eWQQT+0Ou2WJ2aqr4YH3lxGUtEE5VNUI7RCnmwLpIiyz7o4a?=
 =?us-ascii?Q?HTbsM5E/1GZ8xJ0duy//gSEZFFOUQt4XEIAgynaWXvJYIdZFcCedI1anu7fo?=
 =?us-ascii?Q?+wijGSFhZkksidaIlwT0WHrxj4RLsHTYPX5VaH0hkkjU+TZ9GlxWqtdfEcF1?=
 =?us-ascii?Q?XLs1uSv7JHh8c4ASmH3GTsE9UUdGOV5Zo3ACujhfpAtOTsSgqrPBGMXpoopL?=
 =?us-ascii?Q?8oLZDFC5GJKs5F0oYnOfdp+XF64BiGZQETawBEXZGkhMTrGudkCluKd7dy2u?=
 =?us-ascii?Q?Ylol+xw0i9JSzdXC4uqS8M3HVAXQMZSHYcGvC+YOYZLKd/vPjKLVy1cIbTxk?=
 =?us-ascii?Q?j74znp/9oLA9fA9N/J7i/uOxNzo1fgZD8AywZpFq50apVcwtikZKz6g1D4jk?=
 =?us-ascii?Q?7bhgNhBbh41ew2cI9Q12jcC+/8ujcPEVFIKLN+AFki0OuEulWMx52Su0VrPU?=
 =?us-ascii?Q?rmjUCO8aTftn9CKurOSLL4prU/SCf+U/3MiEA1on+tmLFfWnynLq7pqkFVQN?=
 =?us-ascii?Q?CaFxvd6jCelGxBUMuEKfxtsJYvjWD+GFfcke5UQj/69lHRRVBDh869cpQMdQ?=
 =?us-ascii?Q?q/cYtli3KGfRXRAx2m49I+YyyRWnWJYcCyx3qsbyvch5BEMYZn9FI2j1xH7Y?=
 =?us-ascii?Q?6d4mYIPRwd/1kzDENxbU2WAv1jeCAFuvGzLY644coNYsQETzaDTva2OKRVKE?=
 =?us-ascii?Q?XmILeE1zX+ifPLELZ4GpCiSsO/r3R/4dTLvwvxsQbnDoF6H4a8Oh3AokX6UC?=
 =?us-ascii?Q?D7tIMJh9q7Y8+zn2wPKu+sezRH7JxvjyL1T3lJFxsQNfPvtp57OkXBQttTBJ?=
 =?us-ascii?Q?uu4pX4jBk+5bVLmCCLpk8Kxx9DadiMOhNIXMacUR3e/c0CfGIQNffqlr9Bix?=
 =?us-ascii?Q?o9XxdmRZHcVlbMtjqVIMw9c2kZYeNxmkMwArenTjKQeAOQzjA65eoczj4Sx5?=
 =?us-ascii?Q?/S0Cz1pK9tcw0XE+ImHu8KOK2z7t7GbSbSYvAyEQzL7JGdlZZi2QN2JEb3ES?=
 =?us-ascii?Q?oq/bx81zYOAE9DLi4SdAXKtpz1J6FAizXn7GQwY6Fj2B6mdkuwx1mMaMww1x?=
 =?us-ascii?Q?2KDkaFd5zrTvRUPdfcn8KNhw85SUWIwsOK5Vkj/nld65bPMZvwZHsnb2Apn5?=
 =?us-ascii?Q?WSd37ENS9Yac97xlQJHvOtcC1/ciNgIecOgijuwtJfy4e4rgBu885br5wMnX?=
 =?us-ascii?Q?syKoLmspjR6Cl28eiMZL+0CvryZcYi+3ch5qzCzOwa/wvMkhnmM4V0zKOs91?=
 =?us-ascii?Q?xDZsZ/INR+yEiwm/B/8WdlzWvgwXfXPWb0jWP7DbDuI2k55kNBT9x0fW5+mk?=
 =?us-ascii?Q?1HxRW+Msj0DvzpBVhcEiRhLGLG6UHvq+b9Wmm7g2u5jmC8jW3rhkmHa27oqI?=
 =?us-ascii?Q?eq+AOts8uEuuYuZsJ8apruJCnVX8H4rkIijXJQ0qxR3+kkFuQSHFYr9iRZFj?=
 =?us-ascii?Q?3s5k6p1o0gee589wS5goSzXfbqW6oOyZ7vsgSZNmmhVXEpur+k5lgBY+knXi?=
 =?us-ascii?Q?EekCL5sAirSC4ilTzDf152C9IRYoUZusJ0xezKmEFMkg59doCqGMG9krQXoJ?=
 =?us-ascii?Q?KBvehYr9SYP9EjiOsgmyij18spMdECAsk2+h05S5j7aoS0bC30g4tN1Ep4zC?=
 =?us-ascii?Q?muXXn8exoi4Q+GSm6Dim9+M5NqVtCMT7WSAYXz2Jkrs+tl+V7BfJ2B9O1qYT?=
 =?us-ascii?Q?KxPpfst4sA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2329f29-3ece-4829-6536-08da29de957c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 12:48:39.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8wnKBSE0PLQscaxscZVa6rRk48AlxKvvMXBBSXxtNqavvLc092V94vfePbbIV+V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1906
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 04:20:36PM +1000, David Gibson wrote:

> > I think PPC and S390 are solving the same problem here. I think S390
> > is going to go to a SW nested model where it has an iommu_domain
> > controlled by iommufd that is populated with the pinned pages, eg
> > stored in an xarray.
> > 
> > Then the performance map/unmap path is simply copying pages from the
> > xarray to the real IOPTEs - and this would be modeled as a nested
> > iommu_domain with a SW vIOPTE walker instead of a HW vIOPTE walker.
> > 
> > Perhaps this is agreeable for PPC too?
> 
> Uh.. maybe?  Note that I'm making these comments based on working on
> this some years ago (the initial VFIO for ppc implementation in
> particular).  I'm no longer actively involved in ppc kernel work.

OK
 
> > > 3) "dynamic DMA windows" (DDW).  The IBM IOMMU hardware allows for 2 IOVA
> > > windows, which aren't contiguous with each other.  The base addresses
> > > of each of these are fixed, but the size of each window, the pagesize
> > > (i.e. granularity) of each window and the number of levels in the
> > > IOMMU pagetable are runtime configurable.  Because it's true in the
> > > hardware, it's also true of the vIOMMU interface defined by the IBM
> > > hypervisor (and adpoted by KVM as well).  So, guests can request
> > > changes in how these windows are handled.  Typical Linux guests will
> > > use the "low" window (IOVA 0..2GiB) dynamically, and the high window
> > > (IOVA 1<<60..???) to map all of RAM.  However, as a hypervisor we
> > > can't count on that; the guest can use them however it wants.
> > 
> > As part of nesting iommufd will have a 'create iommu_domain using
> > iommu driver specific data' primitive.
> > 
> > The driver specific data for PPC can include a description of these
> > windows so the PPC specific qemu driver can issue this new ioctl
> > using the information provided by the guest.
> 
> Hmm.. not sure if that works.  At the moment, qemu (for example) needs
> to set up the domains/containers/IOASes as it constructs the machine,
> because that's based on the virtual hardware topology.  Initially they
> use the default windows (0..2GiB first window, second window
> disabled).  Only once the guest kernel is up and running does it issue
> the hypercalls to set the final windows as it prefers.  In theory the
> guest could change them during runtime though it's unlikely in
> practice.  They could change during machine lifetime in practice,
> though, if you rebooted from one guest kernel to another that uses a
> different configuration.
> 
> *Maybe* IOAS construction can be deferred somehow, though I'm not sure
> because the assigned devices need to live somewhere.

This is a general requirement for all the nesting implementations, we
start out with some default nested page table and then later the VM
does the vIOMMU call to change it. So nesting will have to come along
with some kind of 'switch domains IOCTL'

In this case I would guess PPC could do the same and start out with a
small (nested) iommu_domain and then create the VM's desired
iommu_domain from the hypercall, and switch to it.

It is a bit more CPU work since maps in the lower range would have to
be copied over, but conceptually the model matches the HW nesting.

> > > You might be able to do this by simply failing this outright if
> > > there's anything other than exactly one IOMMU group bound to the
> > > container / IOAS (which I think might be what VFIO itself does now).
> > > Handling that with a device centric API gets somewhat fiddlier, of
> > > course.
> > 
> > Maybe every device gets a copy of the error notification?
> 
> Alas, it's harder than that.  One of the things that can happen on an
> EEH fault is that the entire PE gets suspended (blocking both DMA and
> MMIO, IIRC) until the proper recovery steps are taken.  

I think qemu would have to de-duplicate the duplicated device
notifications and then it can go from a device notifiation to the
device's iommu_group to the IOAS to the vPE?

A simple serial number in the event would make this pretty simple.

The way back to clear the event would just forward the commands
through a random device in the iommu_group to the PE?

Thanks,
Jason
