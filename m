Return-Path: <kvm+bounces-66795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A45DCE7E35
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 19:46:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AF741300461E
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1609527EC80;
	Mon, 29 Dec 2025 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a5sqJmLi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485C2277C9A
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 18:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033971; cv=none; b=WQL5ZmzV1lQnmuGAaDBqFEwrLgBsCGQ5kmL6NpzQ9KDYnk6040wX1pmq+bxMUPFY28MoPrk++rwMDh8m2u7/OXU9r1wrwP6/VJ0KxpGGe5mry3huu1VS0MUaxtCz8wJNektNuqN72yIn0izOpvzsaNWpNlCq12x3Nz3t/kXI+2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033971; c=relaxed/simple;
	bh=qf0tI7pb4TlDw6BPPCaCivFEdgoLWjtF7BCgtiHUX6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qMkdgOVvDEhXodzf36XD8EySMOQxkVTislSNXTEYptIBjpYpwHf4Xrp2+hbRGrJduUKh5HPFja0g/5REEEuWC/BsbhTxcBvrJREYRso4Y3JQAxZOudou7QVyVewPX6qM1nzxBHG+FjHbjVqWIBQGFILca4Xy5gcRnPwBoBLuxHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a5sqJmLi; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a0d5c365ceso122486325ad.3
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 10:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767033967; x=1767638767; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+d/nCresSnMFfrZFdrPyCy8Yndbcp+1LODehqKnvQeQ=;
        b=a5sqJmLiTjw9NbFWRyuroX4Qb5qJk57sN2wVR/x2jX5qkSQWWJDKY+IYSUqfIc4YvL
         LCmP9VJp4lTFgdvtylP9JziNnlwancT+nHzFjyxy/OwLygDlfvkxyjpRJiHFM9Lweds/
         InL39bmRqrqu5yZ7c7EgxzQ6Xa52QX67NnuKjzEvlPgkDithnd44Z4SSgYSLTy2X3n0J
         bym7jRjQo1aEQ6NhOaacntQTVexQgK4WCf/GFK2DXCw7B5Q7bt5akSFteNRp0mQvGDNH
         /hLSB1Sm/sugjIAceU2F5nwN4FtQpaH5vpAp50VLQ4UZsgFehgXIb/HtPMTjmsoDNB8T
         zmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033967; x=1767638767;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+d/nCresSnMFfrZFdrPyCy8Yndbcp+1LODehqKnvQeQ=;
        b=pzQdS6MlhGROwyeLy841Jgxq2VSFjijxEe4ioJkTINXzSvDcSZgzIFXD/ZsA62tS39
         fSKkgoq6bTUkHGaOGM98UZVJ6VQiIQOSG5M0o+rFJ5HvYecd1b/vfm7Kn/sHh7kJHA96
         Z5TUTpO4NYuM+5zqJ/mBBcmfgeoZbmCcePVsYXAZMDNxJHyzCyOfS9+YJ1lxH/Rrhfop
         BPgIG4CHzd1RPPJpibx0cZsJuKrs1palSN8VqnWctgAWELsqC/lVcqNyT5tovTQf9243
         VXhbutJkcKgxObz6J8erTEgGyAmAgUHMiDs7Oaw5EnOaIRqgzq5811JLwRunrA3J+gjm
         eRAA==
X-Forwarded-Encrypted: i=1; AJvYcCXbbKCcxFMf1WoiDYrHvf0N7kJeu9yieXbX0RKGN6nqx1VGHVjIn9Rq9StMtIVEIcs1Gxw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWJkS9pzi+6UHwFGS2ucMysYRiEtQqtJJ4gb0l1mP43Cw9F7Fb
	Zf7/4jtY5RJ3W17CGn1WLn1OLhLu/97D085oUMG9oiiUSB7AH+4EXsUXrBJi3bFeaWM=
X-Gm-Gg: AY/fxX4wKNnoX/Wu/5QqSRP7ZKkxsn/3k/MM3Ky/fxG0yCJ5XRC4dsA5wWVRnqdly8Q
	QBxLaLmQ1GMPh6fH+IA3eCMLjAmWiZEoF/n0WA+BkGSLKialD+ySB7QXpK37T+wYFc0kV1i+Tvh
	v+RMgG3m4lJvwdfYMXHff7oof1z/7xrXDhO5Opcq+OCAC6WXEgTAyJfQTfXNvymIoz1XwHSrzrz
	6iXi8sP2bdT2+29ifWiaEOxXNN0L17yw7tULXzqVHmcnajWJTVc3wtsgX1khyExaQEONTodFpND
	7vT3RipGaQhNjlhQ0YxhtMF/nwUPbYlFzAlJvvhdza58vJ5sxzh4fYD9Z7wTvHAGj8AH0ooVc1Q
	9kOPUAkNtmx4neIx1R423hHcP3JGOEsjsuG1GkBBko6TCF7Mh1c1fe06+lMlXA2w8ieSVKJg59V
	rKzA7pQbJPY59a1uN8IFQfZxpDp6EW+s3C20oKG0qe9aJB29aifDC2eH/Q
X-Google-Smtp-Source: AGHT+IGVeGODRJ7l8gYnyEdWZ5qvGkrU3bToUij07GsjHgDOtPITl4mJ3dzaJqM00epetagUDbyfBA==
X-Received: by 2002:a17:902:cf0d:b0:29f:b3e5:5186 with SMTP id d9443c01a7336-2a2f293d13bmr306999935ad.56.1767033967059;
        Mon, 29 Dec 2025 10:46:07 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c65d71sm284253105ad.17.2025.12.29.10.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 10:46:06 -0800 (PST)
Message-ID: <c8bba373-0ff1-4acc-ac3e-7157b3627247@linaro.org>
Date: Mon, 29 Dec 2025 10:46:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 11/28] whpx: reshuffle common code
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
 <20251228235422.30383-12-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-12-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> Some code can be shared between x86_64 and arm64 WHPX. Do so as much as reasonable.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> 
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   MAINTAINERS                  |   2 +
>   accel/whpx/meson.build       |   1 +
>   accel/whpx/whpx-common.c     | 562 +++++++++++++++++++++++++++++++++++
>   include/system/whpx-all.h    |  20 ++
>   include/system/whpx-common.h |  21 ++
>   target/i386/whpx/whpx-all.c  | 551 +---------------------------------
>   6 files changed, 616 insertions(+), 541 deletions(-)
>   create mode 100644 accel/whpx/whpx-common.c
>   create mode 100644 include/system/whpx-all.h
>   create mode 100644 include/system/whpx-common.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6b045fb3f8..8d84f141cc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -555,6 +555,8 @@ F: target/i386/whpx/
>   F: accel/stubs/whpx-stub.c
>   F: include/system/whpx.h
>   F: include/system/whpx-accel-ops.h
> +F: include/system/whpx-common.h
> +F: include/system/whpx-internal.h
>   
>   MSHV
>   M: Magnus Kulke <magnus.kulke@linux.microsoft.com>
> diff --git a/accel/whpx/meson.build b/accel/whpx/meson.build
> index 7b3d6f1c1c..fad28dddcb 100644
> --- a/accel/whpx/meson.build
> +++ b/accel/whpx/meson.build
> @@ -1,6 +1,7 @@
>   whpx_ss = ss.source_set()
>   whpx_ss.add(files(
>     'whpx-accel-ops.c',
> +  'whpx-common.c'
>   ))
>   
>   specific_ss.add_all(when: 'CONFIG_WHPX', if_true: whpx_ss)
> diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
> new file mode 100644
> index 0000000000..d106776ff4
> --- /dev/null
> +++ b/accel/whpx/whpx-common.c
> @@ -0,0 +1,562 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * QEMU Windows Hypervisor Platform accelerator (WHPX)
> + *
> + * Copyright Microsoft Corp. 2017
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + *

