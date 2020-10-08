Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FEC286EE2
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 08:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgJHG43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 02:56:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbgJHG42 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Oct 2020 02:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602140187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Knzyk4WI/UuS965rVOwx7edfDVSiZEvMd9Jnqw2zp7M=;
        b=g10GjPSc1gzAwXEoZx/fNkJM5F8JtsGCvJzoKt/IAE3u1XVV2MZQ/3KS0JhkWMBc7GV4gf
        Ucms9LmtzC2OQs3GzCjFGw7KVhvxzgEMTnb99zOgzBy/j6uuq6aMC1cyXPppTa+2zu5Qb1
        F1E0JZjMAiObwGiH8BYywYUvT7ngotY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-UP37N3VLPtGovuJqkcc8qQ-1; Thu, 08 Oct 2020 02:56:25 -0400
X-MC-Unique: UP37N3VLPtGovuJqkcc8qQ-1
Received: by mail-wr1-f70.google.com with SMTP id b6so3511105wrn.17
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 23:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Knzyk4WI/UuS965rVOwx7edfDVSiZEvMd9Jnqw2zp7M=;
        b=lr6hxBvCHoJQDBwAcVBq0UUH2Mkge0T1BP/i6Qo7PlACsYsVySmS+m5MAv5UBvKf7Z
         m96lLgtQuk1PM4C/yyFgNWQx1LVqy8SFTzxsUJduYUv8tTnOIXv9md1ZrYCVV9OzlHs8
         9foKPGLjlIL1r9TlZHgE4kGkFbfhz7ObyI92PO0B1YPgiOfm82IZaKKhrL4Vx9sIk0Qb
         Be9Cvw/q5l2JTc2Bs20i2fPqJyy/0mxv9AlXWeEapuVPtAkFSVnGIwVhtwgJulA6eQF3
         X4K12XciddPmqKW/TFJMOsNcMvjhi4D9YOP/sNjift5aFtDyXS1tNErNm17lnnR+qt/y
         BazQ==
X-Gm-Message-State: AOAM530DzJ3zp7wpyllOiN9whVkYjHWeTuVvhSe370+sBbqBqmSdH0qo
        weuaYwa95tI3pim4OJJFSprJ81RFLI+YUc/1yDEr/pyyH8irpv+kNgO1fx7caxmZ7TxwyhQ655Z
        Yzc0hQsd+BZeV
X-Received: by 2002:a1c:e444:: with SMTP id b65mr6662999wmh.147.1602140184435;
        Wed, 07 Oct 2020 23:56:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyB+WHlDZnVcehp7G/TprfzAJExRwHcGmZshjkG98JqbC6UZlYcAeA0r6WGFdMrD2u5joQ0bQ==
X-Received: by 2002:a1c:e444:: with SMTP id b65mr6662980wmh.147.1602140184145;
        Wed, 07 Oct 2020 23:56:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bb8c:429c:6de1:f4ec? ([2001:b07:6468:f312:bb8c:429c:6de1:f4ec])
        by smtp.gmail.com with ESMTPSA id f14sm5668229wme.22.2020.10.07.23.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 23:56:23 -0700 (PDT)
Subject: Re: [PATCH] target/i386: Support up to 32768 CPUs without IRQ
 remapping
To:     David Woodhouse <dwmw2@infradead.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     x86 <x86@kernel.org>, kvm <kvm@vger.kernel.org>
References: <78097f9218300e63e751e077a0a5ca029b56ba46.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6f8704bf-f832-9fcc-5d98-d8e8b562fe2f@redhat.com>
Date:   Thu, 8 Oct 2020 08:56:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <78097f9218300e63e751e077a0a5ca029b56ba46.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/20 16:18, David Woodhouse wrote:
> +        if (kvm_irqchip_is_split()) {
> +            ret |= 1U << KVM_FEATURE_MSI_EXT_DEST_ID;
> +        }

IIUC this is because in-kernel IOAPIC still doesn't work; and when it
does, KVM will advertise the feature itself so no other QEMU changes
will be needed.

I queued this, though of course it has to wait for the corresponding
kernel patches to be accepted (or separated into doc and non-KVM parts;
we'll see).

Paolo

