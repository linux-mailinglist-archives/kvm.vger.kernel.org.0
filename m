Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA0717FAF
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 20:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfEHSNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 14:13:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:34688 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfEHSNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 14:13:40 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 11:13:39 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 08 May 2019 11:13:40 -0700
Date:   Wed, 8 May 2019 11:13:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2] kvm: nVMX: Set nested_run_pending in
 vmx_set_nested_state after checks complete
Message-ID: <20190508181339.GD19656@linux.intel.com>
References: <1557317799-39866-1-git-send-email-pbonzini@redhat.com>
 <20190508142023.GA13834@linux.intel.com>
 <CAAAPnDE0ujH4eTX=4umTTEmUMyaZ7M0B3qxWa7oUUD-Ls7Ta+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <CAAAPnDE0ujH4eTX=4umTTEmUMyaZ7M0B3qxWa7oUUD-Ls7Ta+A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2019 at 10:53:12AM -0700, Aaron Lewis wrote:
> nested_run_pending is also checked in
> nested_vmx_check_vmentry_postreqs
> (https://elixir.bootlin.com/linux/v5.1/source/arch/x86/kvm/vmx/nested.c#L2709)
> so I think the setting needs to be moved to just prior to that call
> with Paolo's rollback along with another for if the prereqs and
> postreqs fail.  I put a patch together below:

Gah, I missed that usage (also, it's now nested_vmx_check_guest_state()).

Side topic, I think the VM_ENTRY_LOAD_BNDCFGS check should be gated by
nested_run_pending, a la the EFER check.'

> ------------------------------------
> 
> nested_run_pending=1 implies we have successfully entered guest mode.
> Move setting from external state in vmx_set_nested_state() until after
> all other checks are complete.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6401eb7ef19c..cf1f810223d2 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5460,9 +5460,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
>   return 0;
> 
> - vmx->nested.nested_run_pending =
> - !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);

Alternatively, it might be better to leave nested_run_pending where it
is and instead add a label to handle clearing the flag on error.  IIUC,
the real issue is that nested_run_pending is left set after a failed
vmx_set_nested_state(), not that its shouldn't be set in the shadow
VMCS handling.

Patch attached, though it's completely untested.  The KVM selftests are
broken for me right now, grrr.

> -
>   if (nested_cpu_has_shadow_vmcs(vmcs12) &&
>       vmcs12->vmcs_link_pointer != -1ull) {
>   struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
> @@ -5480,14 +5477,21 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   return -EINVAL;
>   }
> 
> + vmx->nested.nested_run_pending =
> + !!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> +
>   if (nested_vmx_check_vmentry_prereqs(vcpu, vmcs12) ||
> -     nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual))
> +     nested_vmx_check_vmentry_postreqs(vcpu, vmcs12, &exit_qual)) {
> +     vmx->nested.nested_run_pending = 0;
>   return -EINVAL;
> + }
> 
>   vmx->nested.dirty_vmcs12 = true;
>   ret = nested_vmx_enter_non_root_mode(vcpu, false);
> - if (ret)
> + if (ret) {
> + vmx->nested.nested_run_pending = 0;
>   return -EINVAL;
> + }
> 
>   return 0;
>  }

--zYM0uCDKw75PZbzx
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-KVM-nVMX-Clear-nested_run_pending-if-setting-nested-.patch"

From 279ce1be96d74aee41e93b597572e612a143cf3c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 8 May 2019 11:04:32 -0700
Subject: [PATCH] KVM: nVMX: Clear nested_run_pending if setting nested state
 fails

VMX's nested_run_pending flag is subtly consumed when stuffing state to
enter guest mode, i.e. needs to be set according before KVM knows if
setting guest state is successful.  If setting guest state fails, clear
the flag as a nested run is obviously not pending.

Reported-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 04b40a98f60b..1a2a2f91b7e0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5428,29 +5428,33 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
 
 		if (kvm_state->size < sizeof(kvm_state) + 2 * sizeof(*vmcs12))
-			return -EINVAL;
+			goto error_guest_mode;
 
 		if (copy_from_user(shadow_vmcs12,
 				   user_kvm_nested_state->data + VMCS12_SIZE,
 				   sizeof(*vmcs12)))
-			return -EFAULT;
+			goto error_guest_mode;
 
 		if (shadow_vmcs12->hdr.revision_id != VMCS12_REVISION ||
 		    !shadow_vmcs12->hdr.shadow_vmcs)
-			return -EINVAL;
+			goto error_guest_mode;
 	}
 
 	if (nested_vmx_check_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_host_state(vcpu, vmcs12) ||
 	    nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
-		return -EINVAL;
+		goto error_guest_mode;
 
 	vmx->nested.dirty_vmcs12 = true;
 	ret = nested_vmx_enter_non_root_mode(vcpu, false);
 	if (ret)
-		return -EINVAL;
+		goto error_guest_mode;
 
 	return 0;
+
+error_guest_mode:
+	vmx->nested.nested_run_pending = 0;
+	return -EINVAL;
 }
 
 void nested_vmx_vcpu_setup(void)
-- 
2.21.0


--zYM0uCDKw75PZbzx--
