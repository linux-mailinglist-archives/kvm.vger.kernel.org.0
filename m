Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1963F470141
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241536AbhLJNGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241528AbhLJNGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:06:54 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C84C061746;
        Fri, 10 Dec 2021 05:03:18 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id l25so29963005eda.11;
        Fri, 10 Dec 2021 05:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iJ6XydTl1DbIydGaQLWVFy37t92UARfNxL/FwCEdhWI=;
        b=MSyIIzkV9ufN9bWhKhojEPyaun3tCtS4/2EcPE4jxWLF9bj9vwNVV3DI2FVn9BCHH9
         upRX22zLJ1exzHzRJ+idroCz4xWxX363Wt56Gq2h0FQ/XRm3ETen+sH5kfRX0wXaJA7D
         V9P6DbamjErvNAa3+/kD2Fq6yr3zbUuYxS9sH0SFZ/q7BG1GvqnAcG/soRWHzFBjFGhj
         BuXaVzXBvGlUUuo2cwws4ck3YtBs/7JIIELTUkIW0NZmXtP06wLPBFaJTf787Pbbvgsp
         gaHVGcQdV/Fqg+LnNI5yf+/37hn2EqoZvhG3j4V7aDOmIXuPTiBA71tKU0vXlr1nJIKb
         JSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iJ6XydTl1DbIydGaQLWVFy37t92UARfNxL/FwCEdhWI=;
        b=v5GKlIBUZFArKvDsIioSnoqfLStIQqaSfFsjicfGEXjuhckW2z7E6zZHsTvKoSyC3g
         kn82HfNgnl/wJ01DCfl8LPAVfh37D+WAGt8U+WNCXnecKcN4vTqgg3VoPKClI3QsACPF
         0HuARCPSHUp1vuVWWETmdOQHWd5kHmLew1yySByDRQkIQtgOBZ0RcvaSfT46xag5AQoR
         IsOqvcrS22omA5AmJWuTgZilS5WlHFHVfQuX2CB/6kVbSRo+JVIKLYyAaN6yVQG3N5VE
         o6UDrS2phJqVofS7aUC25pExvZa7pUU4JbqY8jSd3h2vfyNIHoOBDLNCokcqBWWYaVS5
         yhJA==
X-Gm-Message-State: AOAM5333YatFf/3c5h0pBaVC3HDc7rrW8+L+VfYYKqpZbN0kpn5bdIqD
        jFjEeCwghK70FnMjdbAsgwc=
X-Google-Smtp-Source: ABdhPJyPcXN5D303VMm8JoZQ791rDa4wD8/2NEZL4B+6Ur5SWqIYi2FPLHBpbRICvFCCz+AF0HB0Og==
X-Received: by 2002:a17:907:3da3:: with SMTP id he35mr23187733ejc.464.1639141396884;
        Fri, 10 Dec 2021 05:03:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id n8sm1498492edy.4.2021.12.10.05.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:03:16 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3c30e682-a569-9e91-987d-9e2fc66bb625@redhat.com>
Date:   Fri, 10 Dec 2021 14:03:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 5/6] KVM: x86: never clear irr_pending in
 kvm_apic_update_apicv
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
 <20211209115440.394441-6-mlevitsk@redhat.com>
 <636dd644-8160-645a-ce5a-f4eb344f001c@redhat.com>
 <fbf3e1665357d9517015ad49eee0c9825ed876d4.camel@redhat.com>
 <0a01229bbbb6d133ba164cb5495ad2300eb8d818.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0a01229bbbb6d133ba164cb5495ad2300eb8d818.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 13:47, Maxim Levitsky wrote:
> If we scan vIRR here and see no bits, and*then*  disable AVIC,
> there is a window where the they could legit be turned on without any cpu errata,
> and we will not have irr_pending == true, and thus the following
> KVM_REQ_EVENT will make no difference.

Right.

> Not touching irr_pending and letting just the KVM_REQ_EVENT do the work
> will work too,

Yeah, I think that's preferrable.  irr_pending == true is a conservative 
setting that works; irr_pending will be evaluated again on the first 
call to apic_clear_irr and that's enough.

With that justification, you don't need to reorder the call to 
kvm_apic_update_apicv to be after kvm_x86_refresh_apicv_exec_ctrl.

Paolo

  and if the avic errata is present, reduce slightly
> the chances of it happening.

