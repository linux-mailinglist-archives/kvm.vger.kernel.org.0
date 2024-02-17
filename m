Return-Path: <kvm+bounces-8971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 378AD8592B1
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 21:28:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8DC7280EE8
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 20:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E707E77B;
	Sat, 17 Feb 2024 20:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YLj98TrP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6393D7E581
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 20:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708201725; cv=none; b=KTy3Y/6OlMVSYwGG2XqRkrqZcN0fnx42NgdLOi/kbnfbLWTZGV9NbiYJMdf8LHBPBCi2mjC4sPlNKpJAMxFa0Va/oo+CbPXfeadJu/pezqZSG/80tgS+4P9uvXSISRNvBNNgZQZGeSSnGxpA2iwiH/aRPn3y3fFLGKgPaAWVs6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708201725; c=relaxed/simple;
	bh=fDVwmIS5hG50cQcU7rEpj4WlKe+b1sGiFYc33JEWIWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UL+ILX99rRvHkFzuSsr3dXT+7sZaVz53a9v1FD3lfQxGMS5EPahQ2Vh0znuJDlUg6Z3VgJVfp5VBmcpfsGQl7xprXVhgC6Wqi0UWjweFxhlDQ9ye+jQDVvmhyJ2h8aYK6snBzN/g7VBHr+Hh6isPD/RrsxpamkALcrjO48lCQBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YLj98TrP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dbcf58b05cso29715ad.0
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 12:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708201723; x=1708806523; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqNdYBSTrysSd/mY90h7edFyNLz3VjuiVskFnKsffMU=;
        b=YLj98TrPeAirA6n8aggqwfy/grmoTReXCeNr67XWiXPX3+JBK35f8MLTS6dJype2PQ
         0LaTMG6AnDZ7xFuXFY3zNsKKyH29VVaFxUQz6zxN/5elSu3wjJRDxFac/4W6/qZEvBUx
         5ciknkCeV3BxRNOybinqxib0q0180QMbTx/nCoRUqm9LOLEeY6EOSBqAqSU3L+sum+Oe
         jNZKtC/3SqK2GlEY1QXcVXLXkrUSuwrVkvygYeNjHXnqFEAbeIbO2aPxKnsqGVqqaiCf
         slZODiwu6F/ZbEZTYsT0/xKYsYs2H2vv5MZ0kOOUmQyUOOIqO5bUwYbXvhkMmCQwg8d/
         IiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708201723; x=1708806523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqNdYBSTrysSd/mY90h7edFyNLz3VjuiVskFnKsffMU=;
        b=NpygEBOHhyR91Tk0yo5QLykxb6saVFsPJ2KZ4HvGGuMPqsZelt1S/BKVa5U1JOl8qu
         ugnn5BLO54EJjckmSZzZjYLJQsy0VF0JrzS5BTIrpGg5xGguWvkAW+Euhm64EvoXwCmd
         h1kWlsKomGjGNiYzajLn57IzngXS8ZInmhHZLBZ4R+uH/Ps0ng5CoqBrS5PIjkfVIk5F
         TM9SVWBlU0OqLL0bdqxALcj234kothYXHSI9aYUmZkPdFWeyx+qYPO99Cwnq71Fw9dzE
         fDVWjgFDc+CtbD5TkGkBXtESE14uA5ZSY4fO1eBQmvG8jdVVrzzrnWuz/aRawG1Licoo
         a2JA==
X-Forwarded-Encrypted: i=1; AJvYcCUYHUHUCb0/3BUSOtQm3ArnS/NKQyzvS/IBB/bWCGjyIbZ2XXvCHB4JTFbGLRZYbfi4hIHp4G9GPvQiot9NhtXuic7r
X-Gm-Message-State: AOJu0YyNfd3wKY/R00KE8e/gG2NO5FLEhLrCNH0osaYCW/Mt0vcYdrOd
	eWOwGvMqMYIP/rSRVqnsQeB7LClykMgWBaHhVzD3OVVeOpPQSk8kWf6YkNv5uf9HWT3K01PLnfb
	wpGxCFaYuCHSqfA1f4nzhZtUvdWfFUlbhnZ89
