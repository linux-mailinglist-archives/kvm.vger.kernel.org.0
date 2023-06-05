Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2377224F2
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 13:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbjFELxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 07:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjFELxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 07:53:21 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEB1A7;
        Mon,  5 Jun 2023 04:53:19 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q68lx-00BV67-DW; Mon, 05 Jun 2023 13:53:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=z6InhYcFfQV4kfNF3EKRRmV6b/y4TH6TyIbYstwZzDg=; b=frT7bzA0QICy8T4dPdgzjpMs8+
        OL9JFeOPhv8J4pRRDHKX6cHZ1eZ0VFKtZHVicBAhUAqBEyIPkQKogo1XHw7OZOU5DPNpb0Y3cYosS
        XWpQ/CpXst/+tNAS9nyWyn2jSwkeREAzBtMBN/7c4qMhK5weP/2LMxep7KECyav3aIde87SOA9ih5
        Z8puFwlsXyW55PBU699Xz5uU86y4NqCfP+nAgJ4NdLXvzbzipAv+X5G+whgpkZLhCqiYF5iI4oy9s
        pS7NVQOaLVVqjtvJ36oiDeZI5uNm7+4IsP5B0S7Rz35HKN87xFD3BMgzRbRLS6MYbER8yzYDzjGiJ
        rJyJ4bIQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q68lw-00070x-LP; Mon, 05 Jun 2023 13:53:16 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q68lu-0002P0-No; Mon, 05 Jun 2023 13:53:14 +0200
Message-ID: <7a4a503d-9fc4-d366-02b4-bc145943bd45@rbox.co>
Date:   Mon, 5 Jun 2023 13:53:13 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     dmatlack@google.com, mizhang@google.com, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, Wei Wang <wei.w.wang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230307135233.54684-1-wei.w.wang@intel.com>
 <168565180722.660019.15543226381784798973.b4-ty@google.com>
 <8f319a1e-a869-b666-b606-c0b4764ef7b1@rbox.co> <ZHofVKJxjaUxIDUN@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZHofVKJxjaUxIDUN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/23 18:56, Sean Christopherson wrote:
> On Fri, Jun 02, 2023, Michal Luczaj wrote:
>> I guess this makes the !! in kvm_vm_ioctl_create_vcpu() unnecessary:
>>
>> KVM_BUG_ON(!!xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0)...
> 
> Ya, I saw that, which in addition to Wei's ping, is what reminded me that the
> KVM_BUG_ON() fix hadn't been merged.
> 
>> Is it worth a patch (perhaps along with chopping off !! in
>> kvm_msr_allowed() and few other places)?
> 
> Yes, I think so.

OK, so xa_store() aside[*], I see some bool-to-bools:

arch/x86/kvm/x86.c:
	kvm_msr_allowed():allowed = !!test_bit(index - start, bitmap);
arch/x86/kvm/hyperv.c:
	kvm_hv_hypercall():hc.rep = !!(hc.rep_cnt || hc.rep_idx);
arch/x86/kvm/mmu/mmu.c:
	update_pkru_bitmask():
		pkey_bits = !!check_pkey;
		pkey_bits |= (!!check_write) << 1;
arch/x86/kvm/svm/svm.c:
	msr_write_intercepted():return !!test_bit(bit_write,  &tmp);
	svm_vcpu_after_set_cpuid():
		2x set_msr_interception...
tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c:
	set_or_clear_invalid_guest_state():sregs.tr.unusable = !!set;

But perhaps this is a matter of style and those were meant to be this kind-of
explicit?

[*] https://lore.kernel.org/kvm/20230605114852.288964-1-mhal@rbox.co/
