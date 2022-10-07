Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FD15F7919
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 15:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJGNhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 09:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJGNhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 09:37:33 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F35A573B
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 06:37:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNVg4L2Zn7IeBxM9yNOyXTDqmS3kMA+j2u89ZNCMaKxApOaXdd5wLHFnvMIyDrDH07JfItFJonQ9RiM56Z1e5JgjQ2Da1epj/p0tQYsiT7AXIpLxBYeNL2KIGhSliNpsiN7UuOeFZcNvyCRri7D5AXbEf5DXHGys28d+fa9txRxDVu6x4oFLz3nCYLwbM69geZuVTpg5yQzszdKibjTmQwfKe+/5jTsETWJ/Az0nm6O0hV/c3Lc73LrZpsIxSqq6zDGHx72btAmfy1ETyply4Ir4NgYwurXKY0xJVmYNdA+jNV7hFsS/K+pY81HSriPkE9l1l6jWnT9zG0JxaD1aBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2cJPBu7GT56S0NaCTlK6j3jHVhtladq/vurmjOLJhw=;
 b=BCsqY7DkJXzcl6xAa1587vZ4vin3hXAsunr+Kxk8LReBOUAibz5JbJ6dWZpz7tda5+gr1j4xY6TJZcYYxHt1LIZMlFBeWfitcuXDvT5dwIFPaJLCTRPhtl0qLCtRR8F31IFkV86I3wCBxJkUfztgc+jHsDwaa12aegOqrCimzgQbfcF8BYFct6+RdmDdTAInLLQw7Jo082BIGjx0sK8EbVJJclHc/5EfMSehGkbCMV+tEnITl+GFJ9xcDQ6RG8zxIhYuwNzOJeMkD747cOxrKDqBb0WZJJS44ezbLbiQtzK3WdXW9bvuZIcfSUNR7aOPN+hcFVyaMtaDKt/b3H9llg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2cJPBu7GT56S0NaCTlK6j3jHVhtladq/vurmjOLJhw=;
 b=ov9XOVBCouHsd8wtEen/p3Ihdm5ncibJy/AVZSlkWYEGP4qa5Ik98V2EMEyc4YGc3HtfIO+z+prPtSlkS0gR3S4GyBhLKbzkGzazJMn5W8FLyx49Zv+aeACbDONLQvXQwBgJf1o63vfBd7FZdKf8t0Pq0VMh8vbW+RjDNuAWJ6d3hFdZk7xj94rhUsSjcNGBSPcNuiG6wA2YrtHkf7RG1pyH2YX+5JEP4RAm5ItWclp7opH3ssbvlqfyubs/otAfcf03cu7w+uqaDVAXjcgtWNn/sxR1pVwZrEmQS14d3jYPKecjy9aK6exEj1+N8RCaaAyt651g2fR2+E3iaFqvWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4346.namprd12.prod.outlook.com (2603:10b6:303:58::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 7 Oct
 2022 13:37:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Fri, 7 Oct 2022
 13:37:11 +0000
Date:   Fri, 7 Oct 2022 10:37:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 0/3] Allow the group FD to remain open when unplugging a
 device
Message-ID: <Y0ArhhCOXEYQMC1q@nvidia.com>
References: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
 <20221006135315.3270b735.alex.williamson@redhat.com>
 <Yz9Z3um1HQHnEGVv@nvidia.com>
 <2a61068b-3645-27d0-5fae-65a6e1113a8d@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a61068b-3645-27d0-5fae-65a6e1113a8d@linux.ibm.com>