X-Google-Smtp-Source: AGHT+IGxD1PY0fb7FcS+w6rfznB2Q0PKCaeeqv793sQ84IY+Gop0LdUF+cz8vjhn2EAzzjPIRh+f40cW8rf83aQzVrQ=
X-Received: by 2002:a17:902:cf4e:b0:1db:d064:5272 with SMTP id
 e14-20020a170902cf4e00b001dbd0645272mr49999plg.23.1708201722232; Sat, 17 Feb
 2024 12:28:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240217005738.3744121-1-atishp@rivosinc.com>
In-Reply-To: <20240217005738.3744121-1-atishp@rivosinc.com>
From: Ian Rogers <irogers@google.com>
Date: Sat, 17 Feb 2024 12:28:28 -0800
Message-ID: <CAP-5=fXh79aeHZ-M4CqP_GkfOHw0-7Cc1YLLGEyW5pT7t8eGHw@mail.gmail.com>
Subject: Re: [PATCH RFC 00/20] Add Counter delegation ISA extension support
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Atish Patra <atishp@atishpatra.org>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, 
	Evan Green <evan@rivosinc.com>, Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
	Ingo Molnar <mingo@redhat.com>, James Clark <james.clark@arm.com>, 
	Jing Zhang <renyu.zj@linux.alibaba.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>, John Garry <john.g.garry@oracle.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kan Liang <kan.liang@linux.intel.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, Ley Foon Tan <leyfoon.tan@starfivetech.com>, 
	linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Namhyung Kim <namhyung@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Peter Zijlstra <peterz@infradead.org>, 
	Rob Herring <robh+dt@kernel.org>, Samuel Holland <samuel.holland@sifive.com>, 
	Weilin Wang <weilin.wang@intel.com>, Will Deacon <will@kernel.org>, kaiwenxue1@gmail.com, 
	Yang Jihong <yangjihong1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 4:58=E2=80=AFPM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> This series adds the counter delegation extension support. It is based on
> very early PoC work done by Kevin Xue and mostly rewritten after that.
> The counter delegation ISA extension(Smcdeleg/Ssccfg) actually depends
> on multiple ISA extensions.
>
> 1. S[m|s]csrind : The indirect CSR extension[1] which defines additional
>    5 ([M|S|VS]IREG2-[M|S|VS]IREG6) register to address size limitation of
>    RISC-V CSR address space.
> 2. Smstateen: The stateen bit[60] controls the access to the registers
>    indirectly via the above indirect registers.
> 3. Smcdeleg/Ssccfg: The counter delegation extensions[2]
>
> The counter delegation extension allows Supervisor mode to program the
> hpmevent and hpmcounters directly without needing the assistance from the
> M-mode via SBI calls. This results in a faster perf profiling and very
> few traps. This extension also introduces a scountinhibit CSR which allow=
s
> to stop/start any counter directly from the S-mode. As the counter
> delegation extension potentially can have more than 100 CSRs, the specifi=
cation
> leverages the indirect CSR extension to save the precious CSR address ran=
ge.
>
> Due to the dependency of these extensions, the following extensions must =
be
> enabled in qemu to use the counter delegation feature in S-mode.
>
> "smstateen=3Dtrue,sscofpmf=3Dtrue,ssccfg=3Dtrue,smcdeleg=3Dtrue,smcsrind=
=3Dtrue,sscsrind=3Dtrue"
>
> When we access the counters directly in S-mode, we also need to solve the
> following problems.
>
> 1. Event to counter mapping
> 2. Event encoding discovery
>
> The RISC-V ISA doesn't define any standard either for event encoding or t=
he
> event to counter mapping rules.
>
> Until now, the SBI PMU implementation relies on device tree binding[3] to
> discover the event to counter mapping in RISC-V platform in the firmware.=
 The
