Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4F328210F
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 18:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfHEQDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 12:03:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36656 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfHEQDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 12:03:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so69440938wme.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 09:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LwK/9xcoxcLhVd0bC7/eyesTfSVbLSLef7bJ1QJeiPA=;
        b=MIbfPNWS/L98Cl2y2gGKSgLZhsbLa+pSn5mzlzWXIfleBIZ+mSDYk0pLXP1CL0vU2K
         txwgN1Pevs0TYGrxg4P2mctMcXym0ybDL9ZzXbE21ojSvK6C6zPw96lrqFs5Zbjbc/xJ
         V5Qpj64SsgF7XihdWQMMUxDakUmMGNSiPVTr1UZriOIQRryjLlGnmsdudwqTIxGY4tjF
         byIh/RDxlu5fJZboKxW1/FcCOF8AhZShf3dVBRYDiylB4+4YD13BygCmg2sgn35o/es8
         hkN3r7pz+41lQTvtFnymReY+qGCWCxCBqf75j2ta480mj9sN8GKk8r2r5m1JevVS+EWx
         WD8w==
X-Gm-Message-State: APjAAAU+Sc++Ac8/3opKCAUEuavbdzzHOfMiwuoNwuu/iGSTVsywDnEv
        pRrR20Pwzmz9sIrVmbLfRrrv3Q==
X-Google-Smtp-Source: APXvYqzGW/23QI5xsDwaQipvdvH1ice7rq/tQKOY4EpSalvG7w4huAOnxqDQnYhgBxpemU160KN5eg==
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr19642061wmc.133.1565020983219;
        Mon, 05 Aug 2019 09:03:03 -0700 (PDT)
Received: from [192.168.178.40] ([151.21.165.91])
        by smtp.gmail.com with ESMTPSA id n3sm76821109wrt.31.2019.08.05.09.03.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 09:03:02 -0700 (PDT)
Subject: Re: [PATCH v3 11/19] RISC-V: KVM: Implement VMID allocator
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
References: <20190805134201.2814-1-anup.patel@wdc.com>
 <20190805134201.2814-12-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <21bdde39-8d33-6aae-e729-476ce11406a3@redhat.com>
Date:   Mon, 5 Aug 2019 18:03:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805134201.2814-12-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/19 15:43, Anup Patel wrote:
> +	spin_lock(&vmid_lock);
> +
> +	/*
> +	 * We need to re-check the vmid_version here to ensure that if
> +	 * another vcpu already allocated a valid vmid for this vm.
> +	 */
> +	if (!kvm_riscv_stage2_vmid_ver_changed(vmid)) {
> +		spin_unlock(&vmid_lock);
> +		return;
> +	}
> +
> +	/* First user of a new VMID version? */
> +	if (unlikely(vmid_next == 0)) {
> +		WRITE_ONCE(vmid_version, READ_ONCE(vmid_version) + 1);
> +		vmid_next = 1;
> +
> +		/*
> +		 * On SMP, we know no other CPUs can use this CPU's or
> +		 * each other's VMID after forced exit returns since the
> +		 * vmid_lock blocks them from re-entry to the guest.
> +		 */
> +		spin_unlock(&vmid_lock);
> +		kvm_flush_remote_tlbs(vcpu->kvm);
> +		spin_lock(&vmid_lock);

This comment is not true anymore, so this "if" should become a "while".

Paolo
