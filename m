Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7897B3AF16F
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 19:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhFURKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 13:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhFURKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 13:10:33 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85DCC061756
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 10:08:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m17so5747340plx.7
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 10:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GoxSCKJLN3ao+jAyYEtlEkr/xldmKtHQCJtNY7NrOWY=;
        b=FioMSdx5swYgNtCcKYBAv0NM37OT2BVbfDNQ5Qz2acE/Yei7Ish73AogIu2wEJcgA4
         YW+60HAPnm0BLHa34ObbdTUm4ZTz7S/y/z+qANPLBJbReaxh8JaIGvv4hw88POfxKaot
         FGI01/eiT3reQ4d6hPku7M1lMmp1WXilHk+Jtf/JY5Y72JKcbEEeaf9+5UpMnnwbnvN+
         uORm0QWAzGlb3J0V+9otbtx3SKByrXIsm15VHBXuzFD9FfJoQ8nANXVBZUJmILkw+Xkc
         ywZlmljDaC75R6jHo3QJA/N1ovSOxIqagyBfn40NKfNVuM+Ul5XkGyohPe+WJbSIHSsK
         pEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GoxSCKJLN3ao+jAyYEtlEkr/xldmKtHQCJtNY7NrOWY=;
        b=Ha1UOjd94z4YQKl5vnoL2JrwGYFQ099W8IVKEDXKq7IfZE4oplhjOrFF/BVyMAgoQd
         Dh+8Zcmbr/sxOy+wYoLn4IohutG/Xdkk07MggSEguLGmC0mzALtKf3pyPSMMJaHe88hQ
         pp8s+0Dgn2qzvsOVNwJjdotUtEmNM2rH8q1I4PUS4OXLntwGtCp0iVIwCkbK8Lhuy/zf
         9e7N+Mw1eqZj7vh2qq4Hh9+/Ujo59L3mL3PfBW2F4u95X1Tgq89ekXL/kYn0zjZeOWzv
         6o0vjrtDd865pX8/Ixgu0IB0NxDO4lgMdxoDbtSwx86iKb/yMsmOCFi3bmFgLfS/L2R7
         jE7A==
X-Gm-Message-State: AOAM532jkyZnGWLuEG6kqh83jkbq+JAfI9L052/+grhenkqXk0WoGLk8
        ZGQFDS6+Y7z3zecM58dMfMA0FA==
X-Google-Smtp-Source: ABdhPJzs1GMXbV/9bDzOq/0KurNzolqKa0kZjFW70lSkHjwYFdMFkeFqj7vl2N1jED50glItzmU5FQ==
X-Received: by 2002:a17:90b:3e89:: with SMTP id rj9mr27646029pjb.114.1624295298050;
        Mon, 21 Jun 2021 10:08:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q24sm17709726pgk.32.2021.06.21.10.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 10:08:17 -0700 (PDT)
Date:   Mon, 21 Jun 2021 17:08:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
Message-ID: <YNDHfX0cntj72sk6@google.com>
References: <20210618214658.2700765-1-seanjc@google.com>
 <c847e00a-e422-cdc9-3317-fbbd82b6e418@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c847e00a-e422-cdc9-3317-fbbd82b6e418@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021, Paolo Bonzini wrote:
> On 18/06/21 23:46, Sean Christopherson wrote:
> > Calculate the max VMCS index for vmcs12 by walking the array to find the
> > actual max index.  Hardcoding the index is prone to bitrot, and the
> > calculation is only done on KVM bringup (albeit on every CPU, but there
> > aren't _that_ many null entries in the array).
> > 
> > Fixes: 3c0f99366e34 ("KVM: nVMX: Add a TSC multiplier field in VMCS12")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > 
> > Note, the vmx test in kvm-unit-tests will still fail using stock QEMU,
> > as QEMU also hardcodes and overwrites the MSR.  The test passes if I
> > hack KVM to ignore userspace (it was easier than rebuilding QEMU).
> 
> Queued, thanks.  Without having checked the kvm-unit-tests sources very
> thoroughly, this might be a configuration issue in kvm-unit-tests; in theory
> "-cpu host" (unlike "-cpu host,migratable=no") should not enable TSC
> scaling.

As noted in the code comments, KVM allows VMREAD/VMWRITE to all defined fields,
whether or not the field should actually exist for the vCPU model doesn't enter
into the equation.  That's technically wrong as there are a number of fields
that the SDM explicitly states exist iff a certain feature is supported.  To fix
that we'd need to add a "feature flag" to vmcs_field_to_offset_table that is
checked against the vCPU model, though updating the MSR would probably fall onto
userspace's shoulders?

And FWIW, this is the QEMU code:

  #define VMCS12_MAX_FIELD_INDEX (0x17)

  static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
  {
      ...

      /*
       * Just to be safe, write these with constant values.  The CRn_FIXED1
       * MSRs are generated by KVM based on the vCPU's CPUID.
       */
      kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR0_FIXED0,
                        CR0_PE_MASK | CR0_PG_MASK | CR0_NE_MASK);
      kvm_msr_entry_add(cpu, MSR_IA32_VMX_CR4_FIXED0,
                        CR4_VMXE_MASK);
      kvm_msr_entry_add(cpu, MSR_IA32_VMX_VMCS_ENUM,
                        VMCS12_MAX_FIELD_INDEX << 1);
  }

