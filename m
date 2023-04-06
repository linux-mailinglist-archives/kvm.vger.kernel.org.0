Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE186DA265
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 22:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbjDFUNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 16:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjDFUNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 16:13:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8546A1BD7;
        Thu,  6 Apr 2023 13:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680812015; x=1712348015;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jTVAwKSWYDrCTIGEa7R8+KJ1Dlg5gBxeqqt1IIoxe6g=;
  b=b/Es8cP16hdPw92RUYy7Qg8tdZjcALrdSRAbHnt086a2+OOBV+yNJvCZ
   1Mr6lMtYVcshKmzAScPhuaJzIBXwXulH3GLvp4U2h8Uk+q/ffMzRk/z4Z
   g4YchMbEINnjw3Fdw/FqPDoLc+wuyoxOC6NjdQR9qbof8SiRCK1LbszHv
   nOSGUVDrSYDROdfvGeTBgNWcDFPnrS38QfyGgDDRvX2wXr9l7L747gjrS
   G2lxx8s8Qo8GLKtuwF9lSUqki1qSOSwEVvYV4vGP2iMpjot0rcu3zOc7T
   k9k1EAMr2heIlodGFrgPM1KHgOgJB+8BTuIIh0SO2fSsd26NqzTLjOVmf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="342839806"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="342839806"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 13:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="689809196"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="689809196"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 06 Apr 2023 13:13:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 13:13:33 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 13:13:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 13:13:33 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 13:13:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXpZrZy2MpmwKGf1Af2jxTxjL+FjC5y8Y5d8RxHptfwgOWG8NVqxSjA50fm/DY6HIfGUxlEPO0oAtUYU60HfONXmWYVNt39jyb+KBfZj33WrwQr/sSyx3ppsVLJ7GzaRmiEiSv7QE5yyIClNeIAf0LI4L7cmVHn9QPVACKlMtzL8JaAOtdynU4Szfq+vD536s/fjlVN3E1MyCxLS7GHyRNwnd1D8M2+7wuOGrPRcVmlStBMI9ziNwbzakQbpCEsGErUGZmGMJTGgnZUL/vvHvXRjvb/U5r2hm78i+I30BXMmKY3wHmYuy/fVvw/MqpAl2loGE00hg9qsy0Y5WtjzcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uJCbN9Tg94810WUASdKvKZiCwbLgiUUnd55eOEY3X5M=;
 b=c9wMOj9qK+cg1acARZcHX/1stP/wLUHVFB6ZurAklHDfrfJFTZ2w2C7OG5QfTgfTBDqetWcQbr2c+CwHDQJiUFTw9ZuPymPu7kSIKEtM/KBwY81JbyK0ushq0P0ru0ou7uPItElcCnwPh7bAapEyQY1W2yUPeOkdo47JqdK7m9Z/DGdABLihdnGuhPhRIGoV40K05U2B6KcVX37IAOS8bT5tB5TSrDQpU21wUEvKPf65f4C/8C8/9+pRlBv1hg+1v9EMLyW+jIy74/jss9WthQ9Dmx3MfdPaQ4O5SvLGQQJlGpyoB69j0rDFgJZSEFqdK2XHnH/mC51bhNwdhlOWzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by SA2PR11MB5195.namprd11.prod.outlook.com (2603:10b6:806:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 20:13:32 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6277.030; Thu, 6 Apr 2023
 20:13:31 +0000
Message-ID: <336d51d6-9878-a85f-bfab-19fd78a104b4@intel.com>
Date:   Thu, 6 Apr 2023 13:13:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
 <20230330164050.0069e2a5.alex.williamson@redhat.com>
 <20230330164214.67ccbdfa.alex.williamson@redhat.com>
 <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
 <20230331162456.3f52b9e3.alex.williamson@redhat.com>
 <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
 <20230403142227.1328b373.alex.williamson@redhat.com>
 <57a8c701-bf97-fddd-9ac0-fc4d09e3cb16@intel.com>
 <20230403211841.0e206b67.alex.williamson@redhat.com>
 <5efa361d-012b-bdb6-b5e5-869887bde98d@intel.com>
 <20230404122444.59e36a99.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230404122444.59e36a99.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:254::8) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|SA2PR11MB5195:EE_
