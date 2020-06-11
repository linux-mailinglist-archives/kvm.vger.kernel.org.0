Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E0C1F6346
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 10:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgFKIGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 04:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgFKIGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 04:06:52 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6D4A2074B;
        Thu, 11 Jun 2020 08:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591862812;
        bh=c0zbTaBdIyfBYHMbVLwq48idCED4RJbRflyqGdC0K5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fM3iQGrBseiVVoOOA7lzVDDThz+MiyAGJ3OAf4hwCs1yjKcFgJ81l7yITe79GF4n2
         LkKEwYH+yZmvNv/zMU0waQ1zKjn/HpTPXIk6SN6kvpC7KFpuaLuXBHg65vRQw68oAL
         OLoKHtUw+jx/rmHTSOGST2f9KCACyq7jNQMYGoTc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jjIEc-0021ee-Gz; Thu, 11 Jun 2020 09:06:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 11 Jun 2020 09:06:50 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 00/21] KVM: Cleanup and unify kvm_mmu_memory_cache usage
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <bedae60cc8a6c6c3b77b52e3d3c7bbe2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org, pfeiner@google.com, pshier@google.com, junaids@google.com, bgardon@google.com, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2020-06-05 22:38, Sean Christopherson wrote:
> This series resurrects Christoffer Dall's series[1] to provide a common
> MMU memory cache implementation that can be shared by x86, arm64 and 
> MIPS.
> 
> It also picks up a suggested change from Ben Gardon[2] to clear shadow
> page tables during initial allocation so as to avoid clearing entire
> pages while holding mmu_lock.
> 
> The front half of the patches do house cleaning on x86's memory cache
> implementation in preparation for moving it to common code, along with 
> a
> fair bit of cleanup on the usage.  The middle chunk moves the patches 
> to
> common KVM, and the last two chunks convert arm64 and MIPS to the 
> common
> implementation.
> 
> Cleanup aside, the notable difference from Christoffer and Ben's 
> proposed
> patches is to make __GFP_ZERO optional, e.g. to allow x86 to skip 
> zeroing
> for its gfns array and to provide line of sight for my
> cannot-yet-be-discussed-in-detail use case for non-zero initialized 
> shadow
> page tables[3].
> 
> Tested on x86 only, no testing whatsoever on arm64 or MIPS.

I've given it a go on a small bunch of arm64 boxes, and nothing caught 
fire!
As Ben noticed, the series isn't bisectable (easily fixed) and there is 
some
nagging conflicts with the current state of mainline.

Overall, a very welcome cleanup. The only point of contention is the 
change
in allocation accounting on arm64, but there is an easy fix for that.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
