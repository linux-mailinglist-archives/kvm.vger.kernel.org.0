Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22CE26F920
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 11:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgIRJXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 05:23:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbgIRJXn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 05:23:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600421021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DHGWJXU6i5pp1p7TuHJthcB7MUd2QKUp8KmLLnakRws=;
        b=XP43z81vZv1nVkxLrzLNlD02ePyR5/AvDzEjyUO/RgMpQNT0uPDa8KAWNpHvy8Nz+oOcAA
        1As+9hFanY1Y0CkUyRXtUV4PtgXXfOTA3niz6+N9RIY9qz/1BGK2SG6z+Mb+fXbpe2wK/M
        UUJdRNs2QISiZReyQHDNmMwdI2nG2CQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-QUh5J1KoOo6c2H2xIbjvjA-1; Fri, 18 Sep 2020 05:23:39 -0400
X-MC-Unique: QUh5J1KoOo6c2H2xIbjvjA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A620E81F004;
        Fri, 18 Sep 2020 09:23:37 +0000 (UTC)
Received: from work-vm (ovpn-114-196.ams2.redhat.com [10.36.114.196])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AB5319D7C;
        Fri, 18 Sep 2020 09:23:31 +0000 (UTC)
Date:   Fri, 18 Sep 2020 10:23:29 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 4/5] sev/i386: Don't allow a system reset under an
 SEV-ES guest
Message-ID: <20200918092329.GE2816@work-vm>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <058dcb33a9cc223e3180133d29e7a92bfdc40938.1600205384.git.thomas.lendacky@amd.com>
 <20200917170119.GR2793@work-vm>
 <c54ec30c-21f6-db4f-72c4-b0825482a960@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c54ec30c-21f6-db4f-72c4-b0825482a960@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> On 9/17/20 12:01 PM, Dr. David Alan Gilbert wrote:
> > * Tom Lendacky (thomas.lendacky@amd.com) wrote:
> > > From: Tom Lendacky <thomas.lendacky@amd.com>
> > > 
> > > An SEV-ES guest does not allow register state to be altered once it has
> > > been measured. When a SEV-ES guest issues a reboot command, Qemu will
> > > reset the vCPU state and resume the guest. This will cause failures under
> > > SEV-ES, so prevent that from occurring.
> > > 
> > > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > > ---
> > >   accel/kvm/kvm-all.c       | 9 +++++++++
> > >   include/sysemu/cpus.h     | 2 ++
> > >   include/sysemu/hw_accel.h | 5 +++++
> > >   include/sysemu/kvm.h      | 2 ++
> > >   softmmu/cpus.c            | 5 +++++
> > >   softmmu/vl.c              | 5 ++++-
> > >   6 files changed, 27 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > > index 20725b0368..63153b6e53 100644
> > > --- a/accel/kvm/kvm-all.c
> > > +++ b/accel/kvm/kvm-all.c
> > > @@ -2388,6 +2388,15 @@ void kvm_flush_coalesced_mmio_buffer(void)
> > >       s->coalesced_flush_in_progress = false;
> > >   }
> > > +bool kvm_cpu_check_resettable(void)
> > > +{
> > > +    /*
> > > +     * If we have a valid reset vector override, then SEV-ES is active
> > > +     * and the CPU can't be reset.
> > > +     */
> > > +    return !kvm_state->reset_valid;
> > 
> > This seems a bit weird since it's in generic rather than x86 specific
> > code.
> 
> I could push it down to arch specific code.

It seems best to me.

> Is there a way to do that
> without defining the function for all the other arches?

I don't know this interface too well.

Dave

> 
> Thanks,
> Tom
> 
> > 
> > Dave
> > 
> > > +}
> > > +
> > >   static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
> > >   {
> > >       if (!cpu->vcpu_dirty) {
> > > diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
> > > index 3c1da6a018..6d688c757f 100644
> > > --- a/include/sysemu/cpus.h
> > > +++ b/include/sysemu/cpus.h
> > > @@ -24,6 +24,8 @@ void dump_drift_info(void);
> > >   void qemu_cpu_kick_self(void);
> > >   void qemu_timer_notify_cb(void *opaque, QEMUClockType type);
> > > +bool cpu_is_resettable(void);
> > > +
> > >   void cpu_synchronize_all_states(void);
> > >   void cpu_synchronize_all_post_reset(void);
> > >   void cpu_synchronize_all_post_init(void);
> > > diff --git a/include/sysemu/hw_accel.h b/include/sysemu/hw_accel.h
> > > index e128f8b06b..8b4536e7ae 100644
> > > --- a/include/sysemu/hw_accel.h
> > > +++ b/include/sysemu/hw_accel.h
> > > @@ -17,6 +17,11 @@
> > >   #include "sysemu/hvf.h"
> > >   #include "sysemu/whpx.h"
> > > +static inline bool cpu_check_resettable(void)
> > > +{
> > > +    return kvm_enabled() ? kvm_cpu_check_resettable() : true;
> > > +}
> > > +
> > >   static inline void cpu_synchronize_state(CPUState *cpu)
> > >   {
> > >       if (kvm_enabled()) {
> > > diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> > > index f74cfa85ab..eb94bbbff9 100644
> > > --- a/include/sysemu/kvm.h
> > > +++ b/include/sysemu/kvm.h
> > > @@ -494,6 +494,8 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
> > >   #endif /* NEED_CPU_H */
> > > +bool kvm_cpu_check_resettable(void);
> > > +
> > >   void kvm_cpu_synchronize_state(CPUState *cpu);
> > >   void kvm_cpu_synchronize_post_reset(CPUState *cpu);
> > >   void kvm_cpu_synchronize_post_init(CPUState *cpu);
> > > diff --git a/softmmu/cpus.c b/softmmu/cpus.c
> > > index a802e899ab..32f286643f 100644
> > > --- a/softmmu/cpus.c
> > > +++ b/softmmu/cpus.c
> > > @@ -927,6 +927,11 @@ void hw_error(const char *fmt, ...)
> > >       abort();
> > >   }
> > > +bool cpu_is_resettable(void)
> > > +{
> > > +    return cpu_check_resettable();
> > > +}
> > > +
> > >   void cpu_synchronize_all_states(void)
> > >   {
> > >       CPUState *cpu;
> > > diff --git a/softmmu/vl.c b/softmmu/vl.c
> > > index 4eb9d1f7fd..422fbb1650 100644
> > > --- a/softmmu/vl.c
> > > +++ b/softmmu/vl.c
> > > @@ -1475,7 +1475,10 @@ void qemu_system_guest_crashloaded(GuestPanicInformation *info)
> > >   void qemu_system_reset_request(ShutdownCause reason)
> > >   {
> > > -    if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
> > > +    if (!cpu_is_resettable()) {
> > > +        error_report("cpus are not resettable, terminating");
> > > +        shutdown_requested = reason;
> > > +    } else if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
> > >           shutdown_requested = reason;
> > >       } else {
> > >           reset_requested = reason;
> > > -- 
> > > 2.28.0
> > > 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