> SBI PMU specification[4] defines event encoding for standard perf events =
as well.
> Thus, the kernel can query the appropriate counter for an given event fro=
m the
> firmware.
>
> However, the kernel doesn't need any firmware interaction for hardware
> counters if counter delegation is available in the hardware. Thus, the dr=
iver
> needs to discover the above mappings/encodings by itself without any assi=
stance
> from firmware. One of the options considered was to extend the PMU DT par=
sing
> support to kernel as well. However, that requires additional support in A=
CPI
> based system. It also needs more infrastructure in the virtualization as =
well.
>
> This patch series solves the above problem #1 by extending the perf tool =
in a
> way so that event json file can specify the counter constraints of each e=
vent
> and that can be passed to the driver to choose the best counter for a giv=
en
> event. The perf stat metric series[5] from Weilin already extend the perf=
 tool
> to parse "Counter" property to specify the hardware counter restriction.
> I have included the patch from Weilin in this series for verification pur=
poses
> only. I will rebase as that series evolves.
>
> This series extends that support by converting comma separated string to =
a
> bitmap. The counter constraint bitmap is passed to the perf driver via
> newly introduced "counterid_mask" property set in "config2". Even though,=
 this
> is a generic perf tool change, this should not affect any other architect=
ure
> if "counterid_mask" is not mapped.
>
> @Weilin: Please let me know if there is a better way to solve the problem=
 I
> described.
>
> The problem #2 is solved by defining a architecture specific override fun=
ction
> that will replace the perf standard event encoding with an encoding speci=
fied
> in the json file with the same event name. The alternate solution conside=
red
> was to specify the encodings in the driver. However, these encodings are =
vendor
> specific in absence of an ISA guidelines and will become unmanageable wit=
h
> so many RISC-V vendors touching the driver for their encoding.
>
> The override is only required when counter delegation is available in the
> platform which is detected at the runtime. The SBI PMU (current implement=
ation)
> doesn't require any override as it defines the standard event encoding. T=
he
> hwprobe syscall defined for RISC-V is used for this detection in this ser=
ies.
> A sysfs based property can be explored to do the same but we may require
> hwprobe in future given the churn of extensions in RISC-V. That's why, I =
went
> with hwprobe. Let me know if anybody thinks that's a bad idea.
>
> The perf tool also hook allows RISC-V ISA platform vendors to define thei=
r
> encoding for any standard perf or ISA event. I have tried to cover all th=
e use
> cases that I am aware of (stat, record, top). Please let me know if I hav=
e
> missed any particular use case where architecture hook must be invoked. I=
 am
> also open to any other idea to solve the above said problem.

Hi Atish,

Thank you for the work! I know how the perf tool discovers events is
somewhat assumed knowledge, I thought I'd just go through it here and
explain a difference that is landing in Linux 6.8, as well as recent
heterogeneous/hybrid/big.little support changes, just so those who
aren't up to speed can catch up for the sake of discussion on this
approach - sorry for turning this into a longer email than it perhaps
needs to be, and the historical take may lack accuracy that I
apologize in advance for.

The job of discovering events is to map a name like "cycles" into a
set up for the perf_event_attr passed to perf_event_open. This sounds
simple but "cycles" may be encoded differently for different PMUs on a
heterogeneous system, it may also be an event on an accelerator like a
GPU. So the first thing to recognize is that a name like "cycles" may
map onto multiple struct perf_event_attr values. The behavior of how
the perf tool does this lacks consistency, for example are all or just
core PMUs considered, but this is deliberate for the sake of somewhat
consistency by the tool over time. Perhaps in the future we'll
change/fix this as things like accelerators dominate performance
concerns.

