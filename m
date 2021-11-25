Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C857745E1DB
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357132AbhKYU5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242753AbhKYUzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:55:51 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653F3C061759;
        Thu, 25 Nov 2021 12:50:46 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x15so30192244edv.1;
        Thu, 25 Nov 2021 12:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8w8nqLzeOkFZ7/OAchxNi0wmps4G4eExXYmo6j+ji3A=;
        b=T/KQ3DppR2uvVcr7wYVv4icGbEClb4N5GmjF689S+sTQuH1Eoh1ZR8jiN8mhlVFXbs
         yNvo8ifzO7byP2g+VGD1k7tEQCUy3XqbSCUTrvkQAYMbm3OY6wP0qHs5dFGitHLFK7fM
         uco+TZe6jbA+cJqlwpbd5ZoDOcXOvjqX3PkIqix11VSXbiaSKY1A2iqYZIZmmBHng0WD
         eZdq+FF0vVd4Okj3V1CvpS1FaMK5zJbGSzzpNtiMe1OQx/6TpaE0Y4I6vWJQzqvoOTcw
         bqzVCuVlIeE30oNM1CqQk3qzblP+P+gmEtvnXZlbyCpB22c9II2ueAiV96AMF10lXhW6
         c3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8w8nqLzeOkFZ7/OAchxNi0wmps4G4eExXYmo6j+ji3A=;
        b=ikG2uiBFSs3V1OltgxHmvWWqgOf8j6+gOz6X+qbEtfzD8D4bZkAgBUs89PTLN1Kbw4
         9k2rhKvwIaKp/EdLh8FrHcKKm1ggF+ZxUKjhlrhrtIw2L+jMeu4u9rp2Y+mATKZrDRmr
         DCP+/ptnN2F9hb45NozpIEVUHNIWNuyRkGQktW4BC0KM3ekz9kDv0AcKPMyPrio0Ff+d
         9h6WosOBWr5uIH1OI4EgRfy3g6s5ifqE+ePP0hQyFxS42Nt7LaxpDzHZxOflxG1KHGfJ
         HPmMSjKaXRXmfhc/czSBb1J/aXHZp0r81ir7MbA8+hfonQugDeayvzabWanQ5Oyn1Di4
         mhQg==
X-Gm-Message-State: AOAM532bDYL9Aw92DWcwaPYg9dy678US2xUQhSOXXQEz37zQJb4yz5V3
        ZrMZw8n0ZIgFc0NhS2o88bZr3HsYhZU=
X-Google-Smtp-Source: ABdhPJzp5v5WYcjZF6MLRnr83sJythvAKS7gKgHBebdWupyYttH7+y6r30TnG58qoIOMXtxHmAZf0g==
X-Received: by 2002:a05:6402:2792:: with SMTP id b18mr42617725ede.329.1637873444937;
        Thu, 25 Nov 2021 12:50:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id a17sm2580859edx.14.2021.11.25.12.50.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 12:50:44 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <4708e92c-373b-a07f-c80c-fe194ca706df@redhat.com>
Date:   Thu, 25 Nov 2021 21:50:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 28/59] KVM: x86: Check for pending APICv interrupt
 in kvm_vcpu_has_events()
Content-Language: en-US
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <9852ad79d1078088743a57008226c869b0316da1.1637799475.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9852ad79d1078088743a57008226c869b0316da1.1637799475.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 01:20, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson<sean.j.christopherson@intel.com>
> 
> Return true for kvm_vcpu_has_events() if the vCPU has a pending APICv
> interrupt to support TDX's usage of APICv.  Unlike VMX, TDX doesn't have
> access to vmcs.GUEST_INTR_STATUS and so can't emulate posted interrupts,
> i.e. needs to generate a posted interrupt and more importantly can't
> manually move requested interrupts into the vIRR (which it also doesn't
> have access to).

Does this mean it is impossible to disable APICv on TDX?  If so, please 
add a WARN.

Paolo
