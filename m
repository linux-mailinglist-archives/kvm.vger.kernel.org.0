Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C1D723C8E
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjFFJIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjFFJIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:08:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8122C8F;
        Tue,  6 Jun 2023 02:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686042530; x=1717578530;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=feLSl6vjh71Vq3uq6HMGwtZXo84U/oxY4wcAbiFtXv0=;
  b=W/A8Si1zPuAqJCLnv0cSSupEThKchInu7ZSDDOIccqcUORWkIJzMY9QJ
   vsuEbR4sRX+DOB880Vh8bpozKg77FjgCI6OT/3hWwqZ3RUl4eDPQSabDd
   RMtI/l1n3xMG9cbkVxhQaiyOjh4tRZfWoE+yAaJnWmz7YvI0W/KDSHW71
   QyjnKDlT915EQiJrqvXOQMMd/U3vbYaO/WaBoLmTiIUG2zfKpySvh5jj2
   owVFupY9BSKm9XgdyxWfN5/sspo2QQbdggVPOQ/+oPZFDk+bsacXyhryN
   uUyx7XUp5MFriFValdPO6ypWFQtzAZabf4ClZiFh7ZLkAW+MpKzNRONvN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="384920281"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="384920281"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:08:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="1039102280"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="1039102280"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jun 2023 02:08:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 02:08:47 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 02:08:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 02:08:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 02:08:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUXfSa37mX06gNCVZCCwF6MJm2RDqwceFn0r3giEUflg3OH7AdMMvBT6s+sp0J98pHHWNtrGxQgui2sg17Ag1WkI7sY1k1sfWAGcAMF/9AcmBqZv5oY2UnTNJXBijaZCMvSymdGOTO6Rbp4V8+f6+I2S7CWgHCvkTvk12GJiyTAYFq5OPOrjr6OVcAd2ba/m6cDuT5XdrR15bOuahO59bRmDfOX/6FlQl8MyhqFpQXDgLmEV4fLLtqGzGys3a9FhioW8Kf/5luXwDGollgas4IsxOdi76pgP88EmqUtZWAgaShXlbYxDhrAiylrDvZEEhAmEoy9b7/Alc4b3JAV8ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=feLSl6vjh71Vq3uq6HMGwtZXo84U/oxY4wcAbiFtXv0=;
 b=lA6llOo6dZ40dqpMWiEKQpjhcUZib8BArCrs2RweT2yu2E1R2c/u8aTMdWtqU8JCovcGAX/oqpk9CG/R3g9oFAx5aXgQcaIx+lpsFYGRiSG8gYZG9fZbLaFMw4ElEvjm0i6SfkKruCzF3Z+1yVC71zPQq0fq7Qj7icluT7dm8Lokl6qKjnK6KYqrdD0dNk/pk5TthGLLtEwMm+PBSptm+DSErlk0quN9N3Aa3EdLODY0x+iUT8ZkrfPcyiFVhtyxHJObi1v6Yddln2vZllqL3X9o20JDXSGN34Bj5kQ9ghadMPiYAIMdqfoNGSF02jh/X5y3S387b8Y/oUqIWI53gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA1PR11MB6941.namprd11.prod.outlook.com (2603:10b6:806:2bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:08:43 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 09:08:43 +0000
Date:   Tue, 6 Jun 2023 17:08:32 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
Message-ID: <ZH73kDx6VCaBFiyh@chao-email>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230511040857.6094-11-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA1PR11MB6941:EE_
X-MS-Office365-Filtering-Correlation-Id: ef7ee797-ae5f-42cf-3228-08db666da00d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HOkBLfsdP/pzIVK2MXRQ/on7LKwSNUozaGJJaU1IQPvj86MTMqxw8bcKL7YFk3p1vDHx5H3wjS5nksCgZXxOB4B4Cphm5lm7OT+IRr+atwXhWt3tmb5RKVkeCzwwFAna4uGMhMoe/4hxR8hG4koL+tpm78/fKZc7eqFxLK73/j8ns7NYGnV0c3ztjs7XVhKHlbiEGewQQcW1W2jxxHgTeKphbKmSjM+QKRZMAlayn0GqGGsv1eF5qspMwPoYuAPWeRRidQkbPCP7k9FUX9hZ+APuGjpY54trGOhHCo+sjiPn0qzxRmeTadtQjZAbEixSKiqeEz1DHP0jFBQHzcs/N6AZUyFG+7iEN11CHYtiTdN7e+VLkUg9UiTgIaMTT3f1zvHq7UN3gcBkn9HLufWgXNpuudSqUbUG3noArNNiJGO5yZRCX0k7DVu8bkPXqV+N31mUW2KtWyiB3xu9B3X//s5b3+sp8NvaJxn/rT5JM0+YZ3ivoT3RHeDLrH2ZM1Z7SW9xC/9lBj1ukUobXKO0bcjfDaa84dYzIasoTCcBqqYicL21vOprUzuWTH8xDgRp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(6512007)(9686003)(6506007)(26005)(86362001)(38100700002)(186003)(82960400001)(33716001)(44832011)(41300700001)(2906002)(4326008)(478600001)(66946007)(66476007)(8936002)(6862004)(6636002)(4744005)(8676002)(316002)(5660300002)(6486002)(66556008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SwA15aZH9HEdMfmbnnRCrU8n2gWOhWNc6/iYHWBAuqZY/205us6/9Jzj6fbC?=
 =?us-ascii?Q?gsZw0ZKoUNaEzA5jGk8gteNKHhzRX/krXRUTPsHvNG6BUI30gEUPlKq6gmyX?=
 =?us-ascii?Q?FMLqKiUq3p057DdD2y/GVbH/AvXY85gmiSXr1YW0HJRRmrfQ0OxBVom0L2On?=
 =?us-ascii?Q?E7xE6RGFu9z9Lmglj5zGowBKwrgdItbYHvxF25gdQoI8DmuJTfaVBGTiW/T5?=
 =?us-ascii?Q?+xjoreIQkX3rPfc6v9nzOVnvPaonKr7PSWcv+pa2E04lXxJj7w97UMSjwgKX?=
 =?us-ascii?Q?meQRu/p+sm0lrp9vnoYOowOBWjCEh5aU9iXzlnyKpsrr07REfri7XnXCYRS7?=
 =?us-ascii?Q?05m4xbCcs62fY1FF3C1AWu4B6IYytHaXwWw2Ck2SoVHN/07tz2/zGmVNZyWf?=
 =?us-ascii?Q?ueSyJ+nniKXvncd0Anj+3zkUmnR0cDbSCjQLEWwRzO2Gkrk8WtvW51MS9Z2d?=
 =?us-ascii?Q?UkqJhWunik8f7p1wNKd+Yv92u+eOc49EScivBwqLoZytDAVhC5YDS9u8sA2H?=
 =?us-ascii?Q?ezzR87L5W5DYOQON+hTrzQrm/pQ1pv94mC8HJl2dEd0tyOOf5AmhEk/VpwFX?=
 =?us-ascii?Q?BeJpYguiMw2OyUxeYyQlrK9g6ajeiZeQ1r/QMpSwFZ5DTOoQZpZoN92ASacQ?=
 =?us-ascii?Q?NNU9RPnQlniDx4Z1srATKUgaxUuiruxZvKCfeGR0EhL9USwk/ZdvVfrcbvMv?=
 =?us-ascii?Q?UC9IIrlhYOaBiLV8RhshuOXlwDxa6cr9MbufoYszZJ0v5zQe+mrV1chgl25b?=
 =?us-ascii?Q?VTIgIdvbJSwuU8+XYpFXSUHMgF+a51GHAnwkM4DUbJ6+h8F2DRajg8kkZXgN?=
 =?us-ascii?Q?2AqCod6fwB9i2ZgZt/PHUKiKMJuR4fX3QF1qvgp3idC5o6JxOtFuColoMOax?=
 =?us-ascii?Q?4Scnv6t5e8/tJGhVd0nNicJwo0/qfD8wpEyG/P8bXWPMKtBt0YTiXGA837ug?=
 =?us-ascii?Q?ZqHQeJlHJ6NfQim2Jy8UtKU5PgCFjqKj9Qnq2z2ErcbOPSm9QZN+Q5ZPSnvQ?=
 =?us-ascii?Q?unDxJvARRaIY8qtx7JnsFTmO7YvsL2KBoynbdz4lEV045wFpjbG2bA0VvWoO?=
 =?us-ascii?Q?N7ftDrmN4s4Mb8AF3015hVamyJ0yeWeeFK26FJ9K5mA9G5UwMO8oUldBIdQE?=
 =?us-ascii?Q?eY7zx92Y2qfFBXKq8IpB6cG+tKMWQFas4XZBjKd8ezAcll0nTmLjX2MaztPd?=
 =?us-ascii?Q?Da6It+SccAyNiQT+jyoEWunVvMh2w8KAA99Ex9e3OLOpdISn+SaR+kUTG8NN?=
 =?us-ascii?Q?5OrLN8IKdljWBSN2x3Q+xaJB5FMaG+g8paTQwfYX93hHUYVnyGVJ/6prL1ny?=
 =?us-ascii?Q?OFZey+QLxJv7SbZCxaCj8BsvUxIQqY/3TjWfkBLqCDHfDgCTA/PQPZOHUNRz?=
 =?us-ascii?Q?Qo/mKnDOErH5r82t7tJziSbBWeJ5AHs3OhVxm1G7TP421MMx01xAFgvdnko3?=
 =?us-ascii?Q?DZq8/5SbMT2y4ek6Vje6184fUd+Gfz/XUtZoSFLiscrbMkaPyNGlizl75azK?=
 =?us-ascii?Q?EM5euJvxGVy5TznKerIlWA4ZU9i+N07xnVe6K2qRhGH9yszu33bI4GVD0t1d?=
 =?us-ascii?Q?OnMWhfwXGjrOH4VGxPtTbP7fqfpvCbipcRoUeWqz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7ee797-ae5f-42cf-3228-08db666da00d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:08:42.9261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: muUhB0zVfvlrH8ye+XFcA9Usn2l7xbaSUGC99KXO8JXFyjEPqfhikj2ShYvWgqP9GezYfzWoE6BT8CYN99ypVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6941
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 12:08:46AM -0400, Yang Weijiang wrote:
>Add handling for Control Protection (#CP) exceptions(vector 21).
>The new vector is introduced for Intel's Control-Flow Enforcement
>Technology (CET) relevant violation cases.
>

>Although #CP belongs contributory exception class, but the actual
>effect is conditional on CET being exposed to guest. If CET is not
>available to guest, #CP falls back to non-contributory and doesn't
>have an error code.

This sounds weird. is this the hardware behavior? If yes, could you
point us to where this behavior is documented?
