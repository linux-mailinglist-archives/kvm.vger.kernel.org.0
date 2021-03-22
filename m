Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B627344C02
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 17:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhCVQoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 12:44:23 -0400
Received: from mail-eopbgr770045.outbound.protection.outlook.com ([40.107.77.45]:58333
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229931AbhCVQoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 12:44:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uw2jOde4pn3XXUgdYpJ2odkFTKy2ZJJd9h6ugLOELiF5v463WvVlWg7dfXsWc2/LJBP3e9WQVO+EKfPag3sdqVXmr2xMm+qX9cTWs+r6XEjda4m5bYbl2wkuGllWBTgz38KT4US1gPlG+ix4DRiIhhtrCSw0BowlwK4qK0R23gQMTTdVX9R+65z7/ySdJmTqrd6cS6CeAamcTWcoe1/S2gciyvOSfTDOV3ux+YpEVcgLgfqU446hQsa1/aXWSSpB3ZD4DSQrBKFzdai58zoAKaLzFZ/foJfSX12/jAQexjaNzaJowdbgxMUoKZrKCSotPgGKsdnXqu2xp9xoHDFoPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAdpQdqFv3U3a4Rdp6NSROuvDA1vQ5RHZJ/RflmPmRc=;
 b=j9idK8sZCqaQn4vmT3HsCn+DEdlgMlRrTHR6zCcTTWzv+7Q/M9Ie+yeRoC2J1DY2c4Vk9t2zI1cE7cZs1gH2/CBRM/01JEgg5T8EGL5XghtEGvf9bW7qodYusDNSn6mHzYkTBp1+GXW/ggyoki0CIegOtRnFUNbhNbeDqB3nr5TJiiEx6QxceU51rHStvXLqd9ukZiAiRx1YCGBLQhTL9CDKfkFX8J/psRRFP7f7+JyufRxRMVMHlyHi0k1Z2j6NHX2KVzDsJGkSUs0iUv8gILzyMC7l9xXCGIs1BUp8bn1kh8go3ijaWGBNqURQRiLh2znHYUf8GprrLCoCbdYJ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAdpQdqFv3U3a4Rdp6NSROuvDA1vQ5RHZJ/RflmPmRc=;
 b=qhBXsPbPjbHwjHgA4sd13wit7G2bcYz7ydoR/7dZlOJHEVnViXPEeceSGXcggEnoeJnmi48+Cw0bbAPFNE34Swth9Bbg+JwmfkISaFdXJQMw7loP7WXZMkOR0SHCNwJZ8C/LiT4F0+uIoMNPSXRnKJvzXUDxPsT9AN7ZzFLcyZ7SAZdVo6C93DHFCaw634FOqGCXTtZuCSp36IlDIym+DwfOp7SE2ZYjp/2Y4KJhaZGXPtETBNRMSoSdX4cGaHKS1FUzwDggL8w/0EsRZKnNoYzsHwdaNzIu2tYI5tC8UooOscoML7CVEqRsko/6Q+8YBXoRprHp9FKAEhWQ1yxA3g==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3931.namprd12.prod.outlook.com (2603:10b6:5:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 16:44:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 16:44:13 +0000
Date:   Mon, 22 Mar 2021 13:44:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210322164411.GV2356281@nvidia.com>
References: <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210319092341.14bb179a@omen.home.shazbot.org>
 <20210319161722.GY2356281@nvidia.com>
 <20210319162033.GA18218@lst.de>
 <20210319162848.GZ2356281@nvidia.com>
 <20210319163449.GA19186@lst.de>
 <20210319113642.4a9b0be1@omen.home.shazbot.org>
 <20210319200749.GB2356281@nvidia.com>
 <20210322151125.GA1051@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322151125.GA1051@lst.de>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YTXPR0101CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0014.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Mon, 22 Mar 2021 16:44:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lONf1-0017pA-4L; Mon, 22 Mar 2021 13:44:11 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8eea2d73-4efd-46fe-3620-08d8ed51b941
X-MS-TrafficTypeDiagnostic: DM6PR12MB3931:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB39318C63EFD993EF29C8F845C2659@DM6PR12MB3931.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RK6726gghBLeGGYfkEncgec0hkhdR8MhIZ9kFL6xAYG7jMP2XuXQU5cyH8arAhF4ms3JiAkPSfW7mYR5b63NaZ4TvjOLkaRFmh85GMiTBqRiqMHFvQ4T3kHjMl69/C4CVjPe1lVEz+IxHDECsrOklNXKuU2Len3m08dONMF8PWcDqBDZsGxoimUPaChCmYTqeUGaMBtF5F/lCIePiN/hxt8Vfdub8p9yNDXnZkWtRnKE4tTHB3sypIPw1vdw/BEBW9M7rRbstuuoFrf9sMLVfh9TeogpHcfXMX9Pw4lr0SpL9hTEuZoeO/n9Bey+PUm+qrzzLccK7/qWouikDBW8rIFEnJm7I47sQg1Rn7WVtHU9nQhLGTNOv8dOANjAG/eJpmew9vNtk3Fp0MQynpS4EA57lzOOytVNwUZCP9vh++W/J0T+QSC2OV8FuhMXXEf4WxIClkQKsMqtTHOx2vnZJgITuwMJkl7XeDemCjCtToPCZ37fKeZZi4T2G2CcJDsoo09ZSxKJLuD5cD/jiyXRqB83YBpPMmPZHMHtFfuUk34hZWa+SPzd/DvVTmpvYda7SW0U+kEYyeDQ5WTE3GqE3mGge1aEv0fwiJKAHNBaGCgMhlLesyxUVeXuZMf8zOxAgnd2HbnnV4UzyZlOjA6B2pu3sRPRhetUMILW7Fa6y/g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(66946007)(26005)(9786002)(9746002)(478600001)(316002)(6916009)(38100700001)(66476007)(66556008)(8676002)(5660300002)(2906002)(1076003)(4326008)(186003)(83380400001)(33656002)(8936002)(54906003)(86362001)(2616005)(36756003)(426003)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rkGLNoM1Zfn8e9enKe2P6FnsVdyDCAQ5KKaoeUp3lznIKqIBcYzFcDwlscHi?=
 =?us-ascii?Q?5DMONXmdwgpu1nzjTA05Or9Dd6fpMxowInlQzT+tGEZ5pW5AYKWkYvfT8dlS?=
 =?us-ascii?Q?NxtOwKMv3/9mlv0m9U4U66GIvY8KvDVgmphfmCOw4CTpvcTeSF54eXuJk238?=
 =?us-ascii?Q?5hU2pHGsvFKh7m1LXjygUp2JUtCj2dBww61cSnw/x7ge0Haxv+FQR0MoQ97Q?=
 =?us-ascii?Q?d3cR5q3bDt6cKp91kWOk3S4PboZcGR6M7hi9oBeTfh6DXxIgPrjrz0v/IqmA?=
 =?us-ascii?Q?zjXVM55qvB7IO1HqBjtiHNH6Ci0a4TnONd6OlTajvIJja+PablXgni2zj9S4?=
 =?us-ascii?Q?/OsVRHxhCRROdmFjTFdk0EkALmPbeamXILpBfWXEseyyaTLtNfe64FSZF2bx?=
 =?us-ascii?Q?K47IjLDE5qeqVPdKJSiM8Bg8nTZT/8d4tyRMoQSoFYuzSgubxywysXRHfc2N?=
 =?us-ascii?Q?KXUb1mhdzkgH7LPCc3u71kW+QcK0TFf1B+pnTNYJKCPMXQ42YKr2c+m+GPGM?=
 =?us-ascii?Q?hfiWzN/ys85nrH3Zx5/ULVgoXqk68qtVnJgnkqobqWkHuCguLWDkZqcVDKua?=
 =?us-ascii?Q?HjmGuUwxysBNvigoBNutBJLEZ3ZMT2R9wsPGHjwHTEK1UVBsPz/KtUVYZfIp?=
 =?us-ascii?Q?XlNuZoPkZmoXoZkf7KyW6lw0l5TDqlQttjSBozJImjJDnTU3UPxZo2TXqdTx?=
 =?us-ascii?Q?CMxF2PSEW7hTGXlDGm5T/WoxiS1rBHCkmeyZzIOIG9wuvqLIg3rPxS45VsPE?=
 =?us-ascii?Q?K2oghrri43LevnfVneMvVzZhEEqxcKXKbVt4F99KjS+A70r0gxxbhB6Hb0ab?=
 =?us-ascii?Q?c+pOcqMuhpIVb5rH9a9AoqjSNfEPkil+V+W+7fIs3L8r59FB/oBsV9r5V2Wb?=
 =?us-ascii?Q?PwCG4iKwi0RggiElYw2qQQ9x6qb0/PIg3ti991DVPcW87I8xgL2UHI4Zq8Mg?=
 =?us-ascii?Q?FDLPEjIuE44eE0d3u5EPP+yY+79SSz2qOTxnW1dQIgzQC4YCPrD9W2xSc7h2?=
 =?us-ascii?Q?mdoR93peYmjosYoNBT/abeA6ajMmPP35yJjjfsIlA1diiXOyemkh7xxtVzGL?=
 =?us-ascii?Q?IO+UrWxp/yAuKDGl9WcSldsxatOnN27r+4HfwKzj/iTOUkelnjhcSlwcs3qK?=
 =?us-ascii?Q?TDmYaWaXX0i0E1bvapUD8uLKXbrlxmVsEXgE2Vt4FRijAOfGk7XTygFTmj75?=
 =?us-ascii?Q?QpzbFgUiuXy69X2vUamCYDnUf+oHMySnTc4FD9l6SKLqd4R1zJpr+VTrPjRp?=
 =?us-ascii?Q?/e+RfoxwOsFom4PtlmvDp5wWslLk1UxNPp7G0kuntiq+zs7la//Y46tuuYs9?=
 =?us-ascii?Q?Tnvl9DOExHbqP0EkKQ0GDvuC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eea2d73-4efd-46fe-3620-08d8ed51b941
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 16:44:13.2965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlMW+J0vOzdDZSKOuvkjtiMLFJ2NGARy8E+jlKte2F0Qx83khHfbIQCovsZutdBN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3931
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 04:11:25PM +0100, Christoph Hellwig wrote:
> On Fri, Mar 19, 2021 at 05:07:49PM -0300, Jason Gunthorpe wrote:
> > The way the driver core works is to first match against the already
> > loaded driver list, then trigger an event for module loading and when
> > new drivers are registered they bind to unbound devices.
> > 
> > So, the trouble is the event through userspace because the kernel
> > can't just go on to use vfio_pci until it knows userspace has failed
> > to satisfy the load request.
> > 
> > One answer is to have userspace udev have the "hook" here and when a
> > vfio flavour mod alias is requested on a PCI device it swaps in
> > vfio_pci if it can't find an alternative.
> > 
> > The dream would be a system with no vfio modules loaded could do some
> > 
> >  echo "vfio" > /sys/bus/pci/xxx/driver_flavour
> > 
> > And a module would be loaded and a struct vfio_device is created for
> > that device. Very easy for the user.
> 
> Maybe I did not communicate my suggestion last week very well.  My
> idea is that there are no different pci_drivers vs vfio or not,
> but different personalities of the same driver.

This isn't quite the scenario that needs solving. Lets go back to
Max's V1 posting:

The mlx5_vfio_pci.c pci_driver matches this:

+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1042,
+			 PCI_VENDOR_ID_MELLANOX, PCI_ANY_ID) }, /* Virtio SNAP controllers */

This overlaps with the match table in
drivers/virtio/virtio_pci_common.c:

        { PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },

So, if we do as you propose we have to add something mellanox specific
to virtio_pci_common which seems to me to just repeating this whole
problem except in more drivers.

The general thing that that is happening is people are adding VM
migration capability to existing standard PCI interfaces like VFIO,
NVMe, etc

At least in this mlx5 situation the PF driver provides the HW access
to do the migration and the vfio mlx5 driver provides all the protocol
and machinery specific to the PCI standard being migrated. They are
all a little different.

But you could imagine some other implemetnation where the VF might
have an extra non-standard BAR that is the migration control.

This is why I like having a full stand alone pci_driver as everyone
implementing this can provide the vfio_device that is appropriate for
the HW.

Jason
