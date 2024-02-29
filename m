Return-Path: <kvm+bounces-10336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D8C86BE3B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD60AB21128
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 01:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202EB2E62C;
	Thu, 29 Feb 2024 01:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="PRNTWzWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5831A2D048
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 01:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709169944; cv=none; b=JfwXVf4ez+U/Ivl/2/2rCfq1OAjJ45BPaKlnhRSV49qV+5SS0L5bLJNrMjYXagJu7l6SDUTrs2RjOkggWqjs8yMpi7ho5Ds8D+wczxZkZyDq9DxUXRG3O8KU6vXrLTCBs0p5LMiU4T0h4z4fCj1VYd9tmQNWFVXfeCe2rtDplIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709169944; c=relaxed/simple;
	bh=qIGnVqZ/Kay7J7/4DkGf5cjQtbvjlFkLUW8VJT2xv+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dW34pWr0hJObgybzGoAN5g28Ok2q2EqLM/RwKbMHwTVIYQYExINqWCf1XLQY4crb8UeLy3/XbhEXwN/+yr5641psD7UOOEzigDFVVKo0zhdmtI7MsxVftXPVjGDT06pVzjdftyxoAYMuGmSu2kjWkSAuKe2aiqnfKv1CzV1Zlqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=PRNTWzWZ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e55bb75c9eso315459b3a.3
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 17:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1709169939; x=1709774739; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q7x7uA7NSQkePcQ/Dz95qzCoBbFkkFThRf0k4ROWmH0=;
        b=PRNTWzWZ7sR5TXKazS85KzxxsaggSU8yytwdD3JP0Rfatw4nL6ekoofZinQ5rFWn0R
         Nx/6Ayl+yyoWAizqq3hh6rmipyt7dLRYYOBrvn+qI0ZqANwXsvdaMVqCTxPbTQRhRAWU
         IINUUGazqGcf218VwZ1/4JTiIjYgKdeOW60YSX5ftYtXxPLxjEf9nYPQFkwFpJKUYxHZ
         GN4tAmKp8ClC4V4Y9SUV90li6TXuEU9dqGa+aZ3sUrY3qZ4vJ4F6WJJxGoa5oxKSFYRN
         TZHIZEB3ecQkk8+1+3Tnh4QFoXHIazVpez+PPB7oz0erI8lHAXH7ld22C9kkTzR+FJ/6
         01bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709169939; x=1709774739;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q7x7uA7NSQkePcQ/Dz95qzCoBbFkkFThRf0k4ROWmH0=;
        b=TKf/3zYaE7KJ+aoLV6xpg2h4EJdbKIG1aOxCIXwEcUnby85ML1Mw37M3Y9h7MSaQWc
         EKotUdWzIRLgYAVBVKZ9QBNeudtUttKYLyV3Jlmi3djUIpwqxPCpxdWBrQRy/Nan8uyU
         QmqWLQh0xSD0vxUiMQTL3OAUBmX8wC5KkSii9bOagOoM/qS+Z77C66ZdigPf+fnD7jOH
         8n1p4uWvwGgOeYgRKrp/FgyZKj2/FHG/OjXNnXs8tgu37YXFNRJN9hZfEed6HREaa1Sn
         tof0QMOrFWVV4EmVvdF8BuMgqO0l9ZmAXFknpUF5py1S8lo2QAOx6Nh7WMbVL+8sCGV3
         ebwA==
X-Forwarded-Encrypted: i=1; AJvYcCXkYfKTixCz22IkjBgV1tidynZCqxsgSiO46K1F/Ox5F8uwV5SEOyYALsPmHGWkoWiLM1blRho3tkjJVGAZBJ+mLVEk
X-Gm-Message-State: AOJu0Yzl/fMk4cQWfc8ZXXPdXvs6NZpjrshJvHMqb52YEetFApF/yVkc
	WKbASGyF2ULh5rcmI9mltNNFT2/V5LNHdPjLywOybMOS/Qh8GmLtuClVYWyxbTA=
X-Google-Smtp-Source: AGHT+IGVNq0GdLLoZO6gsHV0enVh/g1iccgeAPyi28DWJ/hAb4TwrAvEc8ANrsMQqAciXHOFf/KYzQ==
X-Received: by 2002:a05:6a00:3d0c:b0:6e4:bb45:49f3 with SMTP id lo12-20020a056a003d0c00b006e4bb4549f3mr1315237pfb.34.1709169939235;
        Wed, 28 Feb 2024 17:25:39 -0800 (PST)
