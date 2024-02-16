Return-Path: <kvm+bounces-8908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C669A858678
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 21:01:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0B9D1C2128C
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 20:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5F5137C51;
	Fri, 16 Feb 2024 20:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="39ULICnh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A53712FF60
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 20:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708113651; cv=none; b=aFnKBRuhTWKyZLh1Cw/gZfQ2UA6YweWEO6nZGKoWd82ZuxBkoSAvZKmYLCxWGbT+VbIGzE28b9tfNSj4VZRFCUYReyi++fOXtcPwaN/8TsOLepKhBdOiDPagBDa0tgXceYmwKlgNImISjsuVM51SQqYbH5j/brKSi/APPU3DQgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708113651; c=relaxed/simple;
	bh=wHb2Sol1izBmr+PlZcMv4kwhMrZqDh8KK0mAiWkKkVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h+Leoaokjwq17XDE6rPsZ7ArKWHIdmyi7W9iJTFmm89qpCPT6QO7VcqbbejzRcyd9Xv5UHYcmHk7NpOrIGvW7Z2Uep7fxL6QXIYZgjXphzcEX3DJ6JYr2Hv8TuV5OCerOV46L6Yarjlja9CCZFpX/2yNnj1kBQc4Xt/jXPvzQmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=39ULICnh; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3c134813841so903032b6e.0
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 12:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708113648; x=1708718448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZOD0553Lqm6cAPSb+tzRXoeZsY8DitV5rPjpakd9UQk=;
        b=39ULICnhLExeBzncflpHQlaWoYEYgXJRvw2a6oyd7HweSmlSWhM2ONpZGXREzJddaE
         PYsaK0gyf/1G2NO9WEk40TD8dDM3S7rKmodzOh1Qvw7dbW5cgPdKc/WeJeRX+cXsjS9F
         KO92ewMEx826F+M+0/zcqG30ViGMT4pBoNOgRIEQn1rR9rWNzU/8TholC038Bk8gjmbs
         om5EYZuTxC0T9WFM8W/nnnTDPGh0xUqoRna5AdJaRpiNxN6h2EPWErQvnlnWEgPwcD87
         UAuZBkNe8Pz9OJXjatu20hkoy3K3a0HSkHUJ+gq+jMMhUUQZ0M6OsnvY00isnL5Zjr92
         7uTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708113648; x=1708718448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZOD0553Lqm6cAPSb+tzRXoeZsY8DitV5rPjpakd9UQk=;
        b=PI8GxLDkou4EWALFxEkhZgDCA9cFLFp7+yig6TbtfF+9UhIneWTxSa1b0UDzdCuriG
         3o81VVaW5h56ClVB5aTS6kK1NscH21EDis1GJkEyd3uydsoqMDg0VhtiTfEnp8m2+UQy
         KYA0kQFChGxLcsYiWQ9FisffUcgxvgKFMvYgo+8vLB3xz5bZ9p7Q2mWdpIB1kbz2mL/N
         19cyZvJmMIQqO7yMN3to9dFdMHRic6y7oPUah704bNLxekvWToAf5TC9WG9iDN+F6m0i
         hirQPbDyqpXrBli2rTXK15ijIUWKEwBxHPCftAcwF+F9iuyPiCiqsjHx5EyK7YKgfb/8
         oywg==
X-Forwarded-Encrypted: i=1; AJvYcCWhE7p9ACtsb3AaKOKMbUaWwWTGZbz9VcENSRgh0vVIuJxVXrQ+Y4pGRmZe0SkjYStZmLqRiNXa1GD33hZP2j2DknAw
X-Gm-Message-State: AOJu0Yyxvl/oZnYdAE7xyQ3d1wPkfPW4sYQ6HVRsXagIAC99IICbYRq5
	ikwv2f81cl+8kj+KBDgkaL+RA+uicmmC1PxoknV5de/A1/NQ2mRaK4R50cBZDuXFdL1TUsFt8K7
	8n43R3JHny/fF0ejONsHqfM1TZcR4aG9uXN8P
