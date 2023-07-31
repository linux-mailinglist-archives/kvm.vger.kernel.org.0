Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843807694A2
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 13:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjGaLVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 07:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbjGaLU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 07:20:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784BD10EB
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 04:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690802403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V5VMLpHOhxXlUy0bWDF9kXZ97zc/VghMcLBrU5Ym92c=;
        b=KNr1ZOZt8BHe9a9IfvWLmd6idJQ1b5fadL7pqUG5MP2af2rlu5ZkO/Efin4UqQiG+czwot
        TfWvrchXUOMxxLvAdWRGI3ar3Qch6z1eu3ILZ/x2sQmkBQ/wiYZsUW49zFYQCS1cnh2gW6
        p07/AuHmHRN8lC2ysCU1WQMuC8PwWBo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-7W_wPVKmOp6-nQ-PncElsw-1; Mon, 31 Jul 2023 07:20:02 -0400
X-MC-Unique: 7W_wPVKmOp6-nQ-PncElsw-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-40a15015b43so31529641cf.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 04:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690802402; x=1691407202;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V5VMLpHOhxXlUy0bWDF9kXZ97zc/VghMcLBrU5Ym92c=;
        b=A4QK2Ia6CfAEiUs4pSUBVgD7iA97mIemSzFNWAydxWfgqx9MIyeDNk58Wi6GAMc+dV
         upjVtDPEE0uUQUhOucQ+PnJ7cJJ7kFTnOucZqfFNhI5acAY3Xdui4TSq7YNVBdUux//D
         wu9u872b7pfx+wcGIni5pB/05sazJFp6a6Ttkc5yUaxGS2/n3Mc2gafVvKmNjpR5VDR8
         RoE2hGkL14eiflLNZnml1XGFJBm26Ig4lleEpHKhshWLqqormWAUv9wX9njtyUw7o5bI
         hm0LYu2MmI5MX2pYtaiuSNg0Cac3XLJdAxOPb2NITA7C9830FSk80/1qvAps3d0C+qU3
         A5Gw==
X-Gm-Message-State: ABy/qLYj1moyXcEVjB0Vsh3UEbtWG9NoZM5PfkiQxDkzpIMLWsGAoiA5
        7y8qkXmLPxbWLog+zO2KUJq1hzkIwHr6hzx9wkEz6DQEoHbn1bqG2PvCq7vOSAxxXFzcU0qfk4c
        qTMexW6+r7WfB
X-Received: by 2002:ac8:7f08:0:b0:409:f273:e28d with SMTP id f8-20020ac87f08000000b00409f273e28dmr8487923qtk.62.1690802401979;
        Mon, 31 Jul 2023 04:20:01 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEVg6/rKm0s9MUEi0BGjFI/ks14KzdgpHID8GGIpvi7qxLN20fQB6V4fe5ZTG4d6GXjiIiI+g==
X-Received: by 2002:ac8:7f08:0:b0:409:f273:e28d with SMTP id f8-20020ac87f08000000b00409f273e28dmr8487873qtk.62.1690802401624;
        Mon, 31 Jul 2023 04:20:01 -0700 (PDT)
Received: from vschneid.remote.csb ([149.12.7.81])
        by smtp.gmail.com with ESMTPSA id x7-20020ac80187000000b00403f5873f5esm3447309qtf.24.2023.07.31.04.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 04:20:01 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>
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
Subject: Re: [RFC PATCH v2 02/20] tracing/filters: Enable filtering a
 cpumask field by another cpumask
In-Reply-To: <20230729150901.25b9ae0c@rorschach.local.home>
References: <20230720163056.2564824-1-vschneid@redhat.com>
 <20230720163056.2564824-3-vschneid@redhat.com>
 <20230726194148.4jhyqqbtn3qqqqsq@treble>
 <20230729150901.25b9ae0c@rorschach.local.home>
Date:   Mon, 31 Jul 2023 12:19:51 +0100
Message-ID: <xhsmh4jlks4yw.mognet@vschneid.remote.csb>
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

On 29/07/23 15:09, Steven Rostedt wrote:
> On Wed, 26 Jul 2023 12:41:48 -0700
> Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
>> On Thu, Jul 20, 2023 at 05:30:38PM +0100, Valentin Schneider wrote:
>> >  int filter_assign_type(const char *type)
>> >  {
>> > -	if (strstr(type, "__data_loc") && strstr(type, "char"))
>> > -		return FILTER_DYN_STRING;
>> > +	if (strstr(type, "__data_loc")) {
>> > +		if (strstr(type, "char"))
>> > +			return FILTER_DYN_STRING;
>> > +		if (strstr(type, "cpumask_t"))
>> > +			return FILTER_CPUMASK;
>> > +		}
>>
>> The closing bracket has the wrong indentation.
>>
>> > +		/* Copy the cpulist between { and } */
>> > +		tmp = kmalloc((i - maskstart) + 1, GFP_KERNEL);
>> > +		strscpy(tmp, str + maskstart, (i - maskstart) + 1);
>>
>> Need to check kmalloc() failure?  And also free tmp?
>
> I came to state the same thing.
>
> Also, when you do an empty for loop:
>
>       for (; str[i] && str[i] != '}'; i++);
>
> Always put the semicolon on the next line, otherwise it is really easy
> to think that the next line is part of the for loop. That is, instead
> of the above, do:
>
>       for (; str[i] && str[i] != '}'; i++)
>               ;
>

Interestingly I don't think I've ever encountered that variant, usually
having an empty line (which this lacks) and the indentation level is enough
to identify these - regardless, I'll change it.

>
> -- Steve
>
>
>>
>> > +
>> > +		pred->mask = kzalloc(cpumask_size(), GFP_KERNEL);
>> > +		if (!pred->mask)
>> > +			goto err_mem;
>> > +
>> > +		/* Now parse it */
>> > +		if (cpulist_parse(tmp, pred->mask)) {
>> > +			parse_error(pe, FILT_ERR_INVALID_CPULIST, pos + i);
>> > +			goto err_free;
>> > +		}
>> > +
>> > +		/* Move along */
>> > +		i++;
>> > +		if (field->filter_type == FILTER_CPUMASK)
>> > +			pred->fn_num = FILTER_PRED_FN_CPUMASK;
>> > +
>>

