Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DB8585582
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 21:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbiG2TSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 15:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiG2TSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 15:18:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B8F81B3C;
        Fri, 29 Jul 2022 12:18:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9U6xK5jQjqTchJVjsGY/5gfZjBnMP53AaYPtYrh4DNA/JlEUObOtyBMM6v4hjRyA+abnHyQhlKru2R0KoyR2FoMfD0xuQmvcELs2JkP8L3FhCAauh47uKCWGBIFXLPNSizTbF44/720b/fSyNtnb94oXSdVDzlM8SHGaYROJyMn8nzeUreAvkyynhoWNzkwsieE9DRrBr5hGcaBQnmnOKVmRPtg3RSccOzcBz7Ls6i9dN2Ie9UasOt1RKLOHGk0Ur6RXFeFaKxy5sHLLs/88u7C4bfLoeDkFk/MgAk30G780mCs+KS0ialLUfwyF3Zyo6yNsLSx2D9LtkLu4AjISw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjrY2RFGmvEYxhP217cMzNmOYzmew87Bvz4XO/JEq2c=;
 b=EU17bo60CJbeLsY1mMaXXqs8miBm2Xov2aw0w6jocJaZ6trEsTJ95l4t7lgHwSy1defuyrqUmNJlMg/cJ4+vNgQ0xktii36T515vWhkoS9cxWW6plEoCNOkDf8w86Wmh1LN42cfBjznpMeeQl4dZXGyzh5NoSjPsgs/HVEYmjuSIa40pIPRJZ2Ue9k1hUm9i24M1n5SVxVEfSCIbH9wuyQCg3RLgG8u8U649tebYbgHrP/qSrjhYBqaxSXUgPrfTtULUnvrcLQlBDxEdWDCG5AduUKTpbuu87/B6WeqeRl8Pbwib/GySt2+LRSWNZT7u1DwOxDbPPzTDd1QUBiAEvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjrY2RFGmvEYxhP217cMzNmOYzmew87Bvz4XO/JEq2c=;
 b=OyfDrV/gA5ldGRWOSzJ/bYmjG2tvFqjeDYUXwPngnc2h30YzO5/Ew6dFaMNars6RsMmcxUOj3acr9KzcZ18TYoEIdJNvlJIxh4Z4iWvXYrmc/qVhMa13fi+RuK8H5mqcmHlokg0kGOZpGMXUsf830HKj56ddoaDzLsdr4q6tiA+MWcx451li/y4xvdK/8UtWzX4NvEY3Dw/2KQN5PO7uR1eElQJ/Hm7KscUwu2VlT0ODykysmSejYNDiiFCcN68UUZPKMq0Nq2vYkXq2e+2lzWoNWIcTVx+lx0yqulUJhP5hIzboa0N0rjLezjx6FtWJMMEtpi/A8XGq+Bv3knjfQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3551.namprd12.prod.outlook.com (2603:10b6:208:104::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 29 Jul
 2022 19:18:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 19:18:44 +0000
Date:   Fri, 29 Jul 2022 16:18:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] vfio/ccw: Remove FSM Close from remove handlers
Message-ID: <YuQyk5jiQ4RWpZ1z@nvidia.com>
References: <20220728204914.2420989-1-farman@linux.ibm.com>
 <20220728204914.2420989-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728204914.2420989-3-farman@linux.ibm.com>
