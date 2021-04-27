Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B8A36CF84
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 01:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbhD0XVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 19:21:23 -0400
Received: from mail-co1nam11on2063.outbound.protection.outlook.com ([40.107.220.63]:4801
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235423AbhD0XVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 19:21:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kakCWnlOCNQJVun3RYvka8UN43O8PcN0X1KDJqhiqE+phi5YMKSKCW9lG0RNIFYzjGHyYcoOR9Z/uXJ+OAlUualLWW/1IZ2h7ihB13Wb6FKqGZ+0VZwK3yRUuqtmHdK7CXyz+DZr38nefYW/G4y/h33kHyJOQ7xTBoCBK3simpEfHbtEbfpjPl3Im4wg6OgvsHahrXeq9eb7i7D4NLcR9PDhUjLte1+C3/+PJ9/3dtqFxbExO68gZpKOTYUOtQCQZamIAsFFjsU96MghGjCd2Yv5xdrenCW17vRhLW41im1USgqYBD+1pPLmeAwDbUsg+4oCwnWFxwFRtYqcFZ1StA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukL/sdIoxvgDH6gvJOgjSeOUQhj9CQ/sOEWYtfJcFVY=;
 b=CZEzlZ0LKKclrW6qV3v1SiCYVP43X+5SkyLZPeynmzYDtMiAH7XiFZ0BvmeXduI9jAXRyZtyo0H1S3G06mgS3AQvNsCqY65CSzqAX1xgLclUJIlCPXu1KnejjjcNBVd1nqf7E1SavfxqOMgR1BMSkMwgJyL6EID7TZGVs/7Cxhxn5HbgBNLlrZ1cwFRb742JUEysEkmtwe+I1fi4b/kkhvVY1OIEXeXojRRYoN5xAEc2Ski9xjP9ztquXjc403a/YPP6JMdbgXh9B/+hPjt18QW+1X/cucbdS19UjT5D0So433CBEaYzGELAblEWcabE8We3a8d6QgQmJKdW7QfLsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukL/sdIoxvgDH6gvJOgjSeOUQhj9CQ/sOEWYtfJcFVY=;
 b=PxrzEKF9I/gD5MWH0h/cFx857Dr6IK9Snv2N/oAZCjglwdj7XhTWHug88Tt/yiKs39oULvpMcxniaom3s7oi+kJ4+ChFGnqE0kSfaHiFlDETT22qI+o0hupvUID9DGFWouck3hEhHV98p60nlTxlVmGVZD+7vXcWLbCoUq+AuvFrkM6dBzgvN/o11PebuxZvz8f+DO1g3AOHaTvhTCX+aysUw8tUXujuJMA8kRRiaEAlKtY0DNL2vm3e3Z5sEEX4FzlQuAhyDnX7qtb0pGSOkGIBOraCMKpHCNNNdY/ZoZaRyaaGYq/sCmL1v303aV9EHMAz2qUzIlgWjXk/yQsOjA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3514.namprd12.prod.outlook.com (2603:10b6:5:183::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Tue, 27 Apr
 2021 23:20:37 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 23:20:37 +0000
Date:   Tue, 27 Apr 2021 20:20:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <20210427232035.GM1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210427143227.62f304fd.cohuck@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427143227.62f304fd.cohuck@redhat.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT1PR01CA0106.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::15) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0106.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25 via Frontend Transport; Tue, 27 Apr 2021 23:20:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lbX0N-00DnqU-En; Tue, 27 Apr 2021 20:20:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3dfeea9-d2af-411d-b9a1-08d909d31089
X-MS-TrafficTypeDiagnostic: DM6PR12MB3514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB351459DBEA09CA8A10FF7BBAC2419@DM6PR12MB3514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +DSqurPFGgsalNmrXFcGBXo62V90kBQLhFmo5elm4KOlJ8ZG+utbQ32VE9DJL6Mf5wAhgmJgCs9/lrVXLg9iwuk+UjmByJHuPI2Vzxow2lwcO9DNQTcTqKX5BKUzu3voFGT295LZhUjEbhinNlBUqxdJJc5B2JnwGenvmMWTShui1M4Rj7BfgB91yYt/nwbsPwhIKhcWBVMIr0sOgxOfFby0zwYlU2YNBv+cZ+nQifTg3VS6tKjiq9otmFfozHQ3Isd4MSUGqaJLQxJE/n0GI1bUmrabUO00YepWUpSDUOK9IIA0TxiVEq6MsakWQbDBl3rpbfj2We9S66193b2yeUwc8PZ/MsKuYRX/mf2L67z8QEIuuAgKBijt3OS0exTyFdEDn+U7Q8kkAUL/DR/Ms1Id5hXHJRyL3sHKjkQG8jjBEo5bSGeA5wygAYdEqg8z9mA0W1SW2UIbQpW6mwkKTZilj7rCpDuBsg1wAfh0AAodqQhrHflnbAN+pCLton4C1Xc37fmCTj8ZWWQfml+aoxYulbQfnAEndjhcch7ujGWqE+/ZhbuDp894LedcC6SjBUKfZDtCnUxZOGrWldAU7KXtNWWvRK0NpiGMFSS/wto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(9746002)(9786002)(83380400001)(478600001)(6916009)(5660300002)(316002)(4744005)(26005)(426003)(86362001)(2616005)(1076003)(8936002)(66476007)(2906002)(8676002)(66946007)(33656002)(38100700002)(186003)(4326008)(66556008)(36756003)(107886003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?odMwqjTAY4ZJ7e+QYEZiPXqnaN3qGwnnXkH18vEcert6zrWvORMZx7zTFo5V?=
 =?us-ascii?Q?2kTAChipQhL2/Pk+6kECQv+p2ysVPbU8lpTke4z58LTG8eIv4oQ0vrqot+ij?=
 =?us-ascii?Q?SmNlNmPG5hmK04TJL+QrmuPx450MMMyw9CqMlLmJaaZjza3esu2C4ovUIadj?=
 =?us-ascii?Q?cTQaadp4pgmEsb4+c7H8oyHehpBQm536NdWFd9JW5X9GxVEjcJaPY2c8rGaS?=
 =?us-ascii?Q?ZJfMxknzFDxgdY327MEIdw8qx3aqfgXCCt8HDSBOc+YYKwWhRiT65cExUk5z?=
 =?us-ascii?Q?6dl8t5rTOzmsRL/f4xR/JyjJQNRkaN7fyfe7GOM0sFqxfqDuQpn7F5p+3TwP?=
 =?us-ascii?Q?1V8fhki1Kc2ceqGSpJXubB66eZPIvgWyyBQdbfsWNobBVAvBDlBH/Tqsb0my?=
 =?us-ascii?Q?f4TVxGSbbN2AFZMSr0rmiJTIw0YIuZnpHBmKyaM7Yd09b/3RWvd5VuiO0zPa?=
 =?us-ascii?Q?MGNoU2W47/TX9SZPIyL3EK+H862eOLNSIJ1EfzuHE90QV594RF+WyDbW20GS?=
 =?us-ascii?Q?sNEw6Rvho2zsFdORo7XvTDnpxUwhIGyCJK/kGkHedX3d9T8PHud4poHbnDL7?=
 =?us-ascii?Q?O/GPIT6jXQfozPxQgk+/F7eskGJphqQWdPDRc2gMGOzFbPWkcev//2esi1lE?=
 =?us-ascii?Q?v6EDWtRhuRlb/VRJMnFouFM1gD1u9ZC5hWwfsd2igR6AO4ZqqzoRfJnzwtdn?=
 =?us-ascii?Q?p3aBUiIU7YNKGaiRqjoqdTpU2KwGTzKbVg/2Hcyj9va4Q3iutq3I8qCeysgI?=
 =?us-ascii?Q?y0Bmg26qk039iwiGNAJmIHu/hpQD6z8MTsnFZ1aMuZERj7Bgc5le77/L58tG?=
 =?us-ascii?Q?0MZkbCZsnqAT/1+10mt/uXbdiunzL89IaDvM4gzfgFEHcwWXkyVhLNeTo8ml?=
 =?us-ascii?Q?F3wnTb13mnB0B4QXZDq0CuFMrAaERxZUPvhRUk/FqKXjO9DxIdhTmmUDPJ5d?=
 =?us-ascii?Q?iS+QOhcG145k02KHRJ9nWF1DHLW0esAs5RFCynyxJ09HeSR24/oF+LxQhfL6?=
 =?us-ascii?Q?4jTLhTfINp0iqFLf/pwV6pu8VQjJEtzlJxquEWehCrp081WP4WNluKTPqSjk?=
 =?us-ascii?Q?CpfjItAjfZ2gEufLgg+Bz87bPMI2EAp/uz+WTp5ae7kKDpnwsyZkeC3Pnk7g?=
 =?us-ascii?Q?WjYy7lFlNtD/9evLCzolX0ctMiHcJb6E9hxmY8+LxJdxROrfG+CvfA3utWhB?=
 =?us-ascii?Q?0ajuTl7PyTAHZ456ZhXR5rgmWm+gfj2Q8QCiFIJpwLZK1Fgez5j1NmF73bTY?=
 =?us-ascii?Q?mEIKtgTYA3w7LwZsKODY/IkbM/Y2Gliz6j0KpeS8cbMWIerPzoEMfzQDJZRk?=
 =?us-ascii?Q?oz1hG+AGy6+25IMa8LcFPPvT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3dfeea9-d2af-411d-b9a1-08d909d31089
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 23:20:37.1825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44rrIuLuw35TwgsC4hfyex3FftXzJobU0O2c0ay9nSGNLPBEjuH/mSb9HaqfvijV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3514
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 02:32:27PM +0200, Cornelia Huck wrote:

> > +		device_unlock(&mdev->dev);
> > +		ret = device_attach(&mdev->dev);
> > +		if (ret)
> > +			return ret;
> 
> device_attach() can return 0 (no driver), 1 (bound), or -ENODEV (device
> not registered). I would expect mdev_bind_driver() to return 0 in case
> of success and !0 otherwise, and I think the calling code does so as
> well?

Oops yes it can, I changed it to this, thanks!

@@ -269,7 +269,7 @@ static int mdev_bind_driver(struct mdev_device *mdev)
 		}
 		device_unlock(&mdev->dev);
 		ret = device_attach(&mdev->dev);
-		if (ret)
+		if (ret < 0)
 			return ret;
 		mdev->probe_err = -EINVAL;
 	}

Jason
