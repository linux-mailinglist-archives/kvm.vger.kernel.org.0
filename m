Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BEA21ED8
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 22:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfEQUFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 16:05:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:39234 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbfEQUFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 16:05:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 13:05:10 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 17 May 2019 13:05:09 -0700
Date:   Fri, 17 May 2019 13:05:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v3 3/5] KVM: LAPIC: Expose per-vCPU timer_advance_ns to
 userspace
Message-ID: <20190517200509.GJ15006@linux.intel.com>
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
 <1557975980-9875-4-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557975980-9875-4-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 16, 2019 at 11:06:18AM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Expose per-vCPU timer_advance_ns to userspace, so it is able to 
> query the auto-adjusted value.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/debugfs.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index c19c7ed..a6f1f93 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -9,12 +9,22 @@
>   */
>  #include <linux/kvm_host.h>
>  #include <linux/debugfs.h>
> +#include "lapic.h"
>  
>  bool kvm_arch_has_vcpu_debugfs(void)
>  {
>  	return true;
>  }
>  
> +static int vcpu_get_timer_advance_ns(void *data, u64 *val)
> +{
> +	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
> +	*val = vcpu->arch.apic->lapic_timer.timer_advance_ns;

This needs to ensure to check lapic_in_kernel() to ensure apic isn't NULL.
Actually, I think we can skip creation of the parameter entirely if
lapic_in_kernel() is false.  VMX and SVM both instantiate the lapic
during kvm_arch_vcpu_create(), which is (obviously) called before
kvm_arch_create_vcpu_debugfs().

> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
> +
>  static int vcpu_get_tsc_offset(void *data, u64 *val)
>  {
>  	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
> @@ -51,6 +61,12 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>  	if (!ret)
>  		return -ENOMEM;
>  
> +	ret = debugfs_create_file("lapic_timer_advance_ns", 0444,
> +							vcpu->debugfs_dentry,
> +							vcpu, &vcpu_timer_advance_ns_fops);
> +	if (!ret)
> +		return -ENOMEM;
> +
>  	if (kvm_has_tsc_control) {
>  		ret = debugfs_create_file("tsc-scaling-ratio", 0444,
>  							vcpu->debugfs_dentry,
> -- 
> 2.7.4
> 
