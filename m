Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF776EA169
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 04:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjDUCC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 22:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjDUCC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 22:02:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFCC1995
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 19:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682042575; x=1713578575;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hEVSavNWEZGjS/FyGLzZFmLT5umgT7c3O7q1T2KZX7Q=;
  b=fOqCH56zh3PBlZ4EEaxVFCVd2VrZ3dIOCNmQiiHqsWKeHWqQL1vo72RF
   Eyz7knqjwVlPMs0h23DCVzS6B0a05L4djyS7zdZ5rRg2vpmY+9lYp29s5
   JC4Qpfjn6QzQzteIQ7M+2k8JmA5TQDvhu3qBeoa6+93MjFCTodszVNSij
   Uw+dvdnPGvF4V+r9yL3S74EXe6IxLKKEHfIMlXpw0VIyWDEOwevjzhgQE
   Wn6zaCXtNeD6EaAJQNOuYb8Ku29pmdfw2nt919kiQVq2Unx0urKin3hT0
   u6cxvAOcgiU+qSvW64NSi4ZxI4u8vvn6GkkPLfHs4G+Yhij4Rm7Y+zsgx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="348686363"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="348686363"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 19:02:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="724640647"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="724640647"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 20 Apr 2023 19:02:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 19:02:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 19:02:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 19:02:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 19:02:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmAcPZbxn7Zn/5og9T8ODYInxVSfzN0+b0J4y+KVX7dKqmlZA4fkcsJsgzI/ffTQAheWnVNK75///tgpTCgrCPDun7A/VrGWhc4Lke2MFf6trmXOLSvMbjjv18bu/HX47KdK4lg5tZzTQABtXiTL3NNyTaKf0Dywb7Zp0EVLRSq/H4MAG7zyJJr3S8GyVzsY4tXsP7O5Lp7gXhcOZfwyrTaP7QHdX/dg1OvmHFO5VaqP5REkTzHbf3mUGCkKdCmyV0dIeFPwBtZ4y1Ajx5AYrkZIZEJYzpEMSqU2AB3UGTjNS8wUDho5v9JqWNgz3BFJ9ImJ0DJKfDo0EdgDNTV8ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aoq9W/zZ3yQtI1nP1LrWqv9cFFxzNhU6LfvtvG9upc8=;
 b=fgF81cFL9v8mpROsdS/k4rGzx7cfFD4G/gJWDp73z7FNzpgDFDE2VJLrXPVA3GBRwVfwqKvDc9M06VvzJ97hhQetY3KESGBXl3kIsTC/pO0KUr+sM+p3sP5cJI+0eAULYadv9UgIU59plNxN9Fwfm7jUeeEAlCuds8ZRyAyn+mxspi0tZPwNUCjp+b6ks6ugCigK0IU5lkzIsiRfctuXVQXuBjNBm0plZyuyfoCrQa9S6+wuTfxEwMPXSgXdfSwmDNeXYBhSnjII1ui7n91R/P92Er4ScXB4tf6ut+2F8/dG6id6/uQyoMQKyJgANUfvDZ14rZWXhieCUxigX+FAUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6781.namprd11.prod.outlook.com (2603:10b6:806:25d::12)
 by SJ2PR11MB7426.namprd11.prod.outlook.com (2603:10b6:a03:4c2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 02:02:43 +0000
Received: from SA1PR11MB6781.namprd11.prod.outlook.com
 ([fe80::e860:919a:74d1:e014]) by SA1PR11MB6781.namprd11.prod.outlook.com
 ([fe80::e860:919a:74d1:e014%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 02:02:43 +0000
Date:   Fri, 21 Apr 2023 10:02:32 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [kvm-unit-tests v3 1/4] x86: Allow setting of CR3 LAM bits if
 LAM supported
Message-ID: <ZEHuuAw39ZXopaqN@chao-email>
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
 <20230412075134.21240-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230412075134.21240-2-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR06CA0209.apcprd06.prod.outlook.com
 (2603:1096:4:68::17) To SA1PR11MB6781.namprd11.prod.outlook.com
 (2603:10b6:806:25d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6781:EE_|SJ2PR11MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: dc8eacad-61e6-4839-de27-08db420c7e23
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4pymxcIhdhHmK971Uhr/uzqlU3TLQ6DOsM2wLmoLHJqpA4OeweTn3RIrqdAm2i/zMmkDJ2ar+pRVnkp3oFkjQYpGvR9fdl7NrW612vj5TP0p8wpRUWYZrqSlq3wf+VQ9El6v6mwPvO0EXXPsvcLi7sd+XcO8fViwOG22D8F4xnQNYUsSbbWjYEB1flWxoLFJTh3L9KJQ4H2uEmV6nLs6nzU7SRvTgRZOvmjMVoL8vLOpl7enhrMRBpmwoBJEARVh8WQomLZi1xXLVz0mjXMBvxx3sQAMQjmGBUWlUJ9vUOCSCdp8kjWKgoljOiAIAOIHPHHkffsbuwC29/IzfP9alJdkJgPyqJ/04VbrqET2LNq8CN6QCKFmvOAFWNZ8GvrgMPyX4/5qEw9kO20sWxPEppj8ZmTujP0431ANnP1kyW4dDsbD8q/V+tEXYLSDAe6NdhTeD9sXllITMGCHWcTUmmGR2A16k2Pyp5k0G16FD2DurJHPNtc24yT/Tsts/5CzrAti/ypRdj3rRSFO/ZjJgt7OmS+5Fd/W9YcgTQ+asQpFRc4zSZVy1gGvf0q+fh4N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6781.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199021)(6916009)(4326008)(316002)(66556008)(66476007)(66946007)(6486002)(478600001)(6666004)(33716001)(5660300002)(41300700001)(8676002)(8936002)(44832011)(2906002)(86362001)(38100700002)(9686003)(6506007)(26005)(83380400001)(82960400001)(186003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?72qsTSsuZbPIyr0NL3O/uYnDRXM9oil9jI9xQPKbAi/ivCif44bao6pY/YDF?=
 =?us-ascii?Q?M1rvU3BXvftPsmwrUPpHCY1ee96t8UoO6U5BXBSPW6IpjfVngmLnvNmCgJzV?=
 =?us-ascii?Q?ZlVCgba4rXF9PJ91ryVCqOUDIArF9O9QWBwYJOmh7fia/P70IK4WoXbkz/Dy?=
 =?us-ascii?Q?AQuc02QaEXtBpM0HQPVPI/Ogh4pQ4smz14DrLm607IMAcw4qZe7J44lMyOBM?=
 =?us-ascii?Q?fDmCW/JNM4HYVMQjkjZf6F+8jIONa3byiyiOCB5KND3wrZww+WYxuS8ilVR5?=
 =?us-ascii?Q?Nlp+NCgrIYJXnZDriNbSo9NOpgSTVnqzHogG5LoJtr/htP1PDRlcLbMYpe/h?=
 =?us-ascii?Q?uQYBxfAHYiY3dyuB1fRd+vAH0Y7HptBj8tnX48aIJrV1hHAwUKzxsTcZPbAo?=
 =?us-ascii?Q?YcdfHyIBvUpuX1h71w/uRqTxi9kQoVbqJirtze9DXYSvNgxT7qQQDbWMyrh1?=
 =?us-ascii?Q?VkkY1qebJ6XoDc350lTu/MPlebOaXF6Gi/jJwIXkmqSvoA44cz0+/mouiRp1?=
 =?us-ascii?Q?BHGeG8Kv+bA40aOajRxRofgkMYFE1giJzJX7wE7xxwQprlu2NTskkh7rbp1k?=
 =?us-ascii?Q?F6VaGJ184JU3N+67cNPd35b4gCuQmp319LCyfSBL2+m3M9Xs2ou2GnjHnFSn?=
 =?us-ascii?Q?AoJR96UA6A9fFh6ANDZoZSDgYB++50rURXw8bHhXmkaLOHHvwxdvTofE3dPW?=
 =?us-ascii?Q?E3ZKZcU6va3Gwv11yokVfxeVhq6yYTXFs2JdMXstdFY8ThqixuUxz98+CjL8?=
 =?us-ascii?Q?J7WXgYPp5ZD/qMKllHSMbo0D3uTn7ikWTi78dkrz2QhE1aftdux06Vx4vme4?=
 =?us-ascii?Q?QZhV3kw/mJwo7alkE5nBZt9IPkKu0T3UKcvyStdBZ3UTKAFPrt+7nNE8/8au?=
 =?us-ascii?Q?7eImUnuz7JMIigmwYkThKzrQ370qQ2eI8OwBfFRn5xlLIqpcvVIuvLjX85+W?=
 =?us-ascii?Q?IAb7Ou3t/u9wOtsYOvjzu2w3jxdow7dl8bETFXWkq00jAVNIYIEunhJozM6E?=
 =?us-ascii?Q?Dad9MHuh/LFIzec82Z0UcA08BS4zOPFqjdhcTKNJIn4b0l+2VDg/p2nFC64W?=
 =?us-ascii?Q?lE1spke6uZaPs4z9rcPbTUUdNyI0zk74gc5b1vYXs+EPU+X0SDtI0VgZaZC6?=
 =?us-ascii?Q?E4SxWt2M8QBj8UujwEhFWDweTYIK/S3P0LR0sVMai/puA+EgivaXCjA9JwYc?=
 =?us-ascii?Q?7JsIbyrRm5SplcnkjGjjlzf5rkB/frtBw7G7Qbe+i15/WJLkxQfu5zCtkn40?=
 =?us-ascii?Q?A2A3Jf1DavMczJg71Zrw0vo4cVvJXU/VJ4hgS1AC0Y7XBtR32B/Mo1TGMjXy?=
 =?us-ascii?Q?Ui1POcCY+z4RS48McoYGOc9ZCI05LjHN+RU3o8Uv08B5Oqe5DNh0SbgAaMLh?=
 =?us-ascii?Q?wLkmsaeuwPBypiSs5yBfs2o+sUR4y9ilr+EWYnixSx+uX7FfyZ/LsRdOjHWD?=
 =?us-ascii?Q?HR82kJwkjhcrr9fDdf6eEOgDX87B0R3nNjU5kYVxo7XUPOmiwRuRxr5AomQg?=
 =?us-ascii?Q?0CNRgWGBtfRXw1ft2k1e4Anie6fj0wJO3S17+IsGXrjcwMM2LfbJkjb+RI/O?=
 =?us-ascii?Q?lmuUo/R/XT9Qne9ZQ6L+AQMIffIEgwcG1sfMeix7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc8eacad-61e6-4839-de27-08db420c7e23
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6781.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 02:02:42.7942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVKqg8Yto+YIu73sqsv8Nq+E/aeNEjgw+uVG2jPjtCDMDNw3qOB20NUnlltKy1xjVoO+XI0Hjf4VQn51hgVDdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7426
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 03:51:31PM +0800, Binbin Wu wrote:
>If LAM is supported, VM entry allows CR3.LAM_U48 (bit 62) and CR3.LAM_U57
>(bit 61) to be set in CR3 field.
>
>Change the test result expectations when setting CR3.LAM_U48 or CR3.LAM_U57
>on vmlaunch tests when LAM is supported.
>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>Reviewed-by: Chao Gao <chao.gao@intel.com>
>---
> lib/x86/processor.h | 3 +++
> x86/vmx_tests.c     | 6 +++++-
> 2 files changed, 8 insertions(+), 1 deletion(-)
>
>diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>index 3d58ef7..e00a32b 100644
>--- a/lib/x86/processor.h
>+++ b/lib/x86/processor.h
>@@ -55,6 +55,8 @@
> #define X86_CR0_PG		BIT(X86_CR0_PG_BIT)
> 
> #define X86_CR3_PCID_MASK	GENMASK(11, 0)
>+#define X86_CR3_LAM_U57_BIT	(61)
>+#define X86_CR3_LAM_U48_BIT	(62)
> 
> #define X86_CR4_VME_BIT		(0)
> #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
>@@ -248,6 +250,7 @@ static inline bool is_intel(void)
> #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
> #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
> #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
>+#define	X86_FEATURE_LAM			(CPUID(0x7, 1, EAX, 26))
> 
> /*
>  * Extended Leafs, a.k.a. AMD defined
>diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>index 7bba816..5ee1264 100644
>--- a/x86/vmx_tests.c
>+++ b/x86/vmx_tests.c
>@@ -7000,7 +7000,11 @@ static void test_host_ctl_regs(void)
> 		cr3 = cr3_saved | (1ul << i);
> 		vmcs_write(HOST_CR3, cr3);
> 		report_prefix_pushf("HOST_CR3 %lx", cr3);
>-		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
>+		if (this_cpu_has(X86_FEATURE_LAM) &&
>+		    ((i == X86_CR3_LAM_U57_BIT) || ( i == X86_CR3_LAM_U48_BIT)))

						    ^ stray space

>+			test_vmx_vmlaunch(0);
>+		else
>+			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
> 		report_prefix_pop();
> 	}
> 
>-- 
>2.25.1
>
