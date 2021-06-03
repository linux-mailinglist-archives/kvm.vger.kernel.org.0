Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADE539A15D
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFCMrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:47:55 -0400
Received: from mail-dm3nam07on2076.outbound.protection.outlook.com ([40.107.95.76]:57921
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229966AbhFCMrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:47:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bgjsa9XYwW5RIpcglfNs4DtQZ7Q6TNrOZ+kcYZghKfRbbCzwL3hvpur8+0kXrVRqMIfe7muhMjozdX2PlKv5a5/5AbVLt9+vSOBzeFezX3uapz+y8WXxZRZfRnGcthk+gVizvAhYNwnIwLiTJpkvL3x73XX84447pv7kTVYll21PoxQJ53xPE96GpjsncTSWF2eRQx5O8EV2iWkHcmVuVerXVEE0+X6kCgrYu4Sl8Fkzhn2cfTOq1JuTZh4Dmi7Cds9jHMa2miyTg/ffTV9H/EGiEPSQHNuXKsSMeNMQI3kWAPUZpnPGUTlm1vEByR/mQeoZwPUY56mcxKxBjDySrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bo0Se6heup2Zs+YGuER4qdhpaOQfMer2VRz0ITH85t4=;
 b=BsMIbI5zvo2EJU2Dr+jGFzAY39JDx6dk2iNPYz77y/7SkdNi5V1w9iv2m3+yvQcVz+n2O4uawyBRFv8bDH8ziQhWy9vkW4ACUv8VzfGWNa738I7YZoNNr/h7A1VBtAUK8mp436gsPSIu71Y1VETPjo6M0tSXMEuLGzStD0vQcG/feJ16BeHLugkRh5UV5TOgusrBrRFGbbuvohcpKZopMAHaWolVZw9janCO40dIaqTzdgYXC496yEkKiRwqb5p8A3lOC+5z3vr5gbQbib34vurRnL+dypUAGB9/vqHs4t/8w5GLcvMoUDbam564CUG6Q59ry2UnrStxBguLZr4I1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bo0Se6heup2Zs+YGuER4qdhpaOQfMer2VRz0ITH85t4=;
 b=SpjOXbBwpfYy0neik1xP5PYKqfN0T9Igw6A2AWRTtqUtiSd0KVNCxiwB/MX7DVp/Z8DvnyuUhJY0ecYM4/GPg9NtYuYgv7NpeDK9cVSKsP46k2GHyGypRUGbZpFGPH+iCxA2roxIo+pNg/i4ocOgckvtGmrwuD3g6BnkzMBEgQUuXOYNEwI9EZ8eCU+GUm93TmDeQ8T2H6bzXPw6+s33zKRdyR9N7DqfEA7lu9SuPhmNiB+/rrOrQSkm3Wrlf3XdAQu8GnlalZUa5T8+ad6k3dV0zEC1xOtICEoHALHo4u6+BJgZr9REooZKqV/jycMCfC6YpTE6sR0AoIFTHaeM0Q==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5377.namprd12.prod.outlook.com (2603:10b6:208:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 3 Jun
 2021 12:46:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 12:46:08 +0000
Date:   Thu, 3 Jun 2021 09:46:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603124607.GV1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko>
 <20210602171930.GB1002214@nvidia.com>
 <YLh2APcZFpDoqOKG@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLh2APcZFpDoqOKG@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0074.namprd02.prod.outlook.com
 (2603:10b6:208:51::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0074.namprd02.prod.outlook.com (2603:10b6:208:51::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Thu, 3 Jun 2021 12:46:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lomjf-00150J-Oz; Thu, 03 Jun 2021 09:46:07 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b46466fa-64ef-47a8-f6a6-08d9268d8f48
X-MS-TrafficTypeDiagnostic: BL1PR12MB5377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5377FD54BFAA0CA4AD5EA074C23C9@BL1PR12MB5377.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Moaivl/cEaOr57ipCoSchMr97Yy/ToNWS6ajRPDpHrdHI8yzjzHVtCgJHzAwc+BSIqTzTmLysBOwaYIKmBESXCmpgN8d5ix35M2MJamBqKIjSsCo9Sxhv+UaCOeYWcStOyjzMzJtJuME7sYtcXGwMhn4wXanPAIOjxfiuMeKzlVpeHFN9zFBk/Ws11QRSDExnRUjpBRAtVdhq/MhMmD0s2SZ2m6nVTG9fx1P8F2Q6Hog0mr9BtNv2VR1J6GVdsCVGiheFiXg/nLZWSvXW5sNRbjPUYlrrN6jRM+P5Sk6XSNVSiLu8S0C9TLH0tgeiobaQsTruCXi9ieL2lRpvBnQgXqQFgfl7r71QSxnRWHcvqX55rMzgRKciJvz3lcmcMC43rHuBbRg4AqPvpwXh0IFwbMzUq25nN2WzIgsE8NmJivPGXSL0niilbDpjAnpt8Yt/qK8mCsRTMXZWGPfszrf9EYfopqZQpU7GcFjT2kTRAmNTvSQ5fzhgMI/c6UredH6l8GmY4IuV9eTC/OcSeN5YEXTtW1a52uvrZx1VBzb0eNH/ozskq7lx0WH2yajwyd9dSHp28gIQI8woDaEUZKzqCVmQzard/PW2gAByCklfBM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(2616005)(83380400001)(38100700002)(426003)(1076003)(86362001)(478600001)(36756003)(66946007)(66556008)(66476007)(2906002)(4744005)(4326008)(54906003)(5660300002)(9786002)(316002)(33656002)(6916009)(9746002)(7416002)(186003)(26005)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DmHeo2v1Ir7wukEVcEi1LiX4mmmraoMlaVYnGeVM5LTa2UeMTgOuanVyy9fC?=
 =?us-ascii?Q?iitfhgddnFfoX7f6QoNdnTE8FY9XqxGyHOBHP8xOHPHCp5eh3JmH8ybf5daE?=
 =?us-ascii?Q?XGuzcE0+Le9WWBysrg7QsNrScMz6SETZHBhjCdeJ5jAeCmmK+lfe4zd6xRdR?=
 =?us-ascii?Q?E/PR3H1ILR9of240kNyRBOh/FyRz7mfGakamirqGRGuBYTsQAMpek+CJIeJs?=
 =?us-ascii?Q?C8H/2NWknVate4MJ0+qjOq0W+h8gMZwiIbC62rXAkZyKUVAc6iUffLemnO8h?=
 =?us-ascii?Q?ans9msEb0AQ0zzInUwKQQ963lcO9944u8+vefyiiUXtc9IMTTJKWI+AnVPBh?=
 =?us-ascii?Q?zFW7tZvEWqSW0wKJC75gxWqbthffYpn5D0KPpRHwVcWYD5XAiE9CRopzu6Xi?=
 =?us-ascii?Q?DQEZoDkK381LYYVlteWixz22p2Zsf/gy4TDWNa2YgmUg+Qy1lw1u0Lj0IhlO?=
 =?us-ascii?Q?WLcIrZsKXh5QqbavGqqLYfaOrxnDd0hQ+2DlojHJmofFlfzbncfruzzTBOLd?=
 =?us-ascii?Q?LQuWl0faDOifGTZUrV0iXULdmvgT0DDBWl31Z3di8nQxIFC16726hvAApBXZ?=
 =?us-ascii?Q?nsfv6r3qmC/dG5K5scXjf9QfpvHDUJO+1SaE814mz+CYK1b9WEcA/N1Ac837?=
 =?us-ascii?Q?krlB7QR4cMASWkNe/3JF6lSofBG294WK89j+j1U8y2kAglQbPqqpj5dlypq0?=
 =?us-ascii?Q?/FUrW0hN7aFrKWJhqsiHl0pMhsM1s88lN7S3NWrZaw7/LdxO1qAmhz/c+QZ/?=
 =?us-ascii?Q?5IQ3sETkyRTEKfpLkG7tUV1xi8z6ecT1uPX8eh5cyXXWwwSu6oRyaj35zR5X?=
 =?us-ascii?Q?0M2mC0eXBrktdBDMvuWtB3ltIu78/AYJNGm7JTP+UI/4zBMsSvRREso+O4gh?=
 =?us-ascii?Q?7T4SM11Gx0cmDI2K9/UmvuSv+nVE/jWY7cT9XSLRKRp3RcXo1dOUnxzHTmh9?=
 =?us-ascii?Q?tTudVa+cP7aEsEd5ra0N3QaPjmsroUCElNeJl9vNuxFn+f/BRiowmBBhd9lF?=
 =?us-ascii?Q?i4rObtcOBJkNeWeUPLw2KsLPQLIt/uLQmUAhc4weUt4OQvQRENkQvYuzr2bM?=
 =?us-ascii?Q?Hy75N/Tje+BI8JVbxw0kG93YKOcJZ0cjScqM3phm8wTBwPs3z3q9UzkkONoc?=
 =?us-ascii?Q?ySkb9SYPv/soqheoh/+s8gFP3iU1PIP52SQmmpv1ryQoRI1XcRGAxo2jwWD1?=
 =?us-ascii?Q?IajHgrvXkgre1ADEY3BLIfWJxC3kCnzZjsnEjQqKWyiRGe8zRhKj/3BklkeD?=
 =?us-ascii?Q?GR+bNw1nVIZvtP3N+GB+CHlTiJb6ZW9ovgXY/74/rXj7poeRK/OO989LVi7W?=
 =?us-ascii?Q?5B/VZ1PkxaXy9F63BaEN95jV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46466fa-64ef-47a8-f6a6-08d9268d8f48
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:46:08.7406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZlvoUtd/Sja67lhHsAgVA7cFmXZthXfCs+PznMLncPYEynzu3SFyfX+d1EJtntr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5377
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 04:26:08PM +1000, David Gibson wrote:

> > There are global properties in the /dev/iommu FD, like what devices
> > are part of it, that are important for group security operations. This
> > becomes confused if it is split to many FDs.
> 
> I'm still not seeing those.  I'm really not seeing any well-defined
> meaning to devices being attached to the fd, but not to a particular
> IOAS.

Kevin can you add a section on how group security would have to work
to the RFC? This is the idea you can't attach a device to an IOASID
unless all devices in the IOMMU group are joined to the /dev/iommu FD.

The basic statement is that userspace must present the entire group
membership to /dev/iommu to prove that it has the security right to
manipulate their DMA translation.

It is the device centric analog to what the group FD is doing for
security.

Jason
