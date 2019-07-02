Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53A75D3B0
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 17:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfGBPzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 11:55:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44398 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfGBPzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 11:55:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id e3so8900060wrs.11
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 08:55:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qYCQhCn7Q1C88y5XcI1pcIq4bgznFTXC6xsuOZbugZw=;
        b=FF9qX/xhVyYT+kyX80uBDAstByRJuzSGlFm/u11QKipKRkt7nwEam47nwV8FMOnwUX
         DAWz9p5d2QXJlhx+xqjdrnwbaHyxSkfnhjiTLyyyNTLVjPVb2YUUe1g8wqJdYmiFkVUo
         /rJyKO3kCarnTeC6unH1WVRyIf04WHtp/0KFOV2BQ6x79RfDC9+QM+k9gBnIbwqNqDFL
         ZnigMfUxp8YCZjU9wjs1EAQEF7d77yeVTXwo9ugLoobF1joPo+qd0H8vF3SHYu9XFJc/
         Ttt5Y/4CuBJ4EH1IwGM6ZbsaFD0tA4aqknljOnR1162wJIZnVUz6jYQuDej2Mpqcmk15
         kBfQ==
X-Gm-Message-State: APjAAAUc4i/05gQSmnNp7e5GlgMlard/wytnD5jlVzqCIonxZtP6C4n5
        GaXPkP53b2QklrO6zkrdA7NPDg==
X-Google-Smtp-Source: APXvYqxoLbNZbibKvwdDEj39fnwanXFx3BKNbrYiLePayx6B2BAZEs+CcyVG1J1Cj0ewRihWPnAdDw==
X-Received: by 2002:a5d:4008:: with SMTP id n8mr22759372wrp.353.1562082943761;
        Tue, 02 Jul 2019 08:55:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id q20sm20264624wra.36.2019.07.02.08.55.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:55:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Consider CMCI enabled based on
 IA32_MCG_CAP[10]
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>
References: <20190625120756.8781-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7efc40e1-43e3-d581-f0bf-fad574a0137f@redhat.com>
Date:   Tue, 2 Jul 2019 17:55:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190625120756.8781-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/19 14:07, Nadav Amit wrote:
> CMCI is enabled if IA32_MCG_CAP[10] is set. VMX tests do not respect
> this condition. Fix it.
> 
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/vmx_tests.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3731757..1776e46 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5855,6 +5855,11 @@ static u64 virt_x2apic_mode_nibble1(u64 val)
>  	return val & 0xf0;
>  }
>  
> +static bool is_cmci_enabled(void)
> +{
> +	return rdmsr(MSR_IA32_MCG_CAP) & BIT_ULL(10);
> +}
> +
>  static void virt_x2apic_mode_rd_expectation(
>  	u32 reg, bool virt_x2apic_mode_on, bool disable_x2apic,
>  	bool apic_register_virtualization, bool virtual_interrupt_delivery,
> @@ -5862,8 +5867,10 @@ static void virt_x2apic_mode_rd_expectation(
>  {
>  	bool readable =
>  		!x2apic_reg_reserved(reg) &&
> -		reg != APIC_EOI &&
> -		reg != APIC_CMCI;
> +		reg != APIC_EOI;
> +
> +	if (reg == APIC_CMCI && !is_cmci_enabled())
> +		readable = false;
>  
>  	expectation->rd_exit_reason = VMX_VMCALL;
>  	expectation->virt_fn = virt_x2apic_mode_identity;
> @@ -5893,9 +5900,6 @@ static void virt_x2apic_mode_rd_expectation(
>   * For writable registers, get_x2apic_wr_val() deposits the write value into the
>   * val pointer arg and returns true. For non-writable registers, val is not
>   * modified and get_x2apic_wr_val() returns false.
> - *
> - * CMCI, including the LVT CMCI register, is disabled by default. Thus,
> - * get_x2apic_wr_val() treats this register as non-writable.
>   */
>  static bool get_x2apic_wr_val(u32 reg, u64 *val)
>  {
> @@ -5930,6 +5934,11 @@ static bool get_x2apic_wr_val(u32 reg, u64 *val)
>  		 */
>  		*val = apic_read(reg);
>  		break;
> +	case APIC_CMCI:
> +		if (!is_cmci_enabled())
> +			return false;
> +		*val = apic_read(reg);
> +		break;
>  	case APIC_ICR:
>  		*val = 0x40000 | 0xf1;
>  		break;
> 

Queued, thanks.

Paolo
