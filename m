Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5423527959B
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgIZAdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:33:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729789AbgIZAdK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:33:10 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601080389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L2svHRBQva/Nus5XSRtpGhL7T7fUDe0VOrf/F1WA0Tc=;
        b=WvHRZFzXxOtcyQl5iQyAufjbZYTXFZQTnGYSYn0Baw+dUFd67MG+F85ycQf1BEFUV2CyOA
        l6zUewQikZthrEQ64HxUMxI/1J0bQv7PzAV1cp+6wfvWs7SAYeKY286QzxDT7EA2Q9QcDH
        R+ZN9Z4vat9yH2aAIvXBlvGiElYTpms=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-WgcRtZJgMdKjp8ABgDYSdw-1; Fri, 25 Sep 2020 20:33:07 -0400
X-MC-Unique: WgcRtZJgMdKjp8ABgDYSdw-1
Received: by mail-wr1-f71.google.com with SMTP id a12so1733938wrg.13
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 17:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L2svHRBQva/Nus5XSRtpGhL7T7fUDe0VOrf/F1WA0Tc=;
        b=iZuwcYeZN52r2iLDqzO6+6VVRNn5nA2O5cxCWQqQECZ6sGtHPRnpWx/FxmCl+mWMXZ
         AsdX4q/JMWrbDoLeNDeJ9KsUBOieSCqCWZINJhatJWMblXdMtRSz7qRrk5lLg6ixN2Op
         wOFw2nGfrL0bXsRuZnAPRe1P3m8rMgRnHk9IPIaM7LUekVBRC23VckKVcz30Y/3U+uI6
         E46Gimy4ubkeIDXErScYYpW1dnPPb47I++c29UV/2b4507xvnAF65pNAN9ZO7M/ukKG6
         M7Er83Pljtk718RYIhkBYccYbWsCEGvLdf/7BljiK/kSNCwNhehZODEViCGrCbx8NfL6
         gLMg==
X-Gm-Message-State: AOAM53113S/5i+pd/og9pUNg16dnjPAG0vetBcXFFjFteHZjWjFn1CNd
        606fJepRBVdvi+/E43h8vpy6WzFVPUB5XoG1kVaUJjPiMZljusyy9fF/tlwSFgJZvVRPZt9dR4x
        ESIstM/xy5RJg
X-Received: by 2002:adf:e407:: with SMTP id g7mr6953556wrm.349.1601080386249;
        Fri, 25 Sep 2020 17:33:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOErB8p/7YPgr4TtDRkw7ALR4XUUJKDTDtDNpkAbJTRk2g4+X6ESLcxvEwumiVX0L1vmkkDg==
X-Received: by 2002:adf:e407:: with SMTP id g7mr6953541wrm.349.1601080386081;
        Fri, 25 Sep 2020 17:33:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id h17sm4946584wro.27.2020.09.25.17.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 17:33:05 -0700 (PDT)
Subject: Re: [PATCH 15/22] kvm: mmu: Support changed pte notifier in tdp MMU
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
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-16-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc3a8cb7-ea8d-9c4d-6341-95522b184a16@redhat.com>
Date:   Sat, 26 Sep 2020 02:33:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-16-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> @@ -1708,6 +1695,21 @@ static int kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  	return kvm_zap_rmapp(kvm, rmap_head);
>  }
>  
> +u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
> +{
> +	u64 new_spte;
> +
> +	new_spte = old_spte & ~PT64_BASE_ADDR_MASK;
> +	new_spte |= (u64)new_pfn << PAGE_SHIFT;
> +
> +	new_spte &= ~PT_WRITABLE_MASK;
> +	new_spte &= ~SPTE_HOST_WRITEABLE;
> +
> +	new_spte = mark_spte_for_access_track(new_spte);
> +
> +	return new_spte;
> +}
> +

And another. :)