X-Google-Smtp-Source: AGHT+IHtkezdrHb07d9IxACTsLidKdtFLYo+vlzlkEsfpYtIqvFJxBeH3UWxznH9bFJhmYFkU+eFX8I9TJqSm/SHuKM=
X-Received: by 2002:a05:6808:f0f:b0:3c1:31f8:577a with SMTP id
 m15-20020a0568080f0f00b003c131f8577amr2532663oiw.18.1708113647708; Fri, 16
 Feb 2024 12:00:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <1f67639d-c6a2-1f36-b086-eb65fa2ab275@amd.com>
In-Reply-To: <1f67639d-c6a2-1f36-b086-eb65fa2ab275@amd.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 16 Feb 2024 12:00:10 -0800
Message-ID: <CAF7b7mrsVogiXwcjP_kNp4KviGa3sfhr2HXP2JD1T4y-OO6Zqg@mail.gmail.com>
Subject: Re: [PATCH v7 00/14] Improve KVM + userfaultfd performance via
 KVM_EXIT_MEMORY_FAULTs on stage-2 faults
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2024 at 11:36=E2=80=AFPM Gupta, Pankaj <pankaj.gupta@amd.co=
m> wrote:
>
> On 2/16/2024 12:53 AM, Anish Moorthy wrote:
> > This series adds an option to cause stage-2 fault handlers to
> > KVM_MEMORY_FAULT_EXIT when they would otherwise be required to fault in
> > the userspace mappings. Doing so allows userspace to receive stage-2
> > faults directly from KVM_RUN instead of through userfaultfd, which
> > suffers from serious contention issues as the number of vCPUs scales.
>
> Thanks for your work!

:D

>
> So, this is an alternative approach userspace like Qemu to do post copy
> live migration using KVM_MEMORY_FAULT_EXIT instead of userfaultfd which
> seems slower with more vCPU's.
>
> Maybe I am missing some things here, just curious how userspace VMM e.g
> Qemu would do memory copy with this approach once the page is available
> from remote host which was done with UFFDIO_COPY earlier?

This new capability is meant to be used *alongside* userfaultfd during
post-copy: it's not a replacement. KVM_RUN can generate page faults
from outside the stage-2 fault handlers (IIUC instruction emulation is
one source), and these paths are unchanged: so it's important that
userspace still UFFDIO_REGISTERs KVM's mapping and reads from the UFFD
to catch these guest accesses. But with the new
KVM_MEM_EXIT_ON_MISSING memslot flag set, the stage-2 handlers will
report needing to fault in memory via KVM_MEMORY_FAULT_EXIT instead of
queuing onto the UFFD.

In the workloads I've tested, the vast majority of guest-generated
page faults (99%+) come from the stage-2 handlers. So this series
"solves" the issue of contention on the UFFD file descriptor by
(mostly) sidestepping it.

As for how userspace actually uses the new functionality: when a vCPU
thread receives a KVM_MEMORY_FAULT_EXIT for an unfetched page during
post-copy it might

(a) Fetch the page
(b) Install the page into KVM's mapping via UFFDIO_COPY (don't
necessarily need to UFFDIO_WAKE!)
(c) Call KVM_RUN to re-enter the guest and retry the access. The
stage-2 fault handler will fire again but almost certainly won't
KVM_MEMORY_FAULT_EXIT now (since the UFFDIO_COPY will have mapped the
page), so the guest can continue.

and userspace can continue using some thread(s) to

(a) Read page faults from the UFFD.
(b) Install the page using UFFDIO_COPY + UFFDIO_WAKE
(c) goto (a)

to make sure it catches everything. The combination of these two things
adds up to more performant "uffd-based" postcopy.

I'm of course skimming over some details (e.g.: when two vCPU threads
race to fetch a page one of them should probably MADV_POPULATE_WRITE
somehow), but I hope this is helpful. My patch to the KVM demand
paging self test might also clarify things a bit [1].

Please let me know if you have more questions!

[1] https://lore.kernel.org/kvm/1f67639d-c6a2-1f36-b086-eb65fa2ab275@amd.co=
m/T/#m28055e5d708103d126985e38e18b591d535e1e84




