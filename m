Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB9D16E9D8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbgBYPSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:18:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49022 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729817AbgBYPSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 10:18:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A3UhdeKT+krjNlC+LM3bZB+rdh00isF5DS1fbUlbjE0=;
        b=dk+NOCKANhzg0WkZepYFvCYl7rOsWNGsnTEE50S1cZZiDq/XDNyou8ansPXTBrk6ciQsGd
        0wSlUsgAj+Q0R49IgReaC48aijyaZg+6D635EWpK2oIAHUiSU/AA1CybZZx/ZY7oe3kTvd
        wc88oaH8CcogusUJH5adB3ma5pl0qrQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-ygIvsOevPiqMtT5SkkNnjg-1; Tue, 25 Feb 2020 10:18:16 -0500
X-MC-Unique: ygIvsOevPiqMtT5SkkNnjg-1
Received: by mail-wm1-f70.google.com with SMTP id z7so1005936wmi.0
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 07:18:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A3UhdeKT+krjNlC+LM3bZB+rdh00isF5DS1fbUlbjE0=;
        b=VIQXFo3xiYqFG4UnLar8hYH4NM6ujbtHeh4thljf/cIk+R+JskPx2jZ/V32jIDevK6
         5ATUW85M6CPAgL9n35+8s+z5+uQCLYxSQhifu1RmCVI1wrTLyk5flOpZOz/c6fJLWqEp
         SkoTUKk7snRrxxSS4yOC0KwspEduSx77TWO1Ou/yz/BE3lgL4+VTbjHvVs41b6dxXxaI
         XLHy5P/jem0hZcPA0KXq16jWFFAuT+BRZE8v3mNjYvlMm2nY328706vDg7pQ7eMBLqRu
         vSEnqB2eL/U+6L4ehP5lqyvjuyVg/Q3U5YNbo3YLRg/59wTfFf6gk+XaDSNE2CDHjZvW
         EPYA==
X-Gm-Message-State: APjAAAULL2+CVIjMDbsL1J8InM1olqj/26tf2n1kVklbBoXniuaUuGwZ
        qNdyJ/kKmATeihLAYZqcKHWSxC8rr+4+or0H5f1bjLqNAD9O+cGfzhjSPyI7UyFRPW52lazoKDt
        BDmeMTlTwoQNz
X-Received: by 2002:a1c:a382:: with SMTP id m124mr5758518wme.90.1582643894059;
        Tue, 25 Feb 2020 07:18:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqxQ4GB2bbPWgq4zi3drCuNanKtM0d7Lh04HjmIfnH07Op+Coz/HCusYRfj4lHibPbvl/9iiKg==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr5758499wme.90.1582643893839;
        Tue, 25 Feb 2020 07:18:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id a198sm4577277wme.12.2020.02.25.07.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:18:13 -0800 (PST)
Subject: Re: [PATCH 48/61] KVM: x86: Do host CPUID at load time to mask KVM
 cpu caps
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-49-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fd7c8e54-b5e1-fa0c-02c7-d308ecfbac80@redhat.com>
Date:   Tue, 25 Feb 2020 16:18:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201185218.24473-49-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/20 19:52, Sean Christopherson wrote:
> +#ifdef CONFIG_KVM_CPUID_AUDIT
> +	/* Entry needs to be fully populated when auditing is enabled. */
> +	entry.function = cpuid.function;
> +	entry.index = cpuid.index;
> +#endif

This shows that the audit case is prone to bitrot, which is good reason
to enable it by default.

Paolo

