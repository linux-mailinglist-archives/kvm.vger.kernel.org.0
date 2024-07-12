Return-Path: <kvm+bounces-21538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69EA292FEDE
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA9D11F2275F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232A9176ABB;
	Fri, 12 Jul 2024 17:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wi1L5shi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6180F1EA85
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803654; cv=none; b=NRrOk9b4Tt98jY/4cA/utVW6fIlPJM+N+5hkZxhNMDnAvRCfm4nrY2D/yuNw6JgsQ1zNyhIYzdZcMVdQyoZWb7IX08C/bpFqhUh45pplsoXeYmOZmzi355HlSSzqz3wy2/Mc0BJk2lQFs34Xjo85O0j3nz+tbzYxpCh1ZYVRgiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803654; c=relaxed/simple;
	bh=wIWOzS69gleIxjBKmtnOx157ayAHvbfhEpgvQBRYoVM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qmQyC2tBVaYKhSJWyGl77BdZi26cbMhvw+ErIknrgHsDo1hLF9PpPzI8CsTEEfM+wOGbbqXeGkHR+TKN7/bAGkelbytAgpRp2hvHDe6ig89i7h/5gQqR9G6fyS0XhG3u0C9PXm4hN64n6V4RimXHsEceoQ2NrUo7/cSRptBUuL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wi1L5shi; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-650ab31aabdso37426947b3.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803650; x=1721408450; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ytgXym087+ix+cfxoEZxubMQnnymiAhvQ7NveRcSk8=;
        b=wi1L5shibqw0XJHQYlHilRy9eQ++QkWRHEc1CCy61u1/LJVgkSN3yLiskI58RokFMk
         b98mmYLw7FcDRa1/5lfrBH9jzEphLch9P/gNyJGTqAtzq/D2NV7larwJ5zGXZn34NQgC
         FMroUqZQ+AF/7+62fqdOHJzDPogJDMB72vVMKlH3lNbxES15L453CWBosFu+mEeiZyWu
         UQjatyMwiQB/1joG/v1kRExDx26s+kP1AhwNOlIpTYfZbf4omdYyDmNCb8GnO0vU50Gl
         FC8B+ob8sdgCwtfNdsAPd2XFP4R6n05GRpXfCUkzPcw15+CIPo0JeABAN3d9lTV6R1Ih
         IOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803650; x=1721408450;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ytgXym087+ix+cfxoEZxubMQnnymiAhvQ7NveRcSk8=;
        b=qSTtmW9Q2sqqqeOwjhhwNzYAXywyFGHjyqudsgAVtS9UsHnmjCNTucQJNHIL8U6a1w
         mjQIBXWvN//1ScFOz59mWOumHRtYJKQeAt18dK4YkDRPQab9/vtE6FRu+HnqqmOCKhn6
         7QFBFxeJnytGzQFmq0wdUwwO0+SKSJC7KuqQk8KKSv/HBxj1CyAxsYxxIyf7f9mTmlw0
         zbTd/SfQ7AtB+Vsa1behaD953CjtjEpJ/8oqvlFRD1byoQf/Zj7ZMu3Tglz9PNUIPFZR
         inGQtVaeiVMr9aBCd0l9ZilLSnzJ7BY/SvPKOgpgDyiq2hSC0niXDpbGwcMaDQJwNxgX
         wVmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCuBb3lanaW2yP9HSYop0I0tSk/U0dbq+u0RrE9a7O7WSBQ63hxbpK5yM3q31ZdDsImeQXUZBuKe2Lo3RdXK7UsZ0E
X-Gm-Message-State: AOJu0YwvQ3kL1TwC7eQGHggFBB2fODK8ab7ww4zpIcOdbtE3jZffLk1f
	JzdtCTjvD0XPpKs3yAVBa6o66XBfRHJ03XxCVA8jSZw/iLUQzlNPFt+qLXpeEPfsFLitgq+NlY6
	LA4C8O0Ua8A==
X-Google-Smtp-Source: AGHT+IG8TqvI2dvWk82SqB0yV1lYetQwFSqt82oxKPZLUbnaxXLLUFdB2zZBUzpz1OE2g1GItFS4de1pWgNzGA==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:690c:60c8:b0:630:28e3:2568 with SMTP
 id 00721157ae682-658eeb6df10mr935937b3.3.1720803649963; Fri, 12 Jul 2024
 10:00:49 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:18 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIACNhkWYC/x2MQQqAIBAAvyJ7TtBtJegr0UF0rb1YKEQg/j3pN
 nOYaVC5CFdYVYPCj1S58hA7KQinzwdricMBDZJxSNpX0SUFPRDZ0xLIzg4jjOAunOT9Z9ve+wf 64CPtXAAAAA==
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Subject: [PATCH 00/26] Address Space Isolation (ASI) 2024
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>, Dennis Zhou <dennis@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Overview
=3D=3D=3D=3D=3D=3D=3D=3D
This RFC demonstrates an implementation of Address Space Isolation
(ASI), similar to Junaid Shahid=E2=80=99s proposal from 2022 [1].

