Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5251549E
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 21:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380325AbiD2TgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 15:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380316AbiD2TgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 15:36:00 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415587560B;
        Fri, 29 Apr 2022 12:32:41 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CE5891EC04AD;
        Fri, 29 Apr 2022 21:32:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651260755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nna9CBQPo5PQdjexXCZm9F8VHeCuCj+Y77aOAoFRonk=;
        b=pxCCzpFBWH45lDHBL3Agrpu0tz38S5FnS1E78+JDahCXr/AgakNfG0sBAwOPK/CFqBO9f3
        HiHwX/vdJLn5HhsC3Ja9Z7e8LId9cSnw+SAHZKIWIyfso/bwol5nBhgqsBitYowZy6uG5J
        iVce5CBstNkh+56eEW28YQwI/7k6jk0=
Date:   Fri, 29 Apr 2022 21:32:33 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <Ymw9UZDpXym2vXJs@zn.tnic>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 05:31:16PM +0000, Jon Kohler wrote:
> Selftests IIUC, but there may be other VMMs that do funny stuff. Said
> another way, I don’t think we actively restrict user space from doing
> this as far as I know.

"selftests", "there may be"?!

This doesn't sound like a real-life use case to me and we don't do
changes just because. Sorry.

> The paranoid aspect here is KVM is issuing an *additional* IBPB on
> top of what already happens in switch_mm(). 

Yeah, I know how that works.

> IMHO KVM side IBPB for most use cases isn’t really necessarily but 
> the general concept is that you want to protect vCPU from guest A
> from guest B, so you issue a prediction barrier on vCPU switch.
> 
> *however* that protection already happens in switch_mm(), because
> guest A and B are likely to use different mm_struct, so the only point
> of having this support in KVM seems to be to “kill it with fire” for 
> paranoid users who might be doing some tomfoolery that would 
> somehow bypass switch_mm() protection (such as somehow 
> sharing a struct).

Yeah, no, this all sounds like something highly hypothetical or there's
a use case of which you don't want to talk about publicly.

Either way, from what I'm reading I'm not in the least convinced that
this is needed.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
