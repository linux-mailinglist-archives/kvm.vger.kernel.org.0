Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883767C5A27
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjJKRTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 13:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjJKRTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 13:19:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8180898
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:19:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+8JJ/fneE3IacB2CuLuOG/NLdk0/Rp7IQB/SKwlRVZcN4cIzKT5iRGSTAZBAGgEgbuHmRtM5hsOlMyOymR4aLSkXOCSwAVmkJhjFsC2ZFFgSYmxpbuJoKH0b/nlhmHRdEgpaRCcpx+HDFZ7vaFddynWZF1bTY+zFvxb+6lo2N5EHFosRlnly4rhfx22wbGhEBW4ZF14w8+gtwN2l+PaGBq6iF+7BkJ+S+ihkV05k81ce56RFxULnS9tx7WpLwi2dJ49Jl8tkhhd62FDajYKf2GM8krsqRaEN3FsIlvXQ6yL4rG1ZtVmIwpNR3MOD9RY4VoJqWuqC7GYxfk//m88eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IgLvr17uhfKwJL7KLm6SXnwAfGQz61l3wTbqbNDMuE=;
 b=jxVojMyP66I7ghsbtuJzpEyW0VdElHoSStnAss6jdxk0Y9zTQq7t/5IpG/Gbyc4mlryMDFbjrnxFJTsNp++WQNYTLUTRVRJh6H+z9yy1ylpEhJJYR4Bt8ydHfWlDUr08RgANHhMcyBnDLmxQgEncv70IDOvFWc52UXaecHqPobFonJnrgPxPM839Iu23OtqbOLn9HZamxudforkeGbDMIQdgwn7uT5tZc7dzsjRC9bO1UH55+twsHa2SYylBZCMY6p/QywvDsS0JfHO5c+X6MRszWITfun76cReoIMz2tDt8VRxubSug0qiReBfDXdTj75MuvkAYrzsYLAvPkCMnSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IgLvr17uhfKwJL7KLm6SXnwAfGQz61l3wTbqbNDMuE=;
 b=N3joM/6FIfMGnoa46mzRQEUAKTdSU94eyxLK8FKcIp19FuywmLUjFBcxvVcf4OGeEyQFgE3Uxmjj8Wa3lGfxaQqMurLIAmSO0VjmAjncUV4esHVbZStld5tj0ha1r5hXKBdQtPlb2dwkZ6a/WCVIuGYw8pQg4U6ntZy8FD4GvlUULfdq9dGYiXQ7eewsOzfUGiuY6/fVEMMl5g61lRwfPPJEyAUXkugwdm66IgSgG/ij2XYwzwF6M/RBLBFLap3RCIxh4OE8a/iQD+htEJQqVJM9NjUAVlo/U3W/rYQ5ogKfBGPOJlcj6Qti7ADXPi4niol2EiDlI2LmPF7Bxagtew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by BN9PR12MB5145.namprd12.prod.outlook.com (2603:10b6:408:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Wed, 11 Oct
 2023 17:19:46 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::5bf0:45ee:4656:5975]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::5bf0:45ee:4656:5975%5]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 17:19:46 +0000
Date:   Wed, 11 Oct 2023 14:19:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011171944.GA3952@nvidia.com>
References: <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <ZSZAIl06akEvdExM@infradead.org>
 <20231011135709.GW3952@nvidia.com>
 <ZSaudclSEHDEsyDP@infradead.org>
 <20231011145810.GZ3952@nvidia.com>
 <20231011125426-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011125426-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL0PR02CA0117.namprd02.prod.outlook.com
 (2603:10b6:208:35::22) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|BN9PR12MB5145:EE_