Received: from [172.16.0.23] (c-67-188-2-18.hsd1.ca.comcast.net. [67.188.2.18])
        by smtp.gmail.com with ESMTPSA id y37-20020a056a00182500b006e56b0f274fsm84872pfa.134.2024.02.28.17.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 17:25:38 -0800 (PST)
Message-ID: <63d73f09-84e5-49e1-99f5-60f414b22d70@rivosinc.com>
Date: Wed, 28 Feb 2024 17:25:34 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/20] Add Counter delegation ISA extension support
Content-Language: en-US
To: Ian Rogers <irogers@google.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, Christian Brauner <brauner@kernel.org>,
 =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>,
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org,
 Evan Green <evan@rivosinc.com>, Guo Ren <guoren@kernel.org>,
 Heiko Stuebner <heiko@sntech.de>, Ingo Molnar <mingo@redhat.com>,
 James Clark <james.clark@arm.com>, Jing Zhang <renyu.zj@linux.alibaba.com>,
 Jiri Olsa <jolsa@kernel.org>, Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
 John Garry <john.g.garry@oracle.com>, Jonathan Corbet <corbet@lwn.net>,
 Kan Liang <kan.liang@linux.intel.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 Ley Foon Tan <leyfoon.tan@starfivetech.com>, linux-doc@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-riscv@lists.infradead.org,
 Mark Rutland <mark.rutland@arm.com>, Namhyung Kim <namhyung@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Peter Zijlstra <peterz@infradead.org>,
 Rob Herring <robh+dt@kernel.org>, Samuel Holland
 <samuel.holland@sifive.com>, Weilin Wang <weilin.wang@intel.com>,
 Will Deacon <will@kernel.org>, kaiwenxue1@gmail.com,
 Yang Jihong <yangjihong1@huawei.com>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
 <CAP-5=fXh79aeHZ-M4CqP_GkfOHw0-7Cc1YLLGEyW5pT7t8eGHw@mail.gmail.com>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <CAP-5=fXh79aeHZ-M4CqP_GkfOHw0-7Cc1YLLGEyW5pT7t8eGHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/17/24 12:28, Ian Rogers wrote:
