Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C3453AF26
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 00:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiFAWLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 18:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiFAWLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 18:11:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D77D124;
        Wed,  1 Jun 2022 15:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654121473; x=1685657473;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=es6Cwl8W59Z9iWQR9a2wl0JY6YwBArtWx7MYgzVvdZM=;
  b=mia3V9Ns0r5685/99jbcdRsx2tQSIvdEIJJu/dUD+dEnZMbrsxTS6o4U
   mmBZ7bjGwut0o/NzJJUlDkmOVz6SF/771ao7vKprDZ+R19WcujSdreQwg
   tICzyXKEy/lqiiog8jyB7jYCpk8lngnkregABUfhL20myihQuGsXDbO5Q
   Kn4uEJafGus36hEKKsYViUTBjRAJLsBsW4Y2AzW0dT79GoZAvxX76PGBg
   pAmFPs0womFodxWHNtU1oLyvA3uwUBgmBXWs/jPejUkETrYWAR+UXxoos
   gljokKPWzaDezZxJhvEabE972SmaMdMmaQz4s+bOdzq5WoBvPnw1cq2tb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="274547914"
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="274547914"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 15:11:13 -0700
X-IronPort-AV: E=Sophos;i="5.91,269,1647327600"; 
   d="scan'208";a="904664455"
Received: from bandyopa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.4.241])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 15:11:11 -0700
Message-ID: <5ec9be313961b4cb3771180a75a4767998c6fdc0.camel@intel.com>
Subject: Re: [RFC PATCH v6 006/104] KVM: TDX: Detect CPU feature on kernel
 module initialization
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Sagi Shahar <sagis@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 02 Jun 2022 10:11:09 +1200
In-Reply-To: <20220526192844.GC3413287@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
         <eb5d2891a3ff55d88545221c588ba87e4c811878.1651774250.git.isaku.yamahata@intel.com>
         <CAAhR5DFWo6KjBO_0QtT71S2ZmKc-kAo6Kqcwc2M4-kFc-PkmyA@mail.gmail.com>
         <20220526192844.GC3413287@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-26 at 12:28 -0700, Isaku Yamahata wrote:
> +       if (!platform_has_tdx()) {
> +               if (__seamrr_enabled())
> +                       pr_warn("Cannot enable TDX with SEAMRR disabled\n");
> +               else
> +                       pr_warn("Cannot enable TDX on TDX disabled platform.\n");
> +               return -ENODEV;
> +       }

This is really overkill.  I cannot tell the difference between "SEAMRR disabled"
and "TDX disabled platform".

Btw, the v4 has removed __seamrr_enabled(), and there are other changes too. 
Could you rebase the KVM code to latest v4?

https://lore.kernel.org/lkml/cover.1654025430.git.kai.huang@intel.com/

-- 
Thanks,
-Kai


