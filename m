Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B71355B93
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 20:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhDFSlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 14:41:24 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:55425
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235039AbhDFSlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 14:41:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mg48I7woklYoBWBjCl7syqcIPqEfklhyJ0W5nc1A/k7D0EV5VyT0W8AJmIw/fSjl5Q30pFR245Rd15XHE/xNTPS2TocPVSP4CTCbTtKOK8hGPyrU01L6o3gGQ4OajLQ11eyy9AFbBCsFls0yPHK2X8xfz/W0ew5+dBpH7ioR/aSyUO8AL21GlKh9XY4B9+98VCkbXxfM9xi3Y/JlwSOFcm+BCMs41HsMXoy2vc3i8516tV/ueK7dluGqtE0qQtYAchk7gkI68nj/meAuzK1DaRWq2FkNTk+oklUPqhO6VoZLrRzeZlIJyzRMl+29mkE02LSyHkdn7v6Ao8S7viWg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+DxUQkh6KDqwIlfTxmm3HY+vl6npH7/tToJkctSQ1E=;
 b=oNwrcW6h/F3v9TrA052h+UONrShg0AexUayjSnU3OGzxXUeU4GUFefWemNUHtmH/M6oJqW7QhBjWjAnMAcnmFSoHfeUdqWJLST4d2ZwCywuO4fcF7gKcJEb2WwsqIGuWxArQgf8XV0xJ6RnBr7ptIYR9Qmo8d5xtLwGmnvuFxnYVs8XgVn9xy11dtV7I6SpZQsIJPE5oMslrH4H0aGBC2b7qoi0ZDCu5jralaAEYs1TgqN5EcAoceTHJqJW5OJMxK0btnmhHresoNyVvaooo1e6AQuiAa4dS7q3Ypq+HQVGNReGchqvUC0nt2IUekn0SuHAtdmvpIMIpy/lnSPLrwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+DxUQkh6KDqwIlfTxmm3HY+vl6npH7/tToJkctSQ1E=;
 b=o27efCVZdWkb9i+ltzeTvFo2EEZHxROk6dyFS8gkaCQiWfq+C4hoWlv28tOFHCBhyyXsqk7SbtWCpOQTnhRNIk3Uy9PguYxuSosrHJqR+xV94vDfx3BSB9Ss3YR3IDA7T0OPJWKuAsYFQuygsHbZqmfj3WKe1h7swg7WWz1GGn5fSxnTrYlSjbWEZesrgCN/kxUZOX+90AB6hxg0O2Bj5R8MXZ4SLLjSCQc0VM+LoLD638Y3LmW212TIvAzAs1DNM8dYQqV4iQWKM4ADXem0ygd9zFt/TO7PpU32Q8KRVTL1WdTcW+5DH7j5yhORboFnLaIDa8g2Me/E8hNkyIUheQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4338.namprd12.prod.outlook.com (2603:10b6:5:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 18:41:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 18:41:12 +0000
Date:   Tue, 6 Apr 2021 15:41:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 04/18] vfio/mdev: Use struct mdev_type in struct
 mdev_device
