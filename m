Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9708A463067
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 11:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbhK3KDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 05:03:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235542AbhK3KDr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 05:03:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638266428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2hUfdHpcnEJ4n2lCxmRVknomjs+8GCkA9N7GEjxk1tE=;
        b=ckaT3VUmZJaIbiOG+6N0p/KWKyTqZ9lLrRLVj1NhZooIjxC2OAgx6ZPq9bsycNggPZPxSi
        zRQK8ingBY3bWyKPEOvlsCbsOj9OshWj+ia3DdvyYbUomAOE+0S1YQHzkuHKwR+J0mDXei
        V8GOnc3v+jCvRfMy1rUQsMmtxDO/7WA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-KxnqTc6uPjC6ZYjkZQMLBw-1; Tue, 30 Nov 2021 05:00:26 -0500
X-MC-Unique: KxnqTc6uPjC6ZYjkZQMLBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5CB7101AFC1;
        Tue, 30 Nov 2021 10:00:25 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B3F55D9C0;
        Tue, 30 Nov 2021 10:00:23 +0000 (UTC)
Message-ID: <37f072bb6c5b27ec71ec40bd2e34d75c54d9ff69.camel@redhat.com>
Subject: Re: [PATCH] KVM: fix avic_set_running for preemptable kernels
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Nov 2021 12:00:22 +0200
In-Reply-To: <20211130084644.248435-1-pbonzini@redhat.com>
References: <20211130084644.248435-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-11-30 at 03:46 -0500, Paolo Bonzini wrote:
> avic_set_running() passes the current CPU to avic_vcpu_load(), albeit
> via vcpu->cpu rather than smp_processor_id().  If the thread is migrated
> while avic_set_running runs, the call to avic_vcpu_load() can use a stale
> value for the processor id.  Avoid this by blocking preemption over the
> entire execution of avic_set_running().
> 
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/avic.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 0a58283005f3..560807a2edd4 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1000,16 +1000,18 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	int cpu = get_cpu();
>  
> +	WARN_ON(cpu != vcpu->cpu);
>  	svm->avic_is_running = is_run;
>  
> -	if (!kvm_vcpu_apicv_active(vcpu))
> -		return;
> -
> -	if (is_run)
> -		avic_vcpu_load(vcpu, vcpu->cpu);
> -	else
> -		avic_vcpu_put(vcpu);
> +	if (kvm_vcpu_apicv_active(vcpu)) {
> +		if (is_run)
> +			avic_vcpu_load(vcpu, cpu);
> +		else
> +			avic_vcpu_put(vcpu);
> +	}
> +	put_cpu();
>  }
>  
>  void svm_vcpu_blocking(struct kvm_vcpu *vcpu)

To be honest, I was thinking to remove vcpu parameter from
avic_vcpu_load and let it figure it out, but this can be
always done later.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

PS: this patch as expected didn't help with the 'is_running' AVIC bug
I am stuck with.

Best regards,
	Maxim Levitsky

