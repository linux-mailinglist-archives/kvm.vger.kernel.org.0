Return-Path: <kvm+bounces-41987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C09E6A708B4
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 19:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B850C1764CD
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 18:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D774026656D;
	Tue, 25 Mar 2025 18:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N1YzAxaF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB5F265CBF
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 18:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742925729; cv=none; b=iJC5AjEui9gQ7ZQSP1wwSY1G+6OH0ugZrlPXWIAdQZvtLax8b1jZPalWkiRONLq7svGhe0OV1IYIdIoZ4zokaohoH5GAkDtq51e93ohriv2/3di7i1hdHRnifqPe2rkLmw0yRTEoXyh+XpXpUO7yCLc2h6pjLO14jlzRid99m1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742925729; c=relaxed/simple;
	bh=nLMbkrCGaYqNYvj/uskEQt94nopA8G1rmBrBvUccgNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khAsH7IFeitv59XlDgIV23b7H5FiE3dNT93JJtOL8CHevAay/Dmzg7aIOKSjvBGBjecbQL1HNcHmJO9SjOk2Ed1wZ++Rz/jb0ay7Bn74aBrAzlfHt96s7NkmS6JCHJbYG4jAvtnqcsFS80CHvnZ/qg00t/7zp2yUniFr8ZrX7Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N1YzAxaF; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e60ad903382so4171274276.0
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 11:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742925726; x=1743530526; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5QxktKIiJwK4b76ZZiDJMYuZI2sYzH5YH5Uf7nq90r0=;
        b=N1YzAxaFHpvFmbz3uMs6+NHmV3cCWMdTItbrRcZz4DS2YPo9S7grh4w1rdQlPxYg1H
         huF6UXkTDe0iCQWb5qusj9xjS6pHn2anTwgfNyInOFHD+4PVTRm1XD+WmArmD7+vXdB4
         V5/IHISA3gu3RxQB2oSdPx+wpomqmcd71VmiTidRjUnOK+m7uxh1WbgaQ24vjAzHHAm1
         6NRipGw1VyrOYsRDSlxCLkI94OBO3J8P8rCcf8DT5atTPRoFB6AFlngSxonAGDDScq+P
         sw0RraXpAg8fRb+b9NRV/8EDJTImpw6t+DZLjPWA6/Ai8xwd+O/U4tW0Wr6Xq8z4szav
         dpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742925726; x=1743530526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5QxktKIiJwK4b76ZZiDJMYuZI2sYzH5YH5Uf7nq90r0=;
        b=xNN3BhG2LFasGiU/oW85qxmodEhx3b8CRjDENK4YloqXpI1KIWfbLUBgvuaG064e3j
         0sDl9UcUtHQyMqksNKhWqXKTfoBFZnaCNFVyyPYOAunifscSUaMqZmAqL7lYcrwdNdp+
         foXE2IJ+0DTxe0cxJCCx1sKX9b27taXvC6s+6djcTdAIGE17HPTR4wHEQ+DoSE8PkMGh
         ZlYXtRVEJsBzw7UqS7u66K8P8fU4fX9q7fVUn84TVXcie9QGiWUi10qN6Ra9IhnFrwj5
         KBiwUr5TadL+Pi+gYgqHTdd+k8EOR2RFa+3SBSyvunYtu0saEoAZRBSA0u+XLwflYBg7
         fpjA==
X-Gm-Message-State: AOJu0YzpmlTRl7uAIkX4inLFRpTET85NJ89DSXN/OG2MS3h95MOnqrbF
	LRiclOmNGsnneu/v9osohEf14NrWgGpVv1Pb9Hr4JCAhlRtzm+MLUte4E3fhHj8M3ZEcWuQMwIj
	stWxdM8i7WTE63/77bt+L/X7tLmulG0PXFLCcOzwvrkf1RshB8pXuOM0=
