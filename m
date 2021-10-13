Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2134D42CA72
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 21:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbhJMTyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 15:54:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231472AbhJMTyp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 15:54:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634154761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Bt6pdkI9efYxb2PaM1vRt2x7pgoGbklMN/ZpR9EusM=;
        b=LX8fiDu96TCe8xso3ZXzuH16CPufc/KcI9kS1CYEMUhmbyFi4jVSloLi5A4lniFNi5WZBC
        ecnPrX6NcUBRtlG/vwHlB56576VE9KJvmPOwhltwPshn7222pxZGac5P3Fx0/2U9DiPQxJ
        8bFStE5yTcPO4dHoJ9dad6gBIQK1eqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-Wp-nIAvtPW2Y9SZ5XPm0Zg-1; Wed, 13 Oct 2021 15:52:38 -0400
X-MC-Unique: Wp-nIAvtPW2Y9SZ5XPm0Zg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51318802936;
        Wed, 13 Oct 2021 19:52:37 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F7E75F4EA;
        Wed, 13 Oct 2021 19:52:02 +0000 (UTC)
Message-ID: <01068d813041258eba607c38f33f7cb13b1026a4.camel@redhat.com>
Subject: Re: [PATCH 2/3] gdbstub: implement NOIRQ support for single step on
 KVM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        kvm@vger.kernel.org
Date:   Wed, 13 Oct 2021 22:52:01 +0300
In-Reply-To: <87v920vs1v.fsf@linaro.org>
References: <20210914155214.105415-1-mlevitsk@redhat.com>
         <20210914155214.105415-3-mlevitsk@redhat.com> <87v920vs1v.fsf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-10-13 at 16:50 +0100, Alex Bennée wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  accel/kvm/kvm-all.c  | 25 ++++++++++++++++++
