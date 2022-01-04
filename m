Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29644847D4
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 19:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiADS0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 13:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbiADS0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 13:26:44 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E741C061761
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 10:26:44 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id o12so83663275lfk.1
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 10:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O5Ysnesytl8XIzmcJR4kL4cqjEHZkL7UyI3OBV+nQBM=;
        b=LfXc7yJhZdS43YbN6gmjjbp6kx/0470ztrwbR5aHbXEOmvymIM3KbYANQ1lKKOuZ9A
         JvN2ethn/9uqURPSjCnoVAtNTmN47kPoP+pF8jdbGw++mRF7qSeTMfmoOKMahYwsY9Ji
         vTgksCwMtKk5ljjn8jysJe6CqDl+7cFwyW1IKfl8NybJAOHzUXuHKqAOqJKr7IzKyWgY
         NGVBz/cZLvKos2ev0z1OFKSp3v22Tl5s2QwhULmT/Lm+/kacqLUeIdiKdBbIGWxOIy7b
         C5EujmsxmtDGHC1W2LxgO3IRj35Cb/scg/Nky3QX8x1LM529ie9D69mUD0D28GxwfGKJ
         bcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O5Ysnesytl8XIzmcJR4kL4cqjEHZkL7UyI3OBV+nQBM=;
        b=wTLkjR8xpOoqyNRkGTopDqhIigXMGieyMnXqTOk93fkLmY0KJiqgaXBKzQFxNM1oSC
         1dqkyC7cl1DrjMMfGK1KMuzOu/7f/fsUEvH/wxuiO6fBseOHpSpN69ZjsBGLo21/CL5Z
         mXV6yhoSBJNyYmMy6RGmfKk8b3KVJaDZXNyLhcgMj+LoomC7QI+0MU2ij8u1/A17/LQE
         MUvKgZJYx7IrHMxh+JGTOOYXiRBwUeftZ94tzz/hjet0gSpe2fxcW6wHX2gOuBmCieA4
         Z0VjrWODgh3ErYQuNEjAoxSkAnxbNUxZ17k2lzGWkVZiXXNfE+mhPAwxbmdyQ2vI5b0t
         RtPw==
X-Gm-Message-State: AOAM5328W0FmT7slcksPqf1nfvVGwcl34smH2eQfDS2wK8OkdFeGuE+P
        vjx7dnevMKieom3RZzbDn7grQ1W4icvNTkfTAQYKaA==
X-Google-Smtp-Source: ABdhPJxe1bzUjLR0pNgT5AJmnCg3tAC7MCGPoCYJi0693n9Nx8RN+8ZdqFs23AVbbNdzisWlKyg62S64HhOMVNqNfnE=
X-Received: by 2002:a05:6512:2003:: with SMTP id a3mr45602725lfb.518.1641320801987;
 Tue, 04 Jan 2022 10:26:41 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-5-dmatlack@google.com>
 <YdQiK2fbOfkQ77ku@xz-m1.local>
In-Reply-To: <YdQiK2fbOfkQ77ku@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 4 Jan 2022 10:26:15 -0800
Message-ID: <CALzav=dSHkEfA+G8EZO4tEdY7TXYB3DhxGb7Y=9ay_jC-S9Xpw@mail.gmail.com>
Subject: Re: [PATCH v1 04/13] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 4, 2022 at 2:32 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Dec 13, 2021 at 10:59:09PM +0000, David Matlack wrote:
> > +/*
> > + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> > + * spte pointing to the provided page table.
> > + *
> > + * @kvm: kvm instance
> > + * @iter: a tdp_iter instance currently on the SPTE that should be set
> > + * @sp: The new TDP page table to install.
> > + * @account_nx: True if this page table is being installed to split a
> > + *              non-executable huge page.
> > + *
> > + * Returns: True if the new page table was installed. False if spte being
> > + *          replaced changed, causing the atomic compare-exchange to fail.
> > + *          If this function returns false the sp will be freed before
>
> s/will/will not/?

Good catch. This comment is leftover from the RFC patch where it did
free the sp.

>
> > + *          returning.
> > + */
>
> --
> Peter Xu
>
