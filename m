Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DBA412959
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 01:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbhITXXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 19:23:16 -0400
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:53297
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232608AbhITXVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 19:21:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsE7Gt/Uwou63tVxLqGKCbn7K7KKJae3nqTyFOZ65dnEBiCxuQshEK3vmA3EbF1A7IM0k9pZXDU1vwhStY6zfolYX7yIJdbWxWq4uCbS2iQm8b/dOHSpWcKZ5sFKSRtHdhp8R27DfTtNCU9/ykh2upoEul0zc5uSFVeNLD6hO72B9vsA2JKXBnEqPZaYqKdVfkjk7tfdCJqqWXNQ7GexFTP6fndXIpSt7EP3s0FQH8u8ae6l5Gd1fboyr7mQr57h1D+SphLYYu2+i8XCFNxl/QT3XqmQfDgh49jc9AfRxybPYB1dDCFnQBMUSEp1wRCX5RQ3NAjrq6HKbUcbWCEqmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=43IBSeo0W3Ec+FNkmCphNKVWn3E33oerX3fYDSN5M0I=;
 b=SlhUdNy1XLiJDhjjku8GafE2GhWDaWXX7Akbrfxn0f1g6sNxxGwtNzUriotZRDnj2ex6VwK5iAl4RI0NalWgYptmA2WQB0tTDb6S2f+0KUTmwAfarA0AbOrhDNmD1qOWn4Lp8SXYYUlZuuZCKK+sf6ZeecOTb1XQ7KcFboraz3Jf/yL5xbVjOFnGtGqql4y9XOYQFRIKj/XL1oZAnFndq5nO4xz6TggL7RF8tmeL+g19U2cglZzEXk2lLGYQCMT8+8t9RECC5BcAzQ4PdR+RgRvtRh0RXeLJfiCZYwBWYC1I2HiQ/1a2pG7VcFr4/3r2Wwwlb0mX+CNkca5eeq7tJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43IBSeo0W3Ec+FNkmCphNKVWn3E33oerX3fYDSN5M0I=;
 b=PP+b3oqP3Co9YqZMuR39j3/vMceKTioVgYmJrX+HXN1+OB0Qj4yUJ7ARABMXa9YGUnN1PZ2xsGbDyaxnlYtdYahPxi9dQ5URc+VXnV9ZDHMzk+3IVQ+Osuz0xBP8oSSgUBLDwpMfF/AY+I+OI81iuiZupnK91G4QLZPeMidFYqNxPVLNgkFL8t0RYqOWrfVBLTJXwamg6YHCXtsfaWhl9A8BU+psXZhkvs1770rWvGM2mgu3dyKLuNqbOqDWmc1nI1rleka4Ch28TjOW1XuTnUb8Ieq8mGy7X/25GzJnF2i4A2sCq5R1cl79AMn7pTa8xX9geYUuP87KdzYWcrVjiA==
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5255.namprd12.prod.outlook.com (2603:10b6:208:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 23:19:46 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 23:19:46 +0000
Date:   Mon, 20 Sep 2021 20:19:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v2] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Message-ID: <20210920231945.GG327412@nvidia.com>
References: <0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com>
 <20210916125130.2db0961e.alex.williamson@redhat.com>
 <ee2a0623-84d5-8c21-cc40-de5991ff94b1@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee2a0623-84d5-8c21-cc40-de5991ff94b1@linux.ibm.com>
