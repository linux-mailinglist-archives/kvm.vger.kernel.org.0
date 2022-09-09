Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B095B2E48
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 07:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiIIFsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 01:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiIIFsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 01:48:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1165333E25;
        Thu,  8 Sep 2022 22:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662702521; x=1694238521;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gt8EKMarhqCPYMwDoBwxrxy3d89AhoXs93DNRTV/wks=;
  b=NbSz10qzAiLPE5O/UcHcTaOzR6gsw2d1J5tBNBHIQLoGoiVMWaNBXn04
   aogXwfGhWHvFwRjEI8BKTt7+dl1EMfScn+9G1DviilKscWVosENnPWj6w
   1DYgDPQG5LYjdwDY5iK4lQgHvW6kE07Me2Yn5q9Fzl8oH5eixr1Lq6WVM
   2h+LC4s4c0ffxEb1NkDA/k+g65AXW/6YQlpFwqndEjxX5XrZT27jSdmh6
   k+lzJuH5rlyRo6iD3xtsyFIHQ23TL4x4nFvSd27zzq1Oggy9h0vv2y2P+
   Terq1oflHgZDPejocwiS18kqPnflS2m5PS+2auidZniRciTNWTgXkYauD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="280428676"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="280428676"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 22:48:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="677026175"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 08 Sep 2022 22:48:40 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 22:48:39 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 22:48:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 22:48:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 22:48:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLZ5m1ThLDO3x/kxWVeZZcQ+VOlygkujTQll874jP9s8xY6t5kU51ds7ekWOrugYEkGAa2L6d/UffcrZs31H60U5BxZSpno0Kd+TtsCTnJwcOUbTh7h2hd4FhA4zAjEqCZDzLZ2YHZlFfchTTUnxAGBIHQhQqVwQ3lAmRafzcgdr6cSaV+XnpAi9TfOaRGlZJlZM7TMPpb48DC3Emh0yZFPgcx9aXpCn5U6mn8Lm5+sKzqu7KQXBdOgucn2MrDxU1dYXL+30IBY/dsTyI1qQ1B/Y0ZH15ntg/21kgb18bCb5Z8/zW52IE7hBw0+1oAb8ciB3RjmGdZ/yh8G7vXh8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGmQcPdl4wjp+21mEzMfRruhXzzL/A7+cj/Ry649EmA=;
 b=JLJ8lF4vmLYf9aooCRM8L2/t0zUC1YAYUS5S8bAcsbcqHgGGYBfQImUD44OGfgnV93f56QZLdJ7ZJ8XveNeVwtOBeeSd9000otV+TAfi4a00pqywyT+7GNO22TolXZ8d0d7N1FAiHpJTH1SELp9nqGX28NVBpL5eSHzAeWb9nPEamMx6LUCqlbXgPJ+fIUbZQk9kmVQNw+IpUo1IPSQywNT3WCmR2LGIz37HIe8Sdm8G6ijgiD/AqRX06e07ixnZjpnsPYi0o8XtiVqFg0M+FqAqehMmviNCAkuUbDetDE+p+4nRBcZfPQJwwryqshArkMy7sLMxW/oBZCpWk4IG3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by MW4PR11MB6837.namprd11.prod.outlook.com
 (2603:10b6:303:221::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 9 Sep
 2022 05:48:36 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 05:48:36 +0000
Date:   Fri, 9 Sep 2022 13:48:32 +0800
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
Subject: Re: [PATCH v4 12/26] KVM: x86: Move TSC fixup logic to KVM arch
 resume callback
Message-ID: <YxrTsE8iT6mTCZgg@gao-cwp>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <a01d2507055525529b1a9c116aa1eb81f4e20b2a.1662679124.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a01d2507055525529b1a9c116aa1eb81f4e20b2a.1662679124.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0118.apcprd02.prod.outlook.com
 (2603:1096:4:92::34) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|MW4PR11MB6837:EE_
X-MS-Office365-Filtering-Correlation-Id: 34b8ee6a-570f-439d-f3bb-08da9226f022
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 04DgGo5Wk5/o+RO4nSMRRHSkt90JkVighUE/lW9GQ5Yb3Erh9xLcfXLCZV3ayEgWhbe/b81lVeP3Ra7iVj61819uPkybnpWGcxmtM+DLxOUKm4l89Bty9y4Ms1eK1Yrzndp6DdikKdkx0PfEhsbbZW8O0mth7QehiraLVMoqjl4JRHrIqGo7g5TsovKeD9T6qsmAxcpYQPHxKF0ZvKFLEbM/6RO6c8Vjb9H9fvnd8j8NbvrkEceRJrYUfz825CTBglBB5To90F4/HBFTAMjINItU9E0nylTsx3nQB/9C7itpAyQYFb1UeLkcLhJlZSyGhnt65A8nAOdTHAz6SRT1GhmuC+PQTvX9UjDChia4exE/+7m6HeUslhk8hzFFLJNShhCJqFfC/Fuf2NDVnFTMy8nMT6A6T5nU4iownkQNrGalMVbg6S520ToFVtBtvuOoRFiGuSlatWuevpIZr+xy4YYCE6MpBqepYZO9xh0VyKjYT6MI/78gcRkqZO4M+5mhyw2ZSS3O3iMp576QxHs3NcbVxA+eHDljwgUZP/cFR78lnIylnsEXGKMAHgSKAH5Q3O6BZuyTa6w2kqlNS2BaGh6vAEiaNi69glPzNuCjla7NMLY1F101NekW+8G/FqbKRnR44EGXM7kKl0g/LDyzp84aafkFz4qb5mWwnrG/m3tGbh1q3l7VRIkcYHbM8YTODtsVgdGMcjfDaXdiR6g4bQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(396003)(366004)(376002)(136003)(39860400002)(33716001)(186003)(9686003)(6512007)(82960400001)(4326008)(66946007)(7416002)(2906002)(4744005)(8936002)(5660300002)(66476007)(34206002)(66556008)(44832011)(8676002)(6636002)(316002)(6486002)(54906003)(26005)(478600001)(41300700001)(6506007)(6666004)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6vzEPwqJ5j9eflBwNMCpJL/kpdDorBnppo/jimii6whZweQVXpElFLUaCchS?=
 =?us-ascii?Q?7j4lwz4q/+9ee4dYJEjhsTVP9/SKL8ZqGA0DgLCu609CCGN5md3jm2YHU6cF?=
 =?us-ascii?Q?t/W7mturbtF6KvFtKva9V5ViDiFOURdBvxpKnufOkY+V48cVCkjfVzv6DsND?=
 =?us-ascii?Q?0Rrau9axGDLjiatnukZ0quILKqEBYgP+/+4CGafL/1Ak3lu5RtohIB40+UN3?=
 =?us-ascii?Q?C7rzxaTsb1ovWixhBhSz4fWRmCBlECyyBWSASWb8hzmJma52jjzYa24l80ww?=
 =?us-ascii?Q?m75BBVauqpBYPL6bsnALxWj7++shj8BFxsT11bJlhJCVzVYscFCcwgSS/RXY?=
 =?us-ascii?Q?yOEEzYzSzKoUbzoixeAwPtFmIF33KhAn5FW+4gmT7CTnfoVj94JfKhWtZWc8?=
 =?us-ascii?Q?yXnBrskkzTprBdDCiQgIoygOf00+8HspEhcX0gEOV+cfcxm5p6CTpSov3YUG?=
 =?us-ascii?Q?3R2uZsWePuMt4dviA39h3rV4QPBknuaey5ZBaHO7c2dn701sdFVj81IqJ8aQ?=
 =?us-ascii?Q?n0mGb5cUeFFL/9wTMa3CD3MNzMyDJcQrKdtnEFDkCtHOVWU/PmDFWrO36kmv?=
 =?us-ascii?Q?rChPyK4ZV9Ly8IfKt76dLGqfPGN3BAWU2N7XqGOuHZkp2QHa/4xaQ+a2auC0?=
 =?us-ascii?Q?+2h0xR+9zQfFQlyLyGafbggWiRbh2CFyuCnGkmwdBUWy+xs/cX2PtCFwOwgW?=
 =?us-ascii?Q?TX/JGzj6mipm7KfW9AD7Cs7+NCYPTkjeyf1+zW8fB7FZ81HJxbKm/YAlQxzV?=
 =?us-ascii?Q?CBqnluJOJAlPqDMyt8AmK0BkqqKtIsSEEpYvtlYzWi76XGvFvlAS4puEnzhu?=
 =?us-ascii?Q?Wgy6tHtYdA8X+DHmJ28VvrR2vgABvZnqeRhEHa3BlP3IJSMJK3zQXreJY9aM?=
 =?us-ascii?Q?t+8iod/lA3uhDVo5opYbKnEuntX5uCv1BlIW7JB4E6YUxOxdC739IjVnL2gd?=
 =?us-ascii?Q?/gkjm+L6R1TCZudV0vFJ8LxZjKE78DHypvtyvXqzGuzl2ZEnTfKjJWM3GiIL?=
 =?us-ascii?Q?ejhyzETR1TfPAUPOaqcnIThpKHHcYwKD3Wp5lcFvFw+yUuXBzQJnsWKwVXI3?=
 =?us-ascii?Q?5HEX5sFuz5Hj+wVH8fgvE8d3lIxrGG6VSdx1i4T9JxDxVuyDb81sTJ6RaPQ0?=
 =?us-ascii?Q?p1B3qLdw9a3yjrihanSWssph0NXj5Pm3yxC6bfkKUZS2/JlOOmLu+dOgYq+C?=
 =?us-ascii?Q?ceH9rOB85d63IhftuXbl5R339Dg4hPjcXy9iRDT07HKebMfIRgXX0luh4Mvj?=
 =?us-ascii?Q?io7dZQZ3yjAsuxjVloI3zQd3WFq+TDNPm15b9E0Y1naoh2wDMFdzwNbAMg3J?=
 =?us-ascii?Q?gXMuhETzq2s5i0oYlwoBdlOnidr8Hnl8Tdh9sS8IoD/bUAIqX2S0Bnpm8wS+?=
 =?us-ascii?Q?uZWGOxzQ9NpmP73tPe9Xt9gf1HgMQhyI6HMoi/okJPm6eP23zTRgK56WoD7v?=
 =?us-ascii?Q?nQ2W4BZuLZFFCw5A4q+LRAdcBy1R1ewNRTK3iyqXvvfIRFFmK8hk4EXBy1HJ?=
 =?us-ascii?Q?OchPwlbczTBnJ3NNZ+XjdVZjgCFccL2ua1gT5lFNJMdl6mJVBWCNZeMFcjJk?=
 =?us-ascii?Q?N83CDutmJQYX4RE+nQQPB20XaKZyHiZKu9vsOs7r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b8ee6a-570f-439d-f3bb-08da9226f022
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 05:48:36.2831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zu2WSR/VJm9txzZx9myTN4r5Gkj3ZC4u3Y6NauLKEt2/jGTKVwe0cRQcGSoPUN5yRyY6kpIAagK0MxQAGV4sDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6837
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 04:25:28PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>commit 0dd6a6edb012 ("KVM: Dont mark TSC unstable due to S4 suspend") made
>use of kvm_arch_hardware_enable() callback to detect that TSC goes backward
>due to S4 suspend.  It has to check it only when resuming from S4. Not
>every time virtualization hardware ennoblement.  Move the logic to
>kvm_arch_resume() callback.

IIUC, kvm_arch_resume() is called on the first CPU waking up from suspension.
But the detection was done on every CPU. Is it a problem (i.e., we fail to
detect TSC goes backward on some CPUs)?
