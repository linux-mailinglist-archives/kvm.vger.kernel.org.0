Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76720112A07
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 12:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfLDLXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 06:23:01 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42101 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727331AbfLDLXB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 06:23:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575458579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QZnLrosPfN9d8D/YgQSkPEoCOg9aABTUH81VkBYisN8=;
        b=Di5bARyAgrI+Us3iQhfJhiZOYqezQqA0/ClATPzfLlZGbZhLbDIwhbYaueGUycqM88Jaas
        Ua2XE3ITLNNk89j8cnbwnicnstFshnsy4moJ/TdV3K51xT+89sIAU5EcxVJe8nDokKkII4
        tMayaKZZkT1Fe4HGYIclAnqBjcWf3Wo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-zXXsox1ZPA-rXBn2mqZfxg-1; Wed, 04 Dec 2019 06:22:58 -0500
Received: by mail-wr1-f71.google.com with SMTP id b2so3500615wrj.9
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 03:22:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QZnLrosPfN9d8D/YgQSkPEoCOg9aABTUH81VkBYisN8=;
        b=BdCpYFPicl2HEO1eFPcBuMwJW7rKHIy6JHg0j7VaA0OfBiT+UnAmbudRdphP8iInmB
         1YkdoYWoq9exMNv5QGzLc8dIYr3ufbJQ/WWZKiwJdQ2g7xmC1Tkgb61gPqQJxGBKqs/X
         NoWoaULSb54DFinaZ2dxF75oxXva9j/hjhN4nV3WrkNsHhDQFqlkuPLd0MEeZCbeRU2j
         p3ut+deLq59M8fqVPzCvGe/8TE+rp0j7DeP7o/aHLLQuujn6QXM07oAvodJ/3ueWFWcX
         gt0ELml2f1NobuDB1mjvh9bRVQPZE8V7X3Yl6ni7Dj3luto8PyrRcmB9Y5Eo42GZQLM1
         Pz6w==
X-Gm-Message-State: APjAAAUKZ50e8mVKP4HIv5yzu+XCGBeucGsytGZywBc09JO+kBzE9wHS
        SSI3VlPUCix+Iw4fRMYR3soIP2g/tVVESmYi65SLCLhChbhDouDqzoO5x0S1gxA/G2rmZ0jHPYD
        sp4BjqXb2EUnE
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr9940542wml.67.1575458577688;
        Wed, 04 Dec 2019 03:22:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqx7Jo9io1wZIZy+j2roCX4NAjKvWVYd89R4kHLpvIwvZkqe8KChoscrIhJVbZvjSZ/EQ8wO+w==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr9940521wml.67.1575458577443;
        Wed, 04 Dec 2019 03:22:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id e6sm6978993wru.44.2019.12.04.03.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 03:22:56 -0800 (PST)
Subject: Re: [PATCH] target/i386: relax assert when old host kernels don't
 include msrs
To:     Catherine Ho <catherine.hecx@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org
References: <1575449430-23366-1-git-send-email-catherine.hecx@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2ac1a83c-6958-1b49-295f-92149749fa7c@redhat.com>
Date:   Wed, 4 Dec 2019 12:22:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1575449430-23366-1-git-send-email-catherine.hecx@gmail.com>
Content-Language: en-US
X-MC-Unique: zXXsox1ZPA-rXBn2mqZfxg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 09:50, Catherine Ho wrote:
> Commit 20a78b02d315 ("target/i386: add VMX features") unconditionally
> add vmx msr entry although older host kernels don't include them.
> 
> But old host kernel + newest qemu will cause a qemu crash as follows:
> qemu-system-x86_64: error: failed to set MSR 0x480 to 0x0
> target/i386/kvm.c:2932: kvm_put_msrs: Assertion `ret ==
> cpu->kvm_msr_buf->nmsrs' failed.
> 
> This fixes it by relaxing the condition.

This is intentional.  The VMX MSR entries should not have been added.
What combination of host kernel/QEMU are you using, and what QEMU
command line?

Paolo

