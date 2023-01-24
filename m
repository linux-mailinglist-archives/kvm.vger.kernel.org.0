Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6E467A425
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 21:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbjAXUov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 15:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbjAXUoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 15:44:46 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9146B4FAC9
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 12:44:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHorGIr3zu6E702aaiidnpFuDnHVzB+QUHl4XBsaK8T6nSmUy553xv+RUby3k01CLrfIFKuIma9f99EZxTSn3QQiV0maY8Ebx9awEwB3en1Yo/md+RSt+gc/GFbc0bZ5ek0gR9NscKcj+7EhoWVSHGW8vSSCG6CRbxKGrJMnEhaIN/FUCAtpogBfWi3BrW+3G4rnUBUB3QzPFjipGQc9a+38n1NJtaT90pZWTcaQ94qFJd843Q4IfdcpXXltN9jQLrZwg9n0YG8c7cQKXaBj2cNOCr6aWTTlJ8N0YCBx9GKUdhCqtoFeSgzTUe2LVyb0uMFjhrTrvTUxDqxB3rFQfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYzBgZyjc64Bjo/3It9DnaNAVUPw8ZK6eM4EOniKak8=;
 b=eZTJe6C8MTtXN49TCcc1utWPRbS/MKcY4GnEsQulWVluN9+AAO7fXLDnnsd7aM0G6vJap1h91d+FAw4WsP4c65bKzzsyg70uzldt6GqOyLEbYGa0nGnTm0yOO6giwzG/3VGd/Bb/IevNTMwTvwCILuq6TGENx6gOH6ZL0lYdqrG4lhafWiLnEnHLOI5zMxTjqekO8wKMGnUrDe8P3BRMPetLBZZqFIZECboNCvS2XdYrkMrdlvdIQ0Me3vPzJ6PqPa1/A9W2hh3s72lN1mmxwsdRlRlrpkt851lzu163sGUFsYN7CtG3ZDYwwFhpm9Ti4dmUeoOqidthJfwoLMLcjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYzBgZyjc64Bjo/3It9DnaNAVUPw8ZK6eM4EOniKak8=;
 b=LUu2sbZk6vNfqmWD3XW+X56Wpz0Mh6SpZC3h/7tYFPE3dLv3Sd89sLMX1f/Zkl9cXR5QePBXZOKhEWLEHKNiUOfKqA25dORjH93SJDqaprRS8B9xyrfC65UthRl6y6fQzVGe0jdCJY59hIa98Taxk1TSYvYMZsdwE1M6LUkBYIzeUODMajJXBbYe1Pj2x9XEDsA66xF8P1vSWE0dwQQD3OPSh00+IJXknk48B8m/Z7/ApUDvco/N2O5gjMh5ezjVr1zS8ktfPWaJRPuAsRhRoAhCQ/n1Ym4ELniFfsTFoQZyGmes2fKDXoBEN4uCgl7oQH4d4+E4l5mzAfeLCb1qUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7123.namprd12.prod.outlook.com (2603:10b6:930:60::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 20:44:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 20:44:41 +0000
Date:   Tue, 24 Jan 2023 16:44:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH 11/13] vfio: Add cdev for vfio_device
Message-ID: <Y9BDOCA7qlbuIMMg@nvidia.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-12-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117134942.101112-12-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR1501CA0033.namprd15.prod.outlook.com
 (2603:10b6:207:17::46) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7123:EE_
