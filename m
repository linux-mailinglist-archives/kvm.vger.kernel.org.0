Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46F638F591
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 00:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhEXWXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 18:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhEXWXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 18:23:02 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6121EC061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:21:32 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id v19-20020a0568301413b0290304f00e3d88so26706130otp.4
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GDIQ9fX7lLs/gbyWNEU6V6HWzQKvLmHPZGiIasFlfRM=;
        b=oXVIQseLDoeABV/dp53lRn0giiPNZMb1SK5CpIaX74y8d+rhVsMtH4iNDvzelsXt3R
         MOphmVil/Eff+qNgr1AJf2R9XVwwslGTbNk4ZImOHcinCwCR/lQbNHoSex6Shrotkaqx
         UTRdl+JWDMyCfW4qxcBOfccdBPJm/3r3iM4M4PfqO3/z9nZf5YGj1a7+qA7nxXltUgpj
         CdP8U3jellankNmbaUC44RGRdP3EJo8OIzpfiB2nrzllD2u8PXBi3978tk9cD0cRNUM4
         67MJHJmxgqiHetnAA1coICZMbqJABK+RHME5mkwNzAl3q0s7XdhFEzs4sbP4A4/A4zcw
         hz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GDIQ9fX7lLs/gbyWNEU6V6HWzQKvLmHPZGiIasFlfRM=;
        b=Cw/I6I5dg41+hfLrCN70wQ2UGrva00D08vpgBJ8nPjRNeLSDuaMLDeju9OORr9bDc9
         Fh7a/04aa0c1mBAowIA9oxwoWV7JEiLjFwJwiHGj0ZTnWKtPFtGXDJDzL49Hj+linLIM
         DGOLrZFsTzJflc6R93kwkqPM+W2Plnbl9LDww5Q8AU3PvLkT3G9eYvn2NBo5sF35LNuS
         hz3avixyDE9KiQcuF28jMHYxlGA5Jrag4AAFy9rqgnQR4iHS5ixcN0v8nfP3TaXuHL8H
         yyV9wdg63+6cBJf9SHsdeOXw/nlFx5F3e82/xvze6EfYizftuQ68JhEZYbC6Ib6MGg7l
         jU+w==
X-Gm-Message-State: AOAM532btXctgx0uZsTHMGFv23nRnk3sNvKqmPO7+FAfm2HTVB7R2BJb
        KlJjDuBZWpuofmm+BFsE2ccN5kzFoK3jR/eDAP9Wog==
X-Google-Smtp-Source: ABdhPJziySXZk11WNjyzRJ6zXrXwgIiDyYvJ5+F9SVg/TMDZkrwooR7ggFmvjnEhHj4wAhfq3lTsk2Unh3rxK7khctU=
X-Received: by 2002:a9d:5786:: with SMTP id q6mr20800952oth.56.1621894891564;
 Mon, 24 May 2021 15:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-43-seanjc@google.com>
 <e2974b79-a6e5-81be-2adb-456f114391da@redhat.com>
In-Reply-To: <e2974b79-a6e5-81be-2adb-456f114391da@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 15:21:20 -0700
Message-ID: <CALMp9eT72keN2r9tfdzsPpzAkV9fN4V4edmXuPyMbt+shVu0Ww@mail.gmail.com>
Subject: Re: [PATCH 42/43] KVM: VMX: Drop VMWRITEs to zero fields at vCPU RESET
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 2:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/04/21 02:46, Sean Christopherson wrote:
> > Don't waste time writing zeros via VMWRITE during vCPU RESET, the VMCS
> > is zero allocated.
>
> Is this guaranteed to be valid, or could the VMCS in principle use some
> weird encoding? (Like it does for the access rights, even though this
> does not matter for this patch).

I see nothing in the SDM that would indicate that zero must be encoded as zero.
