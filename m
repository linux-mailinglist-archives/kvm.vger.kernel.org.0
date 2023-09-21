Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9677AA577
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 01:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjIUXIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 19:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjIUXIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 19:08:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEC48F
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 16:08:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gecKuZ6ybSN2zed3HqR77w0FI7SbYuscvRgLtfQOV7FCnLwOGBgcRSrik7y6hQm3+IjFYjU43S4dVb3xeJlp1RUaqUnWa8DbZFPfwmRMU03eweTXX+gK0NJEQyzdCKcIIUQn2pG6cbfcxMJmki1UVvZuHoBYGX7Uvgwgv9jvdFjapPcXh4fXKhhveKaNMZNZCzCQhoZas1XOgvsUeyHw6jXs4Irlztaj6b/q9hRPiR5XbO4m8h3zIaA8htBPiEEuftBwJPutOtlENsuujAs3VHPFm0FRrI3pFCK0olJa/UTNevyruaO8ZvKX9ReeC0e+PMrSEX31kfMTxZNayLOEhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pXpJ0xBQNZQIeU1wVw5XSnODNyGyAa4MghDCK1ZEmE=;
 b=Iqb9Oy4gtjXBIHr0hrE59Cif6MolUM5OgD+yep5OlVPOGcpxfFSgFsnF1yIL6wsA2C2W9OGANqF8+MWULYTAWVSivIb7cBaMyY7tF0QP7kAy2IAXJGnE/5oTD6oRwi3VDFoD67R++mGzjfiFcOavLtvT83AdRE7gVoYiT0n+iRZutSMDJvoKLadkHmoJ+F7DOiiSfQX+80f269ClkarsiwpkahibE3OMEkkcbR8HHrSY5JkgHEE4mfO+w0rOHNm57zDdKejkptHUeUGoHBWJxXMpUNI+odd6fsOC186Ig8bbL5yLZCpO9fWu6QXz6WwcIJ+hmF40WTNV6OqiHGOIUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pXpJ0xBQNZQIeU1wVw5XSnODNyGyAa4MghDCK1ZEmE=;
 b=TVro3/Oh8l60PKicTtJC1LCpPnCByzOrRllkD7an6euPyWBfiegTXfKmoZpgcyf6vNawuk14WWqleV/XEJZacSERMllb42LGY7KqfTHZYNEGoubXCwbtrZn5EzLqrMIWTLI2GohV3xraI9iywgPwLRoi+g2CEnDsHoU9SklNiRijcd1sljCr4wQdWsky/dUJ/fMdQWb+48+8plWMyos6o/DimITrKZlXiqgtPiCp50zCeqYCj7PKZlg41smsg4Rz+BgRLnWHbYXDYBWmCwGrREYQqKkP31q4YbYHoGJzfkkBv5vfyta1Llo9eDBIbIaqXiw+/r2sM8SKDYH/P7kjhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7465.namprd12.prod.outlook.com (2603:10b6:303:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 23:08:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 23:08:13 +0000
Date:   Thu, 21 Sep 2023 20:08:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921230812.GF13733@nvidia.com>
References: <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921151325-mutt-send-email-mst@kernel.org>
 <20230921195115.GY13733@nvidia.com>
 <20230921164558-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921164558-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR19CA0044.namprd19.prod.outlook.com
 (2603:10b6:208:19b::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: d56ffd37-ef9d-4db7-8a5a-08dbbaf7a19d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BKCsDaHco0uzCeGq9W8wj5nYxSu/y0ZjYIQRfVww7ZeN6jRUtWYjpxjvGRApjbZ3LFOfwu/YyOh3uZwETg7sPtva4QIzyEr7FYz9F68eZx31uRa9wKOAC52zqrT6wEO3sCdX3RPpSwUZQYbS81fYnTGB50qxFG4jcBUZbcjayMgbvn5bt22OMPGQ8E+I8aK7y8Idx5FsjMg2VnOo5xONU1q7p/hEgAU/QpLYAaLSCe4BuR2apKIYZgdMzQs0eS+EwlMadAQ8AscZYj3H6k6sYnOCduI4jviINH8pop45GX2Ve8rmLqmrt5krRyctYbmlgq5aaKz9fs9WM3UaD4ad1qPqQCEXHDVmJnJknPFcIseXJUHTlLZrZTthjR1BNyLXNkLD9/Gnla7Qq4VcEvBIDxvMgRJTw01Qs3dNq5yXlFjFcSN3NMbhnuNcdGjfErrnX1Gt4I0G82uWzr6wE4XKVhE4VPgxSQ/wpIm4sf0B+wxlhcr/9grccyycOs12OQm7oq8vOmXbPk9RQ9JQTUurKJUvBF7oSJAQMOj3b+1YkRfEu2SYa5skFahwXY4jw9xB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199024)(1800799009)(186009)(6512007)(6486002)(6506007)(38100700002)(36756003)(86362001)(33656002)(107886003)(2906002)(6916009)(1076003)(83380400001)(26005)(2616005)(478600001)(8936002)(41300700001)(4744005)(316002)(5660300002)(4326008)(66946007)(66476007)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lEYqTNN3An9qlAPg0jjuFEfNRL9zY37WxLejfkYHSr5fO0zFC6WeEWXInFaw?=
 =?us-ascii?Q?vEz7rn3NdqtfEh5oDIMobE3eb37CqcGGJqsA9n+FMb+KUUUUgZclw3NGrio0?=
 =?us-ascii?Q?hqNTTXZSqEemS9umchiPeUQ10Ba6Iz0wPY4KylYWZZTIxKl8EE1qz2Ke2tfi?=
 =?us-ascii?Q?Ns02j9alSTdcX8/enQPB0/hLux0uldnhvaVr/CllIqreQhYGG/fIOoeTdy/Y?=
 =?us-ascii?Q?PeKxPePQ6VpBwr+aTgNiOUStE3SyCWFAWcKmPU3pv8HdMjHPKut0/gwNs8+Y?=
 =?us-ascii?Q?IGB7B7MY+8JQS90FKZAUMh6QvvI8q8IX0BbT/+9fWLZstsbxPeh9iH6gxuKI?=
 =?us-ascii?Q?N70Oxu5gh9LkGkoVrbWXojvsj3K0xYz7q0QmD5zferDrAHDlPJkQanQ6+myI?=
 =?us-ascii?Q?KXp6N+bAScVg0d3VURZkZfg9o5U3IKzwkFCglEW8+kuUZxFxj0r5X7zKq99B?=
 =?us-ascii?Q?bSMkn+mRn6lxDoBLSgGLR6skYGMl1H4bpXIxtsWdFB6AxxM/jYdL6fwgJ4us?=
 =?us-ascii?Q?69UMvC96YnHBQNoTiWJ3bWnvokrDyEJ9vZk8NAQe2o8T1C4l5MJ7EFCKB7Lg?=
 =?us-ascii?Q?HqPOW3VbGVVb48PirAG/TLU9L1nBYvHQnZm5ijXgDLNwEZ/FkvU04PDWKga0?=
 =?us-ascii?Q?iJi+qbYmECo/H3dTskFyo6yTfCN9riTQYxHTmY28q/oV1MpfyX0jrCZOoA0u?=
 =?us-ascii?Q?L/vlkiwbpy16u70u0OLL9GXJOHdDHGY6qMHiiYedJzvB5KUjsxMUsEnBrx5X?=
 =?us-ascii?Q?hTNljTyfOvBUxXuyfrls0SW5Rfr1veX1NdrcPqToT2UggiOPBECSxP8yvecI?=
 =?us-ascii?Q?ppMYMjKSublyMnaGNPJWug7CUId0TTrBKEiiur+xjAq2fzg1UsHla5BqLvlQ?=
 =?us-ascii?Q?z38gfY4+HE3Gsv5N3I54MpMHohxQfUH1dPiN83XRlHKeyDoqUbAaFAeW6dLz?=
 =?us-ascii?Q?jzzoDfGSmUt/bagXRBKUhHdUsvS7IifFVd64cqkGoVec3UJzF8PgkO5e5kEe?=
 =?us-ascii?Q?9KCI3PAEzyy5Gt0KF6e4Honvo0GQaBtqj53x7qfsXPoG6NE0o0KAIQYg8x1C?=
 =?us-ascii?Q?zi2brxTROoDm9GC5PH9HGkHDfL/cvuM1no1Cnekp1T6CvUbG88bVVt+ejlll?=
 =?us-ascii?Q?/zH7fb/YCC/CmCC+PwmvI/JrA9CuomPOYpCaSKQI7LCTRFMASHJFzDEVZXFN?=
 =?us-ascii?Q?HrSVCIHSQjcXN1G3NiiHz7CymW7EgmBxkXJPyTEdjrCa/QgO/pNlhhsi91z2?=
 =?us-ascii?Q?jQf2X//1h6+142ODmM5+GtkdYxsP5j5osziGcgHdi1/swk6Fv0mH9qgReEsG?=
 =?us-ascii?Q?AjE3vAjE9uKCPf0MBRxuJtyi0WRFvS+bGorQgc9tA2l9CCQGFIDAgwIM6nNJ?=
 =?us-ascii?Q?gOcJYcvkAmew+RM1P/QQQuWbmIkdLFIVtHZfelcz0y4qD0A29XaDSEnGWTqG?=
 =?us-ascii?Q?fF7a7WsTm9CrnqTXg4pTKA2hCqyzNZxFJaHt/QNkwv7AZJYWsylkqkGBXnHe?=
 =?us-ascii?Q?5t65/7eKTM6RFsVOiXXx7SA/DF9PeMgtdxn9Xpmr0ElsyHu3Vfeh7jf4yybm?=
 =?us-ascii?Q?E2++EbZeatrvEPUuK3ZH3uujQ1kM//45ohRDB6HG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56ffd37-ef9d-4db7-8a5a-08dbbaf7a19d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 23:08:13.5473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iu5pxPE7vZ8iFH+Oo5aJs0c633NPyVDuX2HdTWJxSoNOutFz+B5pjGIspNDzk0j8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7465
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 04:55:05PM -0400, Michael S. Tsirkin wrote:
> But which mediation is necessary is exactly up to the specific use-case.
> I have no idea why would you want all of VFIO to e.g. pass access to
> random config registers to the guest when it's a virtio device and the
> config registers are all nicely listed in the spec. I know nvidia
> hardware is so great, it has super robust cards with less security holes
> than the vdpa driver, but I very much doubt this is universal for all
> virtio offload cards.

The great thing about choice is that people can choose the
configuration that best meets their situation and needs.

Jason
