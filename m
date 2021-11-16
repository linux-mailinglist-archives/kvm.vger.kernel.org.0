Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C5C453100
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 12:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhKPLmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 06:42:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235284AbhKPLmA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 06:42:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637062742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8FySTTkg9VAhk/+faOWfih5YjSReOgpVEfBK5ZrOg2s=;
        b=O85WIiqRrme5aWvF6PtKl0ziC85EmTvQe6khBA6JqcgqUMOti2vuCJlWLyDp2WfRoDjRWH
        WcNUOlXJi+CXpoVEkX+iCBlgGgyQbEYNSkc6mfVLPGRDkjEJonDbCrNHIRR4wImpCJSURC
        b/PxvuQayYSXdxFJJNG3HlGq+eXxDBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-VGO9_QFQP02iydSpftQtIg-1; Tue, 16 Nov 2021 06:38:56 -0500
X-MC-Unique: VGO9_QFQP02iydSpftQtIg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7A97108291F;
        Tue, 16 Nov 2021 11:38:33 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 164B819724;
        Tue, 16 Nov 2021 11:38:29 +0000 (UTC)
Message-ID: <76c7c752-f1b0-f100-03dd-364366eff02f@redhat.com>
Date:   Tue, 16 Nov 2021 12:38:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/6] KVM: SEV: Explicitly document that there are no
 TOCTOU races in copy ASID
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20211109215101.2211373-1-seanjc@google.com>
 <20211109215101.2211373-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211109215101.2211373-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/21 22:50, Sean Christopherson wrote:
> Deliberately grab the source's SEV info for COPY_ENC_CONTEXT_FROM outside
> of kvm->lock and document that doing so is safe due to SEV/SEV-ES info,
> e.g. ASID, active, etc... being "write-once" and set atomically with
> respect to kvm->lock.
> 
> No functional change intended.

This isn't true anymore with the move-enc-context-from patches, though! 
  I will send a follow-up shortly.

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 24 ++++++++++++++++--------
>   1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index eeec499e4372..6d14e2595c96 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1737,9 +1737,9 @@ int svm_unregister_enc_region(struct kvm *kvm,
>   
>   int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>   {
> +	struct kvm_sev_info *mirror_sev, *source_sev;
>   	struct file *source_kvm_file;
>   	struct kvm *source_kvm;
> -	struct kvm_sev_info source_sev, *mirror_sev;
>   	int ret;
>   
>   	source_kvm_file = fget(source_fd);
> @@ -1762,9 +1762,6 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>   		goto e_source_unlock;
>   	}
>   
> -	memcpy(&source_sev, &to_kvm_svm(source_kvm)->sev_info,
> -	       sizeof(source_sev));
> -
>   	/*
>   	 * The mirror kvm holds an enc_context_owner ref so its asid can't
>   	 * disappear until we're done with it
> @@ -1785,14 +1782,25 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>   		goto e_mirror_unlock;
>   	}
>   
> +	/*
> +	 * Referencing the source's sev_info without holding the source's lock
> +	 * is safe as SEV/SEV-ES activation is a one-way, "atomic" operation.
> +	 * SEV state, e.g. the ASID, is modified under kvm->lock, and cannot be
> +	 * changed after SEV is marked active (here or in normal activation).
> +	 * That same atomicity also prevents TOC-TOU issues with respect to
> +	 * related sanity checks on source_kvm.
> +	 */
> +	source_sev = &to_kvm_svm(source_kvm)->sev_info;
> +
>   	/* Set enc_context_owner and copy its encryption context over */
>   	mirror_sev = &to_kvm_svm(kvm)->sev_info;
>   	mirror_sev->enc_context_owner = source_kvm;
> +	mirror_sev->asid = source_sev->asid;
>   	mirror_sev->active = true;
> -	mirror_sev->asid = source_sev.asid;
> -	mirror_sev->fd = source_sev.fd;
> -	mirror_sev->es_active = source_sev.es_active;
> -	mirror_sev->handle = source_sev.handle;
> +	mirror_sev->asid = source_sev->asid;
> +	mirror_sev->fd = source_sev->fd;
> +	mirror_sev->es_active = source_sev->es_active;
> +	mirror_sev->handle = source_sev->handle;
>   	/*
>   	 * Do not copy ap_jump_table. Since the mirror does not share the same
>   	 * KVM contexts as the original, and they may have different
> 

