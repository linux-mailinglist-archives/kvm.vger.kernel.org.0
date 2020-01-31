Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F0314F273
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 19:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgAaSzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 13:55:35 -0500
Received: from mga18.intel.com ([134.134.136.126]:30623 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgAaSze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 13:55:34 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:55:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="253419672"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2020 10:55:32 -0800
Date:   Fri, 31 Jan 2020 10:55:32 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: x86: Set kvm_x86_ops only after
 ->hardware_setup() completes
Message-ID: <20200131185531.GB18946@linux.intel.com>
References: <20200130001023.24339-1-sean.j.christopherson@intel.com>
 <20200130001023.24339-6-sean.j.christopherson@intel.com>
 <44e0c550-7dcc-bfed-07c4-907e61d476a1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44e0c550-7dcc-bfed-07c4-907e61d476a1@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 30, 2020 at 06:44:09AM +0100, Paolo Bonzini wrote:
> On 30/01/20 01:10, Sean Christopherson wrote:
> > Set kvm_x86_ops with the vendor's ops only after ->hardware_setup()
> > completes to "prevent" using kvm_x86_ops before they are ready, i.e. to
> > generate a null pointer fault instead of silently consuming unconfigured
> > state.
> 
> What about even copying kvm_x86_ops by value, so that they can be
> accessed with "kvm_x86_ops.callback()" and save one memory access?

Oooh, I like that idea.  And {svm,vmx}_x86_ops could be marked __initdata
to save a few bytes and force all the runtime stuff through kvm_x86_ops.
