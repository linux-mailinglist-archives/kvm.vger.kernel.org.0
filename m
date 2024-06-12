Return-Path: <kvm+bounces-19504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EE8B905D4D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:02:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2660CB220DD
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BE884E07;
	Wed, 12 Jun 2024 21:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="MuY9bWZS"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12E24315D
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718226149; cv=none; b=jGq2pmz8HFOmuRmFKbDdp4Vg9qZ3QywYQf/fstIRTEMvsx49rWogXhRFR+EYyPibedb+8hez5SSZQIk8Kncoo6CzL9tNN+uUUUgZg+FQCBkqLEu9zNgQXuUWtzJaPLWnOH/ql8brLMJUFkCEohp12jerDUvxepLgpMHmA53qvg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718226149; c=relaxed/simple;
	bh=gKChfnxxPaEOVOb26Sbf8eqwiOWKEI/u/Tb4Zma/iZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AffvFKuOAHY5+YWXo4l+t4Ak1nR8kSYoHlL6UwEfJoPkBdDd/ysWKGDVPnBrgCn8LJFsmPBYhm61wzQDNbH+qtnONKuj5FE0+K0kXO5EFdsmrwSeamYkV2wcCEBGaQRH92ED4kiyNCVPj6mIF/K5Tjsv/rfuYxUbODQIyFTrvEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=MuY9bWZS; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=CIYr5tZFHJifDHaa+y+tLJ6gq1EMh6hOggCv06CK6ew=; b=MuY9bWZSX+wotZDy
	KyUWhK/zbYJqwXi4Rw5p+b5cTxSoODS4JPqhTUgSJ7L91MG/0gOenKykxyYyGy5LrG8h74sP8GM9l
	IDuAEJD7cOh717EQT4ezzwDay4dzkgA4bBvQeDHz6ekxd92RgrvZc698rN6Cd0oh289NIMGV3w+lI
	rDgnCh+hGobXtlamQxVXDFWrWeqVazSqhS6Q7CKIXTB6akmtnQYnue8zXTesY+3XMwhLDFS9WMrbs
	a1jg2NV7kjIRHoTfO9YKIk+XTuWjtGDv6nPYG9gPnnts6aGe7pUo4YmZETRm7oPnlgSYkHekXYuRF
	2abDct+A5XnMVNzwzQ==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1sHV6n-005tz7-2O;
	Wed, 12 Jun 2024 21:02:17 +0000
Date: Wed, 12 Jun 2024 21:02:17 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>, qemu-s390x@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandre Iooss <erdnaxe@crans.org>, qemu-arm@nongnu.org,
	Alexander Graf <agraf@csgraf.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>, qemu-ppc@nongnu.org,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH 9/9] contrib/plugins: add ips plugin example for cost
 modeling
Message-ID: <ZmoM2Sac97PdXWcC@gallifrey>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-10-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240612153508.1532940-10-alex.bennee@linaro.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 20:58:18 up 35 days,  8:12,  1 user,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Alex Bennée (alex.bennee@linaro.org) wrote:
> From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> 
> This plugin uses the new time control interface to make decisions
> about the state of time during the emulation. The algorithm is
> currently very simple. The user specifies an ips rate which applies
> per core. If the core runs ahead of its allocated execution time the
> plugin sleeps for a bit to let real time catch up. Either way time is
> updated for the emulation as a function of total executed instructions
> with some adjustments for cores that idle.

A few random thoughts:
  a) Are there any definitions of what a plugin that controls time
     should do with a live migration?
  b) The sleep in migration/dirtyrate.c points out g_usleep might
     sleep for longer, so reads the actual wall clock time to
     figure out a new 'now'.
  c) A fun thing to do with this would be to follow an external simulation
     or 2nd qemu, trying to keep the two from running too far past
     each other.

Dave

