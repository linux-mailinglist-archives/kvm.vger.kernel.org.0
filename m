Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A116F5B2D89
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 06:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiIIEey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 00:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIIEew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 00:34:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C8022BD9;
        Thu,  8 Sep 2022 21:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662698091; x=1694234091;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zBnc/k4nE1/PLqgoFgeRhqVrHK6C1ykarRVv1Ji0opE=;
  b=AuNkNGf1PPjNWlzggpSHgN0+TiVjdPSe6APYqgHmh7DmWt/ZHCOwTKmi
   kuW6FCcLAZLWbKD/CC90quK8YJQh9mIp++/A239wAsp9AOm/LMXMpZ+9S
   uPyb5wqXjFeMjJRM9xNnFC4P0ij0L/+wl/T6qc80zig8zbHYq01dHkBUq
   D5eqQ1M0GNjcA0ryOGgxYSvdZZKQwdIBhAJ5ow0EqoXw24moBUQ1URSG/
   sTnt7D0d0udz4BT6/IHQgr5MSDzRX4hRhIeSdXeKMoMISD+WysdEfCrPF
   9FTAH1Okn6+hs7aZPuZogELGYMVjOXihCWGSQ1wx8YeRnaMcvC7NLOr9X
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="383689082"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="383689082"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 21:34:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="566234156"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 08 Sep 2022 21:34:50 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 21:34:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 21:34:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 21:34:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 21:34:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STpBpOhGOH1hDBDneJbAR/R/JqsGOuUoUtVBY87Qmo3bmX4GQKpFJ1lFQDDD1kOnnPyP9DQmtI61ls2anjqTm8i62FsvdrDIECDUZHTWQsBbFHvwmI3UrIpQEbRJVXUNp6IFRXd9hXIr2rL4hpZfwC2JDAe5td535Hc2eYnMOpsUkUU1bY5sBsqOB8gC4UPRHmd62GQqzwQQavTR9S/hnZrv9yINw5+GohHZUUZzo34HqDbaHJjhcdOwn997hnl31KmrHVr7Nvnvz7R3/3zKkr5yILr8P9I1ogl4lT2UgdtgwuH1BjbfGgaorXxcjOoUiFKFpzNdKP7vxbAdaiy2Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N00luERWnEQllrVoZRkdyKgfLjg0rpL+0tRNtulXt7I=;
 b=Mq6PIvWaBxb4W+uMjFM3V82h/8T+HxAT0Rbi6nOyijb0tSWtCCSingtoR6tnOLmJt1y9oZvby0ZQwPH3sqU3BRcAQ9nE9VA9ORDKZzYxeAyMvbqeZkAa994OkaaAFYzGpVhK7lF0UeROCf88+sE2X2p+ji81q9z/DcjXdCrbB+fzgvfMzNf+JVY95sG47JrgALYJOU24xJR5eQV9YxRxpdcQ2N8YCMv0sTOa85ysr4Ux9wuZFTH+Ryy+ZkYgjxPU43V62fdGcVpI+/uvy+VIdBv/E1RH48JnC34dsRfRsu1meTiGQEK9qcF9ejkXCfc7T1TtHlnwOhJ6+S0gHd6BHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by CH3PR11MB7275.namprd11.prod.outlook.com
 (2603:10b6:610:14c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 04:34:46 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 04:34:45 +0000
Date:   Fri, 9 Sep 2022 12:34:39 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        <isaku.yamahata@gmail.com>, Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Huang Ying" <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 11/26] KVM: Add arch hooks for PM events with empty
 stub
Message-ID: <YxrCX2nhOyWbbGGY@gao-cwp>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <fa7ecd7305d011940121466f094a544c6de39ea3.1662679124.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fa7ecd7305d011940121466f094a544c6de39ea3.1662679124.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0117.apcprd02.prod.outlook.com
 (2603:1096:4:92::33) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|CH3PR11MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: d9eeb790-4ce9-4b6b-afdb-08da921c9f37
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJnNYiVrfjWOdzX/5p3JWrbUybH6BViTQDG6iNDEOSe6sB419GChFy9GYXqUaglXua2Wxqw+GndF5v6vYny/PfoyFhVcMH7JRhEiV5nm3ugmxU8Gsonfk8PJxRI4k5dsANupnQjLV6wSOE52tQEYOx3ynAsjEf6Eb4/7kF8LT6eOBnSXCDIGoQWij4D8rk+Jsp7kvPWWlZNf1xYfy3IndHIowM32rYlUw2buUb4751CN1fqaJPmAk0GXwVwWGyCWkbb8hIHMWzN0ZoyBLezb29kzfm8DU4cfsVaNLArIo/CNj43TwITOPhul2qY9bbcXRAYYlrrXWCoaJNAFt/7MMWqqekIee7RQ1zXvGU4Ua0zmUKAve5A0b87+ucjMoQpmjktPfSK3k70R4JP2PdBLZsWguaOJ17DUGb3jU7yubDPZmHgJZt+Tbqj0TCFVUap8Y2xB4PgEV7bNIPTnuudtlfE2bdFAwY3Vvc+42kuzbYK3A35jiF3CFmAjrN0RyhgJeMkyWSo4DnYsTwuyTAJ61JMPp7IRXFzeNeCvwiMAfbBW/2iBWWg90jJ7F2WbeyNbbsXafm6C62RAuiK/ckGTJ8Tlz8SdUqaaWabZ60gZqF5dc1gl/rxtQ5EVo18C01HguHmMJF0nWMuDaqk/38q4eGibigyqEb9be6xh3awbHbyvc55tViHLFR0KHLqfIss26HrJKa5Qseb34TnV9WqbJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(136003)(396003)(376002)(366004)(346002)(82960400001)(38100700002)(316002)(54906003)(6636002)(6666004)(4326008)(66946007)(8676002)(44832011)(2906002)(66476007)(7416002)(66556008)(8936002)(5660300002)(83380400001)(41300700001)(186003)(6486002)(478600001)(6512007)(34206002)(26005)(86362001)(33716001)(9686003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RXEXGqghSObpro3DSBGSjRv8bJqeQjZ5wnQzIfPtMqtjIhr9L1lqZikVsG2B?=
 =?us-ascii?Q?odpA3HgP0FznSZL6r8p93qRx0b7gPYr4vge7V1F5Jb9Ymw8NYCmQvYDvV7bs?=
 =?us-ascii?Q?EBOGw/fVjhz2CydExcrLgQfwMEO6Gp/t0Xox7u0n5fOdEpJrgnoRD2XUXIw1?=
 =?us-ascii?Q?BELJ36v/gOlOoWTj0FscqL4A/tIQIppDuDgidC1zO6LvelAZyn38XQz5qyq5?=
 =?us-ascii?Q?osDFA0aCWFLScmZPeOsGbPdeiYib33SAhrVz8QhlP11cuzUG+9wl/BUrsvsr?=
 =?us-ascii?Q?8H2CdpiX0gDEMxa7A5nnA0lQ8NQzjbl/WJ/+1Kl9fS2ezQZyFPQGAzkCX4Nx?=
 =?us-ascii?Q?LloGkLJ2pdKETMDCzYT5BjEJ6dwhefv6z4Y/I8mJ6XzxKqs0Rv3k3ElNRSK/?=
 =?us-ascii?Q?vjuBG2SZSaJkhsKDpDTrx7CVNwYUfdVjxTqBWUUdu86Xf5WoFCOmdUPVqnsD?=
 =?us-ascii?Q?DYkqyN/AKL6DZDIt7e4IwqpID8z2iKuJaioPkGePKR9CZhSJtsN8NhbI8mnq?=
 =?us-ascii?Q?wChUaiTSrCLZX+qNBCY8hcetQFSUEdKRhlnfZCdff6Nmjsf4JxoVaCFwAN3U?=
 =?us-ascii?Q?KjsenLLtisr9tLXJPFVIAOWiV0T6CTAHy6NmBcHCPrbOSdDboKn4uV/lA/3b?=
 =?us-ascii?Q?hNK3hISW8b/CKI32sKUPFuPqkZ/WTYe4g+LzEDUBus6yJVwvKJTkf3F5xecP?=
 =?us-ascii?Q?wasLAGhrVfYXHgpLPvct/llP1o0K1t5ZKsxLvbhcz/5Yr9uM6FZraSNWFbGw?=
 =?us-ascii?Q?lON5zRSJ6Nrowd0hYdk2W053HqYsaJ94JrU+gsk6AkopPsjkU88Y9Kb7FCZc?=
 =?us-ascii?Q?AV9ty0GjFsHyOO3dWPleefpY2/UkyENM4an7vHLo6HFuymb0pJPztrEybSh1?=
 =?us-ascii?Q?ZOahXKapw3+3uDEi1GHFssbNnwAOZtudAiufx0M2Ltrc/mI3BnE8/Llgm4fz?=
 =?us-ascii?Q?3J/jwwa5MaINUWMaiHzf2pa40pa3pz2yPTkQU1QXvZl65XZb4S3nj40MW16a?=
 =?us-ascii?Q?LtU/BYpF2naRZYjr3QhatiyUXWiacYcDNFTv1HZSKlfmoPpJlizobD7IzlpN?=
 =?us-ascii?Q?r+i1GFS6XwqJSjsZmircLMuSaTiH9dp83B+gW2ZyKF1Qf2LkdQbSKwG5RCgb?=
 =?us-ascii?Q?f91Rsahp/p4QpIk3e15rUDDZ8WypLMLByvBzNYG4wExW44GPuuEOl6oNLUaA?=
 =?us-ascii?Q?eMHCEDVGUDOgICF3w5m2p5sA4ITgbAGI+wYXUi01dAUxAmZi22AeN3seGkHI?=
 =?us-ascii?Q?WTqbv8Lk0yWT4og6rc1vpdMojqo3cGd+ODE53MGOqPNLxFwrmd15gG9xZkTX?=
 =?us-ascii?Q?ITQWQ4jeqolaRw1GkzI8C0N0gg9IITduZHk4TZGvKBCYuHWw+3uGZq/58UIf?=
 =?us-ascii?Q?PiVkZfdpAN7q9iYkiugQ2ROHr2SBxRomPHLD10a2MwiShm79M+XYmtxcZroc?=
 =?us-ascii?Q?tfSoV8q2s1K4FzVuFZEViTtvwaBYPxUDXo6hJQyaLWLgu4KlliOuohfh2zCt?=
 =?us-ascii?Q?M6sNeiQ4g7J0sq/ypus4+YM3AQ0pe/f2oKHh9fH5vATvYDg7Dbgg+AFEfkrN?=
 =?us-ascii?Q?GvxXnLrWuwPTj9eEA6kZpVPKnD5sOM6ub51ML671?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9eeb790-4ce9-4b6b-afdb-08da921c9f37
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 04:34:45.6031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JNdmYRukJLndz/qcZL8ziPk3oMITSWrHPXEfoDfp3hSzzsHeDMz7ul4q3jncmU91TJ/Fd5KsRpmHpPpakx5v/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7275
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 04:25:27PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Add arch hooks for reboot, suspend, resume, and CPU-online/offline events
>with empty stub functions.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
> include/linux/kvm_host.h |  6 +++++
> virt/kvm/Makefile.kvm    |  2 +-
> virt/kvm/kvm_arch.c      | 44 ++++++++++++++++++++++++++++++
> virt/kvm/kvm_main.c      | 58 +++++++++++++++++++++++++---------------
> 4 files changed, 88 insertions(+), 22 deletions(-)
> create mode 100644 virt/kvm/kvm_arch.c
>
>diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>index eab352902de7..dd2a6d98d4de 100644
>--- a/include/linux/kvm_host.h
>+++ b/include/linux/kvm_host.h
>@@ -1448,6 +1448,12 @@ int kvm_arch_post_init_vm(struct kvm *kvm);
> void kvm_arch_pre_destroy_vm(struct kvm *kvm);
> int kvm_arch_create_vm_debugfs(struct kvm *kvm);
> 
>+int kvm_arch_suspend(int usage_count);
>+void kvm_arch_resume(int usage_count);
>+int kvm_arch_reboot(int val);
>+int kvm_arch_online_cpu(unsigned int cpu, int usage_count);
>+int kvm_arch_offline_cpu(unsigned int cpu, int usage_count);

Why not extract each of them with one separate patch?

>+
> #ifndef __KVM_HAVE_ARCH_VM_ALLOC
> /*
>  * All architectures that want to use vzalloc currently also
>diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
>index 2c27d5d0c367..c4210acabd35 100644
>--- a/virt/kvm/Makefile.kvm
>+++ b/virt/kvm/Makefile.kvm
>@@ -5,7 +5,7 @@
> 
> KVM ?= ../../../virt/kvm
> 
>-kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
>+kvm-y := $(KVM)/kvm_main.o $(KVM)/kvm_arch.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
> kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
> kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
>diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
>new file mode 100644
>index 000000000000..4748a76bcb03
>--- /dev/null
>+++ b/virt/kvm/kvm_arch.c
>@@ -0,0 +1,44 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/*
>+ * kvm_arch.c: kvm default arch hooks for hardware enabling/disabling
>+ * Copyright (c) 2022 Intel Corporation.
>+ *
>+ * Author:
>+ *   Isaku Yamahata <isaku.yamahata@intel.com>
>+ *                  <isaku.yamahata@gmail.com>
>+ */
>+
>+#include <linux/kvm_host.h>
>+
>+/*
>+ * Called after the VM is otherwise initialized, but just before adding it to
>+ * the vm_list.
>+ */
>+__weak int kvm_arch_post_init_vm(struct kvm *kvm)
>+{
>+	return 0;
>+}

use "int __weak" to comply with kernel's convension.

> 
> static int kvm_offline_cpu(unsigned int cpu)
> {
>+	int ret = 0;
>+
> 	mutex_lock(&kvm_lock);
> 	if (kvm_usage_count) {
> 		/*
>@@ -5069,10 +5067,15 @@ static int kvm_offline_cpu(unsigned int cpu)
> 		 */
> 		preempt_disable();
> 		hardware_disable_nolock(NULL);
>+		ret = kvm_arch_offline_cpu(cpu, kvm_usage_count);
>+		if (ret) {
>+			(void)hardware_enable_nolock(NULL);
>+			atomic_set(&hardware_enable_failed, 0);

The error-handling code ignores hardware enabling failure which looks
weird to me. If you extract kvm_arch_offline_cpu() directly like what
you do in patch 14 (rather than add a stub function first and then move
some code to the stub function), the error-handling code isn't needed.
