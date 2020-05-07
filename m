Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22411C9E82
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 00:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgEGWeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 18:34:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44273 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726437AbgEGWeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 18:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588890843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6LcYSbiruJMZTX1IqqyKZmdj0QYBFKURVtqzLOdhOY=;
        b=Uac6jTYDPVjtWNahue/vlZbG3UlFqh7KCKAuRuz1b1Ritqc6lWgW1wtPUfh1BL72hPERwu
        tIb8hfwPxyAJPOzrZm86EuTG+MJft+N/EPQp85prJuPK4gzmsFsGSors0XFjVnrnmjR+qr
        hfbRZ1XUvMgFH/THBKwxry99Ibm8RdI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-r0dHcoD_P1SY_-SV-BN2UQ-1; Thu, 07 May 2020 18:34:00 -0400
X-MC-Unique: r0dHcoD_P1SY_-SV-BN2UQ-1
Received: by mail-wr1-f72.google.com with SMTP id x8so4258595wrl.16
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 15:33:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m6LcYSbiruJMZTX1IqqyKZmdj0QYBFKURVtqzLOdhOY=;
        b=bb4SJKzzftEPXKMxfWa5I1cITdDP881jKHeXRovOsZb7e1R4W18q766d5oCpqsMflW
         +HL/pxNeYcd95qPXRlJ55cqO/CGHnY6kltJPWUcdE0N5pDjRU1uOnAj4GEYKbT8DtKoc
         FZjc0kozzDDRs8GwmomwoqN+uPaYrh1Cx7N+RdvNWCJ37Iaw2v+RmTMdLXlX8nT/moE+
         aS7I8TSYfxuO2eaesdlz8rUJKkGW10l1gz3+0357XJ6uqGJegDGHKXtv7AN+IfuBcJQe
         sw9bKNe5z56GgabF+gmgS1AbERLr7by5y8MTlYRA+y+uPoJAp6GAGLHXy/uUbKjO3Lb6
         p0gA==
X-Gm-Message-State: AGi0PuYq0r/oMmJJJYIJ1yqFjvAK7eWyV3ucQGGe51z+sxvxDhfM/FUB
        GXf4Dt36B4uKGErFdWI7jtrr1W+6KEZeCqcNTkq2xcZqD0oRrdiP3zFljIqUk258/JYmklsi8/f
        LyZYiQH8x4QUM
X-Received: by 2002:a1c:9d0d:: with SMTP id g13mr13257316wme.102.1588890838734;
        Thu, 07 May 2020 15:33:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypJFQjWpHKrGVTS42cCRtRce69jHzd8zAhp5V7FZjYl/ngImOnPRxZo7IHJfA8JrWwI+PbW5UA==
X-Received: by 2002:a1c:9d0d:: with SMTP id g13mr13257293wme.102.1588890838456;
        Thu, 07 May 2020 15:33:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8d3e:39e5:cd88:13cc? ([2001:b07:6468:f312:8d3e:39e5:cd88:13cc])
        by smtp.gmail.com with ESMTPSA id t17sm9481511wro.2.2020.05.07.15.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 15:33:58 -0700 (PDT)
Subject: Re: [PATCH v2 8/9] KVM: x86, SVM: isolate vcpu->arch.dr6 from
 vmcb->save.dr6
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-9-pbonzini@redhat.com> <20200507192808.GK228260@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dd8eb45b-4556-6aaa-0061-11b9124020b1@redhat.com>
Date:   Fri, 8 May 2020 00:33:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507192808.GK228260@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/20 21:28, Peter Xu wrote:
>> -	svm->vcpu.arch.dr6 = dr6;
>> +	WARN_ON(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT);
>> +	svm->vcpu.arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
>> +	svm->vcpu.arch.dr6 |= dr6 & ~DR6_FIXED_1;
> I failed to figure out what the above calculation is going to do... 

The calculation is merging the cause of the #DB with the guest DR6.
It's basically the same effect as kvm_deliver_exception_payload. The
payload has DR6_RTM flipped compared to DR6, so you have the following
simplfications:

	payload = (dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
	/* This is kvm_deliver_exception_payload: */
        vcpu->arch.dr6 &= ~DR_TRAP_BITS;
        vcpu->arch.dr6 |= DR6_RTM;
	/* copy dr6 bits other than RTM */
        vcpu->arch.dr6 |= payload;
	/* copy flipped RTM bit */
        vcpu->arch.dr6 ^= payload & DR6_RTM;

->

	payload = (dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
	/* clear RTM here, so that we can OR it below */
        vcpu->arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
	/* copy dr6 bits other than RTM */
        vcpu->arch.dr6 |= payload & ~DR6_RTM;
	/* copy flipped RTM bit */
        vcpu->arch.dr6 |= (payload ^ DR6_RTM) & DR6_RTM;

->

	/* we can drop the double XOR of DR6_RTM */
	dr6 &= ~DR6_FIXED_1;
        vcpu->arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
        vcpu->arch.dr6 |= dr6 & ~DR6_RTM;
        vcpu->arch.dr6 |= dr6 & DR6_RTM;

->

	/* we can do the two ORs with a single operation */
        vcpu->arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
        vcpu->arch.dr6 |= dr6 & ~DR6_FIXED_1;

> E.g., I
> think the old "BT|BS|BD" bits in the old arch.dr6 cache will be leftover even
> if none of them is set in save.dr6, while we shouldn't?

Those bits should be kept; this is covered for example by the "hw
breakpoint (test that dr6.BS is not cleared)" testcase in kvm-unit-tests
x86/debug.c.

Thanks,

Paolo

