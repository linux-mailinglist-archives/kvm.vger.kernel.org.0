Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06254737DB3
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 10:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjFUIQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 04:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjFUIQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 04:16:35 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9828FE;
        Wed, 21 Jun 2023 01:16:33 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b57b4e95a8so5048261fa.1;
        Wed, 21 Jun 2023 01:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687335392; x=1689927392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JkfTMbz8TLgIEiNfglNK3B/35KQ443+5fwdu9oyRTc8=;
        b=WRc0mQdt8tT8orOjTrBku2drWl4tKtybJ3JXwQLmWxhx4g0aSDX5/KaDjzlcrL7jnJ
         Kp0Ye+hmJe9Trl6uLPq2twnK3LyPL2m1j3hU19vTr9hVQQ+iqmbiw6W8NNnpiCbd/mPJ
         Jc6nyJfBRogTkiZvkvQk5Y5UoUucA8WNjaDOqMyODU+prQOJ975Wn6sjwYfR+B9fHz/v
         UmfXKrtoZW8IsdQs0owO5nC8vezRULKohksj0AfVDjBzBhE75TYH+jD752GfrDhtiBoY
         xkKKGIvSAnP3YUhsuIXrO/n2nZJpEcR7pIcAmoKkBj31fdF/3dRIIca2BFbAfB455uMd
         E0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687335392; x=1689927392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JkfTMbz8TLgIEiNfglNK3B/35KQ443+5fwdu9oyRTc8=;
        b=QfiDvWxjyDkvgkzjmQh1nm+nqH7HW+/uJ23fCjZIzxMIMQW6lMSgdYvmKq8tp5l63f
         4BECtyuEmsl7k5l1vgSVhJeYu07z9seXINnSBJo6A+rZ3Pqa/jlvnApWu/9aRBob3BgP
         cqF0jWRAi4vv5Ib9nzhhF18LFlO4lkfcIr++whbSadU92r5F2TPz+HrCORsGeGQad+VA
         Px1CypvmS0Wpw1W5ukG/igRNFs/6kSZjtHjPq4qqcGZT4SW3q5wT7dr95JAtZa2wpSBN
         FYeNGD/wpxg15IXKy7jnyLtRijXTYlqu6mUfi9yv5s8BMDLrm1tQmMskv2hmHMxTGkvb
         UhXQ==
X-Gm-Message-State: AC+VfDymj18rbHG+87qjTgYfU5zUbrh+DCXI1whYrI2Co/ac4sqi5+ud
        AIul2N6ti5ZfZkjbCqjWWy8=
X-Google-Smtp-Source: ACHHUZ5AaVtsGMoIkyho4i8mUBql4cRD55grmmskRymra4oFpgZkcT3ibkYY2IMooWZGLly3WZfGXw==
X-Received: by 2002:a2e:a4c2:0:b0:2b4:666d:513a with SMTP id p2-20020a2ea4c2000000b002b4666d513amr5951239ljm.3.1687335391604;
        Wed, 21 Jun 2023 01:16:31 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id y16-20020a2e3210000000b002aeee2a093csm785230ljy.59.2023.06.21.01.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 01:16:31 -0700 (PDT)
Date:   Wed, 21 Jun 2023 11:16:29 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [RFC PATCH 0/6] KVM: guest memory: Misc enhacnement
Message-ID: <20230621111629.0000045b.zhi.wang.linux@gmail.com>
In-Reply-To: <CAGtprH8jreK52wTcNhoAcBoHKZfkQ_1AYArgb2v6M_YVRYAw+w@mail.gmail.com>
References: <cover.1686858861.git.isaku.yamahata@intel.com>
        <CAGtprH8O6dsjjNrMzLPmRio0ZDLe6M3U06HD0oNX3NN9FeWQfg@mail.gmail.com>
        <20230619231142.0000134a.zhi.wang.linux@gmail.com>
        <CAGtprH8jreK52wTcNhoAcBoHKZfkQ_1AYArgb2v6M_YVRYAw+w@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 19 Jun 2023 14:55:09 -0700
Vishal Annapurve <vannapurve@google.com> wrote:

> On Mon, Jun 19, 2023 at 1:11___PM Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> >
> > On Mon, 19 Jun 2023 12:11:50 -0700
> > Vishal Annapurve <vannapurve@google.com> wrote:
> >
> > > On Thu, Jun 15, 2023 at 1:12___PM <isaku.yamahata@intel.com> wrote:
> > > > ...
> > > >
> > > > * VM type: Now we have KVM_X86_PROTECTED_VM. How do we proceed?
> > > >   - Keep KVM_X86_PROTECTED_VM for its use. Introduce KVM_X86_TDX_VM
> > > >   - Use KVM_X86_PROTECTED_VM for TDX. (If necessary, introduce another type in
> > > >     the future)
> > > >   - any other way?
> > >
> > > There are selftests posted[1] in context of this work, which rely on
> > > KVM_X86_PROTECTED_VM being just the software-only psuedo-confidential
> > > VMs. In future there might be more work to expand this usecase to
> > > full-scale VMs. So it would be better to treat protected VMs as a
> > > separate type which can be used on any platform without the need of
> > > enabling TDX/SEV functionality.
> > >
> >
> > Out of curiosity, is this really a valid case in practice except selftest?
> > It sounds to me whenever KVM_X86_PROTECTED_VM is used, it has to be tied
> > with a platform-specific CC type.
> 
> Protected VM effort is about being able to have guest memory ranges
> not mapped into Userspace VMM and so are unreachable for most of the
> cases from KVM as well. Non-CC VMs can use this support to mitigate
> any unintended accesses from userspace VMM/KVM possibly using
> enlightened kernels.
> 
> Exact implementation of such a support warrants more discussion but it
> should be in the line of sight here as a future work item.
> 
>

IIUC, what you are saying is (KVM_X86_PROTECTED_VM == (VMs with UPM or GMEM))
&& (KVM_X86_PROTECTED_VM != KVM_X86_CC_VM) && KVM_X86_CC_VM requires
KVM_X86_PROTECTED_VM.

If we think KVM_X86_PROTECTED_VM as a dedicated feature, not tightly coupled
with CC techs, it seems we needs another defination of KVM_X86_CC_VM to represent
CC VM and CC platform types like KVM_X86_CC_TDX_VM to tell which CC tech sits
behind it?

I don't think it is good to mix the usages of KVM_X86_PROTECTED_VM and KVM_X86_CC_VM
together if we are sure KVM_X86_PROTECTED_VM is not going to represent CC VMs
in the code.

> 
> 
> >
> > > TDX VM type can possibly serve as a specialized type of protected VM
> > > with additional arch specific capabilities enabled.
> > >
> > > [1] - https://github.com/sean-jc/linux/commits/x86/kvm_gmem_solo
> >

