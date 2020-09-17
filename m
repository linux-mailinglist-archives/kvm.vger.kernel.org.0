Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71A026D73B
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 10:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgIQI40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 04:56:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726350AbgIQI4Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 04:56:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600332983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u2Q5W6NAzslAk1ByBm0MYfEGJIT21PziYx8gteQ5Vhs=;
        b=ZazY5rTciOz5z3PkF74rvLA3KRiEgy/gl27HcF9URyWcDF3bEkd5Vuv0BWp8rVZTvnoGTK
        Wl/e04/AxEW4Y9PWYbG7/8REHkCrx7GLttUJEAz1rLE3OCxiuDEBrJxchZYGKcx9RKS/Oe
        oUrCBK3rJ6qhddlLyndC/3S1iImje9A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-Q2F6cQAAPKuOQFGyrvpQCg-1; Thu, 17 Sep 2020 04:56:21 -0400
X-MC-Unique: Q2F6cQAAPKuOQFGyrvpQCg-1
Received: by mail-wm1-f71.google.com with SMTP id r10so441914wmh.0
        for <kvm@vger.kernel.org>; Thu, 17 Sep 2020 01:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u2Q5W6NAzslAk1ByBm0MYfEGJIT21PziYx8gteQ5Vhs=;
        b=QjLdzjyXJCfEm5NocWAEIt/EWFmDNO78Kf32/C0pqKjarn2XfE5ZRARNIm7lOBN3OQ
         suO7dqXb0MET7SeVb6cVC+5tyqkrhQITA3KT/RQ/mF4NGR3bqzzi3BTQVIEExxv5e4b5
         2Q62WQfkXo2ycff6rjZPvpBRhBAPZkrFRDb//440wlEbMWnQ+MvRDYW4Xyygjc1LzQJA
         RwttkklcER6LG+9g7sX6juLfOGpNd3LmJKgxD05d3WLu1XW76RK1SCatYCHAo/nHIPMH
         vGitMM0FuqvLtEBbBm1JPT4qJmYNOzJ4/tx4eC2WxH6NWR+/D47RE7Vlw2qFZrxFnwY1
         vVnw==
X-Gm-Message-State: AOAM5330pgqJ2sdQ37om1nd3pJUz6UTeZI99Aqphuh8foQ18A/AB2G4V
        nNkm0M43hD0EGutFZxl9p8JX2i3Lb2oYrjTGmN1rRCHMWyxCAHqUC5xxJXYhPPOoEdV5biUc04w
        rvLC2DlgYD7HU
X-Received: by 2002:adf:f5c7:: with SMTP id k7mr31978540wrp.246.1600332979873;
        Thu, 17 Sep 2020 01:56:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4OF1kdzQGvwv13LuHvoUh2lakQ8Xdk63kyMZtVuSxMDmrRTKIgQMp+gqghXnztKnI07Yygw==
X-Received: by 2002:adf:f5c7:: with SMTP id k7mr31978509wrp.246.1600332979621;
        Thu, 17 Sep 2020 01:56:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d003:b94f:6314:4839? ([2001:b07:6468:f312:d003:b94f:6314:4839])
        by smtp.gmail.com with ESMTPSA id v2sm37283429wrm.16.2020.09.17.01.56.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 01:56:19 -0700 (PDT)
Subject: Re: [PATCH RFC] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
To:     yadong.qi@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        liran.alon@oracle.com, nikita.leshchenko@oracle.com,
        chao.gao@intel.com, kevin.tian@intel.com, luhai.chen@intel.com,
        bing.zhu@intel.com, kai.z.wang@intel.com
References: <20200917022501.369121-1-yadong.qi@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c3eaf796-67f1-9224-3e16-72d93501b6cf@redhat.com>
Date:   Thu, 17 Sep 2020 10:56:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200917022501.369121-1-yadong.qi@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/20 04:25, yadong.qi@intel.com wrote:
> From: Yadong Qi <yadong.qi@intel.com>
> 
> Background: We have a lightweight HV, it needs INIT-VMExit and
> SIPI-VMExit to wake-up APs for guests since it do not monitoring
> the Local APIC. But currently virtual wait-for-SIPI(WFS) state
> is not supported in KVM, so when running on top of KVM, the L1
> HV cannot receive the INIT-VMExit and SIPI-VMExit which cause
> the L2 guest cannot wake up the APs.
> 
> This patch is incomplete, it emulated wait-for-SIPI state by halt
> the vCPU and emulated SIPI-VMExit to L1 when trapped SIPI signal
> from L2. I am posting it RFC to gauge whether or not upstream
> KVM is interested in emulating wait-for-SIPI state before
> investing the time to finish the full support.

Yes, the patch makes sense and is a good addition.  What exactly is
missing?  (Apart from test cases in kvm-unit-tests!)

Paolo

> According to Intel SDM Chapter 25.2 Other Causes of VM Exits,
> SIPIs cause VM exits when a logical processor is in
> wait-for-SIPI state.
> 
> In this patch:
>     1. introduce SIPI exit reason,
>     2. introduce wait-for-SIPI state for nVMX,
>     3. advertise wait-for-SIPI support to guest.
> 
> When L1 hypervisor is not monitoring Local APIC, L0 need to emulate
> INIT-VMExit and SIPI-VMExit to L1 to emulate INIT-SIPI-SIPI for
> L2. L2 LAPIC write would be traped by L0 Hypervisor(KVM), L0 should
> emulate the INIT/SIPI vmexit to L1 hypervisor to set proper state
> for L2's vcpu state.

