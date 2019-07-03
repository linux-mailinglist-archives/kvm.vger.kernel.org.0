Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4432B5E8C4
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 18:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfGCQ0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 12:26:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50432 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCQ0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 12:26:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id n9so2867859wmi.0
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2019 09:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j0uQRQKTOHPyvW++bkZoZSJYlgdc10E2ew9Dkx6AQzM=;
        b=l+RbfDwTosvgCH2NNYWZAGYp3DSs+hzsconIP/l1QZyj8qJG5VDftyNmQYD50k2PUw
         hDTM8nAq5ye7zqRmHRNThETy8cHpJES5wIeuFJ+rQdJzqnlivS8beAOqLL83kUMi5bIa
         H/eFJ76MEm7STSLBzevniz36zPZIeq8of2aZmjs4AeQyeMs7IKbFyWAFsavaPtfkI1fy
         JlCrndLHPyYIsDb8f/NlWsjZC7lGAzhrQc1gPXm9d6uoSiKjqUvpwQkk+BQzi3YKeahB
         6CBiwc81MzYTRnD3OmTjKojBc5q1bs2gghRtNwC8KC1P2ImXtdkCxVg0SuOg/ZyRGUpX
         yAJg==
X-Gm-Message-State: APjAAAUJrgG9u9gWCnK3B+LxQ1ayPrVCiWS9lURkb24/hzSwg3m7jF1z
        7ssQqzk/hnGZ9InPQ5l/YBDguw==
X-Google-Smtp-Source: APXvYqypcIe+Lp1N6JnMUycjOTqMPC65guVqIADpiZsYa4a0AtGoL+IeIfdUyq7itqBmG+HNyDsFsg==
X-Received: by 2002:a1c:343:: with SMTP id 64mr9106444wmd.116.1562171190283;
        Wed, 03 Jul 2019 09:26:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6c1d:63cc:b81d:e1a9? ([2001:b07:6468:f312:6c1d:63cc:b81d:e1a9])
        by smtp.gmail.com with ESMTPSA id l8sm5392733wrg.40.2019.07.03.09.26.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:26:29 -0700 (PDT)
Subject: Re: [PATCH 0/4] kvm: x86: introduce CONFIG_KVM_DEBUG
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn
References: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b4c7169-1f3b-af5e-fb89-52f7d9363a6c@redhat.com>
Date:   Wed, 3 Jul 2019 18:26:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/19 08:21, Yi Wang wrote:
> This series introduce CONFIG_KVM_DEBUG, using which we can make
> the invoking *_debug in KVM simly and uniform.
> 
> FYI: the former discussion can been found in:
> https://www.spinics.net/lists/kvm/msg187026.html

Basically everything except MMU_DEBUG can just be deleted, they are
little more than debugging printk that were left in the code.

For MMU_DEBUG, the way to go is to add more tracepoints, but then
converting all pgprintk occurrences to tracepoints would be wrong.  You
can only find the "right" tracepoints when debugging MMU code.  I do
have a couple patches in this area, I will send them when possible.

Paolo

> Yi Wang (4):
>   kvm: x86: Add CONFIG_KVM_DEBUG
>   kvm: x86: allow set apic and ioapic debug dynamically
>   kvm: x86: replace MMU_DEBUG with CONFIG_KVM_DEBUG
>   kvm: x86: convert TSC pr_debugs to be gated by CONFIG_KVM_DEBUG
> 
>  arch/x86/kvm/Kconfig  |  8 ++++++++
>  arch/x86/kvm/ioapic.c |  2 +-
>  arch/x86/kvm/lapic.c  |  5 ++++-
>  arch/x86/kvm/mmu.c    |  5 ++---
>  arch/x86/kvm/x86.c    | 18 ++++++++++++------
>  5 files changed, 27 insertions(+), 11 deletions(-)
> 

