Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1F07F034
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 11:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387607AbfHBJT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 05:19:28 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37798 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfHBJT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 05:19:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so51337573wrr.4
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 02:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rryOV1whaDt5qbcW76oYyWTCHfociKUQe7uUrG+FL04=;
        b=E5ZTWK11zonFXW76GLZ1fSMPKwq7+JWZo+WT7PQnY8XuxxE6rOt6Osht2AYtjSKJU8
         btl2mWLoFHbDYXr3OyIGjA8AmraZpQ/gp9gQpPNUJO2iQflE3XYdLXtU9i3juiLnyHdO
         dIQu+wiNRMZ+rX14jb1boTSDoGaXo0+Qec+IF8kdVUcESGs69v7nJj1MQG4hMly9SCQi
         qrzmutEWc8clLAWr/fCyoYwm+KOG2+WSPnVsLzXZsHDBlqpoug7AOuK5Ta4KVitF/ofS
         l5AJ0gVWlAGkZHIieX8dLP/o0xLEf4lMPqkVBVj7l0UnqCeg3bD6cseghBch6xpZ2hZR
         Cskg==
X-Gm-Message-State: APjAAAVf9W72s9klMGcKMjPX57h0pc30x+mBs68Wi3G8YGjuVg0P0Zdv
        OeNQxjYAQ7yqJ3HloNAI2Hp/1Q==
X-Google-Smtp-Source: APXvYqza/LpvBZeOyX5mCSYBuS884KevJyp6R0c0GnF4OO2UtCcL/e+zxFkWcQbl0keeDPdzL8UUmg==
X-Received: by 2002:a5d:5510:: with SMTP id b16mr109465347wrv.267.1564737566565;
        Fri, 02 Aug 2019 02:19:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id v4sm75315899wmg.22.2019.08.02.02.19.25
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 02:19:26 -0700 (PDT)
Subject: Re: [RFC PATCH v2 11/19] RISC-V: KVM: Implement VMID allocator
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
 <20190802074620.115029-12-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ef688903-ff49-ffeb-1f95-ef995942d5dc@redhat.com>
Date:   Fri, 2 Aug 2019 11:19:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802074620.115029-12-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 09:48, Anup Patel wrote:
> +struct kvm_vmid {
> +	unsigned long vmid_version;
> +	unsigned long vmid;
> +};
> +

Please document that both fields are written under vmid_lock, and read
outside it.

> +		/*
> +		 * On SMP we know no other CPUs can use this CPU's or
> +		 * each other's VMID after forced exit returns since the
> +		 * vmid_lock blocks them from re-entry to the guest.
> +		 */
> +		force_exit_and_guest_tlb_flush(cpu_all_mask);

Please use kvm_flush_remote_tlbs(kvm) instead.  All you need to do to
support it is check for KVM_REQ_TLB_FLUSH and handle it by calling
__kvm_riscv_hfence_gvma_all.  Also, since your spinlock is global you
probably should release it around the call to kvm_flush_remote_tlbs.
(Think of an implementation that has a very small number of VMID bits).

> +	if (unlikely(vmid_next == 0)) {
> +		WRITE_ONCE(vmid_version, READ_ONCE(vmid_version) + 1);
> +		vmid_next = 1;
> +		/*
> +		 * On SMP we know no other CPUs can use this CPU's or
> +		 * each other's VMID after forced exit returns since the
> +		 * vmid_lock blocks them from re-entry to the guest.
> +		 */
> +		force_exit_and_guest_tlb_flush(cpu_all_mask);
> +	}
> +
> +	vmid->vmid = vmid_next;
> +	vmid_next++;
> +	vmid_next &= (1 << vmid_bits) - 1;
> +
> +	/* Ensure VMID next update is completed */
> +	smp_wmb();

This barrier is not necessary.  Writes to vmid->vmid need not be ordered
with writes to vmid->vmid_version, because the accesses happen in
completely different places.

(As a rule of thumb, each smp_wmb() should have a matching smp_rmb()
somewhere, and this one doesn't).

Paolo

> +	WRITE_ONCE(vmid->vmid_version, READ_ONCE(vmid_version));
> +
