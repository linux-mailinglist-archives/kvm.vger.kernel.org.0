Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD8553B58B
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 10:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiFBI6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 04:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiFBI61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 04:58:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3498C1F5885
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 01:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654160304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QHHhZPNEReae7uDrhQQaxzJlyFyuq/ZiBPU6wUE3JoY=;
        b=fOWAd6aA8sBoL6R3kWpjdvU6GHs6+RJzlvP9upZ98ExMABqbTSeGix5PXHpcgVOhf7JNiU
        Y6JM+Sc2jTe+KGYrGIJRMgWNVE1gMnFsRUuFibeuHtcWxmOKQcTVW34B2qPN1UMDAJK4D/
        O/avSdPPZJ47nS9yiNWUq+yaEyhS4oM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-4Uv8ItREOCOuIoHEtELsdA-1; Thu, 02 Jun 2022 04:58:23 -0400
X-MC-Unique: 4Uv8ItREOCOuIoHEtELsdA-1
Received: by mail-wm1-f71.google.com with SMTP id k5-20020a05600c1c8500b003974c5d636dso2526498wms.1
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 01:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=QHHhZPNEReae7uDrhQQaxzJlyFyuq/ZiBPU6wUE3JoY=;
        b=Xl1A+NCCRJyUyDEBP/OhRKi5vAw4r42o5GYYnGSiHwvBD4gu+4l2qAdiJU2ajVTw0N
         fvLlH7TbA/oGeRMNgLnlqqTAEkcAHk1nswdL9aBEwey1lZtldmol6J1wLd2KT+bywoiR
         TLPdVAx3e8v0oLtepZpmdFVqnopVG3xVl3E6OraDKRw6P1TBmn5e1COKKY0hPCH1OPvi
         d4Rm163chExdot549FuNYxStZd7pJUvdywdSVO0OxpGVJtUBjNpEpigPzGjAbhxk5alA
         2RzUkSWnsKa6/rfdGoL50t3ugzNb/nxh3bmNfe82ykjBfooJzdrwQC+z6FK8xEuY7ywK
         qkMw==
X-Gm-Message-State: AOAM531iVCKpNsHfS9NPt8XGSTeXgYPCRqVUDeCWXOg/kN+nsleiHikG
        YYYzO0gF3v/41tDSC6a1I8BEkhMuqyZAqi55mkrVX0u5TvqRKBkjR+rJEz7sTo/gDdqW85729QF
        ZbPG3dyy2Fqdt
X-Received: by 2002:a05:600c:acf:b0:397:345f:fe10 with SMTP id c15-20020a05600c0acf00b00397345ffe10mr3049068wmr.15.1654160301528;
        Thu, 02 Jun 2022 01:58:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdOrk/aoRIsHEpwlQyKBAnrpDrHsiQ/QLl3k6m7jmIlUh2rzkCgQv5CFQ2NrmYI4xHgZF2FQ==
X-Received: by 2002:a05:600c:acf:b0:397:345f:fe10 with SMTP id c15-20020a05600c0acf00b00397345ffe10mr3049039wmr.15.1654160301152;
        Thu, 02 Jun 2022 01:58:21 -0700 (PDT)
Received: from [192.168.178.20] (p57a1a7d6.dip0.t-ipconnect.de. [87.161.167.214])
        by smtp.gmail.com with ESMTPSA id b11-20020a5d4d8b000000b0020c7ec0fdf4sm4226808wru.117.2022.06.02.01.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 01:58:19 -0700 (PDT)
Message-ID: <0fec9818-bce1-936c-3f6d-488715d9df8c@redhat.com>
Date:   Thu, 2 Jun 2022 10:58:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220524190305.140717-1-mjrosato@linux.ibm.com>
 <20220524190305.140717-3-mjrosato@linux.ibm.com>
 <5b19dd64-d6be-0371-da63-0dd0b78a3a5c@redhat.com>
 <6030c7e6-479d-660c-9198-1c65c74735a1@linux.ibm.com>
 <f8d128d2-e58a-e0a0-ff8a-7ff2b2ffa31e@redhat.com>
 <535b79a5-372d-9bca-d7c7-bac263277230@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v6 2/8] target/s390x: add zpci-interp to cpu models
In-Reply-To: <535b79a5-372d-9bca-d7c7-bac263277230@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> That's exactly my point:
>>
>> sigpif and pfmfi are actually vsie features. I'd have expected that
>> zpcii would be a vsie feature as well.
>>
>> If interpretation is really more an implementation detail in the
>> hypervisor to implement zpci, than an actual guest feature (meaning, the
>> guest is able to observe it as if it were a real CPU feature), then we
>> most probably want some other way to toggle it (maybe via the machine?).
>>
>> Example: KVM uses SIGP interpretation based on availability. However, we
>> don't toggle it via sigpif. sigpif actually tells the guest that it can
>> use the SIGP interpretation facility along with vsie.
>>
>> You mention "CLP instructions will look different", I'm not sure if that
>> should actually be handled via the CPU model. From my gut feeling, zpcii
>> should actually be the vsie zpcii support to be implemented in the future.
>>
> 
> Well, what I meant was that the CLP response data looks different, 
> primarily because when interpretation is enabled the guest would get 
> passthrough of the function handle (which in turn has bits turned off 
> that force hypervisor intercepts) rather than one that QEMU fabricated.

Okay, so more some kind of "the device behaves seems to behave slightly
different".

> 
> As far as a machine option, well we still need a mechanism by which 
> userspace can decide whether it's OK to enable interpretation in the 
> first place.  I guess we can take advantage of the fact that the 
> capability associated with the ioctl interface can indicate both that 
> the kernel interface is available + all of the necessary hardware 
> facilities are available to that host kernel.

Yes.

> 
> So I guess we could use that to make a decision to default a machine 
> setting based upon that (yes if everything is available, no if not).

Right, in theory we could enable interpretation whenever possible
(kernel indicates support, including HW support).

In practice, it would be nice to be able to disable zpci interpretation
for debugging purposes.

One option is to simply glue it to compat machines. So selecting an
older compat machine will disable it.

Another option is a e.g., machine property, which can be used to
force-disable it (e.g., zpcii-disabled) and let the property always
default to false.

Third option would simply combine both, making compat machines make
zpcii-disable result in "true".

> 
>>
>> So I wonder if we could simply always enable zPCI interpretation if
>> HW+kernel support is around and we're on a new compat machine? I there
>> is a way that migration could break (from old kernel to new kernel),
>> we'd have to think about alternatives.
> 
> zpci devices are currently marked unmigratable, so if you want to 
> migrate you need to detach all of them first anyway today.

Okay. So it might be reasonable in the future to simply check on source
and migration if zpcii is in the same state if zpci devices are attached
to the VM. If not, simply fail migration -- in sane enironments, we'd
never get a mismatch.

-- 
Thanks,

David / dhildenb

