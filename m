Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAEC2A93C5
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 11:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgKFKKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 05:10:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgKFKKM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 05:10:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604657411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/uaQ+ciO8/RfcKxsgCor1/p7DcJNB2wEujPSnKBSz8=;
        b=WI9Oxe6AmM09YLWg1hs3skgsaHP+jXenEtWDmi27SgI+vLCaX+gorl/lDFBABM+TmltLS+
        8NeYldEVBY1KJFbj1uwW9I5Wy0U587RdKpNJQJ9tkfZ72Cwde5vnc1c8Mc+QrxT+xl3lEH
        sHbKLfmwJGkuEp4p6U+HYsCyBumsTHI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Isai8td0N766mDEmzONM8A-1; Fri, 06 Nov 2020 05:10:10 -0500
X-MC-Unique: Isai8td0N766mDEmzONM8A-1
Received: by mail-wm1-f72.google.com with SMTP id 3so243496wms.9
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 02:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W/uaQ+ciO8/RfcKxsgCor1/p7DcJNB2wEujPSnKBSz8=;
        b=ufNbXJFu5PHGX887wacmI3isZgN6eaa8dZ04gMeTQRCMvaq0cUBrZVdd0v+CngxIgm
         5nFyvkYpzck9Q1ccr4NunklBx+VhhpdI/RJR1zYCBN7wEHaozLD26JBQyqooLG2VgA5k
         seCTTqJRrk+O7X/VfbuSfFVU/D3l+pdfaHO6bcVtFz2pzh2uoDD7BxmWmS0jMEvGZ/SQ
         XkPFSxrsnA3X8mBuYG3tZ1CTVXpL7+q2zTqWAzupu8A3TV32D1O9W7w70xgMZ/DDPlCF
         R7KX8VRV0/YRbK7dZxRJPcdN1Rw/PdXBhMeOFskfj5WP7O20gpjUNUVChP9XthYfg9jG
         eliQ==
X-Gm-Message-State: AOAM532VYTRiwzWXOtMiDXrUxoWi/fqbv9oSJcRDoRrYSE+8PszMQrsP
        A7cqe8r9qt2cNT87pgZA2aCpjYdgSr/4igdeOu1PngY/ze7KwLl+hSzrCr/Stq+boSwMhGMql4y
        eKZqXPBBnivLz
X-Received: by 2002:a1c:6484:: with SMTP id y126mr1511522wmb.141.1604657408338;
        Fri, 06 Nov 2020 02:10:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPhPkVRuFuerZB14L4+UH5k2bN4LoZqc13UQUmyxQLeHQ2h9vhRQEAWQyFzPA1g4J2AmjJfw==
X-Received: by 2002:a1c:6484:: with SMTP id y126mr1511504wmb.141.1604657408176;
        Fri, 06 Nov 2020 02:10:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q7sm455306wrg.95.2020.11.06.02.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 02:10:07 -0800 (PST)
Subject: Re: [PATCH v2 2/2] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
To:     yadong.qi@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201106065122.403183-1-yadong.qi@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a5c0071c-101a-a2ff-4ced-2f5ec8b38896@redhat.com>
Date:   Fri, 6 Nov 2020 11:10:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201106065122.403183-1-yadong.qi@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 07:51, yadong.qi@intel.com wrote:
> @@ -4036,6 +4060,8 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>   
>   	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
>   		vmcs12->guest_activity_state = GUEST_ACTIVITY_HLT;
> +	else if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
> +		vmcs12->guest_activity_state = GUEST_ACTIVITY_WAIT_SIPI;
>   	else
>   		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
>   

Updated, thanks.

Paolo

