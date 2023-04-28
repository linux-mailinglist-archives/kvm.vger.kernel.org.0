Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8483B6F1938
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 15:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346159AbjD1NUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 09:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjD1NU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 09:20:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F191BE7;
        Fri, 28 Apr 2023 06:20:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBEt4UpXL+qaBw785wcRTbz8Q36SYFpAa6w+yHQchSanMLTkojp7FXy32i4W/G5cnOdTKBAeSjy/IjCsQBhDmzbWhvazeFWlZfRqM8354ne9kxC+zumfMoovg52nR75iydzW+MArrFNrGUpifQ2PP3FkN47drI0jUuVAAWjtI7ndmkVtQcFI3wtT9fFlyuVUkWdiZd6pGScwv3nCJV6GPodSgnfp5+2WHKtVZoHc15dp2rS09RglG0qjcTnSb0GAXZ5vorTdOGaiJ8+FVI4k9UuW5ahcNELIql6qDRSPFzDF1LRPBJgRrnIarpAGJRsdhlcRDy7VUzahAXgGxGlF+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXYjzdeCg2oN9+H98o454ytFgA7kLTpg8GptV7P9aw0=;
 b=PsmfK9JUZvwJ1Ob1sBos5E5rvx3bWfB1BLX+N5K0h7NbO4h8RZq39CwyiHHpKkyXP7+6ZAtE+Gnja/hMcp4Vj6B3JAWtVjHAzMrFGPwfCdzzgBPCh7wokjUEI2FOGCupAUkg5FpZjApVCNfbXIjKgKqxHREYgsCsgYfEkFItXGoUSoVxIm8JER19y//wAEmEVvlqABuO18UR9wBtmw+fZzgIs0F7RIcYSEKqyR3LE103UBpfC4RCjEAg8apMXpCUR1Ht2bHioxXdjbNspf1nZGqn1jt2NwAIOwTHMJOxDwdRXwTGRx39ffT4YCdm3oTAOUBWK4OW0KSyr+yVsr5QJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXYjzdeCg2oN9+H98o454ytFgA7kLTpg8GptV7P9aw0=;
 b=UlE06VqNdJnyoP/PvuuN/cYDg7KK3ygq0XiKZ7SpUPTbu7+6OZNvyqUfuTwhJu/I+/bIsgmMTLuNQU4NOoyiWopPXczdTodCgU0Zpd4aBPUBAFYyFwBPznaVpILwbDzhMieyFHWaYDVpI+RHMoXxduqeYSqK3y4cGiHdhpftwIXQTj8Avb98e7XU5tJECvtOP8kBc+etN4VEVdXIa5gVcPQGh0k0ylTGjgSUXPsgqz2SeKTBvkyS+POl6NSj6WDGvyD9/22SAjDmQ60rOfEzEE873PPS2zL//XCsTV02uTtVtMa+VSj68aeFBlInL0Me7Bjwv5q1bKyrW0XSyEDmnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5962.namprd12.prod.outlook.com (2603:10b6:8:69::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.20; Fri, 28 Apr 2023 13:20:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 13:20:21 +0000
Date:   Fri, 28 Apr 2023 10:20:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, hca@linux.ibm.com
Subject: Re: [PATCH v3 1/1] KVM: s390: fix race in gmap_make_secure()
Message-ID: <ZEvIE9eqfRKrpZyt@nvidia.com>
References: <20230428092753.27913-1-imbrenda@linux.ibm.com>
 <20230428092753.27913-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428092753.27913-2-imbrenda@linux.ibm.com>
