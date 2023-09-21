Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DE47AA0C3
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjIUUsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbjIUUsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:48:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7EBBF117
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 11:18:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqqNvd3WClvf3EHA4otMPgOxYxEkWrMm4HQCu8Vm/7dHJaeg9RZth7hMKB6Nba7HsO/XOt8gNZkYTZON2qvy5eQC+vmVIh3hPRtU7JG8qArx/7QrB1RRYzgUvzzrNi+dkII8HRyJIXuB7LT/6Z+Twt8zlRre3NTMJ6BTALNXlHTYS1eXxILivSsyAqRZfwK3mYbCFvk1Dmo1vPvDoOpO3TucstAtlfauQMEwad/unWmAFGpZH36drpD7ixAGjUJArAWqeKDzedTOzxWIq+GJm/48B3ED8ldFJZisjLM9B1xiO4MUFPVE0uO47MwMt8NlNRbBfKn1OTu4lCu1CM4VEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOvR8031uVAR9/0HE4CYQvaeyUKuU/lZbD1Xme9+YGM=;
 b=XuFbcKt2gm1B+4aYn8LTzz0meJJaBNU4QWB5q7rJBZQb6fI4MU8Tz4ds8Yd8SpxVh3VsXJ27XcRBzaQDbatoVtCWd6Cba1DoxYRFnDFtYPpVDrAuoUdRVYdksZfcybfTjvJ2ZxcX8aAWMyYqNxJBZAhGx7IygFk3SG3XAqdNdJHZ4phf8Iy8WjbcYsGyVbe6E7qHHjXpsF/4Xt373CfXdDVQENKEtQnjoFLQ78KnCL6pw8Ny2ZzdEG1m8YIkZ84CKaDQ+XA9FJ8BvJbQRhE6h4KTcqzHvwq5cmObcHOUjMCF0Tjky7FuP6hZ/179hDs3LIWWgZBSBL7aFffZE4dnNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOvR8031uVAR9/0HE4CYQvaeyUKuU/lZbD1Xme9+YGM=;
 b=oU6rhV8XCBjrcW5HHMi8uz9HmKBq2EEK8VBax4Ra0h9LLd1epOf1BJ0DuWQbStdHH0c9sRNKtUXTXZEfKjin+0ye8/qurcEgoF6WB/R6E0iSNUQT4f4Yo+UhwAyGOCz0jBiQGf75e6i1kFk8Y2X9U/H8bt+c5bOo+oifKmx16geLO7TvSFoWcmqVlZFNupocKfRhLN/m8P9nCK4oggEGu6uXfkp7LnE59h4ItIfH7a118j9gOwRr6u3HT96nXh5/dkNt6rgyf0t43dZ/ji70oGALSoJWWqVSzTawu9K7Dvngta43EztP6I+tEdT4n/GLKxkysTv3NyOpOl0cphEhCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB6669.namprd12.prod.outlook.com (2603:10b6:806:26f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.23; Thu, 21 Sep
 2023 18:16:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 18:16:38 +0000
Date:   Thu, 21 Sep 2023 15:16:37 -0300
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
Message-ID: <20230921181637.GU13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921135426-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: YT3PR01CA0068.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB6669:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7bbb92-2d61-45b3-2a3c-08dbbacee5e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lIg6nLPE0Qhyayme9/JB9As7yXnqhPf235TmxgHgkeMtrKpnKmRDlZLrNGO7PViZ1YjOO6Qs7pOxzt064dkxmoK5+8iKJ0wPK6QeOS7Fd8dYA+ZiKq9Bc25qs5bB6lm/bpfd1/6mbCUzBssZ/eX8LaNW6dcnnGshgATBzxeyoFMEvjjhS096tmGh7auOS7Z1qrMaBuJ2aFQWMfTNe3IgjQ5yyQ6jtrrVwihq0PkoJaYhKYjldJ8gImN7jNDRFMyFeVo2+iOEHS7j6sfnCkLoFlNk3rc0FHJBVTNmFWIY5NXVK1W43gusMFt/ZAuSriLedprnVJEOkLBjOMEnDyG61Sy/pwVYItqaN+lBXvUNrIN+uJmD8tKJJdTRNJqUUnb55wLoX/utgIM61BHv1XMmoF2Ip/GQm2a+1AJxZfIw8KwuucbcZKkg0WpeYLFOXLnPYVDL0gW84sHiGG6hnaAucJO8H3rW2csH6jpC30PiKzuxff9JjuwajImrn01rjNPsogH5vVqFxhiKdEHVgVit5UbrVDyahl9ogotB7o22Ew8tpd6XOcHa32/9+i+WK7Gu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(376002)(39860400002)(396003)(186009)(1800799009)(451199024)(66556008)(33656002)(8676002)(26005)(8936002)(2616005)(4326008)(1076003)(2906002)(107886003)(4744005)(36756003)(86362001)(6506007)(6486002)(5660300002)(478600001)(6916009)(316002)(6512007)(54906003)(38100700002)(66946007)(41300700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q9hOtTFTk7ojFYI9MWzBd8hSJ9KbBw3On7BSMrEsE9CYjJ120GYAmjq+T8LA?=
 =?us-ascii?Q?3G7Yup8xIKdfWLYQ2CGXgxbbebJRbxeodOYFTYkg5+qSNyP8Eu5+rmXVdC5w?=
 =?us-ascii?Q?TrVGsw6POmeHMaeQK9HsA5ikhGl+k3Om01U5tGO6NaqCJM++6yhHQ2MntSog?=
 =?us-ascii?Q?c47ygdp1aSUnWewFNfEXlKcithz/uGibjHh9/L+ZZRy90h0pxuro32bsTonm?=
 =?us-ascii?Q?0XnOm5A4sC2tHKgdCTfQ8IZlSL8eKl677Z9ibr4F5j/gjtELP5hhVciBcjIq?=
 =?us-ascii?Q?j0papvEhgTOOSCT13V3uLdBYj7rwLLGGMoc3SY4gSS1CbkfGCx/MvFUP9Vm/?=
 =?us-ascii?Q?coIyBpaDD+FSxPCKntGFZfmuFzyHWEwwjBiB1m/KE0vyvLUENhVN/rAWvaWh?=
 =?us-ascii?Q?/bOcW6tnzArZ3Eas+8R/vMrnxPduMe2ZViM4xOo9k9zjN7RNBWyku64TRc5b?=
 =?us-ascii?Q?qItl9mkdL8wMYVAUrBBHy84fVHF5Z318tQFovtCgSxjbAPiHFuS5P4e22Dc6?=
 =?us-ascii?Q?BLwK8pybyvx8RhMifAQ/TPMnvwWfiKA7iyCTUKqt2G6njT8ha1l0O1lAOOXn?=
 =?us-ascii?Q?Vk8/RZNcMzNPr/4aEX9SUVL71Fla9+VqMFn77C7GF7rg8LCXVVlS9GjFJCYl?=
 =?us-ascii?Q?PRRqTgUJ27rmouR1RXAjd3OvgS6DiWe40OfyxyTkeTu5WRctWOoaRSNfz2kE?=
 =?us-ascii?Q?1l4tDS91VGwZCD9kLTffc99cHtpKGkKgta+dvrMhJqCZ3stbAbiRbEYmbqI9?=
 =?us-ascii?Q?p8y1Giu9N+udaWXv1SSzYCx2TCxFn+Zi8V3rC3UQZPofrm/DTkX9SQnuRucK?=
 =?us-ascii?Q?QLVvp62vfKOa8UInAFDsyAy0fJ06wKuCrwGHZO2ePpSRnaNchWQPR5kYK1eQ?=
 =?us-ascii?Q?ZNXZt2/UQtRoFjXhfSCQEW2V4YvS34CMHzC41OHnai19+/y5rGgXbwsUnElR?=
 =?us-ascii?Q?+YhWuA+wg/1dlALu0TxIilyAFICjeUO9TT2xgwJREVch6q57t/ZfnzLsOlCw?=
 =?us-ascii?Q?uZ8KAXrlXgXlKrXdeV/ZRMDoJNj451yvmr68iQtmg4bweKqVq4O6zVpMHmbG?=
 =?us-ascii?Q?5imhNLFcG5zXRiswYPmLq7tDO5aWUrG0h81Dc6IiWXovJQEqMQuUMpJnAABE?=
 =?us-ascii?Q?XA4xpASYxa1TkrSLgK9KSrTj1ZCQgyQTC1jBe4uu852gHezxuWjVVzD4Auuq?=
 =?us-ascii?Q?e3zuf8Ry8xeEM0vNb/wzmms6f0TQwiCaBbz4IsOL3VBiEWFArcYnMNKs/R7f?=
 =?us-ascii?Q?b/bV2k0U+xOsIlERs76O1Cot1umDIarRW5Wg9uOs/59IBq1W4v7qSFRprmVs?=
 =?us-ascii?Q?NsWE2Nlkb/lVa9H7U5N+0SwXNXh2ApeBidd7bey4EEyEpzrHBtrfK8rkxnDj?=
 =?us-ascii?Q?bUrwLJqnNvVApMR4u1haxbonBS2WHmywKTi/mJfrUxAHy8UULoI5zCWp5xgt?=
 =?us-ascii?Q?eDmVFrJWtnzpOPWm3c3fzj5iv/gk6ABmsGU7aohLP1Kc+WPhR8IdtCC86a4b?=
 =?us-ascii?Q?wHfi8xAIruSRUiDS5arcSlKSfgZo+8kB+O1CuIfVZtguLtc8ujDCXw+iC1Yw?=
 =?us-ascii?Q?dzRhfNEjD2HU2zIQG+m0biLZeESn13fT76mzqh09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7bbb92-2d61-45b3-2a3c-08dbbacee5e9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 18:16:38.7880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXCFKHVbCrxaflwSFslZVw4rKeexCjGnWXX3qZV9GvGxeAJyjibdLoE9Tfjh715w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6669
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 01:55:42PM -0400, Michael S. Tsirkin wrote:

> That's not what I'm asking about though - not what shadow vq does,
> shadow vq is a vdpa feature.

That's just VDPA then. We already talked about why VDPA is not a
replacement for VFIO.

I agree you can probably get decent performance out of choosing VDPA
over VFIO. That doesn't justify VDPA as a replacement for VFIO.

Jason
