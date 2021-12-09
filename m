Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434B946E9AD
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 15:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhLIOQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 09:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLIOQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 09:16:15 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5ACC061746;
        Thu,  9 Dec 2021 06:12:42 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y12so19640321eda.12;
        Thu, 09 Dec 2021 06:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZKElaajDOEkfrjEsxS9M6gGKFWTRHDQiJWcgcyRkQpo=;
        b=GdLNp3j3BpMVlruZDlCF0206p2jRj4VNmaADdXYXeqE8mnqlgOuw3K8Z9/acK2pVsL
         V3berzH8VSRSZ6FfF0sNADeakU/76SqyNKBOfhNMMoqwxMd9DVr0Eug+oC5EcWGvRF/H
         deXrZCCcqRCi5h8OuIfpHnkSFQo/0m/HmY4TtIj5ISOsSeZZquYXKpsTh9VnYjEotAcZ
         42gSX6R0t8275nRRtI+9vV+L6VY6iDhYHQfh0r030OfDpEwCwuZA0HksmrHSNuQQ2EdK
         BOoNl1o9ZIoxuuqbBWoZ44FqI62xrXwkSKJ4ekK2tBFu2wQ83nETWVN+3sVHvdObcaEP
         fiOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZKElaajDOEkfrjEsxS9M6gGKFWTRHDQiJWcgcyRkQpo=;
        b=H6DlGE72wndUR7MCZNFvkbOWPKBL1eNdoxj/s2nX6aP8uQvk+FoJmRZI/Y5zSL6YqE
         Mf7VX+h/7YB4oqFU4wzE40mdo2iCUNFvnfFdh4BDQ370TPEkLANN293L6c0FeTOMsEXw
         qDfhnlF4WiCe7C2KobBl8RPTpYbkAwRWfaIGtSBWY9dUIsYlvGe1gPetDOFjAXF4dNY/
         wrzEdmhnAPh4k+YoE6dqzq/aU384lo+AZgashR6bDCJcNPsp3cayPmsn2esoZyvWABEL
         6j20gL0d0h0litFbZloYVF91n1TqhoU3UqsqeeIPAUbewhwdCW08u6r2EJDVyTVnXPuR
         Jd4g==
X-Gm-Message-State: AOAM5315InCVOva9lK/IZlEnsyNSkclS+8gt3QzjWaDbGzeO5AbfAG8l
        XherlWXhqKiLa/IjILVq8Hg=
X-Google-Smtp-Source: ABdhPJyi6eaM2wuf0Zr783a2v1d54lABFpWK/cYQbPoVnv1jrgUKsHUZ9R8QEAiDWCYgEIMKOIDp5A==
X-Received: by 2002:a17:906:4787:: with SMTP id cw7mr17127226ejc.311.1639059158557;
        Thu, 09 Dec 2021 06:12:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id e12sm2832350ejs.86.2021.12.09.06.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 06:12:38 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <350532d2-b01b-1d7c-fff3-c3cb171996e8@redhat.com>
Date:   Thu, 9 Dec 2021 15:12:36 +0100
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
> Also reorder call to kvm_apic_update_apicv to be after
> .refresh_apicv_exec_ctrl, although that doesn't guarantee
> that it will see up to date IRR bits.

Can you spell out why do that?

Paolo
