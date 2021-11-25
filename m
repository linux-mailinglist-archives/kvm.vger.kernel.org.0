Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A3845E10C
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243928AbhKYTiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:38:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54088 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356716AbhKYTgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:36:21 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637868788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=skiwKvBvcX77KCN2f+a1API7S+cJO64tQHZvO5EDU4c=;
        b=T15RMYfFjiAphu02avePaqHt7Bwi+JUBPr1tn2q6SSDNUbv9445U8cCjmTqBqlNzN2w645
        VvLlu8Dx8qaf7kFjPhp2JI8JAsYSx/B4HO4Nla93fSthw5iojnGVVimjT7K3uWnTScSL3i
        BJ8QbyY+4chvC0vDQj+tRC4yKi0PBykTY+eKEeJb8XDpOlbnGYZ1PYMLHlXXl//8wMIGWb
        bi3aEY5R5QUoKRPAiIZ4W0kCJAVBjDRcBBuxdWfg0qH1kQMy4qDmCW/SEJFLT8Igz9xd+s
        qyyCGC03Wt9KSf8J0xAgjBMAgnXslgYeGGAeswWzos3NP7Sz0TuDuF3a6a7Z1Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637868788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=skiwKvBvcX77KCN2f+a1API7S+cJO64tQHZvO5EDU4c=;
        b=ZBVCFci4RjLVYbADxRH+ien8hP41tZMfMJF8A9DQTq1WaeaPxozBer6oB/8aPpvsyV3ucn
        TNcR3U908s4K7lBg==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>
Subject: Re: [RFC PATCH v3 17/59] KVM: x86: Add flag to disallow #MC
 injection / KVM_X86_SETUP_MCE
In-Reply-To: <b7c89ebf9f2000c1f8c3d0e57bd7cf622f11f638.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <b7c89ebf9f2000c1f8c3d0e57bd7cf622f11f638.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:33:08 +0100
Message-ID: <87lf1cjaiz.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
>  static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>  					u64 mcg_cap)
>  {
> -	int r;
>  	unsigned bank_num = mcg_cap & 0xff, bank;
>  
> -	r = -EINVAL;
> +	if (vcpu->kvm->arch.mce_injection_disallowed)
> +		return -EINVAL;

Yet another flag because the copy & pasta orgy did not cover that
ioctl. What for?
