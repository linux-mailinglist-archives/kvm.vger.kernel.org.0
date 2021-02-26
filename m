Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2328326A0B
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 23:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZWf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 17:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhBZWfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 17:35:25 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051BEC06174A
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 14:34:44 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t5so132617pjd.0
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 14:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Joz7f24QnnxewLllirX/ZIoWPXA5ldI5c4mM+WeSQyg=;
        b=WmfTC+QGWmT8QNUXUUaILVKCS+3acc5vgFONkWE2IElpeHR3G77DVMok7u6a/xbKP3
         aydPpJ00Fu+t44++6od8vIb/pfcofOvzGmXcEBAl7e+O3DJgJuUb0Yc3qb9oyxHTdPbH
         oJ3Bec+m2sVN7ztsVWJV1bbeO9SHpRI93wZFQ8+N8z5xZKf2P0CBYKoMq4l+6dvbqg99
         I59z710bYY8p0riwzPCtFTRaVViZmG8TslRjP0h5TSiRO9k73kWibcNzs/duXZ38sdHU
         sNQNE+YsYsTMfMTiLzdJOWH4MzjUC8DEEhPU40HHLhm7zVmJ8R2tSmonFEpYge5CK/L0
         Sgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Joz7f24QnnxewLllirX/ZIoWPXA5ldI5c4mM+WeSQyg=;
        b=MN4rJCs0eyTnsIP62+XJz3N8g+44Jz0JWLFxocfi34HofqeK65dYdnoiCDRkjYYFvy
         xMOkNfzJqwxEw9K4vzf7V8nCGZqtHUDsJMi59jYXM33g46aHFqvtGZSfYWvan1rK1u8f
         nCZrbeQDlq0r8EJvMk/9ll/LGHMtLwk/94w5s+WlZuhP5bsV0Z0CfsbHPnf8KaSM6Cl6
         dLoXWBJtHC3vF4f+glTXE1RjTO9wLnrKMNB4Aw9bCyNIZd0hIbzwIFrzppdcgTLqcsmm
         nvyLJe0x3NTiA5jtzd2w6KwmpRgoAjLkpqOgVVOoniuM7U0mT8mgs/w15t1Tr87mfVKC
         +KWw==
X-Gm-Message-State: AOAM531ihZMYKaBJjJ7IBhXqa2pfSUhnNFJfd9jwoXOz5Urr7HdrKAFI
        uFwKw3YU1d3n6KwsnmXlWDBp8g==
X-Google-Smtp-Source: ABdhPJyIAprGG60fuQNZQv79X6q90PZvn6mAwuuY4iaLsqStXaV7kV76EJv+JTNOEvC2Krm6nwdIow==
X-Received: by 2002:a17:90a:6383:: with SMTP id f3mr5437829pjj.14.1614378884331;
        Fri, 26 Feb 2021 14:34:44 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e190:bf4c:e355:6c55])
        by smtp.gmail.com with ESMTPSA id e185sm10755991pfe.117.2021.02.26.14.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 14:34:43 -0800 (PST)
Date:   Fri, 26 Feb 2021 14:34:37 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave@sr71.net>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v6 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YDl3fTOZiQe5O7jW@google.com>
References: <cover.1614338774.git.kai.huang@intel.com>
 <308bd5a53199d1bf520d488f748e11ce76156a33.1614338774.git.kai.huang@intel.com>
 <746450bb-917d-ab6c-9a6a-671112cd203e@sr71.net>
 <YDlRgtnVS4+KkzUW@google.com>
 <55e0f003-ca2b-24d2-5a23-31a77c5b943d@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55e0f003-ca2b-24d2-5a23-31a77c5b943d@sr71.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 26, 2021, Dave Hansen wrote:
> On 2/26/21 11:52 AM, Sean Christopherson wrote:
> >> We must give a more informative message saying that the page is leaked.
> >>  Ideally, we'd also make this debuggable by dumping out how many of
> >> these pages there have been somewhere.  That can wait, though, until we
> >> have some kind of stats coming out of the code (there's nothing now).  A
> >> comment to remind us to do this would be nice.
> > Eh, having debugged these several times, the WARN_ONCE in sgx_reset_epc_page()
> > is probably sufficient.  IIRC, when I hit this, things were either laughably
> > broken and every page was failing, or there was another ENCLS failure somewhere
> > else that provided additional info.  Not saying don't add more debug info,
> > rather that it's probably not a priority.
> 
> Minimally, I just want a warning that says, "Whoops, I leaked a page".
> Or EREMOVE could even say, "whoops, this *MIGHT* leak a page".
> 
> My beef is mostly that "EREMOVE failed" doesn't tell and end user squat
> about what this means for their system.  At least if we say "leaked",
> they have some inclination that they've got to reboot to get the page back.

Oh yeah, no argument there.
