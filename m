Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BF14193AB
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhI0LzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:55:24 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:1185
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234090AbhI0LzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:55:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QR+ukMaWVYEdFxl3dRbols9f/kOVndH8qHat59JNAoojxCy59JYHnjh84M8IZdIS/NTjIoVL+UMPvxr/dK4/qZssWIc+ioqQB461Laku6FGlMtAVIWv/QAn/PVX51kwUymuS5wWZ0bboPWbSTEB6igSWy4P/L0EM4eubv5WsJBFPiEdch/5BVox0oLJW6FckBQ6esVCTq9IO1BwrAi9DTYVaHOvafoV2dywVVFYlGvBJse03ecMAzTcdvGlQCmoyGP/PvZIZd1tjj3591USYcM1VIfIGeIf2WbuB6Q9O17ci8+L7PSt1MROiy8lHowy2V07+afyrzVSLY3wevZRo8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QH49u+y8WZKpdUMUlkCl7kjU/KqxzazBL4sNSYFI8KY=;
 b=mLx0t1hPPhJnvZuHmaU2A4VOPHmgKt0Xi78K4Gh0fIJn1RNUzU06FK/Pxn39CsuNfoRf0XqKH/gfWeZN64gNUkdR+MRZBY3LO4pLBEBJdTYfIbT7x/PRt3G4Xlc3ylK2ZHPFC7rLwzCVlT392cgd7ZXs3W2lXP5MySM8v2cHiEwkQPHDTa0HRf7F2OmZUuhYhfkELIhmairB1YaZzXjZPWeqyA/B+3A0GTjcU8nFb2BY/PIf+DW+j2ukRRpisE/Okf6F/eG7pgvtelvZE8K+7e+H9T8x1beoQvVMdXMpLZ5FAKRdQLH5ucEA7OEEqxnSpj/aypYH8maL1FycU/WH8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QH49u+y8WZKpdUMUlkCl7kjU/KqxzazBL4sNSYFI8KY=;
 b=UeMpWLKTdXHW6NZWU3HlzPoFhIY+BPMumJ7clqXeEaiPIJ3zoV+dxy+fbMbuyabgb+Rc6TQIBiyTVPShMxzsFvqRBMACXv/f8PHSQPtMVwaIXP5ge1Ea9ZGVFrEkGJvcCqqhVvSSA46+/T4z7Jfk9hGZDe70uB34Ujafh3niz6qZfhwsydQycoEYETmykM0uskr7YW/RQAyvON5B7p87sqm15E6ASQJNHzZ2h/211xaULQ8xJsEd1q+o1YTii+ZtszZFVP4bfu128hyoMZiD/oWtms1h5nvoMOZ0N+y1OjpYLMhIp762QYW9LxTrpCFOv8IAsP2er+LrFxBNlqbPrg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5364.namprd12.prod.outlook.com (2603:10b6:208:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:53:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:53:45 +0000
Date:   Mon, 27 Sep 2021 08:53:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210927115342.GW964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:208:c0::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0014.namprd05.prod.outlook.com (2603:10b6:208:c0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Mon, 27 Sep 2021 11:53:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUpCY-006Ina-SP; Mon, 27 Sep 2021 08:53:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6213eab8-8199-4432-089e-08d981ad752a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5364308921A853EC827D61FCC2A79@BL1PR12MB5364.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dNS9cXqFwY+I3669B6k+NZl/QlWWET3XsAZVGmgOKSnRSytO/mThMQkG2NbfQ3mdrf/lixQcQV1NOHogVT47X+uVAJq9+i+KdDZLmx3PG/GnF71whoRLu5cfQ5sE3+TNQnImRh12vOvOP+4YeIM9+0cTABRxhEyengGNswVIxEYOnPaRiS3jAGHRjLvNN7Jgq5z9ozJKoZIAVmR2Z9lR3ngwIu4sf249qmLAvL2Yvw+a7qXUZUFsQLq3Bxuy3BZDEl9ApN41CyJNOg0K25NPRaZYWTsC4V+4NQM9qNoOlHDrSM9fIanuzzsex6ftp8mqYxVHExxmh3pQChpWTJ75lsLLN04ijLwLCmkxZwuse2FHVGl3sBwhMgeI9ESTGF1V8HHvdT5Ftj9GfuqeXXYNg1KkVC4mSK8/ic4hr2rMADhuIZ3uMrKn6Kk0P7BIOOzu3N40jO5I55OoTUBzXC08CobL4WS6xfM3ULoMzIo5xlhRyFGVNVbfXgrfFmIwnYJqryzXyv80kuon4VMWNwrOWGqgOgWAvCRI5wYV84oH/Yg1n/3IurqePGsY9ZrtA4NvIk5ZQX8Myo6K5TqL1CGGKwyhOzAPZoWWCNCULcI8m9HD1bOa7JAP0wCraqeN06/pFIW6Dqrl5QJDKA14dGD4eUfqH1KTvsD4FtfZONHPbpN9m1vcsDkufNdlUxJb0q3O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(66556008)(9786002)(5660300002)(9746002)(2616005)(508600001)(186003)(66946007)(426003)(66476007)(33656002)(6916009)(38100700002)(8936002)(316002)(26005)(8676002)(2906002)(83380400001)(7416002)(86362001)(4326008)(1076003)(107886003)(54906003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZWVIegM9X31QyTp8b0XTMayoDgLvnBsOYjci9nzlj5ieXkC+FQygcGgQ43AA?=
 =?us-ascii?Q?zKQRmSzy2+WNDL+I09+TZQ0eKSxa7VqfRO6IKnMlabswVJbOL7Eylmxj5YIF?=
 =?us-ascii?Q?oYvEYE+JghTXhSOru67HxsKTyQBkJMBJkP+fP/zakBU/EHUvSyOhWvc0STIj?=
 =?us-ascii?Q?nMHofy+EzeG51KSCQthPkouQmP/4z9vY3kWe+HeItQBzM/PEyxadT8D3qoCq?=
 =?us-ascii?Q?t9ITpd7xL1DeRPS2W+f3jWERVbRGyMnN0Lijnh+PkP9HHKYmHRRleqqp+4nA?=
 =?us-ascii?Q?U4gXzIsR1tTyQDhjoqUaTPOVoEFfbwlRqzwjdBZv+Zai1rtQ3GyicjfAYFJJ?=
 =?us-ascii?Q?xgCT08JY5LpcN6T8Qhv/ExSdUMl8StRAMjZKfdbhm9xWj+7Uu1xNdwOEJbmO?=
 =?us-ascii?Q?HyeIFpPlTGvSn0Mj3R55enusM+oQXaSSwDfcuzr3tVSgMCggpyjHQKNA5yJT?=
 =?us-ascii?Q?nMJKA3v/3VzpIFCjLp7n3yRt33FOlmpt03U/OwERrzk819KtVGZybjMx1jY1?=
 =?us-ascii?Q?sXzV4+7juE9GeUNegZLuy0tjq3nI5xQNOlUA67lBLc+KPOJFVdnzZIGL28Qm?=
 =?us-ascii?Q?qIfI2Cz3hM6ZCLCZ48GdF+c+U8KdKOMKIkPTonuWLFou5sCl91qYEnisewbv?=
 =?us-ascii?Q?gf5e8pPDYOSdgARyEnf3Jl7qezJCNEhFwHm16usPfVjhgU2shD615g5bzn5r?=
 =?us-ascii?Q?9tGTb5N6asBMBppBgJiraO7DENFQ6AlLdaRaPR2hd4U/1IfrlOLa3CVdSTln?=
 =?us-ascii?Q?kVapgkD9Wb2iSWkrLUal5UJpjVbJSp5i+m19uKtaeoyWHM5K7QoEJ0hh4hvY?=
 =?us-ascii?Q?MsruTho2GpE3LKbfaQOV4/wtgBSTz1vy8wo7cucU26dymfwc3DabdbdhaUtW?=
 =?us-ascii?Q?6C49Dmes1iLgc4D0Y7YV5BRJPdaGV43OvWxZFVphAAPx5WX+JA7RCJoWk/v1?=
 =?us-ascii?Q?1rpRjIBiffGr0XarX2veuF79/DnyZHcpSdiC5tmwmneKyIcwqiGiuquT4YvO?=
 =?us-ascii?Q?DkiT9VZ3TnnrTnfHYblI8ofv0owgP6OhY3Zx8+UGRZn0N+aNzZP7v478Zc1f?=
 =?us-ascii?Q?+pbRHoqlc8OvwQPqe0lOSClTcpAFs1GJ1kEsfkqAJtNj+H5hbenql/TSqw7K?=
 =?us-ascii?Q?Le0LeRBi5tZpPvbnFw5CUv2wQv4ZqhDLJ2UQJ4q0WsKdH1SrL6WJfY6DUk0g?=
 =?us-ascii?Q?mhO7f8Su3IrbPQaUq8ZBld7kdXajBtW3nyOpDe+IwV2mYPGJFadQ3NzGZnSh?=
 =?us-ascii?Q?Xt1itudR1KBkgUD34a6S3IDgcv/v0QZfHDPwHMS6PH5ylOaC36A2S3FT7+9C?=
 =?us-ascii?Q?/BwIxj8e0m50MfiyhRL9sQzH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6213eab8-8199-4432-089e-08d981ad752a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:53:44.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoGoRDAGYrkZzvqZqWS49GO9HJv03ReIdNmGSN2jCLhv3wf1ZqK0JXVuyg1cl8QJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5364
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 09:42:58AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 8:40 PM
> > 
> > > > Ie the basic flow would see the driver core doing some:
> > >
> > > Just double confirm. Is there concern on having the driver core to
> > > call iommu functions?
> > 
> > It is always an interesting question, but I'd say iommu is
> > foundantional to Linux and if it needs driver core help it shouldn't
> > be any different from PM, pinctl, or other subsystems that have
> > inserted themselves into the driver core.
> > 
> > Something kind of like the below.
> > 
> > If I recall, once it is done like this then the entire iommu notifier
> > infrastructure can be ripped out which is a lot of code.
> 
> Currently vfio is the only user of this notifier mechanism. Now 
> three events are handled in vfio_iommu_group_notifier():
> 
> NOTIFY_ADD_DEVICE: this is basically for some sanity check. suppose
> not required once we handle it cleanly in the iommu/driver core.
> 
> NOTIFY_BOUND_DRIVER: the BUG_ON() logic to be fixed by this change.
> 
> NOTIFY_UNBOUND_DRIVER: still needs some thoughts. Based on
> the comments the group->unbound_list is used to avoid breaking

I have a patch series to delete the unbound_list, the scenario you
describe is handled by the device_lock()

> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 68ea1f9..826a651 100644
> +++ b/drivers/base/dd.c
> @@ -566,6 +566,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  		goto done;
>  	}
>  
> +	ret = iommu_device_set_dma_hint(dev, drv->dma_hint);
> +	if (ret)
> +		return ret;

I think for such a narrow usage you should not change the struct
device_driver. Just have pci_stub call a function to flip back to user
mode.

> +static int iommu_dev_viable(struct device *dev, void *data)
> +{
> +	enum dma_hint hint = *data;
> +	struct device_driver *drv = READ_ONCE(dev->driver);

Especially since this isn't locked properly or safe.

Jason
