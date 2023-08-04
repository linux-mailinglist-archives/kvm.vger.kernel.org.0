Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C70076FC08
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 10:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbjHDI3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 04:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbjHDI33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 04:29:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16224C3B;
        Fri,  4 Aug 2023 01:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691137746; x=1722673746;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kySSYa+8sym3s5e1oJhBU0HKvyZ8jJ23CCC1Jtpb47s=;
  b=HR5uY9vbJmbG4DWDALde7r9kZNVPOGjivMdI33MsbDJ0NVrAYua/NBfG
   KYEqeDMb3N3UU/0vy128Kd5A/pEkWtaMeY0l1OE50WNXxUKndeGebpaDJ
   p4nbdLQWAQQ223qzMBLatJJjLwQkLSvQYIezeyoXmJhomZNQM0S5cTvJe
   V9YqIb8PHlCXgpRS0wYtfgx9qt451josTb7sM9M6m5dJLfNnR+rh84zOz
   KsLMooKyZn099VeV5RUkhfDBsVE4I1zcR9MLgl5FR8o/v8nGz7GaZwbtX
   0yM+EYd3lspS1pTgQHrdRXhKEb6nh+MlIhmN1ZGrDcG/sYRD3DV+TB7Ub
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="456473357"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="456473357"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 01:29:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="853648889"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="853648889"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2023 01:29:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 01:29:05 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 01:29:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 01:29:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 01:29:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc7mdOqmhKTQR27ABJQnO9sGG2CJZIVZ/ZWGccmQIypLcZsGD/dFmo8goeG8i+mrTx/iMy05lQwLSMkZ29Y4Ph7fZWD0vrqlWKfJ2y0EbiTzqpJSnkqDdVe3a5ilzyWZjGj2lckFrKAe79xGsRph3vPaDch4aKk6LqMbe2a87caDpYoG+Tonqz0DNzxRO+0qpGAEKlrZUTZAiFDNtocbzBA9f0BP3MrHLLwI/Zeg1p1U9KwE+xGPLIkRCMoFqLnKyuCo0owyUb6ljx/gaWOYzZ2v0VsvKooATL+dvp+qJt6JYQp3wGqR2TKV4nOdSR6c49W9nM4xl26zQxoKYwYdjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nd+MOeTr29Pqdxwnd4S/Z5wl06Cy4vNRSMBsW20tmrU=;
 b=atn2Root4AAmhJv8cWQMibElXf4d9rHpyCSDNEfxjrSWrMWRNrPIxUKgIjOnhGeW68NArYMKDC8lZvgdsghlW6iV7yxy1by5nWU/T2tm9qIlWCidDpAJR+ndmp6x6562RqRQ6MC2WVyuiRqEbAluOOXIAGSbXtoTFkaeJKWpgWS0iUF5hCV+mL46/U6pRlSS+4ieScRHaualTXArRSKvVim7PypXHLZXb1z9s4VP/UCkhCPhD9fQN2ONvlbAuWbazBQQaTOTMv8m0N0uZs79WHE9734gSwfHOjpxe+lXZHgx3+zD1YEwGTj+/mk1tP5bzoTwvrEGjnIwVxf+IOKAlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ1PR11MB6225.namprd11.prod.outlook.com (2603:10b6:a03:45c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Fri, 4 Aug
 2023 08:29:02 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 08:29:02 +0000
Date:   Fri, 4 Aug 2023 16:28:52 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
Message-ID: <ZMy2xB/RizQElStJ@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-12-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230803042732.88515-12-weijiang.yang@intel.com>
X-ClientProxiedBy: SI1PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::10) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ1PR11MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a7423db-73f9-43fa-c875-08db94c4dbb1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: taN3xb8FxSVkBAtnuRjtrUPemt0hVOytNhA7GfCuxFWE1deYv5+5eI+WwQC9NyurhAtm1aRTe6NVpVsretEGdlgfkVdfub2/zR8zHqpv+o/5TuF3VaBDxTyw9HfXvW7M3Nl4joVl/ZqDgilnzaBAUdf0BXJPN1dhIqm3styz3ZOcIgITozO4Iakx1byd9ZZYY4gz0Nh1zn7F8S+IvgreZNPqPSHVCLZJ2yMebtwJATNNVXq2IhiT+5cGkyhu+Lx8W0m70wplFdmvzU86wqKB7QMKUa4asxm6JdoxEuEEJr6PUYxQLssTSM1JnM7azcTrKhMXnc8w8jGncllGge5cuxTgUl0bt3JLC8LjHXuZiiMj3W6aKGnOnFWKfq0VgxnksEL8ZuWKTYtYGUJyhruZ0EtVY/W86yrtw6zcnNeVF/VgnPakbzgJXkZUkW2MvYDtPZLL7C7kmTRQyXX5GStJoTR5o8MCEFfDrh0Msp1HY80CE2lVU1TWm0JcQq5aALgeN7bswpptUVYz+B3iBRr9wx99u6NVVK3zjQY7IYt64qofj7EFviVYfF1OnGGzGn9q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(366004)(376002)(39860400002)(346002)(1800799003)(186006)(451199021)(2906002)(83380400001)(44832011)(4744005)(86362001)(33716001)(82960400001)(38100700002)(41300700001)(6666004)(6486002)(6512007)(9686003)(316002)(66476007)(6636002)(4326008)(66946007)(66556008)(26005)(6506007)(5660300002)(478600001)(6862004)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EfN5yO07+Rn0fBwxH86bPxOkGDtsn7eywisdMvsaUke4wHWwGzNXtlmPowo2?=
 =?us-ascii?Q?z20UU8L/aCmcF8BkEn4S8QlnmUjQVWys3E3S1ElgLMLgJ9DRwi6YyoApDGbK?=
 =?us-ascii?Q?RI9+bB9QOQagSIgL1SQX22//xWcTaMRpa+MPZioFj10HD4Xi951pY4bBy70L?=
 =?us-ascii?Q?v6pPN3Uoye4fI+TEJvQ19Yw9DoPM34nCenOMocll7V+fNuacVDb0DFn1rym6?=
 =?us-ascii?Q?qDW4G8r92jd/3wZpT53sQ+GoK9oj8/ILJFISpdBiwHgo2FWZdJqWr+I+aISd?=
 =?us-ascii?Q?qUWygVnSl23Wfxp+xSEMAsUU7GrXobdSPBK7SJCgZliYGiFD8rJxdH6Eqw73?=
 =?us-ascii?Q?UYqzGg+FMKMeCKKQJVPogIS8NpYYgUDylsdhne9KvV4KcA8tKDVEfEZMXP05?=
 =?us-ascii?Q?MG6bElRhGZ4b1umFkJhx4Yif0W2/s8OtOiCBGZ45fJvZHX+a0QT6ob1AAC9z?=
 =?us-ascii?Q?OQf7RxkPYBobswjalcROtKzi3ioHe94qcd9JNVZaTgCAM+A7GYdMKDpWhbEN?=
 =?us-ascii?Q?0ZgC6gytQLGxqmBH08hrKhzDBzwzDPD8pIJUzhz6BWUIaOw4FbaLavjSSfhP?=
 =?us-ascii?Q?devLgoDl6JCn330WwT/7RYFbsyvQWyfED5v8e/KOi4qlb5jlp5Mwd/nrFIHF?=
 =?us-ascii?Q?RIBiwO4eo2r/3mY1PD0SUse/q/Anw2X1N/xjb/vBs1ANguJocFylFnQdTqOa?=
 =?us-ascii?Q?igdocgXnom2K7xThCvtNmQ1RP0AU15+M36HfuJMpD9nwUpTzTbfrcISjVfvh?=
 =?us-ascii?Q?Pv5x3Jmq1CMiGyqdIGoIvVL0HyjWMPZhxvHJUrL6Pz31v6SQJUbGxw3sw5gI?=
 =?us-ascii?Q?0G4k9zQ6v0W/stZ02yROT+k4uVhZQN16UpPMfsjEXVQJjbbvVxJxQHCaf28L?=
 =?us-ascii?Q?yu209rOJVZip4sgn5myTetsUKvJmTTZ8Vqs3brI3MyNreArzK5djz1vR3DqK?=
 =?us-ascii?Q?v6GjX/fj+iqLWN0SSZ35KW3HahmNqyLUf62K5aZtCqkG+2eyllnRV4Ozkxvq?=
 =?us-ascii?Q?a108QKTyFJFYICnykTP+8ZoAKX2icU0AVwrTKjDUyek+pOw8e3pINaSRmZim?=
 =?us-ascii?Q?kaUEk5vKqBObmvekzk9nCe/gTEL8Z+T6OKCzh3Ez7CVLxKM0MbqXep4w/pTX?=
 =?us-ascii?Q?aYazpd8XV0+x5ezDJHptBidc+M4tbH//+ouIKKC6/9E6H2JUII2OBi6cmWbQ?=
 =?us-ascii?Q?EzKFiog875nsRSrSaIdvnH8CCrYvqe8nBmK7T2cb4bnZeKiseZuyMfVdddvc?=
 =?us-ascii?Q?0QOVmlMPxsnWJzUzP4aos3/XmoHnoSQU2q+YgokZByVH8qxBNSokG0lyy3/X?=
 =?us-ascii?Q?Pnx/uZS/OoG5dcurZJEIUTQY3Uv4EVy9iVLYjfXGIZvXTDsQk/A+srWsGO+m?=
 =?us-ascii?Q?OBTJmoATKrjSzuc/vw5s7Sd3PNttYPdzWRqD0ukP1RMOQ8m4wsabJNAtokPP?=
 =?us-ascii?Q?lPvIqmVfzqiv1nq6npcJmKssCDz48Ms7v3kB/5AfNFNyt96qzDvlKRjpc7c3?=
 =?us-ascii?Q?YhGk1Xr0VoHIrRCDvgPF0cLGNZtxMOrLBP4WowPTvGui7jvZMaqaY4QPSWJJ?=
 =?us-ascii?Q?S6bQ6de3++IYCr2Uy3sR4b6Bjp/4Ns8XDxhAdA3u?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7423db-73f9-43fa-c875-08db94c4dbb1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 08:29:02.4384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2zonr+xSSmHVikISXnlKmp38TuXdXSrC2XnXkauiBJutSdBu8mvSkHUpN6grYo4YOVRniQiwCyitzZivKfrdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6225
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>+			return 1;
>+		if (is_noncanonical_address(data, vcpu))
>+			return 1;
>+		if (!IS_ALIGNED(data, 4))
>+			return 1;

Why should MSR_IA32_INT_SSP_TAB be 4-byte aligned? I don't see
this requirement in SDM.

IA32_INTERRUPT_SSP_TABLE_ADDR:

Linear address of a table of seven shadow
stack pointers that are selected in IA-32e
mode using the IST index (when not 0) from
the interrupt gate descriptor. (R/W)
This MSR is not present on processors that
do not support Intel 64 architecture. This
field cannot represent a non-canonical
address.
