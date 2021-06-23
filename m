Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B634F3B1F10
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFWQ45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWQ44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 12:56:56 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E7FC061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:54:38 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w71so2798885pfd.4
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5KXLh/nNuoT2ip+063n2eXTSx2vwf4ghELGrq4CweBs=;
        b=bYJ9m9pbQXUrM2IqV1nrLjs6lJxm0fVWw+dFsqVA7AniCDGdowvlGS4CEx5gTLh9Tk
         SI91Bd5c7KzIymPTtKbif30Qih6kuvXD6vZ60Rmn3wdAyL5vX2KuuqCdFYu0BlY14eH4
         5TLVRb6ZpTlztQBPDPfMunK6xLB+5ubSahIqlasR9OfX+fTk1VNvP80/VMxN0SRmmlX3
         RC6AfwH2qMcavkijggcMqKF1JZ7s8B9dr5VAg3NjYjWFCh95Psx1WRtPClLh8eb7Siu4
         y9mS2I04geQKupZkwjiUv1+PjqRVz3AByO9NWas2BfOOSMrZohgaSoy2cbma0nTn05gK
         9Kvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5KXLh/nNuoT2ip+063n2eXTSx2vwf4ghELGrq4CweBs=;
        b=s5thBVkRM1rPPpG1ay3/q7/gOU9fPx7cXKNfCMU1KjueMqsT0bwhPwgQ8LALoPY0Ux
         7WVTxIenrvFQu7AAErwhT5WgOIC4oHwg5cfwVdV1OAqOehQqAU+IkvGL96U+U1/evOxO
         A2QwBCyvSB6m5mjBMfN8/II+GFcxNW2MUi25ISElIbdbCCV8D+GbuslYg82b1ADtnBZy
         Hnmk44sMvPT0Uwjm56QB0UJ2Nl8fNLtWsh/yFdIDyVXTgcroZZ8zaz75pPo/dHol/Rk5
         V05sbiyImGuKMsU3mlzDzRthoSe/MsikrZier2HHUrUvQ7KL4nIDlr/HW2TJZEf6hzvf
         Ve1A==
X-Gm-Message-State: AOAM532lZSjCLGUeaIg/QTW/w/ec+aRrdZGMr5J3MnSFt3EkuF4BjEph
        aijStHLcSgfECsrWYVFrdeLlPgcz29nRkw==
X-Google-Smtp-Source: ABdhPJyE+6Ht+AMUZlWTAssMYAqrIi1ovU/mM3yZDUc92doUyVKyW4sA31zIU7uZt6jGoz9SCNY5Gw==
X-Received: by 2002:a63:f850:: with SMTP id v16mr392047pgj.181.1624467278200;
        Wed, 23 Jun 2021 09:54:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b6sm385609pgw.67.2021.06.23.09.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:54:37 -0700 (PDT)
Date:   Wed, 23 Jun 2021 16:54:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 10/54] KVM: x86/mmu: Replace EPT shadow page shenanigans
 with simpler check
Message-ID: <YNNnSgVUYUewP2qK@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-11-seanjc@google.com>
 <8ce36922-dba0-9b53-6f74-82f3f68b443c@redhat.com>
 <YNNegF8RcF3vX2Sh@google.com>
 <df77b8e9-b2bb-b085-0789-909a8b9d44c3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df77b8e9-b2bb-b085-0789-909a8b9d44c3@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 23/06/21 18:17, Sean Christopherson wrote:
> > > What the commit message doesn't say is, did we miss this
> > > opportunity all along, or has there been a change since commit
> > > 47c42e6b4192 ("KVM: x86: fix handling of role.cr4_pae and rename it
> > > to 'gpte_size'", 2019-03-28) that allows this?
> > 
> > The code was wrong from the initial "unsync" commit.  The 4-byte vs.
> > 8-byte check papered over the real bug, which was that the roles were
> > not checked for compabitility.  I suspect that the bug only
> > manisfested as an observable problem when the GPTE sizes mismatched,
> > thus the PAE check was added.
> 
> I meant that we really never needed is_ept_sp, and you could have used the
> simpler check already at the time you introduced gpte_is_8_bytes. But anyway
> I think we're in agreement.

Ah, yes, I was too clever :-/