> Just trying to understand how this will work for the existing interfaces.
> Best regards,
> Pankaj
>
> >
> > Support for the new option (KVM_CAP_EXIT_ON_MISSING) is added to the
> > demand_paging_test, which demonstrates the scalability improvements:
> > the following data was collected using [2] on an x86 machine with 256
> > cores.
> >
> > vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new =
caps)
> > 1       150     340
> > 2       191     477
> > 4       210     809
> > 8       155     1239
> > 16      130     1595
> > 32      108     2299
> > 64      86      3482
> > 128     62      4134
> > 256     36      4012
> >
> > The diff since the last version is small enough that I've attached a
> > range-diff in the cover letter- hopefully it's useful for review.
> >
> > Links
> > ~~~~~
> > [1] Original RFC from James Houghton:
> >      https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka=
1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
> >
> > [2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
> >      A quick rundown of the new flags (also detailed in later commits)
> >          -a registers all of guest memory to a single uffd.
> >          -r species the number of reader threads for polling the uffd.
> >          -w is what actually enables the new capabilities.
> >      All data was collected after applying the entire series
> >
> > ---
> >
> > v7
> >    - Add comment for the upgrade-to-atomic in __gfn_to_pfn_memslot()
> >      [James]
> >    - Expand description for KVM_MEM_GUEST_MEMFD in kvm/api.rst [James]
> >      and split it off into its own commit [Anish]
> >    - Update documentation to indicate that KVM_CAP_MEMORY_FAULT_INFO is
> >      available on arm [James]
> >    - Expand commit message for the "enable KVM_CAP_MEMORY_FAULT_INFO on
> >      arm64" commit [Anish]
> >    - Drop buggy "fast GUP on read faults" patch [Thanks James!]
> >    - Make KVM_MEM_READONLY and KVM_MEM_EXIT_ON_MISSING mutually exclusi=
ve
> >      [Sean, Oliver]
> >    - Drop incorrect "Documentation:" from some shortlogs [Sean]
> >    - Add description for the KVM_EXIT_MEMORY_FAULT RWX patch [Sean]
> >    - Style issues [Sean]
> >
> > v6: https://lore.kernel.org/kvm/20231109210325.3806151-1-amoorthy@googl=
e.com/
> >    - Rebase onto guest_memfd series [Anish/Sean]
> >    - Set write fault flag properly in user_mem_abort() [Oliver]
> >    - Reformat unnecessarily multi-line comments [Sean]
> >    - Drop the kvm_vcpu_read|write_guest_page() annotations [Sean]
> >    - Rename *USERFAULT_ON_MISSING to *EXIT_ON_MISSING [David]
> >    - Remove unnecessary rounding in user_mem_abort() annotation [David]
> >    - Rewrite logs for KVM_MEM_EXIT_ON_MISSING patches and squash
> >      them with the stage-2 fault annotation patches [Sean]
> >    - Undo the enum parameter addition to __gfn_to_pfn_memslot(), and ju=
st
> >      add another boolean parameter instead [Sean]
> >    - Better shortlog for the hva_to_pfn_fast() change [Anish]
> >
> > v5: https://lore.kernel.org/kvm/20230908222905.1321305-1-amoorthy@googl=
e.com/
> >    - Rename APIs (again) [Sean]
> >    - Initialize hardware_exit_reason along w/ exit_reason on x86 [Isaku=
]
> >    - Reword hva_to_pfn_fast() change commit message [Sean]
> >    - Correct style on terminal if statements [Sean]
> >    - Switch to kconfig to signal KVM_CAP_USERFAULT_ON_MISSING [Sean]
> >    - Add read fault flag for annotated faults [Sean]
> >    - read/write_guest_page() changes
> >        - Move the annotations into vcpu wrapper fns [Sean]
> >        - Reorder parameters [Robert]
> >    - Rename kvm_populate_efault_info() to
> >      kvm_handle_guest_uaccess_fault() [Sean]
> >    - Remove unnecessary EINVAL on trying to enable memory fault info ca=
p [Sean]
> >    - Correct description of the faults which hva_to_pfn_fast() can now
> >      resolve [Sean]
> >    - Eliminate unnecessary parameter added to __kvm_faultin_pfn() [Sean=
]
> >    - Magnanimously accept Sean's rewrite of the handle_error_pfn()
> >      annotation [Anish]
> >    - Remove vcpu null check from kvm_handle_guest_uaccess_fault [Sean]
> >
> > v4: https://lore.kernel.org/kvm/20230602161921.208564-1-amoorthy@google=
.com/T/#t
> >    - Fix excessive indentation [Robert, Oliver]
> >    - Calculate final stats when uffd handler fn returns an error [Rober=
t]
> >    - Remove redundant info from uffd_desc [Robert]
> >    - Fix various commit message typos [Robert]
> >    - Add comment about suppressed EEXISTs in selftest [Robert]
> >    - Add exit_reasons_known definition for KVM_EXIT_MEMORY_FAULT [Rober=
t]
> >    - Fix some include/logic issues in self test [Robert]
> >    - Rename no-slow-gup cap to KVM_CAP_NOWAIT_ON_FAULT [Oliver, Sean]
> >    - Make KVM_CAP_MEMORY_FAULT_INFO informational-only [Oliver, Sean]
> >    - Drop most of the annotations from v3: see
> >      https://lore.kernel.org/kvm/20230412213510.1220557-1-amoorthy@goog=
le.com/T/#mfe28e6a5015b7cd8c5ea1c351b0ca194aeb33daf
> >    - Remove WARN on bare efaults [Sean, Oliver]
> >    - Eliminate unnecessary UFFDIO_WAKE call from self test [James]
> >
> > v3: https://lore.kernel.org/kvm/ZEBXi5tZZNxA+jRs@x1n/T/#t
> >    - Rework the implementation to be based on two orthogonal
> >      capabilities (KVM_CAP_MEMORY_FAULT_INFO and
> >      KVM_CAP_NOWAIT_ON_FAULT) [Sean, Oliver]
> >    - Change return code of kvm_populate_efault_info [Isaku]
> >    - Use kvm_populate_efault_info from arm code [Oliver]
> >
> > v2: https://lore.kernel.org/kvm/20230315021738.1151386-1-amoorthy@googl=
e.com/
> >
> >      This was a bit of a misfire, as I sent my WIP series on the mailin=
g
> >      list but was just targeting Sean for some feedback. Oliver Upton a=
nd
> >      Isaku Yamahata ended up discovering the series and giving me some
> >      feedback anyways, so thanks to them :) In the end, there was enoug=
h
> >      discussion to justify retroactively labeling it as v2, even with t=
he
> >      limited cc list.
> >
> >    - Introduce KVM_CAP_X86_MEMORY_FAULT_EXIT.
> >    - API changes:
> >          - Gate KVM_CAP_MEMORY_FAULT_NOWAIT behind
> >            KVM_CAP_x86_MEMORY_FAULT_EXIT (on x86 only: arm has no such
> >            requirement).
> >          - Switched to memslot flag
> >    - Take Oliver's simplification to the "allow fast gup for readable
> >      faults" logic.
> >    - Slightly redefine the return code of user_mem_abort.
> >    - Fix documentation errors brought up by Marc
> >    - Reword commit messages in imperative mood
> >
> > v1: https://lore.kernel.org/kvm/20230215011614.725983-1-amoorthy@google=
.com/
> >
> > Anish Moorthy (14):
> >    KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
> >    KVM: Add function comments for __kvm_read/write_guest_page()
> >    KVM: Documentation: Make note of the KVM_MEM_GUEST_MEMFD memslot fla=
g
> >    KVM: Simplify error handling in __gfn_to_pfn_memslot()
> >    KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to
> >      userspace
> >    KVM: Add memslot flag to let userspace force an exit on missing hva
> >      mappings
> >    KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and annotate EFAULTs from
> >      stage-2 fault handler
> >    KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and annotate fault in t=
he
> >      stage-2 fault handler
> >    KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
> >    KVM: selftests: Report per-vcpu demand paging rate from demand pagin=
g
> >      test
> >    KVM: selftests: Allow many vCPUs and reader threads per UFFD in dema=
nd
> >      paging test
> >    KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
> >      signal errors via TEST_ASSERT
> >    KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
> >    KVM: selftests: Handle memory fault exits in demand_paging_test
> >
> >   Documentation/virt/kvm/api.rst                |  39 ++-
> >   arch/arm64/kvm/Kconfig                        |   1 +
> >   arch/arm64/kvm/arm.c                          |   1 +
> >   arch/arm64/kvm/mmu.c                          |   7 +-
> >   arch/powerpc/kvm/book3s_64_mmu_hv.c           |   2 +-
> >   arch/powerpc/kvm/book3s_64_mmu_radix.c        |   2 +-
> >   arch/x86/kvm/Kconfig                          |   1 +
> >   arch/x86/kvm/mmu/mmu.c                        |   8 +-
> >   include/linux/kvm_host.h                      |  21 +-
> >   include/uapi/linux/kvm.h                      |   5 +
> >   .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
> >   .../selftests/kvm/access_tracking_perf_test.c |   2 +-
> >   .../selftests/kvm/demand_paging_test.c        | 295 ++++++++++++++---=
-
> >   .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
> >   .../testing/selftests/kvm/include/memstress.h |   2 +-
> >   .../selftests/kvm/include/userfaultfd_util.h  |  17 +-
> >   tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
> >   .../selftests/kvm/lib/userfaultfd_util.c      | 159 ++++++----
> >   .../kvm/memslot_modification_stress_test.c    |   2 +-
> >   .../x86_64/dirty_log_page_splitting_test.c    |   2 +-
> >   virt/kvm/Kconfig                              |   3 +
> >   virt/kvm/kvm_main.c                           |  46 ++-
> >   22 files changed, 453 insertions(+), 172 deletions(-)
> >
> > Range-diff against v6:
> >   1:  2089d8955538 !  1:  063d5d109f34 KVM: Documentation: Clarify mean=
ing of hva_to_pfn()'s 'atomic' parameter
> >      @@ Metadata
> >       Author: Anish Moorthy <amoorthy@google.com>
> >
> >        ## Commit message ##
> >      -    KVM: Documentation: Clarify meaning of hva_to_pfn()'s 'atomic=
' parameter
> >      +    KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
> >
> >      -    The current docstring can be read as "atomic -> allowed to sl=
eep," when
> >      -    in fact the intended statement is "atomic -> NOT allowed to s=
leep." Make
> >      -    that clearer in the docstring.
> >      +    The current description can be read as "atomic -> allowed to =
sleep,"
> >      +    when in fact the intended statement is "atomic -> NOT allowed=
 to sleep."
