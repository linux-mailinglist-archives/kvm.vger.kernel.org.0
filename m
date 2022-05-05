Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C8051C8AF
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 21:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354834AbiEETLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 15:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244319AbiEETLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 15:11:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2803A4A3CC
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 12:07:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRJ0GV6NbtefUs++Ir1/RCW/KU59hQ6lydOVZr7ckuSWgmC4rR96U4zM+yf2h+Bpg4WkE42pv/xm47IFsvsHMhwQ/aMVTd3Q8KFyFn3XEpnyRwCQ81uB5rVWckdcX3hIWJKpXhPR8s3QygFylk6ZlttRSDfDfJptO4OoKDSeleV9MtiSLJGuG2Ax84s/ilBnPO0osxvsHSTIgyRYQTVAHNwp/cBJ8f8Ha8QTCJgSRpjUvCewe2HxGyIuJ7kpuRdBlQH4n2BhlocxzCenkyomtdNFUlLI36nknjfUDpQ5SvSlD0dTx1NZ6XKb0L3x46vgveDLsNw2nPC3Zj7tlH0KyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sboAo7rwWBIqJK8bKI22y/BPUmSI/LO/ISv7RLQa++s=;
 b=c9SLrir6hqRR67hnpV6Owaa3QMqm9Y+z07esUcfsEFmY9xQCuXxMI+4xQX+c7UQwabEO2TTFlEAL2Sf6xlAgt90dp5S77NrXE2zUwSZHsoaPSfFqSG/sG22+884yTg595VaMaBMBTZa0YWbi/pIPMorByJfJuHzyzqXrpWiP1PjFXjtZajEUk2kAX7oUbN5OL9ain63FfpDCfA5p1JOLqGQAJbH3a8WHDx/ijqRjVZAbjZnVGg3+Fz3n4Kwuudy26/rcLGbacrgamLt9x7OLhmUKRe87yR9H550z9HhhMUT60RK2X6koB1xjh2peY5x5G9SU6QycXpPb5s/JHPTtWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sboAo7rwWBIqJK8bKI22y/BPUmSI/LO/ISv7RLQa++s=;
 b=c/t/YA6mg/u/pTZEI8p99oUWBXI3iVgSJ/BRJTW+zyLGPIOczWYhxMn5EBZg9N1tk6EgzeA5o0sOLhNmkuz6FIjyncX1haOVsoj8Lp9GGeR7rZn2NOQYIDg+VRxOWcg22A7sK6vvz3lGsnfcFOJs4lhf2AuTgx7HRXDMVSBIO62fCgomyhY5Jjr33v/yNHydNCZ4S9fYL8zivJhEKACdDf/n3/FiHMGGTMwoZonTpjyrKtbnK7JbDNkJIdJ+idgFn5A4/KkNJUqohZzywQyc+bfA+r3IVV39y6uDmRJN0WmeLxsTJCSTcS0hQhFTo0Bwnr9kvc5vzAmRSx3TquKWHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB6334.namprd12.prod.outlook.com (2603:10b6:8:95::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 19:07:29 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 19:07:29 +0000
Date:   Thu, 5 May 2022 16:07:28 -0300
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
Message-ID: <20220505190728.GV49344@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <YmuDtPMksOj7NOEh@yekko>
 <20220429124838.GW8364@nvidia.com>
 <Ym+IfTvdD2zS6j4G@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ym+IfTvdD2zS6j4G@yekko>
X-ClientProxiedBy: MN2PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:208:d4::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5d19276-914b-43df-7e42-08da2eca8013
X-MS-TrafficTypeDiagnostic: DS7PR12MB6334:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB63343EC16E86DDEA817B2D75C2C29@DS7PR12MB6334.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8sAZ8BFVA4U8DsOuFhpTkGxg4cgg38q8opZC0BEqJXjJGkOl60eqVUKKQzDTQ/eWlOA8iBWw62tHVEMAS9W0vk0IKs1hP39SPPYtSq5gxiLZLToCwKbD1TO/LFmiVPf+FoejC6quQ5zTVhJLGFDBRXU6JapwHC0iWL3jwM2wTbYMBn5zccuAinv7xWJ/bB2OPMGJmC0OrsRHcbQO0XvPYaN9PPoGNPfvLqo69rJKyTqJfqSVU/6/4Q6bXntjY2uHwkIaVV1ltJvyjG2R1dVKj8vthS7sK+M2HFD/chc3373CTuka6BvDJjVLHe/K0NGWHaBpARdmpHZOzxzhm/oQ9mnKCj7BVGPL8ggKaOOn8Y4A7/8kV7H/vHnmChOqt1mKVrIEE4KN4+CG2W23IPvP0MguXPMhijHki6dhccusoP0ko8v5uwoOT0Opr+6hh3P45NapkbO3fl4LZJMAssFsDc8NfSP9MAm52GVSJl0CD1FrJs6L4outD8IYtqm3DKP07282h51hxSfmYfXUKFc2tzXyz+VXWYwAcpNEMqCgm3QbEc6X8SGG4p60kWl/c5vQbkzdg/WT4bGkgHFZAx7FPwftzoostG6arPxVj0rJ0DzXGPYlsrt7vLBwdeACel9+U7FOXd7ZA999jBqnFLbqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6506007)(2906002)(86362001)(26005)(36756003)(8936002)(508600001)(6486002)(38100700002)(5660300002)(8676002)(7416002)(4326008)(66946007)(66556008)(66476007)(83380400001)(33656002)(1076003)(186003)(316002)(54906003)(6916009)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kw/8L4hc6UHC5zUnkuOv7VKNRh6aKeJ1wGU7VuvQYDqnPbTUFsjcb6v7rueZ?=
 =?us-ascii?Q?vdJIqsG8ATyTB7U6ZHMfhWZYrX4f5Ne+k+hKX33+7Mqg4tquy2Z157NAZtZY?=
 =?us-ascii?Q?n9bW5Yi0JW1F6eRjiJbY6bjPZQJYTM5kkYy4RTbvwQ9mfqbHW7bVcNC2XsmW?=
 =?us-ascii?Q?mRZjKlhFe93IgZJFToCpy5mhemLMknR4lcoOSKtwOVtKJUtccGxc0wmoCi/v?=
 =?us-ascii?Q?sJpLJ+Ji+y6Gnw6tizBfDvyn6TJCXgRgohBmV48IaaOb3XrazSfMu/Av/nDi?=
 =?us-ascii?Q?Sj2GsfW/oYJePPQKiQvGu4lZjUSDvZLt3yKiyQNBjocvIgpt7AHqHWAg9axl?=
 =?us-ascii?Q?A6+oCX9K0GPMz8n9MNHh3P1CagV1dg6dhEXOZC3nHE7ds7sMfVjMo2ZrNc9i?=
 =?us-ascii?Q?zqdThL49s5oTdOBUD1ssNB8Qnyh9JGKTSjadNZZVBqQyaWQs8d5eZGcgmch3?=
 =?us-ascii?Q?NgpydLsTC98QGYA/6fXdghuBWS3oD643xrl5HUa7LUlj6AHiJzVvS1M9z2Nb?=
 =?us-ascii?Q?ewEqWDk6P0/f75/tLWMUQ5MhvJgcidvRY8nj1Mk3BuQbvbuzhEfdvx831poq?=
 =?us-ascii?Q?tHqQUHcRbWBnb3I7jlFUzKZ88gI4omVy3O/AD3pJ3sSYX0pO3LHh4r9X3DTZ?=
 =?us-ascii?Q?RHDhpT4uVQnaH3M4S/noLYw3nUeN3X7RSFqr56FINKhbGKZWMuzKjB2N35sl?=
 =?us-ascii?Q?Ffh+oTiL25joZWY9Hp2WtteZLyBWoUdSwR2Dx/br0bqbxbjfNsiaijtzEA/f?=
 =?us-ascii?Q?Qmg1TR03GaBp4FvsyG8WVeLj18QQp0YP0onty/wp6VQaO0Ce9mqbN6BEzkOi?=
 =?us-ascii?Q?WuLqb6f/ZDxtO+8C0iIgRtuHHbA8qMWYQdkFdpJnmFO9CWmTQSlJ9k70dCTx?=
 =?us-ascii?Q?g9Pwj7PJbOVQWxAq8Mm2EZEQrogAQhh4KQhXqGy4x/cO8N6LSCcozhMXMLh2?=
 =?us-ascii?Q?247Dc7q0H+gS+CuFN/UQ1/KyvENknGnjlxT6KAvSUJDJshU+G+H3HXnVM8xG?=
 =?us-ascii?Q?yKCE4+bts0QbzWsXrZEv8Z8FM2GKXmSV3gm3E1NbFpSAcvY04zT7C2GmuQJz?=
 =?us-ascii?Q?ZpXr3VLHyXri6EK8qIuopf0hxq/qAwK2YMIKnpa2BbGgzL6cf8EX+ISkeyn2?=
 =?us-ascii?Q?OQPeud6iDXXSSt/KrvYvWcXYKShRwpwcilf18QogS54R26l8Z3W7oIYaE3go?=
 =?us-ascii?Q?NA1IBrbPkdPdkBchoq4soAEUhoby/o/upxIOedYPOY0eX0+lJNS9GfesOWWK?=
 =?us-ascii?Q?8jigqqdTj6/KxYYnEYLXtk64rcaDEjtAFiuUkmAYz+Cki/CpHO5q5hwZpHoX?=
 =?us-ascii?Q?g7QDwH0Es8aFvumPBLZDQPf/Tb3RQD2k9/e7ub9FfGHSaXnSsc1X7xjnKfz+?=
 =?us-ascii?Q?la4In877kXPmozRjhmx1VH020kHaZzCdCfIS43hZ16xMGHujE39EjeFLqvbo?=
 =?us-ascii?Q?RA+Ic9aESKb/deauAfYYu1G7wjr23383QKohZlezzcoMsmaB3fItwGyBH+lt?=
 =?us-ascii?Q?rnTFmN/fezCgkQAi0n34iIPKiELMjTcnLCl/Bs3gTSfI/z5ywdpjXSGLUIuh?=
 =?us-ascii?Q?oXDa36kGDr5jTPRfGnIEjK9pQr1MP8qE0v3bRopC2Z2+Mb4E/YQtQobxtGsM?=
 =?us-ascii?Q?/5aj8hNCe+BdljMHSog9peuD1W1FP5md8tkxqLiPgeDiHjmWE0C3dUQi+Iw9?=
 =?us-ascii?Q?5D9SeTQar6B0HcCpmlHYdnJ9KHv3iMY2hD09ZY1Y6VhVzU7P0MQkXTcg1/n0?=
 =?us-ascii?Q?TQuRSw+Buw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d19276-914b-43df-7e42-08da2eca8013
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 19:07:29.5566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/ddyA1r80pQT0G9GCcJSTvqVkDmgNxk1jLU5XwqLQmq10qYDZ2wDtC9+bvt3rty
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6334
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 02, 2022 at 05:30:05PM +1000, David Gibson wrote:

> > It is a bit more CPU work since maps in the lower range would have to
> > be copied over, but conceptually the model matches the HW nesting.
> 
> Ah.. ok.  IIUC what you're saying is that the kernel-side IOASes have
> fixed windows, but we fake dynamic windows in the userspace
> implementation by flipping the devices over to a new IOAS with the new
> windows.  Is that right?

Yes

> Where exactly would the windows be specified?  My understanding was
> that when creating a back-end specific IOAS, that would typically be
> for the case where you're using a user / guest managed IO pagetable,
> with the backend specifying the format for that.  In the ppc case we'd
> need to specify the windows, but we'd still need the IOAS_MAP/UNMAP
> operations to manage the mappings.  The PAPR vIOMMU is
> paravirtualized, so all updates come via hypercalls, so there's no
> user/guest managed data structure.

When the iommu_domain is created I want to have a
iommu-driver-specific struct, so PPC can customize its iommu_domain
however it likes.

> That should work from the point of view of the userspace and guest
> side interfaces.  It might be fiddly from the point of view of the
> back end.  The ppc iommu doesn't really have the notion of
> configurable domains - instead the address spaces are the hardware or
> firmware fixed PEs, so they have a fixed set of devices.  At the bare
> metal level it's possible to sort of do domains by making the actual
> pagetable pointers for several PEs point to a common place.

