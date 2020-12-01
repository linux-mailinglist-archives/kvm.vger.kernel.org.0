Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A99D2C94B0
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 02:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgLABcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 20:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728932AbgLABcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 20:32:00 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D32C0613CF;
        Mon, 30 Nov 2020 17:31:20 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id q137so10302263iod.9;
        Mon, 30 Nov 2020 17:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PNkZykPzEuXa80Om8oj9TxXw1OAZxq3GW7d+3ZFIn8c=;
        b=V03DwfRjUq6E4DklFFWjRAyQQ98HY/hYfkKSvK4xXfo0oSvUhv7GWHdXQBrQyB8Utp
         VtNhBKLS52L8xx/YRX625cfTwX0ac5/o0YxE3HyD4NiXFSAJknroMY9mko4TDQQyPZ9O
         DnE2J4K7czWRuXXeU5W6vMrQqPDdoF9TdNjck5h41OpiOt065Al/CNyFjxDdf/uXSOmj
         F+iT0OIwyx18lOe3X8syNJacutaJnLmnleHOdn1ZmndSTmaHf6TBFuFoJQPrbdcTKRfV
         QV3BD7NLU4vOP/pYXykRBP+rPnGSffOdvhvQFuBzbuva3gFVfsuLftus+XkzpIGvXtgZ
         xZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PNkZykPzEuXa80Om8oj9TxXw1OAZxq3GW7d+3ZFIn8c=;
        b=mnjUQkNbPQpE65pYHpOf2wNXjK9XIfjA4Rr9+fi8ST8hsb9yNUxEoSpKwdGphqDuPt
         +LVJ1Rg2UlZnFLN3XJjGTav/7X45b9q2IhPihQG6d6r21tMH8egQRuAvqHh+JPP/fgTq
         IMH/sJ/l2DqMfkvcoTxH9UPhC4bHld4qQOKWB1xNq892larrI1ixW9yndYQQC8DZOepk
         FkLSApemudJ75Iq0PNcX3NawZv+sxm1MUy+FoI53pk1QYuIVC6fWZwv3vrmZRTMrYckE
         C/te/UfwEQBvefrsgaQOUIuGsiR1pg9HQLbep4SKH044nKeuXEzxefXjqJhWTsn0mDGi
         bj2g==
X-Gm-Message-State: AOAM5328kPUJ2S7oP9yCnONt2OFgIx9qSB1CYVR6YaBVCCzC+KfryhW8
        +7SrgxoJqImwjoipkvHVnFJtpAturulMFCM9R2E=
X-Google-Smtp-Source: ABdhPJzoJIB6tXp0JpwcWz8T5K9jHthVKvt7UWVqLfYxdQAL+gIR3fl6rsidxJhur1OUBb5mT1TWYM2PNpGt4iliaJE=
X-Received: by 2002:a5d:8ad6:: with SMTP id e22mr528690iot.154.1606786279443;
 Mon, 30 Nov 2020 17:31:19 -0800 (PST)
MIME-Version: 1.0
References: <20201120095517.19211-1-jiangshanlai@gmail.com>
 <20201126000549.GC450871@google.com> <0724aeb9-3466-5505-8f12-a5899144e68f@redhat.com>
 <CAJhGHyApvmQk4bxxK2rJKzyAShFSXyEb2W0qyFcVoUEcsMKs_w@mail.gmail.com> <X8Uux62rJdf2feJ2@google.com>
In-Reply-To: <X8Uux62rJdf2feJ2@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 1 Dec 2020 09:31:08 +0800
Message-ID: <CAJhGHyD=t3KiX1Tb_MbNOUVt6fXmVkBzax7DOmb-z5aPF3RuUw@mail.gmail.com>
Subject: Re: [PATCH] kvm/x86/mmu: use the correct inherited permissions to get
 shadow page
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@qumranet.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 1, 2020 at 1:41 AM Sean Christopherson <seanjc@google.com> wrote:

>
> Hmm, yes, KVM would incorrectly handle this scenario.  But, the proposed patch
> would not address the issue as KVM always maps non-leaf shadow pages with full
> access permissions.
>

Is it possible to exactly copy the access permissions from the guest
for non-leaf
shadow pages? Any protection from hypervisor (such as dirty track,
rmap_write_protect)
can only play on the leaf shadow ptes.

> Can we have a testcase in kvm-unit-tests?  It's okay of course if it
> only fails with ept=0.

Yes, it may have a flaw with ept=0. I don't get what "It's okay of course"
means. Is it related to kvm-unit-tests? Or no cloud provider uses
ept=0?