X-MS-Office365-Filtering-Correlation-Id: d794496b-d78d-4b1a-52a6-08db36db6430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TvWiv8/m1tDj0mRvvBTDBHhkKIDEf9R5qAcXcmfsL/2sb1qMKCnTz1hbAh5SATEw0nAEvRnbbC22RM/UygIP3qdmEkd02eTkVY9lBvdG4ZzZtd48jKRfHMQxlQKBF9PAtHHBu2zBmJmFZlp1mssynzHjifhhe5alAGtG0CZUwSC59DKrYgik3sLx6LLqrWz/KNpj1+A2ua8wUQoZCgdYBS/aqi5qJTbvNx4LEX2IyLMLORMub+vtqGUJqbfY3pllNskmH7Vyaz5o+HecABe20yecwneb4j40spA6p2NgN94NmyhmyitPmBam3BInj5hAnjWHqPTE8pfM/c4vw7rwWeZdcXNuQFt3/qIK0+eayOTYBMYjCjDWjrBPLqIFlIqFhl2dKqk25sz9mPO9imKyNnV5Gz9phwLRQSMfP50DUQPkw+PJmnsguIi4Hz4Ov10+OFl13zHYeBKJaga29IZSiQZW7R25dEM/JTGazvViqAoKWDCQQ5ZNgmXbmPSJeHkAiCoH6fVGt3w2NkJ/BL04nT0IeWQkpnf9qqJIqbhNDhJlQp1+SkaxzblFnKHtut+xJ8KN2wzroR4qfUCEyCmTyg/Prxy6KGiy9YACvrJDw7tM2D8aE9f7xyFm6GDJtDEUbY7930CL2JLt5TChypFxCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199021)(8936002)(44832011)(5660300002)(41300700001)(4326008)(8676002)(2906002)(6916009)(316002)(478600001)(6486002)(26005)(66899021)(2616005)(6506007)(53546011)(6512007)(6666004)(66476007)(66946007)(31686004)(66556008)(186003)(38100700002)(82960400001)(36756003)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTN5SXoyVXUyS2JKNzZBSUZINUlxNU1ibmo0aWZrNEdFQy9XSkZxWHRIckE0?=
 =?utf-8?B?Um9GRVNJZ0Zza2l6T2tmNHZvbGJKSC9WdVd2NnFEd1JoSEpWUmF1R3I0L1Ja?=
 =?utf-8?B?RTd6UmJxdWRzYTh3SUE1M05nT3dDZmphM3c0Nm5rbElZbEVnNjRIUCsyaEtY?=
 =?utf-8?B?TjBBKzl6ZHZsNUZrdGZXVDdBOXhrZnhXN2Z1NTBuZUsvZE5zV21QM3YxSUNK?=
 =?utf-8?B?MmlSQWNvUFNzZDlYNldQOEpXTUxidCt4disvU1FCUU1IaW9WcVJabXFJSElC?=
 =?utf-8?B?a0xDZGI0Y3krZEFoK1hiQjJLQlNORUlHZ0h4TTlCMllvK3d1MVNzdmZqbWh0?=
 =?utf-8?B?a1pwbXhNZk1DMWwyVUhSQTFiN3d1SlAweXVsZzJUOUdQdW1BVEJCWVJmMmI1?=
 =?utf-8?B?UWg4M2hvalo3OVl5MEdFdUV1cWZXTjZnb08rR0dMd1hQRThHSi9TSlVWNDFx?=
 =?utf-8?B?OHAxbVZOa3hzbGhXWmlQY2NjNVNFS1MwMVpHOTlMemRrV2x1SmVvSDM4SDJK?=
 =?utf-8?B?ZEY3dlExOGIyOURrOHJNQUxZOVlTUFk5STNDSytjV2pyNTY1eHJReVJ5WlZJ?=
 =?utf-8?B?RjRDeWNIcVUxcGx3L0d3cEJxS29JSmdtR01vYkRiZDVXbUtoaTlnMjNXbVI5?=
 =?utf-8?B?bERBdzcwNU01VytFUVI2WWlVYnpmN1haVTFUeW1ITjd0L3dKRkhnSjJJMCtt?=
 =?utf-8?B?emU5d3hQNUtpcm4zM3lvNnpLUlhHSFFyeEVid3dtc01WU2dXOHlFaDJNU0Zh?=
 =?utf-8?B?VC9ReXhxZ3ZiUy85VEpvbi85WHdCWHg1bStzOUpRVW1kWkdlcm5lcnpDMmFF?=
 =?utf-8?B?RUcrQWpJRE83a1d0UVh5UzF2MHFidlc5Y3NnQVdvRVJKU2dVYjJSeE01YVB5?=
 =?utf-8?B?STg2TFFFd25oRXhzdEJZSFNNVmZZNzVqejhISGpKYklQREdnT3VHS1AyakxX?=
 =?utf-8?B?UmJGbTNxYUdjN1NEZlNTVm02L3UxNHc1ZkJyaytURDZXdm54VllJbXh3Q0ov?=
 =?utf-8?B?TnpsWGpIdzFHWEpJSnpkTFZVV1RVN1JUWlBKMUxrWnQ3YXV4dDMwUWtGN2kz?=
 =?utf-8?B?RzVuNWFzTU83NldZN0RyWTVMczA0aWx3L0s0bldUOFlpaEY0b0lncjdYRW5t?=
 =?utf-8?B?R0IvQUtiTVhXQW5OcUZmUmV1MWl0U3RIano2ZldodCtPTnBMb3Q3VnVxMFlW?=
 =?utf-8?B?Q1RZQnFxMTQ0TTdEMnRuUHBjaCtrTXZDV3RTVmJhdHMwVnYxSU1BRjA0Wkxy?=
 =?utf-8?B?TlpzVnp0R2tMVGFJMjJMSFBZWDQza1hlMy85VjJhQzA1eFFSWDdUUmNWTkp0?=
 =?utf-8?B?NzZPblRKcHRKRXVQb2xySzRFd2xodHN6Vk5VL2JyTWNvTEVwdDFCaTJTQkxY?=
 =?utf-8?B?b1kxLzcyVkVuWDFvaFBodncyUWZ4TVd3TW1QOHQxa0pyaENnL1RPNExGZjlW?=
 =?utf-8?B?SGNMbnFIRVp2OUw0NHlMU2JjN0trbW13VW5aTXJUY1RpT2ZtbTJVR3JXajVV?=
 =?utf-8?B?cXd5TG5pNDkwQTNCek1JSk96cUk0T2pUUllIYnpzdk9uRmhGN1ZxbEwrb2xM?=
 =?utf-8?B?QXBnWjVXOFpZZnhtRHpqaitvUGZ2WU1Oc054WTZKTldPZzFuNEtScHFVeVpv?=
 =?utf-8?B?bHRGOWljQVFCcWR0K2xJODY4elV0c0JaaldQcXluVWtzTnl5T3M0NUtZR3Qv?=
 =?utf-8?B?YlFuZmtEbVpTRmkwSGRseWJVdERWVnNYQjhKZTJzRUVSY3RIMnlocWNhMXdq?=
 =?utf-8?B?UUZPelp3V0VTaDlCYkRieVhhT3k2YlJWaEcvL0trRzQvc0g5UzdhZVhMY3F3?=
 =?utf-8?B?NFN1MHMzaDlrblZhbnQ1cHJNQjF2K0RpVlRNU3U1RkFvYjhrallibEx2a2Zy?=
 =?utf-8?B?OTBPd3RLNUtLNDh3enpRaENISHRSR0lhZ1M4MTQyY0NGUFVIL3h0ck9tTHIx?=
 =?utf-8?B?YVdqWEZtYUNqRXI3bnlaeWJxVGF0N3pnVlVuRGk1cEFhaldVaFJVMFNMODN0?=
 =?utf-8?B?SEZoQyt5aEpweWdYbE45SGNta1dtQjhWYytTMUFkSExaMFN2TWcrYXE2YU9G?=
 =?utf-8?B?YjQ5NEVKZnVXZnJLdDl6ZU5SUlM5anJBcE1OTFlJbzZUTnRGTkYxNGQwWXdK?=
 =?utf-8?B?d3lpSUtKMWhxTzVnYXBCWTlZTHczVlJIb1Z6NkY3MWVOVDVPV2NTN2ZrUWdz?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d794496b-d78d-4b1a-52a6-08db36db6430
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 20:13:31.5616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VesRPOplz7YGK2tSXkEBArMqha3QrmVZSmCg+t2WejmbSpTp8/Oo+5NXPJ8b9T9ohdJD8UA4VONh4Hbv7F1v5CEJnlVu1SVfQeGoOBJPu00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5195
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 4/4/2023 11:24 AM, Alex Williamson wrote:

