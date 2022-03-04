Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A594CDBDA
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241472AbiCDSMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 13:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbiCDSMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 13:12:47 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0701C666E;
        Fri,  4 Mar 2022 10:11:59 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id p4so11832903edi.1;
        Fri, 04 Mar 2022 10:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tIN13TWuIqVkdYdqAGwqsk2ezDcrMTPKsAwAdQHKKcE=;
        b=hRj9oqN8hOctWayWpATxG/nIqDH10fnWP899wm8utzM3mCf6Fqcsd659YYKCgTrCi2
         bdacqOg/pXaHec7TKEA4PoSJvutAwRNVFNLDT/uoyjrnIUAopz6BrSt5RcKXaaEsssnX
         EAs3udeSFgirMjKk1Qamysb+AwTWYGDiGYgAoqQdF2vqztqI2zm6cfvVwKy7TxiXIjuU
         i/681TXZpPDDLeS49EnpTgjcD0drM77sb6SfPikxzc4lNf+twPlXHl8uQtsrwqHV1obH
         E10h7AIPzFEZCX3RyiIXyGdNw3pOyefwT0gKgg4aFOk467ZQQf87H17SCKTMdd5HbDQW
         KbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tIN13TWuIqVkdYdqAGwqsk2ezDcrMTPKsAwAdQHKKcE=;
        b=RoEPxECGBJUFEfaBaJc1gkNyHSUtQIB/1WQP2H0h5f3SXzxhRvmy1uLr+GFgzcqBih
         t2mspp5uJej9GVWFVu+ANyZtIk/RFBOHifp8exPbGB2qHmZxdX8G2FW6d/BV10j37j8Z
         WhyR0kYOMP2at1FwgPYBeFUrKvqrN2mBhCWteupqSe/PMGGDvb4ApbRatIzBMBJFi1ah
         R266suldzekUnn4KO4qgseGC5xx5Z6dG6NAN3zvmDtEMSlRquHH4o5h5Yp94vkuloilK
         tCF1i9n8OL1oW/7uB0PMMARdwSAM7WvKiTvQCCB+LGMUxfNIqo4ZPVyhANN3IvsXrW/4
         qtVQ==
X-Gm-Message-State: AOAM531qk3C1S9aM7ExqBMpWRjSW6lJ5Tj31nWVE24+DOMzGvwxJyFh8
        Defb2idZQ71nFhgrXToCFrI=
X-Google-Smtp-Source: ABdhPJyTwzLBayjlRop8xK9BoE2ZyRz1Cy6Kl+/tNQcC0TuDDerswyibHvSKORzTQK309VATWxg0cQ==
X-Received: by 2002:a05:6402:34c5:b0:411:f082:d69 with SMTP id w5-20020a05640234c500b00411f0820d69mr40707510edc.65.1646417517569;
        Fri, 04 Mar 2022 10:11:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id bx1-20020a0564020b4100b00410f01a91f0sm2450758edb.73.2022.03.04.10.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 10:11:56 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8b8c28cf-cf54-f889-be7d-afc9f5430ecd@redhat.com>
Date:   Fri, 4 Mar 2022 19:11:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via
 asynchronous worker
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-22-pbonzini@redhat.com> <YiExLB3O2byI4Xdu@google.com>
 <YiEz3D18wEn8lcEq@google.com>
 <eeac12f0-0a18-8c63-1987-494a2032fa9d@redhat.com>
 <YiI4AmYkm2oiuiio@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YiI4AmYkm2oiuiio@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 17:02, Sean Christopherson wrote:
> On Fri, Mar 04, 2022, Paolo Bonzini wrote:
>> On 3/3/22 22:32, Sean Christopherson wrote:
>> I didn't remove the paragraph from the commit message, but I think it's
>> unnecessary now.  The workqueue is flushed in kvm_mmu_zap_all_fast() and
>> kvm_mmu_uninit_tdp_mmu(), unlike the buggy patch, so it doesn't need to take
>> a reference to the VM.
>>
>> I think I don't even need to check kvm->users_count in the defunct root
>> case, as long as kvm_mmu_uninit_tdp_mmu() flushes and destroys the workqueue
>> before it checks that the lists are empty.
> 
> Yes, that should work.  IIRC, the WARN_ONs will tell us/you quite quickly if
> we're wrong :-)  mmu_notifier_unregister() will call the "slow" kvm_mmu_zap_all()
> and thus ensure all non-root pages zapped, but "leaking" a worker will trigger
> the WARN_ON that there are no roots on the list.

Good, for the record these are the commit messages I have:

     KVM: x86/mmu: Zap invalidated roots via asynchronous worker
     
     Use the system worker threads to zap the roots invalidated
     by the TDP MMU's "fast zap" mechanism, implemented by
     kvm_tdp_mmu_invalidate_all_roots().
     
     At this point, apart from allowing some parallelism in the zapping of
     roots, the workqueue is a glorified linked list: work items are added and
     flushed entirely within a single kvm->slots_lock critical section.  However,
     the workqueue fixes a latent issue where kvm_mmu_zap_all_invalidated_roots()
     assumes that it owns a reference to all invalid roots; therefore, no
     one can set the invalid bit outside kvm_mmu_zap_all_fast().  Putting the
     invalidated roots on a linked list... erm, on a workqueue ensures that
     tdp_mmu_zap_root_work() only puts back those extra references that
     kvm_mmu_zap_all_invalidated_roots() had gifted to it.

and

     KVM: x86/mmu: Zap defunct roots via asynchronous worker
     
     Zap defunct roots, a.k.a. roots that have been invalidated after their
     last reference was initially dropped, asynchronously via the existing work
     queue instead of forcing the work upon the unfortunate task that happened
     to drop the last reference.
     
     If a vCPU task drops the last reference, the vCPU is effectively blocked
     by the host for the entire duration of the zap.  If the root being zapped
     happens be fully populated with 4kb leaf SPTEs, e.g. due to dirty logging
     being active, the zap can take several hundred seconds.  Unsurprisingly,
     most guests are unhappy if a vCPU disappears for hundreds of seconds.
     
     E.g. running a synthetic selftest that triggers a vCPU root zap with
     ~64tb of guest memory and 4kb SPTEs blocks the vCPU for 900+ seconds.
     Offloading the zap to a worker drops the block time to <100ms.
     
     There is an important nuance to this change.  If the same work item
     was queued twice before the work function has run, it would only
     execute once and one reference would be leaked.  Therefore, now that
     queueing items is not anymore protected by write_lock(&kvm->mmu_lock),
     kvm_tdp_mmu_invalidate_all_roots() has to check root->role.invalid and
     skip already invalid roots.  On the other hand, kvm_mmu_zap_all_fast()
     must return only after those skipped roots have been zapped as well.
     These two requirements can be satisfied only if _all_ places that
     change invalid to true now schedule the worker before releasing the
     mmu_lock.  There are just two, kvm_tdp_mmu_put_root() and
     kvm_tdp_mmu_invalidate_all_roots().

Paolo
