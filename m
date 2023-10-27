Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06797D9D41
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 17:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346224AbjJ0Ppo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 11:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346209AbjJ0Ppl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 11:45:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3580CE;
        Fri, 27 Oct 2023 08:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698421537; x=1729957537;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ET3QttEYQo+3p+48IKCHvrkpruVK9gj01sMdP8QeE6Y=;
  b=KF/Smmj2+ZTcXWFk1GNAO7CKH149ezon3sJn1yj1Nkr8BuEHIGAS0Ibi
   kN6OSK+jABu8kUrL2KoC6davUqybElPI4syJ87azMppHna2uhbbwWsog5
   Vi4K/prJsckSswkdRi1CPmy+MB9m3f2XN9RVN7GZWUIP6vMngbfsCFMU1
   7ojsH4Ct+W3zbjvByZO8AIqlFoqvkg8jVLCKui1tthi94NFfvcoTuXxg9
   RAR7GOnJUKB+qgsJ9SgnOnKMaS4xzq5MXiYWFEWdtxRY4qdVhTe/acIif
   ySm9uyl2vTpnfLnkrX8q0KG2YfQ6gFRDR+jClyzJrlppow8d8DuQEIchI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="385001902"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="385001902"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 08:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="7264575"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Oct 2023 08:44:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 27 Oct 2023 08:45:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 27 Oct 2023 08:45:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 27 Oct 2023 08:45:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 27 Oct 2023 08:45:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhKVyyMqP0lJ+wP6ftfECiS9Ulkcj1WJgOLf24L9dse8fTkM9LtJJfTSKupLpIuOQ41ACOYl/yzYKNBCM3vBsG/66/8V+7lxsnT/eBUjpyWqVBLA3TVlI8GQdsxpeax/JblJX64zsDAJKGPY6N1Z0tgM+1Q8w2vw3876ZdL8xrc4y+x5xwPsF3n6XIL6gPXiW9lQQDHf+8NNF96QtuCRZXMzFk+sslESUd2Ka3LiEtYgQAuCeGVVaOraZiNgQYCjrj5IxKlWqSsxV2ff/UfjNw9sslhMXgZ2eV5rxLctdYTNVs2NC7UHo3dtNwa0CE4JsrHWhrN5lTt1tZlYK0qygw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWjaSiz1kochi51vvkPHW4QiM3WIrayI3VaVYPRKG+M=;
 b=HqBHOqd7FBOe3lJKoL4NjLE84+BF4yjNsghREgaCibUiNf8YTlHty8Yitu/FZgKyc7Safae8MdbepadOM4PhgYUYugmMgwjmImmbpcqpZl5pilP6/QU1F9B695hebOobwpKfsEYx1/GEitgTBnlskha8wX2BhOCRgORzVhS4hSIhKi5A5llABBPfSPp/8g1P9uO872wfVSafydTb7pzI6nu0nvC9iGWoOkhVp49AqoW1E6rsoOufJlRyn6pLN0L8dbqPC6Tqs1J8/NpAp9Jiyx/gQArIsaOEf/VTHle7QoPQZbl0bvM0/evlA9VM3CRtIA5l1MWW5heFSLn8YwBnxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5262.namprd11.prod.outlook.com (2603:10b6:5:389::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Fri, 27 Oct
 2023 15:45:26 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.6933.024; Fri, 27 Oct 2023
 15:45:26 +0000
Message-ID: <bc7fa0c4-d20e-713a-da4c-c65ec78080da@intel.com>
Date:   Fri, 27 Oct 2023 23:45:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
To:     Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <chao.gao@intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-7-weijiang.yang@intel.com>
 <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
 <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
 <ZTf5wPKXuHBQk0AN@google.com>
 <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com>
 <ZTqgzZl-reO1m01I@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZTqgzZl-reO1m01I@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::18)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5262:EE_