> Examples
> --------
> 
> Slow down execution of /bin/true:
> $ num_insn=$(./build/qemu-x86_64 -plugin ./build/tests/plugin/libinsn.so -d plugin /bin/true |& grep total | sed -e 's/.*: //')
> $ time ./build/qemu-x86_64 -plugin ./build/contrib/plugins/libips.so,ips=$(($num_insn/4)) /bin/true
> real 4.000s
> 
> Boot a Linux kernel simulating a 250MHz cpu:
> $ /build/qemu-system-x86_64 -kernel /boot/vmlinuz-6.1.0-21-amd64 -append "console=ttyS0" -plugin ./build/contrib/plugins/libips.so,ips=$((250*1000*1000)) -smp 1 -m 512
> check time until kernel panic on serial0
> 
> Tested in system mode by booting a full debian system, and using:
> $ sysbench cpu run
> Performance decrease linearly with the given number of ips.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Message-Id: <20240530220610.1245424-7-pierrick.bouvier@linaro.org>
> ---
>  contrib/plugins/ips.c    | 164 +++++++++++++++++++++++++++++++++++++++
>  contrib/plugins/Makefile |   1 +
>  2 files changed, 165 insertions(+)
>  create mode 100644 contrib/plugins/ips.c
> 
> diff --git a/contrib/plugins/ips.c b/contrib/plugins/ips.c
> new file mode 100644
> index 0000000000..db77729264
> --- /dev/null
> +++ b/contrib/plugins/ips.c
> @@ -0,0 +1,164 @@
> +/*
> + * ips rate limiting plugin.
> + *
> + * This plugin can be used to restrict the execution of a system to a
> + * particular number of Instructions Per Second (ips). This controls
> + * time as seen by the guest so while wall-clock time may be longer
> + * from the guests point of view time will pass at the normal rate.
> + *
> + * This uses the new plugin API which allows the plugin to control
> + * system time.
> + *
> + * Copyright (c) 2023 Linaro Ltd
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#include <stdio.h>
> +#include <glib.h>
> +#include <qemu-plugin.h>
> +
> +QEMU_PLUGIN_EXPORT int qemu_plugin_version = QEMU_PLUGIN_VERSION;
> +
> +/* how many times do we update time per sec */
> +#define NUM_TIME_UPDATE_PER_SEC 10
> +#define NSEC_IN_ONE_SEC (1000 * 1000 * 1000)
> +
> +static GMutex global_state_lock;
> +
> +static uint64_t max_insn_per_second = 1000 * 1000 * 1000; /* ips per core, per second */
> +static uint64_t max_insn_per_quantum; /* trap every N instructions */
> +static int64_t virtual_time_ns; /* last set virtual time */
> +
> +static const void *time_handle;
> +
> +typedef struct {
> +    uint64_t total_insn;
> +    uint64_t quantum_insn; /* insn in last quantum */
> +    int64_t last_quantum_time; /* time when last quantum started */
> +} vCPUTime;
> +
> +struct qemu_plugin_scoreboard *vcpus;
> +
> +/* return epoch time in ns */
> +static int64_t now_ns(void)
> +{
> +    return g_get_real_time() * 1000;
> +}
> +
> +static uint64_t num_insn_during(int64_t elapsed_ns)
> +{
> +    double num_secs = elapsed_ns / (double) NSEC_IN_ONE_SEC;
> +    return num_secs * (double) max_insn_per_second;
> +}
> +
> +static int64_t time_for_insn(uint64_t num_insn)
> +{
> +    double num_secs = (double) num_insn / (double) max_insn_per_second;
> +    return num_secs * (double) NSEC_IN_ONE_SEC;
> +}
> +
> +static void update_system_time(vCPUTime *vcpu)
> +{
> +    int64_t elapsed_ns = now_ns() - vcpu->last_quantum_time;
> +    uint64_t max_insn = num_insn_during(elapsed_ns);
> +
> +    if (vcpu->quantum_insn >= max_insn) {
> +        /* this vcpu ran faster than expected, so it has to sleep */
> +        uint64_t insn_advance = vcpu->quantum_insn - max_insn;
> +        uint64_t time_advance_ns = time_for_insn(insn_advance);
> +        int64_t sleep_us = time_advance_ns / 1000;
> +        g_usleep(sleep_us);
> +    }
> +
> +    vcpu->total_insn += vcpu->quantum_insn;
> +    vcpu->quantum_insn = 0;
> +    vcpu->last_quantum_time = now_ns();
> +
> +    /* based on total number of instructions, what should be the new time? */
> +    int64_t new_virtual_time = time_for_insn(vcpu->total_insn);
> +
> +    g_mutex_lock(&global_state_lock);
> +
> +    /* Time only moves forward. Another vcpu might have updated it already. */
> +    if (new_virtual_time > virtual_time_ns) {
> +        qemu_plugin_update_ns(time_handle, new_virtual_time);
> +        virtual_time_ns = new_virtual_time;
> +    }
> +
> +    g_mutex_unlock(&global_state_lock);
> +}
> +
> +static void vcpu_init(qemu_plugin_id_t id, unsigned int cpu_index)
> +{
> +    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
> +    vcpu->total_insn = 0;
> +    vcpu->quantum_insn = 0;
> +    vcpu->last_quantum_time = now_ns();
> +}
> +
> +static void vcpu_exit(qemu_plugin_id_t id, unsigned int cpu_index)
> +{
> +    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
> +    update_system_time(vcpu);
> +}
> +
> +static void every_quantum_insn(unsigned int cpu_index, void *udata)
> +{
> +    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
> +    g_assert(vcpu->quantum_insn >= max_insn_per_quantum);
> +    update_system_time(vcpu);
> +}
> +
> +static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
> +{
> +    size_t n_insns = qemu_plugin_tb_n_insns(tb);
> +    qemu_plugin_u64 quantum_insn =
> +        qemu_plugin_scoreboard_u64_in_struct(vcpus, vCPUTime, quantum_insn);
> +    /* count (and eventually trap) once per tb */
> +    qemu_plugin_register_vcpu_tb_exec_inline_per_vcpu(
> +        tb, QEMU_PLUGIN_INLINE_ADD_U64, quantum_insn, n_insns);
> +    qemu_plugin_register_vcpu_tb_exec_cond_cb(
> +        tb, every_quantum_insn,
> +        QEMU_PLUGIN_CB_NO_REGS, QEMU_PLUGIN_COND_GE,
> +        quantum_insn, max_insn_per_quantum, NULL);
> +}
> +
> +static void plugin_exit(qemu_plugin_id_t id, void *udata)
> +{
> +    qemu_plugin_scoreboard_free(vcpus);
> +}
> +
> +QEMU_PLUGIN_EXPORT int qemu_plugin_install(qemu_plugin_id_t id,
> +                                           const qemu_info_t *info, int argc,
> +                                           char **argv)
> +{
> +    for (int i = 0; i < argc; i++) {
> +        char *opt = argv[i];
> +        g_auto(GStrv) tokens = g_strsplit(opt, "=", 2);
> +        if (g_strcmp0(tokens[0], "ips") == 0) {
> +            max_insn_per_second = g_ascii_strtoull(tokens[1], NULL, 10);
> +            if (!max_insn_per_second && errno) {
> +                fprintf(stderr, "%s: couldn't parse %s (%s)\n",
> +                        __func__, tokens[1], g_strerror(errno));
> +                return -1;
> +            }
> +        } else {
> +            fprintf(stderr, "option parsing failed: %s\n", opt);
> +            return -1;
> +        }
> +    }
> +
> +    vcpus = qemu_plugin_scoreboard_new(sizeof(vCPUTime));
> +    max_insn_per_quantum = max_insn_per_second / NUM_TIME_UPDATE_PER_SEC;
> +
> +    time_handle = qemu_plugin_request_time_control();
> +    g_assert(time_handle);
> +
> +    qemu_plugin_register_vcpu_tb_trans_cb(id, vcpu_tb_trans);
> +    qemu_plugin_register_vcpu_init_cb(id, vcpu_init);
> +    qemu_plugin_register_vcpu_exit_cb(id, vcpu_exit);
> +    qemu_plugin_register_atexit_cb(id, plugin_exit, NULL);
> +
> +    return 0;
> +}
> diff --git a/contrib/plugins/Makefile b/contrib/plugins/Makefile
> index 0b64d2c1e3..449ead1130 100644
> --- a/contrib/plugins/Makefile
> +++ b/contrib/plugins/Makefile
> @@ -27,6 +27,7 @@ endif
>  NAMES += hwprofile
>  NAMES += cache
>  NAMES += drcov
> +NAMES += ips
>  
>  ifeq ($(CONFIG_WIN32),y)
>  SO_SUFFIX := .dll
> -- 
> 2.39.2
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

