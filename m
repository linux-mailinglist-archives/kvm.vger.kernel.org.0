Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F314F142F
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbiDDMCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 08:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiDDMCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 08:02:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06EAC2B256
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649073607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=54htBfVJnmMSt6wVfB6Zir8BswtOU/CLvIkm4Md47rQ=;
        b=YLSMuoDgfv5AGHEvK4xRYGWL2nwLZDo6slVGmL2KKD1nxljVVab0RrCRGlsWUzVik5PBbw
        mzF2G7sGOFU2LgaSfmsFRL86BH+mFIw4RaIULmFU1GAHlPsTHSUYJskZwLz39M1OSivx54
        O8JqricIqDaZHvQ1eF8oa2LWTZ/YKIQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-SNUcJtbWP2uT5o6NswnBRQ-1; Mon, 04 Apr 2022 08:00:05 -0400
X-MC-Unique: SNUcJtbWP2uT5o6NswnBRQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E20783395E;
        Mon,  4 Apr 2022 12:00:05 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02CF8464DFC;
        Mon,  4 Apr 2022 12:00:02 +0000 (UTC)
Message-ID: <5752e461f5912d4312eb63f1b7f521f54ab40f79.camel@redhat.com>
Subject: Re: [PATCH 4/8] KVM: SVM: Stuff next_rip on emualted INT3 injection
 if NRIPS is supported
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Mon, 04 Apr 2022 15:00:01 +0300
In-Reply-To: <20220402010903.727604-5-seanjc@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
         <20220402010903.727604-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-02 at 01:08 +0000, Sean Christopherson wrote:
> If NRIPS is supported in hardware but disabled in KVM, set next_rip to
> the next RIP when advancing RIP as part of emulating INT3 injection.
> There is no flag to tell the CPU that KVM isn't using next_rip, and so
> leaving next_rip is left as is will result in the CPU pushing garbage
> onto the stack when vectoring the injected event.
> 
> Fixes: 66b7138f9136 ("KVM: SVM: Emulate nRIP feature when reinjecting INT3")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 30cef3b10838..6ea8f16e39ac 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -391,6 +391,10 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
>  		 */
>  		(void)svm_skip_emulated_instruction(vcpu);
>  		rip = kvm_rip_read(vcpu);
> +
> +		if (boot_cpu_has(X86_FEATURE_NRIPS))
> +			svm->vmcb->control.next_rip = rip;
> +
>  		svm->int3_rip = rip + svm->vmcb->save.cs.base;
>  		svm->int3_injected = rip - old_rip;
>  	}

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

