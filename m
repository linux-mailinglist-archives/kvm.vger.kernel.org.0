Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CB7439886
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 16:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhJYO2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 10:28:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233557AbhJYO2q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 10:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635171983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0JDFR/w0BO+fJnaqyJz0KqLIzoSXAKAPvBzPCJS8rh0=;
        b=hbCJMtC+feXdD4DZpsFhxR0KHosx1zwzyF8Tv1JUfLQGhFPT6Sz9jaYEhXZ8ctLiBr5K/+
        1Af4KNf2fipA4V/TwlqSvOhuL0s5hBfhvsM7MGI8li9fR49uEYSSeK/5IpxDydkWDJz9qy
        I/Q+pHO5qIr6muF9tbKPliOWf9AUoz0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-ret85sfRNzGU9M_q7BAoPg-1; Mon, 25 Oct 2021 10:26:22 -0400
X-MC-Unique: ret85sfRNzGU9M_q7BAoPg-1
Received: by mail-ed1-f69.google.com with SMTP id r25-20020a05640216d900b003dca3501ab4so10032740edx.15
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 07:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0JDFR/w0BO+fJnaqyJz0KqLIzoSXAKAPvBzPCJS8rh0=;
        b=plqVCxyhhsdzfam5Y72xMiEapmd+p6i+MdJXqO5zv6FeLxUY239G6xb02S15K4H9rd
         ZlTIzfIzXHz6jnlUX0OtHMd5xJ+YXz8us57ASg/HjzA4fkGJfTGNWYOlivYd1qQvEXi5
         D9FLrd3gKQSj66BSTSD2cqC7FvcVRONsoTxuvJuVZZf7mEdTSP9VmTQ5Gw/F4cBEu816
         X8Noip/nBsab89a9JiOirWCHGT2I+6jUkNKsWmpQ80cqPnj1KNrJjKp+SBftzpoVxQDL
         j3WCqK5RL0zCg7NbqMxw/mBT2GA3ffbsxognyB+WUSygfdZCFincGpiNGlcKwKNLCZJd
         lvaQ==
X-Gm-Message-State: AOAM531VODtSq4h7X9DMIjfNCfZh4/u5thzrR7pDLsLmbFnH7wIwkRxp
        btbXyvEMlmAMB55UQHCMmsyGJnBjIkZSr/AQTzfb/G9KvpBNSbMPgwFmRc3+yqRzamj4GC0t5nO
        BalW/oCryXyKp
X-Received: by 2002:a50:d78c:: with SMTP id w12mr26913794edi.147.1635171980779;
        Mon, 25 Oct 2021 07:26:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKDlcJy9Ggfa6iOgv+1CVaZWvopovsowDbFDE9dApjZRuZhu/xUobrIcg2Oe5NEBC4id/OJQ==
X-Received: by 2002:a50:d78c:: with SMTP id w12mr26913764edi.147.1635171980582;
        Mon, 25 Oct 2021 07:26:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hs28sm1430847ejc.111.2021.10.25.07.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:26:19 -0700 (PDT)
Message-ID: <0333be2a-76d8-657a-6c82-3bb5c9ff2e3b@redhat.com>
Date:   Mon, 25 Oct 2021 16:26:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 35/43] KVM: SVM: Signal AVIC doorbell iff vCPU is in
 guest mode
Content-Language: en-US
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
        Janosch Frank <frankja@linux.ibm.com>
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
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-36-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-36-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/21 04:12, Sean Christopherson wrote:
> +	 */
> +	if (vcpu->mode == IN_GUEST_MODE) {
>   		int cpu = READ_ONCE(vcpu->cpu);
>   
>   		/*
> @@ -687,8 +692,13 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
>   		if (cpu != get_cpu())
>   			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
>   		put_cpu();
> -	} else
> +	} else {
> +		/*
> +		 * Wake the vCPU if it was blocking.  KVM will then detect the
> +		 * pending IRQ when checking if the vCPU has a wake event.
> +		 */
>   		kvm_vcpu_wake_up(vcpu);
> +	}
>   

Does this still need to check the "running" flag?  That should be a 
strict superset of vcpu->mode == IN_GUEST_MODE.

Paolo