X-ClientProxiedBy: MN2PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:208:d4::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 651468de-3d90-4ea7-e339-08da719727a5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WkceYJEkNovDfp7Oiw629bzGm+zaLjBdKO9GJGVy8XbhCYM0WrOkjrHjoo/F47h/n44wNVX5/nAGad7vjAvHnWYtT/QRBrVB0kSctL5dpHmfgCVEWZ4SO3CT3KHbUtD/ohw3MjuzJBi6jLMtaabRb91sj42lHDPKY4FC5uWuQORmVdhC1u1zng+eRJ8dlDlpgz/aR/su13MBONB0bl4cY8hLLb7CBksB3CDozXNxynyerdTBjIUkiQV8SrP1m9vC5rDDNpI22fLT2hDnVVIUqUb7J/B3v5UmoK7ByqvaF2U+fYpIfKz0lIuevnR48c4weRg9GKmtHiFDVpVQWXGNqBb89XnpaQxNkpYjJWMk20ULGLg6ZfemOaGDPkB8Eqpgo/rVaZrk9iV92hU5lYBKM9hYmKsQQfNoIf8TLgRICK86pvV3t0XIhhjB8ReZsLUQZf3j+faaS4WMvLlMFBkIRbpZGS35qhlvhYLqyL3hp7i8nfJZvzMk6XRfrPE2ZH6371KoVPayDJFQYKI92Ak/FBC5VSWk6z4DlobpYnGB2K70Only9b6biqcRX5rARR2suPXbbgHHtQtdMToprb1DN82aWM9v9lDW4eZguscoZLu+QADwawCaHiuEkJlnkeIrOl1vIvL6frMLaoLZ/RiyFFzA4DxkNVbCHVDDd2VNfv1FXxs63hnYqD/2nnMBGjp3/RGYLGM5VLsVMfcw53xYgCFJcy+5rHIdyy+nChgJID9We9dkLkskGFn6n2+LKmrn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(66946007)(66476007)(4326008)(8676002)(66556008)(8936002)(6506007)(4744005)(5660300002)(2906002)(41300700001)(2616005)(86362001)(186003)(6512007)(26005)(6486002)(478600001)(38100700002)(6916009)(54906003)(36756003)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UsU5LUUw0e9rvPpDgC8hMn2ckrxHfASiIYANIGnFb3l5HA1RzKCXL+YIphSA?=
 =?us-ascii?Q?qcO639g06WqQxUSD9nhYrqA30IQwPJ5DGFjlVI3SpKQnlxngJeMz5u0ckq5K?=
 =?us-ascii?Q?/VaYlZ4wbaO9lB/I+XP6QyzcwJUELWFTIkVQ3blGuCTLWGpXb5QCiHVUr5pv?=
 =?us-ascii?Q?8ZeErBzUseGsI/W3oC9DDFgp/o+EGuKDKoX+lYbFa84mpnQyVNITuQLrj4pa?=
 =?us-ascii?Q?WOv7U5Gn3BWMIMrCXD11/GM42hV74ptSNCcJQDUzqG6QDWxYSRxkXs3Yu3NL?=
 =?us-ascii?Q?4DvkPPsFoXa07AdsEf5lY0AuAdvMTpSjq0Xtu1AfFQZjrPWAx8E4RKbiKt/T?=
 =?us-ascii?Q?XsjvXelkO+qY7lnTsPKDqvk+kyBSospupo8zuv5yl/3I+pLU5idzog8AmGiJ?=
 =?us-ascii?Q?JpPgvKAYtQ6nONmdRtcRW/OC9XbUjd29Ur/VJWsjpQtosxvRc0C/9/uzvWmT?=
 =?us-ascii?Q?kStSEAeTVGHXhkOvRAjI5cYwpG5vH5gwz1fqp92PdgSx4vJ77ROlUx+mGCZI?=
 =?us-ascii?Q?t73vKUWse5p+oqU3wxg2S+YaiOp+cjk2FtPqds1krMJDGgof8XTqQO2edMHw?=
 =?us-ascii?Q?k0falThi6pARkiEBQSe2v3dHFaXaRuZJ9GxlNnp68T0ymTWeh2RB3/l9rM1F?=
 =?us-ascii?Q?GRmbTSyr/tPsRFN98zgo4HRs7knLCPf/sh/ikKHylTaRhHCDWc/CsI0JiHtz?=
 =?us-ascii?Q?djEMHsXm2jsewdnmZ7U3TZo31/zqBfntWQ4AIa/f1ZR/2acK2Q1U1+TFGxBd?=
 =?us-ascii?Q?gHJLheuGuxBqNLI8O4WHs4FQ7JszEVmJ12BijW5wQtbO7y7RiYf7fIqe8EZx?=
 =?us-ascii?Q?qGigDsqE8ICw16/HMo97zwTjxpceovXyuivhCX4pwAAtofS44FKaJKXuqNk2?=
 =?us-ascii?Q?wyGuZ/Onrgk+rgWXFfBGiXG1JLbDN3sUpOL35OyUdhC3wghBnRQJ1aa916U3?=
 =?us-ascii?Q?trX8KPHseawDgzM/7clioAErsDmUSAcLyf8EdO1HUonPKmKYT8JhPvrpbAWG?=
 =?us-ascii?Q?L2l7BI1vqSMOTu7BShnFWs7+IMJZUWUtsvIVXWPYR+BaQqolnxdyEpPoal/B?=
 =?us-ascii?Q?kjehJ7+0pvqR/oo03pOBo56jfyetY1OKFRPgTRuczKZi+LxWqzmMGv5dl+/6?=
 =?us-ascii?Q?MNHu4QyzzXeTFkhaB6dcW83Y3WEhSqEz4PyOpjzvH5iHCF5mbPXtcXavMYaf?=
 =?us-ascii?Q?lkaGlk3dI8HflfG8YVmMm/XIzDaDnXl9GKox4XnU3zCN97rdPpbFMMLV0ckF?=
 =?us-ascii?Q?E2hfAATdFesLwC0ISu/0x7Kt/29v/AiQ6ukVzI9fO7lnUJTqv8PrfmmYZ4l/?=
 =?us-ascii?Q?m991cQSZLoPA9MXiSTyfToI5kDyNWePpoPeHVUVUsLJtqhpLHdB2tEsglG72?=
 =?us-ascii?Q?3W+DBgMZwlWlOVpR8XNxIq1pk6sdzUTXAGNU7dLceCQItcfvxnKFbvRwF67W?=
 =?us-ascii?Q?F4I8ttAaiKU3Kk5fzCWuEXM+AOFd7IjZPL3G5R10AJkNJhKjNjGt9f6BIraH?=
 =?us-ascii?Q?gqX6d1+i6Ze/NI0oNcdGqwatFfgaNa55006EloGJuw4f3xB0lwUrnrOuSL61?=
 =?us-ascii?Q?78B2bpoqAJvpA/PVgrcnhd35tBjjxJfbe6OdW1Uo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 651468de-3d90-4ea7-e339-08da719727a5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 19:18:44.9135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OzYiEHCYHxwZq2n0WsZmgUS0kn/Rk73Xtxfmn5ZdWOQukv5a4jT5ypjfHZBOccG0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3551
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 10:49:13PM +0200, Eric Farman wrote:
> Now that neither vfio_ccw_sch_probe() nor vfio_ccw_mdev_probe()
> affect the FSM state, it doesn't make sense for their _remove()
> counterparts try to revert things in this way. Since the FSM open
> and close are handled alongside MDEV open/close, these are
> unnecessary.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c | 1 -
>  drivers/s390/cio/vfio_ccw_ops.c | 2 --
>  2 files changed, 3 deletions(-)

When I first saw this I wondered if the CLOSE might be to expedite the
userspace closing the FD or something, but we have ops->request()
which is supposed to be doing that, so it doesn't really make sense
even if that was the issue.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
