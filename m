Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A97338E64
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 14:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhCLNLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 08:11:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231876AbhCLNK5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 08:10:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615554656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VgFe6uQnJ8rIXGvsrG64YsiX4BNnQyyouHFc/LeT/o4=;
        b=Vc70yUI5k6Hrdx1kl+by999hCh2c3q1tHFfrsH4i5Y+yEKbObMXI1wCMig4ndT56EYtOxP
        ywE4s35jDhv5q9xkfiQMbluvfsQINNxCkIdKpmFORdtNpiF3oFxLthNx7+S7G4RyZd9H19
        mBCmmwgrDFfNnzgMq/FXcCGSN5L38CU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-4fvacKXPMDastM-rowugJQ-1; Fri, 12 Mar 2021 08:10:52 -0500
X-MC-Unique: 4fvacKXPMDastM-rowugJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A53B800D55;
        Fri, 12 Mar 2021 13:10:51 +0000 (UTC)
Received: from [10.36.114.197] (ovpn-114-197.ams2.redhat.com [10.36.114.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01E565D9F2;
        Fri, 12 Mar 2021 13:10:49 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: mvpg: add checks for
 op_acc_id
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
        pmorel@linux.ibm.com
References: <20210312124700.142269-1-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <1bfa888e-bddf-e563-06e5-417eb9d43b89@redhat.com>
Date:   Fri, 12 Mar 2021 14:10:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210312124700.142269-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.03.21 13:47, Claudio Imbrenda wrote:
> Check the operand access identification when MVPG causes a page fault.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/mvpg.c | 28 ++++++++++++++++++++++++++--
>   1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/mvpg.c b/s390x/mvpg.c
> index 5743d5b6..2b7c6cc9 100644
> --- a/s390x/mvpg.c
> +++ b/s390x/mvpg.c
> @@ -36,6 +36,7 @@
>   
>   static uint8_t source[PAGE_SIZE]  __attribute__((aligned(PAGE_SIZE)));
>   static uint8_t buffer[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +static struct lowcore * const lc;
>   
>   /* Keep track of fresh memory */
>   static uint8_t *fresh;
> @@ -77,6 +78,21 @@ static int page_ok(const uint8_t *p)
>   	return 1;
>   }
>   
> +/*
> + * Check that the Operand Access Identification matches with the values of
> + * the r1 and r2 fields in the instruction format. The r1 and r2 fields are
> + * in the last byte of the instruction, and the Program Old PSW will point
> + * to the beginning of the instruction after the one that caused the fault
> + * (the fixup code in the interrupt handler takes care of that for
> + * nullifying instructions). Therefore it is enough to compare the byte
> + * before the one contained in the Program Old PSW with the value of the
> + * Operand Access Identification.
> + */
> +static inline bool check_oai(void)
> +{
> +	return *(uint8_t *)(lc->pgm_old_psw.addr - 1) == lc->op_acc_id;
> +}
> +
>   static void test_exceptions(void)
>   {
>   	int i, expected;
> @@ -201,17 +217,25 @@ static void test_mmu_prot(void)
>   	report(clear_pgm_int() == PGM_INT_CODE_PROTECTION, "destination read only");
>   	fresh += PAGE_SIZE;
>   
> +	report_prefix_push("source invalid");
>   	protect_page(source, PAGE_ENTRY_I);
> +	lc->op_acc_id = 0;
>   	expect_pgm_int();
>   	mvpg(0, fresh, source);
> -	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "source invalid");
> +	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "exception");
>   	unprotect_page(source, PAGE_ENTRY_I);
> +	report(check_oai(), "operand access ident");
> +	report_prefix_pop();
>   	fresh += PAGE_SIZE;
>   
> +	report_prefix_push("destination invalid");
>   	protect_page(fresh, PAGE_ENTRY_I);
> +	lc->op_acc_id = 0;
>   	expect_pgm_int();
>   	mvpg(0, fresh, source);
> -	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "destination invalid");
> +	report(clear_pgm_int() == PGM_INT_CODE_PAGE_TRANSLATION, "exception");
> +	report(check_oai(), "operand access ident");
> +	report_prefix_pop();
>   	fresh += PAGE_SIZE;
>   
>   	report_prefix_pop();
> 

Thanks - works with my TCG implementation as well just fine.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

