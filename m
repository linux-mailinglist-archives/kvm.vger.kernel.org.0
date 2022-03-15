Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D449D4D9EBB
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 16:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349644AbiCOPb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 11:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243514AbiCOPbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 11:31:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1585453736
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 08:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647358241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L47ys7Ju+ra6uvzgdggF4XXVDzazg4VAs7Nuc4o2sMU=;
        b=QqNVz5cJghhJorVwd0aX53Y2PMMlJO5jTPt6sbQW4EQLUYPbUqi+UqC2XxmZHYcYykFO1h
        Xz34UjQUTYF3xX/J+q8HLYxWKjV5MZ5OyZZINJVTAB5HPai444wBA35q8lXzcW1nWTX0UG
        Kjns0dFAFbO/CUQ+9NvY5jgk76L2SjE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-nmT2wb9tMqizw23om19_jA-1; Tue, 15 Mar 2022 11:30:38 -0400
X-MC-Unique: nmT2wb9tMqizw23om19_jA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAB44106655C;
        Tue, 15 Mar 2022 15:30:37 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28B50C33260;
        Tue, 15 Mar 2022 15:30:32 +0000 (UTC)
Message-ID: <c903e82ed2a1e98f66910c35b5aabdcf56e08e72.camel@redhat.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        "Hu, Robert" <robert.hu@intel.com>
Date:   Tue, 15 Mar 2022 17:30:32 +0200
In-Reply-To: <20220315151033.GA6038@gao-cwp>
References: <Yifg4bea6zYEz1BK@google.com> <20220309052013.GA2915@gao-cwp>
         <YihCtvDps/qJ2TOW@google.com>
         <6dc7cff15812864ed14b5c014769488d80ce7f49.camel@redhat.com>
         <YirPkr5efyylrD0x@google.com>
         <29c76393-4884-94a8-f224-08d313b73f71@intel.com>
         <01586c518de0c72ff3997d32654b8fa6e7df257d.camel@redhat.com>
         <2900660d947a878e583ebedf60e7332e74a1af5f.camel@redhat.com>
         <20220313135335.GA18405@gao-cwp>
         <fbf929e0793a6b4df59ec9d95a018d1f6737db35.camel@redhat.com>
         <20220315151033.GA6038@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-15 at 23:10 +0800, Chao Gao wrote:
> On Sun, Mar 13, 2022 at 05:09:08PM +0200, Maxim Levitsky wrote:
> > > > > This won't work with nested AVIC - we can't just inhibit a nested guest using its own AVIC,
> > > > > because migration happens.
> > > > 
> > > > I mean because host decided to change its apic id, which it can in theory do any time,
> > > > even after the nested guest has started. Seriously, the only reason guest has to change apic id,
> > > > is to try to exploit some security hole.
> > > 
> > > Hi
> > > 
> > > Thanks for the information.  
> > > 
> > > IIUC, you mean KVM applies APICv inhibition only to L1 VM, leaving APICv
> > > enabled for L2 VM. Shouldn't KVM disable APICv for L2 VM in this case?
> > > It looks like a generic issue in dynamically toggling APICv scheme,
> > > e.g., qemu can set KVM_GUESTDBG_BLOCKIRQ after nested guest has started.
> > > 
> > 
> > That is the problem - you can't disable it for L2, unless you are willing to emulate it in software.
> > Or in other words, when nested guest uses a hardware feature, you can't at some point say to it:
> > sorry buddy - hardware feature disappeared.
> 
> Hi Maxim,
> 
> I may miss something. When reading Sean's APICv inhibition cleanups, I
> find AVIC is disabled for L1 when nested is enabled (SVM is advertised
> to L1). Then, I think the new inhibition introduced for changed xAPIC ID
> shouldn't be a problem for L2 VM. Or, you plan to remove
> APICV_INHIBIT_REASON_NESTED and expose AVIC to L1?

Yep, I  have a patch for this ( which I hope to be accepted really soon
(KVM: x86: SVM: allow AVIC to co-exist with a nested guest running)
 
I also implemented working support for nested AVIC, which includes support for IPI without vm exits
between L2's vCPUs. I had sent an RFC for that.
 
With all patches applied both L1 and L2 switch hands on AVIC, L1's avic is inhibited
(only locally) on the vCPU which runs nested, and while it runs nested, L2 uses AVIC
to target other vCPUs which also run nested.
 
I and Paolo talked about this, and we reached a very promising conclusion.

I will add new KVM cap, say KVM_CAP_READ_ONLY_APIC, which userspace will set
prior to creating a vCPU, and which will make APIC ID fully readonly when set.
 
As a bonus, if you don't object, I will also make this cap, make APIC base read-only,
since this feature is also broken in kvm, optional in x86 spec, and not really
used by guests just like writable apic id.

I hope to have patches in day or two for this.
 
When this cap is not set, it is fair to disable both IPIv, my nested AVIC,
or even better inhibit AVIC completely, including any nested support.
 
Best regards,
	Maxim Levitsky

> 
> svm_vcpu_after_set_cpuid:
>                 /*
>                  * Currently, AVIC does not work with nested virtualization.
>                  * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
>                  */
>                 if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
>                         kvm_request_apicv_update(vcpu->kvm, false,
>                                                  APICV_INHIBIT_REASON_NESTED);
> 


