Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF38158D8E7
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 14:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243188AbiHIMta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 08:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243172AbiHIMt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 08:49:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1BE718B30
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 05:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660049367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DGno/ZdHYbEjsqGvji74q/f8gYnG55Z5eZDKoCFKyts=;
        b=fifQhwO7j2bYA9ZyA4dmH3V3dj1o8RzMSKwRLr+6igESceX/Qq3+PhkPPO+3co5srkkQwl
        yiVMKOPIv0NRsehTJ5xlYJf4/9i0ZbfiJQu5xtBk8Y3Z9iFts2W3nK5JS164Gm3ts7kROt
        NR0q5wwI1HeVUa4IGy440NLA+P/+/90=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-W6-haLv5OjCPUKYgpGOb6g-1; Tue, 09 Aug 2022 08:49:26 -0400
X-MC-Unique: W6-haLv5OjCPUKYgpGOb6g-1
Received: by mail-ed1-f72.google.com with SMTP id s21-20020a056402521500b00440e91f30easo2044856edd.7
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 05:49:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=DGno/ZdHYbEjsqGvji74q/f8gYnG55Z5eZDKoCFKyts=;
        b=gv4zYnyQDX0HYL1xQkTp64ya0fz2UwEFtT4HtQOKCMv3s/s8GwrW+Bk568MBOGsQeV
         I56aRXhKtSvvgn100+Vv8JvLRM/yQAtKlYETh90MYrYB3G7ubzOlik1iK288vx/5A/MI
         uRevHNr1KNrx8OfZyfAgEPxZcC3DBUI3NHPlPyOZm6RDnkvBdP2IXQSc0UZM3xKwAEnV
         17MGX2tgrsQlLknMth/LdNB9df/b76XmDwiBCCI9TYLzfkz8SWv1UR+aDhVDTyujhq6U
         b5iKzn65zjdYodQtAjM0GST4uZIe1qAPVSMHLCYXwsk9AnNpsqAnZjCSlphZo8YrqnEo
         t4wg==
X-Gm-Message-State: ACgBeo2WlOPB2GbSh0N9DgmBGythadBYae8Z2MfeXrcMWKG3xEiOyUBI
        DyieOd3kR3Va3BrvZT/F0pAMV8F10BgZhTMA1dB5d+RccuRnuzrGDoTwBcEeAOlf9lfm3v5ZOKb
        fZNRi/TpBW13z
X-Received: by 2002:a17:907:97c2:b0:731:5679:2cd3 with SMTP id js2-20020a17090797c200b0073156792cd3mr7315419ejc.746.1660049364915;
        Tue, 09 Aug 2022 05:49:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7++bwrLoebRKl9hvHXUyGipQjUI6Y3jnzAeFiV80QEya367K0SYCYHRxMMXXq59qg+HFZm/w==
X-Received: by 2002:a17:907:97c2:b0:731:5679:2cd3 with SMTP id js2-20020a17090797c200b0073156792cd3mr7315402ejc.746.1660049364712;
        Tue, 09 Aug 2022 05:49:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id b9-20020a170906708900b00730a18a8b68sm1094610ejk.130.2022.08.09.05.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 05:49:24 -0700 (PDT)
Message-ID: <331dc774-c662-9475-1175-725cb2382bb2@redhat.com>
Date:   Tue, 9 Aug 2022 14:49:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-6-seanjc@google.com>
 <YvHT0dA0BGgCQ8L+@yzhao56-desk.sh.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 5/8] KVM: x86/mmu: Set disallowed_nx_huge_page in TDP
 MMU before setting SPTE
In-Reply-To: <YvHT0dA0BGgCQ8L+@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/22 05:26, Yan Zhao wrote:
> hi Sean,
> 
> I understand this smp_rmb() is intended to prevent the reading of
> p->nx_huge_page_disallowed from happening before it's set to true in
> kvm_tdp_mmu_map(). Is this understanding right?
> 
> If it's true, then do we also need the smp_rmb() for read of sp->gfn in
> handle_removed_pt()? (or maybe for other fields in sp in other places?)

No, in that case the barrier is provided by rcu_dereference().  In fact, 
I am not sure the barriers are needed in this patch either (but the 
comments are :)):

- the write barrier is certainly not needed because it is implicit in 
tdp_mmu_set_spte_atomic's cmpxchg64

- the read barrier _should_ also be provided by rcu_dereference(pt), but 
I'm not 100% sure about that. The reasoning is that you have

(1)	iter->old spte = READ_ONCE(*rcu_dereference(iter->sptep));
	...
(2)	tdp_ptep_t pt = spte_to_child_pt(old_spte, level);
(3)	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
	...
(4)	if (sp->nx_huge_page_disallowed) {

and (4) is definitely ordered after (1) thanks to the READ_ONCE hidden 
within (3) and the data dependency from old_spte to sp.

Paolo

