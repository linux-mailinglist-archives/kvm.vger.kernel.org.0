Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B15A5EF955
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbiI2Pnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235670AbiI2PnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:43:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3CE128A17
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664466124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AOs9j6EKBWVbeXkdg2VQcpSwEuz7CVtI8gZySG/+hp4=;
        b=M+Fw2qRG4cZC8Ov+dNvz12/Iyzr+cMDVdIqLumsgKFa8oqTd+7OTweFVEHgyQukPIlTFkc
        sjEkN+IgN4h3TgZ0edCfuriRLhCcGxiClLtQaA1J/1+HCTyNWjGO1xU36APWMHZPb8WK2y
        zS2NSgGbn57VmljgnzoRInAGHKyDr+w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-HwWa1l9gMDyI-EONDlLtew-1; Thu, 29 Sep 2022 11:42:03 -0400
X-MC-Unique: HwWa1l9gMDyI-EONDlLtew-1
Received: by mail-ed1-f71.google.com with SMTP id f10-20020a0564021e8a00b00451be6582d5so1572290edf.15
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=AOs9j6EKBWVbeXkdg2VQcpSwEuz7CVtI8gZySG/+hp4=;
        b=M8O6FGT7BDiAQszMWvs56MJcMx8Ee1jfaGqq/JxBfx5Jri9EpdeMlaO/8NP8l4WRd4
         pV1bYMgweiaH5V//f+eex5aix7JsvUIzFQrohP875QiQ9agij6simQIbZgy4sToxNrci
         fsJ5SMF9XFquWkUX34Vd+s8wEe+ojVe0YLyRU5sXXCzRIJwK01vmAbxiFqghVeHY88LK
         9PZIlW9J6egJeixAQqylVFVv4xkii2Cm1mqbK7Q7a49xnpAlS+Pfx1LdL1vYchkBWfnH
         gWEnRKCZO71w+CIR5jfY/zhZwp2VVafFDKZFpro0mQLyKtJ1Zbfx0KrhltHNwAKWesd4
         anfQ==
X-Gm-Message-State: ACrzQf3OMakTbEPAo1MTPRWsSJFZ0UxoG0oecRnZYvqKT6D8K1q9kIZf
        Vz3XI435WFQZoOWR/ZHTccmpWPLukPkhbp3t1Rl3ca4R8L4MFF7+L49RVudLeMY9dWDeqfcOhbz
        uLZ47EIex9N8g
X-Received: by 2002:a17:906:ee86:b0:741:89bc:27a1 with SMTP id wt6-20020a170906ee8600b0074189bc27a1mr3298334ejb.725.1664466122060;
        Thu, 29 Sep 2022 08:42:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ZN9if01aUOq3bhS/GofCuFW4G12pkPcLFKXn1n96bCMOjelB6Gu6laZwmcmKakTUeYZixOA==
X-Received: by 2002:a17:906:ee86:b0:741:89bc:27a1 with SMTP id wt6-20020a170906ee8600b0074189bc27a1mr3298314ejb.725.1664466121822;
        Thu, 29 Sep 2022 08:42:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id x2-20020a1709060ee200b0073dde62713asm4159050eji.89.2022.09.29.08.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 08:42:00 -0700 (PDT)
Message-ID: <5a352ff5-5d37-e92d-3d4b-c70a5d11c41b@redhat.com>
Date:   Thu, 29 Sep 2022 17:41:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
 <YzRvMZDoukMbeaxR@google.com>
 <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
 <YzSxhHzgNKHL3Cvm@google.com>
 <637e7ef3-e204-52fc-a4ff-1f0df5227a3e@redhat.com>
 <YzW3VxqZTb2hnXCy@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
In-Reply-To: <YzW3VxqZTb2hnXCy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/22 17:18, Sean Christopherson wrote:
> IMO, KVM_MEM_DISABLED or similar is the way to go.  I.e. formalize the "restart
> page faults" semantics without taking on the complexity of batched updates.

If userspace has to collaborate, KVM_MEM_DISABLED (or KVM_MEM_USER_EXIT 
would be a better name) is not needed either except as an optimization; 
you can just kick all CPUs unconditionally.

And in fact KVM_MEM_DISABLED is not particularly easy to implement 
either; in order to allow split/merge it should be possible for a new 
memslot to replace multiple disabled memslots, in order to allow 
merging, and to be only partially overlap the first/last disabled 
memslot it replaces.

None of this is allowed for other memslots, so exactly the same metadata 
complications exist as for other options such as wholesale replacement 
or batched updates.  The only semantics with a sane implementation would 
be to destroy the dirty bitmap of disabled memslots when they are 
replaced.  At least it would be possible for userspace to set 
KVM_MEM_DISABLED, issue KVM_GET_DIRTY_LOG and then finally create the 
new memslot.  That would be _correct_, but still not very appealing.

I don't exclude suffering from tunnel vision, but batched updates to me 
still seem to be the least bad option.

Paolo

