Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FB87C8EE
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 18:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbfGaQkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 12:40:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37827 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729823AbfGaQkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 12:40:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so45345198wrr.4
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 09:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XI06jTjz4+2NKP2BFSy4p2nkfAb+YDjyBM/JZqjZVIM=;
        b=McljYvG+2UbvAfVUIOKVQABrsQvkxEJDvlYW9Vv5W+7qxIgRE6fmBMYW9a4t1ju2q1
         jGKyJTKl9ftO9b4sOwPCOYW0qdnW98TLNyHYCvWd1uGQuS8/3T6hMH1VCFQOP54CCfBK
         HMZKZQOWhpDIh/OEZEKYk8vata8rEiIoPdK11h0TOyzVp3lp4fcA+laNxPHawi48cZ5N
         eQKAIN3bd9eJtommR4oRcNfzreqgdGSwqJJjP6wB++002NfLB59ZiUn0zLqrDl0PgITj
         57NHgxYiEzgQW2gZn99jdK4x8BxNh1lX+PO4/3wLX1fYkMwq9yx1wK+2dPAWUoQEaYM7
         qAcw==
X-Gm-Message-State: APjAAAV5SYo5h4/muXXOK7dnjuLspi94OqZMxjDOoVeaVbGqeNgmExwl
        d6hbRjMIygSBbItsOJvHboPjW+HGYuo=
X-Google-Smtp-Source: APXvYqzGvsX8Ui9AnwLJ1T6O1kIB86uHMLmhVL+oWhIIY1U3ZwpCTgm/bsOd5xhk8P++HgN8/F2sNw==
X-Received: by 2002:adf:edd1:: with SMTP id v17mr50892863wro.348.1564591200457;
        Wed, 31 Jul 2019 09:40:00 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b19sm48840224wmj.13.2019.07.31.09.39.59
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 09:39:59 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: Don't need to wakeup vCPU twice afer timer fire
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1564572438-15518-1-git-send-email-wanpengli@tencent.com>
 <ab8f8b07-e3f9-4831-c386-0bfa0314f9c3@redhat.com>
 <87imri73dp.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a3c6d25e-8ede-695d-8f2d-632799c5fb1c@redhat.com>
Date:   Wed, 31 Jul 2019 18:39:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87imri73dp.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/19 15:14, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 31/07/19 13:27, Wanpeng Li wrote:
>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>
>>> kvm_set_pending_timer() will take care to wake up the sleeping vCPU which 
>>> has pending timer, don't need to check this in apic_timer_expired() again.
>>
>> No, it doesn't.  kvm_make_request never kicks the vCPU.
>>
> 
> Hm, but kvm_set_pending_timer() currently looks like:
> 
> void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
> {
> 	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
> 	kvm_vcpu_kick(vcpu);
> }

Doing "git fetch" could have helped indeed.

Paolo

