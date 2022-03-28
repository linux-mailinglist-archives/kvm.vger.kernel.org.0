Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB02E4EA17D
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 22:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345889AbiC1UbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 16:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344909AbiC1UbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 16:31:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AD366ADC
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:29:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so577560pjf.1
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y3E8E72DVNg1bqj4CzNhc0bBStIOE5d2ucw0gPcv3Rc=;
        b=WipcGv9hde/oJ3ORSV4+OdyvEgRrWVgjCbig0MhgOYm6vGxPzSpYYgLR2gc6cWbpd8
         hRiY7eH3+mwCTIvxv5bJZls6Zx7WgEIdzpihAVIUwftuZWFEVy0xUggZNUdvXP8Q6bQ9
         ZbPIJZW+dV9kaBOsAnGv3sy33QQRD6LHpVAhCPDW5ywzfUc+qLUUSGeFR3D8xREN0Pb8
         AA9vtlt1q2WV1GHTeDhKxjm85Xm6ukv0vFCQxqP3ggYo72M4Pufg1DJeVZmQ5c84fFCe
         RyqK2XMVw06HQH20fW5f6bo5LVFCR5dUZ6G+wdHzcctz0sOsOEDu9VzHwWMikWl+Qs9f
         y0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y3E8E72DVNg1bqj4CzNhc0bBStIOE5d2ucw0gPcv3Rc=;
        b=3E+xJ2HnjXjKOmJIypD9AW3e2EjYPI/Yz3+RrJEGRVOzkdEM7ukT4yojD1pM79Vrya
         ztcuzB5509MtLRZfWnuDqkyv3sfudHaFLvxiMQr/BmC3jQ/jjj8sRKuQZSDL9tza+O8N
         V9S5z0DAe+YHxCaK7w0t7aU5oAU8B08rIEN7f42wSrBUSMxg1tXP1E6wQE9Xi6gSRIcl
         0286twa6EVohLHU/XKVxhgZk3Dc0pILTPd875hWsyfr2KsuPnPvabW70V9FG6LQ/KCS4
         fy+5fyet+bZVDBR5VjLahkSiwIwECQkXeTW4iPrIdqD23+1NtwTVidAyXHkGnIJjzi3g
         TlCg==
X-Gm-Message-State: AOAM532+a4RP50YPIi79NaCglJ6Ng7rzGop1z7HuL/XiVvayaZJT5btv
        ol8PGBJ1AWrdBhLEgts2hTT1Cg==
X-Google-Smtp-Source: ABdhPJxkp0YfTQcf/frk44PWH7Oi5+shmKIumFaBIy+gRO2pJecS3YJisLpzFwAmLcmIbqeVdmIQiA==
X-Received: by 2002:a17:90b:4f86:b0:1c6:b3eb:99a3 with SMTP id qe6-20020a17090b4f8600b001c6b3eb99a3mr926796pjb.66.1648499349457;
        Mon, 28 Mar 2022 13:29:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm16868200pfj.128.2022.03.28.13.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 13:29:08 -0700 (PDT)
Date:   Mon, 28 Mar 2022 20:29:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Speed up slot_rmap_walk_next for sparsely
 populated rmaps
Message-ID: <YkIakXAxkyJiO7iF@google.com>
References: <20220325233125.413634-1-vipinsh@google.com>
 <CALzav=e6W2VSp=btmqTpQJ=3bH+Bw3D8sLApkTTvMMKAnw_LAw@mail.gmail.com>
 <CAHVum0dOfJ5HuscNq0tA6BnUJK34v4CPCTkD4piHc7FObZOsng@mail.gmail.com>
 <b754fa0a-4f9e-1ea5-6c77-f2410b7f8456@redhat.com>
 <CAHVum0cynwp5Phx=v2LV33Hsa8viq0jpVLh0Q_ZtpUZVy6Lm9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0cynwp5Phx=v2LV33Hsa8viq0jpVLh0Q_ZtpUZVy6Lm9w@mail.gmail.com>
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

On Mon, Mar 28, 2022, Vipin Sharma wrote:
> Thank you David and Paolo, for checking this patch carefully. With
> hindsight, I should have explicitly mentioned adding "noinline" in my
> patch email.
> 
> On Sun, Mar 27, 2022 at 3:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 3/26/22 01:31, Vipin Sharma wrote:
> > >>> -static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
> > >>> +static noinline void
> > >>
> > >> What is the reason to add noinline?
> > >
> > > My understanding is that since this method is called from
> > > __always_inline methods, noinline will avoid gcc inlining the
> > > slot_rmap_walk_next in those functions and generate smaller code.
> > >
> >
> > Iterators are written in such a way that it's way more beneficial to
> > inline them.  After inlining, compilers replace the aggregates (in this
> > case, struct slot_rmap_walk_iterator) with one variable per field and
> > that in turn enables a lot of optimizations, so the iterators should
> > actually be always_inline if anything.
> >
> > For the same reason I'd guess the effect on the generated code should be
> > small (next time please include the output of "size mmu.o"), but should
> > still be there.  I'll do a quick check of the generated code and apply
> > the patch.
> 
> Yeah, I should have added the "size mmu.o" output. Here is what I have found:
> 
> size arch/x86/kvm/mmu/mmu.o
> 
> Without noinline:
>               text      data     bss       dec        hex filename
>           89938   15793      72  105803   19d4b arch/x86/kvm/mmu/mmu.o
> 
> With noinline:
>               text      data     bss        dec       hex filename
>           90058   15793      72  105923   19dc3 arch/x86/kvm/mmu/mmu.o
> 
> With noinline, increase in size = 120
> 
> Curiously, I also checked file size with "ls -l" command
> File size:
>         Without noinline: 1394272 bytes
>         With noinline: 1381216 bytes
> 
> With noinline, decrease in size = 13056 bytes
> 
> I also disassembled mmu.o via "objdump -d" and found following
> Total lines in the generated assembly:
>         Without noinline: 23438
>         With noinline: 23393
> 
> With noinline, decrease in assembly code = 45
> 
> I can see in assembly code that there are multiple "call" operations
> in the "with noinline" object file, which is expected and has less
> lines of code compared to "without noinline". I am not sure why the
> size command is showing an increase in text segment for "with
> noinline" and what to infer with all of this data.

The most common takeaway from these types of exercises is that trying to be smarter
than the compiler is usually a fools errand.  Smaller code footprint doesn't
necessarily equate to better runtime performance.  And conversely, inlining may
not always be a win, which is why tagging static helpers (not in headers) with
"inline" is generally discouraged.

IMO, unless there's an explicit side effect we want (or want to avoid), we should
never use "noinline".  E.g. the VMX <insn>_error() handlers use noinline so that
KVM only WARNs once per failure of instruction type, and fxregs_fixup() uses it
to keep the stack size manageable.
