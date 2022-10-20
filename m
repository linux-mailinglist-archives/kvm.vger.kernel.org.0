Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD2860646A
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiJTP0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiJTP0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:26:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BBC1AA27C
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ufks/tNcb9SOyDmv9oYgoUwOJgMNKxxwfpPfplrSfKg=;
        b=O9UXL0mN9xnc1dLwLijMra54+0cAEbHs3XMHdJ8tnFGpTKVG7D1+UdXGG7dmlaGvIPJZGo
        W8D/JYh1fYcEMwiC/DfFMgbjscnpAmZXEYwdskicq3W+kHWSNFq0Yo7z60UYIHGvudRiIf
        WrxRkrFaWohrL9KW3JWSa4fiK9AWv/8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-zBhq3g3QN9K-sXj9IRW4Cw-1; Thu, 20 Oct 2022 11:26:20 -0400
X-MC-Unique: zBhq3g3QN9K-sXj9IRW4Cw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69835811E75
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:26:20 +0000 (UTC)
Received: from starship (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60D4449BB60;
        Thu, 20 Oct 2022 15:26:19 +0000 (UTC)
Message-ID: <4f991c306dca5764c5822fca43f8092001817790.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 08/16] svm: add nested shutdown test.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 20 Oct 2022 18:26:18 +0300
In-Reply-To: <20221020152404.283980-9-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-9-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 18:23 +0300, Maxim Levitsky wrote:
> Test that if L2 triggers a shutdown, this VM exits to L1
> and doesn't crash the host.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  x86/svm_tests.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 19b35e95..2c29c2b0 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -10,6 +10,7 @@
>  #include "isr.h"
>  #include "apic.h"
>  #include "delay.h"
> +#include "vmalloc.h"
>  
>  #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
>  
> @@ -3270,6 +3271,55 @@ static void svm_intr_intercept_mix_smi(void)
>  	svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
>  }
>  
> +
> +static void shutdown_intercept_test_guest(struct svm_test *test)
> +{
> +	asm volatile ("int3");
> +	report_fail("should not reach here\n");
> +
> +}
> +
> +static void shutdown_intercept_test_guest2(struct svm_test *test)
> +{
> +	asm volatile ("ud2");
> +	report_fail("should not reach here\n");
> +
> +}
> +
> +static void svm_shutdown_intercept_test(void)
> +{
> +	void* unmapped_address = alloc_vpage();
> +
> +	/*
> +	 * Test that shutdown vm exit doesn't crash L0
> +	 *
> +	 * Test both native and emulated triple fault
> +	 * (due to exception merging)
> +	 */
> +
> +
> +	/*
> +	 * This will usually cause native SVM_EXIT_SHUTDOWN
> +	 * (KVM usually doesn't intercept #PF)
> +	 * */
> +	test_set_guest(shutdown_intercept_test_guest);
> +	vmcb->save.idtr.base = (u64)unmapped_address;
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> +	svm_vmrun();
> +	report (vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown (BP->PF->DF->TRIPLE_FAULT) test passed");
> +
> +	/*
> +	 * This will usually cause emulated SVM_EXIT_SHUTDOWN
> +	 * (KVM usually intercepts #UD)
> +	 */
> +	test_set_guest(shutdown_intercept_test_guest2);
> +	vmcb_ident(vmcb);
> +	vmcb->save.idtr.limit = 0;
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> +	svm_vmrun();
> +	report (vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown (UD->DF->TRIPLE_FAULT) test passed");
> +}
> +
>  struct svm_test svm_tests[] = {
>  	{ "null", default_supported, default_prepare,
>  	  default_prepare_gif_clear, null_test,
> @@ -3382,6 +3432,7 @@ struct svm_test svm_tests[] = {
>  	TEST(svm_intr_intercept_mix_smi),
>  	TEST(svm_tsc_scale_test),
>  	TEST(pause_filter_test),
> +	TEST(svm_shutdown_intercept_test),
>  	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>  };
>  


Note that on unpatched KVM, this test will cause a kernel panic on the host if run.

I sent a patch today with a fix for this.

Best regards,
	MaxiM Levitsky

