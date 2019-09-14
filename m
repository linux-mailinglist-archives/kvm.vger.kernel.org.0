Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9223B2930
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2019 02:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390879AbfINAtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 20:49:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46975 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390869AbfINAtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 20:49:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so2430676wrv.13
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 17:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIKZaXLQQv0uSg/i+jgYqZicgP3Uf0kOCEkAJwO3gGc=;
        b=MZUluQMYS/48vN/5IPm5izc0c2zKpdDSZf6bvDlUvEk9NDPPSk7D/Q/I8cp2DTLTDd
         KeAGU48+07d9ILQj57zVi1RW0qCaypXciPYv8ZIVjzBwRRz2/ivSMX3GWfSgNX2mSf4T
         ssqMDN7rjVH8zcPROzk06VtSSWy9hMpvcc4PWK5JFq2DC3Vinhm1gYLb2IAwHzO8wSkP
         O6PccG7BQYBKCqYaq410mhJC+fJEysfcjY0Wsrf54sNhSnQBhRCVZ1uR+Db2AB4acybr
         jwaXKpngk0q07V1SIf+vgXY/VqQvQ2FZV6lHYGylTJF6bH2yjOVWvIFght9XTT2LDUHS
         h0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIKZaXLQQv0uSg/i+jgYqZicgP3Uf0kOCEkAJwO3gGc=;
        b=q3Xyr2uAaefJDacm13WhAsqH+SBGFRnh91uf8MT3w/GbWrM9n+oDQ/GqL+nb2sv/2r
         49j4hVuHCEzUVd/XrXA6gol1XwVYMsOQ5ftZtmXSkx509HIjXIf+toYvb70lLo4hJ3av
         fxTpo0bs4RJFzubo/wk2w6UDFgczUNhki34RJjgy8py5F79OhHw9i4je+dwEZGwsmA05
         hvN0bauxUHooOwWxEtlgD993LyJ3QWowA/OPUkfS295jm3aPerJKs6EXZngTxfNe25Nf
         2OT0J2EyV2MYpMvPNISQZDO6Lw8zL1ePysPRL1RiX1P+6Wq9s6uodsgAfKnExjqoBvCJ
         yy5g==
X-Gm-Message-State: APjAAAUxdhF+dudaE7U1rXaPqWTnYJknX5B99RVv6dZf1L7m2QH7pNKm
        XNcLQdtDIrgib+4PYTPkl5QijHmY0K/tRaEmKtM5+w==
X-Google-Smtp-Source: APXvYqy1EfmVkYbXurTyXejJztPBEg9oTYjVRx0g6NTBjEyjrReeTJFrkJ9aIJFQsHbV0ld96rTz2w/+e1W6n5J1WLA=
X-Received: by 2002:a05:6000:1281:: with SMTP id f1mr27747228wrx.247.1568422180442;
 Fri, 13 Sep 2019 17:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190912180928.123660-1-marcorr@google.com> <20190913152442.GC31125@linux.intel.com>
In-Reply-To: <20190913152442.GC31125@linux.intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 13 Sep 2019 17:49:28 -0700
Message-ID: <CAA03e5FdHGoH2YUNba85hdY9_bzoFjReXFzL=TamB303yZw_tA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nvmx: test max atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +static void *alloc_2m_page(void)
> > +{
> > +     return alloc_pages(PAGE_2M_ORDER);
> > +}
>
> Allocating 2mb pages is complete overkill.  The absolute theoretical max
> for the number of MSRs is (8 * 512) = 4096, for a total of 32kb per list.
> We can even show the math so that it's obvious how the size is calculated.
> Plus one order so we can test overrun.
>
> /*
>  * The max number of MSRs is specified in 3 bits bits, plus 1. I.e. 7+1==8.
>  * Allocate 64k bytes of data to cover max_msr_list_size and then some.
>  */
> static const u32 msr_list_page_order = 4;
>

Done. Changed msr_list_page_order to 5, per our previous discussion
that you meant 16 * 512.

> > +enum atomic_switch_msr_scenario {
> > +     VM_ENTER_LOAD,
> > +     VM_EXIT_LOAD,
> > +     VM_EXIT_STORE,
> > +     ATOMIC_SWITCH_MSR_SCENARIO_END,
> > +};
>
> How about:
>
> enum atomic_switch_msr_lists {
>         VM_ENTER_LOAD,
>         VM_EXIT_LOAD,
>         VM_EXIT_STORE,
>         NR_ATOMIC_SWITCH_MSR_LISTS,
> };
>
> IMO that yields a much more intuitive test loop:
>
>         for (i = 0; i < NR_ATOMIC_SWITCH_MSR_LISTS; i++) {
>         }
>
> But we probably don't even need a loop...

Ack. Got rid of the loop.

