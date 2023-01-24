Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE94678D3F
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 02:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjAXBVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 20:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjAXBVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 20:21:33 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E43A26C
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:21:29 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso17014061pjg.2
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wgGa5wrgAdo2NeUwkpPTr8VHG2ztyXDjbUcIQKILZZQ=;
        b=Fj59aztvZsI93KqVdNsaBYgt0ezKwdgNzsUWuwRdK3YtJgfxyhWeV0YpdCsA254hdh
         WNYQaNlZiuY31AdjFsdXMb2hOYwhdOxjeVXeI48dRt+far/UCt0p6INt1pEFeJWaEdvH
         QNwTW9ViwWmLYRMlGlTofNZMRnlovWq8+qA2wm0RoPBtYuBHGIvQOQrrOgUB+Elmp/at
         i+FZEXyRNNAVO5kKKpkgVoFIWBJfYTEYcZllDATZ+N4p9SEVumhM1oAYbm5Sf3GzkYL1
         wVZuBCXqpFZZgWGzPRk2R3cY9F7Ca1V9tZSFMG+t9ypHjIYnWhroNO20jiQaP/vqypQT
         /LVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wgGa5wrgAdo2NeUwkpPTr8VHG2ztyXDjbUcIQKILZZQ=;
        b=7l4m0jr1ptkK+Wf35q0M+Mk8zvJHaxoo8a46dXGwp9BOWYE8BqU+R619yzMz40e0xL
         wF9Z53NTt51pH0Wyr/u90hGyM6GXIEPNNizaDLgclM0Y9YvPq/PKzqmt6Vr3ycGsbXiu
         I+uSDhZ2mTZdSFC5RFOMrPnvDmQHK8lQx5KnYqk2qi0rMG/REOqs8tC0cSDw3U4LwVrs
         cM9plWcZUAEbxjy3LujHS+XYj2N6oTLtQLkFulVdqXJ91QuXjiD+GxuMOrO6Eoiv8kVp
         IauVckw2XMp2dQopafCtA396wSJThBpMid6kk1VGi2oaWEW0YAdlmrZWGbEcIToR1V9m
         BzjA==
X-Gm-Message-State: AO0yUKXvrvFfJ6WGGfDiJ8whWa7U3i+aw113VXlsS1SpJT0tAqcXfkA1
        bfMJRDSTn0NXj0x952nQYuZxKg==
X-Google-Smtp-Source: AK7set/9pywbGEv0WlLYt3ONqn8dxZuuJBmeuykZqm87ZDRWGqgG45nB8eagGTlznEd5u4nG4ID0Ug==
X-Received: by 2002:a17:902:7891:b0:191:4367:7fde with SMTP id q17-20020a170902789100b0019143677fdemr15867pll.0.1674523288475;
        Mon, 23 Jan 2023 17:21:28 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jf1-20020a170903268100b001960690b5d4sm359391plb.59.2023.01.23.17.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:21:28 -0800 (PST)
Date:   Tue, 24 Jan 2023 01:21:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Ackerley Tng <ackerleytng@google.com>,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        isaku.yamahata@intel.com, sagis@google.com, afranji@google.com,
        runanwang@google.com, shuah@kernel.org, drjones@redhat.com,
        maz@kernel.org, bgardon@google.com, jmattson@google.com,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        ricarkol@google.com, yang.zhong@intel.com, wei.w.wang@intel.com,
        xiaoyao.li@intel.com, pgonda@google.com, marcorr@google.com,
        eesposit@redhat.com, borntraeger@de.ibm.com, eric.auger@redhat.com,
        wangyanan55@huawei.com, aaronlewis@google.com, vkuznets@redhat.com,
        pshier@google.com, axelrasmussen@google.com,
        zhenzhong.duan@intel.com, like.xu@linux.intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH v3 08/31] KVM: selftests: Require GCC to realign
 stacks on function entry
Message-ID: <Y88ylDFfMQNcUEw7@google.com>
References: <20230121001542.2472357-1-ackerleytng@google.com>
 <20230121001542.2472357-9-ackerleytng@google.com>
 <Y8sxjppvEnm4IBWG@google.com>
 <CAAYXXYy7=ZTCZ1LQ3_Sy39ju_xG5++dTrxi+DKGcbpJ5VJ3OuQ@mail.gmail.com>
 <99a36eed-e4e5-60ec-0f88-a33d1842a0d6@maciej.szmigiero.name>
 <Y87XnYZx1qzZOLKR@google.com>
 <CAAYXXYyqDJx4=cSy3kp7vX4VF+5z_Rtm6wPM8_o9BmHkB_T-kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYXXYyqDJx4=cSy3kp7vX4VF+5z_Rtm6wPM8_o9BmHkB_T-kg@mail.gmail.com>
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

On Mon, Jan 23, 2023, Erdem Aktas wrote:
> On Mon, Jan 23, 2023 at 10:53 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Jan 23, 2023, Maciej S. Szmigiero wrote:
> > > On 23.01.2023 19:30, Erdem Aktas wrote:
> > > > On Fri, Jan 20, 2023 at 4:28 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Sat, Jan 21, 2023, Ackerley Tng wrote:
> > > > > > Some SSE instructions assume a 16-byte aligned stack, and GCC compiles
> > > > > > assuming the stack is aligned:
> > > > > > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=40838. This combination
> > > > > > results in a #GP in guests.
> > > > > >
> > > > > > Adding this compiler flag will generate an alternate prologue and
> > > > > > epilogue to realign the runtime stack, which makes selftest code
> > > > > > slower and bigger, but this is okay since we do not need selftest code
> > > > > > to be extremely performant.
> > > > >
> > > > > Huh, I had completely forgotten that this is why SSE is problematic.  I ran into
> > > > > this with the base UPM selftests and just disabled SSE.  /facepalm.
> > > > >
> > > > > We should figure out exactly what is causing a misaligned stack.  As you've noted,
> > > > > the x86-64 ABI requires a 16-byte aligned RSP.  Unless I'm misreading vm_arch_vcpu_add(),
> > > > > the starting stack should be page aligned, which means something is causing the
> > > > > stack to become unaligned at runtime.  I'd rather hunt down that something than
> > > > > paper over it by having the compiler force realignment.
> > > >
> > > > Is not it due to the 32bit execution part of the guest code at boot
> > > > time. Any push/pop of 32bit registers might make it a 16-byte
> > > > unaligned stack.
> > >
> > > 32-bit stack needs to be 16-byte aligned, too (at function call boundaries) -
> > > see [1] chapter 2.2.2 "The Stack Frame"
> >
> > And this showing up in the non-TDX selftests rules that out as the sole problem;
> > the selftests stuff 64-bit mode, i.e. don't have 32-bit boot code.
> 
> Thanks Maciej and Sean for the clarification. I was suspecting the
> hand-coded assembly part that we have for TDX tests but  it being
> happening in the non-TDX selftests disproves it.

Not necessarily, it could be both.  Goofs in the handcoded assembly and PEBKAC
on my end :-)
