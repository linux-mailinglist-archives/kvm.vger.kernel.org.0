Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FD86A1D92
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 15:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjBXOjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 09:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjBXOj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 09:39:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D74671C5
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 06:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677249526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F2Gy4jFQ+zLSzSW8KrNNW+axZfls8gC7MpzkteIHstE=;
        b=ISiHdA/+l8nnb2ZNj/qbuR0m+fCexDGXjFC/hlXP8e/P0QDHra4QkuoNkLDkH7aVxSy1cD
        k47M+kr6gS6M2Ij8OdZQJQs1H0vAAdPgJF4P/wfGNL+pBESmaY1UTobT80zwbwHISWOBsR
        8F0AbadFQEejK7N+670UfCwTKQS7hok=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-119-S7JFb-UFOuCJAdJFO213qA-1; Fri, 24 Feb 2023 09:38:45 -0500
X-MC-Unique: S7JFb-UFOuCJAdJFO213qA-1
Received: by mail-wm1-f69.google.com with SMTP id x18-20020a1c7c12000000b003e1e7d3cf9fso1305946wmc.3
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 06:38:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F2Gy4jFQ+zLSzSW8KrNNW+axZfls8gC7MpzkteIHstE=;
        b=qhXH1vrrVHRYnXjzcUpzC2o14JxZrZdjghdGlFqpeuifZruUjIrH1ldns3HqUwiS7/
         bTq9tu1zRcivbYaDN5kbqIWyGxRHEZOk0JT8gK5coyTA44jlB/CGQXOjSZi67MRTDfr/
         msjbcSxR8S0QqLCjyOepIzabTH4pVf/vqOZDHzjhpaV80j0wUvSfwvgfSbi+YPctIAZ6
         mfTcGCJYgI8wxypoH5OUYiqNsQZpRABprDri7mLOodi2LnAzcsciqfo3WI0TpKR/40X+
         hg+8hFQG9F4ZSf4trApQN5Y3aw2UNOP/KQckLziZ1ex47PMjb9sxs9+Edm7NJxcz/bK9
         XJPg==
X-Gm-Message-State: AO0yUKWns7t4IQUvERA7n+uIUyvfK05Zwj2pgfNQYLFEja45hxKbpcCY
        M1U0BfGmrzXFSqojFGnkqLhMhMQwEz/FTquSrjHCgv/e8b8IdebbHUWl/xrp1ZKgaXXnuYlIWDJ
        MBOVZ6C5lctz574vmNQ==
X-Received: by 2002:a1c:7709:0:b0:3ea:fc95:7bf with SMTP id t9-20020a1c7709000000b003eafc9507bfmr2549613wmi.30.1677249523663;
        Fri, 24 Feb 2023 06:38:43 -0800 (PST)
X-Google-Smtp-Source: AK7set9tLVciTVQHdrXjudS/wXkv9w4eH0viCfjQ59ETlgYApLfO7oWjZ7S1UtLnq/jiiyKjNB6iAg==
X-Received: by 2002:a1c:7709:0:b0:3ea:fc95:7bf with SMTP id t9-20020a1c7709000000b003eafc9507bfmr2549588wmi.30.1677249523503;
        Fri, 24 Feb 2023 06:38:43 -0800 (PST)
Received: from starship ([89.237.96.70])
        by smtp.gmail.com with ESMTPSA id ja20-20020a05600c557400b003dfefe115b9sm3062964wmb.0.2023.02.24.06.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 06:38:43 -0800 (PST)
Message-ID: <818358bee687c999d715a90f594eb02207c74e82.camel@redhat.com>
Subject: Re: [PATCH v2 05/11] KVM: x86: emulator: stop using raw host flags
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Fri, 24 Feb 2023 16:38:40 +0200
In-Reply-To: <Y9RzSJuGmIQf1kxA@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
         <20221129193717.513824-6-mlevitsk@redhat.com> <Y9RzSJuGmIQf1kxA@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-28 at 00:58 +0000, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f18f579ebde81c..85d2a12c214dda 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8138,9 +8138,14 @@ static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
> >  	static_call(kvm_x86_set_nmi_mask)(emul_to_vcpu(ctxt), masked);
> >  }
> >  
> > -static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
> > +static bool emulator_in_smm(struct x86_emulate_ctxt *ctxt)
> >  {
> > -	return emul_to_vcpu(ctxt)->arch.hflags;
> > +	return emul_to_vcpu(ctxt)->arch.hflags & HF_SMM_MASK;
> 
> This needs to be is_smm() as HF_SMM_MASK is undefined if CONFIG_KVM_SMM=n.
> 
> > +}
> > +
> > +static bool emulator_in_guest_mode(struct x86_emulate_ctxt *ctxt)
> > +{
> > +	return emul_to_vcpu(ctxt)->arch.hflags & HF_GUEST_MASK;
> 
> And just use is_guest_mode() here.
> 

Makes sense.

