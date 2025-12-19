Return-Path: <kvm+bounces-66339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8789CD00FF
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 14:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2E8230AC4C0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0184E33A9D2;
	Fri, 19 Dec 2025 13:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="krW0g7EJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7254E33A01C
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 13:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766150358; cv=none; b=jbDFFL9J6YlOGEWXWskLpGg9H4KY68yLtKC9nXV6o97jIUe6cfvS5wKnLkcGp6lqhOHXbfLTmK3uHw2/clkSfX1zf3iyxo+kwTi7IsMW/4HGnaamjd6QZbXf3aeUDmr2i4H3Q3Tm1/o1t+CTE1lgejQn6cCQwVIrSHKpDK5tuQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766150358; c=relaxed/simple;
	bh=9v+syDd3Z0HzkwZk1/UE5kzTMMPRhyUnQaTAmWWetbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YArszZoXOtQsnMzuTQuCDG5XYujPnyTLrinRTB3/HVQBAcVwr0c73zG6+tQHB+2Mri8zv0gj5gw5V4ALQwkgGkYtgxqD7bU4TfpVCaOWcVPI74F929pW/0NanVyKmIPt39Ly6GYI5a6BYrw8Lkel5e6CEkLiHAu6NwKcLMW1TaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=krW0g7EJ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-430f2ee2f00so870394f8f.3
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 05:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1766150354; x=1766755154; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DFd4J9jPYMS9ZOzqXHiQyrB1Qi+JjAAfHpMnISnUCtk=;
        b=krW0g7EJiyPU4DqDpD0pWX10sIP+AKGFPqtGLV0MEWTM2a3dhemZtVu+soMv7bUND3
         mrsLyI7eblPyyfocA6IQPFwEQcUehRwFmlgyoLm1UZYPZd3zH6IRA8Vdx46WZMmZCp8F
         A0iLxR3z/HezWmoeWrYrtyPtCrWP5tdNupvvE8v8jJ5N0vKsTGXkB8llqVmozFON0eEe
         1tj7mXyKIK/iKNDvgEF8pvq23rxnQuwFGpCK/dNYd5uVjfwqkBgTS8L+UoMKzpBIgWMI
         5TclLtjgDcojsNo/FGATsWZYFypLgoSms4L4UMmzd7fy289pB/qa7MkJk6Z7QQshvWJF
         t13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766150354; x=1766755154;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DFd4J9jPYMS9ZOzqXHiQyrB1Qi+JjAAfHpMnISnUCtk=;
        b=eybo7GMPCKl4O+fX8dhIAPrnXiwFfOzv2xEWOElgtZ9ubmyIx+4aAw5u7CjxPxXtOr
         OL8nH6QRLrHaR9m+4GeKix8K/A5E7WmGinz4cmS8wD0xf08yJXPICEkQpgiMqdnoCBrb
         E/hnQ5Gap1QT3S/rcogEzS3i61bmWS6LMfV7930Hq3M07/wOZL32US6idhUVVsSfvylK
         5etI4EEjMJEeDivlgZBxPkjCHs1rFjgx+M27Z8j4DsfpVYtVEJXrJfnpRRRkH+4Ohno2
         XKvtDyXQGzEUK6K1aZSRvnsOWkV5JcUcjGK7AzAx2iASIWW8lNk/POdYvsOH/OnfRdpB
         uflA==
X-Gm-Message-State: AOJu0YwFKlkpNyxCD8sJev3zh5n6CJ9n6wBlEJlc37pxEO1Hn4jVjRTI
	TgiFBGzI7R4mEVCkfR8o2qEo49x2KwQY06eK4xzYWcgvZRjvfoHa98B889ZjaONByAA=
X-Gm-Gg: AY/fxX5OIKs5RFQCiTySEFb9Z6kLVaodQnAf+sKNLPRTk8bIoTmCP9JFVwtga3+qAgg
	yrx0Xdc6OYq/NX3/AmaaQkPfcwymrCRmyj/MLDhLCoROOPX57/tO/QREbA//J3kQe+mcOpfKk8H
	+6iXWCGdg3HzqAZ3d/bbIpbEKQTR13hKP3tsxPX5b7AjtDNPaOfyeMNw/c1j4BL9NZZ9GtdF9AA
	LdnvM8K95CgYBe1BeVYFGoUkBTacCBtELgoHvpNsR2ZuQqG2r4/VvVCpry6krd2VsoCR88IjVnX
	rhQpSLzML66ig7CLy6WX46ftqVYtHINH4/Ak5PCbFlODmgFLU7JwCl0vmHtSSh9WILP2z5DpiHg
	yEuLd5YxVy3vrM875I6zazhvhw509dl9yWcSav3OiHRg7FHKCC1nCQYd9BAUVxn/9Hs+2p/a59U
	3eD3TIXGy4DDfY02+hgr1qRcpAScC41sAJN6qDiqn2palPY6Pm3Bsy6jAkcVPAl982/4Scgupm5
	dNzys66+M8sGiHn//UedC/uTJwa6Ucj58ltSAuw4vfAVcE=
