Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D3265110C
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 18:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiLSRON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 12:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiLSROL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 12:14:11 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BEB640F
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 09:14:10 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so9495929pjm.2
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 09:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o8HDc6dT9joGnG0gM3Tw5fM1Y1kizsgnHmZfvE7ewTk=;
        b=YhR1xiT0G8FBVLG4nJ7wyz0mwaCakcQ8zSxJN8XRMcoomBHQBF2s4yfFSUkKVORwII
         bxpniJ4SxJ36LlZU9hk367x2Z+5rIBF3V0A5DpiQ6xGZM0gzmVwwl1t5pLSGio/O7u/A
         ngVFBIpD447Cz0UH2XAPfSeSw2XayP5fw5NTudPakDqqe3n1YQZBP3Qja9+F3l4sAi4c
         Sn53AFhPs5jWQxHskDdW+U4ehLe9k3WzrXVJ1dPTR4/z80LJscC+5JToN19Wd1H2xDCk
         sENCCk2RzauNypk5LI5YUbTo+pgQtS9xLlE38Xau0R2Du5uLrgAvCp+krPBd2Nsw6xKG
         yx0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o8HDc6dT9joGnG0gM3Tw5fM1Y1kizsgnHmZfvE7ewTk=;
        b=WxGH09suCAY48QN0yL56zzixi0DG3w2Dh2NT6Qcu+LKWisiibZ6Bz0hn9LAHP+26uM
         1vIhqWXvZK42Nsfk0QzguKpBX0D4M9vaJYVNrr8S+39t3ePSBVOjUa0AGO/5OQFZIzmQ
         hYK8fRGxV3CRp63Fo1a8kBiZVb0F6BInHfwXNtQScQlNE1aPCvHGtJcBKwrtmP2oPxHT
         s36gZyUZmMU5OSKIFQxjZ2pod6fQPFIXx1+js/ZnT2AGOLOpenLOzfdIf3po9bKVCXAX
         EWzc8+TfauTYuffwIZeHPesEXy48JXLG3F1aUyedmDCDeFclwsOLbCFI8RrcQj+Hoq5R
         aKOw==
X-Gm-Message-State: AFqh2krmneblqIivgdoU+nYFu3E9fAqLu1H1Xh12ibIe0M2heOqYOnck
        JyQ+lSk9IqOzWPWQzKYBuAK/kg==
X-Google-Smtp-Source: AMrXdXtA/r28YJXIRo6rvLUx9viMsWmFPGKLwT5h9L/Tk/gsWPHqogS0jjDxwTKHjwethgFz72RwtA==
X-Received: by 2002:a05:6a20:c1a4:b0:a3:d7b0:aeef with SMTP id bg36-20020a056a20c1a400b000a3d7b0aeefmr1680834pzb.0.1671470049442;
        Mon, 19 Dec 2022 09:14:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i3-20020a631303000000b00478fbfd5276sm6532260pgl.15.2022.12.19.09.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 09:14:04 -0800 (PST)
Date:   Mon, 19 Dec 2022 17:14:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Zhang Chen <chen.zhang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardware
 mitigations
Message-ID: <Y6Cb2OrkQ8X3IvW5@google.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-6-chen.zhang@intel.com>
 <Y5oviY0471JytWPo@google.com>
 <Y6BtcutjgcgE8dsv@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6BtcutjgcgE8dsv@gao-cwp>
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

On Mon, Dec 19, 2022, Chao Gao wrote:
> On Wed, Dec 14, 2022 at 08:18:17PM +0000, Sean Christopherson wrote:
> > To me, this looks like Intel is foisting a paravirt interface on KVM and other
> > hypervisors without collaborating with said hypervisors' developers and maintainers.
> >
> >I get that some of the mitigations are vendor specific, but things like RETPOLINE
> >aren't vendor specific.  I haven't followed all of the mitigation stuff very
> >closely, but I wouldn't be surprised if there are mitigations now or in the future
> >that are common across architectures, e.g. arm64 and x86-64.  Intel doing its own
> >thing means AMD and arm64 will likely follow suit, and suddenly KVM is supporting
> >multiple paravirt interfaces for very similar things, without having any control
> >over the APIs.  That's all kinds of backwards.
> 
> But if the interface is defined by KVM rather than Intel, it will likely end up
> with different interfaces for different VMMs, then Linux guest needs to support
> all of them. And KVM needs to implement Hyper-V's and Xen's interface to support
> Hyper-V enlightened and Xen enlightened guest. This is a _real_ problem and
> complicates KVM/Linux in a similar way as multiple paravirt interfaces.

I never said the PV interfaces should be defined by KVM.  I 100% agree that any
one hypervisor defining its own interface will suffer the same problem.

I think having a PV interface for coordinating mitigations between host and guest
is a great idea.  What I don't like is tying the interface to "hardware" and defining
the interface without even trying to collaborate with others.

> The use case of this paravirt interface is specific to Intel CPU microarchitecture.

Well yeah, because the interface was designed only to work for Intel CPUs.

> Supporting multiple paravirt interfaces may not happen in the near future if there
> is no use case for AMD and arm64.

I'll take that bet.  The vast majority of problems that are solved by PV interfaces
are common to all architectures and vendors, e.g. steal time, PV spinlocks, async
page faults, directed yield, confidential VMs (GHCB vs. GHCI), etc.  I highly doubt
Intel is the only hardware vendor that will ever benefit from paravirtualizing
mitigations.
