Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D489C64784D
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiLHVyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiLHVyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:54:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC6082FB1
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZBcgK9VV/d10fUxDLy8U04mKJvxJMTTu6G7jiNs4zZo=;
        b=Owe3phhIA6pYAlPpV7HzkSqyjETRqpot9s0VCTeaNpsjRK+QnLcP6WMtpGfhYYY4mPvlBa
        wYctBu/VS2kbI5b9ZQ8+syGfxU5c5P2JsHdBUDaCeW7oqkgGPcfBP9wWFzsIZjp7/E/ANP
        rz+j/sY61DCvzu8VKfxcgurH9z7+qbo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-pQRAInqUNWqPC4SgPupWBA-1; Thu, 08 Dec 2022 16:53:28 -0500
X-MC-Unique: pQRAInqUNWqPC4SgPupWBA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44975802E5D;
        Thu,  8 Dec 2022 21:53:28 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0D9840C6EC2;
        Thu,  8 Dec 2022 21:53:26 +0000 (UTC)
Message-ID: <bdeab12758e988f90c1bb4ab1f1e09b3bedff7ac.camel@redhat.com>
Subject: Re: [PATCH v4 06/32] KVM: x86: Track xAPIC ID only on userspace
 SET, _after_ vAPIC is updated
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:53:25 +0200
In-Reply-To: <20221001005915.2041642-7-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> Track potential changes to a vCPU's xAPIC ID only for KVM_SET_LAPIC, i.e.
> not for KVM_GET_LAPIC, and process the update after the incoming state
> provided by userspace is copied to KVM's in-kernel vAPIC.  The latter bug
> is the most problematic issue, as processing the update before KVM's
> vAPIC is actually updated can result in false positives, e.g. due to the
> APIC holding an x2APIC ID (wrong format), and false negatives, e.g. due
> to KVM failing to detect an xAPIC ID "mismatch".
> 
> Processing an "update" in KVM_GET_LAPIC is likely a benign bug now that
> the update helper ignores mismatches, but prior to that fix, invoking
> KVM_GET_LAPIC while the APIC is disabled could effectively cause KVM to
> consume stale state, e.g. if the APIC were in x2APIC mode before being
> hardware disabled.
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 67260f7ce43a..251856ba0750 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2720,8 +2720,6 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>  			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
>  			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
>  		}
> -	} else {
> -		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
>  	}
>  
>  	return 0;
> @@ -2757,6 +2755,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	}
>  	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
>  
> +	if (!apic_x2apic_mode(vcpu->arch.apic))
> +		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
> +
>  	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>  	kvm_recalculate_apic_map(vcpu->kvm);
>  	kvm_apic_set_version(vcpu);


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