X-MS-Office365-Filtering-Correlation-Id: 212827e8-8a42-4337-74ed-08dbd703bd1f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LcG84PrG9Ednq4yJvQ/h8TEuZq5WRbDCIrNdkqutbYjwngKjNuJQy4P09nSxxyYuUbYxscnpRcDHjLVyFu97M6l1LPVxwcJ7ARIC8ZQK2q//h740ecITf+DoPrERSm8fZXB79z42iwJuy9hpdl51pklQC8HyVsLnsysaBEUv7azYb7XtWJ/HxMvOgTbg5IHS2QHQmdphunGHzNry2V3rGeAvC4gENzFbb0CZgv6/XTesjAFFYJUq/JIaOBC45EM0unvKgdnk2TI+8z4dik6qdgcBjSTiWb+eA2eKGCrHPcR8vjQgMimz8h7JU/WMvetX9W9fRA7NnRPBsfcDl+QMfVb7f0OlV0dAJ95BfljNpgE+gWax/RPNaBCuM63Fk05BtXVo3UuortGkAv4z6JKuPEUrx4DUqfegO6IqwRjX1GNG5F1AYYNkQkJWNkygBJ/Twwk3McKXqGttVfEmRh0Uo5sSffE9PNLfPq6vKYvwWPgrBIFdnivgyvll9/iG7/7dCALViCD8gBKiZj4zFUIZWYSdjQ2D61bBC3cFfk5ZMdg0oh2TUpMWgviQ/JQE4m2b6urXGbe9ot9oS+uG80cEH4U2zuEqgbAzpGKcY1cCRtzdlmxpzl0Csf4PLBoufyMc86NhPbB4ZSEdqR32E9R2D2prPepn3017RzZ8DtYP21MhcxUxW60tTlGz9ExSOmu60Pa1b532Fh1AfHE2IpAyqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(376002)(136003)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(6666004)(66476007)(66946007)(6916009)(316002)(38100700002)(66556008)(31686004)(478600001)(6486002)(41300700001)(86362001)(8676002)(4326008)(8936002)(5660300002)(53546011)(6512007)(6506007)(31696002)(36756003)(2616005)(82960400001)(2906002)(83380400001)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3dtQ2xMbHJiTEwzeC92eW9PYWl5eHQ3K0YxcC9Ka1JpTVVjZXJQd3FvbGVr?=
 =?utf-8?B?YmxTOUJpSm11NXhUanhocTdNNW9TUXB6eGhTdmo0SExOeWs5WE85MENXbEZD?=
 =?utf-8?B?My9jVHBrVU9BbGJ1aHFZUExLVUFrbUJaUVFwbHZITlFTQXdQYXA4TW9UZ0R3?=
 =?utf-8?B?K0ptU2NlTmtzOVo3OVFpS1h2WTduNUVGbitHaWsvRWhObHhBSXJuLzlydVpC?=
 =?utf-8?B?NGR3RDRKNS9jVEE5bmI4L3pibGs1WGVaS3NUcTI5Skp2M09vb1hxQWFZWjJO?=
 =?utf-8?B?NHZMN0NoYkxOTVExNEpvZjArd1JhczViRGNXMERoWnRQQW9aMVRLcUFUMDdO?=
 =?utf-8?B?amxtZkJMeGhMUElWVlhha1pmVmF5cVIzam5jVG1JcTJTV1FLa25TYmJ1VFBy?=
 =?utf-8?B?bTlKZnkybHZuVDhmaldlcUc0ZHB4bXdJRVlQRDFwT1JzWnhUWHB3TGFMKzFk?=
 =?utf-8?B?dDg0OCtMS3hsdmYxSFJ3MGJ4UVR5cGRNdVlHK3NKR2xqdEFBWU9SWmZsYWhy?=
 =?utf-8?B?bnVhODR5ZW82T3RkbUg2SHdUTEgxZkxyTWx5ZzlRWjBjM3JoSmZLQ2dMVVFr?=
 =?utf-8?B?UUxkQUpyU2oyYlRyYVpkajFPbWVWTUw1RDNTOE0xN2VwVVZBT0pyL1M0Tjh6?=
 =?utf-8?B?YUlXTHFYTkVlTndjVUFZbzBnQkV5MEFEakU0YkZSR0d3a2ttVExDQXlhd1ps?=
 =?utf-8?B?akNldEZtaTFkVkdZL2ZzUnlaMFg4dXYyRWNsSEk5WjZ6QlJnTGRnOUxBSkpi?=
 =?utf-8?B?WkZwTXVvbS9TSTg1U1pvY3VNVDB0T1BTNG1pYVpiZnphN2l3OFRKWDZZMHE0?=
 =?utf-8?B?eXYvT1VrQVU0N1F1d3NralcyR3F6SGdxeS9vNFhMdS9rT0xGTUwwQXRNNlJl?=
 =?utf-8?B?R3l3V2RGckZJTFgyLytnQnR3U2Z3RU9pSWZHVjl0SkZ5a2k4bnBjVVpEUHFN?=
 =?utf-8?B?VXZYSWwvYWp2Uy96NVlEK3QzVHNrSW5pUy9vVFBBdURqL2RpRis2TFpSSzdF?=
 =?utf-8?B?aWhKOTFUdmpFTG45K2dWVnJMeTliQUx2MEZSWkJsN3hXZWJqSVR5NDJoUG5D?=
 =?utf-8?B?dmdOVm0rTndBV1d0K0hiSFJ2UXpxYVRZTkJ5dEFMZGFCU3pOTE5yMGQ0bTNL?=
 =?utf-8?B?UzFNcFBKYXVieE41cXZ0TTlnT0JtSThoZ2RHbXUxSXNuQ0JjRUptYm5QWERZ?=
 =?utf-8?B?eFZ5cytPSEsxVkxCdnIvY2JrSGcvRFNIMERwTTZlK2doTXB3cmtSZTNJWjZG?=
 =?utf-8?B?ODVzVjNKajhZWEF2WTVtVStPaFNPbzhFcC83dHlpb2ZHaW10cDZablhOUXoz?=
 =?utf-8?B?OG5BUjhReXRuRU9vemkyQlU5OGMwN1FZWGlQWjI4SmNNd0tqbjIyZkhLZW9p?=
 =?utf-8?B?Z1hTWWZEUVRVNG0zam5GWHE5MXo4UVAvWVJCY3RRaHEreWhENjBUMXE3dnVM?=
 =?utf-8?B?UisrZDFIWkNTdDRlZU5UeDVTMEN6eFNLaXVlVDdjSWtTdmNROVhDUFpNUE5O?=
 =?utf-8?B?SzhPbkVGUXU2RHpNZThkQ1VGV2dyV3VocWovTnd2aTduNWFkZDducFMzWVYx?=
 =?utf-8?B?SktUR2dmQi95QXd6K1NaMVhoOUFCZytBd1pOMit1eW1kdkhsOHJZYlZCMTJz?=
 =?utf-8?B?UDQybU9CS2FFeGxqbkpLVDNrUGFWU2V1VmJFaVF2N2lOcW9GaVFQMVVRZFB1?=
 =?utf-8?B?SnRKSWJ0bWFhMGpTcFRUc0dKV0E5Qy9Ra3REOTBndUVKUEpHVTVRQkQvTVdP?=
 =?utf-8?B?QlFYYjFkNnJyUDdRbGRXQlFsanVTWGQvai84VmV1QzVkeC9Za0RjTHYyTUxX?=
 =?utf-8?B?N29Hd3hKUVhKRm91amE1cm9WNytJQW92N0hCYlh6Mm9LVEpqQWhnTWV3enFk?=
 =?utf-8?B?THlPcWpSNGEzVmdaTWxUc08yNjU1dzNGYkJSM1h2c3pwZ08rbGJiTTlwcEJT?=
 =?utf-8?B?c2wzN1EyV1VVSnJtM0lxZXVjVTUzS3ZpbjRGNDBONVlUeDBzcW4rZXhIOEZU?=
 =?utf-8?B?d1BYdEkyOXVtWXFFNVgzRlVuL0pieU50YXI2ckUvQzlFZkZwdGhnaC9oN21H?=
 =?utf-8?B?bE9hNmVvL1NjaDRrTlFQSmJ5S3Y4eHUxNVNDY2R4dUdCRWozd2VMZVQwd1RQ?=
 =?utf-8?B?UHllRkk0WW4zR2tOanFDY2hiKzF6bFE4VHhSTzBjNEdYVFNoQUNPTHZYYmRn?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 212827e8-8a42-4337-74ed-08dbd703bd1f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2023 15:45:26.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFinm1ik8g5r32E/DXp+JLWWg1c+4kykKNSF7cFGMNoaIkAaWOGGMFJsUejTmw6eMjq1H+MXetb2JN5Y8NbeOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5262
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/2023 1:24 AM, Sean Christopherson wrote:
> On Wed, Oct 25, 2023, Weijiang Yang wrote:
>> On 10/25/2023 1:07 AM, Sean Christopherson wrote:
>>> On Fri, Sep 15, 2023, Weijiang Yang wrote:
>>> IIUC, the "dynamic" features contains CET_KERNEL, whereas xfeatures_mask_supervisor()
>>> conatins PASID, CET_USER, and CET_KERNEL.  PASID isn't virtualized by KVM, but
>>> doesn't that mean CET_USER will get dropped/lost if userspace requests AMX/XTILE
>>> enabling?
>> Yes, __state_size is correct for guest enabled xfeatures, including CET_USER,
>> and it gets removed from __state_perm.
>>
>> IIUC, from current qemu/kernel interaction for guest permission settings,
>> __xstate_request_perm() is called only _ONCE_ to set AMX/XTILE for every vCPU
>> thread, so the removal of guest supervisor xfeatures won't hurt guest! ;-/
> Huh?  I don't follow.  What does calling __xstate_request_perm() only once have
> to do with anything?
>
> /me stares more
>
> OMG, hell no.  First off, this code is a nightmare to follow.  The existing comment
> is useless.  No shit the code is adding in supervisor states for the host.  What's
> not AT ALL clear is *why*.
>
> The commit says it's necessary because the "permission bitmap is only relevant
> for user states":
>
>    commit 781c64bfcb735960717d1cb45428047ff6a5030c
>    Author: Thomas Gleixner <tglx@linutronix.de>
>    Date:   Thu Mar 24 14:47:14 2022 +0100
>
>      x86/fpu/xstate: Handle supervisor states in XSTATE permissions
>      
>      The size calculation in __xstate_request_perm() fails to take supervisor
>      states into account because the permission bitmap is only relevant for user
>      states.
>
> But @permitted comes from:
>
>    permitted = xstate_get_group_perm(guest);
>
> which is either fpu->guest_perm.__state_perm or fpu->perm.__state_perm.  And
> __state_perm is initialized to:
>
> 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
>
> where fpu_kernel_cfg.default_features contains everything except the dynamic
> xfeatures, i.e. everything except XFEATURE_MASK_XTILE_DATA:
>
> 	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
> 	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>
> So why on earth does this code to force back xfeatures_mask_supervisor()?  Because
> the code just below drops the supervisor bits to compute the user xstate size and
> then clobbers __state_perm.
>
> 	/* Calculate the resulting user state size */
> 	mask &= XFEATURE_MASK_USER_SUPPORTED;
> 	usize = xstate_calculate_size(mask, false);
>
> 	...
>
> 	WRITE_ONCE(perm->__state_perm, mask);
>
> That is beyond asinine.  IIUC, the intent is to apply the permission bitmap only
> for user states, because the only dynamic states are user states.  Bbut the above
> creates an inconsistent mess.  If userspace doesn't request XTILE_DATA,
> __state_perm will contain supervisor states, but once userspace does request
> XTILE_DATA, __state_perm will be lost.

