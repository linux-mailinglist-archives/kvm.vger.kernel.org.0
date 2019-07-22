Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA636FEFF
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 13:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbfGVLwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 07:52:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43472 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfGVLwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 07:52:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so39062780wru.10
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2019 04:52:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BE8JIygzINCp1gyrm3FdkUYHuzLOE+CPIQkp+cGSXp8=;
        b=MP4cPHdIfLhQt6gPF+FgdqLrtfo3R5SuXzjccc7++QZKA+jInC+fscETzbV9Ye7IZd
         t+W0ngJRiAh1tuUi0/8frtO5HuC+p2Pi+4CgaoBqf+sfXv0IR4xD6bjiPm57LakqjMdX
         +le5qjkWbg4U8Uzzq/56OkpDGL8MUIkPiXYc8Ji0C/7M90UHANCwb5hPrqHjTaRf7ACj
         P9X3GO328wS17j+Ka03Z2H+wa6E9sQXSBg4XvO3Or7OvL/jW3uM69Wy5Hu7cMt4dYyeh
         wHnuq3TyPvvEfLRAoBJ9sSNfTYnd3AN8lMYx08YfzRlO6MAiMCHx8pWVoV9D71QMG59V
         TY/g==
X-Gm-Message-State: APjAAAXPC83qJM60ShehqvP+9BkzkkTBfSygiekJTRbVZrS/6Vvy6+Zv
        LXAhDmbXNtM8tfVE47CyHm8HGg==
X-Google-Smtp-Source: APXvYqwfHFIBVnsFDSM0voRD+9JN0UDeEAkXCVSaMpU1vsGU+PYLKb/I6toSih8nGFXGvBX9kY69mA==
X-Received: by 2002:a5d:4941:: with SMTP id r1mr71698709wrs.225.1563796334656;
        Mon, 22 Jul 2019 04:52:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:10f7:67c8:abb4:8512? ([2001:b07:6468:f312:10f7:67c8:abb4:8512])
        by smtp.gmail.com with ESMTPSA id j9sm42749201wrn.81.2019.07.22.04.52.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 04:52:14 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when
 leaving nested
To:     Jan Kiszka <jan.kiszka@web.de>, kvm <kvm@vger.kernel.org>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <ee67b5c3-d660-179a-07fa-2bebdc940d4f@web.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ab8cfd4b-90de-b96f-5e5f-7bd5c42b5a4d@redhat.com>
Date:   Mon, 22 Jul 2019 13:52:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ee67b5c3-d660-179a-07fa-2bebdc940d4f@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/19 13:52, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Letting this pend may cause nested_get_vmcs12_pages to run against an
> invalid state, corrupting the effective vmcs of L1.
> 
> This was triggerable in QEMU after a guest corruption in L2, followed by
> a L1 reset.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
> 
> And another gremlin. I'm afraid there is at least one more because
> vmport access from L2 is still failing in QEMU. This is just another
> fallout from that. At least the host seems stable now.
> 
>  arch/x86/kvm/vmx/nested.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0f1378789bd0..4cdab4b4eff1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -220,6 +220,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
>  		return;
> 
> +	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
> +
>  	vmx->nested.vmxon = false;
>  	vmx->nested.smm.vmxon = false;
>  	free_vpid(vmx->nested.vpid02);
> --
> 2.16.4
> 

Queued, thanks.

Paolo
