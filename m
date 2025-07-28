Return-Path: <kvm+bounces-53576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0208B1421B
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 20:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6E1018C00B3
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5632777ED;
	Mon, 28 Jul 2025 18:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KaZovOcV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2055276059
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753728080; cv=none; b=GqCePB8NNG+GPM6q3P4M0lciET1Ev1zh+JQ7KH1nxXU811kAeLzkBGsRP9/nLgNBD/1C3kM5/okYw7IJ+xQHqxJDhEfDYuN7ohA75vTv5C+dDGvElvUrsjxRrbss7mOEL0xIGoLito8lIJFMf2bw9Yx5u0Ni6W8vSNSM0TnM0aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753728080; c=relaxed/simple;
	bh=gD9JDAIZeCDO/Gr+tJDqG8UczV39zHLV27VUPKCVkg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cAu28BjDByxuvosbIL0XahLJEuQ/Dbu8xIsXo//d8A/Zljg4OVmYI5H0quv4qMG0H85vNbT2s9rbGjAki7TVr9gN4Rsf7yFc69aRkfCaOJ+1ZYbfaH4/rVz/W70OHpdJgap7qTslI+wwQTxoGv5YJFScBW7YiZJDmTU5O4lHEAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KaZovOcV; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e8e0aa2e3f9so1630788276.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 11:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753728075; x=1754332875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcW9YT4umCsQsq4GXt/Df/GuqdFRmh89E1PylPZViJg=;
        b=KaZovOcVekEl0VRhyIAzLpFbjECyfXO3Vt96bRmTUUmzNSMT5zUZbTnTj0sk/LEjqM
         /buwh5aJc7hLLafTx4IZHgRsjR/LBpgz3htrkXaSGplKv/DBMnGOv0lF7BK7UgUSy3wq
         IpilToEayc+c0An5PYTgMOFlGZSq72ywmeEHNL7I34i85CEGoC7x0jxk+n0nFTMEj3ro
         /+cQNDB0cs1+8sCZURe2hUuXuhWaZd4nBsbg3UdB9E2zniwhcB27zTYj5g8Siw5Hwx88
         FP2MwYmHuk4xUGmuQOMH7tSSI9fOXIGav+2h5EtVTCzulp7d5FX+qRgphG1aQyMZXEYc
         9/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753728076; x=1754332876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IcW9YT4umCsQsq4GXt/Df/GuqdFRmh89E1PylPZViJg=;
        b=h0w2POlWKd3Z2FTTledehCR3KMXX6IMu0c8PLtIBkyJIpFOxaUwj2wHuVBBXMGq0s2
         DQdnQND6l3TP2UnA5fv2dzs0RTYW5nxKJvbbiFG8DcSuKlJ+tX11yJnYqEQYqZjyqUuD
         CfkOkkx3BcRQ0HdDXa9T3Q1pNfrUResD2TJpt7iqTxG30aINyIeFvRyJ8bJopj5HziTb
         9MiUuIIYJiFIEdD7LovGXeGDAoJptIVsFVrYHFcNW3EJMdnOTy7sLajxl0hKY+rcGaW0
         MymI6tHTj4pdR0QUolP124FJx+8kNtQYlAepWbVkcy3BOdmoLQpm7AbzR9AjHjgBmt92
         pKZg==
X-Forwarded-Encrypted: i=1; AJvYcCU2BqiCOCL9XpSkg8rwLwGx2ZMXhh3AiMhCezK34RCwM6eGbw9di5cBhSym6/5j1KncD2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOFV7EKdTimICVHoUTlftOoMjikt1Xpf0nX2HhCzfDwIn3n/5y
	6SRU/qwxGAYlGfqWupzUhjUfINPHw1rhdDfltnrTg9uDv6rqh2MAjBESXtHViT/r00Q5MdoedrU
	tZvCJL2C2gcPvYDTNQ259nW/SObU/XlZ92k58WQFx
X-Gm-Gg: ASbGncuVXFGgO2WxjXHoJa8JXIcnzZ6oDvjwiTuje6MWq9aafHazYMLQu3/CNjd5XAt
	8r6DKQmAbN+JCyBneOrIOG4/T5EC1PMdsP8vGFY+mD8IwqZHFvSr/ye68pCycsZVUPFsxTb9vwj
	WKuvTdwGJvf6WDa+lAKzTP+eqVzsSsl+BQ4JweQgL0mTlBu/YMuL4+hBS3UzdRbWE+Zw3JXhhYs
	7rGneRVBZG5flDs8COLgoIwJ8owpzAlqUOO
