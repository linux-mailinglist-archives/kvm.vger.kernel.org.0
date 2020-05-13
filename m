Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3B51D0FB4
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 12:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgEMK3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 06:29:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727794AbgEMK3C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 06:29:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589365740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kcmT/ox8AHLX/QMTCJPzRwt3hsJ5CzQByK8qyk+UAh8=;
        b=XFQh3s3+BqgZf/oeqbAkce3N8p1GHCw+DmgJLAFJuQuxEMESIWpX7MaGiBvuzLIDlmjaeA
        KL6OWyzRHXYOJiflsuFIvSY59RSvIt42ScTO7u9yLDJmuhhg1DUrppRB23utWs0/mEhti8
        yWTm2w4UOuIgdxr3gPX6bpVm7yM09Jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-xqI8SoykMmaPbd2Rkkxylw-1; Wed, 13 May 2020 06:28:59 -0400
X-MC-Unique: xqI8SoykMmaPbd2Rkkxylw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B59F835B46;
        Wed, 13 May 2020 10:28:57 +0000 (UTC)
Received: from localhost (unknown [10.40.208.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D57247D94A;
        Wed, 13 May 2020 10:28:49 +0000 (UTC)
Date:   Wed, 13 May 2020 12:28:47 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Pan Nengyuan <pannengyuan@huawei.com>
Cc:     <pbonzini@redhat.com>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, euler.robot@huawei.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        zhang.zhanghailiang@huawei.com
Subject: Re: [PATCH v2] i386/kvm: fix a use-after-free when vcpu plug/unplug
Message-ID: <20200513122847.10dbc3c0@redhat.com>
In-Reply-To: <20200513132630.13412-1-pannengyuan@huawei.com>
References: <20200513132630.13412-1-pannengyuan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 May 2020 09:26:30 -0400
Pan Nengyuan <pannengyuan@huawei.com> wrote:

> When we hotplug vcpus, cpu_update_state is added to vm_change_state_head
> in kvm_arch_init_vcpu(). But it forgot to delete in kvm_arch_destroy_vcpu=
() after
> unplug. Then it will cause a use-after-free access. This patch delete it =
in
> kvm_arch_destroy_vcpu() to fix that.
>=20
> Reproducer:
>     virsh setvcpus vm1 4 --live
>     virsh setvcpus vm1 2 --live
>     virsh suspend vm1
>     virsh resume vm1
>=20
> The UAF stack:
> =3D=3Dqemu-system-x86_64=3D=3D28233=3D=3DERROR: AddressSanitizer: heap-us=
e-after-free on address 0x62e00002e798 at pc 0x5573c6917d9e bp 0x7fff07139e=
50 sp 0x7fff07139e40
> WRITE of size 1 at 0x62e00002e798 thread T0
>     #0 0x5573c6917d9d in cpu_update_state /mnt/sdb/qemu/target/i386/kvm.c=
:742
>     #1 0x5573c699121a in vm_state_notify /mnt/sdb/qemu/vl.c:1290
>     #2 0x5573c636287e in vm_prepare_start /mnt/sdb/qemu/cpus.c:2144
>     #3 0x5573c6362927 in vm_start /mnt/sdb/qemu/cpus.c:2150
>     #4 0x5573c71e8304 in qmp_cont /mnt/sdb/qemu/monitor/qmp-cmds.c:173
>     #5 0x5573c727cb1e in qmp_marshal_cont qapi/qapi-commands-misc.c:835
>     #6 0x5573c7694c7a in do_qmp_dispatch /mnt/sdb/qemu/qapi/qmp-dispatch.=
c:132
>     #7 0x5573c7694c7a in qmp_dispatch /mnt/sdb/qemu/qapi/qmp-dispatch.c:1=
75
>     #8 0x5573c71d9110 in monitor_qmp_dispatch /mnt/sdb/qemu/monitor/qmp.c=
:145
>     #9 0x5573c71dad4f in monitor_qmp_bh_dispatcher /mnt/sdb/qemu/monitor/=
qmp.c:234
>=20
> Reported-by: Euler Robot <euler.robot@huawei.com>
> Signed-off-by: Pan Nengyuan <pannengyuan@huawei.com>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
> - v2: remove unnecessary set vmsentry to null(there is no non-null check).
> ---
>  target/i386/cpu.h | 1 +
>  target/i386/kvm.c | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index e818fc712a..afbd11b7a3 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1631,6 +1631,7 @@ struct X86CPU {
> =20
>      CPUNegativeOffsetState neg;
>      CPUX86State env;
> +    VMChangeStateEntry *vmsentry;
> =20
>      uint64_t ucode_rev;
> =20
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 4901c6dd74..0a4eca5a85 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1770,7 +1770,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          }
>      }
> =20
> -    qemu_add_vm_change_state_handler(cpu_update_state, env);
> +    cpu->vmsentry =3D qemu_add_vm_change_state_handler(cpu_update_state,=
 env);
> =20
>      c =3D cpuid_find_entry(&cpuid_data.cpuid, 1, 0);
>      if (c) {
> @@ -1883,6 +1883,8 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
>          env->nested_state =3D NULL;
>      }
> =20
> +    qemu_del_vm_change_state_handler(cpu->vmsentry);
> +
>      return 0;
>  }
> =20

