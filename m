Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87F155E694
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346845AbiF1Nnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346843AbiF1Nnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:43:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F8B9C61
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656423810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cW2a4YUNnUssvuoOmnrQqPk0B+mOaabUamfGI9ndHfY=;
        b=AcYrYnxLjTP1M3tUDD3haBSN2a3Y2RqVL4cL44ryGfKQYMXeG0dIvsVcEeLmyWFSxjVtQZ
        sLuZYYIo6v+SPDSH1zIyjfDq2BMkm0TtZWDLT5yi+hyU2eJQezbumTAmugr3sUTEn64i3g
        vgNs6/z52rucvyykQhUJRqLnPukm9RU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-OLBmRs1BN464TwGQg1zc_w-1; Tue, 28 Jun 2022 09:43:29 -0400
X-MC-Unique: OLBmRs1BN464TwGQg1zc_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 677023C16187;
        Tue, 28 Jun 2022 13:43:28 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A4F7404E4C8;
        Tue, 28 Jun 2022 13:43:26 +0000 (UTC)
Message-ID: <a5fe4ca7a412c7e4970d7c0d48b17cefcd91833c.camel@redhat.com>
Subject: Re: [PATCH v6 00/17] Introducing AMD x2AVIC and hybrid-AVIC modes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Tue, 28 Jun 2022 16:43:25 +0300
In-Reply-To: <84d30ead-7c8e-1f81-aa43-8a959e3ae7d0@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
         <84d30ead-7c8e-1f81-aa43-8a959e3ae7d0@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 20:20 +0700, Suthikulpanit, Suravee wrote:
> Maxim,
> 
> On 5/19/2022 5:26 PM, Suravee Suthikulpanit wrote:
> > Introducing support for AMD x2APIC virtualization. This feature is
> > indicated by the CPUID Fn8000_000A EDX[14], and it can be activated
> > by setting bit 31 (enable AVIC) and bit 30 (x2APIC mode) of VMCB
> > offset 60h.
> > 
> > With x2AVIC support, the guest local APIC can be fully virtualized in
> > both xAPIC and x2APIC modes, and the mode can be changed during runtime.
> > For example, when AVIC is enabled, the hypervisor set VMCB bit 31
> > to activate AVIC for each vCPU. Then, it keeps track of each vCPU's
> > APIC mode, and updates VMCB bit 30 to enable/disable x2APIC
> > virtualization mode accordingly.
> > 
> > Besides setting bit VMCB bit 30 and 31, for x2AVIC, kvm_amd driver needs
> > to disable interception for the x2APIC MSR range to allow AVIC hardware
> > to virtualize register accesses.
> > 
> > This series also introduce a partial APIC virtualization (hybrid-AVIC)
> > mode, where APIC register accesses are trapped (i.e. not virtualized
> > by hardware), but leverage AVIC doorbell for interrupt injection.
> > This eliminates need to disable x2APIC in the guest on system without
> > x2AVIC support. (Note: suggested by Maxim)
> > 
> > Testing for v5:
> >    * Test partial AVIC mode by launching a VM with x2APIC mode
> >    * Tested booting a Linux VM with x2APIC physical and logical modes upto 512 vCPUs.
> >    * Test the following nested SVM test use cases:
> > 
> >               L0     |    L1   |   L2
> >         ----------------------------------
> >                 AVIC |    APIC |    APIC
> >                 AVIC |    APIC |  x2APIC
> >          hybrid-AVIC |  x2APIC |    APIC
> >          hybrid-AVIC |  x2APIC |  x2APIC
> >               x2AVIC |    APIC |    APIC
> >               x2AVIC |    APIC |  x2APIC
> >               x2AVIC |  x2APIC |    APIC
> >               x2AVIC |  x2APIC |  x2APIC
> 
> With the commit 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base"),
> APICV/AVIC is now inhibit when the guest kernel boots w/ option "nox2apic" or "x2apic_phys"
> due to APICV_INHIBIT_REASON_APIC_ID_MODIFIED.
> 
> These cases used to work. In theory, we should be able to allow AVIC works in this case.
> Is there a way to modify logic in kvm_lapic_xapic_id_updated() to allow these use cases
> to work w/ APICv/AVIC?
> 
> Best Regards,
> Suravee
> 

This seems very strange, I assume you test the kvm/queue of today,

which contains a fix for a typo I had in the list of inhibit reasons
(commit 5bdae49fc2f689b5f896b54bd9230425d3643dab - KVM: SEV: fix misplaced closing parenthesis)


Could you share more details on the test? How many vCPUs in the guest, is x2apic exposed to the guest?


Looking through the code the the __x2apic_disable, touches the MSR_IA32_APICBASE so I would expect
the APICV_INHIBIT_REASON_APIC_BASE_MODIFIED inhibit to be triggered and not APICV_INHIBIT_REASON_APIC_ID_MODIFIED


I don't see yet how the x2apic_phys can trigger these inhibits.

Best regards,
	Maxim Levitsky

