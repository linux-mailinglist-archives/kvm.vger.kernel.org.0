Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3723662E25B
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 17:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbiKQQ6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 11:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239950AbiKQQ6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 11:58:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5393668C6D
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668704224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=73VEtBq71HyLWQDeQR9jJb23qBAozZleXBvzHNuzpQk=;
        b=Ed/eTm5agXDhlvPjx1btdJVUcOTUkPSEXSXxn7lez2mtmXyZJWTr4wBBldsZTvr3X5hhXS
        IpsOpW52wkWAwXu1xaHxKdjNBtHz0o/0PlrxFYWuCj8mqkm/4S/hEzh0sVL18R7Pxw/+xl
        daWMKPe/bINA4TMLcifvONvdc/zFAHY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-U_7OsfKWPU6YUGG4bHzBDw-1; Thu, 17 Nov 2022 11:57:03 -0500
X-MC-Unique: U_7OsfKWPU6YUGG4bHzBDw-1
Received: by mail-ej1-f70.google.com with SMTP id sg37-20020a170907a42500b007adaedb5ba2so1430455ejc.18
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:57:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73VEtBq71HyLWQDeQR9jJb23qBAozZleXBvzHNuzpQk=;
        b=2a0mQHBKQuZKvvixTT8jDcLTfBqlL8rVhr6l3rcqdkQd30Zj9XWr5R9hl30E7ZgcBk
         icgmuMmjZBm8Mc8aGiJb+y0Me5O2tRjjE7jxDkO0Yb3YcuIVQXZChzzdsiPWFCYz3DWU
         8Fiub8HefwCA85TQtk+RLE2C56/22xF4HynjHM3sTN8oBePBkf7SaapccdX4L7GkOXSq
         iVHg2TrBIdqdw+5QwUGP4+MWtT32wWgHjayuaKdhdlrY1UJ1/ZzPeR3w5YLAB7p7awCD
         XXOfOEp7YJ6Q5UIN32y4G8afBy55WQZAYize7kg1TXI+MfNt6zNmmaSbIr+51ivVpj1E
         o40A==
X-Gm-Message-State: ANoB5plp8Y+PbLIbiehxxmurKPeyD1ztmpxgRFaOBjjc4JUs6bWcRxgS
        rGlodmIQMJanvy1Hd9kfFbL2plkG/Wc+LyzIy1LGRp1n/jk9ugJ04OMHNyqqp4bjIhRsqNkTQp3
        omUf7sclh50ZR
X-Received: by 2002:a05:6402:702:b0:461:ed76:cb42 with SMTP id w2-20020a056402070200b00461ed76cb42mr2994187edx.229.1668704221968;
        Thu, 17 Nov 2022 08:57:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5/A8mk3TSv/fHOqrDMtT8FRBRgQ6qe6vXoryzK/SC2PGvZXnGmBHxbAzIxJIN2Rvfx5trzZQ==
X-Received: by 2002:a05:6402:702:b0:461:ed76:cb42 with SMTP id w2-20020a056402070200b00461ed76cb42mr2994173edx.229.1668704221744;
        Thu, 17 Nov 2022 08:57:01 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id o5-20020a1709062e8500b00779a605c777sm580784eji.192.2022.11.17.08.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 08:57:01 -0800 (PST)
Message-ID: <323bc39e-5762-e8ae-6e05-0bc184bc7b81@redhat.com>
Date:   Thu, 17 Nov 2022 17:57:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
References: <20221103204421.1146958-1-dmatlack@google.com>
 <Y2l247/1GzVm4mJH@google.com>
 <d636e626-ae33-0119-545d-a0b60cbe0ff7@redhat.com>
 <Y3ZjzZdI6Ej6XwW4@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Do not recover dirty-tracked NX Huge
 Pages
In-Reply-To: <Y3ZjzZdI6Ej6XwW4@google.com>
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

On 11/17/22 17:39, Sean Christopherson wrote:
> Right, what I'm saying is that this approach is still sub-optimal because it does
> all that work will holding mmu_lock for write.
> 
>> Also, David's test used a 10-second halving time for the recovery thread.
>> With the 1 hour time the effect would Perhaps the 1 hour time used by
>> default by KVM is overly conservative, but 1% over 10 seconds is certainly a
>> lot larger an effect, than 1% over 1 hour.
> 
> It's not the CPU usage I'm thinking of, it's the unnecessary blockage of MMU
> operations on other tasks/vCPUs.  Given that this is related to dirty logging,
> odds are very good that there will be a variety of operations in flight, e.g.
> KVM_GET_DIRTY_LOG.  If the recovery ratio is aggressive, and/or there are a lot
> of pages to recover, the recovery thread could hold mmu_lock until a reched is
> needed.

If you need that, you need to configure your kernel to be preemptible, 
at least voluntarily.  That's in general a good idea for KVM, given its 
rwlock-happiness.

And the patch is not making it worse, is it?  Yes, you have to look up 
the memslot, but the work to do that should be less than what you save 
by not zapping the page.

Perhaps we could add to struct kvm a counter of the number of log-pages 
memslots.  While a correct value would only be readable with slots_lock 
taken, the NX recovery thread is content with an approximate value and 
therefore can retrieve it with READ_ONCE or atomic_read().

Paolo

