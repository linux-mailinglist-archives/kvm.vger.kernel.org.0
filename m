Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0230FDB2C
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfKOKU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:20:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30572 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727142AbfKOKU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:20:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573813256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=JT7sqCUywyi+CFPtAoWyKDslv5MO2OXADvzZn1alSwE=;
        b=dy0BUbkDnAQMKOiF8faUQziKcyU426/LDoN5DPr/wmTm9/I7ldhCjOzBu7H3bKzo3X7Yt5
        ZV2BZkce9WVqO0uCW9Aa0YcMayGXRF6lvPWXBJJ3PuQG3yVzI/GjeTm9oIirXVb/1r16vA
        odZFYYlAMXLhGwTt9U0a590gJg2g0M0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-vmEPQQwwOyGydWdGewYvwg-1; Fri, 15 Nov 2019 05:20:52 -0500
Received: by mail-wm1-f69.google.com with SMTP id b10so5763694wmh.6
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 02:20:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f+7Ythom2m3mqPXEPftTtD9RmEE0HRhksOyWfKtpVHA=;
        b=B3tfFoFwL+QKtBMIPUOCkyo/og5aPhmN3EkwXZvmDRvHHx3XEt6DnQpGeiV6Fci5NT
         CGIHp14O+4EWM80102vuzHlDEtU0W9feSfJPvvRRVfLrQLPYVNLsQVXms0Z8oTQpyP4l
         r5kb1XuhGaudq0JdQ41UIH9KicZialxrXmokFAJ4pyDuuMTtO/r9c4UOvpLTYyYTcODV
         d1Ws6+Vtxgla/qSPSTWv7ZN1PGFQ2tVYUqGrymTPA58eV+18XzUz2dmv1+/HH/XAZCvu
         sx1LRRnVdRqqxgzdmhFziskAWEarjx9bfQGfCnB25cxiArZXIM8Wu+YD3mY809d+45my
         XdDA==
X-Gm-Message-State: APjAAAW+Hxa07QBjHE5hBClPMbO/7BQAdrMrmxlx2hOMzRwAWsDVCKGZ
        UhlL2ph7MAqajlH/O7P6yE7Ob53hu8qgLB+LNuvRmLnqhUwpj2/sZGXYcGbP4dBsu92zC9rYlLC
        0EKOlClFQXPEV
X-Received: by 2002:adf:f60a:: with SMTP id t10mr14079618wrp.29.1573813251427;
        Fri, 15 Nov 2019 02:20:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqynOD4HsLDb9tcagX87DYYDaZMZnog2opcE2vf1tCr69OX5KuRjN7yJa/ykArnSGxd6Yd2xPQ==
X-Received: by 2002:adf:f60a:: with SMTP id t10mr14079577wrp.29.1573813251112;
        Fri, 15 Nov 2019 02:20:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id w19sm9228308wmk.36.2019.11.15.02.20.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 02:20:50 -0800 (PST)
Subject: Re: [PATCH] x86: vmx: Verify pending LAPIC INIT event consume when
 exit on VMX_INIT
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Nadav Amit <nadav.amit@gmail.com>,
        Mihai Carabas <mihai.carabas@oracle.com>
