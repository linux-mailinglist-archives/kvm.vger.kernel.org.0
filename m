Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1DF7BBFB3
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 21:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjJFTYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 15:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjJFTYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 15:24:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3533DAB;
        Fri,  6 Oct 2023 12:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696620282; x=1728156282;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=y5iYThSsfHTnZ0l3Het05QHWe8wmzo5zfTRMZg28R1s=;
  b=bNNgtvLfz6SiSfDdGjp2LNjP2k+XpCvoDJmpcwhH8gh/SVn/KYrZb8T8
   zZT9TMkqPm3ncemBgdIFl2XO78dNxa6AMg4+Qn24d6x/4vgmFcbxmP4c0
   wsB6KuSRG3Rqs94jejNQFqXI4rMnXSdHLFllue43Ks/Rm1HYkqWwPGFKe
   2SGAq/1UOibIS5Jo9updv54CN2eWBvZP++YkCu7VuY++Tti0DlNXM55g3
   Wh5gpr1Bnp5aW7FaWbl158WPllEJ2RJtYQ/OPZKEpNqpoZ8N9Hgkuy5aA
   ERpZW9NxqeG0IYTk9zThCKo3BAxU1LQCLQImcg5JyJVZskTPU2CWw4DrH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="382683218"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="382683218"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 12:24:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="752284926"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="752284926"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2023 12:24:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 12:24:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 12:24:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 6 Oct 2023 12:24:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 6 Oct 2023 12:24:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lO1Y5lSU+AVyypXdbZ0M3+rmR+6HqhhrNTsKv9DbrFNV5PwTpl4ewrzBkdWvJyvw5oCuhbViKDpmTYo+W3R96ApeLFireGtIfu9vcK1RGkHScX8r3HNJNQkpYORffZYB24sKmncBzPc70zmpE8CT9QjgA9jLqxsLo6/hKGAvMBeW4q3+sM8A7IyJWu0HcTQSTyaPnCYM5jNx27mE9U789UzTWHLpjO2wfrlZVKDNm2ic00FBAlPErutr4nrDELsGDNticL3HYsPOKJyNmxCNRV00DYRqBXKf5TNMtBvPDJysR7+GkJ3e41Jes+C1OPAIw+/iw8o9pXPCCeGIg9oTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5Jo4Ke9PFbxBtpxoKnSvNfcCdlhc81XSrXfbtZAFDQ=;
 b=ipBxp+i8GZQTBBwH0iKEGCUGCRDNgnF1vZpOsYT65HfMhj+gnbDUB+6HYoLZv1o5VXXOop394foCFGVHUx+k+AiO5T6B1YXWgtLQKmluMKXCWffT87y6H3yBvGQQsNqvqCiE5znhQmo1VGrd+e5yRfNPU51/DI7FWjFCmkXdTkhAdycRpXp54uWiI4jgJGSVXfrgUFIAP9rLkp+G0FteIv/l1HxmUUfsjXPSszfPKoq+zGjcJrnPoaF+wt1kfjsGxT0TFUUKpV0acJpx8gAvCvO4vOl96KWGVikz7wfPEr+LIntAUX8yom5TisT32oT+9dSeVU6yXuppye4nuXoESQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA0PR11MB8335.namprd11.prod.outlook.com (2603:10b6:208:493::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 6 Oct
 2023 19:24:04 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992%5]) with mapi id 15.20.6838.033; Fri, 6 Oct 2023
 19:24:04 +0000
Date:   Fri, 6 Oct 2023 12:23:59 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Lukas Wunner <lukas@wunner.de>, Bjorn Helgaas <helgaas@kernel.org>,
        "David Howells" <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Wilfred Mallawa" <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: RE: [PATCH 05/12] crypto: akcipher - Support more than one signature
 encoding
Message-ID: <65205ecfaf11a_ae7e729414@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
 <f4a63091203d09e275c3df983692b630ffca4bca.1695921657.git.lukas@wunner.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f4a63091203d09e275c3df983692b630ffca4bca.1695921657.git.lukas@wunner.de>
X-ClientProxiedBy: MW4PR03CA0213.namprd03.prod.outlook.com
 (2603:10b6:303:b9::8) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA0PR11MB8335:EE_
