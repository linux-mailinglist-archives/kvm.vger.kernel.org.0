Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B60177A36
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgCCPRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:17:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:9324 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgCCPRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:17:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 07:17:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="228943917"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2020 07:17:21 -0800
Date:   Tue, 3 Mar 2020 07:17:21 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 01/66] KVM: x86: Return -E2BIG when
 KVM_GET_SUPPORTED_CPUID hits max entries
Message-ID: <20200303151721.GB1439@linux.intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-2-sean.j.christopherson@intel.com>
 <599c3a95-a0a6-b31d-56a6-c50971d4ab59@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <599c3a95-a0a6-b31d-56a6-c50971d4ab59@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 03:16:16PM +0100, Paolo Bonzini wrote:
> On 03/03/20 00:56, Sean Christopherson wrote:
> > (KVM hard caps CPUID 0xD at a single sub-leaf).
> 
> Hmm... no it doesn't?
> 
>                 for (idx = 1, i = 1; idx < 64; ++idx) {
>                         u64 mask = ((u64)1 << idx);
>                         if (*nent >= maxnent)
>                                 goto out;
> 
>                         do_host_cpuid(&entry[i], function, idx);
>                         if (idx == 1) {
>                                 entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
>                                 cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
>                                 entry[i].ebx = 0;
>                                 if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
>                                         entry[i].ebx =
>                                                 xstate_required_size(supported,
>                                                                      true);
>                         } else {
>                                 if (entry[i].eax == 0 || !(supported & mask))
>                                         continue;
>                                 if (WARN_ON_ONCE(entry[i].ecx & 1))
>                                         continue;
>                         }
>                         entry[i].ecx = 0;
>                         entry[i].edx = 0;
>                         ++*nent;
>                         ++i;
>                 }

Ah rats, I was thinking of CPUID 0x7 when I wrote that.  Maybe just reword
it to "(KVM hard caps the number of CPUID 0xD sub-leafs)."?

> I still think the patch is correct, what matters is that no KVM in
> existence supports enough processor features to reach 100 or so subleaves.
