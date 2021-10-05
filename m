Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A042422DB4
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbhJEQTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 12:19:35 -0400
Received: from mail-mw2nam08on2057.outbound.protection.outlook.com ([40.107.101.57]:50758
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235710AbhJEQTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 12:19:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDJGunots0ND6CctKcwBQMKiaUBX4hYwJRwRkVm5SwK52ievkR4k0mz1TBV72X5lReyF6R5IEsbqQgz1+oz9UTKkjd1RoPRFZcllsQHwUtfCZirimmH34JP4Yxpabr67c2thLCX65zahwQuGYko2gqNIBzxDZ44t5F1g5v1ZMMJsvFMter793iyViLSbndiwCA7AQ9lTssLcCqmW6dQjAdlGyeaFfnli465IwUNzl0yfOkp4Yacv+zsLGt6zWLcgOYT6/J4NU13zqx393jUXRfJxnMaBQS8VdKuCw7xv3od6jqfNQmMvOvEsC0WL5ZiFJcMyaNc6OBwHUI48hS+AYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dJIXzTp580x0DFcbLgIFy+rRKDpXxAd9XPmuKDLvgE=;
 b=TvcQKOh4Sz10B0QFOFDcB2wP1TJ0YHEcEyh8C24VELsaxpSCDuO0IexNRG62Gx7sw/i6tYYNS1TlvU+bfMVKSkkXWt1W5QiM/anNYIPTBYWWu4LNJNJah1rjyKczAL3/D5sj9ZEqZlfpMBsv5GOmzK50BQCibDuW3ptPey3x7ue9VLDwUQhJSYACl2Pr8EzI854HsYnM++gbC9fHNrCdc4d8bxTLju1d2p/7vfhuO6NUk8B4o9VVO5iNvo0Xgn7yyn0ooi+wIS2+3lYO/X5R6cYovE+YRSq9SsIin25Aq+JKAp8bBtSKdwlWMluoU4IZ7Wy8QVwA8tfet4XI2QMYDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dJIXzTp580x0DFcbLgIFy+rRKDpXxAd9XPmuKDLvgE=;
 b=o8Pzl6uSEHkePmpOQfv1PkO/MSziWg1F34MBvTJzcfVrIRPFTGt8NY9qnjiVDwPYJ7vcRmldBgWU3jcG62ASGVWk3UbraZAjLJ/6WC1Gf19DWBX9SCvpfrAQfPc95TmmhBHuZdyTNFwhGKs50kGApd7z1Xw4+Xa+PjKaN6WIjj44WpSSxp2atbUCEO2+7MI8PIIH1FoYYKSKtE8Jting2urWYjrNnpMofTHq56awE+PgrP7oh6qCmT++PTLHVNm7Lk81cvqEjNgOP/JDowSKmtuyphMLeVRBUvx4q4Nv22trer0Pkv1OOPVK1gh/60ClNKUCIMhITloszm0NH0AutA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5288.namprd12.prod.outlook.com (2603:10b6:208:314::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 16:17:42 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%7]) with mapi id 15.20.4587.018; Tue, 5 Oct 2021
 16:17:42 +0000
Date:   Tue, 5 Oct 2021 13:17:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 1/5] vfio: Delete vfio_get/put_group from
 vfio_iommu_group_notifier()
