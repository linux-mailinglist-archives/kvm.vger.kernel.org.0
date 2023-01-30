Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D0B681985
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 19:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbjA3Slp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 13:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbjA3Sld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 13:41:33 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979D514481
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:41:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id j5so11917023pjn.5
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pMghoIK65PM21gBRzt5p+NP2NarTeHArU4fe9Np3EMM=;
        b=RgUboakthKgaIXLyoWrNSG2Qv+J4K4JVomfyOYRELSvc5h9W2XdiM6x29P9pBoUF4u
         FuefKa87xQLhJqo174kgnXIhDIBqKpjuHKSEm8GQY1vsujPrMdEr+oih2XdcLeMBoHSN
         /DzRzjUdxrmeEF9SsiIOWIRP+i2fwXSPrONAY2rfB6JAKM4u5SuPV2Gnle5+hxGhdIyg
         CeEWU+kqvAPuLpF1NWpgd3T9Zs6+kh1pKBDvywm1ku+M1m+2cd/SAGUfGpjjDj3k0z/a
         keybctHpc1Mf6LAfVm2XgrSmRowAknVTrXv8TT+F+GAxGNOFQtv9Jx63nHffhwPIrSSa
         +80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMghoIK65PM21gBRzt5p+NP2NarTeHArU4fe9Np3EMM=;
        b=ABikXR8GVRhuLwK+Xzwm7+N2Up2y08IDd8MzhWB5ts1bRt+HuGAJV5mLoZdA8F26hk
         rdLlZ8oUejEtcdCSwt5y9WxsHKQem2n4eM+a5SbJlCoFhEpQ6aBRvM9y2Se0+qc09Ips
         h8HuhsJsqcfOoZ4KbCLOB5ncq+5yHtWJDp5kGBK2wVTLbXH/YNM7oXSTdFHPJif70GNX
         umDxexB4gKrJlp4Fmy9sJXm7SKSPVpCEaw80+3N07MmZHgZ1DHVrS8XjTsopgJ+5N1jv
         z2yVgyaJOkCByBHhaHgyXnJa8vN7CehChpNyhdyOb7kZijv6V+iEMYcVLpWwAmIKUoul
         0MZA==
X-Gm-Message-State: AO0yUKVN3sgEb3cUB3ldjxNPJ+fPtZLtBX/sP0tZevarTFLta1aJVZvX
        2ZIIQ2dTY6hbadaB4csGQJoVgg==
X-Google-Smtp-Source: AK7set93e70967TnM9xQUAufViAl7AKeAOmHVIVJKjWAzb0Q/qRJgbxj/GDWc5BGkhuUv0igh5SXqQ==
X-Received: by 2002:a17:902:d70a:b0:193:256d:8afe with SMTP id w10-20020a170902d70a00b00193256d8afemr873089ply.2.1675104083967;
        Mon, 30 Jan 2023 10:41:23 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m3-20020a170902c44300b00186f0f59c85sm8141000plm.235.2023.01.30.10.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 10:41:23 -0800 (PST)
Date:   Mon, 30 Jan 2023 18:41:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
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
Subject: Re: [PATCH v2 03/11] KVM: nSVM: explicitly raise KVM_REQ_EVENT on
 nested VM exit if L1 doesn't intercept interrupts
Message-ID: <Y9gPT709jG/9SpSq@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-4-mlevitsk@redhat.com>
 <Y9RypRsfpLteK51v@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9RypRsfpLteK51v@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023, Sean Christopherson wrote:
> > +	 * If the L2 doesn't intercept interrupts, then
> > +	 * (even if the L2 does use virtual interrupt masking),
> 
> KVM uses "L2" to refer to the thing running at L2.  I think what you are referring
> to here is vmcb12?  And that's controlled by L1.
> 
> > +	 * KVM will use the vmcb02's V_INTR to detect interrupt window.
> 
> s/the vmcb02/vmcb02
> 
> Which of the V_INTR fields does this refer to?  Oooh, you're saying the KVM injects
> a virtual interrupt into L2 using vmcb02 in order to determine when L2 has IRQs
> enabled.
> 
> Why does KVM do that?  Why not pend the actual IRQ directly?

Duh, because KVM needs to gain control in if there are multiple pending events.