Until now, mitigating hardware vulnerabilities has required one or both
of:

- Highly custom mitigations being developed under pressure for every
  specific exploit,
- Prohibitive performance penalties.

ASI is an attempt to improve both of these points by providing a single
technique that mitigates a very broad class of vulnerabilities while
still achieving a tolerable performance overhead.

The basic idea is to run the kernel in a =E2=80=9Crestricted address space=
=E2=80=9D,
where any page that could contain =E2=80=9Csensitive=E2=80=9D data is unmap=
ped. When the
kernel needs to access such data, a page fault occurs, in which we
switch back to the normal (=E2=80=9Cunrestricted=E2=80=9D) address space an=
d perform
vulnerability mitigations. Before returning to potentially malicious
code (VM guest/userspace) we transition back into the restricted address
space and get a chance to perform additional mitigations. Thus, we only
pay the cost of security mitigations for kernel entries (such as VM
Exit) that actually access sensitive data. If we can arrange for these
accesses to be infrequent, it becomes viable to perform aggressive
mitigations on address space transitions. For example, in this RFC we
attempt to obliterate indirect branch predictor training, without
needing to concern ourselves too much with microarchitectural details of
specific exploits. My talk at LSF/MM/BPF this year [2] has some
additional conceptual introduction with diagrams etc, plus some more
detailed discussion of the strategic pros and cons of ASI. Junaid=E2=80=99s=
 RFC
cover letter [1] has some additional discussion too, I won=E2=80=99t rehash=
 it
in detail.

Like Junaid=E2=80=99s RFC, this only implements ASI for protecting against
malicious KVM guests; this is a somewhat simpler use-case to start with.
However, ASI is written as a framework so that we can later use it to
sandbox bare metal processes too. Work has begun on prototyping this but
we don=E2=80=99t have a working implementation yet.

Rough structure of this series:

- 01-14: Establish ASI infrastructure, e.g. for manipulating pagetables,
  performing address space transitions.
- 15-19: Map data into the restricted address space.
- 20-23: Finalize a functionality correct ASI for KVM.=20
- 24-26: Switch it on and demonstrate actual vuln mitigation.

What=E2=80=99s new in this RFC?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Since Junaid=E2=80=99s initial efforts, Google has steadily invested more a=
nd
more deeply towards ASI as a keystone of hardware security. This RFC is
basically the same system that Junaid presented, but I=E2=80=99ve done my b=
est
to shrink it as much as possible. So, this is really just enough to
demonstrate ASI working end-to-end.

The most radical simplifications are the removal of =E2=80=9Clocal nonsensi=
tive=E2=80=9D
memory (see [1] for explanation) and the removal of all of the
TLB-flushing smarts. Those will be implemented later as an enhancement.

What=E2=80=99s needed to make this a PATCH?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

.:: Major problems

Aside from general missing features and performance issues there are two
major problems with this patchset:

 1. It adds a page flag.

 2. It creates artificial OOM conditions.

See =E2=80=9Cmm: asi: Map non-user buddy allocations as nonsensitive=E2=80=
=9D for
details of both problems.

I hope to solve these with a more intrusive but less hacky integration
into the buddy allocator. This was discussed at LSF/MM/BPF [2], I won=E2=80=
=99t
go into detail here, I just failed to get a prototype ready in time for
this RFC. I=E2=80=99ll need to have one ready before I can reasonably ask t=
o
merge anything. It remains an open question if we can find a way to
merge a minimal ASI without that complex integration, without creating
technical debt such as a page flag.

.:: Configuration

As well as the above, I think it needs a cleaner idea of how ASI should
be configured. In this RFC, it=E2=80=99s enabled by setting asi=3Don on the=
 kernel
command-line, and has barely any interaction with bugs.c. ASI does not
trivially fit into the existing configuration mechanism:

  a. Existing mitigations are generally configured per-vuln, while ASI
  is not a per-vuln mitigation.

  b. ASI will never be strictly equivalent to any other mitigation
  configuration (because it deliberately drops protection for at least
  some memory), so making it the default represents a moderately bold
  policy decision.

