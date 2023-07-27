Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AFC7646D9
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 08:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjG0Gcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 02:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjG0Gcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 02:32:45 -0400
Received: from mgamail.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB1F189;
        Wed, 26 Jul 2023 23:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690439564; x=1721975564;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=t4i4dRtC0EocBbZBEWgX5N+2syc4rotKbSap5rTEnVY=;
  b=KKPZhqYazCg1fwml4565P36vu8vIQxcJMT400jAECgRpDI1U3jUKXgu0
   dhywiI+Hddfq3MiCdSvfQMcFSIRr45H8wY7pBf7wDjSyJ6uWpgOc51RMG
   a1xC071BhG9emdTxVflOSYiasKwC7lcIlslUXm/sG3PYcNX1P8QMRi7uo
   iHfyRn/a1BSb4KoK2efHhaU2RRIo0DIsB/PCU+/oVk8a9ataG0jQY71o1
   7Tn123rIRBRICpsXor4pWaPSMsv/l3xuWOggh/qt/zsvjHn2NWrU43DTY
   65pFaNBAVbjZy2dCy2NtbJMk6A8Nl48+fwktVSKsvNYK+FBQW+qMf6/FA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="370895287"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="370895287"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 23:32:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="762045686"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="762045686"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2023 23:32:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 23:32:43 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 23:32:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 23:32:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 23:32:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHrWT41CWi6Ln2J/yNkwIGPV6zZwTbrEHgWISFLF3h1saqzaM4szZOq7k8VXGf+73/PZ1yWPGwhmfRff5zPmMqwGnSXCIvm64oQsI+D69kuj/MrAB/5IQpEeA1S3UZR0IMwlmHqD5BcVik83pBOqzlC5gfLC8Sw+4S5DWd7msjeDimNVeyL7MD2/+ulFkC7CCnAHKoObnMONyAEZnep9ptp1BkaCqBlyC11JZSz0ndYKL7P1XrX1sQttkvxk2iJGgsUV6R6pK34ZdOEh01VtTgM9PX0CEkc1HG+OzqjRxZKq2q6HdmeSw1lAbgOFnpzh8iG1zQumpH8ay87/46VZIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/ZVsq1J7PTxcM938EoAWnxWFYb8si03g17qxci9ABo=;
 b=VNvHbPvhOBrNd7mQV0TaZnW0ugSzNDx+uQqe2GjyOu181ZAv8GZf48+kZfc6XrBzV0vaF3hIQUnB7TBFxh1yaVYCzeO8dFvF5w4PPOCAXGjjAMJs3ifXoFBQY54+8LXD+CN9DU+J1Vyp01XkDemEehvBmIBlc7PqrRtE/XqojGKdQbfrTGCnk0cVa3etsIS6ilzRDL0sIaG0k2yXPFCrpNjMUMQgi044ZIPgjOH50QizA23YQh6zgT51nd2Xh68RWd/ZN56F/7QQZK+UO2Y8W0hZqdqyKe+O7HtKYmCv+DP7W7eWt7sg58Iv5RhFz1UAICrw71Y2avuy3z3ArRbkPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ0PR11MB5895.namprd11.prod.outlook.com (2603:10b6:a03:42b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Thu, 27 Jul
 2023 06:32:36 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 06:32:36 +0000
Date:   Thu, 27 Jul 2023 14:32:24 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 17/20] KVM:x86: Enable CET virtualization for VMX and
 advertise to userspace
