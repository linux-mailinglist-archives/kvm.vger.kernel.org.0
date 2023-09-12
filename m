Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE7A79D8CB
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 20:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbjILSiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 14:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbjILSiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 14:38:02 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7687E10F2
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:37:58 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68fc9e0e22eso1902291b3a.1
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694543878; x=1695148678; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wy5n43SLh7KcjSaJVYVzVDg3MnFdzm1gNQS0TTXtUR4=;
        b=h5puBHtKj0adr1b3YQzUHSxeHSLsQRuriquzsKliOWX1fQR/Bm2/QGldD0I2RxdpLd
         KbSXhjwfQMdsR8nGYyWoebFBi2dIB5EMVvqwCqbxQ/kOAapAr9NHSm6lfIn8vbxn1fAR
         m9PtWcR2Wp56WQlA11/jGkW2nmgP5jaT7jCDLIrwXs/aouxEoggernOIn/HemlEiaeK0
         zzmsPSCMOnjcIkpCoVu2j+mLqNFApTyMaTVWEbnepI1vCxd5cYITayA0Bu5GzrDNi3az
         76qAyrKA+2n1mDGvJgifoalFzNTc2TReWTUJjqIH5KcE3GWEPD/CS4M9inx2tgM0tbaN
         X5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694543878; x=1695148678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wy5n43SLh7KcjSaJVYVzVDg3MnFdzm1gNQS0TTXtUR4=;
        b=oOVI/LEIn4uqeQbn6hcbkfF9RC/9FpwRzoaTTAhlTqmV7iGJ6uDfzq+ZcwIjPUSHWi
         MlLTcOMwecufzpGASBADBLVrNOuYKJI6r/GYp48mN6jhjLII3UQrCX1Tprpw0GL0ebqv
         QBNF+V+m9SchGk4DLAVZTsEvZ/pi4eD6OyOLWoxqWZAh/mY410xYUnLefB5C0sT+01oG
         iUH3rHKpnAf20vZLHLm/EQYjrrkXvziPgURGet+DAZcCRC0gxRbAS0NMgveZQo+9imct
         mBL+t5dBXz6Gm+Gzj6iUz0sMKpZJMSPITA8QzVayM2NjqJF3zErrz+Am1c5/KYAuq7eq
         Bn1w==
X-Gm-Message-State: AOJu0Ywbq0ORo1d03YbGREdJdJs4gSKtd6uyfHuRbKT8loUTQEfz+GLt
        ENiu5zAyTnlIgjhz0cN7rQJtKA==
X-Google-Smtp-Source: AGHT+IErGHsRSrFJvKHefg2NAmQCNrlFHjl+ciy1JtJ0nTYwIV/1H9rX5PxkYX9lsT1GFBHM0HI/Bg==
X-Received: by 2002:a05:6a00:847:b0:68f:cb69:8e78 with SMTP id q7-20020a056a00084700b0068fcb698e78mr664621pfk.5.1694543877695;
        Tue, 12 Sep 2023 11:37:57 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id y24-20020a056a001c9800b0068fb996503esm4624790pfw.100.2023.09.12.11.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:37:57 -0700 (PDT)
Date:   Tue, 12 Sep 2023 18:37:53 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 5/6] KVM: Documentation: Add the missing description
 for mmu_valid_gen into kvm_mmu_page
Message-ID: <ZQCwASSh0ssWYH4I@google.com>
References: <20230801002127.534020-1-mizhang@google.com>
 <20230801002127.534020-6-mizhang@google.com>
 <ZN1QYGfFuzlyjECm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZN1QYGfFuzlyjECm@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023, Sean Christopherson wrote:
> On Tue, Aug 01, 2023, Mingwei Zhang wrote:
> > Add the description for mmu_valid_gen into kvm_mmu_page description.
> > mmu_valid_gen is used in shadow MMU for fast zapping. Update the doc to
> > reflect that.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  Documentation/virt/kvm/x86/mmu.rst | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > index 40daf8beb9b1..581e53fa00a2 100644
> > --- a/Documentation/virt/kvm/x86/mmu.rst
> > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > @@ -208,6 +208,16 @@ Shadow pages contain the following information:
> >      The page is not backed by a guest page table, but its first entry
> >      points to one.  This is set if NPT uses 5-level page tables (host
> >      CR4.LA57=1) and is shadowing L1's 4-level NPT (L1 CR4.LA57=1).
> > +  mmu_valid_gen:
> > +    The MMU generation of this page, used to fast zap of all MMU pages within a
> > +    VM without blocking vCPUs.
> 
> KVM still blocks vCPUs, just for far less time.  How about this?
> 
>      The MMU generation of this page, used to determine whether or not a shadow
>      page is obsolete, i.e. belongs to a previous MMU generation.  KVM changes
>      the MMU generation when all shadow pages need to be invalidated, e.g. if a
>      memslot is deleted, and so effectively marks all shadow pages as obsolete
>      without having to touch each page.  Marking shadow pages obsolete allows
>      KVM to zap them in the background, i.e. so that vCPUs can run while the
>      zap is ongoing (using a root from the new generation).  The MMU generation
>      is only ever '0' or '1' (slots_lock must be held until all pages from the
>      previous generation are zapped).
> 
>      Note, the TDP MMU...
> 

Got you. I think instead of elaborating this, I would simply put this
way: "... without blocking vCPUs for too long". The subsequent description
basically tells how it works and naturally explains how it does not
blocks vCPUs for too long.

> > Specifically, KVM updates the per-VM valid MMU
> > +    generation which causes the mismatch of mmu_valid_gen for each mmu page.
> > +    This makes all existing MMU pages obsolete. Obsolete pages can't be used.
> > +    Therefore, vCPUs must load a new, valid root before re-entering the guest.
> > +    The MMU generation is only ever '0' or '1'.  

