Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F0727FA5F
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 09:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgJAHjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 03:39:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725878AbgJAHjJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 03:39:09 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601537948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QIWTzCXKkMg/CKhfRHWpTjVDVAjxRLdwdegBES+XJQ8=;
        b=glws4Js18WlmGR57CBw2VZ/R8QVtbeAJ7jujXOwDrFsSYT0aBa44Q/5JFguueYVk9EjE2y
        y4/mAAHmFVQP8JiGoGQPJ7IfZpxNG2bsF95/XBHPRFP7VhXmikKUIIRHXA8o6+qPw38Z8u
        BZoid/PATxJ107CwndtCTUKGa0gBe+U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-Pep36yG6M-K0M5E6RqHDHw-1; Thu, 01 Oct 2020 03:39:03 -0400
X-MC-Unique: Pep36yG6M-K0M5E6RqHDHw-1
Received: by mail-wm1-f69.google.com with SMTP id c204so619242wmd.5
        for <kvm@vger.kernel.org>; Thu, 01 Oct 2020 00:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QIWTzCXKkMg/CKhfRHWpTjVDVAjxRLdwdegBES+XJQ8=;
        b=O40/tFofbCqqFCvloqP0nCh68e77zjnP8T0yRLX73R4cuM15AP/nfb+UiGkiUqb0y2
         9ZOzWYPYMD5FsifkAVHu9wniiizRaaz/TpG34Ww7M8wVNQdnZNDSBW3398STwmS5d2aq
         pud4MdBFUQNq9OwB0bFWb5Si5wp+ukGXv/tQ9g6C7vhYvYe/i7XpU3rCxpww/8dwEgHe
         9JXTBM3VQIsbPs0bp5iKtoY1sW3fKb6oFS67wVpVDVegnHwts9TDLOCO9TtcbWWVw48i
         6c342XfPvGbdlesk123PcL1d8RDDnYcb+ui1zw9TZptQSSqgwXmzFD32Emtz4tiSrBbp
         1lNw==
X-Gm-Message-State: AOAM531LmdlQZEl1ltRO8NzxDGdvwVd0oDssrUdLiI+7zJu17JX9Gwl1
        zIgwKsmaYp310xvrDcRdpMHB20fPpvKUiKWVEKB8rfy2PvmE/VQrknAlwXAEqUXDBRVsD9lG/FB
        kLDV/M3A2hQJg
X-Received: by 2002:a05:600c:2283:: with SMTP id 3mr6713956wmf.37.1601537942343;
        Thu, 01 Oct 2020 00:39:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9/L8Rc7SLTmXPgg+Bvp6N6o14YdHqxMvbxbXGnz8qDU/20+hvoQI5Zr9xZVHhilSC+tgmYg==
X-Received: by 2002:a05:600c:2283:: with SMTP id 3mr6713941wmf.37.1601537942116;
        Thu, 01 Oct 2020 00:39:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:aecc:db56:dd3f:503b? ([2001:b07:6468:f312:aecc:db56:dd3f:503b])
        by smtp.gmail.com with ESMTPSA id n66sm7270051wmb.35.2020.10.01.00.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 00:39:01 -0700 (PDT)
Subject: Re: [PATCH v3 17/19] hw/arm: Automatically select the 'virt' machine
 on KVM
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-18-philmd@redhat.com>
 <CAFEAcA-Rt__Du0TqqVFov4mNoBvC9hTt7t7e-3G45Eck4z94tQ@mail.gmail.com>
 <CAFEAcA-u53dVdv8EJdeeOWxw+SfPJueTq7M6g0vBF5XM2Go4zw@mail.gmail.com>
 <c7d07e18-57dd-7b55-f3dc-283c9d13e4b5@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8253ddd7-3149-17d9-1174-6474c4bde605@redhat.com>
Date:   Thu, 1 Oct 2020 09:38:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <c7d07e18-57dd-7b55-f3dc-283c9d13e4b5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/20 22:36, Philippe Mathieu-Daudé wrote:
> Yes, the problem if I don't restrict to KVM, when
> using the Xen accelerator odd things occur
> (using configure --enable-xen --disable-tcg --disable-kvm):
> 
> Compiling C object libqemu-i386-softmmu.fa.p/hw_cpu_a15mpcore.c.o
> hw/cpu/a15mpcore.c:28:10: fatal error: kvm_arm.h: No such file or directory
> 
> See
> https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensions#Use_of_qemu-system-i386_on_ARM

I don't understand.  Is Xen adding CONFIG_ARM_VIRT=y to
default-configs/i386-softmmu.mak??

(By the way, there are duplicate Kconfig symbols between target/arm and
hw/cpu, they could/should be removed from target/arm).

Paolo

