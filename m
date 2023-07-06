Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED6C749AA0
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 13:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjGFLbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 07:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjGFLbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 07:31:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FF6199F
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 04:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688643018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IUyIouoC8ahxmdxehnDEnuXDxYXuSzzBD+vRAySsvH8=;
        b=JppxA5gkv0z2zSIqNak0EcK/+02w/7t3NqeBBD4PaFhbFHZVleG6qiY+PlGOOO0jD8NtY0
        VyFH20fYF7RggygsLhZ4FS8nGgQHvvZbQigZbyGNZxW2BtYLn5VOqcgnYGlkppFuxcn1VD
        aOGOEB1hOa0/nHPrFxso/QgRscFZ9C4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-RXxfQG8AMyu1K1savWEaAA-1; Thu, 06 Jul 2023 07:30:17 -0400
X-MC-Unique: RXxfQG8AMyu1K1savWEaAA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-635a3b9d24eso6621526d6.0
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 04:30:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688643017; x=1691235017;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IUyIouoC8ahxmdxehnDEnuXDxYXuSzzBD+vRAySsvH8=;
        b=X+ulsVhDHJWN/L1ckTzxFicRfJsUlT9DnD10JBWZDqcBV5N3RXBsWAsV1Fz0hc14Rc
         n2mufletCdOHVNCH4s5/YRmiSLLEa34nt/39kDQ2smfQVw9dTdzF2D9HjDdsweSnkEAC
         wbGl7SGeyCSggx0UH4Q0r2XcwUiA56JJCIlULwYiu/DHEKgmoaL3q+RVgq4OKvlHNQ8K
         UDzMnPmcioBXULSGybngeN9NnipfVPAbjFik5B5UBKntsv7hhp9Ei89zvFYwXdTy+i2u
         IP/u1lABRIsIC++almb6dyLHfX1qg2awSefIPna+fkby/bNvmYk6oevLY51l4k5GxmQa
         IHgA==
X-Gm-Message-State: ABy/qLY0q94LPk8X+AJkO7jEoQyGFx+kQsUYVmG+xTbW8FsYU167aUgQ
        3mhkHm5hx8RNw/UwgqHXxJAoJOF7gj7dKC4h7edBjCmHCM5oorRF3Qtb8PrjAM5LRVy/2IjtTDJ
        ysiUeJNsDrX3V
X-Received: by 2002:a0c:db08:0:b0:625:aa49:19f1 with SMTP id d8-20020a0cdb08000000b00625aa4919f1mr1114229qvk.62.1688643017310;
        Thu, 06 Jul 2023 04:30:17 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGGMC/kBtgH7sbrX8rD2ZgNOVsGU4yA48iFb2GJxy2p3hgBQJP/oIfvimw2fu1jmJDlCZa08A==
X-Received: by 2002:a0c:db08:0:b0:625:aa49:19f1 with SMTP id d8-20020a0cdb08000000b00625aa4919f1mr1114196qvk.62.1688643017072;
        Thu, 06 Jul 2023 04:30:17 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id y12-20020a0c8ecc000000b006360778f314sm751558qvb.105.2023.07.06.04.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 04:30:16 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        Dan Carpenter <error27@gmail.com>,
        Chuang Wang <nashuiliang@gmail.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: Re: [RFC PATCH 00/14] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
In-Reply-To: <20230705150328.16791f25@gandalf.local.home>
References: <20230705181256.3539027-1-vschneid@redhat.com>
 <20230705150328.16791f25@gandalf.local.home>
Date:   Thu, 06 Jul 2023 12:30:10 +0100
Message-ID: <xhsmhv8exuvjx.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/23 15:03, Steven Rostedt wrote:
> On Wed,  5 Jul 2023 19:12:42 +0100
> Valentin Schneider <vschneid@redhat.com> wrote:
>
>> o Patches 1-5 have been submitted previously and are included for the sake of
>>   testing
>
> I should have commented on the previous set, but I did my review on this set ;-)
>

Thanks for having a look!

> Anyway, I'm all for the patches. Care to send a new version covering my input?
>

Sure thing, I'll send a v2 of these patches soonish.

> Thanks,
>
> -- Steve