The next thing is that what "cycles" means has been evolving over
Linux releases. Originally "cycles" was assumed to be a CPU event and
there were other events like "page-faults" which were software events.
In perf_event.h there are enums for the "type" of event (hardware,
software, cache, etc.) and for the actual event itself - cycles is
"config" value 0. In the code we tend to refer to this kind of
encoding as legacy. An ability was added (maybe it was always there)
to dynamically add PMUs and PMUs advertise the value for the struct
perf_event_attr through sysfs in  "/sys/devices/<pmu name>/type". On
x86 the performance core typically has a type matching the legacy
hardware number, but on ARM this isn't the case. So that legacy events
can work on heterogeneous/hybrid/big.little systems where there should
be multiple PMUs (looking at most Android devices for misconfiguring
this), there is an extended type field in the top 32-bits of the
struct perf_event_attr config. The extended type means I want this
legacy event type on the extended type PMU.

For non-legacy events there is a problem of how to map a name to a
config value (I'll say singular config value but overtime it has
actually become 4 64-bit values). The sysfs format directory
"/sys/devices/<pmu name>/format" does this. The files in the format
directory say that on x86 the event is encoded in the first byte of
the config and the umask in the second byte. If there is an event like
"assists.any" that has an event of 0xc1 and a umask of 7, then the
perf tool knows to create a config value of 0x7c1 using the format
encoding.

To go from an event name like "cycles" to a format encoding there are
two places to look, the first is "/sys/devices/<pmu name>/events/". In
the events directory on x86 there is a "cpu-cycles" that contains
"event=3D0x3c", i.e. a format style encoding. The second are the json
files that are mapped to format style encodings for a specific cpuid
by jevents.py. The easiest way to see the 2nd kind is to run "perf
list --details":
```
...
  assists.any
      [Number of occurrences where a microcode assist is invoked by hardwar=
e]
       default_core/event=3D0xc1,period=3D0x186a3,umask=3D0x7/
...
```
We can see there is a format style encoding that has been built into
the perf tool.

A place where ambiguity creeps in and is changing in Linux 6.8 is what
to do when we have the same event in places like the legacy name,
sysfs and the json? The behavior we have is:
1) "perf stat -e cycles ..." - the event was specified without PMUs,
it is assumed a legacy encoding on all core PMUs is preferred (note
non-core PMUs that have a cycles event are ignored, but this wouldn't
be the case if the event weren't a legacy event name)
2) "perf stat -e cpu/cycles/" - the event was specified with a core
PMU, prior to 6.8 (ie any current perf tool), a legacy encoding will
be used. In 6.8 and after the json and sysfs encoding will have
priority: https://lore.kernel.org/r/20231123042922.834425-1-irogers@google.=
com
3) "perf stat -e pmu/cycles/" - event was specified with a non-core
PMU so a legacy encoding won't be considered, only json and sysfs.

As I understand the problem you are trying to fix in the perf tool it
is for behavior 1 above, this is because the PMU driver wants the
legacy event encodings to be in json so it needn't discover them.
Behaviors 2 and 3 already prefer json encodings that are built into
the perf tool.

So given behavior 1 is kind of weird, it considers different PMUs
dependent on whether the event is legacy or not, it doesn't override
with a sysfs/json event if one is present, why don't we look to change
behavior 1 so that it is more like behaviors 2 and 3? I believe this
gives you the ability to override legacy events you want. At the same
time I'd like to also remove the "only core PMUs" assumption.

What would this look like? Well in the current code we take a legacy
event and then create a perf_event_attr for each core PMU:
https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/tr=
ee/tools/perf/util/parse-events.c?h=3Dperf-tools-next#n1348
We'd need to change this so that we wild card all the PMUs and
consider the sysfs/json events first, which is what we already do
here:
https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/tr=
ee/tools/perf/util/parse-events.y?h=3Dperf-tools-next#n305
with the sysfs/json fix up being here:
https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/tr=
ee/tools/perf/util/parse-events.c?h=3Dperf-tools-next#n1016

