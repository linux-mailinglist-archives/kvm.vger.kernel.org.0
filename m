Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E43F6FD649
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 07:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbjEJFku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 01:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjEJFkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 01:40:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2228271B;
        Tue,  9 May 2023 22:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683697247; x=1715233247;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AZ0u5YaG5RgdyRrypXhZx0cd4Ebis1NUoshQ+pul9iM=;
  b=aNr5YAN9JHGobVH9+Uu6nkBYdaJxeNp5uT9HJGc1PQQPoq99XoNNzxKN
   68xNGYcO6Hxdoq8hYPXRR7Z0a1eesoPvx/UqEIOtxmLiaI0skjvnQrDS9
   fgw8Wi0ZOH73LGNYvZhO/9te+CRnV1PDU0ortuffsjfI0r/Y1oy9HDVSp
   Y0zmrJ1pnapFsdtgglU7vW4E5AAcAyQpGd/L2867hC9FkAfvtYvO+HAt1
   ydTKyT/hOE/Q8fPxMVuCWdGAd82CgrdLBliKBuR3j4kx47LGI8mNwYeLI
   7fmlIwkEjtxm/KxFlzstUNfCyV++yoJMkxQbhnsd5skm3TbnU8qNKHDJ7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="329750491"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="329750491"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 22:40:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="649620679"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="649620679"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 09 May 2023 22:40:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 22:40:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 22:40:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 22:40:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 22:40:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmyYVhNdNUbgBMY1EsaohRh4nOByJ4iAdJr1g285ZAC9U5gIKrrnZJDjEMuge9mvxQ2lUoJMankxdZtGGOcUldKzOmuAx7Oet3gcDhmBrdINjwol+Hy4/IKwfBNCtezRvsqI8k8LI2TLlaY6gLkYT47C8LhSDHk7QDMvmNBOOUJ+YWUpE4eVgP+b817raOp8J0Xu3y5wSyJKAtj+IMPa0lYUWDJOqCT2wYefPwhkJSqnpo253Yp7T5jzm/YkkhKF/jJETivnCeFT118Qyq7I/HsCvdTr8xCU+z0s8XMzx9Gg4gqcdh/vn0rGQsCczDoF8vNhZLjffRVyciXziHp11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtnTtcmCIKgsA1g3dT6zyGPlINOlzW4GqSxM/vIA6Uw=;
 b=S3WynEKZwT4FdOxOypDJhINYUXCbhVq88N/WfKjxKxSrmCU+XE+ZjETMoGBrF/e249ALPeGE14Wq5ikTDd0zNmEufI6nZoDhDSE1gSxLtRsdwyjAkjy1R7amnDeEpqecw5UdNm7mNl+oKCdzu7ZLVILUnwReZ0bMn0Qn1kLiMTLeu2Z2OBJ6RnxUyFTVPCJrYNPoa7/yABbAouvSLkmUQIJIpKc/OUSLzN0HXA7z7h0t8PtMy8CTtgyYsLCDf2r4hJx9c6DK9xbjP7ITg4QBZij+0qGdUJonKvH+q3eNYGBScpaYEn8y1VKyLgS3w1/tzzF9E4B6tvUO5ACP6FgMiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CY8PR11MB6868.namprd11.prod.outlook.com (2603:10b6:930:5c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 05:40:35 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6363.031; Wed, 10 May 2023
 05:40:35 +0000
Date:   Wed, 10 May 2023 13:39:25 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: only zap EPT when guest MTRR changes
Message-ID: <ZFsuDWwoKRA0W2/j@chao-email>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135143.1721-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230509135143.1721-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SG2PR02CA0097.apcprd02.prod.outlook.com
 (2603:1096:4:92::13) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CY8PR11MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: b685440c-f73b-4106-910f-08db51191388
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 76A2gCFrRl2Iw2CCYn32VMACHeruI/XP3wt0d17TpdbNBD8i3i4DrTd5+svZZVNKesez/NHBYRAJnNYit22d2+dlaC70FO2sA90RdWdF9UPlGOTCs6cw+iBptfLwmLmqq0XM04omIuBTqERvgskHmeaxt+U02Q1qN1i6iV3LBobmdI2bHYzEIP6qjWM6Z6/wSLLRO3EtGeU1lbl6gfrAh/9TdmwFgW++z2SsI9zO0AgKL0mARNA81OewfLxZ/muFMwxfgWyVe8EKzJcZKKUY1ypXwYCFR5/VO12Uip0cZsJJHX1o9rbHZRcINzm6c33LF9udnQbJsgBGHT9zb9nelD3xC7NXujI3kIdhSF04ApbnUWfp7eDhCGEJX3lhuHGjinXD9+r8s7ogZueoe6z5YBz5SfeLsWevdZCaHInQ3s8CoFa/qVOIQ4wjLgcQ2Ofy7WqAtVq+jb9eWoCkYP4ez+Qua+X6QE8zqcZyPjtctyj/O2AVG/CjESf3QDyOaxnqh0cYMtSYIxYaw4qtZ0JJmQ/Q1oUcO8uUBIhD9A9EF/o4F/GHeCesIVOpluWwM4VC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199021)(66946007)(33716001)(66476007)(6666004)(6486002)(66556008)(6636002)(4326008)(316002)(26005)(2906002)(41300700001)(6862004)(8936002)(8676002)(6506007)(9686003)(6512007)(186003)(44832011)(5660300002)(86362001)(38100700002)(82960400001)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2RPBT4P6W/gLI8B1aI1sSizX9NYrqj67CR7TAT7p8zUyaZgIqeTmoN8XooGE?=
 =?us-ascii?Q?yHWBleHr/yDe0R0kQ0sCj3E4PDk2PIwqF009vBcclWdpVb1J3NkpMkmVhmrC?=
 =?us-ascii?Q?w4+O5pHNy2LtqMU5WInVtRXJy9cptv6lRvuosk3bfJ9iWuUxqLXn0DwNjE7g?=
 =?us-ascii?Q?ctQVr7FWvBMd4XLeCRTTLpDi3hvpMqrU1UiuGViZrb5VBIwHhV/orWEWfPOS?=
 =?us-ascii?Q?Un7H0MMD+Ggo1jkQU8jekHsZ9JWk2XnT6cajG0Ok1Eij6UQvulNtGJslJYaw?=
 =?us-ascii?Q?t+bDMX7XWEc3yJM7r7lhI8IlrgqrecAmPc4ruqerniX9SINLrVyBhj13soqN?=
 =?us-ascii?Q?GwGGE6dlkqROjsS5MckfwhVztMlkx5R5ZmeX4GMFK8qk5b23Dpl5qXl/LfQQ?=
 =?us-ascii?Q?3Qo/qEWdg1jsoaaf7LeLMHZZDqStkw6TDGo1FNGMHnnmI95qnE+cjiIykqWn?=
 =?us-ascii?Q?Esu4/Y6k23MpSZHfKoNj03pgSDR4cg6GC1X7eWR9XunIqdgN193X8aR0tsV/?=
 =?us-ascii?Q?7IY1e95fQxTu6bmjw2ZSZRKfCquTvJeVt6TKHm+Po6Qsg+NV3MHfESYo1auN?=
 =?us-ascii?Q?b8RUo1zxNW5kigWaRIGVC6yzr8QWZ9H1UimIDuog/bOH+WxsQ42RFupzcQ76?=
 =?us-ascii?Q?SOjLUVXvbk6/w41ysD3vgEoGbhgPFhVvS6rD1cAO+jX2jlDgY+2e8QTovKCk?=
 =?us-ascii?Q?+m3xhRcObeAovH+cL16zOQlohiC4ENXaQNq4snoNgy6YxVojB8aY9KDG3cyh?=
 =?us-ascii?Q?nh4nJIrL0TawtlZIM9Kva7mHZLhD0c8a3Wh89s40lRNo6CadgzTdWpK1mGrc?=
 =?us-ascii?Q?j6lWvU6uug9frbKLLX2147wyMsP5uMzNCjL1As30TuHuM5weFMpka00rPMTQ?=
 =?us-ascii?Q?mfci/RsOyFXrcs2sPHUriEoBLPUGjY3k8F1GqHdxUrZUs9XDmwl3d0QfPR14?=
 =?us-ascii?Q?NYUb6k2mlndzMg+wwH/O8KVx1MFcCWgwHitByblYxTOCQcUe+dk7y0tqp7KG?=
 =?us-ascii?Q?U/zN1WXCB2ABYs/8gngn079uAH6ryZJvqK3NGiHuPlxGzbqb36i05oF6EJhw?=
 =?us-ascii?Q?+esXV1OHJHdoPh3XzVsyx2Y2pnuUA0iJWZTS8f1iOUI6YdoNv1HsL5DsL+Qo?=
 =?us-ascii?Q?hRq5wdTtgujy+NPZ2/8zOhdE9jU3c85jmIyqps2gZlaI09aZ60W8kCwAOqx0?=
 =?us-ascii?Q?OQtLnHSalmFyTZQawVG/9DtW8vNA2LUjQxNLa0cZR5bKbyBW4xMdCPYzBuIr?=
 =?us-ascii?Q?7Jhw2aAw9MSbdg7Shq7fvhjwS7nxxCxdUoKFs0P/PP2c+I0AEhnK043B81os?=
 =?us-ascii?Q?PLUSmOK06cbwupm4MTf61hu1AwOi8hQOH6KYHJkUMpQUDqX78uBZeq2JjXmc?=
 =?us-ascii?Q?ea2D/xO1AXzF8Qo2C85hy4LZmI1NtvSm8D/0I3zHsEg8k/9iTNTLTV6XdJey?=
 =?us-ascii?Q?Jkz8Xh0j+oGSr9/e0Zl+pWjTNSA16H2b+wlVZtUbjIY9UNySA44gI/eX9BxA?=
 =?us-ascii?Q?Tz7Xbr7DwVdk1z7FQTWPx4sVgmYr48yF892B1KM46+3GOsZeJXgCcDkDaSsO?=
 =?us-ascii?Q?AR5LGfTt0OxIuBSWc6IluOZT8JnC8o6bOUqfP7nU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b685440c-f73b-4106-910f-08db51191388
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 05:40:34.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iW2Dz4/cshwDx87HCtUxUxYc8rDePtTiALxXAeo+J9E8Lk9AZ/wasf6BDW5lyWF6m8TB+CppDH3FvsxPi5zz7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6868
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 09, 2023 at 09:51:43PM +0800, Yan Zhao wrote:
>Call new helper kvm_zap_gfn_for_memtype() to skip zap mmu if EPT is not
>enabled.
>
>When guest MTRR changes and it's desired to zap TDP entries to remove
>stale mappings, only do it when EPT is enabled, because only memory type
>of EPT leaf is affected by guest MTRR with noncoherent DMA present.
>
>Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>---
> arch/x86/kvm/mtrr.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
>index 9fac1ec03463..62ebb9978156 100644
>--- a/arch/x86/kvm/mtrr.c
>+++ b/arch/x86/kvm/mtrr.c
>@@ -330,7 +330,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
> 		var_mtrr_range(&mtrr_state->var_ranges[index], &start, &end);
> 	}
> 
>-	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
>+	kvm_zap_gfn_for_memtype(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));

I am wondering if the check of shadow_memtype_mask (now inside the
kvm_zap_gfn_for_memtype()) should be moved to the beginning of update_mtrr().
Because if EPT isn't enabled, computing @start/@end is useless and can be
skipped.

> }
> 
> static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
>-- 
>2.17.1
>
