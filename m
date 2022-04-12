Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5034FE9EB
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 23:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiDLVYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 17:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiDLVYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 17:24:35 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D0218114F;
        Tue, 12 Apr 2022 14:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649797537; x=1681333537;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BHLbe/RoUopliJXw7PZpTsR/hL9ogzQTYddN+kx+atU=;
  b=KSDBD8iYzCqN0x5BreM7rl7BmaJucB/khEuSIT0O2+sKfLIOtNURroMp
   bQHgDtDdXl42OAMFtkpdMGbpEbl03hzlKod9hWZ8ltuPBRgaVkjtVrzd3
   morhyAleYJ+A3lNyxYaY7ia0rHEgrK0aRxQClhLaW2LUQY4TQUOtCOZ3/
   XldR5ldXOKdBMiE6AJWBsJ8gEY+tjt0wyZurIRCD3/fZ6mGF72zT3euSz
   T+KozsHjkg1i9y5uDnqLcFQobc7xog19ZtoWSK/cR4yRZD7/2PzaLixPH
   9ZhzaSV6JLrRRW52HQwhdJCUp5e9hnS9fjiRtZ/J1kqZePT/5UURnFAoP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="260098619"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="260098619"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 13:54:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="644899572"
Received: from lpfafma-mobl.amr.corp.intel.com (HELO guptapa-desk) ([10.209.17.36])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 13:54:13 -0700
Date:   Tue, 12 Apr 2022 13:54:11 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] x86/tsx: fix KVM guest live migration for tsx=on
Message-ID: <20220412205411.m7n2gnon3ai7wobm@guptapa-desk>
References: <20220411180131.5054-1-jon@nutanix.com>
 <20220411200703.48654-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20220411200703.48654-1-jon@nutanix.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022 at 04:07:01PM -0400, Jon Kohler wrote:
>Move automatic disablement for TSX microcode deprecation from tsx_init() to
>x86_get_tsx_auto_mode(), such that systems with tsx=on will continue to
>see the TSX CPU features (HLE, RTM) even on updated microcode.
>
>KVM live migration could be possibly be broken in 5.14+ commit 293649307ef9
>("x86/tsx: Clear CPUID bits when TSX always force aborts"). Consider the
>following scenario:
>
>1. KVM hosts clustered in a live migration capable setup.
>2. KVM guests have TSX CPU features HLE and/or RTM presented.
>3. One of the three maintenance events occur:
>3a. An existing host running kernel >= 5.14 in the pool updated with the
>    new microcode.
>3b. A new host running kernel >= 5.14 is commissioned that already has the
>    microcode update preloaded.
>3c. All hosts are running kernel < 5.14 with microcode update already
>    loaded and one existing host gets updated to kernel >= 5.14.
>4. After maintenance event, the impacted host will not have HLE and RTM
>   exposed, and live migrations with guests with TSX features might not
>   migrate.

Which part was this reproduced on? AFAIK server parts(except for some
Intel Xeon E3s) did not get such microcode update.

Thanks,
Pawan
