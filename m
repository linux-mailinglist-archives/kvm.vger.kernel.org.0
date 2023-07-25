Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0376202B
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 19:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjGYRaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 13:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjGYRaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 13:30:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2123.outbound.protection.outlook.com [40.107.243.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FB61BD5;
        Tue, 25 Jul 2023 10:30:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gertzjp++6WYYG9GvG2WhhAHF6yy1Q/+HaK6L6Zq+f5Jf1QspDZ+TfSmZPClmnOYPxv9FtgMq2/OsJPcHA8qhaSXiMlsyGnTM4QKzbDp33m9p+8JKC6bFyWF8t3IGOVaa6DezV07pwD1iwNogJmY7W4tXQa6IEVejwTPo1s2HlV+vbz5UYW9AgJpyOKTCHFcG/dg7H0Zae3niC2/Wk0pg5ocDv5eps5NeJDzCftEtBORiSU/BSRNEQugIVp/1oCLJDpuvtEIq6TvfHqcx6OVsvpvVTQC7fOZ9nPXe8zSqb+3GrElojAhz1jFwssK0t6QVH0n3igKn5DWV4Nh2kxqhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMmQ9V0PutOLJJd50e2ybLu0DA01SXKtMART5f9PN4w=;
 b=T7UKvA6NrnEfTpD80q+lMe88RG7V9ottEoKz48E6ScGY/lGGe83pae5s/PdV1sSXFHOrnxHyuORTS36+PzzhZv0xwTxWBGWgnCyhZsTCFnmHsvXiJkOoH96tC8EEI0viFfEUK+8NL+lqi/zduvcDaqfs1yF40syocFBlQq4kj42P09+V5LAJC0NVE+I1QZ9fbUnUDt3L1nn8W9J4bTnDYkxlUOHis3PWQ52QbA+YtqP5zW9qXtAHvnDE0Z2IJyHtcojcQ0EyuL26xU2Y/MkItcfbN0z0VvjbOCgzMNKQY5bmeOtJRWXWZ6oM1qBaKP+3lM3Yb6v9rBsqE03sUSVu/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMmQ9V0PutOLJJd50e2ybLu0DA01SXKtMART5f9PN4w=;
 b=JL0sK10Jq2oHgGKeL27G8afBbVTFRkIvpaem2OBD1nExpRCgXJxM+7ZZvFFrWDUPFcgNnEK3UZ4ZPwE/h4qM9wb0+48e1azPLuabXMAxw5cVQVSS9t5ufIW6fS9Co3bUvlAuBbHRIn47lhwwZ7Uur1oTUihHEXQAgaFA7Cp8QoE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5162.namprd13.prod.outlook.com (2603:10b6:208:339::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 17:29:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::fde7:9821:f2d9:101d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::fde7:9821:f2d9:101d%7]) with mapi id 15.20.6609.032; Tue, 25 Jul 2023
 17:29:59 +0000
Date:   Tue, 25 Jul 2023 19:29:53 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com
Subject: Re: [PATCH v12 vfio 5/7] vfio/pds: Add support for dirty page
 tracking
