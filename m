Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B933668DB
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 12:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238927AbhDUKIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 06:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234167AbhDUKIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 06:08:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB14061426;
        Wed, 21 Apr 2021 10:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618999682;
        bh=eHEN+xvNv4YvU+0kUZBZ3dRo7lQ+OlH7NJjZpac5BbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g1fuwgqnoh/Ym/yBUqnjAw2rN1I+ohrypyyfq/LsVvNuVkv9H3XckngYL7si70auc
         yv32NU0Kh7QrS7uJfN0zg6x6LREXuKcOfc81t7ydLdD/UlWeU7ZvsMvWfLa+QA8JT7
         btm8fjdQhYLJPUyrjEmC0iQ/Zp8lbmUJi6IS6kB/6uyrSsL3s/PoCre44uGfVOnMcS
         qNd9U9STGXTd/TE+Ty872pTr9GE0L2QxW7BNQ6HkkNBM0dFKJ9PCyRnM3HDTq3MX5P
         zM3wFEo/f2fwKO1xcGVgmUxbBr9BmuzB4orh3ykFXczRS05C8TVBfgTRWfK8Cp/P22
         Dfgc0N999AfAQ==
Date:   Wed, 21 Apr 2021 12:07:59 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v3 3/9] KVM: x86: Defer tick-based accounting 'til after
 IRQ handling
Message-ID: <20210421100759.GA16580@lothringen>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415222106.1643837-4-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 03:21:00PM -0700, Sean Christopherson wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> When using tick-based accounting, defer the call to account guest time
> until after servicing any IRQ(s) that happened in the guest or
> immediately after VM-Exit.  Tick-based accounting of vCPU time relies on
> PF_VCPU being set when the tick IRQ handler runs, and IRQs are blocked
> throughout {svm,vmx}_vcpu_enter_exit().

Out of curiosity, how has guest accounting ever managed to work if we have always
cleared PF_VCPU before re-enabling interrupt?

Thanks.
