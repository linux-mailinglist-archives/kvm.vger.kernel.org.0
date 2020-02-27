Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A39171112
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 07:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgB0GiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 01:38:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25201 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726575AbgB0Gh7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Feb 2020 01:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582785478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bhDPIijuRy47oBV7ImGtg0praMNMpJF6liHitqw51PI=;
        b=OdXwCGwFVKgxPKe5Xlllsv/r87wRTdVBxHHlYN5dgNOViIboeE+BUZ4KOTpac/uQXXp+dm
        LYu2+xB4rZie7Us+DThW858SeXpE2hUuuqdzywkPV3IVFBTiP3y9sg5/sq/aAL6G+IGTdJ
        KxcaaYo5BDNRpHbqRDWZjZLe07rVio0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-pJK1Ip0JOQO5mL7nMmAi5Q-1; Thu, 27 Feb 2020 01:37:57 -0500
X-MC-Unique: pJK1Ip0JOQO5mL7nMmAi5Q-1
Received: by mail-wr1-f71.google.com with SMTP id p5so851619wrj.17
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 22:37:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bhDPIijuRy47oBV7ImGtg0praMNMpJF6liHitqw51PI=;
        b=tpkMvBEWAC3bBPUYf5sKWykO1ljRaDE+3/0yhw0qm9i7QjZhBOSEdmH3Q8j2ZqMMuF
         ifD6v9zSwPHsbUPAKkhhHYvALesefKoN+yA9DSZQln1V0OwTjGDOOLKLNsxXuYi7C/E+
         N3omcDUEGLODHAGgekuDZEdTQa5NN57DggaGFy3nqytyovKbKkqr+6/SAMyvbGDW95jK
         NMghgQJdAVOP/FzlFqs4WGJz4mjKsNm//0d4heNuJ29S+vtjRZ9xoyLxiwjez2DMt3AX
         BIyq/jsFNPZcMYJ8A72utxXWl7UeY46JkxkjpoXqD83JRKBre4elbzF3kXlBGLSd2Sfj
         RTSw==
X-Gm-Message-State: APjAAAXk9+H1wflcA9kKGHuq3naovm2khQxGVc3JUUSRDBOvy+/t1Q6o
        KkjZjWUtrVuDybROAPPDvomrg3StTWOiw2NR80OJC4Uzqlri2eUW0wcaWEpGaQrvS9hOH5xHQs8
        BfSTauL6aMPIp
X-Received: by 2002:a5d:6692:: with SMTP id l18mr2842053wru.382.1582785475964;
        Wed, 26 Feb 2020 22:37:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxTR2n4hsOTNKT4K1U9CwsKVfMeIkTgLrEgBtpvYQQGfV8eQR8ZnkQKuhfSx1M2LuUcq/ZFrQ==
X-Received: by 2002:a5d:6692:: with SMTP id l18mr2842038wru.382.1582785475744;
        Wed, 26 Feb 2020 22:37:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id j20sm6935924wmj.46.2020.02.26.22.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 22:37:55 -0800 (PST)
Subject: Re: [PATCH v3 0/5] Handle monitor trap flag during instruction
 emulation
To:     Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200207103608.110305-1-oupton@google.com>
 <045fcfb5-8578-ad22-7c3e-6bbf20c4ea35@redhat.com>
 <CAOQ_Qsg6DnSGU26xBJAQ6CGb6Lh5jX7VTvoXFZRnx3_f0eKYGQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <74650413-5cbc-6dd7-498e-22e89f1f6732@redhat.com>
Date:   Thu, 27 Feb 2020 07:37:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_Qsg6DnSGU26xBJAQ6CGb6Lh5jX7VTvoXFZRnx3_f0eKYGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/02/20 01:22, Oliver Upton wrote:
> Are there any strong opinions about how the newly introduced nested
> state should be handled across live migrations? When applying this
> patch set internally I realized live migration would be busted in the
> case of a kernel rollback (i.e. a kernel with this patchset emits the
> nested state, kernel w/o receives it + refuses).

Only if you use MTF + emulation.  In this case it's a pure bugfix so
it's okay to break backwards migration.  If it's really a new feature,
it should support KVM_ENABLE_CAP to enable it.

Paolo

> Easy fix is to only turn on the feature once it is rollback-proof, but
> I wonder if there is any room for improvement on this topic..

