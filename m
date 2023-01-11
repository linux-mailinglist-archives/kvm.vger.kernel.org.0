Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA1D66666E
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 23:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjAKWuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 17:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbjAKWu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 17:50:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C116D3F441
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673477382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLxSbsWNIzWb53UEC79mpYFzVchvvpiDNtlKM5Fsdzs=;
        b=KlQlo+q+aSvFLBeyrzvlcO1/OSExERNfCRF7DNgDEcA9Xtt7iTsQ4dDdDf+9gKKuM2V0kc
        qLNe6/WE8hbCtFxbghzSQHiyDp6BLNnwiwWTOI09ZiuPihWt/nUZGDWTttF9iBFKwRSjV0
        RL0sTpAy1RIl5uNgYYIoWUqqDkCq7eA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-216-7gOxp7PIPyqulChX1vGGQA-1; Wed, 11 Jan 2023 17:49:40 -0500
X-MC-Unique: 7gOxp7PIPyqulChX1vGGQA-1
Received: by mail-wm1-f69.google.com with SMTP id i7-20020a05600c354700b003d62131fe46so11402681wmq.5
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 14:49:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SLxSbsWNIzWb53UEC79mpYFzVchvvpiDNtlKM5Fsdzs=;
        b=dSl+52o1twNgWcfwsyjEXDENdWzIqxc1KA6k/u7ttHPOe3kP6WjUSH8E3AJrLLsZN6
         V2tJtzKy4Mo6Y2VgQYVUlJaTYVAf7TJTIiNA3tsRrYSwJ4Je1lTEss+ZR4k3DXXdjWpn
         QA4A+RUcv9kO87cPZYGujHP9s3zuTjTv30/r1oJEBcZn3pfgxpkDs15Pru6Za7zFIgXo
         f7miXUi81IOsDYo57GjW5eZBeZrIsAGbfgw4pn96/IVwkoOsApmnof0ZpdI9TRQKgICh
         va0C6zeZrL09w5uFiEsSDeqnCeDfj8J6jQG8pY9ugZDX2smPiXCuegSIBohP1+Mv7Lps
         XjgQ==
X-Gm-Message-State: AFqh2kp+eYJBcAHMErJ4IY4Xs3fOHMsik/Vyhb+0Hmm36y/a03mJ6HDV
        /cf2iFnzwgfKsB8+EAsckZAI1KGEvSVwTjdD5kWAMPO1RVUHUULElLDftNj/P2IK8OZ8/hi6ff2
        L0OmH07e5dzBz
X-Received: by 2002:a05:600c:4d14:b0:3d3:5c7d:a5f3 with SMTP id u20-20020a05600c4d1400b003d35c7da5f3mr57204217wmp.37.1673477379689;
        Wed, 11 Jan 2023 14:49:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvOTk9qqGn5FbnlvxRL2hwLgKou2ql1hAN/w0GxD2jTdYHNVC/3LnJpQSIioBiWT3DerW8KBg==
X-Received: by 2002:a05:600c:4d14:b0:3d3:5c7d:a5f3 with SMTP id u20-20020a05600c4d1400b003d35c7da5f3mr57204212wmp.37.1673477379425;
        Wed, 11 Jan 2023 14:49:39 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id b1-20020adf9b01000000b0028e55b44a99sm14684549wrc.17.2023.01.11.14.49.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 14:49:38 -0800 (PST)
Message-ID: <054e5855-ffa3-7b2b-f90f-54e9caefdd46@redhat.com>
Date:   Wed, 11 Jan 2023 23:49:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, paul@xen.org,
        Peter Zijlstra <peterz@infradead.org>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co> <20221229211737.138861-2-mhal@rbox.co>
 <Y7RjL+0Sjbm/rmUv@google.com> <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
 <Y7dN0Negds7XUbvI@google.com>
 <3a4ab7b0-67f3-f686-0471-1ae919d151b5@redhat.com>
 <f3b61f1c0b92af97a285c9e05f1ac99c1940e5a9.camel@infradead.org>
 <9cd3c43b-4bfe-cf4e-f97e-a0c840574445@redhat.com>
 <825aef8e14c1aeaf1870ac3e1510a6e1fe71129d.camel@infradead.org>
 <60b4f074ee21c0c601321cd7ee8e4a55967fbfae.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <60b4f074ee21c0c601321cd7ee8e4a55967fbfae.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/23 09:49, David Woodhouse wrote:
>> [13890.148203] ======================================================
>> [13890.148205] WARNING: possible circular locking dependency detected
>> [13890.148207] 6.1.0-rc4+ #1024 Tainted: G          I E
>> [13890.148209] ------------------------------------------------------
>> [13890.148210] xen_shinfo_test/13326 is trying to acquire lock:
>> [13890.148212] ffff888107d493b0 (&gpc->lock){....}-{2:2}, at: kvm_xen_update_runstate_guest+0xf2/0x4e0 [kvm]
>> [13890.148285]
>>                 but task is already holding lock:
>> [13890.148287] ffff88887f671718 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x84/0x7c0
>> [13890.148295]
>>                 which lock already depends on the new lock.
>>
> 
> ...
> 
>> [13890.148997] Chain exists of:
>>                   &gpc->lock --> &p->pi_lock --> &rq->__lock
> 
> 
> I believe that's because of the priority inheritance check which
> happens when there's *contention* for gpc->lock.
> 
> But in the majority of cases, anything taking a write lock on that (and
> thus causing contention) is going to be invalidating the cache *anyway*
> and causing us to abort. Or revalidating it, I suppose. But either way
> we're racing with seeing an invalid state.
> 
> In which case we much as well just make it a trylock. Doing so *only*
> for the scheduling-out atomic code path looks a bit like this... is
> there a prettier way?

I'll add a prettier way (or at least encapsulate this one) when I send 
the patches to introduce lock+check functions for gpc.

Paolo

