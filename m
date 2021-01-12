Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45512F37AA
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391593AbhALRvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 12:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727622AbhALRvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 12:51:44 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AFAC061786;
        Tue, 12 Jan 2021 09:51:04 -0800 (PST)
Received: from zn.tnic (p200300ec2f0e8c0065ae075541957fe3.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8c00:65ae:755:4195:7fe3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DF3E91EC03CE;
        Tue, 12 Jan 2021 18:51:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610473863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=g21PW6bH7/Y4DkJPbzn13xs2fcNMYU2M4iSPH3WNfsg=;
        b=Rh+gphchdji41pzbPhuF/kEbktBn9sFtpvqmZau1ROc7ww9P6vR9Pd6TePjXYzpUZ3TAUH
        3s02ZBNs9sC1l+11NwQHuvLHY+3Sbb3W/B6lgxtai3Ynh972Z1Jz4/SgUgKT3famkztCLS
        xObUTMfSsfACO3ZQJURV2Rnq0gbZgLE=
Date:   Tue, 12 Jan 2021 18:51:02 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210112175102.GJ13086@zn.tnic>
References: <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
 <20210109011939.GL4042@zn.tnic>
 <X/yQyUx4+veuSO0e@google.com>
 <20210111190901.GG25645@zn.tnic>
 <X/yk6zcJTLXJwIrJ@google.com>
 <20210112121359.GC13086@zn.tnic>
 <X/3ZSKDWoPcCsV/w@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X/3ZSKDWoPcCsV/w@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 09:15:52AM -0800, Sean Christopherson wrote:
> We want the boot_cpu_data.x86_capability memcpy() so that KVM doesn't advertise
> support for features that are intentionally disabled in the kernel, e.g. via
> kernel params.  Except for a few special cases, e.g. LA57, KVM doesn't enable
> features in the guest if they're disabled in the host, even if the features are
> supported in hardware.
> 
> For some features, e.g. SMEP and SMAP, honoring boot_cpu_data is mostly about
> respecting the kernel's wishes, i.e. barring hardware bugs, enabling such
> features in the guest won't break anything.  But for other features, e.g. XSAVE
> based features, enabling them in the guest without proper support in the host
> will corrupt guest and/or host state.

Ah ok, that is an important point.
 
> So it's really the CPUID read that is (mostly) superfluous.

Yeah, but that is cheap, as we established.

Ok then, I don't see anything that might be a problem and I guess we can
try that handling of scattered bits in kvm and see how far we'll get.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
