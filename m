Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08A2569F09
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 12:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiGGKBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 06:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiGGKBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 06:01:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71BA94D4F1
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 03:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657188108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9SHQnAznbKnOLY1gPlD68a+aIhyQn9db0oXlbPnBHao=;
        b=WINJp48zrjyo753x0yDtcByq7BODpTl26B9R+JbFIyospqqlldJnd/cdUIzJE5LcJqcwrB
        +vRQOn/H2wvVJSgyOjMy7fzvYB32A7iJvI1XWVd229v6Ubl9lSj8rs6cBlOMNAnffXTQ5j
        OBASdwXQOGKDFzRKXzYB622vpbwFnDs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-pQzjlPV3Ohe9BI9XtZ3Ptw-1; Thu, 07 Jul 2022 06:01:47 -0400
X-MC-Unique: pQzjlPV3Ohe9BI9XtZ3Ptw-1
Received: by mail-ed1-f72.google.com with SMTP id m10-20020a056402510a00b0043a93d807ffso1661685edd.12
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 03:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9SHQnAznbKnOLY1gPlD68a+aIhyQn9db0oXlbPnBHao=;
        b=bz4GcWmJFXFcD49m90WPQo5HRNS4mdhi53I9pW1THD/Vn4NURVM8rlCOGpckCIPVWk
         rRRKEymCQJYwQug9zJYhpMrDRzPepib9EqpzXYhMRwnEa/aTEH5L5fCdcVE9JJPYmRD2
         W4qRzSgg49ZmcYfUa730X1IX+00ubcuUsPYPQ2nzSSkmd2zdseDN3kucq+qDX6tacwTF
         JxHr2IR5C5Mi4e7KlYbJn+HWr65aOPOHmRhJHAb6FO0a7eKkf0lKhf9RfO1xfR7diMm0
         Zx8HXPaSO1GliGMq+9HjKMcU+CbmYKiacbFJjbcc7+G6NSHIRZ9hMSc6jx9vE6fcnz/B
         HJXw==
X-Gm-Message-State: AJIora9awR/0JdLjEkFGOq6+E+nfdMoLC6d21Pgroaj3fBqqVUcnNINP
        lYAvtm5GwoxDpeJPBnY8jxnioXNmF7qjvIv/vV2igyZrfB7iEEkwA5kJSTXoCQMUb1NQ28qHbzd
        FGswh298HiDfo
X-Received: by 2002:a05:6402:2708:b0:435:da6f:3272 with SMTP id y8-20020a056402270800b00435da6f3272mr59104343edd.160.1657188106260;
        Thu, 07 Jul 2022 03:01:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sa9itQk8MCQrfGJDkX4tSlr0nI31PyKDn+oNYxgsM/K4ovlzMK3VkwUF9dZvJf9KNmR/8YVg==
X-Received: by 2002:a05:6402:2708:b0:435:da6f:3272 with SMTP id y8-20020a056402270800b00435da6f3272mr59104311edd.160.1657188106004;
        Thu, 07 Jul 2022 03:01:46 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o13-20020a170906768d00b0072af6d20a9asm2372836ejm.75.2022.07.07.03.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 03:01:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/28] KVM: VMX: Support TSC scaling with enlightened
 VMCS
In-Reply-To: <20220629150625.238286-9-vkuznets@redhat.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-9-vkuznets@redhat.com>
Date:   Thu, 07 Jul 2022 12:01:44 +0200
Message-ID: <87let5qm0n.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

...

>
> While on it, update the comment why VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL/
> VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL are kept filtered out

...

> + *	While GUEST_IA32_PERF_GLOBAL_CTRL and HOST_IA32_PERF_GLOBAL_CTRL
> + *	are present in eVMCSv1, Windows 11 still has issues booting when
> + *	VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL/VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL
> + *	are exposed to it, keep them filtered out.

Finally, I got a piece of information from Microsoft on what's going on
and it solves a lot of our problems. They did introduce a new PV feature
bit indicating support for these new fields in eVMCSv1 and Win11 checks
for its presence. This means that we do not need to play the 'eVMCS
revisions' trick as CPUID information from VMM is enough.

-- 
Vitaly

