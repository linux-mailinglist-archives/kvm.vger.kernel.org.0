Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CAD68D943
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjBGN1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBGN1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:27:09 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520FC21A3F
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 05:27:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=boIfHgUiJN7TTnja8N/TVxqneTmq39fe5oRGra/c0q0mlaBQLrHQfQx0CZOdBYu5RVbdRroLVx9AagrQb7RtJMyeGzTjXikZlNXxnCEGfAC+Eukhjga+Ul7zvJzmlc/wP2+xwx7P6/TAktG8E7CdTpq6WK/od14bN8a6s1rkHNHltp7J1a3WMrtzI4hlX5WZMzINROO58bxpLmCFYQcQUCEKYXDV7iDiroCWXa7k6Jo3mMwY37hSNkXpnmFY2drtP0eUxK6OfhDUHhRI24ULbkfEtOxf2/MNygNLd5fGheLmjZudNqE90dXZjeC/tp0NyGxjpx+91VfV3o0jdj2Mcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NlMwI8Cv1ilB5MoTIUynKQ+0J5ZHv2F/fY7siqncKg=;
 b=PJKdr8gatVaHJ74bWvA8OPoWJN12jyGKYCltnatBNnJkEyGJpwlwtTOP1jLy7/aEqnsgCCEROD+d+54dSaoREMTrx7Cl9iJOgcgYbHBvkADsxVHYnCG+JL/JF1H98Ce4PSprnHczrXupLyK9cZ/gC0dsUCBESbuz0oqpleH6wiEkt0eYLohtm2Hclh6322PTWPt7CbbST3mKsJd+hwJDH/H/3b2Yef9CxBWcmFv3+cdHu6G8vrYWTY2Rm4w7CDRSuk8MSRW7kKTCrt28FpbkNjceDGzA59QBp8DShRMCRmiF5DAc5t0JVfdBzt56J3M3bzsod3SUXTglMdc/uZj0rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NlMwI8Cv1ilB5MoTIUynKQ+0J5ZHv2F/fY7siqncKg=;
 b=Phr6hRZkxUVB89psdRtx3XHGyJOmK11qTLCQnQyk+aYsjDcfzZsAzeyjS4xdv4p2Aw6t0+zrECU5ji4QKCpT6fFTaqjfkOHohAp7W3f6oePOUZIWv6RWjTls3MDtcQDeMQRB01r5reImIDYyMHAFFGOC0cl4KeKIMqz9Z85VHCikkxXisu4N8zSdPI4pfPg/ec3Gpy9e8EW3iaxd7gHK8cUSS90zs/Je9KETAqrNqJItOLQd2MCP2nxiZMDJAlDJj2Y1KeBnUBgrvx/BbM4bPoI4I1qUa4K+x4Ko+ZdNjnTk6ITchJUqBmQ0xOmJDP/WmlAIwkv1R5nLmyB52f5jEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5902.namprd12.prod.outlook.com (2603:10b6:510:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 13:27:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Tue, 7 Feb 2023
 13:27:03 +0000
Date:   Tue, 7 Feb 2023 09:27:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Message-ID: <Y+JRpqIIX8zi2NcH@nvidia.com>
References: <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
 <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+JOPhSXuzukMlXR@nvidia.com>
 <DS0PR11MB752996D3E24EBE565B97AEE4C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+JQECl0mX4pjWgt@nvidia.com>
 <DS0PR11MB7529FA831FCFEDC92B0ECBF2C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529FA831FCFEDC92B0ECBF2C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0029.namprd20.prod.outlook.com
 (2603:10b6:208:e8::42) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: 337e2216-bdb8-44b6-ff7d-08db090effdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UE8wWxUZiAgNik3mz7MwYighCNycQ9OLnlv8gEEhZytFqsIjaWXoqJ4RU/PBkcCS5qK8lV2iDppRkD0iHpHdRiWwVNh/jmXa79Khfzn3Y5qpCUHnLyGoTOuSk12gvhV+hARls1NGd9j/ebWM7rQi7GoCk4ws6wwRZ4MrpssYeYm7f47kMeGPUdrauWqEeu91PAmSWef8FHn3QbngrqZ5PfacSJan8Pa7XvVC6V5QTaaIY8pfdwz/rK53dno0yieAhjmvybHna0++PhAfzACHtuIT2gCbmrKPq91gAwZqWmfNw8J2j/+6UXHU7pZ0j7GZ7MVZshzubURI3wS4dgO3V1X0GA9riXe+Fl6nSV6y+/ZmKu2lkkkSMPRfHggnQGS5+jzjRt8+cLNVnYzUhhD7vQBVRC89xFyCHd/LoQWVElkRzPeCKbmHUQVa0WnpzMOfCJuwXoPrpkLwfdrgAuHMhE2Ywigy3MLxJdE71piQcYWb74i8pet2hh45sAU7H6gOOfR0LOomZiZ6ZexXZ3/3ff5WakXmNfNDMCBN3BeJ9TcVc+lXOvTn6cK/HSudSY5H0RFZPeE2E572khzfy+yH8y/90dk+BIpNMd4k+FFKK9x9jftCCG4YQKNUJcGZ2IULakGdfZMF+pRjbvkOZec5Vhz8PNdldSaG7q5kZzkbu1D04lubNv4QZwD56F+VRiOo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199018)(6486002)(54906003)(478600001)(316002)(2906002)(36756003)(86362001)(38100700002)(2616005)(4326008)(8676002)(66476007)(6916009)(5660300002)(8936002)(6506007)(41300700001)(7416002)(6512007)(186003)(26005)(66946007)(66556008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MBt7ma4WSSP6rm3wcdilbSAZimWtaMOUExPkvq0k+HZFR+ZgvpLU6IGJmfUy?=
 =?us-ascii?Q?VEjPNb0+aw+BjO6a4C8AphY/d39YkuAZ18MCaJvtuD6hNwdCtzJ+1zI+2UuM?=
 =?us-ascii?Q?EaY+KgJaykp2IREkRwXjJ4G9DLCvWcB/qykLPq/GupcbH0jgEJj42RzWqgC6?=
 =?us-ascii?Q?9aOmwFIHunREE5rCdIKtOTmAAzOivhCwKa8f4Pcg1NTVrkLZSsroH1pokaU4?=
 =?us-ascii?Q?WEcidISvB+us8FHcIrklMEz06LAVXe+CCls2l9Vd3ZZRJLa+stTUpb2MJMtr?=
 =?us-ascii?Q?kz/OMi9iZHCc+Hdw4poLGN+h0tSxJLIu2/GNP9V6lso3oITeU0CNNq2gRXF4?=
 =?us-ascii?Q?0F3PTaD26WXJchZ//lZgRCICvypouMk2+qn49asVLyfsuMAFmgj5t/EAOi5i?=
 =?us-ascii?Q?iTpj/OVv5szd57gjgBpbEKnMp/acI9OhkF7QJ10UkBHmyj7pqWQShVtbTD3F?=
 =?us-ascii?Q?L6XsmmBIzx84yqihD/weip0hSbIpJn1iieZJscIyp4x0zHIr6XpFGInwoEto?=
 =?us-ascii?Q?kJcdkQI1QuSfzIi5vWnUklj4O9qAIVRgdkGC9QH1cO9SIAFfHvV369tJvvum?=
 =?us-ascii?Q?vZyx0LYIOgyVrWnYWc2fV7eoErl+0U7QtOchL5UIIPfJXUvVZ1vvTIN6mQq9?=
 =?us-ascii?Q?neCESx2iLnaKIuu4exA5hAGpczLb0c/EMdr0+5Wk5LMK2VBMlQdO52/N5Kip?=
 =?us-ascii?Q?eq4Jo0zUB9YDzKL3KGt55irTx+Y5xCObq2myq/7v/8dh51Iob4po/6YkCd+v?=
 =?us-ascii?Q?5PVVwg8JBv+cIq4UPeNYVPw6nrZd7oqfViciR72dKbfPzy4sEbyxZV9+d5Qq?=
 =?us-ascii?Q?vxZVpkLQByqJ9Hl8V5WvGzcPMkV0mxo0CQgPLEHDCLdZaRLifj3IlJg6PhsJ?=
 =?us-ascii?Q?g+2ucPmrMw5L2Pr94yGIGBJ0X1LGxkovb9JHeubfJGaEluHJeUI4LoOcYDr3?=
 =?us-ascii?Q?DofyHtSz8FbW74TF50u8U/RkVy+2dql/iZZrBptfuJUF0dWrQeSCJIr4jZD3?=
 =?us-ascii?Q?SViSAfIO0VTjD2By0dKtDzOOFR/a4OoPTh5FGjZVJe7zplML5N59W1xk84Qs?=
 =?us-ascii?Q?yh5DwwXVTNzdRp4cnF18Zy8XPsSF9EDMRTvJ1pcOAoTMkZ2RJI/JTSyTF9Cy?=
 =?us-ascii?Q?NjiugKg2qTVwaq5O1wtte+7uKAgniJNev9+Lqgplf11IuEFKFM2Jy/f5Ekzi?=
 =?us-ascii?Q?TFx4jwRv2zmjY4lNy7gOcNY4uAtvozJB1ulOSbVHS3S9rr4cUmawz6fqLMtj?=
 =?us-ascii?Q?SgQOcc2NwHchVsuK60cMWu2gA/6wgD73O0JcpjQKAiFSAupCc43/M4zD3Lqa?=
 =?us-ascii?Q?ThD1Le9VIUAo2wfy3lXHgOob9JAq20t6bTQnZbYDTA/XUaibjvsZ1bsTF+/v?=
 =?us-ascii?Q?apqPgiZJIhzXpPauaa96GvZg6mGtZZhGzJv1eIYgbpFIxSYTu6vYCa9xnElq?=
 =?us-ascii?Q?2gzU8C44XhjBnFqwafBubn7JQt1HdF2Hw20HfM3WvpISC3tcN70Si766r3fd?=
 =?us-ascii?Q?bkazU0zEBi/NLXtjnaoY7dn/UgnoBcjZpmjIkNK0gnNpoHZh11IB7hqJnlOP?=
 =?us-ascii?Q?hu/clEf3SDCPLWQDwWsr3qXK3PGzxwrCGC/WXdjv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 337e2216-bdb8-44b6-ff7d-08db090effdc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:27:03.1640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwwYEpwcH/IzUY7vW24n/KAQdrcbZHLoWHXPB4qtEakzNIZ/x1kCQUe2hmGNXD0a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5902
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 01:23:35PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 7, 2023 9:20 PM
> > 
> > On Tue, Feb 07, 2023 at 01:19:10PM +0000, Liu, Yi L wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, February 7, 2023 9:13 PM
> > > >
> > > > On Tue, Feb 07, 2023 at 12:35:48AM +0000, Tian, Kevin wrote:
> > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > Sent: Monday, February 6, 2023 11:51 PM
> > > > > >
> > > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > > Sent: Monday, February 6, 2023 11:11 PM
> > > > > > >
> > > > > > > On Mon, Feb 06, 2023 at 10:09:52AM +0000, Tian, Kevin wrote:
> > > > > > > > It's probably simpler if we always mark DMA owner with
> > vfio_group
> > > > > > > > for the group path, no matter vfio type1 or iommufd compat is
> > used.
> > > > > > > > This should avoid all the tricky corner cases between the two
> > paths.
> > > > > > >
> > > > > > > Yes
> > > > > >
> > > > > > Then, we have two choices:
> > > > > >
> > > > > > 1) extend iommufd_device_bind() to allow a caller-specified DMA
> > > > marker
> > > > > > 2) claim DMA owner before calling iommufd_device_bind(), still
> > need to
> > > > > >      extend iommufd_device_bind() to accept a flag to bypass DMA
> > > > owner
> > > > > > claim
> > > > > >
> > > > > > which one would be better? or do we have a third choice?
> > > > > >
> > > > >
> > > > > first one
> > > >
> > > > Why can't this all be handled in vfio??
> > >
> > > Are you preferring the second one? Surely VFIO can claim DMA owner
> > > by itself. But it is the vfio iommufd compat mode, so it still needs to call
> > > iommufd_device_bind(). And it should bypass DMA owner claim since
> > > it's already done.
> > 
> > No, I mean why can't vfio just call iommufd exactly once regardless of
> > what mode it is running in?
> 
> This seems to be moving the DMA owner claim out of iommufd_device_bind().
> Is it? Then either group and cdev can claim DMA owner with their own DMA
> marker.

No, it has nothing to do with DMA ownership

Just keep a flag in vfio saying it is in group mode or device mode and
act accordingly.

The iommufd DMA owner check is *only* to be used for protecting
against two unrelated drivers trying to claim the same device.

Jason
