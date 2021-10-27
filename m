Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E206543C780
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 12:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbhJ0KVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 06:21:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231910AbhJ0KVQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 06:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635329931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0f27XW5ipOgXyw7srO4b+jUX50VuAlw+C7sxFBFkpEA=;
        b=C5Yt2goiqIUnMSYlfnQPtwtYuW8bghJuzGs5vMKufr1DFcaS4VG5pXobzz9VNON7yKcdKn
        VEK/tOljsyCOSIKHXcy3rWTJndRD1KjGCDv8nGuS6jlnFftuNmxyo0ZVfqY+fVkYv6dsBH
        xta6aH+mzVf/C3m3R7ykoc9PRiFNw/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-NX_vwU-ZN9SDSZWcd7uWxg-1; Wed, 27 Oct 2021 06:18:50 -0400
X-MC-Unique: NX_vwU-ZN9SDSZWcd7uWxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2879100C661;
        Wed, 27 Oct 2021 10:18:45 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC5315BAE0;
        Wed, 27 Oct 2021 10:18:25 +0000 (UTC)
Message-ID: <d13520b7a5a78b26ec994ec66d2fea6deddad40a.camel@redhat.com>
Subject: Re: [PATCH v2 05/43] KVM: Update halt-polling stats if and only if
 halt-polling was attempted
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Wed, 27 Oct 2021 13:18:24 +0300
In-Reply-To: <20211009021236.4122790-6-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:11 -0700, Sean Christopherson wrote:
> Don't update halt-polling stats if halt-polling wasn't attempted.  This
> is a nop as @poll_ns is guaranteed to be '0' (poll_end == start), but it
> will allow a future patch to move the histogram stats into the helper to
> resolve a discrepancy in what is considered a "successful" halt-poll.
> 
> No functional change intended.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5d4a90032277..6156719bcbbc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3217,6 +3217,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  {
>  	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>  	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
> +	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>  	ktime_t start, cur, poll_end;
>  	bool waited = false;
>  	u64 block_ns;
> @@ -3224,7 +3225,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_blocking(vcpu);
>  
>  	start = cur = poll_end = ktime_get();
> -	if (vcpu->halt_poll_ns && halt_poll_allowed) {
> +	if (do_halt_poll) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
>  
>  		++vcpu->stat.generic.halt_attempted_poll;
> @@ -3276,8 +3277,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
> -	update_halt_poll_stats(
> -		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
> +	if (do_halt_poll)
> +		update_halt_poll_stats(
> +			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
>  
>  	if (halt_poll_allowed) {
>  		if (!vcpu_valid_wakeup(vcpu)) {
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

