Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF9F24D15B
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 11:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgHUJWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 05:22:44 -0400
Received: from mail.skyhub.de ([5.9.137.197]:42842 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgHUJWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 05:22:44 -0400
Received: from zn.tnic (p200300ec2f0eda003935e3317bb76801.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:da00:3935:e331:7bb7:6801])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9AA051EC03A0;
        Fri, 21 Aug 2020 11:22:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598001761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=dAWh+gQYvbJ+a8BPVTs3oObQGjpOyZWYcv6DEQm3fJs=;
        b=Y4QdL6eKNpjraFBCZfqbWJ+WkeHwU3HbLys6uixDhQJ5Tftd/dGwTORZkQreleKCt5a+1G
        q6x8ld0WEnAvuWkUX3hIiaiYODlAQ3EoaQ02X0HVEtLHCoRtMr2YZoEx1X4/5RcKIsDef9
        9Lw+G2LWlWh1ZNzYGHIXa2DL/RG3mEY=
Date:   Fri, 21 Aug 2020 11:22:37 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is
 enabled
Message-ID: <20200821092237.GF12181@zn.tnic>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com>
 <20200821074743.GB12181@zn.tnic>
 <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
 <20200821081633.GD12181@zn.tnic>
 <3b4ba9e9-dbf6-a094-0684-e68248050758@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3b4ba9e9-dbf6-a094-0684-e68248050758@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 11:05:24AM +0200, Paolo Bonzini wrote:
> ... RDTSCP is used as an ordered rdtsc but it discards the TSC_AUX
> value.

... and now because KVM is using it, the kernel can forget using
TSC_AUX. Are you kidding me?!

> Hence the assumption that KVM makes (and has made ever since TSC_AUX was
> introduced.

And *this* is the problem. KVM can't just be grabbing MSRs and claiming
them because it started using them first. You guys need to stop this. If
it is a shared resource, there better be an agreement about sharing it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