I'm not sure I understand this - a domain is just a storage container
for an IO page table, if the HW has IOPTEs then it should be able to
have a domain?

Making page table pointers point to a common IOPTE tree is exactly
what iommu_domains are for - why is that "sort of" for ppc?

> However, in the future, nested KVM under PowerVM is likely to be the
> norm.  In that situation the L1 as well as the L2 only has the
> paravirtualized interfaces, which don't have any notion of domains,
> only PEs.  All updates take place via hypercalls which explicitly
> specify a PE (strictly speaking they take a "Logical IO Bus Number"
> (LIOBN), but those generally map one to one with PEs), so it can't use
> shared pointer tricks either.

How does the paravirtualized interfaces deal with the page table? Does
it call a map/unmap hypercall instead of providing guest IOPTEs?

Assuming yes, I'd expect that:

The iommu_domain for nested PPC is just a log of map/unmap hypervsior
calls to make. Whenever a new PE is attached to that domain it gets
the logged map's replayed to set it up, and when a PE is detached the
log is used to unmap everything.

It is not perfectly memory efficient - and we could perhaps talk about
a API modification to allow re-use of the iommufd datastructure
somehow, but I think this is a good logical starting point.

The PE would have to be modeled as an iommu_group.

> So, here's an alternative set of interfaces that should work for ppc,
> maybe you can tell me whether they also work for x86 and others:

