Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C0A76A4BD
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 01:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjGaXTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 19:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjGaXS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 19:18:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6132716
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 16:17:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d063bd0bae8so5977196276.0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 16:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690845456; x=1691450256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A2YbEGxqz9SscBGtet0Gs0ciHUjPL61/tRobVSn5JSc=;
        b=Aspi3sVz1s4NKlFaJjQOa2DQlODn/JsCKt4eqnvhQolwNg6rVTEqjLQs26sN5J6ZNe
         3e/etHAaEqvAoxl+oSQQP1bHfmA59RbK7Nu0azx4K+EVcSxVntDfjH8buFsuy2V7KlEw
         5RZ7h2m65ZZHDqRcD6/spD/JjZaCVH323kw1HLp8C4YPZbjDkNb49TqTz+Z2vaOWATUw
         n/OnsLadTVEbeeCCi9f1Xp8cRMaUuSd29J6gHrEWBjtkXdfJ7q9euJ/ihFEIWOoOKssN
         /B9i1WTYQfm0A5NhSpMZHAiVkGnI47YF/h8cE5B0h4DZfCGtUwSF1W1GjS47WDQ5r/1d
         NbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690845456; x=1691450256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A2YbEGxqz9SscBGtet0Gs0ciHUjPL61/tRobVSn5JSc=;
        b=K4GZCIlXZr2DUuYLYygJLbylbRoTbrtbWyPqvrH13Xzj2ZBdtZnpuk7NZgQqCpwlLl
         etp/QLlahgNSYwl8Gxs5j6tezg+RKHoRKXomdFjl5HxmoNYq4EXwHPwpQlfxnRuwFZsO
         8bGY4qfpz4R8YAFENrsSg0Y+krUYUJep6kEm9GHc7tyjHWnZn3gak+qUTLwsc4PPD3to
         vi4VK014wVCgf/vEFZD5yKiePmORrge7rtRtDMoUQ7x92hdHNDk6SMhQF5+Zvr3sMCDl
         SYYdOREyu11g5Nu/axwYWQ/561Hf1612fDtsKDfOhJQU6O87efERO8uVgQ5NMAJocIQ2
         gCZw==
X-Gm-Message-State: ABy/qLZotI/oAQfVxf0rZtlTCE2ELt9ccff0SRlGqQT+hxoGBKuzambQ
        a3Zoh3ukgWt+Yb1lQYAJAIS8+V74chA=
X-Google-Smtp-Source: APBJJlETEe4EZ6/j95cQ4sv3ryYhK33RfUu+RWsNUCsL/BaRynxJ5PFVR6kJ5MkvzQvyz83entZG77hN4jM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:69c7:0:b0:d07:f1ed:521a with SMTP id
 e190-20020a2569c7000000b00d07f1ed521amr63258ybc.4.1690845456129; Mon, 31 Jul
 2023 16:17:36 -0700 (PDT)
Date:   Mon, 31 Jul 2023 16:17:34 -0700
In-Reply-To: <SA1PR11MB6734A02EEFD83969F1965A8FA805A@SA1PR11MB6734.namprd11.prod.outlook.com>
Mime-Version: 1.0
References: <20230731063317.3720-1-xin3.li@intel.com> <ZMg1sD7IamB0INVs@google.com>
 <SA1PR11MB6734A02EEFD83969F1965A8FA805A@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <ZMhBDoTxqghvF7G7@google.com>
Subject: Re: [PATCH v9 00/36] x86: enable FRED for x86-64
From:   Sean Christopherson <seanjc@google.com>
To:     Xin3 Li <xin3.li@intel.com>
Cc:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jurgen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, Fei1 Li <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023, Xin3 Li wrote:
> > > This patch set enables the Intel flexible return and event delivery
> > > (FRED) architecture for x86-64.
> > 
> > ...
> > 
> > > --
> > > 2.34.1
> > 
> > What is this based on?
> 
> The tip tree master branch.
> 
> > FYI, you're using a version of git that will (mostly)
> > automatically generate the based, e.g. I do
> > 
> >   git format-patch --base=HEAD~$nr ...
> > 
> > in my scripts, where $nr is the number of patches I am sending.  My specific
> > approaches requires HEAD-$nr to be a publicly visible object/commit, but that
> > should be the case the vast majority of the time anyways.
> 
> Are you talking about that you only got a subset of this patch set?

No, I'm saying I don't want to waste a bunch of time tracking down exactly which
commit a 36 patch series is based on.  E.g. I just refreshed tip/master and still
get:

Applying: x86/idtentry: Incorporate definitions/declarations of the FRED external interrupt handler type
error: sha1 information is lacking or useless (arch/x86/include/asm/idtentry.h).
error: could not build fake ancestor
Patch failed at 0024 x86/idtentry: Incorporate definitions/declarations of the FRED external interrupt handler type
hint: Use 'git am --show-current-patch=diff' to see the failed patch

> HPA told me he only got patches 0-25/36.
> 
> And I got several undeliverable email notifications, saying
> "
> The following message to <tglx@linutronix.de> was undeliverable.
> The reason for the problem:
> 5.x.1 - Maximum number of delivery attempts exceeded. [Default] 450-'4.7.25 Client host rejected: cannot find your hostname, [134.134.136.31]'
> "
> 
> I guess there were some problems with the Intel mail system last night,
> probably I should resend this patch set later.

Yes, lore also appears to be missing patches.  I grabbed the mbox off of KVM's
patchwork instance.
