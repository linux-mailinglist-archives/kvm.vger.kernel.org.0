Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5F35365B3
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 18:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348987AbiE0QIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 12:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244397AbiE0QIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 12:08:17 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF651498C1
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 09:08:16 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gz24so4991728pjb.2
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 09:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=84jyFcXhy+7LS/4BL2qQwkaV7/d2/eHd1cRcTDWz3EI=;
        b=QmoCCOzPCZXeGFX5CxM6xUDiY5xxA+rTy9f87DS8FUZKehOK7jj4/99vNCnYbkcfJr
         dF/V4fITPoPzxDK+3WxS+PeU7HHbChP0uUK6b7iniYkYhpqBpXjxZy2m05AeC5DRW8wz
         7RJubuU1csiLGslSaCj9hkDJ+Uj3by1iGoG8ikhy/9lyaS57pkfvTmTp+MvfhgFqz93W
         gjF0Qb80xn0/bquGTnwg1C3dSUfhZV9crL6gcbTJdLfRHoeG0ZPDtWsL1QmpxkrnPL5/
         4aJH5JoMTyRRu5UCLiVQnARlAZ9oMhPG9SFEIr1aJs+zr5lnDe7Rn0pk+0Y01hxGtuRV
         RPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=84jyFcXhy+7LS/4BL2qQwkaV7/d2/eHd1cRcTDWz3EI=;
        b=Ifwt7SNlGksDotT65Hsk3Kp/U+4kFPlvKk6sikRsxNR3VejWIH+zDtvokFb+GYL6HN
         8WOfUJY7fMlv3UHP2Qwc4raaeMP+7dQ+imNDnqSjQqnLotCbQgjjnHW7vv3q8ntFPEo+
         E4C7Vs3KaEbCvBZRofrmIx2GxWxT0oBEZV7tgK+5Zak1dCeTOiv5aJ/refuQ6Krh8EwN
         0DKkzO3rsP/ECAgiPt1TJeUpx+l5eoOg/iEPPh5kQ8Rkz0qKuMCE7NQae4xk28boNBGV
         fOhOGaBrIOoNbdvQXHNt879FOU+c/VoxY96DUGllzEPl3k+e3PFgaKiF3N41zHgqSSdy
         YLYw==
X-Gm-Message-State: AOAM533xm+RJyA/JFCy/YEnI5QoJYCuzifK/Sol3z/D8Z6fydX04jlWy
        QDAkXf9ojVE83bwrGv+ohGZTbQ==
X-Google-Smtp-Source: ABdhPJxCYf8ECYcq48k6t4Rw29fmZa2p0+9eyg0bk1zPMkSRqOghqvhNkFmeNCYmK0xgHg8G4SGobg==
X-Received: by 2002:a17:902:f548:b0:163:90d0:ada8 with SMTP id h8-20020a170902f54800b0016390d0ada8mr5215300plf.22.1653667695905;
        Fri, 27 May 2022 09:08:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902d58c00b0016366fbc155sm3798927plh.255.2022.05.27.09.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 09:08:14 -0700 (PDT)
Date:   Fri, 27 May 2022 16:08:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: Only display message about bios support disabled
 once
Message-ID: <YpD3a3wMbr9xIsub@google.com>
References: <20220526213038.2027-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526213038.2027-1-mario.limonciello@amd.com>
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

On Thu, May 26, 2022, Mario Limonciello wrote:
> On an OEM laptop I see the following message 10 times in my dmesg:
> "kvm: support for 'kvm_amd' disabled by bios"
> 
> This might be useful the first time, but there really isn't a point
> to showing the error 9 more times.  The BIOS still has it disabled.
> Change the message to only display one time.

NAK, this has been discussed multiple times in the past[1][2], there are edge cases
where logging multiple messages is desirable.  Even using a ratelimited printk is
essentially a workaround for a systemd bug[3], which I'm guessing is the cuplrit here.

[1] https://lore.kernel.org/all/20190826182320.9089-1-tony.luck@intel.com
[2] https://lore.kernel.org/all/20200214143035.607115-1-e.velu@criteo.com
[3] https://github.com/systemd/systemd/issues/14906
