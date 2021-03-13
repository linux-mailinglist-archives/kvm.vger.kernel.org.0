Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3185F339D58
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 10:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhCMJdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 04:33:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232904AbhCMJdM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 13 Mar 2021 04:33:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615627992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Tdndx9aurgi/5sVvvOA/y0ZDMqTihJzVHrIsQ43bJs=;
        b=aWZpvG0XSaMOGwuVFeymW3t+XEVflfaE4zPHuCSwiZglsDZvXrYv/kdSXaNI3IuX1g1aXt
        4cuSMkgS3rcQxWg18MTVSJ1ssqo3GUTLcMn3ha4FnwEOVo1Ysng94WNi8Xp9SXtk/EjYjm
        f6wCPpuuJ6bpwEX9o6Kn7OlB59QCleg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-AJRd3C2QPs-4UGvpGE3YIA-1; Sat, 13 Mar 2021 04:33:10 -0500
X-MC-Unique: AJRd3C2QPs-4UGvpGE3YIA-1
Received: by mail-wr1-f71.google.com with SMTP id h30so12398634wrh.10
        for <kvm@vger.kernel.org>; Sat, 13 Mar 2021 01:33:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Tdndx9aurgi/5sVvvOA/y0ZDMqTihJzVHrIsQ43bJs=;
        b=iUrZP5nnlrYSouDvi4ANTb8UIIbPg7CA/KSonrWH427Ys6jk5S2Zq13/AfZjxYY+dI
         1886cv8ydA7k+a7U5PBG/k1lnbeR9XQuiR2qSzAgwae9Z/RQZx1q9B/6Qni/CaMLHLeJ
         YhQVm8OK1z3c+wsiYoLDNcfubi2wDoqa8v/3LFTm/+0oQf91pnF4rsgQ+GTmIHP39k5j
         HRrJbhrW2PmXNuIWP3joEuKBmQgDAGXlVz6SP9SKgU9TjF4HmbegKNGnEmpBc3x1G0c2
         vutoHOkFobZUe0Yuewe11UfqLdxkDTkPugFWz/YnucWnFZgV+g+EuRCi0ePqOd51yvaj
         fAyA==
X-Gm-Message-State: AOAM53268JPoaVAExfaUKIAn5HHdiDSbch8VniuUQ5NCtLa7gKjr6sIv
        8X5IrFqOKCvKU4IO6pNAtS+WJnbAohZzFSLnJje5ZYZ1Bo0MoYHL7TQKYRcA7LZZpzd0jjUCGyv
        0l7JuNCr8lwap
X-Received: by 2002:adf:e412:: with SMTP id g18mr18584092wrm.159.1615627988862;
        Sat, 13 Mar 2021 01:33:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzg3FRJBBi6VfIDfkhCbsogqZme7WQaI6CDyHC5QxwaLbcrsXWQe1OD25UKJ9/fEcTaTGceHw==
X-Received: by 2002:adf:e412:: with SMTP id g18mr18584073wrm.159.1615627988716;
        Sat, 13 Mar 2021 01:33:08 -0800 (PST)
Received: from [192.168.1.124] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id u17sm3646875wmq.3.2021.03.13.01.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 01:33:07 -0800 (PST)
Subject: Re: [PATCH] x86/kvm: Fix broken irq restoration in kvm_wait
To:     Wanpeng Li <kernellwp@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
 <CANRm+CwX189YE_oi5x-b6Xx4=hpcGCqzLaHjmW6bz_=Fj2N7Mw@mail.gmail.com>
 <YEo9GsUTKQRbd3HF@google.com>
 <CANRm+Cy42tM1M2vkuZk3y_-_wD-re9QxvoxWPGmyew+k1j_67w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e363db67-598b-619a-f844-d68dfb1d041a@redhat.com>
Date:   Sat, 13 Mar 2021 10:29:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cy42tM1M2vkuZk3y_-_wD-re9QxvoxWPGmyew+k1j_67w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/03/21 01:57, Wanpeng Li wrote:
>> A third option would be to split the paths.  In the end, it's only the ptr/val
>> line that's shared.
> I just sent out a formal patch for my alternative fix, I think the
> whole logic in kvm_wait is more clear w/ my version.
> 

I don't know, having three "if"s in 10 lines of code is a bit daunting.

Paolo

