Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009C3617EEC
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 15:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiKCOHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 10:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiKCOHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 10:07:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E0F101D0
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 07:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667484408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4x9kvayeo4WDR+ntPzcjIFI+riYUY38wegNmKe10nu4=;
        b=GadKX8RyLlBGSvoUdi5aYkLTELe1P6aEC3GLC1kK4YtW61RazcTHc3qibZBiT9wN+vP6hf
        jG9O6b8B5mARq3dZTq0xpQ7LN3/r1IsBZvPmqsL/pDeSl39vXg6svuBLhzBaD/8rLsb3S9
        hDOUdKaCndbzeoVWZr6JeBojKe3XSQo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-606-58e759YeOs-4mQnSnwBbqg-1; Thu, 03 Nov 2022 10:06:48 -0400
X-MC-Unique: 58e759YeOs-4mQnSnwBbqg-1
Received: by mail-qk1-f200.google.com with SMTP id n13-20020a05620a294d00b006cf933c40feso2016587qkp.20
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 07:06:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4x9kvayeo4WDR+ntPzcjIFI+riYUY38wegNmKe10nu4=;
        b=OuhXzmE+/bbSOkZGBszdsku7sU0LyiKPQno+xqLLQtq4DMxqnH+0wlbJrVoYxaxSBs
         Ag/Jhg/8c5rYNZ6MRLbHhpJedpBgN3LKHmcH+ntJp0isCRdIYSB7fQRZLPAmp3OtnGlk
         569zfzDnjHLNnB9uu8PY81bbKUc5b9pXf5NTMBjAfZNwr8FcMpcoQpLRUdiUO9D3/FfW
         YbceePRjYqEIVYgCf55+ZOFAWRhZlLEJFEkbhIAKtdfvYx2r9Wwbe1qwqKoXFUogjqgH
         G5OXUmiLVTHTOZ0gLI5RhaxKY5F1kjjjzyp/DZcGq+Eh/EHOcj9H3Xc2CRpx3hDgoO3Y
         wdVw==
X-Gm-Message-State: ACrzQf0IsDnKDyxrCVbSYgHUGOuYoLMy/WvYqjp/TVEQZf4VjbA2akgC
        NaER78MR7y4W0AhPmFTBu1Qr7Qnb8Kbplldwogn+Ek9Mu3rOzZe93yjKAMS232AZA3oTgS4mw0h
        3GGhnw9uDZ9hK/bfzQuR6BN+0IDjOHFQz49mpN8U/JydvdVaycCViDL7JrMhojbkn
X-Received: by 2002:ae9:f714:0:b0:6fa:43e5:4be0 with SMTP id s20-20020ae9f714000000b006fa43e54be0mr12025962qkg.243.1667484407005;
        Thu, 03 Nov 2022 07:06:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7TyUBX3uqeAaNVtbhyJqnoCjQSSozPE1tCnGDxPKMpDcmHdEXVL5+awPM0oKn14YKSLETz9w==
X-Received: by 2002:ae9:f714:0:b0:6fa:43e5:4be0 with SMTP id s20-20020ae9f714000000b006fa43e54be0mr12025898qkg.243.1667484406584;
        Thu, 03 Nov 2022 07:06:46 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id o5-20020ac87c45000000b003a50d92f9b4sm608578qtv.1.2022.11.03.07.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 07:06:45 -0700 (PDT)
Message-ID: <33dfde6d609bc800edc5e813705523f6afdcedf0.camel@redhat.com>
Subject: Re: [PATCH 0/9] nSVM: Security and correctness fixes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>, linux-kselftest@vger.kernel.org
Date:   Thu, 03 Nov 2022 16:06:40 +0200
In-Reply-To: <20221103135736.42295-1-mlevitsk@redhat.com>
References: <20221103135736.42295-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-03 at 15:57 +0200, Maxim Levitsky wrote:
> Recently while trying to fix some unit tests I found a CVE in SVM nested code.
> 
> In 'shutdown_interception' vmexit handler we call kvm_vcpu_reset.
> 
> However if running nested and L1 doesn't intercept shutdown, we will still end
> up running this function and trigger a bug in it.
> 
> The bug is that this function resets the 'vcpu->arch.hflags' without properly
> leaving the nested state, which leaves the vCPU in inconsistent state, which
> later triggers a kernel panic in SVM code.
> 
> The same bug can likely be triggered by sending INIT via local apic to a vCPU
> which runs a nested guest.
> 
> On VMX we are lucky that the issue can't happen because VMX always intercepts
> triple faults, thus triple fault in L2 will always be redirected to L1.
> Plus the 'handle_triple_fault' of VMX doesn't reset the vCPU.
> 
> INIT IPI can't happen on VMX either because INIT events are masked while in
> VMX mode.
> 
> First 4 patches in this series address the above issue, and are
> already posted on the list with title,
> ('nSVM: fix L0 crash if L2 has shutdown condtion which L1 doesn't intercept')
> I addressed the review feedback and also added a unit test to hit this issue.
> 
> In addition to these patches I noticed that KVM doesn't honour SHUTDOWN intercept bit
> of L1 on SVM, and I included a fix to do so - its only for correctness
> as a normal hypervisor should always intercept SHUTDOWN.
> A unit test on the other hand might want to not do so.
> I also extendted the triple_fault_test selftest to hit this issue.
> 
> Finaly I found another security issue, I found a way to
> trigger a kernel non rate limited printk on SVM from the guest, and
> last patch in the series fixes that.
> 
> A unit test I posted to kvm-unit-tests project hits this issue, so
> no selftest was added.
> 
> Best regards,
>         Maxim Levitsky
> 
> Maxim Levitsky (9):
>   KVM: x86: nSVM: leave nested mode on vCPU free
>   KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while
>     still in use
>   KVM: x86: add kvm_leave_nested
>   KVM: x86: forcibly leave nested mode on vCPU reset
>   KVM: selftests: move idt_entry to header
>   kvm: selftests: add svm nested shutdown test
>   KVM: x86: allow L1 to not intercept triple fault
>   KVM: selftests: add svm part to triple_fault_test
>   KVM: x86: remove exit_int_info warning in svm_handle_exit
> 
>  arch/x86/kvm/svm/nested.c                     | 12 +++-
>  arch/x86/kvm/svm/svm.c                        | 10 +--
>  arch/x86/kvm/vmx/nested.c                     |  4 +-
>  arch/x86/kvm/x86.c                            | 29 ++++++--
>  tools/testing/selftests/kvm/.gitignore        |  1 +
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/include/x86_64/processor.h  | 13 ++++
>  .../selftests/kvm/lib/x86_64/processor.c      | 13 ----
>  .../kvm/x86_64/svm_nested_shutdown_test.c     | 71 +++++++++++++++++++
>  .../kvm/x86_64/triple_fault_event_test.c      | 71 ++++++++++++++-----
>  10 files changed, 174 insertions(+), 51 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
> 
> -- 
> 2.34.3
> 
> 


I jumped the gun a bit with this patch series, there are few checkpatch.pl issues and some
leftovers I didn't remove. I'll resend this shortly.

Best regards,
	Maxim Levitsky