ASI also warrants configuration beyond on/off: In general because it
provides a way to avoid paying mitigation cost most of the time, in my
opinion ASI is best used in a mode that mitigates exploits beyond those
that are currently known to be possible on a given platform. For
example, in this RFC we attempt to obliterate _all_ indirect branch
predictor training before leaving the restricted address space, even on
platforms where no practical exploit is known to necessitate this. But I
expect many users to reject this philosophy, and the kernel ought to
support a different policy.

Input on this topic would be appreciated - even if it feels like
bikeshedding, I think it=E2=80=99s likely to provoke more interesting discu=
ssion
as a side effect. Otherwise I=E2=80=99ll just come up with _something_ and =
we
can discuss more at [PATCH] time. Perhaps a simple starting point would
be =E2=80=9Cmitigations=3Dasi=E2=80=9D.

.:: Minor issues

- KVM=E2=80=99s rseq_test fails with asi=3Don. I think this is =E2=80=9Cjus=
t=E2=80=9D a
  performance problem; KVM rseq logic is known to trigger ASI
  transitions without additional optimisations that will be explored for
  a later series.

- fill_return_buffer() causes an =E2=80=9Cunreachable instruction=E2=80=9D =
objtool
  warning. I haven=E2=80=99t investigated this.

- Some BUGs that should probably not crash the kernel.

What is =E2=80=9Csensitive memory=E2=80=9D?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

ASI is fundamentally creating a new security boundary. So, where does
the boundary go? In other words, what gets mapped into the restricted
address space?

This is determined at allocation time. In this RFC, there is a new
__GFP_SENSITIVE flag (currently only supported for buddy allocations,
not slab), and everything else is considered non-sensitive. This
default-nonsensitive approach is known as a =E2=80=9Cdenylist=E2=80=9D mode=
l. By simply
adding __GFP_SENSITIVE to GFP_USER, we can already deliver significant
protection from real-world attacks, while already being within reach of
pretty high performance results (more on this later).=20

However, it=E2=80=99s obviously not the case that all data worth leaking is
always in GFP_USER pages. There are two ways to respond to this problem:

1. Expand the denylist, i.e. try to set __GFP_SENSITIVE for all memory
   that can contain secrets.

2. Switch to an =E2=80=9Callowlist=E2=80=9D model where sensitive is the de=
fault. Then
   our job would instead be to set __GFP_NONSENSITIVE wherever we can
   determine it=E2=80=99s safe and worthwhile for performance.

Option 2 clearly puts us in a stronger security posture, but it has the
major disadvantage of risking unpredictable performance impacts: since
ASI transitions are costly, a random system change that causes new pages
to start being touched by the kernel is much more likely to create
sudden, hard-to-diagnose performance degradations. This makes switching
ASI on in production a much scarier proposition.

Opinions at LSF/MM/BPF were surprisingly relaxed about this topic. So if
possible I=E2=80=99d like to prefer option 1, and focus on getting Linux as=
 soon
as possible to a version of ASI that=E2=80=99s viable to run in production,=
 and
from there iterate towards stronger security guarantees. However,
discussion is welcome.

Performance
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I=E2=80=99m a little embarrassed that I don=E2=80=99t have performance data=
 with this
RFC, progress on getting this data has been painful so I decided to just
get discussion started on the implementation, and I hope to follow up
soon with data. Since the initial patchset I=E2=80=99ll be proposing to mer=
ge
will be minimal (something similar in scope to this RFC), we should
expect it to perform badly. So, I=E2=80=99ll need to put together a
forward-looking branch that includes that patchset plus additional
features from future patchsets, so that we can prove that good
performance is achievable longer-term.

Google=E2=80=99s internal version of ASI shows less than 5% degradation on =
all
end-to-end performance metrics, less than 1% is common. However for some
workloads this has required more advanced optimisations than those I
expect to post in the initial upstream branch, so we can expect a worse
degradation in some cases.

The branch that I published for LSF/MM/BPF [2] (not radically different
from this RFC) showed comparable performance to Safe RET for a single-VM
Redis benchmark (<5%), although this was not a rigorous analysis. See
[5] for a graph showing that ASI performs dramatically better than a
comparable blanket mitigation (IBPB on VM Exit).

I=E2=80=99m planning to try and run either the VM-supported workloads from
mmtests [3], or some set of workloads from PerfKit Benchmarker [4],
whichever turns out to be easiest. I=E2=80=99ll compare ASI against
mitigations=3Doff and one or two example configurations for existing
mitigations. Let me know if you have any specific requests/suggestions
for workloads or baseline-comparisons.

