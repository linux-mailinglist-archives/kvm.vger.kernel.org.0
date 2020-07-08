Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66111219410
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 01:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgGHXHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 19:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGHXHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 19:07:34 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B234C061A0B
        for <kvm@vger.kernel.org>; Wed,  8 Jul 2020 16:07:34 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id a12so308365ion.13
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 16:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mLYrBq3kxB014w6k6aADAiZibvi7Dst0ESJua5jQQNY=;
        b=sJRVXB32XkrmmGEaOsRIlIB/HpaKnueVfCkMoHS/YNzdjH/n0Tclh76JVey8R6fLN+
         oXxXplNryQZEYrT76NoPL/2uTXpSkOAsfzxFoA0q6QxV4wgZdl4dlz4zjODkXcy13r7h
         cDdraUgasl71YhUU+UWnbPjSEZrSnN1itiu4kDuQ643gDCXxyfspkUCYYlYiYw1M2yjH
         r/UnT1LcKrB9w/O+DLDgQKaAo1AibVZICMwrYbRN9cgZVFRR3w1ya2LGRKHs0FpIotCR
         EUJ0Hprrkd81/wQ/rv0i/HioF1HgWmRFU6+n7SoSz30ROQGHLUEGhhO+mh/KzOQnl+Dl
         geHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mLYrBq3kxB014w6k6aADAiZibvi7Dst0ESJua5jQQNY=;
        b=Bs3EQFl3H3kZme5d105yvwSuCrVR9sAtm1pbhNmg7aG/1oKnISwSuEQUDwSgU+YoIo
         vMyWmbu7PKREnZeZ07QdMbhihcjX+AZWo+qzSjYUcHl+poD+SLq+rGxfXp+wpJqL1j7Q
         kNZccRbieutuz4rcg2Izky2tLAu8m2oxNeZKrX5jYnmSf5m+JwAaVtJIu6wG49WmQvwe
         phvfHt46BnS5q6RfcEWHpU1cI6p02uVgyG0ayo5bpewELHgQ9+bvgXPikzGu6/a5ojCx
         7pb8qBSAwsHnwEBRG9dUpTlbfOVy5oLtd8+qZFXbbJdJlPFexC3r+HLkyS9Lojimqd2y
         E3WQ==
X-Gm-Message-State: AOAM531Bh7tgsXCNAVjsHOCROh142Hx3Ej3TmYzUVi/0YamqvuVHgwcl
        XolBB2rdtcDk8d+UMoLQFAQ/VjZWEccgDgBVoUpmig==
X-Google-Smtp-Source: ABdhPJwcOtdxUY9jBFzMMb2HfZvedSzRz0uiZZyP30stGRujyKaWgdXSujNfDwB0ckjRO+78c3w3TdPmecn5ZwuyYIM=
X-Received: by 2002:a02:c785:: with SMTP id n5mr70055073jao.75.1594249653086;
 Wed, 08 Jul 2020 16:07:33 -0700 (PDT)
MIME-Version: 1.0
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
 <1594168797-29444-3-git-send-email-krish.sadhukhan@oracle.com>
 <699b4ea4-d8df-e098-8f5c-3abe8e4c138c@redhat.com> <ed07cbc2-991f-1f9e-9a4d-ef9b4294b373@oracle.com>
In-Reply-To: <ed07cbc2-991f-1f9e-9a4d-ef9b4294b373@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 8 Jul 2020 16:07:22 -0700
Message-ID: <CALMp9eQRgRX4nnLHp52SY1emjjs7VO90pGKpV3Y0JJvf-bjNFQ@mail.gmail.com>
Subject: Re: [PATCH 2/3 v4] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are
 not set on vmrun of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 8, 2020 at 3:51 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:

> Just curious about using LME instead of LMA. According to APM,
>
>      " The processor behaves as a 32-bit x86 processor in all respects
> until long mode is activated, even if long mode is enabled. None of the
> new 64-bit data sizes, addressing, or system aspects available in long
> mode can be used until EFER.LMA=1."
>
>
> Is it possible that L1 sets LME, but not LMA, in L2's  VMCS and this
> code will execute even if the processor is not in long-mode ?

No. EFER.LMA is not modifiable through software. It is always
"EFER.LME != 0 && CR0.PG != 0."
