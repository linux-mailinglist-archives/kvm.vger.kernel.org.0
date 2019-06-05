Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330A535CE0
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 14:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfFEMay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 08:30:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33733 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfFEMay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 08:30:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so6841018wru.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2019 05:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LbP+4Vhj30bq0+PmaAtLxhYGOHZkRbouhUMM/rlGAio=;
        b=EKaWdpwsZpiRJTHJF2D7saPY/rR5f3r8j0bIJQ6/0uPYdkcENLiZSHmBMAf419E+LT
         EpSaITMSTYWYduWU2PM46RSWyjbP1sgnDQx/eGQ6dLRmY4YcF0GWj9ioFwKh3bEIyqQe
         w6iM5YsYGfHwejKPGFIl/xmF8Ean91AkPmExtrcszykkgrnI+R6zi/h6mtUNRmktIGT2
         lA/n2nOGOoDY/jClg2tNg+cchPM1+ARhuGUWAG1z0SQLI1Pi05SxqHtJaTLbRG7QjDLd
         JRQosTtQ0i5lCeq51o8wIy22dw/BaciqoJkUyQO2iUKyvkJhZZ6XuTCt/zmIV0HWPy9y
         evvQ==
X-Gm-Message-State: APjAAAVo9ra10xNRQfVlW2heOJKmekyOaFzK4xkAMdgZ1DPRT5UVpyru
        3zz/Esj9oCPVyry7ph5UZWf6JQ==
X-Google-Smtp-Source: APXvYqyvlm5M1bXcrn9GAlNkvwvBbkHrjifqtLlqk0RswqV2sJBC5ghNSb7uw+F4oxs2+AXkRoYKuQ==
X-Received: by 2002:adf:a18a:: with SMTP id u10mr2661650wru.351.1559737853018;
        Wed, 05 Jun 2019 05:30:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id j15sm10149112wrn.50.2019.06.05.05.30.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 05:30:52 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: LAPIC: lapic timer is injected by posted
 interrupt
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
 <1559729351-20244-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <16c54182-7198-f476-080b-5876cd871e42@redhat.com>
Date:   Wed, 5 Jun 2019 14:30:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559729351-20244-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/19 12:09, Wanpeng Li wrote:
> +static void apic_timer_expired_pi(struct kvm_lapic *apic)
> +{
> +	struct kvm_timer *ktimer = &apic->lapic_timer;
> +
> +	kvm_apic_local_deliver(apic, APIC_LVTT);
> +	if (apic_lvtt_tscdeadline(apic))
> +		ktimer->tscdeadline = 0;
> +	if (apic_lvtt_oneshot(apic)) {
> +		ktimer->tscdeadline = 0;
> +		ktimer->target_expiration = 0;
> +	}
> +}

Please rename this function to kvm_apic_inject_pending_timer_irqs and
call it from kvm_inject_apic_timer_irqs.

Then apic_timer_expired can just do

        if (atomic_read(&apic->lapic_timer.pending))
                return;

+	if (unlikely(posted_interrupt_inject_timer(apic->vcpu))) {
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}

etc.

Paolo
