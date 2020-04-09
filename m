Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715751A2D4A
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 03:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgDIBWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 21:22:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25945 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726539AbgDIBWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 21:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586395342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S6zaZRnflWlRwMkihtjBYFyGTc78AtlkI9xkR9S+YcM=;
        b=gk2kFmFPNLqsVmtagTAXb5aw+eHUgq5CVWsVCCAJk8DcHjlVcfXXq+kbU3213Tkn6fo4YI
        sEI/ypsCjsRNYuHIauP1gV0PchF3p+9JmiOjwPfFFxGvGMqPebhjZqJjoyPaDlrcKc+jY8
        qbOmlkB7f5Q67xN7XRC1nj/Gf3gLhEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-4AEZWP3WPPqwU9YNqXMFhA-1; Wed, 08 Apr 2020 21:22:18 -0400
X-MC-Unique: 4AEZWP3WPPqwU9YNqXMFhA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CF9E13FA;
        Thu,  9 Apr 2020 01:22:17 +0000 (UTC)
Received: from localhost (ovpn-12-133.pek2.redhat.com [10.72.12.133])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D461660BFB;
        Thu,  9 Apr 2020 01:22:16 +0000 (UTC)
Date:   Thu, 9 Apr 2020 09:22:14 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kexec@lists.infradead.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: fix crash cleanup when KVM wasn't used
Message-ID: <20200409012214.GB14381@MiWiFi-R3L-srv>
References: <20200401081348.1345307-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401081348.1345307-1-vkuznets@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/01/20 at 10:13am, Vitaly Kuznetsov wrote:
> If KVM wasn't used at all before we crash the cleanup procedure fails with
>  BUG: unable to handle page fault for address: ffffffffffffffc8
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 23215067 P4D 23215067 PUD 23217067 PMD 0
>  Oops: 0000 [#8] SMP PTI
>  CPU: 0 PID: 3542 Comm: bash Kdump: loaded Tainted: G      D           5.6.0-rc2+ #823
>  RIP: 0010:crash_vmclear_local_loaded_vmcss.cold+0x19/0x51 [kvm_intel]
> 
> The root cause is that loaded_vmcss_on_cpu list is not yet initialized,
> we initialize it in hardware_enable() but this only happens when we start
> a VM.
> 
> Previously, we used to have a bitmap with enabled CPUs and that was
> preventing [masking] the issue.
> 
> Initialized loaded_vmcss_on_cpu list earlier, right before we assign
> crash_vmclear_loaded_vmcss pointer. blocked_vcpu_on_cpu list and
> blocked_vcpu_on_cpu_lock are moved altogether for consistency.
> 
> Fixes: 31603d4fc2bb ("KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Kdump kernel hang can be reproduced on a bare metal machine of Intel always,
issue disappeared with this patch applied. Feel free to add:

Tested-by: Baoquan He <bhe@redhat.com>

> ---
>  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3aba51d782e2..39a5dde12b79 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2257,10 +2257,6 @@ static int hardware_enable(void)
>  	    !hv_get_vp_assist_page(cpu))
>  		return -EFAULT;
>  
> -	INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> -	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> -
>  	r = kvm_cpu_vmxon(phys_addr);
>  	if (r)
>  		return r;
> @@ -8006,7 +8002,7 @@ module_exit(vmx_exit);
>  
>  static int __init vmx_init(void)
>  {
> -	int r;
> +	int r, cpu;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	/*
> @@ -8060,6 +8056,12 @@ static int __init vmx_init(void)
>  		return r;
>  	}
>  
> +	for_each_possible_cpu(cpu) {
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> +		INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> +		spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> +	}
> +
>  #ifdef CONFIG_KEXEC_CORE
>  	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
>  			   crash_vmclear_local_loaded_vmcss);
> -- 
> 2.25.1
> 

