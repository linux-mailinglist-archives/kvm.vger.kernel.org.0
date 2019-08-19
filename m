Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC59927EA
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 17:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfHSPFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 11:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfHSPFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 11:05:20 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 83D61793FF
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 15:05:20 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id o5so5370882wrg.15
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 08:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bmeTxHw//EIz7MDBf48uvsF9/9rAGn75Ch54N3RQf+c=;
        b=S8jN60SZBCXli6SZmFJnSg1amA/wabPpGhtNfMfsB1iO91wFb4tuKgF9C7wD6e6tTg
         kxa80wYIEj763OgZLwd8q+IBk/qA1bEY+xasY+RUB6wMfgsdA+6gICWvvqaNMiplCt6M
         i9i+4d/n4axNeeagVcSVCtRuAfYrEqujYLgKISp62/imWryoZnCN+rEe1nRd0xcsBFnB
         zgE6P3R7z1mxsxHlyFjb/hXeiBitL7CoMsUTTD36usPlQla4MppAvzBhntusHGWvDJAC
         RaMTXthhKSaYepgosm/xuvbGRktnBwf0aexwQW5Cwqg7mZN+MzxhdOFIK4rAeVDUu59L
         qXdw==
X-Gm-Message-State: APjAAAW0e+SnHhhDL1hJDpvc67y/TG4WZyQG2eP/JlTga4oSl/zf+fHB
        PNRLjQYGsJSg55w9+hHc3Sc6nadWQ843zQptYW1MybpoVz0QKcapjmGzryPJUtV1dTJ8mvD7TLn
        NQ6ZM1zXbDSqc
X-Received: by 2002:adf:e78c:: with SMTP id n12mr27328054wrm.83.1566227119169;
        Mon, 19 Aug 2019 08:05:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwswmEoLm6iU6z7NMMScqjY1STar/e01s0ghk+Sod0rrzWGNQUnVO7hfMTZiHRwYAO8dTiwCw==
X-Received: by 2002:adf:e78c:: with SMTP id n12mr27328013wrm.83.1566227118905;
        Mon, 19 Aug 2019 08:05:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id l62sm13358486wml.13.2019.08.19.08.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 08:05:18 -0700 (PDT)
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e235b490-0932-3ebf-dee0-f3359216ed9f@redhat.com>
Date:   Mon, 19 Aug 2019 17:05:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814070403.6588-6-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 09:03, Yang Weijiang wrote:
> +
> +int kvm_mmu_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info,
> +			 bool mmu_locked)
> +{
> +	u32 *access = spp_info->access_map;
> +	gfn_t gfn = spp_info->base_gfn;
> +	int npages = spp_info->npages;
> +	struct kvm_memory_slot *slot;
> +	int i;
> +	int ret;
> +
> +	if (!kvm->arch.spp_active)
> +	      return -ENODEV;
> +
> +	if (!mmu_locked)
> +	      spin_lock(&kvm->mmu_lock);
> +

Do not add this argument.  Just lock mmu_lock in the callers.

Paolo