> We're talking about the contexts that we now allocate in the xarray to
> store the eventfd linkage, right?  We need to pre-allocate some irqs
> both to satisfy the API and to support non-dynamic MSI-X devices, but
> we don't need to pre-allocate contexts.  The logic that I propose below
> supports lookup of the pre-allocated irqs for all cases and falls back
> to allocating a new irq only for cases that support it.  irqs and
> contexts aren't exactly 1:1 for the dynamic case due to the artifacts
> of the API, but the model supports only allocating contexts as they're
> used, or "active".

Now I understand. Thank you very much for your patience.

...

> Interrupts and contexts allocated together would be ideal, but I think
> given the API it's a reasonable and simple compromise given the
> non-dynamic support to draw from the initial allocation where we can.
> Actually, there could be a latency and reliability advantage to hang on
> to the irq when an eventfd is unset, maybe we should only free irqs on
> MSI-X teardown and otherwise use the allocated irqs as a cache.  Maybe
> worth thinking about.  Thanks,

I implemented this change and I think it looks good. Enabling of dynamic
MSI-X ended up consisting out of vfio_pci_alloc_irq() you suggested and
one more line that uses it. This is because I also made the change to
defer freeing irqs to MSI-X teardown and doing so is surely more efficient
in the scenario that Jing pointed out.

I did not transition the INTx code to "active" contexts - meaning that
the interrupt context continues to be allocated at the time INTx is
enabled. From what I understand the additional support for mask/unmask
requires a context but it does not need to be active.

Reinette



