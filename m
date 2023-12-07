Return-Path: <kvm+bounces-3881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A1B809557
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 23:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E51E282043
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 22:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1347257313;
	Thu,  7 Dec 2023 22:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="qwvQgD/k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB7B1729
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 14:28:35 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-50be10acaf9so1306114e87.1
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 14:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1701988113; x=1702592913; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F7X6vTFqWb09Hl26abSc3iWrCQ3sx3FODL4PuiNVTps=;
        b=qwvQgD/k5SqjXaqCLOFfY5Vgj+s5ig5xf04vC7RV8K0TKdYo4CZlsbpaKb5XTCGqPC
         l8KDBxF8dhnxOg7UT8zlXppkMUgv61J0S/sETV+AsKPZ4d3Y9TEaRgEvTbLs7TYLWl2X
         CeY+HXrsCTrP6fqfn+pYPR0F+Il0sL+haHTUYGMflMauBSUUSuKe0s1ssRVPhBzm9o3i
         OKeuTVxTM4E0kX4s/J/yLWhLrcUyi/mKFcFYg8EnIavQY4L9nh4N+WKpcvGtK3+NhNn4
         F7n51FobRuWE9CzIuK1NBzAz1J5EdSBuEY7tWygez8zFUpA7K2nFrqmIedt5/CUmKTjn
         5z+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701988113; x=1702592913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F7X6vTFqWb09Hl26abSc3iWrCQ3sx3FODL4PuiNVTps=;
        b=gTbxB5MOSzHjY5TCo2l6hw1gkgSF2Aydc5rheIRwKULg5iij5962vsX11dZgBKOvRS
         YSCbCdkmWkiVPNIc/pwC/cPtf58NZfZmlpHgvM2bWXxZYDj0NrjTNH2k1sQfaEtq/O8S
         T2itDcEsE5lrMjPZ9Jg4hoBMdqiOHywtv0Exm9XVwZKjdXWQFsQDvt+h2Hdojak3cOWj
         3Nt4GxUYjyzwEW5fbhISXPt+VN54EyG2gKyG14nqDILBtclphzu4l5oPQzgJlyuGU/oY
         CprXNZik3Hn4dTyofN2daz/k0ybH1Kd7+G4XVCnLYsAzXg9ilAH94SxzHcmZjX0CkYlv
         DfJQ==
X-Gm-Message-State: AOJu0Yx+8YsrB7U6yKCvfDMDxmrjjmezV0IE1HN24+CI4/nz7aeiPtsn
	tK66lgYQa4snqtagGwW9YWtMgPiXQQTOULL478lDoQ==
X-Google-Smtp-Source: AGHT+IFMeUkqr61TWZyGhho/o1itZ/1GgltEbBbTaiobf127xgg0OQ1wLqtREkQkBS7yymtzB1YAtzVIkINFM0Xan+8=
X-Received: by 2002:a05:6512:2203:b0:50b:f88d:f848 with SMTP id
 h3-20020a056512220300b0050bf88df848mr3898378lfu.23.1701988113187; Thu, 07 Dec
 2023 14:28:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231207-affiliate-state-c4a20ea7e8de@wendy>
In-Reply-To: <20231207-affiliate-state-c4a20ea7e8de@wendy>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Thu, 7 Dec 2023 14:28:22 -0800
Message-ID: <CAHBxVyGE48dprUk+QnQ0WDijy0fi3fu5abDGjBKjuZhXC8y1vw@mail.gmail.com>
Subject: Re: [RFC 0/9] RISC-V SBI v2.0 PMU improvements and Perf sampling in
 KVM guest
To: Conor Dooley <conor.dooley@microchip.com>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 7, 2023 at 4:03=E2=80=AFAM Conor Dooley <conor.dooley@microchip=
.com> wrote:
>
> Hey Atish,
>
> On Mon, Dec 04, 2023 at 06:43:01PM -0800, Atish Patra wrote:
> > This series implements SBI PMU improvements done in SBI v2.0[1] i.e. PM=
U snapshot
> > and fw_read_hi() functions.
>
> I don't see any commentary in this cover letter as to why the series is
> an RFC. v2.0 is a frozen spec per the Releases tab on GitHub, so that
> has ruled out the usual reason for spec related things being RFCs.
>
> What is it about the series that you are not yet willing to stand over?
>

Nothing. It's just my script where I tag any first version of a
feature series as RFC :).
I am planning to send the next one with a version tag this week as I
got some feedback.

Thanks for reviewing the patches :).

> Cheers,
> Conor.
>
> > SBI v2.0 introduced PMU snapshot feature which allows the SBI implement=
ation
> > to provide counter information (i.e. values/overlfow status) via a shar=
ed
> > memory between the SBI implementation and supervisor OS. This allows to=
 minimize
> > the number of traps in when perf being used inside a kvm guest as it re=
lies on
> > SBI PMU + trap/emulation of the counters.
> >
> > The current set of ratified RISC-V specification also doesn't allow sco=
untovf
> > to be trap/emulated by the hypervisor. The SBI PMU snapshot bridges the=
 gap