What=E2=80=99s next?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This cover letter is getting rather long, but briefly here are some work
items that need to be done for a =E2=80=9Ccomplete ASI=E2=80=9D, but which =
I=E2=80=99d like to
defer until infrastructure is already in place in-tree:

- More sensitivity annotations, which will require more allocator
  integrations

- More advanced/flexible mitigations in address space transitions

- Support for sandboxing bare-metal processes

- Avoid address space transitions by expanding the scope of what can be
  run in the restricted address space (e.g. context-switching between
  tasks in the same mm, returning to userspace)

- Deferring TLB flushing and using PCID properly

- Preventing cross-SMT attacks by halting sibling hyperthreads

- Non-x86 support (this isn=E2=80=99t prototyped at all, requires research,
  probably a much longer-term topic).

Acknowledgements
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Thanks to Alexander Chartre for the initial implementation that inspired
Junaid=E2=80=99s RFC.=20

Of course thanks to Junaid Shahid and Ofir Weisse for their fantastic
work on the 2022 RFC and Google=E2=80=99s initial internal implementation.

Reiji Watanabe, Yosry Ahmed and Patrick Bellasi are also major
contributors to this effort from Google (you=E2=80=99ll see them attributed=
 in
commit messages too).

Further thanks to Alexandra Sandulescu and Matteo Rizzo who have
provided security expertise for Google=E2=80=99s deployment. Alexandra is a=
lso
working on reliable easy-to-run exploit PoCs (as kernel selftests) which
have helped us to gain confidence that ASI actually mitigates
vulnerabilities.

References
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[1] Junaid=E2=80=99s RFC:
    https://lore.kernel.org/all/20220223052223.1202152-1-junaids@google.com=
/

[2] LSF/MM/BPF: https://www.youtube.com/watch?v=3DDxaN6X_fdlI
    LWN coverage: https://lwn.net/Articles/974390/
    Code: http://github.com/googleprodkernel/linux-kvm/tree/asi-lsfmmbpf-24

[3] mmtests: https://github.com/gormanm/mmtests

[4] PerfKit Benchmarker: https://github.com/GoogleCloudPlatform/PerfKitBenc=
hmarker

[5] Performance data at LSF/MM/BPF (timestamp link):
    https://youtu.be/DxaN6X_fdlI?t=3D557

To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: H. Peter Anvin <hpa@zytor.com>
To: Andy Lutomirski <luto@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
To: Peter Zijlstra <peterz@infradead.org>

To: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>

To: Alexandre Chartre <alexandre.chartre@oracle.com>
To: Liran Alon <liran.alon@oracle.com>
To: Jan Setje-Eilers <jan.setjeeilers@oracle.com>

To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>

To: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
To: Lorenzo Stoakes <lstoakes@gmail.com>
To: David Hildenbrand <david@redhat.com>
To: Vlastimil Babka <vbabka@suse.cz>
To: Michal Hocko <mhocko@kernel.org>
To: Khalid Aziz <khalid.aziz@oracle.com>

To: Juri Lelli <juri.lelli@redhat.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Valentin Schneider <vschneid@redhat.com>

To: Paul Turner <pjt@google.com>
To: Reiji Watanabe <reijiw@google.com>
To: Junaid Shahid <junaids@google.com>
To: Ofir Weisse <oweisse@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
To: Patrick Bellasi <derkling@google.com>
To: KP Singh <kpsingh@google.com>
To: Alexandra Sandulescu <aesa@google.com>
To: Matteo Rizzo <matteorizzo@google.com>
To: Jann Horn <jannh@google.com>

Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kvm@vger.kernel.org

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Brendan Jackman (15):
      x86: Create CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
      objtool: let some noinstr functions make indirect calls
      mm: asi: Add infrastructure for boot-time enablement
      mm: asi: ASI support in interrupts/exceptions
      mm: asi: Avoid warning from NMI userspace accesses in ASI context
      mm: Add __PAGEFLAG_FALSE
      mm: asi: Map non-user buddy allocations as nonsensitive
      mm: asi: Map kernel text and static data as nonsensitive
      mm: asi: Map vmalloc/vmap data as nonsesnitive
      KVM: x86: asi: Restricted address space for VM execution
      KVM: x86: asi: Stabilize CR3 when potentially accessing with ASI
      mm: asi: Stabilize CR3 in switch_mm_irqs_off()
      mm: asi: Make TLB flushing correct under ASI
      mm: asi: Stop ignoring asi=3Don cmdline flag
      KVM: x86: asi: Add some mitigations on address space transitions

