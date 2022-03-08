Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE494D1F82
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbiCHRzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349330AbiCHRzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:55:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 903F556407
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646762061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VRJ9eIaZpS2RurIQ//hV563/Kpax+xX8+gqd0S50TBY=;
        b=AovMWxRqRQoJ+KxOyTxNtHfnNLKEv9uz5c+1iaoZtwRQD0Id/+Am4xgxM+GNf59gPfNdVD
        5Bo4RQqW8rGeFqskjCboGZvyLuB2UH+NFTblHiJB7eAYuoGQqoR4RmUQMCg0ZCw2zDcyg3
        /vBjW9oRozmc5lWWgmm975yPE+7veSg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-8R_lexIFOAm4LJnuJduRXw-1; Tue, 08 Mar 2022 12:54:20 -0500
X-MC-Unique: 8R_lexIFOAm4LJnuJduRXw-1
Received: by mail-wr1-f71.google.com with SMTP id z1-20020adfec81000000b001f1f7e7ec99so1757403wrn.17
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:54:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VRJ9eIaZpS2RurIQ//hV563/Kpax+xX8+gqd0S50TBY=;
        b=q3/GEkLIBVROLYkIWifEJhqxApS4esAV0isiOpr0b0gm3sLMGP8VdGMcRmFTTsXF0B
         uXuvOSnJETMhY90ksMXp+/kW8Arjhpu/Ypxu7zxjvuYtuQoTJGRoMophY7xKM2ofJv+J
         vq1xSS55FxAUSavkV3T/DX2y6/8ix9bDKMVO+10/Zn+yd2cv2a2r/Ny18wIgPPC+4hom
         TlTGCUTUwKhlV+TZ4x2+a/S8qzP8b3m0hiunwFGNxtIEtE+kY03ODTtgVNzE66Awx3Ds
         j6AEydMa9GtCHeXyu5kqouePzXgZOC3u5bjv290oeF4bEr6igD5DsEArgrFPQXV6ConO
         9Wvw==
X-Gm-Message-State: AOAM530HA6ha/Vq7krcJGeXzU36JGKt4Asjz7IKKYCrcGu0vpMEPwf3L
        JZaHNegzrrCqta9iLcIPfV2mjW6PD+nfbEvzBvlNzLBKYU0TFU0msJ+faMH1gmqLm17EpBWCVyG
        RQ9+V0sdfVwgg
X-Received: by 2002:a05:600c:20a:b0:389:9d03:3439 with SMTP id 10-20020a05600c020a00b003899d033439mr352833wmi.48.1646762059326;
        Tue, 08 Mar 2022 09:54:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6sxWUwC2YMBsFuTHJl07xkb0PgJRqu+2pi7bcfwwkIuL6sqHzyTlnbAEb4xFoRCPjzNHPkw==
X-Received: by 2002:a05:600c:20a:b0:389:9d03:3439 with SMTP id 10-20020a05600c020a00b003899d033439mr352818wmi.48.1646762059111;
        Tue, 08 Mar 2022 09:54:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o19-20020a05600c511300b00389c3a281d7sm3775531wms.0.2022.03.08.09.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 09:54:18 -0800 (PST)
Message-ID: <7e4b4f98-9556-5165-8e36-811701e1f7af@redhat.com>
Date:   Tue, 8 Mar 2022 18:54:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 00/17] KVM: Add Xen event channel acceleration
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
References: <20220303154127.202856-1-dwmw2@infradead.org>
 <db8515e4-3668-51d2-d9af-711ebd48ad9b@redhat.com>
 <ec930edc27998dcfe8135a01e368d89747f03c41.camel@infradead.org>
 <adbaebac-19ed-e8b7-a79c-9831d2ac055f@redhat.com>
 <42ed3b0c3a82627975eada3bcc610d4e074cb326.camel@infradead.org>
 <5a0d39d9-48b9-5849-daf7-19fbadd75f8c@redhat.com>
 <e745f08e615e5eacb04ba492f5fcd1e7d14fa96c.camel@infradead.org>
 <ec9b7bdd-f85a-5b39-1baa-86b5c68bcf31@redhat.com>
 <1e478b74d7e27bbf766fd9f32c54b84cc894da53.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1e478b74d7e27bbf766fd9f32c54b84cc894da53.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 18:40, David Woodhouse wrote:
> On Tue, 2022-03-08 at 18:25 +0100, Paolo Bonzini wrote:
>> On 3/8/22 18:20, David Woodhouse wrote:
>>>> Yes, I'm just talking about the second hunk.  The first is clear(ish).
>>> Oh, I see.
>>>
>>> When the oneshot timer has expired and hasn't been re-armed by the
>>> guest, we should return zero as 'expires_ns' so that it doesn't get re-
>>> armed in the past (and, hopefully, immediately retriggered) when the
>>> guest is restored.
>>>
>>> Also, we don't really want the timer firing*after*  the guest vCPU
>>> state has been serialized, since the newly-injected interrupt might not
>>> get migrated. Hence using hrtimer_cancel() as our check for whether
>>> it's still pending or not.
>>
> Sure. But if we consider it acceptable for the timer to fire again
> after live migration when it already fired on the source host why did
> we even bother fixing the first part above? :)

In the first case the timer has expired and the event has been injected 
by the time the state is retrieved, so you'd get a double event.

In the second the timer expires and the event is injected _on the 
source_  only.  This is required because, if the destination for 
whatever reason aborts the migration, your change would introduced a 
missed event.

Paolo

