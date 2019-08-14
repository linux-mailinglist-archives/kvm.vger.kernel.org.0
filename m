Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEF58CEE5
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 10:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfHNI76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 04:59:58 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:51554 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbfHNI75 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Aug 2019 04:59:57 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2019 04:59:56 EDT
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id EA3D63016E60;
        Wed, 14 Aug 2019 11:53:24 +0300 (EEST)
Received: from [10.17.91.220] (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D9D8D3011E05;
        Wed, 14 Aug 2019 11:53:24 +0300 (EEST)
Message-ID: <3f22404e0d1b7dff45d81516318787c79b7d7eec.camel@bitdefender.com>
Subject: Re: [RFC PATCH v6 76/92] kvm: x86: disable EPT A/D bits if
 introspection is present
From:   Mihai =?UTF-8?Q?Don=C8=9Bu?= <mdontu@bitdefender.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Adalbert =?UTF-8?Q?Laz=C4=83r?= <alazar@bitdefender.com>
Date:   Wed, 14 Aug 2019 11:53:24 +0300
In-Reply-To: <662761e1-5709-663f-524f-579f8eba4060@redhat.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
         <20190809160047.8319-77-alazar@bitdefender.com>
         <9f8b31c5-2252-ddc5-2371-9c0959ac5a18@redhat.com>
         <0550f8d65bb97486e98d88255ea45d490da6b802.camel@bitdefender.com>
         <662761e1-5709-663f-524f-579f8eba4060@redhat.com>
Organization: Bitdefender
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-08-13 at 23:05 +0200, Paolo Bonzini wrote:
> On 13/08/19 20:36, Mihai Donțu wrote:
> > > Why?
> > When EPT A/D is enabled, all guest page table walks are treated as
> > writes (like AMD's NPT). Thus, an introspection tool hooking the guest
> > page tables would trigger a flood of VMEXITs (EPT write violations)
> > that will get the introspected VM into an unusable state.
> > 
> > Our implementation of such an introspection tool builds a cache of
> > {cr3, gva} -> gpa, which is why it needs to monitor all guest PTs by
> > hooking them for write.
> 
> Please include the kvm list too.

I apologize. I did not notice I trimmed the CC list.

> One issue here is that it changes the nested VMX ABI.  Can you leave EPT
> A/D in place for the shadow EPT MMU, but not for "regular" EPT pages?

I'm not sure I follow. Something like this?

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 48e3cdd7b009..569e8f4d5dd7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2853,7 +2853,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
        eptp |= (get_ept_level(vcpu) == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
 
        if (enable_ept_ad_bits &&
-           (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
+           ((!is_guest_mode(vcpu) && !kvmi_is_present()) || nested_ept_ad_enabled(vcpu)))
                eptp |= VMX_EPTP_AD_ENABLE_BIT;
        eptp |= (root_hpa & PAGE_MASK);

> Also, what is the state of introspection support on AMD?

The way we'd like to do introspection is not currently possible on AMD
CPUs. The reasons being:
 * the NPT has the behavior I talked above (guest PT walks translate to
   writes)
 * it is not possible to mark a guest page as execute-only
 * there is no equivalent to Intel's MTF, though it can _probably_ be
   emulated using a creative trick involving the debug registers

If, however, none of the above are of importance for other users,
everything else should work. I have to admit, though, we have not done
any tests.

Regards,

-- 
Mihai Donțu


