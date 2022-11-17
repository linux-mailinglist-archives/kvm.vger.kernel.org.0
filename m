Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB41662E599
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240588AbiKQUFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiKQUE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:04:59 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518B87A34E
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:04:59 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id q9so2828282pfg.5
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6VFQ4Afa3ClxmhWdjL14RkSsjTDkfY1xGuiNh3w0198=;
        b=hHS9pVLaJluK7HQvto+Hwzy4e5GI4S9wdvzeQBJqKrSUeRXAkrWie3YOkJu8czsdJ5
         l5u3/3rx9IuaG/hdU2g/5in3JdaejCYEOziooAqJ2hgOPnnI7tqp+5cDBkDMsDakA64o
         dAyweQqjrvZ6IITxakKRGVhA6vZzZc/4D1sWW5fJ9nOxtI2XKyJ2hVEBUiSP84VaIKOX
         AgkF6Zx4vWQr7kw8/fUXD9OG6LGUEFK1uElnb1X40GcsckwDvtcYTph9pNVqNo3NcyVk
         1paWbyjqszRmuNv5yPXMYwCYK7670hmBs1AWayS1BnqLyUPHhNUP96EvQC/OEpwIT2qH
         fkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VFQ4Afa3ClxmhWdjL14RkSsjTDkfY1xGuiNh3w0198=;
        b=3VHnnqcKORu4Hz9XSdCgFKJ7ESGDafVLShug6MtVoUSQ+Vy1GQOZhPpd6LXkicnl/L
         ghrnoGfdkoeBKHzB6J70YgLYTB/XRhYuXE/sqGSG/CFx/kc9CI+HEsOcdl8LledZhnbV
         fsdtP/A7aCZDlaYlvz5mltKA3A5oW/mu+AUjO0q1Ajnl2/8JUhqMywgtvSiQ34+VNyCS
         2aS4qkFLoYh1YNpNQkO0DzUoL2CFp+t7TKh31d2QjFoaEwq9KNx1DZ3yrfsVa8U7aTV6
         5sh1aq6i3DXR8LC+1jOO9YdfgoIoTJRq/+zPsUqFTqrc+9Rzi2SwmN0bRPvbhLwnItp8
         Hp8Q==
X-Gm-Message-State: ANoB5pmdP3F+6eb1vgEu64rJvEpo4e5XrjQGw3JW8qVa9txK+KyactPp
        xhLsb2CcHujYNwqnmU5xKF4pQQ==
X-Google-Smtp-Source: AA0mqf63/jHE3FkMo0HtxSKxsIXv/1rvDDNdllZk5rej3yLZEzPKv7+rNj/XKeXT2QkTjGq2bwMAEA==
X-Received: by 2002:a05:6a00:1d0e:b0:572:341f:f06a with SMTP id a14-20020a056a001d0e00b00572341ff06amr4443387pfx.67.1668715498701;
        Thu, 17 Nov 2022 12:04:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t15-20020a1709027fcf00b00186a8085382sm591637plb.43.2022.11.17.12.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:04:57 -0800 (PST)
Date:   Thu, 17 Nov 2022 20:04:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH 02/13] KVM: nSVM: don't call
 nested_sync_control_from_vmcb02 on each VM exit
Message-ID: <Y3aT5qBgOuwsOeS/@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117143242.102721-3-mlevitsk@redhat.com>
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

On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> Calling nested_sync_control_from_vmcb02 on each VM exit (nested or not),
> was an attempt to keep the int_ctl field in the vmcb12 cache
> up to date on each VM exit.

This doesn't mesh with the reasoning in commit 2d8a42be0e2b ("KVM: nSVM: synchronize
VMCB controls updated by the processor on every vmexit"), which states that the
goal is to keep svm->nested.ctl.* synchronized, not vmcb12.  Or is nested.ctl the
cache you are referring to?

> However all other fields in the vmcb12 cache are not kept up to	 date,

IIUC, this isn't technically true.  They are up-to-date because they're never
modified by hardware.

> therefore for consistency it is better to do this on a nested VM exit only.

Again, IIUC, this actually introduces an inconsistency because it leaves stale
state in svm->nested.ctl, whereas the existing code ensures all state in
svm->nested.ctl is fresh immediately after non-nested VM-Exit.
