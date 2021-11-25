Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A704145E16A
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356761AbhKYUP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:15:56 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54454 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357004AbhKYUO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:14:58 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637871106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZTKZJgeChVw3msWWtox35n2YclWaURqA0d/qHBiO2oE=;
        b=2iPkaZQ/urf1bPFs4a47nZl9oa2O+v+/iksCK9asihSKSkmW8+fmdRyHzaMLi3RgNJELD+
        7LzyU19xAKmx3GqRa7VvZ5jtOEjSY0x+evJVgA8aToBVDnb6DwlX/SXb5TMgbB7a4bQXUg
        q2cKKO6W1gqccsq534KJ5VfSDkkUbLUdpbWEShQOzJaEUd4vz06C0Y12+rzpTxnPqbhjsD
        QCxYs3AOsLnJ5m2a2ks9XZ9xU+RFus8UMo09cUK8XXNgTcBMkqHtAY/RyZxawiMr6a/Qms
        WwSteBNB/Q+l3bVSInje00jaLEQO79p5mN0xqoebmNCDPq3w+RR/SQj8tj70nA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637871106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZTKZJgeChVw3msWWtox35n2YclWaURqA0d/qHBiO2oE=;
        b=nTPnhvTYFDSVx8AbuNboxqeest7LOSNS6E4mE9tVQeTRLfKriAttgCWpAvwi8/ev1zrk5S
        qb03fo5JXVmFcdCw==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 46/59] KVM: VMX: Move register caching logic to
 common code
In-Reply-To: <2f3c1207f66f44fdd2f3eb0809d552f5632e4b41.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <2f3c1207f66f44fdd2f3eb0809d552f5632e4b41.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:11:45 +0100
Message-ID: <87mtlshu66.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:

> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Move the guts of vmx_cache_reg() to vt_cache_reg() in preparation for
> reusing the bulk of the code for TDX, which can access guest state for
> debug TDs.
>
> Use kvm_x86_ops.cache_reg() in ept_update_paging_mode_cr0() rather than
> trying to expose vt_cache_reg() to vmx.c, even though it means taking a
> retpoline.  The code runs if and only if EPT is enabled but unrestricted
> guest.

This sentence does not parse because it's not a proper sentence.

> Only one generation of CPU, Nehalem, supports EPT but not
> unrestricted guest, and disabling unrestricted guest without also
> disabling EPT is, to put it bluntly, dumb.

This one is only significantly better and lacks an explanation what this
means for the dumb case.

Thanks,

        tglx


