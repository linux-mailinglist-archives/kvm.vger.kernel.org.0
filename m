Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72963BD744
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhGFNAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 09:00:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231948AbhGFNAU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 09:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625576261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DnLEnBkgsWGks2sHBISFH7oG7rJthzexSBxylFpgy8c=;
        b=hwEYJs8vFzR90U3gkrpXqxkyDk7phi7KmMRVwj1ayTZytYBX2QTOpbdvQnNo5+b4o3e11T
        sxyly3Tue65DPH4pwyBq4USz2pMuOZGVj+vLrBVS8BhfaaJhgTRjLNvSqGS1SQk2e71l+M
        O21rU5+uiVlGn8YBjAvI3pSpFBAEJFw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-aE90lo6IMsq-XTZRVNVN7g-1; Tue, 06 Jul 2021 08:57:40 -0400
X-MC-Unique: aE90lo6IMsq-XTZRVNVN7g-1
Received: by mail-ed1-f72.google.com with SMTP id u13-20020aa7d88d0000b0290397eb800ae3so6768037edq.9
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 05:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DnLEnBkgsWGks2sHBISFH7oG7rJthzexSBxylFpgy8c=;
        b=PwPyUGznVL6nbWho4gjH4LAxkeBHsCepXtksx2yqyS7Mi8vgTIgXY4Ticjr5lx7ZMj
         7ikUZH5Ok527fQ+nh5dTcqrZkhWn6j6s5Q7UIgXOFigGQDQFu2KtXT3OQf/B+Lof6FiL
         WD4UL/z/Gz43BKmiPV7Eb3dxj+xtKvFw+zVd5M9HaNwkR1gkA/Vy/ZUrCgAlKMHrL2LO
         IILEBkDGwBhSm9iQLo26dbI17Nfx34VXhrlsu0gbVXEgqYwo0BbVuk49rzb61h9xenpn
         u9/okGPNKSmCRKHSH3qG6Z6XCRS6G7Jv4QoIlyV9BqDfv0y2lO8ou9mesEZG6XZ8TqGD
         voqw==
X-Gm-Message-State: AOAM531pFMKhDhYWfurddgpmetTcWSUNfiQb7FhVnCauZYEYBtUGopFX
        qxUMUGhjTsDiw7ELA4MPI7+zmr6w3/s9zi8gJuGs+wUAYfEiGU8aIIOE24q9xwGu+Xb6tW810Rg
        fUX1GTSkQZKLT
X-Received: by 2002:a17:906:b41:: with SMTP id v1mr12889599ejg.358.1625576259478;
        Tue, 06 Jul 2021 05:57:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLQcQder9RFUtT7E4Nw+mEzCcjU4QaMy7Fr1/rzumUzfDh/6aFBYLjWRGoNaZd0i8PucyR4A==
X-Received: by 2002:a17:906:b41:: with SMTP id v1mr12889588ejg.358.1625576259322;
        Tue, 06 Jul 2021 05:57:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c9sm2891218ejs.28.2021.07.06.05.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 05:57:38 -0700 (PDT)
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <e777bbbe10b1ec2c37d85dcca2e175fe3bc565ec.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 06/69] KVM: TDX: add a helper function for kvm to
 call seamcall
Message-ID: <364da5f9-41eb-74b6-db38-397c8a64b538@redhat.com>
Date:   Tue, 6 Jul 2021 14:57:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e777bbbe10b1ec2c37d85dcca2e175fe3bc565ec.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> +
> +.Lseamcall:
> +	seamcall
> +	jmp	.Lseamcall_ret
> +.Lspurious_fault:
> +	call	kvm_spurious_fault
> +.Lseamcall_ret:
> +
> +	movq    (FRAME_OFFSET + 8)(%rsp), %rdi
> +	testq   %rdi, %rdi
> +	jz 1f
> +
> +	/* If ex is non-NULL, store extra return values into it. */
> +	movq    %rcx, TDX_SEAM_rcx(%rdi)
> +	movq    %rdx, TDX_SEAM_rdx(%rdi)
> +	movq    %r8,  TDX_SEAM_r8(%rdi)
> +	movq    %r9,  TDX_SEAM_r9(%rdi)
> +	movq    %r10, TDX_SEAM_r10(%rdi)
> +	movq    %r11, TDX_SEAM_r11(%rdi)
> +
> +1:
> +	FRAME_END
> +	ret
> +
> +	_ASM_EXTABLE(.Lseamcall, .Lspurious_fault)

Please use local labels and avoid unnecessary jmp, for example

1:
	seamcall
	movq	(FRAME_OFFSET + 8)(%rsp), %rdi
	testq	%rdi, %rdi
	jz	2f

	/* If ex is non-NULL, store extra return values into it. */
	movq    %rcx, TDX_SEAM_rcx(%rdi)
	movq    %rdx, TDX_SEAM_rdx(%rdi)
	movq    %r8,  TDX_SEAM_r8(%rdi)
	movq    %r9,  TDX_SEAM_r9(%rdi)
	movq    %r10, TDX_SEAM_r10(%rdi)
	movq    %r11, TDX_SEAM_r11(%rdi)
2:
	FRAME_END
	ret
3:
	/* Probably it helps to write an error code in %rax? */
	movq	$0x4000000500000000, %rax
	cmpb	$0, kvm_rebooting
	jne	2b
	ud2
	_ASM_EXTABLE(1b, 3b)

Paolo

