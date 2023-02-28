Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF7D6A5A1C
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 14:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjB1Nnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 08:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjB1Nns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 08:43:48 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B18D2E800;
        Tue, 28 Feb 2023 05:43:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jif5BYBhUg6WJ3a5+G4Wz0cfOZIHGXB/8BgDML5+dqyDhxqi98uPC0kqZJ0Qu0rOUvtwbWG8Kn16qndw0wH1Aer9WIdUEe4bZh16tmS9HRcuO6scyK+D3qNfN8CWbdGWSlVuGSRjPviR9Lrx1uIwGcjVk2aI+eFD87T/wDAj5FG19zWwsIuCFAYDZAgz1MWTnwO6prlgr5JgguiYWgMLCzEdEhuypynkOJ3AV9AlAsyXiBPJceY7mIS8l9Vn5dU6/zpR5DjYfdZHnHOEecHJLm7AXX686DcK23I8nzx1amavsrg6EisvqrQ1G4ROOK8JGd034qc/QglFS5eDUwFC0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBteE7xUh7YVxtimwjSvvD+Ei+DK5QWKYTuNGaD6Sx4=;
 b=Ge8hzvqjKVHHr5DkJq+nF2eRjHbk79cjQv2G/GnJyDTZBkLfBi6LRB5CUAcP7PwwbN8WBFvfHQOYVWRJxledMWypNp2L1wGFDp4bXKeeIl+Y3cwwbC5mDdQjBREm2g4dVop/tEiCWf73/dckJncH3SP2pHWxOsXNMfTvYOWV6oBk+CoBtXDzG0TbaWHoYZ6cEXXq+GXOsg1GO9zSkFXuUYo65DbcV9GTUTx8eg6sx3NlKtxy5R9IqoPv9PWIUCPoJIOzg+I4VF0KppEQ8sFC7iQoBvUukHc3bgC6GNVnNPnSblM81r8ibPOHpx2LXvR3n/BL1ri8MFGJ4J3+fzkr4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBteE7xUh7YVxtimwjSvvD+Ei+DK5QWKYTuNGaD6Sx4=;
 b=CRX//HeGBs5QIHmI0T10Bf3PsU2xhtCi7qYhyN8ybGmdaiH9MsRcjvu0uZSBIQBefGIjYK4zljngk+8cTtpYjcX56GvKUiMIENJofRtqc8HWTz9NQaNr5uYDnil3Mj9E+NsAQQyDNJluLCc+UGmtov0lGj2wLDN4yNw526ennGu7icXteZ3PEQInNLCDVPgBQHejuc6M6ZjsnOBPpBsXprTczTJtkMdCskOAi59eMKY+Lm6XdU+DQ4aatw68r90M9t/2vCMjMUVOgBSfrHwr4oXWS4/X8AYlDxTfW/JgItU6rgtqWEkHbgwJChaW2RDW4s11eZcrv7raJM0PQvKtGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4548.namprd12.prod.outlook.com (2603:10b6:5:2a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 13:43:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 13:43:41 +0000
Date:   Tue, 28 Feb 2023 09:43:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Message-ID: <Y/4FDP8H1qRdgVrL@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-18-yi.l.liu@intel.com>
 <Y/z400uzn7Nk0CXe@nvidia.com>
 <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ZTi69p9cCuPn@nvidia.com>
 <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4AzJbjeR4R2rcO@nvidia.com>
 <DS0PR11MB7529175CF279A820C5E5E091C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529175CF279A820C5E5E091C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0314.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4548:EE_
