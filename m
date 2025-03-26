Return-Path: <kvm+bounces-42063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA18A71F6B
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 025923BFDC9
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C217258CF8;
	Wed, 26 Mar 2025 19:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZW8yfkEv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83E02459D5
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017901; cv=none; b=DsyPg6Eht5HKWrMpjqVpa3YnBOYxuWQPLDIPSSaHnK409+9rGMn3G1taC8j+9krOtQnXI3PYJdgJD2ZV5TTXUzYatGn5RHFXu78OKUyD6p+Vg7ofzK8NytGY88h+X1MU/3uiN0nJ9rVgjCpw7+j+uSQ1snDc0d6wbVt9Bf0QjD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017901; c=relaxed/simple;
	bh=ni5DLjoigc4YEqVDxu3C+xdGh9eEwpzQRQuhmWV3oFY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P96uLVdI9Tiwx7RGb6kS9mv1Qv4xUr5WLpLl6LfxFk9wAJaMF9EJbRxE68pMamFMbteU1RIgLC9BSsOczyDEG2/gbW2aCFFH0ZPPmoUyUKLmxype3yPnbkNhgiz2Pmiqqqvm3La3POFgLKwIz8XKhEdYXdzYnUsXMfdioWBzngY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZW8yfkEv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743017898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bh+o0Eq5gmVZwd3ePVQ84C8a4y5x4wc3UzpBy1woWao=;
	b=ZW8yfkEvc9s3JVlEd0aackDD56LwlALd07M6UQXTkTTX4ifcyGs71Wt+Q4YmiSm2oHwle+
	6C463CDkdV3QerGLf3TQXP0m7+OmzhKKLgdJn/x66Ln7funZL9KWErz2C0qWWMSeVY73Gw
	0BJU9O1fRbqk1hKRfRPggRJuSZ2RLT4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-4Rt6vhx6PDGTvb_bSwV5ug-1; Wed, 26 Mar 2025 15:38:16 -0400
X-MC-Unique: 4Rt6vhx6PDGTvb_bSwV5ug-1
X-Mimecast-MFC-AGG-ID: 4Rt6vhx6PDGTvb_bSwV5ug_1743017895
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6ece036a581so3141946d6.1
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 12:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743017895; x=1743622695;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bh+o0Eq5gmVZwd3ePVQ84C8a4y5x4wc3UzpBy1woWao=;
        b=jPoT8rn4Nv6r4fdE8n2WhOmCwvcWzcXtKcyqW3elSzN3/5MTfOALdlfvMjWd2MUfE6
         1jcQn4jrfbAT1PmxaaGGwU3z7K3Jd0ga6ZQ3wpK1Ja4rw0JgzNVhEphvGB1GzyjJVn7K
         rUC+TuSty7B3DDnEuYkvoao0ppZwvPm3QD7kIgC8wcSE9gfHL8G8lkuV9o/VkzAWHnbu
         wA4pghB5clomETM0XbIr4hgWhZ/7NpTPE8J/KfyBrheYOAxAsYJ2ON4L8EjdbCvj8MiV
         LjAW1N7QuoE8STITZkcu2jUBcRvA89fWWpPCDgqw4eWrnC9AatDdQ/u9U1SQ6jDwpNE/
         mZEw==
X-Gm-Message-State: AOJu0YxsP3WMCT3dSiraZkt5mZeB8/Uncb7jskqlK8bkqfxNZPeodqmh
	2Vo/1vvcuEd9QKcnEVsZr86gXzR3wuct0r1DHPLvnvk8SMndeoPT0BE1YAH1dodKHWRfKOK65O7
	ZXpym9X8XPHzv8m8d9uELjSKT/XMyfGgYMgNIQar0icFzr6dD9Q==
X-Gm-Gg: ASbGncsF7mywvk4CUvkr/hay7/8mRlUYN30OlYNFUjK2RwCCTABcbCwVIYh3c7kOhNB
	8BM1jKHwKNES+nUuhcvhlDjD6t5q+RHPlXoCqe2M7U/ag03N3bmV3WJjZWLmy05a/hjpJSj0qVj
	nApeNLQSR4FamIR1FWCq2Gc9isoHVN8xJWI91oni/Z42PsUkPxWrx5Xa74cYfCapQWIaflqUhJc
	/cwpul3cXvux4VTv/lcd24Zif8YHo4gmNf8EpVuEoomExjKy785pztvQYtOGSTlBIZlSgX5Ux/2
	5SpbYUxG9nk8dHU=
