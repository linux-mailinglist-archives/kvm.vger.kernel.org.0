Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9483A7BF53B
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbjJJIE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbjJJIE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:04:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EC6A4;
        Tue, 10 Oct 2023 01:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696925063; x=1728461063;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=9LiiwaafL7vqK3S5UC+zEZeuqHkrKCe3GV3w9WmVU4k=;
  b=XtueLShwNhFTt1rfpMfXbn/ayQ6lkipJceGENEZob9WWbOEkhQLyuFQO
   u24AtSpGBWak0wyABqnpW2Ty//226gZ/q4Em5jko9PwkTzZokxuGZTlBT
   V1WRmDDetUFnNgTJkFfV3h2hkNTazKE0MJDRbBPskIfdwGXjr9OA8hWoR
   BbBRzBechS2GhO4qH+pgmaXJ4uq5QrP7f4jmtRAXnBRQcJYLb5cuovGep
   6k5ECXqiyzbldtqWGd0PIQFe8YeNXk/5rp2ZifKKrfpu4aWQRl/7JL7ar
   LxdCG9EYez9btVvxaXolKtviW8BLTt68xuZdUF3NJc2zvbaAXqNGPvyJq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363684569"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363684569"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:04:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="927050497"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="927050497"
Received: from pors-mobl3.ger.corp.intel.com (HELO localhost) ([10.252.42.155])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:04:20 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     pbonzini@redhat.com, workflows@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: deprecate KVM_WERROR in favor of general WERROR
In-Reply-To: <20231009144944.17c8eba3@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20231006205415.3501535-1-kuba@kernel.org>
 <ZSQ7z8gqIemJQXI6@google.com> <20231009110613.2405ff47@kernel.org>
 <ZSRVoYbCuDXc7aR7@google.com> <20231009144944.17c8eba3@kernel.org>
Date:   Tue, 10 Oct 2023 11:04:18 +0300
Message-ID: <87sf6i6gzh.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 09 Oct 2023, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 9 Oct 2023 12:33:53 -0700 Sean Christopherson wrote:
>> > We do have sympathy for these folks, we are mostly volunteers after
>> > all. At the same time someone's under-investment should not be causing
>> > pain to those of us who _do_ build test stuff carefully.  
>> 
>> This is a bit over the top.  Yeah, I need to add W=1 to my build scripts, but that's
>> not a lack of investment, just an oversight.  Though in this case it likely wouldn't
>> have made any difference since Paolo grabbed the patches directly and might have
>> even bypassed linux-next.  But again I would argue that's bad process, not a lack
>> of investment.
>
> If you do invest in build testing automation, why can't your automation
> count warnings rather than depend on WERROR? I don't understand.

Because having both CI and the subsystem/driver developers enable a
local WERROR actually works in keeping the subsystem/driver clean of
warnings.

For i915, we also enable W=1 warnings and kernel-doc -Werror with it,
keeping all of them warning clean. I don't much appreciate calling that
anti-social.

>
>> > Rather than tweak stuff I'd prefer if we could agree that local -Werror
>> > is anti-social :(
>> > 
>> > The global WERROR seems to be a good compromise.  
>> 
>> I disagree.  WERROR simply doesn't provide the same coverage.  E.g. it can't be
>> enabled for i386 without tuning FRAME_WARN, which (a) won't be at all obvious to
>> the average contributor and (b) increasing FRAME_WARN effectively reduces the
>> test coverage of KVM i386.
>> 
>> For KVM x86, I want the rules for contributing to be clearly documented, and as
>> simple as possible.  I don't see a sane way to achieve that with WERROR=y.
>
> Linus, you created the global WERROR option. Do you have an opinion
> on whether random subsystems should create their own WERROR flags?
> W=1 warning got in thru KVM and since they have a KVM_WERROR which
> defaults to enabled it broke build testing in networking.
> Randomly sprinkled -Werrors are fragile. Can we ask people to stop
> using them now that the global ERROR exists?

The DRM_I915_WERROR config depends on EXPERT and !COMPILE_TEST, and to
my knowledge this has never caused issues outside of i915 developers and
CI.

Maybe the fix to KVM_ERROR config should be

-	depends on (X86_64 && !KASAN) || !COMPILE_TEST
-	depends on (X86_64 && !KASAN) && !COMPILE_TEST


BR,
Jani.


-- 
Jani Nikula, Intel