> >  gdbstub.c            | 60 ++++++++++++++++++++++++++++++++++++--------
> >  include/sysemu/kvm.h | 13 ++++++++++
> >  3 files changed, 88 insertions(+), 10 deletions(-)
> > 
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index 6b187e9c96..e141260796 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -169,6 +169,8 @@ bool kvm_vm_attributes_allowed;
> >  bool kvm_direct_msi_allowed;
> >  bool kvm_ioeventfd_any_length_allowed;
> >  bool kvm_msi_use_devid;
> > +bool kvm_has_guest_debug;
> > +int kvm_sstep_flags;
> >  static bool kvm_immediate_exit;
> >  static hwaddr kvm_max_slot_size = ~0;
> >  
> > @@ -2559,6 +2561,25 @@ static int kvm_init(MachineState *ms)
> >      kvm_sregs2 =
> >          (kvm_check_extension(s, KVM_CAP_SREGS2) > 0);
> >  
> > +    kvm_has_guest_debug =
> > +        (kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG) > 0);
> > +
> > +    kvm_sstep_flags = 0;
> > +
> > +    if (kvm_has_guest_debug) {
> > +        /* Assume that single stepping is supported */
> > +        kvm_sstep_flags = SSTEP_ENABLE;
> > +
> > +        int guest_debug_flags =
> > +            kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG2);
> > +
> > +        if (guest_debug_flags > 0) {
> > +            if (guest_debug_flags & KVM_GUESTDBG_BLOCKIRQ) {
> > +                kvm_sstep_flags |= SSTEP_NOIRQ;
> > +            }
> > +        }
> > +    }
> > +
> >      kvm_state = s;
> >  
> >      ret = kvm_arch_init(ms, s);
> > @@ -3188,6 +3209,10 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
> >  
> >      if (cpu->singlestep_enabled) {
> >          data.dbg.control |= KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP;
> > +
> > +        if (cpu->singlestep_enabled & SSTEP_NOIRQ) {
> > +            data.dbg.control |= KVM_GUESTDBG_BLOCKIRQ;
> > +        }
> >      }
> >      kvm_arch_update_guest_debug(cpu, &data.dbg);
> >  
> > diff --git a/gdbstub.c b/gdbstub.c
> > index 5d8e6ae3cd..48bb803bae 100644
> > --- a/gdbstub.c
> > +++ b/gdbstub.c
> > @@ -368,12 +368,11 @@ typedef struct GDBState {
> >      gdb_syscall_complete_cb current_syscall_cb;
> >      GString *str_buf;
> >      GByteArray *mem_buf;
> > +    int sstep_flags;
> > +    int supported_sstep_flags;
> >  } GDBState;
> >  
> > -/* By default use no IRQs and no timers while single stepping so as to
> > - * make single stepping like an ICE HW step.
> > - */
> > -static int sstep_flags = SSTEP_ENABLE|SSTEP_NOIRQ|SSTEP_NOTIMER;
> > +static GDBState gdbserver_state;
> >  
> >  /* Retrieves flags for single step mode. */
> >  static int get_sstep_flags(void)
> > @@ -385,11 +384,10 @@ static int get_sstep_flags(void)
> >      if (replay_mode != REPLAY_MODE_NONE) {
> >          return SSTEP_ENABLE;
> >      } else {
> > -        return sstep_flags;
> > +        return gdbserver_state.sstep_flags;
> >      }
> >  }
> >  
> > -static GDBState gdbserver_state;
> >  
> >  static void init_gdbserver_state(void)
> >  {
> > @@ -399,6 +397,23 @@ static void init_gdbserver_state(void)
> >      gdbserver_state.str_buf = g_string_new(NULL);
> >      gdbserver_state.mem_buf = g_byte_array_sized_new(MAX_PACKET_LENGTH);
> >      gdbserver_state.last_packet = g_byte_array_sized_new(MAX_PACKET_LENGTH + 4);
> > +
> > +
> > +    if (kvm_enabled()) {
> > +        gdbserver_state.supported_sstep_flags = kvm_get_supported_sstep_flags();
> > +    } else {
> > +        gdbserver_state.supported_sstep_flags =
> > +            SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
> > +    }
> 
> This fails to build:
> 
> o -c ../../gdbstub.c
> ../../gdbstub.c: In function ‘init_gdbserver_state’:
> ../../gdbstub.c:403:49: error: implicit declaration of function ‘kvm_get_supported_sstep_flags’ [-Werror=implicit-function-declaration]
>   403 |         gdbserver_state.supported_sstep_flags = kvm_get_supported_sstep_flags();
>       |                                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../../gdbstub.c:403:49: error: nested extern declaration of ‘kvm_get_supported_sstep_flags’ [-Werror=nested-externs]
> ../../gdbstub.c: In function ‘gdbserver_start’:
> ../../gdbstub.c:3531:27: error: implicit declaration of function ‘kvm_supports_guest_debug’; did you mean ‘kvm_update_guest_debug’? [-Werror=implicit-function-declaration]
>  3531 |     if (kvm_enabled() && !kvm_supports_guest_debug()) {
>       |                           ^~~~~~~~~~~~~~~~~~~~~~~~
>       |                           kvm_update_guest_debug
> ../../gdbstub.c:3531:27: error: nested extern declaration of ‘kvm_supports_guest_debug’ [-Werror=nested-externs]
> cc1: all warnings being treated as errors
> 
> In fact looking back I can see I mentioned this last time:
> 
>   Subject: Re: [PATCH 2/2] gdbstub: implement NOIRQ support for single step on
>    KVM, when kvm's KVM_GUESTDBG_BLOCKIRQ debug flag is supported.
>   Date: Mon, 19 Apr 2021 17:29:25 +0100
>   In-reply-to: <20210401144152.1031282-3-mlevitsk@redhat.com>
>   Message-ID: <871rb69qqk.fsf@linaro.org>
> 
> Please in future could you include a revision number for your spin and
> mention bellow the --- what changes have been made since the last
> posting.

You mean it fails to build without KVM? I swear I tested build with TTG only after you mentioned this 
(or as it seems I only tried to).

Could you give me the ./configure parameters you used?

Sorry for this!
Best regards,
	Maxim Levitsky

> 
> 


