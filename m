Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0115ED1B2
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 02:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiI1AUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 20:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiI1AUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 20:20:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7324EEF0BD
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 17:20:17 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d24so10480083pls.4
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 17:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=ARmfSwcZmRk3I/GSYlIDluOju+opXVVFSk8yWY88kxQ=;
        b=WKJkdzGlGnRB2S0cnnuctJ1YVt+EebjDmH4eiqhau4orPyd81qSzxZOwKO1AKneW0Z
         hJqJNsYFIcX8bGkz1JNeTs5PY+w21wMMPsLXMQhSBGU0VAkPXmZzTh6IOiXvN5pgvPuI
         bQl3aYLOrctepG3rb7K/bT3X94IYNjgZ2u8FcTr0b2LTwA5xKdrnxRnBuAgsc78BQrCl
         W8UiCkjXoUdv+AK1S5mgXNs/qddOehQfVydFv9/99wrLBny1z4w7hMeh/fWl4aePyLLs
         JacB6h8zf1bophxSuOhkc4yJiKbJIB6Rrylrmt/hvQAwr8GWyuX9qQfvpYLwmjF8ReTR
         zt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ARmfSwcZmRk3I/GSYlIDluOju+opXVVFSk8yWY88kxQ=;
        b=RNZQiBPOiL44aJKJhatc2sxgo2VxjlAN+XOVYZ0xWr2qRHhep7mghP0Zjnz9mRS9Wl
         5J48xJI4zVmMe29DUHn5RPufdD5z3sxMZtpEY7OorEwNiOIftA16kGnx8CXXvEOqBhhQ
         4uzlJoLL7AUnpjBtCQtp+WCCv2B5CSe91R1GxWxbHZ1NFbtbGXxhPR4wr1FDisb3lcLU
         etxIsk1XhbKGyX2NjOhng5G3ia0VCnBLN1JdE7JnyE5jfT3lSdKvvDZnrzF6nybkdJZM
         KAXV1ua+91C6fDd5DQpqH9Eo9WMRvBRdsuw1BRPLWJJb6K8p7J7CkbHUO7l0/MmywRYP
         WSkA==
X-Gm-Message-State: ACrzQf0lGyN+q7nRx4/nbjgqIgLe5VkllD79FuvIC7yxpcw7cuBkYvTh
        0774pWFMKuttZKrGbcqYaNdMAA==
X-Google-Smtp-Source: AMsMyM6+hUkcTMZMhO/CYJc7kwL5Vwloi16iKUQtk64rKVP+ZCg2PvZkZJiriavh1nfbiOj3ZY2pIg==
X-Received: by 2002:a17:90a:d18c:b0:205:e522:611e with SMTP id fu12-20020a17090ad18c00b00205e522611emr3136020pjb.20.1664324416362;
        Tue, 27 Sep 2022 17:20:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y35-20020a17090a53a600b001fde265ff4bsm130325pjh.4.2022.09.27.17.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 17:20:14 -0700 (PDT)
Date:   Wed, 28 Sep 2022 00:20:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Roth, Michael" <Michael.Roth@amd.com>
Subject: Re: [PATCH kernel] KVM: SVM: Fix function name in comment
Message-ID: <YzOTOzUzKPQSqURo@google.com>
References: <20220912075219.70379-1-aik@amd.com>
 <Yx79ugW49M3FT/Zp@google.com>
 <699404b6-dfa7-f286-8e66-6d9cadd10250@amd.com>
 <YyAlVrrSpqTxrRlM@google.com>
 <1b766883-23a9-72e6-b7ee-f7473bf6b096@amd.com>
 <13ff8157-7620-bf3e-202b-f087abb72233@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13ff8157-7620-bf3e-202b-f087abb72233@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Nikunj A. Dadhania wrote:
> On 20/09/22 14:18, Alexey Kardashevskiy wrote:
> > On 13/9/22 16:38, Sean Christopherson wrote:
> >> I want to avoid relying on the APM's arbitrary "Type B" classification.  Having to
> >> dig up and look at a manual to understand something that's conceptually quite simple
> >> is frustrating.  Providing references to "Type B" and the table in the changelog is
> >> definitely welcome, e.g. so that someone who wants more details/background can easily
> >> find that info via  via git blame.  
> 
> How about the following:
> 
>       Save states are classified into three types (APM Volume 2: Table B-3. Swap Types)

