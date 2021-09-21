Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B600413174
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 12:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhIUK27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 06:28:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231189AbhIUK2z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 06:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632220046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TOl2THfupnjfQ/gkXriljE1KTl9vLuhPE/7VUmuUxf0=;
        b=BkBc+tqPRRjIovR4RRQJAMqVbI299kIHNCPmOz8hA+lsCiAwU2abJJfkY9eDpTfv2qzfga
        msEUdT0v+U0On+61UOxEeHCUhTnZBBKXpPh+EeGaHpPku4igWk1OAJA/JIXSyANraghhEN
        9mtjjY91zZCt2GYZdt/S8LzHA6Ghc28=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-ocs-RgcbPqKlNte9Dt0Z8A-1; Tue, 21 Sep 2021 06:27:24 -0400
X-MC-Unique: ocs-RgcbPqKlNte9Dt0Z8A-1
Received: by mail-ed1-f72.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso7292114edx.2
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 03:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TOl2THfupnjfQ/gkXriljE1KTl9vLuhPE/7VUmuUxf0=;
        b=sGwDjsypku6v60hAQ5b2So6m5TUrl0B+n5WGt+OlXNVd2DGRNBUpPsfnLcZ3ElfqTs
         JEWcPm7BK/4zhlcH2UJXVGsdNOFM8GXwuwurj/tXiz2Ieua2tJ2v/36GEjeL77bV1/Ux
         IRrbnEwa1InQzDWwJG1fqHZv728CgMwuw1kGMrelWwclYau6nNuWo0YipIZfoIAyTmGG
         g6TUsPUOkx6ay/ZoG3ApkrgM95r8C8fgn9jGXMieqlJGNV8cttROLn1v2kmxG9/+Vscu
         HGWk3S/Vt9DrYiFpD4zRbs17+kp+e4qZzvNIl5NsUuQg6xV79ZdzD0K+P0lbMd+4TNRm
         eJdQ==
X-Gm-Message-State: AOAM533WSxsGStw/647SAb/EtM6Tp6sZU86HyIvmJHXPVm741HtbwMxk
        3L3vjhw9V2ce6uV1ShUTONp+mgboM5oZczJ6dhM3T2MJI5Qa4IVaxPBP2KehwgY1foqX1+q/NGD
        +Q2UPIEazdTO4
X-Received: by 2002:a17:907:7848:: with SMTP id lb8mr33288510ejc.494.1632220043014;
        Tue, 21 Sep 2021 03:27:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPAHOL+IltPry8Ihynhe+a35xQCoX+GqjuIh+yL263I54n/1EOMs7NxrABllZcjaVsXTL3dA==
X-Received: by 2002:a17:907:7848:: with SMTP id lb8mr33288488ejc.494.1632220042781;
        Tue, 21 Sep 2021 03:27:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ml12sm7389829ejb.29.2021.09.21.03.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 03:27:22 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86: skip gfn_track allocation when possible
To:     David Stevens <stevensd@chromium.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20210921081010.457591-1-stevensd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a389892a-cf0e-7d80-d47c-0c68ae3c3416@redhat.com>
Date:   Tue, 21 Sep 2021 12:27:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921081010.457591-1-stevensd@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 10:10, David Stevens wrote:
> This straightforward approach has the downside that for VMs where nested
> virtualization is enabled but never used, gfn_track arrays are still
> allocated. Instead of going so far as to try to initialize things on
> demand, key off of whether or not X86_FEATURE_VMX is set in the guest's
> cpuid to support per-VM configuration instead of system wide
> configuration based on the nested module param.

Can you allocate it lazily like we do for the rmap?

Paolo

