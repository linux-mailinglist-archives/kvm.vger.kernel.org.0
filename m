Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D5729098B
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 18:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410733AbgJPQSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 12:18:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2410726AbgJPQSo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Oct 2020 12:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602865123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=55IofThJBGGfI7Vv9n+rH5kFo9zSb3bSZ3YPS6/pa8g=;
        b=AE022voPJzRYawmTidRcfWMYGPgr69jhjhG0Rg23oLCqLPxe2QggP41uRFybAqdkR2f2J8
        3V0IiBcAlNNPMcmenHO7iUIQbQiy7I5v2Owb6hR0l9L0Kolo+CMLvCbMo8G5IIx7Ci0gDH
        48KvoKbZOlXHfL2gdo8RnrLW6zmR+hA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-gWC0srV1PuKXY7gdTvIf6w-1; Fri, 16 Oct 2020 12:18:41 -0400
X-MC-Unique: gWC0srV1PuKXY7gdTvIf6w-1
Received: by mail-wm1-f70.google.com with SMTP id w23so894639wmi.1
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 09:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=55IofThJBGGfI7Vv9n+rH5kFo9zSb3bSZ3YPS6/pa8g=;
        b=Y21uyxRcMriSt5/0dYYOtx1reFU4oo3g/VSYQKX5S3kYkjnwcn8IQModBMDoVeePsW
         7ammxuQmS204iMBJ3JU0tx2p/LGdt9wTGYJs4Qb2aBsFibTokFAxYEp00TFL2e02qhJj
         6b9nl6n3+wkV6fcsMLeTDlFmIq7wH8220S0SiaQoXPhJDS7VJwBlRGTr3xQ84Rz5txnU
         Q5vQxOW4z9fZr7mcbDtCcYbpY/4QTwk08Zfn3l7+0b8bmELrKG8vKuM5aL6wgsB4QlQh
         isCnT5NzhL2Uc6EhYwH2Rn1I0SBIezBuXC35G2rlGf1RP0wQPIAhCVqKf+idT+8tLVLe
         CSDg==
X-Gm-Message-State: AOAM531URiRbVL93IIFQq4u5HsaNrQQgbe+8PR3T9oLHu/z1goiUhUeX
        eHPVqJmziTn/MiCnqM+x8al7tAUZGMGk/G6OdnuhUIJL0fqz+ujGF54ZtPzRbpsne2w1PA/sDAg
        AIr4hT4Rz2kuK
X-Received: by 2002:a05:6000:1d1:: with SMTP id t17mr26435wrx.164.1602865120607;
        Fri, 16 Oct 2020 09:18:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZtNUzSirPAkkrVoU2Weh+68oUbj2auD4X75K4G+0x8nXulbNuaSpOTcaEbzjCWmUvnOuMCw==
X-Received: by 2002:a05:6000:1d1:: with SMTP id t17mr26403wrx.164.1602865120335;
        Fri, 16 Oct 2020 09:18:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4e8a:ee8e:6ed5:4bc3? ([2001:b07:6468:f312:4e8a:ee8e:6ed5:4bc3])
        by smtp.gmail.com with ESMTPSA id s185sm3450892wmf.3.2020.10.16.09.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 09:18:39 -0700 (PDT)
Subject: Re: [PATCH v2 15/20] kvm: x86/mmu: Support dirty logging for the TDP
 MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20201014182700.2888246-1-bgardon@google.com>
 <20201014182700.2888246-16-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f5e558b2-dab8-ca9e-6870-0c69d683703a@redhat.com>
Date:   Fri, 16 Oct 2020 18:18:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201014182700.2888246-16-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/20 20:26, Ben Gardon wrote:
>  
> +	if (kvm->arch.tdp_mmu_enabled)
> +		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
> +				slot->base_gfn + gfn_offset, mask, true);

This was "false" in v1, I need --verbose for this change. :)

>  	while (mask) {
>  		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),

> +		spte_set = wrprot_gfn_range(kvm, root, slot->base_gfn,
> +				slot->base_gfn + slot->npages, min_level) ||
> +			   spte_set;

A few remaining instances of ||.

Paolo

