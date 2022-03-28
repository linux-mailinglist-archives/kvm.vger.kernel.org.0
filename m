Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF9B4E9ADB
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 17:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiC1PX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 11:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbiC1PX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 11:23:56 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9BE36E2F
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 08:22:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m18so10127653plx.3
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 08:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=y4jeTiPmh1/itpZ2SuVLZQIg9+4PUK2a47pmdNYYEis=;
        b=L3pixW/Cy+d6kb+DaPDXJhFrNwxshMt65sz1EF/s5RgGdKGDS6g3aRLUqeTpR+o6cN
         NQTYRsGi6TiDyHWh3X1cKu6gfV8RkX24XKesUMuUqdnVP37QBORRNKM3ONBe3BP/jG8v
         Ritz/O+fzOW06bgdmIBc/WweczvT+/2m5trvzZddkpSl+G+Y3KrdMBRhv8WnCRlkJA/2
         VApy6Zjufznsyj7u+eWW6qTrM/+ymbIWgvHIOGtJLxclgDH0DFCHy4M5Y1claAyUXfb9
         rBGojNoUTT/aev1AkvpohsXSTyUvbFyNzYWxwUyt9Y7ybCOm93nQwbQV6kk/oAgHc7Q/
         jlvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=y4jeTiPmh1/itpZ2SuVLZQIg9+4PUK2a47pmdNYYEis=;
        b=T+3A3gHQ1NXA0Uu0aXeXkWQVnilN/vVHXGuTdli2Hw7SFwfHVV1CORTui/WqUs2tGO
         ShyjPC6ogLC8oOuyRNPAPoDZpP8DahNBVC+6B7jrYGeYD1Ys1KSI8bH1yhtsovMq8d2U
         4TmQjLlIamtdaPavQ4pb+mxnnbCebFxOWa2mciX7FvJMUNgK22g0VahGGVqgv0hbnFaB
         TyERpZ8ZbZqXNfi99Jqa+hu15+P2hz0Hf+vexJX/xAuNfky3vrowZ5ixIlHJviOkF/72
         kfIuZDLbdErG3H920l3sof6XcY6+iwo2MhY8l6L+LaDVptRPJ4qw8vd406C/z/7yd0/R
         TO0w==
X-Gm-Message-State: AOAM5307KkY7fcfHflOkvzfN/4p/LOzk+l5hkYYeoZhbUqsJ5sur4jYM
        CsBdhdpVZ2R3ZEGMUILZCpQCvA==
X-Google-Smtp-Source: ABdhPJwh98Nt+R5Qe2Lc1Z3eIP/trP/h2ooEjxCKyasqXlNIxP5pG+KKoPRjwFbVUbqLxRe9Xm5kEw==
X-Received: by 2002:a17:90b:4b0e:b0:1c6:f499:1cc9 with SMTP id lx14-20020a17090b4b0e00b001c6f4991cc9mr41573650pjb.133.1648480934928;
        Mon, 28 Mar 2022 08:22:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i67-20020a636d46000000b00398344a27cfsm4996038pgc.8.2022.03.28.08.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 08:22:14 -0700 (PDT)
Date:   Mon, 28 Mar 2022 15:22:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        syzbot <syzbot+6bde52d89cfdf9f61425@syzkaller.appspotmail.com>,
        david@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [syzbot] WARNING in kvm_mmu_notifier_invalidate_range_start (2)
Message-ID: <YkHSopxM7oGb1Nhc@google.com>
References: <000000000000b6df0f05dab7e92c@google.com>
 <33b6fb1d-b35c-faab-4737-01427c48d09d@redhat.com>
 <6730ea89-8d85-bf30-28e5-01ca7ebdacea@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6730ea89-8d85-bf30-28e5-01ca7ebdacea@oracle.com>
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

On Mon, Mar 21, 2022, Maciej S. Szmigiero wrote:
> On 21.03.2022 12:01, Paolo Bonzini wrote:
> > On 3/21/22 11:25, syzbot wrote:
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index 002eec83e91e..0e175aef536e 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -486,6 +486,9 @@ unsigned long move_page_tables(struct vm_area_struct
> >       pmd_t *old_pmd, *new_pmd;
> >       pud_t *old_pud, *new_pud;
> > 
> > +    if (!len)
> > +        return 0;
> > +
> >       old_end = old_addr + len;
> >       flush_cache_range(vma, old_addr, old_end);
> > 
> > but there are several other ways to fix this elsewhere in the call chain:
> > 
> > - check for old_len == 0 somewhere in mremap_to
> > 
> > - skip the call in __mmu_notifier_invalidate_range_start and
> >   __mmu_notifier_invalidate_range_end, if people agree not to play
> >   whack-a-mole with the callers of mmu_notifier_invalidate_range_*.
> > 
> > - remove the warning in KVM
> 
> This probably depends whether it is actually legal to call MMU notifiers
> with a zero range, the first time this warning triggered it was the caller
> that was fixed [1].
> 
> By the way, the warning-on-zero-range was added during memslots patch set
> review process [2], but I think it ultimately does make sense.

My vote is to play whack-a-mole.  This particular flavor isn't all that interesting,
but the HugeTLB bug was a genuine off-by-one error.  Given the low (so far) number
of unique reports, IMO the benefits of detecting buggy callers outweighs the cost of
having to fix/address benign paths where userspace is doing something silly.
