Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0273C15DB
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 17:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhGHPYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 11:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhGHPYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 11:24:37 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13692C061574;
        Thu,  8 Jul 2021 08:21:55 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cs1-20020a17090af501b0290170856e1a8aso6102400pjb.3;
        Thu, 08 Jul 2021 08:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3Fqa3JBj0Mm9fkBkNJ7GXxkTFWxEhmfT0t9V/cQ727s=;
        b=hxtwVxRcpcsJoF9+n57xGeTeJaz2f6WWTY4XnqgKoPLbi41YKZZwEWgQJHG8flKXPP
         hYz2lMwTiaUHs4WpaBvwIrRXHwN7Fowm0tk/ffuuuFSv5BySYvdMNpUR0qDdxBIzsn1J
         kJc+xSKaRWIB5wCxm/hBeIugFbv4HAXyC8ZyAU91Sf8jP6zjCFloMOvZXlmpyfnwLFiQ
         W5psn7i7/h+5n4VqYgAIDCI35zFI8oFzyPmYB8Ygic7UPK//Bw6di+1/Rexl1nWsVot9
         G1gZexwi12GEQvRScQ40Js0kzdfSu1YLXjAQB9Be4qbDJ4p+VSKAl3PvN3rJHR9/i84J
         ysiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3Fqa3JBj0Mm9fkBkNJ7GXxkTFWxEhmfT0t9V/cQ727s=;
        b=Z5LNK/igB2vf+kbT2zkmOQ+hHEmURAeQj71aCXxDwgsqkHBWHDZ/5ESBVOAKKAhzkR
         y8ARlrB0rVLIBN8wobwz+1vs6R1jBi94ELZAG0sGly0mcb7PC9Q3Vm1gYBwvjgwlGH41
         A8m7StdiKISiT5c5A+Hj5Hv/EKEZ+ODWTjwT1lGh39Gls8Y63uFLcjk3lttbQUXCZrex
         Wjo5kqhP0hsasBIiU71VTnClWm+pUjqvyb3Y2PQT+Lc6TU7OkbvRDMS+SCJh7KOVJelH
         FagpY/dmDAfmFL1Id/VHbCWGXQQrnWFgtTpsA3//cnCv3fLwk0WVXp4vvs03XJx+nYVa
         c3Vw==
X-Gm-Message-State: AOAM531sf3RRhC1Gc/p/OgHpXxeu9TrqOoJj624PyRPoD+PS6RdFtZsn
        NTYew4ngpCvEligaztLCN9g=
X-Google-Smtp-Source: ABdhPJz9H92rKwh3I7eM5NHfswNbRROh3I53dWdBQ7onM2aiB+pcMCdG10WGGSdMIk+b4rVpicPNFw==
X-Received: by 2002:a17:902:988f:b029:114:12d2:d548 with SMTP id s15-20020a170902988fb029011412d2d548mr26555639plp.73.1625757714594;
        Thu, 08 Jul 2021 08:21:54 -0700 (PDT)
Received: from localhost ([2601:647:4600:1ed4:adaa:7ff5:893e:b91])
        by smtp.gmail.com with ESMTPSA id m21sm3460649pfa.99.2021.07.08.08.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 08:21:54 -0700 (PDT)
Date:   Thu, 8 Jul 2021 08:21:52 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kernel test robot <lkp@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v2 55/69] KVM: VMX: Add 'main.c' to wrap VMX and TDX
Message-ID: <20210708152152.GB278847@private.email.ne.jp>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <52e7bb9f6bd27dc56880d81e232270679ffee601.1625186503.git.isaku.yamahata@intel.com>
 <0b1edf62-fce8-f628-b482-021f99004f38@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b1edf62-fce8-f628-b482-021f99004f38@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021 at 04:43:22PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> > +#include "vmx.c"
> 
> What makes it particularly hard to have this as a separate .o file rather
> than an #include?

It's to let complier to optimize functionc call of "if (tdx) tdx_xxx() else vmx_xxx()",
given x86_ops static call story.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
