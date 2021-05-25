Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB538F749
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 03:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhEYBE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 21:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhEYBE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 21:04:28 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB25C061756
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 18:02:58 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d16so22253605pfn.12
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 18:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z58QfC5D6YeFAbzSgFuFnv7cuq5vhjfp0Kxje8RxtIo=;
        b=W+B3bpONTpGdLIhDuxN26qGvLBjiytIUAf4B7oENMOFgCrlz6Q+Ybrm9jrsflLeJm5
         rcCnaEuGr2lC/mn11sX0oH5IM73f2dlBowVs1UXKTXeGqM+g3JP9ps0l8SIwWTB8ihDq
         aUEU4szrh2FCBAHV6gQWxAakJjUgdIuzHxCC7QRwlgvlistXUVTZTITy4F3+EH1fWF5m
         4ET9qis/9K3bAFK43k9U7SHr73rE6SY6bebeTKb2ipuWfCC9EIh/l+NDu30IsorkZXfK
         5zJlE137c6UTrUx0t9w+xZBb80U3N6HmUN4liigml7SDZUY1yxuAdqWhaIjISooGS5g/
         4a1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z58QfC5D6YeFAbzSgFuFnv7cuq5vhjfp0Kxje8RxtIo=;
        b=fH2lgsHbKaqTTDRiZ6Q3xjIVsnfGQSU+b1U4AsDTvFp6qONII6PoMdetG/m9f5LGgq
         0gmoE7HLpnR4PG4helEhov5KlQujKox5Z/6lvmbONoZsrm0FdxJLn6Y9+oIm7oOwuixO
         38QKgjoe613dtdwV7Y/mH3zOAlGaQjIb2T4C7tOM/C4wcwqV1fHSkUMbiSlb/t0bWkk0
         05MnULZ0qzs8K72IssxJVAZpSkfGQ6AFl722XFz61wlm/NpL+Z4/i55Ih5kZiqF5f/sR
         ZIPLYHdK8Ca3CizDRWRa64s5OKIhCYrXOACwX5Pk6us1N8XSI9Fu+H9qv040aEVrir2B
         whmw==
X-Gm-Message-State: AOAM530SCLaxiI6rYa47u2UcYhYp13ARMaK26QOOz58onDJdX3DW5o5/
        rNaCHucsDR+yScSDZ0CYuhwFzg==
X-Google-Smtp-Source: ABdhPJyY878/s4A/o8aiG0cDhKDvPtIrkjtz94B+7lT2MUtgJ4XDTGei4+Ezb+bDvWjuG/rNERawxg==
X-Received: by 2002:a05:6a00:84f:b029:2be:3b80:e9eb with SMTP id q15-20020a056a00084fb02902be3b80e9ebmr27677157pfk.39.1621904577837;
        Mon, 24 May 2021 18:02:57 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s5sm6567319pjo.10.2021.05.24.18.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 18:02:57 -0700 (PDT)
Date:   Tue, 25 May 2021 01:02:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 42/43] KVM: VMX: Drop VMWRITEs to zero fields at vCPU
 RESET
Message-ID: <YKxMvVCqOvGSQa2U@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-43-seanjc@google.com>
 <e2974b79-a6e5-81be-2adb-456f114391da@redhat.com>
 <YKwomNuTEwgf4Xt0@google.com>
 <CALMp9eSsOw0=n4-rn5B1A_T9nYBB0UkXWQ+oOJNx6ammfJ6Q-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSsOw0=n4-rn5B1A_T9nYBB0UkXWQ+oOJNx6ammfJ6Q-A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Jim Mattson wrote:
> On Mon, May 24, 2021 at 3:28 PM Sean Christopherson <seanjc@google.com> wrote:
> > That said, I'm not against switching to VMWRITE for everything, but regardless
> > of which route we choose, we should commit to one or the other.  I.e. double down
> > on memset() and bet that Intel won't break KVM, or replace the memset() in
> > alloc_vmcs_cpu() with a sequence that writes all known (possible?) fields.  The
> > current approach of zeroing the memory in software but initializing _some_ fields
> > is the worst option, e.g. I highly doubt vmcs01 and vmcs02 do VMWRITE(..., 0) on
> > the same fields.
> 
> The memset should probably be dropped, unless it is there to prevent
> information leakage. However, it is not necessary to VMWRITE all known
> (or possible) fields--just those that aren't guarded by an enable bit.

Yeah, I was thinking of defense-in-depth, e.g. better to have VM-Enter consume
'0' than random garbage because KVM botched an enabling sequence.  We essentially
get that today via the memset().  I'll fiddle with the sequence and see how much
overhead a paranoid and/or really paranoid approach would incur.
