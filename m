Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F025530AE09
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhBARhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbhBARhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 12:37:45 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B52C0613D6
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 09:37:05 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z21so12547920pgj.4
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 09:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=e3tLlamqi6EsHVI2NML0yw8IMYcpeNFO/sOLZ/Il4hQ=;
        b=iyRrXXzxgZFJhT+KMYt6Kuw+uzwHeh+0+EkgErubLCKnjEQw9Vik72Di9Ogu/Qh8y+
         CpQzhU0GHe17xOUwyUvlBjixXGD+IH/Arvv63Yonyvp3HHiG/iMB3Q9kdx0I0PvEu5yb
         gH9QtAUA+JXLDeIQts7wc/wkTLWiOjdSWBb0PCqe6evv4KXBFP+k0X6ilKl8l+qrD8DZ
         QOq1bdQmuo+9fAtlziV6ZV/ahvcdvkxSbwDEAQsU0BRn38+FCegdeMcoyNdnnGhQ2VKb
         dzc0V3ZK3QgA+aKeC9hrn2w4B1crU5u06JQvlQ2NSiinLNAASHIaiob2Sy+wWo7gmTRe
         B+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=e3tLlamqi6EsHVI2NML0yw8IMYcpeNFO/sOLZ/Il4hQ=;
        b=rMdPbdHKpptaYZFLGo6nlFyliGZMMhorvlW2ZMOu6QmXxEb5Sc9ujf3jmXE9aon3QQ
         9MySyQvOpWxnfCIUvncjLFZpJKY40nGDeyRzrbl0AE1HNjEMoMMAUPTTBjp3ocwoyXia
         o0Mflc7xrQ54HfZJLstsAeHc4BMjlIhCKouRDIn0PWAj2sviqcch/+3C5yXuwZ6IeXKl
         xoDpjssc7nCcfmUmc33UI+T6EoRHSXldNrNrJ1fMtzs6IHsM+6m142joYTPceRSWYXLG
         ZXuV0TiWV8JXljo7mQK1/rIXnipYKSdc7E01O9/d3cT+rczpdWst5zrfQks4zFbTIyjq
         Q6vQ==
X-Gm-Message-State: AOAM530eUgEboz/a6nA8ip6BbFHOlmBY3FWpjCY7CpBxGUPSaAyeKTLz
        gS4T5DESiU6ZkjawQ+xn8gvo6B4jtAl3iw==
X-Google-Smtp-Source: ABdhPJzXJTscogj6sdKLUOea1VrRG7owfCMyOVFziKIOgEM12lAm5hyJ1PaJ/GQS4SctTAhN96mMVA==
X-Received: by 2002:a62:8f96:0:b029:1b7:75a9:a8b7 with SMTP id n144-20020a628f960000b02901b775a9a8b7mr17694285pfd.28.1612201024719;
        Mon, 01 Feb 2021 09:37:04 -0800 (PST)
Received: from google.com ([2620:15c:f:10:829:fccd:80d7:796f])
        by smtp.gmail.com with ESMTPSA id y75sm18416329pfg.119.2021.02.01.09.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:37:04 -0800 (PST)
Date:   Mon, 1 Feb 2021 09:36:57 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even
 if tsx=off
Message-ID: <YBg8OcuPFhQjsz3w@google.com>
References: <20210129101912.1857809-1-pbonzini@redhat.com>
 <YBQ+peAEdX2h3tro@google.com>
 <37be5fb8-056f-8fba-3016-464634e069af@redhat.com>
 <618c5513-5092-f7cd-b47b-933936001180@redhat.com>
 <YBgugM03fsEiOxz1@google.com>
 <cac389ad-96b0-293e-f977-4e9c6d719dea@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cac389ad-96b0-293e-f977-4e9c6d719dea@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021, Paolo Bonzini wrote:
> On 01/02/21 17:38, Sean Christopherson wrote:
> > > > >      /*
> > > > >       * On TAA affected systems:
> > > > >       *      - nothing to do if TSX is disabled on the host.
> > > > >       *      - we emulate TSX_CTRL if present on the host.
> > > > >       *      This lets the guest use VERW to clear CPU buffers.
> > > > >       */
> > 
> > it says "nothing to do..." and then clears a
> > flag.  The other interpretation of "nothing to do... at runtime" is also wrong
> > as KVM emulates the MSR as a nop.
> > 
> > I guess I just find the whole comment more confusing than the code itself.
> 
> What about:
> 
> 
>         if (!boot_cpu_has(X86_FEATURE_RTM)) {
>                 /*
>                  * If RTM=0 because the kernel has disabled TSX, the host might
>                  * have TAA_NO or TSX_CTRL.  Clear TAA_NO (the guest sees RTM=0
>                  * and therefore knows that there cannot be TAA) but keep
>                  * TSX_CTRL: some buggy userspaces leave it set on tsx=on hosts,
>                  * and we want to allow migrating those guests to tsx=off hosts.
>                  */
>                 data &= ~ARCH_CAP_TAA_NO;
>         } else if (!boot_cpu_has_bug(X86_BUG_TAA)) {
>                 data |= ARCH_CAP_TAA_NO;
>         } else {
>                 /*
>                  * Nothing to do here; we emulate TSX_CTRL if present on the
>                  * host so the guest can choose between disabling TSX or
>                  * using VERW to clear CPU buffers.
>                  */
>         }

Awesome!  Thanks much!
