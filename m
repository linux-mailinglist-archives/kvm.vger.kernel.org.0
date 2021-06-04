Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA96639BC7E
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 18:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhFDQF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 12:05:27 -0400
Received: from mail-dm6nam08on2040.outbound.protection.outlook.com ([40.107.102.40]:5056
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229924AbhFDQF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 12:05:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b02Qt2E+oNyXLaOqKxTAicUrud9GHJQ0Q5FORmy0rO3Ad3MHx4ds+BQHK3P8Qt10hhPuxmK+yc+zqa8qq22/80f5d4YUqygMHphLtd6tnsRFybd5QVk87IiWzR9sOdrASJwACHSBOR7bYQeZyGAQBWKWA3ocXDeEn0fi0eoNoueYBWlMNtsnjkvO3vPXHSbtlofK4/+4lv39ejNy97NNTdg1FxNy+iELnoMmAbaOMok6EA69s5JgXGWYYMO29KtHBt+0ez9TLCTZHXnv4BxSFdEsGXrQ34QUFY/frlZS/X7nj5XkEk42uO98j88c2n9lu3j+YgJPiwGY9GEjmcebUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDQ//W7/WXIBw5zORbdNzGxRPQfDjbUPcAS+6SWXP08=;
 b=O56B3t0agwMVeY/q6jDXBLL4fxcEYZOL0V/t7ffcxP8QNoUHsHtmwDEyExwlzOcxpwOFaJ7U8A/0aYhiYcDX2Atg08boWw4295BYTeNsh+nL63z4s2Ngl2ma0UIMuRieNN5LTNdZC9li/xq2+3q/R0e/u9DbHLMcw3QVpMa5tTW7RAXC04yd5wFM9eeuoe8gR7V2TKlq+yOs0gPh5Y0WMNzqCFgVkoswozSEC3cuTOLOX+yALkWXxMFsR1j8mUUKyXpcpDGXh9fD30NhUns8436lULwsTGnXMFxN0sVdb0OmP2q80x7Xfzn0Q78+/+hAgeInXcuJ5A3kxagrCohzzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDQ//W7/WXIBw5zORbdNzGxRPQfDjbUPcAS+6SWXP08=;
 b=ZV+WuWs78m6v5Yp2BXQmti9nPdwe7ca4qErsCG4dJIoPLf9nru45Mfn1UjYSPPQvq7COpSQb7GX1jFN6b1gZ/fjj5Wzxuy28TRczB0QIOD8S11he+wELVMNfDSn37SAuXuWG4O2qrd6Tb/wbKeyLCQqoCI5ZTx03mC5Q0quYw8Mlc9jHXJf+EAt1jlWyK7ZIxw12WKmoEOZI7nX92zxCIpiQb+Lrl9nSL5W7cxOKZIQwjQ8kiaBagzJH+omMsuD+X/z+Q05lglL9D6UZ5T+Pi5H/9nmUAqMuEOL/oSuhzCXF/w2SQ3iHwym6FItmt/JPAMTww15c2V5WArv1mVIKEw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5125.namprd12.prod.outlook.com (2603:10b6:208:309::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 16:03:37 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 16:03:37 +0000
Date:   Fri, 4 Jun 2021 13:03:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604160336.GA414156@nvidia.com>
References: <20210603123401.GT1002214@nvidia.com>
 <20210603140146.5ce4f08a.alex.williamson@redhat.com>
 <20210603201018.GF1002214@nvidia.com>
 <20210603154407.6fe33880.alex.williamson@redhat.com>
 <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
 <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
 <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:208:32b::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0010.namprd03.prod.outlook.com (2603:10b6:208:32b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Fri, 4 Jun 2021 16:03:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lpCIK-001jmM-Lr; Fri, 04 Jun 2021 13:03:36 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e5c7bd7-a887-4138-1fb8-08d927725021
X-MS-TrafficTypeDiagnostic: BL1PR12MB5125:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5125282C9D6343AF749160D0C23B9@BL1PR12MB5125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EUicvy70fS6KoUZfPuqXhnaIY6tSVP+6OXQdNcJ6aNVCf8sZU2BI4+MaFUFATR9JbcCX1xJl3fAcCvsDPFnv1vlV5HCgETL5F5AUMZI2b6++pSZs/Rto0pWMMRnOnBkfezYzgsgJn6partKTrFO0+DV93dY5R64MgbuhK5Rp5FDq9Dd57gzEXAm0rAXupa+1hVgd/ubprlzU4LeZ40MRm5EJ/nSi41HoOwiErr3nuiAHKi8Uck6sSXnRMpgz69xFx7Ee1PakfEEd1HwkFTprUeJNpy2QgPTaOWWBJLaZP8/o6gMoNlKgvGoUL3qWuoiq1oaA3VST5OyMqTVU45jVTzZigZqZpeakI10YVba1YPn7jbYqOurlz2QeOm719hXyLT151YpXRBin3czwZhNb2WUF/9zduu73sYMNHbGsFS1pIMJVw6DbjOrvCWBLHL6cOLMcXX9PYYkRUDATcQrht+yBSWQybz+ZhMmntHGZdhhzTwponfn9iDYtqThgfnJnTGDe1WA/wQjcTlb7khQ8+x19OuIclRVrZLY9cazEaefpTb59RKHOXdQg26Oqati9k3tyPbisgjPgTX24DXg3OG9YlaBcj4Dli1YvdRIDHZdUmUcVTMLVLCDbMSeG7g8xBnRlLbm8fOFHBjcj5umJoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(53546011)(9786002)(36756003)(8936002)(86362001)(2906002)(9746002)(6916009)(66946007)(186003)(478600001)(83380400001)(26005)(7416002)(8676002)(66556008)(66476007)(33656002)(426003)(2616005)(1076003)(4326008)(316002)(54906003)(5660300002)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HIOH6YBEHltGKW/J6ez+o9wE2BDZf4VDuFZrJZKSdBF1K065nbnux4m1zxmg?=
 =?us-ascii?Q?aGBq2hI2uwFG46U9bv+oCJRq3QVlaoF4FF6M0mcDBpmixRLNzoiefCyzFDvZ?=
 =?us-ascii?Q?gkU8exfkBp7axF9xY/yPjm7GVPxGYkDKL82Z1WclS3iaAD6voLo0AcfeOItM?=
 =?us-ascii?Q?Rgt4txvOlCTBnrAIQZ2yJzuAzRS2lI31ZkAuEPO3rfuh7UejzPD15AI9pX+O?=
 =?us-ascii?Q?/xR+IFnB45mxq/NALhn2EIpyE4fTZgl9w+0GrlYV2VKzI6yKNCIRSML5o5qm?=
 =?us-ascii?Q?WHuYeOYKFajyoG/aPphvgJqu/FTAFHafmIxYETu/Z3LpzdNTkBQ7VbCDAnGP?=
 =?us-ascii?Q?s9v9uZgVzga21KsZpNsb0Si1iSNayV0epNb4qc9aG9cIwTWsQP69GZzluqVi?=
 =?us-ascii?Q?/qVQQkfMCrWfvbcqZyY0FS/upMhcmeiegwlIGhPeVBJa1AypmuElTGzO+lqx?=
 =?us-ascii?Q?fB9pTOO4zYFZG3s5zrATZ06mXJsSTPW0y7Jh7U8v6d9IVYmFX+2h2oWxU45S?=
 =?us-ascii?Q?qWBm7BALG+UO+EGTJNks/+Kn2uUFMypYQ931ChtoddThJYfnRSrkVgQZZazM?=
 =?us-ascii?Q?+Z4KeEULXWIYCKcY7SezxYOiMWZiGyhevzfvLEgn3ctyzA4bVDZR2AFAflzp?=
 =?us-ascii?Q?0m590VjOTaxIXfU8wG5JSX21S+c4O7xsaizLIkG3oMMN0VOLpItWYmfUaFh4?=
 =?us-ascii?Q?E/W0ELBa3aVpTVLsZ68TAqTOsDPk0rraAzzFufMfCqgt+kgtVsEatq92N9YP?=
 =?us-ascii?Q?ZloBQ2mr5UDTN6gdEfGNlK6Xqu3VNmhrcs+NVHGzIDcOfAvzqx96mVlXknE/?=
 =?us-ascii?Q?DFBvXjbdoZvvgXPjWCvIZdau6qCTgpNxo/IjH72sslUySKHqt2kIoAMKIz0L?=
 =?us-ascii?Q?PRdGvzLTUHyjEEDRlyxpnP6G7x4V4NFOc9usMsQzCxebEw5jYy9CgrfJV1mt?=
 =?us-ascii?Q?osZp+27x4NMwbQA12p5Seh1frj692MCMyII6lQH3b9Rf3My33eMFM0UmyTI5?=
 =?us-ascii?Q?Xa9HkGgYdUKhL7WeWJ8Saw148Ht3nRvCCcvbgWUwuXCdWkawEldqocF+828C?=
 =?us-ascii?Q?amrRmxMtYusf+n+DBvsXhMOzskcT0vpz6lCAj6ZMSQ4UeQ5Kx5ECXGe3PKEc?=
 =?us-ascii?Q?GTHpAzCGzqvl7SxIkOXVx2TLSRid+s4hPfxw9YV96jCjamKC8bnbEaHG00WN?=
 =?us-ascii?Q?YijgJP9cmJGrvC8kqaxX0SuDLYiFVgViEQhVX4JvJCQpCKxhlLhO4JASzkvL?=
 =?us-ascii?Q?i6yQjAtYgYoncbGjOaPXRo1MCiCo8qdTP/ip++joIR3peWwgTi4WOjsHTlFe?=
 =?us-ascii?Q?qxw91sv4tuyfuPhTdfYt9PeG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5c7bd7-a887-4138-1fb8-08d927725021
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 16:03:37.4903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNTKcU+7u2VVFjz1L7YZwo34MGYyi0EUMfH+29CsWUzf1FOOTHQKyWcGnW8TvxJC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 05:57:19PM +0200, Paolo Bonzini wrote:
> On 04/06/21 17:50, Jason Gunthorpe wrote:
> > > Extending the scenarios where WBINVD is not a nop is not a problem for me.
> > > If possible I wouldn't mind keeping the existing kvm-vfio connection via the
> > > device, if only because then the decision remains in the VFIO camp (whose
> > > judgment I trust more than mine on this kind of issue).
> > Really the question to answer is what "security proof" do you want
> > before the wbinvd can be enabled
> 
> I don't want a security proof myself; I want to trust VFIO to make the right
> judgment and I'm happy to defer to it (via the KVM-VFIO device).
> 
> Given how KVM is just a device driver inside Linux, VMs should be a slightly
> more roundabout way to do stuff that is accessible to bare metal; not a way
> to gain extra privilege.

Okay, fine, lets turn the question on its head then.

VFIO should provide a IOCTL VFIO_EXECUTE_WBINVD so that userspace VFIO
application can make use of no-snoop optimizations. The ability of KVM
to execute wbinvd should be tied to the ability of that IOCTL to run
in a normal process context.

So, under what conditions do we want to allow VFIO to giave a process
elevated access to the CPU:

> >   1) User has access to a device that can issue no-snoop TLPS
> >   2) User has access to an IOMMU that can not block no-snoop (today)
> >   3) Require CAP_SYS_RAW_IO
> >   4) Anyone

Jason
