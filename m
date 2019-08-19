Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C73F9275E
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 16:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfHSOqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 10:46:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfHSOqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 10:46:53 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2155B7BDB6
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 14:46:53 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id b1so5368766wru.4
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 07:46:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eTAKwnUWv77j3jpgf1dY2BGrKvsemf3lKryFUSYGVp8=;
        b=FRGPEGgnTWb9J8hoVboowtfHal7Abp8sn0p9OVr/N3+vSTsONj8f2SfiVsmDQ8xLL6
         PTCsyxxTGvYxRVFI5fzEkoNJY8uANiOyOZuTGmvsXRKfORcZrDJ3kPHSRi/wCSCNygmv
         T6FWh0vamzHp4CP1rsZyDsiOAUbcNUra9SED9MRE5KGPBKRYBir5QMY7UTN82jkOiSMi
         HKw5aWkay6FAjQKD1rgA4YMsrFia7RxYmS3TQ/TCsTsQzmgfgm5JXrqh1plJfH2cYbQn
         IGKXGTxizxDbXDJzbS1tOWM01kZzybEg5SMVR11jonSkBBeAfqcypYMBj99nI3Y9708e
         snwQ==
X-Gm-Message-State: APjAAAUhPRnXhdS1etl3Dwc8kzmQC8QwReFBjKWdHInwM7nm6vBW51zT
        CrR02pnkkdElNdg/vqmqMc40tfCeLWvSGTxKW8q0c18iJ3NCRKrNkGvmXKQuZo4AbkjbisjavYg
        h/i00UDPY9mFZ
X-Received: by 2002:a1c:a80a:: with SMTP id r10mr11865999wme.103.1566226011766;
        Mon, 19 Aug 2019 07:46:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw5wmYrUldf5g0ppZ7OXdDZ2F/3C6VWfdEi/LkIbuWOQoIu7FObZ7g0uK2YnFjnL/LNfQeVcg==
X-Received: by 2002:a1c:a80a:: with SMTP id r10mr11865952wme.103.1566226011502;
        Mon, 19 Aug 2019 07:46:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id c201sm29402270wmd.33.2019.08.19.07.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:46:51 -0700 (PDT)
Subject: Re: [PATCH RESEND v4 8/9] KVM: MMU: Enable Lazy mode SPPT setup
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-9-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <63f8952b-2497-16ec-ff55-1da017c50a8c@redhat.com>
Date:   Mon, 19 Aug 2019 16:46:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814070403.6588-9-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 09:04, Yang Weijiang wrote:
> +
> +	if (vcpu->kvm->arch.spp_active && level == PT_PAGE_TABLE_LEVEL)
> +		kvm_enable_spp_protection(vcpu->kvm, gfn);
> +

This would not enable SPP if the guest is backed by huge pages.
Instead, either the PT_PAGE_TABLE_LEVEL level must be forced for all
pages covered by SPP ranges, or (better) kvm_enable_spp_protection must
be able to cover multiple pages at once.

Paolo
