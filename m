Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323552C5B43
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 19:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391625AbgKZSA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 13:00:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391576AbgKZSA2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 13:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606413626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9eqzauhwraV3oZHcm0FAXnvM9iPp+cElSs8/Pnc2lFQ=;
        b=aZ3NTGzbGH4IQ1kqIh0QBcMWS3jd4QHQxigRSoYP+z6+RE1K0TQwLeGpIBtMiBFcaAaw4F
        ybFeqTzYmdOo3RKWnQXyu5/Yf2AaBMoASwSrCbgw7rYK+wpBaOTpl+Q+Ez4Ae1yCFWq92f
        0zGlzJxgDpUnDcpeGVKwl8z4qZIqamg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-ZRQDqRp4PLqMAa9X4hAVbQ-1; Thu, 26 Nov 2020 13:00:24 -0500
X-MC-Unique: ZRQDqRp4PLqMAa9X4hAVbQ-1
Received: by mail-wr1-f71.google.com with SMTP id p18so1639166wro.9
        for <kvm@vger.kernel.org>; Thu, 26 Nov 2020 10:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9eqzauhwraV3oZHcm0FAXnvM9iPp+cElSs8/Pnc2lFQ=;
        b=sMf0ahSzuihbwa8JmIPn57spWslF9OOmyUSrlfMKj/x5mC2fTh1apJRSQGMOe78Qm8
         9h6dPZO9SD7PykT2ExI7fL0UPteI4aJDo1Legq+F6EOV3Z6ZMzUGBFoiz0BQAHHIyvlj
         ivJFxS3DkR/YzdQSc9XwZCnAye3oK3XKXFI/g0iEPErZf670+hdB8sjZkxDgk8yZ9xNh
         rdod6/4b9kgTH7JhTp6/hox1cRoNYCCQFxydwJwCrHjDpU29G9KOCxAAd+S/6dejzTgm
         uYgoDl//ZQK/3ac5ORlMa4fk83+1t3Nim4oiFhstXboS2uFUNy+6BUDKXiUBcwGIXWbt
         eiyw==
X-Gm-Message-State: AOAM530Ewr3luRQyg+6pyM8qgsM0HVcnVliOXNyxi92c4zKANnfIWwg8
        m6gy1ZfTI7D2rg52U8OB7LGeUXE4W7yIVHwq2tlEYdWArBCEOiC4tpEB3U1iU1Hxvgse7/fWHB3
        0p/MCXq12+Tck
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr4703870wmi.88.1606413622935;
        Thu, 26 Nov 2020 10:00:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFYyNogoh7FlgXmEd/InjydVgr6FEXfAkCPVzY9KW1IPdPkb4WLfnarAcbSJsnpqzI8tlXYA==
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr4703844wmi.88.1606413622668;
        Thu, 26 Nov 2020 10:00:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id x4sm10199100wrv.81.2020.11.26.10.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 10:00:21 -0800 (PST)
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>, "Sironi, Filippo" <sironi@amazon.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Matt Gingell <gingell@google.com>,
        Steve Rutherford <srutherford@google.com>, liran@amazon.com
References: <62918f65ec78f8990278a6a0db0567968fa23e49.camel@infradead.org>
 <017de9019136b5d2ec34132b96b9f0273c21d6f1.camel@infradead.org>
 <20201125211955.GA450871@google.com>
 <99a9c1dfbb21744e5081d924291d3b09ab055813.camel@infradead.org>
 <6a8897917188a3a23710199f8da3f5f33670b80f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm/x86: Fix simultaneous ExtINT and lapic interrupt
 handling with APICv
Message-ID: <e71a7296-810a-cb73-8d34-cd96391750eb@redhat.com>
Date:   Thu, 26 Nov 2020 19:00:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <6a8897917188a3a23710199f8da3f5f33670b80f.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/11/20 13:05, David Woodhouse wrote:
> |It looks like this was introduced in commit 782d422bcaee, when 
> dm_request_for_irq_injection() started returning true based purely on 
> the fact that userspace had requested the interrupt window, without heed 
> to kvm_cpu_has_interrupt() also being true. |

That patch had no semantic change, because 
dm_request_for_irq_injection() was split in two and the problematic bit 
was only split to kvm_vcpu_ready_for_interrupt_injection().

Even pre-patch there was a

	if (kvm_cpu_has_interrupt(vcpu))
		return false;

in dm_request_for_irq_injection() which your patch would have changed to

	if (lapic_in_kernel(vcpu) && kvm_cpu_has_extint(vcpu))
		return false;