ERROR: New file 'accel/whpx/whpx-common.c' must not have license 
boilerplate header text, only the SPDX-License-Identifier, unless this 
file was copied from existing code already having such text.

You can remove "This work..."

> + */
> +
> +#include "qemu/osdep.h"
> +#include "cpu.h"
> +#include "system/address-spaces.h"
> +#include "system/ioport.h"
> +#include "gdbstub/helpers.h"
> +#include "qemu/accel.h"
> +#include "accel/accel-ops.h"
> +#include "system/whpx.h"
> +#include "system/cpus.h"
> +#include "system/runstate.h"
> +#include "qemu/main-loop.h"
> +#include "hw/core/boards.h"
> +#include "hw/intc/ioapic.h"
> +#include "qemu/error-report.h"
> +#include "qapi/error.h"
> +#include "qapi/qapi-types-common.h"
> +#include "qapi/qapi-visit-common.h"
> +#include "migration/blocker.h"
> +#include "accel/accel-cpu-target.h"
> +#include <winerror.h>
> +
> +#include "system/whpx-internal.h"
> +#include "system/whpx-accel-ops.h"
> +#include "system/whpx-common.h"
> +#include "system/whpx-all.h"
> +
> +#include <winhvplatform.h>
> +#include <winhvplatformdefs.h>
> +
> +bool whpx_allowed;
> +static bool whp_dispatch_initialized;
> +static HMODULE hWinHvPlatform;
> +static HMODULE hWinHvEmulation;
> +
> +struct whpx_state whpx_global;
> +struct WHPDispatch whp_dispatch;
> +
> +/* Tries to find a breakpoint at the specified address. */
> +struct whpx_breakpoint *whpx_lookup_breakpoint_by_addr(uint64_t address)
> +{
> +    struct whpx_state *whpx = &whpx_global;
> +    int i;
> +
> +    if (whpx->breakpoints.breakpoints) {
> +        for (i = 0; i < whpx->breakpoints.breakpoints->used; i++) {
> +            if (address == whpx->breakpoints.breakpoints->data[i].address) {
> +                return &whpx->breakpoints.breakpoints->data[i];
> +            }
> +        }
> +    }
> +
> +    return NULL;
> +}
> +
> +/*
> + * This function is called when the a VCPU is about to start and no other
> + * VCPUs have been started so far. Since the VCPU start order could be
> + * arbitrary, it doesn't have to be VCPU#0.
> + *
> + * It is used to commit the breakpoints into memory, and configure WHPX
> + * to intercept debug exceptions.
> + *
> + * Note that whpx_set_exception_exit_bitmap() cannot be called if one or
> + * more VCPUs are already running, so this is the best place to do it.
> + */
> +int whpx_first_vcpu_starting(CPUState *cpu)
> +{
> +    struct whpx_state *whpx = &whpx_global;
> +
> +    g_assert(bql_locked());
> +
> +    if (!QTAILQ_EMPTY(&cpu->breakpoints) ||
> +            (whpx->breakpoints.breakpoints &&
> +             whpx->breakpoints.breakpoints->used)) {
> +        CPUBreakpoint *bp;
> +        int i = 0;
> +        bool update_pending = false;
> +
> +        QTAILQ_FOREACH(bp, &cpu->breakpoints, entry) {
> +            if (i >= whpx->breakpoints.original_address_count ||
> +                bp->pc != whpx->breakpoints.original_addresses[i]) {
> +                update_pending = true;
> +            }
> +
> +            i++;
> +        }
> +
> +        if (i != whpx->breakpoints.original_address_count) {
> +            update_pending = true;
> +        }
> +
> +        if (update_pending) {
> +            /*
> +             * The CPU breakpoints have changed since the last call to
> +             * whpx_translate_cpu_breakpoints(). WHPX breakpoints must
> +             * now be recomputed.
> +             */
> +            whpx_translate_cpu_breakpoints(&whpx->breakpoints, cpu, i);
> +        }
> +        /* Actually insert the breakpoints into the memory. */
> +        whpx_apply_breakpoints(whpx->breakpoints.breakpoints, cpu, true);
> +    }
> +    HRESULT hr;
> +    uint64_t exception_mask;
> +    if (whpx->step_pending ||
> +        (whpx->breakpoints.breakpoints &&
> +         whpx->breakpoints.breakpoints->used)) {
> +        /*
> +         * We are either attempting to single-step one or more CPUs, or
> +         * have one or more breakpoints enabled. Both require intercepting
> +         * the WHvX64ExceptionTypeBreakpointTrap exception.
> +         */
> +        exception_mask = 1UL << WHvX64ExceptionTypeDebugTrapOrFault;
> +    } else {
> +        /* Let the guest handle all exceptions. */
> +        exception_mask = 0;
> +    }
> +    hr = whpx_set_exception_exit_bitmap(exception_mask);
> +    if (!SUCCEEDED(hr)) {
> +        error_report("WHPX: Failed to update exception exit mask,"
> +                     "hr=%08lx.", hr);
> +        return 1;
> +    }
> +    return 0;
> +}
> +
> +/*
> + * This function is called when the last VCPU has finished running.
> + * It is used to remove any previously set breakpoints from memory.
> + */
> +int whpx_last_vcpu_stopping(CPUState *cpu)
> +{
> +    whpx_apply_breakpoints(whpx_global.breakpoints.breakpoints, cpu, false);
> +    return 0;
> +}
> +
> +static void do_whpx_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
> +{
> +    if (!cpu->vcpu_dirty) {
> +        whpx_get_registers(cpu);
> +        cpu->vcpu_dirty = true;
> +    }
> +}
> +
> +static void do_whpx_cpu_synchronize_post_reset(CPUState *cpu,
> +                                               run_on_cpu_data arg)
> +{
> +    whpx_set_registers(cpu, WHPX_SET_RESET_STATE);
> +    cpu->vcpu_dirty = false;
> +}
> +
> +static void do_whpx_cpu_synchronize_post_init(CPUState *cpu,
> +                                              run_on_cpu_data arg)
> +{
> +    whpx_set_registers(cpu, WHPX_SET_FULL_STATE);
> +    cpu->vcpu_dirty = false;
> +}
> +
> +static void do_whpx_cpu_synchronize_pre_loadvm(CPUState *cpu,
> +                                               run_on_cpu_data arg)
> +{
> +    cpu->vcpu_dirty = true;
> +}
> +
> +/*
> + * CPU support.
> + */
> +
> +void whpx_cpu_synchronize_state(CPUState *cpu)
> +{
> +    if (!cpu->vcpu_dirty) {
> +        run_on_cpu(cpu, do_whpx_cpu_synchronize_state, RUN_ON_CPU_NULL);
> +    }
> +}
> +
> +void whpx_cpu_synchronize_post_reset(CPUState *cpu)
> +{
> +    run_on_cpu(cpu, do_whpx_cpu_synchronize_post_reset, RUN_ON_CPU_NULL);
> +}
> +
> +void whpx_cpu_synchronize_post_init(CPUState *cpu)
> +{
> +    run_on_cpu(cpu, do_whpx_cpu_synchronize_post_init, RUN_ON_CPU_NULL);
> +}
> +
> +void whpx_cpu_synchronize_pre_loadvm(CPUState *cpu)
> +{
> +    run_on_cpu(cpu, do_whpx_cpu_synchronize_pre_loadvm, RUN_ON_CPU_NULL);
> +}
> +
> +static void whpx_pre_resume_vm(AccelState *as, bool step_pending)
> +{
> +    whpx_global.step_pending = step_pending;
> +}
> +
> +/*
> + * Vcpu support.
> + */
> +
> +int whpx_vcpu_exec(CPUState *cpu)
> +{
> +    int ret;
> +    int fatal;
> +
> +    for (;;) {
> +        if (cpu->exception_index >= EXCP_INTERRUPT) {
> +            ret = cpu->exception_index;
> +            cpu->exception_index = -1;
> +            break;
> +        }
> +
> +        fatal = whpx_vcpu_run(cpu);
> +
> +        if (fatal) {
> +            error_report("WHPX: Failed to exec a virtual processor");
> +            abort();
> +        }
> +    }
> +
> +    return ret;
> +}
> +
> +void whpx_destroy_vcpu(CPUState *cpu)
> +{
> +    struct whpx_state *whpx = &whpx_global;
> +
> +    whp_dispatch.WHvDeleteVirtualProcessor(whpx->partition, cpu->cpu_index);
> +    AccelCPUState *vcpu = cpu->accel;
> +    whp_dispatch.WHvEmulatorDestroyEmulator(vcpu->emulator);
> +    g_free(cpu->accel);
> +}
> +
> +
> +void whpx_vcpu_kick(CPUState *cpu)
> +{
> +    struct whpx_state *whpx = &whpx_global;
> +    whp_dispatch.WHvCancelRunVirtualProcessor(
> +        whpx->partition, cpu->cpu_index, 0);
> +}
> +
> +/*
> + * Memory support.
> + */
> +
> +static void whpx_update_mapping(hwaddr start_pa, ram_addr_t size,
> +                                void *host_va, int add, int rom,
> +                                const char *name)
> +{
> +    struct whpx_state *whpx = &whpx_global;
> +    HRESULT hr;
> +
> +    /*
> +    if (add) {
> +        printf("WHPX: ADD PA:%p Size:%p, Host:%p, %s, '%s'\n",
> +               (void*)start_pa, (void*)size, host_va,
> +               (rom ? "ROM" : "RAM"), name);
> +    } else {
> +        printf("WHPX: DEL PA:%p Size:%p, Host:%p,      '%s'\n",
> +               (void*)start_pa, (void*)size, host_va, name);
> +    }
> +    */
> +
> +    if (add) {
> +        hr = whp_dispatch.WHvMapGpaRange(whpx->partition,
> +                                         host_va,
> +                                         start_pa,
> +                                         size,
> +                                         (WHvMapGpaRangeFlagRead |
> +                                          WHvMapGpaRangeFlagExecute |
> +                                          (rom ? 0 : WHvMapGpaRangeFlagWrite)));
> +    } else {
> +        hr = whp_dispatch.WHvUnmapGpaRange(whpx->partition,
> +                                           start_pa,
> +                                           size);
> +    }
> +
> +    if (FAILED(hr)) {
> +        error_report("WHPX: Failed to %s GPA range '%s' PA:%p, Size:%p bytes,"
> +                     " Host:%p, hr=%08lx",
> +                     (add ? "MAP" : "UNMAP"), name,
> +                     (void *)(uintptr_t)start_pa, (void *)size, host_va, hr);
> +    }
> +}
> +
> +static void whpx_process_section(MemoryRegionSection *section, int add)
> +{
> +    MemoryRegion *mr = section->mr;
> +    hwaddr start_pa = section->offset_within_address_space;
> +    ram_addr_t size = int128_get64(section->size);
> +    unsigned int delta;
> +    uint64_t host_va;
> +
> +    if (!memory_region_is_ram(mr)) {
> +        return;
> +    }
> +
> +    delta = qemu_real_host_page_size() - (start_pa & ~qemu_real_host_page_mask());
> +    delta &= ~qemu_real_host_page_mask();
> +    if (delta > size) {
> +        return;
> +    }
> +    start_pa += delta;
> +    size -= delta;
> +    size &= qemu_real_host_page_mask();
> +    if (!size || (start_pa & ~qemu_real_host_page_mask())) {
> +        return;
> +    }
> +
> +    host_va = (uintptr_t)memory_region_get_ram_ptr(mr)
> +            + section->offset_within_region + delta;
> +
> +    whpx_update_mapping(start_pa, size, (void *)(uintptr_t)host_va, add,
> +                        memory_region_is_rom(mr), mr->name);
> +}
> +
> +static void whpx_region_add(MemoryListener *listener,
> +                           MemoryRegionSection *section)
> +{
> +    memory_region_ref(section->mr);
> +    whpx_process_section(section, 1);
> +}
> +
> +static void whpx_region_del(MemoryListener *listener,
> +                           MemoryRegionSection *section)
> +{
> +    whpx_process_section(section, 0);
> +    memory_region_unref(section->mr);
> +}
> +
> +static void whpx_transaction_begin(MemoryListener *listener)
> +{
> +}
> +
> +static void whpx_transaction_commit(MemoryListener *listener)
> +{
> +}
> +
> +static void whpx_log_sync(MemoryListener *listener,
> +                         MemoryRegionSection *section)
> +{
> +    MemoryRegion *mr = section->mr;
> +
> +    if (!memory_region_is_ram(mr)) {
> +        return;
> +    }
> +
> +    memory_region_set_dirty(mr, 0, int128_get64(section->size));
> +}
> +
> +static MemoryListener whpx_memory_listener = {
> +    .name = "whpx",
> +    .begin = whpx_transaction_begin,
> +    .commit = whpx_transaction_commit,
> +    .region_add = whpx_region_add,
> +    .region_del = whpx_region_del,
> +    .log_sync = whpx_log_sync,
> +    .priority = MEMORY_LISTENER_PRIORITY_ACCEL,
> +};
> +
> +void whpx_memory_init(void)
> +{
> +    memory_listener_register(&whpx_memory_listener, &address_space_memory);
> +}
> +
> +/*
> + * Load the functions from the given library, using the given handle. If a
> + * handle is provided, it is used, otherwise the library is opened. The
> + * handle will be updated on return with the opened one.
> + */
> +static bool load_whp_dispatch_fns(HMODULE *handle,
> +    WHPFunctionList function_list)
> +{
> +    HMODULE hLib = *handle;
> +
> +    #define WINHV_PLATFORM_DLL "WinHvPlatform.dll"
> +    #define WINHV_EMULATION_DLL "WinHvEmulation.dll"
> +    #define WHP_LOAD_FIELD_OPTIONAL(return_type, function_name, signature) \
> +        whp_dispatch.function_name = \
> +            (function_name ## _t)GetProcAddress(hLib, #function_name); \
> +
> +    #define WHP_LOAD_FIELD(return_type, function_name, signature) \
> +        whp_dispatch.function_name = \
> +            (function_name ## _t)GetProcAddress(hLib, #function_name); \
> +        if (!whp_dispatch.function_name) { \
> +            error_report("Could not load function %s", #function_name); \
> +            goto error; \
> +        } \
> +
> +    #define WHP_LOAD_LIB(lib_name, handle_lib) \
> +    if (!handle_lib) { \
> +        handle_lib = LoadLibrary(lib_name); \
> +        if (!handle_lib) { \
> +            error_report("Could not load library %s.", lib_name); \
> +            goto error; \
> +        } \
> +    } \
> +
> +    switch (function_list) {
> +    case WINHV_PLATFORM_FNS_DEFAULT:
> +        WHP_LOAD_LIB(WINHV_PLATFORM_DLL, hLib)
> +        LIST_WINHVPLATFORM_FUNCTIONS(WHP_LOAD_FIELD)
> +        break;
> +    case WINHV_EMULATION_FNS_DEFAULT:
> +        WHP_LOAD_LIB(WINHV_EMULATION_DLL, hLib)
> +        LIST_WINHVEMULATION_FUNCTIONS(WHP_LOAD_FIELD)
> +        break;
> +    case WINHV_PLATFORM_FNS_SUPPLEMENTAL:
> +        WHP_LOAD_LIB(WINHV_PLATFORM_DLL, hLib)
> +        LIST_WINHVPLATFORM_FUNCTIONS_SUPPLEMENTAL(WHP_LOAD_FIELD_OPTIONAL)
> +        break;
> +    }
> +
> +    *handle = hLib;
> +    return true;
> +
> +error:
> +    if (hLib) {
> +        FreeLibrary(hLib);
> +    }
> +
> +    return false;
> +}
> +
> +static void whpx_set_kernel_irqchip(Object *obj, Visitor *v,
> +                                   const char *name, void *opaque,
> +                                   Error **errp)
> +{
> +    struct whpx_state *whpx = &whpx_global;
> +    OnOffSplit mode;
> +
> +    if (!visit_type_OnOffSplit(v, name, &mode, errp)) {
> +        return;
> +    }
> +
> +    switch (mode) {
> +    case ON_OFF_SPLIT_ON:
> +        whpx->kernel_irqchip_allowed = true;
> +        whpx->kernel_irqchip_required = true;
> +        break;
> +
> +    case ON_OFF_SPLIT_OFF:
> +        whpx->kernel_irqchip_allowed = false;
> +        whpx->kernel_irqchip_required = false;
> +        break;
> +
> +    case ON_OFF_SPLIT_SPLIT:
> +        error_setg(errp, "WHPX: split irqchip currently not supported");
> +        error_append_hint(errp,
> +            "Try without kernel-irqchip or with kernel-irqchip=on|off");
> +        break;
> +
> +    default:
> +        /*
> +         * The value was checked in visit_type_OnOffSplit() above. If
> +         * we get here, then something is wrong in QEMU.
> +         */
> +        abort();
> +    }
> +}
> +
> +static void whpx_cpu_accel_class_init(ObjectClass *oc, const void *data)
> +{
> +    AccelCPUClass *acc = ACCEL_CPU_CLASS(oc);
> +
> +    acc->cpu_instance_init = whpx_cpu_instance_init;
> +}
> +
> +static const TypeInfo whpx_cpu_accel_type = {
> +    .name = ACCEL_CPU_NAME("whpx"),
> +
> +    .parent = TYPE_ACCEL_CPU,
> +    .class_init = whpx_cpu_accel_class_init,
> +    .abstract = true,
> +};
> +
> +/*
> + * Partition support
> + */
> +
> +bool whpx_apic_in_platform(void)
> +{
> +    return whpx_global.apic_in_platform;
> +}
> +
> +static void whpx_accel_class_init(ObjectClass *oc, const void *data)
> +{
> +    AccelClass *ac = ACCEL_CLASS(oc);
> +    ac->name = "WHPX";
> +    ac->init_machine = whpx_accel_init;
> +    ac->pre_resume_vm = whpx_pre_resume_vm;
> +    ac->allowed = &whpx_allowed;
> +
> +    object_class_property_add(oc, "kernel-irqchip", "on|off|split",
> +        NULL, whpx_set_kernel_irqchip,
> +        NULL, NULL);
> +    object_class_property_set_description(oc, "kernel-irqchip",
> +        "Configure WHPX in-kernel irqchip");
> +}
> +
> +static void whpx_accel_instance_init(Object *obj)
> +{
> +    struct whpx_state *whpx = &whpx_global;
> +
> +    memset(whpx, 0, sizeof(struct whpx_state));
> +    /* Turn on kernel-irqchip, by default */
> +    whpx->kernel_irqchip_allowed = true;
> +}
> +
> +static const TypeInfo whpx_accel_type = {
> +    .name = ACCEL_CLASS_NAME("whpx"),
> +    .parent = TYPE_ACCEL,
> +    .instance_init = whpx_accel_instance_init,
> +    .class_init = whpx_accel_class_init,
> +};
> +
> +static void whpx_type_init(void)
> +{
> +    type_register_static(&whpx_accel_type);
> +    type_register_static(&whpx_cpu_accel_type);
> +}
> +
> +bool init_whp_dispatch(void)
> +{
> +    if (whp_dispatch_initialized) {
> +        return true;
> +    }
> +
> +    if (!load_whp_dispatch_fns(&hWinHvPlatform, WINHV_PLATFORM_FNS_DEFAULT)) {
> +        goto error;
> +    }
> +
> +    if (!load_whp_dispatch_fns(&hWinHvEmulation, WINHV_EMULATION_FNS_DEFAULT)) {
> +        goto error;
> +    }
> +
> +    assert(load_whp_dispatch_fns(&hWinHvPlatform,
> +        WINHV_PLATFORM_FNS_SUPPLEMENTAL));
> +    whp_dispatch_initialized = true;
> +
> +    return true;
> +error:
> +    if (hWinHvPlatform) {
> +        FreeLibrary(hWinHvPlatform);
> +    }
> +    if (hWinHvEmulation) {
> +        FreeLibrary(hWinHvEmulation);
> +    }
> +    return false;
> +}
> +
> +type_init(whpx_type_init);
> diff --git a/include/system/whpx-all.h b/include/system/whpx-all.h
> new file mode 100644
> index 0000000000..f13cdf7f66
> --- /dev/null
> +++ b/include/system/whpx-all.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef SYSTEM_WHPX_ALL_H
> +#define SYSTEM_WHPX_ALL_H
> +
> +/* Called by whpx-common */
> +int whpx_vcpu_run(CPUState *cpu);
> +void whpx_get_registers(CPUState *cpu);
> +void whpx_set_registers(CPUState *cpu, int level);
> +int whpx_accel_init(AccelState *as, MachineState *ms);
> +void whpx_cpu_instance_init(CPUState *cs);
> +HRESULT whpx_set_exception_exit_bitmap(UINT64 exceptions);
> +void whpx_apply_breakpoints(
> +struct whpx_breakpoint_collection *breakpoints,
> +    CPUState *cpu,
> +    bool resuming);
> +void whpx_translate_cpu_breakpoints(
> +    struct whpx_breakpoints *breakpoints,
> +    CPUState *cpu,
> +    int cpu_breakpoint_count);
> +#endif
> diff --git a/include/system/whpx-common.h b/include/system/whpx-common.h
> new file mode 100644
> index 0000000000..e549c7539c
> --- /dev/null
> +++ b/include/system/whpx-common.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef SYSTEM_WHPX_COMMON_H
> +#define SYSTEM_WHPX_COMMON_H
> +
> +struct AccelCPUState {
> +    WHV_EMULATOR_HANDLE emulator;
> +    bool window_registered;
> +    bool interruptable;
> +    bool ready_for_pic_interrupt;
> +    uint64_t tpr;
> +    uint64_t apic_base;
> +    bool interruption_pending;
> +    /* Must be the last field as it may have a tail */
> +    WHV_RUN_VP_EXIT_CONTEXT exit_ctx;
> +};
> +
> +int whpx_first_vcpu_starting(CPUState *cpu);
> +int whpx_last_vcpu_stopping(CPUState *cpu);
> +void whpx_memory_init(void);
> +struct whpx_breakpoint *whpx_lookup_breakpoint_by_addr(uint64_t address);
> +#endif
> diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
> index cef31fc1a8..052cda42bf 100644
> --- a/target/i386/whpx/whpx-all.c
> +++ b/target/i386/whpx/whpx-all.c
> @@ -33,6 +33,8 @@
>   
>   #include "system/whpx-internal.h"
>   #include "system/whpx-accel-ops.h"
> +#include "system/whpx-all.h"
> +#include "system/whpx-common.h"
>   
>   #include <winhvplatform.h>
>   #include <winhvemulation.h>
> @@ -232,28 +234,9 @@ typedef enum WhpxStepMode {
>       WHPX_STEP_EXCLUSIVE,
>   } WhpxStepMode;
>   
> -struct AccelCPUState {
> -    WHV_EMULATOR_HANDLE emulator;
> -    bool window_registered;
> -    bool interruptable;
> -    bool ready_for_pic_interrupt;
> -    uint64_t tpr;
> -    uint64_t apic_base;
> -    bool interruption_pending;
> -
> -    /* Must be the last field as it may have a tail */
> -    WHV_RUN_VP_EXIT_CONTEXT exit_ctx;
> -};
> -
> -bool whpx_allowed;
> -static bool whp_dispatch_initialized;
> -static HMODULE hWinHvPlatform, hWinHvEmulation;
>   static uint32_t max_vcpu_index;
>   static WHV_PROCESSOR_XSAVE_FEATURES whpx_xsave_cap;
>   
> -struct whpx_state whpx_global;
> -struct WHPDispatch whp_dispatch;
> -
>   static bool whpx_has_xsave(void)
>   {
>       return whpx_xsave_cap.XsaveSupport;
> @@ -379,7 +362,7 @@ static uint64_t whpx_cr8_to_apic_tpr(uint64_t cr8)
>       return cr8 << 4;
>   }
>   
> -static void whpx_set_registers(CPUState *cpu, int level)
> +void whpx_set_registers(CPUState *cpu, int level)
>   {
>       struct whpx_state *whpx = &whpx_global;
>       AccelCPUState *vcpu = cpu->accel;
> @@ -594,7 +577,7 @@ static void whpx_get_xcrs(CPUState *cpu)
>       cpu_env(cpu)->xcr0 = xcr0.Reg64;
>   }
>   
> -static void whpx_get_registers(CPUState *cpu)
> +void whpx_get_registers(CPUState *cpu)
>   {
>       struct whpx_state *whpx = &whpx_global;
>       AccelCPUState *vcpu = cpu->accel;
> @@ -934,7 +917,7 @@ static int whpx_handle_portio(CPUState *cpu,
>    * The 'exceptions' argument accepts a bitmask, e.g:
>    * (1 << WHvX64ExceptionTypeDebugTrapOrFault) | (...)
>    */
> -static HRESULT whpx_set_exception_exit_bitmap(UINT64 exceptions)
> +HRESULT whpx_set_exception_exit_bitmap(UINT64 exceptions)
>   {
>       struct whpx_state *whpx = &whpx_global;
>       WHV_PARTITION_PROPERTY prop = { 0, };
> @@ -1084,23 +1067,6 @@ static HRESULT whpx_vcpu_configure_single_stepping(CPUState *cpu,
>       return S_OK;
>   }
>   
> -/* Tries to find a breakpoint at the specified address. */
> -static struct whpx_breakpoint *whpx_lookup_breakpoint_by_addr(uint64_t address)
> -{
> -    struct whpx_state *whpx = &whpx_global;
> -    int i;
> -
> -    if (whpx->breakpoints.breakpoints) {
> -        for (i = 0; i < whpx->breakpoints.breakpoints->used; i++) {
> -            if (address == whpx->breakpoints.breakpoints->data[i].address) {
> -                return &whpx->breakpoints.breakpoints->data[i];
> -            }
> -        }
> -    }
> -
> -    return NULL;
> -}
> -
>   /*
>    * Linux uses int3 (0xCC) during startup (see int3_selftest()) and for
>    * debugging user-mode applications. Since the WHPX API does not offer
> @@ -1136,7 +1102,7 @@ static const uint8_t whpx_breakpoint_instruction = 0xF1;
>    * memory, but doesn't actually do it. The memory accessing is done in
>    * whpx_apply_breakpoints().
>    */
> -static void whpx_translate_cpu_breakpoints(
> +void whpx_translate_cpu_breakpoints(
>       struct whpx_breakpoints *breakpoints,
>       CPUState *cpu,
>       int cpu_breakpoint_count)
> @@ -1230,7 +1196,7 @@ static void whpx_translate_cpu_breakpoints(
>    * Passing resuming=true  will try to set all previously unset breakpoints.
>    * Passing resuming=false will remove all inserted ones.
>    */
> -static void whpx_apply_breakpoints(
> +void whpx_apply_breakpoints(
>       struct whpx_breakpoint_collection *breakpoints,
>       CPUState *cpu,
>       bool resuming)
> @@ -1306,93 +1272,6 @@ static void whpx_apply_breakpoints(
>       }
>   }
>   
> -/*
> - * This function is called when the a VCPU is about to start and no other
> - * VCPUs have been started so far. Since the VCPU start order could be
> - * arbitrary, it doesn't have to be VCPU#0.
> - *
> - * It is used to commit the breakpoints into memory, and configure WHPX
> - * to intercept debug exceptions.
> - *
> - * Note that whpx_set_exception_exit_bitmap() cannot be called if one or
> - * more VCPUs are already running, so this is the best place to do it.
> - */
> -static int whpx_first_vcpu_starting(CPUState *cpu)
> -{
> -    struct whpx_state *whpx = &whpx_global;
> -    HRESULT hr;
> -
> -    g_assert(bql_locked());
> -
> -    if (!QTAILQ_EMPTY(&cpu->breakpoints) ||
> -            (whpx->breakpoints.breakpoints &&
> -             whpx->breakpoints.breakpoints->used)) {
> -        CPUBreakpoint *bp;
> -        int i = 0;
> -        bool update_pending = false;
> -
> -        QTAILQ_FOREACH(bp, &cpu->breakpoints, entry) {
> -            if (i >= whpx->breakpoints.original_address_count ||
> -                bp->pc != whpx->breakpoints.original_addresses[i]) {
> -                update_pending = true;
> -            }
> -
> -            i++;
> -        }
> -
> -        if (i != whpx->breakpoints.original_address_count) {
> -            update_pending = true;
> -        }
> -
> -        if (update_pending) {
> -            /*
> -             * The CPU breakpoints have changed since the last call to
> -             * whpx_translate_cpu_breakpoints(). WHPX breakpoints must
> -             * now be recomputed.
> -             */
> -            whpx_translate_cpu_breakpoints(&whpx->breakpoints, cpu, i);
> -        }
> -
> -        /* Actually insert the breakpoints into the memory. */
> -        whpx_apply_breakpoints(whpx->breakpoints.breakpoints, cpu, true);
> -    }
> -
> -    uint64_t exception_mask;
> -    if (whpx->step_pending ||
> -        (whpx->breakpoints.breakpoints &&
> -         whpx->breakpoints.breakpoints->used)) {
> -        /*
> -         * We are either attempting to single-step one or more CPUs, or
> -         * have one or more breakpoints enabled. Both require intercepting
> -         * the WHvX64ExceptionTypeBreakpointTrap exception.
> -         */
> -
> -        exception_mask = 1UL << WHvX64ExceptionTypeDebugTrapOrFault;
> -    } else {
> -        /* Let the guest handle all exceptions. */
> -        exception_mask = 0;
> -    }
> -
> -    hr = whpx_set_exception_exit_bitmap(exception_mask);
> -    if (!SUCCEEDED(hr)) {
> -        error_report("WHPX: Failed to update exception exit mask,"
> -                     "hr=%08lx.", hr);
> -        return 1;
> -    }
> -
> -    return 0;
> -}
> -
> -/*
> - * This function is called when the last VCPU has finished running.
> - * It is used to remove any previously set breakpoints from memory.
> - */
> -static int whpx_last_vcpu_stopping(CPUState *cpu)
> -{
> -    whpx_apply_breakpoints(whpx_global.breakpoints.breakpoints, cpu, false);
> -    return 0;
> -}
> -
>   /* Returns the address of the next instruction that is about to be executed. */
>   static vaddr whpx_vcpu_get_pc(CPUState *cpu, bool exit_context_valid)
>   {
> @@ -1634,7 +1513,7 @@ static void whpx_vcpu_process_async_events(CPUState *cpu)
>       }
>   }
>   
> -static int whpx_vcpu_run(CPUState *cpu)
> +int whpx_vcpu_run(CPUState *cpu)
>   {
>       HRESULT hr;
>       struct whpx_state *whpx = &whpx_global;
> @@ -2057,65 +1936,6 @@ static int whpx_vcpu_run(CPUState *cpu)
>       return ret < 0;
>   }
>   
> -static void do_whpx_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
> -{
> -    if (!cpu->vcpu_dirty) {
> -        whpx_get_registers(cpu);
> -        cpu->vcpu_dirty = true;
> -    }
> -}
> -
> -static void do_whpx_cpu_synchronize_post_reset(CPUState *cpu,
> -                                               run_on_cpu_data arg)
> -{
> -    whpx_set_registers(cpu, WHPX_SET_RESET_STATE);
> -    cpu->vcpu_dirty = false;
> -}
> -
> -static void do_whpx_cpu_synchronize_post_init(CPUState *cpu,
> -                                              run_on_cpu_data arg)
> -{
> -    whpx_set_registers(cpu, WHPX_SET_FULL_STATE);
> -    cpu->vcpu_dirty = false;
> -}
> -
> -static void do_whpx_cpu_synchronize_pre_loadvm(CPUState *cpu,
> -                                               run_on_cpu_data arg)
> -{
> -    cpu->vcpu_dirty = true;
> -}
> -
> -/*
> - * CPU support.
> - */
> -
> -void whpx_cpu_synchronize_state(CPUState *cpu)
> -{
> -    if (!cpu->vcpu_dirty) {
> -        run_on_cpu(cpu, do_whpx_cpu_synchronize_state, RUN_ON_CPU_NULL);
> -    }
> -}
> -
> -void whpx_cpu_synchronize_post_reset(CPUState *cpu)
> -{
> -    run_on_cpu(cpu, do_whpx_cpu_synchronize_post_reset, RUN_ON_CPU_NULL);
> -}
> -
> -void whpx_cpu_synchronize_post_init(CPUState *cpu)
> -{
> -    run_on_cpu(cpu, do_whpx_cpu_synchronize_post_init, RUN_ON_CPU_NULL);
> -}
> -
> -void whpx_cpu_synchronize_pre_loadvm(CPUState *cpu)
> -{
> -    run_on_cpu(cpu, do_whpx_cpu_synchronize_pre_loadvm, RUN_ON_CPU_NULL);
> -}
> -
> -static void whpx_pre_resume_vm(AccelState *as, bool step_pending)
> -{
> -    whpx_global.step_pending = step_pending;
> -}
> -
>   /*
>    * Vcpu support.
>    */
> @@ -2244,295 +2064,18 @@ error:
>       return ret;
>   }
>   
> -int whpx_vcpu_exec(CPUState *cpu)
> -{
> -    int ret;
> -    int fatal;
> -
> -    for (;;) {
> -        if (cpu->exception_index >= EXCP_INTERRUPT) {
> -            ret = cpu->exception_index;
> -            cpu->exception_index = -1;
> -            break;
> -        }
> -
> -        fatal = whpx_vcpu_run(cpu);
> -
> -        if (fatal) {
> -            error_report("WHPX: Failed to exec a virtual processor");
> -            abort();
> -        }
> -    }
> -
> -    return ret;
> -}
> -
> -void whpx_destroy_vcpu(CPUState *cpu)
> -{
> -    struct whpx_state *whpx = &whpx_global;
> -    AccelCPUState *vcpu = cpu->accel;
> -
> -    whp_dispatch.WHvDeleteVirtualProcessor(whpx->partition, cpu->cpu_index);
> -    whp_dispatch.WHvEmulatorDestroyEmulator(vcpu->emulator);
> -    g_free(cpu->accel);
> -}
> -
> -void whpx_vcpu_kick(CPUState *cpu)
> -{
> -    struct whpx_state *whpx = &whpx_global;
> -    whp_dispatch.WHvCancelRunVirtualProcessor(
> -        whpx->partition, cpu->cpu_index, 0);
> -}
> -
> -/*
> - * Memory support.
> - */
> -
> -static void whpx_update_mapping(hwaddr start_pa, ram_addr_t size,
> -                                void *host_va, int add, int rom,
> -                                const char *name)
> -{
> -    struct whpx_state *whpx = &whpx_global;
> -    HRESULT hr;
> -
> -    /*
> -    if (add) {
> -        printf("WHPX: ADD PA:%p Size:%p, Host:%p, %s, '%s'\n",
> -               (void*)start_pa, (void*)size, host_va,
> -               (rom ? "ROM" : "RAM"), name);
> -    } else {
> -        printf("WHPX: DEL PA:%p Size:%p, Host:%p,      '%s'\n",
> -               (void*)start_pa, (void*)size, host_va, name);
> -    }
> -    */
> -
> -    if (add) {
> -        hr = whp_dispatch.WHvMapGpaRange(whpx->partition,
> -                                         host_va,
> -                                         start_pa,
> -                                         size,
> -                                         (WHvMapGpaRangeFlagRead |
> -                                          WHvMapGpaRangeFlagExecute |
> -                                          (rom ? 0 : WHvMapGpaRangeFlagWrite)));
> -    } else {
> -        hr = whp_dispatch.WHvUnmapGpaRange(whpx->partition,
> -                                           start_pa,
> -                                           size);
> -    }
> -
> -    if (FAILED(hr)) {
> -        error_report("WHPX: Failed to %s GPA range '%s' PA:%p, Size:%p bytes,"
> -                     " Host:%p, hr=%08lx",
> -                     (add ? "MAP" : "UNMAP"), name,
> -                     (void *)(uintptr_t)start_pa, (void *)size, host_va, hr);
> -    }
> -}
> -
> -static void whpx_process_section(MemoryRegionSection *section, int add)
> -{
> -    MemoryRegion *mr = section->mr;
> -    hwaddr start_pa = section->offset_within_address_space;
> -    ram_addr_t size = int128_get64(section->size);
> -    unsigned int delta;
> -    uint64_t host_va;
> -
> -    if (!memory_region_is_ram(mr)) {
> -        return;
> -    }
> -
> -    delta = qemu_real_host_page_size() - (start_pa & ~qemu_real_host_page_mask());
> -    delta &= ~qemu_real_host_page_mask();
> -    if (delta > size) {
> -        return;
> -    }
> -    start_pa += delta;
> -    size -= delta;
> -    size &= qemu_real_host_page_mask();
> -    if (!size || (start_pa & ~qemu_real_host_page_mask())) {
> -        return;
> -    }
> -
> -    host_va = (uintptr_t)memory_region_get_ram_ptr(mr)
> -            + section->offset_within_region + delta;
> -
> -    whpx_update_mapping(start_pa, size, (void *)(uintptr_t)host_va, add,
> -                        memory_region_is_rom(mr), mr->name);
> -}
> -
> -static void whpx_region_add(MemoryListener *listener,
> -                           MemoryRegionSection *section)
> -{
> -    memory_region_ref(section->mr);
> -    whpx_process_section(section, 1);
> -}
> -
> -static void whpx_region_del(MemoryListener *listener,
> -                           MemoryRegionSection *section)
> -{
> -    whpx_process_section(section, 0);
> -    memory_region_unref(section->mr);
> -}
> -
> -static void whpx_transaction_begin(MemoryListener *listener)
> -{
> -}
> -
> -static void whpx_transaction_commit(MemoryListener *listener)
> -{
> -}
> -
> -static void whpx_log_sync(MemoryListener *listener,
> -                         MemoryRegionSection *section)
> -{
> -    MemoryRegion *mr = section->mr;
> -
> -    if (!memory_region_is_ram(mr)) {
> -        return;
> -    }
> -
> -    memory_region_set_dirty(mr, 0, int128_get64(section->size));
> -}
> -
> -static MemoryListener whpx_memory_listener = {
> -    .name = "whpx",
> -    .begin = whpx_transaction_begin,
> -    .commit = whpx_transaction_commit,
> -    .region_add = whpx_region_add,
> -    .region_del = whpx_region_del,
> -    .log_sync = whpx_log_sync,
> -    .priority = MEMORY_LISTENER_PRIORITY_ACCEL,
> -};
> -
> -static void whpx_memory_init(void)
> -{
> -    memory_listener_register(&whpx_memory_listener, &address_space_memory);
> -}
> -
> -/*
> - * Load the functions from the given library, using the given handle. If a
> - * handle is provided, it is used, otherwise the library is opened. The
> - * handle will be updated on return with the opened one.
> - */
> -static bool load_whp_dispatch_fns(HMODULE *handle,
> -    WHPFunctionList function_list)
> -{
> -    HMODULE hLib = *handle;
> -
> -    #define WINHV_PLATFORM_DLL "WinHvPlatform.dll"
> -    #define WINHV_EMULATION_DLL "WinHvEmulation.dll"
> -    #define WHP_LOAD_FIELD_OPTIONAL(return_type, function_name, signature) \
> -        whp_dispatch.function_name = \
> -            (function_name ## _t)GetProcAddress(hLib, #function_name); \
> -
> -    #define WHP_LOAD_FIELD(return_type, function_name, signature) \
> -        whp_dispatch.function_name = \
> -            (function_name ## _t)GetProcAddress(hLib, #function_name); \
> -        if (!whp_dispatch.function_name) { \
> -            error_report("Could not load function %s", #function_name); \
> -            goto error; \
> -        } \
> -
> -    #define WHP_LOAD_LIB(lib_name, handle_lib) \
> -    if (!handle_lib) { \
> -        handle_lib = LoadLibrary(lib_name); \
> -        if (!handle_lib) { \
> -            error_report("Could not load library %s.", lib_name); \
> -            goto error; \
> -        } \
> -    } \
> -
> -    switch (function_list) {
> -    case WINHV_PLATFORM_FNS_DEFAULT:
> -        WHP_LOAD_LIB(WINHV_PLATFORM_DLL, hLib)
> -        LIST_WINHVPLATFORM_FUNCTIONS(WHP_LOAD_FIELD)
> -        break;
> -
> -    case WINHV_EMULATION_FNS_DEFAULT:
> -        WHP_LOAD_LIB(WINHV_EMULATION_DLL, hLib)
> -        LIST_WINHVEMULATION_FUNCTIONS(WHP_LOAD_FIELD)
> -        break;
> -
> -    case WINHV_PLATFORM_FNS_SUPPLEMENTAL:
> -        WHP_LOAD_LIB(WINHV_PLATFORM_DLL, hLib)
> -        LIST_WINHVPLATFORM_FUNCTIONS_SUPPLEMENTAL(WHP_LOAD_FIELD_OPTIONAL)
> -        break;
> -    }
> -
> -    *handle = hLib;
> -    return true;
> -
> -error:
> -    if (hLib) {
> -        FreeLibrary(hLib);
> -    }
> -
> -    return false;
> -}
> -
> -static void whpx_set_kernel_irqchip(Object *obj, Visitor *v,
> -                                   const char *name, void *opaque,
> -                                   Error **errp)
> -{
> -    struct whpx_state *whpx = &whpx_global;
> -    OnOffSplit mode;
> -
> -    if (!visit_type_OnOffSplit(v, name, &mode, errp)) {
> -        return;
> -    }
> -
> -    switch (mode) {
> -    case ON_OFF_SPLIT_ON:
> -        whpx->kernel_irqchip_allowed = true;
> -        whpx->kernel_irqchip_required = true;
> -        break;
> -
> -    case ON_OFF_SPLIT_OFF:
> -        whpx->kernel_irqchip_allowed = false;
> -        whpx->kernel_irqchip_required = false;
> -        break;
> -
> -    case ON_OFF_SPLIT_SPLIT:
> -        error_setg(errp, "WHPX: split irqchip currently not supported");
> -        error_append_hint(errp,
> -            "Try without kernel-irqchip or with kernel-irqchip=on|off");
> -        break;
> -
> -    default:
> -        /*
> -         * The value was checked in visit_type_OnOffSplit() above. If
> -         * we get here, then something is wrong in QEMU.
> -         */
> -        abort();
> -    }
> -}
> -
> -static void whpx_cpu_instance_init(CPUState *cs)
> +void whpx_cpu_instance_init(CPUState *cs)
>   {
>       X86CPU *cpu = X86_CPU(cs);
>   
>       host_cpu_instance_init(cpu);
>   }
>   
> -static void whpx_cpu_accel_class_init(ObjectClass *oc, const void *data)
> -{
> -    AccelCPUClass *acc = ACCEL_CPU_CLASS(oc);
> -
> -    acc->cpu_instance_init = whpx_cpu_instance_init;
> -}
> -
> -static const TypeInfo whpx_cpu_accel_type = {
> -    .name = ACCEL_CPU_NAME("whpx"),
> -
> -    .parent = TYPE_ACCEL_CPU,
> -    .class_init = whpx_cpu_accel_class_init,
> -    .abstract = true,
> -};
> -
>   /*
>    * Partition support
>    */
>   
> -static int whpx_accel_init(AccelState *as, MachineState *ms)
> +int whpx_accel_init(AccelState *as, MachineState *ms)
>   {
>       struct whpx_state *whpx;
>       int ret;
> @@ -2715,77 +2258,3 @@ error:
>   
>       return ret;
>   }
> -
> -bool whpx_apic_in_platform(void) {
> -    return whpx_global.apic_in_platform;
> -}
> -
> -static void whpx_accel_class_init(ObjectClass *oc, const void *data)
> -{
> -    AccelClass *ac = ACCEL_CLASS(oc);
> -    ac->name = "WHPX";
> -    ac->init_machine = whpx_accel_init;
> -    ac->pre_resume_vm = whpx_pre_resume_vm;
> -    ac->allowed = &whpx_allowed;
> -
> -    object_class_property_add(oc, "kernel-irqchip", "on|off|split",
> -        NULL, whpx_set_kernel_irqchip,
> -        NULL, NULL);
> -    object_class_property_set_description(oc, "kernel-irqchip",
> -        "Configure WHPX in-kernel irqchip");
> -}
> -
> -static void whpx_accel_instance_init(Object *obj)
> -{
> -    struct whpx_state *whpx = &whpx_global;
> -
> -    memset(whpx, 0, sizeof(struct whpx_state));
> -    /* Turn on kernel-irqchip, by default */
> -    whpx->kernel_irqchip_allowed = true;
> -}
> -
> -static const TypeInfo whpx_accel_type = {
> -    .name = ACCEL_CLASS_NAME("whpx"),
> -    .parent = TYPE_ACCEL,
> -    .instance_init = whpx_accel_instance_init,
> -    .class_init = whpx_accel_class_init,
> -};
> -
> -static void whpx_type_init(void)
> -{
> -    type_register_static(&whpx_accel_type);
> -    type_register_static(&whpx_cpu_accel_type);
> -}
> -
> -bool init_whp_dispatch(void)
> -{
> -    if (whp_dispatch_initialized) {
> -        return true;
> -    }
> -
> -    if (!load_whp_dispatch_fns(&hWinHvPlatform, WINHV_PLATFORM_FNS_DEFAULT)) {
> -        goto error;
> -    }
> -
> -    if (!load_whp_dispatch_fns(&hWinHvEmulation, WINHV_EMULATION_FNS_DEFAULT)) {
> -        goto error;
> -    }
> -
> -    assert(load_whp_dispatch_fns(&hWinHvPlatform,
> -        WINHV_PLATFORM_FNS_SUPPLEMENTAL));
> -    whp_dispatch_initialized = true;
> -
> -    return true;
> -error:
> -    if (hWinHvPlatform) {
> -        FreeLibrary(hWinHvPlatform);
> -    }
> -
> -    if (hWinHvEmulation) {
> -        FreeLibrary(hWinHvEmulation);
> -    }
> -
> -    return false;
> -}
> -
> -type_init(whpx_type_init);


