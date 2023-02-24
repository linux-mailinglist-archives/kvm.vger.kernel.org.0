Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EB86A14F9
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 03:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBXCgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 21:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjBXCgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 21:36:13 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE8A2278A;
        Thu, 23 Feb 2023 18:36:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIlpg50bHKEdlW8uWJfsDwBtk1DmieN74AvZqyizVwvMaKI87hJDS09vA2l8Nmj/E5jCTrCrFMKYkTjyX2XNbQqdKnFivDIltABkGCGwbJeva+/F8awiMjX6y5eyUl+GyelXTG0UrG91pt6ApHWhkbnclxjyjd7owaFNcZDV0g3+IQw7pCgY52FxwNPhxVDXi9VEYL2NKNQc0qJ6zLIv7aqXMs/oTsld0t7+ssU98Wb9qN5utOxe4TeS0X5ncyUDKWY7wUdNpOHTF5yvTh8LZqpLYIS0l1fL+YIqteXhq8BSHykzi8a39FSUJlksj4eRSc5ajDvQSqNp86/se4fyDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhQbjPTY66S2HodrpNBtxopTPt3nGd/7yDEordtKS6w=;
 b=OkAMdEGAmCz5+NXn3tnJYL/qKGagt6htuThQ5o7XfNi/7BWLoOBLaKcQKFG6a+d/vDRehacrO/4aN2lMCOz1LorOdLAvLH99ABjE55CLgbUT+NHFZ5+60g8MMKkB/CKTN874xBBtQ3dTrISGvGqMJsZJP6IQssiA8HZADs5BW+1muC7ha6a9jxDUcNv4P+hpeZeQxO1ZlDQeBrw8QXGoVpusg4x5T1vUYpMT04PBPO861b2TP2cGfFwzrckTkd9Wor0DBkMEtmoAxcrfh8YaRc9PuTR2sMsBsVs2U+mC21+FPSiyj2OQhd7PN9KNriOVZ8A5ATQFvxw86ZDic9YN0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhQbjPTY66S2HodrpNBtxopTPt3nGd/7yDEordtKS6w=;
 b=hLO6oTFLv8jtyfFvS3RHKiKUcIIRgA/hN2tOFgmcn2JNHkI5Vbmj+MO6Tyn0msNzgK6CVYdATQXLWStwSmS0TBH9Xa795Ha0VMGTCTlx/V+q24Xor+Pg4PGFPL62bluvH2oSWQD6xzXRZn8MhuGM2jzgdQpAMzyd1hK2YuGJpGA7IyKVJ5yc4HRaafeBeMAGnRcrGDR/e6xqykkeEBZ98CT27TEsriF37uJE6GMAQupaV8EyttViDMFgq+7CgI51sJDVDakf1vknweA/lXuc8OGFmxsuffRHryGoukxiV0LP7yL6ksTkkne+jcSo4caPJbqQA/B66Q79LUsaqbIe4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7753.namprd12.prod.outlook.com (2603:10b6:930:85::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Fri, 24 Feb
 2023 02:36:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 02:36:07 +0000
Date:   Thu, 23 Feb 2023 22:36:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Message-ID: <Y/gilafqe4Xm45jY@nvidia.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y/dobS6gdSkxnPH7@nvidia.com>
 <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C959AA31F8515002B6B48CA89@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0057.namprd02.prod.outlook.com
 (2603:10b6:207:3d::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7753:EE_
X-MS-Office365-Filtering-Correlation-Id: 410bdb59-0e6c-4a1b-d859-08db160fe1d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zj3dNydQMB7CJEvJwi/rFD5l/IzR/lyWR+W/NfZIz6rY7QohqLIP2tVrPV6Idfgh6i0Z/0wfPfxAgaUboveCWECbOufSZpqpkT7Z4ADkyFAVyPgqEcUAB1ZFMnDR4MS2y+0mdkwMK5MCH4i5ZihLPFJjfPJry7JBkgut1wkvsAeCn18v1Exe4cM9eiAbBJv3bs9DJq20eDOxzqP0qw+1xTnkDfv8jZo4rXXiKghOcj8s6YWJDGYBqzafW1EZxPNBGQ9iQpkZEY+H2MIzVH6RprxV82C65Pz+rPyiULOsQ1Vffxa7XPA0VeBs+Jf4fpQEusq5ivhpWSGD06jqdTSTkAQ0YxuRtH4TVDztOejjCdyRdsgTq29uo6UzaMNw/iueDx36bmyQ6cc5T6TlQszlgEauSmBRo4Jzaiu0NBVxtIpjqs/o8uyth6XMTb5Gcl5vrLCT7IlL072zuwzXuuuVpLWFrXIGnaZc7WsgDWjw64SvratfqZ5LhuSydxuYUJcpzeardc+o2ql6YpEAuTlC8eY6vcY+kHmRJ2uSWB7BgPmoUTDdvr5PboxsFo1NbrYKJd5c36++DdOFPuQVCV1fLK26E3FIs1P6Fn+duhXWHRdmixwAD0xdXVkKfBcLmyTX1CZ4buxrPRWdmXFlTDtCCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199018)(4744005)(86362001)(83380400001)(41300700001)(8936002)(2906002)(38100700002)(5660300002)(7416002)(186003)(6506007)(6512007)(2616005)(26005)(8676002)(54906003)(478600001)(66556008)(66946007)(316002)(66476007)(6486002)(4326008)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H4jIYVAybKaNQKx0YLT9kmgCabnccbDTZczU5Hdv7s8G2wHcS7YF1YEBf0i4?=
 =?us-ascii?Q?2sjAiSxhnDTSlcl3wPP0h3pJeMEkkUVpOnKJW4/aCh0SHn5iURV4Xt4h+n00?=
 =?us-ascii?Q?eLtqjUSMKloTyPFOS3GkX2nZfnYAvdHY9JPEN58thcbYXCMOQl4Skx9pWHOq?=
 =?us-ascii?Q?xXeG1OaLpzrErgrifQBktUFPB4nkXj5eKs74Qxz3YK+ZqbnlC1njk58bvFzu?=
 =?us-ascii?Q?ABJsiWj+2mPd+rpbB5zQieZEqJ+r9uKyJv3A/HH/E0j115mKHQmTfI7TUVqM?=
 =?us-ascii?Q?NXjpQvO8G1aNcWBDBmC585ZZeSzpy6b4Cn036digWrGcyHQ83c8l48MunodM?=
 =?us-ascii?Q?0prCxoDDyogWkzpESqDy/ye9z4eynGY/1dNMTxCgX/MtcuGJqi5zf0qbDw6A?=
 =?us-ascii?Q?Aj7AaOx5qDcJE5aXWOU28TLV3YYT5qtxwOk3hzctoNYrFDTz48eLE55PXZhv?=
 =?us-ascii?Q?WXCmQIXzDii8iih8pGPiK04BtfkNF0GiVGdnQ6fdsq6zs6K7tMH4goGFlrxJ?=
 =?us-ascii?Q?GnyIAwmMBvEBYbgE2imec+HQoBh44dkHHI0pmgvTd9iz/L6x1d4FV5/olkqH?=
 =?us-ascii?Q?GOYdND31ymkBuGZrkKYwipneyeYAYw5V5nbJYjj22IwqcnqIe+w3FKbfs+Xc?=
 =?us-ascii?Q?9yFFeRuddmjbCqzyxBrR52mrUmNXGR5IkbAwOVyF7qvokzzXW1MutbFn/uaY?=
 =?us-ascii?Q?XD7dM8XdJLubPClfeOY1hrG4MSjrxfJ1tRoD8RSDgFCXuoV+W97osAsQRUBL?=
 =?us-ascii?Q?uU7FJrbi/+H1sxKsSKOo9rGTaJS3Atl8jQcrZICJ1MxkcgmnGN9sZ1dr8QdQ?=
 =?us-ascii?Q?e+9S5pYaNXG4iuFqg039HPH6kXUDw02nv7a+w7JVIiScfYA6b1xz/ksGXZo4?=
 =?us-ascii?Q?HZfAbmqCnNboParo3eBrSrbB6jQCyMqfiu5kFxwqRx56muZFXk4lrofiu/Ki?=
 =?us-ascii?Q?nGOwjRB+iUfTiUslmQSH1HWF7KFOwILA78xTkGV04ESDV51XB6YZs6c9pk14?=
 =?us-ascii?Q?CobhjTKvXnFF+Bwj31Gkgo+1TPpgwPIEulfQ6+y/glUcfzOvGN/Ieyfvz4M/?=
 =?us-ascii?Q?ABqD2zRL3horZph4yA5ZHG7acMmJ1g9g0c4rRYseuOymV256g+1DX9x79glz?=
 =?us-ascii?Q?LY4sdDPW5BIgcLHHdj+rh+VqBuHGUWNx5LsyBRaouG8BWvGF3oQzBQ61HO9I?=
 =?us-ascii?Q?BnHyyg623alEp5vErxjdY50rLhUJfbyGCYDUVCwZq5ykLIQj43Hvs6cbdRkZ?=
 =?us-ascii?Q?TLnok+ehs2MvBLW35aSg9ZRjDRNn5Yikp/F5EFYBSaxhQLpFjSn8H+tAh/Be?=
 =?us-ascii?Q?mdMAO914tX7b4Y/b7z8/CjVLQndAmG3ObLtiTr+2eQ7bX/eXHixcqYwgU3w7?=
 =?us-ascii?Q?BOeFfW8jGtF40dxGruBax+NJdZBG6qk9d9JDo7zxH227ZnoRrOPS70QaR5Go?=
 =?us-ascii?Q?8snecRr9xYpjLk3djTxaVS+L3dVgEwkRB+QHXaDJM+YxSm5TDOfWXh0adGi2?=
 =?us-ascii?Q?5nl6j63H0L4JH/KSXZbs5OTFovJxXtKkKLBXb6wXxlWgQe7uz2UCozzZv/G1?=
 =?us-ascii?Q?Q7yvBwqvZaoi7j75O5pMcdxTnI/f89+W5P1qK1Og?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410bdb59-0e6c-4a1b-d859-08db160fe1d8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 02:36:07.4349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vm1aMTNlm4+W2ZyL3OS8qr17pKy2qL+yYNCVSD3bDqVJaCZmNditKXfJd+A6Uky3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7753
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 02:21:33AM +0000, Tian, Kevin wrote:

> Yi, while you are incorporating this change please also update the
> uapi header. Rename 'group_fds[]' to 'fds[]' and add comment to
> explain that it could be an array of group fds or a single iommufd.

Upon reflection we can probably make it even simpler and just have a 0
length fd array mean to use the iommufd the vfio_device is already
associated with

And the check for correctness can be simplified to simply see if each
vfio_device in the dev_set is attached to the same iommufd ctx
pointer instead of searching the xarray.

Would need to double check that the locking is OK but seems doable

Jason
