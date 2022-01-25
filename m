Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CFD49BADB
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 19:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358625AbiAYSBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 13:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386981AbiAYR75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 12:59:57 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0155CC061755
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 09:59:53 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id q22so9266374ljh.7
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 09:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lFjB3Wm/k6WQfraTITgg2GtwyUa0VJgZe+4Lv6O2Co4=;
        b=XC5zj1EbYhH7i02SUszkuxdEq0CFUvpTJK9gm5UwhigE44rfmwdE6x6nljyc4wBmr8
         +9gzi8AOlUFfPFKEFqIwj+klWB2qDZbQlAPOxGka+SkqcGN9CjTVC/vwS1V1i/oD0S3+
         S8hPQ3oIKDhd1uMCbsp5GLhly7UnWipGCxHLSRRYGY8TEOKQGZgJPMj5E+YcrG3H7ut5
         7mFlRRRHYV3rnD9QBRZtPiCyULiclVVv7bpi9AsacwAYK3p7HDPXTtboG07mH0LllT/Y
         nGLk5GMhdQNROjEBLCxP4tUiMaaqyA9Dy065MJcIDkpo5ihz6CFmqFHJiUd1/eegzCxE
         pVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lFjB3Wm/k6WQfraTITgg2GtwyUa0VJgZe+4Lv6O2Co4=;
        b=jNofIPRXw01nqpDqZUWmGKr5JRM1QfK/AqvLTNc4qf3w0IdoQq85UpbjYoNxDxyuoi
         wJymi+/8qw3Jy7czMT6cUi8ca6OpV7gCNIzsCzoYVHrTMns42ECJIT5Z4E9oKeFKYZZM
         1wN1zSvngnwKhPODU/saSMp5GgnoK9By14cXM3EyVvxaLkQUgHZ51sOkb8ZEFUiuEi8c
         3xt6zECH8R0z21I8f8Cma21oPDsaF39BMAk+CmrmEjMAfHLs6ODOWWeULkn24RcBemMw
         lHYF2hqTMtxmw+yiQMehqJYcIY2VBIzsWdmQ5sNAXXoF76JWQ5Fi0idkNRgjYs6l5YBt
         X86Q==
X-Gm-Message-State: AOAM530jPgUArC2l8Xhn+IR0DcDrJbeOCr4ztwgY+93U/kxbWbvFPlq8
        cVfwxg98tkYbncfmHfi6d58PHK1qeIAejYQftGSv3A==
X-Google-Smtp-Source: ABdhPJxQ9nD4vwnn29xZGWj3D6iRwIXJNsR5YJoMUhf3PKdCUcgDUmQUmPwG7N4/S9I9QoC2u/Aky+rHtMS1l9BwtgY=
X-Received: by 2002:a2e:8e73:: with SMTP id t19mr3579753ljk.132.1643133590805;
 Tue, 25 Jan 2022 09:59:50 -0800 (PST)
MIME-Version: 1.0
References: <20220118110621.62462-1-nikunj@amd.com> <20220118110621.62462-4-nikunj@amd.com>
 <CAMkAt6rxeGZ3SpF9UoSW0U5XWmTNe-iSMc5jgCmOLP587J03Aw@mail.gmail.com> <04698792-95b8-f5b6-5b2c-375806626de6@amd.com>
In-Reply-To: <04698792-95b8-f5b6-5b2c-375806626de6@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 25 Jan 2022 10:59:39 -0700
Message-ID: <CAMkAt6rCU3K-dk7edxa9iKrOZ0uh5442K0U5Fbux=js0q6qQ+g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 25, 2022 at 10:49 AM Nikunj A. Dadhania <nikunj@amd.com> wrote:
>
> Hi Peter
>
> On 1/25/2022 10:17 PM, Peter Gonda wrote:
> >> @@ -1637,8 +1627,6 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
> >>         src->handle = 0;
> >>         src->pages_locked = 0;
> >>         src->enc_context_owner = NULL;
> >> -
> >> -       list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
> > I think we need to move the pinned SPTE entries into the target, and
> > repin the pages in the target here. Otherwise the pages will be
> > unpinned when the source is cleaned up. Have you thought about how
> > this could be done?
> >
> I am testing migration with pinned_list, I see that all the guest pages are
> transferred/pinned on the other side during migration. I think that there is
> assumption that all private pages needs to be moved.
>
> QEMU: target/i386/sev.c:bool sev_is_gfn_in_unshared_region(unsigned long gfn)
>
> Will dig more on this.

The code you linked appears to be for a remote migration. This
function is for an "intra-host" migration meaning we are just moving
the VMs memory and state to a new userspace VMM on the same not an
entirely new host.

>
> Regards
> Nikunj
