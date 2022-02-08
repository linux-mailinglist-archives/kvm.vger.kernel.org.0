Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154CD4ADCBB
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239282AbiBHPe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 10:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiBHPe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:34:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02B6CC061576
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 07:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644334465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Y3EJy6n/DsdzTGf9lL710fnSXTO377GHvERYvGo1WE=;
        b=aoa8bYMm0+yf83xG1ixXxs1Id1Bm2vPQMuoXxiCjU4KDn9p06fJwcOycTk6Iz6CDhaeYU3
        8aYif/NFqwT9jZJXudYan38utnW0wXvJlRrxidh9v42vKEvAyiBRFkYJFTYVkHlCn4k/jE
        u+NOAjmQuK54H9QpO+cQyZCs8mBZOYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-iiRkjq6WOpeFYqFokH1Z3w-1; Tue, 08 Feb 2022 10:34:24 -0500
X-MC-Unique: iiRkjq6WOpeFYqFokH1Z3w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E046A84BA4D
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 15:34:22 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F413374E92;
        Tue,  8 Feb 2022 15:34:21 +0000 (UTC)
Message-ID: <060ce89597cfbc85ecd300bdd5c40bb571a16993.camel@redhat.com>
Subject: Re: warning in kvm_hv_invalidate_tsc_page due to writes to guest
 memory from VM ioctl context
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date:   Tue, 08 Feb 2022 17:34:20 +0200
In-Reply-To: <87ee4d9yp3.fsf@redhat.com>
References: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
         <87ee4d9yp3.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-08 at 16:15 +0100, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > [102140.117649] WARNING: CPU: 10 PID: 579353 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3161 mark_page_dirty_in_slot+0x6c/0x80 [kvm]
> ...
> > [102140.123834] Call Trace:
> > [102140.123910]  <TASK>
> > [102140.123976]  ? kvm_write_guest+0x114/0x120 [kvm]
> > [102140.124183]  kvm_hv_invalidate_tsc_page+0x9e/0xf0 [kvm]
> > [102140.124396]  kvm_arch_vm_ioctl+0xa26/0xc50 [kvm]
> 
> ...
> 
> > This happens because kvm_hv_invalidate_tsc_page is called from kvm_vm_ioctl_set_clock
> > which is a VM wide ioctl and thus doesn't have to be called with an active vCPU.
> >  
> > But as I see the warring states that guest memory writes must alway be done
> > while a vCPU is active to allow the write to be recorded in its dirty track ring.
> >  
> > I _think_ it might be OK to drop this invalidation,
> > and rely on the fact that kvm_hv_setup_tsc_page will update it,
> > and it is called when vCPU0 processes KVM_REQ_CLOCK_UPDATE which is raised in the
> > kvm_vm_ioctl_set_clock eventually.
> >  
> > Vitaly, any thoughts on this?
> >  
> 
> TSC page (as well as SynIC pages) are supposed to be "overlay" pages
> which are mapped over guest's memory but KVM doesn't do that and just
> writes to guest's memory. This kind of works as Windows/Hyper-V guests
> never disable these features and expecting the memory behind them to
> stay intact.
> 
> Dirty tracking for active TSC page can be omited, I belive. Let me take
> a look at this.
> 
> > For reference those are my HV flags:
> >  
> >     $cpu_flags: |
> >         $cpu_flags,
> >         hv_relaxed,hv_spinlocks=0x1fff,hv_vpindex,     # General HV features
> >         hv_runtime,hv_time,hv-frequencies,             # Clock stuff        
> >         hv_synic,hv_stimer,hv-stimer-direct,#hv-vapic, # APIC extensions
> >         #hv-tlbflush,hv-ipi,                           # IPI extensions
> >         hv-reenlightenment,                            # nested stuff
> >  
> >  
> >  
> > PS: unrelated question:
> >  
> > Vitaly, do you know why hv-evmcs needs hv-vapic?
> >  
> >  
> > I know that they stuffed the eVMCS pointer to HV_X64_MSR_VP_ASSIST_PAGE,
> >  
> > But can't we set HV_APIC_ACCESS_AVAILABLE but not HV_APIC_ACCESS_RECOMMENDED
> > so that guest would hopefully still know that HV assist page is available,
> > but should not use it for APIC acceleration?
> 
> Yes,
> 
> "hv-vapic" enables so-called "VP Assist" page and Enlightened VMCS GPA
> sits there, it is used instead of VMPTRLD (which becomes unsupported)
> 
> Take a look at the newly introduced "hv-apicv"/"hv-avic" (the same
> thing) in QEMU: 
> 
> commit e1f9a8e8c90ae54387922e33e5ac4fd759747d01
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Thu Sep 2 11:35:28 2021 +0200
> 
>     i386: Implement pseudo 'hv-avic' ('hv-apicv') enlightenment
> 
> when enabled, HV_APIC_ACCESS_RECOMMENDED is not set even with "hv-vapic"
> (but HV_APIC_ACCESS_AVAILABLE remains). 
> 

Cool, I didn't expect this. I thought that hv-vapic only enables the AutoEOI
deprecation bit.

This needs to be updated in hyperv.txt in qemu - it currently states that
hv-evmcs disables posted interrupts (that is APICv) and hv-avic
only mentions AutoEOI feature.

Thanks!
Best regards,
	Maxim Levitsky

