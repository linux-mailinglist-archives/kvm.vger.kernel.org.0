Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C935232F144
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 18:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCERep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 12:34:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhCERe2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 12:34:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614965668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwcvmNyd8TJhEYQ41B0ZqMwHc4Pit4/K/RZB9QMn9JY=;
        b=AwEuTblvex72WQgN/VnczZmYZgIPr+ondntoQZSuNwS4SjKXkWZ/Bjy4/Ktg+EFWopEPpv
        4raSXkdxwcnsLDUlFDKbXVAlFFg/QlAq0uMz/rudb0pm82pQKeQ3uq7/O9xDEVmAMEHaX7
        oFv2MxJSEAoG73y0+AFzqeXFSpdhydY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-ciySKEG7MTieSx1ZgG0hfQ-1; Fri, 05 Mar 2021 12:34:27 -0500
X-MC-Unique: ciySKEG7MTieSx1ZgG0hfQ-1
Received: by mail-wr1-f71.google.com with SMTP id y5so1356563wrp.2
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 09:34:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AwcvmNyd8TJhEYQ41B0ZqMwHc4Pit4/K/RZB9QMn9JY=;
        b=QdsRiEEnA4JOyIz1JIzM2dPLDVsipL+oVRKKTXq0GRKuAaTxaKVIugVAPdQy/qQR32
         IvtKpFMQkeN3yH4TNtM3GpPLOL5w5orwlnYCEyDLfLtrgxub1VoRrb8GGj00YYk6XJX/
         J7BNrg4qpkQB6sanaxQ2QY2s2pouMPPmuv0BlyW8EYrI9hcR1PdvIkBs0oMNtfbPkmSm
         HC5VCcVqx1A4VXNXze5BFHALShEgD6o++7s9CahmiosvB+/xsPPL66PmrvSx+Ja+zBUX
         Z76Mzh6cIgmNVafrpsqH41EgfzSpg21KCCwYxnBPF79yPzH8yovXWV0mb0D1NwPHkCOd
         YpFA==
X-Gm-Message-State: AOAM533VbelE0d6u52kSGKesgPLv0ZPB+e0m/EyvcT3mlRhJ5zrKsl6s
        JaGqJ7c3LdtwcIoN46u8fZzizByrPZK8iKLsDcw6x2rjFIZfusg4JVRNYJ+OX1hOFXwMFhstceb
        ljYJRkGeYOTSv
X-Received: by 2002:a1c:e389:: with SMTP id a131mr10091510wmh.78.1614965665497;
        Fri, 05 Mar 2021 09:34:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyAtzQnqLYpKTx9k1+dfEF1yqaMxFSbQIjreB352fD+qUw+PsXpTW/EesxQZDcxOd7ID8tORQ==
X-Received: by 2002:a1c:e389:: with SMTP id a131mr10091493wmh.78.1614965665338;
        Fri, 05 Mar 2021 09:34:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o2sm5741952wme.16.2021.03.05.09.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 09:34:24 -0800 (PST)
Subject: Re: [PATCH v2 05/17] KVM: x86/mmu: Allocate pae_root and lm_root
 pages in dedicated helper
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210305011101.3597423-1-seanjc@google.com>
 <20210305011101.3597423-6-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2ef5e563-8d7d-3d5a-6a19-d7daaf5c0881@redhat.com>
Date:   Fri, 5 Mar 2021 18:34:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305011101.3597423-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/21 02:10, Sean Christopherson wrote:
> +	/*
> +	 * This mess only works with 4-level paging and needs to be updated to
> +	 * work with 5-level paging.
> +	 */

Planning for this, it's probably a good idea to rename lm_root to 
pml4_root.  Can be done on top.

Paolo