References: <20191111124023.93449-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <00b2d142-1d96-efb8-5907-5674f0f80f73@redhat.com>
Date:   Fri, 15 Nov 2019 11:20:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111124023.93449-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: vmEPQQwwOyGydWdGewYvwg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 13:40, Liran Alon wrote:
> Intel SDM section 25.2 OTHER CAUSES OF VM EXITS specifies the following
> on INIT signals: "Such exits do not modify register state or clear pendin=
g
> events as they would outside of VMX operation."
>=20
> When commit 48adfb0f2e8e ("x86: vmx: Test INIT processing during various =
CPU VMX states")
> was applied, I interepted above Intel SDM statement such that
> VMX_INIT exit don=E2=80=99t consume the pending LAPIC INIT event.
>=20
> However, when Nadav Amit run the unit-test on a bare-metal
> machine, it turned out my interpetation was wrong. i.e. VMX_INIT
> exit does consume the pending LAPIC INIT event.
> (See: https://www.spinics.net/lists/kvm/msg196757.html)
>=20
> Therefore, fix unit-test code to behave as observed on bare-metal.
> i.e. End unit-test with the following steps:
> 1) Exit VMX operation and verify it still continues to run properly
> as pending LAPIC INIT event should have been already consumed by
> VMX_INIT exit.
> 2) Re-enter VMX operation and send another INIT signal to keep it
> blocked until exit from VMX operation.
> 3) Exit VMX operation and verify that pending LAPIC INIT signal
> is processed when exiting VMX operation.
>=20
> Fixes: 48adfb0f2e8e ("x86: vmx: Test INIT processing during various CPU V=
MX states")
> Reported-by: Nadav Amit <nadav.amit@gmail.com>
> Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  x86/vmx_tests.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 43 insertions(+), 2 deletions(-)
>=20
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index b137fc5456b8..a63dc2fafb49 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8427,13 +8427,34 @@ static void init_signal_test_thread(void *data)
>  =09/* Signal that CPU exited to VMX root mode */
>  =09vmx_set_test_stage(5);
> =20
> -=09/* Wait for signal to exit VMX operation */
> +=09/* Wait for BSP CPU to signal to exit VMX operation */
>  =09while (vmx_get_test_stage() !=3D 6)
>  =09=09;
> =20
>  =09/* Exit VMX operation (i.e. exec VMXOFF) */
>  =09vmx_off();
> =20
> +=09/*
> +=09 * Signal to BSP CPU that we continue as usual as INIT signal
> +=09 * should have been consumed by VMX_INIT exit from guest
> +=09 */
> +=09vmx_set_test_stage(7);
> +
> +=09/* Wait for BSP CPU to signal to enter VMX operation */
> +=09while (vmx_get_test_stage() !=3D 8)
> +=09=09;
> +=09/* Enter VMX operation (i.e. exec VMXON) */
> +=09_vmx_on(ap_vmxon_region);
> +=09/* Signal to BSP we are in VMX operation */
> +=09vmx_set_test_stage(9);
> +
> +=09/* Wait for BSP CPU to send INIT signal */
> +=09while (vmx_get_test_stage() !=3D 10)
> +=09=09;
> +
> +=09/* Exit VMX operation (i.e. exec VMXOFF) */
> +=09vmx_off();
> +
>  =09/*
>  =09 * Exiting VMX operation should result in latched
>  =09 * INIT signal being processed. Therefore, we should
> @@ -8511,9 +8532,29 @@ static void vmx_init_signal_test(void)
>  =09init_signal_test_thread_continued =3D false;
>  =09vmx_set_test_stage(6);
> =20
> +=09/* Wait reasonable amount of time for other CPU to exit VMX operation=
 */
> +=09delay(INIT_SIGNAL_TEST_DELAY);
> +=09report("INIT signal consumed on VMX_INIT exit",
> +=09=09   vmx_get_test_stage() =3D=3D 7);
> +=09/* No point to continue if we failed at this point */
> +=09if (vmx_get_test_stage() !=3D 7)
> +=09=09return;
> +
> +=09/* Signal other CPU to enter VMX operation */
> +=09vmx_set_test_stage(8);
> +=09/* Wait for other CPU to enter VMX operation */
> +=09while (vmx_get_test_stage() !=3D 9)
> +=09=09;
> +
> +=09/* Send INIT signal to other CPU */
> +=09apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT,
> +=09=09=09=09   id_map[1]);
> +=09/* Signal other CPU we have sent INIT signal */
> +=09vmx_set_test_stage(10);
> +
>  =09/*
>  =09 * Wait reasonable amount of time for other CPU
> -=09 * to run after INIT signal was processed
> +=09 * to exit VMX operation and process INIT signal
>  =09 */
>  =09delay(INIT_SIGNAL_TEST_DELAY);
>  =09report("INIT signal processed after exit VMX operation",
>=20

Queued, thanks.

