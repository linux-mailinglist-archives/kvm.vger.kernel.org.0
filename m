Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DECB2007CA
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 13:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbgFSL3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 07:29:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55347 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731168AbgFSL3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 07:29:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592566183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b3G5Sg9UDrE3ygdkaaLbR8lITkBl+GdILcq1UrtCIMM=;
        b=VMWqPkzU4iEvuSBgyoVny3Ifr52RLGvEkYWKEbE1R+Xj0hxNCHCGUlbgFtTyOEV82jXV0g
        RFJm0R2F4dYh0C04q8RzgAgrnmCC/hBOlzGNOeJvaa5q4dPS6BI4TZ82OX+Aw/lm1yK1mD
        ow4fmqLp8rqKamLVj0+zgdJHfepyz+I=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-MYIh07HpPDSTIBqsGc194Q-1; Fri, 19 Jun 2020 07:29:41 -0400
X-MC-Unique: MYIh07HpPDSTIBqsGc194Q-1
Received: by mail-ej1-f71.google.com with SMTP id i17so3873022ejb.9
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 04:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=b3G5Sg9UDrE3ygdkaaLbR8lITkBl+GdILcq1UrtCIMM=;
        b=S4URI1aY7TsBQM9w3D4gxHwS25m2YNtaGxAbZ3h6bhVHDJGTyAUBdqPl4oVyhFvke0
         J3Q8P4Rt/DjPBYC8abj/FCkNZuDM/7bfIzGAt1F7WyMmAIf65cECH/oscq1xExUge/Sj
         q4KYEYKUgx4SyI0dxjiVeYFYYyTuGU2ZmUVhdIuuL/SR4J8SI5MJlFEhxk44dUOW73Rp
         VQMUyluTWlgGQGDnB45hpTZATa0mz3Q6SLtaHjob/U+v5KW074hcQ9WMDKCRx65gdWxF
         Hes8kSbPyAAwwW7/z+c5PKiQbor4fLgg/rsqdu0VZWqiZ2EQJH3sOiv4C+sX/NjVh3T2
         kkuA==
X-Gm-Message-State: AOAM532IW1wuwR/5LgODbf1AB/2tDi8l92h64OHjloMEce42xpHMrUMv
        uoiU4H6GOjZbaV/hSM4RdCPzYIQJ39QfFxFoZY8zqbq/nTwz0xL4U9hSVlA0WwN/B+eGi4Chp1h
        I0H/Cr4rtKvz7
X-Received: by 2002:a17:906:cc85:: with SMTP id oq5mr3120803ejb.142.1592566180116;
        Fri, 19 Jun 2020 04:29:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKOezBmCA21RB4bkpAUbx0Esf7jxxGwzvG3u6+Ourw/aIp/mFzQOIEXQr09AR9vOGl8T5Zqg==
X-Received: by 2002:a17:906:cc85:: with SMTP id oq5mr3120784ejb.142.1592566179899;
        Fri, 19 Jun 2020 04:29:39 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q5sm4447074edr.21.2020.06.19.04.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 04:29:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     like.xu@intel.com, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH RFC] Revert "KVM: VMX: Micro-optimize vmexit time when not exposing PMU"
In-Reply-To: <2c7d6849-7fac-b9f6-7bcb-5509863564f3@intel.com>
References: <20200619094046.654019-1-vkuznets@redhat.com> <2c7d6849-7fac-b9f6-7bcb-5509863564f3@intel.com>
Date:   Fri, 19 Jun 2020 13:29:38 +0200
Message-ID: <87366rguot.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Xu, Like" <like.xu@intel.com> writes:

> On 2020/6/19 17:40, Vitaly Kuznetsov wrote:
>> Guest crashes are observed on a Cascade Lake system when 'perf top' is
>> launched on the host, e.g.
> Interesting, is it specific to Cascade Lake?
>

Actually no, just reproduced this on a Haswell system. If you run the
guest with "-cpu host,-pmu" and do 'perf top' (on the host) the guest
crashes immediately.

> Would you mind sharing the output of
> "cpuid -r -l 1 -1" and "cat /proc/cpuinfo| grep microcode | uniq" with us ?

Sure (this is probably unrelated because the issue also reproduces on
Haswell but still):

# cpuid -r -l 1 -1

CPU:
   0x00000001 0x00: eax=0x00050657 ebx=0x03200800 ecx=0x7ffefbff edx=0xbfebfbff

# cat /proc/cpuinfo| grep microcode | uniq
microcode	: 0x500002c

This is "Intel(R) Xeon(R) Gold 5218 CPU @ 2.30GHz"

-- 
Vitaly

