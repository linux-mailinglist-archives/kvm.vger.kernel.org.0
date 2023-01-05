Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534D365F76F
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 00:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbjAEXDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 18:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjAEXD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 18:03:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB9A671A8
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 15:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672959762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rX5uF/mXp9psyq5I2gcorWzyzTk5LRT7WAPFOWecXkU=;
        b=bSQQLgFL7EMnFT7dV5a1/gfDOmasfu5fL68+PO3FKZC/zrsZIbWl87JWeDux9ueB8Sn3To
        QRqg1CTHFL/65a5ilWPk2JPmTflgGzm1KctIg4tmiYwc0WY2jrJZEDeFSzGbOqxaB5PFCn
        I/3bCeCgSOmzJ4AP6WtZGh1l1Z1vtJg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-116-FaFT6t7rPKWmtQw-zwJ-9w-1; Thu, 05 Jan 2023 18:02:41 -0500
X-MC-Unique: FaFT6t7rPKWmtQw-zwJ-9w-1
Received: by mail-ed1-f69.google.com with SMTP id b16-20020a056402279000b0046fb99731e6so68340ede.1
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 15:02:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rX5uF/mXp9psyq5I2gcorWzyzTk5LRT7WAPFOWecXkU=;
        b=htP4IZ6Feo5IyEQDWCrHECY61MJORyUTv+ZAvPm/7kZjk8FS8WwpITM5QwyHvNdZqH
         k80SDzEPdYvad/BFEWHbeAFbWa8RcBeXkxk4k7+liv9PpxQ/jo+cn/7YEdvJqdI2ES7E
         f2ZubJyFXE/LZsDrCnOGhFBv1qGiYDt+yASSGAEnCAMNryTINvaxOSVVfPSgrKJp5gUW
         C52qQ9Tz/oQb6nmY15w362CAfFPetBvNXg8+qJZkfHjNzi3E4Pffi98Jr1pOGfKDDrmN
         cDKBxieyHKGroyNo3O36+X2CH57UmHXfghCphzT0mdwZgyvgO+uE9NKYQaB7gHyCY8Gx
         sxQg==
X-Gm-Message-State: AFqh2kpemn38l99jVimRzsgjdp9BVCgQsfIvoAb7XJOBDAZU1bYBsGOu
        ufEb+NV4fihL/9icU6Kq6WgaWXDNgVeHlXdjr6bfcFkHkmObgvr5SozphMD3nTVWQJVdP3MmOvY
        FFb1PXkJ/Fyxs
X-Received: by 2002:a17:907:b686:b0:7c1:7c3a:ffba with SMTP id vm6-20020a170907b68600b007c17c3affbamr50931596ejc.35.1672959759812;
        Thu, 05 Jan 2023 15:02:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvejNE/ASmvPQcZvxGCabtfNFy4CnjBpCgTVyy6Bg5KekpdhYpxpnjGVr6MW8NYQn88z2zggQ==
X-Received: by 2002:a17:907:b686:b0:7c1:7c3a:ffba with SMTP id vm6-20020a170907b68600b007c17c3affbamr50931582ejc.35.1672959759542;
        Thu, 05 Jan 2023 15:02:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id bo6-20020a0564020b2600b0048ca2b6c370sm6377299edb.29.2023.01.05.15.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 15:02:38 -0800 (PST)
Message-ID: <3a4ab7b0-67f3-f686-0471-1ae919d151b5@redhat.com>
Date:   Fri, 6 Jan 2023 00:02:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
To:     Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     dwmw2@infradead.org, kvm@vger.kernel.org, paul@xen.org
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co> <20221229211737.138861-2-mhal@rbox.co>
 <Y7RjL+0Sjbm/rmUv@google.com> <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
 <Y7dN0Negds7XUbvI@google.com>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y7dN0Negds7XUbvI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/23 23:23, Sean Christopherson wrote:
> Ha!  Case in point.  The aforementioned Xen code blatantly violates KVM's locking
> rules:
> 
>    - kvm->lock is taken outside vcpu->mutex

Ouch yeah, that's not salvageable.  Anything that takes kvm->lock inside 
kvm->srcu transitively has to be taking kvm->lock inside vcpu->mutex as 
well.

In abstract I don't think that "vcpu->mutex inside kvm->lock" would be a 
particularly problematic rule; kvm->lock critical sections are much 
shorter than vcpu->mutex which covers all of KVM_RUN for example, and 
that hints at making vcpu->mutex the *outer* mutex.  However, I 
completely forgot the sev_lock_vcpus_for_migration case, which is the 
exception that... well, disproves the rule.

Fortunately, it's pretty easy to introduce a new lock just for xen.c and 
revert the docs patch.

Paolo