> On Fri, Feb 16, 2024 at 4:58 PM Atish Patra <atishp@rivosinc.com> wrote:
>>
>> This series adds the counter delegation extension support. It is based on
>> very early PoC work done by Kevin Xue and mostly rewritten after that.
>> The counter delegation ISA extension(Smcdeleg/Ssccfg) actually depends
>> on multiple ISA extensions.
>>
>> 1. S[m|s]csrind : The indirect CSR extension[1] which defines additional
>>     5 ([M|S|VS]IREG2-[M|S|VS]IREG6) register to address size limitation of
>>     RISC-V CSR address space.
>> 2. Smstateen: The stateen bit[60] controls the access to the registers
>>     indirectly via the above indirect registers.
>> 3. Smcdeleg/Ssccfg: The counter delegation extensions[2]
>>
>> The counter delegation extension allows Supervisor mode to program the
>> hpmevent and hpmcounters directly without needing the assistance from the
>> M-mode via SBI calls. This results in a faster perf profiling and very
>> few traps. This extension also introduces a scountinhibit CSR which allows
>> to stop/start any counter directly from the S-mode. As the counter
>> delegation extension potentially can have more than 100 CSRs, the specification
>> leverages the indirect CSR extension to save the precious CSR address range.
>>
>> Due to the dependency of these extensions, the following extensions must be
>> enabled in qemu to use the counter delegation feature in S-mode.
>>
>> "smstateen=true,sscofpmf=true,ssccfg=true,smcdeleg=true,smcsrind=true,sscsrind=true"
>>
>> When we access the counters directly in S-mode, we also need to solve the
>> following problems.
>>
>> 1. Event to counter mapping
>> 2. Event encoding discovery
>>
>> The RISC-V ISA doesn't define any standard either for event encoding or the
>> event to counter mapping rules.
>>
>> Until now, the SBI PMU implementation relies on device tree binding[3] to
>> discover the event to counter mapping in RISC-V platform in the firmware. The
>> SBI PMU specification[4] defines event encoding for standard perf events as well.
>> Thus, the kernel can query the appropriate counter for an given event from the
>> firmware.
>>
>> However, the kernel doesn't need any firmware interaction for hardware
>> counters if counter delegation is available in the hardware. Thus, the driver
>> needs to discover the above mappings/encodings by itself without any assistance
>> from firmware. One of the options considered was to extend the PMU DT parsing
>> support to kernel as well. However, that requires additional support in ACPI
>> based system. It also needs more infrastructure in the virtualization as well.
>>
>> This patch series solves the above problem #1 by extending the perf tool in a
>> way so that event json file can specify the counter constraints of each event
>> and that can be passed to the driver to choose the best counter for a given
>> event. The perf stat metric series[5] from Weilin already extend the perf tool
>> to parse "Counter" property to specify the hardware counter restriction.
>> I have included the patch from Weilin in this series for verification purposes
>> only. I will rebase as that series evolves.
>>
>> This series extends that support by converting comma separated string to a
>> bitmap. The counter constraint bitmap is passed to the perf driver via
>> newly introduced "counterid_mask" property set in "config2". Even though, this
>> is a generic perf tool change, this should not affect any other architecture
>> if "counterid_mask" is not mapped.
>>
>> @Weilin: Please let me know if there is a better way to solve the problem I
>> described.
>>
>> The problem #2 is solved by defining a architecture specific override function
>> that will replace the perf standard event encoding with an encoding specified
>> in the json file with the same event name. The alternate solution considered
>> was to specify the encodings in the driver. However, these encodings are vendor
>> specific in absence of an ISA guidelines and will become unmanageable with
>> so many RISC-V vendors touching the driver for their encoding.
>>
>> The override is only required when counter delegation is available in the
>> platform which is detected at the runtime. The SBI PMU (current implementation)
>> doesn't require any override as it defines the standard event encoding. The
>> hwprobe syscall defined for RISC-V is used for this detection in this series.
>> A sysfs based property can be explored to do the same but we may require
>> hwprobe in future given the churn of extensions in RISC-V. That's why, I went
>> with hwprobe. Let me know if anybody thinks that's a bad idea.
>>
>> The perf tool also hook allows RISC-V ISA platform vendors to define their
>> encoding for any standard perf or ISA event. I have tried to cover all the use
>> cases that I am aware of (stat, record, top). Please let me know if I have
>> missed any particular use case where architecture hook must be invoked. I am
>> also open to any other idea to solve the above said problem.
> 
> Hi Atish,
> 
> Thank you for the work! I know how the perf tool discovers events is
> somewhat assumed knowledge, I thought I'd just go through it here and
> explain a difference that is landing in Linux 6.8, as well as recent
> heterogeneous/hybrid/big.little support changes, just so those who
> aren't up to speed can catch up for the sake of discussion on this
> approach - sorry for turning this into a longer email than it perhaps
> needs to be, and the historical take may lack accuracy that I
> apologize in advance for.
> 
> The job of discovering events is to map a name like "cycles" into a
> set up for the perf_event_attr passed to perf_event_open. This sounds
> simple but "cycles" may be encoded differently for different PMUs on a
> heterogeneous system, it may also be an event on an accelerator like a
> GPU. So the first thing to recognize is that a name like "cycles" may
> map onto multiple struct perf_event_attr values. The behavior of how
> the perf tool does this lacks consistency, for example are all or just
> core PMUs considered, but this is deliberate for the sake of somewhat
> consistency by the tool over time. Perhaps in the future we'll
> change/fix this as things like accelerators dominate performance
> concerns.
> 
> The next thing is that what "cycles" means has been evolving over
> Linux releases. Originally "cycles" was assumed to be a CPU event and
> there were other events like "page-faults" which were software events.
> In perf_event.h there are enums for the "type" of event (hardware,
> software, cache, etc.) and for the actual event itself - cycles is
> "config" value 0. In the code we tend to refer to this kind of
> encoding as legacy. An ability was added (maybe it was always there)
> to dynamically add PMUs and PMUs advertise the value for the struct
> perf_event_attr through sysfs in  "/sys/devices/<pmu name>/type". On
> x86 the performance core typically has a type matching the legacy
> hardware number, but on ARM this isn't the case. So that legacy events
> can work on heterogeneous/hybrid/big.little systems where there should
> be multiple PMUs (looking at most Android devices for misconfiguring
> this), there is an extended type field in the top 32-bits of the
> struct perf_event_attr config. The extended type means I want this
> legacy event type on the extended type PMU.
> 
> For non-legacy events there is a problem of how to map a name to a
> config value (I'll say singular config value but overtime it has
> actually become 4 64-bit values). The sysfs format directory
> "/sys/devices/<pmu name>/format" does this. The files in the format
> directory say that on x86 the event is encoded in the first byte of
> the config and the umask in the second byte. If there is an event like
> "assists.any" that has an event of 0xc1 and a umask of 7, then the
> perf tool knows to create a config value of 0x7c1 using the format
> encoding.
> 
> To go from an event name like "cycles" to a format encoding there are
> two places to look, the first is "/sys/devices/<pmu name>/events/". In
> the events directory on x86 there is a "cpu-cycles" that contains
> "event=0x3c", i.e. a format style encoding. The second are the json
> files that are mapped to format style encodings for a specific cpuid
> by jevents.py. The easiest way to see the 2nd kind is to run "perf
> list --details":
> ```
> ...
>    assists.any
>        [Number of occurrences where a microcode assist is invoked by hardware]
>         default_core/event=0xc1,period=0x186a3,umask=0x7/
> ...
> ```
> We can see there is a format style encoding that has been built into
> the perf tool.
> 
> A place where ambiguity creeps in and is changing in Linux 6.8 is what
> to do when we have the same event in places like the legacy name,
> sysfs and the json? The behavior we have is:
> 1) "perf stat -e cycles ..." - the event was specified without PMUs,
> it is assumed a legacy encoding on all core PMUs is preferred (note
> non-core PMUs that have a cycles event are ignored, but this wouldn't
> be the case if the event weren't a legacy event name)
> 2) "perf stat -e cpu/cycles/" - the event was specified with a core
> PMU, prior to 6.8 (ie any current perf tool), a legacy encoding will
> be used. In 6.8 and after the json and sysfs encoding will have
> priority: https://lore.kernel.org/r/20231123042922.834425-1-irogers@google.com
> 3) "perf stat -e pmu/cycles/" - event was specified with a non-core
> PMU so a legacy encoding won't be considered, only json and sysfs.
> 
> As I understand the problem you are trying to fix in the perf tool it
> is for behavior 1 above, this is because the PMU driver wants the
> legacy event encodings to be in json so it needn't discover them.
> Behaviors 2 and 3 already prefer json encodings that are built into
> the perf tool.
> 
> So given behavior 1 is kind of weird, it considers different PMUs
> dependent on whether the event is legacy or not, it doesn't override
> with a sysfs/json event if one is present, why don't we look to change
> behavior 1 so that it is more like behaviors 2 and 3? I believe this
> gives you the ability to override legacy events you want. At the same
> time I'd like to also remove the "only core PMUs" assumption.
> 

