Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E293F6BE6
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 00:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhHXWtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 18:49:31 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:64832
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229906AbhHXWt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 18:49:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PY3bVDxwUeaGUlrdkUyGz3n4xzJLVytmAq2JzeUhj6XBkUq035rSJB9Jkl+U96yPxMWM1wc0w5TJmK8DqRprZvXPMWouIGGF4NL9/JiZsZTKDqna3RGfHoG5zT7+UfJVB9pWObNz2A+Z+ANZbPbH4UGdG/l+livHU0XHfcge9gsJ7QTDz6yZjOBssnvYNSAa61vUyOMDe7HQAHroHG9AXlfN46pomUZdJkYUislcnbjmOttLqqY4QTquUcBGIaQMyK2ZtSow/9vBrjq64DgCdvX98r0K005wso2qrVN1tIj8RUPEySM/enz/IVPIo9FvLhezLjjVX4S67ccZjQ/Big==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXpK0HHuQWaJItC+7wz1xj8hz6wpgqavrequmqpNAP0=;
 b=YbGNrt5jw3vU5MkzGQi1KKl47wbLX4wHOgHx8K3DhGFXzo/y+fEliPTaslDVXvGuvOFViA/1UXrcNI2soe6qg1XI9ehZ+JMyOWbAMALZrGFw8jqVf2eQZk08IMfxSTUj3h3ptMCNV4SMyDpRgES9YIKy5xz8fnJOu4VzUfmFbNFj7uaPsyqBvFfJwiLcl4eqqwsBc6Jy2u2wSUEbcIP719ZCmXL+c1UuL18sQhETJt07FT8YdEHT6L5g8gpN65ATL1vw+wkBHo/8NIpz4ZW8z1apGyS3x7hr3fP01tpuCxckvGRTpJR02oVDMvVhUHBYKUXrj4VzxiYK2+2WKHTJQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXpK0HHuQWaJItC+7wz1xj8hz6wpgqavrequmqpNAP0=;
 b=C47RhXOgIf2rM217yrCF+tTZNV5Q8M9cBHwt6Yynm1zX6rn/2MW6kzyejHv/Ilbbn/rA+yltZMq+ZdMJxMy2NovI58c7r0PXCYrtOELxTgjrRZ+lT91iQ8E2ZnbTJVm5K7Mnbt8eOcsZh8C1Yw4W++uzJi5kLQ2t85bweMmrEpxb+IkXGPV4n6/ueVIXki99JppE1VNNfhVq8qYKSiiNolZQ7rneF0YI9UIsHk9flzpHOeQCaX0UXi+lHUlqd3yOffezNNe4hhLjSGRH/56bP8uLMCqD/AVR/AHzURoKZdDK1Zuiof79tSO1fmPIUWyUwzeG99SIcKD8aQ423WM8dQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Tue, 24 Aug
 2021 22:48:42 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:48:42 +0000
Date:   Tue, 24 Aug 2021 19:48:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH V3 06/13] vfio/pci: Split the pci_driver code out of
 vfio_pci_core.c
