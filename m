Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE93718043B
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 18:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgCJRCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 13:02:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41293 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726633AbgCJRCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 13:02:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583859725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UkWPqE2JkjD0+rSe1RwEqI2R5lR5OgljToSA2P+0lDk=;
        b=XGPLqVgd8zgCiYS8WSuo+eh+/+Pmoe2JlJF063d4lj+xKqLc9ew+WdlhNh3I5NlgFZHmdp
        8SAJ0CTUShJgfDtz35zYVXX9GJQjLeRUtl4VmE+HCmacg/e5oenNM31z7V/W8NqoToQPzl
        RCEWdDCkxufyiGzcaqlQggQg085FMxo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-9hJWdklTNdCll66Ph94jlQ-1; Tue, 10 Mar 2020 13:02:03 -0400
X-MC-Unique: 9hJWdklTNdCll66Ph94jlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B660A1005512
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 17:02:02 +0000 (UTC)
Received: from fuller.cnet (ovpn-116-43.gru2.redhat.com [10.97.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E11239051C;
        Tue, 10 Mar 2020 17:01:59 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 08EB4418CC02; Tue, 10 Mar 2020 11:03:24 -0300 (-03)
Date:   Tue, 10 Mar 2020 11:03:23 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        nilal@redhat.com
Subject: Re: [Patch v1] x86: Fix the logical destination mode test
Message-ID: <20200310140323.GA7132@fuller.cnet>
References: <1583795750-33197-1-git-send-email-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1583795750-33197-1-git-send-email-nitesh@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 07:15:50PM -0400, Nitesh Narayan Lal wrote:
> There are following issues with the ioapic logical destination mode tes=
t:
>=20
> - A race condition that is triggered when the interrupt handler
> =C2=A0 ioapic_isr_86() is called at the same time by multiple vCPUs. Du=
e to this
>   the g_isr_86 is not correctly incremented. To prevent this a spinlock=
 is
>   added around =E2=80=98g_isr_86++=E2=80=99.
>=20
> - On older QEMU versions initial x2APIC ID is not set, that is why
> =C2=A0 the local APIC IDs of each vCPUs are not configured. Hence the l=
ogical
> =C2=A0 destination mode test fails/hangs. Adding =E2=80=98+x2apic=E2=80=
=99 to the qemu -cpu params
> =C2=A0 ensures that the local APICs are configured every time, irrespec=
tive of the
> =C2=A0 QEMU version.
>=20
> - With =E2=80=98-machine kernel_irqchip=3Dsplit=E2=80=99 included in th=
e ioapic test
> =C2=A0 test_ioapic_self_reconfigure() always fails and somehow leads to=
 a state where
> =C2=A0 after submitting IOAPIC fixed delivery - logical destination mod=
e request we
> =C2=A0 never receive an interrupt back. For now, the physical and logic=
al destination
> =C2=A0 mode tests are moved above test_ioapic_self_reconfigure().
>=20
> Fixes: b2a1ee7e ("kvm-unit-test: x86: ioapic: Test physical and logical=
 destination mode")
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>

Looks good to me.

> ---
>  x86/ioapic.c      | 11 +++++++----
>  x86/unittests.cfg |  2 +-
>  2 files changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index 742c711..3106531 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -432,10 +432,13 @@ static void test_ioapic_physical_destination_mode=
(void)
>  }
> =20
>  static volatile int g_isr_86;
> +struct spinlock ioapic_lock;
> =20
>  static void ioapic_isr_86(isr_regs_t *regs)
>  {
> +	spin_lock(&ioapic_lock);
>  	++g_isr_86;
> +	spin_unlock(&ioapic_lock);
>  	set_irq_line(0x0e, 0);
>  	eoi();
>  }
> @@ -501,6 +504,10 @@ int main(void)
>  	test_ioapic_level_tmr(true);
>  	test_ioapic_edge_tmr(true);
> =20
> +	test_ioapic_physical_destination_mode();
> +	if (cpu_count() > 3)
> +		test_ioapic_logical_destination_mode();
> +
>  	if (cpu_count() > 1) {
>  		test_ioapic_edge_tmr_smp(false);
>  		test_ioapic_level_tmr_smp(false);
> @@ -508,11 +515,7 @@ int main(void)
>  		test_ioapic_edge_tmr_smp(true);
> =20
>  		test_ioapic_self_reconfigure();
> -		test_ioapic_physical_destination_mode();
>  	}
> =20
> -	if (cpu_count() > 3)
> -		test_ioapic_logical_destination_mode();
> -
>  	return report_summary();
>  }
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index f2401eb..d658bc8 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -46,7 +46,7 @@ timeout =3D 30
>  [ioapic]
>  file =3D ioapic.flat
>  smp =3D 4
> -extra_params =3D -cpu qemu64
> +extra_params =3D -cpu qemu64,+x2apic
>  arch =3D x86_64
> =20
>  [cmpxchg8b]
> --=20
> 1.8.3.1