As with the 6.8 change to prioritize sysfs/json over legacy the
largest part of this change will be updating all the test
expectations. Wdyt?

Things this patch series does that I don't like:
 - hardcoding the expected CPU's PMU to "cpu", this should almost
certainly be an iterator over all core PMU types. This allows core
PMUs not to be called "cpu" and for heterogeneous configurations to
work.
 - doing things in an arch specific way. Test coverage is really hard
and when something lives in arch directory we lose coverage unless we
run on that machine type. Ugh, I'm just reminded that ARM
heterogeneous is broken because of an arch override that doesn't
consider >1 core PMU. Testing an ARM heterogenous PMU set up is hard
but not doing so breaks people running Linux on M1 macs. Really we
should just have PMU specific behaviors and the arch directory should
disappear. This would also greatly help cross architecture work where
you may record from perf on one architecture, but analyze the data on
another.
 - we've been moving to have perf and the json have less special
architecture knowledge. Weilin's patches aside, we've added things
like  "/sys/devices/<pmu name>/caps/slots" so that metrics can use
"#slots" rather than hard coding the pipeline width in each metric. My
hope for Weilin's patches is that we can make it less Intel specific
and ultimately we may be able to advertise the specific features like
number of fixed and generic counters via something like sysfs.
However, the counters an event can go on is a property of the event so
I see a need for the sysfs/json to add this.

Congratulations if you got this far, sorry this email was so long. Thanks,
Ian