Message-ID: <20211005161741.GT964074@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <1-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <20211004162532.3b59ed06.alex.williamson@redhat.com>
 <20211004223431.GN964074@nvidia.com>
 <20211004220152.306c73d2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004220152.306c73d2.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:208:256::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0015.namprd13.prod.outlook.com (2603:10b6:208:256::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Tue, 5 Oct 2021 16:17:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXn8P-00B9bQ-Ab; Tue, 05 Oct 2021 13:17:41 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6c9ad90-6ee9-4746-c2a2-08d9881ba8c9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5288:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5288499917084BBE39809FA1C2AF9@BL1PR12MB5288.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y+lGKNcRStA2ZTGfSKDDOvEAaI0m7Wv5xPd3EBBhQqGvrnp2KIw8Kzp9dQ3hD62IVolbnrEAjkk/3X1dK/vE4U3gveGgn9O0nvtkw/z/4wNYdAS0JwXB3qHLBEBEcB66TSsfifh2D1THLwTFcAds+Hzp1lOxIfhldLn+fdoyN7O4OqruhaWUh7Ze0dl+uTPWc/imAb6e0Rr2jWt4Du5rc4VZdCcf/h77zTYfVVsruTMAqtSeLhsGJuUcWwCdSVE5vbpTohVyI6hM6JnUAsirxkK/g4c0LsfU3cHniXO/yvYUbS0sp1C1LWdiuudwGR+qIkMm8nSxMeU1k2tjmmPX8OhQqcQ/J9GAvw8UIZDEzem/5LCebkGklQlSWzBo8jwHtw8yoksrdNsIlcFLyq5FgpEcBeOh/HX19i72W1FPguOMCz/IYd53R5CsLjdK4hwYcgOl9FhVRBGW8hwvLEjCjoUb61bfhDEizC9c5TbirVwAUTBAB4coE9l+fkKfu18Cu3coO50ZnYjnT1cXg7HkGovCDoWSdoxuXJYWhmLBVli3Ky85nVVdz4VQ5V6IXFaHBDUBIrDKL4Hozd2eJxPi7v9jjMKl/p8pTdUrAq8xRc0HQOnYiZh+Ppvz3AX+S60KI49n7EtdZ7zB2sstJxp/UTLfWdtt2oMkFrOMrcK4P7kWeBM4Zqy/BCqtFaScOViBTLznqbaFc96NqTV8MZvfkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(426003)(186003)(2616005)(26005)(5660300002)(508600001)(9746002)(9786002)(8676002)(4326008)(1076003)(316002)(36756003)(54906003)(8936002)(66476007)(66946007)(66556008)(2906002)(38100700002)(86362001)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SYOWfaE3XxuODKJL6DKKkir3L/rgTJ9nEM3/6uhN0Cj3W3Kh7ADGOhl8wBAD?=
 =?us-ascii?Q?y2Ub8mmWgPFV4768b8WfS69RMq6+iYOnxFanzaxULsC149yajewvTRCVAkaL?=
 =?us-ascii?Q?4GJeREKoKnIw9MMp5WbJ0+XZ/rNN8jeJ4xgunPp8eG8KZZE2J9bS+6J9grK6?=
 =?us-ascii?Q?gj6vSiFJwzJwZ2NjMHZ0SouUJCWtstIT7WMbx+gxdihJVdeDudMtFwrFPmQe?=
 =?us-ascii?Q?7UUrALKbMKY/gqAYKde9U22+nMx2uJKzLy+YC4wtHZJbhQA2SnZMb7Vfx0nj?=
 =?us-ascii?Q?MKT2IPmX/5m9jKhV2Iuoa0CrLOu4+7usQEvb5uKpGifpHz5qhU90JKUFR3wV?=
 =?us-ascii?Q?DWNk7lDO3pqh2KhqxmR9SrcfHytDzDqwtDp0CKHT4UueyWR/6xPd+AY7Ezya?=
 =?us-ascii?Q?q+6hGppDxLhA6rInLKeOcPuZC3OPQzBW1zArOcD/vb4WrCyD0jEv/CfUr03w?=
 =?us-ascii?Q?nTrxPGcOEm9WKft/Yfw8mALPCUO8fVpld/1eDLVxbtLbblvmIzCoay4xOlgt?=
 =?us-ascii?Q?XK6ExD67O9B3zG5qnQfntgJX/5eFMQklV8ZoXuPpEs8p7WxeX2SYVjhIOH/H?=
 =?us-ascii?Q?AV/lWXlmKUQUE++vDP/4ObV+YmMB/mDnOjhg1PgaE23fP8S8sT6T85dLGVkl?=
 =?us-ascii?Q?X33mkO9IQI8wTzyZ3VI+xrgPey/yVfeO1gXvKgei7OplgQohauiKRks6zgQX?=
 =?us-ascii?Q?AuwAw/Hbz9PIDoDO5YQPiZ1Jgc9KXHYU0ssWgZzmFvygxY+caBIETsEkN6PQ?=
 =?us-ascii?Q?lurVE2ejEwQFA9vSPfv9vtHDeHIbPsWpJiTIPYEcga3ZMQYAu/6s4oKDF/jW?=
 =?us-ascii?Q?kFceoNyL6Lw91xDKniwZf8ac4LCzXOHJf+Cm1dDt3wLEDd/srADS/VikqcOF?=
 =?us-ascii?Q?lnoQT6il4EpDOYhPz964giCWsZklWS9zZcarT3DaeuS2F0r9WnReg5c1/EmW?=
 =?us-ascii?Q?WVXgNEPXBwdl4v4D+n0/nNQtxEKiki6M2npLfUCWF/6QR96cf2jMjK4yysmN?=
 =?us-ascii?Q?vbK43wZHbkxFzKRY6I9UKZRkqt0p67+oo8yBuY6nBprcC5UWq8A2zYBo4CkB?=
 =?us-ascii?Q?vJZ3FofJaWLijJQHqvjbMUaRGTKYUDLihAk+5FeT1C+OIY/TwU/WkbkQPDIk?=
 =?us-ascii?Q?YV/cSHxKPGTGv4jN160U+OUklmLAQvRBoum3fTZ3dQL3Z9BNyQcqJWXzKWPd?=
 =?us-ascii?Q?KIvTI0p0+WfSaWFUrFK0NbA7P12ItpuI6FJLDV5Ox4Daj0KJqJ90UrBT4JiA?=
 =?us-ascii?Q?lGCNFDNp+bGImYLuV2BezEuHz95o+72iaKjLRcsQeMWr+7mpO1akTteFRnK7?=
 =?us-ascii?Q?mlZ5sVzYLmOZ6LEfFVuKplcA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c9ad90-6ee9-4746-c2a2-08d9881ba8c9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 16:17:42.8329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kGWrbrE5TIUj3uHAWhB0wfthyRad44OQ1M0bwCprz7beB9luZOUACzhqse5vQx90
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5288
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 10:01:52PM -0600, Alex Williamson wrote:

> I think the commit log argument is that notifies racing the group
> release are harmless so long as the container is unused, and releasing
> a group with active container users would be unbalanced, which
> justifies the WARN_ON added here.  

Yes

I changed it like this:

@@ -327,6 +327,10 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
        struct vfio_unbound_dev *unbound, *tmp;
 
        mutex_unlock(&vfio.group_lock);
+       /*
+        * Unregister outside of lock.  A spurious callback is harmless now
+        * that the group is no longer in vfio.group_list.
+        */
        iommu_group_unregister_notifier(group->iommu_group, &group->nb);
 
        list_for_each_entry_safe(unbound, tmp,
@@ -413,12 +418,6 @@ static void vfio_group_release(struct kref *kref)
        struct vfio_group *group = container_of(kref, struct vfio_group, kref);
        struct iommu_group *iommu_group = group->iommu_group;
 
-       /*
-        * These data structures all have paired operations that can only be
-        * undone when the caller holds a live reference on the group. Since all
-        * pairs must be undone these WARN_ON's indicate some caller did not
-        * properly hold the group reference.
-        */
        WARN_ON(!list_empty(&group->device_list));
        WARN_ON(atomic_read(&group->container_users));
        WARN_ON(group->notifier.head);

Thanks,
Jason
