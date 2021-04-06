Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E1F355BB6
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 20:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbhDFSxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 14:53:43 -0400
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:28961
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234102AbhDFSxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 14:53:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuTSs3mTLlRZMZ8h1x7j5kT5Hrv8lUqg8gqX005/qOP/mTt2/9YUHvlB9MFMjet7vVZ2QyHuuI3ocvYekKpctQv5DFTRbunCUeYOHmXXJjoA4j2be8Vpo1u1bP3T5PFR/YSJ+vtrZpCaPwZP/QWEinHeQV5sy/Qsvz4vEjZPEuNOnEC1yJWwu1yxxSVCzdBxLJboiouA2viH7PmvKes0Pot8M5MPkhw/KqHSFE6AR7ClwZeTXVlMTLs/EFn+090MvkaYMKtaApkoo91UVBnhtfM6Nmqmn6+krQEvqICfLqFKcByqtH/jTYJDs2H4VK072/MaNIJJ7lFUnJe9dZYywQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYLI0KHwqmFro/B+C04dQHoFHwtnfHVn1wxrWpmIsNI=;
 b=d1UuwdbTb6+DHyvAO2REh7cIYMlcmI/g2tLNu8XFRe2MVOM7w6Ay2IrYrIouQf0UiOqqhzTMmTJNw3EhRQbBnWc35mLbX0ZDpLWl8z4MZqRZXlsEv9yuP6L+FHffm545G0tbO0vlGA9GKR9GrMczHq4THW/VD02XzNKQOEMmROFEf3z27PAVTBCfSCXH+y7G2Ugj9Gdk7+hHJ3kECl1dx84Og+Am0yuczb4AIfWQnmgLDRnxtp/V7HaSvPKon/cDoFjBYTzJjqtCO49rtWXO0Z/6Cy7m3hw8vrdykrE8SEWcO/w/S+KhCw7672CpFx83lP2EuZNrts54xTZ6yrB0zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYLI0KHwqmFro/B+C04dQHoFHwtnfHVn1wxrWpmIsNI=;
 b=nnxHjIqtp2tx7nIOQGDdrmdWiFDpsGQE6BwXmNa/gXj2NzAB7rhmhVT9OPtob24SVo0ulz/q0dB6AFSsL+myyIaN/b+Ua/EuqynZM/8kiykzSzPSjXrmrRowWZ0Dt7Qntr2acDODqF/Te2QfK/SbJ5TS911usl8Y8vaw7J+3Hr1Fh7VPNyJ2TddemQCxVkG6yoWxuwsbwYQg7JtNx85dz7TNF/P2axUgA6k01EamJ2H+d5+NgjfPdd+w2Fx3qxDRorQYJJ2qUMYoSHBEX9RXLJ7UAar3W5MfjXdjj7dAuRSN9KfY2GXoXfNCyHwSZ6Czgmu12tXjzTHzA3pMf5Iaug==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4796.namprd12.prod.outlook.com (2603:10b6:5:16a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 18:53:32 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 18:53:32 +0000
Date:   Tue, 6 Apr 2021 15:53:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 11/18] vfio/mdev: Add mdev/mtype_get_type_group_id()
Message-ID: <20210406185331.GE282464@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <11-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <20210323192330.GI17735@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323192330.GI17735@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0232.namprd13.prod.outlook.com (2603:10b6:208:2bf::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.11 via Frontend Transport; Tue, 6 Apr 2021 18:53:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTqpP-001R51-9j; Tue, 06 Apr 2021 15:53:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3b117e3-f3f6-4c19-565a-08d8f92d467e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4796:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB479660FFAC18B8BF5C1E02F9C2769@DM6PR12MB4796.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZFDLXA36+oisKp1aD0K6HJVkVJrUxWNceYZucU1uogE8yIVFdWNGnpjHBcsA6jREpB/y2QjExNJhN9+StbNKnWlzSAPNAtkmtiEk1GkJE+gJM8uevpa8bgUb6bJyqQvivfF4qwC8Fv/XchD5nP86mOB9O6eeS34juCaP+p414J1O3I9dlJkgQbx/TPBf6y5F+3NMYFN3t0zPlF7S60ns+8xD0Q4UTiuNcPTJaujhxHQCWhJkD34Na5p8VBOv0XveNOP+sA2UjZ8Dxuflm1KHf8+nHIUlvVZHIh3+xWkv5Hfc+SoYdrsZCUBC4S++yBbAvlxetuG6oPozCbr4BmdzcPjWMC7PAAooifIZcCDTKQ88RTZ9dUuhEdNg93s653gxO/KaC78IgKkRrCDPx7OYE6kmocr8kHrjo3eNdiwkaNZCmtCCHUWxe3URaVZDKoVIBVyqhjeqAfEVrIveAUjIrUm7F1snzZbqwyeWuWIL+g962bONOn8/atM3JZU2qY3FQCi1gua1MQuey//VteozEUe6POyFeAf3dWzi6v6CLT0IhyHZquOCG695iNcXV73Gpr+KDAOi60avznjwDOEoNI3QvXJAP5L7zvae0oXSHc7sT30FHEAhH9ZgRCIA9Qu5lMCEaENuBp1rpOQdctBN+Cc6tYrIfjNp2Kv8d0kPBae+7AV2biPUKBk3fyFqsA/H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(4326008)(9786002)(9746002)(86362001)(478600001)(66476007)(426003)(36756003)(6916009)(26005)(2906002)(8676002)(8936002)(316002)(33656002)(54906003)(2616005)(186003)(1076003)(38100700001)(66556008)(5660300002)(83380400001)(107886003)(66946007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gm2dSQp3khUBV3F0tBd5IdKDn1Cg70Mq8YkbUIDbLECwnUlKVoygfcDlpZ2I?=
 =?us-ascii?Q?a+YO/9wStOxooNE/Q7T5ryG2jkFulkwWecGS9rF58aKTmaB14+gCmCS5lgFw?=
 =?us-ascii?Q?SP6MjC2LJp0R8Ag/0yuxODgrmyPIIv4nJ0CNi8Ian+WEIRqtcVA2dkAaPul/?=
 =?us-ascii?Q?pfKRGDEQfZJ/XpPOyO/7nr6ZxeSTs10jjNYnv1ka4v/oi363irzmkOIl0TtG?=
 =?us-ascii?Q?bhqRegwbkz8q8nG2F8QHtnGoOAP5tv/nWxcVOWn+gGiQednK/OAvNq/6x8Ee?=
 =?us-ascii?Q?ltw/m+WhR09hc9oqzUNS/9qvb5RYlG4rw/tac633ZRnsm9Puf1iGNQGKe7lj?=
 =?us-ascii?Q?svXkppD/kg+M6je1Ji/6nco2Rd5Tq/KX1MRdMwis12anljUHcYGXIDfRVKJq?=
 =?us-ascii?Q?Pavo9xuCgILiovw9Kn7+dXtAg9TaFgVSBl9ZcubFPP9qjX9i7zkBF2or2eDj?=
 =?us-ascii?Q?8Ts3F+ewvhsYQyVR46ZaIRuT6ivC6nJxEeJ3FCZLkEqxEU562rdOhKUxtQQX?=
 =?us-ascii?Q?kFeg9F4h0W9NVzvw0NKYF8hbXt5E0x97ADF+6eX1Ccu9Uuo81zHYLGPGKCyq?=
 =?us-ascii?Q?UFDCpNNKdGdO6ZYgcxTnfsvhNiG8rBbbouzk84OUjoExepeo0owW3mlEF6LE?=
 =?us-ascii?Q?SYvG+pel9TCi2lwUM4A+MysD7aDRkLUj+MUqDtKokLKi3kqoWyoXLgRZNGi7?=
 =?us-ascii?Q?vm0HVDqemOWI7RMbCqgBVnkekYBkPTCMpgyFUTo1F0lIHrjCEiBSVzkOMWF5?=
 =?us-ascii?Q?5hw5b3cv6V4k+0I1qkkre9axtCyNBBE+22v+Q7+nB2EZINEiXAV6gxkaDcjD?=
 =?us-ascii?Q?qOVHKEhZ5072gUAURRIZoh5+9XA+hXkndsdxmLmhVzx3HeWyqAl2Vdt4zVbT?=
 =?us-ascii?Q?59RmBzLeyLwOAgHa3WcFnRE9/8k9GkDzWvZT08Hs8cKIma8gikeVuFUyfHTK?=
 =?us-ascii?Q?EZuNwjnl7072kjNlVafRzwrhc3/p7N8AKZP0aD/87n++kefM2ufJX8xdxJXN?=
 =?us-ascii?Q?jY4Y0i1XeF9txK2ERzzr1x0X4pT5ryjj/M5ZLRtWCzsKtK2oJBKFrNZY2/4H?=
 =?us-ascii?Q?9wqfJuGcs8I+J5kmkW6Rzxh+EHUJeaXWMI/4nalmlP/GjPkh1imdmzQfReZA?=
 =?us-ascii?Q?Qi3fWq4/aSy9nUN1Rkc9oBMeFJRS8ywKzl6LtLlQbwbu/xNatqpNP986ZbPh?=
 =?us-ascii?Q?pP/kfPQScILoq4VGuOFtbnjxlfvfz+VFvskMjigGZvWdMyyM7BIILOmevJ66?=
 =?us-ascii?Q?kn4Gkdq8y0b/6Sdz7lUrQ2cc+KgFkoE7xiWlAg3ub1fLad3qdV9klxn962PU?=
 =?us-ascii?Q?hKJOzJhGFzQPY3gUmk1yF+0l8xJbOauuFeu6XUx//UG1ew=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b117e3-f3f6-4c19-565a-08d8f92d467e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 18:53:32.5783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5a3WPmmPkKKHOwu59nAz1bixvznCJFMNPjd+UBmHGz58W2HoShdcQsv+YZ4soCV8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4796
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 08:23:30PM +0100, Christoph Hellwig wrote:
> On Tue, Mar 23, 2021 at 02:55:28PM -0300, Jason Gunthorpe wrote:
> > +/*
> > + * Return the index in supported_type_groups that this mdev_device was created
> > + * from.
> > + */
> > +unsigned int mdev_get_type_group_id(struct mdev_device *mdev)
> > +{
> > +	return mdev->type->type_group_id;
> > +}
> > +EXPORT_SYMBOL(mdev_get_type_group_id);
> > +
> > +/*
> > + * Used in mdev_type_attribute sysfs functions to return the index in the
> > + * supported_type_groups that the sysfs is called from.
> > + */
> > +unsigned int mtype_get_type_group_id(struct kobject *mtype_kobj)
> > +{
> > +	return container_of(mtype_kobj, struct mdev_type, kobj)->type_group_id;
> > +}
> > +EXPORT_SYMBOL(mtype_get_type_group_id);
> 
> The single field accessors are a little silly..

Looked at this for a while, and to fix it I'd have to pull in the
struct mdev_parent into the public header too (for
mtype_get_parent_dev()) and I think the two silly accessors are the
lessor evil at that point.

Jason
