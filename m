Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488F42F8110
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 17:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbhAOQqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 11:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAOQqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 11:46:31 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1901DC061757
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 08:45:51 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 30so6347742pgr.6
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 08:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TWuR3ZJ2UHICr0CiKVPTEVeDZF6pZ+WV9FNSFwhbdvQ=;
        b=tWvplHkApxVZ6MP6t8FotDQ+IHmJJBEZQWdV4QVV3+cKi3iDm/rTftLgnt/Ui8bEQR
         gym7ZJ/zjKICKBaXLKWxMtZSkZH+Hse7G9sYW2CRcQ3aDRPmRST+Jn4wfjpQ8bE6SOGV
         /RIW5lUJC7S6LvIGaFxhubFGwtI3JUMtIqu06WAKBvXiC7M51OWFgxzayu4bNUl6gCct
         zuaAImQPxpmkgSA3ckGCyCQwDozK8aemjLo2RVeyiXJG5yyOulAGuFs4Uap53ujlm20D
         dL8ACsVf6hZKZTo0AuoHCyf1bKbeiruCuqHY+ULuzpBFT2/gqocyIU15cXxeEQpH98oI
         4hQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TWuR3ZJ2UHICr0CiKVPTEVeDZF6pZ+WV9FNSFwhbdvQ=;
        b=klJQ0k179oQSC7NgI5yfup/cENMIUgbS889DFU0ETwSttQ/xmXreSsEEQUtMv0NR5z
         jlc7TNx1DHdqViO/brtYlSEo5VB8rHzMACP7nnl9zzpbhw8WS8lXPnbxtuFPlvyXImU8
         kmLDFHeDT6Poz65MkHrW1YorbPoTgK41ud9eWiAGtQLmaLsEIq3FKuwABG8lHFKftLWJ
         zjMljvx0rILgPh1YilDaOP8N3ktusglQX6gevqGqqsHrU/BH2gn64QhDu5FfV1LYygZx
         jC1t4N/aTVNsByJiCG4szZlH5dGXhPT2ARW64LlTbxReIYrrJNWWwERNbevcl/xP9JEj
         gKyA==
X-Gm-Message-State: AOAM5339rtXVPNSqleIXr9GGvDa6zO57D9u7ASa3OWD0HbzRwXXM3y1G
        JWwbXio22zpvObdskJfNiySppTbNUYCybw==
X-Google-Smtp-Source: ABdhPJx/joI/0iL7ov0niLl5D6IK5weqMVWW7wXnPSsxawzu9EjDeF4O5L36F6bX+KrMnIs12bNXpQ==
X-Received: by 2002:a05:6a00:884:b029:1b4:440f:bce7 with SMTP id q4-20020a056a000884b02901b4440fbce7mr2209052pfj.20.1610729150481;
        Fri, 15 Jan 2021 08:45:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 4sm9199887pjn.14.2021.01.15.08.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:45:49 -0800 (PST)
Date:   Fri, 15 Jan 2021 08:45:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 0/4] KVM: x86: Drastically raise KVM_USER_MEM_SLOTS
 limit
Message-ID: <YAHGt3zIUpNbJQm7@google.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <YAG8t9ww/dgFaFht@google.com>
 <87zh1a5fuj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh1a5fuj.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Fri, Jan 15, 2021, Vitaly Kuznetsov wrote:
> >> Longer version:
> >> 
> >> Current KVM_USER_MEM_SLOTS limit (509) can be a limiting factor for some
> >> configurations. In particular, when QEMU tries to start a Windows guest
> >> with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as SynIC
> >> requires two pages per vCPU and the guest is free to pick any GFN for
> >> each of them, this fragments memslots as QEMU wants to have a separate
> >> memslot for each of these pages (which are supposed to act as 'overlay'
> >> pages).
> >
> > What exactly does QEMU do on the backend?  I poked around the code a bit, but
> > didn't see anything relevant.
> >
> 
> In QEMU's terms it registers memory sub-regions for these two pages (see
> synic_update() in hw/hyperv/hyperv.c). Memory for these page-sized
> sub-regions is allocated separately so in KVM terms they become
> page-sized slots and previously continuous 'system memory' slot breaks
> into several slots.

Doh, I had a super stale version checked out (2.9.50), no wonder I couldn't find
anything.

Isn't the memslot approach inherently flawed in that the SynIC is per-vCPU, but
memslots are per-VM?  E.g. if vCPU1 accesses vCPU0's SynIC GPA, I would expect
that to access real memory, not the overlay.  Or is there more QEMU magic going
on that I'm missing?
