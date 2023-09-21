Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264A47A9EBA
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjIUULU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjIUUK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:10:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0815769029
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:53:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGEXnp7HTW18yWzs5fFUviLsGDfk2KHtW+jGiiaqr+164yVxxZlmorgnf3+vu5M1p+nfXmYKrpqXtLEodoMxKgVluLRbCpXFwB8eCawcw2B/GCuaLYmTIcOSlKNz1RuDLcB4ocYPm2Ukj9jdhbb/ujofUw5xid1iJ9EfGYDc4zumZTdh99u1dw578WZShc0qDULuMKtuy/B4bz9xirxQd9rDpHVJYC786iiLqpXsi8wPAi6kH8Bvg5wo5AkLNwITIe3QrA6QD0nIQKuIInKGSvvhlqinVq3Wo+a+eujVSH0H1j7KRgVYOt0444K7SJP4D/mZSmqEKg69aCerZWpbkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e79eqnbQAn+PurW/Bh3cmTknSZrZFTpbwNes30BbWBc=;
 b=GUpOrIGRHUfnhG9jEKHMt/Prq6SLvzYCdSX8b7qMZJHZYn2qRvw0PZ3QqTYOWJVfzh3QnkeQutMyuZ3t2mOfD3huxSg4exY5ViuUTp258J21NdzzHTitXBxuz/U/YtLQMqXYM5Zo/0O7RClSSokbWjswfnjGKBGs80OQ0KXVHRvkPJIPD5LFUDWLSJP4UZ04iKwrxVXgZ/OA8hWOSLlzI0XiHO/5Jbs02+lil8mQY3KpPlqYuNwuAL6EC//Yg13wY/LRYWaRLTOVAMiz+VmbEqYDAMiCmkF5u9lIrmvMoL030zXw+rfoL6kG9rB3Dn8ZimqtEhnTq3/D3jAv2BRNsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e79eqnbQAn+PurW/Bh3cmTknSZrZFTpbwNes30BbWBc=;
 b=h6ApHR/nM8H8bK0zqw0JGkPIADMiRlliZ5met/9H1Mu6tQeAvgDZo9MIao8Qch+JCR+V7tcgYaR+ODhJmZA5OPz7dcFJfK17xX5XrPLJsmi4bzxEBIxyg3xnJqdi6JInGmokvTQjn/2Vp0hkxmfIWV+LLlw3v1VEmhLqqHg+yTbQntoKJRZZ//qh7axwTJ93/aJ2JgQp48lHrKd2VdSaWVHoR3Ak9tRmPvJLp+PUh/r6QgriHYBmTlnZtgK/jjbapffRqH9r2wM2QkokcfcPLjGSzJ63K4IMaOGgoeo4TOW7G/jvqtZENdLI1MEXInqsyH2hS7amrrMGjDL9BFXqGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB9169.namprd12.prod.outlook.com (2603:10b6:610:1a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Thu, 21 Sep
 2023 19:53:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 19:53:46 +0000
