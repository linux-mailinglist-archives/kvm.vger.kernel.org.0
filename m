Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9B03F35C6
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 22:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbhHTUy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 16:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhHTUy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 16:54:26 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4393C061756
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 13:53:48 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id f22so2527765qkm.5
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 13:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJhLGr0SS5PF10n3fxhzHZmG/BsOEa6vMnDsgK0F/eg=;
        b=qZHhOVfvqTDAs7Vxag262xjADvDjb6zDTWSLRTNLV6o2zdtMNDZ0PdrNxaCWpc+A0e
         sc+C8RAHPVLMlgW1NkTt9qSzA4VewGqhNLepjU+SRJgQcjXSBZu/uC9cjhJ+baFUaLrI
         8LyoMpMISdMlhgvNhD0FKspuDm82mfQs3hEatzgP1MLHKLT7IcinBW+r74VWOuwI0iBD
         TN64Y51MT+g/7I+DeyavLOiqtkt/MAPa6qOEfduxISn/LRMlnX0zyOXU7cVhvdNKG4zM
         ynaObzoRfBaliJDsBG/LJyYdIoCcmJc5YyV71/LGWvBjW7JsmZzQuMnwBWxr/7vjLA5y
         s1Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJhLGr0SS5PF10n3fxhzHZmG/BsOEa6vMnDsgK0F/eg=;
        b=BTlYPKlrVzArn20ooES2ejiL3mY2qZv2mQcxFQTsf6LYtKSPgDj32xSkEzg52bBLFH
         3wQuU8F7KxAjaG+vY0YK7VTSLW5lUZAaO4bJWkcqc00mXiZZTOn4elQ+0PZCpDJegJn9
         4m1GE5ReSbA6NDmgNJVGy5Gxfa8e+6gdSHobM3z4f7n+/gTdJL5XiMKidF26/PNVcU08
         vJRInu4rKMxwedS8Gm+NR+btRdlFqkzDLl1YG3/+nhRdjmrB2inU+1oWy9t4xSWLWGQ0
         VzLMvD+gpZSUyX8hv3bUSQSfg6EaVDKRFHNB7kSyzojVbKbIg+7Cg+AMQa73IiNlOONW
         /i+Q==
X-Gm-Message-State: AOAM533PagO0Z9J2Db0/i0HsFbC4ZzsFNLMjmc5xP9DQ3H5Oisehpqwo
        j8GwQQL2XPYt0u3yjwnt6t6iewv+Xpq/Z7Gmv/NJfA==
X-Google-Smtp-Source: ABdhPJwxBW3OBnIrJYoEMIdO7YZ0+CadUfOZepyRoPB/TnU2muM0Q2rFEDyd51YEPYBLcCDQV4enJa3GuMlvJ12oIkE=
X-Received: by 2002:a37:66d1:: with SMTP id a200mr10294551qkc.440.1629492827571;
 Fri, 20 Aug 2021 13:53:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210819154910.1064090-1-pgonda@google.com> <20210819154910.1064090-2-pgonda@google.com>
 <CAA03e5Gh0kJYHP1R3F7uh6x83LBFPp=af2xt7q3epgg+8XW53g@mail.gmail.com>
 <CAMkAt6oJcW3MHP3fod9RnRHCEYp-whdEtBTyfuqgFgATKa=3Hg@mail.gmail.com> <YR7iD6kdTUpWwwRn@google.com>
In-Reply-To: <YR7iD6kdTUpWwwRn@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 20 Aug 2021 13:53:36 -0700
Message-ID: <CAA03e5F62WEcs3PN6M9qGzW+wuufp+BjwDHcTt18yaB42RDYkA@mail.gmail.com>
Subject: Re: [PATCH 1/2 V4] KVM, SEV: Add support for SEV intra host migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 3:58 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Aug 19, 2021, Peter Gonda wrote:
> > > >
> > > > +static int svm_sev_lock_for_migration(struct kvm *kvm)
> > > > +{
> > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > +       int ret;
> > > > +
> > > > +       /*
> > > > +        * Bail if this VM is already involved in a migration to avoid deadlock
> > > > +        * between two VMs trying to migrate to/from each other.
> > > > +        */
> > > > +       spin_lock(&sev->migration_lock);
> > > > +       if (sev->migration_in_progress)
> > > > +               ret = -EBUSY;
> > > > +       else {
> > > > +               /*
> > > > +                * Otherwise indicate VM is migrating and take the KVM lock.
> > > > +                */
> > > > +               sev->migration_in_progress = true;
> > > > +               mutex_lock(&kvm->lock);
>
> Deadlock aside, mutex_lock() can sleep, which is not allowed while holding a
> spinlock, i.e. this patch does not work.  That's my suggestion did the crazy
> dance of "acquiring" a flag.
>
> What I don't know is why on earth I suggested a global spinlock, a simple atomic
> should work, e.g.
>
>                 if (atomic_cmpxchg_acquire(&sev->migration_in_progress, 0, 1))
>                         return -EBUSY;
>
>                 mutex_lock(&kvm->lock);
>
> and on the backend...
>
>                 mutex_unlock(&kvm->lock);
>
>                 atomic_set_release(&sev->migration_in_progress, 0);

+1 to replacing the spin lock with an atomic flag. Correctness issues
aside, I think it's also cleaner. Also, I'd suggest adding a comment
to source code to explain that the `migration_in_progress` flag is to
prevent deadlock due to the "double migration" discussed previously.
