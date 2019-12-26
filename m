Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F54012A9D6
	for <lists+kvm@lfdr.de>; Thu, 26 Dec 2019 03:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfLZCfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Dec 2019 21:35:22 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44093 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLZCfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Dec 2019 21:35:22 -0500
Received: by mail-ot1-f66.google.com with SMTP id h9so28265396otj.11;
        Wed, 25 Dec 2019 18:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wFW6PwbhpwDHaE85ZcsN3eRZyhhib4+0nJ3fxwBkdbQ=;
        b=s17YA35ez9d8oUT+5ziW2uwqnJZChzC2qjILhPLVrrr/W66l4jWJ4NtZlpatnZ7pq6
         RZiXcd5CoW5OIxEcpjbLJ8M5b/EO/CUbGinvNb+HG3lqSRhHigsIFA4YhdTbgmmWNzAX
         4fTRcKQD+SEFXBSz+WzxVfHxBkReFcIzvt1iP4s3xxWaGnuV/t7Z6FlvLHWzQsrKzs6V
         0qjrxkspMs87NIsqAR+zCQrrIFXBogAfQ6IPBhHfJTyW31e6KV4WCVJryY8orNT4Xsy4
         xzFtNagzYJ1INykIzBlMf85YX+ZGuijJ3iEUzf/hlYJy/RO2sBozaBb5Vjh1FVvNDWwo
         J7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wFW6PwbhpwDHaE85ZcsN3eRZyhhib4+0nJ3fxwBkdbQ=;
        b=hAYD1/tSZruxEdLHoJnxgJ+Eam6ZRoYiuSTPl5tlz2/KVywfX1iPnd0CQUCprESKD7
         0gboVF3i6ofzifTNIlU+FuB8W/EIqLZPkfLvX840BsTl8WMHa7/bDJ1u5rUzYQW+WE32
         lZWUW8V1n8o/j8ZQ7Dn0kWvtYmwx53x1lQW7U8QukRFjdy49tfbgY+imuScQC0+CePlY
         7dylBJrT4WGpceZgNDEX5cXsA3W9cDw+SqHsuivSs0kH71lFRrVhhiH/oxFd7ZK1uIyH
         q3ktxHVwfKSItzetVSgSiCz9qER/aTudALkt0hNOEyeAFxK5cV24PjggnwNKsKc09iJ1
         jyYQ==
X-Gm-Message-State: APjAAAXGuvcRleieqYhgjU1YrddORlJIesHuV4Rloll9yVbDKvZbLvZG
        G+XF+n6cv0JsqETFFPydavD35/N176h4KTfRln8=
X-Google-Smtp-Source: APXvYqzjQ9A4fSZzWSQxhzMu/0DJgsol6AAfnQuDXNE+o0GkXwGevSZyeXV8daR4RwyxU5KmhpiLHYiJj//zCdFAWuo=
X-Received: by 2002:a9d:3f61:: with SMTP id m88mr31944549otc.56.1577327721351;
 Wed, 25 Dec 2019 18:35:21 -0800 (PST)
MIME-Version: 1.0
References: <5744632b88b44369a68c0b0704bfb48e@huawei.com>
In-Reply-To: <5744632b88b44369a68c0b0704bfb48e@huawei.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 26 Dec 2019 10:35:10 +0800
Message-ID: <CANRm+Cx0LUkJZc4Y-cNenKB=SURSMQKDNjp0EoRQo2QQJV7SzA@mail.gmail.com>
Subject: Re: [PATCH] KVM: nvmx: retry writing guest memory after page fault injected
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Dec 2019 at 10:32, linmiaohe <linmiaohe@huawei.com> wrote:
>
> Hi,
>
> Liran Alon <liran.alon@oracle.com> wrote:
> >> On 25 Dec 2019, at 4:21, linmiaohe <linmiaohe@huawei.com> wrote:
> >>
> >> From: Miaohe Lin <linmiaohe@huawei.com>
> >>
> >> We should retry writing guest memory when
> >> kvm_write_guest_virt_system() failed and page fault is injected in handle_vmread().
> >>
> >> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> >
> >Patch fix seems correct to me:
> >Reviewed-by: Liran Alon <liran.alon@oracle.com>
>
> Thanks for your review.
>
> >However, I suggest to rephrase commit title & message as follows:
> >
> >"""
> >KVM: nVMX: vmread should not set rflags to specify success in case of #PF
> >
> >In case writing to vmread destination operand result in a #PF, vmread should not call nested_vmx_succeed() to set rflags to specify success. Similar to as done in for VMPTRST (See handle_vmptrst()).
> >"""
>
> Thanks for your sueestion, I would rephrase commit title & message accordingly.
>
> >
> >In addition, it will be appreciated if you would also submit kvm-unit-test that verifies this condition.
>
> I'd like to submit kvm-unit-test that verifies this condition, but I am not familiar with the kvm-unit-test code yet and
> also not in my recent todo list. So such a patch may come late. It would be appreciated too if you could submit this
> kvm-unit-test patch. :)

Hmm, did you verify your own patch? Please give the testcase.