Message-ID: <20210406184110.GD282464@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <4-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <MWHPR11MB1886C79A69977CA40421FFA88C619@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886C79A69977CA40421FFA88C619@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0127.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::12) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0127.namprd13.prod.outlook.com (2603:10b6:208:2bb::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 18:41:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTqdS-001QVl-Cs; Tue, 06 Apr 2021 15:41:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bb3a6ad-d6f4-4125-4c43-08d8f92b8cf3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4338:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4338AA54DC1AC0D9CD495335C2769@DM6PR12MB4338.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: unJXVLBpFjYaWhI6Ux6nMbuogGxa50vQvycH8GYvlrzfo6mdfB5rNA+PfwAPm9x7PQd/G6Zj3yaxFdaABdLN2tMr5bCE8l+L25gGM681ZYjJuUtOXTldG6MUhAXmQqCc27VAviwo+kyQqwNfewXiIycgob0zatVviKwLshKii1X+ULLEgRlewr3q6aGPTgYwHVA6iLmAv1+inIs1yMlSW+T+H9JGrlZPyA7AEtad0Woe0YbyAuRCXR7yBDtmgkxZckEqMQfxEJnMWd6EmXeROnKLW9J/D7aXmTl0LwZ8DSqmRiG8avIRKxD9pOGaNbNxDIsaqpAjEISKbqHeA50SlLwzpgXeFQ/RmAbrMxqGu//2UezdrkRlojdhYBI5VN7b/ZL0TasGoNgJC9jcGGa2JbI3EbquFJ0VkEKii6/ErrjZ50q0EOTrVSUYdO81wdiOoz/JoI5vk9e6gIx79XLx4TZRtMomMgRmkhJmD0WP7IO53HsTOqA8LCfr6lP4PipETrux0H2+a8Hx9mQW0dQhpJHH3Y+Q6lX6ck6i935/melSx6q+zi8RuAl2MBFd5ImD+FqL9YhgA1jWw5Q9J8+A7WamAfVkOncnWsrsvpK7cgqvH3pn57Y3UtxcUhQTUA6RGUeZGJd2ys/s/Xd6x1YAjyDwioDDw7ivZwsrq1KOJJxUldCi/jeNe9VAfOjU6m7+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(54906003)(33656002)(5660300002)(6916009)(8676002)(4326008)(4744005)(2616005)(26005)(426003)(38100700001)(2906002)(66476007)(316002)(9746002)(66946007)(107886003)(1076003)(9786002)(8936002)(66556008)(86362001)(478600001)(186003)(36756003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?upyK+Eo8PSx63Rk2v8ZVDsAP1Nn9LzYC8dN851lXUVThFmqc9dJOu3xtxHqU?=
 =?us-ascii?Q?ZOhumZABQSoHNMdilg0/wxPCjLmv+N4220wB2Id65fuPFym8RFFiyPOfuW3h?=
 =?us-ascii?Q?9yak40UD+O+lctl4JMTDzjeSTaCWu9Kc2hIu5HPHToJRRhqLExZFzBf0Khlm?=
 =?us-ascii?Q?fl0d/tNS1ahCUXOVatNVY9TZ551rzxnn503VS1ZPf4a2BxxZBL5X7dyX2RVS?=
 =?us-ascii?Q?hqg0FGwIOpUmcSnV6gflyUZ8zCljZm/uCzH9jlnUTO/oPG9uRQFanyiHSJ26?=
 =?us-ascii?Q?xn9X3ZUz7BrHpXiFqL3nYkBRuuEgr5WXSZ1aUYFGih8g9puyW+aMC7IhtGZq?=
 =?us-ascii?Q?+wZAfr2ZiMKgb/xbi1fmmnl4zkTNk20bFrikTlMmkhLbO55P5tB6CO1WxN4s?=
 =?us-ascii?Q?wGO+n5kiP0eGCvYTxBEr/rQwbK5Yk5vgnDAeWe+FMUHCBtKHb/WHhDKekASU?=
 =?us-ascii?Q?ma1NHYULqDd2b386ZFCb+a9xR7o/c0dwkxWzqsUlhnvM3FQDyxXFnS/noCQp?=
 =?us-ascii?Q?8jNxNtE0Uy6ObUQCkTOOG0ezzbFhUT1BZS/p/VcqLSC87RUVJ+UOJL9yI7ZI?=
 =?us-ascii?Q?FMd9K6TlWC9HXCb1+6cnJJhRdXt72K514SCV+vzN2xrTctozsE6KnnUAybiR?=
 =?us-ascii?Q?DG3ZPnx2QqaYN6TGtiiS/zkT+gf1JLzlufsUtyEZHclYM+8rxIl6X7GInwzg?=
 =?us-ascii?Q?FDn595dK/B/OeIMygGGsEyI0gXzxbDOGzrmN+iFCau68q4369/UJ+bWE1DnN?=
 =?us-ascii?Q?jSpRaC3NBxTggb8l+WlzUZRLo1DzCS0A3/43fSeMhlV7gqtz4GCzIBL9aSPQ?=
 =?us-ascii?Q?JfDNRfA+Xm5vvFN2SUjEn3JNzblLOM9X2D+EOcfyy9nk0St2z+JpzZkXlzX0?=
 =?us-ascii?Q?t6qq9jWP8vNbwCDZOVRSJdZqImZxQVn160v2f5XYeBV8lBuWo2Ciq7YuUmne?=
 =?us-ascii?Q?CHkqKPSQ0je8+kAGml9FEBrT+8p3yctO0DQMhlTsOIK9I+EgL2rMQE4cx48g?=
 =?us-ascii?Q?B8/tE1ZMboUK+4sff/drCZTKkgczaDbyuQ4TliU4iahBPqD+jS0yTja0pid+?=
 =?us-ascii?Q?E4qqu8SuZPOtNPDq70AtdUrIDHKeVZQc6WmOzW3yZeVs/jO52bVmvd0PfTiw?=
 =?us-ascii?Q?ZixeHPrcjmJitOSt9mkzAr9Gx6pfynwuyGFLYJ8GOZjybdcTZr8i4IN6UagN?=
 =?us-ascii?Q?K9BkzGserxsnOSsDGB9SQqgq7Bc28uAbMxWfdttaGImEIRbph2VUHMi24Jea?=
 =?us-ascii?Q?eymsS6XzKE2MgwzIqZINoM/RaCh7veAWbmhzTgo8HJ/Y3ReScbNkc+GyQeyv?=
 =?us-ascii?Q?73K7jtnFrZNyvIS82267mtb5RkIXnOJQAncTLAsICji3eQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb3a6ad-d6f4-4125-4c43-08d8f92b8cf3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 18:41:11.8169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mR11+VPi779nW2QTTjHuk4oo6Eh5Hay6EXxUCgKWMthOcd4gXU6UZ9p5gXO6MBB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4338
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 26, 2021 at 02:29:56AM +0000, Tian, Kevin wrote:
> > -int mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type
> > *type)
> > +int mdev_create_sysfs_files(struct mdev_device *mdev)
> >  {
> >  	struct kobject *kobj = &mdev->dev.kobj;
> 
> What about adding a local "struct mdev_type *type" here? otherwise,

Okay, saves two links in the diff

Jason