X-Google-Smtp-Source: AGHT+IFUedUyaN7FVM4hNwKAqMiuSpJ80gJNt0Ya1FnndgUrjUxzdooMyM8p/7osbYBPFxG9KOMkKQ==
X-Received: by 2002:a05:6000:26cf:b0:42f:b649:6dc9 with SMTP id ffacd0b85a97d-4324e70997cmr3518881f8f.58.1766150353635;
        Fri, 19 Dec 2025 05:19:13 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab33f5sm5096298f8f.41.2025.12.19.05.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 05:19:13 -0800 (PST)
Message-ID: <9887353c-28ed-4a83-b0d8-551d78a29a93@grsecurity.net>
Date: Fri, 19 Dec 2025 14:19:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net>
 <aUNci6Oy1EXXoQuY@google.com>
 <769da4d7-0e8c-447a-be6b-1e3ad9a0ae36@grsecurity.net>
 <aURHXUX3tC8ElwFa@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aURHXUX3tC8ElwFa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18.12.25 19:26, Sean Christopherson wrote:
> VICTORY IS MINE!!!!!!!

🏆

> [...]
> Writing MSR_KVM_WALL_CLOCK_NEW via the AP's VM-Entry load list passes with.
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 510454a6..2d140ee5 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -6,6 +6,7 @@
>  
>  #include <asm/debugreg.h>
>  
> +#include "kvmclock.h"
>  #include "vmx.h"
>  #include "msr.h"
>  #include "processor.h"
> @@ -1967,7 +1968,7 @@ struct vmx_msr_entry {
>         u32 index;
>         u32 reserved;
>         u64 value;
> -} __attribute__((packed));
> +} __attribute__((packed)) __attribute__((aligned(16)));
>  
>  #define MSR_MAGIC 0x31415926
>  struct vmx_msr_entry *exit_msr_store, *entry_msr_load, *exit_msr_load;
> @@ -9861,6 +9862,8 @@ static void vmx_init_signal_test(void)
>          */
>  }
>  
> +static bool use_kvm_wall_clock;
> +
>  #define SIPI_SIGNAL_TEST_DELAY 100000000ULL
>  
>  static void vmx_sipi_test_guest(void)
> @@ -9869,7 +9872,7 @@ static void vmx_sipi_test_guest(void)
>                 /* wait AP enter guest with activity=WAIT_SIPI */
>                 while (vmx_get_test_stage() != 1)
>                         ;
> -               delay(SIPI_SIGNAL_TEST_DELAY);
> +               // delay(SIPI_SIGNAL_TEST_DELAY);
>  
>                 /* First SIPI signal */
>                 apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
> @@ -9903,6 +9906,12 @@ static void vmx_sipi_test_guest(void)
>         }
>  }
>  
> +static const struct vmx_msr_entry msr_load_wall_clock = {
> +       .index = MSR_KVM_WALL_CLOCK_NEW,
> +       .reserved = 0,
> +       .value = 1,
> +};
> +
>  static void sipi_test_ap_thread(void *data)
>  {
>         struct guest_regs *regs = this_cpu_guest_regs();
> @@ -9937,7 +9946,15 @@ static void sipi_test_ap_thread(void *data)
>         /* Set guest activity state to wait-for-SIPI state */
>         vmcs_write(GUEST_ACTV_STATE, ACTV_WAIT_SIPI);
>  
> -       vmx_set_test_stage(1);
> +       if (use_kvm_wall_clock) {
> +               wrmsr(MSR_KVM_WALL_CLOCK_NEW, 0);
> +               vmcs_write(ENT_MSR_LD_CNT, 1);
> +               vmcs_write(ENTER_MSR_LD_ADDR, virt_to_phys(&msr_load_wall_clock));
> +       } else {
> +               vmx_set_test_stage(1);
> +       }
> +
> +       delay(SIPI_SIGNAL_TEST_DELAY);
>  
>         /* AP enter guest */
>         enter_guest();
> @@ -9980,6 +9997,8 @@ static void vmx_sipi_signal_test(void)
>         u64 cpu_ctrl_0 = CPU_SECONDARY;
>         u64 cpu_ctrl_1 = 0;
>  
> +       use_kvm_wall_clock = this_cpu_has_kvm() && this_cpu_has(KVM_FEATURE_CLOCKSOURCE2);
> +
>         /* passthrough lapic to L2 */
>         disable_intercept_for_x2apic_msrs();
>         vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
> @@ -9996,6 +10015,13 @@ static void vmx_sipi_signal_test(void)
>         /* start AP */
>         on_cpu_async(1, sipi_test_ap_thread, NULL);
>  
> +       if (use_kvm_wall_clock) {
> +               while (rdmsr(MSR_KVM_WALL_CLOCK_NEW) != 1)
> +                       cpu_relax();
> +
> +               vmx_set_test_stage(1);
> +       }
> +
>         /* BSP enter guest */
>         enter_guest();
>  }
>  

What a hack! I like it :D

Happy holidays!

Thanks,
Mathias

