Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DE93D96FB
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 22:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhG1Uol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 16:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhG1Uol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 16:44:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF2BC061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 13:44:38 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z3so2881974plg.8
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 13:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JKhYNwVtUcp4ro2cn3vBpepmIsUitpS2N9O0Akilpxs=;
        b=TjRNT1lBPk9nMKLFJP4cYldUWDOJ85jWLeh7Fm6QUt+euyu2F9X+/9RhdzUaAaCk6c
         68wNsxdZrCHj9MPFrP1HymbrqMOHz+YW1bkHcj2b3ZvOZ4J3pGKpUWN8B7qaoxRb+DmC
         RPs0AegkISl8MzmjBNr7uM8kqWmkuDsEI4tuk4bRBjxQVntvR/zwCz6MyMWN+lxQM0sJ
         e3JRPxfoVMRzZLhjMfXyGIGAi3YTfTV9rWX3MCO2xwsbeCUxg7icDHuiOzfmfOL0Jqnr
         3JcZ1DvHH82smpwmExd9Bt7WUP0DN5GrgXX6TCvXuLcTllJj9sMR1Eyrg7zVplWQ4ONa
         tKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JKhYNwVtUcp4ro2cn3vBpepmIsUitpS2N9O0Akilpxs=;
        b=Y63/oByZgQ9UYO2akflnn1Kozg4BL3glO3pyMzDRVpxYKbKQjLPnJloJewcPpfAXpx
         rwHX+EQi705NvzU+ZSDArwLzuNZ3izvqGnTR4CGzkW6WVXARGmbaZYkgdtws862pZtK9
         0zNmcfrEcZT96CN3CJey0o+0t4cgOKiem4pvWPB8XmWjBKi0Pg7Hbm2ipiM6AxR+wP2B
         GviCf6S4C0t71oOBBmQBzcRBylfGyJsFUbayNcoj9NYFHq/DREhAmUCrlBBRZBSkWPM0
         ah232cpzYgNAuoVcT1RGH2jGGtcSBvZPHl88i+iIeofnqgjIHQpgbA1aZ3mC1AybGkG5
         kHYA==
X-Gm-Message-State: AOAM5331EClENkXdwJl1PIFWbFQYVXLOY7Z4pIKK4UpyqpnamrifX/G1
        8KdglCkHUQv9DuE3p9nckeTtCg==
X-Google-Smtp-Source: ABdhPJwDNqv6/oCIErCVMa6h8MNsSlG+xcG3LueWac7TWFNwnvzRDteRSi0D00QGsumG2dN8bfz86Q==
X-Received: by 2002:a63:4423:: with SMTP id r35mr685414pga.358.1627505077700;
        Wed, 28 Jul 2021 13:44:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id on9sm6637907pjb.47.2021.07.28.13.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 13:44:37 -0700 (PDT)
Date:   Wed, 28 Jul 2021 20:44:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 46/46] KVM: x86: Preserve guest's CR0.CD/NW on INIT
Message-ID: <YQHBsbHYayhSJOSz@google.com>
References: <20210713163324.627647-1-seanjc@google.com>
 <20210713163324.627647-47-seanjc@google.com>
 <CAAeT=FzGDUr8MK5Uf3jyUxtf+2jCf=bgG760L0mjjM3vRsXKSg@mail.gmail.com>
 <A41676B6-2E9F-4F8E-B91E-8F9A077A2FA8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A41676B6-2E9F-4F8E-B91E-8F9A077A2FA8@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021, Nadav Amit wrote:
> 
> > On Jul 19, 2021, at 9:37 PM, Reiji Watanabe <reijiw@google.com> wrote:
> > 
> > On Tue, Jul 13, 2021 at 9:35 AM Sean Christopherson <seanjc@google.com> wrote:
> >> 
> >> Preserve CR0.CD and CR0.NW on INIT instead of forcing them to '1', as
> >> defined by both Intel's SDM and AMD's APM.
> >> 
> >> Note, current versions of Intel's SDM are very poorly written with
> >> respect to INIT behavior.  Table 9-1. "IA-32 and Intel 64 Processor
> >> States Following Power-up, Reset, or INIT" quite clearly lists power-up,
> >> RESET, _and_ INIT as setting CR0=60000010H, i.e. CD/NW=1.  But the SDM
> >> then attempts to qualify CD/NW behavior in a footnote:
> >> 
> >>  2. The CD and NW flags are unchanged, bit 4 is set to 1, all other bits
> >>     are cleared.
> >> 
> >> Presumably that footnote is only meant for INIT, as the RESET case and
> >> especially the power-up case are rather non-sensical.  Another footnote
> >> all but confirms that:
> >> 
> >>  6. Internal caches are invalid after power-up and RESET, but left
> >>     unchanged with an INIT.
> >> 
> >> Bare metal testing shows that CD/NW are indeed preserved on INIT (someone
> >> else can hack their BIOS to check RESET and power-up :-D).
> >> 
> >> Reported-by: Reiji Watanabe <reijiw@google.com>
> >> Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > 
> > Thank you for the fix and checking the CD/NW with the bare metal testing.
> 
> Interesting.
> 
> Is there a kvm-unit-test to reproduce the issue by any chance?

No :-/
