Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5F35C01DC
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiIUPmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiIUPlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:41:45 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A5DB1EE
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:41:13 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j12so6287226pfi.11
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=91sIiMMXf+XZf2y2yqdicbq+CnNERKB1i2IpRNulDOM=;
        b=aAlj1VFD0eGAuI+68oUtYoEH6yhLMs3ZDu0i5jonRbSV3/zwextdKWRSYNlpAoz/wM
         dXLm8N1GwbRZiBiDRlIe7udz0/0AVVCSnjxOb78D7rRjV56ux6dJu8IGKQG1eNRxoRFH
         0cGlfs+MLoTfGix1o2F+wJN5DverGAmFOgSvItgCQ7krW3LbqqVZ+H7wt7LOTFougB74
         ILPWgusRqEuo4/neFDbDSc6fYOt/2/xDS+AdPBlFVJ1q08tCZ1Q2N29wdv1iikwWQs21
         /LapXhcam+oQ8fLA7AHOhb9mMFhLxSiNL8NAy32SXReB5QxSw9ih4L8pmfFQ0PeOj4m6
         ui4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=91sIiMMXf+XZf2y2yqdicbq+CnNERKB1i2IpRNulDOM=;
        b=ZegsxAA9MUUFcXiSeiVxmSKCtP1quzj1wI4RC4HUt7H6QXT+uFcIAY1t2vBQEA1FNo
         iy3tZi1TJUxMeyfWhmY73q1RLXC0Fujx+Wu2K/lyW+/a97NHu0ktI1LXvXjTluPLuVEP
         OexGYOiG6SNL24K9JFuz65V4XmaEgOr/1SttEx63Ta+EPvfBiHNiRk1a1Drsp+Ur1RaN
         Ucpx2ggzlB/r12S+3UqTY1z03b4uQkWfXZzeFDWaShouqya1qwZsPYwn/hWaEKFfZwVB
         mOW4OiMEZ/q4lwa4H+J3yh7I4gVjQSpnSuBEeZ7Mu7kFEcOnH8LfJeViYCNtlXf0jHCr
         mqmw==
X-Gm-Message-State: ACrzQf1OaIqJaVpKVp+O8Jvs8uAcqK28n5u8lw9a6/7lsn7DnLKpsAXW
        UJ1stBwrVBM4xCxil+kZXjxsdQ==
X-Google-Smtp-Source: AMsMyM7wFmaOmyLX5T/GZckzAlfHslLzY7kkHRSDQZwjjOFcvQrM4xRm0MGsDc+7uCn5SdoKDr4vnQ==
X-Received: by 2002:a63:5a50:0:b0:429:8580:fc61 with SMTP id k16-20020a635a50000000b004298580fc61mr26000546pgm.215.1663774872529;
        Wed, 21 Sep 2022 08:41:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902eccd00b0016be596c8afsm2170943plh.282.2022.09.21.08.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 08:41:12 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:41:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 1/9] KVM: x86/mmu: Bug the VM if KVM attempts to
 double count an NX huge page
Message-ID: <YyswlLykptcOciOS@google.com>
References: <20220830235537.4004585-1-seanjc@google.com>
 <20220830235537.4004585-2-seanjc@google.com>
 <87tu50oohn.fsf@redhat.com>
 <YysjGNtYJbbPuxSN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YysjGNtYJbbPuxSN@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Sean Christopherson wrote:
> On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> > [  962.257992]  ept_fetch+0x504/0x5a0 [kvm]
> > [  962.261959]  ept_page_fault+0x2d7/0x300 [kvm]
> > [  962.287701]  kvm_mmu_page_fault+0x258/0x290 [kvm]
> > [  962.292451]  vmx_handle_exit+0xe/0x40 [kvm_intel]
> > [  962.297173]  vcpu_enter_guest+0x665/0xfc0 [kvm]
> > [  962.307580]  vcpu_run+0x33/0x250 [kvm]
> > [  962.311367]  kvm_arch_vcpu_ioctl_run+0xf7/0x460 [kvm]
> > [  962.316456]  kvm_vcpu_ioctl+0x271/0x670 [kvm]
> > [  962.320843]  __x64_sys_ioctl+0x87/0xc0
> > [  962.324602]  do_syscall_64+0x38/0x90
> > [  962.328192]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Ugh, past me completely forgot the basics of shadow paging[*].  The shadow MMU
> can reuse existing shadow pages, whereas the TDP MMU always links in new pages.
> 
> I got turned around by the "doesn't exist" check, which only means "is there
> already a _SPTE_ here", not "is there an existing SP for the target gfn+role that
> can be used".
> 
> I'll drop the series from the queue, send a new pull request, and spin a v5
> targeting 6.2, which amusing will look a lot like v1...

Huh.  I was expecting more churn, but dropping the offending patch and then
"reworking" the series yields a very trivial overall diff.  

Vitaly, can you easily re-test with the below, i.e. simply delete the KVM_BUG_ON()?
I'll still spin a v5, but assuming all is well I think this can go into 6.1 and
not get pushed out to 6.2.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 54ee48a87f81..e6f19e605979 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -804,7 +804,15 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-       if (KVM_BUG_ON(!list_empty(&sp->possible_nx_huge_page_link), kvm))
+       /*
+        * If it's possible to replace the shadow page with an NX huge page,
+        * i.e. if the shadow page is the only thing currently preventing KVM
+        * from using a huge page, add the shadow page to the list of "to be
+        * zapped for NX recovery" pages.  Note, the shadow page can already be
+        * on the list if KVM is reusing an existing shadow page, i.e. if KVM
+        * links a shadow page at multiple points.
+        */
+       if (!list_empty(&sp->possible_nx_huge_page_link))
                return;
 
        ++kvm->stat.nx_lpage_splits;

