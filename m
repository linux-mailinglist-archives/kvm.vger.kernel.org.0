Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E38B1A7D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 11:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbfIMJKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 05:10:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387655AbfIMJKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 05:10:37 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39ED712BE
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 09:10:36 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id t185so1082406wmg.4
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 02:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lfR7hCR3n1vMNF7VisZxsxqzSWEAbbNmpmDv0NMLiRM=;
        b=i95spu1tHWVjtUfquSh83rQ5wnsT5tUKbNu4PSpfwYSczNtTxfhjZsVL2SK7sI51Ea
         M1WDBcfCoav4j0AvTweruUlwQyIPCl1j2k68Whe3qc+7+cR3O6c1KRKQcLJNC39emPTU
         fyOmmbUlm7zUoGQdKQ7KGZGILBbhUpgRJ9vA2r+P8rfvT58vn/on6I3Wg5kVOrKlMmHo
         ZqPxJHEKaQRp586MfCnNeGjZL36thiV+i9uTw2RrQ/kTvlCOcKcyVimNbRXmSmeWkp8v
         NIdEb9VpNjaJXaaSkN00rvp6lvrDbPNF6Ydu2au4tZ37+3GyOrdIKMWU8Msr5AWP1AUd
         fZJw==
X-Gm-Message-State: APjAAAVVxQC84UJcUwRaGQLzO1fwpoD9td2goFOTrOY3n4eu0G7C+5EA
        FR7XPgptKucctUTSswYqmb4ICjPcm7DR+T89URH34pzBweCCEYAjA7FA+aGoD0Q3gs6mEh33DPo
        ysvOKcddwlij4
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr2815656wrx.163.1568365834524;
        Fri, 13 Sep 2019 02:10:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzXc1bL5xFrSnBSo98QxqZe1gFpSVLipO6h3XpfBIdBwq42ngDjAhZicWU9t26AJiy3BJD+Fw==
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr2815637wrx.163.1568365834261;
        Fri, 13 Sep 2019 02:10:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3166:d768:e1a7:aab8? ([2001:b07:6468:f312:3166:d768:e1a7:aab8])
        by smtp.gmail.com with ESMTPSA id h125sm3380157wmf.31.2019.09.13.02.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2019 02:10:32 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: Handle unexpected MMIO accesses using master
 abort semantics
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
References: <20190913015623.19869-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b924ac35-d69a-be11-a037-7ff09be89125@redhat.com>
Date:   Fri, 13 Sep 2019 11:10:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913015623.19869-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/19 03:56, Sean Christopherson wrote:
> Use master abort semantics, i.e. reads return all ones and writes are
> dropped, to handle unexpected MMIO accesses when reading guest memory
> instead of returning X86EMUL_IO_NEEDED, which in turn gets interpreted
> as a guest page fault.
> 
> Emulation of certain instructions, notably VMX instructions, involves
> reading or writing guest memory without going through the emulator.
> These emulation flows are not equipped to handle MMIO accesses as no
> sane and properly functioning guest kernel will target MMIO with such
> instructions, and so simply inject a page fault in response to
> X86EMUL_IO_NEEDED.
> 
> While not 100% correct, using master abort semantics is at least
> sometimes correct, e.g. non-existent MMIO accesses do actually master
> abort, whereas injecting a page fault is always wrong, i.e. the issue
> lies in the physical address domain, not in the virtual to physical
> translation.
> 
> Apply the logic to kvm_write_guest_virt_system() in addition to
> replacing existing #PF logic in kvm_read_guest_virt(), as VMPTRST uses
> the former, i.e. can also leak a host stack address.
> 
> Reported-by: Fuqian Huang <huangfq.daxian@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

For 5.5, I'll look into doing proper emulation in
vmxon/vmclear/vmptrld/vmptrst emulation.

Paolo

> ---
> 
> v2: Fix the comment for kvm_read_guest_virt_helper().
> 
>  arch/x86/kvm/x86.c | 40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4cfd786d0b6..3da57f137470 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5234,16 +5234,24 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
>  			       struct x86_exception *exception)
>  {
>  	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> +	int r;
> +
> +	r = kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,
> +				       exception);
>  
>  	/*
> -	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
> -	 * is returned, but our callers are not ready for that and they blindly
> -	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
> -	 * uninitialized kernel stack memory into cr2 and error code.
> +	 * FIXME: this should technically call out to userspace to handle the
> +	 * MMIO access, but our callers are not ready for that, so emulate
> +	 * master abort behavior instead, i.e. reads return all ones.
>  	 */
> -	memset(exception, 0, sizeof(*exception));
> -	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,
> -					  exception);
> +	if (r == X86EMUL_IO_NEEDED) {
> +		memset(val, 0xff, bytes);
> +		return 0;
> +	}
> +	if (r == X86EMUL_PROPAGATE_FAULT)
> +		return -EFAULT;
> +	WARN_ON_ONCE(r);
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_guest_virt);
>  
> @@ -5317,11 +5325,25 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
>  int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
>  				unsigned int bytes, struct x86_exception *exception)
>  {
> +	int r;
> +
>  	/* kvm_write_guest_virt_system can pull in tons of pages. */
>  	vcpu->arch.l1tf_flush_l1d = true;
>  
> -	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
> -					   PFERR_WRITE_MASK, exception);
> +	r = kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
> +					PFERR_WRITE_MASK, exception);
> +
> +	/*
> +	 * FIXME: this should technically call out to userspace to handle the
> +	 * MMIO access, but our callers are not ready for that, so emulate
> +	 * master abort behavior instead, i.e. writes are dropped.
> +	 */
> +	if (r == X86EMUL_IO_NEEDED)
> +		return 0;
> +	if (r == X86EMUL_PROPAGATE_FAULT)
> +		return -EFAULT;
> +	WARN_ON_ONCE(r);
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
>  
> 

