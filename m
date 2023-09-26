Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DDC7AE304
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 02:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjIZAlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 20:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjIZAlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 20:41:13 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0457F10A
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 17:41:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWBpWYRrjbkHpXb21/Rw6B8cDkqnLvrQuGDcD3aL5JNBG6mj0ebxc2fyClVdw9RclHNOSIeERi/0n0K/ArEHVZa6ljHc47QRHGqVnwrLlvpbxxtZj5GFqw8rKtnsbgmU/E6pg0rfB7lyvazW54lClE5DwL0tR5U0by/7ypQJWXAeeOxm0bUu6/+OcnJx2RPkdrPN5LCjQhE6J/vFj/jiSUWhf9q4m/P0aiVmCel/0EJ6Rkb1kiPEQbn6TqKLvn5rKCmokuaZQier1XyUgdJnNYeir7OPyadGDwJpAJJaVr9jfNi+doFNLN5dXMM1hqePuxW/03zH/7BU9OTjYQ2lpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPXMpwIb+R19WxdkJ5OWzUp5bgUbFD2KM3I7d7rVOP4=;
 b=SV5YcjFFqSFLtbSs1Sx7e6YSU1V92QPtll4FwtE27rQ8xxzfIdxkVzA9sQMDP42slwQYQ5q56hVAHGNyKh/9gbms0qhQH7MgMHiXy9LY7VBlePVYqtrDQVFZLp4/XQlhvwraqGF2QWgJ/6h6y9p91wt1R+dbZfryMdeJXDKIGs/S4oVwvRoDYrn1swVsf05pkHGOwrafsIJADvPew/qgUZBbJGpGsr2Ta1oSpl5TtcXSC9iHSPXwwOpZWvTazM4BgOh+EGWQPsSzpAgXqT342HoUxeRXSmdLhXDpzBbJHZA4A+DpnUAZYPFkj3smJVKOCxcntecipwjXoEa0y9T6Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPXMpwIb+R19WxdkJ5OWzUp5bgUbFD2KM3I7d7rVOP4=;
 b=hNRKMkr6MkaY1vzsjv/kV706fXY7EhA561/XkXTc/QWGtnm5jcvOmWVZ3QCi0mUcdxmunJYlekAsgmmPU0gAqB6bGv0zfre2l2gWRK1Heqv7jYCjEnuSiDcLVC5Xt0ZkppT/f91Q513Pz655QAerP9vcTvauUICjV7g1sfRKsb87lUFJUeaRct4zYLX66MGY0L2GCDUCfpOUoZNu9+jRyOQ5Sxg0+z264iKoz4miWpurV9w5wzR/45dND38VIQ1wbaRNEmm+EmqljVFXuVlsURpfx++bjU+xThbz/wbsSv+gxR4RJF7jTUzYYrPl87e4q2vHhowvAA8AyxPctztG9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5618.namprd12.prod.outlook.com (2603:10b6:510:134::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Tue, 26 Sep
 2023 00:41:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Tue, 26 Sep 2023
 00:41:01 +0000
Date:   Mon, 25 Sep 2023 21:40:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230926004059.GM13733@nvidia.com>
References: <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
 <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
 <20230925122607.GW13733@nvidia.com>
 <20230925143708-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925143708-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR01CA0033.prod.exchangelabs.com (2603:10b6:208:10c::46)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fc97af-4eda-4cc6-a44e-08dbbe294202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u2Z8ETK2syPlP+OU/ROzR89k18yVOVabx91oPw6bMUXnOoTEDYXe/bxcZZgkjE5dSiRGeibLT9r+EOhebJAFhJ02pOvUWmz9w8V6Ol72gqwiVYcikngtutX4F/zEz/517j1XAJLgmNexvoYRqfSF3b+4xizm5HiLWIvd5Uqi9H1xWqLe88EMVf02yK8yBCO/1Kp8Hctt5UwJDwqL1w7j6707dteSdyggshbMwzx9v/gefBSFI1DZ06IWM6saEImN8gmPZXiPY8MW5tMecSQZvonQzqcgmbXsE4esgUqwkLy8UTVc+KjMLmUBvRG1V13LzZ/Tlvv7xQPLRszRph/WjgV/sfwetK3VPG7JlWFxtOJvzCQ9DN6NxVvHosGbdWotLsg0a5quljEwcqAp1h5wqfQKXmhMsijijdKbo4QAyI+E+IOi1zT3NfLLSKEccEpKCJQV6ajgYIMItaJjAz4CEVaAee8nRtwm4M87y7CYGTfToYBIEHzn9A+IMOkehVPB0Oq9la+kS+1hC3m5PJcwTQ5noOoN8HpL/aNLx6wjE222g+e6GU6/3Q9Nd5s34PQF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(136003)(376002)(230922051799003)(186009)(1800799009)(451199024)(26005)(1076003)(107886003)(6512007)(2616005)(86362001)(33656002)(36756003)(6486002)(38100700002)(4326008)(8936002)(66476007)(478600001)(316002)(66556008)(54906003)(5660300002)(6916009)(8676002)(6506007)(66946007)(83380400001)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PIYHB+tcnGccRNc5JUxRGt4CYdAxRjt6pKnwLTxDTrkAzxQSxxt9k2wuSNA9?=
 =?us-ascii?Q?YczN1C/Maf8KEcBTSShsHUbns/3bMiLItc30KnTX99X2ob1HHhRzUFagAMzF?=
 =?us-ascii?Q?Uy1Hb6nI92csCkgvc+YttPGG9AYAD42UtvTU3ocPfVqninRLg1vx/yZgPwL3?=
 =?us-ascii?Q?jqabGCRtU0EMa8ROO2g3NJLFZ+CBfN55A1rcTLd/uoOpCOzAfcPuARmHdjZW?=
 =?us-ascii?Q?h90dmNOqcDOoYFzY12SFzSO96qJH28J6BY6mmF7MSRSrwlD4FFbkuPFcTz96?=
 =?us-ascii?Q?EW/czHiXZupWTngXB2Czipz+zluZTUKeDek7X1Mg8UvgQ6bPhD0s91/zGxHZ?=
 =?us-ascii?Q?h6NXJ43kYuMY8OYzEa/NMBmC7zFQi0UjvGfCEiBy4YUFU+8vOa37mInJXfpk?=
 =?us-ascii?Q?k0ZWhRuTx1Zz9U59aEBGMHsfLq3EexNllCu2fjmv5c/m/QcnVCFfgZLIxr/D?=
 =?us-ascii?Q?rJj6nx9SgYihIXDXisXs7NGFV9QfRsuN6pGiSh42orKmkGnLVozKycUbRQgh?=
 =?us-ascii?Q?17Tgnd79P2QHbyHxXL0+LpOcv6ZlmvoGNEBJMl4xdAncbzOaKWDoYcO7JYTq?=
 =?us-ascii?Q?zZLc8Zy6A9ag3tuT4JryTV8v7P52W2V2EYNEO1eLbetQrcII26TZuj5/ww4g?=
 =?us-ascii?Q?jD552ion3iUq5oLQsXYptxlZoOJlL+/7qgqpLW03Amxs9+aQv01wfTcK9mWM?=
 =?us-ascii?Q?C2eLfBGQdNi9YSp05UiZPStaQeJkRcn1JhiAEgGFwR1tpwUUo1svaPoopzOy?=
 =?us-ascii?Q?WMBf/WNVt1pIatkMn90tXaFmxYXIO76UiwSF1ABupDJkFytEJLgDyi7QznFT?=
 =?us-ascii?Q?S3NfCLdxWfvfJJBcXXnfJ21IWE0I7QeeHunRrogU15Ar9cIOfuGiu9S5XD86?=
 =?us-ascii?Q?oefKFNajp9QGmxMMoFc5aXWIf/Ay9oKP4mbpIpd7j00jr6eTJYMYeKlSgGtT?=
 =?us-ascii?Q?I/bArj/5n6Hhsb3DrMpcaC/ld+xYwpJ2e1KDUbSFuUOznYyEWPq5IIrjqFK2?=
 =?us-ascii?Q?H3cjsHosUAJs/nG8ALCtCOwwITpqt9NMXGDKaUEEIErG1xga7NcJvPUs0cxz?=
 =?us-ascii?Q?x2YzWpwS8G1y7aOp2nbM8MOsG18Vx7qtEwiWJWhJELwzXao2bR9sagGHsHAp?=
 =?us-ascii?Q?w+D4T8KsdYvxezSZqFTxl0OYpgehsTx7jFfpFpJn83+KjKyGJkaFx9SPc3p2?=
 =?us-ascii?Q?rJk5qTn+e868nc2ED8NrvDB5QGRrfI89ENOxhGVAtQKL1cgL02fl1GbvBJz9?=
 =?us-ascii?Q?OaCj34334UzjPnQykP2y+2HW0XPw84WWX3HCkGDcIkGplDHSLM1533Ycpzf7?=
 =?us-ascii?Q?ZMl+745H9UGTGV0LjmfRj8KKbe3676+UQVYiEdH/D5llP1Zwx/EnOZAA9iwr?=
 =?us-ascii?Q?mFpItnUxdTLID2b6i41FSbhm9PS5ob/TvFmTKn2gssTcbz+e48QCjPhAugjg?=
 =?us-ascii?Q?0EGVCHOjU0addU3xlvabOWaMd/QqPKdTYS3mWa3wrvN2WVxAhDtmtdKaz6FB?=
 =?us-ascii?Q?YxCuYai+RzBpy+Cv+KlDnUigG9o07m2jYDZMwKsIZ2xz0rzsB374tq4kR6NS?=
 =?us-ascii?Q?dLLJoQaKV5atxrLDwEuXQDd/DvUlZIMU6CVwtsil?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fc97af-4eda-4cc6-a44e-08dbbe294202
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 00:41:01.4913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z07Zu8inh7uLkIwXw3GxhurKe6eEDRH0ZCMlr6BmfgwNFTToZFJ/5wlgBo8Y4J25
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5618
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 03:44:11PM -0400, Michael S. Tsirkin wrote:
> > VDPA is very different from this. You might call them both mediation,
> > sure, but then you need another word to describe the additional
> > changes VPDA is doing.
> 
> Sorry about hijacking the thread a little bit, but could you
> call out some of the changes that are the most problematic
> for you?

I don't really know these details. The operators have an existing
virtio world that is ABI toward the VM for them, and they do not want
*anything* to change. The VM should be unware if the virtio device is
created by old hypervisor software or new DPU software. It presents
exactly the same ABI.

So the challenge really is to convince that VDPA delivers that, and
frankly, I don't think it does. ABI toward the VM is very important
here.

> > In this model the DPU is an extension of the hypervisor/qemu
> > environment and we shift code from x86 side to arm side to increase
> > security, save power and increase total system performance.
> 
> I think I begin to understand. On the DPU you have some virtio
> devices but also some non-virtio devices.  So you have to
> use VFIO to talk to the DPU. Reusing VFIO to talk to virtio
> devices too, simplifies things for you. 

Yes

> If guests will see vendor-specific devices from the DPU anyway, it
> will be impossible to migrate such guests away from the DPU so the
> cross-vendor migration capability is less important in this
> use-case.  Is this a good summary?

Well, sort of. As I said before, the vendor here is the cloud
operator, not the DPU supplier. The guest will see an AWS virtio-net
function, for example.

The operator will ensure that all their different implementations of
this function will interwork for migration.

So within the closed world of a single operator live migration will
work just fine.

Since the hypervisor's controlled by the operator only migrate within
the operators own environment anyhow, it is an already solved problem.

Jason
