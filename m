Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9727D7EFCA
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 11:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732558AbfHBJD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 05:03:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34083 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfHBJD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 05:03:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so977420wmd.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 02:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MJhjj3mBwgft1ytEPPkTSsGclIEbwHaqa5f1BjqWwHE=;
        b=nt7vPjiZ33A0heFCLcD+u/rNYPBEPXXkfjkwrsAy7qj3efij8e46t6ZFvHLvX2e+ca
         RZSaGaLfC820HcVYsf1g8cpoocGBMp2mLboNUE1A0Qnu1Ss9ymAC0harRvv+fkr9UsKy
         7+ByOptEmbsEVNBppoPSdEkt37XSFXW4BmOJXa0m1U/p+21W532+2Ep7BORjSBwhiAp6
         qRAbv/MLkygvjvjQCu/r1LL6/eHxOAEAwLij4pyPFuIYhdJZ7Mb9dOrSNSvSM7WAPJUW
         JGx8qE6YXob4Tvb/rFFqclUUdgOshqXkrNYePyZFW/P5kkpu0P/w81JgP3jfYnnqpy1j
         jMWg==
X-Gm-Message-State: APjAAAV7GDLc/8/kY769pt+FRr8kHDkjX/URyjgBcWrjla4ZJ3UdtnTH
        PZ6+rauwklx2DhW+Pdm9rhUGqw==
X-Google-Smtp-Source: APXvYqwsIb5IBIb6EjqofR+ghzM+7hHKpee/wh5qbODjTO4IntyFDdqwrWHi5Cj5QkR8IwdGqC0VFw==
X-Received: by 2002:a1c:f418:: with SMTP id z24mr3454407wma.80.1564736606068;
        Fri, 02 Aug 2019 02:03:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id z5sm53295288wmf.48.2019.08.02.02.03.25
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 02:03:25 -0700 (PDT)
Subject: Re: [RFC PATCH v2 10/19] RISC-V: KVM: Handle WFI exits for VCPU
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
 <20190802074620.115029-11-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5b966171-4d11-237d-5a43-dc881efb7d0a@redhat.com>
Date:   Fri, 2 Aug 2019 11:03:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802074620.115029-11-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 09:47, Anup Patel wrote:
> +		if (!kvm_riscv_vcpu_has_interrupt(vcpu)) {

This can be kvm_arch_vcpu_runnable instead, since kvm_vcpu_block will
check it anyway before sleeping.

Paolo

> +			kvm_vcpu_block(vcpu);
> +			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> +		}

