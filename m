Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F096E544EFD
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240564AbiFIO1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 10:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiFIO1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 10:27:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F3412FB29;
        Thu,  9 Jun 2022 07:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654784865; x=1686320865;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eCY5vfssjBdEESu3NYeDhokIbEHWS/CgrAYFRq7UYdE=;
  b=DXH8TA4evcya/w22/AJ3pBxXQ/UxKms8dGCZKg2yCCidvBaG5orPxp+S
   QiPbZHNrn5IldMAjOhtJhR4gHGsNo7mLSGehHwTeAwQYbfWvAmfASF9b2
   iTZHT0qmAuqzA/oYSdfbHyk6z9r/asxDavKkQFOdtceFO0ARHLENyR5JT
   c2bQYn2T0u+wszTo5OP779k6EgZiLxPIeblOvwEJAnVHIaWSh3kQAB50p
   8yxxtNPRA1e/iRQ+VVXZ7LihhbV9tpsPZ3eEZHXIfJQFhicXpatwtIH2x
   il7TWj+oVsLLuHrW11jEFaj36DiN0i7+JD8Obvq53c2Lh0fLX5ArOmChi
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="257125019"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="257125019"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 07:27:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="908344064"
Received: from fungjona-mobl.amr.corp.intel.com (HELO [10.212.203.188]) ([10.212.203.188])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 07:27:43 -0700
Message-ID: <f62ab257-b2e0-3097-e394-93a9e7a0d2bf@intel.com>
Date:   Thu, 9 Jun 2022 07:27:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle
 state
Content-Language: en-US
To:     Grzegorz Jaszczyk <jaz@semihalf.com>, linux-kernel@vger.kernel.org
Cc:     dmy@semihalf.com,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
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
        <linux-pm@vger.kernel.org>
References: <20220609110337.1238762-1-jaz@semihalf.com>
 <20220609110337.1238762-2-jaz@semihalf.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220609110337.1238762-2-jaz@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/22 04:03, Grzegorz Jaszczyk wrote:
> Co-developed-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
> Signed-off-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
> Co-developed-by: Tomasz Nowicki <tn@semihalf.com>
> Signed-off-by: Tomasz Nowicki <tn@semihalf.com>
> Signed-off-by: Zide Chen <zide.chen@intel.corp-partner.google.com>
> Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> ---
>  Documentation/virt/kvm/x86/hypercalls.rst | 7 +++++++
>  arch/x86/kvm/x86.c                        | 3 +++
>  drivers/acpi/x86/s2idle.c                 | 8 ++++++++
>  include/linux/suspend.h                   | 1 +
>  include/uapi/linux/kvm_para.h             | 1 +
>  kernel/power/suspend.c                    | 4 ++++
>  6 files changed, 24 insertions(+)

What's the deal with these emails?

	zide.chen@intel.corp-partner.google.com

I see a smattering of those in the git logs, but never for Intel folks.

I'll also say that I'm a bit suspicious of a patch that includes 5
authors for 24 lines of code.  Did it really take five of you to write
24 lines of code?
