Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9176464CB90
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 14:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbiLNNsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 08:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbiLNNsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 08:48:08 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DC5264A6;
        Wed, 14 Dec 2022 05:48:07 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id w23so3338442ply.12;
        Wed, 14 Dec 2022 05:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/9eqK/hjcD9Lg4iWqN5uvayjQEDXlG4BGCPiAhKd3a0=;
        b=eA5yAh3ZPPNxHpT8QpRDYZ/AqfNsbAyuujrUszAcxrb6/+oCDIeFP0+ZwPduui0Olx
         URIe+QKJUx5OtGDzpgp3SXfJKk80DZgp26B2fFoCv8KI6NCn1gOLsLOTLJJ78s6MhWWL
         eGEy5Nuk8w2dab03gaS5d1ts+ZgJLMATwS3f+Ij9mXzhRr44wiSBp0IPq1jFS/kvYZDg
         sI/aK08w1535H1wYHwbuCvxJMNhtwdpoKCnMO3rkdmlBem9oHgtxlXwmJYtW79cP3Rk/
         rT8UkVN0TtHK5sWE+Ez0FJWdl0x9kTTKBgBW0g1qap+7Ap1SlFePaEgwXi1IDCJzXQFS
         1gdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/9eqK/hjcD9Lg4iWqN5uvayjQEDXlG4BGCPiAhKd3a0=;
        b=ZpoMiZFSalYl4Y8CcsHsBoZi7OGWEtVrPbWm2gGK9DbFdKK/g3eejOsEohL79BXtoN
         +oNEjuiEMdFUXzs4fym1lJ+i9JRHjyk0GFRjC6Y1OW4bSQMUGwCV+5cfd/orI+4LGhld
         0m8zyW44Mlq+UzrA6YI+2RYqKp76fLnYLZEb4bD2geFP5SlbgUtZiRpliD+UAVbcuzWH
         JqxD0fHfwilIHsvQ0mwdU53ZlqMzz6/jgL3GE0Xgq6q65vG9CcwP0Yl4k8ezfmkIDBE9
         G4fie515eph5d+AHOR1ogYV3Yg4L/HhXkXMvP2f1eRwNvqQkJsDdYP5p/Ob7z9vN8WtH
         SFwA==
X-Gm-Message-State: ANoB5plZ4uDM09XSfifDUrYPHivJR94HGaekL89uUa+ZGmRPeSFlxSwz
        ++UNSNbrUWF4G3UScRd2qmJ05M0QCT0d6NWWCTw=
X-Google-Smtp-Source: AA0mqf6/xeYTAzn0W0hCQ3NuFFAoqoh/wpWuE8inr+myqXC77shQEHVHPdVEZrwdBEe63GsOUW1ppr/1EUcrwTXfx+c=
X-Received: by 2002:a17:902:d510:b0:186:b137:4b42 with SMTP id
 b16-20020a170902d51000b00186b1374b42mr6292205plg.98.1671025686835; Wed, 14
 Dec 2022 05:48:06 -0800 (PST)
MIME-Version: 1.0
References: <20221212153205.3360-1-jiangshanlai@gmail.com> <20221212153205.3360-2-jiangshanlai@gmail.com>
 <Y5jAbS4kwRAdrWwM@google.com>
In-Reply-To: <Y5jAbS4kwRAdrWwM@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Wed, 14 Dec 2022 21:47:55 +0800
Message-ID: <CAJhGHyAksXZHO_BC391ax4rHgQLE=xWeZu6dxN60gSgGij+ZLg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86/mmu: Reduce the update to the spte in FNAME(sync_page)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

On Wed, Dec 14, 2022 at 2:12 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 12, 2022, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > Sometimes when the guest updates its pagetable, it adds only new gptes
> > to it without changing any existed one, so there is no point to update
> > the sptes for these existed gptes.
> >
> > Also when the sptes for these unchanged gptes are updated, the AD
> > bits are also removed since make_spte() is called with prefetch=true
> > which might result unneeded TLB flushing.
>
> If either of the proposed changes is kept, please move this to a separate patch.
> Skipping updates for PTEs with the same protections is separate logical change
> from skipping updates when making the SPTE writable.
>
> Actually, can't we just pass @prefetch=false to make_spte()?  FNAME(prefetch_invalid_gpte)
> has already verified the Accessed bit is set in the GPTE, so at least for guest
> correctness there's no need to access-track the SPTE.  Host page aging is already
> fuzzy so I don't think there are problems there.

FNAME(prefetch_invalid_gpte) has already verified the Accessed bit is set
in the GPTE and FNAME(protect_clean_gpte) has already verified the Dirty
bit is set in the GPTE.  These are only for guest AD bits.

And I don't think it is a good idea to pass @prefetch=false to make_spte(),
since the host might have cleared AD bit in the spte for aging or dirty-log,
The AD bits in the spte are better to be kept as before.

Though passing @prefetch=false would not cause any correctness problem
in the view of maintaining guest AD bits.

>
> > Do nothing if the permissions are unchanged or only write-access is
> > being added.
>
> I'm pretty sure skipping the "make writable" case is architecturally wrong.  On a
> #PF, any TLB entries for the faulting virtual address are required to be removed.
> That means KVM _must_ refresh the SPTE if a vCPU takes a !WRITABLE fault on an
> unsync page.  E.g. see kvm_inject_emulated_page_fault().

I might misunderstand what you meant or I failed to connect it with
the SDM properly.

I think there is no #PF here.

And even if the guest is requesting writable, the hypervisor is allowed to
set it non-writable and prepared to handle it in the ensuing write-fault.

Skipping to make it writable is a kind of lazy operation and considered
to be "the hypervisor doesn't grant the writable permission for a period
before next write-fault".

Thanks
Lai
