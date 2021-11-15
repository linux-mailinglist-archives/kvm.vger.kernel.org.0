Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C47452834
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243692AbhKPDHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244935AbhKPDHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:07:30 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA95C06120E
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:35:57 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so590033pjb.2
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t+zeUthCjwxIPtiqPuvHkjVJXWI02lrp3HVe/TTmMOM=;
        b=npoTfvZsyHR62144HIHzj1jI/1WdWaAajjPuelBpZnaPwbvplPx+mC8Kx0FExblInN
         Ii5mhcVJVekLichUGe6qpce5rTwI0F5OSzoKLCsq3TjE9YNuKMNOE1uiIyCozLwSmL2F
         kthi8i0r2Uz+QWF36+z8q128aAgKe9wN0ar9gxHqz8fr2AUBzpzoeK9yAAYwP4kG1lmI
         TgbY39G9n3Z2P2tsLqFwJDmQfMHGvU3PfgzbuzFh864dsJ6tIdDMrgekKqKc5XmPELTw
         OAzo2RHAblFZNnVxx/PdIiMQcBRRMOw/I0o9EXZjYpmSEQyRDetgJejE3mDHSXmOGMlK
         kSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t+zeUthCjwxIPtiqPuvHkjVJXWI02lrp3HVe/TTmMOM=;
        b=nQOYTpq8TrblFbzUnrC+StRzI8vBnAeAanBZogUxKK0X9g/AQgW+jsfTp8zE7n67qX
         SFpPeqFRpQtD2WEUR1tkm4MuxtTJHfekuOlzWFzi/WrlpJoTZZ8E10joQFlmaaN/ynVj
         G0Sfn23JM38q6bKMxWseY/upYIrCbJrU62m+2P4JNqrlQSqOytVSRqAyop69+/zgZ+Fn
         k2A0SzPl1NCTpytg7pw6Zji6ksqa5sgtVqOYI+CROYJO37lfSrtNQGAukb63k8NUV87E
         CiftVQ/c5K/4vfeZzwcuFvZw6B6wLywFU3mB27wVXxvjjfFz1Aj/jAx8GGP+jfmnM93d
         3A+A==
X-Gm-Message-State: AOAM533dhMduZjO0024p28WS35yaPmpRvK/zmUTZhdfwQdQJrEhqKXlA
        0Yq+FY+Nk4wiEGQ0mFzLQ/EiRg==
X-Google-Smtp-Source: ABdhPJxP8k37Yn+RVzY4mitYLWlpK3o6ksKluoDvGBw+s7bgUCaPyOflgd189QuPhvlSQHcJNw43Vg==
X-Received: by 2002:a17:902:d491:b0:142:892d:a89 with SMTP id c17-20020a170902d49100b00142892d0a89mr39125545plg.20.1637019356587;
        Mon, 15 Nov 2021 15:35:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g7sm12000240pfv.159.2021.11.15.15.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 15:35:56 -0800 (PST)
Date:   Mon, 15 Nov 2021 23:35:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH 1/6] KVM: SEV: Disallow COPY_ENC_CONTEXT_FROM if target
 has created vCPUs
Message-ID: <YZLu2FcX4XdbiVBt@google.com>
References: <20211109215101.2211373-1-seanjc@google.com>
 <20211109215101.2211373-2-seanjc@google.com>
 <CAMkAt6qLVLsP6_0X_u+zdRT99rutphZ11y-1-hEUQ8KZOUU8tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6qLVLsP6_0X_u+zdRT99rutphZ11y-1-hEUQ8KZOUU8tA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021, Peter Gonda wrote:
> On Tue, Nov 9, 2021 at 2:53 PM Sean Christopherson <seanjc@google.com> wrote:
> > +       /*
> > +        * Disallow out-of-band SEV/SEV-ES init if the target is already an
> > +        * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
> > +        * created after SEV/SEV-ES initialization, e.g. to init intercepts.
> > +        */
> > +       if (sev_guest(kvm) || kvm->created_vcpus) {
> >                 ret = -EINVAL;
> >                 goto e_mirror_unlock;
> >         }
> 
> Now that we have some framework for running SEV related selftests, do
> you mind adding a regression test for this change?

Can do, will likely be a few days though.