Date:   Thu, 21 Sep 2023 16:53:45 -0300
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
Message-ID: <20230921195345.GZ13733@nvidia.com>
References: <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921152802-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:208:239::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB9169:EE_
X-MS-Office365-Filtering-Correlation-Id: 1acba4e3-4e6c-407d-1abe-08dbbadc7789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jcTqXaAjuGiJcA++/3CIn3g0MvZgvqWS4DpinhhvTEej9ceNqaB1d1qWB+zxa7cy2cHGrLzZ4rsa7oWk9uOchoLOXxj33yx0mtNh+Q/CgSZSgUE4vBZ6802BGO1t3U7Y+8R+4MU5Lxn7m0S4vIroqJjDr36+vdjlUaurp5XKD0otgMbEtmdAEgYYL4gpq7D8U8pSpjUFjzP32d0agkUPD7if9HX8brW+sCDt+pV/4yjWF33qkBgHj7ZfkteBJfoZCUNIGm1TlJAYjDfKmKVuNdTPHCSutZ7t4k8NviBh3vEniRcvLuTtfREf4h1T7ki87Q1856jkSd7Zmn0SmXmagLk+4TSSS+j16pyNGHQyXQz4gybgucTxHFA1irB0hjR9UOYBrlFfMO7LP4mC6N23TxpTuie4HjVgZI6H7siseLDiQteFm0zYA/GDAvRPvWKoh27wN0+chBLI30nKp3Q7Hk+NJaGQO8OoY7UnhCUzL7gPUTrVLbU13oD+qJ11oHP9qrVa1qw91QMCnH9f30yn1krX2ut48vBkcp0gebzUasSln5VPNTBapMBkV4cg/VKg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199024)(1800799009)(186009)(478600001)(6916009)(8676002)(66946007)(316002)(36756003)(54906003)(66476007)(66556008)(5660300002)(41300700001)(1076003)(86362001)(38100700002)(26005)(2906002)(4744005)(2616005)(107886003)(33656002)(8936002)(6506007)(6486002)(6512007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZFyDSF+s3i5I5d736+/u8yws4dELlLe48D3zO6JdyzcPfoFQLXBEt8UQzNUq?=
 =?us-ascii?Q?+BoQjTYmRB/HJHmah2/d0YP1ufw25Bl42mBTJsxLouPGrMkAJHshGyF/pH25?=
 =?us-ascii?Q?Xvn0T6DFPTp+gubzWc5wjUta3Fo+pcvWAWCBRg3/6uNjrhHdY33I7d4hogU+?=
 =?us-ascii?Q?y9G5cimtuOLL8pqU+JeJ9cJxk7LKThqGmsjvob7TmbBa+M4Ay4iudk9Guf9c?=
 =?us-ascii?Q?r/LBg7sfie8HgmkeZHrfsj8UXJthVK2Sep2LaSBNdgiFzjSOJ6Awxkp1MKSM?=
 =?us-ascii?Q?Wtmy7Hjx/127rfCIsKU26wQJMLU3TPErImsrumDsawcEnrK1uRLS3kI1BrpG?=
 =?us-ascii?Q?sPSdjK3wlDwInI2gXVCk8p2jrNbcXCasgcud9AuW3Ar18izHnHWEG9IJeq/A?=
 =?us-ascii?Q?7GKoveibaykacU6ZI0PVNZfzUFm31oCLgKxMQi3GS2g+bP9vY21RZh6h2s1L?=
 =?us-ascii?Q?xOAjfEkGCIGCN0ittP5ebMFPAu0OvazHFABsR66ocG3TOZ+7gdBXysfRdSjZ?=
 =?us-ascii?Q?sJ8thDfAhimjpIgRqfHHCZfrxHaXLJcVpC+I5lRKCzfEM5Hc45ec41CeCesS?=
 =?us-ascii?Q?uPKk0zOVz2fbg2Dra28g2FKdnqRl/DXgY1vwLrj0YLjQI1qcAikjtQYzcU19?=
 =?us-ascii?Q?0AJqkdhC0jEmPXqWl46vscUt/fiOFZ/ABKeosFQ65Ae7+FaPsML+KAAcdkrs?=
 =?us-ascii?Q?gkcmAk7jD21ti1zQ8rFLbJj5bzhCO2ng4BLgx5S8wpLGqV2V4ooPMjiRQkKM?=
 =?us-ascii?Q?0B2vewNbHEvDddKBpD3SEnQHvdz6JtimrrfbSR2DJhtQlTJm53YrUo9Kak/1?=
 =?us-ascii?Q?/G9j5fCE7MqHzh0RCsKEobvLa9cg3p8lzgNB7kXz2FiSlXr35fmeky0cgdY+?=
 =?us-ascii?Q?n+Kbg86ZOtEErz5PoW6pfOJ6xXCN+CSAuXfW2WzHQ2fya3hBR7pUqs3f1xTT?=
 =?us-ascii?Q?Uac6ty/BGRvJjfKD+P5rfIiN8lxNYlsdwzon9UOil/v+jhTJnE7JiuWpfnm8?=
 =?us-ascii?Q?k3PYMUHrU9S3QQR+dUjv3MZDAFJKfOCxY+oO5tiPIwpnGEtpYvaXeUlCwyj8?=
 =?us-ascii?Q?JhqkiXtdMNBuQlZNoPZAvvr7umXwWkkQxchfJn6/XH0ykm9hExuxWB2Rqfa3?=
 =?us-ascii?Q?VKkFj2JoVDbMAqukllUIYWrld8w5Qi42phGDbWbrn/5QEpRblQsDkrE+Glaz?=
 =?us-ascii?Q?akLSeYRCVXVKpvAuR1cMVcxBAyhaIUMN8CemE/nJIci8xlWnvKLwpt51Z8XD?=
 =?us-ascii?Q?5Amgms2mvfn9y34enilSimupUNaFsilEYcGS/+ec6DQ1PMWTGcc30joVD0Oi?=
 =?us-ascii?Q?ya/cnPtzquDUNpYqwvR3a8YwC31ihDH+maL2pyOKlwcFDfa2tIyjSFtN3xM1?=
 =?us-ascii?Q?woMZGOTuCPtF+znoNdSsiovDbuf7zp1CT1huHalGPdPthe1kPw58mGniPEbl?=
 =?us-ascii?Q?5x+ZZRvZ7LQeIQFmi7VGQ/G/pW2OI3YlSiLwbTBV/qHCk9wc5LIZKLuVIUl2?=
 =?us-ascii?Q?sh5nPgGnlCPwjRncnXcK5CV2rKX+Qfg+32Q4OAbjp4ZhMIM545JWeUQ1BU52?=
 =?us-ascii?Q?w9yFXESXaNuHfE7UTvXH3kfquAddtpFJ0mcbPyMK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1acba4e3-4e6c-407d-1abe-08dbbadc7789
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 19:53:46.5213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Jm16Qn7Iq4793EosCBuuGQLAZvTnYJVGrRX749TA3lneXtRyZYyY56I8vGhxpaH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9169
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:34:03PM -0400, Michael S. Tsirkin wrote:

> that's easy/practical.  If instead VDPA gives the same speed with just
> shadow vq then keeping this hack in vfio seems like less of a problem.
> Finally if VDPA is faster then maybe you will reconsider using it ;)

It is not all about the speed.

VDPA presents another large and complex software stack in the
hypervisor that can be eliminated by simply using VFIO. VFIO is
already required for other scenarios.

This is about reducing complexity, reducing attack surface and
increasing maintainability of the hypervisor environment.

Jason
 
