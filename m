Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17C91457E7
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 15:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgAVOfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 09:35:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48711 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725940AbgAVOfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 09:35:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579703741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xFtBnuA8Z1Te0Pu/OG4AJ4ugC7ZoC2Bg8KQUirpZDDM=;
        b=fsWxkwrLFTo8PtKmGttZNkuiC6SxIGRdtKL+uBG4dpnciCtnX8aXwIJrCrBAASsoFQCixw
        1kOhjwW4Tr2FYWSESJYqFcI+6tu7hshNSaT1af+mzgDuunY/K91Mbp7jiUqct5BMJ0B35s
        cgjFWSRNeGD3JMRLypAlWC3oaEhLtrQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-eGpPybFXMwid5C6JSFxl4A-1; Wed, 22 Jan 2020 09:35:39 -0500
X-MC-Unique: eGpPybFXMwid5C6JSFxl4A-1
Received: by mail-wr1-f71.google.com with SMTP id u12so3142129wrt.15
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 06:35:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xFtBnuA8Z1Te0Pu/OG4AJ4ugC7ZoC2Bg8KQUirpZDDM=;
        b=n89EkeKOhUptY5bm+tFR+HbcvGq9JfAoI17XVu4wndORCINfBRIIOqn/wSQ7hpVkZk
         XjUiPiOfDbzlKfQI7sQx5j5dqJtvwInl2kQpSv9J+9wvqJC/PEzDGrlU1Xgalcn5BR3w
         domT2/FsUSTrSXMVXBl09n1KxQKquZrifZzcJtkpKnz+iNKkFHPFaIBazEKx5iiGYMyF
         5eVbQe8nPIs01yB6iK2TCYKMkxGc2JjNaHqah9rxgD5yiAaj2OXMvmp+7qcHZGP0yyUT
         73yg7NF02fYMWaUKaBJFTiFa3Fo+cAD7JCzmLn8xHx2qCG5n2dbLRLZGw8QJpKksAldN
         wWkg==
X-Gm-Message-State: APjAAAXsgNKbcLXQjdzJu+MKvqc3WBP5F+uBvh5YsKajYhZMHMi9P5D6
        6zfasjyyr5uUCMK7WCrDz3iAw3OIY5GNIVFCsGuCI24llKQaqaL9sey6GdmfKKSZ5wbJBNwLDtj
        qgLRBMr86/biW
X-Received: by 2002:adf:e40f:: with SMTP id g15mr11373874wrm.223.1579703738024;
        Wed, 22 Jan 2020 06:35:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxzVOuWpdVsL4u5Kc9GOTrtAXCJ9my4RfvoGG0hvJeCTDXsX7s7a0PNoQ87r7UEkiMImwavMg==
X-Received: by 2002:adf:e40f:: with SMTP id g15mr11373849wrm.223.1579703737717;
        Wed, 22 Jan 2020 06:35:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id 124sm4540042wmc.29.2020.01.22.06.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:35:37 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: fix overlap between SPTE_MMIO_MASK and
 generation
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <1579623061-47141-1-git-send-email-pbonzini@redhat.com>
 <CANgfPd8fq7pWe00fKm7QEiOAVFuubSQ-jJxEM1sCKzqJk9rSzw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41696542-3022-c794-cc43-66aa0aff5b46@redhat.com>
Date:   Wed, 22 Jan 2020 15:35:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd8fq7pWe00fKm7QEiOAVFuubSQ-jJxEM1sCKzqJk9rSzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 18:24, Ben Gardon wrote:
> BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK |
> MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK)
> 

Yes, this is a better assertion.  I've replaced it in the patch.

Paolo

