Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1481F513AC7
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 19:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343822AbiD1RZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 13:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244722AbiD1RZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 13:25:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD2965BE5A
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 10:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651166524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3LdEdkdoLKwdyJRw9U/ij8FGS03kA2dkuIR6qlHtPI=;
        b=PmkB9TEtk8Z+j/Gr2ZxCHs7Dr8NzjWxbq70eMbxFvOG4Ac75GDatZOHAvCPqJoAdmCgR18
        PMe9+r18GDRVJBl+RwPBPGHjws7BCf8c9zWhOZX1/DZzlG6jCsYhahbGS+hG/i+Ci5oTt9
        lgi/jIKS6Rdma5pK2kA252dlA/inIMw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-RaGUCpt0NaGLulKogK1Acw-1; Thu, 28 Apr 2022 13:22:01 -0400
X-MC-Unique: RaGUCpt0NaGLulKogK1Acw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE6C8101AA45;
        Thu, 28 Apr 2022 17:22:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82500C15D40;
        Thu, 28 Apr 2022 17:21:57 +0000 (UTC)
Message-ID: <cfa024924eb3be66f94a2c59e164b9a1fa16653e.camel@redhat.com>
Subject: Re: [syzbot] WARNING in kvm_mmu_uninit_tdp_mmu (2)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     syzbot <syzbot+a8ad3ee1525a0c4b40ec@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Date:   Thu, 28 Apr 2022 20:21:56 +0300
In-Reply-To: <8f21a9d4b4ceb7c515f776b1a981c801e439c5f0.camel@redhat.com>
References: <00000000000082452505dd503126@google.com>
         <13b3235ef66f22475fd4059df95ad0144548ccd1.camel@redhat.com>
         <YmqzoFqdmH1WuPv0@google.com>
         <8f21a9d4b4ceb7c515f776b1a981c801e439c5f0.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 20:16 +0300, Maxim Levitsky wrote:
> On Thu, 2022-04-28 at 15:32 +0000, Sean Christopherson wrote:
> > On Tue, Apr 26, 2022, Maxim Levitsky wrote:
> > > I can reproduce this in a VM, by running and CTRL+C'in my ipi_stress test,
> > 
> > Can you post your ipi_stress test?  I'm curious to see if I can repro, and also
> > very curious as to what might be unique about your test.  I haven't been able to
> > repro the syzbot test, nor have I been able to repro by killing VMs/tests.
> > 
> 
> This is the patch series (mostly attempt to turn svm to mini library,
> but I don't know if this is worth it.
> It was done so that ipi_stress could use  nesting itself to wait for IPI
> from within a nested guest. I usually don't use it.
> 
> This is more or less how I was running it lately (I have a wrapper script)
> 
> 
> ./x86/run x86/ipi_stress.flat \
>         -global kvm-pit.lost_tick_policy=discard \
> 	        -machine kernel-irqchip=on -name debug-threads=on  \
> 	        \
> 	        -smp 8 \
> 	        -cpu host,x2apic=off,svm=off,-hypervisor \
> 	        -overcommit cpu-pm=on \
> 	        -m 4g -append "0 10000"

I forgot to mention: this should be run in a loop.

Best regards,
	Maxim Levitsky

> 
> 
> Its not fully finised for upstream, I will get to it soon.
> 
> 'cpu-pm=on' won't work for you as this fails due to non atomic memslot
> update bug for which I have a small hack in qemu, and it is on my
> backlog to fix it correctly.
> 
> Mostly likely cpu_pm=off will also reproduce it.
> 
> 
> Test was run in a guest, natively this doesn't seem to reproduce.
> tdp mmu was used for both L0 and L1.
> 
> Best regards,
> 	Maxim levitsky


