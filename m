Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BA865E40
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 19:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfGKRMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 13:12:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39248 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbfGKRMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 13:12:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so7117411wrt.6
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 10:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jxtBFGrLM9ebJLyUflgxgAUhrlPh7lgx6/ntfyx9XO8=;
        b=AOJI0Yd4kgnlN3CCz0kHkMfje33Y2/coYNj9vp+2MvFNyBjsCq8IPme8e7UfXPKLKD
         +qpEqFEXEPwxwACqJhnp12focxKjStOSpQLD/+psZFr+SFWJ1zE+O9mWJtYahZXTDJh7
         Cw7F20VLqJ8Vn+4dwLTi3pzNcx+qj+2ckOmFFeI/YUWQgeKEftQLcCeghfecl1I0GHyO
         X64Ou+5I9O9Xs65DQUMNDg2CA7ijHQFsxIwmOAK8YRPT68m5YMkZirJDDq120YMaWk7M
         rKvHIG09OsupoW3RUm2BbBF1bqqKtbxKW5CXDEc5mBCGRHpdbrm+ELfb0fBDJ8ZG5DiR
         pGFw==
X-Gm-Message-State: APjAAAU0CO69RHV51RmEFHy++xs+cbZDGeVMLJ0jBZxPsQf8LsXfTBLd
        mb8iLEA3NP/zatq7+OE+0cL7GHZTxEo=
X-Google-Smtp-Source: APXvYqwz/aexZyXNB5ItnJK4ujGh9FOUDoat8ZBZvgm9Rop7VETOo2vYfNbEVE/0BZj02EvW3Avrjw==
X-Received: by 2002:a5d:62c1:: with SMTP id o1mr6244962wrv.293.1562865139278;
        Thu, 11 Jul 2019 10:12:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id u9sm5844898wrr.30.2019.07.11.10.12.18
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 10:12:18 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: PMU Event Filter
To:     Eric Hankland <ehankland@google.com>
Cc:     Wei Wang <wei.w.wang@intel.com>, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, kvm@vger.kernel.org
References: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
 <21fd772c-2267-2122-c878-f80185d8ca86@redhat.com>
 <CAOyeoRVrXjdywi-00ZafkVtEb_x6f5ZEmdMqq6v67XMedv_LKQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8c0502f4-64eb-3d34-1d76-a313b8f2f37a@redhat.com>
Date:   Thu, 11 Jul 2019 19:12:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAOyeoRVrXjdywi-00ZafkVtEb_x6f5ZEmdMqq6v67XMedv_LKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/19 19:04, Eric Hankland wrote:
> Thanks for your help. The "type"->"action" change and constant
> renaming sound good to me.

Good!  Another thing, synchronize_rcu is a bit slow for something that
runs whenever a VM starts.  KVM generally uses srcu instead (kvm->srcu
for things that change really rarely, kvm->irq_srcu for things that
change a bit more often).

Paolo

> On Thu, Jul 11, 2019 at 4:58 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 11/07/19 03:25, Eric Hankland wrote:
>>> - Add a VM ioctl that can control which events the guest can monitor.
>>
>> ... and finally:
>>
>> - the patch whitespace is damaged
>>
>> - the filter is leaked when the VM is destroyed
>>
>> - kmalloc(GFP_KERNEL_ACCOUNT) is preferrable to vmalloc because it
>> accounts memory to the VM correctly.
>>
>> Since this is your first submission, I have fixed up everything.
>>
>> Paolo

