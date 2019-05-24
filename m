Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF5029F04
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 21:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732014AbfEXTYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 15:24:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34074 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfEXTYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 15:24:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id e19so2594963wme.1
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 12:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nyLjJIuQiovth1xD2VEh6yhqzDwukSC9bwtOSeIYGcw=;
        b=C+HuG4Y6EygLzCeTM3BiyzBbnhMWXZkQLJHH0Z7+Lg6VE9Dkk4XW3aZxPk8aKGOA1D
         RzfCr1Le2V/KAx9lCfx/Q42HmKv3E4uEkl8P3XKDRakMdD2nSUiYrdDBs6vYQNZJXIAs
         jvTkBdnfLsmaq7X9zKpOiNaGPbDVJuWH9QqD6gJP6HKJSewxndOxoK15iXOk7xnFjo2m
         h+GBF6ijMfAF0gKVlGIQy3K8SIl0vY1Q1YE8oHOc+u+qPxntCez9v8sHwK+8RZHT5wRo
         78otVeibylnn+eibbfPgBs9OC/cUXenK3u4lbaeb7wkfXYU17aWSV8HdAZ/VhO8AHZIP
         SbZg==
X-Gm-Message-State: APjAAAU23eIKbCWnApC2fIL48XE3h6j/G5iAfrC0LyUtwnyu7WwKfqQr
        TuEx1s1PZp8TmnjjSpLLfTsGSA==
X-Google-Smtp-Source: APXvYqwpivDxBiLvuh+u+TU2U9mrTwlWvi9GbLx3yb6/3wK2Yk7yt3xcNnZUE5m30VdPRo86NKFqYA==
X-Received: by 2002:a7b:c7d6:: with SMTP id z22mr1002065wmk.54.1558725841041;
        Fri, 24 May 2019 12:24:01 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id h12sm3770895wre.14.2019.05.24.12.23.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:24:00 -0700 (PDT)
Subject: Re: [PATCH] kvm: selftests: aarch64: fix default vm mode
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, thuth@redhat.com
References: <20190523110546.23617-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc23c04b-cfb0-5c30-93cc-5e10efe994d1@redhat.com>
Date:   Fri, 24 May 2019 21:23:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523110546.23617-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/05/19 13:05, Andrew Jones wrote:
> VM_MODE_P52V48_4K is not a valid mode for AArch64. Replace its
> use in vm_create_default() with a mode that works and represents
> a good AArch64 default. (We didn't ever see a problem with this
> because we don't have any unit tests using vm_create_default(),
> but it's good to get it fixed in advance.)
> 
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 03abba9495af..19e667911496 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -227,7 +227,7 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
>  	uint64_t extra_pg_pages = (extra_mem_pages / ptrs_per_4k_pte) * 2;
>  	struct kvm_vm *vm;
>  
> -	vm = vm_create(VM_MODE_P52V48_4K, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
> +	vm = vm_create(VM_MODE_P40V48_4K, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
>  
>  	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
>  	vm_vcpu_add_default(vm, vcpuid, guest_code);
> 

Queued, thanks.

Paolo
