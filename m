Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21B83F2373
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbhHSW7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbhHSW7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:59:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404FFC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:58:31 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so8156218pje.0
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8y5LqE4GdIR929n9d9+ayleYuEU4gSh8xvm/xko1ui8=;
        b=QWHBI897Zpttl5mcDjfI+YVe6BFEYWDr3Gf2V50xV1oDU7WdDnAUuIZjAwDlKjl4zQ
         6wIl8/IbGUU2b4/RocsbAhkg+bTMeXlYlppcgxuc+J7YxEu0MPsoWPqx42u5qw1iWJzc
         XcGNJd7tx/UgjCAHtcF1YPw5XCR1UsQUAnnq8f4pFuOBPNJ/wWpuQT8lBXrdPZagcKBF
         0SNZX9fvVZJhKgXB8zTTsvEX9lzRlYeRgrzaprdGCqLkRy3FiaEXhYE+cwIbsC63M/0V
         skLtLERUzJVLzX3nx/Nfg96NMpbvOQEbJ7+7SMFfIlnXLpOnR4a+GjTaA8CCNeC3kfrn
         SQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8y5LqE4GdIR929n9d9+ayleYuEU4gSh8xvm/xko1ui8=;
        b=cDUy6nqY5IzyGKnyNpch3jZhbz+DTCIzkOGgKA9QnPQId8eWY3B7gkqKW16lBFbrJ4
         IGOD9xQXiTVH9YhYtE/NkCz41Vuw7H40kBQBlOv130cR5z8vhIMxxDv3qeCeREd9KIng
         ratlJqwDJ9liITITG7O0Q72GdMhv1su0pawiBpE7QPj/hTy//jS8D4o3987E6JKwvu6O
         R/FQ5n7rpP5WBuAdYRBi4FqpMIv2+NfSzFyojD1ByTcsBijyB7wP+MUS3ceN7wBqDfUg
         slGWyJVsE8M2MDetpEyODOwa8oylNPkiXavo42bjnlnlaI9WHwzhOffeYUZ1S8Z1r9he
         mS3A==
X-Gm-Message-State: AOAM530H+bylaQbDzvgYt8Rjj5sToV8Yq687KolCOE32G3eThHQlIQ8c
        egwHM/9ZTOaA9uIm5Lk0QFzwTA==
X-Google-Smtp-Source: ABdhPJxInDZ1rJn3rwONKayLNmeE6Uv2NWbacmzUYRzmxkkr3zLQLh2eWsOd3SEcDEdZDsO46uljjA==
X-Received: by 2002:a17:902:8c83:b029:129:17e5:a1cc with SMTP id t3-20020a1709028c83b029012917e5a1ccmr13710692plo.49.1629413910546;
        Thu, 19 Aug 2021 15:58:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j11sm4754203pfa.10.2021.08.19.15.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 15:58:30 -0700 (PDT)
Date:   Thu, 19 Aug 2021 22:58:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 V4] KVM, SEV: Add support for SEV intra host migration
Message-ID: <YR7iD6kdTUpWwwRn@google.com>
References: <20210819154910.1064090-1-pgonda@google.com>
 <20210819154910.1064090-2-pgonda@google.com>
 <CAA03e5Gh0kJYHP1R3F7uh6x83LBFPp=af2xt7q3epgg+8XW53g@mail.gmail.com>
 <CAMkAt6oJcW3MHP3fod9RnRHCEYp-whdEtBTyfuqgFgATKa=3Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6oJcW3MHP3fod9RnRHCEYp-whdEtBTyfuqgFgATKa=3Hg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021, Peter Gonda wrote:
> > >
> > > +static int svm_sev_lock_for_migration(struct kvm *kvm)
> > > +{
> > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > +       int ret;
> > > +
> > > +       /*
> > > +        * Bail if this VM is already involved in a migration to avoid deadlock
> > > +        * between two VMs trying to migrate to/from each other.
> > > +        */
> > > +       spin_lock(&sev->migration_lock);
> > > +       if (sev->migration_in_progress)
> > > +               ret = -EBUSY;
> > > +       else {
> > > +               /*
> > > +                * Otherwise indicate VM is migrating and take the KVM lock.
> > > +                */
> > > +               sev->migration_in_progress = true;
> > > +               mutex_lock(&kvm->lock);

Deadlock aside, mutex_lock() can sleep, which is not allowed while holding a
spinlock, i.e. this patch does not work.  That's my suggestion did the crazy
dance of "acquiring" a flag.

What I don't know is why on earth I suggested a global spinlock, a simple atomic
should work, e.g.

		if (atomic_cmpxchg_acquire(&sev->migration_in_progress, 0, 1))
			return -EBUSY;

		mutex_lock(&kvm->lock);

and on the backend...

		mutex_unlock(&kvm->lock); 

		atomic_set_release(&sev->migration_in_progress, 0);

> > > +               ret = 0;
> > > +       }
> > > +       spin_unlock(&sev->migration_lock);
> > > +
> > > +       return ret;
> > > +}
> > > +
> > > +static void svm_unlock_after_migration(struct kvm *kvm)
> > > +{
> > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > +
> > > +       mutex_unlock(&kvm->lock);
> > > +       WRITE_ONCE(sev->migration_in_progress, false);
> > > +}
> > > +
> >
> > This entire locking scheme seems over-complicated to me. Can we simply
> > rely on `migration_lock` and get rid of `migration_in_progress`? I was
> > chatting about these patches with Peter, while he worked on this new
> > version. But he mentioned that this locking scheme had been suggested
> > by Sean in a previous review. Sean: what do you think? My rationale
> > was that this is called via a VM-level ioctl. So serializing the
> > entire code path on `migration_lock` seems fine. But maybe I'm missing
> > something?
>
> 
> Marc I think that only having the spin lock could result in
> deadlocking. If userspace double migrated 2 VMs, A and B for
> discussion, A could grab VM_A.spin_lock then VM_A.kvm_mutex. Meanwhile
> B could grab VM_B.spin_lock and VM_B.kvm_mutex. Then A attempts to
> grab VM_B.spin_lock and we have a deadlock. If the same happens with
> the proposed scheme when A attempts to lock B, VM_B.spin_lock will be
> open but the bool will mark the VM under migration so A will unlock
> and bail. Sean originally proposed a global spin lock but I thought a
> per kvm_sev_info struct would also be safe.
 
Close.  The issue is taking kvm->lock from both VM_A and VM_B.  If userspace
double migrates we'll end up with lock ordering A->B and B-A, so we need a way
to guarantee one of those wins.  My proposed solution is to use a flag as a sort
of one-off "try lock" to detect a mean userspace.
