Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665FD3A14D3
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 14:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhFIMtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 08:49:40 -0400
Received: from mail-mw2nam08on2079.outbound.protection.outlook.com ([40.107.101.79]:3005
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231314AbhFIMtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 08:49:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZaHhdyxplqqMKSJvRqeXQMWbA0eQy3ZWHly+xGsVFa92hSIfyLTP850Aa1OgEaL59fepePZxcxsm9kbcP9JMxeF7MoiMMm48qanelwNUv1edTSm/xfqTZEN+YAaw/UNoTPstpofcM+5yjW9Oo/uTnBMxvywY3QIjz5DZYVEAMoziiC0W0xmtBCKMye6N4T0S8ZUrjsGI28T1frL0zpcAGl02Xx2TLXEwnjznrAk7HH+ftFn//+JkJyuZmh0B/KCdyT0XdCPmvgV5LJ22CO7uXuJDiDl/oi5V2+kbi1p1X2rPFg72j48nyApFyd6YtunfKJzlArk4epIytH9lJPnz0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EobltV2wl1u+XtCTOs9ATHgTpcCj4ijXDl22O4B0UkQ=;
 b=e6VYdoPJpG5fBtggyBzPCV+c4Yn8srWmLdPkGHU+44gsaUxAUIIMDkuuQoJiy4arslhCZws56Bg4VPhdFUGOAblXbSVLamURw12CX+Y3+r3PKu27zNepVT/81xqYdP9Wo50a9/RVmzfL0Fcq2Pni3X+wD2uWBex7e4sDsI22kKDMtKqUYQmaej0bUQYsikAqhjoqugKyrWYsx33kurzp1o4dtm0wpFrJHjxqBjFpgYHev2q2orKTdqxS8736sqr1lHPOa8aJjy8ewr950sbTx5JNLj8g0SX5L934iQPD9/kKnDbGnQytnZrKaKkE4T8EhGx5bCViAlWfE+PXR8KZDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EobltV2wl1u+XtCTOs9ATHgTpcCj4ijXDl22O4B0UkQ=;
 b=h0VIsPTOfPCUjU7ZUESLDhRURBbOPvVHMNH/BdPElZ1bVgu2vYO/rjkmL+aquT3XbjG/90ObIohWrCjG6Ww1nZVG5FvLn+MC2UvufXVyOZ7V7y7XNmhpHWlcWN2OfbMxmw8a0T126iH9Stxpw2/rMXmIFPGzalBiBNpJDapIrU21x9Vnt4UoSIblw08EOwhmirdqO87QaqYdCzCLAiyBMgzHHJ54Uu2VPTRQyrtZQe5mrqn5Nzxhq6BDPy/hGn2xuv///Uow2vOFwDsv2EL9lCXcriJIvILjxCxUjMVmiUeF1NBC+1V7dJMRalM1UN93kyPJsezG9EyCEjzp2XaLVg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5521.namprd12.prod.outlook.com (2603:10b6:208:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 12:47:43 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 12:47:43 +0000
Date:   Wed, 9 Jun 2021 09:47:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210609124742.GB1002214@nvidia.com>
References: <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <MWHPR11MB18861A89FE6620921E7A7CAC8C369@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210609115759.GY1002214@nvidia.com>
 <086ca28f-42e5-a432-8bef-ac47a0a6df45@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <086ca28f-42e5-a432-8bef-ac47a0a6df45@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:207:3c::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0008.namprd02.prod.outlook.com (2603:10b6:207:3c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 12:47:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqxcU-004cDi-LT; Wed, 09 Jun 2021 09:47:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8847714-f33e-45f7-8a93-08d92b44c663
X-MS-TrafficTypeDiagnostic: BL0PR12MB5521:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5521660465B9D4523CC0A4D5C2369@BL0PR12MB5521.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JMErMtErf6b+K8EIX6ZJdACbBCIuYL26Q9GIfggB/sgxaNHkaJ8n/gM+v2ivBjAcyJ4xcpcLSWbzz+RwHBZ2Vg058oZusfEIcFtGstZ3XCUEoXbSVdBOBFHT0JZkUh/j48lPxEmBtWz8ECs6UmAr4WxGmZpVMaEvX18Igf5SWfwqRiQEw1aE3KEhuCSMFGsVabxDpGKYKjwbQCW4G8O+mdB7jo/pCcWtlaS06jnmHP/9iszrQL+Athu9ffS0yBj9FN5/p1JvIcfR7aGj3PZaBLAj23hz6MilJpQcQa/p+Mw4rdaqIUZCZBg9qZI/uIJ+EkYJSDGsxDTFe03XM1v9Iy/9octlo7JJWg3lHpqCQQDSuNyv0ez2plzYOjNZ7cThz1i3CxjROHSQY9RYZZjraaGJ6IsL/9H6/lfiTiwHzTKyyCuHcglHqX4yae98Dl1LvGJQ36YYQU4gxMjo5yrW0Y11CmigFGkbjIvfWUunUua1XhU+f2FTX4vzvQ+LN2Zv2V9TzqJLB0sRcyUQLmgv1OzugHda8eaubU5wOIFzaCiYchyoq2EwtgP2oin5acJc8ZlAuutF+IHCFgOENPRkL2g+EA9xt4TWJPorf9oDpPA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(53546011)(2906002)(4744005)(26005)(8676002)(316002)(4326008)(1076003)(86362001)(5660300002)(33656002)(6916009)(478600001)(426003)(66946007)(9746002)(2616005)(36756003)(66556008)(9786002)(66476007)(186003)(8936002)(7416002)(54906003)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L4JVA+rOWtJkOOQzJBqi8VYYy5xEKletxTio0Ckdq51QRYEpEr8jBsRBkLre?=
 =?us-ascii?Q?Nh9cgiej0awOMkf1i5NMuOHUtpQYzetOPayasPS0TJQ6RwPBsXFMMuGf8rvH?=
 =?us-ascii?Q?QHjXJkqHvQou2SA9j2lDaiQQkZ67YaP71C2O2unJwsAqceu797UduCLP0VJD?=
 =?us-ascii?Q?8zeJSbb/KhoKeURnyaa569jry24Db8QvseipmJWvmSyoEYcMvs1BAtcvTWOY?=
 =?us-ascii?Q?Vawdq9ppCE8dJ5HNsqafayMRv1QFoSUTVF8j5m92c2LvaQBL+iyD2K/egXDZ?=
 =?us-ascii?Q?fZ/Iz25EPypPmuWqroHRpRKmtJz+Tev9+04us/404D/kpETR16BC7hSNyo6R?=
 =?us-ascii?Q?7RD2CFBscRWoDJC/Yo9EELM6HxD09HoHWbUKjWkYuYSXX9oKYIa6CQadt+8f?=
 =?us-ascii?Q?9egUHVu6x0heeiFgVCA8B9msLIBaKT2Hwfi9aJ3SH7vw6f98Em5QdUgm5gSj?=
 =?us-ascii?Q?LssvOHOqe3kiRrlPMMyK3U6Qsf0Pij4jj0SLw9d37vyOWz96cCRspIBKVscu?=
 =?us-ascii?Q?YEOQQlHuUp3/alTfmr/0sa4tSBzCADylQd3Kgzpxy38QjgBwYP1yRJOzS/Ey?=
 =?us-ascii?Q?eQEFBhGt2wq3POvEJD/0ldNsMZeSkqlY/f/rPajOgYjPvVHjQoygBmGN0NNj?=
 =?us-ascii?Q?LsUUrixp0QnyE3yr8NsdzyDdesl6dhZKWEepoaDETiSNPrSfcWalYXI5avc7?=
 =?us-ascii?Q?SP0/Zt3TM7SqmdZee+LXiQ+lYE5jF0FXXBbhRBur4SQvFoYxoFwPS8WvdjYI?=
 =?us-ascii?Q?a8IqCHqTybLGZH0x56Y841/ySAhWOZcijz2HU6OgbnZb0Lvk+QZFKaoTeNxW?=
 =?us-ascii?Q?jFLGmmKr8oQMQAAbBdIDtYsq6SADD9pThgkWj9e5UPX4dLEAlRL28zFVRmi6?=
 =?us-ascii?Q?hb56qn0H3uu8zSZ8rDzYcgL8UyhYmRrv3SmgJrmEMZ1/8kJlkEvvrD9mDgkZ?=
 =?us-ascii?Q?oqGyZ7MAS7qSxBlpvqPnEcBq38b5TVcYhu8LzmL+JrEW/omcF2ylkpLD9dQO?=
 =?us-ascii?Q?8L40NFV387C9rcoOg3Im9DI5SuoDhCT7ThNoE+rgxjEFpZ4mfIzOQtyqxvjM?=
 =?us-ascii?Q?6E87XCb/hU4bjQolK64+My4BttQjt/i/mJdlMTzPLaD+LdwSSCYjUctUNdRS?=
 =?us-ascii?Q?sKoZS8DGw0p+jWFdoC06FdpGeXHPcL9CwNLIFn904UJE+KFYWIpyXF2JWD/r?=
 =?us-ascii?Q?5e59GRwcPZQsqO0POIYPX8Msq1NfMCOQZH/eenRja1VodZtfEJ/S96OFUNjy?=
 =?us-ascii?Q?MqZuGxu5uJHfs5nPmt0l7QfsXywFJJphp/fR9UTcaol5RfcTcMeBHH2E4lAJ?=
 =?us-ascii?Q?p+ihENOJizLSaH8j/LIgo0oy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8847714-f33e-45f7-8a93-08d92b44c663
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 12:47:43.8247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3Hh0HMHWXYpBsA75x3++5L/Y64x+l7vAFBBAOkXGSro6g8XbJLmZDBkxxecolwo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5521
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 02:46:05PM +0200, Paolo Bonzini wrote:
> On 09/06/21 13:57, Jason Gunthorpe wrote:
> > On Wed, Jun 09, 2021 at 02:49:32AM +0000, Tian, Kevin wrote:
> > 
> > > Last unclosed open. Jason, you dislike symbol_get in this contract per
> > > earlier comment. As Alex explained, looks it's more about module
> > > dependency which is orthogonal to how this contract is designed. What
> > > is your opinion now?
> > 
> > Generally when you see symbol_get like this it suggests something is
> > wrong in the layering..
> > 
> > Why shouldn't kvm have a normal module dependency on drivers/iommu?
> 
> It allows KVM to load even if there's an "install /bin/false" for vfio
> (typically used together with the blacklist directive) in modprobe.conf.
> This rationale should apply to iommu as well.

I can vaugely understand this rational for vfio, but not at all for
the platform's iommu driver, sorry.

Jason
