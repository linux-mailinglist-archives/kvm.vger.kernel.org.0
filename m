Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646864868DE
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 18:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbiAFRlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 12:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242012AbiAFRlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 12:41:44 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A339C061201
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 09:41:44 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t187so3095492pfb.11
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 09:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6gPF6LIvuNsMGdMGQX3Xt0jGn5hRDQzTXJU/Apy4X9o=;
        b=ZXCj1o4HApJ/G+dSeBxr7o9+V1a1WB/D6yDpeMM1dZjJKJIsE7AUy+AGCgAKPNS3kt
         GSJ1bXgIehhEN49gNObI53pqK8MoVCeskaArovAEomnqYvaI88uGaPDfgYQ09Icf7QDU
         ZRBXxfoD5GNPVEtDjJigsKlI/90jIv0i2IkTNzfOIICO6JPavH+h6X8MZho0x5c1y3b3
         AtexljqK/mngSsltvRxemmDQ5nLfkhAT9cRnZlCMX/7uzUoWVuoT6NAaUwwxjdjOqJou
         5dAWCXU17wFbVbFiMMLX0eN9n4oQwCvxNKneGv/juASqztGmcExb/MBYJmOoToW5s7uD
         slKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6gPF6LIvuNsMGdMGQX3Xt0jGn5hRDQzTXJU/Apy4X9o=;
        b=zwrKO4iMpZbrdqIEI7JhPvJCidT65c+IB/UCb+Rguq2m7QX4ajcU/Gg52APBKI5tL4
         wfUAiMnPEe0gt+Iz75HvqPWEzO9JZ2n6k98L30y7Cytt5+8sOpQ0slo3WDOGK5agDflP
         KYUJSivoDiMO4sPrw2djOgwTvKJ+kFL5xnWghUWy5Ix+LoU6jSy1ULh71p/oC75GU97y
         KBYMoR0sPPR+RgF5+q/cc6t9pwP1n7dUgXlMjvKaR54+PR27SPUud/1NLZFGPcqH7FDZ
         1x23A+eq1Zke/0Oumtf5o9CNC5D4n2ziJqB87iQUQbAtmRCZoiWCdAqWSdz5mIAM06NR
         TmpQ==
X-Gm-Message-State: AOAM530qUjv93BELH6PbxI1Oh6B2zqsJ/K7RJEdfyK9ojE5tOnRDlS+6
        mt5PHkqXGQneOgAMFq4zUsb//g==
X-Google-Smtp-Source: ABdhPJxN8AU6A7B/z1GX0JgAJYOn+uaycfZURuK9IT+76YgEIPNdaUDq06/lOci9WrxYfwhbw+ByDA==
X-Received: by 2002:aa7:97a1:0:b0:4bc:f921:5ae4 with SMTP id d1-20020aa797a1000000b004bcf9215ae4mr2323740pfq.78.1641490903635;
        Thu, 06 Jan 2022 09:41:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k6sm3412416pff.106.2022.01.06.09.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 09:41:43 -0800 (PST)
Date:   Thu, 6 Jan 2022 17:41:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 5/5] KVM: SVM: allow AVIC to co-exist with a nested
 guest running
Message-ID: <Ydcp01dTJZKi0yuz@google.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
 <20211213104634.199141-6-mlevitsk@redhat.com>
 <YdYUD22otUIF3fqR@google.com>
 <21d662162bfa7a5ba9ba2833cc607828b36480ca.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d662162bfa7a5ba9ba2833cc607828b36480ca.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022, Maxim Levitsky wrote:
> Also I recently found that we have KVM_X86_OP and KVM_X86_OP_NULL which are the
> same thing - another thing for refactoring, so I prefer to refactor this
> in one patch series.

I have a mostly-complete patch series that removes KVM_X86_OP_NULL, will get it
finished and posted after I get through my review backlog.
