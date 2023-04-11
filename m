Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70EB6DDC03
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 15:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjDKNZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 09:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjDKNZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 09:25:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0B349DC;
        Tue, 11 Apr 2023 06:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LI7w7OuIcikf+oerAfm+zjXl/QzNpox5q4zB6ijUk18wbpHT/9Z7Rr8r91otGDEAQZVsYyAuQ1hTnzysbfEq23MrTMbaAdZfib2xlZnIyNu9af2UZRB+UivNmGrWILvtFHmtmzXxwLCJXx6NSwNHskXKscZ78HouUshrQfLV+0D3aPtdb3N0eNXF2L6OZ1+fPOdPrgPxMF+i39SPRPCDQG371WCzAh7QeOo9I6kfAalnu6OX2IBBKAQcn8uUgmHF6n0VBBNYP626DU0sn4TqBI49hHixn09bpk1pCjB/En5c80nybRnLvRe06vVV0v3uZGrEparQjbGd6KM8FFarWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMfpxsECi0wlX3LW8XtDYZl4FzJpMl142Bme+SSzTuY=;
 b=dlbNpsWDgmYyFkg5tUDbp7xqJXTHfAS9tgRj1L0xBEoIAf7nlhwtmpOyU+GAL7IpkThR0xJXBR5PMbStjl0ZpB24QLUj3Nf0pogFn5PL32C41aSAbNYOPJuYa675PU4ZDHJ+7zVEaAOTJLiidoZon1KVBK120R3O6QC7LX/cIW+yt6RaW+ZdXIkq211E8asLlYMBzepKiJkhGi8PS2EI/cE8Al70h/yZqXkZQu7Tv+KYR/iAQPWTA0eWTOtcz/Row9iL/ya7qQPWnP3iU7y2xFUusXI9k9mgmgdLvu8JNIy0e1Juw+voxx/5/w0DGKzZK6C+mC3O/WyrcvRcstK32Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMfpxsECi0wlX3LW8XtDYZl4FzJpMl142Bme+SSzTuY=;
 b=CZ75cy2QmihRKbnf1wj8fx8gETxdBe2qQmH496jbadhzoE9XxtNf3QLL2UoCJGleFayzqZ4T0vlehd9F6m8sySDq89WMr6Ri4RaebnNijd/jBhg6bcCpOuj9c6qdf1AZ98k+GzvT1D5t/Kw4ElrfmK1IVDhHLNZCXDzw3VtbjMVorSHe6kGI0likIkfw2KMkk6ML/qktcOcJYyzk4AizfrZTHIoL0Q9hvalMP/z1NaBrCEhamcpA5wKHBdI0q/Q1nxaw2kxwgfnSZ/7h8ikMI8KhwAtnJduA21QnyMayT0lyPUut3JPfa0nvUeWuxtfozwanm3oohZeG/sWTuYyZGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8279.namprd12.prod.outlook.com (2603:10b6:208:40c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 13:25:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 13:25:00 +0000
Date:   Tue, 11 Apr 2023 10:24:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZDVfqpOCnImKr//m@nvidia.com>
References: <20230405102545.41a61424.alex.williamson@redhat.com>
 <ZC2jsQuWiMYM6JZb@nvidia.com>
 <20230405105215.428fa9f5.alex.williamson@redhat.com>
 <ZC2un1LaTUR1OrrJ@nvidia.com>
 <20230405125621.4627ca19.alex.williamson@redhat.com>
 <ZC3KJUxJa0O0M+9O@nvidia.com>
 <20230405134945.29e967be.alex.williamson@redhat.com>
 <ZC4CwH2ouTfZ9DNN@nvidia.com>
 <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406115347.7af28448.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0119.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8279:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b766ed-8330-4558-0b10-08db3a90268b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JBjhckPSSMHuIk/cjozHQrZBuFXXBhI8oBxY2T9KX9GgyQ9D3iwtaIZFL+dBL9RgoJWgOAuxIEnm7bGMUgGZ745Mqly8f2grYPdn/dRnxHZDpotdvi440DiZ1foJTuyLylLfCpRDdVdVWa9x0GvweXpxkBHn/sv8aSvnw66zbYvDymfRs3ZVVdBIdmA/YpesqhA9z1XTnZIFUthYvm7VQCwXkO9+z7nz51Lw009MRgDjdacCxPbqK6PqO5DqkaceWaUI1gRL1AvuWOMW+ibFfQVgrDqOcrPHnLF65Cspss8oblsjsKYgZtfpeUacNvYfn51SgSK0j+F0bovOqqNs7IdZtsaC1lY5GerenvgXmkI+uiAUKvSu63NZhddyzVBs8qmUGLdll8m4eGieQJ1pD6vnTsjHC8zXtuU5up0OJMfzP8oUV9NgBXyJSZwkejbeLed5ERPQ/WtRoajpcTp+Acl3qD7fznx1ZKhfjZDllGqwR+pocA65MDkHQvAmW39VP2ZJnmEhcV8WrUSKMe9coK0hXGiWZpT6CNV9E4he2DUkTsLxFOpHgXSzOCuNA2Jh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(36756003)(86362001)(6486002)(41300700001)(316002)(66556008)(478600001)(4326008)(6916009)(8676002)(66946007)(66476007)(54906003)(5660300002)(7416002)(2906002)(8936002)(38100700002)(186003)(26005)(6512007)(6506007)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zfv4W4m4LIDCo0KDShGve3+1YrPL+kqL3LC80HUdFva6F5Q2DomCwv9JBDKV?=
 =?us-ascii?Q?dFnpChCu/EUZJnfjvQNAP4GJrTfndV2H/n2RSrrXFDqIJ7Mcwc1fIBlcwk9Q?=
 =?us-ascii?Q?O+LjAVRcoXxBjG1OKiB6sSdG75ojwgMjKlEPptj0yLuB3orj+8abmKaufmXb?=
 =?us-ascii?Q?3uZUSMaxK40BxJ3ETxobQ5WhjU1tVIS+q35UDMZ5VZ7XEYSldiwmWWpgfb9i?=
 =?us-ascii?Q?FFyp0ESuuz6l+JP4U5MLGAvCXmh+v+dRJ6cQTPLE2ke94mzu29NHxS/9N99h?=
 =?us-ascii?Q?qo/vLpXv9e56gNr92sjuihgaelAdfN0gBZWz19K3QARTbriGgl8NoHleo+1n?=
 =?us-ascii?Q?U99tJRp5zY5jLkr7Hcv+MCKVqp7ckyHQ6DyQWmp0E7U1UAHOLuKr89ywaVZn?=
 =?us-ascii?Q?A1WgpC2HHAd0R0rIVt32gPQ9KJce59+4ha7vq4K99VT+UTe5hR9u8wBEzjkp?=
 =?us-ascii?Q?UNnV8rLBDJrT3qvn0HXoLcZxRg3rGSuPysLQmA8har2o6yhNOib86Dmvuso9?=
 =?us-ascii?Q?+7Y3SPRpRTZTQ2YnaxxtQiH1JiOn88P4Vxl/CegfQOvcHWLf2yE0VdFbyJCo?=
 =?us-ascii?Q?h0RO3ocgH8ImzVUAeftldRAfJp/4/ciApM0ggJAXN76h/CYrJXv7wFlltWwS?=
 =?us-ascii?Q?9VA+5cfJgZw9LOz63lkgOzuv7koPULJ52hzT2opYc8dZTBdeBxlnHI6N4YWU?=
 =?us-ascii?Q?XO2pco1YEaokg4vhLWSvkWvMkCHG+f/GKhFbqD3Xo8LhXO6MX45Bn/q4IGgb?=
 =?us-ascii?Q?2Wkfv4o7WpnaanJtXHWthamIKd9m8MTSsu9NLa+CWsNbQOvhovgJdBy/RWqr?=
 =?us-ascii?Q?y6BrXqwYnC0Si8b1sDVVarKKliPhv5GE1ANqb27rrrO1R7LzGQpP4OqKygWI?=
 =?us-ascii?Q?3w7XLPtoskzpfV3qHi7xYfV8U743ZiUiy/26xB+jPdKUTdpaXh6kgmUV3mff?=
 =?us-ascii?Q?rPponQk7P76ZQB22x6PwbBaoqsXeplwcjwX6c44qGytu+VCuPF3eIWfr1Vws?=
 =?us-ascii?Q?2dGXM2mNDJrRT+et1J84CqqfElx+p1uCeSApS4klHoUL6pUPbe88K8r37xPv?=
 =?us-ascii?Q?1NdZzY2znvU/WWvUruBljhHXjT+epXPcoXpeTcSUvTHRj++pqxvjEH0Y9cGW?=
 =?us-ascii?Q?EkWpLSvSlP6jXcvk08SGMlGTp5gTuOMW01atDo4nYG1/r/p5F5jvQBEhvA2P?=
 =?us-ascii?Q?1w3Ndby4YZNZbEJR9Z/B1KKJ4BT0dGc9ob82TSY+aOAl5cw/e1akLbk/5XQQ?=
 =?us-ascii?Q?3PFYsiEOFTJmoXq9Wz+ORWtD2VZdnOTVlrTLkOgY3Ag39J9+rfO/2rHQaL3B?=
 =?us-ascii?Q?4O8ESETN/dMXtUg5fMddFBXOiNF5pP3Ua6MA3M918LvFeLnisM2GiS3O5DzQ?=
 =?us-ascii?Q?RFOHRAZ/mogWwuhF4aJExO1uZE/5Q/1mShv8+3k9wBmNa9qOZE7IQqDwkOIv?=
 =?us-ascii?Q?vKPiCpYsNgDTrocvmKNQx7pHxPumMI+EZry6zlNltFhEh4xI4M6VO+oXRoPZ?=
 =?us-ascii?Q?j510RZg0Ww75mvdNVKE9Vt9iTqaAOP8Um3olfDUiZ78jIeNdkPOzTlOOVOyK?=
 =?us-ascii?Q?V5KVMnHH4/mEMmaCSP7oZr7M1qN22SnstX2ySkoM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b766ed-8330-4558-0b10-08db3a90268b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 13:25:00.2251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oB0aqb90EGhN4q9qNQmSAUorhswx31N2VP3kgbAlt/3YBRxXKlAw7o+cZ5WLizD3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8279
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023 at 11:53:47AM -0600, Alex Williamson wrote:

> Where whether a device is opened is subject to change outside of the
> user's control.  This essentially allows the user to perform hot-resets
> of devices outside of their ownership so long as the device is not
> used elsewhere, versus the current requirement that the user own all the
> affected groups, which implies device ownership.  It's not been
> justified why this feature needs to exist, imo.

The cdev API doesn't have the notion that owning a group means you
"own" some collection of devices. It still happens as a side effect,
but it isn't obviously part of the API. I'm really loath to
re-introduce that group-based concept just for this. We are trying
reduce the group API surface.

How about a different direction.

We add a new uAPI for cdev mode that is "take ownership of the reset
group". Maybe it can be a flag in during bind.

When requested vfio will ensure that every device in the reset group
is only bound to this iommufd_ctx or left closed. Now and in the
future. Since no-iommu has no iommufd_ctx this means we can open only
one device in the reset group.

With this flag RESET is guaranteed to always work by definition.

We continue with the zero-length FD, but we can just replace the
security checks with a check if we are in reset group ownership mode.

_INFO is unchanged.

We decide if we add a new IOCTL to return the BDF so the existing
_INFO can get back to the dev_id or a new IOCTL that returns the
dev_id list of the reset group.

Userspace is required to figure out the extent of the reset, but we
don't require that userspace prove to the kernel it did this when
requesting the reset.

Jason
