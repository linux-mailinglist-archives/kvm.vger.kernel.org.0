Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 728C07A401
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 11:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbfG3JZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 05:25:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43031 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbfG3JZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 05:25:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so64919235wru.10
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 02:25:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cUzWE80r0+/Jm/PmpREfM87NZ7CTSmB2MTbi4J4MfgQ=;
        b=HGcQQTGJsHa0C3YQciiV+jpHgZ3WM+j3kdng8CcBsCFwF0O2aNwmkh3aAt5W+gFRpf
         M2oxtowWvuKEATUqZ0Lw1VP9nKMRkXHn8/Ae5NJ9kCVbcmn+KSTtiYfSxSIDYvf/4bVV
         3u06TzNtkyq7iV3Lun5+HPtUErq0OHnBOrD9+3/jXsy9Qk4jp+4Z+XDfenCQSPEFse8y
         wSDW+c5+I5TA5IDqJGvoU6/NUV4YzWAIWhOTYdBOrQbXYtdUlPO9T4ESVs36ybBqbM12
         6N30d+Rhmr9eUckqpXPFRubpSzYHulBK6ASfbHWpUHHooN4MsbFNP5mowILAasVFa9lW
         N/kQ==
X-Gm-Message-State: APjAAAW8i9EqiepvqNZKS2BLVG0R1VMtFICne4qXj8HFFKdG4TfSHvFw
        gYoS8+wtEJsCfhZNWun3dvf5vQ==
X-Google-Smtp-Source: APXvYqz+F0XEhEJWXPXqrEBWvnNsKyL98ooHfR6J44rQZTpHYL5dhBASE4lu+y3QS4SD34KieOnK3Q==
X-Received: by 2002:adf:dd8e:: with SMTP id x14mr124398481wrl.344.1564478727541;
        Tue, 30 Jul 2019 02:25:27 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o7sm34682654wru.58.2019.07.30.02.25.26
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 02:25:27 -0700 (PDT)
Subject: Re: [RFC PATCH 03/16] RISC-V: Add initial skeletal KVM support
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
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-4-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d1157450-258b-91c1-72cb-867c96f929d8@redhat.com>
Date:   Tue, 30 Jul 2019 11:25:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-4-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:56, Anup Patel wrote:
> +void kvm_riscv_halt_guest(struct kvm *kvm)
> +{
> +	int i;
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		vcpu->arch.pause = true;
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
> +}
> +
> +void kvm_riscv_resume_guest(struct kvm *kvm)
> +{
> +	int i;
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		vcpu->arch.pause = false;
> +		swake_up_one(kvm_arch_vcpu_wq(vcpu));
> +	}

Are these unused?  (Perhaps I'm just blind :))

Paolo
