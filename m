Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342A91F6B73
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgFKPqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 11:46:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:65327 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728641AbgFKPqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 11:46:15 -0400
IronPort-SDR: BEE35dJE/e7S9qJOUK5gq/Ks5JMWMDxyf90+eru9Cqn07jAhbDg79yv/VqSHhN4yj0OqnVyhxf
 kQO8kCzTLrcA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 08:46:15 -0700
IronPort-SDR: 3iKlFSNmGLJIQjG6i4tV9DKlsjIjo/kGZ/UFziPeMJdfG9W3E92AKxhhodHCTS+EuQk+hqoqc0
 jidNOjbX/9Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="419145052"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 11 Jun 2020 08:46:15 -0700
Date:   Thu, 11 Jun 2020 08:46:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>
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
Subject: Re: [PATCH 18/21] KVM: arm64: Use common KVM implementation of MMU
 memory caches
Message-ID: <20200611154615.GG29918@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-19-sean.j.christopherson@intel.com>
 <3555daf3b38c890e1e74f05d6f49f9be@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3555daf3b38c890e1e74f05d6f49f9be@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 09:01:44AM +0100, Marc Zyngier wrote:
> On 2020-06-05 22:38, Sean Christopherson wrote:

...

> >@@ -1024,7 +993,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm,
> >struct kvm_mmu_memory_cache *cache
> > 	if (stage2_pgd_none(kvm, *pgd)) {
> > 		if (!cache)
> > 			return NULL;
> >-		pud = mmu_memory_cache_alloc(cache);
> >+		pud = kvm_mmu_memory_cache_alloc(cache);
> > 		stage2_pgd_populate(kvm, pgd, pud);
> > 		get_page(virt_to_page(pgd));
> > 	}
> 
> Quick note: this patch (as it is) breaks on arm64 due to Mike Rapoport's
> P4D rework. I've fixed it locally in order to test the series.

Good to know, I'll wait to send v2 until that gets pulled into Paolo's tree.
Thanks for the heads up, and especially for testing!
