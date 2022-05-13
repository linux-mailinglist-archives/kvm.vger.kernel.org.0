Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7815352653B
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 16:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379553AbiEMOt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 10:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbiEMOty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 10:49:54 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF410A19C
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 07:49:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i24so7880215pfa.7
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 07:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h9qNNc7KmTxiSu7indN0sAScbimmSjieBJURsL+745I=;
        b=rpYMq81J4aID+QQaQNbyXclttNYEanHp98Nuj/07I6nvXdajqjM/9AvgeUvwnO8Ug4
         QlZnxFADFYATmXFZvlDm58zJofyb064iWMfloHCZtAaDuXqMlpR9/ejwNC2vD8ZZOw03
         xfS8PzkidmFM/SLaGtHTmW0xwB73IimfndGJ3UKhEX7im5095BA1XQrR2/q1/RsSnXEg
         AhKG/bmejJ/fMYa8EjKC1yRHIEt0wUbg1ya51z8YDlN6BZtt/2SQt3Y0ozNOwURutL8U
         VzWlu5Vs4KYph53wS0A7s1n3dPwIrhm+7p3l4Lw3LEOcNUmxBMWybJp6lHEQNgeIv4TA
         qOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h9qNNc7KmTxiSu7indN0sAScbimmSjieBJURsL+745I=;
        b=1nVH6aT8POx2w821Lpu3slLHCi/YRpHnvsbuKtEhDiuQMq+f/cIvtTCoi49Owoy/67
         LIFaY6QC6UBjjGEr/I7LTwJuXUrrKfiuUHKOH0kGxkE8PYe4YmDQHVzEGyt86zKKTZ9E
         AoQN3PlB3CODzIz2tVy/7PXdvYcm03kF+4/wuUxZUGVpldvPUgg9tmOw+LLqYx4NVbX9
         D+Drwb8PtNLnoZkE+TO/5qE0BJHfVTHjT8D7yPULAri6xK7xL4pWMG4VY9FpfYbyUHYT
         680/hM3B/Z4xVnaFpSchyxdMGg4RE0+15oPXfi2J316SUdqhgal2nYZBMJbDDMEfLKY3
         nFzw==
X-Gm-Message-State: AOAM530Zu0sQL8EiwOkzo88+tCO6merJ2GlQ4XvGPbZ+jQOiFCqxrxmk
        mqjn5xbJWlyZ23L6I/9BrKPUCQ==
X-Google-Smtp-Source: ABdhPJzDg2GUh+q4cr2s2KEFP1pJQmv2betNXqCDUG8UGWDCKL/icaB+hwvagQU6tIMaX0W+1WbIkA==
X-Received: by 2002:a62:7ccc:0:b0:510:4e07:79f3 with SMTP id x195-20020a627ccc000000b005104e0779f3mr5127515pfc.10.1652453392173;
        Fri, 13 May 2022 07:49:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p1-20020aa78601000000b00512ee8a74a9sm179349pfn.217.2022.05.13.07.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 07:49:51 -0700 (PDT)
Date:   Fri, 13 May 2022 14:49:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>
Subject: Re: [PATCH] KVM: SVM: Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak.
Message-ID: <Yn5wDPPbVUysR4SF@google.com>
References: <20220512202328.2453895-1-Ashish.Kalra@amd.com>
 <CAMkAt6ogEpWf7J-OhXrPNw8KojwuLxUwfP6B+A7zrRHpNeX3uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6ogEpWf7J-OhXrPNw8KojwuLxUwfP6B+A7zrRHpNeX3uA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 13, 2022, Peter Gonda wrote:
> On Thu, May 12, 2022 at 4:23 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > For some sev ioctl interfaces, the length parameter that is passed maybe
> > less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
> > that PSP firmware returns. In this case, kmalloc will allocate memory
> > that is the size of the input rather than the size of the data.
> > Since PSP firmware doesn't fully overwrite the allocated buffer, these
> > sev ioctl interface may return uninitialized kernel slab memory.
> >
> > Reported-by: Andy Nguyen <theflow@google.com>
> > Suggested-by: David Rientjes <rientjes@google.com>
> > Suggested-by: Peter Gonda <pgonda@google.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> 
> Can we just update all the kmalloc()s that buffers get given to the
> PSP? For instance doesn't sev_send_update_data() have an issue?
> Reading the PSP spec it seems like a user can call this ioctl with a
> large hdr_len and the PSP will only fill out what's actually required
> like in these fixed up cases? This is assuming the PSP is written to
> spec (and just the current version). I'd rather have all of these
> instances updated.

Agreed, the kernel should explicitly initialize any copy_to_user() to source and
never rely on the PSP to fill the entire blob unless there's an ironclad guarantee
the entire struct/blob will be written.  E.g. it's probably ok to skip zeroing
"data" in sev_ioctl_do_platform_status(), but even then it might be wortwhile as
defense-in-depth.

Looking through other copy_to_user() calls:

  - "blob" in sev_ioctl_do_pek_csr()
  - "id_blob" in sev_ioctl_do_get_id2()
  - "pdh_blob" and "cert_blob" in sev_ioctl_do_pdh_export()

The last one is probably fine since the copy length comes from the PSP, but it's
not like these ioctls are performance critical...

	/* If we query the length, FW responded with expected data. */
	input.cert_chain_len = data.cert_chain_len;
	input.pdh_cert_len = data.pdh_cert_len;