> PATCH organization:
> PATCH 1 is from the perf metric series[5]
> PATCH 2-5 defines and implements the indirect CSR extension.
> PATCH 6-10 defines the other required ISA extensions.
> PATCH 11 just an overall restructure of the RISC-V PMU driver.
> PATCH 12-14 implements the counter delegation extension and new perf tool
> plumbings to solve #1 and #2.
> PATCH 15-16 improves the perf tool support to solve #1 and #2.
> PATCH 17 adds a perf json file for qemu virt machine.
> PATCH 18-20 adds hwprobe mechanism to enable perf to detect if platform s=
upports
> delegation extensions.
>
> There is no change in process to run perf stat/record and will continue t=
o work
> as it is as long as the relevant extensions have been enabled in Qemu.
>
> However, the perf tool needs to be recompiled with as it requires new ken=
rel
> headers.
>
> The Qemu patches can be found here:
> https://github.com/atishp04/qemu/tree/counter_delegation_rfc
>
> The opensbi patch can be found here:
> https://github.com/atishp04/opensbi/tree/counter_delegation_v1
>
> The Linux kernel patches can be found here:
> https://github.com/atishp04/linux/tree/counter_delegation_rfc
>
> [1] https://github.com/riscv/riscv-indirect-csr-access
> [2] https://github.com/riscv/riscv-smcdeleg-ssccfg
> [3] https://www.kernel.org/doc/Documentation/devicetree/bindings/perf/ris=
cv%2Cpmu.yaml
> [4] https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-pm=
u.adoc
> [5] https://lore.kernel.org/all/20240209031441.943012-4-weilin.wang@intel=
.com/
>
> Atish Patra (17):
> RISC-V: Add Sxcsrind ISA extension definition and parsing
> dt-bindings: riscv: add Sxcsrind ISA extension description
> RISC-V: Define indirect CSR access helpers
> RISC-V: Add Ssccfg ISA extension definition and parsing
> dt-bindings: riscv: add Ssccfg ISA extension description
> RISC-V: Add Smcntrpmf extension parsing
> dt-bindings: riscv: add Smcntrpmf ISA extension description
> RISC-V: perf: Restructure the SBI PMU code
> RISC-V: perf: Modify the counter discovery mechanism
> RISC-V: perf: Implement supervisor counter delegation support
> RISC-V: perf: Use config2 for event to counter mapping
> tools/perf: Add arch hooks to override perf standard events
> tools/perf: Pass the Counter constraint values in the pmu events
> perf: Add json file for virt machine supported events
> tools arch uapi: Sync the uinstd.h header file for RISC-V
> RISC-V: Add hwprobe support for Counter delegation extensions
> tools/perf: Detect if platform supports counter delegation
>
> Kaiwen Xue (2):
> RISC-V: Add Sxcsrind ISA extension CSR definitions
> RISC-V: Add Sscfg extension CSR definition
>
> Weilin Wang (1):
> perf pmu-events: Add functions in jevent.py to parse counter and event
> info for hardware aware grouping
>
> Documentation/arch/riscv/hwprobe.rst          |  10 +
> .../devicetree/bindings/riscv/extensions.yaml |  34 +
> MAINTAINERS                                   |   4 +-
> arch/riscv/include/asm/csr.h                  |  47 ++
> arch/riscv/include/asm/csr_ind.h              |  42 ++
> arch/riscv/include/asm/hwcap.h                |   5 +
> arch/riscv/include/asm/sbi.h                  |   2 +-
> arch/riscv/include/uapi/asm/hwprobe.h         |   4 +
> arch/riscv/kernel/cpufeature.c                |   5 +
> arch/riscv/kernel/sys_hwprobe.c               |   3 +
> arch/riscv/kvm/vcpu_pmu.c                     |   2 +-
> drivers/perf/Kconfig                          |  16 +-
> drivers/perf/Makefile                         |   4 +-
> .../perf/{riscv_pmu.c =3D> riscv_pmu_common.c}  |   0
> .../perf/{riscv_pmu_sbi.c =3D> riscv_pmu_dev.c} | 654 ++++++++++++++----
> include/linux/perf/riscv_pmu.h                |  13 +-
> tools/arch/riscv/include/uapi/asm/unistd.h    |  14 +-
> tools/perf/arch/riscv/util/Build              |   2 +
> tools/perf/arch/riscv/util/evlist.c           |  60 ++
> tools/perf/arch/riscv/util/pmu.c              |  41 ++
> tools/perf/arch/riscv/util/pmu.h              |  11 +
> tools/perf/builtin-record.c                   |   3 +
> tools/perf/builtin-stat.c                     |   2 +
> tools/perf/builtin-top.c                      |   3 +
> .../pmu-events/arch/riscv/arch-standard.json  |  10 +
> tools/perf/pmu-events/arch/riscv/mapfile.csv  |   1 +
> .../pmu-events/arch/riscv/qemu/virt/cpu.json  |  30 +
> .../arch/riscv/qemu/virt/firmware.json        |  68 ++
> tools/perf/pmu-events/jevents.py              | 186 ++++-
> tools/perf/pmu-events/pmu-events.h            |  25 +-
> tools/perf/util/evlist.c                      |   6 +
> tools/perf/util/evlist.h                      |   6 +
> 32 files changed, 1167 insertions(+), 146 deletions(-)
> create mode 100644 arch/riscv/include/asm/csr_ind.h
> rename drivers/perf/{riscv_pmu.c =3D> riscv_pmu_common.c} (100%)
> rename drivers/perf/{riscv_pmu_sbi.c =3D> riscv_pmu_dev.c} (61%)
> create mode 100644 tools/perf/arch/riscv/util/evlist.c
> create mode 100644 tools/perf/arch/riscv/util/pmu.c
> create mode 100644 tools/perf/arch/riscv/util/pmu.h
> create mode 100644 tools/perf/pmu-events/arch/riscv/arch-standard.json
> create mode 100644 tools/perf/pmu-events/arch/riscv/qemu/virt/cpu.json
> create mode 100644 tools/perf/pmu-events/arch/riscv/qemu/virt/firmware.js=
on
>
> --
> 2.34.1
>

