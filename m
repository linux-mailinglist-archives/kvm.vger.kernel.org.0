Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC73C77B0
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 22:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhGMUQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 16:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbhGMUQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 16:16:03 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664C9C0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:13:12 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id a18so31837623ljk.6
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=euiefEzk8mTeEXe4b+xrYgYoRjWy4AZgIK0NfHWQQzY=;
        b=f3/XcZVE2NMeiY6ih5O52kTDCfLHjzpuTfJBCpCgGZamAJrHdECI2vw1aPCvj85xPW
         GPLJD9mFbQyPfKWlUL3z1d2IiBEfeuvFNrPcl5wfRwg6EWlrdaLa4v9wZ9GOmJ4VxWVI
         n68Gqak1aavAXeg2LaGOp4LZjxSUCNY2rIBUO+1hhyq9jP/kYmzSj76eTWuh+2j1jFSz
         /fmZWjXUzVH6tZdgLyA0XG78IhPkV2PefuU0PmnFa3Uk5Q0e6Qaeo5XusHH+xealSh8a
         /DTI3MYAzeKRMimRNk+JNxEcRKDgSqrFqSINEGR3Jq1Vn7W+mAcudwgOEW3mbrmhc5R8
         RblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=euiefEzk8mTeEXe4b+xrYgYoRjWy4AZgIK0NfHWQQzY=;
        b=efOCmtgMqQPk1o79vhU/UxWnFv39bEDaVfkAzlDZlreHnLC76Rzmkbi99SUvY95tW3
         dGePCNeYBPIEBnqGi8u4zHUbHL6Xia/CXhSaJX5naWp19rRICUd/AMH0xFP6RRYReqCW
         Si1U8+jFi55NN5sNpgvarO4DC5pmRPLNRj3oG6PK6AE9lUvHDacjy8sJLwIK3slo2SJ0
         +3BpL15MTruNwfXmOjImVz+0RyGZYJVuuyA67mJn/SxEcVZIxchhEnuS/0PjoUhbFVj0
         S1LooR2tBicqLinb10cO1uhVfhKGsSKpLGDLY6rSFN08/SKXd8rVCGECBI0TTYC0SQEP
         coVQ==
X-Gm-Message-State: AOAM530HP4qKqKUSrtGlwCbDE7YKUPLdQWlNJAUbPq7q5YT3x5puxP98
        tJEFlwhWN7flBLWY7ObLLPWRP409OxoZtciHezWWXQ==
X-Google-Smtp-Source: ABdhPJyNecPrGapneKA1aOeM7OZOTvb3YKLrvCDt7UITwo7dlhUBX/NySFVBTXbe1XxtZKoE87yfxNJFq+FbvmNiPjE=
X-Received: by 2002:a2e:8110:: with SMTP id d16mr5731777ljg.42.1626207190335;
 Tue, 13 Jul 2021 13:13:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210621163118.1040170-1-pgonda@google.com> <20210621163118.1040170-3-pgonda@google.com>
 <3f4a1b67-f426-5101-1e07-9f948e529d34@amd.com>
In-Reply-To: <3f4a1b67-f426-5101-1e07-9f948e529d34@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 13 Jul 2021 14:12:58 -0600
Message-ID: <CAMkAt6oaxyEMSLkqPRHpL7uwj2ph9=wW8aeH4PP0FrbdGzx9+A@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM, SEV: Add support for SEV local migration
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     kvm list <kvm@vger.kernel.org>, Lars Bull <larsbull@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
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

Thanks for reviewing Brijesh! Seanjc@ said he would comment so I'll
lump your suggestions and his into the V2.

On Mon, Jul 12, 2021 at 3:09 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
>
> On 6/21/21 11:31 AM, Peter Gonda wrote:
>
> > +     if (!sev_guest(kvm))
> > +             return -ENOTTY;
> > +
> > +     if (sev->es_active)
> > +             return -EPERM;
> > +
> > +     if (sev->info_token != 0)
> > +             return -EEXIST;
> > +
> > +     if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> > +                        sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > +     if (!entry)
> > +             return -ENOMEM;
> > +
> > +     entry->asid = sev->asid;
> > +     entry->handle = sev->handle;
> > +     entry->pages_locked = sev->pages_locked;
> > +     entry->misc_cg = sev->misc_cg;
> > +
> > +     INIT_LIST_HEAD(&entry->regions_list);
> > +     list_replace_init(&sev->regions_list, &entry->regions_list);
>
> I believe the entry->regions_list will be NULL if the command is called
> before the memory regions are registered. The quesiton is, do you need
> to check whether for a valid sev->handle (i.e, LAUNCH_START is done)?

Makes sense to add a check for LAUNCH_START by checking sev->handle,
I'll add that in V2.

Would it also make sense to add similar checks to ioctls like launch
update, measure, and finish? If so I can send a separate patch to add
those checks.

>
>
> > +
> >   /* Userspace wants to query session length. */
> >   static int
> >   __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
> > @@ -1513,6 +1711,18 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >               goto out;
> >       }
> >
> > +     /*
> > +      * If this VM has started exporting its SEV contents to another VM,
> > +      * it's not allowed to do any more SEV operations that may modify the
> > +      * SEV state.
> > +      */
> > +     if (to_kvm_svm(kvm)->sev_info.info_token &&
> > +         sev_cmd.id != KVM_SEV_DBG_ENCRYPT &&
> > +         sev_cmd.id != KVM_SEV_DBG_DECRYPT) {
> > +             r = -EPERM;
> > +             goto out;
> > +     }
>
> Maybe move this check in a function so that it can later extended for
> SEV-SNP (cmd ids for the debug is different).
>
> Something like:
>
> static bool is_local_mig_active(struct kvm *)
> {
>         ....
> }

Will do!

>
> Once the migration range hypercall is merged, we also need to preserve
> any metadata memory maintained by KVM for the unencrypted ranges.

OK. Any suggestions on how to manage these impending conflicts. Are
those almost ready and I should build these patches on top of those or
what would you suggest?

>
> -Brijesh
