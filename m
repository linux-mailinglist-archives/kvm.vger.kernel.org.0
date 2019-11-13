Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBB7FB463
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKMPz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:55:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55190 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726074AbfKMPz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 10:55:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573660556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mlGkyHaMp7bMHeXoyPDgBJEztNxGeiS89bc92OgwQ08=;
        b=S5sIIat7xjtpBvdBWdeOQ0Xh60rqC+B+u/ckLQT8Nk0XUsHwU/KK2ji1t6XuWbNy02v0jT
        mvBnCLEtbxce6SxFgokmHYV3WHcRKrrMunoCiB6ah2vU/2mzPiaVRFcKPQ6srTtycGn+Yr
        cbihl9Rj2V+QP9CfyGCdNoQvRe52j7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-PPemGn2jMVSNIn0TflawJw-1; Wed, 13 Nov 2019 10:55:55 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 196BC107ACC5
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 15:55:54 +0000 (UTC)
Received: from localhost.localdomain (ovpn-122-119.rdu2.redhat.com [10.10.122.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD8366293B;
        Wed, 13 Nov 2019 15:55:53 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] svm: run tests with host IF=1
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <1573660209-26331-1-git-send-email-pbonzini@redhat.com>
From:   Cathy Avery <cavery@redhat.com>
Message-ID: <afcc073a-15cc-7ac5-4b26-48667e546cf4@redhat.com>
Date:   Wed, 13 Nov 2019 10:55:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1573660209-26331-1-git-send-email-pbonzini@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: PPemGn2jMVSNIn0TflawJw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/13/19 10:50 AM, Paolo Bonzini wrote:
> Tests should in general call VMRUN with EFLAGS.IF=3D1 (if there are
> exceptions in the future we can add a cmp/jz in test_run).  This is
> because currently interrupts are masked during all of VMRUN, while
> we usually want interrupts during a test to cause a vmexit.
> This is similar to how PIN_EXTINT and PIN_NMI are included by
> default in the VMCS used by vmx.flat.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   x86/svm.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/x86/svm.c b/x86/svm.c
> index 4ddfaa4..097a296 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -254,6 +254,7 @@ static void test_run(struct test *test, struct vmcb *=
vmcb)
>       u64 vmcb_phys =3D virt_to_phys(vmcb);
>       u64 guest_stack[10000];
>  =20
> +    irq_disable();
>       test->vmcb =3D vmcb;
>       test->prepare(test);
>       vmcb->save.rip =3D (ulong)test_thunk;
> @@ -269,7 +270,9 @@ static void test_run(struct test *test, struct vmcb *=
vmcb)
>               "mov regs, %%r15\n\t"       // rax
>               "mov %%r15, 0x1f8(%0)\n\t"
>               LOAD_GPR_C
> +            "sti \n\t"=09=09// only used if V_INTR_MASKING=3D1

I thought sti was going to be conditional

// entered with IF=3D0
 =A0=A0=A0 clgi
 =A0=A0=A0 cmp=A0=A0=A0 $0, test_host_if
 =A0=A0=A0 jz=A0=A0=A0 1f
 =A0=A0=A0 sti

>               "vmrun \n\t"
> +            "cli \n\t"
>               SAVE_GPR_C
>               "mov 0x170(%0), %%r15\n\t"  // rflags
>               "mov %%r15, regs+0x80\n\t"
> @@ -284,6 +287,7 @@ static void test_run(struct test *test, struct vmcb *=
vmcb)
>   =09tsc_end =3D rdtsc();
>           ++test->exits;
>       } while (!test->finished(test));
> +    irq_enable();
>  =20
>       report("%s", test->succeeded(test), test->name);
>   }
> @@ -301,7 +305,6 @@ static bool default_supported(void)
>   static void default_prepare(struct test *test)
>   {
>       vmcb_ident(test->vmcb);
> -    cli();
>   }
>  =20
>   static bool default_finished(struct test *test)


