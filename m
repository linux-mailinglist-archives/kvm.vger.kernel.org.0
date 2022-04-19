Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C36506745
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 10:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350139AbiDSI6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 04:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345386AbiDSI6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 04:58:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF6BD2612D
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 01:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650358527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sAp+F+npHVI/LvkJesk2bVKFg1Wa6g6pN0S+Js80XoI=;
        b=JWwDhKg6DW3i97/gkuQixLpnMfOY6qRBDcUn2tPOjgj0OVNmkv7+PdXgQwjg1dR5rfVhUD
        Y/0G75MdqgDUi7LhTo8h+PHoEUZA9pmBPOusfR3WO0KJpoLxebKsleV4AzHD3y+JNYnxUX
        GmgfPsJ0clN4QbV2cSmKBgozWL1/JNk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-cvwRzkmxM9Szm0_kiSLc0w-1; Tue, 19 Apr 2022 04:55:24 -0400
X-MC-Unique: cvwRzkmxM9Szm0_kiSLc0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C56EF3811F2D;
        Tue, 19 Apr 2022 08:55:23 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 465364087D60;
        Tue, 19 Apr 2022 08:55:19 +0000 (UTC)
Message-ID: <204c7265de2d69ed240d18e30c7595702277cdbb.camel@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: Don't re-acquire SRCU lock in
 complete_emulated_io()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 19 Apr 2022 11:55:18 +0300
In-Reply-To: <20220415004343.2203171-2-seanjc@google.com>
References: <20220415004343.2203171-1-seanjc@google.com>
         <20220415004343.2203171-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-15 at 00:43 +0000, Sean Christopherson wrote:
> Don't re-acquire SRCU in complete_emulated_io() now that KVM acquires the
> lock in kvm_arch_vcpu_ioctl_run().  More importantly, don't overwrite
> vcpu->srcu_idx.  If the index acquired by complete_emulated_io() differs
> from the one acquired by kvm_arch_vcpu_ioctl_run(), KVM will effectively
> leak a lock and hang if/when synchronize_srcu() is invoked for the
> relevant grace period.
> 
> Fixes: 8d25b7beca7e ("KVM: x86: pull kvm->srcu read-side to kvm_arch_vcpu_ioctl_run")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab336f7c82e4..f35fe09de59d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10450,12 +10450,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  
>  static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
>  {
> -	int r;
> -
> -	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> -	r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
> -	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> -	return r;
> +	return kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
>  }
>  
>  static int complete_emulated_pio(struct kvm_vcpu *vcpu)

I wonder how this did work....

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