X-MS-Office365-Filtering-Correlation-Id: e99747c9-2241-4f87-9698-08dbca7e444e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ho1BA/Fivsy507KNzh4BFpzveGRZ9Y/HGiC/JgO0Y3zKnNsWgUN/MPc5E3/GGAlRRLVugMqTKsPENOyoAx33ECwXe1Yre5EwQdAJGXqCqP1VF4u1FSTeLsVppoiKR3JT3hN0FhOqdNMLPJpk1Aa/6vaSt0TqUyWyQdHwP/p/mfRffuzpiUZAaCQC9RgRcP4l7Hd6Gh1zscIGHGOuS4mnnmIE6AebAYY8Y43sza9ipxsq5DYrdL3ASPNH04WbQKFjkzIQq4Vk9N8o4WisE0gsO/Q8lF9Ij3IvBRbIWESBaHUXiz4Ajn5KsYVU0KEOZ9RzXjyfXPcVJGGbDw4ldC1FvJonFz3ZO4ZvzFICnEPiDYZJ7KIL94UrC2YyaYk/BgfhaoVrSg+NMiuZrE/iyTS+M9p0mNmwmGhHSj3aFOw71NLpPc0JNfQPRlbqCpYfXMqleUuLjVq9WwVY2KROFSyOrkpYyb996uie7Qa/LOGJTtq+uyu7ZBvxe2ACVR9Km51ryREJOatC0+G2D4pKY19MTXUwuHPYJUdyGQcaq315Bm6dKU+eTvAajZiI8qMIuT9z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(39860400002)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(6512007)(478600001)(6486002)(86362001)(33656002)(36756003)(6506007)(4326008)(8676002)(8936002)(4744005)(66946007)(5660300002)(38100700002)(54906003)(316002)(6916009)(66476007)(66556008)(2906002)(41300700001)(1076003)(26005)(2616005)(107886003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xO+tq1oguNSAFTdOBBIRYgQKRHraVQCiTukqL4K3Y7b6jHx2F/mjSdlbAsW3?=
 =?us-ascii?Q?9jp0QFfDOwbeXkeg53J/0RjXHD/6RUKOkg30vWiBNqa0sPzhTXxx/cxDZIjJ?=
 =?us-ascii?Q?iPfWLns7yvUmdg+Hl9juhAZF9B5aSncAHtqGN9n2Ro8M3QajwCBlA/nIZIR4?=
 =?us-ascii?Q?smBbeHMfCUMbsTLZL/O8iFiZMiXtnXevXlYsUvrnJ4fZanrwM2CD8i25Jnk2?=
 =?us-ascii?Q?Jdf5Jc1fPhnv5i+wIUwDsF6V7a8GlTjAetqGH6/PrxT9x5CS/vOTw1WrT917?=
 =?us-ascii?Q?qgU7SxPTltP1u7cN0MwfFy6Ohjo3HkzRa62XsmyyK5pKNsGqu+FrmlT+M+H/?=
 =?us-ascii?Q?tJI0gENCVJ1SiPWtmtcK/x7moovpKhPAyZhe5XRtDaYxPK5xRfkp5Gp4BtP8?=
 =?us-ascii?Q?2lplqqxE3jhbUdxY2SUxn9CDgHXIVbUfMkUZQWlPZR9HPjLj8lcXYKKqSVC2?=
 =?us-ascii?Q?8W0/5GL6yoxKjZjrLjRwRWXjZRrDvWd7k/47Z7BWWp/YxqVaqouTVKdERKqg?=
 =?us-ascii?Q?mT7F7ZvFFRUeo9i7zAzBlieOM+e3B35vVzLba5jYRnU9frdBJygv++Tn1H6N?=
 =?us-ascii?Q?zRLCEm8ZmUJsSL9b46da9q3eysnPpP2lViQdkjBIAOVCiMxPhSPycMJe5zPV?=
 =?us-ascii?Q?Lg9KFamBqcszc4PIKWq+LXzDwbFNJBq18W+XRk3ui/FK5ZtIkWBjaH6pOWZW?=
 =?us-ascii?Q?fQvc/5lEi+WBYnMqcaPe1+rViLHBS3VMhoU8mJ4x6GbDCMZoNlM154tKOQbi?=
 =?us-ascii?Q?aQXTwnIgwipcYnSEcku8dsI06Zm5dQrencFBaL8nUsLzKicI7Zx+3wj6+ehq?=
 =?us-ascii?Q?gidXEqF9qPqhuxIg4K5wmC9H6rShVj7VFiIka/USL4cPtIbgtUbnYW29GP60?=
 =?us-ascii?Q?1ZW6vpyLMp0aqmCSPMTLMIyObHHj4zge0tvWmi1xS+AnTu35dS1PWBAcBw1e?=
 =?us-ascii?Q?zK2zLluMa+ISSzk66/78TE/7RWSb9YL3TALFKsATjko62jwPXzGj3/jdnNNm?=
 =?us-ascii?Q?I2yfjJFlwEm5xc3QmihRF4MkRrqiFah9OhpjI5rCzXeR7f56qlT9HPTKTtxC?=
 =?us-ascii?Q?Wvtu3n0756l3lYPOKb0mFHDZngC9gigTkuq9RDN+y8mDhDNbLN6THwx73Y/9?=
 =?us-ascii?Q?D1L4X1hlSyz/093Nwyg14hjcdore4fhy6qcNxzWPIoFyjfCpFllInqPpkauk?=
 =?us-ascii?Q?t/ax0vQgNMR5zFim8FByGhAQQN9AiiETdmRvMytbh4sGphln/zfqG+MkTyXe?=
 =?us-ascii?Q?3d2JuMwvDa5XRdeLH7TasHYvO83KDrWqT6nldvtyNcwCUsYRXvyVdvpqG65Q?=
 =?us-ascii?Q?dqqqfio1fw2ZChkHZ3Pe7S4ZihkCdXV7zGe2cpi5sG4U8MuMU4UwCfbgnYEH?=
 =?us-ascii?Q?5UslaLCMZuOXwJfUVe2J7qxRRG3+/0C5IGZqOFJLIHblQ8jKl8waq3YMjHz/?=
 =?us-ascii?Q?S82F6jp6KwtrhY8GZwF+2v6VNLVuEjGlTwdIQVNhBARgXFtk0nCK5vW5F/5U?=
 =?us-ascii?Q?Uzmpd4oBCTi49ag6EE2ymINwSH29+6r47QtvvTiaiHwS1h85q5CRs+WQS3sY?=
 =?us-ascii?Q?2+cwUzKXRFAnH5byXlDGaI0q1uAXifvsm205BJE+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e99747c9-2241-4f87-9698-08dbca7e444e
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 17:19:46.4889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uu/ekZbkjxyfbneDrlGdK5ekYSkR4qG6H80sAtotBPPwB6lfjQKa++naLyoDnWbZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5145
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 12:59:30PM -0400, Michael S. Tsirkin wrote:
> On Wed, Oct 11, 2023 at 11:58:10AM -0300, Jason Gunthorpe wrote:
> > Trying to put VFIO-only code in virtio is what causes all the
> > issues. If you mis-design the API boundary everything will be painful,
> > no matter where you put the code.
> 
> Are you implying the whole idea of adding these legacy virtio admin
> commands to virtio spec was a design mistake?

No, I'm saying again that trying to relocate all the vfio code into
drivers/virtio is a mistake

Jason
