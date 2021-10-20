Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602084348CA
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhJTKSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhJTKSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 06:18:20 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AC9C061746;
        Wed, 20 Oct 2021 03:16:06 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so5497043ote.8;
        Wed, 20 Oct 2021 03:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+NK7fxwngDHuRlH9Iqj7BGuivoeJsWjFfQKb/q5lgXk=;
        b=XVuPjfUn3lfaJFnUxzGiBNYWTsaLagROaN6SQ5u9Kj/kEPDJLLDlFyLLQquC4fO5jU
         LoiiTN09RpGM4UBQ60Pq4EmWOtnYdlVDkX8guMU38U2r6t9cw4KI/nqKdOsSHrd1Qj9q
         WPuQpcwiprFWKh9tu8ERmnu3bhR0H5//vNQZkjYd6H9nRxRM3x+6+wv4rH+BgOLmbHbc
         lgzDf7ZIBGJYzOxEHFuiPvIenSkF9Ru7HuKnj+FpRCYTZUD9nBW3P9X02tbu3+lohVG+
         kdkgsmsasBxsREYNmaFpJXchghER8lFHG30PFl5Xw9MIHnhbGCPhK2UeHEMWe0LmYG5T
         6trg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+NK7fxwngDHuRlH9Iqj7BGuivoeJsWjFfQKb/q5lgXk=;
        b=DVQnCUtJAFQQ0uoUYRRNGcUYYNsuVLcXWqCUjN8LBgzV5i/EcwdajIihRS40FtdrYy
         rBXxFn4qoBfsO8qTPk532dcFFp6tYGqK3/WwUcW72fQuf+kMxFRbcj6dLknyBZSClzld
         7w1su4pBB5IZfFeZZETc0VZ5E14tCED8mzOrRk2zlLx9DYbELU+/5MQwOa3v+uWBeWMT
         AiN55cIftHvxEGh5oJOHWYqnbowpUUwNuHrxvfzH7WbaLVILqNagFYYymiXrYLat8yJl
         NK3jWJ+ujaRaxse4kuGLdgDhZJ6m1B6G6PTXUha3BydikImmKzd/2F8SOQ3XxbO6JKnM
         MH8w==
X-Gm-Message-State: AOAM531/o+xhwpE9wRiHfhr3bTR/QVHs8nktTfrxLJDiAuEvxOEE7Q0e
        0SaMiE2wuMjqtVd4CI4CqsJHrfFnBH9r3DyzKhk=
X-Google-Smtp-Source: ABdhPJzHyTBKElHWIFn/8PiVUNEIsNHneTqB8PRxnwtDes3QjtpQP+mu7Qyuz9TxkDlFY59LfF2yzmG7x13iHphOoNU=
X-Received: by 2002:a9d:ea3:: with SMTP id 32mr9966465otj.0.1634724965703;
 Wed, 20 Oct 2021 03:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <1634719951-73285-1-git-send-email-wanpengli@tencent.com> <ead08efc-ab79-7646-3d19-6d808097f688@redhat.com>
In-Reply-To: <ead08efc-ab79-7646-3d19-6d808097f688@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Oct 2021 18:15:54 +0800
Message-ID: <CANRm+CyrAbmS5_oWptUT3jWNfCe-DE7+C2WiE+b2_2VzUPpAig@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: emulate: Don't inject #GP when emulating RDMPC if CR0.PE=0
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 at 17:02, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/10/21 10:52, Wanpeng Li wrote:
> > From: Wanpeng Li<wanpengli@tencent.com>
> >
> > SDM mentioned that we should #GP for rdpmc if ECX is not valid or
> > (CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1).
> >
> > Let's add the CR0.PE is 1 checking to rdpmc emulate, though this isn't
> > strictly necessary since it's impossible for CPL to be >0 if CR0.PE=0.
> >
> > Reviewed-by: Sean Christopherson<seanjc@google.com>
> > Signed-off-by: Wanpeng Li<wanpengli@tencent.com>
> > ---
> > v3 -> v4:
> >   * add comments instead of pseudocode
>
> No, the commit message was fine.  What I meant is there's no need to
> change the code.  Just add a comment about why CR0.PE isn't tested.

Just sent out a new version.

    Wanpeng
