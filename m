Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7253C340A46
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 17:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhCRQgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 12:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhCRQf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 12:35:29 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824A9C06174A
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:35:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s21so3219870pjq.1
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KIr3wy+y1kkcXB0bz4TgTW6yLj48GRxKZuzLPuR96xM=;
        b=C98/sCD1HP4t2ExHOUZFnhbTyZxzVsmRpaRv3I/7PP34k9CJnisGyLvPe3TMUJv0u8
         gJHfEFXXgQ/CNJ4BXs1tr4K3ZLp+38L9shJbtpY55dlBkJrxhf4Vx1yDyLJTMFfVjv8U
         g7MVMM4zYQ1MM9L2TCg9kYzOJ/CO+acNGqDUyPxe0TLbG3cZBZhr6NRv1LftjWfLNUZl
         x7OguUh5bD2p9hPBA2hTA7fVzGMWLdWMIl2l4KVaWT+nD4JMZshcQ4ggNE8hGykR/FMo
         u9UroJAOG8atP8/rfGlEqmIXWGAcLVhOJ2i/7HmFhj2OiZdp3ze/JKB9X3cCHupfij+L
         2VFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KIr3wy+y1kkcXB0bz4TgTW6yLj48GRxKZuzLPuR96xM=;
        b=RqEVHnN4sXvMHhR+XUj7stZfXZ3hAh4KJ85OPndOr2njheSi4oJcfgMZFpzVz4qWew
         44acpv+8BJ+Wi+E+Dr6W7afB5ngwGv0s+4GnaJoR02aOmWuc6Oq9smkvz8gf5TsePguX
         fXEmHsKSPaAPWXD/VbR++9EF5dhvsZBuI+hU2xc6Df7qVGdFS/P/cgVdCw7HFutCQzTB
         uhbFPlpUR+FX1S2vSBHZmLNe4uahsspsvAZSHr5321HG+S+5WKYcp8wfNriGaPq6BGuT
         GoXJGFZyq/cm3Lrghh9ut3UsyZBkiKFWoemiyLW/ikePwRfPiZaJ7sBPfarH4QhKnVyt
         w8Zg==
X-Gm-Message-State: AOAM5315mx5L3ZGjJAuFbB3O5oOXqLCgOUWD5BE1GiOMOeZa36ntkCB1
        pfiP3Xz0FallkTFfAQj4dEERoA==
X-Google-Smtp-Source: ABdhPJywC2AE/q3RAOMe7bVSpLr05w+jqDX2n+281p/auHHEioD3W81MQ5I1KIhh3lwi/4HhApoeQA==
X-Received: by 2002:a17:90a:c004:: with SMTP id p4mr5229804pjt.202.1616085328845;
        Thu, 18 Mar 2021 09:35:28 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z1sm2904556pfn.127.2021.03.18.09.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 09:35:28 -0700 (PDT)
Date:   Thu, 18 Mar 2021 16:35:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/3] KVM: SVM: allow to intercept all exceptions for debug
Message-ID: <YFOBTITk7EkGdzR2@google.com>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
 <20210315221020.661693-4-mlevitsk@redhat.com>
 <YFBtI55sVzIJ15U+@8bytes.org>
 <4116d6ce75a85faccfe7a2b3967528f0561974ae.camel@redhat.com>
 <YFMbLWLlGgbOJuN/@8bytes.org>
 <8ba6676471dc8c8219e35d6a1695febaea20bb0b.camel@redhat.com>
 <YFN2HGG7ZTdamM7k@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFN2HGG7ZTdamM7k@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021, Joerg Roedel wrote:
> On Thu, Mar 18, 2021 at 11:24:25AM +0200, Maxim Levitsky wrote:
> > But again this is a debug feature, and it is intended to allow the user
> > to shoot himself in the foot.
> 
> And one can't debug SEV-ES guests with it, so what is the point of
> enabling it for them too?

Agreed.  I can see myself enabling debug features by default, it would be nice
to not having to go out of my way to disable them for SEV-ES/SNP guests.

Skipping SEV-ES guests should not be difficult; KVM could probably even
print a message stating that the debug hook is being ignored.  One thought would
be to snapshot debug_intercept_exceptions at VM creation, and simply zero it out
for incompatible guests.  That would also allow changing debug_intercept_exceptions
without reloading KVM, which IMO would be very convenient.