> >      +    Make that clearer in the docstring.
> >
> >           Signed-off-by: Anish Moorthy <amoorthy@google.com>
> >
> >   2:  36963c6eee29 !  2:  e038fe64f44a KVM: Documentation: Add docstrin=
gs for __kvm_read/write_guest_page()
> >      @@ Metadata
> >       Author: Anish Moorthy <amoorthy@google.com>
> >
> >        ## Commit message ##
> >      -    KVM: Documentation: Add docstrings for __kvm_read/write_guest=
_page()
> >      +    KVM: Add function comments for __kvm_read/write_guest_page()
> >
> >           The (gfn, data, offset, len) order of parameters is a little =
strange
> >      -    since "offset" applies to "gfn" rather than to "data". Add do=
cstrings to
> >      -    make things perfectly clear.
> >      +    since "offset" applies to "gfn" rather than to "data". Add fu=
nction
> >      +    comments to make things perfectly clear.
> >
> >           Signed-off-by: Anish Moorthy <amoorthy@google.com>
> >
> >   -:  ------------ >  3:  812a2208da95 KVM: Documentation: Make note of=
 the KVM_MEM_GUEST_MEMFD memslot flag
> >   3:  4994835c51f5 =3D  4:  44cec9bf6166 KVM: Simplify error handling i=
n __gfn_to_pfn_memslot()
> >   4:  3d51224854b1 !  5:  df09c7482fbf KVM: Define and communicate KVM_=
EXIT_MEMORY_FAULT RWX flags to userspace
> >      @@ Metadata
> >        ## Commit message ##
> >           KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags t=
o userspace
> >
> >      +    kvm_prepare_memory_fault_exit() already takes parameters desc=
ribing the
> >      +    RWX-ness of the relevant access but doesn't actually do anyth=
ing with
> >      +    them. Define and use the flags necessary to pass this informa=
tion on to
> >      +    userspace.
> >      +
> >           Suggested-by: Sean Christopherson <seanjc@google.com>
> >           Signed-off-by: Anish Moorthy <amoorthy@google.com>
> >
> >   5:  6bab46398020 <  -:  ------------ KVM: Try using fast GUP to resol=
ve read faults
> >   6:  556e7079c419 !  6:  6a6993bda462 KVM: Add memslot flag to let use=
rspace force an exit on missing hva mappings
> >      @@ Commit message
> >
> >           Suggested-by: James Houghton <jthoughton@google.com>
> >           Suggested-by: Sean Christopherson <seanjc@google.com>
> >      -    Reviewed-by: James Houghton <jthoughton@google.com>
> >           Signed-off-by: Anish Moorthy <amoorthy@google.com>
> >
> >        ## Documentation/virt/kvm/api.rst ##
> >       @@ Documentation/virt/kvm/api.rst: yet and must be cleared on ent=
ry.
> >      -   /* for kvm_userspace_memory_region::flags */
> >          #define KVM_MEM_LOG_DIRTY_PAGES      (1UL << 0)
> >          #define KVM_MEM_READONLY     (1UL << 1)
> >      -+  #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
> >      +   #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
> >       +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
> >
> >        This ioctl allows the user to create, modify or delete a guest p=
hysical
> >      @@ Documentation/virt/kvm/api.rst: It is recommended that the lowe=
r 21 bits of gues
> >        be identical.  This allows large pages in the guest to be backed=
 by large