X-Google-Smtp-Source: AGHT+IHJXVEqdrBcAnXuWTXHuvnxMMbIDKrglSs4ZONJ/fmemCGL+0skuCrs971o7keTd04AvO3sGQGtgRZWwCamA6Q=
X-Received: by 2002:a25:2003:0:b0:e8d:7121:c1d4 with SMTP id
 3f1490d57ef6-e8df1257d62mr10719565276.49.1753728075348; Mon, 28 Jul 2025
 11:41:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-8-jthoughton@google.com> <aIFOV4ydqsyDH72G@google.com>
In-Reply-To: <aIFOV4ydqsyDH72G@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 28 Jul 2025 11:40:38 -0700
X-Gm-Features: Ac12FXzNRSGTZQCvwPF4p1LQM7f4KRHOP7ZrLSwhiH3TkaYDZA11PdSrSTxTMtA
Message-ID: <CADrL8HVJrHrb3AJV5wYtL9x0XHx+-bNFreO4-OyztFOrupE5eg@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] KVM: selftests: Add an NX huge pages jitter test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2025 at 2:04=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 07, 2025, James Houghton wrote:
> > +             /*
> > +              * To time the jitter on all faults on pages that are not
> > +              * undergoing nx huge page recovery, only execute on ever=
y
> > +              * other 1G region, and only time the non-executing pass.
> > +              */
> > +             if (page & (1UL << 18)) {
>
> This needs a #define or helper, I have no idea what 1 << 18 is doing.

I'll use (SZ_1G >> PAGE_SHIFT), thanks. It's just checking if `page`
lies within an odd-numbered 1G region.

>
> > +                     uint64_t tsc1, tsc2;
> > +
> > +                     tsc1 =3D rdtsc();
> > +                     *gva =3D 0;
> > +                     tsc2 =3D rdtsc();
> > +
> > +                     if (tsc2 - tsc1 > max_cycles)
> > +                             max_cycles =3D tsc2 - tsc1;
> > +             } else {
> > +                     *gva =3D RETURN_OPCODE;
> > +                     ((void (*)(void)) gva)();
> > +             }
> > +     }
> > +
> > +     GUEST_SYNC1(max_cycles);
> > +}
> > +
> > +struct kvm_vm *create_vm(uint64_t memory_bytes,
> > +                      enum vm_mem_backing_src_type backing_src)
> > +{
> > +     uint64_t backing_src_pagesz =3D get_backing_src_pagesz(backing_sr=
c);
> > +     struct guest_args *args =3D &guest_args;
> > +     uint64_t guest_num_pages;
> > +     uint64_t region_end_gfn;
> > +     uint64_t gpa, size;
> > +     struct kvm_vm *vm;
> > +
> > +     args->guest_page_size =3D getpagesize();
> > +
> > +     guest_num_pages =3D vm_adjust_num_guest_pages(VM_MODE_DEFAULT,
> > +                             memory_bytes / args->guest_page_size);
> > +
> > +     TEST_ASSERT(memory_bytes % getpagesize() =3D=3D 0,
> > +                 "Guest memory size is not host page size aligned.");
> > +
> > +     vm =3D __vm_create_with_one_vcpu(&vcpu, guest_num_pages, guest_co=
de);
> > +
> > +     /* Put the test region at the top guest physical memory. */
> > +     region_end_gfn =3D vm->max_gfn + 1;
> > +
> > +     /*
> > +      * If there should be more memory in the guest test region than t=
here
> > +      * can be pages in the guest, it will definitely cause problems.
> > +      */
> > +     TEST_ASSERT(guest_num_pages < region_end_gfn,
> > +                 "Requested more guest memory than address space allow=
s.\n"
> > +                 "    guest pages: %" PRIx64 " max gfn: %" PRIx64
> > +                 " wss: %" PRIx64 "]",
>
> Don't wrap this last one.
>
> > +                 guest_num_pages, region_end_gfn - 1, memory_bytes);
> > +
> > +     gpa =3D (region_end_gfn - guest_num_pages - 1) * args->guest_page=
_size;
> > +     gpa =3D align_down(gpa, backing_src_pagesz);
> > +
> > +     size =3D guest_num_pages * args->guest_page_size;
> > +     pr_info("guest physical test memory: [0x%lx, 0x%lx)\n",
> > +             gpa, gpa + size);
>
> And don't wrap here either (82 chars is totally fine).

Right.

>
> > +
> > +     /*
> > +      * Pass in MAP_POPULATE, because we are trying to test how long
> > +      * we have to wait for a pending NX huge page recovery to take.
> > +      * We do not want to also wait for GUP itself.
> > +      */
>
> Right, but we also don't want to wait for the initial fault-in either, no=
?  I.e.
> plumbing in MAP_POPULATE only fixes the worst of the delay, and maybe onl=
y with
> the TDP MMU enabled.
>
> In other words, it seems like we need a helper (option?) to excplitly "pr=
efault",
> all memory from within the guest, not the ability to specify MAP_POPULATE=
.

I don't want the EPT to be populated.

In the event of a hugepage being executed, consider another memory
access. The access can either (1) be in the executed-from hugepage or
(2) be somewhere else.

For (1), the optimization in this series doesn't help; we will often
be stuck behind the hugepage either being destroyed or reconstructed.

For (2), the optimization in this series is an improvement, and that's
what this test is trying to demonstrate. But this is only true if the
EPT does not have a valid mapping for the GPA we tried to use. If it
does, the access will just proceed like normal.

This test only times these "case 2" accesses. Now if we didn't have
MAP_POPULATE, then (non-fast) GUP time appears in these results, which
(IIRC) adds so much noise that the improvement is difficult to
ascertain. But with MAP_POPULATE, the difference is very clear.

This test is 100% contrived to consistently reproduce the memory
access timing anomalies that Vipin demonstrated with his initial
posting of this series[1].

[1]: https://lore.kernel.org/kvm/20240906204515.3276696-3-vipinsh@google.co=
m/

>
> > +     vm_mem_add(vm, backing_src, gpa, 1,
> > +                guest_num_pages, 0, -1, 0, MAP_POPULATE);
> > +
> > +     virt_map(vm, guest_test_virt_mem, gpa, guest_num_pages);
> > +
> > +     args->pages =3D guest_num_pages;
> > +
> > +     /* Export the shared variables to the guest. */
> > +     sync_global_to_guest(vm, guest_args);
> > +
> > +     return vm;
> > +}
> > +
> > +static void run_vcpu(struct kvm_vcpu *vcpu)
> > +{
> > +     struct timespec ts_elapsed;
> > +     struct timespec ts_start;
> > +     struct ucall uc =3D {};
> > +     int ret;
> > +
> > +     clock_gettime(CLOCK_MONOTONIC, &ts_start);
> > +
> > +     ret =3D _vcpu_run(vcpu);
> > +
> > +     ts_elapsed =3D timespec_elapsed(ts_start);
> > +
> > +     TEST_ASSERT(ret =3D=3D 0, "vcpu_run failed: %d", ret);
> > +
> > +     TEST_ASSERT(get_ucall(vcpu, &uc) =3D=3D UCALL_SYNC,
> > +                 "Invalid guest sync status: %" PRIu64, uc.cmd);
> > +
> > +     pr_info("Duration: %ld.%09lds\n",
> > +             ts_elapsed.tv_sec, ts_elapsed.tv_nsec);
> > +     pr_info("Max fault latency: %" PRIu64 " cycles\n", uc.args[0]);
> > +}
> > +
> > +static void run_test(struct test_params *params)
> > +{
> > +     /*
> > +      * The fault + execute pattern in the guest relies on having more=
 than
> > +      * 1GiB to use.
> > +      */
> > +     TEST_ASSERT(params->memory_bytes > PAGE_SIZE << 18,
>
> Oooh, the 1 << 18 is 1GiB on PFNs.  Ugh.  Just use SZ_1G here.  And asser=
t immediate
> after setting params.memory_bytes, don't wait until the test runs.

Will do, thanks.

>
> > +                 "Must use more than 1GiB of memory.");
> > +
> > +     create_vm(params->memory_bytes, params->backing_src);
> > +
> > +     pr_info("\n");
> > +
> > +     run_vcpu(vcpu);
> > +}
> > +
> > +static void help(char *name)
> > +{
> > +     puts("");
> > +     printf("usage: %s [-h] [-b bytes] [-s mem_type]\n",
> > +            name);
> > +     puts("");
> > +     printf(" -h: Display this help message.");
> > +     printf(" -b: specify the size of the memory region which should b=
e\n"
> > +            "     dirtied by the guest. e.g. 2048M or 3G.\n"
> > +            "     (default: 2G, must be greater than 1G)\n");
> > +     backing_src_help("-s");
> > +     puts("");
> > +     exit(0);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     struct test_params params =3D {
> > +             .backing_src =3D DEFAULT_VM_MEM_SRC,
> > +             .memory_bytes =3D DEFAULT_TEST_MEM_SIZE,
> > +     };
> > +     int opt;
> > +
> > +     while ((opt =3D getopt(argc, argv, "hb:s:")) !=3D -1) {
> > +             switch (opt) {
> > +             case 'b':
> > +                     params.memory_bytes =3D parse_size(optarg);
> > +                     break;
> > +             case 's':
> > +                     params.backing_src =3D parse_backing_src_type(opt=
arg);
> > +                     break;
> > +             case 'h':
> > +             default:
> > +                     help(argv[0]);
> > +                     break;
> > +             }
> > +     }
> > +
> > +     run_test(&params);
> > +}
> > --
> > 2.50.0.727.gbf7dc18ff4-goog
> >

