Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C1A445AE8
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 21:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhKDUI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 16:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhKDUIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 16:08:55 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC710C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 13:06:16 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id f5so6360207pgc.12
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 13:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t6h33BXhPYBQBuyLFqDnFlYYuA+tbBLYs00jO/l0RTs=;
        b=EDUGKUl8X9HnJ11lWBNwL6XuHPoMuE9NAiermUIjA02AntbYF/4QvL7Bg5qMLmlMPf
         6VlAERivL4w0LxupEb8BX4xeUfs+l9qRymyvfBlaQBTEgdxmA+dbbwQsaIgwRkDScXWR
         vz8rtVFgrwdPRmtbFzD61nop3ff/GnHh/ylB3vh53x+ymbECY+WpcnZ7NNUfgQ4/Owbk
         /BaehvWlufiKJW4I68yoAceu1b04EX6Slf5yJbLalSXycjA/UM5cTWEE5XAk31g/sBJc
         C146WdGeAGLLHIJV69oloEgsCKCXDNz4NznUBTaHbysA6toSggF4UxT2IezqKEFWiBEr
         7qwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t6h33BXhPYBQBuyLFqDnFlYYuA+tbBLYs00jO/l0RTs=;
        b=o+hFj7X+uOuFNensG5MW2d6iZwRyH6lmO/9h/zgpfhd19h2TR9yuXY19xyZs/dHw80
         927G85U8YuemKyL9y+C3Pli40WBGB+Z2X9yWG2DhJsjwjj5+luMhVQv+tESm0jSYX+Kb
         zVPp/ry9lXYPQfUntnztC0yA4JJp23CSe8thPHPOY/FVmFSVFH62yxVMVOqnGZbyFS3j
         tIQndTZSY2XK13Va3ZwvKxVEA93SkCsz+DYTJC22cE0Cv4G5w8usM6VJFjl7lrmMEXfb
         vgqtPE4ZHZxz+UtNzIQFqMveRbFOWt1pl2F0vaR8Rtlz0TAIfuGOuNPXr6gjeOVuICv6
         oh6w==
X-Gm-Message-State: AOAM531IaODwCSqOEcX6CHk/asJ+vqhuzDm42udo/2SQZibMOYNvDcGi
        uok0dJnnjP9cZoLiXPauAx0a/g==
X-Google-Smtp-Source: ABdhPJxxCrq3QnNSwlhxw81TlebGccY4p2RbgJZ5JGpCjQ0T1d1qQfXg1S1BEetHdzGTc8722YVBtQ==
X-Received: by 2002:a05:6a00:887:b0:44b:dee9:b7b1 with SMTP id q7-20020a056a00088700b0044bdee9b7b1mr55414337pfj.84.1636056376002;
        Thu, 04 Nov 2021 13:06:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c3sm5701341pfv.25.2021.11.04.13.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 13:06:15 -0700 (PDT)
Date:   Thu, 4 Nov 2021 20:06:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5 V11] KVM: SEV: Refactor out sev_es_state struct
Message-ID: <YYQ9MzKKF9dt8Wbk@google.com>
References: <20211021174303.385706-1-pgonda@google.com>
 <20211021174303.385706-2-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021174303.385706-2-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FWIW, "git format-patch -v $version" will generate the version info for you.
Based on the weird ordering of the shortlog and the cover letter subject

   [PATCH 1/5 V11] KVM: SEV: Refactor out sev_es_state struct

vs.

   [PATCH V11 2/5] KVM: SEV: Add support for SEV intra host migration

it looks like you might be hand-editing these?

Note, format-patch also takes --rfc, and you can override the entire thing for a
free form prefixes in --subject-prefix, e.g. I use it to call out "[kvm-unit-tests PATCH ...].

The PATCH part of the "prefix" needs to be provided manually, but then you do fun
things like replace PATCH with something else entirely, append an incremental
version, e.g. v2.1, which some people do if they need to make a small change to
one patch in a large series.

On Thu, Oct 21, 2021, Peter Gonda wrote:
> Move SEV-ES vCPU metadata into new sev_es_state struct from vcpu_svm.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---

At some point in the future we really need to do some cleanup to reduce the
"depth" of things like svm->sev_es... and svm->vcpu.arch..., but for now,

Reviewed-by: Sean Christopherson <seanjc@google.com>
