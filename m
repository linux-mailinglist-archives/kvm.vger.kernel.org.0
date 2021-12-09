Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CD346E035
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 02:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241844AbhLIBZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 20:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbhLIBZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 20:25:24 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAF0C0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 17:21:51 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id m15so3605663pgu.11
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 17:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w/2SmMvf9K2cSdfzoqFxaQEz5ChfX3X+U4tpykInEaw=;
        b=mwo4lkEwwBUJir6tlHp+fTlpznBWkrUVJWP6QbZ5pFMr6tlT8/+dDemVj+2n6BkTOn
         4foW2SIczEF7RvWwmSMmZkjJ3ZECtRLD8eT7j0xTPchQT7UOBr2cwvPb9Nc8lEFq0KPZ
         sQUyDXN+GiJEU8JE632N4Uzjaxve4XAIzgC+0ydwRt2EuALsfbe1hcATX79u+qFSOyXs
         1reWxe3BoV10R3ZwKDEOhh5ANxW/6YIVqVSOo0Dqc6V7CvckS81Q1plLbqepubpr6NWD
         xDHqKxVx3MwW/Wl2r9CkHrr0Sj13+n/+ID+X7pAk//ybTFsQkOzfJYNU1fau4dtGJupq
         kBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w/2SmMvf9K2cSdfzoqFxaQEz5ChfX3X+U4tpykInEaw=;
        b=KR34yULCstf01RFIEnIHwxoNOSaUFaL4fqW83/We3yxv132StTT2ZtCX7Yo2yLV5gM
         Vl6Gq41Tm1Rea3D3BtKIFvCgOQMfBGc/HiYAMeDKzF82JvV+fTo30NtxKzA5n//HkF/7
         UvM2fya0G1KtTHNtY4lV8/LZgIPmDyzMEZCgGufK7UfDB7aG5vP7ICQeGo6k4Ycl6iXD
         DiADGeLvrLAlJDoOPZdyvz1kJhLFPrD98zsqTXMUH70T1sf+7YJDjOaxpcBRlylpUX9I
         ecu4FWmEZRQjN7I7vHC3L/6+90H4O6XEYt4WGlO60ico+I2FlOZBUJPKqdlp0tnM/n+f
         y4TQ==
X-Gm-Message-State: AOAM531Wt9eHz+7/L/7FDX1oQgN3dCNKDTguxUSn9C4mO4vaNbZncny+
        kFRcqhSR32h0/wtq+7dqOYLlXA==
X-Google-Smtp-Source: ABdhPJyzY+aozezUHQm+uFO0WdH/nyLw/UF99ZDTG9ckrSFpFzI7DHGTlNtknPEeWMOSrwtiXY60uw==
X-Received: by 2002:a63:c003:: with SMTP id h3mr32145470pgg.261.1639012911092;
        Wed, 08 Dec 2021 17:21:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v1sm4550953pfg.169.2021.12.08.17.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 17:21:50 -0800 (PST)
Date:   Thu, 9 Dec 2021 01:21:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 1/12] KVM: X86: Fix when shadow_root_level=5 && guest
 root_level<4
Message-ID: <YbFaK8E3hg5lVX/X@google.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
 <20211124122055.64424-2-jiangshanlai@gmail.com>
 <YbFY533IT3XSIqAK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbFY533IT3XSIqAK@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021, Sean Christopherson wrote:
> On Wed, Nov 24, 2021, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > 
> > If the is an L1 with nNPT in 32bit, the shadow walk starts with
> > pae_root.
> > 
> > Fixes: a717a780fc4e ("KVM: x86/mmu: Support shadowing NPT when 5-level paging is enabled in host)
> 
> Have you actually run with 5-level nNPT?  I don't have access to hardware, at least
> not that I know of :-)
> 
> I'm staring at kvm_mmu_sync_roots() and don't see how it can possibly work for
> 5-level nNPT with a 4-level NPT guest.

Oh, and fast_pgd_switch() will also break kvm_mmu_sync_prev_roots() / is_unsync_root()
by putting a root into the prev_roots array that doesn't have a shadow page associated
with the root.