X-Received: by 2002:ad4:5ec5:0:b0:6e6:6c7f:1116 with SMTP id 6a1803df08f44-6ed238d7b21mr9194086d6.24.1743017894835;
        Wed, 26 Mar 2025 12:38:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IES5BQrGvTlTVzodj7mSmVgS7g34qhKgTxcZF2l+qD44xC2dhVK38HYIxTUX3Aw95ISiL9kTg==
X-Received: by 2002:ad4:5ec5:0:b0:6e6:6c7f:1116 with SMTP id 6a1803df08f44-6ed238d7b21mr9193776d6.24.1743017894310;
        Wed, 26 Mar 2025 12:38:14 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eb3ef1f15fsm70765636d6.34.2025.03.26.12.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 12:38:14 -0700 (PDT)
Message-ID: <bd09a55c777c9342e950f8cfbd9e5f8c1cdecd23.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: access_tracking_perf_test: add
 option to skip the sanity check
From: Maxim Levitsky <mlevitsk@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@collabora.com>, 
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Shuah Khan <shuah@kernel.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
  linux-kselftest@vger.kernel.org, Anup Patel <anup@brainfault.org>
Date: Wed, 26 Mar 2025 15:38:12 -0400
In-Reply-To: <CADrL8HWrgbV+coEod_EUnvG27HX3WtJDMua3FPiReCRCtXaNhw@mail.gmail.com>
References: <20250325015741.2478906-1-mlevitsk@redhat.com>
	 <20250325015741.2478906-3-mlevitsk@redhat.com>
	 <CADrL8HWrgbV+coEod_EUnvG27HX3WtJDMua3FPiReCRCtXaNhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2025-03-25 at 11:01 -0700, James Houghton wrote:
> On Mon, Mar 24, 2025 at 6:57 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > Add an option to skip sanity check of number of still idle pages,
> > and set it by default to skip, in case hypervisor or NUMA balancing
> > is detected.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Thanks Maxim! I'm still working on a respin of this test with MGLRU
> integration, like [1]. Sorry it's taking me so long. I'll apply my
> changes on top of yours.
> 
> [1]: https://lore.kernel.org/kvm/20241105184333.2305744-12-jthoughton@google.com/
> 
> > ---
> >  .../selftests/kvm/access_tracking_perf_test.c | 33 ++++++++++++++++---
> >  .../testing/selftests/kvm/include/test_util.h |  1 +
> >  tools/testing/selftests/kvm/lib/test_util.c   |  7 ++++
> >  3 files changed, 37 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > index 3c7defd34f56..6d50c829f00c 100644
> > --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > @@ -65,6 +65,8 @@ static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
> >  /* Whether to overlap the regions of memory vCPUs access. */
> >  static bool overlap_memory_access;
> > 
> > +static int warn_on_too_many_idle_pages = -1;
> > +
> >  struct test_params {
> >         /* The backing source for the region of memory. */
> >         enum vm_mem_backing_src_type backing_src;
> > @@ -184,11 +186,10 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
> >          * are cached and the guest won't see the "idle" bit cleared.
> >          */
> >         if (still_idle >= pages / 10) {
> > -#ifdef __x86_64__
> > -               TEST_ASSERT(this_cpu_has(X86_FEATURE_HYPERVISOR),
> > +               TEST_ASSERT(warn_on_too_many_idle_pages,
> 
> I think this assertion is flipped (or how warn_on_too_many_idle_pages
> is being set is flipped, see below).
Yes it is no doubt about. 

I didn't notice this when I flipped the meaning
of the variable as Sean suggested.
Thanks!

Best regards,
	Maxim Levitsky


> 
> >                             "vCPU%d: Too many pages still idle (%lu out of %lu)",
> >                             vcpu_idx, still_idle, pages);
> > -#endif
> > +
> >                 printf("WARNING: vCPU%d: Too many pages still idle (%lu out of %lu), "
> >                        "this will affect performance results.\n",
> >                        vcpu_idx, still_idle, pages);
> > @@ -342,6 +343,8 @@ static void help(char *name)
> >         printf(" -v: specify the number of vCPUs to run.\n");
> >         printf(" -o: Overlap guest memory accesses instead of partitioning\n"
> >                "     them into a separate region of memory for each vCPU.\n");
> > +       printf(" -w: Skip or force enable the check that after dirtying the guest memory, most (90%%) of \n"
> > +              "it is reported as dirty again (0/1)");
> >         backing_src_help("-s");
> >         puts("");
> >         exit(0);
> > @@ -359,7 +362,7 @@ int main(int argc, char *argv[])
> > 
> >         guest_modes_append_default();
> > 
> > -       while ((opt = getopt(argc, argv, "hm:b:v:os:")) != -1) {
> > +       while ((opt = getopt(argc, argv, "hm:b:v:os:w:")) != -1) {
> >                 switch (opt) {
> >                 case 'm':
> >                         guest_modes_cmdline(optarg);
> > @@ -376,6 +379,11 @@ int main(int argc, char *argv[])
> >                 case 's':
> >                         params.backing_src = parse_backing_src_type(optarg);
> >                         break;
> > +               case 'w':
> > +                       warn_on_too_many_idle_pages =
> > +                               atoi_non_negative("1 - enable warning, 0 - disable",
> > +                                                 optarg);
> 
> We still get a "warning" either way, right? Maybe this should be
> called "fail_on_too_many_idle_pages" (in which case the above
> assertion is indeed flipped). Or "warn_on_too_many_idle_pages" should
> mean *only* warn, i.e., *don't* fail, in which case, below we need to
> flip how we set it below.
> 
> > +                       break;
> >                 case 'h':
> >                 default:
> >                         help(argv[0]);
> > @@ -386,6 +394,23 @@ int main(int argc, char *argv[])
> >         page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
> >         __TEST_REQUIRE(page_idle_fd >= 0,
> >                        "CONFIG_IDLE_PAGE_TRACKING is not enabled");
> > +       if (warn_on_too_many_idle_pages == -1) {
> > +#ifdef __x86_64__
> > +               if (this_cpu_has(X86_FEATURE_HYPERVISOR)) {
> > +                       printf("Skipping idle page count sanity check, because the test is run nested\n");
> > +                       warn_on_too_many_idle_pages = 0;
> > +               } else
> > +#endif
> > +               if (is_numa_balancing_enabled()) {
> > +                       printf("Skipping idle page count sanity check, because NUMA balance is enabled\n");
> > +                       warn_on_too_many_idle_pages = 0;
> > +               } else {
> > +                       warn_on_too_many_idle_pages = 1;
> > +               }
> > +       } else if (!warn_on_too_many_idle_pages) {
> > +               printf("Skipping idle page count sanity check, because this was requested by the user\n");
> > +       }
> > +
> >         close(page_idle_fd);
> > 
> >         for_each_guest_mode(run_test, &params);
> > diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> > index 3e473058849f..1bc9b0a92427 100644
> > --- a/tools/testing/selftests/kvm/include/test_util.h
> > +++ b/tools/testing/selftests/kvm/include/test_util.h
> > @@ -153,6 +153,7 @@ bool is_backing_src_hugetlb(uint32_t i);
> >  void backing_src_help(const char *flag);
> >  enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
> >  long get_run_delay(void);
> > +bool is_numa_balancing_enabled(void);
> > 
> >  /*
> >   * Whether or not the given source type is shared memory (as opposed to
> > diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> > index 3dc8538f5d69..03eb99af9b8d 100644
> > --- a/tools/testing/selftests/kvm/lib/test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/test_util.c
> > @@ -176,6 +176,13 @@ size_t get_trans_hugepagesz(void)
> >         return get_sysfs_val("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size");
> >  }
> > 
> > +bool is_numa_balancing_enabled(void)
> > +{
> > +       if (!test_sysfs_path("/proc/sys/kernel/numa_balancing"))
> > +               return false;
> > +       return get_sysfs_val("/proc/sys/kernel/numa_balancing") == 1;
> > +}
> > +
> >  size_t get_def_hugetlb_pagesz(void)
> >  {
> >         char buf[64];
> > --
> > 2.26.3
> > 