> >        pages in the host.
> >
> >      --The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
> >      --KVM_MEM_READONLY.  The former can be set to instruct KVM to keep=
 track of
> >      +-The flags field supports three flags
> >       +The flags field supports four flags
> >      -+
> >      -+1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep =
track of
> >      +
> >      + 1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep =
track of
> >        writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl t=
o know how to
> >      --use it.  The latter can be set, if KVM_CAP_READONLY_MEM capabili=
ty allows it,
> >      -+use it.
> >      -+2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capabi=
lity allows it,
> >      - to make a new slot read-only.  In this case, writes to this memo=
ry will be
> >      +@@ Documentation/virt/kvm/api.rst: to make a new slot read-only. =
 In this case, writes to this memory will be
> >        posted to userspace as KVM_EXIT_MMIO exits.
> >      -+3.  KVM_MEM_GUEST_MEMFD
> >      + 3.  KVM_MEM_GUEST_MEMFD: see KVM_SET_USER_MEMORY_REGION2. This f=
lag is
> >      + incompatible with KVM_SET_USER_MEMORY_REGION.
> >       +4.  KVM_MEM_EXIT_ON_MISSING: see KVM_CAP_EXIT_ON_MISSING for det=
ails.
> >
> >        When the KVM_CAP_SYNC_MMU capability is available, changes in th=
e backing of
> >        the memory region are automatically reflected into the guest.  F=
or example, an
> >      +@@ Documentation/virt/kvm/api.rst: Instead, an abort (data abort =
if the cause of the page-table update
> >      + was a load or a store, instruction abort if it was an instructio=
n
> >      + fetch) is injected in the guest.
> >      +
> >      ++Note: KVM_MEM_READONLY and KVM_MEM_EXIT_ON_MISSING are currently=
 mutually
