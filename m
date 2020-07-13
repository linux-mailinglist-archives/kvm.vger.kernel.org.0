Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F2F21E104
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 21:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgGMTzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 15:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGMTzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 15:55:00 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046F8C061755
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 12:55:00 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h22so19474753lji.9
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 12:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O0K0GAMN27LF3svfaFIhOLEn8RGlrbuLKuNu7ITbTf0=;
        b=fBT8peuW3lGyxIZIiJFzFmk/qzmfbpMsz0//bIlgTttgYQD22hMLfAAC6hngpFXtUI
         aXq+NbaMeO7AeDU9Vtvz5cSjWqQ+l1kaXgVTOZu9PdK5bhM9GWLYfDUsJ68cwjJBU4vo
         xlGUOMlbo3tnlaeVMejcFNXTaMV4U4adMVUYseocIArhyCxXoDtccWAVH2K78+x4LE3i
         721l5DX6jEh6UMCHlPngGRdNQJinkEf5LyS96pzqXgP6uvvcBsCiUk4kpI++YpJGgf81
         KxKTffcgS/DIMBBzqodCQUyKz+5BPEyD4XghpuyTy+Gq3yp1O4Q2C1nAGrXQfqHBhpzI
         kDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O0K0GAMN27LF3svfaFIhOLEn8RGlrbuLKuNu7ITbTf0=;
        b=blcNY4rleiYGTy/Af2Orn04JrMj8h0jiHDRZ0cGXHzpRBwKFED2MvJHfbatLe+TyeQ
         6JXCCfUvabC0OTDgNGCdNLnibGVgpOMaEiRjGRnYGlCmVd8QIbW6MnLdQ5Q3ttVYjcmC
         e9PnAYYYHFIpL8+Sq79/cnWFqnxIBZ+t4XRZZqwokSz9zPiqxvXHPR9TowFja8vho2I+
         4Sw7+3mCaBwJRYJyxr1az8/X24ii6HUfybWUyedvcHkTLJOYyc0UiQ0zjLmzP9crhGyu
         7NbMLJM4f0EyTD9NctaF/zH6PzN6DuWzYsx/BsOAbxDTfBcpyvd6vRfR6HGEiOOGdCap
         6a8A==
X-Gm-Message-State: AOAM530UaRx7quqYG0LSx5E1ScS/nvlwCoUqtnpIJ0katb07tWpfyKaK
        0JO2908X6K6xiXQDUdLdhKwpnInJRcq0fjZW7nS5Hg==
X-Google-Smtp-Source: ABdhPJy+rqlEMokxtkgQNOclspDUVMKn/gJAkVsFMXqnyDaBt7xhGnJ6fvdQOS2jvtDbE09wbVfZ63aXc79vrLAdAAQ=
X-Received: by 2002:a2e:91c9:: with SMTP id u9mr575751ljg.147.1594670098049;
 Mon, 13 Jul 2020 12:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200710200743.3992127-1-oupton@google.com> <61da813b-f74b-8227-d004-ccd17c72da70@redhat.com>
 <CALMp9eS1NB25OjVmAOLPEHu7eEMSJFy1FpYbXLSSKwp0iDs_QA@mail.gmail.com> <35f1f26a-3d50-26b1-9c83-478da9017d59@redhat.com>
In-Reply-To: <35f1f26a-3d50-26b1-9c83-478da9017d59@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 13 Jul 2020 12:54:46 -0700
Message-ID: <CAOQ_Qsgic6ddYpabGskohOyCiiC45DKSYZLFSTsSimgqyfxSPA@mail.gmail.com>
Subject: Re: [PATCH 1/4] kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 3:40 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/07/20 00:09, Jim Mattson wrote:
> >>  But I have a fundamental question that isn't answered by either the
> >> test or the documentation: how should KVM_SET_TSC_OFFSET be used _in
> >> practice_ by a VMM?
> >
> > One could either omit IA32_TIME_STAMP_COUNTER from KVM_SET_MSRS, or
> > one could call KVM_SET_TSC_OFFSET after KVM_SET_MSRS. We do the
> > former.
>
> Other questions:
>
> 1) how do you handle non-synchronized TSC between source and destination?
>

On the source side we record a host TSC reading establishing the start
of migration, along with the TSC offsets. We recalculate new offsets
that compensate for the elapsed time + TSC difference between
source/target when restoring the VM.

> 2) how is KVM_REQ_MASTERCLOCK_UPDATE triggered, since that's the main
> function of the various heuristics?

We initialize all TSCs to 0 at VM creation, then restore offsets (if
any). Should the offsets be out of phase, we write a garbage value to
the TSC MSR to break the vCPU matching, then set the offset. Not the
most elegant solution, it'd be better if the {GET,SET}_TSC_OFFSET
ioctls instrumented this directly.

>
> Paolo
>
