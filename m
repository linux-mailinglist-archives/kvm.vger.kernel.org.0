Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6A5605C36
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 12:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJTKYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 06:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiJTKXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 06:23:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D20929345
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 03:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666261303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IP4XVtyT8sCR5WHZQvsMW5lgFqpDy1UbjPyj0MmEvlQ=;
        b=O1WgzPOO0lJU7S9ieSIVPF8MrzdcMTh5US+Lv0MmqwBAwdbc/JlneiGPnQExELzUAqhF2d
        kL7S9PF0ajRO6suFtQBb860mIZ1onnWsxiqaOXFxlbwl+ySa70rcuFgtgfIgbn1fIWd9Xg
        4JIA38h5HJn5DeeafkcZDRFaBewPGQc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-1xAhMVMYMIGJYmgBfYmMCw-1; Thu, 20 Oct 2022 06:21:40 -0400
X-MC-Unique: 1xAhMVMYMIGJYmgBfYmMCw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE19B185A7AC;
        Thu, 20 Oct 2022 10:21:38 +0000 (UTC)
Received: from starship (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20D4E40C6E16;
        Thu, 20 Oct 2022 10:21:31 +0000 (UTC)
Message-ID: <3cc09554f20231aecdf0cd762a282c42aee9273c.camel@redhat.com>
Subject: Re: [PATCH v2 1/5] perf/x86/intel/lbr: use setup_clear_cpu_cap
 instead of clear_cpu_cap
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Date:   Thu, 20 Oct 2022 13:21:30 +0300
In-Reply-To: <Y1EPRauBmAXMVrCa@loth.rohan.me.apana.org.au>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
         <20220718141123.136106-2-mlevitsk@redhat.com> <Yyh9RDbaRqUR1XSW@zn.tnic>
         <c105971a72dfe6d46ad75fb7e71f79ba716e081c.camel@redhat.com>
         <YzGlQBkCSJxY+8Jf@zn.tnic>
         <c1168e8bd9077a2cc9ef61ee06db7a4e8c0f1600.camel@redhat.com>
         <Y1EOBAaLbv2CXBDL@zn.tnic> <Y1EPRauBmAXMVrCa@loth.rohan.me.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 17:05 +0800, Herbert Xu wrote:
> On Thu, Oct 20, 2022 at 10:59:48AM +0200, Borislav Petkov wrote:
> > I really really don't like it when people are fixing the wrong thing.
> > 
> > Why does the kernel need to get fixed when something else can't get its
> > CPUID dependencies straight? I don't even want to know why something
> > would set AVX2 without AVX?!?!
> 
> That's exactly what I said when this was first reported to me as
> a crypto bug :)

I agree with you, however this patch series is just refactoring/hardening of the kernel -
if the kernel can avoid crashing - why not.

Of course the hypervisor should not present such broken configurations to the guest - 
in fact the guest kernel can't fix this - guest userspace will still see wrong CPUID and
can still crash.

TL;DR - this patch series is not intended to workaround a broken hypervisor and such,
it is just a hardening against misconfiguration.

Best regards,
	Maxim Levitsky


> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 


