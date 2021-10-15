Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DEC42EFDA
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbhJOLnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:43:24 -0400
Received: from mail-co1nam11on2083.outbound.protection.outlook.com ([40.107.220.83]:25857
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235398AbhJOLnX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:43:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWxMxgZ0QSU5pGQS84IitjK/4lTRTqSSuo3JUDlkyboxf9KihZBW33tZfIirvDX7iExUR7vy7TpX31OY/JqT60TvAwhCgZl3ec6ik1qzE41oyQZT9QE+uZg2jvZKYzwVC1rDEUrQsbG3JWwRx4hR05A/uZZgDYpeWdJ7PxrlU6MTdVo2iXFDmN4f+8DtAz4ee0lCxipbY3vzfNoUSOxqI8x5VRGSV0U9TgeaTrWrk6xsrTw6TePLxNyjixBn8wQMt4roIOmzz0CUrgjPppqFGcosNlkEDswL5c3I5uP/6yPFLO40rqRXdxYQVzgaPR2C9E3t02WEzVbkQG1jxvUGWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1htkSE8IfUnkBW0iG44SkmbbYC9taJWDjvKhk+hORs=;
 b=WDXV5Kj9pMLWhx8dCa34FnzRyJs6EXOh0CRPGW2cV50QVEdF2ylxQv403SdaqXKXGvU0VX+n6h2nVJcB1CcM2hHgd/CecICv2bysJxOV0n++mORh9kl2LU7vzv9LzBLradeck05Vxbxnz361JhJv04pof4uTP3DbljN8oIQx5D4h04HLgdOOTCqjKvnFNG7CerxIeW+1iDlWMcHuZ0rX7fXIuPiJmr46qjg17QK6ML39lynq0/OhXnnCkjr1S34BPb2BLI7lf8xULf6Deh7QMnxmfVzCGrm2g+DvIvNGx2W0MUh2xA9R2l/tvt/3L6V+ThSe0z5D0ba2ELQT9HCgmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1htkSE8IfUnkBW0iG44SkmbbYC9taJWDjvKhk+hORs=;
 b=S0ezbYkJyY7XLzNgG69VuXO17LwuHkrnw7IezZqDa47FYGaaKlTFllEm+fi5yDWj0M4EBlkV8I+fSw4GVDAXV8odE9+aUAfgP9bvRt+OKMn87WsLN1UAIZTm0Bv4zNPjMa7hum1PcHMU2bho+qaQ3Xjd7zdyg8/WCv68OiBRZlbLuaF9WDfuACBf38s90PowN9g+nD+PBFcBVqP88HTm+Gx6DC10WyfUhvIJXit9gxfvBot02yPEOHc3jx088hQ4PHUTOwhoN3KzjgGKssYlR52zVUb5NQ8Z8OW+ZBNmJT5QBiL4xvysYqVQrCTMZu1H6H7IcbdVPy3nMcdXgkgL9Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 11:41:16 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 11:41:16 +0000
Date:   Fri, 15 Oct 2021 08:41:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH v2 0/5] Update vfio_group to use the modern cdev lifecycle
Message-ID: <20211015114115.GE2744544@nvidia.com>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
 <PH0PR11MB5658A21677BA355E1A44A6C9C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB5658A21677BA355E1A44A6C9C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0239.namprd13.prod.outlook.com (2603:10b6:208:2bf::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.10 via Frontend Transport; Fri, 15 Oct 2021 11:41:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbLaN-00FJVX-8B; Fri, 15 Oct 2021 08:41:15 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d1d2709-5c34-47a9-569d-08d98fd0b265
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5208470FF5D7A59995B35CA1C2B99@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q2ApEfe7XWpfsufRjNOucyFLaJrARS10ceg812XIErNUG4FeazKp6Kt3GP5tHaJodTiyGo9N7uVNmd5SFy572eTgo6Q6oY+8zINAJVEwvwgUHUDc182/x18tB5sH19GGdvcYFHL7nwuPT8KrotZyv+Jv6hJn+I4uQm4M24FD59uhz43KORV4bz+YqbEK7N2N/9WHMEzQLXG+4FCoWH8cMruOjpcYX0M2yt6Zej1cakfYepfb50JSoO0sGeGCzaxJihGmk25C1lLAGt0HNpf9+/EGKgOTtd1imlNTQTtX57vG0jB/AisBPrrVmfffopD4Yp2GOvgM1yYMcirJKm7cWSYXQ6tVUpyhMRMUi3OZoXha9kBRgI2d/93PejnxTqH+iiJE14xe18r8CNeEj7ovexf4UH+2InuC+qIDkiVA+rMmhGzfsYL5Aoi7gcbQ3nSYIbvZz8c36dhgrwitAv0pISQmhcQ1euZiUweSTKZkZjTch5sEeHClfCHVSIU6yhOk4zalZNZZ6Bhwn9Vqd637xQGxOyLtSqk16l/futFgHfQH7uCidJ7IrJ1/NbaQxWEN4GHCaaKhuCc9qkIcXhtsrhJzg1DKkLYsA/sR0ujRueI0i8MAx6M4eQp7UATagckYuYVTjZP3putPFzpCxiTeWVdiSbSlshaSek3VHXQC/okTNKp98BXaaYWaAfrmZ/tT5uo26ZvwzWqEK1tHa/BFxob1kLmp1KLCq+dC4B1rILCsC003sHfCWZlvJ7yP1fQuqtaabFZMYgPgIDKRN1upjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(38100700002)(5660300002)(8676002)(66476007)(966005)(2616005)(83380400001)(4326008)(2906002)(6916009)(426003)(36756003)(508600001)(1076003)(4744005)(86362001)(186003)(316002)(26005)(33656002)(9746002)(9786002)(8936002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XFcHttBrjvT1QLZGTLEX9pPGaHXS5baezoyPtxrdxxJT+S055K6OdfA5XKwl?=
 =?us-ascii?Q?2p5LxxnWr4qlGTIOkNOYr5pzip/J49adt++gYsIYqL21DmHnOq8krVe6bmaw?=
 =?us-ascii?Q?ZwCninUSkFe8WyOUsQXP+REXdRqvfOcZ2ox+rijtPf8yoQODKnzl8rG9SHay?=
 =?us-ascii?Q?TOJd7MzOXoYb5ZLenfxOi3o0ONCeherSd/LORBbuWVlfSenRcUdIxHXshQje?=
 =?us-ascii?Q?1TZwey6OAANT42Gd403XsUBrFESi0AWaKTVK6TpGASmhIp/XmYSbUjaQMgcX?=
 =?us-ascii?Q?owGK4xJgu23jz04TOL9L4VKZ2KICCgEL7JFuIeY9vRhrSSGp+JWouD+2EU2Y?=
 =?us-ascii?Q?K0zypVK5QFb42PSfk4g+XfbjnD4ioYpi8ZyalaQiZU3CB27KBg9A7qF3b50d?=
 =?us-ascii?Q?HTGI82oroZe+px/rsSXRc/4Soh6fJiOcJVyx9zmCclK+uAJf8FWXSHojgBgQ?=
 =?us-ascii?Q?YNZX9/s5R+ehoi/RcJoJ5cZpgoVZlm/4+Zkhj4QNCqc6V8RHK6IcTUiLUPbZ?=
 =?us-ascii?Q?pCI1ITxolS3Y7GIUUW+m7YtEunqIeJ4cXwJrZLy9VBzxJRQw1NDonUWqInh7?=
 =?us-ascii?Q?ajb393CiLuSYNcUWL7ML4Zr5h4uPiG3kmpJph7Bns+BG5s5H84xAK/0KSkCR?=
 =?us-ascii?Q?wFwf7H3xNyaRYY9PeM85qCrf7EQbPkvtZJZ/P6axbY7wky4aH0XozUHalvmM?=
 =?us-ascii?Q?p6TfSYh6uWrcOzgMaQdHprRELB2+hQ/bujLgltZ7fPJI6NXZ/18W4EphzvGD?=
 =?us-ascii?Q?M3Mh7X9tjJOoU6QehjnhgnL0EZcEV0cohmG/qMggiS9Uht5fGBhEoEf6NRR3?=
 =?us-ascii?Q?nBfHzpwMZNymMUbiqIMGHwQ5V801aZ/Izx6dKDL7ZsWMzEf36iBZFmf6vF0Z?=
 =?us-ascii?Q?WJjznXo4UMB2GPGDAhfAZd7TB7gIjo+NncagrWTzriNwSzrZEXIfPbhhN9B9?=
 =?us-ascii?Q?WzkFS15n3ynxxpKbLtuPyz8rSxrfKMriMnMJ1OwhFnMasNgc9KV/DmJy++Jh?=
 =?us-ascii?Q?RGGA3sN6vJHRXOJ3lEtnX7J0vTVXiTxYsV3IFucLn1o/F+MDuklyf+bPqTZ3?=
 =?us-ascii?Q?bOR9YtDFZaRl0Mp87VM62lFq5UYfG2OsQTif/SllxXW3e4XRchlmWsCMZ0OW?=
 =?us-ascii?Q?y7Dl9AGqq8hMEuzrGkbVe1tSNFprZc1pXZM0ozz3t74/70nMfvYvtMFWoGUf?=
 =?us-ascii?Q?KHLEdsXFH1i3EduAHPL1d5QOuPhP4FxozQRLpFYXPd3rlXqGHmlsH7wPDu0Z?=
 =?us-ascii?Q?EW2I50XSIz5RVxKyjAxd17B0IYmBifQrpcStDpjA0LCrfQ7iZ6Nx2FfKo8f7?=
 =?us-ascii?Q?C0bdzXBN6GoWW0P4raj4NBi/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1d2709-5c34-47a9-569d-08d98fd0b265
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:41:15.9726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PeViwnrMY+EIkbkIy7zhBuqNjET8TOdRRFVbs6mckm8Oy6cl5WfFafygmM/h2AdH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 06:03:18AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, October 13, 2021 10:28 PM
> > 
> > These days drivers with state should use cdev_device_add() and
> > cdev_device_del() to manage the cdev and sysfs lifetime. This simple
> > pattern ties all the state (vfio, dev, and cdev) together in one memory
> > structure and uses container_of() to navigate between the layers.
> > 
> > This is a followup to the discussion here:
> > 
> > https://lore.kernel.org/kvm/20210921155705.GN327412@nvidia.com/
> > 
> > This builds on Christoph's work to revise how the vfio_group works and is
> > against the latest VFIO tree.
> 
> Jason, do you have a github branch includes these changes and also
> Christoph's revise work. I would like to rebase the iommufd things on
> top of it. Also, want to have a try to see if any regression.

 https://github.com/jgunthorpe/linux/commits/vfio_group_cdev

Jason
