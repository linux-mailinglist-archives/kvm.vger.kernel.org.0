Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33EC453A15
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 20:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbhKPTX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 14:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhKPTX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 14:23:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BA6C061570;
        Tue, 16 Nov 2021 11:20:28 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637090427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x2KWQ8Oh4UH2l0tA32LVkIco7cmGVqFYP1+iJVEZMQk=;
        b=fFTNJ/UnPNXRkW6L0YNh0bsgC1/GpXsTcYElUEFwvRHb344/6pOAFoyJMtPzJiRxgz0h90
        g+XMTUiBBiiFz0/2KlBvh7Ev81nylKGFRDYgGkute/LlUXMKX67KNx+fuW43VVeLUND3yG
        K3Zlam875GEsnIjBTKLtb5c8ZqH4TJzo+3bO6ZFuunmKwvFdBW22YgvNrwm/fIi9s5GPsQ
        87Oh1HUfewZ6J62EVzd57XAPi2eGqBtgC0dff8vMoMj+69lNndSHUKEpvGf+APHPRT5M91
        9PhVFNqzpimzpzeQR5lThkfWXjtnokjz82L3Y1PVvwRVOl2ydP3C7kkDnS/K0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637090427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x2KWQ8Oh4UH2l0tA32LVkIco7cmGVqFYP1+iJVEZMQk=;
        b=Xpl12LGwuHl3RybY25Mwu0A6n2v0Ju5ZQQ70YqAGTVwEzyeR1eo1YZ/lHWYqwDt8YfJ5je
        uR3oeT3JZVZB7GBg==
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
In-Reply-To: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
Date:   Tue, 16 Nov 2021 20:20:26 +0100
Message-ID: <878rxn6h6t.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jing,

On Wed, Nov 10 2021 at 13:01, Liu, Jing2 wrote:

more thoughts.

> Once we start passthrough the XFD MSR, we need to save/restore
> them at VM exit/entry time. If we immediately resume the guest
> without enabling interrupts/preemptions (exit fast-path), we have no
> issues. We don't need to save the MSR.

Correct.

> The question is how the host XFD MSR is restored while control is in
> KVM.
>
> The XSAVE(S) instruction saves the (guest) state component[x] as 0 or
> doesn't save when XFD[x] != 0. Accordingly, XRSTOR(S) cannot restore
> that (guest state). And it is possible that XFD != 0 and the guest is using
> extended feature at VM exit;

You mean on creative guests which just keep AMX state alive and set
XFD[AMX] = 1 to later restore it to XFD[AMX] = 0?

> we can check the XINUSE state-component bitmap by XGETBV(1). By adding
> more meaning to the existing field: fpstate->in_use, it can be useful
> for KVM to set the XINUSE value.

As I pointed out to Sean, the problem is inconsistent state. Checking
XGETBV(1) cannot make that go away. And I have no idea how you want to
abuse fpstate->in_use for anything related to the XINUSE bitmap. It's a
single bit for a particular purpose and has absolutely nothing to do
with XINUSE. Trying to overload that is just wrong.

If XFD is not trapped then you have exactly three options:

   1) Make it an autosave MSR and grab the guest XFD value from that
      memory to update fpstate and the shadow memory before reenabling
      interrupts

   2) Do the MSR read how I suggested before reenabling interrupts

   3) Conditionally post XSAVES when fpstate->is_guest == true

Anything else wont work.

Thanks,

        tglx
