Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8AA75C13C
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 10:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbjGUISx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 04:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjGUISu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 04:18:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3C5AA
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 01:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689927482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wWAtfDt+4FFr8z2L0240XKTF6ityOHMPZsX6cXcmsiA=;
        b=C756oBKR2e53s64qZeV+zKpr1xZ7ILv/jNAx5LeduQAIpBfUfHzHE46TIPgufaQWIvzPcw
        4TFB9XM8V4/OQxapVtVUmd9qTO2eBrlJBqEe0YdwhKZzu5MI6UeDBy/nDnDKv1hgHd2Vqg
        xFQis29kWvQFIz1edO6IcrWNiy0c8HY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-pHkgqcdHOzydZuFLvizZwg-1; Fri, 21 Jul 2023 04:17:57 -0400
X-MC-Unique: pHkgqcdHOzydZuFLvizZwg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fb40ec952bso8809805e9.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 01:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689927476; x=1690532276;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wWAtfDt+4FFr8z2L0240XKTF6ityOHMPZsX6cXcmsiA=;
        b=dJxA81b+ToGs6DIXvGq6SIWkaLyZ2sRyP0AWI69J03705Nsz73xe3PCsP0xW/25LKp
         x7xc1NmZrC+JM7fbID2Mqn4eKsI9SnZa2K1ZtfUj2SzpX1ai1CsnZ4ZBMFnDLM0ErZv2
         8aXCDooW3DOIml4j1XaS2HRbxSHMU6M+t32AKBQjEGIhvqNZSOSs9GOhWb2Z3AvubTnE
         kOUUkELz3K0xSvBymYHdka02HaOs2AAYHQNT6N3Bm//0tupRYYNBJdd08k4fRr2Jkv3E
         pV80T6v7Csk7xG1nkjWV5CYdqZLy0apaNgHTxIo/aoakmL/7KTigLA27oE9rQxBmQf9h
         Hvzw==
X-Gm-Message-State: ABy/qLaFtushXwW3XC9QcuYVH952orRp6NP2jZncmL1n1befnmz3DDR1
        xDi7BKkeDzKI08w9s3xqbl0v+pxxrJ/R0OgODHSUnt723KXBYdRPiO+yDzLzeYmRb3MwrG/xGbe
        DBZ1aL6bXY1e9
X-Received: by 2002:adf:e44b:0:b0:314:23b:dc56 with SMTP id t11-20020adfe44b000000b00314023bdc56mr932477wrm.71.1689927476496;
        Fri, 21 Jul 2023 01:17:56 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHEdRURX7Fjh/lMcHTt/3ezRGKcsgd4gH+GjQ+oOshjaOTIibUtlYcUjT+ZyXHohXPiIFUBeg==
X-Received: by 2002:adf:e44b:0:b0:314:23b:dc56 with SMTP id t11-20020adfe44b000000b00314023bdc56mr932410wrm.71.1689927476191;
        Fri, 21 Jul 2023 01:17:56 -0700 (PDT)
Received: from vschneid.remote.csb ([149.12.7.81])
        by smtp.gmail.com with ESMTPSA id j6-20020a5d6046000000b003143b14848dsm3444226wrt.102.2023.07.21.01.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 01:17:55 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org, rcu@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Zqiang <qiang.zhang1211@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
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
Subject: Re: [RFC PATCH v2 16/20] rcu: Make RCU dynticks counter size
 configurable
In-Reply-To: <20230720163056.2564824-17-vschneid@redhat.com>
References: <20230720163056.2564824-1-vschneid@redhat.com>
 <20230720163056.2564824-17-vschneid@redhat.com>
Date:   Fri, 21 Jul 2023 09:17:53 +0100
Message-ID: <xhsmhjzutu18u.mognet@vschneid.remote.csb>
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

On 20/07/23 17:30, Valentin Schneider wrote:
> index bdd7eadb33d8f..1ff2aab24e964 100644
> --- a/kernel/rcu/Kconfig
> +++ b/kernel/rcu/Kconfig
> @@ -332,4 +332,37 @@ config RCU_DOUBLE_CHECK_CB_TIME
>         Say Y here if you need tighter callback-limit enforcement.
>         Say N here if you are unsure.
>
> +config RCU_DYNTICKS_RANGE_BEGIN
> +	int
> +	depends on !RCU_EXPERT
> +	default 31 if !CONTEXT_TRACKING_WORK

You'll note that this should be 30 really, because the lower *2* bits are
taken by the context state (CONTEXT_GUEST has a value of 3).

This highlights the fragile part of this: the Kconfig values are hardcoded,
but they depend on CT_STATE_SIZE, CONTEXT_MASK and CONTEXT_WORK_MAX. The
static_assert() will at least capture any misconfiguration, but having that
enforced by the actual Kconfig ranges would be less awkward.

Do we currently have a way of e.g. making a Kconfig file depend on and use
values generated by a C header?

