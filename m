Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3635219C63
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 11:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgGIJgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 05:36:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45480 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbgGIJgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 05:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594287393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CtOSVWjGIJKi9/oO387KsYV6nN71WYUQnc1/rUIVcCQ=;
        b=UOFFEb9kDldq6A/Ibk2A2lDn7Y71QQBlpaI4tPAOsm4iBpwRox+2n4BKRwdKGNySQBz3VP
        9+B0VPSUeND9unRDzIH0+VTsDLo6vx7C4ylLNQKXPCqIZQKZW6GNsrFTchJmO2Vv0j9Rsy
        11GoKawE/ontdX2yrZp5NCjG0XdGQaM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-Yn8TH2lgN1yQ_PbokLDVnA-1; Thu, 09 Jul 2020 05:36:29 -0400
X-MC-Unique: Yn8TH2lgN1yQ_PbokLDVnA-1
Received: by mail-wm1-f70.google.com with SMTP id g138so1736629wme.7
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 02:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CtOSVWjGIJKi9/oO387KsYV6nN71WYUQnc1/rUIVcCQ=;
        b=Uv5wSFcd3uSxrbvlbK7/6dlOwcEwugko8J1TRbMmAfim1wLXIScOy6BOXW8+FUDlqR
         /YPG0y3IZR2Oc1LRtpFKIGfvB2QNgJ63q+fBIn1p5ntoBHWbXSGkHykpiCCZEke7PQLn
         ur2aT1CWgCvOeeoNZ7sYevP8RHCCi7+NQKNax6rTi0gHl1AgEk1uappX6sEA7szWOWMD
         LbTUAgpdt/hHTm0sA8gQPgZ0hTvWYrM+O/4zTaebxy3Cz6WczhLyzVizdjPkXcyCmHxd
         qf3bAWTx+pbjNcI6byZfsriQRzcarB00l75HmIbAlVnBJVRhYeiT3YLKQSDt3yso0iVI
         NHgQ==
X-Gm-Message-State: AOAM532XvSfqbH9B2+BU/eechOPJJKGbZ14uksJpdgQtdIAg6oZ6BN3E
        BVkwLtheAlRO+Ym/Aznjg0Cb+tAqSugl9xiePbKEqqAXyPTsrqoQ1RpEVlLyf1+r4ENW1if1tPF
        qfFNdkSISGgR4
X-Received: by 2002:adf:8444:: with SMTP id 62mr59594556wrf.278.1594287387920;
        Thu, 09 Jul 2020 02:36:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxF+/9SCj0U6GXVf8JwpX3nYzuOn1m0oxzuCcXP3M+psZPR6wlzkntLRIF5WbnZXVyW0XesCg==
X-Received: by 2002:adf:8444:: with SMTP id 62mr59594536wrf.278.1594287387675;
        Thu, 09 Jul 2020 02:36:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id j15sm4559275wrx.69.2020.07.09.02.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 02:36:27 -0700 (PDT)
Subject: Re: [PATCH 2/3 v4] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are
 not set on vmrun of nested guests
To:     Jim Mattson <jmattson@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
 <1594168797-29444-3-git-send-email-krish.sadhukhan@oracle.com>
 <699b4ea4-d8df-e098-8f5c-3abe8e4c138c@redhat.com>
 <ed07cbc2-991f-1f9e-9a4d-ef9b4294b373@oracle.com>
 <CALMp9eQRgRX4nnLHp52SY1emjjs7VO90pGKpV3Y0JJvf-bjNFQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c7fb2ca9-1663-c305-741d-5a184ca02850@redhat.com>
Date:   Thu, 9 Jul 2020 11:36:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQRgRX4nnLHp52SY1emjjs7VO90pGKpV3Y0JJvf-bjNFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 01:07, Jim Mattson wrote:
>> Just curious about using LME instead of LMA. According to APM,
>>
>>      " The processor behaves as a 32-bit x86 processor in all respects
>> until long mode is activated, even if long mode is enabled. None of the
>> new 64-bit data sizes, addressing, or system aspects available in long
>> mode can be used until EFER.LMA=1."
>>
>>
>> Is it possible that L1 sets LME, but not LMA, in L2's  VMCS and this
>> code will execute even if the processor is not in long-mode ?
>
> No. EFER.LMA is not modifiable through software. It is always
> "EFER.LME != 0 && CR0.PG != 0."

In fact, AMD doesn't specify (unlike Intel) that EFER.LME, CR0.PG and
EFER.LMA must be consistent, and for SMM state restore they say that
"The EFER.LMA register bit is set to the value obtained by logically
ANDing the SMRAM values of EFER.LME, CR0.PG, and CR4.PAE".  So it is
plausible that they ignore completely EFER.LMA in the VMCB.

I quickly tried hacking svm_set_efer to set or reset it, and it works
either way.  EFLAGS.VM from the VMCB is also ignored if the processor is
in long mode just like the APM says in "10.4 Leaving SMM"!

Paolo

