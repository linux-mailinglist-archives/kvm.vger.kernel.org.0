Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C6054CBFE
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbiFOO66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiFOO6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:58:42 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD9C340D6
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:58:40 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id w20so19320205lfa.11
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5WjwBxoG8hcN2wNzdX82aRVBrLb67GAEmI1dQxMZy0=;
        b=r4gnFG1k9OgfmQ7EP/1Y+kdN2g5zJ3GOyFpW2D2CfDDrt/w87w3TdP8K++zTRXmZ1O
         BUsJ3h/tq/C3iprUij5d3WqyvOGMw/I5Nw2LzaFWW8Kk0jJmwkKplMI+l41JN3y5PSh4
         fnlFCyTAhS1yp+NaBsuAeFVDg+5EuG0LyQq5/dUn8T7aUi5OZPsYHQCp1xCWXpUZPDXd
         rJIptAm7vdcpJ/0G+qLHiC/f1LoLW2Sc6al5aQ3TJyiMG5BWUbqQ6aJ5ktnFyy06b9xI
         vu0WMbDHRbaiTdW1pIt4zXGO7csAzT3AsR+uTXqQIKxq3R7RPeMvVGoqtPSHqpYKJYto
         cxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5WjwBxoG8hcN2wNzdX82aRVBrLb67GAEmI1dQxMZy0=;
        b=GcXTsFeCy7GfmASxqOkMVXCfyCQJHaMruXKUcJywz2FNlzoZug3fi2fvf9oWvFNrFO
         +AzyoB6FzUnGb0gbV6bdL0hL1ORjkd5QLk6GKq2CJn2SB6RVORfNqDD5gkyUuSfyCT7Q
         7wNpOEwfwS6AWn1hCPFFTBudltxQAPzkB7Ne95i3d+4Uxk6+50wiF7oaIK9GuZqOo0K9
         Rp7oX6mTUq32dc7aGRCrG3xA4E1drrPPuK/jKXvGgtqXMrWbhZ29Zdv6mp0bQOulPSLC
         QO9trx1H4um5MFh69lssoKMFzZwc7g+6fIRvrw3RKnEiHXidMrb7QRJBG9NX06XJX9lh
         6R9g==
X-Gm-Message-State: AJIora+FF7XfxXRmYmumy1NsPsDTNmiiRMv2/8RfN8EABMrgeaocvyGw
        k08hdh7rF9Mi/UPfJkK1T1Uk3ToI0msKzg8wngbY2g==
X-Google-Smtp-Source: AGRyM1tsa7MGR5pQIMXjpltWXkrdU447D/S/FlKYW140feHY76B0SAzLsFd6ea6D8NUxYt63ZdD7D4DNCzgzKnVlH+0=
X-Received: by 2002:a05:6512:ba6:b0:47d:a6e3:ab37 with SMTP id
 b38-20020a0565120ba600b0047da6e3ab37mr6168253lfv.157.1655305118992; Wed, 15
 Jun 2022 07:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220614021141.1101486-1-sashal@kernel.org> <CAG48ez1bRMCUzmkP2zpQ_4Jx0sqRw=b9-sDa-0QSqoGHpqZVJA@mail.gmail.com>
In-Reply-To: <CAG48ez1bRMCUzmkP2zpQ_4Jx0sqRw=b9-sDa-0QSqoGHpqZVJA@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 15 Jun 2022 16:58:02 +0200
Message-ID: <CAG48ez3nxe32Hv3dXO27_rK3qrSGZUW8Pp1sxLDxwKWkL1BaoQ@mail.gmail.com>
Subject: Re: [PATCH MANUALSEL 5.15 1/4] KVM: x86: do not report a vCPU as
 preempted outside instruction boundaries
To:     Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 4:53 PM Jann Horn <jannh@google.com> wrote:
>
> On Tue, Jun 14, 2022 at 4:11 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Paolo Bonzini <pbonzini@redhat.com>
> >
> > [ Upstream commit 6cd88243c7e03845a450795e134b488fc2afb736 ]
> >
> > If a vCPU is outside guest mode and is scheduled out, it might be in the
> > process of making a memory access.  A problem occurs if another vCPU uses
> > the PV TLB flush feature during the period when the vCPU is scheduled
> > out, and a virtual address has already been translated but has not yet
> > been accessed, because this is equivalent to using a stale TLB entry.
> >
> > To avoid this, only report a vCPU as preempted if sure that the guest
> > is at an instruction boundary.  A rescheduling request will be delivered
> > to the host physical CPU as an external interrupt, so for simplicity
> > consider any vmexit *not* instruction boundary except for external
> > interrupts.
> >
> > It would in principle be okay to report the vCPU as preempted also
> > if it is sleeping in kvm_vcpu_block(): a TLB flush IPI will incur the
> > vmentry/vmexit overhead unnecessarily, and optimistic spinning is
> > also unlikely to succeed.  However, leave it for later because right
> > now kvm_vcpu_check_block() is doing memory accesses.  Even
> > though the TLB flush issue only applies to virtual memory address,
> > it's very much preferrable to be conservative.
> >
> > Reported-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> This feature was introduced in commit f38a7b75267f1f (first in 4.16).
> I think the fix has to be applied all the way back to there (so
> additionally to what you already did, it'd have to be added to 4.19,
> 5.4 and 5.10)?
>
> But it doesn't seem to apply cleanly to those older branches. Paolo,
> are you going to send stable backports of this?

Also, I think the same thing applies for "KVM: x86: do not set
st->preempted when going back to user space"?
