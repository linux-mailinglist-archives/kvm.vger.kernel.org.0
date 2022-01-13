Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B132B48E030
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 23:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbiAMWT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 17:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbiAMWT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 17:19:26 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0BFC06161C
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:19:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o3so11818245pjs.1
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 14:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fsLvM7YnJBN4ooybRpuDhWGMymnq2SHHolVRxp/E+Yw=;
        b=HQCL9T5Wjp8Cd4nPObAlAtQ1xk0NWb6yw2+tV62YUTcBe5srnRXi9SCY34CBR+3Tx4
         QNeVse260Kn1xHbN+tvi64mnPLwVPK/K25Kqv1EeT59TtbFQkeqGHfLOx7dFzEienO//
         A/+GPCK1BIJOyWsZ7vMBGqar6A26B20UX+rAemPCndm+IQqqWXO3TS59XxNkrhyB+71o
         huNoRgbL4hNcaQa9Tb0a5jwMNfPIG4mkswjkMi30LraJ6wfRYJ7RVXhJ/EKxaCMeYX0l
         qlrmty9lvjdgRHBarAFJSwXB4K6FFZJ2NaARYJNYUQ1TWqqErCPyzGbsPUvovZQKUASh
         rAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fsLvM7YnJBN4ooybRpuDhWGMymnq2SHHolVRxp/E+Yw=;
        b=nE0YvB11IxFf8Rllgp6b3cOi8Fo2DmVVWdhMaqeePVx+Itzs1cqHj7YsCWwfGbzWfy
         g8ug6F3wdMLuWLKcIZ/UEVeqG8yHbbJoW5y51133gR0wiJa/E3qUcB3gab/wCUHz5jj7
         N/zglQGckEpb+jZflq3kIXa/IlyUtL7hZ12jhnvk5+YtuWhCwzsQh8fSRHsN5NErvEXF
         jK4sbBHjlgyxEU/4HcislkMAGv4laKnvaqO0l0ZD2dSzJxGPo4i/doLDo0IlhxYJVNZD
         5N9iRUsF05QqWmd4XXxOlUzzyqlcfXpYgUtmfqeZh0p5u824+pnQW1W/rUoqtMx+3FRY
         ejvw==
X-Gm-Message-State: AOAM531Rz+IADa4gS248+/xzwR0pNdORct8DoWphRFyb5w57axmXqi6j
        MJ5WhlmWypBxGvQi+vro/O4kXg==
X-Google-Smtp-Source: ABdhPJwZj/DNoOH5CoTksMoa0X0ZOwJFcGwdna0ZtODfjPpv+VtxS2/Ymk+PDq5p/1FeD/RU0kPzwg==
X-Received: by 2002:a17:902:6bc1:b0:149:7c61:ad31 with SMTP id m1-20020a1709026bc100b001497c61ad31mr6787586plt.93.1642112365720;
        Thu, 13 Jan 2022 14:19:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l3sm3088784pgs.74.2022.01.13.14.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 14:19:24 -0800 (PST)
Date:   Thu, 13 Jan 2022 22:19:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when
 APIC ID is changed
Message-ID: <YeClaZWM1cM+WLjH@google.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-8-guang.zeng@intel.com>
 <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
 <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
 <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
 <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
 <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
 <20220110074523.GA18434@gao-cwp>
 <1ff69ed503faa4c5df3ad1b5abe8979d570ef2b8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ff69ed503faa4c5df3ad1b5abe8979d570ef2b8.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022, Maxim Levitsky wrote:
> Both Intel and AMD's PRM also state that changing APIC ID is implementation
> dependent.
>  
> I vote to forbid changing apic id, at least in the case any APIC acceleration
> is used, be that APICv or AVIC.

That has my vote as well.  For IPIv in particular there's not much concern with
backwards compability, i.e. we can tie the behavior to enable_ipiv.
