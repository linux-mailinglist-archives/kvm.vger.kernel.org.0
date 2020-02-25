Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C9E16E9B5
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbgBYPMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:12:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40560 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730772AbgBYPMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 10:12:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n9AuFaGX+OfC1AhBs7I+WP0Y97RXtgeXjaWUzUUvUtc=;
        b=RPxwIDFrqzHguN9z6tUMnlAb93TCAuv1DqN8+JKtPNk8ltXPA7xGN/BcGsItFx7Su240fG
        ltziRip6AFIbP3LVdrdmg1cmS7MLKfzt5tLugw4l/LJ5Sqbk6k/2Or0GnXWr+1S4ZfWOqB
        njYI00KnB+MMUR2K2a59cS5qeMLy+Gg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-b1xt-gdVNr6e1sKC0Wab-w-1; Tue, 25 Feb 2020 10:12:31 -0500
X-MC-Unique: b1xt-gdVNr6e1sKC0Wab-w-1
Received: by mail-wm1-f69.google.com with SMTP id p2so1145608wmi.8
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 07:12:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n9AuFaGX+OfC1AhBs7I+WP0Y97RXtgeXjaWUzUUvUtc=;
        b=IEWgVCH2H2MoBeVF9Wf0bbh5QJCdEaWTMY2LwVJcgufld/reCw6q2CUZzRDvq+B+Cx
         +XXRczPSJtsYBreJSjbWdFoWT15A9H3L4p70s4LxvlS/XAjEN5nxGFxrcdX9UiWf6dq1
         WSaJV7buCqvwPrJvG0udTfZ40dh5XKGVzwWTCgbOhMv9x/3hYXx2HOrEOCUHQDChX8lk
         EluiE92J0rNacv6HI8D9tdWoTCfPOZX6wUR2XWN61seplkUkSU7ajuTWYxHFKQAGGqHS
         SxyA0rcnDrvHJuBJrVAyZiCLmPhVkO831qjGfJLq6Lk/vMfW7WeCitj/ZYjXX62Q3FR6
         mGiw==
X-Gm-Message-State: APjAAAW/2J0kz51oWFxG+XZboqoxHhcHke0KozeinSVuNRi+4tLHcBX1
        bJF3TJ0JXPvz/kf34MC/no/R4P/OSDn+kJ3IXHcwhEoWxUkNM3crkO8ih30gNI3751WOrPD/6g9
        uMCP5NUgb98e2
X-Received: by 2002:a1c:4c8:: with SMTP id 191mr5689500wme.148.1582643550168;
        Tue, 25 Feb 2020 07:12:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPmXEjpuSQxnI4Q0UL9dt+lV+yrzN5FG9QIOg/h6vSPdSjGw8Qc+qU8/RjoS3W49r/+7syWQ==
X-Received: by 2002:a1c:4c8:: with SMTP id 191mr5689424wme.148.1582643548994;
        Tue, 25 Feb 2020 07:12:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id f1sm24558217wro.85.2020.02.25.07.12.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:12:28 -0800 (PST)
Subject: Re: [PATCH 43/61] KVM: x86: Use KVM cpu caps to mark CR4.LA57 as
 not-reserved
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-44-sean.j.christopherson@intel.com>
 <8736azocyp.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66467dd7-09f0-7975-5c4e-c0404d779d8d@redhat.com>
Date:   Tue, 25 Feb 2020 16:12:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8736azocyp.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/20 23:08, Vitaly Kuznetsov wrote:
>> +
>> +static __always_inline bool kvm_cpu_cap_has(unsigned x86_feature)
>> +{
>> +	return kvm_cpu_cap_get(x86_feature);
>> +}
> I know this works (and I even checked C99 to make sure that it works not
> by accident) but I have to admit that explicit '!!' conversion to bool
> always makes me feel safer :-)

Same here, I don't really like the automagic bool behavior...

Paolo

