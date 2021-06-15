Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC553A8C28
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 01:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhFOXC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 19:02:26 -0400
Received: from mail-dm6nam12on2073.outbound.protection.outlook.com ([40.107.243.73]:43073
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230186AbhFOXCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 19:02:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hyu4J3SFVrXe6xlwuraDs9dESj91HPrXn7tt78VuEulyGjDAsCAvI4uSKrczlS5HrybWNEOnwPC58NQ7PxfDdQFzh8z9/BRrnq7O5mY/SNNq4uY9u6x1oBzkw6F7KZiGwYifqd+cKI8JsYmFZmNPx0D2DQZpw+o3Px/XJ5YSPoKMpcHXzpySOAfC7g2jhW985GG462/EBN7lHxCJAZhXySlYaWXwv3KHByXf91N5lFM9eGSS/VlUiIDjL5+RKxoC31/aPzHZrFeHlB5ie6ooHgWvUIpB4LAimTxRK5uTVIaLVW4/aS7l3xHS/tK1UCJow1+U6i1VjSx2m2pLvjdz7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1+7GZx9jsvllj7uZxCuI3ZppqER0B1GuBjH/FdeLBc=;
 b=OgX6kxQZqRt8uRq63s6eyrldXhrfhXKOBzyDt7oHIZhCArY/nzBm+UuIsxednEO+2Ojpt24Fy/ILwDSlKBe/c1mU3U7C6do2dkpq3yfm+2BUwnCLQX5v3oEPs/KQ7cS1D7cXwsc/KQN9zx5GKLaNPHaZFfEAKnXijkfLl+Ng8tiyWOyog3FToH7jMgTCjITzL6fxAOGEMYKFWtw00P4XtqemQLHn7iKOnPkj/5ifcSg2SuyLbdQWssqGCUzZT8b/YtN4YF0rhMmvColF2xAR40X2IEC8YHeNkGmsBuY6nfEA6cdFlpu28pUaw/L4G/LQ0l0gj5BboaPnVeRiUxNDbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1+7GZx9jsvllj7uZxCuI3ZppqER0B1GuBjH/FdeLBc=;
 b=LBIM+b5DJC8IERtsj5pzDKvdgDmT1WwrvV+jhMHoIYDAka8CI/IAtdJzKtuqabn1Jz186GXRCBMGIJ/nDQxwGQ7B3pF6MzxG6P0vQ6nmEjwweuduZ5p1OfruxBSP5OdHHexEt9v26LJ0dhcLmKw1pjg5y4APzvFLTTtCVO381+KimPMYekm4hMQxuTpVTaeho2jZTqQyhIYE7ITbOXGXZgSRRfIOy+SdsXRWO5PAUFauP9tVMCTMo+cWlJBfAi767k4VFArHfvxMCa21OJNC0z+KC5of8pb1Ga8R0XykiaxsaLmvnBg58lFiLiRRijrRvyQ4EEyJ3bWL+oLAGEOS6Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Tue, 15 Jun
 2021 23:00:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.016; Tue, 15 Jun 2021
 23:00:19 +0000
Date:   Tue, 15 Jun 2021 20:00:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210615230017.GZ1002214@nvidia.com>
References: <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
 <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
 <20210614124250.0d32537c.alex.williamson@redhat.com>
 <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
 <20210615090029.41849d7a.alex.williamson@redhat.com>
 <20210615150458.GR1002214@nvidia.com>
 <20210615102049.71a3c125.alex.williamson@redhat.com>
 <20210615204216.GY1002214@nvidia.com>
 <20210615155900.51f09c15.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615155900.51f09c15.alex.williamson@redhat.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:610:54::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR11CA0020.namprd11.prod.outlook.com (2603:10b6:610:54::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 23:00:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltI2b-007G6J-Ra; Tue, 15 Jun 2021 20:00:17 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 432a3b44-71c6-4d05-eadf-08d9305158e8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5080EF208F3025BC2E7E5772C2309@BL1PR12MB5080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:285;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eewi7wC4Ghqiqs+15Pn5c42JnEjhBH3iN4XbunbeDRUzBYhoHts2tYeVDPh703WKOSQVKf0l5ev1cOBizaFSP1L/0I5ryvQTkq94Z7HXC+eg2ILDdi55Ugxaxx0FG6Mi9jBXFuz/iEiotpM81siCOlb53JVa3XClBh0krr5pqHazBULRAX0lr6PsvwtXpStsJngQ8CtbZIjK+VNCOh4BV6MrNm7Q6McBzdnrlJuwVVZkIcrRaaNk5FSZa9SUG4hzmR3lZ8hBbcaGaNoXHYw1CgukkeN6VYnWOvIFCfWHpkGlNIbHWV7oB03AXgT3X7PU+R3qy74zaOPv3RAyx+/KA/jjPu3eRTfBfx8ljyVoGG1CXaF7E8w+n+bNz72DM78QezCoUtdZ/bRw6QSiLV1ARxeJcPO0pdv4fRfYU+bBYxrEbhkgLhW4tWywRMWocSE9IxQkVGGLgOXrPAMGJJkQcgOrNkE1CLIqPjQgWQRtE4mUKpnj8+eULok/21Pjn57BL7V8TvEOje2GQ2qraQK/KmH8GEeZre86jfk/+nNCz8eM4c0QA+p/bE7HOas3qe6Yhk/NgGoKMFRyBD3gn2n+3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(66476007)(26005)(2906002)(66556008)(426003)(86362001)(33656002)(36756003)(66946007)(4326008)(2616005)(9746002)(8936002)(8676002)(6916009)(186003)(316002)(478600001)(9786002)(83380400001)(1076003)(38100700002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mHT1a0yVdiPLDZ7BeW3zr0jM74Ug28aFVT5QzHA7iG0Tyr+fJl79hJenR+8v?=
 =?us-ascii?Q?qSOhEUJAnSEXEvvK+Oxxk++WRoFaq+W3nmmwdYclsVKnsiDojtxW89wYmTj8?=
 =?us-ascii?Q?ZuM9bZAFBA0nWhnfOs4AGC852oJJ9y9h1c5Q/xu6y7rmhnIoOL1SDYKupu14?=
 =?us-ascii?Q?rj8WEvGs9aDZF7mQLLsuOrm6S1PHoO9+Bwwdar9KYxbEX85sATrTSW8lC3Er?=
 =?us-ascii?Q?/Eco2h2sYYejVrxRCHhylY3Be4EWogB4PFXw2+4HssUwvmI6CAKUtwd4FfRN?=
 =?us-ascii?Q?GSqUbJwAU4eQ+knRgv6LWFaAZKJ46M8P5k5BMhA18rTOXq1cY+LF6pMJRe47?=
 =?us-ascii?Q?4UPRmIq4KuBByyzMPZE2usFnufUgjRN+3fAcJQYmsVtk3mTUGqsIY7NAtzBl?=
 =?us-ascii?Q?wwd9J5cNChzqFBBE92LfStH97/vdd4M2/RUN+f4LoysVDYgNoEimystmsfmX?=
 =?us-ascii?Q?QVMiu03o1vnFHZ1NBd8ebnHCbk0rkmxWrG2bz5WmKRDK/ba2kACdhbFC6Fiw?=
 =?us-ascii?Q?44lY2J3M7kKyOTm+zX5Y2lwjlOjcDGeN9zjT78x797yIgjfRjwWHfDmZWycc?=
 =?us-ascii?Q?bw+HTyeIGhv0N4olrNgWImYqdx8S1Zkh8s8juQq37msQHkW8ISlFV9WW1syN?=
 =?us-ascii?Q?eLsgtpWY69vjKJaBf1H8ipSbCAtlol5dFp4sk632pyz1jSMA+XNyTwFYxNBq?=
 =?us-ascii?Q?zBYiNwnaoQE5UWGU1kGIJCi8XRSrg6WkmFg+6RRZSm7pqAEo9mMj315yg4Kg?=
 =?us-ascii?Q?NgCwcYvHpc7LDhw9vhC9BzI+vgUTv0gzo7+e2v/Yy7SmN0UeTfhsWfKvpPDn?=
 =?us-ascii?Q?odyKpcTllfv5qrlCNaxq9QUh3gCNNWK9GVQlHcre3GU6mcgioMYdSs2FTorq?=
 =?us-ascii?Q?TlVilgyX4HbggSoZlp6NcboxRF9cooLCwDB08HDpxrhsGCXERNkJatM1lC2U?=
 =?us-ascii?Q?Mjc0xaR/XidP33AhGUqOC7sa0mnpAOUEb9PL/MjvEPVH1EqkFTjx/kpohyap?=
 =?us-ascii?Q?rklliYNDJhFBSbQeRetqXo4mNML3mMVDZ65AaIlVeoxejZMCeNoMPWgtU8Gp?=
 =?us-ascii?Q?cy7AaUKBNri7v+3gN2HBVDCc7NFApj89ipWkBNxSaZZiBx0k23BAgFSMZkb5?=
 =?us-ascii?Q?8HwJkQ5Bgj9uPwiyft4cZN33rXR2HLQXLXqJWxwn3gHobLlBlY8Pg2WLyF/4?=
 =?us-ascii?Q?e5RDyu3SKpkU/zQyb9KOLDc8YjyCzxUTqIP/xpe0ct2RNryGZaOp+JsZRGDg?=
 =?us-ascii?Q?1hTbtK+6oNyOsxAmi8TyfA6KhH7BYqCkJZBHfe7RBGALwftlD0B/Qfj4r16g?=
 =?us-ascii?Q?YznE8KSzUd0xPE8q5gJFH4tJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 432a3b44-71c6-4d05-eadf-08d9305158e8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 23:00:19.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6f2ICIEzxtMc5J2TlaROpdqW5Cq+ojoQ6m3l9iD3iqoHUesdtQt3DZ/5nL/4Ho7p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 03:59:00PM -0600, Alex Williamson wrote:
> On Tue, 15 Jun 2021 17:42:16 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jun 15, 2021 at 10:20:49AM -0600, Alex Williamson wrote:
> > > On Tue, 15 Jun 2021 12:04:58 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Tue, Jun 15, 2021 at 09:00:29AM -0600, Alex Williamson wrote:
> > > >   
> > > > > "vfio" override in PCI-core plays out for other override types.  Also I
> > > > > don't think dynamic IDs should be handled uniquely, new_id_store()
> > > > > should gain support for flags and userspace should be able to add new
> > > > > dynamic ID with override-only matches to the table.  Thanks,    
> > > > 
> > > > Why? Once all the enforcement is stripped out the only purpose of the
> > > > new flag is to signal a different prepration of modules.alias - which
> > > > won't happen for the new_id path anyhow  
> > > 
> > > Because new_id allows the admin to insert a new pci_device_id which has
> > > been extended to include a flags field and intentionally handling
> > > dynamic IDs differently from static IDs seems like generally a bad
> > > thing.    
> > 
> > I'd agree with you if there was a functional difference at runtime,
> > but since that was all removed, I don't think we should touch new_id.
> > 
> > This ends up effectively being only a kbuild related patch that
> > changes how modules.alias is built.
> 
> But it wasn't all removed.  The proposal had:
> 
>  a) Short circuit the dynamic ID match
>  b) Fail a driver-override-only match without a driver_override
>  c) Fail a non-driver-override-only match with a driver_override
> 
> Max is only proposing removing c).
> 
> b) alone is a functional, runtime difference.

I would state b) differently:

b) Ignore the driver-override-only match entries in the ID table.

As if we look at new_id, I can't think of any reason for userspace to
add an entry to the ID table and then tell the kernel to ignore
it. If you want the kernel to ignore it then just don't add it in the
first place.

Do you have some other scenario in mind?

Jason