Message-ID: <20210824224840.GZ1721383@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
 <20210822143602.153816-7-yishaih@nvidia.com>
 <20210823091624.697c67d6.alex.williamson@redhat.com>
 <393721ae-2183-2b1b-f670-8006992c4e55@nvidia.com>
 <20210824154839.159a1243.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824154839.159a1243.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:208:d4::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR04CA0017.namprd04.prod.outlook.com (2603:10b6:208:d4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:48:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIfDk-004c0M-Pc; Tue, 24 Aug 2021 19:48:40 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e65a9b22-c639-4589-1f7a-08d96751520f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53491B14278A31FB458DF83CC2C59@BL1PR12MB5349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j21IYUOgnLnjZ6w3+rWFHNRJoWAle/ztak/Ytjkth+9PE8YD8qQbT6NOxwgext7UEZmArK5yveJgqv9Jwl1RMcG58ttQ8HRIzUvtCQC8rnX0RMOxiH03K5n5EQ6KMObfCBtuIWXQtEToCchAB4yRV1leUS/GQrrS+76/glYS6/MteacX6HLO0zl7gwk637iDfXkJIde1bHxDgTx2HWvTg62Di98kLGpxm4ilQlQMlwpdW15+2TrdCFKO+sXNR4cS3me2eYFr2ZP14CciU4J9F8Jh4heTTHHbF3TXPhTOmKU1JYs4PUKk5JS6sn800mXYuYd4v+QJwKHNA/Xzh+AcFU57b6+w62lMR5ixlRyoFLYJK623dAuY0E4NBodKUwvwQk83QTA490R67wa4SfhkvFaVvson18FJ1M3b6aa1cDr0Jlua+aQgMHsdA9lKYrb/4/hqDGIRxwJVEXQ4eKiMaW7dUzAZO4CIYq6n+m3yhQJFNwii1Veqt5ZkxjAeqdoVChGlxOkBfHqyNaF4KxziCkAc/gKyf/io8liqgairopV1R6+5xrkgxWBN7pUN1OhXL4xqPkx0hZ+oZ80u7vdjqhuzhyreQCC9ygLpmcFH01rwC4EOkji4rMzwK16VqAK3BIlE4V/Fj5HqoVQyEjopRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(5660300002)(2906002)(66476007)(186003)(66556008)(8936002)(9786002)(7416002)(478600001)(36756003)(426003)(26005)(33656002)(53546011)(8676002)(316002)(6916009)(1076003)(86362001)(107886003)(4326008)(83380400001)(54906003)(2616005)(66946007)(38100700002)(9746002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PtnQYROGpeRZZ9mcNgLnVHIqXfEEwXdZlh2JuefSLIY5RN5N83HzNIzn/T8o?=
 =?us-ascii?Q?t5/lzlGIbibzgFVH6dvrw18pN6u06kSxLXBwqMbSfoMkrMrTwJYmzBheY5ya?=
 =?us-ascii?Q?QXoSkxHf4iQx3YpzR/I5gbIXJTXxddQ6gzHChRp29x9S8G4bc7moRA6pD1If?=
 =?us-ascii?Q?e2686u4PQjsHlobizWCxKlgzW1Dl1CbfTsas8oR5AyQcUqHPVgQl/F5reZUY?=
 =?us-ascii?Q?K76ChWEmbV5sR7fSPxjkYHKXvaZ2mxJD+a0F5dvE5CGfalcuXBVerthqbXX0?=
 =?us-ascii?Q?+7tgmwd3LfP7sct49eyRrk/B1x1CHIKIilpgTuxssIJsXAJAy5vddJfSIFGh?=
 =?us-ascii?Q?YCHh1UP6hMq5UA9R7Q5ROuiPwtecyxkFzYlatqj8zppm4N65rVXtZA0AwoRD?=
 =?us-ascii?Q?NijHXLw1LBdMKYkyBlzBbvauD0K01NeQGjVkQMr7iS72r0SBE8jLFhJXcaj/?=
 =?us-ascii?Q?lLUnH0eQjajd1ZA0Sf+Co8zEVyb7jP37uwHTzEr3DqA8LNj9UlnMUR3UlFdW?=
 =?us-ascii?Q?FybEDZ/Gfe3JKgC3aH7JpC5u/+RTpQfMr4Om9nxlD3G1h+K8UXwMpBXETIeD?=
 =?us-ascii?Q?rnNbACqStOmd9HCYjnKhZ1ezF2pfyjgsg8jXLM7AZCGnSmD04hBL13MGn0Eq?=
 =?us-ascii?Q?Te1M7xfH+f/YPJwgNXXnXQloQvQsXOxZ56t9xgc/TUiD6yIEkLdFidl1abEG?=
 =?us-ascii?Q?q8Y/keF+gxV4IRBxKrHoZlppKrLtUV6YLMPVv/4bIv1KJslnZJeqlCE6w2oc?=
 =?us-ascii?Q?c9J3q/by8hSeqC7HLrZxhELIqUM83LNds35r4rWHpQzlhKiJh3kG+zcqLMkl?=
 =?us-ascii?Q?Cdq3gQQFOedSE9PBh0dFxoURf0Q7pLyhoKq18AAgpGl1Mv4qsnNAgbZsT9h4?=
 =?us-ascii?Q?/2bvI+I5skarMNmSglP6sRwZyRDn0huz++8tuBThEzP+8vyBt00EniuhBlWZ?=
 =?us-ascii?Q?EToPuc6AnNNfo5FLw99YdRaITAz7UQSAd5bZPSKG/2Caj+x0Wh93rgFlUWCY?=
 =?us-ascii?Q?6GANsDqvoyMcX8QC9s5uxxY2dwtujEtiAxbdugm0PU3NMZYSWVkmomlkLUyc?=
 =?us-ascii?Q?8F+3pZlGObgDy9WmWInrX++77+Lw5zWQdQ+u0hV8pHCDAVmggtsKNjdwzhFT?=
 =?us-ascii?Q?0+JgF1jfM7bKpgR6JEykjr+zjBqgfR2IUHY4Tjz57dJTTuIJyUlg+IWyqch2?=
 =?us-ascii?Q?r7dXzqJBZ/+qlWz+aSfk33P0P+U8ijxoLlC/MbYDol8DiJSaWFZ3JSfcDaQu?=
 =?us-ascii?Q?b029ZCEjx8+Lxi126Xz8rzemKLKpKvrh2UHUVqgkQcAPyfY/Q3s3EvxooXkl?=
 =?us-ascii?Q?0vHa8k2wyIasnS4f0W2ixbUg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65a9b22-c639-4589-1f7a-08d96751520f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:48:41.8421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: av/hDTlbYr2uZKXFkBgH1IfbsCYHoBCHWOBbDlenDRM0aIWqKZox21ZKwEFLuv4o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 03:48:39PM -0600, Alex Williamson wrote:
> On Mon, 23 Aug 2021 18:28:49 +0300
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> 
> > On 8/23/2021 6:16 PM, Alex Williamson wrote:
> > > On Sun, 22 Aug 2021 17:35:55 +0300
> > > Yishai Hadas <yishaih@nvidia.com> wrote:  
> > >> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > >> new file mode 100644
> > >> index 000000000000..15474ebadd98
> > >> +++ b/drivers/vfio/pci/vfio_pci.c  
> > > ...  
> > >> +static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
> > >> +{
> > >> +	might_sleep();
> > >> +
> > >> +	if (!enable_sriov)
> > >> +		return -ENOENT;
> > >> +
> > >> +	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
> > >> +}  
> > > As noted in previous version, why do we need the might_sleep() above
> > > when the core code below includes it and there's nothing above that
> > > might sleep before that?  Thanks,  
> > 
> > This is used to mention vfio_pci_core_sriov_configure might sleep.
> > 
> > If this is redundant, can you please remove this one line upon merge ?
> 
> I guess I'm not sure how far up we need to, or should, percolate
> might_sleep() annotations.  vfio_pci_core_sriov_configure() calls
> vfio_device_get_from_dev() which makes use of mutexes, which I think is
> the original reason for the annotation there ahead of those in the PCI
> iov code.  But is the annotation through mutex_lock() enough on its own,
> ie. should we remove all of our gratuitous annotations in the vfio part
> of the code path?  Thanks,

Generally you'd want to use might_sleep() on a path where the sleep is
conditional - particularly something where the conditions are rare.

Given that the mutex_lock is basically unconditional and the
!enable_sriov = false is rare, I'd suggest to delete the whole lot of
it on this path.

Jason
