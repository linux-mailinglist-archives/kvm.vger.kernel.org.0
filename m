Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE941A0DBC
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 14:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgDGMed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 08:34:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28190 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726562AbgDGMec (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 08:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586262871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TfvECcAWRcxfXpKI3PWwEQlcjFRStOQz8jHjDBJz+ic=;
        b=Xpx6BMrvOuys3jbvVzcF81AkevmGH05FhKHUCXVXllNUrfMn24wl2+E2FX6pWRVW2T/PFA
        jTHyWOnURuXEFTC7NZIX0bMqSOMybIRqGbFBfI36xfTA5sU/LuUk/iZWu2NOjaGBDpchI0
        SMmHOAubtLXqYS4UUASL+9D9Kvjf12Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-qLv_QnSGMwOkLcIePOk-dw-1; Tue, 07 Apr 2020 08:34:30 -0400
X-MC-Unique: qLv_QnSGMwOkLcIePOk-dw-1
Received: by mail-wr1-f72.google.com with SMTP id d1so1699935wru.15
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 05:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TfvECcAWRcxfXpKI3PWwEQlcjFRStOQz8jHjDBJz+ic=;
        b=LSUFTWM8FiG0itTjgPulllp3veI3M7hzOc7pyXCHbVk9P1cv4dL9oX+VKAkzCvwcGI
         MYa8LwpnnuiahXxCsS8adu/2XP+NiKDyz6tQUruJHi0YZHC/jEdnln+VrPH1VZk5e22K
         VR16ZeEL6su0+yWplDHOn9AefOswRUHNvfG0xlsUUS/ZdGLDLSNRefqWEISAMM0CyC3w
         PjZ9jE2gyA8VRmcq2BGkJ2GzJMJHvpYfbSWHwt6uuMFJj0efKauyaXTrL5vTftHmdLf2
         p6DlYsScTUMsMx9Adu5KkmKAQJtRC/hVgU1ZLvDIguOgT0EODzTci7GkjAycFjH8DseS
         XNgA==
X-Gm-Message-State: AGi0Pua1QvQxlwGDJ/mxcYHAEJEhsQmafE5HIW8EtM0Xzed/7RMsjTBL
        HXZF+1QnfkRD+qehu4FDrnTebV41uMLhWCMEC6QvI2MZrGeBRD0dhzDoGXP8RZx5RmpU5pcTheq
        pR2o0tgTXaSSe
X-Received: by 2002:a7b:c157:: with SMTP id z23mr2168402wmi.178.1586262869152;
        Tue, 07 Apr 2020 05:34:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypL8bzCcr/8mV3878eAIAzlhZ29BFvVRcleYPOt87SpSL4fEJ//M96BIuOmKEW8v4wpvRHjT5Q==
X-Received: by 2002:a7b:c157:: with SMTP id z23mr2168385wmi.178.1586262868931;
        Tue, 07 Apr 2020 05:34:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bd61:914:5c2f:2580? ([2001:b07:6468:f312:bd61:914:5c2f:2580])
        by smtp.gmail.com with ESMTPSA id o129sm2245808wma.20.2020.04.07.05.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 05:34:28 -0700 (PDT)
Subject: Re: [PATCH v3] KVM: X86: Filter out the broadcast dest for IPI
 fastpath
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1585815626-28370-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <59287b27-188b-6c97-9e48-8362d655df68@redhat.com>
Date:   Tue, 7 Apr 2020 14:34:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1585815626-28370-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/04/20 10:20, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Except destination shorthand, a destination value 0xffffffff is used to
> broadcast interrupts, let's also filter out this for single target IPI 
> fastpath.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * update subject and patch description
> 
>  arch/x86/kvm/lapic.c | 3 ---
>  arch/x86/kvm/lapic.h | 3 +++
>  arch/x86/kvm/x86.c   | 3 ++-
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e24d405..d528bed 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -59,9 +59,6 @@
>  #define MAX_APIC_VECTOR			256
>  #define APIC_VECTORS_PER_REG		32
>  
> -#define APIC_BROADCAST			0xFF
> -#define X2APIC_BROADCAST		0xFFFFFFFFul
> -
>  static bool lapic_timer_advance_dynamic __read_mostly;
>  #define LAPIC_TIMER_ADVANCE_ADJUST_MIN	100	/* clock cycles */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_MAX	10000	/* clock cycles */
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index bc76860..25b77a6 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -17,6 +17,9 @@
>  #define APIC_BUS_CYCLE_NS       1
>  #define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
>  
> +#define APIC_BROADCAST			0xFF
> +#define X2APIC_BROADCAST		0xFFFFFFFFul
> +
>  enum lapic_mode {
>  	LAPIC_MODE_DISABLED = 0,
>  	LAPIC_MODE_INVALID = X2APIC_ENABLE,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5e95950..5a645df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1559,7 +1559,8 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
>  
>  	if (((data & APIC_SHORT_MASK) == APIC_DEST_NOSHORT) &&
>  		((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
> -		((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
> +		((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
> +		((u32)(data >> 32) != X2APIC_BROADCAST)) {
>  
>  		data &= ~(1 << 12);
>  		kvm_apic_send_ipi(vcpu->arch.apic, (u32)data, (u32)(data >> 32));
> 

Queued, thanks.

Paolo

