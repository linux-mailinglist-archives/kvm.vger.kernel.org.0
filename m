Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E4648EDDF
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 17:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243236AbiANQSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 11:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239062AbiANQSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 11:18:33 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7D9C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 08:18:32 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 8so3143612pgc.10
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 08:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7VMdD/jG1OhLf0ccWBGGvDrHOZitMiDuwr1tmbzaiPk=;
        b=dtsLpROvyW71vMsAeyUDpkELOk3IIZsyrBrQaMpABVKaCHSph5MPHi31CrLCVeFCfb
         qAC8978AT1Bv5z7usNwPhes62xlyu6fWhXnwKyXTmJavoREl5nY0j+RfLOSKddAbTqdj
         LYGlpYwRYf5bA/XS28pQ1V6/seMux030uA/Hf6VJF3ShDFU3OvNV8TiwSagntC0z1q43
         KfvTqyoCJFhpjhe1qjy+ZS6RsNEVqWo1FcwAsKrWyP9er3vkh3pF+r2I8z1BllSkoWYS
         gwf4XuPebfTzvVx22RBy0MsH8/gwrfnKt6wCT6WLLZWZh+E3wRBL8j6/U/y+zS0L3gVL
         cDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7VMdD/jG1OhLf0ccWBGGvDrHOZitMiDuwr1tmbzaiPk=;
        b=PHgZQALkYBKjq+pAJOA1G/LMzws+mTl5OAk9gj66TSaZ4Oo8zP4zvU+uHldhzOy9Kd
         se3zhV82MUYm3DCXDKi0Zx6I9s1JmwHlhD0g4RD9Up7lCYuUNlIAWdb8YBkjX/++sm3x
         63m9STgm1aFeMVLWRQuv8nRzqN2RbZeAcmLccqLwPLluw6MbVXlYbug+L3Nik2xhJvsQ
         mCVITK6aaHY0+GbhS68pp9yKGr3XgZEYySG4d9Yn2cPjVhzLzpgkpzPcv7MXH/VdLEML
         j+9sZrzQ4q3N0xQg28uKq2I6BVBg1IR/ZStufQ4HRHGHCJPzvfqkMjCw01JlxPh/j2zq
         NlTQ==
X-Gm-Message-State: AOAM5301E/jz2ixz2tynSKfyUeW1+Lyu4kHVGhE0xpCXmUyoqiRYqBYO
        vX6bSWEtWta7tGlen5AXILQzmg==
X-Google-Smtp-Source: ABdhPJw8er2uWFApX4KapuD5tBwh7MswU/QprQpkNs5xP88OBelj+H2tdzEm9pgcSKcQ4Kwt7Xhxrw==
X-Received: by 2002:a63:8548:: with SMTP id u69mr6595782pgd.306.1642177112043;
        Fri, 14 Jan 2022 08:18:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m14sm5985121pff.151.2022.01.14.08.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:18:31 -0800 (PST)
Date:   Fri, 14 Jan 2022 16:18:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v5 8/8] KVM: VMX: Resize PID-ponter table on demand for
 IPI virtualization
Message-ID: <YeGiVCn0wNH9eqxX@google.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-9-guang.zeng@intel.com>
 <YeCjHbdAikyIFQc9@google.com>
 <43200b86-aa40-f7a3-d571-dc5fc3ebd421@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43200b86-aa40-f7a3-d571-dc5fc3ebd421@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022, Zeng Guang wrote:
> On 1/14/2022 6:09 AM, Sean Christopherson wrote:
> > On Fri, Dec 31, 2021, Zeng Guang wrote:
> > > +static int vmx_expand_pid_table(struct kvm_vmx *kvm_vmx, int entry_idx)
> > > +{
> > > +	u64 *last_pid_table;
> > > +	int last_table_size, new_order;
> > > +
> > > +	if (entry_idx <= kvm_vmx->pid_last_index)
> > > +		return 0;
> > > +
> > > +	last_pid_table = kvm_vmx->pid_table;
> > > +	last_table_size = table_index_to_size(kvm_vmx->pid_last_index + 1);
> > > +	new_order = get_order(table_index_to_size(entry_idx + 1));
> > > +
> > > +	if (vmx_alloc_pid_table(kvm_vmx, new_order))
> > > +		return -ENOMEM;
> > > +
> > > +	memcpy(kvm_vmx->pid_table, last_pid_table, last_table_size);
> > > +	kvm_make_all_cpus_request(&kvm_vmx->kvm, KVM_REQ_PID_TABLE_UPDATE);
> > > +
> > > +	/* Now old PID table can be freed safely as no vCPU is using it. */
> > > +	free_pages((unsigned long)last_pid_table, get_order(last_table_size));
> > This is terrifying.  I think it's safe?  But it's still terrifying.
> 
> Free old PID table here is safe as kvm making request KVM_REQ_PI_TABLE_UPDATE
> with KVM_REQUEST_WAIT flag force all vcpus trigger vm-exit to update vmcs
> field to new allocated PID table. At this time, it makes sure old PID table
> not referenced by any vcpu.
> Do you mean it still has potential problem?

No, I do think it's safe, but it is still terrifying :-)

> > Rather than dynamically react as vCPUs are created, what about we make max_vcpus
> > common[*], extend KVM_CAP_MAX_VCPUS to allow userspace to override max_vcpus,
> > and then have the IPIv support allocate the PID table on first vCPU creation
> > instead of in vmx_vm_init()?
> > 
> > That will give userspace an opportunity to lower max_vcpus to reduce memory
> > consumption without needing to dynamically muck with the table in KVM.  Then
> > this entire patch goes away.
> IIUC, it's risky if relying on userspace .

That's why we have cgroups, rlimits, etc...

> In this way userspace also have chance to assign large max_vcpus but not use
> them at all. This cannot approach the goal to save memory as much as possible
> just similar as using KVM_MAX_VCPU_IDS to allocate PID table.

Userspace can simply do KVM_CREATE_VCPU until it hits KVM_MAX_VCPU_IDS...
