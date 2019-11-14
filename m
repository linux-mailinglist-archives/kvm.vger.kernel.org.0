Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E74FC62B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 13:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfKNMQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 07:16:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37536 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726185AbfKNMQZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 07:16:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573733784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k5zYUiU+g7WjuH6/6S9d3SsIOHZGX/0lXuRO2F2b2zQ=;
        b=gtzQsQ8TvSPwv93pBvdC1JdpjaDSxEkSm4tzmjOYzfHmxCDO4HYqLII78WRgRGQc4LjEtF
        aZ9bp2OtUaH36EGLUVCPJBZIcu08RE/FDWwCxn68LdmRPkwe7mgAzQ4vkjSMaq1Mkus0bD
        SP45oRzZHbq6xHRcIfLlpQYjSutzErA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-W15Wn3CUPRKT6FoE0Ncj9Q-1; Thu, 14 Nov 2019 07:16:22 -0500
Received: by mail-wm1-f70.google.com with SMTP id l184so3802500wmf.6
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 04:16:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k5zYUiU+g7WjuH6/6S9d3SsIOHZGX/0lXuRO2F2b2zQ=;
        b=E1uwtRTPgvnMQsoVOjMxN7qf1reiUC9X5bnmQa2IDp5R+uGtA4AJVX/2UKkNLeS2xc
         hlMWMJim8rE7K06yEmOz4ElIGZp5CyAhIDYTeb9XhgxPIcVW2koZWjSR/2ul55VKLp2W
         qfNlmsmK+CvFk8UAHihu5Ovtbxgsmt6S5ZLR+IBPzdINHQu+D/TYmOEy0peHR4eL2FHa
         vhRXovBN741wVJxbfRckGclyUeRuSKX6rj0mzqBM3pLigTKbgKOVbyUpohPgDmXwDNdI
         cbsdPKxJJ5BLoZkt1qF0PrpaepJMhhNY5SjQVrdkqOJCqCiJc5yXzbttuWl6mW38Mftk
         9H/A==
X-Gm-Message-State: APjAAAV4WjvVXD3edmVDkDfDTU2ys4YkwBxawoi0EDJFFzDWT1Rdfrcd
        Au9L8RuLdMsO8n4fImCpqR2AtedqXRk3Avlfx9ur074wwGC5Vb3wKZPdP5c5dyAUZ+gCuITN+ia
        F/ZNosrHtTM1b
X-Received: by 2002:adf:fad1:: with SMTP id a17mr955468wrs.328.1573733781796;
        Thu, 14 Nov 2019 04:16:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqzz5g+kyx23kgyTEuyGc6yicSZ4gGEGPYNBpJi/bvdemWwfLS7ljePZ6vQ6ZO5YNNmD4Dn6dA==
X-Received: by 2002:adf:fad1:: with SMTP id a17mr955449wrs.328.1573733781522;
        Thu, 14 Nov 2019 04:16:21 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id l1sm6959625wrw.33.2019.11.14.04.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 04:16:21 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Take slots_lock when using
 kvm_mmu_zap_all_fast()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191113193032.12912-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b46d531-6423-3ccc-fc5f-df6fbaa02557@redhat.com>
Date:   Thu, 14 Nov 2019 13:16:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113193032.12912-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: W15Wn3CUPRKT6FoE0Ncj9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/19 20:30, Sean Christopherson wrote:
> Failing to take slots_lock when toggling nx_huge_pages allows multiple
> instances of kvm_mmu_zap_all_fast() to run concurrently, as the other
> user, KVM_SET_USER_MEMORY_REGION, does not take the global kvm_lock.
> Concurrent fast zap instances causes obsolete shadow pages to be
> incorrectly identified as valid due to the single bit generation number
> wrapping, which results in stale shadow pages being left in KVM's MMU
> and leads to all sorts of undesirable behavior.

Indeed the current code fails lockdep miserably, but isn't the whole
body of kvm_mmu_zap_all_fast() covered by kvm->mmu_lock?  What kind of
badness can happen if kvm->slots_lock isn't taken?

Paolo

