Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1D12B3A5
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 13:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfE0LyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 07:54:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38166 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfE0LyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 07:54:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id t5so15567082wmh.3
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 04:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P5EOrlyjnRiB+y/WPq9w3g8tKXEcoSy+dzLfiTqoBtI=;
        b=iCGoR/0Qb3kVe3NO44BNCnLj6CQpkgfSr5Lc1FHvPWEBoUf+004nYe57vU/qMViU/s
         n4jK81w0ocLIaSIuMPKXLC8Mx9IPi6fnNVORdYyTKd2Hvr2/Z64OIcA6Sv0AuNcB3ASc
         jhXlgWFCe0II9r346hzyE9XLFxwQHGPLuaL7YDNGdv8v80IwM2BNs/bm++KoRlGCAVRL
         RmaF4ZHdpdV3cKPDvz6XF2iGHwMUAwyZeTepf5OfBUNlQJUnMKC0+2q/FjknY5Ej2d+q
         BBhWNpMiwQzR1TZfzL79wodX7pLwIRM1sPmgQ8jDW71FrM0eB/2MnfC1hVW1Qz0nuOjz
         /4TA==
X-Gm-Message-State: APjAAAXbFcVHtgh0Hw1NMFAgdGmdKoszq51vRVB1UgP5Qx9b+o/A0SRW
        lP7VuGQyPllym0xEBTaCLS3pWZvxmYs=
X-Google-Smtp-Source: APXvYqxzDiEzyVy1UAaifd36atFjeFl7M914KMNNS1XYii7hm0Pb5j9z4gdY0m8pSq5ybhyLSkyCVA==
X-Received: by 2002:a1c:ed07:: with SMTP id l7mr8825437wmh.148.1558958041069;
        Mon, 27 May 2019 04:54:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c43e:46a8:e962:cee8? ([2001:b07:6468:f312:c43e:46a8:e962:cee8])
        by smtp.gmail.com with ESMTPSA id 16sm9799263wmx.45.2019.05.27.04.54.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 04:54:00 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: X86: Implement PV sched yield hypercall
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1558953255-9432-1-git-send-email-wanpengli@tencent.com>
 <1558953255-9432-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b8525d8-e26b-e4df-508d-b6a4d9c06a76@redhat.com>
Date:   Mon, 27 May 2019 13:53:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558953255-9432-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/19 12:34, Wanpeng Li wrote:
> +	rcu_read_lock();
> +	map = rcu_dereference(kvm->arch.apic_map);
> +	target = map->phys_map[dest_id]->vcpu;
> +	rcu_read_unlock();
> +
> +	kvm_vcpu_yield_to(target);

This needs to check that map->phys_map[dest_id] is not NULL.

Paolo
