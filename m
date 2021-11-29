Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D064626FF
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbhK2XAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 18:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbhK2W7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:59:48 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABED9C08ED82;
        Mon, 29 Nov 2021 09:53:55 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y12so75362755eda.12;
        Mon, 29 Nov 2021 09:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1y5DEAA90y8cYxRCLd33wqhLVpAEzLmdNKss0/RInBo=;
        b=E58dL1Cy0ML/Fq7U+4vMD/XpyhySESNFxGtsJEr0iGA5QuLlhcOX/A4/jdDRZEzDIQ
         fPsLvJxXz3PX63V9su/FgauAMqwxco+y+olI1dCd3mpfxLlYlBPlhWOjrxeLq9guNxSM
         eEfi9IneXptokJh8diXl/ugbj5GCH/6ELhKn4aofNdddGLZ+OqUWg1z9TxLUnKXffmNg
         lUaqpY0k7AwGkJ3OL2ZtKNoHyBmTZ4KtwmtpxoPlTCt2JnQOPjXQ7vH4M7rfgBjlRgND
         uViwUXN3LorpSW+ON86lkQL5g7/VvacQD/GzeWK08eJHfKwJKQfnwt7i4lLeeVe5Mvw/
         ad3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1y5DEAA90y8cYxRCLd33wqhLVpAEzLmdNKss0/RInBo=;
        b=x4bbK/cjcMnOoyxtkDp7Z3F+2SdUFuT80avz2Tmcu44Jfj+dh6AzycwELMXJuXzPcQ
         vLpc+he5hqyOnGi+y5qiJxfLNrR0Px3Wt6aLL7yl7fj2aXHZWueJE0MrCS7ZI/+PoFEe
         k0n9zKbA2jvYjlGXKpeG363N68FxqZgmcISOMaGOG5G6GZgM4MtFvmn9AkkK1aW2nKuU
         l4c6HdItYcDeosAS9qSTXFEEArBMqXqsNE2ot/WSimKSPVspAoO/UCVplylraCTuaOa6
         hU62QT7UchN8fQtuLGLaSaDqOt1SCvEpurFiyvxFzwTo8KT6cAkFt2omJTbgx3wsZLyC
         Votg==
X-Gm-Message-State: AOAM5310EUJg1Dqp0pxtKg0+W7O6Mn/q6iTwmgRsFiYZdWD+0d+TjoQ9
        x4b/oOfmOg2XQw+uGhep+5g=
X-Google-Smtp-Source: ABdhPJyEFZTCnn35jIBM5GkhncH3CSPbL5gmVmWsUh9Tr+ztH5c8bc9QO9Acd3UAKwaA5P3qYhybfg==
X-Received: by 2002:a05:6402:2744:: with SMTP id z4mr77472004edd.310.1638208434290;
        Mon, 29 Nov 2021 09:53:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id gt18sm7974997ejc.46.2021.11.29.09.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 09:53:53 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
Date:   Mon, 29 Nov 2021 18:53:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
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
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaUNBfJh35WXMV0M@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 18:25, Sean Christopherson wrote:
> If a posted interrupt arrives after KVM has done its final search through the vIRR,
> but before avic_update_iommu_vcpu_affinity() is called, the posted interrupt will
> be set in the vIRR without triggering a host IRQ to wake the vCPU via the GA log.
> 
> I.e. KVM is missing an equivalent to VMX's posted interrupt check for an outstanding
> notification after switching to the wakeup vector.

BTW Maxim reported that it can break even without assigned devices.

> For now, the least awful approach is sadly to keep the vcpu_(un)blocking() hooks.

I agree that the hooks cannot be dropped but the bug is reproducible 
with this patch, where the hooks are still there.

With the hooks in place, you have:

	kvm_vcpu_blocking(vcpu)
	  avic_set_running(vcpu, false)
	    avic_vcpu_put(vcpu)
	      avic_update_iommu_vcpu_affinity()
	      WRITE_ONCE(...) // clear IS_RUNNING bit

	set_current_state()
	  smp_mb()

	kvm_vcpu_check_block()
	  return kvm_arch_vcpu_runnable() || ...
	    return kvm_vcpu_has_events() || ...
	      return kvm_cpu_has_interrupt() || ...
		return kvm_apic_has_interrupt() || ...
		  return apic_has_interrupt_for_ppr()
		    apic_find_highest_irr()
		      scan vIRR

This covers the barrier between the write of is_running and the read of 
vIRR, and the other side should be correct as well.  in particular, 
reads of is_running always come after an atomic write to vIRR, and hence 
after an implicit full memory barrier.  svm_deliver_avic_intr() has an 
smp_mb__after_atomic() after writing IRR; avic_kick_target_vcpus() even 
has an explicit barrier in srcu_read_lock(), between the microcode's 
write to vIRR and its own call to avic_vcpu_is_running().

Still it does seem to be a race that happens when IS_RUNNING=true but 
vcpu->mode == OUTSIDE_GUEST_MODE.  This patch makes the race easier to 
trigger because it moves IS_RUNNING=false later.

Paolo
