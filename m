Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600F5375727
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 17:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbhEFPan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 11:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbhEFPag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 11:30:36 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C98C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 08:29:37 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id h20so3592291plr.4
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 08:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N+EP+JftDHBDPDSkYNABjTVewDBiKl28JZHNfPavMbU=;
        b=DiHoRy8U0D1jKboD2ItdhXdV0p3rEqAIGlRWpc17GNB9UH626qgkrqxK6o7aMVAe19
         EUnjfooX31L2+fEPs+XCuEKHodj1yucRGA5jL/Z5buUGSOWFbx67N4ZmoOGDjgQ/z8Xr
         CpflTWMibEhCj3NFfZl3RwQdNO5PwiJo/AcycgD57eafmIduFRa6ENPVuGsmSdfdf6Wv
         fZ1gHO0FPOHIBLe8INV5wea8LplxzCQAQ/OyH3jNR0WgZKNCdlwuXTheDFTgFPPoMLtI
         kIivonMljp6fcJtqnKi7oWM8wKgq/GSrfj+0mgtOm+A2C9xRNEbNDkPpXYxggMU/EP3J
         mgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N+EP+JftDHBDPDSkYNABjTVewDBiKl28JZHNfPavMbU=;
        b=A4sgsW5+vKdumeGfR2BhVjiln7J2G39gMErgov+Lovo8L0FoStjYQb6cCXeylEDOGk
         Zldvhap3GiybcpLMYpxiqzcLIgSYhTXabziu2VPEjyfd2RJFu0ow4Q7/aNlGhOJAACle
         ywiKJsr4zK3wKtJF8vkqjhta64NPKM0Gh3bIaPQdSEhnSwOHBOqYx91FQOfBV+gzX8lG
         q5xhxj5zFBnp/IM2dPRl8VwcJ02cD2AX7IX6aRlHD6oNm6teyODfw65Z6ERuRzSwYdOi
         fKjvls7McVgVh2JLRejnzgUUTyNn0XdnpmnKbn2DkIdJplRpv8FzkI3bgY8ZgfwhF7ge
         F6/w==
X-Gm-Message-State: AOAM533AUsmqpxZCWgTZCA4utj/440drqZREzybJpeaZKRBqtui0hA+Z
        phPtWh6lCu1A3UMVF8idYZPm5w==
X-Google-Smtp-Source: ABdhPJxnuLQnkiQude49owGTZwZUuIJCfFEIK3DAkRAJwOoeGJ3jrZczVgKfX3aKaMnTZswvZACW4w==
X-Received: by 2002:a17:90b:224c:: with SMTP id hk12mr5274735pjb.37.1620314976720;
        Thu, 06 May 2021 08:29:36 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d188sm2482589pfd.203.2021.05.06.08.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 08:29:36 -0700 (PDT)
Date:   Thu, 6 May 2021 15:29:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Fix pf_fixed count in
 tdp_mmu_map_handle_target_level()
Message-ID: <YJQLXH/qebWuzLmF@google.com>
References: <cover.1620200410.git.kai.huang@intel.com>
 <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
 <CANgfPd-hf-+trgTWe=pjjuWSEyVn8F4WyZ4p5kqaMiqghjseew@mail.gmail.com>
 <193d473bdfcefa8a552a787025642eb90d3b9e18.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <193d473bdfcefa8a552a787025642eb90d3b9e18.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021, Kai Huang wrote:
> On Wed, 2021-05-05 at 09:11 -0700, Ben Gardon wrote:
> > It would probably also be worth putting a comment on pf_fixed so that
> > people in the future know what it's supposed to mean and we don't get
> > into archeology, reverse engineering the meaning of the stat again.
> 
> It seems the legacy MMU code path is a better place to add the comment to explain when
> pf_fixed should be increased.  However I am not sure whether it is necessary for this
> patch (and I confess I found it's hard to explain why to increase pf_fixed in case of
> emulation :)).  Or perhaps Sean can write a patch to add comment to legacy MMU :)

Ya, I think it makes sense to hold off on documenting the existing behavior in
the TDP MMU.  As is often the case in KVM, just because KVM has always done
something one way, doesn't mean it's correct/ideal.  But, bikeshedding over what
faults exactly should count towards pf_fixed is best left to a separate patch.

> I ended up with  below, by adding a comment in TDP MMU saying "to make it consistent with
> legacy MMU...", and in the commit message, I put a lore link of this discussion, since I
> found Sean's explanation is quite useful. When people are interested in, they can do a git
> blame and find the commit msg of this change -- although it is not as straightforward as
> having comment directly.
> 
> Is this OK to you?
> 
> And Sean?

Yep, works for me.
