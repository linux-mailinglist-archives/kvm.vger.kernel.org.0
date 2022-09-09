Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA6F5B32BF
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 11:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiIIJEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 05:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiIIJDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 05:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18351365FA
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 02:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662714175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zHlfqI7LQSp6dc3XrEoWZiHy1ZdcT/Lw/HJNhlYjtFw=;
        b=W4naSNVzewbEamHj5fMlaqRl+0p2Noeaqa1j1YCLMqdaMjF6+PGMk9sb2GJRyUPb909aoq
        2cZ7xvWp3fS1W8buGu3bgIn0qEF7WuJ7xjmB94JzHRKM34+xaKM2y0mrQfHPJKYuHIq28W
        Yac+9kFMlyzbHjJOhUQwi0MIPEx+WDQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-296-XgoGh9zeMpuSMruSdWuV6A-1; Fri, 09 Sep 2022 05:02:52 -0400
X-MC-Unique: XgoGh9zeMpuSMruSdWuV6A-1
Received: by mail-wm1-f70.google.com with SMTP id o25-20020a05600c339900b003b2973dab88so553666wmp.6
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 02:02:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=zHlfqI7LQSp6dc3XrEoWZiHy1ZdcT/Lw/HJNhlYjtFw=;
        b=ZrpLe6A1tFQ4N6JxXIwMceNuLW12jbz0SViT8XckG2GGgyNGCJdWziGb0r2D0vXkF6
         csctuzH0jmOEkycyiINC4PC8LD5donUSwNwliTFFmckluHFWfCWlcgnahLhckcZgrTer
         I7zCnuVZG3qCjvTm1fbi5KbLG4dt5yaLE8ohZJzvi9vROrnFgS+aQIbiBU0z2wW1tJhC
         2GPlF2ce/uW9kOY45gx5L0K0H61IrXxVz3KzOvkK9iHCtuOW6Hwdzo6QUy/aWD6np0uF
         TcdhaKeuipOmb0X3PoRdyWy/CthPaX3C/Cfn5C6ZoqGCQxlnKNyqcxrssIU7ZbiV6VdS
         zvMA==
X-Gm-Message-State: ACgBeo1PuxxwCVd5ZWSJ40EGn+uMzrZR60dMrr73B6SknGRUjYi0TQ5a
        87UNV7wVWyWwbGPgNpurxUL8Ot8GQA2wsib4nTeDHjy07BOrgrJDUIoiPNjIUCmLlD6wWvBuPxv
        KnsHyU1abuteM
X-Received: by 2002:a05:600c:1e8b:b0:3a6:1a09:2a89 with SMTP id be11-20020a05600c1e8b00b003a61a092a89mr4659855wmb.108.1662714171610;
        Fri, 09 Sep 2022 02:02:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6p9MuPIBZn8UKjqDTf9uyJYHHhrKQv3ZTZrBd8BwMOJwSJMGJhhalRpYBGvX1ife4LilKxRg==
X-Received: by 2002:a05:600c:1e8b:b0:3a6:1a09:2a89 with SMTP id be11-20020a05600c1e8b00b003a61a092a89mr4659836wmb.108.1662714171378;
        Fri, 09 Sep 2022 02:02:51 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bo21-20020a056000069500b00225239d9265sm1315860wrb.74.2022.09.09.02.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 02:02:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm/x86: reserve bit
 KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
In-Reply-To: <20220909050224.rzlt4x7tjrespw3k@sirius.home.kraxel.org>
References: <20220908114146.473630-1-kraxel@redhat.com>
 <YxoBtD+3sgEEiaFF@google.com>
 <20220909050224.rzlt4x7tjrespw3k@sirius.home.kraxel.org>
Date:   Fri, 09 Sep 2022 11:02:49 +0200
Message-ID: <87tu5grkcm.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gerd Hoffmann <kraxel@redhat.com> writes:

> On Thu, Sep 08, 2022 at 02:52:36PM +0000, Sean Christopherson wrote:
>> On Thu, Sep 08, 2022, Gerd Hoffmann wrote:

...

>> >  arch/x86/include/uapi/asm/kvm_para.h | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>> > index 6e64b27b2c1e..115bb34413cf 100644
>> > --- a/arch/x86/include/uapi/asm/kvm_para.h
>> > +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> > @@ -37,7 +37,8 @@
>> >  #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
>> >  #define KVM_FEATURE_MIGRATION_CONTROL	17
>> >  
>> > -#define KVM_HINTS_REALTIME      0
>> > +#define KVM_HINTS_REALTIME                      0
>> > +#define KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID  1
>> 
>> Why does KVM need to get involved?  This is purely a userspace problem.
>
> It doesn't.  I only need reserve a hints bit, and the canonical source
> for that happens to live in the kernel.  That's why this patch doesn't
> touch any actual code ;)
>
>> E.g. why not use QEMU's fw_cfg to communicate this information to the
>> guest?
>
> That is indeed the other obvious way to implement this.  Given this
> information will be needed in code paths which already do CPUID queries
> using CPUID to transport that information looked like the better option
> to me.

While this certainly looks like an overkill here, we could probably add
new, VMM-spefific CPUID leaves to KVM, e.g.

0x4000000A: VMM signature
0x4000000B: VMM features
0x4000000C: VMM quirks
...

this way VMMs (like QEMU) could identify themselves and suggest VMM
specific things to guests without KVM's involvement. Just if 'fw_cfg' is
not enough)

-- 
Vitaly