Junaid Shahid (8):
      mm: asi: Make some utility functions noinstr compatible
      mm: asi: Introduce ASI core API
      mm: asi: Switch to unrestricted address space before a context switch
      mm: asi: Use separate PCIDs for restricted address spaces
      mm: asi: Make __get_current_cr3_fast() ASI-aware
      mm: asi: ASI page table allocation functions
      mm: asi: Functions to map/unmap a memory range into ASI page tables
      mm: asi: Add basic infrastructure for global non-sensitive mappings

Ofir Weisse (1):
      mm: asi: asi_exit() on PF, skip handling if address is accessible

Reiji Watanabe (1):
      mm: asi: Map dynamic percpu memory as nonsensitive

Yosry Ahmed (1):
      percpu: clean up all mappings when pcpu_map_pages() fails

 arch/alpha/include/asm/Kbuild            |   1 +
 arch/arc/include/asm/Kbuild              |   1 +
 arch/arm/include/asm/Kbuild              |   1 +
 arch/arm64/include/asm/Kbuild            |   1 +
 arch/csky/include/asm/Kbuild             |   1 +
 arch/hexagon/include/asm/Kbuild          |   1 +
 arch/loongarch/include/asm/Kbuild        |   1 +
 arch/m68k/include/asm/Kbuild             |   1 +
 arch/microblaze/include/asm/Kbuild       |   1 +
 arch/mips/include/asm/Kbuild             |   1 +
 arch/nios2/include/asm/Kbuild            |   1 +
 arch/openrisc/include/asm/Kbuild         |   1 +
 arch/parisc/include/asm/Kbuild           |   1 +
 arch/powerpc/include/asm/Kbuild          |   1 +
 arch/riscv/include/asm/Kbuild            |   1 +
 arch/s390/include/asm/Kbuild             |   1 +
 arch/sh/include/asm/Kbuild               |   1 +
 arch/sparc/include/asm/Kbuild            |   1 +
 arch/um/include/asm/Kbuild               |   1 +
 arch/x86/Kconfig                         |  27 ++
 arch/x86/include/asm/asi.h               | 267 +++++++++++
 arch/x86/include/asm/cpufeatures.h       |   1 +
 arch/x86/include/asm/disabled-features.h |   8 +-
 arch/x86/include/asm/idtentry.h          |  50 ++-
 arch/x86/include/asm/kvm_host.h          |   5 +
 arch/x86/include/asm/nospec-branch.h     |   2 +
 arch/x86/include/asm/processor.h         |  15 +-
 arch/x86/include/asm/special_insns.h     |   8 +-
 arch/x86/include/asm/tlbflush.h          |   5 +
 arch/x86/kernel/process.c                |   2 +
 arch/x86/kernel/traps.c                  |  22 +
 arch/x86/kvm/svm/svm.c                   |   2 +
 arch/x86/kvm/vmx/nested.c                |   8 +
 arch/x86/kvm/vmx/vmx.c                   | 124 +++--
 arch/x86/kvm/x86.c                       |  60 ++-
 arch/x86/lib/retpoline.S                 |   7 +
 arch/x86/mm/Makefile                     |   1 +
 arch/x86/mm/asi.c                        | 748 +++++++++++++++++++++++++++=
++++
 arch/x86/mm/fault.c                      | 119 ++++-
 arch/x86/mm/init.c                       |   5 +-
 arch/x86/mm/init_64.c                    |  25 +-
 arch/x86/mm/mm_internal.h                |   3 +
 arch/x86/mm/tlb.c                        | 136 +++++-
 arch/xtensa/include/asm/Kbuild           |   1 +
 include/asm-generic/asi.h                |  84 ++++
 include/asm-generic/vmlinux.lds.h        |  11 +
 include/linux/compiler_types.h           |   8 +
 include/linux/gfp_types.h                |  15 +-
 include/linux/mm_types.h                 |   7 +
 include/linux/page-flags.h               |  16 +
 include/linux/pgtable.h                  |   3 +
 include/trace/events/mmflags.h           |  12 +-
 kernel/fork.c                            |   3 +
 kernel/sched/core.c                      |   3 +
 mm/init-mm.c                             |   4 +
 mm/internal.h                            |   2 +
 mm/page_alloc.c                          | 143 +++++-
 mm/percpu-vm.c                           |  52 ++-
 mm/percpu.c                              |   4 +-
 mm/vmalloc.c                             |  61 ++-
 tools/objtool/check.c                    |  14 +
 tools/perf/builtin-kmem.c                |   1 +
 62 files changed, 1977 insertions(+), 136 deletions(-)
---
base-commit: a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6
change-id: 20240524-asi-rfc-24-2ea47c41352d

Best regards,
--=20
Brendan Jackman <jackmanb@google.com>


