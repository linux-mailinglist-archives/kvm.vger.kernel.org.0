Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2211F1B592B
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 12:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgDWK3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 06:29:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30826 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726764AbgDWK3v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 06:29:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587637790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9AXR8INu2V1rXzlem4kdzH7dLRNBQB5Vc6BL374Yjc=;
        b=QCbKW3wey8QmbxjndK+D/pMZywGPHSdn1pa2RBFqsBhmFdAp0KWNcx0PLGCROg5u2rT+MB
        0QcihTlMe1V6tB5aJXMFrr1DYwPTl1o/4OpQ/KEtwG465H7QREMql3dpqE/lIaRWPex9O1
        eiczTRgYurwAMqcrVKW9fRMpd1iiY1g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-rjLn_tymNCqDK1vsq2J2qQ-1; Thu, 23 Apr 2020 06:29:48 -0400
X-MC-Unique: rjLn_tymNCqDK1vsq2J2qQ-1
Received: by mail-wr1-f70.google.com with SMTP id m5so2626072wru.15
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 03:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v9AXR8INu2V1rXzlem4kdzH7dLRNBQB5Vc6BL374Yjc=;
        b=qF+MV3Kq02SJiBwKaTSjJjt2d8JgHUotsBcor/9tk8PLnc9XNKSgoSPjPVCCdeYBaA
         FcdypixyU56trQ9wlpzoOP+5AeHqsEb18/qXzL1ocMFUdXit8zgXaxX5kGNMTD/+Iwgz
         KmOpwmiPXRT6SdyzySnZCQsUTCPNAcABXxwo/w772lDGlAOLP7EO57O6OhJITNZOKeRH
         TaPw7ErbSh93WliFps8RMQq2og1kG7isNrSUvpAOLs6twnRgMr68Xbs/YGlhNuZrRbsR
         8DOQfkejEWhCx1GGvG/CT8bJPyrRXzHw9Qy/tF32OmK90cb3ywjPfqZ5UvEjXotpGBWf
         vFwg==
X-Gm-Message-State: AGi0PuYLtiF9Duf3hM0fu8fj1Q3Rqxx+PzE6gp6doYl+D1ex+I0SVUvT
        cTvltX0+LTP0Auh855wWjuj2uVRjE+eN69wAZZBRs71qiRA619ZOdTyk/Lbh1sm9iSWvXb/k0UE
        1zVKvlhqxBT/T
X-Received: by 2002:adf:a3d5:: with SMTP id m21mr4322767wrb.54.1587637787646;
        Thu, 23 Apr 2020 03:29:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypIKDKQY6xB5YBU0fXjYucgfv1RSNisE2zdI//PsRQUExilnMvDayNiGTxi7DsmMMZbDdNW2ow==
X-Received: by 2002:adf:a3d5:: with SMTP id m21mr4322755wrb.54.1587637787471;
        Thu, 23 Apr 2020 03:29:47 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id x13sm3273966wmc.5.2020.04.23.03.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 03:29:46 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] KVM: VMX: Handle preemption timer fastpath
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
 <1587632507-18997-6-git-send-email-wanpengli@tencent.com>
 <99d81fa5-dc37-b22f-be1e-4aa0449e6c26@redhat.com>
 <CANRm+CyyKwFoSns31gK=_v0j1VQrOwDhgTqWZOLZS9iGZeC3Gw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce15ea08-4d5d-6e7b-9413-b5fcf1309697@redhat.com>
Date:   Thu, 23 Apr 2020 12:29:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CyyKwFoSns31gK=_v0j1VQrOwDhgTqWZOLZS9iGZeC3Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 11:56, Wanpeng Li wrote:
>> Please re-evaluate if this is needed (or which parts are needed) after
>> cleaning up patch 4.  Anyway again---this is already better, I don't
>> like the duplicated code but at least I can understand what's going on.
> Except the apic_lvtt_tscdeadline(apic) check, others are duplicated,
> what do you think about apic_lvtt_tscdeadline(apic) check?

We have to take a look again after you clean up patch 4.  My hope is to
reuse the slowpath code as much as possible, by introducing some
optimizations here and there.

Paolo