X-Gm-Gg: ASbGncuxJa5QoPQJzCr3FW9lP7Ts1J3L+wyKmEbucLoW2N1pYrFXM1YWT/WQDSF+AQv
	JfPNt3z3TBhLrv3uUS12djRd1xPfwqH6EXQGarwZLmXoCiOjJIAUn1aNS8BNalAi087b6q77oqe
	rJHHxVlF+/zOWyaZQGgsSZnp11yLm6iw6I15UCrxrVzBiZ39FRVloTdRIs
X-Google-Smtp-Source: AGHT+IFJ58QuMFXBhgsfgVMV9+98zwWR6+D5N7tZ2YCcDARvTT9tXCL3H8xMqcRSqaHvPFUvfH4bv7+G6TkVSQEAXWo=
X-Received: by 2002:a05:6902:2781:b0:e5d:c5f3:13e1 with SMTP id
 3f1490d57ef6-e66a4faa663mr18324543276.35.1742925725596; Tue, 25 Mar 2025
 11:02:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250325015741.2478906-1-mlevitsk@redhat.com> <20250325015741.2478906-3-mlevitsk@redhat.com>
In-Reply-To: <20250325015741.2478906-3-mlevitsk@redhat.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 25 Mar 2025 11:01:29 -0700
X-Gm-Features: AQ5f1Jqr8Ey0IH-CbdbzhC0C2_tO7cFF6MTtHHXP7tWz7fi3ARRfyDuVqLTZB50
Message-ID: <CADrL8HWrgbV+coEod_EUnvG27HX3WtJDMua3FPiReCRCtXaNhw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: access_tracking_perf_test: add
 option to skip the sanity check
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@collabora.com>, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Shuah Khan <shuah@kernel.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-kselftest@vger.kernel.org, Anup Patel <anup@brainfault.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2025 at 6:57=E2=80=AFPM Maxim Levitsky <mlevitsk@redhat.com=
> wrote:
>
> Add an option to skip sanity check of number of still idle pages,
> and set it by default to skip, in case hypervisor or NUMA balancing
> is detected.
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks Maxim! I'm still working on a respin of this test with MGLRU
integration, like [1]. Sorry it's taking me so long. I'll apply my
changes on top of yours.

[1]: https://lore.kernel.org/kvm/20241105184333.2305744-12-jthoughton@googl=
e.com/

