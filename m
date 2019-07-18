Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5EF6CCFE
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 12:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfGRKu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 06:50:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43617 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfGRKu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 06:50:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so28126792wru.10
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 03:50:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r/6N+NqUcfNUhaLvc/XebCwHV0my/Y+ood81huzepL4=;
        b=MjX3VOZEcx804g0f53DUBh4qCS8x+YQp3hBhiTZD86ZDmT3MUAVelvaTpprt7vASnb
         0IXmea3IRFt3JKkB5oG5umMso2X3YoDUspuWYeHn+Y9Pmlp6W+SSCGXEPf83U5aenl07
         3EiD+QgrDHVc2PGzgzLyR+K6fNYrI/kRc4DrDIq1Gifw5eYIcE7+KSev+eeH0zb8l15j
         2il9jeNU7AdwMrG7yXOKB/2OgidONB8nAya1Mrpc4kizgiJol+cViUn0Hk3X37BeoNdk
         1/Ga7yTv5phfeyx4kEgQjIqZnjnYrxlgMIWbCvXDqHdPpNPTDAxgUWSLIjrw8RBPdlyf
         NLeQ==
X-Gm-Message-State: APjAAAWuNLD6O4MFeksrEh1yPJTEgZT2tXK8mogV16FDxXmCNIEpk/Q4
        5B+xd4+Vz8fSXenwOmoaN1yEY5ydIebNeA==
X-Google-Smtp-Source: APXvYqxDEd0BHdy/LnKTX0FqAAxAAhRgawn6cQuZMDEm2oFxCN05FuKmdpRDPiLbogbas8mX6C7cJQ==
X-Received: by 2002:adf:9ece:: with SMTP id b14mr365651wrf.192.1563447024327;
        Thu, 18 Jul 2019 03:50:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id l17sm13512499wrr.94.2019.07.18.03.50.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 03:50:23 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: SVM: Fix detection of AMD Errata 1096
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     Singh Brijesh <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190716235658.18185-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f011a43e-6bd3-0a90-fc19-a5b075994aa3@redhat.com>
Date:   Thu, 18 Jul 2019 12:50:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190716235658.18185-1-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/19 01:56, Liran Alon wrote:
> AMD Errata 1096:
> When CPU raise #NPF on guest data access and vCPU CR4.SMAP=1, it is
> possible that CPU microcode implementing DecodeAssist will fail
> to read bytes of instruction which caused #NPF. In this case,
> GuestIntrBytes field of the VMCB on a VMEXIT will incorrectly
> return 0 instead of the correct guest instruction bytes.
> This happens because CPU microcode reading instruction bytes
> uses a special opcode which attempts to read data using CPL=0
> priviledges. The microcode reads CS:RIP and if it hits a SMAP
> fault, it gives up and returns no instruction bytes.
> 
> Current KVM code which attemps to detect and workaround this errata have
> multiple issues:
> 
> 1) Code mistakenly checks if vCPU CR4.SMAP=0 instead of vCPU CR4.SMAP=1 which
> is required for encountering a SMAP fault.
> 
> 2) Code assumes SMAP fault can only occur when vCPU CPL==3.
> However, the condition for a SMAP fault is a data access with CPL<3
> to a page mapped in page-tables as user-accessible (i.e. PTE with U/S
> bit set to 1).
> Therefore, in case vCPU CR4.SMEP=0, guest can execute an instruction
> which reside in a user-accessible page with CPL<3 priviledge. If this
> instruction raise a #NPF on it's data access, then CPU DecodeAssist
> microcode will still encounter a SMAP violation.
> Even though no sane OS will do so (as it's an obvious priviledge
> escalation vulnerability), we still need to handle this semanticly
> correct in KVM side.
> 
> As CR4.SMAP=1 is an easy triggerable condition, attempt to avoid
> false-positive of detecting errata by taking note that in case vCPU
> CR4.SMEP=1, errata could only be encountered in case CPL==3 (As
> otherwise, CPU would raise SMEP fault to guest instead of #NPF).
> This can be a useful condition to avoid false-positive because guests
> usually enable SMAP if they have also enabled SMEP.
> 
> In addition, to avoid future confusion and improve code readbility,
> comment errata details in code and not just in commit message.
> 
> Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
> Cc: Singh Brijesh <brijesh.singh@amd.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/svm.c | 42 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 735b8c01895e..7d6410539dd7 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7120,13 +7120,41 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  
>  static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>  {
> -	bool is_user, smap;
> -
> -	is_user = svm_get_cpl(vcpu) == 3;
> -	smap = !kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
> +	unsigned long cr4 = kvm_read_cr4(vcpu);
> +	bool smep = cr4 & X86_CR4_SMEP;
> +	bool smap = cr4 & X86_CR4_SMAP;
> +	bool is_user = svm_get_cpl(vcpu) == 3;
>  
>  	/*
> -	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh
> +	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
> +	 *
> +	 * Errata:
> +	 * When CPU raise #NPF on guest data access and vCPU CR4.SMAP=1, it is
> +	 * possible that CPU microcode implementing DecodeAssist will fail
> +	 * to read bytes of instruction which caused #NPF. In this case,
> +	 * GuestIntrBytes field of the VMCB on a VMEXIT will incorrectly
> +	 * return 0 instead of the correct guest instruction bytes.
> +	 *
> +	 * This happens because CPU microcode reading instruction bytes
> +	 * uses a special opcode which attempts to read data using CPL=0
> +	 * priviledges. The microcode reads CS:RIP and if it hits a SMAP
> +	 * fault, it gives up and returns no instruction bytes.
> +	 *
> +	 * Detection:
> +	 * We reach here in case CPU supports DecodeAssist, raised #NPF and
> +	 * returned 0 in GuestIntrBytes field of the VMCB.
> +	 * First, errata can only be triggered in case vCPU CR4.SMAP=1.
> +	 * Second, if vCPU CR4.SMEP=1, errata could only be triggered
> +	 * in case vCPU CPL==3 (Because otherwise guest would have triggered
> +	 * a SMEP fault instead of #NPF).
> +	 * Otherwise, vCPU CR4.SMEP=0, errata could be triggered by any vCPU CPL.
> +	 * As most guests enable SMAP if they have also enabled SMEP, use above
> +	 * logic in order to attempt minimize false-positive of detecting errata
> +	 * while still preserving all cases semantic correctness.
> +	 *
> +	 * Workaround:
> +	 * To determine what instruction the guest was executing, the hypervisor
> +	 * will have to decode the instruction at the instruction pointer.
>  	 *
>  	 * In non SEV guest, hypervisor will be able to read the guest
>  	 * memory to decode the instruction pointer when insn_len is zero
> @@ -7137,11 +7165,11 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>  	 * instruction pointer so we will not able to workaround it. Lets
>  	 * print the error and request to kill the guest.
>  	 */
> -	if (is_user && smap) {
> +	if (smap && (!smep || is_user)) {
>  		if (!sev_guest(vcpu->kvm))
>  			return true;
>  
> -		pr_err_ratelimited("KVM: Guest triggered AMD Erratum 1096\n");
> +		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
>  		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>  	}
>  
> 

Queued, subject to Brijesh's answer on guest CR4.SMAP vs host CR4.SMAP.

Paolo
