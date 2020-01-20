Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A77714221C
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 04:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgATDrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 22:47:12 -0500
Received: from ozlabs.org ([203.11.71.1]:44663 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgATDrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 22:47:12 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 481Hfj74CGz9sRK; Mon, 20 Jan 2020 14:47:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1579492030; bh=1dfZ9T6ilNfzX2EqbpEQ5eAKgIEJ6P5R1+t5DDy1LSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JwTKZpUVsDbJ4TcBhEsofl/FKEJ5tQrZ9Aj0R5fO2fk6ipXMh/Ze+fuyk+OikxvSN
         67/wLRnHG2mDyEw8LSp8oRMr2p5aKIS1bUJ4t3GOuRZbsLyzpzHmOuZ2qTHBGOqfbF
         moZ/eN5AqS9TPo6UXaN5U6ooTa7+OmIYkvdmFYWqpFVxDhUrMzJ34X8IxIDq0Ms2f6
         wkQCV272ypuxGDczKD0+9/Hd5WXIkWzuKDoo+s7KsL/R/o3ah5CvtNtzTmgEF5QLDA
         JoX9Oljp4OG49H/vTZPOusq/ctGjNpNJBsOmEo+EUk8lzjUU+oofoyANvdWbPRrwrC
         HNXz1928tQDng==
Date:   Mon, 20 Jan 2020 14:46:58 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 41/45] KVM: PPC: Move all vcpu init code into
 kvm_arch_vcpu_create()
Message-ID: <20200120034658.GD14307@blackberry>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-42-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191218215530.2280-42-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 01:55:26PM -0800, Sean Christopherson wrote:
> Fold init() into create() now that the two are called back-to-back by
> common KVM code (kvm_vcpu_init() calls kvm_arch_vcpu_init() as its last
> action, and kvm_vm_ioctl_create_vcpu() calls kvm_arch_vcpu_create()
> immediately thereafter).  Rinse and repeat for kvm_arch_vcpu_uninit()
> and kvm_arch_vcpu_destroy().  This paves the way for removing
> kvm_arch_vcpu_{un}init() entirely.
> 
> Note, calling kvmppc_mmu_destroy() if kvmppc_core_vcpu_create() fails
> may or may not be necessary.  Move it along with the more obvious call
> to kvmppc_subarch_vcpu_uninit() so as not to inadvertantly introduce a
> functional change and/or bug.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

This doesn't compile.  I get:

  CC [M]  arch/powerpc/kvm/powerpc.o
/home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c: In function ‘kvm_arch_vcpu_create’:
/home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c:733:34: error: ‘kvmppc_decrementer_wakeup’ undeclared (first use in this function)
  vcpu->arch.dec_timer.function = kvmppc_decrementer_wakeup;
                                  ^
/home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c:733:34: note: each undeclared identifier is reported only once for each function it appears in
/home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c: At top level:
/home/paulus/kernel/kvm/arch/powerpc/kvm/powerpc.c:794:29: warning: ‘kvmppc_decrementer_wakeup’ defined but not used [-Wunused-function]
 static enum hrtimer_restart kvmppc_decrementer_wakeup(struct hrtimer *timer)
                             ^
make[3]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:266: arch/powerpc/kvm/powerpc.o] Error 1

The problem is that kvmppc_decrementer_wakeup() is a static function
defined in this file (arch/powerpc/kvm/powerpc.c) after
kvm_arch_vcpu_create() but before kvm_arch_vcpu_init().  You need a
forward static declaration of kvmppc_decrementer_wakeup() before
kvm_arch_vcpu_create(), or else move one or other function.

Paul.
