Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DA3BFD0F
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 04:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfI0CP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 22:15:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:26834 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbfI0CP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 22:15:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 19:15:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="194333780"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.164]) ([10.239.196.164])
  by orsmga006.jf.intel.com with ESMTP; 26 Sep 2019 19:15:25 -0700
Subject: Re: Suggest changing commit "KVM: vmx: Introduce
 handle_unexpected_vmexit and handle WAITPKG vmexit"
To:     Liran Alon <liran.alon@oracle.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <B57A2AAE-9F9F-4697-8EFE-5F1CF4D8F7BC@oracle.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <8edd1d4c-03df-56e5-a5b1-aece3c85962a@intel.com>
Date:   Fri, 27 Sep 2019 10:15:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <B57A2AAE-9F9F-4697-8EFE-5F1CF4D8F7BC@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/2019 7:24 PM, Liran Alon wrote:
> 
> I just reviewed the patch "KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit” currently queued in kvm git tree
> (https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?h=queue&id=bf653b78f9608d66db174eabcbda7454c8fde6d5)
> 
> It seems to me that we shouldn’t apply this patch in it’s current form.
> 
> Instead of having a common handle_unexpected_vmexit() manually specified for specific VMExit reasons,
> we should rely on the functionality I have added to vmx_handle_exit() in case there is no valid handler for exit-reason.
> In this case (since commit 7396d337cfadc ("KVM: x86: Return to userspace with internal error on unexpected exit reason”),
> an internal-error will be raised to userspace as required. Instead of silently skipping emulated instruction.
> 
> -Liran
> 

+Sean

Hi Liran,

After read your code, I understand your suggestion. But if we don't add 
exit reason for XSAVES/XRSTORS/UMWAIT/TPAUSE like this:

@@ -5565,13 +5559,15 @@ static int (*kvm_vmx_exit_handlers[])(struct 
kvm_vcpu *vcpu) = {
[...]
-	[EXIT_REASON_XSAVES]                  = handle_xsaves,
-	[EXIT_REASON_XRSTORS]                 = handle_xrstors,
+	[EXIT_REASON_XSAVES]                  = NULL,
+	[EXIT_REASON_XRSTORS]                 = NULL,
[...]
+	[EXIT_REASON_UMWAIT]                  = NULL,
+	[EXIT_REASON_TPAUSE]                  = NULL,

It is confused when someone read these code. So how about I move your 
code chunk:

vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
                 exit_reason);
dump_vmcs();
vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
vcpu->run->internal.suberror =
         KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
vcpu->run->internal.ndata = 1;
vcpu->run->internal.data[0] = exit_reason;

into handle_unexpected_vmexit(), then this function become:

static int handle_unexpected_vmexit(struct kvm_vcpu *vcpu)
{
	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
                 exit_reason);
	dump_vmcs();
	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
	vcpu->run->internal.suberror =
         	KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
	vcpu->run->internal.ndata = 1;
	vcpu->run->internal.data[0] = to_vmx(cpu)->exit_reason;
	return 0;
}

Then vmx_handle_exit() also can call this function.

How about this solution?

Tao
