Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D819477E2E8
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 15:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbjHPNnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 09:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343500AbjHPNnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 09:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BEA2D66
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 06:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692193273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jN9TOD4A/0Qw8dNB02SZeeOMSlTj43nwfdVrkfW3Nrw=;
        b=fb45Tfq6m3XxGFjzy/Cv3DI4BkCICzTinERVhuqND4nWpx6aeLB1VoLEaHOCGCUojpShND
        blzw/F66TjRaYaErCLRXMTDEIF+Cs+P4CaM2I1WENnkbBkVKR7zYzQhiZ700oEzmZdgOqn
        /FK4LgYt+F/JKI0jB2fUibeNIrdMz8M=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-uhcOsuocMHWx2BhmgSdvMA-1; Wed, 16 Aug 2023 09:41:12 -0400
X-MC-Unique: uhcOsuocMHWx2BhmgSdvMA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-64742e2d873so13568726d6.0
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 06:41:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692193272; x=1692798072;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jN9TOD4A/0Qw8dNB02SZeeOMSlTj43nwfdVrkfW3Nrw=;
        b=Mj2vd5LqciNXZF/VMFVXlxgTeDExvLdEt8LYYeTmGgXGa7TNE7wEV09lsSSZ3HoX+/
         F63Iw8k/NUnijR5rR3FL3aDH4rSgmVTichh7jzLLSfVIBhNLtMzPfH+QJSUy2NU0BooS
         TKbWsXUfQvopr4FoR0/aHNQw6A63n/UdjI8agOQqTq7Sr5vGD82k2qit5kz9ocCqMH8f
         Ue1t7C5prfGfnM8shrwYF35hnAjwUviFyc/fnZLGcZ1mwa9LZTC9xC85Zl/9euS/LLpA
         11X6Gtt7jzsEVhHFh+MPSwSk45PDESJv/v973Bo62VJMEzSr9aI18kR2Aiz1mzFMqXpD
         sfxA==
X-Gm-Message-State: AOJu0Ywp7S79up/alvZAQys2mpD1gu58HfEet+hQVBj8+bqPHNf1O7kG
        J+8p3fTXEHJW426vBSJzr6zGuZGOKoXgRGMBxGa4+xRovogZmXIZpS60gb+72DsnI1arOVA93Na
        O4OgbxKO8cAR1
X-Received: by 2002:a0c:f5c8:0:b0:635:fb19:2ebd with SMTP id q8-20020a0cf5c8000000b00635fb192ebdmr2093299qvm.13.1692193272092;
        Wed, 16 Aug 2023 06:41:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaHYffXAFhTd9CZKBPQvUZnBh/Jw60Onr4ZL78JsygR0WcnheSxJMVeodMGwp8PDoLFTRlaw==
X-Received: by 2002:a0c:f5c8:0:b0:635:fb19:2ebd with SMTP id q8-20020a0cf5c8000000b00635fb192ebdmr2093286qvm.13.1692193271857;
        Wed, 16 Aug 2023 06:41:11 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id y3-20020a0cd983000000b0062ffbf23c22sm4844318qvj.131.2023.08.16.06.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 06:41:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Roman Mamedov <rm+bko@romanrm.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: Fwd: kvm: Windows Server 2003 VM fails to work on 6.1.44 (works
 fine on 6.1.43)
In-Reply-To: <87il9f5eg1.fsf@redhat.com>
References: <8cc000d5-9445-d6f1-f02e-4629a4a59e0e@gmail.com>
 <87o7j75g0g.fsf@redhat.com> <87il9f5eg1.fsf@redhat.com>
Date:   Wed, 16 Aug 2023 15:41:08 +0200
Message-ID: <87cyzn5cln.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>
>> Bagas Sanjaya <bagasdotme@gmail.com> writes:
>>
>>> Hi,
>>>
>>> I notice a regression report on Bugzilla [1]. Quoting from it:
>>>
>>>> Hello,
>>>> 
>>>> I have a virtual machine running the old Windows Server 2003. On kernels 6.1.44 and 6.1.45, the QEMU VNC window stays dark, not switching to any of the guest's video modes and the VM process uses only ~64 MB of RAM of the assigned 2 GB, indefinitely. It's like the VM is paused/halted/stuck before even starting. The process can be killed successfully and then restarted again (with the same result), so it is not deadlocked in kernel or the like.
>>>> 
>>>> Kernel 6.1.43 works fine.
>>>> 
>>>> I have also tried downgrading CPU microcode from 20230808 to 20230719, but that did not help.
>>>> 
>>>> The CPU is AMD Ryzen 5900. I suspect some of the newly added mitigations may be the culprit?
>>>
>>> See Bugzilla for the full thread.
>>>
>>> Anyway, I'm adding it to regzbot as stable-specific regression:
>>>
>>> #regzbot introduced: v6.1.43..v6.1.44 https://bugzilla.kernel.org/show_bug.cgi?id=217799
>>> #regzbot title: Windows Server 2003 VM boot hang (only 64MB RAM allocated)
>>>
>>> Thanks.
>>>
>>> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=217799
>>
>> From KVM's PoV, I don't see any KVM/x86 patches v6.1.44..v6.1.45 
>
> Oh, sorry, my bad, in the description of the BZ it is said that 6.1.44
> is already broken, so it's most likely srso stuff then:
>
> dd5f2ef16e3c x86: fix backwards merge of GDS/SRSO bit
> 4f25355540ad x86/srso: Tie SBPB bit setting to microcode patch detection
> 77cf32d0dbfb x86/srso: Add a forgotten NOENDBR annotation
> c7f2cd045542 x86/srso: Fix return thunks in generated code
> c9ae63d773ca x86/srso: Add IBPB on VMEXIT
> 79c8091888ef x86/srso: Add IBPB
> 98f62883e751 x86/srso: Add SRSO_NO support
> 9139f4b6dd4f x86/srso: Add IBPB_BRTYPE support
> ac41e90d8daa x86/srso: Add a Speculative RAS Overflow mitigation

Sean's https://lore.kernel.org/all/20230811155255.250835-1-seanjc@google.com/
(alteady in 'tip') can actually be related and I see it was already
tagged for stable@. Can anyone check if it really helps?

> dec3b91f2c4b x86/cpu, kvm: Add support for CPUID_80000021_EAX
>
> it would still be great to try to bisect to the particular patch causing
> the issue.

-- 
Vitaly

