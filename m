Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C9427BC3F
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 06:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgI2E67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 00:58:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:9010 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI2E67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 00:58:59 -0400
IronPort-SDR: JJqsR0XMWfOj9auY20M6RcEP9GHzczCY7LoLR96u1Q90q/Dx1vdLYG6jM8C7mfqTE/43giwzJL
 +w0gpcFRET3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="162178069"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="162178069"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:58:59 -0700
IronPort-SDR: gnAUvWJqY1dLAMnLcm6rWIkPcVgctrQARKnqdC1hBpd1sQb6aEIHpSMLz/A7Ui9YmXl5z5Xfb8
 5NfUSgIhCsgA==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="514538541"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:58:58 -0700
Date:   Mon, 28 Sep 2020 21:58:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, robert.hu@intel.com
Subject: Re: [RFC PATCH 1/9] KVM:x86: Abstract sub functions from
 kvm_update_cpuid_runtime() and kvm_vcpu_after_set_cpuid()
Message-ID: <20200929045857.GA353@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
 <1596163347-18574-2-git-send-email-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596163347-18574-2-git-send-email-robert.hu@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 10:42:19AM +0800, Robert Hoo wrote:
> Add below functions, whose aggregation equals kvm_update_cpuid_runtime() and
> kvm_vcpu_after_set_cpuid().
> 
> void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> void kvm_pke_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> void kvm_mwait_update_cpuid(struct kvm_vcpu *vcpu, bool set)
> void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu)
> static void kvm_pv_unhalt_update_cpuid(struct kvm_vcpu *vcpu)
> static void kvm_update_maxphyaddr(struct kvm_vcpu *vcpu)
> static void kvm_update_lapic_timer_mode(struct kvm_vcpu *vcpu)

Ugh, I just reread this, you're adding functions with no callers.  This patch
should replace the existing code so that there are callers, and more
importantly so that we can verify old==new.
