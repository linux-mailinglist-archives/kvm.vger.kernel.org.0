Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B4B145904
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 16:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgAVPvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 10:51:10 -0500
Received: from mga14.intel.com ([192.55.52.115]:54041 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgAVPvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 10:51:09 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2020 07:51:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,350,1574150400"; 
   d="scan'208";a="425895201"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 22 Jan 2020 07:51:09 -0800
Date:   Wed, 22 Jan 2020 07:51:08 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
Message-ID: <20200122155108.GA7201@linux.intel.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
 <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com>
 <20200122054724.GD18513@linux.intel.com>
 <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com>
 <87eevrsf3s.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eevrsf3s.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 22, 2020 at 04:08:55PM +0100, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
> > On 22/01/20 06:47, Sean Christopherson wrote:
> >>> Yes, it most likely is and it would be nice if Microsoft fixed it, but I
> >>> guess we're stuck with it for existing Windows versions.  Well, for one
> >>> we found a bug in Hyper-V and not the converse. :)
> >>>
> >>> There is a problem with this approach, in that we're stuck with it
> >>> forever due to live migration.  But I guess if in the future eVMCS v2
> >>> adds an apic_address field we can limit the hack to eVMCS v1.  Another
> >>> possibility is to use the quirks mechanism but it's overkill for now.
> >>>
> >>> Unless there are objections, I plan to apply these patches.
> >> Doesn't applying this patch contradict your earlier opinion?  This patch
> >> would still hide the affected controls from the guest because the host
> >> controls enlightened_vmcs_enabled.
> >
> > It does.  Unfortunately the key sentence is "we're stuck with it for
> > existing Windows versions". :(

Ah, I didn't understand what "it" referred to :-)

> >> Rather than update vmx->nested.msrs or filter vmx_get_msr(), what about
> >> manually adding eVMCS consistency checks on the disallowed bits and handle
> >> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES as a one-off case by simply
> >> clearing it from the eVMCS?  Or alternatively, squashing all the disallowed
> >> bits.
> >
> > Hmm, that is also a possibility.  It's a very hacky one, but I guess
> > adding APIC virtualization to eVMCS would require bumping the version to
> > 2.  Vitaly, what do you think?
> 
> As I already replied to Sean I like the idea to filter out unsupported
> controls from eVMCS but unfortunately it doesn't work: Hyper-V actually
> expects APIC virtualization to work when it enables
> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES (I have no idea how without
> apic_access_addr field but). I checked and at least Hyper-V 2016 doesn't
> boot (when >1 vCPU).

Nice.

I still don't see what we gain from applying this patch.  Once eVMCS is
enabled by userspace, which presumably happens before the guest is launched,
the guest will see the eVMCS-unfriendly controls as being unsupported, both
for eVMCS and regular VMCS.  AFAICT, we're adding a fairly ugly hack to KVM
just so that KVM can lie to userspace about what controls will be exposed to
the guest.

Can we extend the API to use cap->args[1] to control whether or not the
unsupported controls are removed from vmx->nested.msrs?  Userspace could
pass '1' to leave the controls untouched and then surgically hide the
controls that the guest is too dumb to know it shouldn't use by writing the
appropriate MSRs.  Assuming existing userspace is expected/required to zero
out args[1..3], this would be fully backwards compatible.


diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 72359709cdc1..241a769be738 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -346,8 +346,8 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
        return 0;
 }

-int nested_enable_evmcs(struct kvm_vcpu *vcpu,
-                       uint16_t *vmcs_version)
+int nested_enable_evmcs(struct kvm_vcpu *vcpu, uint16_t *vmcs_version,
+                       bool allow_unsupported_controls)
 {
        struct vcpu_vmx *vmx = to_vmx(vcpu);
        bool evmcs_already_enabled = vmx->nested.enlightened_vmcs_enabled;
@@ -358,7 +358,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
                *vmcs_version = nested_get_evmcs_version(vcpu);

        /* We don't support disabling the feature for simplicity. */
-       if (evmcs_already_enabled)
+       if (evmcs_already_enabled || allow_unsupported_controls)
                return 0;

        vmx->nested.msrs.pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0cccc52e2d0a..5e1b8d51277b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4005,7 +4005,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
        case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
                if (!kvm_x86_ops->nested_enable_evmcs)
                        return -ENOTTY;
-               r = kvm_x86_ops->nested_enable_evmcs(vcpu, &vmcs_version);
+               r = kvm_x86_ops->nested_enable_evmcs(vcpu, &vmcs_version,
+                                                    cap->args[1]);
                if (!r) {
                        user_ptr = (void __user *)(uintptr_t)cap->args[0];
                        if (copy_to_user(user_ptr, &vmcs_version,
