Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 703A910B610
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfK0SsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:48:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44042 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727423AbfK0SsK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 13:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574880487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hAv+8Rp9p8BKrYrz0WR6s4F38PMsBWQjRKLYMYSaIm4=;
        b=U9NEryXhYGxXAM0q4IeLGxfD87Hd8i1wDG3N50QWtiFpSDiciyJp7t7MUVR4xfiY2ARq9H
        3vELcrvB5iUNZaP8wiAU2rT1NIVLNQpqbpcPsCAxJgGqIgbK1fjny381Xh3gOFq1GowmP8
        OZFGJ8AbEDCagNvitIxKNR3HDB/cSEw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-KT0ssU7kPXC09VGJWcNnQg-1; Wed, 27 Nov 2019 13:48:04 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEA918017CC;
        Wed, 27 Nov 2019 18:48:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2EC95D9D6;
        Wed, 27 Nov 2019 18:47:58 +0000 (UTC)
Date:   Wed, 27 Nov 2019 19:47:56 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH 10/18] arm/arm64: selftest: Add prefetch
 abort test
Message-ID: <20191127184756.encuqdupgwcky6ys@kamzik.brq.redhat.com>
References: <20191127142410.1994-1-alexandru.elisei@arm.com>
 <20191127142410.1994-11-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20191127142410.1994-11-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: KT0ssU7kPXC09VGJWcNnQg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 27, 2019 at 02:24:02PM +0000, Alexandru Elisei wrote:
> When a guest tries to execute code from MMIO memory, KVM injects an
> external abort into that guest. We have now fixed the psci test to not
> fetch instructions from the I/O region, and it's not that often that a
> guest misbehaves in such a way. Let's expand our coverage by adding a
> proper test targetting this corner case.
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm64/asm/esr.h |  3 ++
>  arm/selftest.c      | 97 +++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 97 insertions(+), 3 deletions(-)
>=20
> diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
> index 8e5af4d90767..8c351631b0a0 100644
> --- a/lib/arm64/asm/esr.h
> +++ b/lib/arm64/asm/esr.h
> @@ -44,4 +44,7 @@
>  #define ESR_EL1_EC_BKPT32=09(0x38)
>  #define ESR_EL1_EC_BRK64=09(0x3C)
> =20
> +#define ESR_EL1_FSC_MASK=09(0x3F)
> +#define ESR_EL1_FSC_EXTABT=09(0x10)
> +
>  #endif /* _ASMARM64_ESR_H_ */
> diff --git a/arm/selftest.c b/arm/selftest.c
> index e9dc5c0cab28..caad524378fc 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -16,6 +16,8 @@
>  #include <asm/psci.h>
>  #include <asm/smp.h>
>  #include <asm/barrier.h>
> +#include <asm/mmu.h>
> +#include <asm/pgtable.h>
> =20
>  static cpumask_t ready, valid;
> =20
> @@ -68,6 +70,7 @@ static void check_setup(int argc, char **argv)
>  static struct pt_regs expected_regs;
>  static bool und_works;
>  static bool svc_works;
> +static bool pabt_works;
>  #if defined(__arm__)
>  /*
>   * Capture the current register state and execute an instruction
> @@ -91,7 +94,7 @@ static bool svc_works;
>  =09=09"str=09r1, [r0, #" xstr(S_PC) "]\n"=09=09\
>  =09=09excptn_insn "\n"=09=09=09=09\
>  =09=09post_insns "\n"=09=09=09=09=09\
> -=09:: "r" (&expected_regs) : "r0", "r1")
> +=09:: "r" (&expected_regs) : "r0", "r1", "r2")
> =20
>  static bool check_regs(struct pt_regs *regs)
>  {
> @@ -171,6 +174,45 @@ static void user_psci_system_off(struct pt_regs *reg=
s)
>  {
>  =09__user_psci_system_off();
>  }
> +
> +static void check_pabt_exit(void)
> +{
> +=09install_exception_handler(EXCPTN_PABT, NULL);
> +
> +=09report("pabt", pabt_works);
> +=09exit(report_summary());
> +}
> +
> +static void pabt_handler(struct pt_regs *regs)
> +{
> +=09expected_regs.ARM_pc =3D 0;
> +=09pabt_works =3D check_regs(regs);
> +
> +=09regs->ARM_pc =3D (unsigned long)&check_pabt_exit;
> +}
> +
> +static void check_pabt(void)
> +{
> +=09unsigned long sctlr;
> +
> +=09/* Make sure we can actually execute from a writable region */
> +=09asm volatile("mrc p15, 0, %0, c1, c0, 0": "=3Dr" (sctlr));
> +=09if (sctlr & CR_ST) {
> +=09=09sctlr &=3D ~CR_ST;
> +=09=09asm volatile("mcr p15, 0, %0, c1, c0, 0" :: "r" (sctlr));
> +=09=09isb();
> +=09=09/*
> +=09=09 * Required according to the sequence in ARM DDI 0406C.d, page
> +=09=09 * B3-1358.
> +=09=09 */
> +=09=09flush_tlb_all();
> +=09}
> +
> +=09install_exception_handler(EXCPTN_PABT, pabt_handler);
> +
> +=09test_exception("mov r2, #0x0", "bx r2", "");
> +=09__builtin_unreachable();
> +}
>  #elif defined(__aarch64__)
> =20
>  /*
> @@ -212,7 +254,7 @@ static void user_psci_system_off(struct pt_regs *regs=
)
>  =09=09"stp=09 x0,  x1, [x1]\n"=09=09=09\
>  =09"1:"=09excptn_insn "\n"=09=09=09=09\
>  =09=09post_insns "\n"=09=09=09=09=09\
> -=09:: "r" (&expected_regs) : "x0", "x1")
> +=09:: "r" (&expected_regs) : "x0", "x1", "x2")
> =20
>  static bool check_regs(struct pt_regs *regs)
>  {
> @@ -288,6 +330,53 @@ static bool check_svc(void)
>  =09return svc_works;
>  }
> =20
> +static void check_pabt_exit(void)
> +{
> +=09install_exception_handler(EL1H_SYNC, ESR_EL1_EC_IABT_EL1, NULL);
> +
> +=09report("pabt", pabt_works);
> +=09exit(report_summary());
> +}
> +
> +static void pabt_handler(struct pt_regs *regs, unsigned int esr)
> +{
> +=09bool is_extabt;
> +
> +=09expected_regs.pc =3D 0;
> +=09is_extabt =3D (esr & ESR_EL1_FSC_MASK) =3D=3D ESR_EL1_FSC_EXTABT;
> +=09pabt_works =3D check_regs(regs) && is_extabt;
> +
> +=09regs->pc =3D (u64)&check_pabt_exit;
> +}
> +
> +static void check_pabt(void)
> +{
> +=09enum vector v =3D check_vector_prep();
> +=09unsigned long sctlr;
> +
> +=09/*
> +=09 * According to ARM DDI 0487E.a, table D5-33, footnote c, all regions
> +=09 * writable at EL0 are treated as PXN. Clear the user bit so we can
> +=09 * execute code from the bottom I/O space (0G-1G) to simulate a
> +=09 * misbehaved guest.
> +=09 */
> +=09mmu_clear_user(current_thread_info()->pgtable, 0);
> +
> +=09/* Make sure we can actually execute from a writable region */
> +=09sctlr =3D read_sysreg(sctlr_el1);
> +=09if (sctlr & SCTLR_EL1_WXN) {
> +=09=09write_sysreg(sctlr & ~SCTLR_EL1_WXN, sctlr_el1);
> +=09=09isb();
> +=09=09/* SCTLR_EL1.WXN is permitted to be cached in a TLB. */
> +=09=09flush_tlb_all();
> +=09}
> +
> +=09install_exception_handler(v, ESR_EL1_EC_IABT_EL1, pabt_handler);
> +
> +=09test_exception("mov x2, xzr", "br x2", "");
> +=09__builtin_unreachable();
> +}
> +
>  static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
>  {
>  =09__user_psci_system_off();
> @@ -298,7 +387,9 @@ static void check_vectors(void *arg __unused)
>  {
>  =09report("und", check_und());
>  =09report("svc", check_svc());
> -=09if (is_user()) {
> +=09if (!is_user()) {
> +=09=09check_pabt();
> +=09} else {
>  #ifdef __arm__
>  =09=09install_exception_handler(EXCPTN_UND, user_psci_system_off);
>  #else
> --=20
> 2.20.1
>

Did you also test with QEMU? Because this new test dies on an unhandled
unknown exception for me. Both with KVM and with TCG, and both arm64 and
arm32 (KVM:aarch32 or TCG:arm).

Thanks,
drew

