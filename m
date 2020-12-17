Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100B42DCE8B
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 10:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgLQJjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 04:39:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726908AbgLQJjV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 04:39:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608197875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mikdXqxOQUmFSJUILlBGsIFt6CBxIrSXNkMzSbIKjmM=;
        b=G87VQGv4ub72r8V48J3lyvGkNDWy6OVjBYCsnP3PYaozowskxwcAv1Carq+FKozUslZzbV
        jHTfIMTfYsvIAu9QulI9eoxD06nyUbcXKTRoj2JOff0DIsWFDZzZFKfzkaqf7BduOPp8gT
        m60Pws6toKfuoZ648KpiosyvNFr4t9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-gF_XJdaQPcWhCliuAQ9Plw-1; Thu, 17 Dec 2020 04:37:51 -0500
X-MC-Unique: gF_XJdaQPcWhCliuAQ9Plw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D742D801817;
        Thu, 17 Dec 2020 09:37:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-175.ams2.redhat.com [10.36.112.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD4591992D;
        Thu, 17 Dec 2020 09:37:44 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 5/8] s390x: sie: Add SIE to lib
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-6-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <0bb4934a-23b6-bf4f-2742-3892c17c81d0@redhat.com>
Date:   Thu, 17 Dec 2020 10:37:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201211100039.63597-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/2020 11.00, Janosch Frank wrote:
> This commit adds the definition of the SIE control block struct and
> the assembly to execute SIE and save/restore guest registers.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm-offsets.c  |  13 +++
>  lib/s390x/asm/arch_def.h |   7 ++
>  lib/s390x/interrupt.c    |   7 ++
>  lib/s390x/sie.h          | 197 +++++++++++++++++++++++++++++++++++++++
>  s390x/asm/lib.S          |  56 +++++++++++
>  5 files changed, 280 insertions(+)
>  create mode 100644 lib/s390x/sie.h
> 
> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
> index ee94ed3..35697de 100644
> --- a/lib/s390x/asm-offsets.c
> +++ b/lib/s390x/asm-offsets.c
> @@ -8,6 +8,7 @@
>  #include <libcflat.h>
>  #include <kbuild.h>
>  #include <asm/arch_def.h>
> +#include <sie.h>
>  
>  int main(void)
>  {
> @@ -69,6 +70,18 @@ int main(void)
>  	OFFSET(GEN_LC_ARS_SA, lowcore, ars_sa);
>  	OFFSET(GEN_LC_CRS_SA, lowcore, crs_sa);
>  	OFFSET(GEN_LC_PGM_INT_TDB, lowcore, pgm_int_tdb);
> +	OFFSET(__SF_GPRS, stack_frame, gprs);
> +	OFFSET(__SF_SIE_CONTROL, stack_frame, empty1[0]);
> +	OFFSET(__SF_SIE_SAVEAREA, stack_frame, empty1[1]);
> +	OFFSET(__SF_SIE_REASON, stack_frame, empty1[2]);
> +	OFFSET(__SF_SIE_FLAGS, stack_frame, empty1[3]);
> +	OFFSET(SIE_SAVEAREA_HOST_GRS, vm_save_area, host.grs[0]);
> +	OFFSET(SIE_SAVEAREA_HOST_FPRS, vm_save_area, host.fprs[0]);
> +	OFFSET(SIE_SAVEAREA_HOST_FPC, vm_save_area, host.fpc);
> +	OFFSET(SIE_SAVEAREA_GUEST_GRS, vm_save_area, guest.grs[0]);
> +	OFFSET(SIE_SAVEAREA_GUEST_FPRS, vm_save_area, guest.fprs[0]);
> +	OFFSET(SIE_SAVEAREA_GUEST_FPC, vm_save_area, guest.fpc);
> +
>  
>  	return 0;
>  }
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index f3ab830..5a13cf2 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -8,6 +8,13 @@
>  #ifndef _ASM_S390X_ARCH_DEF_H_
>  #define _ASM_S390X_ARCH_DEF_H_
>  
> +struct stack_frame {
> +	unsigned long back_chain;
> +	unsigned long empty1[5];
> +	unsigned long gprs[10];
> +	unsigned int  empty2[8];

I think you can drop empty2 ?

> +};
> +
>  struct psw {
>  	uint64_t	mask;
>  	uint64_t	addr;
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index bac8862..3858096 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -11,6 +11,7 @@
>  #include <asm/barrier.h>
>  #include <sclp.h>
>  #include <interrupt.h>
> +#include <sie.h>
>  
>  static bool pgm_int_expected;
>  static bool ext_int_expected;
> @@ -57,6 +58,12 @@ void register_pgm_cleanup_func(void (*f)(void))
>  
>  static void fixup_pgm_int(void)
>  {
> +	/* If we have an error on SIE we directly move to sie_exit */
> +	if (lc->pgm_old_psw.addr >= (uint64_t)&sie_entry &&
> +	    lc->pgm_old_psw.addr <= (uint64_t)&sie_entry + 10) {

Can you please explain that "magic" number 10 in the comment?

> +		lc->pgm_old_psw.addr = (uint64_t)&sie_exit;
> +	}
> +
>  	switch (lc->pgm_int_code) {
>  	case PGM_INT_CODE_PRIVILEGED_OPERATION:
>  		/* Normal operation is in supervisor state, so this exception
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> new file mode 100644
> index 0000000..b00bdf4
> --- /dev/null
> +++ b/lib/s390x/sie.h
[...]
> +extern u64 sie_entry;
> +extern u64 sie_exit;

Maybe better:

extern uint16_t sie_entry[];
extern uint16_t sie_exit[];

?

Or even:

extern void sie_entry();
extern void sie_exit();

?

 Thomas

