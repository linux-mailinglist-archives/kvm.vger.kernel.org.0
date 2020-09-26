Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF012795A1
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgIZAkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:40:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729475AbgIZAkG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:40:06 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601080805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RLfhd/5bYRV/vkTpgR+bbr7PSmMvVl3Y9TGL5mOHg5U=;
        b=UI/ScXlYHmLmfwTgipE4cuPni7APJ3Gd1Eiuw1TYwz1+RLATm9D2iWk3QzBOcBoE893eGd
        uV9cPxkTqM53IE3Q6HziUqhv8qtWoNls8j6ACvwe8/Xcp+9RKmBCvEYSBq5P0B4o5zESRz
        B3rhozlvIYJ8JYs0NRMcsebGkRJ/jj0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-BdSnS-O6MOmF_Zt2ti8JqQ-1; Fri, 25 Sep 2020 20:40:03 -0400
X-MC-Unique: BdSnS-O6MOmF_Zt2ti8JqQ-1
Received: by mail-wr1-f71.google.com with SMTP id a12so1740768wrg.13
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 17:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RLfhd/5bYRV/vkTpgR+bbr7PSmMvVl3Y9TGL5mOHg5U=;
        b=LhUN2nrxlb8oeSGwo+INZdCrje+GVQZOjfpcBzycFcKcHkMwG12zMdO+5D15BM34Hb
         qyzbcu6+y3poajydr9+2U/kTjdm/Uf3QVdvXIGxIt1ba4Rsc31R7kl6/ORs5FH2QwBag
         LOx0krLphoGoinDflwW2FCfnlGjiK9kOa0Uc2G0Z5WZXA4x0KvcZFX0UQp8LE8QndWN/
         /JmeT5/fy5/qa9vkrbjLUiGxAe12MlmmBJdNrYPWPgtVkB5wi041UjxsB1A9YjnOka03
         VZaBir5ysXSz78PJvDzKwUXnuLokzk7znTLSAL0ZCQnc+ITkKw/AHuLK4xqKqgy//kOq
         QWdA==
X-Gm-Message-State: AOAM5319oMehidMSouakzzoqAEMTr2jJXxlbcTP+cAp/DWsUjBxSej50
        EzV2rzLSIHwVWPr2qZ11R0P+NgI2lDDkl2Ec2ogFzWi4b6ocFUtKvJH4gkmb3G43lFwAVrf0Ihl
        Afcw5WmNYsFtp
X-Received: by 2002:a5d:4a49:: with SMTP id v9mr7634159wrs.153.1601080801966;
        Fri, 25 Sep 2020 17:40:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHVWQSJ1v4AGxHT4u44l41ZXAB2w95dcVabmJ55wOBlgzpdmrSnQQrWcTxaNhMjPC3Msp4Uw==
X-Received: by 2002:a5d:4a49:: with SMTP id v9mr7634149wrs.153.1601080801772;
        Fri, 25 Sep 2020 17:40:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id d2sm4665022wro.34.2020.09.25.17.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 17:40:00 -0700 (PDT)
Subject: Re: [PATCH 05/22] kvm: mmu: Add functions to handle changed TDP SPTEs
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
 <20200925212302.3979661-6-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <af1045cb-2e53-4967-831c-5375ef1c97a2@redhat.com>
Date:   Sat, 26 Sep 2020 02:39:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-6-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> +
> +	/*
> +	 * Recursively handle child PTs if the change removed a subtree from
> +	 * the paging structure.
> +	 */
> +	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
> +		pt = spte_to_child_pt(old_spte, level);
> +
> +		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> +			old_child_spte = *(pt + i);
> +			*(pt + i) = 0;
> +			handle_changed_spte(kvm, as_id,
> +				gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
> +				old_child_spte, 0, level - 1);
> +		}

Is it worth returning a "flush" value to the caller, to avoid multiple
kvm_flush_remote_tlbs_with_address when e.g. zapping a 3rd-level PTE?

Also I prefer if we already include here a "stupid" version of
handle_changed_spte that just calls __handle_changed_spte.  (If my
suggestion is accepted, handle_changed_spte could actually handle the
flushing).

Paolo

> +
> +		kvm_flush_remote_tlbs_with_address(kvm, gfn,
> +						   KVM_PAGES_PER_HPAGE(level));
> +
> +		free_page((unsigned long)pt);
> +	}

