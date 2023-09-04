Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BF379144E
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350861AbjIDJHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjIDJHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:07:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EE7139;
        Mon,  4 Sep 2023 02:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693818423; x=1725354423;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=mBaYR7QwAwB5f4qFgq4vv1+x+5UGMT28hgs2lZS4ZyU=;
  b=DDFTHQUJn54/xOyMjVQcZc0YIt2sifYcY4JGLRMNzZZL750MiwrRlfPi
   HZYXhUvW94PQcXXot/jY2d8y/Rmv9aN2JilCxIuT+437YNt5yRE0svjWk
   /GuBzuZBmxkwoR30T5rxJFgHfEZEto0WGxghtgfgSEa0clTv92PywvlVb
   LqlUuZhB33sC9QsPMo7ktqiG6BvVEPFmj4BNnkL59Nm+h/W9BYdSyfBku
   /SBN/2MZQa22eLQBXlBfyftYTW0LftheyH5gan6IgvjJiSPohprGKNEfh
   yWuil7jr8W2GP39ww6teS/uVcAR4HH089ua+TS6X9G3PEmESvKwPzINT1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="373942256"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="373942256"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 02:07:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="987429997"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="987429997"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 02:07:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 02:07:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 02:07:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 02:07:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 02:07:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Chm36b/YX2l+PpLCSGFlPM/f4nFUyST+pN1lRKzYRzsnFW68k0wdQIF9L1xbtrmDEibANkzvWzlkVjf6eWp2aPDTEwHLoOq/czLLeF/z7YEgJ+ctGLHVypplN2QoQsgb0bJwX6L9eyNkOVGkYyS/IULe5MFWc9IAUwnSVrw2e4aqG9+NH4u9hF3sCDBECfnsrmoFtTJKNGrNi+5k48vd25gUhcORa+pqF0KNgovoHGPQP8O43jqVjCvYCKBo0NPzekYbK0nXPVwmK7xgqbn4G6esHX3q+nZF9SS0OkREZgem6mISBLJqyuPZGi/1fVtocB52T+5gDfzYaat1f+n+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ipTG5ixM8/inXF+cMk6F65md/LZOzymD9ZEYfiaZSE=;
 b=d/BX+xzxhMNLqF9HFFIptfSoqJVUGZXpg9IemrOa0v1/ta2lj4eV1abwl9PvwlqLUQWhPlHOVVvJMKJzqPG5+D1nHdwVmPi3rU4OaIAS1lBD69+0VrXjPeg0WkwxRcdgk7DMZ3fYdaJn0tdXxZ/GQCTr2lgSkbEJNREHpE3pv3r817KN7r4bmOZgcqh/ms1XK5+ipmVWoIwRhSrhKaXgijlaD9JPprxesZgcQ9QXUuhzYMPjJR85RuH6f8wRfwToEi2lPwI5Cz/FDq6v3liQXOZ/wMYVEBqsPoqCjDBoO28WLyiPP6URJkZELlY6ZJVxsAsYgbDMadacjaZ2t+3Xjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8341.namprd11.prod.outlook.com (2603:10b6:610:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 4 Sep
 2023 09:06:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 09:06:59 +0000
Date:   Mon, 4 Sep 2023 16:39:23 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v4 11/12] KVM: x86/mmu: split a single gfn zap range when
 guest MTRRs are honored
Message-ID: <ZPWXu4RBjJgiYYjo@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065602.20805-1-yan.y.zhao@intel.com>
 <ZOk2HWEubJIRo1HN@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZOk2HWEubJIRo1HN@google.com>
