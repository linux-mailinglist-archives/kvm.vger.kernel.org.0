Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415AB2F4B67
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbhAMMgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:36:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbhAMMgf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610541308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sb3DhGUTWswdzJJT1rUP84akykAvIdzISi4rLTrKXp0=;
        b=gw4muGEQVskk1K9tNmIZKUQuhKSOcpGOJJVMbWe6RpAY4RoTmUDa27mpjSM4pXeXDWqS6O
        0PW8Xhs/8gCVG7L8VZtLDKXd9YszPAMmYP+VOe3/olSu91Isu7gTEm8IDaUSX3Y/dYmM7F
        Y2lWz8xrERbW6TsvVtQwn4RkmMTJsVA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-lRmjpbTyPZuHZryGqHyN7w-1; Wed, 13 Jan 2021 07:35:07 -0500
X-MC-Unique: lRmjpbTyPZuHZryGqHyN7w-1
Received: by mail-ej1-f72.google.com with SMTP id y14so817247ejf.11
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 04:35:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sb3DhGUTWswdzJJT1rUP84akykAvIdzISi4rLTrKXp0=;
        b=pUhlBuhAo1Bl8jpLO5krTMWDRYCwUGUOxGXn2uLDisiFcv1qJqcjJAQ7ihpsicoUTN
         j3IvtcfFSppwFFzMH9mUstxn/tvVYRslbajU22PXg7OFCpuvnDSS0rKXGdx4+eLbFrEn
         8KkhzcojZNeNVALEzWJ3eoW5kCRRX6yO+ZhBvmm6TwUkdrO1TKdpK7GZkr/I0EjXDhwV
         XpPFqpGbw5L91LGMYbaAj58IyHWsIJWZW5rSPeYWbZGSSmDCXphHupxJdoepWJIHL/us
         ui7k6Ve4qURRk/A+sEjico7ZpbiLImYONS8GqPKpCznF4ZzaOlSBVntU/gXjNuVxoiJA
         oNAg==
X-Gm-Message-State: AOAM532EhRpj2mpuKOEY0girbWWX6zY2YCwI3Hk7Y7KVsXTr5lyrGbL5
        m7F9Hxsj5PMnzlOKjBdmq1nDtcCUZ9hDVdEv+P3HKYmdQVeaQjQPXdUA0OpfwNcvqgm+mbnCtTD
        /uZDrsyB8QYA4
X-Received: by 2002:a17:906:5958:: with SMTP id g24mr527209ejr.217.1610541305722;
        Wed, 13 Jan 2021 04:35:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqjEXrFoS2059vufYe8LRIwHim/ck52P4+HruHVf2B/GsS0iM84gRMqM3r3Cm57WdEqO7j/Q==
X-Received: by 2002:a17:906:5958:: with SMTP id g24mr527189ejr.217.1610541305571;
        Wed, 13 Jan 2021 04:35:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l14sm787769edq.35.2021.01.13.04.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 04:35:04 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <090232a9-7a87-beb9-1402-726bb7cab7e6@redhat.com>
 <X/3fbaO1ZarMdjft@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
Message-ID: <51f96502-95d2-569c-2973-eb839f84019f@redhat.com>
Date:   Wed, 13 Jan 2021 13:35:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X/3fbaO1ZarMdjft@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 18:42, Sean Christopherson wrote:
> On a related topic, it feels like nested should be disabled by default on SVM
> until it's truly ready for primetime, with the patch tagged for stable.  That
> way we don't have to worry about crafting non-trivial fixes (like this one) to
> make them backport-friendly.

Well, that's historical; I wish it had been disabled by default back in 
the day.

However, after 10 years and after the shakedown last year, it's hard to 
justify breaking backwards compatibility.  Nested SVM is not any less 
ready than nested VMX---just a little less optimized for things such as 
TLB flushes and ASID/VPID---even without this fix.  The erratum has 
visible effects only on a minority of AMD systems (it depends on an 
unlucky placement of TSEG on L0), and it is easy to work around it by 
lowering the amount of <4G memory in L1.

Paolo