Absolutely. Thanks for the detailed context and walking through the 
different cases for each event type.

> What would this look like? Well in the current code we take a legacy
> event and then create a perf_event_attr for each core PMU:
> https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/tree/tools/perf/util/parse-events.c?h=perf-tools-next#n1348
> We'd need to change this so that we wild card all the PMUs and
> consider the sysfs/json events first, which is what we already do
> here:
> https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/tree/tools/perf/util/parse-events.y?h=perf-tools-next#n305
> with the sysfs/json fix up being here:
> https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/tree/tools/perf/util/parse-events.c?h=perf-tools-next#n1016
> 
> As with the 6.8 change to prioritize sysfs/json over legacy the
> largest part of this change will be updating all the test
> expectations. Wdyt?
> 

That's awesome. That's exactly what I want. Let me know if you are going 
to push that change or want me to work on it while revising this series.

I am happy to test those changes either way.

> Things this patch series does that I don't like:
>   - hardcoding the expected CPU's PMU to "cpu", this should almost
> certainly be an iterator over all core PMU types. This allows core

Agreed. I did not like this approach either and not sure if this is the 
best method to fix the problem we have. I should have clarified well 
that in the cover letter.

> PMUs not to be called "cpu" and for heterogeneous configurations to
> work.
>   - doing things in an arch specific way. Test coverage is really hard


We do have an additional architecture specific issue at hand here.
As described, we need the event mapping with platforms with newer ISA 
extensions but doesn't need it for older platforms without ISA 
extensions. In addition to that, the new ISA extension doesn't cover 
virtualization. Thus, kvm guests continue to rely on the old way of 
discovering the events through SBI (ecall) interface.

