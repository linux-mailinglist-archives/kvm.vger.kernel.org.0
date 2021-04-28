Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EC936D7C5
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 14:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbhD1Myx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 08:54:53 -0400
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:63489
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239604AbhD1MyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 08:54:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0TvgtFKL3T9ElT0bz2IRDGwCqBbrdmo0ZfI73fE3iSLXDYLWOFaZXloVhyf7oknKbjG3FKmaW7GaTr6LyIAj9ZgeXrWEFk0dUwB+c7DVFQY+7cnnD0JDlwnFyGrsMrHOw6Hla6dho7+p99WiVPP++QjfSv3w5Z8F0F0l3DWr/ilcIqL4fFmm3rbvugCHMmuXtT2cKNb9aoNBME6t2m42DaLN7nUZn0RKFIpLquSQwfGgZ2qxWFKwf7td2BoILq2gS3QDpDGQLDNk7Au8/EGBSOtUDfZsBamMS9gvjmUIxj1+wGFa3/u9EVoOuxLx3oiU2HxN/qVLaZDhjCdUDY8ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2ISmGMoejstPayUHt5QlaF61EhE5qQMHPfUEfILqdw=;
 b=SI+FEJNRQ0oL9ngXM23vf0/PbCqxEHduezGX3vlIxXR4oN4ILTsiJk3+eLYTMl7HT60TMdOsUl3rr5Hra7bZSM7iZlZJSXm/DGiv/oAwmetDG982Ni9FYv5JJxEuq+++VW/nHGzabnljx8z2wKxkgQTNvraYYrM0ulp1PUmqYb9IJnofqUEs1W3bkmOGBnRThxzjV0eXTSAPOp39xmu1vhGiD4RjuNK8RO5iHUqYVYvJcl0NIhE4iMKJGqFHdCHdQNxUtd9gAtGOEq+hHTN3EWQNm4huXwc3Vq8dFk2ssw7TVAi8c6VDxG+qI/ht28qsM6UgkXvaOyZnJQwfG8XGsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2ISmGMoejstPayUHt5QlaF61EhE5qQMHPfUEfILqdw=;
 b=qfuyOfi6PijToCghynLqzP71kVcBowetb7W1erhJ6/9kIVdDeVkPZnSHcLRn2gFa4Jh2+FDeGerWdLlJie2v+1AZqozotMjNnONYT2Lb4g/XbvhXT5ze02IfKevZGsO+o4Th6c6VUjdZEpJ+r7DYqBZR0raP+KvwHPCXwVQLvn8Aop1xxmHiLzpxCIQ9XpkfiEfK1rpGHjyrAdjLDFrX1Q5acX7GoaRWbP0rPpysNDy8WvqCvjtDPW0F0lPRSE+K4kKJqFQ0zqtFnyW+aL99+DvPDtbqSF96wPQkKAQLku+Ts/QCerxtT+qFfPjQnsaftK6OJ0McKXPsCyY6t73CGA==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1145.namprd12.prod.outlook.com (2603:10b6:3:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.27; Wed, 28 Apr
 2021 12:53:24 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 12:53:24 +0000
Date:   Wed, 28 Apr 2021 09:53:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 09/13] vfio/mdev: Remove vfio_mdev.c
Message-ID: <20210428125321.GP1370958@nvidia.com>
References: <9-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060703.GA4973@lst.de>
 <YIkCVnTFmTHiX3xn@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIkCVnTFmTHiX3xn@kroah.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: SJ0PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::10) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by SJ0PR13CA0125.namprd13.prod.outlook.com (2603:10b6:a03:2c6::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Wed, 28 Apr 2021 12:53:23 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lbjgv-00E0Ok-CA; Wed, 28 Apr 2021 09:53:21 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdcd27dc-ffb0-4e2a-822f-08d90a449bbd
X-MS-TrafficTypeDiagnostic: DM5PR12MB1145:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11458473E12D87A1A53B7B9DC2409@DM5PR12MB1145.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uUn+WUNFlM/fJwxhzcLVDHODy7r8ENtpgvVDRUHRRiOFUrimbxpoouAEiO7BuuQ4n1buoNghB65m7j55WxSLjD3zjT1lx0Ai/iVww9sZfFhrKEosbRjvfrC7CKN4rVQXpLmtksEJemPkTV2GPC4YAlfcK3BtoCj7wvMV2BTKDB+u8rEoltigGZJsGOH8hbxP1MGu6mJ6AKFAnlOmtUGdLaRsQgJ3Vu6FWGZBVmzPWx0ssMIZXW3yQlasekxLKpLgqvGsQ8JnYin77at4GWDLJcnME4gly+UDGOqfLUPC9IIk6lqGH0RW4EwiguyyZBfum22WX5sVKnrAO8LNEfSPs3CU5LXINVOvNTeRUT4/3Od+CkeHqLvPY9oQx3gB+1Gnw8Ro+NP7lzFU02MTtGa+fNndEW4aHVjfAawmbxrHqMbcjdWc9Pu7ki+Fac03w1digJhc/BExt1/YRxtfz9EGxb+QReJEPj72AjlkmKteBtGdvk1sZzlvE20UsXSWjv7qenbId/cnB9CztaEB5231e5qPTWYCnHCLMluzVNSEkHMAPE3xo7dSpI+uM89MzXf0K1Nugo9sXgmjUrTEzTKaPB9zQB1PQsGaAXI2QcUZU5g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(36756003)(1076003)(33656002)(66556008)(66946007)(8936002)(86362001)(7416002)(2616005)(316002)(426003)(66476007)(107886003)(54906003)(478600001)(2906002)(26005)(8676002)(83380400001)(9786002)(38100700002)(186003)(6916009)(5660300002)(9746002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JNRcQ9Fa37ucDYaZPV19Z2kI6ZJ1FhbJxckzt20FddB6V85U+mU05cm5aHMB?=
 =?us-ascii?Q?myJpV7jHrhq4ia8fRb0CCttsDmpSG4bFk9SyT340og0u4ZWsxPC9oclt5RfR?=
 =?us-ascii?Q?bijRlz/7He7aCnflpIP+/+vjq/Z02RmuYeegG26OcbScZuvh67hGK+LkcaAN?=
 =?us-ascii?Q?iSClzlIMI3KmK288I7zYwYwGtqYKgWme41tFBWcD2C/HaNYRmjvY9Bugxsmp?=
 =?us-ascii?Q?Mn+S0US+kY2XIuHyZNQ0B07ASX+4Q6R/+kJGtWmj3BPPQW1Aa5kAZBAEcB2k?=
 =?us-ascii?Q?UV3yGhQCG0ZzNqaRucAegN+VPHwZeAd10rR9CXzBM+7NaEYtYQO6fdZhgKok?=
 =?us-ascii?Q?LfwGOE1I2IPrag+7VMCMGwQZ8480PodOhMInZKtL26uZTDJhPPWOkbo42hnx?=
 =?us-ascii?Q?UiQlyup8tR9mUqV3aGyg6oB3oaDUF49Xl4vYFXa7+v9qVxxEzZSOAjd6vrMr?=
 =?us-ascii?Q?VZmmxg9Uk/CE/jm06yVR4BM12wdNK3UtVwDWws5sF0alSl6HVXwHnDUD0gzQ?=
 =?us-ascii?Q?KfVlFMVSR6bq1REpqA3NEYR7n9yxaemHZQqmjrmt9fJlY+vVg4G1vNPJ+Mr6?=
 =?us-ascii?Q?lx15fIG5Yz9T2UfscZxYYtf/6SLqq80UAU8/qNT4sBtI2x5CtlXGOftxh1hk?=
 =?us-ascii?Q?XE7gVNjxCbnXPCT3xXUJGmlK5oMuWamWdX3mbWBa0WBAZOEOVGrd0syRnLEZ?=
 =?us-ascii?Q?TPhFCSQ9mWVGrabhcyRJvZU3YdPJSfs/7Ae8W579VPpITc7zq9Y9OnoIEwWT?=
 =?us-ascii?Q?J0YaoElG1HLcIjqx5QsONFMzhXTZ7V+xbI5a9U7leBKKXoi4PF6dNK/Wq22c?=
 =?us-ascii?Q?pCIQFy0Caf3qdEGsMaNNYG0Ygp7FSGTMU3Tn5lq+LRUW7v68bpJZdfBlhJFm?=
 =?us-ascii?Q?IAzt+m8eiI3MyPib/0SZ4VKOpnRiCl/nj5WyzrcznJ8XsEJ9jUUm1EheLvgE?=
 =?us-ascii?Q?dRLUlKuZvtuYgD82qx995sK/N4Ty1f7MzI7k9vrzHUXDniET4STnx+Aei/9l?=
 =?us-ascii?Q?+09dfsCc2pkiotFRNJJNE+tBoNdGBbMKW4iHMlsKM3GI4Mfa+3eywmkhn2HT?=
 =?us-ascii?Q?d30y+rC1UPA9pVaWpPy7qy2j5To8y3E8lzLh6J/eKQABmagKS+2aNChoFIOS?=
 =?us-ascii?Q?zQxO/EGO4YBl/uGQUtCG1miTX07FfSIsLqn2T3X3XR3kVl37StC52F9xnlan?=
 =?us-ascii?Q?VCqoLm9JvM6fMvfcppCV84W4B34lIn9dlLaXa8KgoMQgaBH6JS0CTfPWAH7Y?=
 =?us-ascii?Q?QrPyCH+8FuEG0EbV4GZXPh5Y9fVfKJhJlz6YtGlFvz5SPiUH3DRcyiFLGKWu?=
 =?us-ascii?Q?iOo43NQuy5SbKrkCPUFf0207?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcd27dc-ffb0-4e2a-822f-08d90a449bbd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 12:53:23.9526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ppjSVUHqslAmWmf+eDSm3q5JrXu5tQr37MspNCy7u3gUcgmPAUIIi0Kyh+6cI5iA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1145
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 08:36:06AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 28, 2021 at 08:07:03AM +0200, Christoph Hellwig wrote:
> > On Mon, Apr 26, 2021 at 05:00:11PM -0300, Jason Gunthorpe wrote:
> > > Preserve VFIO's design of allowing mdev drivers to be !GPL by allowing the
> > > three functions that replace this module for !GPL usage. This goes along
> > > with the other 19 symbols that are already marked !GPL in VFIO.
> > 
> > NAK.  This was a sneak by Nvidia to try a GPL condom, and now that we
> > remove that not working condom it does not mean core symbols can be
> > just changed.
> 
> Agreed, these symbols should not be changed.

During the development on this series I got a private email that
people have existing !GPL mdev drivers.

When I checked I saw that VFIO community seems to have decided that
!GPL is OK for mdev. I say this because many essential symbols for
implementing a mdev in vfio.c have been marked !GPL:

drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_info_cap_shift);
drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_info_add_capability);
drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_pin_pages);
drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_unpin_pages);
drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_group_pin_pages);
drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_group_unpin_pages);
drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_dma_rw);
drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_register_notifier);
drivers/vfio/vfio.c:EXPORT_SYMBOL(vfio_unregister_notifier);

Why it is like this, I do not know. IMHO it is not some "condom" if a
chunk of the core vfio.c code is marked !GPL and is called by mdev
drivers.

The Linux standard is one patch one change. It is inapporiate for me
to backdoor sneak revert the VFIO communities past decisions on
licensing inside some unrelated cleanup patch.

If you two want to argue VFIO has err'd and should be using GPL for
its API toward mdev then please send a patch to switch the above
symbols and I'll rebase this series ontop of it.

That way the change can get a proper airing and not be sneakily buried
inside a cleanup patch.

Otherwise this patch changes nothing - what existed today continues to
exist, and nothing new is being allowed.

Jason
