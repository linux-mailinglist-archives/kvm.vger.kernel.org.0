Return-Path: <kvm+bounces-19819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC6AD90BC7A
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 22:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ABCE1C21C13
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 20:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D41A198E8F;
	Mon, 17 Jun 2024 20:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="bfsfFEQ1"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C2B7492
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 20:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718657774; cv=none; b=ZFjBupLzHmeV5Oh296hIp4o2RFrau2JDjq84cR1eOReaeR8gHwRJ+/rygot3PtV80AyEwLugcbT8iTICgTrOrhLWfRr3Y6KNNU8WoFngKLCaFvvYGUWaUpHX3zCMXifVNz1XfL9R375aIrg+YpRacreiP/FvLFiwk65UeRztylU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718657774; c=relaxed/simple;
	bh=hZxAiat3DmrP1bsRXfa9R0dek2Et5t9Yv0kg1TIkwUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XlvAx/Gq/zTlGKtsOu8YsdwQug7hyWeyLNuyhUFM3HieGPA1TOf6x+IbAqeHcPjem7SEr+5lql1c9E2Lzh8MwBQLD8XpwqhbT755LgLNiPRBETJaxmDxk4IT81UJmf47y+zR+sufS0pOPHALreD799pRkWsPPQThbjZsy96ONAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=bfsfFEQ1; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=rzuWFGH9nz0Vt6FWTS7gnA6FC7azHhR2rkN/N3vGe58=; b=bfsfFEQ1jqjK9vmd
	6+LJ7dz+maV/a3RkzAOh31Pmvf6ROfXGZCwQ2OPDI9KSmcAZ7QYu2OFxtnk+WT/phuflTnsxK6pkM
	hsZ8sTYfePTPAodOax6krwdQIFZs4rp9qwexgaPElbXUw3FviusSPVA37F0VYm9OsMPTPMDN5sOjc
	4n++TSoDiHQguNtB82FndKLlOa/0QSCQ4QcmW4pvyC4nDyITB++qT1wPTvQMenYpfKygH65KbNNJz
	y/VzHR+QRXuZbCEJyeysM3tNsSGYkjMGf29/3sdCLVjMdhnwymDuoAOlEfDEQdiEd1UaTYBcEF0Gr
	gswHtRxt4P9fhkEhTw==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1sJJOU-006le1-2O;
	Mon, 17 Jun 2024 20:56:02 +0000
Date: Mon, 17 Jun 2024 20:56:02 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	qemu-devel@nongnu.org, David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <ZnCi4hcyR8wMMnK4@gallifrey>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-10-alex.bennee@linaro.org>
 <ZmoM2Sac97PdXWcC@gallifrey>
 <777e1b13-9a4f-4c32-9ff7-9cedf7417695@linaro.org>
 <Zmy9g1U1uP1Vhx9N@gallifrey>
 <616df287-a167-4a05-8f08-70a78a544929@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <616df287-a167-4a05-8f08-70a78a544929@linaro.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 20:53:22 up 40 days,  8:07,  2 users,  load average: 0.03, 0.02,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Pierrick Bouvier (pierrick.bouvier@linaro.org) wrote:
> On 6/14/24 15:00, Dr. David Alan Gilbert wrote:
> > * Pierrick Bouvier (pierrick.bouvier@linaro.org) wrote:
> > > Hi Dave,
> > > 
> > > On 6/12/24 14:02, Dr. David Alan Gilbert wrote:
> > > > * Alex Bennée (alex.bennee@linaro.org) wrote:
> > > > > From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> > > > > 
> > > > > This plugin uses the new time control interface to make decisions
> > > > > about the state of time during the emulation. The algorithm is
> > > > > currently very simple. The user specifies an ips rate which applies
> > > > > per core. If the core runs ahead of its allocated execution time the
> > > > > plugin sleeps for a bit to let real time catch up. Either way time is
> > > > > updated for the emulation as a function of total executed instructions
> > > > > with some adjustments for cores that idle.
> > > > 
> > > > A few random thoughts:
> > > >     a) Are there any definitions of what a plugin that controls time
> > > >        should do with a live migration?
> > > 
> > > It's not something that was considered as part of this work.
> > 
> > That's OK, the only thing is we need to stop anyone from hitting problems
> > when they don't realise it's not been addressed.
> > One way might be to add a migration blocker; see include/migration/blocker.h
> > then you might print something like 'Migration not available due to plugin ....'
> > 
> 
> So basically, we could make a call to migrate_add_blocker(), when someone
> request time_control through plugin API?
> 
> IMHO, it's something that should be part of plugin API (if any plugin calls
> qemu_plugin_request_time_control()), instead of the plugin code itself. This
> way, any plugin getting time control automatically blocks any potential
> migration.