Thus, a platform (e.g Qemu) can have both options present depending on
how it is configured.

To cover both cases, I introduced a RISC-V specific mechanism to detect 
the presence of the ISA extension in the perf tool.

"PATCH 18-20 adds hwprobe mechanism to enable perf to detect if platform 
supports delegation extensions."

If we don't want to keep any architecture specific hooks in this path, 
can we use a sysfs way to enable/disable mapping ?

I believe the pmu driver can update the sysfs for the perf tool to 
decide in that case ?

> and when something lives in arch directory we lose coverage unless we
> run on that machine type. Ugh, I'm just reminded that ARM
> heterogeneous is broken because of an arch override that doesn't
> consider >1 core PMU. Testing an ARM heterogenous PMU set up is hard
> but not doing so breaks people running Linux on M1 macs. Really we
> should just have PMU specific behaviors and the arch directory should
> disappear. This would also greatly help cross architecture work where
> you may record from perf on one architecture, but analyze the data on
> another.
>   - we've been moving to have perf and the json have less special
> architecture knowledge. Weilin's patches aside, we've added things
> like  "/sys/devices/<pmu name>/caps/slots" so that metrics can use
> "#slots" rather than hard coding the pipeline width in each metric. My
> hope for Weilin's patches is that we can make it less Intel specific
> and ultimately we may be able to advertise the specific features like
> number of fixed and generic counters via something like sysfs.

While that's ideal for x86/ARM64 where number of platform vendors are 
less (x86) or ISA has defined all-to-all event to counter mapping.

In RISC-V, we tried to push for all-to-all mapping which was not 
accepted withing RISC-V working groups. Every platform vendor will most 
likely end up in a different mapping of event to counters.

Thus, event to counter mapping via "Counter" field in json solve this
problem quite well. The only downside is that there is no common way 
across the architecture to pass that information to the pmu driver.

Hence a RISC-V specific solution via config2
https://lore.kernel.org/lkml/20240217005738.3744121-17-atishp@rivosinc.com/

Please let me know if this can be solved in an eficient way as well.

> However, the counters an event can go on is a property of the event so
> I see a need for the sysfs/json to add this.
> 
> Congratulations if you got this far, sorry this email was so long. Thanks,
> Ian
> 

Apologies for the delayed reply and Thanks again!

