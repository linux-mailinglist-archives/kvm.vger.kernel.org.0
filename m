Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFAA1DD908
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 23:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgEUVER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 17:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 17:04:15 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BB8C061A0E;
        Thu, 21 May 2020 14:04:14 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f134so6786062wmf.1;
        Thu, 21 May 2020 14:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QZeCeK8p2wSrt+bTxeHQ3mMh/QGdI4wG1j05OuSlGgk=;
        b=KYJcYHl84sDa95PB04uFCMRdQKl4v34HIURpNkaVLAb6sErv5f5Ec+xYAApNBpC4jg
         5WV1Y/y+4MXXp8uHTeDyyIwgqJ0bPZnoya5g8DeGpUtO4vjfAUlqzGnmxUKieG7/Hf9z
         8Imoj8Qkgo35lwCoztWJXdEp/5pMnYAvYyn3jVft+AwxO9jiase0HFT+8qcMX2vYPhx0
         WbJJ5X8sjv1g0i4m9rUQ945YlN6OcZokbGW9vcFGH6p7jHzvtu8tMRHBXVqjHcjl/oYG
         LvHCVEyGO57owTWljirz+fx3u+1GLfL69dk+L8RaFlYUDTdtEYw/Et8LFG7gfmd1ayHk
         +qXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QZeCeK8p2wSrt+bTxeHQ3mMh/QGdI4wG1j05OuSlGgk=;
        b=H2HXBFvgtqTGC3yuY1B5Uw0LMpWW2pJyQjJVVCJM/oaf3c+pcW0LK1fz0gEt225On7
         WgxagD/sL3PJ1JNYOUU1kCoaSo4IYl4b0v+823lCFhTH9lKvgUIILFXi7GgPDITrX+/x
         o8zyuw1LYJIfXNDq1Hn4aPeBDsek3PaA6sOap33K+/hzRk+03fPafK5biBsd09ZdIWpA
         XGZRhiFj7OuZjXI0fJf/C7xLm+e5JQq5LppNbrd1Ha+9/b9ewKpdO5yBWZE5EgVo1xW7
         0CI9G2TLBEKZb2dMMCtphCONlWdk7U/XAxn6TPWyY0SV3BEVoY7pWUhCss2LaLuM8eTa
         UaLg==
X-Gm-Message-State: AOAM532pjMAmePdWp2eaXu2Yg9keTgiR7d5c0VJNhQAYhi3LIIV6GMKg
        Pzhl3EzoTqixLIxOxhUaCmmfzjZm
X-Google-Smtp-Source: ABdhPJxpTtdlO07F422Z9vG5KPD6eIgSMGVrcQIlZjhwwVaWpw/QF+N24tIYFjtqcRPFcMpTU450Fg==
X-Received: by 2002:a1c:b60b:: with SMTP id g11mr10470942wmf.49.1590095052723;
        Thu, 21 May 2020 14:04:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1c48:1dd8:fe63:e3da? ([2001:b07:6468:f312:1c48:1dd8:fe63:e3da])
        by smtp.googlemail.com with ESMTPSA id u10sm7573129wmc.31.2020.05.21.14.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 14:04:11 -0700 (PDT)
Subject: Re: [PATCH v2 03/22] KVM: SVM: immediately inject INTR vmexit
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     wei.huang2@amd.com, cavery@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200424172416.243870-1-pbonzini@redhat.com>
 <20200424172416.243870-4-pbonzini@redhat.com>
 <87blmhsb7y.fsf@vitty.brq.redhat.com>
 <8bc4c38a-1717-1e4f-b322-fdd51f614717@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
 uUHgL9dKIfvpm+rNXRn9wAwGjk0X/A==
Message-ID: <73e55aba-dc71-ae36-d491-a6afed844c9a@redhat.com>
Date:   Thu, 21 May 2020 23:04:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <8bc4c38a-1717-1e4f-b322-fdd51f614717@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/20 16:08, Paolo Bonzini wrote:
> On 21/05/20 14:50, Vitaly Kuznetsov wrote:
>> Sorry for reporting this late but I just found out that this commit
>> breaks Hyper-V 2016 on KVM on SVM completely (always hangs on boot). I
>> haven't investigated it yet (well, this is Windows, you know...) but
>> what's usually different about Hyper-V is that unlike KVM/Linux it has
>> handlers for some hardware interrupts in the guest and not in the
>> hypervisor.
> 
> "Always hangs on boot" is easy. :)  At this point I think it's easiest
> to debug it on top of the whole pending SVM patches that remove
> exit_required completely (and exit_required is not coming back anyway).

Ok so there could be two bugs, as the hang seems to happens much earlier
later in the series (try "grep int_ctl:.0x.....1.." on the trace).

As one could guess from the grep, one thing that is certainly different
between KVM and Hyper-V is that Hyper-V injects interrupts using
int_ctl; sometimes it also uses eventinj but presumably it's just
copying it from exitintinfo).

This could cause problems: for example, when L1 wants to inject a
virtual interrupt into L2 that has interrupts disabled or V_TPR >=
V_INTR_PRIO, and KVM also wants to inject an interrupt to L1, then KVM
might end up stomping on Hyper-V's int_ctl.  However I cannot think
off-hand of a scenario where this could happen in this case, because
Hyper-V does set EXIT_INTR and therefore we should never get into
enable_irq_window while L2 is running.  Still, that's one place where
I'd start adding some trace_printk's.

Also, if a uniprocessor guest also fails, it might be easier to debug.

Paolo