> ---
>  .../selftests/kvm/access_tracking_perf_test.c | 33 ++++++++++++++++---
>  .../testing/selftests/kvm/include/test_util.h |  1 +
>  tools/testing/selftests/kvm/lib/test_util.c   |  7 ++++
>  3 files changed, 37 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/to=
ols/testing/selftests/kvm/access_tracking_perf_test.c
> index 3c7defd34f56..6d50c829f00c 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -65,6 +65,8 @@ static int vcpu_last_completed_iteration[KVM_MAX_VCPUS]=
;
>  /* Whether to overlap the regions of memory vCPUs access. */
>  static bool overlap_memory_access;
>
> +static int warn_on_too_many_idle_pages =3D -1;
> +
>  struct test_params {
>         /* The backing source for the region of memory. */
>         enum vm_mem_backing_src_type backing_src;
> @@ -184,11 +186,10 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm=
,
>          * are cached and the guest won't see the "idle" bit cleared.
>          */
>         if (still_idle >=3D pages / 10) {
> -#ifdef __x86_64__
> -               TEST_ASSERT(this_cpu_has(X86_FEATURE_HYPERVISOR),
> +               TEST_ASSERT(warn_on_too_many_idle_pages,

I think this assertion is flipped (or how warn_on_too_many_idle_pages
is being set is flipped, see below).

>                             "vCPU%d: Too many pages still idle (%lu out o=
f %lu)",
>                             vcpu_idx, still_idle, pages);
> -#endif
> +
>                 printf("WARNING: vCPU%d: Too many pages still idle (%lu o=
ut of %lu), "
>                        "this will affect performance results.\n",
>                        vcpu_idx, still_idle, pages);
> @@ -342,6 +343,8 @@ static void help(char *name)
>         printf(" -v: specify the number of vCPUs to run.\n");
>         printf(" -o: Overlap guest memory accesses instead of partitionin=
g\n"
>                "     them into a separate region of memory for each vCPU.=
\n");
> +       printf(" -w: Skip or force enable the check that after dirtying t=
he guest memory, most (90%%) of \n"
> +              "it is reported as dirty again (0/1)");
>         backing_src_help("-s");
>         puts("");
>         exit(0);
> @@ -359,7 +362,7 @@ int main(int argc, char *argv[])
>
>         guest_modes_append_default();
>
> -       while ((opt =3D getopt(argc, argv, "hm:b:v:os:")) !=3D -1) {
> +       while ((opt =3D getopt(argc, argv, "hm:b:v:os:w:")) !=3D -1) {
>                 switch (opt) {
>                 case 'm':
>                         guest_modes_cmdline(optarg);
> @@ -376,6 +379,11 @@ int main(int argc, char *argv[])
>                 case 's':
>                         params.backing_src =3D parse_backing_src_type(opt=
arg);
>                         break;
> +               case 'w':
> +                       warn_on_too_many_idle_pages =3D
> +                               atoi_non_negative("1 - enable warning, 0 =
- disable",
> +                                                 optarg);

We still get a "warning" either way, right? Maybe this should be
called "fail_on_too_many_idle_pages" (in which case the above
assertion is indeed flipped). Or "warn_on_too_many_idle_pages" should
mean *only* warn, i.e., *don't* fail, in which case, below we need to
flip how we set it below.

> +                       break;
>                 case 'h':
>                 default:
>                         help(argv[0]);
> @@ -386,6 +394,23 @@ int main(int argc, char *argv[])
>         page_idle_fd =3D open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
>         __TEST_REQUIRE(page_idle_fd >=3D 0,
>                        "CONFIG_IDLE_PAGE_TRACKING is not enabled");
> +       if (warn_on_too_many_idle_pages =3D=3D -1) {
> +#ifdef __x86_64__
> +               if (this_cpu_has(X86_FEATURE_HYPERVISOR)) {
> +                       printf("Skipping idle page count sanity check, be=
cause the test is run nested\n");
> +                       warn_on_too_many_idle_pages =3D 0;
> +               } else
> +#endif
> +               if (is_numa_balancing_enabled()) {
> +                       printf("Skipping idle page count sanity check, be=
cause NUMA balance is enabled\n");
> +                       warn_on_too_many_idle_pages =3D 0;
> +               } else {
> +                       warn_on_too_many_idle_pages =3D 1;
> +               }
> +       } else if (!warn_on_too_many_idle_pages) {
> +               printf("Skipping idle page count sanity check, because th=
is was requested by the user\n");
> +       }
> +
>         close(page_idle_fd);
>
>         for_each_guest_mode(run_test, &params);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
> index 3e473058849f..1bc9b0a92427 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -153,6 +153,7 @@ bool is_backing_src_hugetlb(uint32_t i);
>  void backing_src_help(const char *flag);
>  enum vm_mem_backing_src_type parse_backing_src_type(const char *type_nam=
e);
>  long get_run_delay(void);
> +bool is_numa_balancing_enabled(void);
>
>  /*
>   * Whether or not the given source type is shared memory (as opposed to
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
> index 3dc8538f5d69..03eb99af9b8d 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -176,6 +176,13 @@ size_t get_trans_hugepagesz(void)
>         return get_sysfs_val("/sys/kernel/mm/transparent_hugepage/hpage_p=
md_size");
>  }
>
> +bool is_numa_balancing_enabled(void)
> +{
> +       if (!test_sysfs_path("/proc/sys/kernel/numa_balancing"))
> +               return false;
> +       return get_sysfs_val("/proc/sys/kernel/numa_balancing") =3D=3D 1;
> +}
> +
>  size_t get_def_hugetlb_pagesz(void)
>  {
>         char buf[64];
> --
> 2.26.3
>

