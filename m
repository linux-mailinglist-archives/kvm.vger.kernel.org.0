Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C599F626605
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 01:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiKLA2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 19:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbiKLA2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 19:28:09 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5461A120B9;
        Fri, 11 Nov 2022 16:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668212888; x=1699748888;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=VTwT+tialsxf5AgEEfz84pbg5q8YEjG4yNnIKMSkPdc=;
  b=fOe156300LLX8Zts56P+54hSvyojqEVvNiQ9sVRP1i5WYiF2nhNy6FEf
   9fi/R0sxpotfHgSB9pB3Drkq1TTaSkLKMpUGxh6ki7sqNUb45tr3doqB0
   NSFKzBuk0Q7U3W3G6G/S6VrpLCYes5pivL8PP1bs7OjP/xHojvB0evlNe
   l/D+Ui+i+mysFXpYFhbo3yRKC6Sp8gM1LfHe9VPB8XlBjbS9Lnu8Cm3Cs
   I0rFQiSMi1lIaFQc3s5rphgFLQKvPXv3Zk9cIj63KrJynDy0+Fol9bE+G
   5492uajuYbaLGOBwxmSVXIFgC4LMD3oZ2x992jBwCfp3bGoJ6/5geek3Z
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="373813762"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="373813762"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 16:28:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="615620375"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="615620375"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 11 Nov 2022 16:28:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 16:28:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 16:28:06 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 11 Nov 2022 16:28:06 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 11 Nov 2022 16:28:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdwOudJ4NX5FjcBfSDLwMV0pN5v+fL43SzckdpeWtU9xE0P6qo3kWFcvW7WRXch8SN2tIHlV5BXO5e7iXKiTlh60SSe+UUcR19JqgcekAMRPKTULr/YZX1cvA3ArFDeWhh6WQnozDC/KU6WCdIGSTF8DuNGhs2HG3PjFd3eW+uYrgEA2I/bjrBBO/4RfIVCbQOVjdsaDo/nCjuvkb7hCw9SZoPzEwohOvUu8a4cJijLq72xOHfl79ixO2IUGanDEpDHj2GADi8pDpob/nyowAU2qBqOOlwaeTC45h821LNOoI8EYpHlJQ8cCY5dnzN/1ex+3Z7Nx7EI2QMjiWeBsmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L5nQbX5YmVXKgjhrLtJi/Mxzfbx4kdPpX+VcerN28s=;
 b=icbF/Vo4AJwqtH6qujbzQASZSVgerqQ2jJsSALLleWvuXvlqfSFftq+18hgzV8MrGB09AQyEHwXEyIBjA/xTQer5+f/acDUZlwazlJHHHZ1j+ElpfXzSF4V34/OPy1QGKmldOuXqKexYMG5adslVDDt9oCWlyb0t+vei01bIXmFw7923JoNkA8DHiUBnyEEgwxDe9bprrrPrYS3eojOGSHBW0tIpXb8sh6S3FoDlI4yS2FkV5g0mcIPVGhJdKLiqtXF8RpTKoUCTFaQAZiARjnwPkLZFXYEMh+v1nwPo361jvUsQWNB/JOc5TJPSC5LfwoWAm4sinkdSdTNkuPiYrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6809.namprd11.prod.outlook.com (2603:10b6:303:1e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.14; Sat, 12 Nov
 2022 00:28:03 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.016; Sat, 12 Nov 2022
 00:28:03 +0000
Date:   Sat, 12 Nov 2022 08:05:18 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>, <zhenyuw@linux.intel.com>,
        <pbonzini@redhat.com>, <intel-gvt-dev@lists.freedesktop.org>
Subject: Re: [PATCH v2 2/3] drm/i915/gvt: switch from track_flush_slot to
 track_remove_slot
Message-ID: <Y27jPnf48VStNRwN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103436.22381-1-yan.y.zhao@intel.com>
 <Y26BV9a9q8nBz/+7@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y26BV9a9q8nBz/+7@google.com>
X-ClientProxiedBy: SI2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:196::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6809:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d60985e-c171-423d-e636-08dac444c2a2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZaq+D8R8XU+HQuag8Lyx5sFDhj98cUIxBwgoBSPnotDkOThBJA52aw8LyySeycktjaAgAdJe/e475b3jJfbu91q0mTJe5grncsZ0sMGbgD8wGZ8s+OSvj5iy+FbaPjzRDPLmQ6Uv9UlAqSK6EjGBtSjZHedDB26cs34N5yFqU4dJN9d2uL7tNMZLjZhm+HQlYvO2LUWC+jzXiPaRJnu3FhBoDpLkeqZU0upT4Ay6E5wnLr9J+db/i7NLVBMdJxBZiT0afkVs5QsJOOs9FxK+knaD6T1XBMBLNHkRKMxeCFfvqwx4YyHmvbpPkpEzHIIsDjuewFFLvxQUz997iyVPR/QkvcvxEEbYWKj2oyZKmh/y7tlwHeYKQ/GaXsLrwOl0Nt7hkUGU9SedZ3akLh3kYmhmYv8WErZebwTI/ojgeJuTLtJl7URJ+rZHOQVOjd4e5xMqZqYWVUEXnDb2jo13HAXrLZnPk6lP7u6Hyw6ryjE4NQupDAn5Zs4RVjnd/f0MDxMjaErtKzn51sVzJ+OJPCmnuBLnYIpE129jI4UI2rI7KJ7JmnOnCC7mOzjgsM2gEAYjDgwbochTDyZe+mLYsrTihnEfSPmE8yqei9CMmYe1OrbIquZCCTj+b7Ms5WvUG5I8KMMIKGnxX6U0+KhLlIGApAMD1AtMSTzLyByMiIpNwI+xr2Dyw2Ix3HejmLhPS29tYiWc+E9518M4/lwJ/VE3MjhNpLvSMZ89uGHlHY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199015)(6916009)(82960400001)(38100700002)(478600001)(966005)(6486002)(66946007)(66556008)(4326008)(8676002)(66476007)(316002)(186003)(86362001)(3450700001)(6506007)(6512007)(6666004)(26005)(5660300002)(8936002)(2906002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?twTkOoudIbHv8JA/F2RlelwmwfCfeEAnZPbbhGuWMgd8dDuB1NgHvAES+zpm?=
 =?us-ascii?Q?az07LqiY14qwM9G+sJm/w7enSY2/aUQ2dNiYhmZYPO/3N9voKl9jSmJZgl++?=
 =?us-ascii?Q?C5Oeni+Bmw/gX1ZT33qTShBl4p4zqBs2eKek6msXqshnKY2wL5o9sFEC8aG7?=
 =?us-ascii?Q?FBJGSbz+ba6ZSdTGfb+w//qAnM8N19hiYTw+7dSfE0SCHZuEN4C3iB+MdEfh?=
 =?us-ascii?Q?UNp9FXj9L8Ta6VtUmjenyY/yGPdomH+QI7/OWZCK+7NFVShqDhbXdobToOwS?=
 =?us-ascii?Q?5qiNDB9Shwnpy0ZMVYlxlnubUCVOXqIc9dMw5vewxbe9q5pReKTq4MLSkzph?=
 =?us-ascii?Q?GJgb3ipRtgtIYuPfvG2OoXEOHAnj4Se22qfC67xlRnZB81FPpmgEcoZHSsIX?=
 =?us-ascii?Q?KZ9jjAnsg4uuc+CqFw6MSXybyAqVd9IXVaYzuABqXThn/v6sfXlM7oERW2if?=
 =?us-ascii?Q?ffZuz3BAIDojOZzth9cIOc/ijuGfz+GPCAg/rDD06tlcF5vxpDC1tTS18FX/?=
 =?us-ascii?Q?VdXuf9IYkYxFgR/z0olNRkRtNqr7NbbsTvvnNT93fCOMBep9L97iTteI0x7H?=
 =?us-ascii?Q?+dIhV6OjdCfduWgHCFfevv2JMe+/jS1xowqQSCWbRfTY2+nwZLlHKbExNfel?=
 =?us-ascii?Q?xChntT5/XRSL0oZX7cTTFSW5MGuj+irR3911mM+W9Q4pspjzyzMLuJjNhzE5?=
 =?us-ascii?Q?2XmupYaBn9sWJL/s3vbQTez4PqNTTBwMi50vN14ZP5Ac7g89HoT8E3kQzSxX?=
 =?us-ascii?Q?2MOlHvvscnydC2CQKUKpfzhTcVCMmPI3LKqS9m3y7z+tWro2FdsU/C7N7nHI?=
 =?us-ascii?Q?8cHFFlo9IGAHpHxfGYx29n+QeeJFnpmWRRUqrvApR8N162NKAgeT0oUtIa0s?=
 =?us-ascii?Q?p5u906iVwUvP0BELVWAijGUKmShLbb1DjlpTvKB84P3hCNUqBjC7+y5BdQd1?=
 =?us-ascii?Q?MLB/tyd3cdZpD6ISyb+1Py7Mm45ZnE3EhBH3/33+MezCBq6EmbRVQqVlVFXn?=
 =?us-ascii?Q?QGaJMFhXHhUN7TCxqgdZycqylRkMK3S5hd8KlYU5PV/HoMy4xtgsJV7b9Y6R?=
 =?us-ascii?Q?AMsL9ar5tSTUPLezNKpxK0o9gIpqA+oN3jLBKtJfelVbw06PB3K3N/3BqTcE?=
 =?us-ascii?Q?3o5W5wu1lDTd/NKrjySQoh/H9eDmeIqSowUtpaOlbQrt9wWQe22mgxVG3WZL?=
 =?us-ascii?Q?6cL5ibhiSZy6MGSxw4ogxh1qNB2PDHgDuZMDI/hOu5kNVRalPnNG56YsXMeB?=
 =?us-ascii?Q?3FsdSkEpyBxl9uhd7vGVKd3O8Hzlmb2pbSg4wOTx1Cp53JVezUUJvDYMhAuz?=
 =?us-ascii?Q?mWgMdPZwpvbCpPby8XPXgcwNf18M2fi5ylHC7368DvwujTXlQhuNurLxig8e?=
 =?us-ascii?Q?+bW+KSPK1LDHwau/30WN/t/j7W3xgPxiEROcJzKju5uv6kYdoJkA9sK8uKbT?=
 =?us-ascii?Q?OxGrqeQgZTfwjszpS5txGns9Hh6P4i/6g6RFHCnmcgUtetYsqcw8lMiSobxe?=
 =?us-ascii?Q?3RvrH3gQbZZQj2jHCGv2jmaqF7pyy4ij9/GQ/mX+fiut2YME8eFmoqwPUO0C?=
 =?us-ascii?Q?xgfCtbeRgcPzY3UJe+YbZf5sNoCka+8Bfah0NXhCBWkzq1LAJKcoJ5heNvFD?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d60985e-c171-423d-e636-08dac444c2a2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2022 00:28:02.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdBwfpC7g02ne5r66l5CZ0jI4JXpRO7jqSMYIkYpu3JfNB11qNi2CoZnuOfnKEmli+hrzRbrzVtIFtoSjhtfzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6809
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 05:07:35PM +0000, Sean Christopherson wrote:
> On Fri, Nov 11, 2022, Yan Zhao wrote:
> > KVMGT only cares about when a slot is indeed removed.
> > So switch to use track_remove_slot which is called when a slot is removed.
> 
> This should capture the original motivation, i.e. that the existing
> ->track_flush_slot() hook is theoretically flawed.  I think it also makes sense
> to call out that KVMGT undoubtedly does the wrong thing if a memslot is moved,
> but that (a) KVMGT has never supported moving memslots and (b) there's no sane
> use case for moving memslots that might be used by the guest for the GTT.
> 
> Bonus points if you can figure out a way to capture the restriction in the docs,
> e.g. somewhere in gpu/i915.rst?
> 
> Lastly, provide a link to the original discussion which provides even more context.
> 
> Link: https://lore.kernel.org/all/20221108084416.11447-1-yan.y.zhao@intel.com
>
Got it. I'll do it next time!

Thanks
Yan

> > Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
