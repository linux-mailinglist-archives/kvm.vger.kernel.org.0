Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC93142247
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 05:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgATEEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 23:04:20 -0500
Received: from ozlabs.org ([203.11.71.1]:51483 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgATEEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 23:04:20 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 481J2T5VvKz9sRQ; Mon, 20 Jan 2020 15:04:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1579493057; bh=GlIncoWYmOYv5Dni23RSwo6uZojZl918YWnmGeGzyJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V/Pa+sHEae+jG71OR9r2A404DaS5UBDnEl6W5GR08hXip3iEYMnPJKOgSS38mznMS
         QFzFYRElYmpf39vGFlmcBXqAVGdMsLFjm/U25lpx6q0fNhotMfBPwIAqSNRKv/jocP
         A5kGrOXz8juIsyZkgL8m65HZO5Fh3mx4+Y9Ux1ecPuIMT+sYjoMy+YSKDxMsJPTVPp
         HQfIaljJGxLrxk3xUQeJAE38M8fGC3e1O4wLIfYvDRR2aZSLUNac6unBI8qCtwWfOb
         HgwP/Q9WG5+8ApO9XCFy1bxiLQ13UNNmnGOK8PeEgB/i16xsXwKAaVRbebZ2djABCZ
         zP8/aQGwqo1nw==
Date:   Mon, 20 Jan 2020 15:04:12 +1100
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
Subject: Re: [PATCH v2 12/45] KVM: PPC: Allocate vcpu struct in common PPC
 code
Message-ID: <20200120040412.GF14307@blackberry>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-13-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191218215530.2280-13-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 01:54:57PM -0800, Sean Christopherson wrote:
> Move allocation of all flavors of PPC vCPUs to common PPC code.  All
> variants either allocate 'struct kvm_vcpu' directly, or require that
> the embedded 'struct kvm_vcpu' member be located at offset 0, i.e.
> guarantee that the allocation can be directly interpreted as a 'struct
> kvm_vcpu' object.
> 
> Remove the message from the build-time assertion regarding placement of
> the struct, as compatibility with the arch usercopy region is no longer
> the sole dependent on 'struct kvm_vcpu' being at offset zero.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

This fails to compile for Book E configs:

  CC      arch/powerpc/kvm/e500.o
/home/paulus/kernel/kvm/arch/powerpc/kvm/e500.c: In function ‘kvmppc_core_vcpu_create_e500’:
/home/paulus/kernel/kvm/arch/powerpc/kvm/e500.c:464:9: error: return makes integer from pointer without a cast [-Werror=int-conversion]
  return vcpu;
         ^
cc1: all warnings being treated as errors
make[3]: *** [/home/paulus/kernel/kvm/scripts/Makefile.build:266: arch/powerpc/kvm/e500.o] Error 1

There is a "return vcpu" statement in kvmppc_core_vcpu_create_e500(),
and another in kvmppc_core_vcpu_create_e500mc(), which both need to be
changed to "return 0".

(By the way, I do appreciate you fixing the PPC code, even if there
are some errors.)

Paul.