X-ClientProxiedBy: SI2PR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:4:197::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8341:EE_
X-MS-Office365-Filtering-Correlation-Id: 9db4a8e9-100c-48be-a5f1-08dbad264b91
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gj3qhC6vJxV+cft8m2BQ8r+Pi+Sl0gFOsT73zGncds4naDhdLhGYmS7dK2I03TJQLfok0Or6/v0dc5p1wgT+u2Lsv2SV2NKrAit/knOb1e0pY0B1K6gCvwVL1Z587re6rzwVWQbSLIHUpWwFe39HrtDPhOXhugq7+Me+DCSmUEsDE7/1oASAV30/aCnOdFqyCAntyVu/Qanb8kjPp7X9KXueNvP8hSOiJ6TBaIFdC/PS3Bmt9L8dvcPKKf3ElyMwFgFo00vjB/9MuXRtH5A1e8GWYV3TD0nxwVfzh3Izy6nHECKaLuU/mr8oh6GsElIA8aIQOyjb/8daWajHBn7aCuwElI07UcP4EYzLT2QBwceRXkxXFH3SF+bOoi0GYFHBOni2gHmmiVwlIlSimKvSqASV49wnwEWl700glEvzc2unrFrvcULl4zeWjd15eHsXX66SGB4xVK6xQXoBJux7O63M3lPkySvq5PKB7086abGXZan7dPAeREaV+GHw0CZTF9VIi9ukjd0uB2KJg0REAa51ANwCd39x4Ml3A8G2SuvZUYSzaPWzJBwGaVg+4kx6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(136003)(376002)(366004)(186009)(1800799009)(451199024)(41300700001)(478600001)(38100700002)(6666004)(82960400001)(86362001)(83380400001)(26005)(6512007)(6486002)(6506007)(3450700001)(66946007)(2906002)(316002)(6916009)(66476007)(66556008)(4744005)(8936002)(5660300002)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hDDv5F1mN/4C/IK4GKxJ08CBjbfM1v8/v8jJJpTHwiL+vZu59g+B3XoVS6C5?=
 =?us-ascii?Q?tyC/lnGTZD7hOsPj0gH/RW/BQ7W06T3dDiV4jrBLAepDb6ZwkHNB4IEGlROs?=
 =?us-ascii?Q?9nDDu51HbCy8me0SV3GjnI6liDpDq3okqQwr31SOsn/gumWSZyOMVK0ZLQ8Z?=
 =?us-ascii?Q?WefPtXIX1glwmpVA9YtQhh6gIiwvH0Nu8oOhRsbtJVv4mlWJot/ci2/YR8Yu?=
 =?us-ascii?Q?qwaihVXZgdZXEIkZp+dLtlcuh3/3IhwaS1o1WhMm/rfVXngQxHRVTD9viL2k?=
 =?us-ascii?Q?dwgwwZpqN8GDK9ePG5ZwE0ZBx36JcxJghCHeyNwpaJmZb9uv3EKYulyuhbZ7?=
 =?us-ascii?Q?rqCT4k00LJEyem7yJwAqvCG8B7LHOX/q/vnvT2xDN/UrpzRhZBaiFVPHRxsk?=
 =?us-ascii?Q?m0xlXxKh8QhCHw6LFWd+zioXq1HG9i+fSsq5UYXlwgZcTkDkTugLjU7/fZ6i?=
 =?us-ascii?Q?WVxUYfc1viGg8gnE1X9PGkRbqlmguWJAXCc+Cp/GdDyH4DvQr03CsrO2Ow6e?=
 =?us-ascii?Q?IT273AG8kMLUvQwfEX45Q3bKcLG3kOjZA5yiEhH5buSgiRvg6kY7DFPaHQ2f?=
 =?us-ascii?Q?S32vwBBBf+wyUo5ddXkNjKEk+z0MOLE32ev7UXFOIvf7RhcT8FK+u2oMcABJ?=
 =?us-ascii?Q?jEbtQQ19cFfE/kJjLL0fCIivLWAGng5xF5GsZplg6ByQlhBSp0Y0RIvixzyt?=
 =?us-ascii?Q?4YP84bcpcrcX4fTYa586K7lATuxQTAIUelMPsiLheXtrzLKUnDRy2sJuUuek?=
 =?us-ascii?Q?xuc+UzoUA9T7byWD95cWTz2guMNB1nQROcsyR3SN5uHG6fds1uX01eyYSjZP?=
 =?us-ascii?Q?9I+aIdtEUR5/xZcR0iS93zH/y1symDwix2QwUEhgd6siWDutVa68Ru2mxY5s?=
 =?us-ascii?Q?AWUQA33mXrzVqHtXlFJ4ZjJa9ohIcY/G9HhjyNNVn7F0dbHBpYDRRCEMe/mM?=
 =?us-ascii?Q?x7rdr+6gwoQPnqLxainq75UHqSvgtEipprjprOnosYDocBxQri/vzS1HjmMD?=
 =?us-ascii?Q?gomca86nyEkx4gKE9gQdIevYwjT3IvaK/OgciQHjOPXmTqfuyVRhhyQEjGw/?=
 =?us-ascii?Q?PRNbc67HwTCApIuUBLYd4ic+NM/e6v2BOn3wRkbjDiZLJHbIEW5bfMNsfhSP?=
 =?us-ascii?Q?GkMaC5geCMvJsVSBOb11eB2O1hvwYaTGe3fnnuhVO8H7RdFiskjdowm4wKNJ?=
 =?us-ascii?Q?Snce8Imp/oYl/ZMiZ2RA6R63x2JN6WY4frxDSBdPHJEh+aShUNp3g+IUUzfC?=
 =?us-ascii?Q?Pa4mDSTQNU4p9sdPmZNXvjofbs7Cmq6v07flnyAge/B4+BFkqFgUO8kcCYv4?=
 =?us-ascii?Q?mrEns8eiYm6bOG1QuQX41dp8x7MVwFNjt/Q8YwHyCJOAwld/QDrJrCZQS6p6?=
 =?us-ascii?Q?qpw4XfJttj54r7hKVmWOQkA0/BI7NAj9ldigj7Ubc5II5kFjRp8CHEDWdOFP?=
 =?us-ascii?Q?eCvNO+4Cn2xAN1Z5gPFbRh/3skOVHAPa3sRBVA7lcIPFcZeVRiklZGLdoXuN?=
 =?us-ascii?Q?EO3knGPiG9XUze75p+KJv9AqcVXkx/lMa0Mb7hDtD5d3bZJXNfuYPiExnVTB?=
 =?us-ascii?Q?/ExRHexM4HQ6PzbXBxx2UjHpvhL/dTUiejPNUgBz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db4a8e9-100c-48be-a5f1-08dbad264b91
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:06:59.2706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QiUGM5w37XukTzohkCGegW6BnlGgDDLp8QzsGz0rHDAnQdA+68il5fyhlhNheJp5zWPklOBjLhz9OD3YdZv3Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8341
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 04:15:41PM -0700, Sean Christopherson wrote:
> On Fri, Jul 14, 2023, Yan Zhao wrote:
> > Split a single gfn zap range (specifially range [0, ~0UL)) to smaller
> > ranges according to current memslot layout when guest MTRRs are honored.
> > 
> > Though vCPUs have been serialized to perform kvm_zap_gfn_range() for MTRRs
> > updates and CR0.CD toggles, contention caused rescheduling cost is still
> > huge when there're concurrent page fault holding mmu_lock for read.
> 
> Unless the pre-check doesn't work for some reason, I definitely want to avoid
> this patch.  This is a lot of complexity that, IIUC, is just working around a
> problem elsewhere in KVM.
>
I think so too.
