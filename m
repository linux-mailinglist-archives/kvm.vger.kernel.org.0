Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519A53B6724
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 18:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhF1Q7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 12:59:31 -0400
Received: from forward101p.mail.yandex.net ([77.88.28.101]:49479 "EHLO
        forward101p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231947AbhF1Q7a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 12:59:30 -0400
Received: from forward102q.mail.yandex.net (forward102q.mail.yandex.net [IPv6:2a02:6b8:c0e:1ba:0:640:516:4e7d])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id 68CAE3281BC3;
        Mon, 28 Jun 2021 19:57:03 +0300 (MSK)
Received: from vla5-9129714d0767.qloud-c.yandex.net (vla5-9129714d0767.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3609:0:640:9129:714d])
        by forward102q.mail.yandex.net (Yandex) with ESMTP id 639CA3A2000B;
        Mon, 28 Jun 2021 19:57:03 +0300 (MSK)
Received: from vla5-47b3f4751bc4.qloud-c.yandex.net (vla5-47b3f4751bc4.qloud-c.yandex.net [2a02:6b8:c18:3508:0:640:47b3:f475])
        by vla5-9129714d0767.qloud-c.yandex.net (mxback/Yandex) with ESMTP id jQjvdacNKU-v2HablTV;
        Mon, 28 Jun 2021 19:57:03 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624899423;
        bh=Rv4ZdFyZG7UCTZv1iOEuWU8C7r84bRSgRRVryBSHfE4=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=hhcf+Fc5gRRw6ywCBJhMz8JRz4bEpvr8w2w0VnFXHRZiFS2UJ0mwg5nFnOG3B48cw
         Amop9b/gWPWmQ4FCd8dpcpHOPw+fUSnUyZryUMGczMVKE5wCH4I1IKeG3LOBtr8Rej
         JRUShp87SOa2Ws+uBToHn+3VUXeZ/E3QC2AkFD0o=
Authentication-Results: vla5-9129714d0767.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-47b3f4751bc4.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 8Vo9wPZJma-v13ut8hj;
        Mon, 28 Jun 2021 19:57:01 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210627233819.857906-1-stsp2@yandex.ru>
 <87zgva3162.fsf@vitty.brq.redhat.com>
 <b3ee97c8-318a-3134-07c7-75114e96b7cf@yandex.ru>
 <87o8bq2tfm.fsf@vitty.brq.redhat.com>
 <b08399e2-ce68-e895-ed0d-b97920f721ce@yandex.ru>
 <87lf6u2r6v.fsf@vitty.brq.redhat.com>
 <17c7da34-7a54-017e-1c2f-870d7e2c5ed7@yandex.ru>
 <CALMp9eRJedCx6AMW+gMBMeMvGRzn6uzB0wtAzTDRLdYMB1Kc5Q@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <3e6c3da2-838e-5cf1-8d73-c59542a063b8@yandex.ru>
Date:   Mon, 28 Jun 2021 19:57:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRJedCx6AMW+gMBMeMvGRzn6uzB0wtAzTDRLdYMB1Kc5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

28.06.2021 19:39, Jim Mattson пишет:
> Yes, with shadow paging, kvm intercepts all guest page faults. You
> should be able to replicate this behavior on modern CPUs by adding
> "ept=N" to the kvm_intel module parameters.

Yes, that works as a reproducer
on a more modern CPUs.
Thanks!

