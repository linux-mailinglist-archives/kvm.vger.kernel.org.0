Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5651D379002
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhEJN6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:58:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243932AbhEJN4F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:56:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620654899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vdbtOJRevwu3NxxTOXXeVn6DSiusgRXUjQnBlJvGV0Y=;
        b=B6+fRLLG4QwhlXpFsWMkjc28wY66DtaJpTnv81Ki7dXrFtU+iO9Ql6Ccf6qJLZfbIr5ewa
        BHqmxBC8uoHNhYtu41Yu6RGkBjycaeui4X6IWoBN90YfT83LJ1lZbuVilyyC53O8i3Gw4k
        cVfELR1pvSsODxtcM/sNMdTGGS6qWXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-iqapyitXOdCQSPwoNd7cNQ-1; Mon, 10 May 2021 09:54:57 -0400
X-MC-Unique: iqapyitXOdCQSPwoNd7cNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9A961009600;
        Mon, 10 May 2021 13:54:09 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED51B60BD8;
        Mon, 10 May 2021 13:54:04 +0000 (UTC)
Message-ID: <e2fcb43ba6ef92675fa0565065164909f5a4909e.camel@redhat.com>
Subject: Re: [PATCH 5/8] KVM: X86: Move tracing outside write_l1_tsc_offset()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     ilstam@mailbox.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Date:   Mon, 10 May 2021 16:54:03 +0300
In-Reply-To: <20210506103228.67864-6-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-6-ilstam@mailbox.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> From: Ilias Stamatis <ilstam@amazon.com>
> 
> A subsequent patch fixes write_l1_tsc_offset() to account for nested TSC
> scaling. Calculating the L1 TSC for logging it with the trace call
> becomes more complex then.
> 
> This patch moves the trace call to the caller and avoids code
> duplication as a result too.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/kvm/svm/svm.c | 4 ----
>  arch/x86/kvm/vmx/vmx.c | 3 ---
>  arch/x86/kvm/x86.c     | 4 ++++
>  3 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9790c73f2a32..d2f9d6a9716f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1090,10 +1090,6 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  		svm->vmcb01.ptr->control.tsc_offset = offset;
>  	}
>  
> -	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
> -				   svm->vmcb->control.tsc_offset - g_tsc_offset,
> -				   offset);
> -
>  	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
>  
>  	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cbe0cdade38a..49241423b854 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1812,9 +1812,6 @@ static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
>  		g_tsc_offset = vmcs12->tsc_offset;
>  
> -	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
> -				   vcpu->arch.tsc_offset - g_tsc_offset,
> -				   offset);
>  	vmcs_write64(TSC_OFFSET, offset + g_tsc_offset);
>  	return offset + g_tsc_offset;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 87deb119c521..c08295bcf50e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2299,6 +2299,10 @@ EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
>  
>  static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
> +	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
> +				   vcpu->arch.l1_tsc_offset,
> +				   offset);
> +
>  	vcpu->arch.l1_tsc_offset = offset;
>  	vcpu->arch.tsc_offset = static_call(kvm_x86_write_l1_tsc_offset)(vcpu, offset);
>  }

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