X-ClientProxiedBy: BL0PR1501CA0003.namprd15.prod.outlook.com
 (2603:10b6:207:17::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4346:EE_
X-MS-Office365-Filtering-Correlation-Id: 37ce02fe-df06-443d-8e84-08daa86909be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: craKGDXAcfSytBOB8JPzhdZmTtWoJpTb5FaiTiLaLCm6C0Upfrogejwuxfs3djKxYtqrGDDbSJCC4GlMVEt2aIoS9um0AFK7/hQEOX1Pt7VL/NHxPtYE8GB8p6/guuoFYmOsA5nMO7bHncSloiNrNtexGIkWysF5jFkQ6jfelfLqX9Yqo/+1u4i5qyVHt6zypsz15NrOTeMxBeJncxW4rwkByr1eovr/4FekIkYMwNAq1ZV8hpXE8038u165cxkk63688GeSrHA4hgjtj7TNoHowCOv2fhWyyuJFzDWkcM4SU+oSdUZJ9dlvshpz017cbUX157hi2m/gfnPY6BWwDW5IrUeFBJYykWozZWgEbnI+vrQ178hFebN3Hk58MovYfm71nDkokHZi/5W/OcnytSW911sADuaq4Y0v1h3JwVBVHebnBvIs7l4UZk5onbOeQoNGwBI9dd5N09yCSvV6r33qf9LgggXssLqHCV9JVvUMEZfBSaVI+wjqRH0NrzHQ4XE7dPSDjxfWbzLqPtwKDeyM3HtFNGSvuapdFQCIT6vTYE04xp3eLgjvtbPbUk9+RJH8SqZw5MVj2pdIONTw9Fxif0Ptyks862gPVGzejk3587976XehPz9TyK+GWRaFeuyDCmmfIy5THI8QAxZBgX9NqDssEsxyeH6Y266miSLzWXdmvE7VwqnQ2eFcwy9rXWE83M/xSdQkk7elRmCBxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199015)(6506007)(86362001)(66946007)(66476007)(66556008)(6916009)(316002)(4326008)(8676002)(54906003)(36756003)(38100700002)(478600001)(186003)(26005)(6512007)(6486002)(41300700001)(8936002)(2906002)(2616005)(4744005)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LqFvJpnKRpQsrZ65HNIeBeQAxbenvA38eyI21A3BoghZC3Ht9A+tP0aomSri?=
 =?us-ascii?Q?4aMEtMKoh3bs4yGLUsLBhz1JVqmWeI+Nbjm1GczMLNX4x/0PYYDzouuJpJSX?=
 =?us-ascii?Q?BKTh45xIR/wJd0GEL/2R48rPm8ligZEJCKszF0CPGO9Wg1GFXij9+oartddF?=
 =?us-ascii?Q?n/RnZj20lgsEXUxcF/N84TYfqP0cRCVlejG36wMoHF7iGitbL8fcvHqyHDfS?=
 =?us-ascii?Q?Xj12JIXz6/t7BwGfqLfN6UcGbVO7ZJsv6T6TBpbgIQgfJVZyUZm9e/+fyYN8?=
 =?us-ascii?Q?fb9kwkBKAAlXHjjvqHNXNs6u8XRoVTSIqohpKFFzKQd2d+Gz9q3Kb/PHazW+?=
 =?us-ascii?Q?nZrNjtJLXcF51OdlizahwwUPOGqVKhx7+F1+0x1RdAQlRBDahUA8l/NYCINd?=
 =?us-ascii?Q?7uh3mnaByJc15Ak3SSngtRCTTTT3Xr5dw6utRUDTZHcjR5DIoBPlsXwBINaj?=
 =?us-ascii?Q?mLUEMNAAh+7wJoarhWfPYrtUSvdo4aRui2zYI7GxhTfEaSr8Z7tFBGPvTlDs?=
 =?us-ascii?Q?IkkubIl0/Pv1uSH9+62HAfk4n5z8EEEeNA2zLS5IksibulxEz2JYNV1CLfMN?=
 =?us-ascii?Q?h+m7VWHU49BIyrb9v6xcDm5fzPBk0C9oONqNRCJWMJ3Pfgs5rVwir7FnFIMJ?=
 =?us-ascii?Q?C4jFXcIfAM6RQ9OH+glv8zpRPsbXzE2rFA38yeIEMyimpKdCZJ4wM/x9aS0A?=
 =?us-ascii?Q?11SmfJ7daYttYVH+cYxYNcERnTVxKE9oAQfIa7GCNT8VUNod3SnPWN28o4tj?=
 =?us-ascii?Q?RqrEvTW0NVcjaP9SAU1Axl7wImhnK/kn6787BY8Nob5nWn6VOeawYYLLCr7F?=
 =?us-ascii?Q?MrI1+J+SGzfjLcXk3FzBKRrcKT1xDZUrzFI+gDi1HnWoPK5tU2a/0NALJra0?=
 =?us-ascii?Q?nT7DV6T+1viCjCAFMsy0VKbGFC3sPTKPl05brve8HDR4981GD5oOyExJrn2B?=
 =?us-ascii?Q?KWEBVxb/84vv8McKSpuDc3E3Up67x+wuvaKYkQVUcvCOmkBXpUBoZ8TypobF?=
 =?us-ascii?Q?rdSTEXDkZQ3e8SEoUtfC/WHBwArgjmADaOI9r+ZbOIp/H7b2EPWZmlGwBhor?=
 =?us-ascii?Q?PspVlN/RFrhzNkGsGJ/QTomdlSnKRTg5LXGPF/Ax3wNyoRzg6ruMVyn6Nqz7?=
 =?us-ascii?Q?gztRrNcvgP0LEcWcchCFEqyQkPRGHyeMG9lK9eehHuqn+Dy6f2CKVopmtmjn?=
 =?us-ascii?Q?AwoBwX5T7ftpeIsXxBaj4xq64vfVp2A5+BpiX7chuZEy4STLvxVNGvEViSG/?=
 =?us-ascii?Q?HxTtTPSrhbudfYzDxjezmzox8t/wS7OJlnhO5tJrGHEWdizbJI/zjBKznfm3?=
 =?us-ascii?Q?pM6z9U+oW9B/ZrErFtd64y9DrdriwaXDFqy01ngTmAzy1JlG0yYtbkvvQVto?=
 =?us-ascii?Q?1vqUJMYl/mqPDey0csDPFwHi59ch+RAVJZw9NJ6aMa6pUgisLhPeIULPXcXT?=
 =?us-ascii?Q?G6mTR6Y7dMIRhvi3xPouycSpOysO6E0gt5UqkKcUBjywN4KPdAIasMWmdlGf?=
 =?us-ascii?Q?FSI98iJ6H9b9zPpqF2Bq94H4RnWIZsmhTMZjBOmmsQtFhh5u6jh2I3698IBN?=
 =?us-ascii?Q?w9ThFG39XPhTDx7pL3s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ce02fe-df06-443d-8e84-08daa86909be
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 13:37:11.7674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+yvwhU01/wXRmIOXAAxxF14oLlxeGXGbdNv68N8WtCyFC4G7E+JZIJCgt1oSe0I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4346
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 06, 2022 at 07:28:53PM -0400, Matthew Rosato wrote:

> > Oh, I'm surprised the s390 testing didn't hit this!!
> 
> Huh, me too, at least eventually - I think it's because we aren't
> pinning everything upfront but rather on-demand so the missing the
> type1 release / vfio_iommu_unmap_unpin_all wouldn't be so obvious.
> I definitely did multiple VM (re)starts and hot (un)plugs.  But
> while my test workloads did some I/O, the long-running one was
> focused on the plug/unplug scenarios to recreate the initial issue
> so the I/O (and thus pinning) done would have been minimal.

That explains ccw/ap a bit but for PCI the iommu ownership wasn't
released so it becomes impossible to re-attach a container to the
group. eg a 2nd VM can never be started

Ah well, thanks!

Jason
