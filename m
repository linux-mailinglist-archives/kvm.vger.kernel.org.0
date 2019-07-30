Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6546D7A35B
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 10:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbfG3Isl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 04:48:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51450 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfG3Isl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 04:48:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so56320802wma.1
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 01:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wubL2/vgzPA1pd7g/Ft25BpXcTqsyo1e/4gw/momGtU=;
        b=JCbtuwjWt6T6C1iJM5hvenbK5QItsje1dHbh5kmKFdpMGZ3zEjMdOlHT+3poUdCAVY
         a7bDy1Q/80XSNNfS8rTBgPl/QaUnnrwfdaShtfp7rmR7p+iztEqWVF02HhbsX7p+AsVR
         AXug1tqemAUlDBXz/yiINiH6UB+zKzzgntb5jaCrZbyZV119NSStI1OSv2pQGkVnB71A
         881sSsy/5jNxEdcnJkv6nbm10FmZkrSLaz+e8+9xmrcMO9zwuU3UM7uCvtTIwcQWBm2O
         NBLDmuF+DfL8vmHSrdZQ7F0n+hnbgL2Y74VOPZrT99sh4dItCm5vOT6m9WGr531hLX0J
         Artw==
X-Gm-Message-State: APjAAAULMMpr8v2wEFdoha3a7CpM4DroBsrRZ9Ii2s3iSfOoRRNTSi77
        o3jkh+Ps2MSLUJSxUIVp2hGRIw==
X-Google-Smtp-Source: APXvYqyiUPbNE/jZJSqWwOHETlXCAehk9SFPzETDwVZDm9bd+5/kuQgX8raiwe8ulQU1S0IqxtSatA==
X-Received: by 2002:a7b:c0d0:: with SMTP id s16mr74366958wmh.141.1564476518833;
        Tue, 30 Jul 2019 01:48:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id f3sm46989185wrt.56.2019.07.30.01.48.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 01:48:38 -0700 (PDT)
Subject: Re: [RFC PATCH 04/16] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
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
 <20190729115544.17895-5-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ade614ae-fcfe-35f2-0519-1df71d035bcd@redhat.com>
Date:   Tue, 30 Jul 2019 10:48:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729115544.17895-5-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/19 13:56, Anup Patel wrote:
> +	cntx->hstatus |= HSTATUS_SP2V;
> +	cntx->hstatus |= HSTATUS_SP2P;

IIUC, cntx->hstatus's SP2P bit contains the guest's sstatus.SPP bit?  I
suggest adding a comment here, and again providing a ONE_REG interface
to sstatus so that the ABI is final before RISC-V KVM is merged.

What happens if the guest executes SRET?  Is that EXC_SYSCALL in hedeleg?

(BTW the name of SP2V and SP2P is horrible, I think HPV/HPP or HSPV/HSPP
would have been clearer, but that's not your fault).

Paolo

> +	cntx->hstatus |= HSTATUS_SPV;

