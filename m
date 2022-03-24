Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30554E6684
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 16:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351549AbiCXQAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 12:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351642AbiCXQAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 12:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1C67B0A51
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 08:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648137506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQInes9wfFX71q4vYPtVuJSXowVUG72HzIQ/XH1gQcA=;
        b=fNGZvnPQDvoz7c3+7MkIPz/t2Oal35LO4ctchQ7dnSPHWNrBGYWwfEGSdckobotKE3M6yo
        UN2z4eWyShTn+EI6mB8xHZYIbqkwnaaN1YbGmwFTa8XOpD6puvZeaKbStmR6KDXqJr/o5t
        pSW9G0hWbsqCCTukJhZfoIloKwGE8AY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-6a5ZNZXGNne6g--GCxBnxA-1; Thu, 24 Mar 2022 11:58:23 -0400
X-MC-Unique: 6a5ZNZXGNne6g--GCxBnxA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C55B4185A7B2;
        Thu, 24 Mar 2022 15:58:22 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A43A4C15D49;
        Thu, 24 Mar 2022 15:58:21 +0000 (UTC)
Message-ID: <68b1caabe6242dda55720c553102f7eca0587c00.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Move npt test cases and NPT code
 improvements
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Manali Shukla <manali.shukla@amd.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org
Date:   Thu, 24 Mar 2022 17:58:20 +0200
In-Reply-To: <20220324053046.200556-1-manali.shukla@amd.com>
References: <20220324053046.200556-1-manali.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-24 at 05:30 +0000, Manali Shukla wrote:
> If __setup_vm() is changed to setup_vm(), KUT will build tests with PT_USER_MASK set on all 
> PTEs. It is a better idea to move nNPT tests to their own file so that tests don't need to 
> fiddle with page tables midway.
> 
> The quick approach to do this would be to turn the current main into a small helper, 
> without calling __setup_vm() from helper.
> 
> Current implementation of nested page table does the page table build up statistically 
> with 2048 PTEs and one pml4 entry. With newly implemented routine, nested page table can 
> be implemented dynamically based on the RAM size of VM which enables us to have separate 
> memory ranges to test various npt test cases.
> 
> Based on this implementation, minimal changes were required to be done in below mentioned 
> existing APIs:
> npt_get_pde(), npt_get_pte(), npt_get_pdpe().
> 
> v1 -> v2
> Added new patch for building up a nested page table dynamically and did minimal changes 
> required to make it adaptable with old test cases.
> 
> There are four patches in this patch series
> 1) Turned current main into helper function minus setup_vm().
> 2) Moved all nNPT test cases from svm_tests.c to svm_npt.c.
> 3) Enabled PT_USER_MASK for all nSVM test cases other than nNPT tests.
> 4) Implemented routine to build up nested page table dynamically.
> 
> *** BLURB HERE ***
> 
> Manali Shukla (4):
>   x86: nSVM: Move common functionality of the main() to helper
>     run_svm_tests
>   x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
>     file.
>   x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
>   x86: nSVM: Build up the nested page table dynamically
> 
>  x86/Makefile.common |   2 +
>  x86/Makefile.x86_64 |   2 +
>  x86/svm.c           | 169 ++++++++++++-------
>  x86/svm.h           |  18 ++-
>  x86/svm_npt.c       | 386 ++++++++++++++++++++++++++++++++++++++++++++
>  x86/svm_tests.c     | 369 +-----------------------------------------
>  6 files changed, 526 insertions(+), 420 deletions(-)
>  create mode 100644 x86/svm_npt.c
> 

Yesterday I was prototyping something similar for my use case.
 
I would like to have mini SVM library which can be called from any test,
and in particular from a test which is mostly not SVM, but sometimes
one of its vCPU enters a nested guest.

(The test in question sends lots of IPIs between vCPUs, and sometimes,
it likes a vCPU to be running a nested guest to test that this works.
 
I'll see if I can finish this. Meanwhile these patches do look good to me.
 
Best regards,
	Maxim Levitsky
 
 
 

