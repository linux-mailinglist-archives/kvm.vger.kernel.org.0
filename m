Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDE9782749
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 12:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbjHUKoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 06:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbjHUKoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 06:44:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7D8DC;
        Mon, 21 Aug 2023 03:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692614655; x=1724150655;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3nfvjFAdPgEJclV3O4XkVFMBu9Rd4Ro2c0f/QdkRajA=;
  b=IlTWhiLtnzImMu3yEvD+1JMpQv/sIShltrWtDf8TcQ/Z4A6kioCNOC1y
   Qj711NVtUtyaypTrz2bDCNHJZzLi4Vu7EcR7U4e352/IxI5OAW9Gf7wNx
   QIEFXu8IYsilMb8MwgLGoAmkJucIr0fbRL7I47zROqAvGDAWD7Y4SxZfq
   CZg8wDoioCfoPZ7pXPEIPvyPCOT7DgU1Mzvhkgqbaw/5q0TMjt6NJUULM
   csSSRqgrHLBjcaXQDrBaVbnx7hMD8PA4p+LjdHLbGC6BnHaauL7q99EQa
   eI2yYA4sTtg0U2PiedJ7ecs/a6UnbGXXFt5hkdBcPNllgTjLosNfNp7y5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="353134058"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="353134058"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 03:44:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="801230892"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="801230892"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 21 Aug 2023 03:44:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 21 Aug 2023 03:44:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 21 Aug 2023 03:44:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 21 Aug 2023 03:44:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 21 Aug 2023 03:44:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lo8WB0BWMji9aOl12x3ps01mpod+811hzHEhjM1JBPJH5+dC/NjfnvPYimBdihBGjH+t1YYefleUwK8rkNTdUzONASJIpbvS3bst6jud9SZS2RtScyvBScz8A3INyGXDA+J5I0LzoE2K8sDPBEjBD05+gWLDbSWw6GOS2QJJMoa4ab8GIh6UkxPlg5CxBNjbZ8eTuKhPXsa9diukG1RX6Xr0dmpVPD1gtUv7SD53EGzi3KVaeF5ueg2AbYt43nNwjNtmjfDcJGdiRIYtvYi7lJIuxyVl2NbU7pnF70X2hHOLc9YTpxBoXNGYub6iguL2f7XDOAKTMuk/n38pQ2Dt8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tZKPhQ1JMfHw+KwMljwnK+9RtsuJSA8dm77sYtWK24=;
 b=ilMAcbPLDycw3Bk+uu5xibUAQLI2egwc37hE2jkGsJK4VqgYj+z6aLAISNSbpN2YncSPWMf1xFEe5hD2EIFeSzVX45ypPto/WrT8FtLSL5Zshap+bittL9eS6IIfK6WlFTJtoJYffIOI7/YLldkRwNcSKEVd6k15OpaJ/RXABcizkMVdoaFSCI/bC6VYujMRw2VJGAW7Zr8hy1pw5PJvVi5zjD5aK2Ze5LJPN/j2vIB9SfV641Ns33vqXHKvQqKJYxfauvBn7X8f5pq6MH5Sv1USr2E3fI8tDFCWBdDyWjKQE7RgEVzqN1vIi3GN2OvvwVF1o3TvSRWf+9JUNj2YOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM6PR11MB4625.namprd11.prod.outlook.com (2603:10b6:5:2a8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 10:44:11 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6699.020; Mon, 21 Aug 2023
 10:44:10 +0000
Date:   Mon, 21 Aug 2023 18:44:00 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Hao Xiang <hao.xiang@linux.alibaba.com>
CC:     <kvm@vger.kernel.org>, <shannon.zhao@linux.alibaba.com>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
Message-ID: <ZOM/8IVsRf3esyQ1@chao-email>
References: <1692588392-58155-1-git-send-email-hao.xiang@linux.alibaba.com>
 <ZOMWM+YmScUG3U5W@chao-email>
 <6d10dcf7-7912-25a2-8d8e-ef7d71a4ce83@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6d10dcf7-7912-25a2-8d8e-ef7d71a4ce83@linux.alibaba.com>
X-ClientProxiedBy: SGXP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::30)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM6PR11MB4625:EE_
X-MS-Office365-Filtering-Correlation-Id: 998e7b14-968a-44b5-332f-08dba2338d88
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nyqgrlkFWRpqvgK415/2bUmP8RG2FVbT6bksXUQeRgPRUWuN2Wpg8iyZn2AaRY1qY9XA124HzE1KXZaZl5Fg5XmR2ZyFAUoRp0YbtfO4gnPXnANnMxsxyyerj9uiIh1PnFsBqXj5dmE8EZxDmZJ5+GmKA7uP5U4U+SvDtKyuLFqD4af7+WFeWq8oxc4ejJO+I+Ck1f8JRdeNXjXZ4wkLLUsCgPBhskGs9Wd08no5lgoupFSqwvw/BP22jbPMPWrjEIfwW6nYfSNfS5/5CWq8mteTzY9zju3MKFJ+w3noCt8HeujMvQL586bQ+Eg7Q479fxSBUfHHTHebXAbphuDdiy7yq7qDoJ9As1acUl9blQZxAM/NG8H1GkhFszmUAl5Xj+ROjqK3P7CmGnyoXw31A/BbK+l8I7iMYHnb2e+H8mc0Q2sbGJrZUKWPcZXw4gllGqKPEqL6N+2ioF7yAIrt29qVat1R+ZHdXLHr0GePWLIcmGLZU1Q6yyxzjp0QYuqLiluAzETCAORs/DPXtbG/cPtZVP+EH+nLHm5rbeSf7G0lF0LfbpCFbmP/wzNoh0JN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199024)(186009)(1800799009)(2906002)(38100700002)(6506007)(6486002)(5660300002)(44832011)(26005)(86362001)(8676002)(8936002)(4326008)(316002)(9686003)(66946007)(6512007)(6916009)(66556008)(66476007)(82960400001)(478600001)(6666004)(41300700001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nV7WWZ0H+fhuUxu1RRlhCbY8Rhu8uoSKSbWTESPl7Pvb0z2q1AqQzhen7aa8?=
 =?us-ascii?Q?9M353IdA+S9LW0ImXdH+g2Sm9m20lLenDEFoFiQrC3eSu3gzNk4GlFqMetwC?=
 =?us-ascii?Q?lWJjxcnZ79YkTXE809DuZFkUhHmksIHoeLsbtNd1JvRN0c44GbfeW4VOQJD/?=
 =?us-ascii?Q?xcCP3aea6NZn50LI23ZfDuEUS1R+Ahqw+41BFdUKB7RW3CtR9rvqr+yl9FOf?=
 =?us-ascii?Q?O8MuT6NsFL5KcAfrDAUibde2ZjyEeOLk0YbF2zT33MPHdWyFWEXZeccC0/Dt?=
 =?us-ascii?Q?rRYX2MJfRvnWxfWRGP+4JFIpIv39zlyg33VpSEWSrLQhuJ08GPDlikZkSYDg?=
 =?us-ascii?Q?aT9exdayLAfWZ1oXiXlTpxYp7bnr8EmOjatDvtBnCdXv/4h5qCfOaJS4b8HW?=
 =?us-ascii?Q?YMNzAcPsZpuJkgHzHpvtws3/MWx0srlhekPaXWwhBFBDspmZOUcx02il4jlH?=
 =?us-ascii?Q?Fkr1jz/dUf8M/G1TVuK3YazxCfQ0bOv7BLqM9vu0GZuKs+NBdKCgLNERGzGf?=
 =?us-ascii?Q?Bo6i/eSET2TGUYSJoWsRRVY4M0a+IlsvXnKnZ4nuNy6Xw6yNUn6FQsbJZSVD?=
 =?us-ascii?Q?kc2SW0hsKmMoOoxNKhjwvTdgId63mfcLm/bd7V6XQWqXZQS9SvbY+EZGGoG1?=
 =?us-ascii?Q?Wrye3CsX+krZ1CfWOQ+Uoc+m6OdtBP/D5rG7SX3LbvvUYJl/FTKBD6xM/7kS?=
 =?us-ascii?Q?ZTE9qK6JHyA7twhET68xeBCjB8ilmApsFhSTOu6l3Qc9Q2cfsLfDwJPIg//7?=
 =?us-ascii?Q?VvAWvKAX5xI0XNsF2a1XcyN3QR+zmX/dMJqlheD/T2LV9/05aSd06NbwHnG8?=
 =?us-ascii?Q?R64OK0ecqm4AsJHG1TEvuDvgQGF5ssi9YkEuA7vZR2Q9VaEVAxvQrqapvaXH?=
 =?us-ascii?Q?S8nYXSkn3E8omWuua9aBlhqBw6fmdVeYvM8nNj6Qn5VBU4v0M6LLj7yPwYBS?=
 =?us-ascii?Q?Ji9o8FgpMu2dUupCCaGWJUgXrzWCik/1gpbXk0tjRqf3x35gLdEZ+7RKt2F8?=
 =?us-ascii?Q?VMzm5EErnD06UbwWsVSA8PS8jjg0WSQ4V0J5ieS9gWMUf4E4EnQf6noFp8ry?=
 =?us-ascii?Q?smjuW+psRdJ2NC05v/8HD68wtnT6prrzX4FL8QICpR7lLY9S3iuXAtv8lORe?=
 =?us-ascii?Q?fAWgoxQRzTb2sQqxekBxMWlA1oQ9byzMt+3ioIAVfcbmY9pt2KHq6LE/OoeR?=
 =?us-ascii?Q?+QDnMLDBOL6kJn5DVY6bV9mTpoY7a2m553uJBUK3Sf2JmVXBvqp/sK2mlQU1?=
 =?us-ascii?Q?hKVMMewXJyjIe7eT0bjQEeBgjKSkafX+F46ptYEWVw/zqKeodTl23+zS04Fj?=
 =?us-ascii?Q?32eG08p9FgoVckY8JuD0AjtRe6f6IGDjtQUcogb5wPwK/50SokJJkEduShaI?=
 =?us-ascii?Q?pSFl8e1TBgttgJG8ba60qfEND0Vgs5Ew9zM0yIJHqBrjt0moDSCt0znGSylj?=
 =?us-ascii?Q?kUZIs0i6QHr1CCmSHVkL0Baimz7VU3biCG/j9QtvJwZt9E5tPsrz0KacH3Zi?=
 =?us-ascii?Q?nvmBwcRzW6EkByMfkYlDC/D8jz8er3bsTeDFezLSqvyvM0QS6OO/1zMpC9gJ?=
 =?us-ascii?Q?IYvGiIERqG7uJTMw9EQKVshCzfPrTJt4yDC/s+Hz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 998e7b14-968a-44b5-332f-08dba2338d88
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 10:44:10.5642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XrZVAMH7Y9SSgQoonCSz2Elsju8+c3tmCHwKqcl2pNDDTVJ/ztr3Pjb/IS0BGQAYxx97ecNp20fXJ4kBNqO9FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4625
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023 at 05:11:16PM +0800, Hao Xiang wrote:
>For reason that,
>
>The turbo frequency info depends on specific machine type. And the msr value
>of MSR_PLATFORM_INFO may be diferent on diffrent generation machine.
>
>Get following msr bits (needed by turbostat on intel platform) by rdmsr
>MSR_PLATFORM_INFO directly in KVM is more reasonable. And set these msr bits
>as vcpu->arch.msr_platform_info default value.
> -bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
> -bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)

I don't get why QEMU cannot do this with the existing interface, e.g.,
KVM_SET_MSRS.

will the MSR value be migrated during VM migration?

looks we are in a dilemma. on one side, if the value is migrated, the value can
become inconsisntent with hardware value. On the other side, changing the ratio
bits at runtime isn't the architectural behavior.

And the MSR is per-socket. In theory, a system can have two sockets with
different values of the MSR. what if a vCPU is created on a socket and then
later runs on the other socket?

>
>On 2023/8/21 15:52, Chao Gao wrote:
>> On Mon, Aug 21, 2023 at 11:26:32AM +0800, Hao Xiang wrote:
>> > For intel platform, The BzyMhz field of Turbostat shows zero
>> > due to the missing of part msr bits of MSR_PLATFORM_INFO.
>> > 
>> > Acquire necessary msr bits, and expose following msr info to guest,
>> > to make sure guest can get correct turbo frequency info.
>> 
>> Userspace VMM (e.g., QEMU) can configure this MSR for guests. Please refer to
>> tools/testing/selftests/kvm/x86_64/platform_info_test.c.
>> 
>> The question is why KVM needs this patch given KVM already provides interfaces
>> for QEMU to configure the MSR.
