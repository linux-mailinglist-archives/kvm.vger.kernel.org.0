Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AC062E164
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 17:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbiKQQT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 11:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240147AbiKQQTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 11:19:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23FA73B8A
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668701884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jmt4crieJ53vJFGSwDpL91h5KYtfGELIvaDY4/Yjn7Q=;
        b=StikZgyIUZmGBtEfI0zEhUxDDlNWMteqlqu8asRgRydgl2L8woYuBW1knwmDuKHEnc7ITr
        S2PjH1JpH5aUvwPHSgJQBS6sen1krV9VnCR6qxO3JE7fmmQncFj6XPI7ueNT+r6z6sIIW6
        zABTvK0/sHrwIXpnP3Vyqr1hlCjeqrs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-49-PGE4Hw-lPUKsMCEA3aGSfQ-1; Thu, 17 Nov 2022 11:18:02 -0500
X-MC-Unique: PGE4Hw-lPUKsMCEA3aGSfQ-1
Received: by mail-ed1-f72.google.com with SMTP id l18-20020a056402255200b004633509768bso1519584edb.12
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:18:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmt4crieJ53vJFGSwDpL91h5KYtfGELIvaDY4/Yjn7Q=;
        b=sWnG1+TECyC+x2byR7wwUB5uOcbPZeRR5Sxg2O4wmhhStI+qcGFPgP571VlmgKnG1Z
         WB+PfouncCIWNqa4HaZdgv/3VBtodSa7YG5f2MmVGwo6GinQPZ2ap1g6KSbOSALBX1lt
         rBOtVVaJMoXfeUnWzKgKLKdLDuOE/BZj1M9y3sA2FGuCSed1KepfIpYUeYcy8TQbbyrb
         S0zyJD6rRWZGkp3Yh9HijL17hmQkQO3xHV1iDz7MBiSRZpP6vDqIrc5kYBWFDu8FboT3
         NIws0fCyAkfBbmpvJSGl+kjQyFsUEY/Jk3bwL8/xVw/mJgdeqUffvwolgtj11DBGV8HB
         lANw==
X-Gm-Message-State: ANoB5pmYG9bMgeAWYNrC6HNObYGNX5Ai6osD0wNy+Tnh/YWb4R1D8IgK
        lFny1axCYSHys2SQcD7to2nikB7ejMh1TzavEotiMeKqIZoKxUZ+X4AwQ+XY56oKfXFN3bZMnsG
        Lwy/hX33ItIMv
X-Received: by 2002:a17:906:35d5:b0:7ad:aeda:f814 with SMTP id p21-20020a17090635d500b007adaedaf814mr2854525ejb.441.1668701880054;
        Thu, 17 Nov 2022 08:18:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6HggCEIqF2hQe746UTIOxh6433msN0MS/rg8TuVAlTAQD0R9KQg3aYDF70NRyqHbSO9LrprQ==
X-Received: by 2002:a17:906:35d5:b0:7ad:aeda:f814 with SMTP id p21-20020a17090635d500b007adaedaf814mr2854506ejb.441.1668701879782;
        Thu, 17 Nov 2022 08:17:59 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id s8-20020aa7cb08000000b00461b169c02csm708543edt.91.2022.11.17.08.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 08:17:59 -0800 (PST)
Message-ID: <c1d640a1-1ccf-87a8-1acc-1abf9f76d006@redhat.com>
Date:   Thu, 17 Nov 2022 17:17:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3 2/2] KVM: x86/mmu: Split huge pages mapped by the TDP
 MMU on fault
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
References: <20221109185905.486172-1-dmatlack@google.com>
 <20221109185905.486172-3-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221109185905.486172-3-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/22 19:59, David Matlack wrote:
> Eager page splitting remains beneficial for write-heavy workloads, but
> the gap is now reduced.
> 
>               | Config: ept=Y, tdp_mmu=Y, 100% writes         |
>               | Iteration 1 dirty memory time                 |
>               | --------------------------------------------- |
> vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
> ------------ | -------------- | ------------- | ------------ |
> 2            | 0.317710329s   | 0.296204596s  | 0.058689782s |
> 4            | 0.337102375s   | 0.299841017s  | 0.060343076s |
> 8            | 0.386025681s   | 0.297274460s  | 0.060399702s |
> 16           | 0.791462524s   | 0.298942578s  | 0.062508699s |
> 32           | 1.719646014s   | 0.313101996s  | 0.075984855s |
> 64           | 2.527973150s   | 0.455779206s  | 0.079789363s |
> 96           | 2.681123208s   | 0.673778787s  | 0.165386739s |
> 
> Further study is needed to determine if the remaining gap is acceptable
> for customer workloads or if eager_page_split=N still requires a-priori
> knowledge of the VM workload, especially when considering these costs
> extrapolated out to large VMs with e.g. 416 vCPUs and 12TB RAM.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>

Queued this one, patch 1 does not apply anymore.

Thanks,

Paolo

