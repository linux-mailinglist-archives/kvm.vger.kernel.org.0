Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F2040B722
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 20:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhINSs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 14:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhINSs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 14:48:26 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A0CC061574
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 11:47:08 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id l18so366651lji.12
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 11:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xneKBAqlxDQOaEQA2mIeUw2gUAM26ROug0ElrNbX+h0=;
        b=TuDdYN4cnsSSFOCn87hQrwIkD0tYeX0OEGY4njPw6/N8hsqYRCnJoQn5HrrvBggKCZ
         W6rk3WH0WDGwuqDsaz9GACfK5KexEIiCtHhKOnYh8Br+ryj9GeMkEE7149dq4dnK3cIl
         GbVEJRbPmRwk4SLpXi+RkqYqyL1hyQTaqUurDApBFcJLxsrBR7hApABvkc3UaCDvSzh+
         5F2/KooFPD5xBwSaY3AVEEKTH6nQi4uqcgCpJgH2X+rLU92nyGWkMXk1eLUt9cMkdBrK
         ArfbXDAvCJsvymf71frMuSeWg965yxWA2dSq3R0jwrxcIq7nyWCEnheuRuWF4opRf7H7
         B1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xneKBAqlxDQOaEQA2mIeUw2gUAM26ROug0ElrNbX+h0=;
        b=LycBaroOiYYrSZJu3jjcgLPBBiAmDP+gj2N2aTom+Cld7LK5afR3Y8UR1kur7swKg6
         OMuTsnIwongi817hcOZHehKCJcJFdJhcgWwKbTGHOQeVRzf/JcqacKosiXy//CVLuySf
         4ssN2WXZUHqi0lLhC8xpUoEosp+koAX79rW1YOptvsp9NZdplQGGxCOwUqVtoct4tuwX
         xz2Kiyv7bUJtfAU9xb9iO7IRAolci5LyPfa2cYu6+OrAZdr/UsmKxu5Af0tIOXMUIZWy
         uC2M0iPX8X10s219Cm4bKEpFjG34WB7pGBKpQLF8GsJRdFt4jbyAzHRX3TBSIF3Y7NXB
         0/MQ==
X-Gm-Message-State: AOAM5331/C+NQq5BRRU6rOuaWPs55LZM/ZxJy7Wi7LBQKqBnR0lLbvLs
        l6jzkfGURofJTX4L4K2IZfoB1XlOoxG2cqykMfohWQ==
X-Google-Smtp-Source: ABdhPJx9TkD1ztkZNFs9nsgve+eEPbsWeqzhntnMC3qtvaAvap01tmmXJNUa9dmDhdqMx7AA06qafNYkSZKIF/HTOAw=
X-Received: by 2002:a05:651c:54c:: with SMTP id q12mr17453992ljp.369.1631645226425;
 Tue, 14 Sep 2021 11:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210914171551.3223715-1-pgonda@google.com> <YUDcvRB3/QOXSi8H@google.com>
 <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com> <YUDsy4W0/FeIEJDr@google.com>
In-Reply-To: <YUDsy4W0/FeIEJDr@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 14 Sep 2021 12:46:54 -0600
Message-ID: <CAMkAt6r9W=bTzLkojjAuc5VpwJnSzg7+JUp=rnK-jO88hSKmxw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for SEV-ES
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021 at 12:41 PM Sean Christopherson <seanjc@google.com> wrote:
>
> -stable, for giggles
>
> On Tue, Sep 14, 2021, Peter Gonda wrote:
> > On Tue, Sep 14, 2021 at 11:32 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Sep 14, 2021, Peter Gonda wrote:
> > > > Copying an ASID into new vCPUs will not work for SEV-ES since the vCPUs
> > > > VMSAs need to be setup and measured before SEV_LAUNCH_FINISH. Return an
> > > > error if a users tries to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM from an
> > > > SEV-ES guest.
> > >
> > > What happens if userspace does KVM_CAP_VM_COPY_ENC_CONTEXT_FROM before the source
> > > has created vCPUs, i.e. before it has done SEV_LAUNCH_FINISH?
> >
> > That's not enough. If you wanted to be able to mirror SEV-ES you'd
> > also need to call LAUNCH_UPDATE_VMSA on the mirror's vCPUs before
> > SEV_LAUNCH_FINISH. That is do-able but I was writing a small change to
> > fix this bug. If mirroring of SEV-ES is wanted it's a much bigger
> > change.
>
> Is it doable without KVM updates?  If so, then outright rejection may not be the
> correct behavior.

I do not think so. You cannot call KVM_SEV_LAUNCH_UPDATE_VMSA on the
mirror because svm_mem_enc_op() blocks calls from the mirror. So
either you have to update vmsa from the mirror or have the original VM
read through its mirror's vCPUs when calling
KVM_SEV_LAUNCH_UPDATE_VMSA. Not sure which way is better but I don't
see a way to do this without updating KVM.

>
> > > Might be worth noting that the destination cannot be an SEV guest, and therefore
> > > can't be an SEV-ES guest either.
> >
> > sev_guest() implies sev_es_guest() so I think this case is covered.
>
> Yes, I was suggesting calling that out in the changelog so that readers/reviewers
> don't worry about that case.
>
> > > Cc: stable@vger.kernel.org
>
> > Oops. I'll update in the V2 if needed. Added to this thread for now.
>
> FWIW, you don't actually need to Cc stable, just including it in the changelog is
> sufficient as the script automagic will pick it up when it hits Linus' tree.

Ack. I'll send out a V2 with updated changelog after we've settled on
the first issue.
