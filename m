Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C765A4E5935
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 20:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344293AbiCWTgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 15:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344277AbiCWTgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 15:36:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611A363F6
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 12:34:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUURyahsFQMmnEnB2xaFU1Zm/tqXUtKHLJBEdht3Z0F3+Vp5afbnf2l45j/IQ+RQz+DYdzs2RYwuqm6huoWISzazP6dYb/MP7TLlcbt5/wvIJIU+uNQKGV7Oj03/SczvqWT0UZPqxImL9NAVaKGZnrkI5GwWxN8Bm1Z+5iHFFqDD1SblbN9/hdYo+of74HP8tzt8B53EnU7i2j+xKxyavNPoaz6Xi0pZDzDJyg3EqrFX8UBXYX18ihtlaVufMs3tPRVZk0D6kF1kcBaiu2KDbHmDM1lj+rt/PJZvcvWNZkMRpol24YCOA4b/BqKOyPwAH7/oMIq1jUaZChWa3+LwCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYBrssyTkYV5+CPenOKVA9YMmMERH0t8MgrAibiGmWA=;
 b=O4Px8Ylyw/gEx2YZkCywbcPYhfv71NM9iNxIdDAGJe2w+rwubGVBrGWpuswkeN09SaV4Nw2/1Z3UJA6WfAc//TQhnQkh2HXqf5S7+TJAY0Ae9ZH9/oYamQkXnuxdUzAqxMOy7UFNg/jGBatsGco2+4BuWqAOjkStMikS8MVZiajxFr9ZUKDdZaiBUxyblMiTPqXyRg2IJBPuau8IlHAlV+dsocjSfTM9wypvLN4NBe5XDnsejSydp+nPhkPvxTig88R0jgHv+LuyMZ+GFJsEh/h4cV/7EU1Jnj4q8Cfm1iQXZdoE1YSNPPb4pbKcoDVRj/Bwxzo8avh705iCijyQWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYBrssyTkYV5+CPenOKVA9YMmMERH0t8MgrAibiGmWA=;
 b=fBctiu/RR8O28psOir4kdD5jhAjWVmIgQV7U7jMdbJoCLrNqgTynYTXYGo0dXfK6hkuN0G3/AbPgrlTltJCpm/C+YuzgBrWMbMjiKkyVJjivcY0M17i1rnXj7zHV1wGeBlEArpWH3EA96thc4T2oZbi9qo35zw+ssPq0yhJyUw+7ogDzJHd9oirKtju4I82myqdjhCSXOa9sBaFWZcFbJf26TA1rN6S11NbHaS6UP+Qco/71qJEqIIUPe2/+ecFnQgSY3wMnvmXQR87REFzNL4wSglC2Aaw+09M5RBgkZC81xnjRRURyOsJcTzCf617eY8C11jw9KUs+j3q17Xejvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4502.namprd12.prod.outlook.com (2603:10b6:208:263::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Wed, 23 Mar
 2022 19:34:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 19:34:40 +0000
Date:   Wed, 23 Mar 2022 16:34:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
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
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220323193439.GS11336@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323131038.3b5cb95b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323131038.3b5cb95b.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR19CA0050.namprd19.prod.outlook.com
 (2603:10b6:208:19b::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fa218bc-9d79-4c52-a510-08da0d042c5d
X-MS-TrafficTypeDiagnostic: MN2PR12MB4502:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4502E0C4797B203647513DB8C2189@MN2PR12MB4502.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ox81EMa3WkLrvXlju1aA1tgmTeeQj3qAgAgkfuXSqj1JubSoofPdo83SHOg4arMMZgp0zXQk7CDjOecNq5k2NTwnEc6EK9dTiF414l5aHFT9D20L/N9TisbJaLZnxubRW7RsE0om054HCem3uyyBggKM8NINOBqQJkJSq63NbnEfwQZ10uphrL4LI5DopSeAX5hjYyl5A+35RstP3OYvUP5cnwu+DeHEtAXx8LzkcnkbrEIB/cztj8yVkt7oHbUP1NRgoaN2Hoegylhm4orffJquZIvN3NXqYGbc7a+EwrZIlLtt5jDgyQofe3nPAazWdsUz82zHbZjsV2dRNLlJh0kSujr5ThvY/dHt8Ywqih74HjgVB3Wmi22M4seDFwfgkYoNnLfzoMJFoE1F6soZFh2CAwJr1OEuEr8H4dePhTcQC1LJq8UPNF71Dvc17oOiXVde0gPQ1cPLAojUwQe24HJMX6ZVeIV3J8L45RE6N8hH60Tk70ijf0FymVetrLIoRuiWQuHVj6LNCZHi/mPnqIM/lMVDBr7HWdy0ZVvfBh4ndivaOvEy9NvanUc5wPE/lqGNX9WeqlBzHqgrO0G8bzDNog/3nXqsKFcWb6fvR0YumuStLPXMRI0Wmoz39JDLsqIFA4t40y6J+Bgjg9MUew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(508600001)(6506007)(7416002)(186003)(1076003)(26005)(316002)(86362001)(36756003)(54906003)(6916009)(2906002)(33656002)(4326008)(6512007)(66946007)(6486002)(66556008)(66476007)(38100700002)(5660300002)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gH6ZFkerTz6ovMMLz+Y9TWnSeiig4UIAG6D3oJQU4O6EAPs0OPdFb3IhGcnP?=
 =?us-ascii?Q?/It0PXIzoO2fjxoDLRNM5meqWdoXI0Iuduu3xEI19P846y1cXslzFnZIU6i7?=
 =?us-ascii?Q?bcHIugtre/C9yPIdN+S5nmzLZT2niYbjiGDQ8sL2vXsiIKbvg8ml9qX0R9Sz?=
 =?us-ascii?Q?AhEdSs6wGZ3zIaYkazcDnk0iSJyIfnfQwJ7FSB+hLbhbu1pVg0SQF/urOolt?=
 =?us-ascii?Q?7JxMdjX/7LpdbmXdeOODsCo8fJoHDd0AljV70whlWctY2M/jkD91HKWsWnfq?=
 =?us-ascii?Q?GcFpBhLdCzwFcBMGL7QbytFhjS+M0xnPYbhplqhHpRONBmihZYV0dn5Rkg61?=
 =?us-ascii?Q?hsUXZ71tCPTtymbMqkFQAYkBNQYG114v6Py4UQpjatxX0lKo2x7viLpmKBXz?=
 =?us-ascii?Q?kHThq5LJT4uXHUM38D86XPQ649X+sJVbJ72DnkbM5FEglfwemry1Z6SJVAtn?=
 =?us-ascii?Q?ZJ5B8wzy138IA5DPL9UiTfYL+wyGbIDN9nd2zxdNLYv8+w86TqVGhayf+pTm?=
 =?us-ascii?Q?qmaZTImnLZaHf/fzBRYO5TlYpvU+KBuwjCFIlVxXoB22ZtNvYEMqCDlIfXFk?=
 =?us-ascii?Q?PTpzBCU7MBCAwA5oT9AxblRoKQCdUUHyjW3JnmlHYuvMt8acs++lnovViaIe?=
 =?us-ascii?Q?08YjhPKvmIbTGzH+xYlV6leMPKSqXcK5aNfO85JeefcOV7OWlhR+rRpjdJOb?=
 =?us-ascii?Q?z3MBAypGoLVN8u/fiuVB1WpnAzi/f+FH3zuBmUTS++c8iDU01pj0Ur00KjxX?=
 =?us-ascii?Q?mt0K3OlRLadi93nEEgzFlNh79+OXf7sonig8+Uv/E3yLDjPmWNOW6NbR1zhr?=
 =?us-ascii?Q?mEfJEM22fRfpPLIDNRABFAJjt7VDucMP0tp6gp6A5BlEiRVEvYUv4fQs9nN9?=
 =?us-ascii?Q?gmq8llOss/yaQZbQlF120H8usON3RnW5Dh3mckaZ7KE5yaADoU2zoaEgfZ0U?=
 =?us-ascii?Q?AlI7TJUFYc6h0qJdJ56l63TPbtb3GVI2/R9RYE5/JmNXb7x3TTKZi5JarIc+?=
 =?us-ascii?Q?gocOY+I3/S65JF1wnSvZJjFrDieBIPsQAn9JN1+9AKru4QX2OnwbNb/Yg2I+?=
 =?us-ascii?Q?KN87q5wSPpxOaqSmfXwsrD8Q5GqM76R3tkPCiRYTbYtpSxq4yTPF2tsOYpyG?=
 =?us-ascii?Q?IMmAlZWcvruS8VWa/n5jQTqK6tE21IOrPp3gY4gKnnGQz68GkLsiLdtIjN2v?=
 =?us-ascii?Q?YICoyN6Id1XL+/2F7FmMSrnk+tD7rv7rgG6ovlub8+qLU9mA3wA5yyEVsM5B?=
 =?us-ascii?Q?KW3GhNcvPZ9YrTSlvfk/zPnCM4FtpiQx8CjE/J45gtriG0bIrk2d5uu/6cs4?=
 =?us-ascii?Q?e0rF/N4PAQyNZC1Me6vJDTAraP+FJXDTNSns+GwHxqlmd/Kvi+yVNxgZhwye?=
 =?us-ascii?Q?ngMD/jUiowj/y+9J44WS8nMPXAQOn50y6X+lS7+A/n29X0aupW3d8eayFmJ5?=
 =?us-ascii?Q?lUFDaCl4Ru17xTkSEyuSAzyrkPe8Vgcl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa218bc-9d79-4c52-a510-08da0d042c5d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 19:34:40.4991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3dmp0Jw9BZS4gOzOvxR9ZrxJ/NGWykjHcfzUiYApEAOzKUxkg+1AHBA1wBfSS8fJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4502
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 01:10:38PM -0600, Alex Williamson wrote:
> On Fri, 18 Mar 2022 14:27:33 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > +static int conv_iommu_prot(u32 map_flags)
> > +{
> > +	int iommu_prot;
> > +
> > +	/*
> > +	 * We provide no manual cache coherency ioctls to userspace and most
> > +	 * architectures make the CPU ops for cache flushing privileged.
> > +	 * Therefore we require the underlying IOMMU to support CPU coherent
> > +	 * operation.
> > +	 */
> > +	iommu_prot = IOMMU_CACHE;
> 
> Where is this requirement enforced?  AIUI we'd need to test
> IOMMU_CAP_CACHE_COHERENCY somewhere since functions like
> intel_iommu_map() simply drop the flag when not supported by HW.

You are right, the correct thing to do is to fail device
binding/attach entirely if IOMMU_CAP_CACHE_COHERENCY is not there,
however we can't do that because Intel abuses the meaning of
IOMMU_CAP_CACHE_COHERENCY to mean their special no-snoop behavior is
supported.

I want Intel to split out their special no-snoop from IOMMU_CACHE and
IOMMU_CAP_CACHE_COHERENCY so these things have a consisent meaning in
all iommu drivers. Once this is done vfio and iommufd should both
always set IOMMU_CACHE and refuse to work without
IOMMU_CAP_CACHE_COHERENCY. (unless someone knows of an !IOMMU_CACHE
arch that does in fact work today with vfio, somehow, but I don't..)

I added a fixme about this.

> This also seems like an issue relative to vfio compatibility that I
> don't see mentioned in that patch.  Thanks,

Yes, it was missed in the notes for vfio compat that Intel no-snoop is
not working currently, I fixed it.

Thanks,
Jason
