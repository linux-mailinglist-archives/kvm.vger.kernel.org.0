Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C15E473162
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 17:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbhLMQOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 11:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238112AbhLMQOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 11:14:53 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F127FC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 08:14:52 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so13752735pjb.1
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 08:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gbg5NBcU+Kt7bMbQGsll86R5wmp6wy+SeQg+HFeWQMU=;
        b=TJB7Qin1sYghSOjLKjmgWXT42aw2P6kr/Ngk6/01rj+e5fc9J/41emHTRKYiTKAl97
         4UdDM+CRlqfrxs83pyD4MZyXT7N4yCxrtyPTWelHc+qWbJ+wyynfDbefkniVjC5n3S3H
         i9UADEXlQGTY2Hu0t6wlKBJ2F8cY+XgR3sGrk5pZ7ZtAVBKQuNKWfBGtLzk+hlHdMEfE
         1H7RBK6Tt2xSf0cXBTNaAkQ5O21CPw9K8S6twCbacoqd1Py3lHo9KITAuLE2BNPtSxer
         jq9P6HomyxLMgBreghLJkw1cUhXVJGhZxNvzE3LtY+WZrFdYU1MJGhaUBShMzzXCvY5Q
         s4jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gbg5NBcU+Kt7bMbQGsll86R5wmp6wy+SeQg+HFeWQMU=;
        b=s+A9N9l1Ux9NTq19Ti7FC+X4pcPYVcS0WN2n6sh2LD7zWyulBlRS+QW/lNyWZMKCdu
         PKXYwKNEOUd+6BemWY4FMOepL+M8byxLegJIQVzmjFMjLeQkPfk/cbJXjX8mCYkKNThV
         ju7s1kbHH5OpB7P51UyaOd1L8Uxow8cuWcmIWHTU2inHFcmMjhFHufg+nyhgFfidxBLu
         xLBMtmBgoFG+lGSYzSxHWKkXXpF14XLtoB1HDonLG2MiXo13dagdRNC/ZhBXwNmydPnr
         5DrsCO7tOEMG5vNu0sUGXB9BvpOBY/n9agROlEVM5LlpDT5pml+OM8ZClCjpVELVv0QJ
         euPA==
X-Gm-Message-State: AOAM530t3oOjz3aDBWOfxLymjHCUHQz66o1+PObgRHpI7aClbj2LCAKT
        IqJPCgY9xJA1LTA9l68l0SHJeg==
X-Google-Smtp-Source: ABdhPJy6vkREUxeKHnjXtrwjlQx57ir/+wUT/CJQUc0NqX1mv/nKXQeOj95DPQ3+9dJ3w7LzBbvOFg==
X-Received: by 2002:a17:90b:3ec1:: with SMTP id rm1mr45400647pjb.171.1639412092238;
        Mon, 13 Dec 2021 08:14:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p15sm14262517pfo.143.2021.12.13.08.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 08:14:51 -0800 (PST)
Date:   Mon, 13 Dec 2021 16:14:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ignat Korchagin <ignat@cloudflare.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
Subject: Re: Potential bug in TDP MMU
Message-ID: <Ybdxd7QcJI71UpHm@google.com>
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com>
 <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com>
 <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
 <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
 <YbQPcsnpowmCP7G8@google.com>
 <501ebf09-dee3-6394-cda7-bf94c7b55695@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501ebf09-dee3-6394-cda7-bf94c7b55695@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 11, 2021, Paolo Bonzini wrote:
> On 12/11/21 03:39, Sean Christopherson wrote:
> > That means that KVM (a) is somehow losing track of a root, (b) isn't zapping all
> > SPTEs in kvm_mmu_zap_all(), or (c) is installing a SPTE after the mm has been released.
> > 
> > (a) is unlikely because kvm_tdp_mmu_get_vcpu_root_hpa() is the only way for a
> > vCPU to get a reference, and it holds mmu_lock for write, doesn't yield, and
> > either gets a root from the list or adds a root to the list.
> > 
> > (b) is unlikely because I would expect the fallout to be much larger and not
> > unique to your setup.
> 
> Hmm, I think it's kvm_mmu_zap_all() skipping invalidated roots.

That should be impossible.  kvm_mmu_zap_all_fast() invalidates those roots before
it completes, and all paths that lead to kvm_mmu_zap_all_fast() prevent
kvm_destroy_vm() from getting to mmu_notifier_unregister().

kvm_mmu_invalidate_mmio_sptes() and kvm_mmu_invalidate_zap_pages_in_memslot()
are reachable only via memslot update, which requires a reference to KVM and thus
prevents putting the last reference to to KVM.

set_nx_huge_pages() runs with kvm_lock held, which prevent kvm_destroy_vm() from
proceeding to mmu_notifier_unregister().

If your patch does make the problem go away, we have a bug somewhere else.

One other experiment that's probably worth trying at this point is running with
my zap and flush overhaul[*], which is based on commit 81d7c6659da0 ("KVM: VMX:
Remove vCPU from PI wakeup list before updating PID.NV").  I highly doubt it will
fix the issue, but I'm out of other ideas until one of us can reproduce the bug.

https://lore.kernel.org/all/20211120045046.3940942-1-seanjc@google.com/
