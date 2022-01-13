Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B96148E015
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 23:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbiAMWJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 17:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiAMWJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 17:09:38 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C49BC061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:09:38 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id i8so1097755pgt.13
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AC2HTFJ1ATzCZyLtom4XJg0IJvKzl0TNNBtGMizTd8Q=;
        b=U+T4F26wkMoKmJIJ1QTUZgPt3LYcSKtsHbd7REnwzpdUxVIhXc1VGzxKOTWPI/T42o
         /22qUfEf209ZLOY0KUQ2v6LedfQ8tKtsUQjHtebLySJIPezt6kftoGGvXNiNUhO4cKyo
         U6Mw6T+i2lJxtSjkt4IzCQEvIEp47zj5YQLxgqsdutt10cPRQCG16PT4/hEixtm6voRx
         /nNf1s0FOttaN9D2C1QLSK0Fm1FZi8CMNufXrnwf4yBxOSgoEEAiAXQYwRBntEl7jnVE
         ODD+o76Juw2dJS8kRdTpVn0SYm4g782O8ehDCTHXVmKUvbwG8c2Ng8PJRv5ZX2PgTyWH
         mwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AC2HTFJ1ATzCZyLtom4XJg0IJvKzl0TNNBtGMizTd8Q=;
        b=DECHfWfvEev5lWzZZuMQlcJbgcsNlBiIru4NNQyPaJ1q8IPTkfZMxDBUlZacUfk2oM
         lGe2zp9vBlSxQUZJevVjAtobsy6XAdtdC495OHhKJK3dtfuyvQ8A7K34juS14u+dSA8O
         /ZuaWftFvdeNvbaKKL5MkbqpUYfPvB69ChwWXx5o5YEfl1zzZz8x3hH9zCWaYijvkAVI
         cKXqWIFoHGhZlic4wcAc5tVITCgMWs1nxzAQnMAWCakI1liCOQPfFVJCYTXFPk/hR+sn
         fBOYiLtn4fMFSQxEnQJjlBm3n6lzBz3YAq8dY7ROdEARLZ30iC2FAvwxelofeigHdZgP
         VEVw==
X-Gm-Message-State: AOAM531kiLXmv1KVxIcIxiCg8+8Comi5P7wAXgh120e7cthJ855vpAf1
        lJBCZNVhxiQh6nUXnFF21bwnwg==
X-Google-Smtp-Source: ABdhPJwn/TmRC2ZoREFVED7MDc2QJTqiBDWq2zTBbSNYy5uyZEWJariDsNSuc5VL4Ix8KcssmQIwcQ==
X-Received: by 2002:a63:ae4b:: with SMTP id e11mr5548909pgp.386.1642111777586;
        Thu, 13 Jan 2022 14:09:37 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n5sm3512558pfo.39.2022.01.13.14.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 14:09:37 -0800 (PST)
Date:   Thu, 13 Jan 2022 22:09:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v5 8/8] KVM: VMX: Resize PID-ponter table on demand for
 IPI virtualization
Message-ID: <YeCjHbdAikyIFQc9@google.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-9-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231142849.611-9-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 31, 2021, Zeng Guang wrote:
> +static int vmx_expand_pid_table(struct kvm_vmx *kvm_vmx, int entry_idx)
> +{
> +	u64 *last_pid_table;
> +	int last_table_size, new_order;
> +
> +	if (entry_idx <= kvm_vmx->pid_last_index)
> +		return 0;
> +
> +	last_pid_table = kvm_vmx->pid_table;
> +	last_table_size = table_index_to_size(kvm_vmx->pid_last_index + 1);
> +	new_order = get_order(table_index_to_size(entry_idx + 1));
> +
> +	if (vmx_alloc_pid_table(kvm_vmx, new_order))
> +		return -ENOMEM;
> +
> +	memcpy(kvm_vmx->pid_table, last_pid_table, last_table_size);
> +	kvm_make_all_cpus_request(&kvm_vmx->kvm, KVM_REQ_PID_TABLE_UPDATE);
> +
> +	/* Now old PID table can be freed safely as no vCPU is using it. */
> +	free_pages((unsigned long)last_pid_table, get_order(last_table_size));

This is terrifying.  I think it's safe?  But it's still terrifying.

Rather than dynamically react as vCPUs are created, what about we make max_vcpus
common[*], extend KVM_CAP_MAX_VCPUS to allow userspace to override max_vcpus,
and then have the IPIv support allocate the PID table on first vCPU creation
instead of in vmx_vm_init()?

That will give userspace an opportunity to lower max_vcpus to reduce memory
consumption without needing to dynamically muck with the table in KVM.  Then
this entire patch goes away.
