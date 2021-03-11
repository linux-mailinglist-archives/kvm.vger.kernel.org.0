Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02083369FA
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 03:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhCKCBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 21:01:18 -0500
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:11072
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229648AbhCKCA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 21:00:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5ynbByIaGcRh8eGqGGZS14RzVYHamS+R8Emw8wtNHaxt3ZhBHMQlIdrdnTbVXyhbPwA5RPbJyYfm6HTwSVW50xkxrcR7zwon4h3J4xTZUdVx5IyT6wKQ5oWo14uGfZt7o27Tc1ooWcGaDIJc8O6KlKZ+d4HnGIh7k8KEOzB3BuLM4wYVbpzn0pNWiAo4lv3OGf8CTxvnMRHoClWjrE6wLWZxL8vFxSj00AhL2YWbyKoAhy6DRtCUnb4ETBvMXDCfNsgTD4aDRlfa3msRJyPoYVjb8FAXkSPqPSlnO5aBeVvfIcvqTjAloQo3dYOZz9HXgsYT70IPCUXbxUHjyxN+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilwIDVvTwIlX4vTM0MT6S9l9icL7oYfnoEZsic65vmY=;
 b=W8UBgy1yflLOc4JnFj5SRsR2iT8KpbYf55YXkBzu8Sl2l1Dlf0F8DBXgN8wdcmmLZVGN4uCz5XeTqiFT5fvUC/aO379bY+7BLRBjtVPR8UF7Ht0/bbEBtBbZ7oTekrRNCExMG0/30vn+6AgvIb70cr5V0ATVWXMDToSgHcuEU5KoVSEMT6dY1sIB2fMFybnzdAnx09eJFu2e1yfE0SmSZ413fgKfpXR75WfceiSWvxFr4hHCh2jZDR6GDPASIbNuceXmO34cFCpl7zLTxcKvVcAigwU51ELJIH4gRoPcH4ecqkHjps9yceavOrVhHyW7yOy+RLo9Q9UQuFeZBSau2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilwIDVvTwIlX4vTM0MT6S9l9icL7oYfnoEZsic65vmY=;
 b=IaRINqVs4Iry+aNt3DsJxO/Q8WBvOkoO978MZDHx+RUIYbzdxdZyxN57gicoaa1UKXzSBTJm9ZV5PWcBhIiJuTezdKWNkvg7r0gY4quY/Xv0Oyvgof5y42qHqV7pvjUq1XGoG+FYhXMKVQV6zQaM0AHI+/pSS89D0caH7O9+nUM2Gdoa0GH0JzmTLEaGtrMQQ4FBno0GDSbmuWtos+k81qDZhYecsiZMFxsw9Zsivtcutq7leBMJ+fAVyce8fMvjCLfrtk6pk/x2ggu69VraL8EeMftIsfYp635tkkG/96N2765pQsDy5uK0cJgp2hMtlxtXxRMUSPSuOdsCX4dkWg==
