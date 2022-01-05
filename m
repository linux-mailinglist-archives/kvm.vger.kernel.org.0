Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088B14857A1
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 18:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242520AbiAERtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 12:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242516AbiAERtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 12:49:33 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABC6C061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 09:49:33 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id k21so90832518lfu.0
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 09:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=96jmeQugkiXuEjt+cvm/Lgp/1EQnyluP5VtBL0XRQLQ=;
        b=eRG3WglwCebunNb1c59a51ERKxJSHSZeZ47Tpo0KgVdQhAdafbBvx6GXWq1LlvK0/X
         buXIOqlmyGCWyZXL2CE2nJ3BXT0ORz82CCoaCJlwUC9JqAraobD9lRL6AezM0z6AoZ+J
         553sy0YaHA5z883mpm6NgKAQrJZ5N6ez/FkBC5SdY7FBNhFDHdHHGe8QH7CwqxDuSFeI
         mqcSO30qO/bglXR4GiC7Yry5rKBcAXExu0qpb8TAtV3NsO8ssZVtvw/I/bJJo6ykwn3f
         GurafyNcraNzMyXPUkoZePF6BjSi7vwVbjk3DQzTfINP/2562Iq57ezUqDRmyzOjDdhs
         f1mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=96jmeQugkiXuEjt+cvm/Lgp/1EQnyluP5VtBL0XRQLQ=;
        b=ddoRklL7Fs9TjLQFZlC2yfEuz0TskYpRfR432wUmo5hX1QRQCgVfGXkOH48HKTFrfv
         lKy1Ji2a8NA8I8uaohcQXorXU2K0RTbLrrMvCs1tde5x7MKH3lkiUWG0LTpLLFDeSdAP
         cA7Yz7Cc2t/0ufOq8aJNFOPRxDAnlwixq4WtNiQLlUJoMo/OViPnSj24XMFeMWhAGd3L
         lsb1CgHKbMTOV6syqmUTiUrhQtbInwU79zgDUzay/OStJNKnsq9qEDzTxnhBEFp6RFEV
         CYkN3Xq1hmsWkcob0pc4gfYddSkb0emaVFsSCOiWLsTFcrccVeVJZ4zUGIwARFs91WKu
         PTCQ==
X-Gm-Message-State: AOAM530LJ6ptRV3HWvz0HOY+rr3viXq5Q/DwqvIKd8L3JoAFssF6n+y1
        HPoA2J90ROrnjB8e7GtJTxzWhicL2YnM+Q+uWwBZV6tyaYQ=
X-Google-Smtp-Source: ABdhPJxyeZyiXB0ha2Az5URgaQV8TDrFZPHShjWIPBESFwSJ4OKANt76XgM/FQj6J1+zsV9fFAYZsEtsoL2TF++cxvs=
X-Received: by 2002:ac2:498c:: with SMTP id f12mr48322767lfl.250.1641404971252;
 Wed, 05 Jan 2022 09:49:31 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-10-dmatlack@google.com>
 <YdVOycjyfi4Wr9ke@xz-m1.local>
In-Reply-To: <YdVOycjyfi4Wr9ke@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 5 Jan 2022 09:49:04 -0800
Message-ID: <CALzav=dbJhibg1Qy5FGaCPKJZ+AmwjFyoAAzHNFAwLy-dLmCQw@mail.gmail.com>
Subject: Re: [PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty
 logging is enabled
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

On Tue, Jan 4, 2022 at 11:55 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Dec 13, 2021 at 10:59:14PM +0000, David Matlack wrote:
> > When dirty logging is enabled without initially-all-set, attempt to
> > split all huge pages in the memslot down to 4KB pages so that vCPUs
> > do not have to take expensive write-protection faults to split huge
> > pages.
> >
> > Huge page splitting is best-effort only. This commit only adds the
> > support for the TDP MMU, and even there splitting may fail due to out
> > of memory conditions. Failures to split a huge page is fine from a
> > correctness standpoint because we still always follow it up by write-
> > protecting any remaining huge pages.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Thanks for adding the knob.
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> One trivial nitpick below:
>
> > +u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index, unsigned int access)
> > +{
> > +     u64 child_spte;
> > +     int child_level;
> > +
> > +     if (WARN_ON(is_mmio_spte(huge_spte)))
> > +             return 0;
> > +
> > +     if (WARN_ON(!is_shadow_present_pte(huge_spte)))
> > +             return 0;
> > +
> > +     if (WARN_ON(!is_large_pte(huge_spte)))
> > +             return 0;
> > +
> > +     child_spte = huge_spte;
> > +     child_level = huge_level - 1;
> > +
> > +     /*
> > +      * The child_spte already has the base address of the huge page being
> > +      * split. So we just have to OR in the offset to the page at the next
> > +      * lower level for the given index.
> > +      */
> > +     child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
> > +
> > +     if (child_level == PG_LEVEL_4K) {
> > +             child_spte &= ~PT_PAGE_SIZE_MASK;
> > +
> > +             /* Allow execution for 4K pages if it was disabled for NX HugePages. */
> > +             if (is_nx_huge_page_enabled() && access & ACC_EXEC_MASK)
>
> IMHO clearer to use brackets ("A && (B & C)").

Agreed.

>
> I don't even see anywhere that the tdp mmu disables the EXEC bit for 4K.. if
> that's true then perhaps we can even drop "access" and this check?  But I could
> have missed something.

TDP MMU always passes ACC_ALL so the access check could be omitted
from this patch. But it will be needed to support eager splitting for
the shadow MMU, which does not always allow execution.



>
> > +                     child_spte = mark_spte_executable(child_spte);
> > +     }
> > +
> > +     return child_spte;
> > +}
>
> --
> Peter Xu
>
