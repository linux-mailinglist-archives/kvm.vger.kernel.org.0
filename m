Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3188A112E93
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 16:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfLDPg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 10:36:27 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55363 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728256AbfLDPgX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 10:36:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575473781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQOOeXeSC4acVeDbgVDeAqxSN0LyEEhsWxQonnVcIBc=;
        b=S8ZW8EwdT7uzSYnGXRFwP/tzp0mHsw82eFOF1pnJhOO/5jDzBLVdtzYMqoGcTqn799z+ev
        JGGpnefNZueaRoeEJX6+4Tiqal1E7TtGEc6YmKo52BSQwoiOUauORtY7ypWaDk4J2wE67B
        FaPswPC/wIJ1yFw3OtZfqkkHTfGq2fU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-NyBIbXopMnyBh7Y1mZTlRQ-1; Wed, 04 Dec 2019 10:36:20 -0500
Received: by mail-wm1-f70.google.com with SMTP id g26so525831wmk.6
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 07:36:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iQOOeXeSC4acVeDbgVDeAqxSN0LyEEhsWxQonnVcIBc=;
        b=fL8wNUxAxweXfurjpxET3xP52YLYrFh+9/1YAlSJwYq2RG3/aV/Pcqq8TXvkl0rnft
         SzHKOY1zrHpRFLcwRzRs3qVbbaRoQtmdZHr9uyxGWUkFDpici6p+UmtxTMMkTbVNrF2s
         dJUaXFwW6RsUSlAqxXzUmhUUHRV3MPEzSHbSv30xSId/t3cCJNUBPyGVRO/3EDnrdhh+
         WbfkS+UNBFaGHbV0zGIffmXw2pNhIU9WLGvWeGOyQYJNtjKZyfyr+PrYJAeHwxc9sGZI
         tOsiNSxl5+54KDX+kr1OHtytH7Dxkfdb/8DB1RRTh/6lWdU9igo5LIVFu8kAe30x1T5o
         uaAg==
X-Gm-Message-State: APjAAAWa2+3nyC2nolrtcUpPT8gyUK5GZOFjlPjSk2DEyxM8slCXTOa8
        MwMYNLHKavFhXR7OYuooERGUjfrgxd+XmjWLk/bu+SNEOAf5eyZVhz98sM8ILgsYgPnE6xgU7CI
        AsyLoJ/K0xWEA
X-Received: by 2002:adf:e984:: with SMTP id h4mr4581506wrm.275.1575473779565;
        Wed, 04 Dec 2019 07:36:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqy/M5MWOKcaMYIoGibWVUMRdDrTEapMHfZlP1x2J2svqUsmIkTvIxs8nBkMZJD5A0y+qXkVRg==
X-Received: by 2002:adf:e984:: with SMTP id h4mr4581491wrm.275.1575473779351;
        Wed, 04 Dec 2019 07:36:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id n188sm8242847wme.14.2019.12.04.07.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 07:36:18 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <1575471060-55790-1-git-send-email-pbonzini@redhat.com>
 <20191204152942.GB6323@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d46bd0a8-5743-4665-85ea-14351fd85cdd@redhat.com>
Date:   Wed, 4 Dec 2019 16:36:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191204152942.GB6323@linux.intel.com>
Content-Language: en-US
X-MC-Unique: NyBIbXopMnyBh7Y1mZTlRQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 16:29, Sean Christopherson wrote:
> 
> The extra bit of paranoia doesn't cost much, so play it safe?  E.g.:
> 
> 	if (unlikely(boot_cpu_data.extended_cpuid_level < 0x80000008)) {
> 		WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_TME) || SME?);
> 		return boot_cpu_data.x86_phys_bits;
> 	}
> 
> 	return cpuid_eax(0x80000008) & 0xff;

Sounds good.  I wouldn't bother with the WARN even.

Paolo