Authentication-Results: ozlabs.ru; dkim=none (message not signed)
 header.d=none;ozlabs.ru; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4041.namprd12.prod.outlook.com (2603:10b6:5:210::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Thu, 11 Mar
 2021 02:00:57 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.031; Thu, 11 Mar 2021
 02:00:57 +0000
Date:   Wed, 10 Mar 2021 22:00:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210311020056.GI2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210310130246.GW2356281@nvidia.com>
 <3b772357-7448-5fa7-9ecc-c13c08df95c3@ozlabs.ru>
 <20210310194002.GD2356281@nvidia.com>
 <7f0310db-a8e3-4045-c83a-11111767a22f@ozlabs.ru>
 <20210311013443.GH2356281@nvidia.com>
 <d862adf9-6fe7-a99e-6c14-8413aae70cd4@ozlabs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d862adf9-6fe7-a99e-6c14-8413aae70cd4@ozlabs.ru>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0413.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0413.namprd13.prod.outlook.com (2603:10b6:208:2c2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.22 via Frontend Transport; Thu, 11 Mar 2021 02:00:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKAdE-00B0QG-0O; Wed, 10 Mar 2021 22:00:56 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 783bb9fa-73a6-418b-6af2-08d8e43182c9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4041:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40412DD991ABBD56079354ACC2909@DM6PR12MB4041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d7hna2zrcfItTAcUavaaDjax267J3KorzMh+HNcVJ1pPCbRZpfZiOY22SRndyI94cVKHIm47fI3vug+u2pRc3HDoVPjGGOy7FyX0HhkEi8S9pnxi8/IjJCQCmlC/KLKGcemAUzEJuv3+G6tlqjKnj1q76TdwMhKyFRgw1MyI+80kXHzHTnNkcLKdlS9y7EVskX/r8QVXq7hmhI3UVG0uZqXSarVynkDBNiGjQdeG/GOwcz/fIUKbWHnU2LYDYz5JHsxj2tSO6PD/MdXB7jafxMp4PG1+1s9kFCQP7ewztjdqf+EzuJ4r3IylvqP5MsaosUHyU0dn4wGgTwvhI75XThdGXaJl5PlnSwUQHbt4FkT3jyO9cA19DCbfoOMs404zccmgcy0RtqyjQzC9cZtMIgSrXqL0A9pBsVUtRlEJP1yPcMFpawiDhHnY9G+YLj5xVqBlJnu3nevsPTSWKGrRblo4YiFJyO5ZthyteSuda3eL7Z2W2W2w4SQGGB5enQom9RTrXUpH0dEcNlwfkKCapQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(316002)(36756003)(66476007)(66556008)(66946007)(9786002)(9746002)(2906002)(86362001)(1076003)(8936002)(33656002)(426003)(6916009)(5660300002)(8676002)(4326008)(2616005)(186003)(26005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tNndZf4v75HGgn1bDE018oJEqLcJx5B2bPcJ8vpSfzxE5JxtyuaNjkewyZAs?=
 =?us-ascii?Q?1KOIYdvsr0+rMubzX9oQnfQ3cvrcZAqGDo3Frq6B8or3A42b1AWNqoQWnWo/?=
 =?us-ascii?Q?BEg5gJ+L95wRkuIj+ZkkvTn6D644B2avgd/HNc96Bmf2MqqUHumYn+/orzQ2?=
 =?us-ascii?Q?943FqsBRxMsbWCFIr2KL//gOce/vOQnnuToniDQVAHR105KW2TXiQT5aUJMQ?=
 =?us-ascii?Q?nZ2Lt3l04ExGugccstycIhktsPBtvjKjUuWUJvSzZZalsl6M3cjL/tOpdTjh?=
 =?us-ascii?Q?bv1ipBdV7tSLT41gvJ60FyIHzfCBLMMizog3PKqJvKIxlSMZwfKsa6LRUFDS?=
 =?us-ascii?Q?iNrTJka/IRwPV8huk138KeDRLhcw4h6EGRvxtP4qVyVWYvwbwU3ydh1lbRBV?=
 =?us-ascii?Q?bYIFSQS8md7h48JfxLyXR9mo9ATdkvP6OwZoodhXwykhqQZdkpP4+X7Gd8qC?=
 =?us-ascii?Q?Kl+95JsOrClSs7PduztTFpNMb/RSTVg+NC3lKsL+aYwh5bSJ8xctfvt7OUs9?=
 =?us-ascii?Q?qhZHK+ozdvLF4OFqc6Y16yTuhlfa9zjvDLTlTNfUlEi8lgOdLR5myptyFI5K?=
 =?us-ascii?Q?F74WaygKT6oBO081UqXhsXNzTKlzqW+SEtUo6SGKvw/vkmzdGA4EdtLe2Mrt?=
 =?us-ascii?Q?0b/A8kfiVQt0DZvkdpl/3JxiqjP1JTyWXFjwihANbm8DfY2FtyJ/LlvHjY0w?=
 =?us-ascii?Q?18PI2ufl5+Hwb6F//laJk+dnqwsh5y1QWcEFa3MJSWW/gSGFYoPncx9JD+nS?=
 =?us-ascii?Q?q3tBlTmywF98ukub6dl4wuSolW0IJ298Kf9Qu37+rOlcme6PJ2LsXBP30K3o?=
 =?us-ascii?Q?2YZcy0Kp6YkaWWziJD0kU9mN8fQB6ywukxE2gVHnO3KO8ovJnla3MQpCDkFC?=
 =?us-ascii?Q?5r9/VIGCbhA+FZUkw/K7seXJv32Tf47GUfWDQ8rrjgpTMQyWwhHB2LLQv3Eb?=
 =?us-ascii?Q?NArS6WNH10/TlNi8EAYs2TAEieW4BsiNIqtKXOmF0UqsHH26egMlj6TZpb8r?=
 =?us-ascii?Q?KPTIvs5tVFOhGBZZGj1k9KEPw0UGK8Ari3sAVa7eK+JrmLgfPCq4XaqzBXs2?=
 =?us-ascii?Q?aT3mXSp5zunyFmhAwOOzrqJqhH7faDiQNRyrZjJCxtNFba1YguSy6anb1FzK?=
 =?us-ascii?Q?Qq+j7TALZurdD6fxQcBHAD6YZ0MYp2R0xRO6aS308LIaBx/j4h+FXwbbpDQW?=
 =?us-ascii?Q?X9ek5YZMym4TqNYyWlIhgkdYxDaoU33wuwVjO6cSHY94sxyZxMINUmWS6c5f?=
 =?us-ascii?Q?+Iv54hol/dL8nRj/VzAJT9Iya53yzS5qgYe9+yPHmyS5AHFI0rMOl1oCTL+s?=
 =?us-ascii?Q?mzHMiEK3oidr5SCJw5dtkogmz+zV5HsERTjHxW0M9ajhww=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783bb9fa-73a6-418b-6af2-08d8e43182c9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 02:00:57.3662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8A1Io3XAMZsiY9lo08aClNq3QmmZ/j2QyRbOYSxCSvcNhkj5KumplwFnR5kKd14G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 12:42:56PM +1100, Alexey Kardashevskiy wrote:
> > > btw can the id list have only vendor ids and not have device ids?
> > 
> > The PCI matcher is quite flexable, see the other patch from Max for
> > the igd
>  
> ah cool, do this for NVIDIA GPUs then please, I just discovered another P9
> system sold with NVIDIA T4s which is not in your list.

I think it will make things easier down the road if you maintain an
exact list <shrug>

> > But best practice is to be as narrow as possible as I hope this will
> > eventually impact module autoloading and other details.
> 
> The amount of device specific knowledge is too little to tie it up to device
> ids, it is a generic PCI driver with quirks. We do not have a separate
> drivers for the hardware which requires quirks.

It provides its own capability structure exposed to userspace, that is
absolutely not a "quirk"

> And how do you hope this should impact autoloading?

I would like to autoload the most specific vfio driver for the target
hardware.

If you someday need to support new GPU HW that needs a different VFIO
driver then you are really stuck because things become indeterminate
if there are two devices claiming the ID. We don't have the concept of
"best match", driver core works on exact match.

Jason