Fundamentally PPC has to fit into the iommu standard framework of
group and domains, we can talk about modifications, but drifting too
far away is a big problem.

>   * Each domain/IOAS has a concept of one or more IOVA windows, which
>     each have a base address, size, pagesize (granularity) and optionally
>     other flags/attributes.
>       * This has some bearing on hardware capabilities, but is
>         primarily a software notion

iommu_domain has the aperture, PPC will require extending this to a
list of apertures since it is currently only one window.

Once a domain is created and attached to a group the aperture should
be immutable.

>   * MAP/UNMAP operations are only permitted within an existing IOVA
>     window (and with addresses aligned to the window's pagesize)
>       * This is enforced by software whether or not it is required by
>         the underlying hardware
>   * Likewise IOAS_COPY operations are only permitted if the source and
>     destination windows have compatible attributes

Already done, domain's aperture restricts all the iommufd operations

>   * A newly created kernel-managed IOAS has *no* IOVA windows

Already done, the iommufd IOAS has no iommu_domains inside it at
creation time.

>   * A CREATE_WINDOW operation is added
>       * This takes a size, pagesize/granularity, optional base address
>         and optional additional attributes 
>       * If any of the specified attributes are incompatible with the
>         underlying hardware, the operation fails

iommu layer has nothing called a window. The closest thing is a
domain.

I really don't want to try to make a new iommu layer object that is so
unique and special to PPC - we have to figure out how to fit PPC into
the iommu_domain model with reasonable extensions.

> > > > Maybe every device gets a copy of the error notification?
> > > 
> > > Alas, it's harder than that.  One of the things that can happen on an
> > > EEH fault is that the entire PE gets suspended (blocking both DMA and
> > > MMIO, IIRC) until the proper recovery steps are taken.  
> > 
> > I think qemu would have to de-duplicate the duplicated device
> > notifications and then it can go from a device notifiation to the
> > device's iommu_group to the IOAS to the vPE?
> 
> It's not about the notifications. 

The only thing the kernel can do is rely a notification that something
happened to a PE. The kernel gets an event on the PE basis, I would
like it to replicate it to all the devices and push it through the
VFIO device FD.

qemu will de-duplicate the replicates and recover exactly the same
event the kernel saw, delivered at exactly the same time.

If instead you want to have one event per-PE then all that changes in
the kernel is one event is generated instead of N, and qemu doesn't
have to throw away the duplicates.

With either method qemu still gets the same PE centric event,
delivered at the same time, with the same races.

This is not a general mechanism, it is some PPC specific thing to
communicate a PPC specific PE centric event to userspace. I just
prefer it in VFIO instead of iommufd.

Jason
