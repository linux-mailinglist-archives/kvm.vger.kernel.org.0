Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D276B38F59B
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 00:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhEXWaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 18:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXWaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 18:30:14 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA203C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:28:44 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v13-20020a17090abb8db029015f9f7d7290so720080pjr.0
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 15:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wjHpPJplladoMyN508+roXM5QX3joM77pztZx4dnUzs=;
        b=Vh9c4pDMcMGHrDB/DXKm60YSRnio8FmkVEXBrs70mST+GX+GqtGg7DbzngmZeLYOlF
         TwnPui9rY6g+IixjZoEWmDWk93pl3ZSH7muk3fn0u/oYcmafAkQopuNDOCq2/2c3Pojj
         k0SCysDD0W33PzlYFD/w7g8YVnxrccbFHdewjygkBEo2FPzOGp3yzkBD0cmpufPBplk8
         kgXTPHhfByDtKazuIeTBKos7tsz5uIUFkMtMygnyCmzDO5cfFeFhiL5g/D0U5wX5uu3A
         odJzYyursS1h8P1XGBBbX1ifx5CX2zpMxcfMRFZult61SqSolWMpn638LEPINTSPKaQL
         cj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wjHpPJplladoMyN508+roXM5QX3joM77pztZx4dnUzs=;
        b=deTwZdslgmrSbgA6LhzuyRurCFeS2e+u4WD402juDrlWvSrCjelWfxf/Ihcbzm0VXW
         QSP1E2xQyzxCFhcsMdnT/8PX2Q9Fzm+S/x6YobzuCF4RaBBf7m4p5Y+VW90CtpiulxuS
         e0ZUzutmOp9ll/55RYKufMSB+dVejzs8LEiXG4NB+xdY8IEo/qVZdYMWAJwY8sXxMeLs
         oOM6eiVA13JvOV1oWjnZMHHIfX1M0GLDbHP7C8LSSUm1ZTK4rLppsnpUVyOhH+0v6d6x
         KOkU3+0Us/L5QjbmXKPlvFkSbTKYOP56/VcieLEJZpUXQ0zYJzZJLEjMHZsiWOfPhtn6
         ohzg==
X-Gm-Message-State: AOAM531qpCs0060MaPhd63JFxxnffefI9teFt39sRut88ibL0bK8jxeb
        Wu6gNjCn5ZJcO0SVvTWy5J8ggQ==
X-Google-Smtp-Source: ABdhPJymBcH3mXTox6PlhJFMX+WysdycfN2VP+NWNbw7SdmI4w4ynWj/wQqPhVDzRBOWP01+PF/G0A==
X-Received: by 2002:a17:902:f545:b029:f5:4b82:9cc9 with SMTP id h5-20020a170902f545b02900f54b829cc9mr27428087plf.68.1621895324070;
        Mon, 24 May 2021 15:28:44 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b23sm2385959pfi.34.2021.05.24.15.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 15:28:43 -0700 (PDT)
Date:   Mon, 24 May 2021 22:28:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 42/43] KVM: VMX: Drop VMWRITEs to zero fields at vCPU
 RESET
Message-ID: <YKwomNuTEwgf4Xt0@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-43-seanjc@google.com>
 <e2974b79-a6e5-81be-2adb-456f114391da@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2974b79-a6e5-81be-2adb-456f114391da@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Paolo Bonzini wrote:
> On 24/04/21 02:46, Sean Christopherson wrote:
> > Don't waste time writing zeros via VMWRITE during vCPU RESET, the VMCS
> > is zero allocated.
> 
> Is this guaranteed to be valid, or could the VMCS in principle use some
> weird encoding? (Like it does for the access rights, even though this does
> not matter for this patch).

Phooey.  In principle, the CPU can do whatever it wants, e.g. the SDM states that
software should never write to the data portion of the VMCS under any circumstance.

In practice, I would be flabbergasted if Intel ever ships a CPU that doesn't play
nice with zero initiazing the VMCS via software writes.  I'd bet dollars to
donuts that KVM isn't the only software that relies on that behavior.

That said, I'm not against switching to VMWRITE for everything, but regardless
of which route we choose, we should commit to one or the other.  I.e. double down
on memset() and bet that Intel won't break KVM, or replace the memset() in
alloc_vmcs_cpu() with a sequence that writes all known (possible?) fields.  The
current approach of zeroing the memory in software but initializing _some_ fields
is the worst option, e.g. I highly doubt vmcs01 and vmcs02 do VMWRITE(..., 0) on
the same fields.
