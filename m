Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044CF6EC72F
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 09:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjDXHdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 03:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjDXHdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 03:33:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD372E6C;
        Mon, 24 Apr 2023 00:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682321570; x=1713857570;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RsTC2qLsOqcLl8Oq0Lv07G7/XiW+AoW7hifsb+/GmY0=;
  b=ZH4rWaX1nAFUw0wgys8ElZ9SC+CbpCyBo8wKdOXaHBZqITnkTxhsm/Nu
   pgslm8VorgAs71wrmOhlFym1Hg0ckdANYZTnBUBRpq7i9hMxzkH/yyTXc
   e8T2XGlxW3yWi3dk6aObD6xywAp7wT0Qift4lLdWvV8igBBlH66atdba6
   KjkDTZT7rb5EhDLluT8MBUX0Bg//3NM9BNwv5GVhfG1CwJkoteqVcGfbL
   5D8n9d11+52EJ2xwRmusDRE+UFHZukodXEvx3J6/gCCZa2s3js9fgVhuU
   mcTFJ7tu/PkTG/+8gri1P8m3YhNWgH7i0FziYHN3lStisKTCI2G5t9hqL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="409317560"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="409317560"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 00:32:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="836858957"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="836858957"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 24 Apr 2023 00:32:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 00:32:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 00:32:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 24 Apr 2023 00:32:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 24 Apr 2023 00:32:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDIdhbBxYKDnRSsmV7RrQn/fEDN/bmGTmjLO4MGNXqIi46H8YXa+JMmJlfmk4+rDik0i2blGWq8gqSYka+pwzoFWXhb5XsQuhbDEaapJz/6j8VeTxmk4ZZIV/v2q1wsX5fUZVp8TcfjbTwzwmSD/T8z4uoLYbzQ3C2t7HnYb4dCaFj7a9046xd7p1gnu0kJXHt7d/kSsMYxG0YVnZ/POWkyhK+uupiGa1bwjH/l7Osg/YIFbCQx5umuAqMIpCaHenfs8DK6CsiFlZu+9sUM5yFWYnT7vIp7ENdpOBERrlxyjnc0mVeb3zzilmPYO+bdFZaWXPwqN8uUvMg606eMmrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsTC2qLsOqcLl8Oq0Lv07G7/XiW+AoW7hifsb+/GmY0=;
 b=Nr/5+PsDPEzrjFWvID5SwGL1BvhNFf1o8zarFpdvgs9j/93JOMrHRIUNHDrjnjj0pfEFslm/Z56qvaqq8XQzB/YdYuYKtE5h29TuV+K9WQRvJbJ9Fkt22CP+AQFpnBgVVGSuspydp/sRR/e+yD+RQ/R/n27qGKlKx8Pgp4CJGpdGSnHurTSujXnB4llprsJeC4NrdIqbCV2wYGgTUALCFBcdaVBcMQJa1u4ekGuc83QGRft8Rd9QXbi7wop4rXYd6RpRjL8OUkr/6g6MUKahPAsg9UC5wdP5p84vxNRe0xV6lClryL78L7TWy/CsQHtAu89nTx7yjOT+Ro78V6nJ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ0PR11MB5645.namprd11.prod.outlook.com (2603:10b6:a03:3b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 07:32:46 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 07:32:46 +0000
Date:   Mon, 24 Apr 2023 15:32:36 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] KVM: x86: Virtualize CR4.LASS
Message-ID: <ZEYwlMmzYnJjNNHq@chao-email>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-2-guang.zeng@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230420133724.11398-2-guang.zeng@intel.com>
X-ClientProxiedBy: SG2PR01CA0114.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::18) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ0PR11MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: 982a6008-7a35-4e39-1f76-08db44961953
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0bSKg4Y78xWdJLfnQ0N0uhzLDWIZITnl0tcJ838rBg3G1lM4xYBNQXfQXgH1Cup4YS4xb4KxJz4hJCbopZ7Xjduo2YSMI378X5EOp44UfMdwTKqFHEqA898SG44D36RGX8xloqVjtkj74+ddeFzygQOuCpqeBspIHXQeKtCB9XCWujLc3i/EoXH2PHX+QwFyz8OevIWlAedD3SSDRqN73I0B+XAsd9hEjwlaasS8RAQZp2CNI/SGC0iizkQXETgbpTnqk1IKn0M/VmofTiW26I7vg439m5WMLMEO2sBIL3W6ZZPQTCTv23yxjn0AEal3m3SruMS+XaBQ7Az2Ego1RRpoCDlxYXK5ouQad1iqFbifW7SNMNpBiFGKU3FQtYQzEZeIJCdP/XYV8soi8Dpt+QSB//oAumUB2rX8yH6kJL6niwejQxGzV4H6Z7EZSNnUkcYaqygL1Qv6pZmKlh4aKDqRVmJCPL6tdewkndsIOqxWXhh+JEDr8nuA2pSl8PydxFKZtqg42qHZ26uhv0kJbiHGEZvSqPDdpzWlgnSZpLnjJii4hrqAB350jsAGR85
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(478600001)(54906003)(6636002)(86362001)(186003)(6486002)(26005)(9686003)(6506007)(6512007)(33716001)(6666004)(4326008)(66476007)(66556008)(316002)(82960400001)(44832011)(83380400001)(66946007)(2906002)(4744005)(38100700002)(41300700001)(8676002)(6862004)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZqltEdXtD0vJtswM8UWb4d07UJKpIPlZey2wvszaAGEkz6G6CLVQTUuxnVqm?=
 =?us-ascii?Q?Jw6EPH/PKtHois4qwA/hWKVcNw20fXt/EIGY1JCj4i4ny86b2IAq1NkG2L86?=
 =?us-ascii?Q?/L+jkBlXCPEa7Mh1sATNw3R0ycllfJsg+1jq4bi4exy9G0z7rpTOpgbZepV3?=
 =?us-ascii?Q?8JNb8dMNtwyo9wmnrI7b+SeT20Mt7/2dsCP7LuW25DPVlhvLc9FW0JadulA7?=
 =?us-ascii?Q?7Y+UlHkRdNsbIqrjGP5BQ6feEXSMgdk2Jxb8o8Eig7fhNmOmCJiLJQ/HQ9pQ?=
 =?us-ascii?Q?4GtErFCBtqOmqqlz+etMxJ0yqhBNbTRAg65qerb4g1b34f7HjA79rZjsB7Ws?=
 =?us-ascii?Q?9IyHMpoMtJ+8pTwk5wT7w63O0vTRizBloBRP9SnVXb3dq6GsBq1rUz0H0aWQ?=
 =?us-ascii?Q?it4vvJkUVMHMMC4KVBuPlyTjWJ099MC2e+i1Ejta9HbpuP6JiKMje4Gnybe+?=
 =?us-ascii?Q?DaDIJCE/JO3NU5qzKNnhw2PYiU3qe0gF2kuMtAn63aqFL1W8rVEYGjavqlhw?=
 =?us-ascii?Q?7gSYs09Lz3f8u1D/wMzd7PVI+NeZees8qATjvdFSdnXeX6ZiWLkQ1lekIliE?=
 =?us-ascii?Q?9Wr/O+W84Qjp4rMwxDb7d4JamDLF4IBacYpR11AOyBT+FU95sZclnjz5zfWh?=
 =?us-ascii?Q?V8vyF+fjNxHdKG6M7a1q1E9/6LPxG2ItT+At4NXpTzf3i/r0RGasLip2R/Tc?=
 =?us-ascii?Q?c2oKcsiiKAuz4gn4WKK5xTBRyjfFGXX6o+lc3oVgYIVFwqfWnWC1GNH9fuqn?=
 =?us-ascii?Q?iZPQ7pRw48WhsatM60SGBS6/S+CDCfdSaqm8xlzJwYWJazkY3kegdG9ENQCj?=
 =?us-ascii?Q?pCftItB72KssL0C0piDIir0xGAxQeFijg2WCh4GCPV+fBTvkN2kCLUE43kXP?=
 =?us-ascii?Q?ibvCK4GEYo6w0ygp/O4YN06c+IEu3ZdSkYmvka+KWkvPN5pubzQq7UvG440V?=
 =?us-ascii?Q?XrlPQWl37vjlSaLC1vht7Dxhs9LOqxZd+YRLgPpktpmUghIqKO15Q8mUP09F?=
 =?us-ascii?Q?459VUrSt+Pvnc0IW8BKXZ3wtooB5zCA/9gfNQVNUcHNS6mmUSjI5daE7Hv5m?=
 =?us-ascii?Q?hrq4d4Wn8WwiEcEQuW3Z5vYnjKSie1b4W7vsVc2E85ldRQqTfhVB4ukEmpPG?=
 =?us-ascii?Q?ZR8h5Y86/nXlJa9OjfqwAx56s9CoFnv6B3OElglm8AEnCGMXCZXDW91xwm0y?=
 =?us-ascii?Q?myHseZ5dpVEY7hjwjx7sWI5uPFjQcQyYg3LgL+Zjyh6ac+6ibzvkmwSehqpo?=
 =?us-ascii?Q?Z0x82UKTpVLJmDEkS9zfOh2uOu/yS2/zMyhtk19eceGREx3n2F46TyrLSJ6R?=
 =?us-ascii?Q?CFPHKwfXJunhkt7KVi+z59DNl4OSwUzYNm45pt9KCjdks0KjOhRdEjAmwsBI?=
 =?us-ascii?Q?CUAYHT5om8MIVMMOVxM+2d8JLj1ny+v4KC7QeEHzm/yS9ay+QoWxWNL9diaF?=
 =?us-ascii?Q?OVwTMKg/xVCs8JHc/IXwT2iU+5wiMvInubRG3z7bdlQSaeUqnPf5PbP6noXZ?=
 =?us-ascii?Q?15acBGOddrqKzDHdWAyMFg4uYmDfY7u+EOMN7fw+7ICwIeLC/BuVSvGswkg3?=
 =?us-ascii?Q?8d0ziC+WpWAOuBtcfEVfOoPT5EUQeW2WcN32wiNz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 982a6008-7a35-4e39-1f76-08db44961953
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 07:32:46.6790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8gSL+m6pgly7snN871PUQIIW8OwKzWiZmXHN2pZGSWXqxb/4/vchN3JducpvwUdtI9iBwoE7eptKi6v9HERAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5645
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 09:37:19PM +0800, Zeng Guang wrote:
>Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
>as CR4.LASS generally set once for each vCPU at boot time and won't be
>toggled at runtime. Besides, only if VM has LASS capability enumerated with
>CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
>to set CR4.LASS.

>By design CR4.LASS can be manipulated by nested guest as
>well.

This is inaccurate. The change in nested_vmx_cr_fixed1_bits_update() is
to allow L1 guests to set CR4.LASS in VMX operation. I would say:

Set the CR4.LASS bit in the emulated IA32_VMX_CR4_FIXED1 MSR for guests
to allow guests to enable LASS in nested VMX operation.
