Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F1F3C781B
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 22:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhGMUmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 16:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235149AbhGMUmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 16:42:02 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12779C0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:39:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id p17so36359plf.12
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vAEz6tbBq7rYrMMnkx41TwsKhbqefEUfL96yExQSeis=;
        b=vXnVzvAmDrRF8FTIsxLeNffuHPTEaCiYb4YtzDpnJgAQPgXvS5lawhS8/WpTLy6Vo8
         XlS/V+9queLMhMPiBN3DLqU2fxswvlBmwcLsjpD2m5ckBzHUhDYMteAj2jmdG4vTJfog
         NU5w6EgdvzWFrdlyYRIGFeE75quGdFyU8yJBd214cGiixfntXOFbiMbPSCeRXmpB4Kvw
         eF95YGDWecVO/K9fGyUaoAhWC/2xHXoluwTYXaQqEmoEywCIGKTh01ebamJj6d05BlT8
         2Q7lSXC0DvKkNpfCZb/zgF0QjpTWOs5uzuEdlE8SsZJg2Z97Y0tQ9ph7APv7V+7TkLMh
         L0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vAEz6tbBq7rYrMMnkx41TwsKhbqefEUfL96yExQSeis=;
        b=mYxgWIams65JKaZX5C2FI/QrIMgjx9wgeKSUJStZP+e1mjCInoW3zW5C/lArLo8fd3
         fqOQteHL46k2UEczt6kwhafmu6ZFGE7Q8GPphxs7Hag6SThsVkMw2NeLAYobz1vywSqw
         WPtUg40o4H8b789BGjM5Mpg/CHvYGHpwH9UoAivXsue+8TyjPjxjYUEENsoWOIE0Dti5
         C+Uap7tElKt2YVz7r8f9yOLGvoiRdAKQft57dzjszxAgozYYNAZFKY5cUkquQIkWXQCO
         VAUgzoMAnetkGl33AZZEY7Ic+HBFxAILbLjz7j6HP8pND/Kqjtase0cRRmXmgNZmsNl8
         KGYw==
X-Gm-Message-State: AOAM5316+y0jOTx0AIxVL3h/rwOA8k5QJoqRnxM0AcIqpQE/fzRm8Wg7
        WDhRmnTtkuM7DbQso03uc9NHjA==
X-Google-Smtp-Source: ABdhPJxKaCTzakoran7rQmGGw8tLT/Er02SRPgN8R/aU28R0uj21uUB5p9Z0RNISuFUJlrAIQ3rCSg==
X-Received: by 2002:a17:90a:1785:: with SMTP id q5mr99843pja.38.1626208750366;
        Tue, 13 Jul 2021 13:39:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d29sm37603pfq.193.2021.07.13.13.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 13:39:09 -0700 (PDT)
Date:   Tue, 13 Jul 2021 20:39:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v2 22/69] KVM: x86: Add vm_type to differentiate
 legacy VMs from protected VMs
Message-ID: <YO356ni0SjPsLsSo@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <8eb87cd52a89d957af03f93a9ece5634426a7757.1625186503.git.isaku.yamahata@intel.com>
 <e2270f66-abd8-db17-c3bd-b6d9459624ec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2270f66-abd8-db17-c3bd-b6d9459624ec@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021, Paolo Bonzini wrote:
> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> >   struct kvm_arch {
> > +	unsigned long vm_type;
> 
> Also why not just int or u8?

Heh, because kvm_dev_ioctl_create_vm() takes an "unsigned long" for the type and
it felt wrong to store it as something else.  Storing it as a smaller field should
be fine, I highly doubt we'll get to 256 types anytime soon :-)

I think kvm_x86_ops.is_vm_type_supported() should take the full size though.
