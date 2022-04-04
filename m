Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386AB4F2034
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 01:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbiDDXVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 19:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243125AbiDDXV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 19:21:29 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70691DFE7
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 16:19:30 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z6so13302503iot.0
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 16:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4HQuxb/8RWMSgNIJitUFJzaBlGJWxUNK7LO21+WkcG4=;
        b=Et2iWkTnW2r9yego6aq6wuHaWBZ4EPhFdAlYbpl3fySBWEZ2suJ7cmpKbqAZVDEYJV
         penv5MLm4ibzzjyZiCG+sRGdi8Owm7364yw8WjIBdlTFlfXoBJO7+FNNr9McLPDqsk/+
         Wk3JJz1J8PkUOamRTT2csAmTyuLOZGX07uWOwgNGZ1je/MbzCba3qb/ZUCyBExVSbyUT
         pMee689hFU90nSNMhNGDq3sULdZzSgRygc/zJleZXc6y0m6EZ+663aM9zSvn4AgP6AsS
         4zwbH01jcZUOsOFgfWw1EUdI9wee7r/o5gNsIU9levXCN6L9MQE2pBXPeWowZWRd2Rr2
         JePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4HQuxb/8RWMSgNIJitUFJzaBlGJWxUNK7LO21+WkcG4=;
        b=6fCY07T5UIO+BPBYM+6PU5ZJ83cRYilQtud35yr8PgL+2P8Hk4dWic5QLXbCt1uNl2
         9JByZUmKz/EgFfNihcpnOlLpegKJogLVuPxmZrIykxfROcbu9UeqpIA3Y+kYoEL1ZPvu
         zLqcukH4jp8SHXu1loNzTNFQ5MJgoRL4fWK5eXcHAlMNO1RBDLCxiuNxizFHCFnkXlvk
         zIfRF1EyrwDk8XIMaEJhc4bEvNvj7z7eCLo/Bmr5EkF+rWVS1KIGDzOJpWU/NL2/yVj6
         s9xpOuw8f5B+2Uad7pRHt7hrkff4+MgDbnzQDIcSqpMHj/8rKURFMDSm+/vuNrfluLXY
         gj6Q==
X-Gm-Message-State: AOAM531sCKq8IdqiT+d0vDMIOUEA17bGBekx3txyGZalxSxWgp6WWAbt
        BHLuMrbiy+8q6jh8aTQk2MuHmw==
X-Google-Smtp-Source: ABdhPJybHp4SBT2pqY9bfoXsSLyxE3+imCY7mtDDFkk9g25hqxAWHP1Ohh8UmDjlZHjJtCgPNsazsQ==
X-Received: by 2002:a05:6602:80a:b0:649:f33:ecb2 with SMTP id z10-20020a056602080a00b006490f33ecb2mr344836iow.150.1649114369644;
        Mon, 04 Apr 2022 16:19:29 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id s10-20020a6b740a000000b006413d13477dsm7067073iog.33.2022.04.04.16.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 16:19:28 -0700 (PDT)
Date:   Mon, 4 Apr 2022 23:19:25 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Plumb cp10 ID traps through the
 AArch64 sysreg handler
Message-ID: <Ykt8/Q5LLpZdgLu5@google.com>
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-3-oupton@google.com>
 <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
 <YkqCAcPCnqYofspa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkqCAcPCnqYofspa@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 04, 2022 at 05:28:33AM +0000, Oliver Upton wrote:
> Hi Reiji,
> 
> On Sun, Apr 03, 2022 at 08:57:47PM -0700, Reiji Watanabe wrote:
> > > +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
> > > +{
> > > +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> > > +       u32 esr = kvm_vcpu_get_esr(vcpu);
> > > +       struct sys_reg_params params;
> > > +       int ret;
> > > +
> > > +       /* UNDEF on any unhandled register or an attempted write */
> > > +       if (!kvm_esr_cp10_id_to_sys64(esr, &params) || params.is_write) {
> > > +               kvm_inject_undefined(vcpu);
> > 
> > Nit: For debugging, it might be more useful to use unhandled_cp_access()
> > (, which needs to be changed to support ESR_ELx_EC_CP10_ID though)
> > rather than directly calling kvm_inject_undefined().
> 
> A very worthy nit, you spotted my laziness in shunting straight to
> kvm_inject_undefined() :)
> 
> Thinking about this a bit more deeply, this code should be dead. The
> only time either of these conditions would happen is on a broken
> implementation. Probably should still handle it gracefully in case the
> CP10 handling in KVM becomes (or is in my own patch!) busted.

Actually, on second thought: any objections to leaving this as-is?
kvm_esr_cp10_id_to_sys64() spits out sys_reg_params that point at the
MRS alias for the VMRS register. Even if that call succeeds, the params
that get printed out by unhandled_cp_access() do not match the actual
register the guest was accessing. And if the call fails, ->Op2 is
uninitialized.

Sorry for backtracking here.

--
Thanks,
Oliver