> > in ISA as well and enables perf sampling in the guest. However, LCOFI i=
n the
> > guest only works via IRQ filtering in AIA specification. That's why, AI=
A
> > has to be enabled in the hardware (at least the Ssaia extension) in ord=
er to
> > use the sampling support in the perf.
> >
> > Here are the patch wise implementation details.
> >
> > PATCH 1-2 : Generic cleanups/improvements.
> > PATCH 3,4,9 : FW_READ_HI function implementation
> > PATCH 5-6: Add PMU snapshot feature in sbi pmu driver
> > PATCH 7-8: KVM implementation for snapshot and sampling in kvm guests
> >
> > The series is based on v6.70-rc3 and is available at:
> >
> > https://github.com/atishp04/linux/tree/kvm_pmu_snapshot_v1
> >
> > The kvmtool patch is also available at:
> > https://github.com/atishp04/kvmtool/tree/sscofpmf
> >
> > It also requires Ssaia ISA extension to be present in the hardware in o=
rder to
> > get perf sampling support in the guest. In Qemu virt machine, it can be=
 done
> > by the following config.
> >
> > ```
> > -cpu rv64,sscofpmf=3Dtrue,x-ssaia=3Dtrue
> > ```
> >
> > There is no other dependancies on AIA apart from that. Thus, Ssaia must=
 be disabled
> > for the guest if AIA patches are not available. Here is the example com=
mand.
> >
> > ```
> > ./lkvm-static run -m 256 -c2 --console serial -p "console=3DttyS0 early=
con" --disable-ssaia -k ./Image --debug
> > ```
> >
> > The series has been tested only in Qemu.
> > Here is the snippet of the perf running inside a kvm guest.
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > # perf record -e cycles -e instructions perf bench sched messaging -g 5
> > ...
> > # Running 'sched/messaging' benchmark:
> > ...
> > [   45.928723] perf_duration_warn: 2 callbacks suppressed
> > [   45.929000] perf: interrupt took too long (484426 > 483186), lowerin=
g kernel.perf_event_max_sample_rate to 250
> > # 20 sender and receiver processes per group
> > # 5 groups =3D=3D 200 processes run
> >
> >      Total time: 14.220 [sec]
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.117 MB perf.data (1942 samples) ]
> > # perf report --stdio
> > # To display the perf.data header info, please use --header/--header-on=
ly optio>
> > #
> > #
> > # Total Lost Samples: 0
> > #
> > # Samples: 943  of event 'cycles'
> > # Event count (approx.): 5128976844
> > #
> > # Overhead  Command          Shared Object                Symbol       =
        >
> > # ........  ...............  ...........................  .............=
........>
> > #
> >      7.59%  sched-messaging  [kernel.kallsyms]            [k] memcpy
> >      5.48%  sched-messaging  [kernel.kallsyms]            [k] percpu_co=
unter_ad>
> >      5.24%  sched-messaging  [kernel.kallsyms]            [k] __sbi_rfe=
nce_v02_>
> >      4.00%  sched-messaging  [kernel.kallsyms]            [k] _raw_spin=
_unlock_>
> >      3.79%  sched-messaging  [kernel.kallsyms]            [k] set_pte_r=
ange
> >      3.72%  sched-messaging  [kernel.kallsyms]            [k] next_upto=
date_fol>
> >      3.46%  sched-messaging  [kernel.kallsyms]            [k] filemap_m=
ap_pages
> >      3.31%  sched-messaging  [kernel.kallsyms]            [k] handle_mm=
_fault
> >      3.20%  sched-messaging  [kernel.kallsyms]            [k] finish_ta=
sk_switc>
> >      3.16%  sched-messaging  [kernel.kallsyms]            [k] clear_pag=
e
> >      3.03%  sched-messaging  [kernel.kallsyms]            [k] mtree_ran=
ge_walk
> >      2.42%  sched-messaging  [kernel.kallsyms]            [k] flush_ica=
che_pte
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >
> > [1] https://github.com/riscv-non-isa/riscv-sbi-doc
> >
> > Atish Patra (9):
> > RISC-V: Fix the typo in Scountovf CSR name
> > drivers/perf: riscv: Add a flag to indicate SBI v2.0 support
> > RISC-V: Add FIRMWARE_READ_HI definition
> > drivers/perf: riscv: Read upper bits of a firmware counter
> > RISC-V: Add SBI PMU snapshot definitions
> > drivers/perf: riscv: Implement SBI PMU snapshot function
> > RISC-V: KVM: Implement SBI PMU Snapshot feature
> > RISC-V: KVM: Add perf sampling support for guests
> > RISC-V: KVM: Support 64 bit firmware counters on RV32
> >
> > arch/riscv/include/asm/csr.h          |   5 +-
> > arch/riscv/include/asm/errata_list.h  |   2 +-
> > arch/riscv/include/asm/kvm_vcpu_pmu.h |  16 +-
> > arch/riscv/include/asm/sbi.h          |  11 ++
> > arch/riscv/include/uapi/asm/kvm.h     |   1 +
> > arch/riscv/kvm/main.c                 |   1 +
> > arch/riscv/kvm/vcpu.c                 |   8 +-
> > arch/riscv/kvm/vcpu_onereg.c          |   1 +
> > arch/riscv/kvm/vcpu_pmu.c             | 232 ++++++++++++++++++++++++--
> > arch/riscv/kvm/vcpu_sbi_pmu.c         |  10 ++
> > drivers/perf/riscv_pmu.c              |   1 +
> > drivers/perf/riscv_pmu_sbi.c          | 219 ++++++++++++++++++++++--
> > include/linux/perf/riscv_pmu.h        |   6 +
> > 13 files changed, 478 insertions(+), 35 deletions(-)
> >
> > --
> > 2.34.1
> >

