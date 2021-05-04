Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBDD373171
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 22:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhEDUev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 16:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbhEDUeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 16:34:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CE1C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 13:33:54 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s22so8709409pgk.6
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 13:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C/Cj5I1mlYbC1jzOSOOF25th5Igc+hh3GZ0g8FBcqEI=;
        b=iJK5pVK/mFTAX9dUEyWr8HZrmhDgXZDtAgyBPKUHMH/tfsSqh7lV8WkaqvRkVAayYJ
         dMIWinGEclPrkiRLO5JznMDfhYa4SPPNcgv3nwymb8py/lcXiUTUqh0JUiobhbBfyUBw
         gQXwAeCxMotR5IXMRTtcTZF13yvlBcqS1IeFgBTDZ1Hf8zcInRNc7vx1LKBnU3OKgMUW
         /D6CW0Xdhkg09ACm8LsbGTZHsDR28PW/8DPcEyqiShwOdjIsDZfkO9wSvvvrE3WOCS5N
         D/XA11bS2yDyGl9Rum8ifYdKmgwhh6iHHSBHmSSeyTa2P8MCaVhgWFhAfPntNpUMwSP/
         9k7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C/Cj5I1mlYbC1jzOSOOF25th5Igc+hh3GZ0g8FBcqEI=;
        b=pQ1opqhkj9NWVQmPxaDNR+CtXT1axYkCjt8Zam3Q8jRT4MeyK/l8p7wQCt+bD/T9l8
         1mNcXOmXu0uLM/xeLpot9OSQ/QUEtRyHBVsJTpiKtNOGKIMwuv7GKIobnVQf+S8aHnqk
         mG8FQ97v53+Mq9L+4vzzKMpS0o757j1dICBeGckjLTGfGgpBqLSd3OzlC8sEqkDwe8HA
         WVSg8p62RWCChr9T+8SosDJcefFb64B0nhlRMpej93wVLRHZD3PPSL/IjHr24POp8G+R
         x/WiZhogJ/ecgUvursfGsLgej6MHMHjdxjRIsajDYSwVjXwpBuX9uKRgkIfSxLglFrqB
         0ooA==
X-Gm-Message-State: AOAM531U+Q6tuSerdx7TGDh17dzYc22fjH47Hf0GcAB+Tmt5MFtuYhDc
        rrkioBFXiW9kcdu452nJ9p42Bg==
X-Google-Smtp-Source: ABdhPJwCWZtzZv/BwmPQtdaiVrP1zcRE4DkGiKPJIPVLifXrJtC4yE4WMvk10tD+y6F4JF/C+shn6g==
X-Received: by 2002:a17:90b:33c4:: with SMTP id lk4mr7487384pjb.225.1620160434179;
        Tue, 04 May 2021 13:33:54 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k14sm15371273pjg.0.2021.05.04.13.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 13:33:53 -0700 (PDT)
Date:   Tue, 4 May 2021 20:33:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, ashish.kalra@amd.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
Subject: Re: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <YJGvrYWLQwiRSNLt@google.com>
References: <20210429104707.203055-1-pbonzini@redhat.com>
 <20210429104707.203055-3-pbonzini@redhat.com>
 <YIxkTZsblAzUzsf7@google.com>
 <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
 <YJF/3d+VBfJKqXV4@google.com>
 <f7300393-6527-005f-d824-eed5f7f2f8a8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7300393-6527-005f-d824-eed5f7f2f8a8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021, Paolo Bonzini wrote:
> On 04/05/21 19:09, Sean Christopherson wrote:
> > On Sat, May 01, 2021, Paolo Bonzini wrote:
> > > - make it completely independent from migration, i.e. it's just a facet of
> > > MSR_KVM_PAGE_ENC_STATUS saying whether the bitmap is up-to-date.  It would
> > > use CPUID bit as the encryption status bitmap and have no code at all in KVM
> > > (userspace needs to set up the filter and implement everything).
> > 
> > If the bit is purely a "page encryption status is up-to-date", what about
> > overloading KVM_HC_PAGE_ENC_STATUS to handle that status update as well?   That
> > would eliminate my biggest complaint about having what is effectively a single
> > paravirt feature split into two separate, but intertwined chunks of ABI.
> 
> It's true that they are intertwined, but I dislike not having a way to read
> the current state.

From the guest?
