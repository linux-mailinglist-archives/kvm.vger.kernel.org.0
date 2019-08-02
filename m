Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBACC7EFD4
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 11:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404597AbfHBJDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 05:03:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44827 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732895AbfHBJDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 05:03:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so76349774wrf.11
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 02:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bwx8/3+omec7zmijOtKif9DQxXapLJoupah+QfmoXjM=;
        b=N/AEu3hBPLdL4vg9tsSS6KikLBHJQE5kO6krW1gVc4kMOsZkFwErVX8M86CpocgWSx
         TBD+zEaz/w9+zmaj+jGmGMJc6yB90sQ96L6sFAmN32XmkrFAN/AZLmqCifZd9FjxyIAH
         j5Ogm/MeGKQCqmju/FARRtMRiOcABjXOzJ7oZtkYzoVp+YZzM4PMoCqYd6fG+RIQlT3N
         /3WiP8LoQct+bjvn+LKOwOH2EYTaL3pElAxwKV/3asgtTAXiElq5EsPZMw2KB08ORYW8
         39CVXYp75VAeHI64/yTWUXMvu1N4Ez8v/D3+IPoZkDYpJ7AptQdXoA0wrUfT/06oJrAg
         gtiQ==
X-Gm-Message-State: APjAAAVfOlhJlPGELxR29b+tjBhdwj1VgzCVf4ASne7tpgYrdnu8CJY2
        JeIxSqH9XbBpzaP4XSe6xHnTTw==
X-Google-Smtp-Source: APXvYqzL/HKYIOOtRRO6u1IKHQOTKAtJRMqcFBTlwICbd/6fS4zdHbTSm6by+RvwTllnE7+5D6q80Q==
X-Received: by 2002:a5d:4e02:: with SMTP id p2mr36191018wrt.182.1564736625330;
        Fri, 02 Aug 2019 02:03:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id c30sm140911490wrb.15.2019.08.02.02.03.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 02:03:44 -0700 (PDT)
Subject: Re: [RFC PATCH v2 07/19] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190802074620.115029-1-anup.patel@wdc.com>
 <20190802074620.115029-8-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <03f60f3a-bb50-9210-8352-da16cca322b9@redhat.com>
Date:   Fri, 2 Aug 2019 11:03:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802074620.115029-8-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 09:47, Anup Patel wrote:
> +	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
> +		kvm_riscv_vcpu_flush_interrupts(vcpu, false);

Not updating the vsip CSR here can cause an interrupt to be lost, if the
next call to kvm_riscv_vcpu_flush_interrupts finds a zero mask.

You could add a new field vcpu->vsip_shadow that is updated every time
CSR_VSIP is written (including kvm_arch_vcpu_load) with a function like

void kvm_riscv_update_vsip(struct kvm_vcpu *vcpu)
{
	if (vcpu->vsip_shadow != vcpu->arch.guest_csr.vsip) {
		csr_write(CSR_VSIP, vcpu->arch.guest_csr.vsip);
		vcpu->vsip_shadow = vcpu->arch.guest_csr.vsip;
	}
}

And just call this unconditionally from kvm_vcpu_ioctl_run.  The cost is
just a memory load per VS-mode entry, it should hardly be measurable.

Paolo
