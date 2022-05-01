Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6909251625A
	for <lists+kvm@lfdr.de>; Sun,  1 May 2022 09:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242262AbiEAGxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 02:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiEAGx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 02:53:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E99777E585
        for <kvm@vger.kernel.org>; Sat, 30 Apr 2022 23:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651387804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q3u3MlJs34Y3mqoufs+636rYeTTf6eHsg/a1Eoy23vg=;
        b=RcCcVQ1n2Axwpplp82bpaRRS+RgQZfJAdo1vUQCIlsThLDo/yzvrrO31J90BgyBEr3LgxJ
        dqfC9gYtrHtMvmI9LsvJyBktjwmaZ8yX41Z68YZ+zzsPSdjIu64deE4a9o0X7qzRaY00Qr
        Z6+/jWgOWWpu4uQBGBWNaFYh3hSZkGY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-Q1LTSDhBP5a7f4e66Oa3zA-1; Sun, 01 May 2022 02:50:01 -0400
X-MC-Unique: Q1LTSDhBP5a7f4e66Oa3zA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78A3A8002BF;
        Sun,  1 May 2022 06:50:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 463DA14152E6;
        Sun,  1 May 2022 06:49:58 +0000 (UTC)
Message-ID: <3f0a9c9782b90e882da1229c00241da8cef89b21.camel@redhat.com>
Subject: Re: [PATCH v2 11/12] KVM: SVM: Do not inhibit APICv when x2APIC is
 present
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
Date:   Sun, 01 May 2022 09:49:57 +0300
In-Reply-To: <YmwZxAWJ8KqHodbf@google.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-12-suravee.suthikulpanit@amd.com>
         <3fd0aabb6288a5703760da854fd6b09a485a2d69.camel@redhat.com>
         <01460b72-1189-fef1-9718-816f2f658d42@amd.com>
         <b9ee5f62e904a690d7e2d8837ade8ece7e24a359.camel@redhat.com>
         <41b1e63ad6e45be019bbedc93bd18cfcb9475b06.camel@redhat.com>
         <YmwZxAWJ8KqHodbf@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-04-29 at 17:00 +0000, Sean Christopherson wrote:
> On Tue, Apr 26, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-04-26 at 10:06 +0300, Maxim Levitsky wrote:
> > BTW, can I ask you to check something on the AMD side of things of AVIC?
> > 
> > I noticed that AMD's manual states that:
> > 
> > "Multiprocessor VM requirements. When running a VM which has multiple virtual CPUs, and the
> > VMM runs a virtual CPU on a core which had last run a different virtual CPU from the same VM,
> > regardless of the respective ASID values, care must be taken to flush the TLB on the VMRUN using a
> > TLB_CONTROL value of 3h. Failure to do so may result in stale mappings misdirecting virtual APIC
> > accesses to the previous virtual CPU's APIC backing page."
> > 
> > It it relevant to KVM? I don't fully understand why it was mentioned that ASID doesn't matter,
> > what makes it special about 'virtual CPU from the same VM' if ASID doesn't matter? 
> 
> I believe it's calling out that, because vCPUs from the same VM likely share an ASID,
> the magic TLB entry for the APIC-access page, which redirects to the virtual APIC page,
> will be preserved.  And so if the hypervisor doesn't flush the ASID/TLB, accelerated
> xAPIC accesses for the new vCPU will go to the previous vCPU's virtual APIC page.

This is what I want to think as well, but the manual says explicitly 
"regardless of the respective ASID values"

On the face value of it, the only logical way to read this IMHO,
is that every time apic backing page is changed, we need to issue a TLB flush.

Best regards,
	Maxim Levitsky

> 
> Intel has the same requirement, though this specific scenario isn't as well documented.
> E.g. even if using EPT and VPID, the EPT still needs to be invalidated because the
> TLB can cache guest-physical mappings, which are not associated with a VPID.
> 
> Huh.  I was going to say that KVM does the necessary flushes in vmx_vcpu_load_vmcs()
> and pre_svm_run(), but I don't think that's true.  KVM flushes if the _new_ VMCS/VMCB
> is being migrated to a different pCPU, but neither VMX nor SVM flush when switching
> between vCPUs that are both "loaded" on the current pCPU.
> 
> Switching between vmcs01 and vmcs02 is ok, because KVM always forces a different
> EPTP, even if L1 is using shadow paging (the guest_mode bit in the role prevents
> reusing a root).  nSVM is "ok" because it flushes on every transition anyways.
> 


