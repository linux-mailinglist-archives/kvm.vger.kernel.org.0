Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D92A423539
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 02:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbhJFAnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 20:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236969AbhJFAnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 20:43:06 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B60C06174E
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 17:41:15 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id g14so923517pfm.1
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 17:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/Twg3K4gp+yGHpRxWybK7U//bFNhuubvyWg25c1dXUA=;
        b=LtSHvLTg5hUhnlUSroodmREz1Y3HjVdqPk4Gb70XZsg9cRgV0BiVFpKJVxPQWGZicK
         +GRQioBNmN5oLYSFPySIP2G5riMlYbyv6g5lG5iL5XpX04iVEItn2zOhwNICiUUW0GgV
         U1wsWBWW4JNMSkMKPM1sbK+AHaM6KDDrUq98BuGYwgbF7OYP2TJZvzvLvs4UCIu9EmoX
         aK8hKBze0scL52eJ63yBe+YktNLC3dRNtPjq9RenSrKrP/GlthiZdNtKw8xJSXZfho1F
         cei8+285B5Bqh7nIaJu9CfFsWmb/N6LWyRQB9sduQwweLTdPg84LGEI4igBkOtSZy06j
         qgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/Twg3K4gp+yGHpRxWybK7U//bFNhuubvyWg25c1dXUA=;
        b=NqEUegxPZY+RzM8/tfqicDS4m24wXUsHCVaA43HXCx9qyDt+WXBR0+yLE0BaLUWT0M
         +PYUF4+i3cXH3JD6FXjtblMU7PX40+vIfssdDU8NjjNvSjdcy+V1L3g26gjS4mF4G7kt
         yklmXwFHjL3ZvDpqaNFkASGIHs2RzaYFbjDQ8tWMXwK9SXNNKfy9mWWpw7ymxtRXmXiQ
         3etxImObW1bCMMosV0X1Ygd9+JZLfTsKuok8tqRihBRy21IbrIKB22zTaSdSEmrwpX2I
         zl3+tADwXgRR81wYp03S9AdYJckxSqTzalXjdRNG7p39bPy5Bc4e+ncSPxoBWZBEluhY
         iMDQ==
X-Gm-Message-State: AOAM530/8PQmvp5SeH6w2ShPlCeyKzQI52lCbof6Byv+16DXIrczE6JJ
        kaK4O9Ohq72MAn4SKYKmfj2XvRH6P739nQ==
X-Google-Smtp-Source: ABdhPJw+wQW5MK+6oVivNcDSO/mJgzoT4+thkQFYhWLzXbm1PJO9hCHq9u3cAAseI4Oi5526qLOwkg==
X-Received: by 2002:a65:62d1:: with SMTP id m17mr18013771pgv.370.1633480874547;
        Tue, 05 Oct 2021 17:41:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o16sm18276979pgv.29.2021.10.05.17.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 17:41:13 -0700 (PDT)
Date:   Wed, 6 Oct 2021 00:41:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Colin King <colin.king@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] KVM: x86: Fix allocation sizeof argument
Message-ID: <YVzwpjSmGuVczgEG@google.com>
References: <20211001110106.15056-1-colin.king@canonical.com>
 <YVxyNgyyxA7EnvJb@google.com>
 <CAD=HUj7t0qRbpzXDs4EZDeLUK=cTTCAxSbh8V0FUCMzpq7rNFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=HUj7t0qRbpzXDs4EZDeLUK=cTTCAxSbh8V0FUCMzpq7rNFg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 06, 2021, David Stevens wrote:
> On Wed, Oct 6, 2021 at 12:41 AM Sean Christopherson <seanjc@google.com> wrote:
> > Hrm, this fails to free the gfn_track allocations for previous memslots.  The
> > on-demand rmaps code has the exact same bug (it frees rmaps for previous lpages
> > in the _current_ slot, but does not free previous slots).
> >
> > And having two separate flows (and flags) for rmaps vs. gfn_track is pointless,
> > and means we have to maintain two near-identical copies of non-obvious code.
> 
> I agree that's better than my patch. I can put together a new patch
> once it's decided whether or not my patch should be dropped.

All yours, unless Paolo wants to fight you for it :-)  I'm totally ok doing
cleanup/fixes on top.