X-MS-Office365-Filtering-Correlation-Id: 05139039-3d38-443c-d0d0-08dafe4bd14b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FyGpXe3l2SS1Vho+zokl6kinV/T7QrC7zWguH30Df9jx2A+Nk9pf4qmZ6uv9tLMRHAJ4zwOJxTQKtcjUA2HtXz8mHu1sNAxq591wJzzGwv9mbmaY19N/thrc93lZnUzw0M6fPt3jN1PSTVLY+bI9atCbCxMXTAnx3L/Ww6T6P/fnH4KQXWDetwt+sLNFRZFT5HOxZeHGSqgiJTaQxgpfuIlrHeJfM/Og77hUEoGk4MfxwmpnfEt7m0sB0a472T+acE7ErzWwKZuM4zkF2q9rhv6aoY2fqSCZbDojfbW9BxNt9UXDM9wLRdJGTJVBznJxW2NkfuNEWts1SLph1G43QMfB75T27de6b6WHL2t/9kpu9AiZVvM3y6qEWWUBMdIQFXmE/W2QyQH7Dx8qKON0HMyBsj78jfX5nXvm9pY+XleQMIBQNhwMXqxNT05IG7sYNRCgPrlLHS2fYABDjossGOIU2ok5qyYPjN+QSpuGOspKZ98cLWDupSO3IkSfWBH98HWEdphHaWaR3U98C/DjkKcBh2LzIPd7RZZ9jKB26sxrS8QQJt1A+T8iGxQXg9L5lV16PRdgqXZqykZrXHgRWc5YmnmFHBBnAvUWQJ+4dDN3/9VgE+qlBjkn0oE6LZPMBskdodaXtdMd3rekPEtjnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(86362001)(36756003)(478600001)(6916009)(316002)(2906002)(5660300002)(6486002)(7416002)(66556008)(66946007)(4326008)(8676002)(66476007)(41300700001)(8936002)(6506007)(38100700002)(186003)(2616005)(26005)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sFPzXkAQ9xbUSRBN4xIrZCTcZVBTQweAC5bXRtP/LABI5NEc7Pk5ngMb2JN5?=
 =?us-ascii?Q?/Eo33YQamw9WLYpy9Wy43W1IFGfUuPKvEVYUsXgHU5StBF3iOubDP4gBmOyU?=
 =?us-ascii?Q?yD5Rq+xNZVZ/5H3VGi8igc5K2dIdrlMsw/8/4PO98Y+ASwfitL62GvcJ1FNL?=
 =?us-ascii?Q?MVnLtbJhaglphFzAUTmgRRas8I09Q9ucZaYA9P/qmMUSizQ7PolgsBV+mQVb?=
 =?us-ascii?Q?SFbCCfg+YAbE9ZP5oRlFgB4tFux8oPXxamnC99VwX/UNM76tPIFFMWMG2+Hu?=
 =?us-ascii?Q?wI0JIgPur6po1ZTJU/EaBnW5jEwVWKnn+jSh7+PZI42q3R11K1MJDFh1EqOd?=
 =?us-ascii?Q?lFzYFysHPwAn8/7X380CjEPryhjWyLI+igS0r82kUwyaWdCUByxEK8PKf+ng?=
 =?us-ascii?Q?sg/LN7m6WyjuVPAbR4XlLP9hzZUUJC6qMzB5jO7LoE13WnCe4oJ/A5tREQl3?=
 =?us-ascii?Q?QbhiJ8mLE/5anun0h9nh5x9CCgmcI5ecMOGOaVMTs4SAsN6xFKHC3QXLbWJt?=
 =?us-ascii?Q?7Vqkd4Kdxf0OZmeIdShL3jI/SZRLoIxXohrm18uIzicW1GKVyVp2VXFf+1nA?=
 =?us-ascii?Q?gE37wXMnVxkw3nomY3sb/yURJtyGiaYMYVmSGsFlkwFkIKa8Df8Fc1kw1siR?=
 =?us-ascii?Q?XBZ7D5t3rFIqYZrMBiiqvCm0QaBGw0+wj6PC7bfbhcyLrShdMAL8iJbqV4sM?=
 =?us-ascii?Q?xRYB4eKbAxtKfMtUWYBBBlc17GOUXF+9jnl/v2Apw/t65eWQqxpzaIexgWYZ?=
 =?us-ascii?Q?Arm6AMJANxLRs/Bn5UsbCfeX40JCgtLAPzdSgjkV7tAdF9BlPW1RVBAhFnB+?=
 =?us-ascii?Q?t2iiQBR1wMYzNfqRSqquBV6VKI4wmty8wkNX05BooQK3Ii8/0tQFyId+Alsi?=
 =?us-ascii?Q?/hz2OHitvVc9UIBvr8ieh8fgaawzSr9IQnt+prjPqMoQTGSbY4yeHwp8z5Nk?=
 =?us-ascii?Q?VTqeQm9KxFWTH53kMCaK5IOGg3Ag3VKZed0HCn/cYrRQHlivr6xM013K64IN?=
 =?us-ascii?Q?dLxWURJZxQNeG/qZFnZZhinbGLXqwtDnbC9MOq5oWlZVIGIM73Ze38LSPTpJ?=
 =?us-ascii?Q?ultPHHkFXQyg2wPIQBse/Nola7fhAdhie5wnbGz1O+eNtA1VkmgxT6JNEkpi?=
 =?us-ascii?Q?wTVU3w70Vl8cevH8Vb+FTm78AK1fq5hG25KDgxV4D1Q3/Ijo+VT4Lnzr7hQi?=
 =?us-ascii?Q?MqIb5E4GTtCRHYX4McXUm71aJSe8WuisMbKQF2zNciAzo1cB6XUbEJ/RyOS9?=
 =?us-ascii?Q?fBNeMQFpt7Qme23MoWQbqpoUfKAj276ASQGx8q14ueKWils1/sw9pEteqd1P?=
 =?us-ascii?Q?0schVtODI6wdMSa2sfo0uP1qt2yvl4KpWt5BzRZORz+3A87hqnD81CEV3Pd6?=
 =?us-ascii?Q?yfidXR9PvaxPIU90CvZmHoOgPJRnAteIWNU11/3RiXB5ZhOtPwAVapru4aF9?=
 =?us-ascii?Q?r4Cwuh5noolbrWNWQ7pyr0z+62Bp6T2XOeT1dEkrM1quqtif3rVeN8FSSgH8?=
 =?us-ascii?Q?i9AsmMg5LkS8UtJsXECfcZzYbvnG5Ms3USK1x4tuNFtevIFt+jZ1lCasFk6u?=
 =?us-ascii?Q?fE9iHrvDqhi/Z/4fVFVDJcGA8AVfnO/AS+9/J1fq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05139039-3d38-443c-d0d0-08dafe4bd14b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 20:44:41.5317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J81Zf4X+YiJW/oiHfwk7lpa4rsW+vIPCEyjnsbTOxrjoFe5npYli4bgiM3MM/pmg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7123
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023 at 05:49:40AM -0800, Yi Liu wrote:
> This allows user to directly open a vfio device w/o using the legacy
> container/group interface, as a prerequisite for supporting new iommu
> features like nested translation.
> 
> The device fd opened in this manner doesn't have the capability to access
> the device as the fops open() doesn't open the device until the successful
> BIND_IOMMUFD which be added in next patch.
> 
> With this patch, devices registered to vfio core have both group and device
> interface created.
> 
> - group interface : /dev/vfio/$groupID
> - device interface: /dev/vfio/devices/vfioX  (X is the minor number and
> 					      is unique across devices)
> 
> Given a vfio device the user can identify the matching vfioX by checking
> the sysfs path of the device. Take PCI device (0000:6a:01.0) for example,
> /sys/bus/pci/devices/0000\:6a\:01.0/vfio-dev/vfio0/dev contains the
> major:minor of the matching vfioX.
> 
> Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
> that the major:minor matches.
> 
> The vfio_device cdev logic in this patch:
> *) __vfio_register_dev() path ends up doing cdev_device_add() for each
>    vfio_device;
> *) vfio_unregister_group_dev() path does cdev_device_del();
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/vfio/vfio_main.c | 103 ++++++++++++++++++++++++++++++++++++---
>  include/linux/vfio.h     |   7 ++-
>  2 files changed, 102 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 78725c28b933..6068ffb7c6b7 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -43,6 +43,9 @@
>  static struct vfio {
>  	struct class			*device_class;
>  	struct ida			device_ida;
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	dev_t                           device_devt;
> +#endif

It is a bit strange to see this called CONFIG_IOMMUFD, maybe we should
have a CONFIG_VFIO_DEVICE_FILE that depends on IOMMUFD?

Please try to use a plain 'if (IS_ENABLED())' for more of these

It probably isn't worth saving a few bytes in memory to complicate all
the code, so maybe just always include things like this.

> @@ -156,7 +159,11 @@ static void vfio_device_release(struct device *dev)
>  			container_of(dev, struct vfio_device, device);
>  
>  	vfio_release_device_set(device);
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	ida_free(&vfio.device_ida, MINOR(device->device.devt));
> +#else
>  	ida_free(&vfio.device_ida, device->index);
> +#endif

A vfio_device_get_index() would help this

Jason
