Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9A468A117
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 19:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbjBCSBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 13:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjBCSBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 13:01:31 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1E43C39
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 10:01:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2wjIQV3Zvx9mFTKuO1ibeHM7Kg5BgoaER6d44urggP2veJJ1epihrF/WA59UToD1lFz7ZX20CZko9Jk3DmVPxfHnNCsiMUw+DQwyXKccNyLEJxkeWSTWgwBwwqhya8LRah2u2b/p4bcKk+IHbbvTL0rdUvR8LA25kYBVwQv0MdLH9F0Sb0IBqX6+vJ2FwF2SDlBCN/rWdbpqSNq1NejEOnkITO2uy6NuCIF92za9hbavJym0MK5QN1a80IDZlkI/a+y7W717EJZeXJ96coOimQWn9Q1idO3AGImV76lIl/mP2CCcrJDCtAbJhzTIHgHFjip63+DPhx3t952OBc0zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2Silb1or+p3mPfSkPCWffpKG/nfMlv8jYlAHOVIsHA=;
 b=n1txYLgKpAX7cUnbztTj7LniykcbRs4ri1q7f2/fYg7QJmb+o3+drABbONUxqedaRE0dkym/vzrSf02hl8ARpWjdc8HQK24J1E3yw60bDn3c9tPXcJ8zWUQ/HSO200uk6nx/tRWYR6nScgLyvbfM5l+jieIjtsFqbsI+zDFqgXgM6ov5MKYLizLLLgAvVTLlEUtuWXnqv4iDH9Fq5RnabThGaKq3o5ouU2wsrV1NetDmEQwEVjtCsdoNlwGZ+rtD432QKKZK37T7ekmyD6YTk++fsTTEChWeEpqQkClGdUHOSJ9hwVKd22546pmwMC/SdeCl8/bDJyj+YGiOYjvZ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2Silb1or+p3mPfSkPCWffpKG/nfMlv8jYlAHOVIsHA=;
 b=a4a4frdWVOdSFP49MCSb/bLV4K6N2U7+WIuAnazd4eUnb8aUYHcbF86qz7ktFgsizh0zLeUv1QmSCklzcP4j+fHdaTx+fjFSGqg0CRZ5/HcXBm9WiZgx+O5kCI2O3LrOZ2Lkr/hKLLlDOW7Zs14FyIon5/v8zXXCJ0jHcSqin6UMyz5AdpLsKRPTG07U8X8SYdmb9VBNwaC5/qf3aAhmwPZIfigAU2bIPNdsdr/nZwVPL8xXEplzQes2yydspxMpAcoS7IYqbliyZEzLyaqnTcsq9TocRKPJmrISWjiDqhQDgw+tYE79i+YcxgRLV2F0U/YDN+sccMH/W68k/PQ9YA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7540.namprd12.prod.outlook.com (2603:10b6:930:97::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Fri, 3 Feb
 2023 18:01:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 18:01:28 +0000
Date:   Fri, 3 Feb 2023 14:01:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        alex.williamson@redhat.com, clg@redhat.com, qemu-devel@nongnu.org,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, nicolinc@nvidia.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: Re: [RFC v3 18/18] vfio/as: Allow the selection of a given iommu
 backend
Message-ID: <Y91L9+suOHM804wk@nvidia.com>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
 <20230131205305.2726330-19-eric.auger@redhat.com>
 <Y90DOL2pnYxHHNzL@nvidia.com>
 <3ddad294-69f7-3067-1420-e1438cf017cb@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ddad294-69f7-3067-1420-e1438cf017cb@redhat.com>
X-ClientProxiedBy: MN2PR18CA0014.namprd18.prod.outlook.com
 (2603:10b6:208:23c::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7540:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f7fd774-d846-4e44-88ce-08db0610ac4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5lH4JX5YWnl7g2xNJR3x58dSbFElgn+cmT9uwv3Lhs9DdBKKplEdP7ZRcK2+sOKqjSulrGUBl4/xwCpag59s6PbIiQ8sb1MczUfIvAWzqzOUG2stLpl/qlFt1i1mFgnFUydIhEsfOKY66NH6+qIr/v01RP5QzdCKoPsdCOvUwECyIQgNW7qvI3vXdUZNeD759+cKAA3tdu/0PFWxlejOmwk/CHSv+quLUW3nA+IbaSw9GyEJpsOmCsdAIDENt+73+csTypY3vE5VXQMc45kve5iN5Rv14A3Nq9RlwySK0yohL9ZQldUJff8LXbvxEynGrMX1ZNSVRUOwvFvVgW+sDp+53aTMD0lPVrt6yej9MCxP1z79wj5m6+Ukdpnrqe3EBaXvDvP4hEl3oa7VMJ9jdGWGd5oDl/uWSSX/4Tgxjx5uLpyS3+wzePgmkJcnjUXu5WJbTGStDZa8kYwv25KRMHfD/aED30rs/sVR8VbEayrXWXWhD8AdCPkDUv9wvpTSeDNZ4mGcbS+x823bZ210eD43wFObxgZwXiAk4T7eRCHIDeA6F49ILnzLC6/WP1IIqw2h9L+LlfFDIpy2zDXgQG8BJJ8jDDI2m03DnPqFpcuja24OWonn2xVsMsVUupkOowGAkZhL3d1hOyKFUbJCwm3tQipc371FIA/idau/mI4j0UQ8W/SWA8bvUG7yyQ6k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199018)(7416002)(5660300002)(8936002)(6916009)(2906002)(4326008)(41300700001)(316002)(6486002)(478600001)(66476007)(6506007)(186003)(53546011)(26005)(6512007)(66556008)(2616005)(8676002)(66946007)(83380400001)(38100700002)(36756003)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f/gwsTgXpqD+deMB858qnnTp+GGzd8FBYUGjJPG4ds2WkLOT9qyxpHzVShHj?=
 =?us-ascii?Q?HYeNmNoXooHQGwg/MzPscjFCOOG1VU1Ds951YSUSc5aBAwrFVekT9gaafuY4?=
 =?us-ascii?Q?+0UlsFiKtNT2tkIC91WTOrr9HDKDKq22OeQLp289CUj0aUvmOTH1X0CTNsGR?=
 =?us-ascii?Q?dWbX6wt0SGRtrbPOrW9KTqG6Ipt6gyeQfogK2FEf5HTlZvsn1982fR8RPPt9?=
 =?us-ascii?Q?glfZUyOkafENaywDZyX6F9EzKofgMzTj7RxjQ+3rP12DFe0m3saWqWOCjocX?=
 =?us-ascii?Q?QPzmCjXFeRCT6ZTFBrBiwo1rNN45YG36XwWiwXekYhwz4SjM3iMvpxFiF9un?=
 =?us-ascii?Q?Z0x28q4DqIJjJNTwLy6b/dVqUnx8p5ffIQ2mXSuZI1eLZOaiRWKlckiSW5m9?=
 =?us-ascii?Q?1H9AGM0DIfIgf3A3usOYY8Io3elHza9mfIMI9yFdU1Ru6LQShiLsxXN/kItV?=
 =?us-ascii?Q?5FTHFtbc5zuEpQ2KV4vnVKoYQ5TEz7SYVQ3jIg0BbT4U/T2P1zaB3gOeSJRi?=
 =?us-ascii?Q?v1FcvfZI+BKHZIkvvHOvmQtaLc4qfoa3dyDWEc6OU/9qKf+Uo7wH+sPWAvGf?=
 =?us-ascii?Q?EqqeuSGo+gGQ8M1MFVcC8bBd8d3AUlv7O5CR1uTyVJhz/L0RmrZ1N20pijoV?=
 =?us-ascii?Q?t/KwAgBK+8RuCs8XQMiYU6kTv+VBHcaABoE9qfgdnJRXAAWrIGcJbzTGG9bX?=
 =?us-ascii?Q?XYSouln7ySXNV+SUGDKNh+LjeyZHdPe75oERLpXWdt7R4s8lmkLO5A1VauBj?=
 =?us-ascii?Q?nhbhWDEq1oWDnFuesSkrpcEx6sV3yXzo8CEVsmM6sWeDsnZy1yQJiH6qlMJ5?=
 =?us-ascii?Q?i8V/oQL7x7LjiqC594SHkjOK0TVvqRt98cV959Mm5B69BQ2PBGW7a0TLXa06?=
 =?us-ascii?Q?wF/i8UxWHAi1FoZXyk1QGW/HsDAROCxspNnJJIJ/LSEMkeXoyj4pQhO5HFLP?=
 =?us-ascii?Q?C9HjX8v7ldYefEG1PQAdmhmea8UhfUgRE+wPQA+W8UMhN48XWGETzeBdm11i?=
 =?us-ascii?Q?wclAtvHPkGZufL/NTzVYrtIW0wvOWuqH4bGg06WCqHK4SCG0L/kj2sgzbMMS?=
 =?us-ascii?Q?vP5voLtg21EjIpuHD7Y5NUsa4HGzjyRDRjzLBI5OuKjN66L/z4gJo2wqPvCF?=
 =?us-ascii?Q?37js14vZk4KNRD16Hna8SAZOmxGviXH2CEEdOwRBUQ0wLXbRVqj9I2F4ZUP5?=
 =?us-ascii?Q?eGWa073ZaDdsl6NcRIfBShxygT0M3grOJtynQe0AKJJDIAIDYkslu+98gkCj?=
 =?us-ascii?Q?0QQ+UKfZNWef1OaFUb7m4Ufm39sN83iLAfdiVMVVBaJ592kI+gLukuEdIgLM?=
 =?us-ascii?Q?aOK0DI1GJsHvmmknpqJtip5HlzSNQQlFJbPvH0DEfubLHdwJweQhJOzbXRdb?=
 =?us-ascii?Q?+NCYY4G4kgEvI3PtRBlFNqSqi3QUG4MG13hqOElsoB6uACFZ+E8qYpN5aw6g?=
 =?us-ascii?Q?znAsW9ONd11oE9nw6UBY05S7O6zoTUJF7iRMwHqyWiKS6g2De0uwpnOZ7XW5?=
 =?us-ascii?Q?uA0U0o2xC5KPK1J1/zBkXqS6diuct/P1pMXyrTcDbkGXRcMlirWsTf17UIxm?=
 =?us-ascii?Q?hrEEkv5wyZyqM8xJYR32ldq5JXqjQy0iOa8WtdMS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7fd774-d846-4e44-88ce-08db0610ac4d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 18:01:28.5562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xcGRd0BQd2gV2u/08zHGa7ZS1v3DUYGjnypxio6fcLcG99bOv5IQnbqtluKz9na6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7540
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023 at 06:57:02PM +0100, Eric Auger wrote:
> Hi Jason,
> 
> On 2/3/23 13:51, Jason Gunthorpe wrote:
> > On Tue, Jan 31, 2023 at 09:53:05PM +0100, Eric Auger wrote:
> >> Now we support two types of iommu backends, let's add the capability
> >> to select one of them. This depends on whether an iommufd object has
> >> been linked with the vfio-pci device:
> >>
> >> if the user wants to use the legacy backend, it shall not
> >> link the vfio-pci device with any iommufd object:
> >>
> >> -device vfio-pci,host=0000:02:00.0
> >>
> >> This is called the legacy mode/backend.
> >>
> >> If the user wants to use the iommufd backend (/dev/iommu) it
> >> shall pass an iommufd object id in the vfio-pci device options:
> >>
> >>  -object iommufd,id=iommufd0
> >>  -device vfio-pci,host=0000:02:00.0,iommufd=iommufd0
> >>
> >> Note the /dev/iommu device may have been pre-opened by a
> >> management tool such as libvirt. This mode is no more considered
> >> for the legacy backend. So let's remove the "TODO" comment.
> > The vfio cdev should also be pre-openable like iommufd?
> 
> where does the requirement come from?

I would expect it helps sandbox security.

We couldn't do this with the original VFIO model, but now we can have
libvirt open the vfio with privilege and FD pass it to qemu.

This way qemu never needs to have privilege to open a VFIO or iommu
cdev node.

Jason
