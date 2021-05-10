Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09A6379810
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 21:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhEJUA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 16:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhEJUA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 16:00:27 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA71C06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 12:59:22 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id q186so2680140ljq.8
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 12:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z3iJh2XmGP7LkEWrFxeTJh6BbwLsdzrCzxXMlURocYQ=;
        b=lv1c8f50xF9jqpc8vxaf3InOEokK44UCAOqI3N5+cVGgZytZk0XgUubCIIMD1VAhiu
         0NQFNlJoovN6HsnwBHK5iaB/N66Dh28LK7kNc1AGDy2qHG22honcnvRGYqze45gmjiyc
         iST+zZNWjk4GFR7f+PpOiaGksl+C278jMmelZ/VnvXyhoyx6OfMR7emluvTVOtpiFIi9
         Dy10/N4CMV/K+8Mrz+bBXyGBOHvd91cfpXDUFb6cAsrmiQYxZ66vUIfKZWKVA5vGHKlM
         vOZLqKbzIO2bo35VQpgQcIsfXFAVa/OKJ6kQvR1NOnPtio//+e1fGN610TwJR8EQXclQ
         Ch+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z3iJh2XmGP7LkEWrFxeTJh6BbwLsdzrCzxXMlURocYQ=;
        b=iennZ9gBcmjLtjXJQWESGc+6HTY7O/RvdCFfKy4FNc6hMiZlrB6jZyBMjdb5Ex5dpg
         v/g6CPteO4TunhXpWi/+IAfunNOQytQahTsn/6kyJHQfs3Vrf6FmGSuYQgGksIHWkYJX
         QbqHsi42fNXA+8R1u97ABy9+eOvUJ4uyOtFc1V0ArcBHpLDUGXopRXQhmsQYOx1jsJz4
         kolkgmLOqYYOfUXvHKH85BuCSD4tPb5G3JfaM1LQKii9LREBtoPAxC8RYRnE+gzp/bi6
         vJXl4lb6NBTI1gNmRgR0Qon7N+wWw7n0bHGXwUkLQI3aqvtK0q1L4V554/EYcwj9qVko
         kd+A==
X-Gm-Message-State: AOAM531PahEzPzf7PNiKTeAXAkSHaebYTanjAPKonMBrkd1vN08AgmYm
        atKF22mxoossVNAvt7ZNUCyt8uEsY4L61EvLMRJuJg==
X-Google-Smtp-Source: ABdhPJyddD8hG71EF83WGp0+f/zJPwwaOLbGtEtLDWhw+H5XOzY6vF/J4iRM6g4vhdjKpZ7aShSfJAErS6E5T+qwJAA=
X-Received: by 2002:a2e:8e62:: with SMTP id t2mr21396917ljk.20.1620676760311;
 Mon, 10 May 2021 12:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210430123822.13825-1-brijesh.singh@amd.com> <20210430123822.13825-33-brijesh.singh@amd.com>
 <CAMkAt6oYhRmqsKzDev3V5yMMePAR7ZzpEDRLadKhhCrb9Fq2=g@mail.gmail.com> <84f52e0e-b034-ebcf-e787-7ef9e3baae2f@amd.com>
In-Reply-To: <84f52e0e-b034-ebcf-e787-7ef9e3baae2f@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 10 May 2021 13:59:08 -0600
Message-ID: <CAMkAt6rfnjqPZHUqJM1r6GjnBMy-Gbw8VtGv4gd-G0Rjq+ALnQ@mail.gmail.com>
Subject: Re: [PATCH Part2 RFC v2 32/37] KVM: SVM: Add support to handle MSR
 based Page State Change VMGEXIT
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, jroedel@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, tony.luck@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 11:51 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> Hi Peter,
>
> On 5/10/21 12:30 PM, Peter Gonda wrote:
> >> +static int snp_make_page_shared(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
> >> +{
> >> +       struct rmpupdate val;
> >> +       int rc, rmp_level;
> >> +       struct rmpentry *e;
> >> +
> >> +       e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
> >> +       if (!e)
> >> +               return -EINVAL;
> >> +
> >> +       if (!rmpentry_assigned(e))
> >> +               return 0;
> >> +
> >> +       /* Log if the entry is validated */
> >> +       if (rmpentry_validated(e))
> >> +               pr_debug_ratelimited("Remove RMP entry for a validated gpa 0x%llx\n", gpa);
> >> +
> >> +       /*
> >> +        * Is the page part of an existing 2M RMP entry ? Split the 2MB into multiple
> >> +        * of 4K-page before making the memory shared.
> >> +        */
> >> +       if ((level == PG_LEVEL_4K) && (rmp_level == PG_LEVEL_2M)) {
> >> +               rc = snp_rmptable_psmash(vcpu, pfn);
> >> +               if (rc)
> >> +                       return rc;
> >> +       }
> >> +
> >> +       memset(&val, 0, sizeof(val));
> >> +       val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> > This is slightly different from Rev 2.00 of the GHCB spec. This
> > defaults to 2MB page sizes, when the spec says the only valid settings
> > for level are 0 -> 4k pages or 1 -> 2MB pages. Should this enforce the
> > same strictness as the spec?
>
>
> The caller of the snp_make_page_shared() must pass the x86 page level.
> We should reach here after all the guest provide value have passed
> through checks.
>
> The call sequence in this case should be:
>
> snp_handle_vmgexit_msr_protocol()
>
>  __snp_handle_page_state_change(vcpu, gfn_to_gpa(gfn), PG_LEVEL_4K)
>
>   snp_make_page_shared(..., level)
>
> Am I missing something  ?

Thanks Brijesh. I think my comment was misplaced. Looking at 33/37

+static unsigned long snp_handle_page_state_change(struct vcpu_svm
*svm, struct ghcb *ghcb)
+{
...
+ while (info->header.cur_entry <= info->header.end_entry) {
+ entry = &info->entry[info->header.cur_entry];
+ gpa = gfn_to_gpa(entry->gfn);
+ level = RMP_TO_X86_PG_LEVEL(entry->pagesize);
+ op = entry->operation;

This call to RMP_TO_X86_PG_LEVEL is not as strict as the spec. Is that OK?

>
> >> +       return rmpupdate(pfn_to_page(pfn), &val);
> >> +}
> >> +
> >> +static int snp_make_page_private(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
> >> +{
> >> +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> >> +       struct rmpupdate val;
> >> +       struct rmpentry *e;
> >> +       int rmp_level;
> >> +
> >> +       e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
> >> +       if (!e)
> >> +               return -EINVAL;
> >> +
> >> +       /* Log if the entry is validated */
> >> +       if (rmpentry_validated(e))
> >> +               pr_err_ratelimited("Asked to make a pre-validated gpa %llx private\n", gpa);
> >> +
> >> +       memset(&val, 0, sizeof(val));
> >> +       val.gpa = gpa;
> >> +       val.asid = sev->asid;
> >> +       val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> > Same comment as above.
>
> See my above response.
>
>
> >
> >> +       val.assigned = true;
> >> +
> >> +       return rmpupdate(pfn_to_page(pfn), &val);
> >> +}