X-ClientProxiedBy: MN2PR05CA0062.namprd05.prod.outlook.com
 (2603:10b6:208:236::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0062.namprd05.prod.outlook.com (2603:10b6:208:236::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Mon, 20 Sep 2021 23:19:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSSZd-0037cE-Gv; Mon, 20 Sep 2021 20:19:45 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e077c65e-06fb-4e87-6b31-08d97c8d22c2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5255:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5255D92F9006B71CAA514046C2A09@BL1PR12MB5255.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XAnCWvgvVD0dv9qlZySsI75EomNNcc6Iuwb77nFSN9wg1n/PFHisoBo2nDcK5140IGDJifzX58UMdbFxOla3VS5x1wdpUWGCMRY+Bicd/aYTCqebMriotyGNNzBfqhfQYli2Wv1DfjTWAeYUsdF0/c4ghZm+QIsmJkaZpafFhB1zer5p23roo+gD4YQbyXeVFa7aflWGIUaki59p6zhFH6jwkAhJ0XV1Yq1T9aZP2vBiRCmzPzZAkDevekYtp2tr0S/XMejCVhqnanw+F03qMEfVYxsQf8zxPlVSm9tS7li+Z3jcGy8eXtR/nKzeuGotYx2Kb+IriFxIrX1vYMRC3aGa7kkLjP/pim9aIU5NUReulycAU1Vg37XICEo0Fqy6gNbAVrNvxcy1m89KEeRJYhJo1SmDZ6FGupu0iMbnIPXIkn+CuD6eIL6XEjtsfnypcJt98ExFI1j35T6TEZO46ZfoC2SgVVrAIgPxmKwBVG1rNOACv3dzIMtzEOHER5VCVlt/3H7pzIwJ8xLEZo4YJbrwfC0oqP43hrQco5yH77RGcOVzgGDVUVfDByzb/Ej0GSr5IKnwg3LJh214UdsQtZrzMIBBTKuulnAHH52ofkgmJggjzlgywgFX+w2ASsKDCBfCnASnRcW/40asNo9hshCAUMjIMbMhxVUzAnQdvku5TRJFVOHoJnLoXjnCDqaHqTGF8b8V7pVap+Ivr+qfbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(508600001)(66476007)(66556008)(66946007)(6916009)(36756003)(1076003)(83380400001)(33656002)(2906002)(8676002)(426003)(53546011)(2616005)(9786002)(9746002)(186003)(38100700002)(8936002)(54906003)(86362001)(5660300002)(4326008)(316002)(26005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aIsB3WiUGCRqlPCpMs6v7UTzLH1GfXzn5qIC922RJnjVhyHEs1cdRuUFNgku?=
 =?us-ascii?Q?dG6mFyXf/buKVU8PbXrN+HPFkG8XD5aRt5tZXzTeAsk0Xsi+gY968ot2+Yas?=
 =?us-ascii?Q?pUa/rJk2TfoGek28u1OVR3T0Cjb5KaLjrmMhGdZkEb0cjCeLLbuqxidHrJlX?=
 =?us-ascii?Q?0oizVPwk5cBCCkSc9usUokavoRMh2YaBIci6bJsv0rSk/W6v7mokF8m50iP8?=
 =?us-ascii?Q?XugWv760u9Ysw72SRbxJwWIYnFL4oG9tgR/T1SX0IlSmNLil/+WHnL24ONKY?=
 =?us-ascii?Q?K2YCtDkr9ilcDlSg0VBIS6KJ6uvDB+Pe/m64pOiN20Kcy2RTZqGfLLXrEABJ?=
 =?us-ascii?Q?3Ra9Zl58t0iDP5gcH1fOiUKggepbbNYJuME6w6BgzpQxqI0dpt+DVxDLdSmh?=
 =?us-ascii?Q?ab5i8PJ2fqWGKQYJNdpkoMD2D9XaWnRaVANc7Yqo8io41taZZOQXK3fwMsW8?=
 =?us-ascii?Q?vFHDxe6RayornqA+6wHP4yPFiGfVvF+iQS1jv3y8XUkVfhVSE6sMTCQSC3pB?=
 =?us-ascii?Q?kSTHbQl/h0Q0+dbXNUAo0aTc0wZpUbSgIhdPGlB4urs3tmGGl6cCQR6RKq8/?=
 =?us-ascii?Q?+9ajIpyhYDNU+LyYIVTWqt0krN3gJS1iCaO+n8+SYSk4Pu9dOrtW090PCgBd?=
 =?us-ascii?Q?USyO6sxeMMpEU4bMymipBrgoGJLwEGaZy5QQffRd7NiOSVKaGPXhpzXWUxzM?=
 =?us-ascii?Q?EytQkI5ANmDi/bYH/RjDFuxtldLGP5nl6LSS+RdT67FZej0VdCm5suf6Lpv5?=
 =?us-ascii?Q?+VquspxMwOoksl8XUSPeJHpzJrKsF6oA18GipPrlbbWJNVVO6G5m9hsY3kJ+?=
 =?us-ascii?Q?3eaWWYTTrhfTPiROencvmbDKEV2dUL+G+kdqKQ9QeQxTrXBc4/TSX3H1Klgn?=
 =?us-ascii?Q?z8XFVRe9F1j/8FqiMQXKca++pHkflOQ9kY2QgZq667GPcdLSnDmn2uK4MCHg?=
 =?us-ascii?Q?P+gDa2eJ+BH3YjBv9gaE4F7HXhAI+QB3UGb8ZQTGMp5QchSD9TJ9JELUHgT8?=
 =?us-ascii?Q?pZxqNeZmxCocm3x5G0n8d57TcqAfQZUJrAcfpdLtikpebVyDqLJmTTSVuRuD?=
 =?us-ascii?Q?Mz8qZ0ZNv1b6BvlJtD6ZsVY7aSl8AWWobWrIoo1ry+3ibnOmu/gJs6vS5n/5?=
 =?us-ascii?Q?jKMLMzhAygxNKlOKPEyr2xPLdOZXEn92Eb/+a4puSXSTOL/9qW3LmwYCIdZM?=
 =?us-ascii?Q?Nsg0zeAFWbPmmSJa0bn8FYykOHjW3nJddKwZg0ek65w1gfOPFVomigUrxr2N?=
 =?us-ascii?Q?gqW4hrTS15xU0P1Y8NFUfxX8AGzfbCVKCgUkCAoFtuDkKEvIVhIa3PEohOvc?=
 =?us-ascii?Q?s9kIzwLsWr69ZfSR7uLGZ/yf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e077c65e-06fb-4e87-6b31-08d97c8d22c2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 23:19:46.6349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g9bXjfuLcKOf6JcAgA5pONCDCP/iPPJIcR/W0O4YeyRTdxY1o8VQ6cMS9SpLiKSK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5255
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021 at 05:26:25PM -0400, Tony Krowiak wrote:
> 
> 
> On 9/16/21 2:51 PM, Alex Williamson wrote:
> > On Fri, 10 Sep 2021 20:06:30 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > Without this call an xarray entry is leaked when the vfio_ap device is
> > > unprobed. It was missed when the below patch was rebased across the
> > > dev_set patch.
> > > 
> > > Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >   drivers/s390/crypto/vfio_ap_ops.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > Hi Tony, Halil, Jason (H),
> > 
> > Any acks for this one?  Thanks,
> > 
> > Alex
> 
> I installed this on a test system running the latest linux
> code from our library and ran our test suite. I got the
> following running a simple test case that assigns some
> adapters and domains to a mediated device then
> starts a guest using the mdev.

Oh, neat. There is no reason for this stuff to be in the
matrix_dev->lock, it should be symmetrical with the error unwind in
probe.

I'll resend it.

Thanks,
Jason
