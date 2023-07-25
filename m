Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3AD762038
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 19:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjGYRcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 13:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbjGYRcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 13:32:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9152D5A;
        Tue, 25 Jul 2023 10:31:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oh00xdFi//MxWl0T3x+tm4BUmlB9qG8v55NzQOJ8b6H7yNHRysKyTRJALsYQELWL6tFmIe5HUeU5M0Ka180BjfYNXm8lwwlXZ7naFbm0fSRm1zQOsHfLYBnOK1uetlv8Aq0B0YOvLpfjaAGv1O9XUH/UP0b1AKRdy3LrjUODAAb23auKmUFBA1upM2Zke+jX+uGjrN+yQm3OPIRO85NCUnA/9rft6Szq6B0QC5zU8MF6GicNqzEaxBtg1tdZIcniZWb7suguPX+717IJu5BuQYrjGHibP6h9xuTpPQGWUdQnDzaZdEYkbRbnKzkuRYYX1rom3cKjA5Ko2sVq71n1Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFZgQWzpl2v/bYIcbeiIX7kRN7VPtxQ1O/09FnQXwo0=;
 b=J04rT2C282ijtrVNzjqTchScDejQhDxenq7Zfx9ruAONm3u0KWEdhhluhm47aTsyGHWTlqMS6WPZZAHF7y0T82VkaneyPJ5D8p43x492XS8pvzOLjNIoldMBj//pA3oY95bndRM8ShpgVNAgmMUnJ/nAmJCpJx+Jx3hZRTU6fwCWuL+Kjl2oivH7ZSYjc40YNtQa5ULcd1xXmZnnqImwr1YM1Rq74nXgFbLeT03Vk+tbab2BvBpxqv5iCUhE5Au+DbrQXAuoGeFrI3PHYX0JSbU/IfokSrsL9FszWD4ENAv7J6ZE0ByqtMX258Ro581Wt4OkZai+yCsA2oQj9ljgGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFZgQWzpl2v/bYIcbeiIX7kRN7VPtxQ1O/09FnQXwo0=;
 b=F/HLKAl67GqOxlZ+sHP1NmIzDW3vZ7D9ohjyxSEAUsy3JWITml1Dkex2RwNKLUBej26nRvvfIqAKQa22oxP8HIP3GMsA5kDOr+7gsOxG7NV6cWVTJkkgHUpuHzbHNe4TO8IlgJerzcL8JnpLa8cWrUKvN+Tz9myLHZSBmzBSO2I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5104.namprd13.prod.outlook.com (2603:10b6:408:160::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 17:31:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::fde7:9821:f2d9:101d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::fde7:9821:f2d9:101d%7]) with mapi id 15.20.6609.032; Tue, 25 Jul 2023
 17:31:50 +0000