> > +static void atomic_switch_msr_limit_test_guest(void)
> > +{
> > +     vmcall();
> > +}
> > +
> > +static void populate_msr_list(struct vmx_msr_entry *msr_list, int count)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < count; i++) {
> > +             msr_list[i].index = MSR_IA32_TSC;
> > +             msr_list[i].reserved = 0;
> > +             msr_list[i].value = 0x1234567890abcdef;
>
> Maybe overkill, but we can use a fast string op for this.  I think
> I got the union right?
>
> static void populate_msr_list(struct vmx_msr_entry *msr_list, int count)
> {
>         union {
>                 struct vmx_msr_entry msr;
>                 u64 val;
>         } tmp;
>
>         tmp.msr.index = MSR_IA32_TSC;
>         tmp.msr.reserved = 0;
>         tmp.msr.value = 0x1234567890abcdef;
>
>         asm volatile (
>                 "rep stosq\n\t"
>                 : "=c"(count), "=D"(msr_list)
>                 : "a"(tmp.val), "c"(count), "D"(msr_list)
>                 : "memory"
>         );
> }

Skipped per our previous conversation that this doesn't work due to
the string being 16 bytes.

> > +     for (s = 0; s < ATOMIC_SWITCH_MSR_SCENARIO_END; s++) {
> > +             switch (s) {
> > +             case VM_ENTER_LOAD:
> > +                     addr_field = ENTER_MSR_LD_ADDR;
> > +                     cnt_field = ENT_MSR_LD_CNT;
> > +                     break;
> > +             case VM_EXIT_LOAD:
> > +                     addr_field = EXIT_MSR_LD_ADDR;
> > +                     cnt_field = EXI_MSR_LD_CNT;
> > +                     break;
> > +             case VM_EXIT_STORE:
> > +                     addr_field = EXIT_MSR_ST_ADDR;
> > +                     cnt_field = EXI_MSR_ST_CNT;
> > +                     break;
> > +             default:
> > +                     TEST_ASSERT(false);
> > +             }
> > +
> > +             msr_list = (struct vmx_msr_entry *)vmcs_read(addr_field);
> > +             memset(msr_list, 0xff, two_mb);
>
> Writing 8mb of data for each test is a waste of time, i.e. 6mb to reset
> each list, and another 2mb to populate the target list.
>
> The for-loop in the helper is also confusing and superfluous.

Ack. Got rid of the helper.

> > +     /* Setup atomic MSR switch lists. */
> > +     msr_list = alloc_2m_page();
> > +     vmcs_write(ENTER_MSR_LD_ADDR, virt_to_phys(msr_list));
> > +     msr_list = alloc_2m_page();
> > +     vmcs_write(EXIT_MSR_LD_ADDR, virt_to_phys(msr_list));
> > +     msr_list = alloc_2m_page();
> > +     vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(msr_list));
>
> This memory should really be freed.  Not holding pointers for each list
> also seems silly, e.g. requires a VMREAD just to get a pointer.

Done.

> > +
> > +     /* Execute each test case. */
> > +     for (s = 0; s < ATOMIC_SWITCH_MSR_SCENARIO_END; s++) {
>
> Since you're testing the passing case, why not test all three at once?
> I.e. hammer KVM while also consuming less test cycles.  The "MSR switch"
> test already verifies the correctness of each list.

Done.

> > +             struct vmx_msr_entry *msr_list;
> > +             int count = max_msr_list_size();
> > +
> > +             switch (s) {
> > +             case VM_ENTER_LOAD:
> > +                     msr_list = (struct vmx_msr_entry *)vmcs_read(
> > +                                     ENTER_MSR_LD_ADDR);
>
> These should use phys_to_virt() since virt_to_phys() is used to write them.

Hmm. Actually, why don't we just use an explicit (u64) cast. That's
what I originally had, but then when Jim pre-reviewed the patch before
I posted it on the list he suggested virt_to_phys() with a ?. I didn't
really understand why that was better than the explicit cast. And your
suggestion to use phys_to_virt() doesn't work at all because it
returns a pointer rather than a u64.

> > +                     break;
> > +             case VM_EXIT_LOAD:
> > +                     msr_list = (struct vmx_msr_entry *)vmcs_read(
> > +                                     EXIT_MSR_LD_ADDR);
> > +                     break;
> > +             case VM_EXIT_STORE:
> > +                     msr_list = (struct vmx_msr_entry *)vmcs_read(
> > +                                     EXIT_MSR_ST_ADDR);
> > +                     break;
> > +             default:
> > +                     report("Bad test scenario, %d.", false, s);
> > +                     continue;
> > +             }
> > +
> > +             configure_atomic_switch_msr_limit_test(msr_list, count);
>
> Again, feeding the list into a helper that also iterates over the lists
> is not intuitive in terms of understanding what is being tested.

Done. Got rid of the loop.

> > +     /* Atomic MSR switch tests. */
> > +     TEST(atomic_switch_msr_limit_test),
>
> This is a misleading name, e.g. it took me quite a while to realize this
> is testing only the passing scenario.  For me, "limit test" implies that
> it'd be deliberately exceeding the limit, or at least testing both the
> passing and failing cases.  I suppose we can't easily test the VMX abort
> cases, but we can at least test VM_ENTER_LOAD.

Done. Renamed to atomic_switch_max_msrs_test.

> Distilling things down to the bare minimum yields something like the
> following.

Thanks!
