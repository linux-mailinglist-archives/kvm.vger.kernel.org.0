Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE25586ED6
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 18:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiHAQly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 12:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiHAQlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 12:41:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E303818B29
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 09:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659372109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DhoXo/Y209peqbHa3vvcONnGjAEeyiXsA/tKUz+QGDY=;
        b=CqJjeL4rqTdq/MFBzz0JtKd9oFcn8gY2sk+ANGVF4lSV6jRvL/h08IDTSAgE5nAwDpUtWi
        DwELzI32LbiF7+cBlmrX2T98aYqOtQSWmd8qTuVMk180JOr30bbiEOZgFXR7+lFxM1pfHd
        FiolMH1qCvuGQ/bMVyVu6tAx2kIVb7Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-P3FGFkgGO8au2CMneF6HXQ-1; Mon, 01 Aug 2022 12:41:32 -0400
X-MC-Unique: P3FGFkgGO8au2CMneF6HXQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 309443C0E20F;
        Mon,  1 Aug 2022 16:41:31 +0000 (UTC)
Received: from starship (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0951D492C3B;
        Mon,  1 Aug 2022 16:41:24 +0000 (UTC)
Message-ID: <acb29da31cf7a805d8e6e8419151c27f6b135c58.camel@redhat.com>
Subject: Re: [PATCH v2 0/5] x86: cpuid: improve support for broken CPUID
 configurations
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
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
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Date:   Mon, 01 Aug 2022 19:41:23 +0300
In-Reply-To: <85aa20bb-09ca-d1a6-8671-947370765a02@intel.com>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
         <fad05f161cc6425d8c36fb6322de2bbaa683dcb3.camel@redhat.com>
         <4a327f06f6e5da6f3badb5ccf80d22a5c9e18b97.camel@redhat.com>
         <85aa20bb-09ca-d1a6-8671-947370765a02@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-08-01 at 09:31 -0700, Dave Hansen wrote:
> On 8/1/22 09:05, Maxim Levitsky wrote:
> > > A very kind ping on these patches.
> > Another kind ping on these patches.
> 
> Maxim,
> 
> This series is not forgotten.  Its latest version was simply posted too
> close to the merge window.  It'll get looked at in a week or two when
> things calm down.
> 
> Please be patient.
> 

Thanks!

Best regards,
	Maxim Levitsky

