Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C5A7694AC
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 13:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjGaLVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 07:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjGaLVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 07:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC255172A
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 04:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690802425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5vaUW0ZFNoavCkOsFWH4xJQw7j0BCOKV0sVk8cbQiFE=;
        b=CYKx1O7Sa+KAxkzJjncUFmvRSPSy8t221jyjykmWBOyVZyPBUDH3JzUsb9H3puHWlSdKXs
        W1v27oirBDFN/UTLpdUSU90zn/0+HvXEX+wXjNTEEzSVofT3j1rL5mLLAw1JJMdCjgnOAt
        tjAa/cwgHhRjsPvOFI6QvBLJnde2TsQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-FyAOxNCTNkO0-kbAgmf3VA-1; Mon, 31 Jul 2023 07:20:24 -0400
X-MC-Unique: FyAOxNCTNkO0-kbAgmf3VA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-63cf5bb17c6so56979566d6.0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 04:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690802424; x=1691407224;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5vaUW0ZFNoavCkOsFWH4xJQw7j0BCOKV0sVk8cbQiFE=;
        b=BR+76iJyixmQeULPu7nR5rQd50raiytLIUe0SixlYBulMjVTWUtsH+Mc7KVV6vyvBA
         VJ0Y+owc4VOpLySDRquAFf+kwDir7IdRMgHWeTqKsdefJNgN1qRKr98DjR61suU+Lsew
         C0oJyaSW1jqzFCAzRnx3Tls2U4B5b7ZGZArjYKGubH4CZaFFTgE6GwRvytapnSbiTxsa
         I+uoMsb6pCbXccBzmYwhS225ltHiP6OmWE1GxjHESqtZhnBhCNRxaYIFMbUZR5w4KPuY
         MYR9QUm3mrP/RGdm5WH6MrvyxfD6ts+wPKpqwQNNSW+7UcpYe/lfi20tvjd4sahAPnbU
         747g==
X-Gm-Message-State: ABy/qLY1zQpGHj9njEC6QVoE+dmWQNKaU6DUVVvT+NM7mrGYMsm3NzVD
        LmET32SaQcaoP5D12x71bkzP58cZSw1ydxWH9pzk1HBLYWzSvI2V7kuQ/TqsT/vwFdAHnizw2Ed
        mzqO7bpK3d/pn
X-Received: by 2002:a05:620a:3199:b0:765:a678:977c with SMTP id bi25-20020a05620a319900b00765a678977cmr11440901qkb.67.1690802424230;
        Mon, 31 Jul 2023 04:20:24 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF4PsqV0GfIB6WcE+e1KZA+Ob00KHOmMkV0SPV2mk8Z9iXGAjuozcLuEeBrBpyr3ypNADcfxg==
X-Received: by 2002:a05:620a:3199:b0:765:a678:977c with SMTP id bi25-20020a05620a319900b00765a678977cmr11440851qkb.67.1690802423943;
        Mon, 31 Jul 2023 04:20:23 -0700 (PDT)
Received: from vschneid.remote.csb ([149.12.7.81])
        by smtp.gmail.com with ESMTPSA id c23-20020a05620a11b700b00767303dc070sm3206663qkk.8.2023.07.31.04.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 04:20:23 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org, rcu@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
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
Subject: Re: [RFC PATCH v2 05/20] tracing/filters: Optimise cpumask vs
 cpumask filtering when user mask is a single CPU
In-Reply-To: <20230729153436.1e07bfa6@rorschach.local.home>
References: <20230720163056.2564824-1-vschneid@redhat.com>
 <20230720163056.2564824-6-vschneid@redhat.com>
 <20230729153436.1e07bfa6@rorschach.local.home>
Date:   Mon, 31 Jul 2023 12:20:13 +0100
Message-ID: <xhsmh3514s4ya.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/23 15:34, Steven Rostedt wrote:
> On Thu, 20 Jul 2023 17:30:41 +0100
> Valentin Schneider <vschneid@redhat.com> wrote:
>
>>              /* Move along */
>>              i++;
>> +
>> +		/*
>> +		 * Optimisation: if the user-provided mask has a weight of one
>> +		 * then we can treat it as a scalar input.
>> +		 */
>> +		single = cpumask_weight(pred->mask) == 1;
>> +		if (single && field->filter_type == FILTER_CPUMASK) {
>> +			pred->val = cpumask_first(pred->mask);
>> +			kfree(pred->mask);
>
> Don't we need:
>                       pred->mask = NULL;
>
> here, or the free_predicate() will cause a double free?
>

We do, thanks for spotting this.

> -- Steve
>
>> +		}
>> +

