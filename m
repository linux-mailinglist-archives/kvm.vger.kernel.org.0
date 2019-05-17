Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2950D21CC8
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 19:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfEQRr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 13:47:29 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:38129 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfEQRr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 13:47:29 -0400
Received: by mail-it1-f196.google.com with SMTP id i63so13337144ita.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 10:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IK28MJD2iFmE9+Gx2woqqyhNagawB06wV7GHXJ2nXyQ=;
        b=Hyu4OCUWSc4JD+46pFpzlNgSUamRQhTpIqszayhM784WQ05sJNWkH7vsP8Ept2Qcrk
         VlJ/WCrRNZxaP3pVwVky4sraTIoLZMP8H/y5VFBvb4gqTNb1LEfRJH2qWjHu7m1IGDbF
         3jUxC3WRGYzvXaubI7Vs7IFQCgPnTA7ON+vzPaJJNfPQvH1OxJ9wKxdsvH+jwX5Mjfi5
         bihgsWgO+CP40V9KNB7BNYLHvZrabZdDVZaA/WTOwpQz4+XziuiJCls35aMiep2nso+C
         GdxK1t18H5fG5emB76afTyaBqVmSvClzS4GgAoL6RjRjfMQtRdNCpHLVuvSsUt+whcmx
         7D7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IK28MJD2iFmE9+Gx2woqqyhNagawB06wV7GHXJ2nXyQ=;
        b=sADPZZbIC5RdmhOQOA9f+klT34DzBuirYloSF5OFRyqz93ma8CQEzEccLG1Cx0Ci73
         On1SuOpXNtGf8hG8SAj1haN9WN0nKawYG1W1Qn7myf3tVJwm8+O5TK2aa4aFEe2OucYM
         fKZKRz+F/u1otHIFGOkQUwduvtaOZyeHcZO7GNdOF8skRB6DRyIqVokYIQzJTRAwQITu
         oH9LQI8kI4knW+gHbtMtjYBL5t5yNkq6rJVTqd03FuLi3TZC8DEYgKupL0V3aMsAmptY
         6nB+2qmvudb116bbchoFLdi2vCSlax3YGAXbxKd9mipTW7PlW7hmzCxDLA0RuN4Ff/aV
         uV4Q==
X-Gm-Message-State: APjAAAW716d76pblkAA3ZWe3NbbGOa05SydD4RJwmZUP5bfDGPceI8TE
        4CGg48NePQoG/rybmBHCyiN46qkeUVJBxdR1sbnchg==
X-Google-Smtp-Source: APXvYqyQZkGYsHC2I///F75ESdV7p/RjZTMmfl6WaICkf+Ov3p/m04pInF7n8xfWmkFR8tooBhzUNAB5D/Ki7NMCTmE=
X-Received: by 2002:a02:234b:: with SMTP id u72mr4000614jau.4.1558115248380;
 Fri, 17 May 2019 10:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190327201537.77350-1-jmattson@google.com> <20190401170616.GC28514@zn.tnic>
In-Reply-To: <20190401170616.GC28514@zn.tnic>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 17 May 2019 10:47:17 -0700
Message-ID: <CALMp9eSEkKK+v4mR4-9pcO6mKUT6Fs2m3KTwQLdrNWf3DKhpJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Include multiple indices with CPUID leaf 0x8000001d
To:     Borislav Petkov <bp@suse.de>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Jacob Xu <jacobhxu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 1, 2019 at 10:06 AM Borislav Petkov <bp@suse.de> wrote:
>
> On Wed, Mar 27, 2019 at 01:15:36PM -0700, Jim Mattson wrote:
> > Per the APM, "CPUID Fn8000_001D_E[D,C,B,A]X reports cache topology
> > information for the cache enumerated by the value passed to the
> > instruction in ECX, referred to as Cache n in the following
> > description. To gather information for all cache levels, software must
> > repeatedly execute CPUID with 8000_001Dh in EAX and ECX set to
> > increasing values beginning with 0 until a value of 00h is returned in
> > the field CacheType (EAX[4:0]) indicating no more cache descriptions
> > are available for this processor."
> >
> > The termination condition is the same as leaf 4, so we can reuse that
> > code block for leaf 0x8000001d.
> >
> > Fixes: 8765d75329a38 ("KVM: X86: Extend CPUID range to include new leaf")
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
>
> Reviewed-by: Borislav Petkov <bp@suse.de>

Paolo?
