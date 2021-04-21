Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A5C367150
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 19:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbhDUR3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 13:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239320AbhDUR3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 13:29:31 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454B1C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 10:28:58 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id k25so43159291oic.4
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 10:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w7rE49UxM7/OHX/aDG2Rhfv89OJM2v8ODxq3iaQLyvo=;
        b=OF5FhV7KzxvYiQlqjciKRfMbn65xojZddak4DP1NPJhUB0MfgRt3L7z6XMXWBy4uh5
         VAE8JV5MrhqQ0o+8h6IFDfPkOzZpIAiAcQZqi++Ntq9YTVeQN5rOlCmu/lsdu/FMYn5t
         NfuyFJjMM6MZx02WFnZ7Bz1OBXrwKoPbNYdpXOTE7ZTZpPdx7eZ92zfOGlC60Uew45qA
         nfIlgfmyO6dsSTgNTO+5ebvdrG92o7K4r33fRS3a3XbQWw1tOXpZrOIiu08AbzSrSRb7
         LMVntIVKwi00BMsMxN0L15mgzSrHu/7OBWCi3W7J07qg6SgcmgG2XNc7+QjgRVJiA3xn
         /1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w7rE49UxM7/OHX/aDG2Rhfv89OJM2v8ODxq3iaQLyvo=;
        b=F58dS6bD5hSoa6yskY/3QLTFzG3ewQwIVdEyoB0mBA0zSRSAng6K5W03zzrny8f5hG
         cwLrXK94DN92zebfKaJ8fP3Danj4LxWoQCqO6nNeQNHuH869XcMJweBEYU3KU9h0+9Gv
         UgBQeBzs/75hEDNMAFgNJyV/B9W3kp+LFwL0sS3wrRyyz5i9/jAWiRt1+/iztoIUz2oK
         1B3EluaPKyLRd7XrpeVvX5i1t2yhqKGxOXNCAENUPmA3FMbVkIlwhwxhwTJH7GQ3J6l6
         PUU3ux53Vmq9HlY2WFtDlEeDG3lYZ8LeIVX6uoPA23s+wMguWT5og6+lCXtmLH3olfrS
         zTbQ==
X-Gm-Message-State: AOAM5338zwbKZdobmwYAlW1uN84oQsNiymkFsqAWQrEJPob9uWNgFUwC
        vjvHuqSc0BSLF0ASWBvceQtxKwab7rFvf4/cv36a3g==
X-Google-Smtp-Source: ABdhPJwmBx2d3l76uA3zKdnmiUkqyJVda+wASDgBK3x7RX5nq6m6SEdx8OuyFmeFhVkhMOQPmFxNLupw56D58pf8+Ys=
X-Received: by 2002:aca:408b:: with SMTP id n133mr7620578oia.13.1619026137344;
 Wed, 21 Apr 2021 10:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <YH8eyGMC3A9+CKTo@google.com> <m2sg3kt4jc.fsf@dme.org> <CALMp9eQZLe_8esohDqt_0eLffOrAeC0vS1RSVw152z2RhmPntw@mail.gmail.com>
 <cunpmynfu6o.fsf@dme.org>
In-Reply-To: <cunpmynfu6o.fsf@dme.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Apr 2021 17:28:46 +0000
Message-ID: <CALMp9eTn3jiF8SDtTe9Wn7PSe2GZcjR1mVsHbU=QAxSR2AnPug@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
To:     David Edmondson <dme@dme.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 10:01 AM David Edmondson <dme@dme.org> wrote:
>
> On Wednesday, 2021-04-21 at 09:26:34 -07, Jim Mattson wrote:
>
> > On Wed, Apr 21, 2021 at 1:39 AM David Edmondson <dme@dme.org> wrote:
> >>
> >> On Tuesday, 2021-04-20 at 18:34:48 UTC, Sean Christopherson wrote:
> >>
> >> > On Fri, Apr 16, 2021, Aaron Lewis wrote:
> >> >> +                    KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> >> >> +            vcpu->run->emulation_failure.insn_size = insn_size;
> >> >> +            memcpy(vcpu->run->emulation_failure.insn_bytes,
> >> >> +                   ctxt->fetch.data, sizeof(ctxt->fetch.data));
> >> >
> >> > Doesn't truly matter, but I think it's less confusing to copy over insn_size
> >> > bytes.
> >
> >> And zero out the rest?
> >
> > Why zero? Since we're talking about an instruction stream, wouldn't
> > 0x90 make more sense than zero?
>
> I'm not sure if you are serious or not.
>
> Zero-ing out the rest was intended to be to avoid leaking any previous
> emulated instruction stream. If the user-level code wants to start
> looking for instructions after insn_bytes[insn_size], they get what they
> deserve.

If we limit the copy to insn_size bytes, the only leak is what was
already present in the vcpu->run structure before this, which may or
may not be a previous instruction stream, and which has been readable
by userspace all along.