Date:   Tue, 25 Jul 2023 19:31:44 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com
Subject: Re: [PATCH v12 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZMAHAE9dnMzKzFgW@corigine.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-5-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719223527.12795-5-brett.creeley@amd.com>
X-ClientProxiedBy: AM0PR01CA0145.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5104:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ea3f882-1b70-4daf-49dc-08db8d35079e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: coU6uoDD2iVyi5a/XnRU9cwWf0WTVHPwVvHhudYGuo+fMycWbP2Mwfu7M9TN5Fx72I9HD5VgjDtLb7btR2DkZXlpt9+5gaVyTFyNEEFfxHtw027t+6n9pQCzQLCrwjZZA8F1DERNpZOX3xzj+WI+7qiVI8RWdywyLka74xJJAt0vcJ3ykW0UGLtdPxYfXjsQUuJLxxKklf0LEh1IzqEAZbhkP3FL6f5+viJujRVWBMqjKREsQc9jK3gxlDR5uaumYc4Khwzj3yi0U3UQu/9iogbv9wen7aDDyAibt49q+dgsdVHlGKPTvZUQ1zVOcn0G2ptMO9rha3RPSXHXgQmqelR1MS7zQdRVGiTiBPleMgoA4ssrW4lCKX694/auW2LIK1ZmWgpjcni80IMvlq2ryIh02GBSiQMryIBeJd+NiSJLKKTmOwWF5acQWLROe/pWJRc/Nw6R2APyQ+gUplBpdrJPx2rv9omSd7wgjQ6KLMPvrTBof1WdaJ+7MIoMBCi9KSsSqKg+z3N1ihI4ETRDOXknf4HxO/ZtWH61l1iRLWMjYzXZ0dpnPrwWCzICGDgyIKdGQDO3+jUqQAw0FhfDAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199021)(36756003)(86362001)(4744005)(2906002)(44832011)(186003)(6506007)(6666004)(38100700002)(6486002)(966005)(6512007)(478600001)(4326008)(66476007)(316002)(66946007)(6916009)(8936002)(66556008)(2616005)(8676002)(41300700001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w+sjjZkwrM/c8LkUN9xkenaCy3fn5GvA/d7ANMrn0oVsD7RDOv7O/AGp6w9C?=
 =?us-ascii?Q?xCMWpGAnaelSmuKuYJ62ZF8MWBXFq8ELVU0GEImnEloWegqkSWA7NKT3b+0Q?=
 =?us-ascii?Q?zTndM+rf/WUH5SAdt7uPYQ47uyPnmk+GYeLYeCQYv8+/qEPA5+9ZL73xVWJk?=
 =?us-ascii?Q?VKbLFo7xIQ7yFA3JARyb8qA28Myto7T+gy8Uag+IhlEwPDqNhKwjoRlaN7pr?=
 =?us-ascii?Q?taCacpQChGkyGsPxR6l6+83lWOOF3n6Gz2Wk1MnTf/fStN2/TxAUZb5n+mjK?=
 =?us-ascii?Q?vYsdnAd1ltLf3LaLEI8D4mH2RyMuJNX4CX/qs68tZyXoWfriv4CijMRXnSsd?=
 =?us-ascii?Q?k7aaIwoNYnY5zexOLjaHyyhHd1pX68QqoFHwrN5uumkwxZq1JIr0xxNY7eSM?=
 =?us-ascii?Q?6rzW5O9sPQSGBnZETbpYVpLwolD3tX4VjypmKKN4Sr0y3WzXCE8VQlFvlK3a?=
 =?us-ascii?Q?/UmAQuGDWOWbkEhaEucO8S5GFzGelfT/YdR5TinsRFfXGo6NPY2DujI30JoK?=
 =?us-ascii?Q?hSJPhnt4+zOvZFMK+rtdNpua8spP8p/fRHnw9uuH+VBjc6KfhVvhIdS/GbQS?=
 =?us-ascii?Q?ZawiJqKzRISbzWept67LEHBsYzoI+sW4UQHBVVUATDqQyfmn0j1twv/H0Dzh?=
 =?us-ascii?Q?o0esPO4Oh5xJHDg6DfhEX6kButZpOawcI64QkvH3gQzi21p7rzzDRFzRLEgX?=
 =?us-ascii?Q?CNkAPu59DusBV3IKAwxNO53jslt16n2A1rKnxg+qzKTEqfwA1uR5+IqfUb3j?=
 =?us-ascii?Q?tHhhg1ld7kN07Qh2Q552MJg3DHeYYiMEPmdq10uWNSOand8aOo6B634un9x2?=
 =?us-ascii?Q?QMh9immdV+3Z/OgQ2+gHB8mPrTZRVWVO2PBhDcH53NvrCgtYHNs5sU4C+8Ig?=
 =?us-ascii?Q?0x90yUeNuaCkiGS/BwT8DvmY/c0lrzR0LwNa3KEuNHeXN0UIBkMmB99CMI1K?=
 =?us-ascii?Q?N6fbxagWFStaOcjA9zLjk3GXSyTSW/CNPhdoVHHpRbZcn8HeGOJmNLJFlALs?=
 =?us-ascii?Q?hJLQIQwBZtNarzM+qk0xPXAM+mnteFMcDPze+iFQdQCcPq30nJPRyv6DOUTS?=
 =?us-ascii?Q?B6NIkYBSCXMAs37RXGa+OOVyYClEg8OjbrqbMzXiPgbQEKt5s8n/IXh2noEx?=
 =?us-ascii?Q?cy0/7O+Bwq3B+mxkc9QPERJjSUzNaBq38rk0J/bXtPOIDew9pW2rrlUVjoZx?=
 =?us-ascii?Q?cshck+1bpOaF2eU5aZ2m6JmOQZkXnqnDO6JimnGicPxPCULQ46ZjFDX5ib4M?=
 =?us-ascii?Q?iMHhr4eYy4L90WtPYuSaLrt2IriLLYJ8NRUqjSPQTaQJSolvYapTkiPpxdo1?=
 =?us-ascii?Q?T8tF93JkDHJaua97CS1OFTfkK6ft8ruSUNe6aLBdgznNS4ycMaPlsX1puGf8?=
 =?us-ascii?Q?Qnm3t7OifRqwgo+36TJULIYJ24MGKvJ5tNJmvBvL5uAmfWCMKyncqhDSesM0?=
 =?us-ascii?Q?dULC0Pf/XClC3ym+y5XxYddMJs8ovNbYwcN7aWIA9HDLTEJLe9WP0G1teEe/?=
 =?us-ascii?Q?DgOHF6ZNmkWnY2iw16NNAns91z9HouDHYOYNBS9E9qIIBAhjRXjccCXWZF3a?=
 =?us-ascii?Q?i/9hhajx5tfI7aUUvhHmk3j1tROeOsPlh/7tRQpI2a7yxiHxOCFxOhHpuqQu?=
 =?us-ascii?Q?RVXoFL70nlULj9wR5K6VfOBhFU86jft/YeMWmtHeQs8GcH+04ehnH1d0cRLF?=
 =?us-ascii?Q?Z894VQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea3f882-1b70-4daf-49dc-08db8d35079e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 17:31:50.5080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ru2pQGNdXF5kOmoRmiBHmJMSFAwcQjxX5iyMqiM8hmHuFwTvqBE59l3pSlx0iDGD8SDzbtZoTkUBScyamHImODmvTIz2teVYcSzZws1jY5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5104
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 03:35:24PM -0700, Brett Creeley wrote:

...

> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c

...

> +static int pds_vfio_get_save_file(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
> +	struct pds_vfio_lm_file *lm_file;
> +	int err;
> +	u64 size;

Hi Brett,

please use reverse xmas tree - longest line to shortest -
for these local variable declarations.

https://github.com/ecree-solarflare/xmastree is your friend here.
