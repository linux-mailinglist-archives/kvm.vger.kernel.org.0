Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1BB40650C
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbhIJBXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbhIJBXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:23:18 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBE1C0612AC
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 18:16:08 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so131520otf.6
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 18:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cGAyUL8bp8BmihGQbVBB5Ud51RVhdqCDb2c9LcQm9Qk=;
        b=EzrrGCy8DmzpGQL1ZpWiLsC+VVQlDGA9wIY9fvS3uHzBRrbihpPVv0mLc8LrobN/MV
         S31Bg81HQmiNst71q25BlZIRh+1aeDmX2FhCgAX1ZKTRp9H/6nIl5k1UvDI5cnhtiNB+
         AEu+hMCWuB8s2IGeWIC3smZcljMRJOb22RzlwxpxRsrxIHPt2OyGVMjoNgtneyc+sz48
         A2abUpyeigP9ggBUTNYzzuMrMZrDW8cAOTIYZE24tgd7RdpdBZEG9LfQRRhb+4lw8PrW
         F8t9Y0PE/fR4rbuQ+XgvQyzUieVQ0gb64uMPXYTk14IAbwB4xyKS0geofNVPhDJ33OOj
         GuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cGAyUL8bp8BmihGQbVBB5Ud51RVhdqCDb2c9LcQm9Qk=;
        b=lUjWOF1cFvXGjZ+iIdGDIzurTCTe6cYnTCslGi+hccVSC7Hk9F5cR8A7F02rcglbAA
         Tv8FqMR8j5nMepuXz0fYn9Ivf0SLUC3cnWEeH0dWk2aolIW2C21XUhORtCjQc6mT37aW
         OZFxJvZbbndIrXK+iHSyTWaR45s82LVh5YY3eY0cIVMBhnedGd9cHRRgBDD/Mm7cMSpr
         aUghVWS3QCY9TQEHKlUWt5AzGu0HOxWiM+B6i7t4RmMrWlbBl2ANWD6kRry2Jcwa1jDL
         cvYuhCRJD/x6KVmZq7QGwu65KN6oZkZzW+RgcTXOdKzhIN1iUDsw1cHKAjdHSg5UsfKO
         9Zww==
X-Gm-Message-State: AOAM530ogOhVuq/8MqODgLPl4rJTIf4ayKjp4BSy7uy65zrDtz8arO8w
        I7j94Pk8l1gZjJ/OOQqOZaZ0tPT1vqUTPIqDy19tvw==
X-Google-Smtp-Source: ABdhPJyyEMT6Ic/FnBQyMKpWAY/Lq+ISrhC02XxfIvxVP7Cv6NywynWeAOwJXTle3byAGTkGxZ5QMj8QsaauFMK6IhE=
X-Received: by 2002:a05:6830:2b24:: with SMTP id l36mr2545318otv.25.1631236568003;
 Thu, 09 Sep 2021 18:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210902181751.252227-1-pgonda@google.com> <20210902181751.252227-2-pgonda@google.com>
 <YTqirwnu0rOcfDCq@google.com>
In-Reply-To: <YTqirwnu0rOcfDCq@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 9 Sep 2021 18:15:56 -0700
Message-ID: <CAA03e5Ek=puWCXc+cTi-XNe02RXJLY7Y6=cq1g-AyxEan_RG2A@mail.gmail.com>
Subject: Re: [PATCH 1/3 V7] KVM, SEV: Add support for SEV intra host migration
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

> > +     dst->asid = src->asid;
> > +     dst->misc_cg = src->misc_cg;
> > +     dst->handle = src->handle;
> > +     dst->pages_locked = src->pages_locked;
> > +
> > +     src->asid = 0;
> > +     src->active = false;
> > +     src->handle = 0;
> > +     src->pages_locked = 0;
> > +     src->misc_cg = NULL;
> > +
> > +     INIT_LIST_HEAD(&dst->regions_list);
> > +     list_replace_init(&src->regions_list, &dst->regions_list);
> > +}
> > +
> > +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
> > +{
> > +     struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> > +     struct file *source_kvm_file;
> > +     struct kvm *source_kvm;
> > +     int ret;
> > +
> > +     ret = svm_sev_lock_for_migration(kvm);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (!sev_guest(kvm) || sev_es_guest(kvm)) {
> > +             ret = -EINVAL;
> > +             pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");
>
> Linux generally doesn't log user errors to dmesg.  They can be helpful during
> development, but aren't actionable and thus are of limited use in production.

Ha. I had suggested adding the logs when I reviewed these patches
(maybe before Peter posted them publicly). My rationale is that if I'm
looking at a crash in production, and all I have is a stack trace and
the error code, then I can narrow the failure down to this function,
but once the function starts returning the same error code in multiple
places now it's non-trivial for me to deduce exactly which condition
caused the crash. Having these logs makes it trivial. However, if this
is not the preferred Linux style then so be it.
