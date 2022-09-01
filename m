Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEA15A8E36
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 08:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiIAGS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 02:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiIAGS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 02:18:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE92CAE210;
        Wed, 31 Aug 2022 23:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662013105; x=1693549105;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jJiFRD4eSMhx2SQcDd2ppp7luH3smUSROyAX0bYvwdo=;
  b=kj0CqzrNZrJ9pJXJzVtoIbI7EIzj4dld/zFK0PC960dzqaK2YsEDscW5
   M7z9Wrwi9oJ+MTx9ulJZ+SEh3O8oKPxhXUBPn/O1ucC9N3CarSIDPvQSI
   TdeTV09V3r+XGsN3VPvcjFl3opf8lDSsIe4jUHK4ezYlmrVJh2Y6rX664
   Fq/bWIpcMU8NTOVoX7i3jCStF7V1cscoumuEWsI4ExXKdEhCt/PkQqUZF
   2Tx1qAwM+Von0B/if1b0sZy8kB4zJywXBl+BdWoka+HuGhrecFjHUVEbD
   smbf5tX7YWZEhaAXFEs+WaxJiEssOOTI+hw+QK7vikT0vEWpnbkYLxSqn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321772557"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="321772557"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 23:18:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="563322191"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 31 Aug 2022 23:18:23 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 23:18:22 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 23:18:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 23:18:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 23:18:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPRq4xbWSPgGQ4qGJZ8CwZqxs67y+7uNtHLNa+e7ynBHYc0EcGqFKjcWwFjyDrjEr+oi6krQNuPjZyd99qcmFl4NAiOy4Py+JMYJcQFuGEYuSs7/hOiMZ4Gm0lkpcjE+nsYvCiqAm7fps3tepNMb4bNal3HLmCYHamOj+Mo6db8K7SNMXhW6hHrcvX3gebBop10Aj/m7mrC1Pf9jz8/Uh9UAMRSoF0WEbah366HPBvCiOGY0hbnqPQbqVxQXpfXnefuRcWO+CDpHKy1ShShbe8NtHn8N9ifEGQX123s/rau7zzhFgYz4YBVJ1U0r2vRGVIR3CmeBH+904J2GLwkTJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRs+CgbdlrMr2zGvUWOG+U2lYzYumvNkUBoG9xoHmtk=;
 b=ChVaZY1TlHsZh72k0xuB+/QS5d+h0LK3ZCcCUpAB3gekOlPHeowMZ8BFlsxysLqN7g3TAkun+aq80RIqsXPvsv9nCRmX92OwT63bp9ytDh+cYzGdT7FSOCPyNotvEG9m5XtYHSO7IWD+HOtL0D30zZQnBrwj1uPjsEJIqdMuOwrhM1UJQvdMtlAQZt+0ybHLJ7X+Y268qqst8hNtr3kHLGkQzx/wddGosjuNTCd1Z9E2ESIuwpWDOaiWB3Z8oo6jAyexAuXj1/faqdNbkXmwIAUV7BCzqqVzgIwXB2zkS/LtNF2DEp408YoPN7JjAc5TylbDUWSQj1TUwSr9orsI3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by SA2PR11MB5066.namprd11.prod.outlook.com
 (2603:10b6:806:110::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Thu, 1 Sep
 2022 06:18:15 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 06:18:14 +0000
Date:   Thu, 1 Sep 2022 14:18:09 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>,
        "Will Deacon" <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 05/19] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <YxBOoWckyP1wvzMZ@gao-cwp>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
 <d2c8815a56be1712e189ddcbea16c8b6cbc53e4a.1661860550.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d2c8815a56be1712e189ddcbea16c8b6cbc53e4a.1661860550.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR04CA0167.apcprd04.prod.outlook.com (2603:1096:4::29)
 To MWHPR1101MB2221.namprd11.prod.outlook.com (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e60ecb29-23b7-40d0-7441-08da8be1c0b2
X-MS-TrafficTypeDiagnostic: SA2PR11MB5066:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sEe/Lv2yA38iFimxOl2EAcGkRknlHxCGULgsfyKeRFxFLpZd8WQ1yuBolge/0LUHSRU9mnaPTD6aWzaseV9WZrGm+YkK8Dqg/wwXkUOkMHLW01esjmZpUm17TKF1yCWYypZfooTsMUUZ52VZ8mTgd82UzFeMVckDs/Twp32/jgiQPdC86BnIsCRrjgHZlWZgXWwuOmdcowCK7xM+oQmYEVlUZbnQGGk59rEShTGHinkKrJfDRIH+1Na+kdUUqAv6JcusF+Cw3Mk3QEFuztL3RdAZkjpjSYT7AhczugScib++P/Jer2Z2VXUpsXp5W15RhaxEyEEiLQ6DCIe3s4o5/PWG/CzY1Y7yNBhz6CtnMNU23Co1xRrsPifJtjuRA3pyEjxChE4GhCJTeFT5szSfPYc603sDpd59Ayr/lEyC9k2Juiv8+d1JEppNOYSWEGXPuu9Hs7xvQPW7C6qBdiU/9dTPAzrJGHI0pzE3veUdHNLQvx5A8O/whGLfpKtwr6jGIqycaRmSAIStLoM3nq36OPbh+8qFwqqL/XdZXe7PcMkFNZzis3QGvQW40+Vsoc6keij8gE9pEY9xO7eUzTUOYth16JTl/0hIab6iK8OJJKGeP33rPtGec9SnLkDQwti1xiqUgy5NFNkdnabWijdqyfq6m6YFAd04KqHyDfyuJxpdHqosnmWN4uh33Gu/Etyen+eWAlVFdjZflaVsA8wXPryt2wYh34ssOOIMBifB//O/KtMjxGH8RDZORiXai1Ax17UklonGYJw2SP3cUVosrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(396003)(346002)(39860400002)(366004)(136003)(83380400001)(38100700002)(66556008)(966005)(316002)(66476007)(4326008)(8676002)(66946007)(478600001)(54906003)(82960400001)(6486002)(6636002)(34206002)(6666004)(8936002)(5660300002)(41300700001)(44832011)(86362001)(186003)(33716001)(26005)(6506007)(2906002)(6512007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7tS0HKEILF7dmnaiQ4A+ziE04ChiTuZWvZ8FO+4U0sMEn6T3kWRjohFi05ST?=
 =?us-ascii?Q?XtcWHUX1anrL0hGb+ADsvYQzrH2UHwZqzG6vmR6ng1cq2aaLzY4vJcWPaMCi?=
 =?us-ascii?Q?i13/rLki9AriaVQLkvOo2RZ+t+JC9iBQ73cE7DOKyy55zqswoS9ehLWkCqdu?=
 =?us-ascii?Q?5OmG9Nhj/YvKx96g0+FUt05HdR5OO5LGqYmFWOmVmwyEQhylZ21jTSqpuzVb?=
 =?us-ascii?Q?dP2FcioPhhcRA4Dw/ds2Kb5gdCXHXbRzxBwY9s7YuQ5Ts/hjKpd8V62y23rc?=
 =?us-ascii?Q?sYHO7symOnC6BFgl1Xq+RqH1/a3Fzkw5SbW5i4M/bBVPRmTv4b55CkM9c00w?=
 =?us-ascii?Q?FM5oRMhzpkEVVPBcWVEM1FfEMu1cT6AXVjrjQTBKm4f4KVLJjo0HuLh0vSIV?=
 =?us-ascii?Q?VyeD4kpfgoVxB/Qi5Y76QfnJd6GcU3i6I9GqYVHA9ddrbOm9n8RGZgxQVwwU?=
 =?us-ascii?Q?1DJHPbQju6P32SnPFgs4ZxDjP2S2lHwrDTS9Oy3CHy6tvP3ZcZVb8i7s1jKz?=
 =?us-ascii?Q?/ydLGJ5O+XOYNtSL+CKm/oaelQuktz7FviVSFy3am/1HqgjNOf1jyTG1FPP1?=
 =?us-ascii?Q?UWdScJXcSVr12olOOUk/TzJu3Kpc2ypnHvzphDqLp5aLpJfA7pL/F3h1KhRg?=
 =?us-ascii?Q?qryibBhg/dHqT7Z/R4p8fEbQfQJaRDN+JHGOqgcS28v5dQQOvGB7mh2Tv1rk?=
 =?us-ascii?Q?Bm9ti+353RcSqRXTIGnywNGBmvzRguiUqg0xTGobN0HfLownLsMm5Sgj0Hhe?=
 =?us-ascii?Q?EuBdl85DVKdWmgWumStPzeO3L4jmNKxRbNzF32OHf2cxQGkyjVXUfmBAsRLp?=
 =?us-ascii?Q?5b3CRdgsPEfQ1MMEOPOe7vQ7OJcotLV8Pb/ZPQmNH6WuVMBAfEUYBX8zLEvI?=
 =?us-ascii?Q?YKMp5/X/1OHqfamfsPzl5GEwrttiO7skgRj81WBSwV7sOS65R2G3UemDGr55?=
 =?us-ascii?Q?DTucnBdRly7N7YZPUmFx+cgDvVm93gxm4ksYybf/M9JWYb2vMkDFTWZB8bOo?=
 =?us-ascii?Q?2CGp1Wowgi/SYSlXDuOOLO1OvRiveu9UoHblzOtEK7U3FN3nfqcyJI6eWqyp?=
 =?us-ascii?Q?wU90jAhWu16rMO3WghLTtCs6CKZG7h8dvLphaumsjbOILI7Y7bcpzY1md382?=
 =?us-ascii?Q?eEfNVC81rdPDQMblmOvuHAr+iOCk7c5z0e69pS6nbPcpb4++84WLSBmhEIfx?=
 =?us-ascii?Q?xtt/Jq0mH4alTwdjkV3qucjDVE16Ur5Udpvs0d5m86dvdb0MlaSKWOCC40G1?=
 =?us-ascii?Q?eNcb/cjTlx6wrHpF0E+Mhgc90Ao2mTGRjSC4TigBKTM3cr0Ryt4ifrDVU+rq?=
 =?us-ascii?Q?wGmN5AXgHzdK0kQmWWtglgYK1z2RlxkQv1L4TzOeW3uaDaPfgJa9brYu9UCl?=
 =?us-ascii?Q?gEE0GbhvvJRToJvgsXh9Ia7oEychV3FeSXh+7CkYso8JyBxYRWXcUECgHfCv?=
 =?us-ascii?Q?/0XYh7p2aC+LWNAGuANZXUDAieeCmKx4cai3ARYrOavjcbor4umzRh0nRxAp?=
 =?us-ascii?Q?gCBOUT+SQjExwsSqrS0Yqv1o5DSKNBXEozNRVUc9ZpXQjIjo3ueGh2Ynfeai?=
 =?us-ascii?Q?8r1Tqn8Qwo7BUAE2WZwE4mQw4XXXD5XR18XyC0Ed?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e60ecb29-23b7-40d0-7441-08da8be1c0b2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 06:18:14.4731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBr/UVMBdT+U3tGXweyyQ6zA70BHaRjhj2CZyvdd4hO5r/uvhCAdcpQIcTwDnYkFAn3rqHXlWxlxd1kN7vj7ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5066
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 05:01:20AM -0700, isaku.yamahata@intel.com wrote:
>From: Chao Gao <chao.gao@intel.com>
>
>The CPU STARTING section doesn't allow callbacks to fail. Move KVM's
>hotplug callback to ONLINE section so that it can abort onlining a CPU in
>certain cases to avoid potentially breaking VMs running on existing CPUs.
>For example, when kvm fails to enable hardware virtualization on the
>hotplugged CPU.
>
>Place KVM's hotplug state before CPUHP_AP_SCHED_WAIT_EMPTY as it ensures
>when offlining a CPU, all user tasks and non-pinned kernel tasks have left
>the CPU, i.e. there cannot be a vCPU task around. So, it is safe for KVM's
>CPU offline callback to disable hardware virtualization at that point.
>Likewise, KVM's online callback can enable hardware virtualization before
>any vCPU task gets a chance to run on hotplugged CPUs.
>
>KVM's CPU hotplug callbacks are renamed as well.
>
>Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>Signed-off-by: Chao Gao <chao.gao@intel.com>

Isaku, your signed-off-by is missing.

>Link: https://lore.kernel.org/r/20220216031528.92558-6-chao.gao@intel.com
>---
> include/linux/cpuhotplug.h |  2 +-
> virt/kvm/kvm_main.c        | 30 ++++++++++++++++++++++--------
> 2 files changed, 23 insertions(+), 9 deletions(-)
>
>diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
>index f61447913db9..7972bd63e0cb 100644
>--- a/include/linux/cpuhotplug.h
>+++ b/include/linux/cpuhotplug.h
>@@ -185,7 +185,6 @@ enum cpuhp_state {
> 	CPUHP_AP_CSKY_TIMER_STARTING,
> 	CPUHP_AP_TI_GP_TIMER_STARTING,
> 	CPUHP_AP_HYPERV_TIMER_STARTING,
>-	CPUHP_AP_KVM_STARTING,
> 	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
> 	CPUHP_AP_KVM_ARM_VGIC_STARTING,
> 	CPUHP_AP_KVM_ARM_TIMER_STARTING,

The movement of CPUHP_AP_KVM_STARTING changes the ordering between
CPUHP_AP_KVM_STARTING and CPUHP_AP_KVM_ARM_* above [1]. We need
the patch [2] from Marc to avoid breaking ARM.

[1] https://lore.kernel.org/lkml/87sfsq4xy8.wl-maz@kernel.org/
[2] https://lore.kernel.org/lkml/20220216031528.92558-5-chao.gao@intel.com/
