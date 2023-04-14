Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6B26E1CE6
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 09:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjDNHEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 03:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjDNHEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 03:04:08 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5370358A;
        Fri, 14 Apr 2023 00:04:05 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2a76c29675bso873301fa.1;
        Fri, 14 Apr 2023 00:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681455844; x=1684047844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNC6c0xQ2h1SpIFbxyMVPWbgAESPX8VkOwXJK9TQscE=;
        b=Al0TNUDmjboO7Q4Izn7ycGOoqkwkwEmlDsdtpcYn712dPRdWz1T/g56hZWkt6s1o7A
         KIbzSRi/ynOHYyAVnGn+6U1mmtoiryWLnEAuo/4rN+uxv0CDoGzlz/O+BnOa01BzHp/x
         CTOUW79JVretRDDXQp15NwQdk21G3jAs2e6/tqVF/6hQCFEh8S9uZ7Nif1PK0cXHo/jV
         XG5VFNyQ28Ln6tjSQ5XAaCWmmFte5KNBtJhFgmHgMmWBbG9OSXg9ZjzjyqaUeIRWken2
         szNFZCB/mGI7mRpuMGRY4Kf6xhICoQQFjvtlwNMnCr/2J5TB8UPvIan2ljArTAwRP05e
         e7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681455844; x=1684047844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SNC6c0xQ2h1SpIFbxyMVPWbgAESPX8VkOwXJK9TQscE=;
        b=PSrXQP8oCfkn7wNC6uTaWC1IDxav1SAMzsgW7V25nAYSg+oF04nSW3FNXTzYPpvr7R
         fGrMXEY236BJeVlejt4Dya8WYYEvhaFDsCpbdL4Y5UOnOVy2hS8s71gZKWBxeNXBLv73
         qjhrvUGdDKfe92lglnOHCUwCAZS11eJFft58krAfrQjZnaHx4f17w2KKJ2UKli3UulkV
         tnRA7Ix2OWmvNvdgyC1Zocg0ygXCM59cNoxh5mbyL15Bpx2HS7vbSCXN9AXTpZNgpt48
         YsCqWd0kGXi/VqB7hLJzUAbxAOkLZxUya5lPYyadQ7N+Na3nQLUJrRGnhJH1gIFh8zN3
         3ZQw==
X-Gm-Message-State: AAQBX9cwR71GwbymF7Jr7HAJq52EamxyNt1EVZBduyUyBtjux82pzUr2
        Zu1lzLmJKh1OiGS5p092JHg=
X-Google-Smtp-Source: AKy350aRdZiS3Z9ue+txSP8VFrS8uHtMXjH4JMhqAFyBHrSJ8HDcAjWgTCWzvh6Znqk46OFjrXXvOQ==
X-Received: by 2002:ac2:5a0a:0:b0:4e8:586c:f13 with SMTP id q10-20020ac25a0a000000b004e8586c0f13mr363211lfn.6.1681455843741;
        Fri, 14 Apr 2023 00:04:03 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id q5-20020ac24a65000000b004eae7890269sm658148lfp.138.2023.04.14.00.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 00:04:03 -0700 (PDT)
Date:   Fri, 14 Apr 2023 10:03:50 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH 0/5] Add TDX intra host migration support
Message-ID: <20230414100350.00000955.zhi.wang.linux@gmail.com>
In-Reply-To: <20230407201921.2703758-1-sagis@google.com>
References: <20230407201921.2703758-1-sagis@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Apr 2023 20:19:16 +0000
Sagi Shahar <sagis@google.com> wrote:

Hi:

Is there any userspace using these APIs? I cant find them in AMD-QEMU repo
and upstream QEMU repo. It would nice to first take a look on how userspace
is going to use it.

> This patchset adds support for TDX intra host migration using the same
> API which was added for SEV intra host migration here:
> https://lore.kernel.org/all/20211021174303.385706-1-pgonda@google.com/
> 
> This patchset relies on the latest TDX patches from Intel:
> - fd-based approach for supporing KVM v10 and
>   https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@linux.intel.com/
> - TDX host kernel support v10
>   https://lore.kernel.org/lkml/cover.1678111292.git.kai.huang@intel.com/
> - KVM TDX basic feature support v13
>   https://lore.kernel.org/cover.1678643051.git.isaku.yamahata@intel.com
> 
> The tree can be found at https://github.com/googleprodkernel/linux-cc/tree/copyless
> and is based on Intel's tdx tree at https://github.com/intel/tdx/tree/kvm-upstream
> 
> In the TDX case, we need to transfer the VM state from multiple sources:
> 
>  * HKID and encrypted VM state is transfered between the kvm_tdx
>    objects.
>  * Encrypted and runtime state is transfered between the vcpu_tdx
>    objects.
>  * The EPT table backing TD's private memory is transfered at the
>    kvm-mmu level. This is needed since the secure EPT table managed by
>    the TD module remains the same after the migration so moving the
>    current private EPT table eliminates the need to rebuild the private
>    EPT table to match the secure EPT table on the destination.
>  * Information regarding the current shared/private memory is trasfered
>    using the mem_attr_array stored at the kvm object.
>  * Additional information derived from shared/private memory state is
>    trasfered at the memslot level.
> 
> Tested with selftests locally. I will attach the self test in the next
> version after we send the new TDX selftest framework patches based on
> KVM TDX basic feature support v13.
> 
> Sagi Shahar (5):
>   KVM: Split tdp_mmu_pages to private and shared lists
>   KVM: SEV: Refactor common code out of sev_vm_move_enc_context_from
>   KVM: TDX: Add base implementation for tdx_vm_move_enc_context_from
>   KVM: TDX: Implement moving private pages between 2 TDs
>   KVM: TDX: Add core logic for TDX intra-host migration
> 
>  arch/x86/include/asm/kvm_host.h |   5 +-
>  arch/x86/kvm/mmu.h              |   2 +
>  arch/x86/kvm/mmu/mmu.c          |  60 ++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c      |  88 +++++++++++-
>  arch/x86/kvm/mmu/tdp_mmu.h      |   3 +
>  arch/x86/kvm/svm/sev.c          | 175 +++--------------------
>  arch/x86/kvm/vmx/main.c         |  10 ++
>  arch/x86/kvm/vmx/tdx.c          | 245 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h          |   2 +
>  arch/x86/kvm/vmx/x86_ops.h      |   5 +
>  arch/x86/kvm/x86.c              | 166 ++++++++++++++++++++++
>  arch/x86/kvm/x86.h              |  16 +++
>  12 files changed, 613 insertions(+), 164 deletions(-)
> 

