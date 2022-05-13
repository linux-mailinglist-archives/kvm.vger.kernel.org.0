Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70F8526AF8
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377434AbiEMUJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344872AbiEMUJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:09:48 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F8C5A2ED
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:09:46 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 4so11491861ljw.11
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pjCREFqJlKd2e4ScgAkDgjCbWBN7JS6DRPvPR2eYjk4=;
        b=KwRkUDm8dsv90HT32n7Ztq64gzcZF/kbB6tGx1fdQXDKGZjG+GBVpWD5AOzmGAWnd/
         rerMc/t+Kt10xdfBUlOCSActjob6KhPB4oKiXD392qk8MZ0VHkJPsrHoE62OIQs8WWPS
         /woEZdsfOwomyd9Fj4W/PAgH+rT6NJIIckIrUocjf2DpBUF59s+U5V1ibDFxwg2y6ov9
         OeGsICg7lU+vGRU1tPMWBOEoNc1ZjfELi8R4AHlvwpLGgFLOkbyeGW1/JLSvi+nNgZEN
         /8aIvf0iAOF4sFr9xIkbwN/NITqEFAGVxG54VyVFuxs8n57P2CDyO5IBDUhTTRY2P6aB
         5vAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pjCREFqJlKd2e4ScgAkDgjCbWBN7JS6DRPvPR2eYjk4=;
        b=ngUeH0X36ybkmdV1sEpee7JbPU2PCqjvcqiinicjQFUjJk0IKBOG9lvlexXSjvSuGX
         Ff3QVWn5hQUlJ32iQeld56aetV8yw7SqcLv/p61fgbXCbQJ1yBUP4BeA4UZQGd0QvoOe
         RNyMUv51G3kzg64Srhb4DWKOtFAiPGAF0sHF7ze1gDPx3PIo8fPziJY8SUeTkPihWntH
         ejC8VV3zIhCflp6yAYQSB+IjYqkGwMwqMrlvVyG40ETERpJhOWMwbNARNwEW5DnKCun9
         voxBuMOk7L3OoQN59aYBlu4yoXG4CW5ejgHMtJTRTVP4L4OxTd7iZZokrudugLkhBMyn
         PLhA==
X-Gm-Message-State: AOAM531lphZihr4fpKzl1VRqfIHpDcz+jesONRr+VtphsY8RSIm3H1Zc
        gCFtsOpymAOskk/X0pWvQViE7SgWwze8qia7/UYFiw==
X-Google-Smtp-Source: ABdhPJyIQ/Fq8kEYsZT3oQ8B+jEEuHoR3rsMsbWkyrcVV8WZYv4O+PyJUttYpqpiFYm2/bU3XvQ8sVx8UJPsHb8eaQ8=
X-Received: by 2002:a05:651c:1508:b0:250:5b32:55d5 with SMTP id
 e8-20020a05651c150800b002505b3255d5mr4018224ljf.278.1652472584716; Fri, 13
 May 2022 13:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220512202328.2453895-1-Ashish.Kalra@amd.com>
 <CAMkAt6ogEpWf7J-OhXrPNw8KojwuLxUwfP6B+A7zrRHpNeX3uA@mail.gmail.com>
 <Yn5wDPPbVUysR4SF@google.com> <51219031-935d-8da4-7d8f-80073a79f794@amd.com>
In-Reply-To: <51219031-935d-8da4-7d8f-80073a79f794@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 13 May 2022 16:09:33 -0400
Message-ID: <CAMkAt6rSXdFzVg6-tk8Yv9uQJEJaHtcvBHTBmWyjMVCs4uq1uw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent
 kernel memory leak.
To:     Ashish Kalra <ashkalra@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>
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

On Fri, May 13, 2022 at 2:11 PM Ashish Kalra <ashkalra@amd.com> wrote:
>
> Hello Sean & Peter,
>
> On 5/13/22 14:49, Sean Christopherson wrote:
> > On Fri, May 13, 2022, Peter Gonda wrote:
> >> On Thu, May 12, 2022 at 4:23 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >>> From: Ashish Kalra <ashish.kalra@amd.com>
> >>>
> >>> For some sev ioctl interfaces, the length parameter that is passed maybe
> >>> less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
> >>> that PSP firmware returns. In this case, kmalloc will allocate memory
> >>> that is the size of the input rather than the size of the data.
> >>> Since PSP firmware doesn't fully overwrite the allocated buffer, these
> >>> sev ioctl interface may return uninitialized kernel slab memory.
> >>>
> >>> Reported-by: Andy Nguyen <theflow@google.com>
> >>> Suggested-by: David Rientjes <rientjes@google.com>
> >>> Suggested-by: Peter Gonda <pgonda@google.com>
> >>> Cc: kvm@vger.kernel.org
> >>> Cc: linux-kernel@vger.kernel.org
> >>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >>> ---
> >>>   arch/x86/kvm/svm/sev.c | 6 +++---
> >>>   1 file changed, 3 insertions(+), 3 deletions(-)
> >>>
> >> Can we just update all the kmalloc()s that buffers get given to the
> >> PSP? For instance doesn't sev_send_update_data() have an issue?
> >> Reading the PSP spec it seems like a user can call this ioctl with a
> >> large hdr_len and the PSP will only fill out what's actually required
> >> like in these fixed up cases? This is assuming the PSP is written to
> >> spec (and just the current version). I'd rather have all of these
> >> instances updated.
>
> Yes, this function is also vulnerable as it allocates the return buffer
> using kmalloc() and copies back to user the buffer sized as per the user
> provided length (and not the FW returned length), so it surely needs fixup.
>
> I will update all these instances to use kzalloc() instead of kmalloc().

Do we need the alloc_page() in __sev_dbg_encrypt_user() to have __GFP_ZERO too?


>
> > Agreed, the kernel should explicitly initialize any copy_to_user() to source and
> > never rely on the PSP to fill the entire blob unless there's an ironclad guarantee
> > the entire struct/blob will be written.  E.g. it's probably ok to skip zeroing
> > "data" in sev_ioctl_do_platform_status(), but even then it might be wortwhile as
> > defense-in-depth.
> >
> > Looking through other copy_to_user() calls:
> >
> >    - "blob" in sev_ioctl_do_pek_csr()
> >    - "id_blob" in sev_ioctl_do_get_id2()
> >    - "pdh_blob" and "cert_blob" in sev_ioctl_do_pdh_export()
>
> These functions are part of the ccp driver and a fix for them has
> already been sent upstream to linux-crypto@vger.kernel.org and
> linux-kernel@vger.kernel.org:
>
> [PATCH] crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent
> kernel memory leak
>
> Thanks,
>
> Ashish
>
> >
> > The last one is probably fine since the copy length comes from the PSP, but it's
> > not like these ioctls are performance critical...
> >
> >       /* If we query the length, FW responded with expected data. */
> >       input.cert_chain_len = data.cert_chain_len;
> >       input.pdh_cert_len = data.pdh_cert_len;
