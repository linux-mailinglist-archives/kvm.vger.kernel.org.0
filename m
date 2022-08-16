Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2812F596310
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 21:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbiHPTXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 15:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbiHPTXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 15:23:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C12F305
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 12:23:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso1598633pjl.1
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 12:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/IC0HnZmVrkoH3nvGfIyhZkes4sS84DBqU1XHr/AIAY=;
        b=N1cUoRaeDy5uzXUXUPkEjxLp/Fpa/P2h7JZmGiv4lZH3ufQNFSB5FmeRsupLY3TmGD
         0rwqVQ+2bCj6jDClbfXOeQ79PQta/n52qMBrzYoJuyqvvnouSwhu/J4KV6NynMh7B4LG
         udiQIvlFpVasDmPiKCLc/cIlh3zywruGDZtOCqRIFhDxNsb5y39OEJuliFwp1a43LpkA
         yHNXwDye3+dxHn7UO2UzNhpxnZxZfA3tw3EzJthKOdtyjgE6CxmwXoZWcdjavJ4QgxhR
         GJpV19gk+0P199H89gvQecShykwJ5wJ2H6722vpfQQ6a+eL745KeDyGinoZ2dzG+9s+5
         jrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/IC0HnZmVrkoH3nvGfIyhZkes4sS84DBqU1XHr/AIAY=;
        b=4LOgwkCa8O03xdH5CKOpMyNjJy3Sq1BXu0Lcb3FXutV9s8uiSM7i8f8DEW8H9PyzHQ
         emeJ+Tro+hfwwKJFJE5b9nkl9nIwqOelpW6JEqKuI+gfVdN18RC4btMRiKIqCNcRBOra
         WhULXSc/XG9rtoy1bu2JSKpsN1DREQmB6cMMTdLjG3fzJrzdTZe2CIJJImh53YyWnhoX
         ozMcuUT27L9uI91WuBF1M4ZXSQnNKjWpXwXh6UKzwba6tS99+tfdfF3Qwu+xXzOM4mPW
         kRbFwU0CowEzt9SUhirFSyF/3axyK1ZeC0cZeVAHbfJfE2jQIOOGxtNRVP2NAP+NR07g
         nlrQ==
X-Gm-Message-State: ACgBeo0xT0l5UHyVt/DfUd6ZR+y5YjCQ26rUDm4+gOaysEWBoW28C5qt
        sozsovT2CwNpnreebiPpHnl11w==
X-Google-Smtp-Source: AA6agR7LoGM80ZQ//JrY4LqKyhGoHTJ/FPLU9ixn/x/glsQzgNd4oauMrFObJ/HMvt8QwD2ZkMY5WQ==
X-Received: by 2002:a17:902:f641:b0:172:9642:1bf1 with SMTP id m1-20020a170902f64100b0017296421bf1mr826786plg.36.1660677786991;
        Tue, 16 Aug 2022 12:23:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g23-20020a63e617000000b0041cd2417c66sm7832661pgh.18.2022.08.16.12.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 12:23:06 -0700 (PDT)
Date:   Tue, 16 Aug 2022 19:23:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 3/3] KVM: Move coalesced MMIO initialization (back) into
 kvm_create_vm()
Message-ID: <YvvulrnUbFYTOUAd@google.com>
References: <20220816053937.2477106-1-seanjc@google.com>
 <20220816053937.2477106-4-seanjc@google.com>
 <YvvcHitVaf2EDAj0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvvcHitVaf2EDAj0@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022, Oliver Upton wrote:
> On Tue, Aug 16, 2022 at 05:39:37AM +0000, Sean Christopherson wrote:
> > Invoke kvm_coalesced_mmio_init() from kvm_create_vm() now that allocating
> > and initializing coalesced MMIO objects is separate from registering any
> > associated devices.  Moving coalesced MMIO cleans up the last oddity
> > where KVM does VM creation/initialization after kvm_create_vm(), and more
> > importantly after kvm_arch_post_init_vm() is called and the VM is added
> > to the global vm_list, i.e. after the VM is fully created as far as KVM
> > is concerned.
> > 
> > Originally, kvm_coalesced_mmio_init() was called by kvm_create_vm(), but
> > the original implementation was completely devoid of error handling.
> > Commit 6ce5a090a9a0 ("KVM: coalesced_mmio: fix kvm_coalesced_mmio_init()'s
> > error handling" fixed the various bugs, and in doing so rightly moved the
> > call to after kvm_create_vm() because kvm_coalesced_mmio_init() also
> > registered the coalesced MMIO device.  Commit 2b3c246a682c ("KVM: Make
> > coalesced mmio use a device per zone") cleaned up that mess by having
> > each zone register a separate device, i.e. moved device registration to
> > its logical home in kvm_vm_ioctl_register_coalesced_mmio().  As a result,
> > kvm_coalesced_mmio_init() is now a "pure" initialization helper and can
> > be safely called from kvm_create_vm().
> > 
> > Opportunstically drop the #ifdef, KVM provides stubs for
> > kvm_coalesced_mmio_{init,free}() when CONFIG_KVM_MMIO=n (arm).
> 							   ^^^
> We have CONFIG_KVM_MMIO=y on arm64. Is it actually s390?

Yes, I apparently can't read.
