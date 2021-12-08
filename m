Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B74B46CFBA
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 10:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhLHJNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 04:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhLHJNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 04:13:06 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E738BC061746;
        Wed,  8 Dec 2021 01:09:34 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l25so5966315eda.11;
        Wed, 08 Dec 2021 01:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yxJcUg9sr80nOyHJimTgCrmoTuePLh38op6h19juAN8=;
        b=KxmeuubkIsid0/Zjzzn7drJ0L1h6+WV6DWVWUMk2BiOWy13ruchzwLqm2oijcsPVpE
         to/VbHRF1yMHhG0FiuJ7/OmPiPOWlYCMZhrzS0Di/7rcQD8JyNMrJwW6Lwqekk89pZ9P
         iedFxwe+A1CFiNuA5/kS0fGrG/XIeKNP9asAPuF++KgVaQob2qhtIWMh0BYlf2+pUDmr
         JxOFSPgmF2stkrxY19oUSfRuF7j55Jnl622/QXszvGBMuxxvNR+/MRZ72wJnYUvUAlUI
         1gWPnqKldj6gN+JE8YwMRZc8cGOLV+O9s0MIo9wl0Jw6gazdgrW0VXLGvWS0otivgPld
         TDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yxJcUg9sr80nOyHJimTgCrmoTuePLh38op6h19juAN8=;
        b=nvb39WSuz4iJcUtiFLcX+FuI3b6iOpehyUQTfCDQ6sztDR/aqJ8fjbF6j/vRe2jEWA
         hJ+bttECRE46yCcpKmW29qzZw8MCvFe6BP9CqoVwCuXxKLutt8ar3gz28D2cAqdbp06n
         8qFT5nObEXMUiqmX1QSstmyv1HXmXS5DB7XPZ69vO8QX3TIHJXk48DumIP+YXi4DEOP8
         zyZWJ6cqvIjyjNVZqhMHTOTF5pjA1t+CqdiymV/cVwKToNNH1sSLHmOCKW1wEl4IkEwl
         gzAnZwF2Jb88CHsbJEdNxgAZYu5H+QHDhzt2DjQGIY/00G4Rn/AI+PJ7DDASsiYj9QRe
         gXxw==
X-Gm-Message-State: AOAM533BCPxnR4FwPhqFawqX7Tbp/8PdsrcXCrGhwEOcbvKmbfy6jvoW
        mZ4dRzHZ6aKbvwio3IjhO2o=
X-Google-Smtp-Source: ABdhPJxlOWCIQm+Jvdx6A/CtmDxo8HbH6QmDLTJeN+1HhkhDhp+9MKTNku5GvFmdsWYRXrANcF5d9g==
X-Received: by 2002:a17:906:6a18:: with SMTP id qw24mr6143614ejc.118.1638954573547;
        Wed, 08 Dec 2021 01:09:33 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id t5sm1632550edd.68.2021.12.08.01.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 01:09:33 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <60743c95-f9aa-a7c6-1709-39c70e224321@redhat.com>
Date:   Wed, 8 Dec 2021 10:09:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 16/15] KVM: X86: Update mmu->pdptrs only when it is
 changed
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144527.88852-1-jiangshanlai@gmail.com> <Ya/xsx1pcB0Pq/Pm@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ya/xsx1pcB0Pq/Pm@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 00:43, Sean Christopherson wrote:
> what guarantees the that PDPTRs in the VMCS are sync'd with
> mmu->pdptrs?  I'm not saying they aren't, I just want the changelog
> to prove that they are.

If they aren't synced you should *already* have dirty VCPU_EXREG_PDPTR 
and pending KVM_REQ_LOAD_MMU_PGD, shouldn't you?  As long as the caching 
invariants are respected, this patch is fairly safe, and if they aren't 
there are plenty of preexisting bugs anyway.

Paolo

> The next patch does add a fairly heavy unload of the current root for
> !TDP, but that's a bug fix and should be ordered before any
> optimizations anyways.

