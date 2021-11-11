Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434F644DC21
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 20:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhKKTYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 14:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhKKTYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 14:24:49 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744B1C061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 11:22:00 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 188so5991293pgb.7
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 11:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NU9yNrRTWhRt8Iu+JyV+drvZ4GlwYyD5wgIGgFheUp0=;
        b=D+YokyZsFaTTiQsNMIO/51OfYVigi6S4PfjZUB0K9pMuqFGTt8+aD2QmqH2IiC4pZK
         y4PtA9I4L9+KpD/yx2lLIBKLuyPva9A9jrW6Pdm5N8QGb6hyvUrXdAdoPMCxh63w7hjc
         R0ZB2GIT55qWRH04MwzvIgOEaeLgb/4ux6nC1PmuuTf5TyqPs5BZ9D/af7JFIO0buM0L
         GDLYhQGa6HzYMbwxeLjJwTllJ4/7pzqEJ5RcGBz+VWS/gY7uTzLjZJIstMvwTM7eNg9A
         vH0JCa6ymLW9PX6rm8eRLizwOGK9ol+Mqtf9p4TuOPaY4BmddzT1JB+0TrQfN6Mn6swm
         mSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NU9yNrRTWhRt8Iu+JyV+drvZ4GlwYyD5wgIGgFheUp0=;
        b=AU3AkoCkq/Rp3IXgZNYMm/iGfELUhkx0vmrwGYmEJ/Fxh7XzQQrh4ZWwIj34F3hZ8q
         kmjyYxSMDce+dYh4X9tcM4HILMx1dGUOq5xzeWpxvHvd6qeq1IQOpa0sprkstmiamKcK
         4sDrP1X2Jqd48q84D7b4v/YsHbVDtYRJ6FDoS4a9qBBoDfV6TvIFZSmRqHiC0/5vYJNx
         oFufpgvr1Bc302XnMN6gghuvaHc0n9bSpZH50DS4E44Xo6rGIe+kirCb59RC/Y8B95+N
         G7lTrl64o37tzl1xLQwcRBv95ybcsyps5ov3KY+YFu0fW4DzzASPwJWsj6UKOBgsNvV+
         i2vA==
X-Gm-Message-State: AOAM532Ci8OesFavjiLwMmLs3zQLyad8CwXJGg+eAyqEO1zEqFz7N6Bu
        dAqTw0AysEMhs9sMV73ZvpFM+Q==
X-Google-Smtp-Source: ABdhPJyVypyZgfxQZAgQpleYB2lt0Zoz966O5Cijwolzf0KCsHbhzznqVReNelOo+hcP7J8KCd4rRQ==
X-Received: by 2002:a05:6a00:21c2:b0:44c:fa0b:f72 with SMTP id t2-20020a056a0021c200b0044cfa0b0f72mr8733801pfj.13.1636658519819;
        Thu, 11 Nov 2021 11:21:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u38sm4340901pfg.0.2021.11.11.11.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 11:21:59 -0800 (PST)
Date:   Thu, 11 Nov 2021 19:21:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v2 04/12] KVM: selftests: Require GPA to be aligned when
 backed by hugepages
Message-ID: <YY1tUyUL6pbe7lH+@google.com>
References: <20211111000310.1435032-1-dmatlack@google.com>
 <20211111000310.1435032-5-dmatlack@google.com>
 <CANgfPd9L4pnKQiiTFcccuCQ69Ohta=wvWRH5MVDzCZVZyp_dBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9L4pnKQiiTFcccuCQ69Ohta=wvWRH5MVDzCZVZyp_dBA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021, Ben Gardon wrote:
> On Wed, Nov 10, 2021 at 4:03 PM David Matlack <dmatlack@google.com> wrote:
> >
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Assert that the GPA for a memslot backed by a hugepage is aligned to
> > the hugepage size and fix perf_test_util accordingly.  Lack of GPA
> > alignment prevents KVM from backing the guest with hugepages, e.g. x86's
> > write-protection of hugepages when dirty logging is activated is
> > otherwise not exercised.
> >
> > Add a comment explaining that guest_page_size is for non-huge pages to
> > try and avoid confusion about what it actually tracks.
> >
> > Cc: Ben Gardon <bgardon@google.com>
> > Cc: Yanan Wang <wangyanan55@huawei.com>
> > Cc: Andrew Jones <drjones@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Aaron Lewis <aaronlewis@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > [Used get_backing_src_pagesz() to determine alignment dynamically.]
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/kvm_util.c       | 2 ++
> >  tools/testing/selftests/kvm/lib/perf_test_util.c | 7 ++++++-
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 07f37456bba0..1f6a01c33dce 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -875,6 +875,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
> >         if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
> >                 alignment = max(backing_src_pagesz, alignment);
> >
> > +       ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
> > +
> >         /* Add enough memory to align up if necessary */
> >         if (alignment > 1)
> >                 region->mmap_size += alignment;
> > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > index 6b8d5020dc54..a015f267d945 100644
> > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > @@ -55,11 +55,16 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
> >  {
> >         struct kvm_vm *vm;
> >         uint64_t guest_num_pages;
> > +       uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
> >         int i;
> >
> >         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> >
> >         perf_test_args.host_page_size = getpagesize();
> > +       /*
> > +        * Snapshot the non-huge page size.  This is used by the guest code to
> > +        * access/dirty pages at the logging granularity.
> > +        */
> >         perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
> 
> Is this comment correct? I wouldn't expect the guest page size to
> determine the host dirty logging granularity.

"guest page size" is a bit of a misnomer.  It's not the page size of the guest's
page tables, rather it's the non-huge page size of the PTEs that KVM uses to map
guest memory.  That info is exposed to the guest so that the guest and host agree
on the stride.

> >         guest_num_pages = vm_adjust_num_guest_pages(mode,
> > @@ -92,7 +97,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
> >
> >         guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
> >                               perf_test_args.guest_page_size;
> > -       guest_test_phys_mem = align_down(guest_test_phys_mem, perf_test_args.host_page_size);
> > +       guest_test_phys_mem = align_down(guest_test_phys_mem, backing_src_pagesz);
> >  #ifdef __s390x__
> >         /* Align to 1M (segment size) */
> >         guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
> > --
> > 2.34.0.rc1.387.gb447b232ab-goog
> >
