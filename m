Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C178F7C30D
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 15:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387911AbfGaNON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 09:14:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33335 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfGaNOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 09:14:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so1287563wme.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 06:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gz31ZtEBBBh4AY8YF3Nce0ldeOIawCcKF5dsmgirTKo=;
        b=FNhacp34nfSHzyFiO2rXRbUIXaAJhb9YaV4azr1SG/9rGjmicQlaQAooavVwEOTL/O
         iCQh6UbNK95UoTbbG9NG6g6JqQOsjxc61CtgsYcwIpiGLLoYxP4Nr+qbrVCyf47kzA97
         mwu9uC5C2Wy74qRO9XE6LQlLpChMCRZtk1cFHBeC/B4Ps6DEq9peogVYplWHmtAF8r9I
         jSfwUaEXcuegE3FKax3L9963eXEl29erTKLH9y9htrNwhdYBBz3XpoeCFl2YJZgvb+QH
         vPSx9uLvhcNUtfxZsROGSJFvWKzeh7xKt6XNGNVEbg+l5pItc40VTLZhzfeyG8G4xpbR
         f98Q==
X-Gm-Message-State: APjAAAXenAG3m1N9UUQzpWGEYNcMgqt7SkHK/8mq82xqpi5al/Sk8OPg
        wxBSDQDfOjTeIAkz2yaSCagrG2P/nKw=
X-Google-Smtp-Source: APXvYqzxyOAmJaEAf18YC/3zT9FnwwJPz0gNcTInqH52EdUefytW35XXucNbuuGattNqfWtufLo2xQ==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr6120739wmg.135.1564578851424;
        Wed, 31 Jul 2019 06:14:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b8sm62215395wrr.43.2019.07.31.06.14.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 06:14:10 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: Don't need to wakeup vCPU twice afer timer fire
In-Reply-To: <ab8f8b07-e3f9-4831-c386-0bfa0314f9c3@redhat.com>
References: <1564572438-15518-1-git-send-email-wanpengli@tencent.com> <ab8f8b07-e3f9-4831-c386-0bfa0314f9c3@redhat.com>
Date:   Wed, 31 Jul 2019 15:14:10 +0200
Message-ID: <87imri73dp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 31/07/19 13:27, Wanpeng Li wrote:
>> From: Wanpeng Li <wanpengli@tencent.com>
>> 
>> kvm_set_pending_timer() will take care to wake up the sleeping vCPU which 
>> has pending timer, don't need to check this in apic_timer_expired() again.
>
> No, it doesn't.  kvm_make_request never kicks the vCPU.
>

Hm, but kvm_set_pending_timer() currently looks like:

void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
{
	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
	kvm_vcpu_kick(vcpu);
}

-- 
Vitaly
