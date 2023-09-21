Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBA87A9AE3
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjIUSv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjIUSvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:51:17 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BEB8E6B4
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:44:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2tdMapepvjwlTouX/uiiFOhOX7TVbk/Y+O11IUV8tGdAhpzLnW6+tzI/5RpfTt8EtHATxjyVN/YhVIczhuDcwla2fqzVzAkl4XztT1VVJ20Q5EiKVNIWSxa/tBXzXssEQlTprrpqeFo+aNfpfiXfQ2F1RCCyYghmTMRihPYFkMf5nWClYhvvtTBnxbYlHeQOLVLou7Kdhra20l5PGXzA4woqQVHCqJriq9AbqTCHudhvRuLgMt4p98cYoyUvsLTAWiRT0hvtsyBS9i8NlNMXVh8TWoaZCVkIC7mPBb1m2mH+a4SatMSCwEFAk9uMr4WMAoJJO6R8mLDJ8Ac68KagQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcHbRm4bcEXIKiPB2eEnjr2Xt7J2TZWw68TbfDe602o=;
 b=Y3mbPb2v3aR7FMhWbGVT93e6bVsYtOdqS1dOYrSTNQbCphOG1pNh3/iTdsTC5PTOypg2uWDFMiyGH0gh6Wq80ZotUF3Hi4eEdkqXH0dXaOHjSILOj7k3NIqTzV8j+TC5VRToAqjmRm5QsROH0KSz7422ADoRTPVUR4navR15IgsMB5+b7KZQ3YANRZdK2meUt38J/h89Z+veqzS2hAJmcxgCAp3OmqVQRuxa0KbYIfx8mKVqDLuuZePsnqiLyHmxbMfiMEis1niWnyMmesxnGo2/5RHldcHtZOhFF0p6IpzOVIT5iRO4T5n1Q5xw4ZjrbaygCqVjkkN4N9MfhkADYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcHbRm4bcEXIKiPB2eEnjr2Xt7J2TZWw68TbfDe602o=;
 b=GfnV04gOYt+/54uvjiqywxuvLis3SP6r45duG6dGPvvOFSlAvbYQ8hJgwK3E52NcfukGFhBpuTcm2g9umFZ0740EjBlHNwiym9HTObj2j8ZOwzLm7lF7BDbvpkyHm+yEpt69AFIxRm4WymWi6Ogg9RM9NNs3kauxmWtcNwIJWoH1E3Bn6/7l9zJwMYs0HuvO9CCP6svh8zCyKE4IMvCcyQsAFR95+O57I5utlSa3PntyAVlzsH6J4xq1QvFfuuvGm6VEjWgrG6DkzlBT8ZW5ETeyNQoy5doCuFjW3xKxXLIu38bvmXRaWTODJco9ihehzZ75vF3D4WpJ4OOCXZUDvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB8507.namprd12.prod.outlook.com (2603:10b6:610:189::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.19; Thu, 21 Sep
 2023 17:44:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 17:44:53 +0000
Date:   Thu, 21 Sep 2023 14:44:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921174450.GT13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921131035-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BY5PR17CA0037.namprd17.prod.outlook.com
 (2603:10b6:a03:167::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB8507:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b7c9ae6-11ba-4875-4e99-08dbbaca7631
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OnXJi9ejc745deLt1CZ3w0eIQUFrfw8X10qndcED+Zn+Ugmkar1vMCo1TIobgDSfbURVJYD5DjzwXjFBYXhTQKfhMr97CwLNfdBcM/XJNPu9ACjw7y5eiFK9Gz5ujMvy4JYSKf0s656drfIDqQSjHIaDIC2PfMzdub+qSyJsxrc1sPdGcYL/xxUa3Fg/fjIroXGahzwTa8GYapFITNts/eP/8e4vvidNQLAvIhw5a3nZoNSpLpMkKzSnEMj76BYu57He9kpy1BV9kZezE6vmPqQpQUXDy7QTPPfGzd7UKAYKe6woNRPrZk7DNzf5uBNamu479GykQT7oPJbaEe89Asa2DZysN8Yq8J5jdZjGSvnMg+2FqGSj3yyna0qIFup5VcjRoKsoXf/9DmvhzJWKmQbkVjeKJC2sGT4zvt1csBnEzD/mMWRBLOgWta1NZ6d09K7DTHju+VBQSqKoBknofyqicILgWcneiVG4ro80Q5aDYoSvIU4kpdz9GGzkHXqWQ9aMbImYQjxPwXXJuuh6D6d2XGdXvFknD35+4Se5T3eaavXu5qtJS9MiYppy1EJj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(366004)(396003)(186009)(451199024)(1800799009)(2616005)(5660300002)(107886003)(26005)(1076003)(41300700001)(2906002)(86362001)(38100700002)(33656002)(36756003)(4326008)(8676002)(8936002)(83380400001)(478600001)(6512007)(6486002)(6506007)(6916009)(316002)(66476007)(66556008)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jy22ZBLm96IqxOC6JrmKszJO5IhfnWEUL9RFdFssC2TKSF7TFF5T7EljDCmV?=
 =?us-ascii?Q?DsyFqGs5zNncbbL98nH1Wqmf0VyHzx/YOw/oAl7yos1Q0njwhlKcptR8wWf0?=
 =?us-ascii?Q?VninmBrbEHpb/kGwyhaEu7bCiioD2TX5m3N4AkBKDP9gm1Xo2n9psr06za/6?=
 =?us-ascii?Q?ucE41wGKWGRyJEr1JyVdxIDX3OYV8a3XQxTriV3FcwjYQklyKINGhEpSJY9t?=
 =?us-ascii?Q?TSB5HMnUlSpiQUvW/O30J22USZ4Cj2g7kxpEYwbhgC8+fMbz3Tu0tmrRl9zf?=
 =?us-ascii?Q?aNZrDNBdOfVNY+NlliV+wHLJXrCmzg6wWGo2P5pmOVX4HRrAdCRVDUm/CH63?=
 =?us-ascii?Q?ZIvp9ejiW77Q8OGo3rHejCiNdLC3HfvyQzITojtwOSCQTfOmh3ynYK3BZrN4?=
 =?us-ascii?Q?2IzHKKtgag+nK8BsSgH0Hc4D7TNeidnvUSvjWYzzIkooupOwevEKUF5n358i?=
 =?us-ascii?Q?BGrp8S24Epkjpuo+i+BvfcBgwfWH7kmEifBg9Uuh2Kc58HTiqgZSWxBA7Jkq?=
 =?us-ascii?Q?EgSyl0BjR6Dd7vvMUMiZvYDwTinml9BCE4ujE62ru5h6aECL13PxAZ8Rd+V0?=
 =?us-ascii?Q?47xiF679CjArJPVy8HTl08VJSyGKgZrlE+VoOIxD2DxgEFDWUB4ByuMQ7ERR?=
 =?us-ascii?Q?IwTYKOZ9BWuJ9NFrWtqh+bKYu3iUI9CSoDQDOA3Uza/f345IAKMAeAtJT2qX?=
 =?us-ascii?Q?mCKP4QznxOqfkuTh9zrXkMvqcGvuE34IiEdy6G8W+RKIUKzs2IWtPXmc4XGG?=
 =?us-ascii?Q?VjEhnpQkncjYhrhAMolGI/TlzIUP1OezCPLX2RKG7O3rv9CQJjg4jOlsAp4Q?=
 =?us-ascii?Q?VAlmgLmIKydrl828WMv1MecMGJFiL4brt7Hr0u714rv9LRlDskTMmHRvz2uY?=
 =?us-ascii?Q?mnYHf60rLl0sQaBZ0ZhsosLrpd505QyskaqslQGnLYLo6lGxyZbK/kenpM9O?=
 =?us-ascii?Q?1iukBZbLmM7vd6TRZ3rAE8AoUK1WTD2/3UsxRJyB0nCH1VluYsBdxshxpSkq?=
 =?us-ascii?Q?l5GbxD1IO7kS8YmW9zTKigi0jxJRIN7zWeUsSzJNyftgILKWZGWQ9PrY0Xt8?=
 =?us-ascii?Q?gELN6Gae0mlW+dUPpS+jmSCHQbDrf63INYHszSXxu86i8/8xGKT1iThi5qeC?=
 =?us-ascii?Q?C+nr5fuANFuE6k00taEUu78BDMuy+7cQV2FhyWPmJkzuPxNVz4lrO+bwmh8O?=
 =?us-ascii?Q?CZ6AvbNJaTa28Oik9/AiBdel+mF2JBmN7nyl5E9umyc+0mSHb2m+/HIOyvDZ?=
 =?us-ascii?Q?ovai3G6a1WZjCjGC3lYM9+f8MxfUDuZRdnnxopMDEjxyFAL/BerfBMXRLk7i?=
 =?us-ascii?Q?rAzQ42OcwZZupJOEvW9ybowVuA7IvwuaygE3QTl6X90+Z6EVSRlLnyFLNF1u?=
 =?us-ascii?Q?wCofsdRQ7JNq2qDoubodT5EdyC9I87ViwvDkhzpQpAjph3dNIW/AmZM+Nkl1?=
 =?us-ascii?Q?7kWNRRDmYU5/E1/wCF73cH+h2M0wO1M+jnffaXtoJItAjf3TwDw26UHbte8r?=
 =?us-ascii?Q?gjWtQ1/oDbAM7UfBJzqczATWmupsrZIjsNq4Tr89gDMNpUJELvp4IB01dA/L?=
 =?us-ascii?Q?kJKuyqy5Jnr+FfFjYIqeRgjD05kPJ1TGXWwqWU3W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b7c9ae6-11ba-4875-4e99-08dbbaca7631
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 17:44:53.3669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbRWTzrqVNkEms4EuHaARbkhHHZgRcILaqbzVm8J3RHpdz3nLEaBXYPBQWRpfNin
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8507
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 01:21:26PM -0400, Michael S. Tsirkin wrote:
> Yea it's very useful - it's also useful for vdpa whether this patchset
> goes in or not.  At some level, if vdpa can't keep up then maybe going
> the vfio route is justified. I'm not sure why didn't anyone fix iommufd
> yet - looks like a small amount of work. I'll see if I can address it
> quickly because we already have virtio accelerators under vdpa and it
> seems confusing to people to use vdpa for some and vfio for others, with
> overlapping but slightly incompatible functionality.  I'll get back next
> week, in either case. I am however genuinely curious whether all the new
> functionality is actually useful for these legacy guests.

It doesn't have much to do with the guests - this is new hypervisor
functionality to make the hypervisor do more things. This stuff can
still work with old VMs.

> > > Another question I'm interested in is whether there's actually a
> > > performance benefit to using this as compared to just software
> > > vhost. I note there's a VM exit on each IO access, so ... perhaps?
> > > Would be nice to see some numbers.
> > 
> > At least a single trap compared with an entire per-packet SW flow
> > undoubtably uses alot less CPU power in the hypervisor.
>
> Something like the shadow vq thing will be more or less equivalent
> then?

Huh? It still has the entire netdev stack to go through on every
packet before it reaches the real virtio device.

> That's upstream in qemu and needs no hardware support. Worth comparing
> against.  Anyway, there's presumably actual hardware this was tested
> with, so why guess? Just test and post numbers.

Our prior benchmarking put our VPDA/VFIO solutions at something like
2x-3x improvement over the qemu SW path it replaces.

Parav said 10% is lost, so 10% of 3x is still 3x better :)

I thought we all agreed on this when vdpa was created in the first
place, the all SW path was hopeless to get high performance out of?

Jason
