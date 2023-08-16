Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7808D77E1A2
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 14:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245193AbjHPM3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 08:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245363AbjHPM3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 08:29:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7A02733
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 05:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692188851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ijKYo6YIrYvwnBAnXfDfO1VnMtwxZii0rV5a4PpvoTc=;
        b=Eq16wliQdyG7OHPMgWpurXX+xGIlVkxnmFUud/sffHVyhVwG1KkaeCxtBoH6STP4lAZTcb
        4z5OhnYtw/II9qtq5nnjjXLJ8M7+ltv+m71KsTcuzwnyI7pc7CEraCUe1TWE49Jj1H3T3P
        QUZexSsE5BzoLU0tAPvPAMDMPKaG9Tw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-RDLMCw-hOE281KF0SVF-oA-1; Wed, 16 Aug 2023 08:27:30 -0400
X-MC-Unique: RDLMCw-hOE281KF0SVF-oA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-993eeb3a950so369203666b.2
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 05:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692188849; x=1692793649;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ijKYo6YIrYvwnBAnXfDfO1VnMtwxZii0rV5a4PpvoTc=;
        b=P/y67Kkk1T9hbULYsYn2vO1Z4DFO0UcMcYJPWCvVc2KpkD8BkxdM9BHjCUFaG0EYTC
         VJ41naHMaw3ISF1fg7afr51MmjcaMKGLDdKJB88/qCyhDyJtmTRNV17Zo5DvHminuvZ8
         q/cBlIDUfXplmh9yEkX6yKwRxxGKVpFtKmon0fXs61YPSMb8ZIuYZcnqUjhlbPWXMBRI
         NNRBFvwG8iD0q+QbskfVYhCMHg12Q2/ph7Jr97lDbBi0zdBX9YvpQt+wAGz/xt6e7UUX
         Q/VqgxqQYSiSIpS0WS44BpVnJtqTt52NGyBeoLmjwC308GjIsrPU68/1sOhxjhu7GAYN
         e1ug==
X-Gm-Message-State: AOJu0YyZdeSVWCFx/8Dg02SN+SaqGNFswNbfAuB51Ei/zct1Jp1s4Zxx
        0pTjgLhlQiLkRIBvvSQZM0grISe02P95P37GnSz7/QxqoKv03AQi30eeXhsltRlFb5hnbCXEffe
        +whyGuuvukKxt
X-Received: by 2002:a05:6402:31f7:b0:523:406a:5f6 with SMTP id dy23-20020a05640231f700b00523406a05f6mr1443604edb.12.1692188849185;
        Wed, 16 Aug 2023 05:27:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHU/74XE/K5Jc7jA6BEqLvhuW4kSG78ZzyQI/ebU7QqsSkoPCOzbXSL5nsV7AciG7WH7ck9vQ==
X-Received: by 2002:a05:6402:31f7:b0:523:406a:5f6 with SMTP id dy23-20020a05640231f700b00523406a05f6mr1443587edb.12.1692188848862;
        Wed, 16 Aug 2023 05:27:28 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id o8-20020aa7c508000000b005255eec8797sm4365977edq.79.2023.08.16.05.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 05:27:27 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Roman Mamedov <rm+bko@romanrm.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Borislav Petkov (AMD) <bp@alien8.de>
Subject: Re: Fwd: kvm: Windows Server 2003 VM fails to work on 6.1.44 (works
 fine on 6.1.43)
In-Reply-To: <8cc000d5-9445-d6f1-f02e-4629a4a59e0e@gmail.com>
References: <8cc000d5-9445-d6f1-f02e-4629a4a59e0e@gmail.com>
Date:   Wed, 16 Aug 2023 14:27:27 +0200
Message-ID: <87o7j75g0g.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bagas Sanjaya <bagasdotme@gmail.com> writes:

> Hi,
>
> I notice a regression report on Bugzilla [1]. Quoting from it:
>
>> Hello,
>> 
>> I have a virtual machine running the old Windows Server 2003. On kernels 6.1.44 and 6.1.45, the QEMU VNC window stays dark, not switching to any of the guest's video modes and the VM process uses only ~64 MB of RAM of the assigned 2 GB, indefinitely. It's like the VM is paused/halted/stuck before even starting. The process can be killed successfully and then restarted again (with the same result), so it is not deadlocked in kernel or the like.
>> 
>> Kernel 6.1.43 works fine.
>> 
>> I have also tried downgrading CPU microcode from 20230808 to 20230719, but that did not help.
>> 
>> The CPU is AMD Ryzen 5900. I suspect some of the newly added mitigations may be the culprit?
>
> See Bugzilla for the full thread.
>
> Anyway, I'm adding it to regzbot as stable-specific regression:
>
> #regzbot introduced: v6.1.43..v6.1.44 https://bugzilla.kernel.org/show_bug.cgi?id=217799
> #regzbot title: Windows Server 2003 VM boot hang (only 64MB RAM allocated)
>
> Thanks.
>
> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=217799

From KVM's PoV, I don't see any KVM/x86 patches v6.1.44..v6.1.45 and in fact
there are only two x86 patches:

f2615bb47be4 x86/CPU/AMD: Do not leak quotient data after a division by 0
98cccbd0a19a x86/hyperv: Disable IBT when hypercall page lacks ENDBR instruction

and I'm pretty certain the later is unrelated; f2615bb47be4 looks like
it can, in theory, be related. Cc: Borislav.

-- 
Vitaly

