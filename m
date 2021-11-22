Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37F34594F5
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbhKVSuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbhKVSuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:50:10 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CF4C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:47:03 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 71so627194pgb.4
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PNl9qmCVto3KUe1CsXAVRN/v/7RApWzP2E7VF0W9lc8=;
        b=rVBvrXjxLAb1n/5LtIOr1nVP8HuXbXe7TAcAsYR2OuZ+ADxNq5z8iCPGFd1r/7ePgZ
         3MTur8u/7ePJ+HDVUss72WdlYPR2bXKoW7sPDwhq5H76TfmQ/TlxNFThnc+4FaBKSMgG
         BuhLBrXTI6DPG4HjeplQPNBoOa8bqspIvGeswwF7kMyXWmZOBBM8i+YweXXbY1I+X9RQ
         Y9gROaYeWbnkAZvslmsXcUm0tn5gPfmuiGOtJn/pjdIleRpwiRAk6MLQYLZRGhRT5/JM
         GrZFzdffyDr8u1pWw2Xf2kwwObj4YL1HiiGsxXQQwlgNooS6ehzLGScw6QygVBgUYalh
         ezTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PNl9qmCVto3KUe1CsXAVRN/v/7RApWzP2E7VF0W9lc8=;
        b=uasB/+cB/wmBOs2pPXRaGhpukm3mNMkeclLNFPhtpicXYYZU5rPHw3FmjH5VidqSNd
         YGnQXRUs58Wz+K7Rrj/QN28Yzy8J4odTq5KQA1bKj+cR9vFDM/yIjzkMispy4bDQNP04
         J/MLd0DYmanGd6mXkZLkRPoOD6bYLbzF4Mlws7sEg8xkXFSDvMGOxnonhYydZSKeuWUT
         2OA6H0Hq3yQfpBo3pXIj2nGVXI6EI0ppJKGaBIcxRP51rSwP4SP38Gaq4AkeB1yhnmgo
         1gqVef2KQg477rk8PfV/jMt6lIyhh2RRMKbZ9WNVXdBfoL6WAtEaUX0N+O1XFIfaYXQ0
         Wfrw==
X-Gm-Message-State: AOAM530NbxvnjqvldE+n2iVhCAqiEs6+OoJhF5hP+gOViIVyCzLl6a0K
        trZsRwEzf++7FWrBeR+zZ/wFLA==
X-Google-Smtp-Source: ABdhPJyFEL+xAkz6QQ0tjJRGP5U11T9ZqMvExyunio/Erp2Cdyi/pMCfKbuWHOvUD3yEk3Iicj2hvA==
X-Received: by 2002:a05:6a00:244d:b0:44d:c279:5155 with SMTP id d13-20020a056a00244d00b0044dc2795155mr45388090pfj.0.1637606822880;
        Mon, 22 Nov 2021 10:47:02 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c21sm9978151pfl.138.2021.11.22.10.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 10:47:02 -0800 (PST)
Date:   Mon, 22 Nov 2021 18:46:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 11/15] KVM: x86/MMU: Refactor vmx_get_mt_mask
Message-ID: <YZvloswO5g/o02V6@google.com>
References: <20211115234603.2908381-1-bgardon@google.com>
 <20211115234603.2908381-12-bgardon@google.com>
 <a1be97c6-6784-fd5f-74a8-85124f039530@redhat.com>
 <YZZxivgSeGH4wZnB@google.com>
 <942d487e-ba6b-9c60-e200-3590524137b9@redhat.com>
 <CANgfPd-_7tR9tSJg85-0wAG72454qeedovhBvbX6OS1YNRxvMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-_7tR9tSJg85-0wAG72454qeedovhBvbX6OS1YNRxvMw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Ben Gardon wrote:
> On Fri, Nov 19, 2021 at 1:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 11/18/21 16:30, Sean Christopherson wrote:
> > > If we really want to make this state per-vCPU, KVM would need to incorporate the
> > > CR0.CD and MTRR settings in kvm_mmu_page_role.  For MTRRs in particular, the worst
> > > case scenario is that every vCPU has different MTRR settings, which means that
> > > kvm_mmu_page_role would need to be expanded by 10 bits in order to track every
> > > possible vcpu_idx (currently capped at 1024).
> >
> > Yes, that's insanity.  I was also a bit skeptical about Ben's try_get_mt_mask callback,
> > but this would be much much worse.
> 
> Yeah, the implementation of that felt a bit kludgy to me too, but
> refactoring the handling of all those CR bits was way more complex
> than I wanted to handle in this patch set.
> I'd love to see some of those CR0 / MTRR settings be set on a VM basis
> and enforced as uniform across vCPUs.

Architecturally, we can't do that.  Even a perfectly well-behaved guest will have
(small) periods where the BSP has different settings than APs.  And it's technically
legal to have non-uniform MTRR and CR0.CD/NW configurations, even though no modern
BIOS/kernel does that.  Except for non-coherent DMA, it's a moot point because KVM
can simply ignore guest cacheability settings.

> Looking up vCPU 0 and basing things on that feels extra hacky though,
> especially if we're still not asserting uniformity of settings across
> vCPUs.

IMO, it's marginally less hacky than what KVM has today as it allows KVM's behavior
to be clearly and sanely stated, e.g. KVM uses vCPU0's cacheability settings when
mapping non-coherent DMA.  Compare that with today's behavior where the cacheability
settings depend on which vCPU first faulted in the address for a given MMU role and
instance of the associated root, and whether other vCPUs share an MMU role/root.

> If we need to track that state to accurately virtualize the hardware
> though, that would be unfortunate.