> >      ++exclusive.
> >      ++
> >      + 4.36 KVM_SET_TSS_ADDR
> >      + ---------------------
> >      +
> >       @@ Documentation/virt/kvm/api.rst: error/annotated fault.
> >
> >        See KVM_EXIT_MEMORY_FAULT for more information.
> >      @@ include/uapi/linux/kvm.h: struct kvm_userspace_memory_region2 {
> >
> >        /* for KVM_IRQ_LINE */
> >        struct kvm_irq_level {
> >      -@@ include/uapi/linux/kvm.h: struct kvm_ppc_resize_hpt {
> >      +@@ include/uapi/linux/kvm.h: struct kvm_enable_cap {
> >        #define KVM_CAP_MEMORY_ATTRIBUTES 233
> >        #define KVM_CAP_GUEST_MEMFD 234
> >        #define KVM_CAP_VM_TYPES 235
> >       +#define KVM_CAP_EXIT_ON_MISSING 236
> >
> >      - #ifdef KVM_CAP_IRQ_ROUTING
> >      -
> >      + struct kvm_irq_routing_irqchip {
> >      +        __u32 irqchip;
> >
> >        ## virt/kvm/Kconfig ##
> >       @@ virt/kvm/Kconfig: config KVM_GENERIC_PRIVATE_MEM
> >      @@ virt/kvm/kvm_main.c: static int check_memory_region_flags(struc=
t kvm *kvm,
> >       +
> >               if (mem->flags & ~valid_flags)
> >                       return -EINVAL;
> >      ++       else if ((mem->flags & KVM_MEM_READONLY) &&
> >      ++                (mem->flags & KVM_MEM_EXIT_ON_MISSING))
> >      ++               return -EINVAL;
> >
> >      +        return 0;
> >      + }
> >       @@ virt/kvm/kvm_main.c: kvm_pfn_t hva_to_pfn(unsigned long addr, =
bool atomic, bool interruptible,
> >
> >        kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slo=
t, gfn_t gfn,
> >      @@ virt/kvm/kvm_main.c: kvm_pfn_t __gfn_to_pfn_memslot(const struc=
t kvm_memory_slot
> >                       writable =3D NULL;
> >               }
> >
> >      -+       if (!atomic && can_exit_on_missing
> >      -+           && kvm_is_slot_exit_on_missing(slot)) {
> >      ++       /* When the slot is exit-on-missing (and when we should r=
espect that)
> >      ++        * set atomic=3Dtrue to prevent GUP from faulting in the =
userspace
> >      ++        * mappings.
> >      ++        */
> >      ++       if (!atomic && can_exit_on_missing &&
> >      ++           kvm_is_slot_exit_on_missing(slot)) {
> >       +               atomic =3D true;
> >       +               if (async) {
> >       +                       *async =3D false;
> >   7:  28b6fe1ad5b9 !  7:  70696937be14 KVM: x86: Enable KVM_CAP_EXIT_ON=
_MISSING and annotate EFAULTs from stage-2 fault handler
> >      @@ Documentation/virt/kvm/api.rst: See KVM_EXIT_MEMORY_FAULT for m=
ore information.
> >
> >        ## arch/x86/kvm/Kconfig ##
> >       @@ arch/x86/kvm/Kconfig: config KVM
> >      -        select INTERVAL_TREE
> >      +        select KVM_VFIO
> >               select HAVE_KVM_PM_NOTIFIER if PM
> >               select KVM_GENERIC_HARDWARE_ENABLING
> >       +        select HAVE_KVM_EXIT_ON_MISSING
> >   8:  a80db5672168 <  -:  ------------ KVM: arm64: Enable KVM_CAP_MEMOR=
Y_FAULT_INFO
> >   -:  ------------ >  8:  05bbf29372ed KVM: arm64: Enable KVM_CAP_MEMOR=
Y_FAULT_INFO and annotate fault in the stage-2 fault handler
> >   9:  70c5db4f5c9e !  9:  bb22b31c8437 KVM: arm64: Enable KVM_CAP_EXIT_=
ON_MISSING and annotate an EFAULT from stage-2 fault-handler
> >      @@ Metadata
> >       Author: Anish Moorthy <amoorthy@google.com>
> >
> >        ## Commit message ##
> >      -    KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and annotate an EF=
AULT from stage-2 fault-handler
> >      +    KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
> >
> >           Prevent the stage-2 fault handler from faulting in pages when
> >           KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_=
memslot()
> >      -    calls to check the memslot flag.
> >      -
> >      -    To actually make that behavior useful, prepare a KVM_EXIT_MEM=
ORY_FAULT
> >      -    when the stage-2 handler cannot resolve the pfn for a fault. =
With
> >      -    KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of =
stage-2
> >      -    faults as vCPU exits, which userspace can attempt to resolve =
without
> >      -    terminating the guest.
> >      +    call to check the memslot flag. This effects the delivery of =
stage-2
> >      +    faults as vCPU exits (see KVM_CAP_MEMORY_FAULT_INFO), which u=
serspace
> >      +    can attempt to resolve without terminating the guest.
> >
> >           Delivering stage-2 faults to userspace in this way sidesteps =
the
> >           significant scalabiliy issues associated with using userfault=
fd for the
> >      @@ Documentation/virt/kvm/api.rst: See KVM_EXIT_MEMORY_FAULT for m=
ore information.
> >
> >        ## arch/arm64/kvm/Kconfig ##
> >       @@ arch/arm64/kvm/Kconfig: menuconfig KVM
> >      +        select SCHED_INFO
> >               select GUEST_PERF_EVENTS if PERF_EVENTS
> >      -        select INTERVAL_TREE
> >               select XARRAY_MULTI
> >       +        select HAVE_KVM_EXIT_ON_MISSING
> >               help
> >      @@ arch/arm64/kvm/mmu.c: static int user_mem_abort(struct kvm_vcpu=
 *vcpu, phys_addr
> >               if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
> >                       kvm_send_hwpoison_signal(hva, vma_shift);
> >                       return 0;
> >      -        }
> >      --       if (is_error_noslot_pfn(pfn))
> >      -+       if (is_error_noslot_pfn(pfn)) {
> >      -+               kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SI=
ZE, PAGE_SIZE,
> >      -+                                             write_fault, exec_f=
ault, false);
> >      -                return -EFAULT;
> >      -+       }
> >      -
> >      -        if (kvm_is_device_pfn(pfn)) {
> >      -                /*
> > 10:  ab913b9b5570 =3D 10:  a62ee8593b84 KVM: selftests: Report per-vcpu=
 demand paging rate from demand paging test
> > 11:  a27ff8b097d7 ! 11:  58ddb652eac1 KVM: selftests: Allow many vCPUs =
and reader threads per UFFD in demand paging test
> >      @@ Commit message
> >           configuring the number of reader threads per UFFD as well: ad=
d the "-r"
> >           flag to do so.
> >
> >      -    Acked-by: James Houghton <jthoughton@google.com>
> >           Signed-off-by: Anish Moorthy <amoorthy@google.com>
> >      +    Acked-by: James Houghton <jthoughton@google.com>
> >
> >        ## tools/testing/selftests/kvm/aarch64/page_fault_test.c ##
> >       @@ tools/testing/selftests/kvm/aarch64/page_fault_test.c: static =
void setup_uffd(struct kvm_vm *vm, struct test_params *p,
> > 12:  ee196df32964 ! 12:  b4cfe82097e2 KVM: selftests: Use EPOLL in user=
faultfd_util reader threads and signal errors via TEST_ASSERT
> >      @@ Commit message
> >           [1] Single-vCPU performance does suffer somewhat.
> >           [2] ./demand_paging_test -u MINOR -s shmem -v 4 -o -r <num re=
aders>
> >
> >      -    Acked-by: James Houghton <jthoughton@google.com>
> >           Signed-off-by: Anish Moorthy <amoorthy@google.com>
> >      +    Acked-by: James Houghton <jthoughton@google.com>
> >
> >        ## tools/testing/selftests/kvm/demand_paging_test.c ##
> >       @@
> > 13:  9406cb2581e5 =3D 13:  f8095728fcef KVM: selftests: Add memslot_fla=
gs parameter to memstress_create_vm()
> > 14:  dbab5917e1f6 ! 14:  a5863f1206bb KVM: selftests: Handle memory fau=
lt exits in demand_paging_test
> >      @@ Commit message
> >
> >           Demonstrate a (very basic) scheme for supporting memory fault=
 exits.
> >
> >      -    >From the vCPU threads:
> >      +    From the vCPU threads:
> >           1. Simply issue UFFDIO_COPY/CONTINUEs in response to memory f=
ault exits,
> >              with the purpose of establishing the absent mappings. Do s=
o with
> >              wake_waiters=3Dfalse to avoid serializing on the userfault=
fd wait queue
> >      @@ Commit message
> >           [A] In reality it is much likelier that the vCPU thread simpl=
y lost a
> >               race to establish the mapping for the page.
> >
> >      -    Acked-by: James Houghton <jthoughton@google.com>
> >           Signed-off-by: Anish Moorthy <amoorthy@google.com>
> >      +    Acked-by: James Houghton <jthoughton@google.com>
> >
> >        ## tools/testing/selftests/kvm/demand_paging_test.c ##
> >       @@
> >
> > base-commit: 687d8f4c3dea0758afd748968d91288220bbe7e3
>