Message-ID: <ZMIPeAHn5aN2HVS4@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-18-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-18-weijiang.yang@intel.com>
X-ClientProxiedBy: KL1PR01CA0139.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::31) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ0PR11MB5895:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a3b2961-64ee-42db-fe48-08db8e6b442e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tct1Gq/SliKnix33nyjwd/nRSDQCeY+eYgGpNxi4kHErxi0NiCOQLwkOlBeCXGhrL9UWHbPrTc3aO6GIT2XznITCIj1Ue23yj8aIKafi/MBW9HoWt/riY0uYbzjSJah4FnJlU78CU1CMlCJOAqCDGnMvJsKSDytjBca3IB3sFQCTv7LESRGjaCweWeC+rTvv/EGvW1lqQeikXwSdZbZ1XlO+pBct8QCgcRI6zDiiPuYFkF7zEuLh+ftsMzcwfd7zD1YCcnXTc2pgTa1HiarikIGqArMIlLs1envO4HpL1NBzx2QBhzu625YuipaQuSQosfoyt1tM0ToMuYB0Kk06dURfGQPOD34HKkz6onzJJbfHpmS1jQSeYHbIekpRuD+p8la7jKZeCD6giOqaEnNpqhCmoFn8mDlmBYKH71LArVW4HE3OINFOhKmoy5KU3Z3UXzDCdVW5qPzQjOhie6yLs/2FFsGojSLZwxL5hY/JlqlxLrQmz3jf4wsPy7AXGyba5uRTId3zfiNeP1a7FggxyVuu/PdVaWw2LZuYydxaEV2HankhN7jHeTn44raznyJo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199021)(86362001)(33716001)(2906002)(558084003)(44832011)(186003)(6506007)(26005)(38100700002)(9686003)(6666004)(6486002)(6512007)(8936002)(6862004)(4326008)(66556008)(66946007)(6636002)(41300700001)(66476007)(8676002)(316002)(478600001)(5660300002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7FoQ0jCmPMWFbHu3W0G8Fc0Cpfe/facLL2m1VMQn5HKx+tqXuLsb/lNRwuT/?=
 =?us-ascii?Q?1WLtedAnYCcvDIipWmVH9Dqh8tT8TCn6Z1BQHbaOoScOTJvzW07cEt4RckuG?=
 =?us-ascii?Q?UksM2qbOTfoGPz6v7SoF+Sh0zLzNqz6vZdJ5AQEAKRTHbOW3RZcxGZ9tt0dq?=
 =?us-ascii?Q?99UhBjEDo2wte5VMsm52BlTZHSvsnsBgk/jX5e80Vry2sr1jiGi+7AIUFNSk?=
 =?us-ascii?Q?ntlAAli3yZ++9E5/drhUF9ZT52r7vq7UrghB1aIdm75XA79QErYQwcZVNePC?=
 =?us-ascii?Q?VNL42jo7kKNf/UxpYmqi+ljMTEbZoR+XDA6rfKa/uxGnR6+OfRXQ8CChmRq7?=
 =?us-ascii?Q?cKM9jo6ic9zNEz7rDXz8h0l7eop5q2U9NBqgb7llWNOV/t4eF0aRrY6u7X+U?=
 =?us-ascii?Q?qefzmfNczsNENwsNXK/BMhnQotsv+MoLkuW9A4GFsV7YMWbVsFkEMU8KJ3sp?=
 =?us-ascii?Q?W73Ljt6aLMXZO6xNFOcB08d5DsDDcsdxOsTvI5rlIsi0rF+gJ6+AmahEJr7b?=
 =?us-ascii?Q?DvwBq1sh+ul8uQ84aoLpHpS7HlqYlILoLjNXN3hRLodZTOy+q+H08lkFvdK2?=
 =?us-ascii?Q?DFSSHOPKLNQsTRj41XV6art5GkAGSM9USlUQWhlHKLIiQwPbVQHeH3bBO0UF?=
 =?us-ascii?Q?QRtGy8vuXzYe8wmRnSOexea7QbUXT2nB44MWWqfBBU0bC36zVlBbV/RXgxAs?=
 =?us-ascii?Q?9HftgR2OyUTTeSIs/k9V0rFkZ/at3DUwvQL86kCHFHEvwLXXNt5Qg+8vRDri?=
 =?us-ascii?Q?g6wYGJACCMkAWGM2vLsXdFTZTmPG2eN2mPvNn0cwknKGDfGFt4CmHBJvT5QJ?=
 =?us-ascii?Q?2BKKzmcV81+iJ2F8jBT18TEJKy9npvebk3pR7vOLqAae+TnrhimFrO889awM?=
 =?us-ascii?Q?ml1u7Gme+CuCy/kzNJ/IQORQPPCIR9RWo2MPcPFl4vCcBMBgZ7+QP1XDInUI?=
 =?us-ascii?Q?MrF5HDCyF8V8/SSTwikZL5Mkw4tgZmo0PU9YveC0Jm4sF0wpBXb8x9N5tLiE?=
 =?us-ascii?Q?45+70zChsZQopycZ4l/mqGip834ac2cROW4GADVmY4XIjlsvycwr2YrctWYF?=
 =?us-ascii?Q?5sEcUqtxkNk7qkE2LueVK5Ldc75DWuxe/huAtC8juN2XWGTfpcCJSiDgzl5f?=
 =?us-ascii?Q?PP6jv7HDsGlxxBbVq549Vmx0EZvbsD3NjidFBsuP2XFJ0k/QNmHG8PUqybQw?=
 =?us-ascii?Q?8tEf0znmV+M9Z5llpANb3EtAYrvY9yumHK4BVRM3dBQoz+wEvMuc/xUctlZ/?=
 =?us-ascii?Q?MBzq9lfENW7wuiqe7KMQtHBoNcrffJF33cg6DI312kYSnSQ6GBaXe7xqYzwK?=
 =?us-ascii?Q?G/3KMaF8X/JERkdWyGszB3A6sMOthQ2sc9JTvgN8i3Uo8ELQOHO79TO8XZqj?=
 =?us-ascii?Q?z2/GEY/vfhmhaCeqY6pDPzz9WrY6Q6MmSrO3rZ84pUFo2ez/XA+XxRYBVJuo?=
 =?us-ascii?Q?vYXEl8PR3MFzp4fk2KZH7bUnxXdr/+tTa+gCEeKlNs2JF8q6gWYRHAuu6B6P?=
 =?us-ascii?Q?kACEw8ujZ6DnZGnFDRtdMoBFmaJ3hX0/ShR9d5IrTWT+LhIilHpkCc/vP4Vw?=
 =?us-ascii?Q?u8bX30h2Jam83b061fzRLRdQjXZpg32NzgkLNcAK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3b2961-64ee-42db-fe48-08db8e6b442e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 06:32:36.0613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwallOr1X+o6zOLy8hCcKaJiR+nHQZCM2NxcoFRC1snsJ63tikSnY7wNoee+VARX92ZZA5OLJvqexZ8ZTwX52w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5895
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 11:03:49PM -0400, Yang Weijiang wrote:
> 	vmcs_conf->size = vmx_msr_high & 0x1fff;
>-	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
>+	vmcs_conf->basic_cap = vmx_msr_high & ~0x7fff;

why bit 13 and 14 are masked here?