Message-ID: <ZMAGkcIPnWs/+Y/B@corigine.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-6-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719223527.12795-6-brett.creeley@amd.com>
X-ClientProxiedBy: AS4P189CA0044.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5162:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd0712c-db32-4edf-bd54-08db8d34c569
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NUi556vBQZHl/Na+rms+GMK9K4m0atE2/gk+8CYE9Ph3LpGNDfMerZMk00gBbmGz62GScm9J51Qt4pz4xjZOSGhejyepmWIPCoZF8ZXCJKzazzKB7TIY/Zg1DqSiznkgslJ39oBMyD77/vvdLG8Qhm1fX1YEHRko49glHXZrw5Ts84z4bZEWt4c0Qg1nAc1FagHNJa1hCrL/jrJ+pBzi5uKbeejA2eehxypoAr/iDvVWryCLe2Q7Con3gCtr5KBQUXKfK5s1ftdetDfMTP++31rD6OFlQQKRNZyv75MnO6WCpkTuOv+LhNvuaoHfx2M+Je2rqklvE+Rek1urxe9ECV/pp9Ac0wXENbXTscTlhPb/hATKkD0Cq4aDQPUxvHfSHxMOOat4J/53hjBLnnIaxlUbFvHns1bfXRHZOzLw3nf+NH/CnK8CMY9eKXco1DNwq47oOfW/IOMDxe+SbyMnEfH2cLreI24hxKUOyj9oXgq1rwdZrsTOtLWp3WBG09mayZOGsnmVtJJYymKe/+mAzK94hh6sdx60T2xJXgBGJttwdxSiPhtmIsyKfpoIAr714nAy9bh+XTllaAAQspdYzW7cdoml6luRWZbRw3i2lrrpabDnfqqgFkGJBkFevBtCOFL9zE6uAmsirv0Ax9TS8VsNkWxGLs/S9itonVt9WLI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39840400004)(136003)(376002)(366004)(451199021)(36756003)(86362001)(2906002)(4744005)(44832011)(186003)(6506007)(6666004)(6512007)(6486002)(38100700002)(478600001)(4326008)(66476007)(66946007)(6916009)(66556008)(8676002)(2616005)(8936002)(316002)(5660300002)(41300700001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1QmC7gnA46aYrcPr8jbtjr4eZ7WVNrgr7AlDSWCRpQOq6Q1ymjuPW4WgLaCf?=
 =?us-ascii?Q?xLpgA+3CJeVkWffKDg3QBk0uY5rROaPzZTjsqvuKY6z9o1pk0yfD0tH9Lv0u?=
 =?us-ascii?Q?ytB6lEgVthrc0HWNSJ79shC/a5iot4/TglH8HWkcIFbREeAU55yqdcm4X2sf?=
 =?us-ascii?Q?Ia7Pl1lHfJnlAb9Ap5QAN9HIDiEExEG3sgYW2CrVGU+fQqNaZ1Ag6DhqnktP?=
 =?us-ascii?Q?4JDaKGtmiTAimBukJpz3u4dksnXwR1gYVWM8F2P3jQB5JUVQHcMgmhgGC2tu?=
 =?us-ascii?Q?QJvY988DEoU4es+4JVgSCt8YQX2CdcCApAYg0kTLLM3qkea/U77wgLZfYpky?=
 =?us-ascii?Q?cbdogg19njJPPlWUk6Ke6a7PVzOrFytvvjEZKXAM1VYhTEpi+bQoIJNuP6kN?=
 =?us-ascii?Q?uXE1BEMHjYtGeyHZX5g7guPoCd9OR+AioEijGiVw/zkf5xvkG1HdLxN7xSnN?=
 =?us-ascii?Q?IB01SbiiH7n7l3RhVU4OAxMSXo5e5A8aN7MbLFSXb6HKqnMI0I1oxLPf69jV?=
 =?us-ascii?Q?U5+tLcc7FTNmGLR2LvIcu0guF1lVHm76nPiO+UHJQGPNNi+cBgX9kbiX6A+E?=
 =?us-ascii?Q?X3U0tYC8qvAhpocMZTMFBcHlDaCj+SFhwu8JgTNikJun3uY7zLD0Hw37vQ01?=
 =?us-ascii?Q?QHr77EwH6ZxbP/yQrNFGcAejwYM4GuqMHsU98vleLobpsxAINB3PImUahmAs?=
 =?us-ascii?Q?NDcfFTxN2hpk+yXp2R71jOP1WQP8dC9oQ5QVgbTZo3bZq71B1i3IUBa5ZXOe?=
 =?us-ascii?Q?X5dZ9OGL87Kqsv+ld4bgiYn/kSKw3+1qL2KXgQsvQ757+EOjQj+ExBW4zJkQ?=
 =?us-ascii?Q?xF/uCZXWwP8Vcapk3KZgzKWPf8PQ5j5M27Ve7MHCdVdoD+TcJ22YFhV5XpE3?=
 =?us-ascii?Q?WnWsLH397fw/63abfD7YY0lpGHuL9wPBm9VqENdrjCvdhL0QQZvMOW9QvK9d?=
 =?us-ascii?Q?XUvQAQP5WfjsbskAn4ez3yS5O4oQCfkEAxcrgFXk0wBXTI5pOQKRTVsxhlm3?=
 =?us-ascii?Q?Gd6CgQ0h3KSko70h2YuOtvBsiZaqeiKbUyX/UlsUdlSDidRkUsZ6EJBKQnf3?=
 =?us-ascii?Q?CV3GPbhqgzB+29eDEfAYGfF2TeoMdxTenFIUtxMIc5ltS5BquT+WLYRxvYR5?=
 =?us-ascii?Q?G2k9Mr8lozyisYlb6SxB97xbA7kXPFGjCW6ytt3vWTRYsuNm3v2z2HxAhlDi?=
 =?us-ascii?Q?AUtmWO7MVM3VXXhI3AwHoGnWqGa/8isjlMDyUD7QfNgv0GfI7aKAh7TAqo2i?=
 =?us-ascii?Q?OzE4kDlJEwH6BgNbRaDo1XqkLSO69dXow2W1/6dy41GjlnBsC1BfoJLZIBiS?=
 =?us-ascii?Q?0v7XfzU8WyNpF/RooopM6zHIPpf58aRygltxuIFAncj36HFOtXpfQcNh3PlC?=
 =?us-ascii?Q?jWzg87tWgGc9AhDOLLs/sTr36kcnM1tlncy5qwUbqcV74t8Y15H8olyP9YzT?=
 =?us-ascii?Q?jWpSYR4cRY/ujhmQdIA2ESDB1l8siQuRXEsK4IbLz1nY7dAEdHd5Lk2s+mQT?=
 =?us-ascii?Q?lvbysvf5Ejg9fjto3xmU5vh3uH4XQUKQ9wMwet8/IeAyCf7mBOwFG9dE3FMw?=
 =?us-ascii?Q?pxywusfooPPCqR+7rTCQkol7Ke+Vjw8SXmcHQ/GP5atFs/BlTNTfHbF5Qf2L?=
 =?us-ascii?Q?jf6iobpXXhcGWt4VDVDZ4oXaoKTJZBg2nw9vjnAKlRi2I7C/WH71+WeEtkoY?=
 =?us-ascii?Q?DTpJ8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd0712c-db32-4edf-bd54-08db8d34c569
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 17:29:59.4402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpwWssfCf7Qx3ghR5AGMQUGm+fDsPj1AScG6z26wZ8yATu4a6b6gui/3PbCfPpgIhaDr3UeTN9R8wgsSJYRXXuDplSgRiLvF84XmLZmQPyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5162
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 03:35:25PM -0700, Brett Creeley wrote:

...

> +static void pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
> +{
> +	if (dirty->host_seq.bmp)
> +		vfree(dirty->host_seq.bmp);
> +	if (dirty->host_ack.bmp)
> +		vfree(dirty->host_ack.bmp);

Hi Brett,

I don't think there is a need to guard these vfree calls,
as I think they will be no-ops with NULL arguments.

> +
> +	dirty->host_seq.bmp = NULL;
> +	dirty->host_ack.bmp = NULL;
> +}

...