Note my question asked for a 'any definitions of what a plugin ..' - so
you could define it that way, another one is to think that in the future
you may allow it and the plugin somehow interacts with migration not to
change time at certain migration phases.

> > > >     b) The sleep in migration/dirtyrate.c points out g_usleep might
> > > >        sleep for longer, so reads the actual wall clock time to
> > > >        figure out a new 'now'.
> > > 
> > > The current API mentions time starts at 0 from qemu startup. Maybe we could
> > > consider in the future to change this behavior to retrieve time from an
> > > existing migrated machine.
> > 
> > Ah, I meant for (b) to be independent of (a) - not related to migration; just
> > down to the fact you used g_usleep in the plugin and a g_usleep might sleep
> > for a different amount of time than you asked.
> > 
> 
> We know that, and the plugin is not meant to be "cycle accurate" in general,
> we just set a upper bound for number of instructions we can execute in a
> given amount of time (1/10 second for now).
> 
> We compute the new time based on how many instructions effectively ran on
> the most used cpu, so even if we slept a bit more than expected, it's
> correct.

Ah OK.

Dave

> > > >     c) A fun thing to do with this would be to follow an external simulation
> > > >        or 2nd qemu, trying to keep the two from running too far past
> > > >        each other.
> > > > 
> > > 
> > > Basically, to slow the first one, waiting for the replicated one to catch
> > > up?
> > 
> > Yes, something like that.
> > 
> > Dave
> > 
> > > > Dave >
> > > > > Examples
> > > > > --------
> > > > > 
> > > > > Slow down execution of /bin/true:
> > > > > $ num_insn=$(./build/qemu-x86_64 -plugin ./build/tests/plugin/libinsn.so -d plugin /bin/true |& grep total | sed -e 's/.*: //')
> > > > > $ time ./build/qemu-x86_64 -plugin ./build/contrib/plugins/libips.so,ips=$(($num_insn/4)) /bin/true
> > > > > real 4.000s
> > > > > 
> > > > > Boot a Linux kernel simulating a 250MHz cpu:
> > > > > $ /build/qemu-system-x86_64 -kernel /boot/vmlinuz-6.1.0-21-amd64 -append "console=ttyS0" -plugin ./build/contrib/plugins/libips.so,ips=$((250*1000*1000)) -smp 1 -m 512
> > > > > check time until kernel panic on serial0
> > > > > 
> > > > > Tested in system mode by booting a full debian system, and using:
> > > > > $ sysbench cpu run
> > > > > Performance decrease linearly with the given number of ips.
> > > > > 
> > > > > Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> > > > > Message-Id: <20240530220610.1245424-7-pierrick.bouvier@linaro.org>
> > > > > ---
> > > > >    contrib/plugins/ips.c    | 164 +++++++++++++++++++++++++++++++++++++++
> > > > >    contrib/plugins/Makefile |   1 +
> > > > >    2 files changed, 165 insertions(+)
> > > > >    create mode 100644 contrib/plugins/ips.c
> > > > > 
> > > > > diff --git a/contrib/plugins/ips.c b/contrib/plugins/ips.c
> > > > > new file mode 100644
> > > > > index 0000000000..db77729264
> > > > > --- /dev/null
> > > > > +++ b/contrib/plugins/ips.c
> > > > > @@ -0,0 +1,164 @@
> > > > > +/*
> > > > > + * ips rate limiting plugin.
> > > > > + *
> > > > > + * This plugin can be used to restrict the execution of a system to a
> > > > > + * particular number of Instructions Per Second (ips). This controls
> > > > > + * time as seen by the guest so while wall-clock time may be longer
> > > > > + * from the guests point of view time will pass at the normal rate.
> > > > > + *
> > > > > + * This uses the new plugin API which allows the plugin to control
> > > > > + * system time.
> > > > > + *
> > > > > + * Copyright (c) 2023 Linaro Ltd
> > > > > + *
> > > > > + * SPDX-License-Identifier: GPL-2.0-or-later
> > > > > + */
> > > > > +
> > > > > +#include <stdio.h>
> > > > > +#include <glib.h>
> > > > > +#include <qemu-plugin.h>
> > > > > +
> > > > > +QEMU_PLUGIN_EXPORT int qemu_plugin_version = QEMU_PLUGIN_VERSION;
> > > > > +
> > > > > +/* how many times do we update time per sec */
> > > > > +#define NUM_TIME_UPDATE_PER_SEC 10
> > > > > +#define NSEC_IN_ONE_SEC (1000 * 1000 * 1000)
> > > > > +
> > > > > +static GMutex global_state_lock;
> > > > > +
> > > > > +static uint64_t max_insn_per_second = 1000 * 1000 * 1000; /* ips per core, per second */
> > > > > +static uint64_t max_insn_per_quantum; /* trap every N instructions */
> > > > > +static int64_t virtual_time_ns; /* last set virtual time */
> > > > > +
> > > > > +static const void *time_handle;
> > > > > +
> > > > > +typedef struct {
> > > > > +    uint64_t total_insn;
> > > > > +    uint64_t quantum_insn; /* insn in last quantum */
> > > > > +    int64_t last_quantum_time; /* time when last quantum started */
> > > > > +} vCPUTime;
> > > > > +
> > > > > +struct qemu_plugin_scoreboard *vcpus;
> > > > > +
> > > > > +/* return epoch time in ns */
> > > > > +static int64_t now_ns(void)
> > > > > +{
> > > > > +    return g_get_real_time() * 1000;
> > > > > +}
> > > > > +
> > > > > +static uint64_t num_insn_during(int64_t elapsed_ns)
> > > > > +{
> > > > > +    double num_secs = elapsed_ns / (double) NSEC_IN_ONE_SEC;
> > > > > +    return num_secs * (double) max_insn_per_second;
> > > > > +}
> > > > > +
> > > > > +static int64_t time_for_insn(uint64_t num_insn)
> > > > > +{
> > > > > +    double num_secs = (double) num_insn / (double) max_insn_per_second;
> > > > > +    return num_secs * (double) NSEC_IN_ONE_SEC;
> > > > > +}
> > > > > +
> > > > > +static void update_system_time(vCPUTime *vcpu)
> > > > > +{
> > > > > +    int64_t elapsed_ns = now_ns() - vcpu->last_quantum_time;
> > > > > +    uint64_t max_insn = num_insn_during(elapsed_ns);
> > > > > +
> > > > > +    if (vcpu->quantum_insn >= max_insn) {
> > > > > +        /* this vcpu ran faster than expected, so it has to sleep */
> > > > > +        uint64_t insn_advance = vcpu->quantum_insn - max_insn;
> > > > > +        uint64_t time_advance_ns = time_for_insn(insn_advance);
> > > > > +        int64_t sleep_us = time_advance_ns / 1000;
> > > > > +        g_usleep(sleep_us);
> > > > > +    }
> > > > > +
> > > > > +    vcpu->total_insn += vcpu->quantum_insn;
> > > > > +    vcpu->quantum_insn = 0;
> > > > > +    vcpu->last_quantum_time = now_ns();
> > > > > +
> > > > > +    /* based on total number of instructions, what should be the new time? */
> > > > > +    int64_t new_virtual_time = time_for_insn(vcpu->total_insn);
> > > > > +
> > > > > +    g_mutex_lock(&global_state_lock);
> > > > > +
> > > > > +    /* Time only moves forward. Another vcpu might have updated it already. */
> > > > > +    if (new_virtual_time > virtual_time_ns) {
> > > > > +        qemu_plugin_update_ns(time_handle, new_virtual_time);
> > > > > +        virtual_time_ns = new_virtual_time;
> > > > > +    }
> > > > > +
> > > > > +    g_mutex_unlock(&global_state_lock);
> > > > > +}
> > > > > +
> > > > > +static void vcpu_init(qemu_plugin_id_t id, unsigned int cpu_index)
> > > > > +{
> > > > > +    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
> > > > > +    vcpu->total_insn = 0;
> > > > > +    vcpu->quantum_insn = 0;
> > > > > +    vcpu->last_quantum_time = now_ns();
> > > > > +}
> > > > > +
> > > > > +static void vcpu_exit(qemu_plugin_id_t id, unsigned int cpu_index)
> > > > > +{
> > > > > +    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
> > > > > +    update_system_time(vcpu);
> > > > > +}
> > > > > +
> > > > > +static void every_quantum_insn(unsigned int cpu_index, void *udata)
> > > > > +{
> > > > > +    vCPUTime *vcpu = qemu_plugin_scoreboard_find(vcpus, cpu_index);
> > > > > +    g_assert(vcpu->quantum_insn >= max_insn_per_quantum);
> > > > > +    update_system_time(vcpu);
> > > > > +}
> > > > > +
> > > > > +static void vcpu_tb_trans(qemu_plugin_id_t id, struct qemu_plugin_tb *tb)
> > > > > +{
> > > > > +    size_t n_insns = qemu_plugin_tb_n_insns(tb);
> > > > > +    qemu_plugin_u64 quantum_insn =
> > > > > +        qemu_plugin_scoreboard_u64_in_struct(vcpus, vCPUTime, quantum_insn);
> > > > > +    /* count (and eventually trap) once per tb */
> > > > > +    qemu_plugin_register_vcpu_tb_exec_inline_per_vcpu(
> > > > > +        tb, QEMU_PLUGIN_INLINE_ADD_U64, quantum_insn, n_insns);
> > > > > +    qemu_plugin_register_vcpu_tb_exec_cond_cb(
> > > > > +        tb, every_quantum_insn,
> > > > > +        QEMU_PLUGIN_CB_NO_REGS, QEMU_PLUGIN_COND_GE,
> > > > > +        quantum_insn, max_insn_per_quantum, NULL);
> > > > > +}
> > > > > +
> > > > > +static void plugin_exit(qemu_plugin_id_t id, void *udata)
> > > > > +{
> > > > > +    qemu_plugin_scoreboard_free(vcpus);
> > > > > +}
> > > > > +
> > > > > +QEMU_PLUGIN_EXPORT int qemu_plugin_install(qemu_plugin_id_t id,
> > > > > +                                           const qemu_info_t *info, int argc,
> > > > > +                                           char **argv)
> > > > > +{
> > > > > +    for (int i = 0; i < argc; i++) {
> > > > > +        char *opt = argv[i];
> > > > > +        g_auto(GStrv) tokens = g_strsplit(opt, "=", 2);
> > > > > +        if (g_strcmp0(tokens[0], "ips") == 0) {
> > > > > +            max_insn_per_second = g_ascii_strtoull(tokens[1], NULL, 10);
> > > > > +            if (!max_insn_per_second && errno) {
> > > > > +                fprintf(stderr, "%s: couldn't parse %s (%s)\n",
> > > > > +                        __func__, tokens[1], g_strerror(errno));
> > > > > +                return -1;
> > > > > +            }
> > > > > +        } else {
> > > > > +            fprintf(stderr, "option parsing failed: %s\n", opt);
> > > > > +            return -1;
> > > > > +        }
> > > > > +    }
> > > > > +
> > > > > +    vcpus = qemu_plugin_scoreboard_new(sizeof(vCPUTime));
> > > > > +    max_insn_per_quantum = max_insn_per_second / NUM_TIME_UPDATE_PER_SEC;
> > > > > +
> > > > > +    time_handle = qemu_plugin_request_time_control();
> > > > > +    g_assert(time_handle);
> > > > > +
> > > > > +    qemu_plugin_register_vcpu_tb_trans_cb(id, vcpu_tb_trans);
> > > > > +    qemu_plugin_register_vcpu_init_cb(id, vcpu_init);
> > > > > +    qemu_plugin_register_vcpu_exit_cb(id, vcpu_exit);
> > > > > +    qemu_plugin_register_atexit_cb(id, plugin_exit, NULL);
> > > > > +
> > > > > +    return 0;
> > > > > +}
> > > > > diff --git a/contrib/plugins/Makefile b/contrib/plugins/Makefile
> > > > > index 0b64d2c1e3..449ead1130 100644
> > > > > --- a/contrib/plugins/Makefile
> > > > > +++ b/contrib/plugins/Makefile
> > > > > @@ -27,6 +27,7 @@ endif
> > > > >    NAMES += hwprofile
> > > > >    NAMES += cache
> > > > >    NAMES += drcov
> > > > > +NAMES += ips
> > > > >    ifeq ($(CONFIG_WIN32),y)
> > > > >    SO_SUFFIX := .dll
> > > > > -- 
> > > > > 2.39.2
> > > > > 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

