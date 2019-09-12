Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C19CB0D4C
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 12:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbfILKxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 06:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731301AbfILKxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 06:53:55 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E186B81DE7
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 10:53:54 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id r21so2440066wme.5
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 03:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=F2/22McNqXu2675zlE4drufzM0q9TuqFfPiUeK7sLs8=;
        b=jePvHcH/BhwbvvoWFnsuzdPH3GFRXaDtCPE3G3VH07LddV1NGd7NxCl77mE80W7IKs
         rBJd+0AGQoi30ZieEn6RZSy88tEaxsTk2jrL8Ukj3l5xoaNu4hbTBgW9lbX+vHmIMUda
         AM0+OjAev9aILbCiKbIg0koOTwnrc7JVJr245dbi+CzpS9rd/ZLllCP/PmPzTLvaBg21
         DY1+R34QHJz4UIjNTO+ZXYn+8oj9p5IjCxQsF8DSKC/Wbxt50SVEm00t48bKA8Lkt1Aa
         zpGcwhR4uejQtw02qTsWQXLbh8qZIDHTcIAnjMinUH4TUa3D/G3My8dMkQ7M5YDVtHMl
         yvaA==
X-Gm-Message-State: APjAAAW6Y5Xl2mESRws5I+VNrCAAxN+lH7sqG5vsQsrGRmZY5KuigjX3
        NXCcf9Xldyhhd/9l709hQ+yhe2K+pa5zHmQrW6G/OWii0Si3vQqcCI5JiLpN7OIWu5sM+REmjDA
        JxhQArU1IMVoi
X-Received: by 2002:adf:9c81:: with SMTP id d1mr18127705wre.123.1568285633423;
        Thu, 12 Sep 2019 03:53:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxxKcoyAmyDMGRGzHyI3ySQclYgNKAb2uu8KJpoZguHmsq7+ZolY8KGFJv9C6/WKJVkStMPqw==
X-Received: by 2002:adf:9c81:: with SMTP id d1mr18127684wre.123.1568285633189;
        Thu, 12 Sep 2019 03:53:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c132sm6786713wme.27.2019.09.12.03.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 03:53:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: work around leak of uninitialized stack contents
In-Reply-To: <CABXRUiTD=yRRQFfSdS=2e9QaO-PEgvZ=LBar927rL04G59nHxQ@mail.gmail.com>
References: <20190912041817.23984-1-huangfq.daxian@gmail.com> <87tv9hew2k.fsf@vitty.brq.redhat.com> <CABXRUiTD=yRRQFfSdS=2e9QaO-PEgvZ=LBar927rL04G59nHxQ@mail.gmail.com>
Date:   Thu, 12 Sep 2019 12:53:51 +0200
Message-ID: <87r24leqf4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fuqian Huang <huangfq.daxian@gmail.com> writes:

> Vitaly Kuznetsov <vkuznets@redhat.com> 於 2019年9月12日週四 下午4:51寫道：
>>
>> Fuqian Huang <huangfq.daxian@gmail.com> writes:
>>
>> > Emulation of VMPTRST can incorrectly inject a page fault
>> > when passed an operand that points to an MMIO address.
>> > The page fault will use uninitialized kernel stack memory
>> > as the CR2 and error code.
>> >
>> > The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ERROR
>> > exit to userspace;
>>
>> Hm, why so? KVM_EXIT_INTERNAL_ERROR is basically an error in KVM, this
>> is not a proper reaction to a userspace-induced condition (or ever).
>>
>> I also looked at VMPTRST's description in Intel's manual and I can't
>> find and explicit limitation like "this must be normal memory". We're
>> just supposed to inject #PF "If a page fault occurs in accessing the
>> memory destination operand."
>>
>> In case it seems to be too cumbersome to handle VMPTRST to MMIO and we
>> think that nobody should be doing that I'd rather prefer injecting #GP.
>>
>> Please tell me what I'm missing :-)
>
> I found it during the code review, and it looks like the problem the
> commit 353c0956a618 ("KVM: x86: work around leak of uninitialized
> stack contents (CVE-2019-7222)")
> mentions. So I fixed it in a similar way.
>

Oh, yes, I'm not against the fix at all, I was just wondering about why
you think we need to kill the guest in this case.

-- 
Vitaly
