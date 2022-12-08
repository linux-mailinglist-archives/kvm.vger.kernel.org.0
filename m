Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1542164788E
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiLHWEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiLHWEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:04:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FE65F87
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 14:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T2TBX0pwDoKA7pjPWivzCMhRaquWJ9TqaggawR0ILGI=;
        b=FIjoFS/a/XiuIZko7zmJdc1P3/4EEw3QIZckzDfWvfTCCyQXAyU3xLv6/sMMZ0hnhP5Zxe
        HsHD4IiNQ5HRHlmUFu7aSCybeg79GcrXomQJukoIad5l+zccexLDPqwQa2pwThKSAWVIyk
        OLam5zWWT6qyL+mKmh+af9yYrtO74Nw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-NrvIW46DO72CjLvC3vh1ag-1; Thu, 08 Dec 2022 17:02:31 -0500
X-MC-Unique: NrvIW46DO72CjLvC3vh1ag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBDD7858F17;
        Thu,  8 Dec 2022 22:02:30 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 592D11121339;
        Thu,  8 Dec 2022 22:02:29 +0000 (UTC)
Message-ID: <b431b6650bd939ae51f6c792da581dce04b1940d.camel@redhat.com>
Subject: Re: [PATCH v4 03/32] KVM: SVM: Flush the "current" TLB when
 activating AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Fri, 09 Dec 2022 00:02:28 +0200
In-Reply-To: <b9f336f17eec6bfbb8429700e0f135d19813c576.camel@redhat.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-4-seanjc@google.com>
         <b9f336f17eec6bfbb8429700e0f135d19813c576.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-12-07 at 18:02 +0200, Maxim Levitsky wrote:
On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> Flush the TLB when activating AVIC as the CPU can insert into the TLB
> while AVIC is "locally" disabled.  KVM doesn't treat "APIC hardware
> disabled" as VM-wide AVIC inhibition, and so when a vCPU has its APIC
> hardware disabled, AVIC is not guaranteed to be inhibited.  As a result,
> KVM may create a valid NPT mapping for the APIC base, which the CPU can
> cache as a non-AVIC translation.
> 
> Note, Intel handles this in vmx_set_virtual_apic_mode().
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6919dee69f18..712330b80891 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -86,6 +86,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>                 /* Disabling MSR intercept for x2APIC registers */
>                 svm_set_x2apic_msr_interception(svm, false);
>         } else {
> +               /*
> +                * Flush the TLB, the guest may have inserted a non-APIC
> +                * mapping into the TLB while AVIC was disabled.
> +                */
> +               kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
> +
>                 /* For xAVIC and hybrid-xAVIC modes */
>                 vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>                 /* Enabling MSR intercept for x2APIC registers */

I agree, that if guest disables APIC on a vCPU, this will lead to call to kvm_apic_update_apicv which will
disable AVIC, but if other vCPUs don't disable it, the AVIC's private memslot will still be mapped and
guest could read/write it from this vCPU, and its TLB mapping needs to be invalidated if/when APIC is re-enabled.
 
However I think that this adds an unnecessarily (at least in the future) performance penalty to AVIC nesting coexistence:
 
L1's AVIC is inhibited on each nested VM entry, and uninhibited on each nested VM exit, but while nested the guest
can't really access it as it has its own NPT.
 
With this patch KVM will invalidate L1's TLB on each nested VM exit. KVM sadly already does this but this can be fixed
(its another thing on my TODO list)
 
Note that APICv doesn't have this issue, it is not inhibited on nested VM entry/exit, thus this code is not performance
sensitive for APICv.
 
 
I somewhat vote again, as I said before to disable the APICv/AVIC memslot, if any of vCPUs have APICv/AVIC hardware disabled,
because it is also more correct from an x86 perspective. I do wonder how often is the usage of having "extra" cpus but not using them, and thus having their APIC in disabled state.
KVM does support adding new vCPUs on the fly, so this shouldn't be needed, and APICv inhibit in this case is just a perf regression.

Or at least do this only when APIC does back from hardware disabled state to enabled.

Best regards,
	Maxim Levitsky


