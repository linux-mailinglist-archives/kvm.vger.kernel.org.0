Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D95F611C64
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 23:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJ1VZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 17:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiJ1VZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 17:25:16 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32BF53021
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 14:25:14 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-3321c2a8d4cso58470017b3.5
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 14:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k6L4CwrBQE2xvQ751kbdJWpzh7gTpOPSQMOkGlbikgw=;
        b=l7fpr1yhsW6NhS40mkohuWBFF5JtjMRX3m0KBkN4ePAVcTe8SnrS6qQh4J5grcCZuv
         DECdhKfx8pxRmAbuGYzPdZQUL52yZ4egasGm3eZ6liOO0MDx0cPOWqFz9VWvCGvyyAgU
         SdY8aOvGRi3VY02UA884rGnHSCXAJNGhJGTXEjp/t2frfaNVYns/BCvIWCDMYL6QCsQv
         qGJEZkYzPUMmsrl57AwuM7Y2uE/WXDRllDakbTwUeKwRBwUHertqnQxNkNBB3247lNJa
         xwwgptU+1smGjajGASTcqnkl/xDZKa0kmcJe2By77vuhPhisKgvfDkzqP2v0E2JUFBIh
         lw9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6L4CwrBQE2xvQ751kbdJWpzh7gTpOPSQMOkGlbikgw=;
        b=dxX7I0dMEAApvmS7gAQdL2dE2ZOP/AqtcOjlKX4009rrKBWXCDRIUoLNoQa1Am+MCa
         Xv0yQTOG3OW9rTRPB9t8ztj6v6c66AmjdOVU9VUdsa7gMpLJePHX/emELbY1W897Apx1
         0Z7jhR3pEaLFfZ59diZxM76fYNtde/8k1L/sNbpl1c5OgGaGurPhZenQB0O/pEQ3ZmlT
         F3PVnwszggbQJpdjy8mwADvqQRqXhYr+K22pxEUKSClTqON7SSe6nIqRK7Te1qv1JuP/
         +RCT88KD+pX2dTT0e+Nki0Oh7RiuZJQrR0ZO+yKu3xBK3o0a0cFqRuXGnM4yogVZHKqU
         y61g==
X-Gm-Message-State: ACrzQf3ZxTKrLvCBaCcSK3XvHJDZ2p6zvQa8x0j8PyJRKUYSberOodaZ
        2AS2fxm+vdOY5vr9sNqN44OQpCFWzSj/SpH8YIrI3g==
X-Google-Smtp-Source: AMsMyM6aNtflhaJekkGuR1eynUASo+BQ+cJEKFwRt8ipRwiXIm7K2IFl4AYVDoDTJXYgWDMJNT5OvwX4IToTCGcObb0=
X-Received: by 2002:a81:16c2:0:b0:36f:f574:4a49 with SMTP id
 185-20020a8116c2000000b0036ff5744a49mr1399741yww.111.1666992314085; Fri, 28
 Oct 2022 14:25:14 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200316.2221027-1-dmatlack@google.com> <7314b8f3-0bda-e52d-1134-02387815a6f8@redhat.com>
 <CALzav=e-gJ77LCo7HsL4X37B96njySebw8DGbPV_xcHbhaCBag@mail.gmail.com> <Y1xEggz1oeNObHuP@google.com>
In-Reply-To: <Y1xEggz1oeNObHuP@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 28 Oct 2022 14:24:48 -0700
Message-ID: <CALzav=dOxzbEkMpSfQxo3WawZmwasGyeKEh7AeUugsVsAUKk4w@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Do not recover NX Huge Pages when dirty
 logging is enabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 28, 2022 at 2:07 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 28, 2022, David Matlack wrote:
> > I'll experiment with a more accurate solution. i.e. have the recovery
> > worker lookup the memslot for each SP and check if it has dirty
> > logging enabled. Maybe the increase in CPU usage won't be as bad as I
> > thought.
>
> If you end up grabbing the memslot, use kvm_mmu_max_mapping_level() instead of
> checking only dirty logging.  The way KVM will avoid zapping shadow pages that
> could have been NX huge pages when they were created, but can no longer be NX huge
> pages due to something other than dirty logging, e.g. because the gfn is being
> shadow for nested TDP.

kvm_mmu_max_mapping_level() doesn't check if dirty logging is enabled
and does the unnecessary work of checking the host mapping level
(which requires knowing the pfn). I could refactor
kvm_mmu_hugepage_adjust() and kvm_mmu_max_mapping_level() though to
achieve what you suggest. Specifically, when recovering NX Huge Pages,
check if dirty logging is enabled and if a huge page is disallowed
(lpage_info_slot), and share that code with the fault handler.
