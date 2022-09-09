Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5485B2FD6
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 09:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiIIHc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 03:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiIIHcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 03:32:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0571223A6;
        Fri,  9 Sep 2022 00:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662708771; x=1694244771;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=31+b98zuMzpZLVrpTIpGQYfionZ5Wcm6lu4C9m3hiTM=;
  b=YEdWJ21xokOHkJWFFnEkWn/fEYzeaguSvAPBiRJDC5bwyUO8+y7lHsfR
   BKP5fVuy79ZyGKFVWiPk8AaqbGHOAroM3BGc3jduKVU+El6ncS1qwOjhq
   PfIo5aYS2aCMGU0Igf1jZXP6M67FnBAB6NXJbjcesFvBt+Wq0PzuV5T+j
   WqvLOpThHqWbtaRFLlQPSofN8F2VNHMJhQMQOX8M0Dv9uct0AXOAhX43i
   rM76voUVAAlJa+Iqt9NVyxL3TNF0xoHx+K5h94Cc3Xe1RCmDRdFittn21
   OKuKis92n7ojTTsYQQribR4T7OsVJV7hWDskdG3m6MRpv05mgCTkMCI4n
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="359143797"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="359143797"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 00:32:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="615188648"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 09 Sep 2022 00:32:50 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 00:32:50 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 00:32:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 9 Sep 2022 00:32:49 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 9 Sep 2022 00:32:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLSqsONYpNiKS6/nzpsTBUZ0VLmkkxaUuz+F0M8Zfd7XE/AWK1VEJRvbmbyXHM4xaRrgjGdqb8BWFzrp8qxtjc1aft8IMCjvz9CtVuB1L81vPyo+3EEUrlVwwZ8dduog6GkSXgYWDemYIePsXCeBOl0mdUAl8MevHqx2YfwaXo84gSQnACw5LfaJ4Re90n6wpczqNeCay4V7AhWfanIYJs//qibHlezLf0JQXpm9ErmYL+Dtd1NAN5rOYmE6lwlFeP/zonJb+1+O59NVTj/he/CgpHlBH0k4KKod8AbYtaB/Sb/k78yPHwxhdzEkVHVmynjV2WMMQ3bP1qqZiMGmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2Pbbf6Oj/z2HbGo1DoGm65xlM5IIFFqHTSxY+nEHog=;
 b=hAvvoijlDWGSrkuOeEgh8EswlXxv0jgFjTxrV2lawStKvIes5jEm/UiNxBBpgkCPNG+dTKPVLAXcP4I+yzTdDWDN2/CWpJ9mj69Q8lUeOqQNEs6hKbvMdjl+dhHyX6tLYw8fPp4xavB8TL1PzoO2k1r5XLDDBdSFqzuC4ZctTIkbx8Bd6ql7FrrKjRxfAUAngSbl6lY02yhoEokc5JSKMUpMHAh2rAgcC9QUphhZOsMLR2fdBRaKxxi6M3LHHDpjoRNZFYIAuDWu6kqdyHRGMXZMH8df6jr3Ei/OKQrr/TPQLdSO4jWORKFei2ltnLFGpGhj7J+RDpGjGrtCYZk1RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by SA0PR11MB4638.namprd11.prod.outlook.com
 (2603:10b6:806:73::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Fri, 9 Sep
 2022 07:32:46 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 07:32:46 +0000
Date:   Fri, 9 Sep 2022 15:32:41 +0800
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
Subject: Re: [PATCH v4 17/26] KVM: Introduce a arch wrapper to check all
 processor compatibility
Message-ID: <YxrsGSwQPastRxwj@gao-cwp>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <bf667e324f45609c7ff6d06b49ca6bf767f77ae6.1662679124.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bf667e324f45609c7ff6d06b49ca6bf767f77ae6.1662679124.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:3:18::15) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|SA0PR11MB4638:EE_
X-MS-Office365-Filtering-Correlation-Id: 41d5dc35-c5ed-4c80-d3ee-08da92357db8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pMRF8iotaa6JLU9UXeM4D5WoCQ6utW+skx1DegADfCPBBibDEzJGsXQ6JfQptnYJCB79HQKxqjFE7zYhD7j9m1YTYTn5bKwKAjZr4i5kPVAUXYtyZqqkhHmnJZZuQBaU/XGyOlhtmHG3bl7eY2bcRuk1/OFze6m5tMesoU7wnnQsWfwAUyK5j1R1eEWdUAc1/KY1+oMV5hsMJmnLjXxYYtOIzgPU+sURBESjkLA2BR4h5hw1o/Bklilp28WjClosPE0HojtYgSpWmiY+zyJwQOtggKaqWppMy4vNCQ1BA11wbKDKYAMqG0ir70QbWNMFoeOK1V83Q4+yGKhEuqpdGLaxw0EbglzAKuvCzexZuBdkEtsB/aoNKFhMQ2qyMOB6mzRxm+vrzXHSxPoXN1i5f5wxJNgiNqLqwJmUJWl3EsxREYsnoOXSk66GUyTtMmxJfgwtwZb181VgnxxugK4/BFoXX30/Oyo+QVyX5XOeo4JDqo6V2YGlM+TFpMS0ytFHMHaJi/ujldnvUL12c7diUsn0CenHwmrQXUV5N6fhyKlGzokpfkFgdG3ATgNC+ZOt7Vpw/z78dUv8z2LHGCiBK1KVcGyN05K9IhxpsMmVcyL2B857n48k0rgMpsr0aV4aiVtjTNxxDjAeplShmigqkrcf4Q/8ew0efGMjy9y/bqOesd/t+c/dNUa0v9s84IvxN9T+1oOYT2AtUdJiSPDgyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(39860400002)(396003)(366004)(136003)(6486002)(316002)(54906003)(6636002)(82960400001)(86362001)(83380400001)(6666004)(186003)(478600001)(9686003)(41300700001)(38100700002)(26005)(6506007)(6512007)(7416002)(66556008)(2906002)(8936002)(44832011)(34206002)(5660300002)(8676002)(4326008)(66476007)(66946007)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XlGvCKQVojEbPrgziRDVrcN6IIaLN3G7PR5oFRPgdZsrw4hJLiL/Jex3tTKt?=
 =?us-ascii?Q?h94ftgnwKtkJREGWJQSdtf0fN6x+ykMKXEH5wJ3Sht2ElVy7xVqyjzruZ0ef?=
 =?us-ascii?Q?0XlSXuZBCD96yD0BkpYKe3j2nTsazwY2SYBlGKhgkzQHvFxdpscMHvd0a2Dy?=
 =?us-ascii?Q?Boulz+1F9WkSkf4xI35WzHIuZPdTlQUuD3N81p4ZvV+KRqe6Sg+duKHiIHpL?=
 =?us-ascii?Q?OdlJa0QaiAy0zWtTyppASLDjiJ4CDhcamUMkuTZPsdi531320W4+pBtlqmXm?=
 =?us-ascii?Q?Z1vli67vozdEUlluTeAIVCO1vL7sSHdZCaKIeSBh/CG1nJpBrWQ8CJm/PRka?=
 =?us-ascii?Q?byepyO1CTDYamBlUHaBOhtgsnPOVmSGZPzKpcoMGJ9ot5ORQHcVNkbyISTUG?=
 =?us-ascii?Q?Yf7fbl+P5L7qJ+lAdzuhiB8+hG8OsYvFjyX4aPpgbe+XogcNGAJszqDlyRXi?=
 =?us-ascii?Q?qC7mQi+//u+YqbY0neCDqDsid5LPQBmKJnpWvyYXsVIpMxQGxqvDFes2Cj6p?=
 =?us-ascii?Q?3lHXSh3EfKWFaz2yPtax53h+cjJocPReWk6B/3WGJGCZ8tsmBY9r/MNNY2Eo?=
 =?us-ascii?Q?kcdg1cVVhxCFxMXkr2SCaGkmfS0QDTbW9Osq0F9GRPXbRjQ9eg2qEF1fOHd1?=
 =?us-ascii?Q?T826ANr0ZyPu2gBZx/qzmXQrKOwBoHb3VEfJD7s0BA33Rc2EH0bTHqJCzFah?=
 =?us-ascii?Q?2VabzdirZs6/aP2H6NF2ijN3PtUg8pSaaTW0vuQmT1I/6gyrMsaIvBQ3Qyj+?=
 =?us-ascii?Q?EgN2fLIy2JnXi0fBjPLRNm1qsNq2NN70W1sp67vn5g9u0vXRCnoW4LBR09Ll?=
 =?us-ascii?Q?hgzl9gbqy/J+4XDOUrebvedrghJuNSheiSK9E3bK813j297As5Mq8rnPLfXM?=
 =?us-ascii?Q?1UvjJY6QREETDpxY8bn5pf3GFDZlWEizTw8gO5t3KF2rYt7wUC7cby9WkHWj?=
 =?us-ascii?Q?iCxUjBsFT/WTchhJU/qVEx/+WaQfO6KRDZ1TgGo4xRiJzs6S2F98pgjQ8No0?=
 =?us-ascii?Q?J2uQvWXRejXWFd5yU6XG3bHN36AdlhsVmjZP6NgjICa79arpV3sWak7JpeC1?=
 =?us-ascii?Q?iO0jNQI1PaJBpZWJitLesW+RyY+YeJ9/gXhsi0UUvJGLEZdrrdtrI7MWmKMc?=
 =?us-ascii?Q?o79u+LpjWeyEy+OuRfTATCmNZLUj82BD9rnDrL5TW/BMKOtlMhLwaKJ0hwzF?=
 =?us-ascii?Q?8zuX2cJl51xKuA+3O+CK3ZJDgTpjb6ub7Obi5JlDI3DO5gwQ7C+OWD0T1gvy?=
 =?us-ascii?Q?dkyvA5nAJ9vUSU6ny+B/UrLCfe7h/lURs9N19r0+fIsVRlPzC5VAgPdmJxeu?=
 =?us-ascii?Q?j+Pw5LzABg7hfJEwvUVVwmzuy+GIuyD+aGlzjrcpxHhIqDackEupe1PNqOof?=
 =?us-ascii?Q?3uGw6Sg3CRJJH5a/ewtlSxOFpEAJZxfDuDaZp7crOnWhpoyBncoVGBrcPOdd?=
 =?us-ascii?Q?9OtbA0i+GUOa2RD2uaJ4mPrwTa38R9gh+ffugWH83uKvW27ie0X2ObmDU46G?=
 =?us-ascii?Q?ry+s/6LtcwpS8CVxmO2IjIqoLdOrOVlQZ4ekNFYRCU0v/FzmG47sI78urH7c?=
 =?us-ascii?Q?kX48MqZlzUReaRN9wz14R7+orhS4+ghWqmF6z0wr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d5dc35-c5ed-4c80-d3ee-08da92357db8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 07:32:46.7783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiztvVc9iEE7ODoE5O1Ru8DGby4L+0rsSn80TrkmrxAekS6Km4Me9t01ryFVKxeaZ6GmgqFH3SUilZMZWPDaeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4638
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

On Thu, Sep 08, 2022 at 04:25:33PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Introduce a arch wrapper to check all processor compatibility and define
>default implementation as weak symbol to keep the current logic.
>
>The hardware feature compatibility check is arch dependent, only x86 KVM
>does cpu feature check on all processors.  It doesn't make much sense to
>enforce the current implementation to invoke check function on each
>processors.  Introduce a arch callback,
>kvm_arch_check_processor_compat_all(), so that arch code can override it.
>
>Eventually feature check should be pushed down into arch callback,
>(kvm_arch_hardware_setup(), kvm_arch_online_cpu(), and kvm_arch_resume()),
>the two compatibility check, kvm_arch_check_processor_compat{,_all}(), will
>be eliminated.  This is a transitional step for it.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>+__weak int kvm_arch_check_processor_compat_all(void)

nit: int __weak
