Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E8B54E824
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 18:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiFPQxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 12:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378462AbiFPQs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 12:48:29 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4F2403F8
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:48:20 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m14so1722336plg.5
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/kn16vTwAaiq9Bc2ILIkOn3nZMwcL4ACg5m6p87/3Yo=;
        b=PRRxzD/clcgliJHEd07/uq15rx/yBZ9V4j/rYWq4ZHrSp30epHtSPOlJiP59CoqqZr
         6c1JmzQXK2eO929G6Ykm1fK/53At6DA/HfU+VdIRzVij4QeUeNz26ZovCUMIy/fEqvk4
         JM/pLBrzU8c2a0aiSiWN7IXGKNVRF8+wynuX/BN73HFNKFTlbDiKzEaEsYMdnPFk9yyI
         GVHyulrayWn/dcsOkO0yjThufPqncch97jY/VlU6HRpIQcMWDL5ERCShy+I9KvEM7UZg
         vzbcHTshM7cmF0QzoRdyO34Xk9YZOKwVNUbTLAU2ZwSgTtziSbN2uOYvamfTR/Ncpnu3
         ABjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/kn16vTwAaiq9Bc2ILIkOn3nZMwcL4ACg5m6p87/3Yo=;
        b=vu0bCoIFDcmoOLJZwEfVmVeKhqz4wtwanMz3PZqSu1wLXlqs8Cw9weBb6Sx+hIHf4Q
         IeSVD+zA7yIODg+MGCaYiW2IVFNTNmPAmiW6crty/ke9Ixzvr8ohCSpyq5+EEzxnNQ9p
         U/mx9XU673R3yn8fPyg9wXzSZ9uegq3Z+0k0Gdd0n+bpRZJBhkEBYlbukN9QjSPzvJ7C
         Jo7oj0kXzhuNDO54ZmqML+KzJYwdnnS18BGtGhIZ9X0si+96VfNPUyPK6EVCbjcaFWoZ
         epAGhsb7sS6MIWQfJhyOC8sH9FaFrV/lpvE7JwDRebB1uVNA8VbiCmZspkoplNYNg4iO
         HgcQ==
X-Gm-Message-State: AJIora+ZMV6bTMjepbfqaZ3UDM5DeqgVyF8+zb/z6RMCQbj6vhuDY7aC
        0ed9blWls3nxrV4zIlPH2Src0A==
X-Google-Smtp-Source: AGRyM1t3uWSAXvdTnUwhyjK92FH1zEVpL2y3mTXY46DWvFJiA+j/mfNxm/+AhMgmBmGLFn0ua19XVQ==
X-Received: by 2002:a17:902:e889:b0:167:523c:6011 with SMTP id w9-20020a170902e88900b00167523c6011mr5191842plg.114.1655398099979;
        Thu, 16 Jun 2022 09:48:19 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p14-20020a170902e74e00b00163bfaf0b17sm1881313plf.233.2022.06.16.09.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:48:19 -0700 (PDT)
Date:   Thu, 16 Jun 2022 16:48:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, Dmytro Maluka <dmy@semihalf.com>,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sachi King <nakato@nakato.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Dunn <daviddunn@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI" <linux-acpi@vger.kernel.org>,
        "open list:HIBERNATION (aka Software Suspend, aka swsusp)" 
        <linux-pm@vger.kernel.org>, Dominik Behr <dbehr@google.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle
 state
Message-ID: <Yqtez/J540yD7VdD@google.com>
References: <20220609110337.1238762-1-jaz@semihalf.com>
 <20220609110337.1238762-2-jaz@semihalf.com>
 <YqIJ8HtdqnoVzfQD@google.com>
 <CAH76GKNRDXAyGYvs2ji5Phu=5YPW8+SV8-6TLjizBRzTCnEROg@mail.gmail.com>
 <YqNVYz4+yVbWnmNv@google.com>
 <CAH76GKNSfaHwpy46r1WWTVgnsuijqcHe=H5nvUTUUs1UbdZvkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH76GKNSfaHwpy46r1WWTVgnsuijqcHe=H5nvUTUUs1UbdZvkQ@mail.gmail.com>
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

On Wed, Jun 15, 2022, Grzegorz Jaszczyk wrote:
> pt., 10 cze 2022 o 16:30 Sean Christopherson <seanjc@google.com> napisał(a):
> > MMIO or PIO for the actual exit, there's nothing special about hypercalls.  As for
> > enumerating to the guest that it should do something, why not add a new ACPI_LPS0_*
> > function?  E.g. something like
> >
> > static void s2idle_hypervisor_notify(void)
> > {
> >         if (lps0_dsm_func_mask > 0)
> >                 acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_HYPERVISOR_NOTIFY
> >                                         lps0_dsm_func_mask, lps0_dsm_guid);
> > }
> 
> Great, thank you for your suggestion! I will try this approach and
> come back. Since this will be the main change in the next version,
> will it be ok for you to add Suggested-by: Sean Christopherson
> <seanjc@google.com> tag?

If you want, but there's certainly no need to do so.  But I assume you or someone
at Intel will need to get formal approval for adding another ACPI LPS0 function?
I.e. isn't there work to be done outside of the kernel before any patches can be
merged?
