Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56DD37960F
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhEJRgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhEJRg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:36:27 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FD2C061220
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:30:27 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id z9so24524060lfu.8
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VWGUpuUFEiRwS6iEGwvYVeEnSLAfGX83FWm14bOadMQ=;
        b=TryB5+5sCOw2p2JHDUFly6UFDPRMsWS1H2xS5cgcZ3qF4inIUjDfTRahdlci8khE8A
         vz8vU7LSssup2VmHDa2WFLFTGuHSbuijyjDAvp9Ca9d5m/O0j9UlcXbz9/2ZkB47E0zG
         LkUk86g5q0FucZtowbq6B8WA4FvdWESEyTHtJEpPil541JKffXO58kIuaml1l/9WuZQb
         f3Zaf8f9ds4hMRjdFLmdZ8bgP2a8Ne3ZrEKEPh4MxfODfSsEhNsD6jieZs/krJhjylKx
         86aTdMKJIxQuioORt2Z8NwNFZoZP0s6M4LQ5iN929RYBfzYz7pGa0IBQw40NrgYA8up7
         /ZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VWGUpuUFEiRwS6iEGwvYVeEnSLAfGX83FWm14bOadMQ=;
        b=pv5CKmkkr3jGVfnzp0xYPe8rlt2PqVKNPRvgOr17wq5AD1EwMZJV5cKblJwLmJoX1c
         oLw1aZhihqW4T+sYeC7SdP6iEP6JwGOxtQCEW6fr/gj5tZeLn9xsAjLxcOWx55R1lNHg
         4wxDM7zOQPsV9FHfGnNVqaMFVg8YB9xP0BRqGcTIBUTJoURyHll73woc5xxeQjbM0TBm
         uEQqFhexT6OkFUFFv/wz0hq5CIBiZulCkc9NjpZ36n5OpbtUQ9zoCSlOc07884tZEmbn
         EakjkQ5Srv2+JrcIOzHW4aqHmXQ4gdvvaDgKVRVt5z4EpOeLXWzYDY3qy2gXSBq7KmI8
         Yh2A==
X-Gm-Message-State: AOAM533aH0PCYicZ81atJUA+0GERMJd1TzfbUvbYyLnaaYS6t4rvKNTs
        h4AqZlazLzuV66ZjFVTbzn3fU3o9B1uGoNAdjfqgKQ==
X-Google-Smtp-Source: ABdhPJxiX95gH4ekENcRKooOjRHwORcRSYGwvXl6F0iPJKYVM1J+AG3el7/DWgEhG9Uo793ClAuoc+XxKze/1Gre5qE=
X-Received: by 2002:a05:6512:1084:: with SMTP id j4mr3698207lfg.423.1620667826078;
 Mon, 10 May 2021 10:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210430123822.13825-1-brijesh.singh@amd.com> <20210430123822.13825-33-brijesh.singh@amd.com>
In-Reply-To: <20210430123822.13825-33-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 10 May 2021 11:30:14 -0600
Message-ID: <CAMkAt6oYhRmqsKzDev3V5yMMePAR7ZzpEDRLadKhhCrb9Fq2=g@mail.gmail.com>
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

> +static int snp_make_page_shared(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
> +{
> +       struct rmpupdate val;
> +       int rc, rmp_level;
> +       struct rmpentry *e;
> +
> +       e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
> +       if (!e)
> +               return -EINVAL;
> +
> +       if (!rmpentry_assigned(e))
> +               return 0;
> +
> +       /* Log if the entry is validated */
> +       if (rmpentry_validated(e))
> +               pr_debug_ratelimited("Remove RMP entry for a validated gpa 0x%llx\n", gpa);
> +
> +       /*
> +        * Is the page part of an existing 2M RMP entry ? Split the 2MB into multiple
> +        * of 4K-page before making the memory shared.
> +        */
> +       if ((level == PG_LEVEL_4K) && (rmp_level == PG_LEVEL_2M)) {
> +               rc = snp_rmptable_psmash(vcpu, pfn);
> +               if (rc)
> +                       return rc;
> +       }
> +
> +       memset(&val, 0, sizeof(val));
> +       val.pagesize = X86_TO_RMP_PG_LEVEL(level);

This is slightly different from Rev 2.00 of the GHCB spec. This
defaults to 2MB page sizes, when the spec says the only valid settings
for level are 0 -> 4k pages or 1 -> 2MB pages. Should this enforce the
same strictness as the spec?

> +       return rmpupdate(pfn_to_page(pfn), &val);
> +}
> +
> +static int snp_make_page_private(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +       struct rmpupdate val;
> +       struct rmpentry *e;
> +       int rmp_level;
> +
> +       e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
> +       if (!e)
> +               return -EINVAL;
> +
> +       /* Log if the entry is validated */
> +       if (rmpentry_validated(e))
> +               pr_err_ratelimited("Asked to make a pre-validated gpa %llx private\n", gpa);
> +
> +       memset(&val, 0, sizeof(val));
> +       val.gpa = gpa;
> +       val.asid = sev->asid;
> +       val.pagesize = X86_TO_RMP_PG_LEVEL(level);

Same comment as above.

> +       val.assigned = true;
> +
> +       return rmpupdate(pfn_to_page(pfn), &val);
> +}
