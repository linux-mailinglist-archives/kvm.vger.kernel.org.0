Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3397239B4
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733264AbfETOTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:19:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54357 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731093AbfETOTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:19:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id i3so13518700wml.4
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ma+3YbQeP6ocnNB4lBqpN5AJZ6O5XN7qaoJyz66C7OU=;
        b=ry424Kw62KU1IuD2S/qgbi+WEj7qY2bnqaLzT8UkgXu3RPaHxG+25k5rsk8hgjdEEZ
         PL0f+mRAIBypwJcuhPQ7Nzg13f7LGmWBB7kBMxGiw0v8HLZ7ic+L5mGTkklM+LJtVXUr
         CaxU5txbT6UhfyOe24k9PpPSD1A2Mgwv6KREv1VldldmRPvc5W+cZVpBoIxd6rjE+I8J
         LrDhEIpbL2LtngvfcLad1jhO8ESSto+8Ej3ImVQtHlEcnQHToG60ME5TRKeJvbpsuyun
         wIBFgRDVJxCTBixNshstF7fPcj3AHYT6CJhvED1GJTsGakHWfuu/YxfKiRtu7U7wTRsv
         muxA==
X-Gm-Message-State: APjAAAW8OXkhNQIBiBRv3R37TmqnrBfpZl1GJC0X9sWsJR475vl46Pd9
        qTWAiZPIFBneo0Eh8m79/NWUTQ==
X-Google-Smtp-Source: APXvYqxJOH7Rtlo1WiAk3z+mcx84t7B7KtLeXu7RUw2C08S4gV43Xmv4/Xo3qaQvywVBOSq3FLjKPQ==
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr12858723wmk.72.1558361962992;
        Mon, 20 May 2019 07:19:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id k184sm38811781wmk.0.2019.05.20.07.19.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:19:22 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Zero allocated pages
To:     "nadav.amit@gmail.com" <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>
References: <20190503103207.9021-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <156b4b7d-2758-9cf4-07a7-981f9d4b24d3@redhat.com>
Date:   Mon, 20 May 2019 16:19:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503103207.9021-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/19 12:32, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> For reproducibility, it is best to zero pages before they are used.
> There are hidden assumptions on memory being zeroed (by BIOS/KVM), which
> might be broken at any given moment. The full argument appears in the
> first patch commit log.
> 
> Following the first patch that zeros the memory, the rest of the
> patch-set removes redundant zeroing do to the additional zeroing.
> 
> This patch-set is only tested on x86.
> 
> v1->v2:
> * Change alloc_pages() as well
> * Remove redundant page zeroing [Andrew]
> 
> Nadav Amit (4):
>   lib/alloc_page: Zero allocated pages
>   x86: Remove redeundant page zeroing
>   lib: Remove redeundant page zeroing
>   arm: Remove redeundant page zeroing
> 
>  lib/alloc_page.c         |  4 ++++
>  lib/arm/asm/pgtable.h    |  2 --
>  lib/arm/mmu.c            |  1 -
>  lib/arm64/asm/pgtable.h  |  1 -
>  lib/virtio-mmio.c        |  1 -
>  lib/x86/intel-iommu.c    |  5 -----
>  x86/eventinj.c           |  1 -
>  x86/hyperv_connections.c |  4 ----
>  x86/vmx.c                | 10 ----------
>  x86/vmx_tests.c          | 11 -----------
>  10 files changed, 4 insertions(+), 36 deletions(-)
> 

Queued, thanks.

Paolo
