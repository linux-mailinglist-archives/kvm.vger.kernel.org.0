Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A406BF96
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 18:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfGQQ1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 12:27:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38198 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfGQQ1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 12:27:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so25519290wrr.5
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2019 09:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=77LfX5TBrAXvTY65lk0+TDDEXR8yxc8w01mcbTPv8w8=;
        b=r+clgKCXB4e2Cz8Rw7zNmdlya/gTVDWSZvg23LGDyM6ebGpXOv6Na7+wMWVDMFJ72S
         BweTMdXmdBD9quJvSQ4nYjV4mmDm1XtLldB9ln9eFdafRcbwZKvyHz6eq0qaIXvEWwfr
         c7ahEvNmSOLyUL0z74OATqvLld/8iFa4hPaa2amzy2qMkTl45WHeBNjekX2m0ahBh+6M
         oLW8JqqDx2RzcVbeGQ8bix0Y0K20aPTKyL256gemt6KQ9gCfvemE1nr3BpBTKx4S8Vhk
         W2EEbz/NA9INSTNjVR/DYXldyMEpRmMILB8jdSwrn+aMmW/xHdJKkx4R+KyjIjG73fkU
         sj1g==
X-Gm-Message-State: APjAAAUqkLk5rNZVWOdyGYRcRG/NU52bC686J/bkfGB5llloADYWxAk+
        N0HBKAt6r0C/negakrQiMlH0rA==
X-Google-Smtp-Source: APXvYqwM9ov3nYMPI5jYiMjqrCSzPDsPtgILq6tjd7jCtMRTyA7mtJXiXg+g9/ZGRFcts9g5h4rzJQ==
X-Received: by 2002:a5d:5452:: with SMTP id w18mr5278577wrv.327.1563380824795;
        Wed, 17 Jul 2019 09:27:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id e19sm33590007wra.71.2019.07.17.09.27.03
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 09:27:04 -0700 (PDT)
Subject: Re: [PATCH v7 2/2] KVM: LAPIC: Inject timer interrupt via posted
 interrupt
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <1562376411-3533-1-git-send-email-wanpengli@tencent.com>
 <1562376411-3533-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e8bc7f76-28e0-6c02-5cf2-bb1015a0d0db@redhat.com>
Date:   Wed, 17 Jul 2019 18:27:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562376411-3533-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/19 03:26, Wanpeng Li wrote:
> +
> +void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> +{
> +	if (!lapic_timer_int_injected(vcpu))
> +		return;
> +
> +	__kvm_wait_lapic_expire(vcpu);
> +}
>  EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);

I changed this to

	if (lapic_timer_int_injected(vcpu))
		__kvm_wait_lapic_expire(vcpu);

and queued the two patches.

Paolo
