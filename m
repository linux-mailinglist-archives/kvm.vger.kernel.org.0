Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170B26A56FE
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 11:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjB1Kqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 05:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjB1Kqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 05:46:31 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D70B27486;
        Tue, 28 Feb 2023 02:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677581190; x=1709117190;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jocKCLAunfcUAsuHrxAEBOf49ZALiTqn3odtAW60lG4=;
  b=aYb3Dy/uoamETcBl6ILSikPVJW8lv2g2WepurQg+Y5xCjoyWEvi/tU+Y
   7q8wWmQLyubwC4zQ5hb+1asU5mX3wVZHE91VUBx3DZQEgd3cMHj3l6DFQ
   +TKJ6zrZZL9fR6UhndIumWmkePCUN6STopWvKukNS1jSOf9ruJOma33M1
   VgbHlOHakyLn2f80aOoDKz9Lg/X6DFM1Oz4HY4TOhOsg5PflzXY9RaM4n
   MiN7yFHPx19cvtMYbcrfD3jbbmsCiY+38XB6BRJ54RjdFkIkeRJIHSV/R
   SpQS8jWoxtLnOCvtF4nfuTWrqL87aXtz8kxopi1C5wqGqwqC9CaXT/4WE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="396671894"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="396671894"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 02:46:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="651579721"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="651579721"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 28 Feb 2023 02:46:28 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 02:46:28 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 02:46:27 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 02:46:27 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 02:46:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsySj3YgoMdE+7NcAHUcoooIg83ZvBM+Tii7vhvou0JTJPhRUOHoVktgoZXN3fPFR4KhoWDTy/f21Ck01KS/8JSCSqxJ7gYdfb3s68Pt1u7YufyYPwoCxg67bGn2cvmQOGgnsXsvQAMwHoquGeaYnC3V6VfwYBk8JvtkMbLmVytRDo4MjNTW+QpjpFqGVUJIu/EnY851+kuUHHanfaakAyt0weRqyGO5TL3U7jCQXW0oo/ZFmERPJ/v/XmA4bz+6XeegNr7Lj6QnXNREiiPKzpRlN7yitSitrYYgeVD9ne8MwMaAvDPokBroCV1em4pKskVK4/Rt7woCj7Z5i45Aqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEqkcw3FFTobyOQGLDUnMZ27cTHWEJQLGfzr35g5aes=;
 b=EdsS8xQt6uChhXXNJXnQZZvHq1FwfsXT8UUlP9Ae5XqafRTxbYresCnRVQHimlleBrjfxzTjn+yRKHhFP94WNYY16I1ExL0ENE628HaNoX5SBrk1i7I+U4ISXdw74w2yH7gDZasfub/4U6mRIaOd8oUNkumruCd7nL1lumJo7sNgSNuSZZAW00R4oXR8vzz1vF7aqeNrKPyp5uacnAOk9ppte8AwygPye1spx+uzjPOm1xfFx5RL9LyDBHi/sPHx64PVj+g3aWJyPMAOQLI6j7H16y74E39fkCSN3h/jddbRmfMnvIF1Ns61hE2z/vKYdWY0zD06i6LM5X9Ja04OYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5447.namprd11.prod.outlook.com (2603:10b6:208:315::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 10:46:26 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 10:46:25 +0000
Message-ID: <fd0da26f-6437-75bf-c013-f338174325fe@intel.com>
Date:   Tue, 28 Feb 2023 11:45:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/2] lib/bitmap: drop optimization of
 bitmap_{from,to}_arr64
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>
References: <20230227214524.914050-1-yury.norov@gmail.com>
 <20230227214524.914050-2-yury.norov@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230227214524.914050-2-yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HE1PR02CA0091.eurprd02.prod.outlook.com
 (2603:10a6:7:29::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5447:EE_
X-MS-Office365-Filtering-Correlation-Id: 480a0a68-ff42-4a8e-2760-08db19790a25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: olKXEE/547Or7atlMTq3Siw9dWlSpPW+y52wcp+idAcJK86tblZEGr2h30jYFdjb4U2n3WEnYk0r1e5be3fZltnPPVNlTi+0VFRlkjyTjCRNY4wFPm6n5I6lSo83LaEmBAswbKW1+9m4l15/xGUZm1kwZAgDJmBajA6NvTIzrvkZZB8NXko2CNpSlK1i4+7y4HcdaAQrTKj+S+rvFCq4CvTXOUXapVeAca9kdhjy5yswW6xloO6kUeT4HEOz45Bcan+lzzWR8FSKzjW6TIEHBQ60mPuSIIoyqNa+AlEGVhLdm9J6g/O14hrdsFJtMGfcrZwitLXW3MSgrp26hH96NwwV1bLcRI18dv+ismkedyi2Mf2GoU1IcQ8n+MxPQcyth1CZbBwQCeOWzwKQ8HpyT0wooIivCf7g6FKBm2AvY78sf9QQ8wQRWsDScfkXwluzJPJW/X8drV+d5ztwzy6n+W+639/Wy/z1vvx56AoFIvdIgtO4cz76x44AIIVkaIISxNZX+y0RII2PZzeAT6u+3DwTP5dRSQZbZOu/gLBi9Ci61lAgG7S1lU0vXraQqpMdPN0snWV0XrByh/sS0UlWzTJ0d07xkNM54F6oQYqyuIrfE62UKOXYWLDeBIN8y/O38WyzWb/6lxdBf5H7bAIfTcXFlJSxchSnZpHz+GF9tdLwEhB8wZUjt2vP1ygT3OM2HirjQI70k6s09hQECooq/JxGHkDLraphP5VW6un4EwI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199018)(66946007)(6506007)(66476007)(66556008)(6512007)(186003)(54906003)(6666004)(316002)(26005)(2906002)(478600001)(86362001)(966005)(6486002)(36756003)(31696002)(83380400001)(5660300002)(41300700001)(31686004)(7416002)(8936002)(8676002)(6916009)(4326008)(2616005)(38100700002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFFISEFhZG85aGE5TU9JTmJ6eC9TMWRaUXl4aW83eUpveVA4SFAyOHFwOHh1?=
 =?utf-8?B?TWtlY3RmNjVGTTl5Y21ZNWtFNHB1bW8vQzhNWFRHWkZodEZRbE5xUmRaNnIr?=
 =?utf-8?B?QUhPZUF0dm5uM21rQkJQVWxzMXlHcjNBNVhNK2RiTGJPLy9QTzJCME90WUs0?=
 =?utf-8?B?aU01T2NtQzkwdS9wQkk0dTJQZTRGNHAzeXJ4dVZZQVhydnRPRmEvcjFlbHhI?=
 =?utf-8?B?M2MwTDFLZlBOM0NVYTZ1Yi9pa3B6MHZhVkdIcGNJZ3RrVFNFZ1hZZE0zeDhx?=
 =?utf-8?B?MjUzdE9XNGVBTG85d2hoaktZMEdkZkQzMmRmRzFmc3EzV3R5Q3VoUVV3WHZT?=
 =?utf-8?B?U3VxR3l5VkxNam9uWFZsTmJqY28yQnhrK0VROGVPa01WM1BUQWNIQk5xMlBN?=
 =?utf-8?B?NEpsWWhrUU05dU9SMFB1VTB6dEF6eGVpUmJ1OTloZnNySlRyd0xjQjB6aFVH?=
 =?utf-8?B?TFRiQUkwNXA3WGtwQjAraTlYNkp3Q05QR2xDRkFaNDhkSGFCcmtDTndkZFRR?=
 =?utf-8?B?WXNBbUdNMjJ6SWN6TUNNbnQzc08wSE9zSDlaRXh1cEZkNXR1NlFsTWVlVU14?=
 =?utf-8?B?dEJwazY4YzdTQmJVVVU2N3VCQ0JqdXdPamwzUTZxUzNZM3JrRVNoTE9tZlhW?=
 =?utf-8?B?bmNGeXl5SkRWbC9NdW5nekRCam8xNUVOZW9Hd2pJWnRraGlsUWtocE51N0Er?=
 =?utf-8?B?ajN0cjlEK1dQbVVTeGZ0a2dVc0lQUmR5dzdScVB1bXRGNmhENkxySkNIYnpp?=
 =?utf-8?B?elNlVjhwYW12NlRRcG9lM0ZWYjFRYS94WFdIdjNvNk9HdytZVlBqc3ZlajNH?=
 =?utf-8?B?SWdITWdLc0RhcWE5R1RxU2RGWmVaU1NuakhUR2hUdG5aNFljYVIxb2pDRm1F?=
 =?utf-8?B?SkRpZFJ1T0lTc3ZqSmtnZG13ZzhLdStOa3MwZjVGY0RIdE94TWFkc2I3cmtp?=
 =?utf-8?B?RncxN2F6VDBHazJ6NVZaYW9Qa1ZHZldWTjhOMDdQNE14M05ES0ZXZXY2cWYx?=
 =?utf-8?B?TDFQaThhWWw5ak9ydEFUbm5KdjFpREk1VXI2NlhFWnkvakFkMnBJdGZOZkdn?=
 =?utf-8?B?Q0ZHL3hKaVhkVk9tZzl4NGkvQmNUSW9MczhFdWNPMjRzbS9xaGJrS1BKUFlv?=
 =?utf-8?B?RUx0bzY5M0RNbnhxKytVVTRuTXI3akRGczQ3cnc1RmdHcVc2Ni9DMUIvUlhX?=
 =?utf-8?B?bE1ocXR3dzlXUTIxM2RyRjl0YVhlZ1duNTQwN0hYQXI1Mi93c05tTjZCMUVN?=
 =?utf-8?B?Qmw5ZDA1WXlZbzlGM0RETktNM3poZnliWThHaFBRWEJWT2d5YTlBaFJlblVM?=
 =?utf-8?B?RkQrQUFJNndoRlRoZC9lSlNKUE1RdGhCWlpXSTFUU1RYby9WUE80VmlmWmc1?=
 =?utf-8?B?eEJ3MEZ2cHZUTFllQzN5RDhjV2tjTW1XSG9YTkZ0MjlUWXl1Ukc0WDNNNjJk?=
 =?utf-8?B?QkU3akYvWWtWVW9pbWJ2eDhSemtYM0c1VW1MSjBFME9FNmNsTUNET2FEaDFC?=
 =?utf-8?B?aXpPWkg4MnZvc2NFY2VlcWNRd3Qrc00yWkxPWitQNWhzSmRIdGU2bkMwMEJv?=
 =?utf-8?B?eU1yN1lYaSt6dk83RGh1NVVHbTQ4MWJUMVBXeXd1a2hDQ21aYklsRCswV2tI?=
 =?utf-8?B?T2tUcEhISGhvNUlyUmgzdjJKY3lJNXI2UUkrcmRLNTdNd0h6Z2FOdEpaSkIr?=
 =?utf-8?B?di83ZEp3OFZCN05SRyt4WVJRRGtITkloMUFKTU5pbEpvck03aHZSN1Y3SDhs?=
 =?utf-8?B?RWs0TG9ENFNlTTZvZ042c3M4RjU4Q1FEcDZ1amk3WlJvbU9XRFhxMTdGdllp?=
 =?utf-8?B?SFRVS05GYitSTUZpZ1d5T0VCRTA1VkUyWisyNTBOaTd1YVVjWS9Lc29zLzRr?=
 =?utf-8?B?My9mcFluTlpmY2ROaUFzaVJQdkcrTlRsakdWKzlKbmtPR1lyUjlqY1plVnZC?=
 =?utf-8?B?RDl5YTd1NjJVc3p0TWtFZVpucmdGZ01TWUppRVVJNFlmQkNTZFFaQjlwSHlD?=
 =?utf-8?B?a2tRYjRKQmNxR1ZSQmtvSjdseXowVjBLYnhnYTZLNWxHVjczaGpnbFRrdHRo?=
 =?utf-8?B?K3pQUjNaNkNwaENOckNoelhKeW9IS3U5ekNzTUlNTDRZRmhjS25uMEFYclAz?=
 =?utf-8?B?cU83alBGV1U5UDVvdk5xOEF4S3R5ekYxRmxMQVJUYk9HNFFGeU1qQWNwLzYw?=
 =?utf-8?Q?2IrWbkqnLMtshGboa3hJ/WY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 480a0a68-ff42-4a8e-2760-08db19790a25
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 10:46:25.8126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rf4BIHfrf/+CCQ4oRHkYAUt3Y5O1uZYqCDJVT0hx1Qcg2VETip1NwfPPLZ5+VYEuUxNi3Iu6cU2kMzZYCPl804v9w7xRCkUCdNWy7GDj4/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5447
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Date: Mon, 27 Feb 2023 13:45:24 -0800

> bitmap_{from,to}_arr64() optimization is overly optimistic on 32-bit LE
> architectures when it's wired to bitmap_copy_clear_tail().
> 
> bitmap_copy_clear_tail() takes care of unused bits in the bitmap up to
> the next word boundary. But on 32-bit machines when copying bits from
> bitmap to array of 64-bit words, it's expected that the unused part of
> a recipient array must be cleared up to 64-bit boundary, so the last 4
> bytes may stay untouched when nbits % 64 <= 32.
> 
> While the copying part of the optimization works correct, that clear-tail
> trick makes corresponding tests reasonably fail:
> 
> test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> 
> Fix it by removing bitmap_{from,to}_arr64() optimization for 32-bit LE
> arches.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/lkml/20230225184702.GA3587246@roeck-us.net/
> Fixes: 0a97953fd221 ("lib: add bitmap_{from,to}_arr64")
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  include/linux/bitmap.h | 8 +++-----
>  lib/bitmap.c           | 2 +-
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 40e53a2ecc0d..7d4c90eb3df4 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -302,12 +302,10 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
>  #endif
>  
>  /*
> - * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
> - * machines the order of hi and lo parts of numbers match the bitmap structure.
> - * In both cases conversion is not needed when copying data from/to arrays of
> - * u64.
> + * On 64-bit systems bitmaps are represented as u64 arrays internally. So,
> + * the conversion is not needed when copying data from/to arrays of u64.
>   */
> -#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
> +#if BITS_PER_LONG == 32
>  void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits);
>  void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
>  #else
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index 1c81413c51f8..ddb31015e38a 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -1495,7 +1495,7 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
>  EXPORT_SYMBOL(bitmap_to_arr32);
>  #endif
>  
> -#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
> +#if BITS_PER_LONG == 32
>  /**
>   * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
>   *	@bitmap: array of unsigned longs, the destination bitmap

For the series:

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

Thanks,
Olek
