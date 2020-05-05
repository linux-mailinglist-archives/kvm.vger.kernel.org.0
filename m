Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D481C606E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 20:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgEEStw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 14:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEEStv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 14:49:51 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FD4C061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 11:49:51 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so2701876iob.3
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 11:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25DNXBEo9mxNWn6NxcAV3IwfSkfCUfjgs/WrJpbKFYI=;
        b=YwXqNCxDTXEMAxsGRi0KUOTeISgCUQlPxcpcBBVeZ5dIDnC4kLxqO1Vrr2Wqwjg7mH
         cm9WKt6zk7E+ODBVQS5G8TNJHiwL+H13gseJirCooUY/57lggtEvsB53FninbUfefV7D
         RmuNZIR2paEbhbkS6Eih3+0/X4lyVleS6w2HC7L2mx/mVDFSQlfTggItqfuZzpewMdtw
         R+EpJjU2DkyqmQRwktXOtw7bz4CBXHFHkX3sM34uDQ9pZ6oiYoqYz6Ea4McOhUBe9ZJX
         F0kUZcDoqiYRkVsUaW+lOup2zQwnadm0ezfKk3IZU3KGJPzyWEW5+v7yghk8JkApUl4r
         HFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=25DNXBEo9mxNWn6NxcAV3IwfSkfCUfjgs/WrJpbKFYI=;
        b=W2UfK3xTW/qlvVkLrJRl629hX7tT1Pc+vbj8QHNFIY3+mcBqE/1u4y3MCEwu2hGzBc
         LIYrOn1nXwk0JWhh0PcPIjYlsjqKFyHBjWt8GYO7OTbdCZHlly+uQIM9/5aQcec1OCZj
         jAVH8rYbb5kV+e/J6N3J0PSJa7BvtUgdMkTaX/ZFN2H0gngqYaGv8jiLJHLvk+UWNdBO
         2O+7EK1HlK+JNGHM/nBxtVBEdF5/ZFglKLxvcvEtN5UJLBPAS5zGfDwbfZ9HbbvhAzL6
         st8Mv9SXemzC/Fp5EBLaNs4bilCyd4v+P3pi4vCmI40cwiX7EL08rqD8+CNjCrXLaxJt
         69/Q==
X-Gm-Message-State: AGi0PuYgoIPqb6wNQhceCfHUMbS55WhAZJ6jP/0TuPwQX/cPJL49JLz6
        d9mRqOVIgJh6wAzXlkHuJWPUoUAIGgXrYwvSmjr9gQ==
X-Google-Smtp-Source: APiQypJNCD0h0iuMHFgfvXcd238NjYPVZLtz5aO1TdS4cVgkrYEYX2J9B64+CjKPpcNNzjpaqWAtRTLmQu3//94thco=
X-Received: by 2002:a6b:c910:: with SMTP id z16mr4793739iof.164.1588704589972;
 Tue, 05 May 2020 11:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200501185147.208192-1-yuanyu@google.com> <20200501185147.208192-2-yuanyu@google.com>
 <20200501204552.GD4760@linux.intel.com> <49fea649-9376-f8f8-1718-72672926e1bf@oracle.com>
In-Reply-To: <49fea649-9376-f8f8-1718-72672926e1bf@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 5 May 2020 11:49:38 -0700
Message-ID: <CALMp9eSr4J70G1PGqiAoxA9RCeR-N_FcLeJgXMr8AbtFCVKc7Q@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add KVM_HC_UCALL hypercall
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 1, 2020 at 6:05 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
> On 01/05/2020 23:45, Sean Christopherson wrote:
> > Off the top of my head, IO and/or MMIO has a few advantages:
> >
> >    - Allows the guest kernel to delegate permissions to guest userspace,
> >      whereas KVM restrict hypercalls to CPL0.
> >    - Allows "pass-through", whereas VMCALL is unconditionally forwarded to
> >      L1.
> >    - Is vendor agnostic, e.g. VMX and SVM recognized different opcodes for
> >      VMCALL vs VMMCALL.
> I agree with all the above (I believe similar rational had led VMware to
> design their Backdoor PIO interface).

Just to set the record straight...

VMware's backdoor PIO interface predates both VMX and SVM, so VMCALL
and VMMCALL played no role whatsoever in its design. Moreover,
VMware's backdoor PIO interface actually does not allow the guest
kernel to delegate permissions to guest userspace. VMware ignores the
I/O permission bitmap in the TSS for the backdoor ports, so userspace
always has access to them. It's the VMware hypervisor that decides
whether or not to accept certain hypercalls at CPL>0.
