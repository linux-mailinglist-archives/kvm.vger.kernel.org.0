Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DF5470071
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 13:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240870AbhLJMLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 07:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhLJMLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 07:11:31 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABE0C061746;
        Fri, 10 Dec 2021 04:07:56 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id t5so28916864edd.0;
        Fri, 10 Dec 2021 04:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nj7aP+DT5LdcUR+5nEFGqEHWsnVehVd/fkoHc9nNYc4=;
        b=PhzM3O1qKcQ6YnFuTodoI7J8Z5uhpIMeuJx8RqlbzOzof2j0B6UdH5KOD+SOTHa0N3
         PM6y2bII+meR0KzImjli57ZPHMHaamPbDdJ56NIWPXQW4qJ82ZBgUF1rILyur0lf6TGo
         Nj6OFNLNWLyEzg10MLoZxC3P1TzkpOiDfHu6u2h8YlhzsvZVYl8c4BbV3p463PGqDx15
         Q8W2b2arNtQ4MDSo75tLzzUg5OaLvUEMF4pTXpoEQZIpkijgvXTk6TJnoeFtcIBRW2uF
         bhmpXNCDm7Z/G9xVyJMXeb0TGD+iP15y92UaPhIeIYJRqXffDEQUAmhQOR0pzsOZ7Bja
         kg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nj7aP+DT5LdcUR+5nEFGqEHWsnVehVd/fkoHc9nNYc4=;
        b=7U/eVgNcmjKfAlOBnraduYF3rlWSEDU/6yPiLfhqElVsEwlRAthYG0XwDGdjDQ7hWR
         Te5TGOs5ZemLxCb6egSeq9giINhyzIJUgeB+n/wjVUCcHF86PRdWRqY8FqXKWsTslPDf
         56BwY2JdYd3N8hydwaH3dHkdXJPlnxl6SexGsfw5rJgZBbfS7+qaVn4GFYsBpnPLG/mp
         IstNGHbKXIVhE//rivEsEmj4CvqEuWors3nqcYm7I+Fh0LeWZcTW3VGZFRGVW6DEBNmJ
         4FHwT3dR8PmJUCFisVChAwi1b+6hLmPlRCO3UgXJN84RQAFtbuJoOth4g4xDIEAaWIL0
         VKJA==
X-Gm-Message-State: AOAM531qGoxymq4W2ZXZZP6lg9bc69H/5vFwAP+jaZ5qv4PAWnRdAqoZ
        shP5KoniBoDzdKoVdZDRzOc=
X-Google-Smtp-Source: ABdhPJxM8AmICWv2HgQ8A1RCPyWqAzT+vD4vNLzvjcG0RW1U58Rr9OllD13q/j4OJf7YTLam2+qihg==
X-Received: by 2002:a17:906:ff47:: with SMTP id zo7mr23315986ejb.148.1639138074679;
        Fri, 10 Dec 2021 04:07:54 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.1])
        by smtp.googlemail.com with ESMTPSA id bd12sm1337669edb.11.2021.12.10.04.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 04:07:54 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <636dd644-8160-645a-ce5a-f4eb344f001c@redhat.com>
Date:   Fri, 10 Dec 2021 13:07:52 +0100
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211209115440.394441-6-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 12:54, Maxim Levitsky wrote:
> It is possible that during the AVIC incomplete IPI vmexit,
> its handler will set irr_pending to true,
> but the target vCPU will still see the IRR bit not set,
> due to the apparent lack of memory ordering between CPU's vIRR write
> that is supposed to happen prior to the AVIC incomplete IPI
> vmexit and the write of the irr_pending in that handler.

Are you sure about this?  Store-to-store ordering should be 
guaranteed---if not by the architecture---by existing memory barriers 
between vmrun returning and avic_incomplete_ipi_interception().  For 
example, srcu_read_lock implies an smp_mb().

Even more damning: no matter what internal black magic the processor 
could be using to write to IRR, the processor needs to order the writes 
against reads of IsRunning on processors without the erratum.  That 
would be equivalent to flushing the store buffer, and it would imply 
that the write of vIRR is ordered before the write to irr_pending.

Paolo
