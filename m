Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50734373661
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhEEIif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:38:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231430AbhEEIid (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620203857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtKn7q/jjyOaIwnU/kXei3Qud4D4X3ajMn/UbY3OmKo=;
        b=KUlKtfLDCgHGNP6dsyY7mnh08E93DBupr8oHXBeeQwGcIjrvm3EU0kV+AGGSmYMh/sYGO9
        0rwhZ/IQKuiRbcQtzd9sJw1ysK4bHrKwQZeK/UzYYh3M2P/6Ei5rXeTGm1nC2vnGiHqOrt
        I5rNQhw2uHiLFLhi2vkodziyeaSexoc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-Y38uIskSMuSBnB16EjMj_A-1; Wed, 05 May 2021 04:37:34 -0400
X-MC-Unique: Y38uIskSMuSBnB16EjMj_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B65B1800D41;
        Wed,  5 May 2021 08:37:34 +0000 (UTC)
Received: from starship (unknown [10.40.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 725B260C17;
        Wed,  5 May 2021 08:37:28 +0000 (UTC)
Message-ID: <5f4ffcb1091567221bd0b9fd1efef53742e87332.camel@redhat.com>
Subject: Re: [PATCH 2/2] gdbstub: implement NOIRQ support for single step on
 KVM, when kvm's KVM_GUESTDBG_BLOCKIRQ debug flag is supported.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Date:   Wed, 05 May 2021 11:37:27 +0300
In-Reply-To: <871rb69qqk.fsf@linaro.org>
References: <20210401144152.1031282-1-mlevitsk@redhat.com>
                 <20210401144152.1031282-3-mlevitsk@redhat.com> <871rb69qqk.fsf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-19 at 17:29 +0100, Alex Benn=C3=A9e wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
>=20
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  accel/kvm/kvm-all.c  | 25 +++++++++++++++++++
> >  gdbstub.c            | 59 ++++++++++++++++++++++++++++++++++++--------
> >  include/sysemu/kvm.h | 13 ++++++++++
> >  3 files changed, 87 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index b6d9f92f15..bc7955fb19 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -147,6 +147,8 @@ bool kvm_vm_attributes_allowed;
> >  bool kvm_direct_msi_allowed;
> >  bool kvm_ioeventfd_any_length_allowed;
> >  bool kvm_msi_use_devid;
> > +bool kvm_has_guest_debug;
> > +int kvm_sstep_flags;
> >  static bool kvm_immediate_exit;
> >  static hwaddr kvm_max_slot_size =3D ~0;
> > =20
> > @@ -2186,6 +2188,25 @@ static int kvm_init(MachineState *ms)
> >      kvm_ioeventfd_any_length_allowed =3D
> >          (kvm_check_extension(s, KVM_CAP_IOEVENTFD_ANY_LENGTH) > 0);
> > =20
> > +    kvm_has_guest_debug =3D
> > +        (kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG) > 0);
> > +
> > +    kvm_sstep_flags =3D 0;
> > +
> > +    if (kvm_has_guest_debug) {
> > +        /* Assume that single stepping is supported */
> > +        kvm_sstep_flags =3D SSTEP_ENABLE;
> > +
> > +        int guest_debug_flags =3D
> > +            kvm_check_extension(s, KVM_CAP_SET_GUEST_DEBUG2);
> > +
> > +        if (guest_debug_flags > 0) {
> > +            if (guest_debug_flags & KVM_GUESTDBG_BLOCKIRQ) {
> > +                kvm_sstep_flags |=3D SSTEP_NOIRQ;
> > +            }
> > +        }
> > +    }
> > +
> >      kvm_state =3D s;
> > =20
> >      ret =3D kvm_arch_init(ms, s);
> > @@ -2796,6 +2817,10 @@ int kvm_update_guest_debug(CPUState *cpu, unsign=
ed long reinject_trap)
> > =20
> >      if (cpu->singlestep_enabled) {
> >          data.dbg.control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGL=
ESTEP;
> > +
> > +        if (cpu->singlestep_enabled & SSTEP_NOIRQ) {
> > +            data.dbg.control |=3D KVM_GUESTDBG_BLOCKIRQ;
> > +        }
> >      }
> >      kvm_arch_update_guest_debug(cpu, &data.dbg);
> > =20
> > diff --git a/gdbstub.c b/gdbstub.c
> > index 054665e93e..f789ded99d 100644
> > --- a/gdbstub.c
> > +++ b/gdbstub.c
> > @@ -369,12 +369,11 @@ typedef struct GDBState {
> >      gdb_syscall_complete_cb current_syscall_cb;
> >      GString *str_buf;
> >      GByteArray *mem_buf;
> > +    int sstep_flags;
> > +    int supported_sstep_flags;
> >  } GDBState;
> > =20
> > -/* By default use no IRQs and no timers while single stepping so as to
> > - * make single stepping like an ICE HW step.
> > - */
> > -static int sstep_flags =3D SSTEP_ENABLE|SSTEP_NOIRQ|SSTEP_NOTIMER;
> > +static GDBState gdbserver_state;
> > =20
> >  /* Retrieves flags for single step mode. */
> >  static int get_sstep_flags(void)
> > @@ -386,11 +385,10 @@ static int get_sstep_flags(void)
> >      if (replay_mode !=3D REPLAY_MODE_NONE) {
> >          return SSTEP_ENABLE;
> >      } else {
> > -        return sstep_flags;
> > +        return gdbserver_state.sstep_flags;
> >      }
> >  }
> > =20
> > -static GDBState gdbserver_state;
> > =20
> >  static void init_gdbserver_state(void)
> >  {
> > @@ -400,6 +398,23 @@ static void init_gdbserver_state(void)
> >      gdbserver_state.str_buf =3D g_string_new(NULL);
> >      gdbserver_state.mem_buf =3D g_byte_array_sized_new(MAX_PACKET_LENG=
TH);
> >      gdbserver_state.last_packet =3D g_byte_array_sized_new(MAX_PACKET_=
LENGTH + 4);
> > +
> > +
> > +    if (kvm_enabled()) {
> > +        gdbserver_state.supported_sstep_flags =3D
> >  kvm_get_supported_sstep_flags();
>=20
> This falls over as soon as you build something without KVM support (like
> a TCG only build or an emulation only target):

This is something I'll check from now on before sending patches.


>=20
>   [10/1152] Compiling C object libqemu-riscv32-softmmu.fa.p/gdbstub.c.o
>   FAILED: libqemu-riscv32-softmmu.fa.p/gdbstub.c.o=20
>   cc -Ilibqemu-riscv32-softmmu.fa.p -I. -I../.. -Itarget/riscv -I../../ta=
rget/riscv -Idtc/libfdt -I../../dtc/libfdt -I../../capstone/include/capston=
e -Iqapi -Itrace -Iui -Iui/shader -I/usr/include/pixman-1 -I/usr/include/li=
bdrm -I/usr/include/spice-server -I/usr/include/spice-1 -I/usr/include/glib=
-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -fdiagnostics-color=3Daut=
o -pipe -Wall -Winvalid-pch -Werror -std=3Dgnu99 -O2 -g -isystem /home/alex=
/lsrc/qemu.git/linux-headers -isystem linux-headers -iquote . -iquote /home=
/alex/lsrc/qemu.git -iquote /home/alex/lsrc/qemu.git/include -iquote /home/=
alex/lsrc/qemu.git/disas/libvixl -iquote /home/alex/lsrc/qemu.git/tcg/i386 =
-iquote /home/alex/lsrc/qemu.git/accel/tcg -pthread -U_FORTIFY_SOURCE -D_FO=
RTIFY_SOURCE=3D2 -m64 -mcx16 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_LARG=
EFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wundef -Wwrite-strings =
-Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv -Wold-style-d=
eclaration -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-=
y2k -Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-=
labels -Wexpansion-to-defined -Wimplicit-fallthrough=3D2 -Wno-missing-inclu=
de-dirs -Wno-shift-negative-value -Wno-psabi -fstack-protector-strong -DLEG=
ACY_RDMA_REG_MR -fPIC -isystem../../linux-headers -isystemlinux-headers -DN=
EED_CPU_H '-DCONFIG_TARGET=3D"riscv32-softmmu-config-target.h"' '-DCONFIG_D=
EVICES=3D"riscv32-softmmu-config-devices.h"' -MD -MQ libqemu-riscv32-softmm=
u.fa.p/gdbstub.c.o -MF libqemu-riscv32-softmmu.fa.p/gdbstub.c.o.d -o libqem=
u-riscv32-softmmu.fa.p/gdbstub.c.o -c ../../gdbstub.c
>   ../../gdbstub.c: In function =E2=80=98init_gdbserver_state=E2=80=99:
>   ../../gdbstub.c:404:49: error: implicit declaration of function =E2=80=
=98kvm_get_supported_sstep_flags=E2=80=99; did you mean =E2=80=98hvf_get_su=
pported_cpuid=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>            gdbserver_state.supported_sstep_flags =3D kvm_get_supported_ss=
tep_flags();
>                                                    ^~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~
>                                                    hvf_get_supported_cpui=
d
>   ../../gdbstub.c:404:49: error: nested extern declaration of =E2=80=98kv=
m_get_supported_sstep_flags=E2=80=99 [-Werror=3Dnested-externs]
>   ../../gdbstub.c: In function =E2=80=98gdbserver_start=E2=80=99:
>   ../../gdbstub.c:3536:27: error: implicit declaration of function =E2=80=
=98kvm_supports_guest_debug=E2=80=99; did you mean =E2=80=98kvm_update_gues=
t_debug=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>        if (kvm_enabled() && !kvm_supports_guest_debug()) {
>                              ^~~~~~~~~~~~~~~~~~~~~~~~
>                              kvm_update_guest_debug
>   ../../gdbstub.c:3536:27: error: nested extern declaration of =E2=80=98k=
vm_supports_guest_debug=E2=80=99 [-Werror=3Dnested-externs]
>   cc1: all warnings being treated as errors
>=20
>=20
> > +    } else {
> > +        gdbserver_state.supported_sstep_flags =3D
> > +            SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP_NOTIMER;
> > +    }
> > +
> > +    /*
> > +     * By default use no IRQs and no timers while single stepping so a=
s to
> > +     * make single stepping like an ICE HW step.
> > +     */
> > +
> > +    gdbserver_state.sstep_flags =3D SSTEP_ENABLE | SSTEP_NOIRQ | SSTEP=
_NOTIMER;
> > +    gdbserver_state.sstep_flags &=3D gdbserver_state.supported_sstep_f=
lags;
> > +
> >  }
> > =20
> >  #ifndef CONFIG_USER_ONLY
> > @@ -2023,24 +2038,43 @@ static void handle_v_commands(GdbCmdContext *gd=
b_ctx, void *user_ctx)
> > =20
> >  static void handle_query_qemu_sstepbits(GdbCmdContext *gdb_ctx, void *=
user_ctx)
> >  {
> > -    g_string_printf(gdbserver_state.str_buf, "ENABLE=3D%x,NOIRQ=3D%x,N=
OTIMER=3D%x",
> > -                    SSTEP_ENABLE, SSTEP_NOIRQ, SSTEP_NOTIMER);
> > +    g_string_printf(gdbserver_state.str_buf, "ENABLE=3D%x", SSTEP_ENAB=
LE);
> > +
> > +    if (gdbserver_state.supported_sstep_flags & SSTEP_NOIRQ) {
> > +        g_string_append_printf(gdbserver_state.str_buf, ",NOIRQ=3D%x",
> > +                               SSTEP_NOIRQ);
> > +    }
> > +
> > +    if (gdbserver_state.supported_sstep_flags & SSTEP_NOTIMER) {
> > +        g_string_append_printf(gdbserver_state.str_buf, ",NOTIMER=3D%x=
",
> > +                               SSTEP_NOTIMER);
> > +    }
> > +
> >      put_strbuf();
> >  }
> > =20
> >  static void handle_set_qemu_sstep(GdbCmdContext *gdb_ctx, void *user_c=
tx)
> >  {
> > +    int new_sstep_flags;
> >      if (!gdb_ctx->num_params) {
> >          return;
> >      }
> > =20
> > -    sstep_flags =3D gdb_ctx->params[0].val_ul;
> > +    new_sstep_flags =3D gdb_ctx->params[0].val_ul;
> > +
> > +    if (new_sstep_flags  & ~gdbserver_state.supported_sstep_flags) {
> > +        put_packet("E22");
> > +        return;
> > +    }
> > +
> > +    gdbserver_state.sstep_flags =3D new_sstep_flags;
> >      put_packet("OK");
> >  }
> > =20
> >  static void handle_query_qemu_sstep(GdbCmdContext *gdb_ctx, void *user=
_ctx)
> >  {
> > -    g_string_printf(gdbserver_state.str_buf, "0x%x", sstep_flags);
> > +    g_string_printf(gdbserver_state.str_buf, "0x%x",
> > +                    gdbserver_state.sstep_flags);
> >      put_strbuf();
> >  }
> > =20
> > @@ -3499,6 +3533,11 @@ int gdbserver_start(const char *device)
> >          return -1;
> >      }
> > =20
> > +    if (kvm_enabled() && !kvm_supports_guest_debug()) {
> > +        error_report("gdbstub: KVM doesn't support guest debugging");
> > +        return -1;
> > +    }
> > +
> <snip>
>=20
> Otherwise it looks fine as far as it goes, however it would be nice to
> have some sort of test in for this. The gdbstub has a hand-rolled gdb
> script in tests/guest-debug/test-gdbstub.py but it's not integrated with
> the rest of the testing.
I'll take a look!

>=20
> As I suspect you need a) KVM enabled, b) a recent enough kernel and c)
> some sort of guest kernel that is going to enable timers and IRQs this
> might be something worth porting to the acceptance tests.
>=20
> We have an example in tests/acceptance/reverse_debugging.py which is run
> as part of check-acceptance. It's TCG only but perhaps is a template for
> how such a test could be implemented.

Thanks for the review,
	Best regards,
		Maxim Levitsky
>=20


