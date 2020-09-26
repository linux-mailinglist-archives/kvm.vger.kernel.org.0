Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB162795A8
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgIZApN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:45:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729475AbgIZApN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 20:45:13 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601081111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=THB7IC/JWhxZevRd2onFndLEn2GCtRvU8MFtJ3qjSYk=;
        b=H+8QpMCFHc4qnaM3xh7NbNOeRuCxPh3VIE+BT0Zb7epvQqSMhvEwv/jjP4VHxe4fkIMADS
        Y2l4vQLiLzxsAG+Xn55tbCIRvVWJKeBhZNepqhTs6L70EYZMCNqftBoyrl19Juz9hfGak8
        LdRWdwzqBZkvAzc8hj6RGx5c+aDdKoo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-DjsIHTwrNpemvRBGFVYPcA-1; Fri, 25 Sep 2020 20:45:09 -0400
X-MC-Unique: DjsIHTwrNpemvRBGFVYPcA-1
Received: by mail-wm1-f70.google.com with SMTP id r10so256034wmh.0
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 17:45:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=THB7IC/JWhxZevRd2onFndLEn2GCtRvU8MFtJ3qjSYk=;
        b=J3hQurox+LtYo/pcaHeGQreqRmBTFS8/lkuAGutAguV9QUO1DRMHqXf3orZRF4Fqk1
         yhoSbiM9RydLDH4m/2WoxjDWAIbcBIMFrAWBf9xraezggfBEgjl0P8UimSrK2Q0MuQSv
         /eTCjETFJweIcVFC7pcINa7TneEqQanJ3sC+FmHDAFYHj09AHS91IqdspFMrytjvxN4D
         CvTWy5ANjyS+14MOjNg7CVOwqqcHpYVR97uK+WF1xizVfN7XJfll8484ABqDKcNt0qqL
         NhPEmAD6Rc/84qUnSl6I8iqLzSS+H8IX4PekEc9kNkTnRESKoem2+zC73duTr5MuJ1kD
         CTrQ==
X-Gm-Message-State: AOAM5314+26KqYiluvuvC/tlr7jtVqkcE9zQIM+PT+5ZfkSAN4xXDODs
        18EXiQA8IQE3dXpjIobTexCJT1RgyAYlK5B+Qz9T+74wdCJj2VmOyqpky55x6YaSUsceZTY7aTC
        SLJ7eKSDi3G9I
X-Received: by 2002:a1c:2441:: with SMTP id k62mr182089wmk.178.1601081108522;
        Fri, 25 Sep 2020 17:45:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwOlCh16r0w3UJihzxNZ1L5h4HpPuJBkBWo8IJxIE8xjzCY31gEUpQlISn1MAUg/RpixsgUw==
X-Received: by 2002:a1c:2441:: with SMTP id k62mr182070wmk.178.1601081108327;
        Fri, 25 Sep 2020 17:45:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id q15sm4636631wrr.8.2020.09.25.17.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 17:45:07 -0700 (PDT)
Subject: Re: [PATCH 16/22] kvm: mmu: Add dirty logging handler for changed
 sptes
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
 <20200925212302.3979661-17-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c7745e5b-767a-01ce-23db-076df8160ddd@redhat.com>
Date:   Sat, 26 Sep 2020 02:45:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925212302.3979661-17-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 23:22, Ben Gardon wrote:
> +static void handle_changed_spte_dlog(struct kvm *kvm, int as_id, gfn_t gfn,
> +				    u64 old_spte, u64 new_spte, int level)
> +{
> +	bool pfn_changed;
> +	struct kvm_memory_slot *slot;

_dlog is a new abbreviation... I think I prefer the full _dirty_log,
it's not any longer than _acc_track.

I wonder if it's worth trying to commonize code between the TDP MMU,
mmu_spte_update and fast_pf_fix_direct_spte.  But that can be left for
later since this is only a first step.

Paolo