X-ClientProxiedBy: MN2PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:208:236::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: 0608923a-0e36-493b-1b8f-08db47eb5158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBR23rPli36O0oK8asEIXf1TidRNORIc9ow+tDQb8rAhF7PPJplbNiTfRTv+bGyHmNnby43T6Mk3CKq45hGCeQ8cz/oMxgXV1aTiTK4Ui80o6AKK6H/ZmHTAm0y+wc5cISVQdQUKS+mRMREvspe/xhgXEhFkcFi+wjHr7bF798ttGpATm7AOc55GApYSEQK1Iky21lZ9Ub8GtUEQCm/i8Wq3EqWogYijW3OifuKVOl8ka5Cr4UF7g5X8PlpXgS9VCrxCSXGzUry5XW40DbYLgjPMChkom0O5SYdtEI+eb0aYGmruwxEoCRzQ0AywJw498P0PdbRWsG42572TVB5VxZet5jmmwX6lY2W8d9BPLFjmI9RB6XXzDkSvVmikhx5hohZacwRd3GCaCmUakId74uT0k4vQuPsZ7yLrqjlCpoyl15tYRuUscadpxpaGkyf2RuGej1eLGfNizjXn9/agsT3FFcRtpYvv+9mMvjZwv/7FfX7M5kel5fVMwLbuOznes66t2MT4qUvyCOvnqCHVaEE5rBzB0CTt6age2HFJKf/4L3zQ535eAbChWYaVq5ZIVz4n1BEl27669q4fE3tTUtnm1/npndhxNjUGXFT5rfw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199021)(86362001)(186003)(66476007)(6916009)(66946007)(4326008)(41300700001)(6512007)(6506007)(66556008)(26005)(316002)(966005)(83380400001)(6486002)(2616005)(478600001)(36756003)(38100700002)(5660300002)(2906002)(8676002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O/V6xhXEkBne2uFqdJZBxs68be+ppx8AqOW7E82XwxyUErptvR77Kl35vFJq?=
 =?us-ascii?Q?uV8lfDIbYr6gKgNk3beRXijc6qYUdGVbFA3YZpIcJB2QH+QP/pfN/phEYpeU?=
 =?us-ascii?Q?D02P7ykq9QXnlaUdwqPqhNGrMXaUpcXOS7qGmtfXC8Vzn4DTkUVL5agMb0ya?=
 =?us-ascii?Q?LdZDMKkaWlmznbqGz0l0TvUYiKZ7GxW+6PjWrCRS3QBTrYo0h9Gj040BIO5f?=
 =?us-ascii?Q?XjKQytjYnvjof42NqfNRgzL/W9A6uxP4nTNC7oxUEOYSR2UPsShkJ3Nx5odV?=
 =?us-ascii?Q?0ZUkDgtR8aKXCRNG5TfKNP9RgIhlazVNPBFQcNTwyxBaPJ5XXciU7Im4yZ80?=
 =?us-ascii?Q?x8Hxb91Ely9s2JeiASSe+eXQb832dRYgXXtzO1rtF9KfLtBf1AHcWOMVnIQw?=
 =?us-ascii?Q?hycWobqDl7danRa+3nnRy4Ez8gcaGTkA6h7P7XVI+Rq0R5O8YuqlPdiaGl6Z?=
 =?us-ascii?Q?0WyI/fvnUO8h28Rz57qCE1K4ncS1eLgA0MolnCBDPc41ebiZ5pJnwBKqiYMw?=
 =?us-ascii?Q?fHN6opgb2+JUy+Erb/Elbhyc9xaVK7Zw+0SBrx7Y8IMKICVLNHrFi02oAiH6?=
 =?us-ascii?Q?duuAWJvShI4YUJsm0Mx5++kudPBAxtvzPc3Zc36ZwKoS02CFsPg6J19PcUEp?=
 =?us-ascii?Q?EItDs0XNZ9Ny0v7HCqdb4OzeYiRCmGQP/knWhurACNIlt4nMvGtGPd60J7vr?=
 =?us-ascii?Q?NhJ64X3ZKa8r7G8DmokrWDpCt5h9uZk6LKPdhmqC1ktYKb37mbEkkQHY2/uJ?=
 =?us-ascii?Q?/G86tiPguVXo/D7/jD4xvc+HXAf2J11/L+KqDfE9Wk7LR7x1IT/APXrWaJn+?=
 =?us-ascii?Q?XpZcEJua8BgQqjP0V4E5IdkB/tr+L5vTpLl2THzMrOk8RZaTM/6MYH1FVpSA?=
 =?us-ascii?Q?4Q9PUd7zDKpzsxPnRZp8g+TdpYAjZXTFEgETQOS39ArsMOLEAs5n9xbiSdnz?=
 =?us-ascii?Q?6cM3iiL5pvB6mzgrVz19HRPVdZdP5xkRnmMeQgsrPHeUQuTWq/HU7FC30yKy?=
 =?us-ascii?Q?qMXRpxXEnEtDEbcXHR9e3WGEj71Ag57AdvR1l2ARkK4pteCy/SlegsFPL2xV?=
 =?us-ascii?Q?jkNSMK3+gnFDmoVsceRBSqlOcPzaKj1wqQqQuNBbWldr2Q9fzp/sOoOB44W+?=
 =?us-ascii?Q?AonA0NKQETkYPDXXMdCDIgkzDVkNko/mHzJEhooWTKRVF+pjYdI1gUwWewzv?=
 =?us-ascii?Q?2SOcLPr5qYWZfgwmj3vO09L7k7BHl/nELbvWCyetQ4KUnSFjalnWqPmNHRIC?=
 =?us-ascii?Q?aTFLp+WeCXfF27XXftlsPt1UY3akHjFjD8I88VvTwyvsJG7D2T8mD8cuWurr?=
 =?us-ascii?Q?QWjio18lILx9h6vYlwa0IqHTx0sBR12cjoI6tAcGKcQqxTH3JCEi10054sKm?=
 =?us-ascii?Q?P2CjQh6p4K/bE8zS+VTTJZzeYc/RpsZFXF9sxN1XXtsXiFjesmmsJhsPsrJa?=
 =?us-ascii?Q?c/PbzBUVO7ch2nE7rUTb7p7HQWbH7J3R4PKa3LI95JZDWtBVlSvsipiXFjip?=
 =?us-ascii?Q?JjEsuyZmy6YXmjABA6OyJP83NS06trQz0cSkboG71l2h/Wmhy46bKb2HaStK?=
 =?us-ascii?Q?y5MkjTXjmFiYE1stP9X0qP2LUzwie83WLRooicMG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0608923a-0e36-493b-1b8f-08db47eb5158
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 13:20:21.2194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rO+UtAzkJWXQvBe8tpTCCjLuG8qC535HM4tfSIg6dXAMyUQw3teq8W0GzkMddkC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5962
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 28, 2023 at 11:27:53AM +0200, Claudio Imbrenda wrote:
> Fix a potential race in gmap_make_secure() and remove the last user of
> follow_page() without FOLL_GET.
> 
> The old code is locking something it doesn't have a reference to, and
> as explained by Jason and David in this discussion:
> https://lore.kernel.org/linux-mm/Y9J4P%2FRNvY1Ztn0Q@nvidia.com/
> it can lead to all kind of bad things, including the page getting
> unmapped (MADV_DONTNEED), freed, reallocated as a larger folio and the
> unlock_page() would target the wrong bit.
> There is also another race with the FOLL_WRITE, which could race
> between the follow_page() and the get_locked_pte().
> 
> The main point is to remove the last use of follow_page() without
> FOLL_GET or FOLL_PIN, removing the races can be considered a nice
> bonus.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Link: https://lore.kernel.org/linux-mm/Y9J4P%2FRNvY1Ztn0Q@nvidia.com/
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
> ---
>  arch/s390/kernel/uv.c | 32 +++++++++++---------------------
>  1 file changed, 11 insertions(+), 21 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