X-MS-Office365-Filtering-Correlation-Id: edce40c1-1974-40ed-f86b-08db1991cd4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVTxT4/8aMGcU2N+Ny93HJn0kkNt6tmU8V+Um5+M7FCnlUl4dlr1FaMICPCc/Ni+tHdlyHMgw/DCzH0nFi9MQxzdUC6sUFY+Xjbk/cSHC9RgHAEMHJM3wVj/SDlIpSZt/s++M1NE4AO3agwbClKPg/gB0ECu0utw25CUDxUEOs9SMle/OeR6yHt9Wpu219x6aQXnG61VC3bKsX4q4z6qMdPwIYP7+lSEroIU1QYvBEuHAmV4oxQvhvsd5GK3wgn2n27/YN6UzI2JdmrD9WJFgF5rFvUFK6fxPk+t/NExtDu/15IT7XxL1wlzw+HFeVK1EtBAxUgkzY7s6HsnWwknH7+rqg9U6DEV446ESYNKz7motWgliODf3p/QixsnZ62l+rvZzhJDn22FTiw1JnbRc/aX0ztw9iaiOPaNBZycgU5rQrsmwkZdXYNU6LNRojVEWF4UjV/ipnN9FNDe+N8Zo0OcAcijd93wJZ0bnrH5NsNjc0S+cNOT/tke48NrxR/ATldwuifWB0EYSlZl5mCZ/cowi4fNTPom0MJfnuJDLKQeD1GctPJoG5zDdr9sjcU6nNayn2A9hIIn4MHDkIlWa++k/VrzD57iYMrEv0toosbKTtGZoC3PpHQBNE13VTW0Joyx2lrU93/k4K9C7i3IJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199018)(86362001)(36756003)(41300700001)(66946007)(66556008)(66476007)(7416002)(5660300002)(8936002)(6916009)(4326008)(2906002)(38100700002)(8676002)(6486002)(478600001)(54906003)(316002)(83380400001)(2616005)(186003)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4+EK2SwLv8ex6LTR7z+64h+7dP4uQrzCMaci509cRWbPTFiDhMiGcVjda4f4?=
 =?us-ascii?Q?8PsfqvSwNTa420G/SzpMkpwfFskKmZaLjjgFYntf7gpR8nx4UBaH8YLzl33I?=
 =?us-ascii?Q?SemLYhME7cAB8WwwpggzG81PKSBT/qvVqihVsHBEzP4WexsctuCD7q2ecOfj?=
 =?us-ascii?Q?bsqAXuAP7Q7ej5dv8e9/HY9fP6VQik7YaOE2pjJDTh4o9PgH/c3wR7R+NO74?=
 =?us-ascii?Q?50dqvHtjGUvJf6yvIeGGYQoY6Ns7GrqbCtAsEfGmuttje532Ip6BwI0bxaA6?=
 =?us-ascii?Q?A29iXScpSpTBfm92gUPISTl7iNghtY8T3mLMo+IdLBs7cRfMvWh6O3AxYbGq?=
 =?us-ascii?Q?bcZW4g+nwiC4vLaAn+JHVuiXtbAOndNEQG5Jkj9N71Gx+2k4ikH/duaeXpEa?=
 =?us-ascii?Q?BzLeLHFJ04IrZvBXQPdrP6ZPcUIL59Lon5DxdwdyXDiF8ehx7klJEOwvTOzh?=
 =?us-ascii?Q?ki7GAbIeN1MPDkVaeHhbqpqCB6IrToumNZvWC+X2JZZoqcxFZg0ruQqqaVpT?=
 =?us-ascii?Q?Bfkbc29cvfbHNO/lFMN3AdMhEKugst+vPwC/jbDPxQhzkopxg3r+PggDisdx?=
 =?us-ascii?Q?bF5FGqL6/iUfNdcGBP4XTjYYYp1Jj4UHJAlKSpOS9/U1vf+NhWJOMkRhhYbr?=
 =?us-ascii?Q?Z3cJREuwf92Li+pZ778ZGIXotBFcf8gFKRZAo5EMdI22O5I3/CPPGob6z01h?=
 =?us-ascii?Q?irLTWusR/Y7/rd3b3LkXeGVoQr713qeIelfI7FsmUL/H9neuOLV9mP8EIJ2F?=
 =?us-ascii?Q?NzBAmUDnc9dAOnvFfnqINi25XQwKAVIwrLhmu9Ch90puhpeY1+W7MezCovmv?=
 =?us-ascii?Q?EDbeCWjWQqqNopxgQxeldGta7K4BIVzB1AXKLOExJh7NPLdzWT6gDdDqtWhW?=
 =?us-ascii?Q?wR7z8vB4mu0TDtNvAooK1jZDY57iE3DXeCanjyM8Nf2KdDwkUwduxFnQUjeC?=
 =?us-ascii?Q?gunIlop1NqscHvc5Rdc4gjfEfhNC2bCY0pw17I5ugdHBnRUkdu9eGEHSBvmi?=
 =?us-ascii?Q?ePiVr0OGt1bLIzm9Cl/8pfUMgf0ka2YiRxHRrYQ66jQxLZ17leQwIfHuj5VO?=
 =?us-ascii?Q?uaAYEgDHBVZlFpRWfyTHhDPL1aD1/c7wrgo5lMJn+7NhlOXNZu8GmnddWpNi?=
 =?us-ascii?Q?NWKt8oW6KVAj3qrNOdRtLfQKw5zjVN9SJK2GrkTLo4K0vEFy3tTfZxwt4h9V?=
 =?us-ascii?Q?0AaiqKTC0Hj4jdKwcDlrx29ptQFppqn2wgQxItNvHrf+cBx/LBShRGDFGTjy?=
 =?us-ascii?Q?s6N4epZRUb3rjIW9cDzY/8fKUVy35SjqMsiIbkeetATX/LIiLllL7cLazrYu?=
 =?us-ascii?Q?0EieAvzX8Gp7UcuZiqYxvRsPBBDwauCnH+761BoJRNvKyt2O/GPHq94sZasM?=
 =?us-ascii?Q?eEJnYHX++L5bp9s2qG30kbTGhXAwq4HE/j4SnjnNwbt0tJ3PeaOS8s/mtujQ?=
 =?us-ascii?Q?E67NeNsublLQl8ZQOtgulHRSuzten8ENUBKBLfDSVpyu74gspgtuQhxv7kLJ?=
 =?us-ascii?Q?GAKB88oCl094II2Q7lUcHv1tCm4TF4shg7dNOGzlXuSSvzJwuxwOrBc9D9SC?=
 =?us-ascii?Q?PNioWH4h8En9+UC5093R6Blc1XU6Wy3jBkeCYtaA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edce40c1-1974-40ed-f86b-08db1991cd4e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 13:43:41.1228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9N2CFSMWTA4SVE8Pf3WjlzR8pXm0y7yLFxk+YlU6taB/HptnxpAf4oDQJEeLGfO/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4548
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 01:36:24PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 28, 2023 9:26 PM
> > 
> > On Tue, Feb 28, 2023 at 01:22:50PM +0000, Liu, Yi L wrote:
> > 
> > > > A null iommufd pointer and a bound df flag is sufficient to see that
> > > > it is compat mode.
> > >
> > > Hope df->is_cdev_device suits your expectation.:-) The code will look
> > > like below:
> > 
> > Yes, this is better.. However I'd suggest 'uses_container' as it is
> > clearer what the special case is
> 
> Surely doable. Need to add a helper like below:
> 
> bool vfio_device_group_uses_container()
> {
> 	lockdep_assert_held(&device->group->group_lock);
> 	return device->group->container;
> }

It should come from the df.

If you have a df then by definition:
  smp_load_acquire(..) == false     - Not bound
  df->device->iommufd_ctx != NULL   - Using iommufd
  df->group->containter != NULL     - Using legacy container
  all other cases                   - NO_IOMMU                

No locking required since all these cases after the smp_load_acquire
must be fixed for the lifetime of the df.

Jason
