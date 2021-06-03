Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64EE39ABDF
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 22:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFCUhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 16:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCUhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 16:37:13 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AC4C06174A
        for <kvm@vger.kernel.org>; Thu,  3 Jun 2021 13:35:13 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id v27-20020a056830091bb02903cd67d40070so3934742ott.1
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 13:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t9xGNkcktSlF9kmlEuS8GcNEn+IOZ6s4YoIEwUCwV/M=;
        b=eQE+d+/kbXV8Atq1C+7kjrvp7Y1EMF5QaP8wrZEjF3l/EjiL4YPV8PkC2+culToXEX
         DgASp1WMO3dgdJ6l5VGG48P1KKiCBh4C6BrSrB5urMzFwBajVMy9CaLEFx6NFslP9F+u
         LZ6dMpyMmgO83LHuZuqqiZtwzzENk6BXZyd4JreCI59eZTwdukYB32VFo/q/zE34hl7o
         Gc3TSgXfcdxVezW8llFenxGu4I1IkuGRLZcMPKWt7hn3inzKd8dpP1E1L6GDeEo31X/2
         y6Te+4FlVXgzB7ixkkvLq/n9vCcPve2E3QMzwCxnUDhabBUHfcLtytmzp3UkR3kWEg7z
         BGgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t9xGNkcktSlF9kmlEuS8GcNEn+IOZ6s4YoIEwUCwV/M=;
        b=IMWSNjVbCGORx1LV64u+omHx8vMpUeto8qjDTfm3y87atL6gUrofWxV1Xc9d4GJ4O+
         VsVMZfxSary8eme5Hl+24xyyJc22h++/HsKnD6nX2SGjTJzsJBfqR14Fo9zZwlF3cmR8
         OAvV+aFRSw80R5tg1ntcxA0IC4SQYQZufb76a3h5PQIC4QaK+4hIqoWGpb5EIHkImAUK
         XYpGy4l8ccXEuan1rGN+mIs6Nxyg0wnSh96dzLPu0YmQ1hGerkNKsbX+KKGyunic2ty/
         rHfO4YmExMnhO3W8Aa9/68qUZOpIFZsmQj610aPpTYI73s9OlL/JcAnfZ2uSlURGH0f9
         u8Mw==
X-Gm-Message-State: AOAM533xb5sEdVYzDxX6cs2w67T0scKlBAb3WR7jmD3SYsaDyMO5SeAj
        ROBpTRP+O2NOA6UzyfCfYz716u3BsnXrbhN8njMcRw==
X-Google-Smtp-Source: ABdhPJy7ZgQraA6Me1tT2Or+VqNh/R3lrXcKuAXA7Mtnuz77OH/8o3lMB4FRAdEj5GNBP+GO+yWKkp4Ko7qLdqIs+sc=
X-Received: by 2002:a05:6830:2011:: with SMTP id e17mr915511otp.295.1622752512262;
 Thu, 03 Jun 2021 13:35:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210510144834.658457-1-aaronlewis@google.com> <20210510144834.658457-2-aaronlewis@google.com>
In-Reply-To: <20210510144834.658457-2-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Jun 2021 13:35:01 -0700
Message-ID: <CALMp9eQ_42r-S-JPD-n7oXEaeMRVZdUG1UQkYJkhmHCSUkjvrw@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 7:48 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add a fallback mechanism to the in-kernel instruction emulator that
> allows userspace the opportunity to process an instruction the emulator
> was unable to.  When the in-kernel instruction emulator fails to process
> an instruction it will either inject a #UD into the guest or exit to
> userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> not know how to proceed in an appropriate manner.  This feature lets
> userspace get involved to see if it can figure out a better path
> forward.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: David Edmondson <david.edmondson@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