Your patch certainly works, but _what_ does

		!(lapic_in_kernel(vcpu) && kvm_cpu_has_extint(vcpu)) &&
  		kvm_cpu_accept_dm_intr(vcpu)

mean in terms of the vcpu's state?  I have no idea, in fact at this 
point I barely have an idea of what 
kvm_vcpu_ready_for_interrupt_injection does.  Let's figure it out.


First act
~~~~~~~~~

First of all let's take a step back from your patch.  Let's just look at 
kvm_cpu_has_interrupt(vcpu) and trivially remove the APIC case from 
kvm_cpu_has_interrupt:

+static bool xxx(struct kvm_vcpu *vcpu)
+{
+	WARN_ON(pic_in_kernel(vcpu->kvm));
+	if (!lapic_in_kernel(vcpu))
+		return vcpu->arch.interrupt.injected;
+	else
+		return kvm_cpu_has_extint(vcpu);
+}

  	return kvm_arch_interrupt_allowed(vcpu) &&
-		!kvm_cpu_has_interrupt(vcpu) &&
  		!kvm_event_needs_reinjection(vcpu) &&
+		!xxx(vcpu) &&
  		kvm_cpu_accept_dm_intr(vcpu);

Again, no idea does "xxx" do, much less its combination with 
kvm_cpu_accept_dm_intr.  We need to dive further down.


Second act
~~~~~~~~~~

kvm_cpu_accept_dm_intr can be rewritten like this:

         if (!lapic_in_kernel(vcpu))
		return true;
	else
                 return kvm_apic_accept_pic_intr(vcpu));

Therefore, we can commonize the "if"s in our xxx function with those 
from kvm_cpu_accept_dm_intr.  Remembering that the first act used the 
negation of xxx, the patch now takes this shape

+static int yyy(struct kvm_vcpu *vcpu)
+{
+	WARN_ON(pic_in_kernel(vcpu->kvm));
+	if (!lapic_in_kernel(vcpu))
+		return !vcpu->arch.interrupt.injected;
+	else
+		return (!kvm_cpu_has_extint(vcpu) &&
+			kvm_apic_accept_pic_intr(vcpu));
+}

  	return kvm_arch_interrupt_allowed(vcpu) &&
-		!kvm_cpu_has_interrupt(vcpu) &&
  		!kvm_event_needs_reinjection(vcpu) &&
- 		kvm_cpu_accept_dm_intr(vcpu);
+		yyy(vcpu);

This doesn't seem like progress, but we're not done...


Third act
~~~~~~~~~

Let's look at the arms of yyy's "if" statement one by one.

If !lapic_in_kernel, the return statement will always be true because 
the function is called under !kvm_event_needs_reinjection(vcpu).  So 
we're already at

static int yyy(struct kvm_vcpu *vcpu)
{
	WARN_ON(pic_in_kernel(vcpu->kvm));
	if (!lapic_in_kernel(vcpu))
		return true;
	
	return (!kvm_cpu_has_extint(vcpu) &&
		kvm_apic_accept_pic_intr(vcpu));
}

As to the "else" branch, irqchip_split is true so 
kvm_cpu_has_extint(vcpu) is "kvm_apic_accept_pic_intr(v) && 
pending_userspace_extint(v)".  More simplifications ahead!

	!(A && B) && A
     =>  (!A || !B) && A
     =>  A && !B

that is:

static int yyy(struct kvm_vcpu *vcpu)
{
	WARN_ON(pic_in_kernel(vcpu->kvm));
	if (!lapic_in_kernel(vcpu))
		return true;
	
	return (kvm_apic_accept_pic_intr(vcpu) &&
		!pending_userspace_extint(vcpu));
}

which makes sense: focusing on ExtINT and ignoring event reinjection 
(which is handled by the caller), the vCPU is ready for interrupt 
injection if:

- there is no LAPIC (so ExtINT injection is in the hands of userspace), or

- PIC interrupts are being accepted, and userspace's last ExtINT isn't 
still pending.

Thus, the final patch is:

  static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
  {
+	WARN_ON(pic_in_kernel(vcpu->kvm));
+
  	return kvm_arch_interrupt_allowed(vcpu) &&
-		!kvm_cpu_has_interrupt(vcpu) &&
  		!kvm_event_needs_reinjection(vcpu) &&
-		kvm_cpu_accept_dm_intr(vcpu);
+		(!lapic_in_kernel(vcpu)
+		 || (kvm_apic_accept_pic_intr(vcpu)
+		     && !pending_userspace_extint(v));
  }

I'm wondering if this one fails as well...

Paolo

