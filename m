Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDFD5A380C
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 16:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiH0OD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 10:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiH0OD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 10:03:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E6B356CE
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 07:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661609004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uj29lg/rFR13eSbcfn7Az7CrWnF65yQqENZwv3mtKJ4=;
        b=RbjzYF6E3EFRYhwa8eZaXtnJvggMZ1J+chDujyYUTRMvpflpEYx3Ke/ZT6Hx5VSt8xzgET
        A239Yh8K8VGrhvZeSDCehe8pa/BUnKDqjMRMhNw4ExB9iPYYhHmATxcB2RqESk/2jbD/Xx
        jL9uRJcXh6r5aJDRsLxH8CMtq9hvobk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-436-g-3TKw14P7mTnaDfUq_SRw-1; Sat, 27 Aug 2022 10:03:22 -0400
X-MC-Unique: g-3TKw14P7mTnaDfUq_SRw-1
Received: by mail-ed1-f71.google.com with SMTP id h6-20020aa7de06000000b004483647900fso582320edv.21
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 07:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=Uj29lg/rFR13eSbcfn7Az7CrWnF65yQqENZwv3mtKJ4=;
        b=6q27Z3DP4wUOtJJJT81mKOKAfai+yyeTLl+oYGExu5ds2FlKT3QTvJWABk765je8CR
         j4/9NEE6XHaHtGDt5DDQdgtwXjwvAXHxOpwj4KHlqY1Imd3drmhCNZAIqPVPiCVEGeOu
         ChTfnnZYQJqT3b+1EF4QA4Ev54I77v4NIKW53NpST9g+qDsULnbVdSK8jrQOppnv/HVy
         s4IWyJhyIuOGg7QvM/uz2quKxqXYu59Yzj2vujme7BAMN0NF+7ElDC952a9jlJTdpIRh
         NKNqEp04fjmWSOTIOpoy4U4VUebb7ciqLbm2BYJtL00xbggEgM3bmYhhgWQWlaSNC1hM
         KFQA==
X-Gm-Message-State: ACgBeo3QBn53l3xOGOqNyzt7SKIIE5GwYwIu6eHsg7rc+1PspwSrb5L8
        ooHxPPIlpy37HODtihyZNMIw5EUG0p8yhgmAFLh0j3+oy5uskjeUayYo2M47PV+g9SH/IHRWD1t
        RgXcTMxNA/hQ4
X-Received: by 2002:a05:6402:2206:b0:446:9bb7:a1c0 with SMTP id cq6-20020a056402220600b004469bb7a1c0mr10438945edb.344.1661609001751;
        Sat, 27 Aug 2022 07:03:21 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4I8V/x/r0YYTcWRQTu1BolzUybA3nBSxAg5R9QO7oN1UST3iV0RBTDimx2jcKUH2123ImG1w==
X-Received: by 2002:a05:6402:2206:b0:446:9bb7:a1c0 with SMTP id cq6-20020a056402220600b004469bb7a1c0mr10438932edb.344.1661609001563;
        Sat, 27 Aug 2022 07:03:21 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h8-20020a50ed88000000b004463b99bc09sm2809162edr.88.2022.08.27.07.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 07:03:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v6 00/36] KVM: x86: eVMCS rework
In-Reply-To: <87v8qevs6k.fsf@redhat.com>
References: <20220824030138.3524159-1-seanjc@google.com>
 <87fshkw5zo.fsf@redhat.com> <Ywe/j3fqfj9qJgEV@google.com>
 <87v8qevs6k.fsf@redhat.com>
Date:   Sat, 27 Aug 2022 16:03:20 +0200
Message-ID: <87h71xvl5j.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

...

>
> Honestly I'm starting to think the 'evmcs revisions' idea (to keep
> the exact list of features in KVM and update them every couple years
> when new Hyper-V releases) is easier. It's just a list, it doesn't
> require much. The main downside, as was already named, is that userspace
> VMM doesn't see which VMX features are actually passed to the guest
> unless it is also taught about these "evmcs revisions" (more than what's
> the latest number available). This, to certain extent, can probably be
> solved by VMM itself by doing KVM_GET_MSRS after vCPU is created (this
> won't help much with feature discovery by upper layers, tough). This,
> however, is a new use-case, unsupported with the current
> KVM_CAP_HYPERV_ENLIGHTENED_VMCS implementation.

...

Thinking more about the above, if we invert the filtering logic (to
explicitly list what's supported), KVM's code which we will have to add
for every new revision can be very compact as it will only have to list
the newly added features. I can't imagine fields *disappearing* from
eVMCS definition but oh well..

Anyway, I think this series is already getting too big and has many
important fixes but some parts are still controversial. What if I split
off everything-but-Hyper-V-on-KVM (where no controversy is currenly
observed) and send it out so we can continue discussing the issue at
hand more conveniently?

-- 
Vitaly

