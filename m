Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EDF48CEFF
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 00:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiALXOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 18:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiALXOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 18:14:37 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD92C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 15:14:33 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so7945224pji.3
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 15:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d0jCBobpVlBNvfREglfkw9YIUT/N0ds0mEhgutOEthA=;
        b=n6Jxs6LoIzS+LRw2wZy+Sc+Am+Ey0wbLg2vXnruhPw8xCIDgqyAyRn3pZbeNeZ2SvO
         p7B+gQMPcATJIFB5RGgQbjvqAqXyxsr54/VXtIxGQyBT/paqUQFIf7L3ZiSZMEPHDXsD
         XxDFFK6mJTOfjCriQUU4awpFu580O0fyI39e/XH9wvYqnl4DqkagsJ+qcHOe+Uj08FvG
         hVj/142yKdUswoc84398SfOY1T7gOHTwI+2GMFp4JYx39VoXZrxkpnL8racb8H+i6Btf
         OFFTr5tsmwvK/E+5YOcbVBgF2w9CCubvlPp4vC63A2SHyOx5Zf+YY8c+tGGigTdhwd/r
         ve/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d0jCBobpVlBNvfREglfkw9YIUT/N0ds0mEhgutOEthA=;
        b=TAj6zqX7aSNnrW/W1jj7LYuRs+2k6yulSAPHaTDk/Ka5/1frHaLu7PbSQJ+Rk15xIo
         WUkGr3vTlxYeIt8he7S1Het6hMl8aBnP3OPLlHAb3Wcr2Ntlxl7rIhx4b+U5+LmVJaxE
         lZ/3+tpSZSxyihCioendx/f32cIKQ2jqpM47M8ktLsKs2brWj/ug4DoGn55PUaBfdlWP
         b2DpXahbBoyhGUXdHQZEbUSsF5+1bjhaJVU4cb6mWXZMFUGkFLoJe++gcOHScTercRxw
         RBRTnfG/cZENAOc56dTIjesT6WfMF5XcVVptMg6rsuRl7aSweaT6loe8WX+pE+XvTKQY
         C9ig==
X-Gm-Message-State: AOAM530d7tsaHcuILaFWyxvNuUNA0tcpB6tj8Oi/RTfoHendFU7kKjr5
        Nc3fOHyWkCEo5thZTI5rapRvMQ==
X-Google-Smtp-Source: ABdhPJwbLerEnHvBEXjR+pRHR7npc25cvNWskbT2LviKUgAOfZkdQMObjbgnEDsUiFmQb4/W0gaKsg==
X-Received: by 2002:a17:902:cec5:b0:14a:5aa5:6a76 with SMTP id d5-20020a170902cec500b0014a5aa56a76mr1636127plg.51.1642029272798;
        Wed, 12 Jan 2022 15:14:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r13sm590859pga.29.2022.01.12.15.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 15:14:32 -0800 (PST)
Date:   Wed, 12 Jan 2022 23:14:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Fix write-protection of PTs mapped by
 the TDP MMU
Message-ID: <Yd9g1KIoNwUPtFrt@google.com>
References: <20220112215801.3502286-1-dmatlack@google.com>
 <20220112215801.3502286-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112215801.3502286-2-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, David Matlack wrote:
> When the TDP MMU is write-protection GFNs for page table protection (as
> opposed to for dirty logging, or due to the HVA not being writable), it
> checks if the SPTE is already write-protected and if so skips modifying
> the SPTE and the TLB flush.
> 
> This behavior is incorrect because the SPTE may be write-protected for
> dirty logging. This implies that the SPTE could be locklessly be made
> writable on the next write access, and that vCPUs could still be running
> with writable SPTEs cached in their TLB.
> 
> Fix this by unconditionally setting the SPTE and only skipping the TLB
> flush if the SPTE was already marked !MMU-writable or !Host-writable,
> which guarantees the SPTE cannot be locklessly be made writable and no
> vCPUs are running the writable SPTEs cached in their TLBs.
> 
> Technically it would be safe to skip setting the SPTE as well since:
> 
>   (a) If MMU-writable is set then Host-writable must be cleared
>       and the only way to set Host-writable is to fault the SPTE
>       back in entirely (at which point any unsynced shadow pages
>       reachable by the new SPTE will be synced and MMU-writable can
>       be safetly be set again).
> 
>   and
> 
>   (b) MMU-writable is never consulted on its own.
> 
> And in fact this is what the shadow MMU does when write-protecting guest
> page tables. However setting the SPTE unconditionally is much easier to
> reason about and does not require a huge comment explaining why it is safe.

I disagree.  I looked at the code+comment before reading the full changelog and
typed up a response saying the code should be:

		if (!is_writable_pte(iter.old_spte) &&
		    !spte_can_locklessly_be_made_writable(spte))
			break;

Then I went read the changelog and here we are :-)

I find that much more easier to grok, e.g. in plain English: "if the SPTE isn't
writable and can't be made writable, there's nothing to do".

Versus "unconditionally clear the writable bits because ???, but only flush if
the write was actually necessary", with a slightly opinionated translation :-)

And with that, you don't need to do s/spte_set/flush.  Though I would be in favor
of a separate patch to do s/spte_set/write_protected here and in the caller, to
match kvm_mmu_slot_gfn_write_protect().
