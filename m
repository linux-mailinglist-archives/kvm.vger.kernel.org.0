Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F576D13AB
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjC3XtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjC3Xst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:48:49 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2051.outbound.protection.outlook.com [40.107.101.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226151BD2;
        Thu, 30 Mar 2023 16:48:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AK8gZDdTV0qpM+9epwBbXhz27KCUlUunnZfOgetTWbUFE6PcC1Vn99sShMvH1MiV46zkJTzcWQIDUdU6NDD2sG5M4NLrdTP3FhWIt9tRy+kMsn0skxyZYjjJ73XvlHFxaKnxHSpy3Nyrd9CHuzBE491puOJySuu9Php8t9DdBcMeznPUpfdediLPQIleWVjipYixOtImWLHl1HuksAlSYk6upoZvdLM0K8e7gjep7wGuOfiJLsVsVzyOlxY5Io1xWvRUf6L/nnPi6a/7I89ryxeZhmGf4o0Xeko4P5ZefAjM8VrUirDpsTf7GPhVNh4zHlGSMRjfgBCibNX7+SFXiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCrKfdh4TYBmO7EiKXkWCCnZ0SpuvVwMZIUnS9Zefw8=;
 b=dRxcLntzcV/703wKzlZ+wWzKKdixgtj+N+6OV8b4miAqseRDYCokhTWSDBlLPe23vXGaZjICUDaNbT4Xi+ENvzeYo4QXI1+/BMGRxZn8fnjfIaIdDKhyvXEt8e7D6aEGBLaDtro6rDZSP0DBJI4owdTnkatLkfJhAwURCHfyapkLUxde2BzeqvqU/hqjfNC314Jfnz8X2+7XMEoHINH54HJcSorMkL41jz5FCeFG58uTUREVwKVe6fRXT0Oi7In3uPi7GUWVJkFlBr5d7AUCmzu7obv9s9yTZCapKUmPNzQUJwOPEGV3xJi/VsjuzRQCW8QhB6xa4wexWbMUNrizug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCrKfdh4TYBmO7EiKXkWCCnZ0SpuvVwMZIUnS9Zefw8=;
 b=Wmb5dVVd9239zgvMj7F9sHtf2De4FglBi9yi9Yop7sOqJ7XTK+sSQ38pqPThZ5TfR5mhwsZzaLLR5ezWBjT4FDIZRmVxKzeXxthVgqCgHQM6OS/fwT0lpE4v2vDSR3CyOpc2aA4fdp3XTm6tCO8bWYB/zTotXS3Df943lSV2fC7978siJHSDP+CaUcUrEfUg+NBioNfL75DDdT808141/Oo4i8dWAXpDC3ZSI/pW+36lVC4AKtb5Yn/4eBrAJBgPR729lrl6ODPXzXGBnT8/NHKQ7owX5kAN2or2U0oCxAIwV6n5FTiwlUi9mHUiqcsf5wEE4BPm2SjJ8ybwxDXKQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7889.namprd12.prod.outlook.com (2603:10b6:510:27f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 23:48:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:48:01 +0000
Date:   Thu, 30 Mar 2023 20:47:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v2 05/10] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZCYfrkjOdkLZULUQ@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093458.44939-6-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR0102CA0061.prod.exchangelabs.com
 (2603:10b6:208:25::38) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7889:EE_
X-MS-Office365-Filtering-Correlation-Id: c7124060-7996-420f-40a9-08db3179313d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0MIgSYUlcLdUACo126L1Ss8dv2aodXa9MSb2VQqNfc1mLD39Gvmj5xwqvXGlAUUGNDO7fI064NsWJa87lt2PPQkvue/oyy/9bcJdkoSLKwQkU0l10XJD7X7BuOJTpK1btwYUbHWng0yXDLfqt4JlsVZuTlh3fyZEmHsFWqGM7RZfNLpn9omzHEeqBTn145ZDsosTkyOAlDktpQPIxWX7LgJRUqPCZZfRcFr/mAknN4ddFtbyy49DZcMKiCdnT1qX5YAWK3OLFaCbrn5E+jGVeOk37Q8ZG4I8JSdly+zkJHej90jdsmyrI/vycIAucWdI2xt4QXhWT58ucpQw4T+1xzPkBph972U3yU6+bY9XekutxdSwknt1YSRcfvsr3qBmTMrKYKXXt4Lh/OgzoVa6jxv6rXhbS6Z1hfZfX41dyZ7da3oaQkm8JyWdGmb5a0o7M1Jr4OsbJROufCP0WVxve3Jf8nUPSsQ9xaO0Nu01uFwK0qQ8qgvbsW23+TtjhJjpLpe0ySaTNcTO5fwIi48WCLEVILNKwUsWfsNLEW9RMJC5Xyn0sU2tR9IBkKKfhXKk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(83380400001)(8936002)(6486002)(2616005)(7416002)(5660300002)(2906002)(38100700002)(36756003)(41300700001)(8676002)(6916009)(4326008)(186003)(66476007)(66946007)(66556008)(86362001)(6512007)(6506007)(26005)(6666004)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9H+TcKSiDjnxSBHDVu1Vtz94Ux8Ee6dGhJM0r0N8VrGko8iB5EHLtiWoa1eV?=
 =?us-ascii?Q?smQCuccJSSgMbjPoWtgF1cB+Vpl3xHMsy19d+AbCAL7TrHodZrpoBqFudMUh?=
 =?us-ascii?Q?cxHVzIREmkIazLn4+yjOb4r2+YtrxD+5wv+miwzQ5P3kUhR72FHO40aGEdaE?=
 =?us-ascii?Q?/xrAT09nxLbuwyKwHE/nexTmy+ynJsEnfpwAf5uc3W5crne/rJmKaN0ciP2Z?=
 =?us-ascii?Q?NhNuGTIp5f/4WK3y5DMpNCHV30K+mX2DFd3jQ+9ug8EFznnaaj0RP2sMgBjH?=
 =?us-ascii?Q?JjPNNi805EQ+m11Z8N86F7ySZa//1cXNddWxgrLBqs1lp4NlkbF5LMub6/g+?=
 =?us-ascii?Q?gWJiTd007JhRbJIBquzpnK5EDqHTulxmb62m6QyWEOU1vzPc89DZ+Kf+PvXC?=
 =?us-ascii?Q?lsa+Nnbrg+8NUcJkKxDO/yizalNUNnsPNrAUeCh4mAQaVztvMEourre9I+sv?=
 =?us-ascii?Q?V7cgDdf6Ir/2ZK7h9x+Ns8fmV1gSPRdYKhPn9vMoPjXsW/z1Ead7nbp4hZ8+?=
 =?us-ascii?Q?d/k1ryweffJI1TUBC0Ef2FNTiL+LMb18dHjSbdoFPW4/esamoHwrGaxigZ7w?=
 =?us-ascii?Q?m/DEQ4ZH/euBtsu2BhUGRS0k8jCo3wdl9//Nq7Q3otfVB2JU+fFEtb85Bh2z?=
 =?us-ascii?Q?hLQX1BykXipT86E4L1nZPrw7fm7ECLLYTboDBHMMMbFxVBbCutXrF8L+S5LI?=
 =?us-ascii?Q?TFu/C8Lh3DXUKp6/z7kK9Q4xnfkmK+U00n5LTmHKFMs4K//4Mn52GdmOAKFb?=
 =?us-ascii?Q?aFO7Ip7H5CfOsJj7S6rbGztTp/yDzoneQblHkuQi1FqZr2rafm2MkPHDRY1s?=
 =?us-ascii?Q?VmT+bl87e7LKt1WaoBFSGWsP+s4k0vBq/IMAsWrutnCAoPgpeDm/JmsKzxwp?=
 =?us-ascii?Q?SGPBzEKrM9+ZlPi+pAC+xdFIAguqS2n31Wb0x5/6XT3fJOR9oqJq4H7nwEl4?=
 =?us-ascii?Q?ntxpzTlP44/XnLXTh4K2o+PstBC6wqzFRKud197fScWAwlP+ilIAaZFlWz3l?=
 =?us-ascii?Q?KilYocuV9Txv75nsrgtGurunKwPzANhdNnxQlSjRs/YFVo0aewvBGHhKKbXi?=
 =?us-ascii?Q?rHG/7z9BA3kdj7XyKOtOCz21dEdkGuWYUIPuSydnlQPy2zj7itRwrVgUn/cO?=
 =?us-ascii?Q?M5eztV6XM7lgfnqAqqdNgrK2BnskW0IsJ0RV9IB9zWv20KNw4TBICLM5opHn?=
 =?us-ascii?Q?HD+n9+tOPNABhvJSRBBrnFlJ1YU7P7XpZFF5za+/XKKGIKzUcDGGsuoS8n64?=
 =?us-ascii?Q?oWK15pQl7YNr0TXqzjOR8YwmR5vAU4hyRjMojCKtuA6BbralD8n2jXHdswyU?=
 =?us-ascii?Q?O/Vh3gsDrKjpCa9JOtnzmz7OFaAMo7KBg2WMtrSHLzXfOKbHrJ8Jb3Q9LpyJ?=
 =?us-ascii?Q?MmAu9n+F3annKB5yMooI2kxCTtFbSO3GaMRvebed/laBvBYL5kWMmlD4rwiv?=
 =?us-ascii?Q?QNJsE1006na4EcLzPDXnmz2zdoZSZqO8yeDgo4uVkDn1yskFTMv9QLVrJ6tk?=
 =?us-ascii?Q?UWmLt2MZDkOIHrA64UCwYTeplwVfenflqFRCjPU/F8xAhf54+g4TZJNGrcC4?=
 =?us-ascii?Q?NqQntxHD3rN9dUn6Bmlb25pds9RftubGLhOzCtgt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7124060-7996-420f-40a9-08db3179313d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:47:59.0896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ypsGLkZMmgONkfJOUZ4ubln82Dbr/e6ZYI//AGQuXk2KbC9ft9Pw2JnZ9N2X1s6R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7889
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:34:53AM -0700, Yi Liu wrote:
> as an alternative method for ownership check when iommufd is used. In
> this case all opened devices in the affected dev_set are verified to
> be bound to a same valid iommufd value to allow reset. It's simpler
> and faster as user does not need to pass a set of fds and kernel no
> need to search the device within the given fds.
> 
> a device in noiommu mode doesn't have a valid iommufd, so this method
> should not be used in a dev_set which contains multiple devices and one
> of them is in noiommu. The only allowed noiommu scenario is that the
> calling device is noiommu and it's in a singleton dev_set.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 42 +++++++++++++++++++++++++++-----
>  include/uapi/linux/vfio.h        |  9 ++++++-
>  2 files changed, 44 insertions(+), 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
