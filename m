Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4617A474EB2
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 00:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhLNXpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 18:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbhLNXpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 18:45:18 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D636C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:45:18 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id p18so14825173plf.13
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LFIWXrhudzGmJHAnuVfONET3YfG5tuem416kroSKDJs=;
        b=KrnYpFfEfLeJgKgEamLir3HXlMJAR1nZu7iGEm/hcuNjm/fjGeNxUpHpTDaXWc+zGI
         PZXD88LKjB5KJX1NE1ZcjdMnJa89UDoqpJhcDGUTB5ii44UAMmL506rpOEArpU360Tql
         LWSIadOKbS1ozIn1sRI8qNz4fNZKnvBX/BFBtDb8UlfzSTegjAQk2GRxcpC21uhF1qow
         6BaxJESi1ASLnBI1C3balD+T2+XnR2daHFRJGCkgN+bt8Cpb57kEOrBu0rIJYfqy7c46
         U58Z1ThWtJe3oUhGBGLq8EA6zzUEcrjrQ0Me+hFSn/CoNYcpvFxEtArVI0vFJtOGGOOD
         3jEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LFIWXrhudzGmJHAnuVfONET3YfG5tuem416kroSKDJs=;
        b=xPlC2ap3TO/6+nx/fayOsMMXfPmcuGElMgiROQdAfp/WN+pH31SwIKtTpAtq1DDeBf
         Ztwv4GogXtcNre6bdNId4S5IdJFRojpUtabeJcYuxWsnPcIz/xg7h78FMBAWPKVRWPiI
         31Z14QgvXJ6/2DmeUbUSMFNptMWqvtrX81kL2qEEZeNqePjhoQ28D6uAtJ2Hq5hSNhh4
         iyPzOIqBSIndD/JrNzeEXVDEMyvKj99MEPqPPr4fC16VV8rmFJkgAZi0+F4OjzWzg3TN
         O/754wfe9O/CIh5zFpaOVHGC4S5YjPdgp5tR8s56jc0EBY1uMh8skVXwgGxTgkjK8r1P
         Rnww==
X-Gm-Message-State: AOAM531jUjEZb0y07VMrEvRd59GSoTEgjPMP1V/EVpOWo+UNjwtSJkrx
        5mHVNj1yitwGVQWq0Rqs9kuGmg==
X-Google-Smtp-Source: ABdhPJwr9ENILtdbmn5JPRBGq6/87lKw1+7XI7lrRltyqX3WlXwUi9WFyJqtm+yZG0mqjF+QVrjZyA==
X-Received: by 2002:a17:90b:3ecc:: with SMTP id rm12mr8691195pjb.75.1639525517550;
        Tue, 14 Dec 2021 15:45:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id rj8sm3549236pjb.0.2021.12.14.15.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 15:45:16 -0800 (PST)
Date:   Tue, 14 Dec 2021 23:45:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Subject: Re: [PATCH 10/28] KVM: x86/mmu: Allow yielding when zapping GFNs for
 defunct TDP MMU root
Message-ID: <YbksiTgVdzN0Z6Dn@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-11-seanjc@google.com>
 <CANgfPd_H3CZn_rFfEZoZ7Sa==Lnwt4tXSMsO+eg5d8q9n39BSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_H3CZn_rFfEZoZ7Sa==Lnwt4tXSMsO+eg5d8q9n39BSQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Ben Gardon wrote:
> On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Allow yielding when zapping SPTEs for a defunct TDP MMU root.  Yielding
> > is safe from a TDP perspective, as the root is unreachable.  The only
> > potential danger is putting a root from a non-preemptible context, and
> > KVM currently does not do so.
> >
> > Yield-unfriendly iteration uses for_each_tdp_mmu_root(), which doesn't
> > take a reference to each root (it requires mmu_lock be held for the
> > entire duration of the walk).
> >
> > tdp_mmu_next_root() is used only by the yield-friendly iterator.
> >
> > kvm_tdp_mmu_zap_invalidated_roots() is explicitly yield friendly.
> >
> > kvm_mmu_free_roots() => mmu_free_root_page() is a much bigger fan-out,
> > but is still yield-friendly in all call sites, as all callers can be
> > traced back to some combination of vcpu_run(), kvm_destroy_vm(), and/or
> > kvm_create_vm().
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
> I'm glad to see this fixed. I assume we don't usually hit this in
> testing because most of the teardown happens in the zap-all path when
> we unregister for MMU notifiers and actually deleting a fully
> populated root while the VM is running is pretty rare.

Another *sigh*.

AFAIK, the above analysis is 100% correct, but there's a subtle problem with
yielding while putting the last reference to a root.  If the mmu_notifier runs
in parallel, it (obviously) won't be able to get a reference to the root, and so
KVM will fail to ensure all references to an unmapped range are removed prior to
returning from the mmu_notifier.

But, I have a idea.  Instead of synchronously zapping the defunct root, mark it
invalid, set the refcount back to '1', and then use a helper kthread to do the
teardown.  Assuming there is exactly one helper, that would also address my
concerns with kvm_tdp_mmu_zap_invalidated_roots() being unsafe to call in parallel,
e.g. two zappers processing an invalid root would both put the last reference to
a root and trigger use-after-free of a different kind.