X-MS-Office365-Filtering-Correlation-Id: f0317825-7844-41d2-2da6-08dbc6a1cd6e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y0SI78m+kzAonoRTNkySGbC/Rf7urfWNMh+t/3C5rLtMHqOgUf/nJakhGCQJbXoP3e/o0L/c5tg/1CBZnDZQPm1MCUWZ98wU5NbEQlTauvXPG9WejZP3KrUcYu3CNuVHCmmixHr2wGONkFKk4DgoMtpeT/+75OvJyNGhyZnA2KAVMUVLifX7hxovGOnVXoxLUmaYj7/N59r4HMdzLKJlvuVwtkLXraLa2FWnjNHrzdP0jOhJITCU8iV7Oij9ThEyypxg/4cl2cPYOJ2mUfk3mrjScbzslhmpS28PsVHEU1IaG74ufmR4+n2vuYfh9veTOCt/fgROkkZYqT2U7IJoCVNxrOImfaftTaX+mP4FcaEGYkfdCiLZjsoUEeqJyEeTkXMjcC/i8N0A/ivQZfQX9sNugl0LQyp/piUnw85JrbZjbywAc1zDHEcL7roKiYJX5weKlEbqxof2yK7U5cCSS+k//N8s4SPbPm64vxNbPbVZ6ZGRULJR7ha+F2HAoLxG+I+bJsjUXVv0UwsQKHHGZ6NlUm93FhuD1HqCgQMBpHoP9pk8EjXOHWj3RoR4Dklr+f94x1bP4OrRvgYwq8JOivjv7T7sc7swDPa5t8s+1/c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(376002)(39860400002)(396003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6486002)(82960400001)(41300700001)(83380400001)(7416002)(2906002)(86362001)(6512007)(26005)(921005)(6506007)(9686003)(8936002)(4326008)(8676002)(316002)(54906003)(110136005)(38100700002)(6666004)(66556008)(66476007)(66946007)(5660300002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pIthdSrxpqJ3TOMjcNo8m+iohFLL9kwnrH2DME9/Wd9hKhzgW9BLeSRobH/m?=
 =?us-ascii?Q?NuSV/pxyDF9oiszjjNq2ymryDtUPxgbOdXJKbqBuC/YjsPbtYhHINBw18EnQ?=
 =?us-ascii?Q?VWUwdwUc3rTnKFKUJDBBdLSge7HfKw+n4OlEh39jNTJKxT407+318o2LV2Jr?=
 =?us-ascii?Q?ruRpbtptsIH/9RAZP+Pwmr9YB4zsvtnK8ezVARMRs41l6TKRbgg0Ce1z8kFd?=
 =?us-ascii?Q?c+8f/s3E5u9KgDEoroUJImIP1Kxl0zMaBeMWM733pqHo2bedZ9XuLtOwFpbK?=
 =?us-ascii?Q?vJcadFEYC3X/Nfv7hP5AZCDrEMh4f6xmz1Oz0UMzOyXQRVf32DiMAnQDPzZn?=
 =?us-ascii?Q?bgCgTwPYWBmaS2zJGA2ASaF1mGKBriabHQxVq25m7/ENVOj42ecRvt6bSaTZ?=
 =?us-ascii?Q?WJoZWN1I4suBmnMNVlueLEYM1zdBEEXjhw3inVq0fFzCf/41FLUQhEDqFuba?=
 =?us-ascii?Q?ArZT6vPY3I6zJqxOfAHAxqd/9FUeqO0ADzCkS58+cOkwdgWcpcLRemglPCgL?=
 =?us-ascii?Q?XbfKW3kIEODmvXfbmhiqIV1yVdOGjjKeWTYcCbj6bZruAy11bvK1ppG+ZW2c?=
 =?us-ascii?Q?svi2sziuvV5igNAegE/kTueR0ZslKbOo0jxP9xm/TBljJ2AgoN8hJLRNmro6?=
 =?us-ascii?Q?k+oZnMqGJ8NWEd8N1DUkQLmqNRepUE0Y2Wn3pZrZ2zYlJVyIOhtASnAN80PO?=
 =?us-ascii?Q?Cbn0xgd4niHddialYbQTRi+7+iY8RRGciC4gZ7WyOZA7oms0AZ7qxy6/XOBV?=
 =?us-ascii?Q?jFXknlW5CaY37SPxRUN3kTNMXZ7xDVP/KOad0TYDCZHRV4LZUfiKuh5JDq3K?=
 =?us-ascii?Q?7anUnphYqPHjTeOZ3pypD9QwG4jM4sSztus+Cy9c+dDkiiPphTmDLIzTr2uM?=
 =?us-ascii?Q?B1hPd5bgnoYg6ESQshYZ+Bk2li4PKtAfIHpBzXnEAiMCjZtH4ooS9pngZPQT?=
 =?us-ascii?Q?UrGNOYtg63DTGVVUsU4RIpLTYLl1qhTp/lGZkYpj34z1sorHpuYkvjAr3RnA?=
 =?us-ascii?Q?DJHEeSdWx6x4vSnCAYSWgKK3eV0NmPbHNpdX9ok26/0YgtQepwCBJ6VV0chL?=
 =?us-ascii?Q?7qD543rszTbYY1553B5i0zWeG++qntu3KwAZRClSa/w6VOVP0CRD4/m3jdZ6?=
 =?us-ascii?Q?+AQl5oe64IRBcGzDe5KnSfYzdW3xy8egZBfjh3pCm2ZrESR3mP8OoqFiLlO1?=
 =?us-ascii?Q?nrDMYTk61RvG8jqSoe2byNOkUQQDD0T9YtzTvWpykMrGOMhw8galxx7d+E5d?=
 =?us-ascii?Q?zuATKn99m1vgwZFpkFYLsfP0BFFJifgu4X2AP3nKWTCrU4gVmo0W1qFRtvFn?=
 =?us-ascii?Q?fwvaS2FC7f8RHmkbgrTw935/QCHGoZeSxJtqZ28khBos6HC43pyVx/hx/64K?=
 =?us-ascii?Q?WFHqsCA1GmDn9qW740qIqXFUr1wXP1DeGdO3Za7RAeDTeS2EQGy4vA2/v31x?=
 =?us-ascii?Q?CrHAlQ+Y/7mS9yUDvghgFWkZcKzSIwilq9Ojje1iqA/YOm5SE7GJCPuK+X1k?=
 =?us-ascii?Q?FKiiCL57qjn3rZHV0RT8XNGG2P0Fbf/bzHEGDopjsNV5Ohn/YgWoMQcs2529?=
 =?us-ascii?Q?/8p+akv8Df0P2jePQW3J8k5+0sycn4Ruwss87h9nHtZERujk9FjISnNfgioc?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0317825-7844-41d2-2da6-08dbc6a1cd6e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 19:24:04.3019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2CacS3d2kaBvAq43u3biEhR9qsL40FpMgE8F1gZcKnnikdzBsA5J8jaDa61cWUc78yi1B1/L2zqZC1UIUzo3X2+dy2IDbPHRiEzeBFvTmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8335
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lukas Wunner wrote:
> Currently only a single default signature encoding is supported per
> akcipher.
> 
> A subsequent commit will allow a second encoding for ecdsa, namely P1363
> alternatively to X9.62.
> 
> To accommodate for that, amend struct akcipher_request and struct
> crypto_akcipher_sync_data to store the desired signature encoding for
> verify and sign ops.
> 
> Amend akcipher_request_set_crypt(), crypto_sig_verify() and
> crypto_sig_sign() with an additional parameter which specifies the
> desired signature encoding.  Adjust all callers.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  crypto/akcipher.c                   |  2 +-
>  crypto/asymmetric_keys/public_key.c |  4 ++--
>  crypto/internal.h                   |  1 +
>  crypto/rsa-pkcs1pad.c               | 11 +++++++----
>  crypto/sig.c                        |  6 ++++--
>  crypto/testmgr.c                    |  8 +++++---
>  crypto/testmgr.h                    |  1 +
>  include/crypto/akcipher.h           | 10 +++++++++-
>  include/crypto/sig.h                |  6 ++++--
>  9 files changed, 34 insertions(+), 15 deletions(-)

I can only review this in generic terms, I just wonder why this decided to
pass a string rather than an enum?