If we do end up with a verbose comment, don't bother with the volume+table details,
it will inevitably become stale, even if that takes a few years.

What I would take verbatim is the blurb on the classification being determined
by "how it is handled by hardware during a world switch", which is the most
important details from KVM's perspective.

I don't necessarily dislike the idea of capturing the types in a comment, but I
also don't think there's a whole lot of value added in doing so.  E.g. without the
full table, it doesn't help verify the correctness of the code.

I'm fine either way though, it's not that large of a comment and it will likely
prove helpful to someone at some point in time.

> 
>       A: VM-Enter:

So this really should be VMRUN, since the table here is specifically covering
VMRUN behavior, not KVM's broader VM-Enter sequence.  As mentioned earlier in the
thread, VM-Enter/VM-Exit is preferred when talking about the sequence, but in this
case the table is documenting hardware behavior that is specific to VMRUN.

Hrm, and I know that same earlier comment said "on VM-Exit" is preferred, but since
this is again specifically talking about the hardware concept of VMEXIT, it's
probably best to use that terminology for the table.

The short comment I proposed used "on VM-Exit" because it didn't dive as far into
the details of hardware's view of things.

> Host state are saved in host save area

Hmm, I like the APM's approach of avoiding the question of whether or not "Host
state" is plural, i.e. omit the "are" (versus "is"?).

>          VM-Exit: Host state are restored

s/restored/loaded

Doesn't matter as much here, but when KVM is doing the "saving" for type-B,
"restored" can become misleading as KVM isn't strictly required to save its
current state.

> automatically from host save area

s/automatically//

KVM could also "automatically" load state on exit, and there's also no need to
further qualify that hardware loads are "automatic".  Hardware either loads state
or it doesn't, e.g. there's no knob that lets KVM say "don't load this state".

>       B: VM-Enter: Host state are _not_ saved to host save area, KVM needs to save 
>                    required states manually in the host save area

Drop the KVM line, i.e. keep the "table" purely about the types, and leave the
"KVM needs to handle type-B" til the end.  E.g. the "manually" part is arguably
wrong depending on how VMSAVE is classified.

>          VM-Exit: Host state are restored automatically from host save area
> 
>       C: VM-Enter: Host state are _not_ saved to host save area.
>          VM-Exit: Host state are initialized to default(reset) values.

Please align the comments after the colon, makes it easier on the eyes

>       Manually save state(type-B) that is loaded unconditionally by hardware on 

The "save state(type-B)" reads a little odd, maybe "save type-B state"?  And the
"unconditionally" can be dropped (see "automatically" above), as can the "SEV-ES
guests" blurb since this is SEV-ES specific code.  Hmm, though it might be worth
throwing in a "for SEV-ES guests" in the intro?

>       VM-Exit for SEV-ES guests, but is not saved via VMRUN or VMSAVE (performed 
>       by common SVM code).

Hmm, the comma should be after VMRUN, since type-B state is _all_ state that isn't
saved by hardware VMRUN, whereas the key point of this last blurb is to call out
that KVM already saves a subset of type-B state via VMSAVE.

All in all, this?

	/*
	 * All host state for SEV-ES guests is categorized into three swap types
	 * based on how it is handled by hardware during a world switch:
	 *
	 * A: VMRUN:   Host state saved in host save area
         *    VMEXIT:  Host state loaded from host save area
	 *
	 * B: VMRUN:   Host state _NOT_ saved in host save area
         *    VMEXIT:  Host state loaded from host save area
	 *
	 * C: VMRUN:   Host state _NOT_ saved in host save area
         *    VMEXIT:  Host state initialized to default(reset) values
	 *
	 * Manually save type-B state, i.e. state that is loaded by VMEXIT but
	 * isn't saved by VMRUN, that isn't already saved by VMSAVE (performed
	 * by common SVM code).
	 */
