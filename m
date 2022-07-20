Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E07A57B62B
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 14:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiGTMOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 08:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiGTMOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 08:14:33 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3196BC22;
        Wed, 20 Jul 2022 05:14:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmdX23I/p45XGqsA6OLLgQ591f9cUVQ12IGHuOHwJsnFmYKpNDfccN26aIlxqSf9a+NLkTp0748B8/ZjSTXwBOjLd7eCBvjvtY3aYqALlxk6VTWhK6I2X1vIOZU7tp/VN3KgXdk+b8rfWMam4n74G6rEphVZlMgnAgojrwodjPZNdMcxGqGHpxX16fQg5wqFr1wy/1OWciNfRDI4KJ3iVhosbXS5dfCO2oGND6LqZxNUkdel4b4jajpKPbArkXOZHd57OubgWUSA9i+i/8AOEdu7cxi63mmi0m4/fFT1p8P4quOsCsIQmdtDn1l/azfLvpvwjXFRLqbIfdSRto6obw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwHL78AipD2QfQoOvljgygcXQ3gzDa8pPok6kJJ6WmM=;
 b=MQ+qe1WSO7ybsQxNatz/KYqEraDyBX+QFb9XhaZLxot/y/ifgDOeC+A7KdEweRU3nMs1wql3ywEaReHmrSAHBbLgbKO6VVZTuIpO+hatfKpAQYQSLQodcGfTPIrm/8OOOEtPcu9kb6zCIIMiCibD1s8uIPHHUtuhXK5HQwxKCgY4UVvbwkp5MRH7quAvKdyN3Ufi0tyWtvuxCRyT+KYiv57kTL4L/PzZiSZIMhLSjFP3yt5HvsGU7qGQKj8ghvRbiPNyIMwnYHTwn5uG9N9SYKP0/Epqxx0qBkSNEWz8Gsozusasf6Qa0t1G0ux772rMMm1F2Nw94cP7DiiMLjvz2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwHL78AipD2QfQoOvljgygcXQ3gzDa8pPok6kJJ6WmM=;
 b=gFkVpW+MVVbEB1TOjMo+v84xjATPT25Ao385bc9ZYDZaXrLO7p273oisk8mjQEFS5q3rSdic/HbzlwRtu5sJSqtojXFADMB7rVumQ3Mob1PjlU1yo2HdOciqiTsxioT1NisK1nx8GrjW94R/mjhJ8aecEZGXVGzjMY3dLhgQNtjapkmNXNxh82/GvUM/PpZgtz5EshTQsBFBYojNLgLkYOEjrj37YCBd8gW4EiiYLR/OYB4BkUQumWYXCo+FzOS1NemTetJWxmvgzz/AjDHOe8CPa+cGwWDuCc231vNiI/fIj5KZX22SzM6te4GRWw3I97zzwbEgYg+uC0QpjOSiIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB3220.namprd12.prod.outlook.com (2603:10b6:408:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 12:14:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.018; Wed, 20 Jul 2022
 12:14:26 +0000
Date:   Wed, 20 Jul 2022 09:14:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Subject: Re: simplify the mdev interface v6
Message-ID: <20220720121425.GT4609@nvidia.com>
References: <20220709045450.609884-1-hch@lst.de>
 <20220718054348.GA22345@lst.de>
 <20220718153331.18a52e31.alex.williamson@redhat.com>
 <1f945ef0eb6c02079700a6785ca3dd9864096b82.camel@linux.ibm.com>
 <20220719144928.GB21431@lst.de>
 <20220719092644.3db1ceee.alex.williamson@redhat.com>
 <20cba66846a011e2fe8885f15def6ec837d12d0b.camel@linux.ibm.com>
 <29248eb6e20ef5990d3189ba5468fe4d8bada61a.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29248eb6e20ef5990d3189ba5468fe4d8bada61a.camel@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:208:256::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b2c1e2f-8ab3-4c10-4a39-08da6a496384
X-MS-TrafficTypeDiagnostic: BN8PR12MB3220:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R0Df1zrxf65/tzF2OxUXwJxYJ9PsEr1rO5hfmj3RFpZFSNDTis/caQ8PtOwSO5RM5CeuyfInAZueeQOM94sopzHNSTaWehzwOmHF4gOrdoFJoWZPG3kTtCsbev7db9aFney2dPrZVQkLMxB8/sc2npQAKOpBqxo+tT4IJN7LqZmUJd1tpJYE2vfZLs50JIVTuqHC6+COprz0bEHFcIhO+SFbRl0TBXHS7+9ol3Fz3WrNLhPljkP9Dxz2k0RGyP/86ypfgZ2dKDQFqyCJQCRJ5ovn6dvxbOjEpltR8eoOHbDrUVngnJJsq+29RW0Fz2Q1HQme+78dhDWxnJPNivMbYTuKxga6And0iz0tiuSqaV2FfblmG47T9O1Hg3oeL7ipd1qEPKY9fygBKxbFYh3ljL00QyljOABH9UvM3YtOFkI+RnpZlyBcKWBeawg3Nq1OKMth9TbiGO0NLZxyLrZeedtgTjVa7yQ0VWO559jCoZaws81ssn/tGx/YIf3AdnxjVlt6us8iOAL4i/VWzY43Q6omdjU5jaSpyykhWFdPlnEGdiARdOF8NTY8bsYp9s9RGDi5h/nMoCdoiVFHjq5SzQLaEu6wc+mRTopeAT/MjtozeOtPQ73lWbJBdywtXum/cOOXhWFsOSHubgoC2w9NjebL6cvkRZY4OnPcXQqjshOetItTDUrqMCszTmNiKTcLs4gUtAlSm0oADyx2VyBnmknXEfstsAgwChHTDIpWAAWIVfpDPfplkOCE742XTTlh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(41300700001)(86362001)(6506007)(478600001)(6486002)(26005)(316002)(1076003)(6916009)(6512007)(54906003)(186003)(8676002)(66476007)(66556008)(4326008)(5660300002)(7416002)(4744005)(2906002)(66946007)(8936002)(38100700002)(2616005)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RBCX08kNFpZVZ0H3YllaG9cZlStpWxUWXxAeJEISg0NKGyAUacpT12eL+Qey?=
 =?us-ascii?Q?cP9ooXglp5VFv9uaPyQKZ66eM1wjd/7+sB/O+cCSgRIiCunSrm8G4h5hiVPX?=
 =?us-ascii?Q?KsJZ3rROa22k2enkPIh8g6uEiG0iyOG0QIF6krT9O+PoxT7R1o2di8EZwvqO?=
 =?us-ascii?Q?T3l2seKhUyExR5bHVlTd599vn+aJWAxb2hss9NFjWyvWxcL53OIrgRvqeOnE?=
 =?us-ascii?Q?omX8f8IZehq4OgXDIwe3W2D9hXGRKMTPAKYATZHJ8uyw9oNGCSd1YJoL41p2?=
 =?us-ascii?Q?R+2jEAryeZf75IoonUub+FGY8Lb53Dffvpk2PCZM3mo4/huHO6wRHMnR4T4L?=
 =?us-ascii?Q?invj36O7gWfkU+59sYoYLUHJDx09cmYdPWgd+5VpOfYm3JEXt5JVa+tClMwf?=
 =?us-ascii?Q?1ZS4bht8JcgkisZdUCLmdHT/oQYkN8TFEni7wDzbhdzspcyCqQXjRDBiTP8/?=
 =?us-ascii?Q?qhl3wFZ4LE+t+pLkBWvOnAxmBd+T2x+La+sADfEFNyItTHAe5l37Np69cC9s?=
 =?us-ascii?Q?68G2Yb4dEilLEYQj/mm3MZdHrbV6VkHd6bfnMa1/1N8TpM4MdvDb5CNkm5l7?=
 =?us-ascii?Q?Klb5bbqRMTcOPRDdzLEiP/Q2KmHW92LxGVrcxz+3AC2RBrmI66Y5Lz0U8afh?=
 =?us-ascii?Q?YU7+uEI9NkNa5Jad6KQ6arocze0LmMDRPb52L4NWTzyqT+3OZiHusTeIUsL4?=
 =?us-ascii?Q?QBgGW01SC7A+5gZGxaoGMySMvzVM0fKJLCGfk35HqrovVNGS95Rt1dc/Pgzy?=
 =?us-ascii?Q?cipZHR1QewllvleHyAXroem3yoqLBlk5YCniPXgjieAhNeUpm5SrmVFwwSJG?=
 =?us-ascii?Q?d9i5ZkuS2CHXM5MQxXm7jbo7UIhWdvFyUDiw9zrKOtInUdyUK7lCu9p9BCIO?=
 =?us-ascii?Q?TadZuFrjlo3Uh58w/ZrCzBvmzeEjkRBzlB0OiTWIkA6ULOPvPjTTqp3ekxVZ?=
 =?us-ascii?Q?V6anvyiaF6XasrL87ISXnKunlg8j5OZzii7MfMuAXeAbELlNywalk5y84cse?=
 =?us-ascii?Q?bEgxTktXwqHU9kzGeHk5+e2mBf1+aOuu8pfX6kuSAj/ImmMHmPYn2mUmrNYz?=
 =?us-ascii?Q?AFtIe0Y1P8Ogow32Jo0nOSM6Eja2V7XzenaN1Et1jkTvb6TYWX8Qfjf8l1EN?=
 =?us-ascii?Q?JauaX5CLHHIydEIsjcORumjjwiiSu79ng9XJ8r7qHJ3PSEEpiI4MFlNaWTSa?=
 =?us-ascii?Q?Kb9O1qV4f2C4p15kgcdCxjeaPUczX3wNqezs8poslYIpwA2+B0ifsTJSvtMt?=
 =?us-ascii?Q?LL/mUAPeoH4AmmHgtni+4A/Zge41dGQ3sNAEuo0BU8xWO5p9O7UqLl/Lux4h?=
 =?us-ascii?Q?IRrg4hzQPm+acApxJeNfxCnYIhNX9c7mrlOcYlE3AD/iln3rd4DeQmOfsMEC?=
 =?us-ascii?Q?aEnRbppepSSAliYdGvRsYOuXggJNgVnmNoQc6UWRAKb8lGu8PyrbG+GPR+HQ?=
 =?us-ascii?Q?z/jkxgFV/thNj4brDKSreZk6wg+aofMiJUYbzjzoskaxtY7F22wD4jaIpxFD?=
 =?us-ascii?Q?3Pw131He7EwqVFhiE78vmxpD1fxTzeRE9WtDs8GisDq5/hmujD1cLMoby/3t?=
 =?us-ascii?Q?jIqaqxE2jWqgHMUmI0YuczYpUIGSK1Syfk4D2oLL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2c1e2f-8ab3-4c10-4a39-08da6a496384
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 12:14:26.2523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIbYYdwq10OecPbtZyFeKpAPzL3VUvXKKUxDwn/9frkt597jsIXesLyDvNtj5ZoA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3220
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 19, 2022 at 10:41:49PM -0400, Eric Farman wrote:

> I suspect the second item (or something similar) is needed anyway,
> because Alex' tree + this series crashes frequently in (usually)
> mdev_remove. I haven't found an explanation for how we get in this
> state, but admittedly didn't spent a lot of time on them since the
> proposed changes to struct subchannel are a non-starter.

It seems strange, at least from a mdev perspective, we shouldn't need
an extra kref on the private.

All references from the mdev universe, including via mdev_remove(),
should halt after mdev_unregister_parent() returns, and ccw calls it
in a context where the private must already be guarenteed valid.

It suggests perhaps mdev_remove() is missing some references?

Jason
