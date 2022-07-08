Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD80456AFEC
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 03:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiGHBeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 21:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbiGHBea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 21:34:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EF572EEE;
        Thu,  7 Jul 2022 18:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657244069; x=1688780069;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Q0hvsnX7RVkuwvneu2Zqjjl/dVg/+ONMLULG1th9+jg=;
  b=EgI9kvdaA3IoRAGFuuZs8MS/41LkwidzKmT1DEfS+maBU2vTpjPFUMOq
   tEVQytJI7r+4uobRu5yxjG1OJU4A94qLB0LbsuA97DEbKWG5L75mRIm+8
   aFFxtRpBzKtny5Tna1sswjIn3nvaURkl2qEuV1PUSeGY6ww/EKbRtzR1p
   zNnS3nJ/xYXIw3EEP6Z0Kd8mcNl/rVsFrd56T8JliaeC9bfKUEUBSE+5L
   Y34YYjx7I356dgt5jE2UZ3Hpr3BYkDw/UfTd/Oa7/6mVdVzp70HWUTy8a
   Aw42fA0qGuP69DT/kBiyytPVBGTj7Xw5MgR1RvuyIYl4rZYucSpBxmWlS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="348146469"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="348146469"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 18:34:29 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="920816315"
Received: from pantones-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.54.208])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 18:34:23 -0700
Message-ID: <7f27a51961d212c17933b39ea0b5b884c2939ff9.camel@intel.com>
Subject: Re: [PATCH v7 101/102] Documentation/virtual/kvm: Document on Trust
 Domain Extensions(TDX)
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 08 Jul 2022 13:34:20 +1200
In-Reply-To: <9e54fa1ac03df3cd2fb7a2e64d3cffc35d4f097e.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <9e54fa1ac03df3cd2fb7a2e64d3cffc35d4f097e.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> +
> +- Wrapping kvm x86_ops: The current choice
> +  Introduce dedicated file for arch/x86/kvm/vmx/main.c (the name,
> +  main.c, is just chosen to show main entry points for callbacks.) and
> +  wrapper functions around all the callbacks with
> +  "if (is-tdx) tdx-callback() else vmx-callback()".
> +
> +  Pros:
> +  - No major change in common x86 KVM code. The change is (mostly)
> +    contained under arch/x86/kvm/vmx/.
> +  - When TDX is disabled(CONFIG_INTEL_TDX_HOST=3Dn), the overhead is
> +    optimized out.
> +  - Micro optimization by avoiding function pointer.
> +  Cons:
> +  - Many boiler plates in arch/x86/kvm/vmx/main.c.
> +
> +Alternative:
> +- Introduce another callback layer under arch/x86/kvm/vmx.
> +  Pros:
> +  - No major change in common x86 KVM code. The change is (mostly)
> +    contained under arch/x86/kvm/vmx/.
> +  - clear separation on callbacks.
> +  Cons:
> +  - overhead in VMX even when TDX is disabled(CONFIG_INTEL_TDX_HOST=3Dn)=
.
> +

Why putting "Alternative" in the documentation?  You may put it to the cove=
r
letter so people can judge whether the design is reasonable, but it should =
not
be in the documentation.

--=20
Thanks,
-Kai