Exactly, thanks for calling it out!

> And because that's not confusing enough, clobbering __state_perm would also drop
> FPU_GUEST_PERM_LOCKED, except that __xstate_request_perm() can' be reached with
> said LOCKED flag set.
>
> fpu_xstate_prctl() already strips out supervisor features:
>
> 	case ARCH_GET_XCOMP_PERM:
> 		/*
> 		 * Lockless snapshot as it can also change right after the
> 		 * dropping the lock.
> 		 */
> 		permitted = xstate_get_host_group_perm();
> 		permitted &= XFEATURE_MASK_USER_SUPPORTED;
> 		return put_user(permitted, uptr);
>
> 	case ARCH_GET_XCOMP_GUEST_PERM:
> 		permitted = xstate_get_guest_group_perm();
> 		permitted &= XFEATURE_MASK_USER_SUPPORTED;
> 		return put_user(permitted, uptr);
>
> and while KVM doesn't apply the __state_perm to supervisor states, if it did
> there would be zero harm in doing so.
>
> 	case 0xd: {
> 		u64 permitted_xcr0 = kvm_get_filtered_xcr0();
> 		u64 permitted_xss = kvm_caps.supported_xss;
>
> Second, the relying on QEMU to only trigger __xstate_request_perm() is not acceptable.
> It "works" for the current code, but only because there's only a single dynamic
> feature, i.e. this will short circuit and prevent computing a bad ksize.
>
> 	/* Check whether fully enabled */
> 	if ((permitted & requested) == requested)
> 		return 0;
>
> I don't know how I can possibly make it any clearer: KVM absolutely must not assume
> userspace behavior.
>
> So rather than continue with the current madness, which will break if/when the
> next dynamic feature comes along, just preserve non-user xfeatures/flags in
> __guest_perm.

Yes, it's time to rectify the confusion and make permission based settings clearer.
Below patch looks good to me, thanks!

> If there are no objections, I'll test the below and write a proper changelog.
>   
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 26 Oct 2023 10:17:33 -0700
> Subject: [PATCH] x86/fpu/xstate: Always preserve non-user xfeatures/flags in
>   __state_perm
>
> Fixes: 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE permissions")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index ef6906107c54..73f6bc00d178 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
>   	if ((permitted & requested) == requested)
>   		return 0;
>   
> -	/* Calculate the resulting kernel state size */
> +	/*
> +	 * Calculate the resulting kernel state size.  Note, @permitted also
> +	 * contains supervisor xfeatures even though supervisor are always
> +	 * permitted for kernel and guest FPUs, and never permitted for user
> +	 * FPUs.
> +	 */
>   	mask = permitted | requested;
> -	/* Take supervisor states into account on the host */
> -	if (!guest)
> -		mask |= xfeatures_mask_supervisor();
>   	ksize = xstate_calculate_size(mask, compacted);
>   
> -	/* Calculate the resulting user state size */
> -	mask &= XFEATURE_MASK_USER_SUPPORTED;
> -	usize = xstate_calculate_size(mask, false);
> +	/*
> +	 * Calculate the resulting user state size.  Take care not to clobber
> +	 * the supervisor xfeatures in the new mask!
> +	 */
> +	usize = xstate_calculate_size(mask & XFEATURE_MASK_USER_SUPPORTED, false);
>   
>   	if (!guest) {
>   		ret = validate_sigaltstack(usize);
>
> base-commit: c076acf10c78c0d7e1aa50670e9cc4c91e8d59b4

