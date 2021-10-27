Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0769B43C89A
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 13:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbhJ0Lci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 07:32:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241637AbhJ0Lch (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 07:32:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635334212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6755i8Ev1p/V649+fKWbCguz7hafsCtx6KF7gf1uorY=;
        b=TX/V5o7c9HZn0ZYo1Stbn5UuRW1GQ4TLUWo1UuB7pNERiGnFNu87TCgocVolnSwZws3Ly0
        McB8kWSV8zufJ0S2j5l9cGSYABg9A2udHCTxhp7HgKb+bsB9vhLVkYGONA5Vah5BRrPu9j
        lvJFsPddbHDevsHwOr3pgLk5y/5Y4Gk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-SCV0Ypy_PSae9_O3yFoh6Q-1; Wed, 27 Oct 2021 07:30:07 -0400
X-MC-Unique: SCV0Ypy_PSae9_O3yFoh6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B14A3100C66D;
        Wed, 27 Oct 2021 11:30:03 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A291C101E591;
        Wed, 27 Oct 2021 11:29:47 +0000 (UTC)
Message-ID: <62231cec8a62db6bf2baba24cc55e0ec2515d0b1.camel@redhat.com>
Subject: Re: [PATCH v2 07/43] KVM: Reconcile discrepancies in halt-polling
 stats
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
Date:   Wed, 27 Oct 2021 14:29:46 +0300
In-Reply-To: <20211009021236.4122790-8-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Move the halt-polling "success" and histogram stats update into the
> dedicated helper to fix a discrepancy where the success/fail "time" stats
> consider polling successful so long as the wait is avoided, but the main
> "success" and histogram stats consider polling successful if and only if
> a wake event was detected by the halt-polling loop.
> 
> Move halt_attempted_poll to the helper as well so that all the stats are
> updated in a single location.  While it's a bit odd to update the stat
> well after the fact, practically speaking there's no meaningful advantage
> to updating before polling.
> 
> Note, there is a functional change in addition to the success vs. fail
> change.  The histogram updates previously called ktime_get() instead of
> using "cur".  But that change is desirable as it means all the stats are
> now updated with the same polling time, and avoids the extra ktime_get(),
> which isn't expensive but isn't free either.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 35 ++++++++++++++++-------------------
>  1 file changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4dfcd736b274..1292c7876d3f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3204,12 +3204,23 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>  static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>  					  ktime_t end, bool success)
>  {
> +	struct kvm_vcpu_stat_generic *stats = &vcpu->stat.generic;
>  	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
>  
> -	if (success)
> -		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
> -	else
> -		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
> +	++vcpu->stat.generic.halt_attempted_poll;
> +
> +	if (success) {
> +		++vcpu->stat.generic.halt_successful_poll;
> +
> +		if (!vcpu_valid_wakeup(vcpu))
> +			++vcpu->stat.generic.halt_poll_invalid;
> +
> +		stats->halt_poll_success_ns += poll_ns;
> +		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_success_hist, poll_ns);
> +	} else {
> +		stats->halt_poll_fail_ns += poll_ns;
> +		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_fail_hist, poll_ns);
> +	}
>  }
>  
>  /*
> @@ -3230,30 +3241,16 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	if (do_halt_poll) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
>  
> -		++vcpu->stat.generic.halt_attempted_poll;
>  		do {
>  			/*
>  			 * This sets KVM_REQ_UNHALT if an interrupt
>  			 * arrives.
>  			 */
> -			if (kvm_vcpu_check_block(vcpu) < 0) {
> -				++vcpu->stat.generic.halt_successful_poll;
> -				if (!vcpu_valid_wakeup(vcpu))
> -					++vcpu->stat.generic.halt_poll_invalid;
> -
> -				KVM_STATS_LOG_HIST_UPDATE(
> -				      vcpu->stat.generic.halt_poll_success_hist,
> -				      ktime_to_ns(ktime_get()) -
> -				      ktime_to_ns(start));
> +			if (kvm_vcpu_check_block(vcpu) < 0)
>  				goto out;
> -			}
>  			cpu_relax();
>  			poll_end = cur = ktime_get();
>  		} while (kvm_vcpu_can_poll(cur, stop));
> -
> -		KVM_STATS_LOG_HIST_UPDATE(
> -				vcpu->stat.generic.halt_poll_fail_hist,
> -				ktime_to_ns(ktime_get()) - ktime_to_ns(start));
>  	}
>  
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


