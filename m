Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B222FB4B6
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 17:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfKMQNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 11:13:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23802 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728279AbfKMQND (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 11:13:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573661582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XU9+yeAwEgbZM2IaGlIP2ouV67U6mvFBM/dGWtm5ylI=;
        b=NGpHiM6m18AiZ1g5GgwruqV8yQ98gaYh8x4zPhqag5HHTakTI1qygibdg0F13oXbsHh1lB
        PDRQkTH+EUHC1QEtcFX2Anj+iH7BK0yOTDYp3tt3YCr/px9FYfEyxHLLE+Sg1LsiR3s3ai
        DOFXcvj6lyw+Rs7FbhexZtHkioutL1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-TqjfXIt2M0-aXclUMXV1oQ-1; Wed, 13 Nov 2019 11:13:01 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 214B98C7926
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:13:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-122-119.rdu2.redhat.com [10.10.122.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C339F10027B9;
        Wed, 13 Nov 2019 16:12:59 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] svm: run tests with host IF=1
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <1573660209-26331-1-git-send-email-pbonzini@redhat.com>
From:   Cathy Avery <cavery@redhat.com>
Message-ID: <a3fd6e28-1ea8-8d97-400b-83a2118bf9c5@redhat.com>
Date:   Wed, 13 Nov 2019 11:12:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1573660209-26331-1-git-send-email-pbonzini@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: TqjfXIt2M0-aXclUMXV1oQ-1
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

Reviewed-by: Cathy Avery <cavery@redhat.com>