>> PATCH organization:
>> PATCH 1 is from the perf metric series[5]
>> PATCH 2-5 defines and implements the indirect CSR extension.
>> PATCH 6-10 defines the other required ISA extensions.
>> PATCH 11 just an overall restructure of the RISC-V PMU driver.
>> PATCH 12-14 implements the counter delegation extension and new perf tool
>> plumbings to solve #1 and #2.
>> PATCH 15-16 improves the perf tool support to solve #1 and #2.
>> PATCH 17 adds a perf json file for qemu virt machine.
>> PATCH 18-20 adds hwprobe mechanism to enable perf to detect if platform supports
>> delegation extensions.
>>
>> There is no change in process to run perf stat/record and will continue to work
>> as it is as long as the relevant extensions have been enabled in Qemu.
>>
>> However, the perf tool needs to be recompiled with as it requires new kenrel
>> headers.
>>
>> The Qemu patches can be found here:
>> https://github.com/atishp04/qemu/tree/counter_delegation_rfc
>>
>> The opensbi patch can be found here:
>> https://github.com/atishp04/opensbi/tree/counter_delegation_v1
>>
>> The Linux kernel patches can be found here:
>> https://github.com/atishp04/linux/tree/counter_delegation_rfc
>>
>> [1] https://github.com/riscv/riscv-indirect-csr-access
>> [2] https://github.com/riscv/riscv-smcdeleg-ssccfg
>> [3] https://www.kernel.org/doc/Documentation/devicetree/bindings/perf/riscv%2Cpmu.yaml
>> [4] https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-pmu.adoc
>> [5] https://lore.kernel.org/all/20240209031441.943012-4-weilin.wang@intel.com/
>>
>> Atish Patra (17):
>> RISC-V: Add Sxcsrind ISA extension definition and parsing
>> dt-bindings: riscv: add Sxcsrind ISA extension description
>> RISC-V: Define indirect CSR access helpers
>> RISC-V: Add Ssccfg ISA extension definition and parsing
>> dt-bindings: riscv: add Ssccfg ISA extension description
>> RISC-V: Add Smcntrpmf extension parsing
>> dt-bindings: riscv: add Smcntrpmf ISA extension description
>> RISC-V: perf: Restructure the SBI PMU code
>> RISC-V: perf: Modify the counter discovery mechanism
>> RISC-V: perf: Implement supervisor counter delegation support
>> RISC-V: perf: Use config2 for event to counter mapping
>> tools/perf: Add arch hooks to override perf standard events
>> tools/perf: Pass the Counter constraint values in the pmu events
>> perf: Add json file for virt machine supported events
>> tools arch uapi: Sync the uinstd.h header file for RISC-V
>> RISC-V: Add hwprobe support for Counter delegation extensions
>> tools/perf: Detect if platform supports counter delegation
>>
>> Kaiwen Xue (2):
>> RISC-V: Add Sxcsrind ISA extension CSR definitions
>> RISC-V: Add Sscfg extension CSR definition
>>
>> Weilin Wang (1):
>> perf pmu-events: Add functions in jevent.py to parse counter and event
>> info for hardware aware grouping
>>
>> Documentation/arch/riscv/hwprobe.rst          |  10 +
>> .../devicetree/bindings/riscv/extensions.yaml |  34 +
>> MAINTAINERS                                   |   4 +-
>> arch/riscv/include/asm/csr.h                  |  47 ++
>> arch/riscv/include/asm/csr_ind.h              |  42 ++
>> arch/riscv/include/asm/hwcap.h                |   5 +
>> arch/riscv/include/asm/sbi.h                  |   2 +-
>> arch/riscv/include/uapi/asm/hwprobe.h         |   4 +
>> arch/riscv/kernel/cpufeature.c                |   5 +
>> arch/riscv/kernel/sys_hwprobe.c               |   3 +
>> arch/riscv/kvm/vcpu_pmu.c                     |   2 +-
>> drivers/perf/Kconfig                          |  16 +-
>> drivers/perf/Makefile                         |   4 +-
>> .../perf/{riscv_pmu.c => riscv_pmu_common.c}  |   0
>> .../perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} | 654 ++++++++++++++----
>> include/linux/perf/riscv_pmu.h                |  13 +-
>> tools/arch/riscv/include/uapi/asm/unistd.h    |  14 +-
>> tools/perf/arch/riscv/util/Build              |   2 +
>> tools/perf/arch/riscv/util/evlist.c           |  60 ++
>> tools/perf/arch/riscv/util/pmu.c              |  41 ++
>> tools/perf/arch/riscv/util/pmu.h              |  11 +
>> tools/perf/builtin-record.c                   |   3 +
>> tools/perf/builtin-stat.c                     |   2 +
>> tools/perf/builtin-top.c                      |   3 +
>> .../pmu-events/arch/riscv/arch-standard.json  |  10 +
>> tools/perf/pmu-events/arch/riscv/mapfile.csv  |   1 +
>> .../pmu-events/arch/riscv/qemu/virt/cpu.json  |  30 +
>> .../arch/riscv/qemu/virt/firmware.json        |  68 ++
>> tools/perf/pmu-events/jevents.py              | 186 ++++-
>> tools/perf/pmu-events/pmu-events.h            |  25 +-
>> tools/perf/util/evlist.c                      |   6 +
>> tools/perf/util/evlist.h                      |   6 +
>> 32 files changed, 1167 insertions(+), 146 deletions(-)
>> create mode 100644 arch/riscv/include/asm/csr_ind.h
>> rename drivers/perf/{riscv_pmu.c => riscv_pmu_common.c} (100%)
>> rename drivers/perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} (61%)
>> create mode 100644 tools/perf/arch/riscv/util/evlist.c
>> create mode 100644 tools/perf/arch/riscv/util/pmu.c
>> create mode 100644 tools/perf/arch/riscv/util/pmu.h
>> create mode 100644 tools/perf/pmu-events/arch/riscv/arch-standard.json
>> create mode 100644 tools/perf/pmu-events/arch/riscv/qemu/virt/cpu.json
>> create mode 100644 tools/perf/pmu-events/arch/riscv/qemu/virt/firmware.json
>>
>> --
>> 2.34.1
>>


