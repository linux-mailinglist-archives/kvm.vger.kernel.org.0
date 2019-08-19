Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DDF9282F
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 17:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfHSPSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 11:18:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbfHSPSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 11:18:03 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 034F336887
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 15:18:03 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id k14so5409371wrv.2
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 08:18:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tFK/2DMY9q6eOmfekCYuwpB3kuZu21btnlVWLmyIxL4=;
        b=ribmiMPFDVxPFmzNuQGM2qjf4CHI/iLJ+kbOp8Ep4DJxW8n/qlamSM7d3CB1bb1mr7
         Zypir9uOR9PGW07qQMtnofb6GLMT2+5mko9qEFdocRbOaQ/236Ujm2mUiqU1tQc5Y7oq
         YHeGxOf7vsdJzHHL/ri8PwG2drpZ9NpRzhe/Q4vDIB2XbMUxumnKQWjzXd4jFMYo2B/h
         pJoqQsEdGGM7NT/GxnFHyVtZmy6i55sDexGdIDuyRqYbAiJ3x+FMXvAR0vIRn53Sam0z
         k2H0uxWUSXLTbIQZ4sJ49FAI7KvWPomcfeKhwkJb3ZG+KAvc17EEInheRUOUJjOEbXre
         g2eg==
X-Gm-Message-State: APjAAAUKUgMZhkg0c8GoLXtA+KxVQRWMYs272jryazcOoeCrERSp37HY
        rS2pz1alnfEHSHUrQZQn2A1USOtEFe1qrRnWoxsgvf4klZY9vrW8av+kOa2ABjFDQBGwtHoJd1+
        6xAuyoGPneN9k
X-Received: by 2002:a1c:9e4b:: with SMTP id h72mr20033980wme.99.1566227881394;
        Mon, 19 Aug 2019 08:18:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwG3aInZcHfj+Xk9fzqy4JDN13omWZpnKB32m676GPtOSbmueYAVxw6y0pJkMhO7pGEM+bJIA==
X-Received: by 2002:a1c:9e4b:: with SMTP id h72mr20033957wme.99.1566227881065;
        Mon, 19 Aug 2019 08:18:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id o5sm12416090wrv.20.2019.08.19.08.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 08:18:00 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: x86: fix reporting of AMD speculation bug CPUID
 leaf
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
References: <1565854883-27019-1-git-send-email-pbonzini@redhat.com>
 <1565854883-27019-2-git-send-email-pbonzini@redhat.com>
 <CALMp9eQcRbMjQ_=jQ=qaYmh1Lavc3PYvm4Qcf3zY+N8j3zZe-w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0e29f624-10f5-7ab5-1823-280f32732b68@redhat.com>
Date:   Mon, 19 Aug 2019 17:18:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQcRbMjQ_=jQ=qaYmh1Lavc3PYvm4Qcf3zY+N8j3zZe-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/19 23:45, Jim Mattson wrote:
> On Thu, Aug 15, 2019 at 12:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> The AMD_* bits have to be set from the vendor-independent
>> feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
>> about the vendor and they should be set on Intel processors as well.
>> On top of this, SSBD, STIBP and AMD_SSB_NO bit were not set, and
>> VIRT_SSBD does not have to be added manually because it is a
>> cpufeature that comes directly from the host's CPUID bit.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> On AMD systems, aren't AMD_SSBD, AMD_STIBP, and AMD_SSB_NO set by
> inheritance from the host:
> 
> /* cpuid 0x80000008.ebx */
> const u32 kvm_cpuid_8000_0008_ebx_x86_features =
>         F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
>         F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
> 
> I am curious why the cross-vendor settings go only one way. For
> example, you set AMD_STIBP on Intel processors that have STIBP, but
> you do not set INTEL_STIBP on AMD processors that have STIBP?
> Similarly, you set AMD_SSB_NO for Intel processors that are immune to
> SSB, but you do not set IA32_ARCH_CAPABILITIES.SSB_NO for AMD
> processors that are immune to SSB?
> 
> Perhaps there is another patch coming for reporting Intel bits on AMD?

I wasn't going to work on it but yes, they should be.  This patch just
fixed what was half-implemented.

Paolo
