Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E1E369888
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 19:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhDWRig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 13:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWRie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 13:38:34 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C95C061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 10:37:58 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id p12so35673105pgj.10
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 10:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5bu/6L4heVpMPYLnt4LzXj+yzwX6cdLvXLfTwmZluPI=;
        b=OV3x5/Wm9kQ7iQ/ya+iwqLKBig/M30v0HhKYs9eBxENOMT/qeZYy3a3Es25I4FCdZ7
         sO4cNaiTfQaqjHoJ/HziS9wZetQXPMQ0RgkxpUZyMV9BdK6x+oMtrGSiK586KPmRcALP
         mcVrszxgOaJr2BsAKpG9oKWQBOK/i2EHxyf2Cx35MPSKAQKpxzD4BCrfQAuwh1li/KYE
         xXCGwK66B3Sj++ChM8QS7kkB3MHdGHgpD3MbL9J7jeYIaLfyL0rGPYg7K+TeOjOnNhK9
         yKAWAIh52G58xqS7iKaGpF1ghmcpg1O+cBCfQlnRO1MExjnzh5CGt9wLa8Dzo2/vxqCr
         PZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5bu/6L4heVpMPYLnt4LzXj+yzwX6cdLvXLfTwmZluPI=;
        b=HJiJrirSWTP9DyyPnDO7suKvOdG3jUY/CdJFS1jJW6EquZYVmL17C+mu+JIlBEOCdK
         mO9lapU2f9cHY1TWWSLr1jZwudh8wywZZEHJNYrhsOswkd9LFqVovet5ckghwyk0k1p/
         YMq0Y7/xly0xGrbjpI0F43OAJDEvaK23YLucuVYRR7zcULtTePj0+gEMnTlvPoABRzx9
         kjDKuSJS8IuJ4FLHzAAIRh5pjVKEZECoFYb7gee18nkdi67ogPhHRm8N7e2VKJ/peBZM
         rOTJc9RGNDFmQxXRgZNOsbGiJF1YKjJ4IJvEDnfqoLko/l1r217BEva9pJkNYHQYrymP
         7unQ==
X-Gm-Message-State: AOAM532tw5bJ8B1xVUpbc6Lbj8PIcNYCJyOHcKUpek+0En4Y6ZGbuLRu
        bAIVZrIG0m7Fyr1pNMgVfxvTNA==
X-Google-Smtp-Source: ABdhPJywxdRAWLVOTRkyjmPRGqtM8zqy6/svqUFe5cTTme4Yp9PPkm+xR11VV7EO2dQkTd4TJe4glQ==
X-Received: by 2002:a63:dc49:: with SMTP id f9mr4757064pgj.361.1619199477353;
        Fri, 23 Apr 2021 10:37:57 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d132sm5061980pfd.136.2021.04.23.10.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 10:37:56 -0700 (PDT)
Date:   Fri, 23 Apr 2021 17:37:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <dme@dme.org>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation
 errors
Message-ID: <YIMF8b2jD3b8IfPP@google.com>
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org>
 <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
 <cunmttrftrh.fsf@dme.org>
 <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
 <cunk0oug2t3.fsf@dme.org>
 <YILo26WQNvZNmtX0@google.com>
 <cunbla4ncdd.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cunbla4ncdd.fsf@dme.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021, David Edmondson wrote:
> On Friday, 2021-04-23 at 15:33:47 GMT, Sean Christopherson wrote:
> 
> > On Thu, Apr 22, 2021, David Edmondson wrote:
> >> Agreed. As Jim indicated in his other reply, there should be no new data
> >> leaked by not zeroing the bytes.
> >> 
> >> For now at least, this is not a performance critical path, so clearing
> >> the payload doesn't seem too onerous.
> >
> > I feel quite strongly that KVM should _not_ touch the unused bytes.
> 
> I'm fine with that, but...
> 
> > As Jim pointed out, a stream of 0x0 0x0 0x0 ... is not benign, it will
> > decode to one or more ADD instructions.  Arguably 0x90, 0xcc, or an
> > undending stream of prefixes would be more appropriate so that it's
> > less likely for userspace to decode a bogus instruction.
> 
> ...I don't understand this position. If the user-level instruction
> decoder starts interpreting bytes that the kernel did *not* indicate as
> valid (by setting insn_size to include them), it's broken.

Yes, so what's the point of clearing the unused bytes?  Doing so won't magically
fix a broken userspace.  That's why I argue that 0x90 or 0xcc would be more
appropriate; there's at least a non-zero chance that it will help userspace avoid
doing something completely broken.

On the other hand, userspace can guard against a broken _KVM_ by initializing
vcpu->run with a known pattern and logging if KVM exits to userspace with
seemingly bogus data.  Crushing the unused bytes to zero defeats userspace's
sanity check, e.g. if the actual memcpy() of the instruction bytes copies the
wrong number of bytes, then userspace's magic pattern will be lost and debugging
the KVM bug will be that much harder.

This is very much not a theoretical problem, I have debugged two separate KVM
bugs in the last few months where KVM completely failed to set
vcpu->run->exit_reason before exiting to userspace.  The exit_reason is a bit of
a special case because it's disturbingly easy for KVM to get confused over return
values and unintentionally exit to userspace, but it's not a big stretch to
imagine a bug where KVM provides incomplete data.
