Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE961D0B81
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 11:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbgEMJJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 05:09:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27993 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730677AbgEMJJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 05:09:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589360970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LkQRKl9tLygDVkb/DJW18fHZ9G4cW+Tv9HaEWtJVlFg=;
        b=S7zM8ArUeuJk+7MoaMAW0vq/F1073CDQGNpEQAQkVgEEUtwK7kYTx6FzYFvt6IZMvZRGB+
        +oaL4fgt5jcLf08LVxyJcAFKwtegF8bXbyikpcJW6zD792Oi03MnoRwm1JJaN2QlStl7it
        4Ckm8TdUtV46EfyF5YVV4y9wk/pUyDE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-RjFx8uD0NZaWEjlhnImaew-1; Wed, 13 May 2020 05:09:26 -0400
X-MC-Unique: RjFx8uD0NZaWEjlhnImaew-1
Received: by mail-wm1-f71.google.com with SMTP id h6so11357143wmi.7
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 02:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LkQRKl9tLygDVkb/DJW18fHZ9G4cW+Tv9HaEWtJVlFg=;
        b=kze9j9gmRFN9jFud9sOdVxhr4SJxbAU2q/aZMkOgB8XQe8R4f//Gv7yTX7K+gw94Xb
         akXrq3RRhRMeGCbS3OG4hHt6/YzKjstkGsh/Kvpme+5nKZWvJ24FYdZ9fllcD2LTaVwG
         TyhB/2I1RPO5IeOrWtcZotipmAEhVG6IrTTaUyAxG1ivOIRjmmiV+FWfj8Z6QAyJb8R9
         hgOQ8pm2ciciHhSSx+hjZNrFG2XTPz5sKdQ1i+IOEquasaSWal/z1FpMBmgHLZx3h3Nx
         t9db1JgnBwAIiReoMT14Q/RJFOfZ8N02UJMGxd/a7BY77Qp9736zKLxd0KzCzQJLiDPr
         rp4A==
X-Gm-Message-State: AGi0PuaH92HmfTTTtwdcm9mVKE7BhOZSRbwFa2R+aRyzgFxHs3jRP8fi
        qRoz1HqVpf8R1jEj5ClmPiDymI9QqAuc9XNOqsF8Gy5j+VBvkZLFwo0NNXOu3qIC2yhtPwjUfGA
        IVJBQU+uH0q1P
X-Received: by 2002:a1c:99d3:: with SMTP id b202mr43420408wme.126.1589360965710;
        Wed, 13 May 2020 02:09:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypIjv23QQ+2IFmFvDYhwD6Weh2biJtnHzNX52SF/bAHYC2OofdpyPGHaYJrzuFQpZNuwDeYLdw==
X-Received: by 2002:a1c:99d3:: with SMTP id b202mr43420381wme.126.1589360965486;
        Wed, 13 May 2020 02:09:25 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b145sm13059757wme.41.2020.05.13.02.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 02:09:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
In-Reply-To: <20200512175017.GC12100@linux.intel.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com> <20200511164752.2158645-3-vkuznets@redhat.com> <20200512152709.GB138129@redhat.com> <87o8qtmaat.fsf@vitty.brq.redhat.com> <20200512155339.GD138129@redhat.com> <20200512175017.GC12100@linux.intel.com>
Date:   Wed, 13 May 2020 11:09:23 +0200
Message-ID: <874kskmcak.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

>
> Why bother preserving backwards compatibility?  AIUI, both KVM and guest
> will support async #PF iff interrupt delivery is enabled.  Why not make
> the interrupt delivery approach KVM_ASYNC_PF_V2 and completely redefine the
> ABI?  E.g. to make it compatible with reflecting !PRESENT faults without a
> VM-Exit via Intel's EPT Violation #VE?
>

That's the plan, actually. 'page not present' becomes #VE and 'page
present' becomes an interrupt (we don't need to inject them
synchronously). These two parts are fairly independent but can be merged
to reuse the same new capability/CPUID.

-- 
Vitaly

