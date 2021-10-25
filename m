Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7321843963B
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 14:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhJYMZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 08:25:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233384AbhJYMY6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 08:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635164555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttahzS8cNPktjo1tT0ZScVrIZ1y3XB+eXWmahoJabDk=;
        b=H+bq6z2G297T84O7JaHiCE72hKiKqVba24OybOtuxoSmv87U1egq6nAzOwVvqhP4G2dORC
        qlGaun26aNK8Gcwnr5So5seXX227smu4aZimOpiEvgRZ0RD2zivKWiGVm4+fCu8wfa7KgQ
        ezrU5l3CD2I7Im8TEHLPcGB+5zUUAEY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-PgnmZ_C4Pryd3kqXi-plDA-1; Mon, 25 Oct 2021 08:22:31 -0400
X-MC-Unique: PgnmZ_C4Pryd3kqXi-plDA-1
Received: by mail-wm1-f72.google.com with SMTP id b81-20020a1c8054000000b0032c9d428b7fso3442955wmd.3
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 05:22:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ttahzS8cNPktjo1tT0ZScVrIZ1y3XB+eXWmahoJabDk=;
        b=tyGjMvKEmEKg6n0Bx52/BfaPdEx+1xU3WpqCtSpXqD9vlUycXyqS/CT1cLB0eng6vP
         pXK5LRs4YMXWjvLQkxX+vUbu0q+8ZZ6lUWq3wfl1yUsAtVh7FPfL725zpF+ZEdxgjEzy
         a8tP+ObmxcPV2MpnEOIlP6EH76mX+uyIUBAnbcUIfaaFNN8L1cM7LMFki1J2iGP0B9Ek
         G9jkHS3PpzFUY1F5j2o/p8lBcPYwKHnWch84GWHsqkKB00mNse/mPyq9zlB9Oo1O3Gmg
         sBcOIWP0zpaV6a9V3QoLwY5zNJEMcPCrubYzM/2THFsYEBpJT/gHxahzrjQyDZ65eX4y
         3AlA==
X-Gm-Message-State: AOAM530M5Rz72HqebqDQMLazz+M1Vysv0cYLQb5wFvNVVWDqsQmKrClX
        dkWPpYiIhF5Db5Mz0UBN6XTpjErhws1nPWp82MBepIOXztYaJCmJMBAU8VEf3x94i6iUXjiCnii
        YqKaItUpGCd0N
X-Received: by 2002:a5d:4d52:: with SMTP id a18mr22852053wru.406.1635164550771;
        Mon, 25 Oct 2021 05:22:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+XwQeH2jC/I+KFyNlsvty5W4aVuSNW5Gjd+BBXNM4x5KokUyngv0Fen/jVAiY0MWT21BR5Q==
X-Received: by 2002:a5d:4d52:: with SMTP id a18mr22852022wru.406.1635164550526;
        Mon, 25 Oct 2021 05:22:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm5512666wry.71.2021.10.25.05.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 05:22:29 -0700 (PDT)
Message-ID: <95bee081-c744-1586-d4df-0d1e04a8490f@redhat.com>
Date:   Mon, 25 Oct 2021 14:22:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [EXTERNAL] [PATCH] KVM: x86/xen: Fix runstate updates to be
 atomic when preempting vCPU
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
 <09f4468b-0916-cf2c-1cef-46970a238ce4@redhat.com>
 <a0906628f31e359deb9e9a6cdf15eb72920c5960.camel@infradead.org>
 <2e7bcafe1077d31d8af6cc0cd120a613cc070cfb.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <2e7bcafe1077d31d8af6cc0cd120a613cc070cfb.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/21 14:19, David Woodhouse wrote:
> So, with a fixed version of kvm_map_gfn() I suppose I could do the
> same, but that's*two*  maps/unmaps for each interrupt? That's probably
> worse than just bouncing out and letting userspace do it!

Absolutely!  The fixed version of kvm_map_gfn should not do any 
map/unmap, it should do it eagerly on MMU notifier operations.

Paolo

