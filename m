Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520AF57DD1A
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 11:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbiGVJG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 05:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiGVJGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 05:06:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24BBA81495
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 02:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658480777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rbYwuV3i4PqAHK5ld50ISeNUCppbs4nL1D7WPVjNER8=;
        b=PADBQZdjNaL7GC9+aUD9livOYlIPVAGTfpeKgTjf+8n/3ak2QkslV/HWyzcuDYslvnktKt
        vEG96YEcJS9VIGcIrWHPz0BZGyyS1+jky/tQm09YlH46hG+4QmFSS0UXLv2NlpIgLq4bBx
        rncXnTwYaD/JvMqn5Jt2+JEQsmfHw6E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-LjdUbZgTPcmgRMRM2GBxig-1; Fri, 22 Jul 2022 05:06:16 -0400
X-MC-Unique: LjdUbZgTPcmgRMRM2GBxig-1
Received: by mail-wm1-f71.google.com with SMTP id n30-20020a05600c501e00b003a3264465ebso3192813wmr.1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 02:06:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=rbYwuV3i4PqAHK5ld50ISeNUCppbs4nL1D7WPVjNER8=;
        b=hZnQ+9HylbumZNYCodweto+CEO9KTKJ/fpDYDWQwA9qklRy9eKl4Agkb83yvlfVrm8
         e1++PJaVsoHkPCJ/15Bkq4sDl52OUqr25bp3zkIBxAlLkS2mudEEYxHUH0wLTJv63d2B
         mSkAr7bEkVkferZZCjju6oKf3pXIjvuH8NQD5SNe/Dplw6KwGCOCzlVV9CsATDcfpdVz
         2+u6xiCFfgpvdz7hojLFG40eNdltrbABFEKMdLqWSV7P6ooBVLFCDJ4OjCGc29MgYN70
         MHur9/i+9d5rjy1lgKr6N1B6LouJa4IyhEByMlG5PF1kV9JTb1H/Z0JOExx5B9CErUS/
         81QA==
X-Gm-Message-State: AJIora9tYVn0kU/iwxpR4L7UMN7e7XCMfHxzuKqZpPfaBLDSPLzPhON9
        e3tCIJZGzKoOw7l0GNwJHpYLUVcUsK1psI6Sp5rNTrCLDg7OQyEMUQeGte9ZYkidIC0Lh6yEt1G
        rvN+rCSPzOXZk
X-Received: by 2002:adf:db51:0:b0:21e:41c2:c2e8 with SMTP id f17-20020adfdb51000000b0021e41c2c2e8mr1810840wrj.452.1658480775029;
        Fri, 22 Jul 2022 02:06:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sseLStw14oJt7duxvShbI7FdU+s/HM9kzzuXgW+lC0wBk1bXpXWTeYkdzVUHcidYvvr0xarw==
X-Received: by 2002:adf:db51:0:b0:21e:41c2:c2e8 with SMTP id f17-20020adfdb51000000b0021e41c2c2e8mr1810813wrj.452.1658480774794;
        Fri, 22 Jul 2022 02:06:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id f8-20020a05600c4e8800b003a31673515bsm9457159wmq.7.2022.07.22.02.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 02:06:14 -0700 (PDT)
Message-ID: <2f5c2242-0c73-9770-9e17-9c87c27c2f05@redhat.com>
Date:   Fri, 22 Jul 2022 11:06:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-7-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 06/15] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
In-Reply-To: <20220607213604.3346000-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/22 23:35, Sean Christopherson wrote:
> From: Oliver Upton <oupton@google.com>
> 
> Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
> when guest MPX disabled"), KVM has taken ownership of the "load
> IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls. The ABI
> is that these bits must be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
> MSRs if the guest's CPUID supports MPX, and clear otherwise.
> 
> However, commit aedbaf4f6afd ("KVM: x86: Extract
> kvm_update_cpuid_runtime() from kvm_update_cpuid()") partially broke KVM
> ownership of the aforementioned bits. Before, kvm_update_cpuid() was
> exercised frequently when running a guest and constantly applied its own
> changes to the BNDCFGS bits. Now, the BNDCFGS bits are only ever
> updated after a KVM_SET_CPUID/KVM_SET_CPUID2 ioctl, meaning that a
> subsequent MSR write from userspace will clobber these values.
> 
> Uphold the old ABI by reapplying KVM's tweaks to the BNDCFGS bits after
> an MSR write from userspace.
> 
> Note, the old ABI that is being preserved is a KVM hack to workaround a
> userspace bug; see commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX
> controls when guest MPX disabled").

Actually this is not a userspace bug.  It's an L1 workaround for running 
*correct* L1 userspace without a *kernel* bugfix on L0, namely commit 
691bd4340bef ("kvm: vmx: allow host to access guest MSR_IA32_BNDCFGS").

But thanks for writing the incorrect commit message, because now that 
I've actually looked at the history, I'm going to say screw 6 year old 
kernels used as L0.  Let's just revert commit 5f76f6f5ff96.

I've applied patches 1-5, let's see how bad the conflicts are in the 
rest of the series.

(This shows another reason why sometimes series seem to be cursed and 
don't get reviews: maintainers having a fuzzy feeling that *something* 
is wrong with them and putting off the review until it finally clicks).

Paolo

