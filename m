Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953EB23E5F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392860AbfETRXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 13:23:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44316 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392853AbfETRXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 13:23:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id w13so4759790wru.11
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 10:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5IBTHlLWle5UHeHtFTJc2+zC+bcnwX/bM8+GOzR3AZs=;
        b=dMSUtjtjUUIz5vsZd9wuJJMLKYDugMbYoJoJqvPJvXpWu8sEkvE5n4mG29UdVTm1yl
         qzWGZiFCZUZtnTUgP1ljZH56ymflk57dKvgzLTA0xGv+jrmpeUMbFQGxknpkaKdEZG0+
         9xU3nyd8ZnZNAocF46kb2VSVSqfh/IYPmonC5rnf/QB0YqEfz2QMOiycB31lfI0kKuJP
         5M1lkJHDxnZzw+K94aLtsnOOBgGuC8exAO4AluClm1MvtawiLKWYIrNk4ZpacmQqFxlu
         A5PNtGON0SbnLoJNuUExu3abM/FMvflM2JnlcO8SMo7i4sE7IzH1IPFL2COLmkgOsSGi
         Qhdw==
X-Gm-Message-State: APjAAAXtj8cF+rBMbxjo/5j9RKh8OjExC649Fm1eWby/eM6ihXMfWxBJ
        8TgbbeVEoDbA/fdyIivvQo0BTw==
X-Google-Smtp-Source: APXvYqyMHAUocoJjg+Rd0QCpMErsETkEHHPCbpKrDtr/Wh2IbPJRUt3kGmDTQyjsfGosb8vnh6kVmw==
X-Received: by 2002:a5d:53c8:: with SMTP id a8mr10808166wrw.152.1558373024313;
        Mon, 20 May 2019 10:23:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id x6sm27281408wru.36.2019.05.20.10.23.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 10:23:43 -0700 (PDT)
Subject: Re: [PATCH RESEND] kvm: make kvm_vcpu_(un)map dependency on
 CONFIG_HAS_IOMEM explicit
To:     Michal Kubecek <mkubecek@suse.cz>, kvm@vger.kernel.org
Cc:     Radim Krcmar <rkrcmar@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        linux-kernel@vger.kernel.org
References: <20190520164418.06D1CE0184@unicorn.suse.cz>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41adfaf7-90e8-b011-2716-ea5dc464ae5a@redhat.com>
Date:   Mon, 20 May 2019 19:23:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520164418.06D1CE0184@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 18:44, Michal Kubecek wrote:
> Recently introduced functions kvm_vcpu_map() and kvm_vcpu_unmap() call
> memremap() and memunmap() which are only available if HAS_IOMEM is enabled
> but this dependency is not explicit, so that the build fails with HAS_IOMEM
> disabled.
> 
> As both function are only used on x86 where HAS_IOMEM is always enabled,
> the easiest fix seems to be to only provide them when HAS_IOMEM is enabled.
> 
> Fixes: e45adf665a53 ("KVM: Introduce a new guest mapping API")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---

Thank you very much.  However, it's better if only the memremap part is
hidden behind CONFIG_HAS_IOMEM.  I'll send a patch tomorrow and have it
reach Linus at most on Wednesday.

There is actually nothing specific to CONFIG_HAS_IOMEM in them,
basically the functionality we want is remap_pfn_range but without a
VMA.  However, it's for a niche use case where KVM guest memory is
mmap-ed from /dev/mem and it's okay if for now that part remains
disabled on s390.

Paolo
