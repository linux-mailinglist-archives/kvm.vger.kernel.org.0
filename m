Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74850EBA2E
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 00:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfJaXJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 19:09:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728598AbfJaXJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 19:09:03 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 10FF683F45
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 23:09:03 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id f2so3335274wmf.8
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 16:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mATxAs5QUuHhGLu4F5uya27TIQoq4oCslUyJ/ewXecc=;
        b=CfO/Zy4nTSph+nM6oIbgFQPS0J3OymtRx0RIvXKalmtdbg3FpS5Dhkb7MLwrtp+b7U
         ots940IbbOKCuQKluTVQv8HjvFXLV8st8kGVq4ttYZDAP3xhNJa5yFjmaTEQF0jVGSJy
         w3faatt4Dhhko391N81MO+D85N/Ioo1sRcwO4SwDzxQba3x6m15hhx03fuK+RN6PBH+s
         RWe6kNdRYuz9J0pnc+QotfJiJw4hB1rhdEcUQkpD8RjDWIUNSrw92txYpqyNP7amK/pc
         bb+vEmbkUXr6HRh/Rc3BYiEnB+XU6LWLJhOcvV4M9NOieGsqdyW2g+LVZedhL2wQTfdf
         263g==
X-Gm-Message-State: APjAAAWD7EcfhTBmCdptg14qHWKI/N953+lTS83QkIIFufsg4qDr+CPz
        MtRH/YK5Y650urZa0Z6z8NFze3Wun6w93t0mU2qOLY3+miJVdyDTd0f3PiwUjdeWffLrx2dJVd/
        MsD83y/vt0Xh6
X-Received: by 2002:a5d:526a:: with SMTP id l10mr4422741wrc.72.1572563341599;
        Thu, 31 Oct 2019 16:09:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzHKNAtsHbJkc9+5ud92PKvpwuft/n6upWOztoYCIkE5v3ubSmQnx0vJT0OfWCTVMMKSJrLyg==
X-Received: by 2002:a5d:526a:: with SMTP id l10mr4422722wrc.72.1572563341337;
        Thu, 31 Oct 2019 16:09:01 -0700 (PDT)
Received: from [192.168.20.72] (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id u187sm5035303wme.15.2019.10.31.16.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 16:09:00 -0700 (PDT)
Subject: Re: [PATCH v3 15/16] kvm: x86: ioapic: Lazy update IOAPIC EOI
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1568401242-260374-16-git-send-email-suravee.suthikulpanit@amd.com>
 <3771e33d-365b-c214-3d40-bca67c2fa841@redhat.com>
 <5581f203-b9de-7f33-8afc-0d7026387a46@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <46754b8f-ed86-f622-0f9a-0fc1ffb2cb0c@redhat.com>
Date:   Fri, 1 Nov 2019 00:09:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5581f203-b9de-7f33-8afc-0d7026387a46@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/10/19 16:17, Suthikulpanit, Suravee wrote:
> What if we change kvm->arch.apicv_state to kvm->arch.apicv_disable_mask 
> and have each bit representing the reason for deactivating APICv.
> 
> For example:
>      #define APICV_DISABLE_MASK_IRQWIN        0
>      #define APICV_DISABLE_MASK_HYPERV        1
>      #define APICV_DISABLE_MASK_PIT_REINJ     2
>      #define APICV_DISABLE_MASK_NESTED        3
> 
> In this case, we activate APICv only if kvm->arch.apicv_disable_mask == 
> 0. This way, we can find out why APICv is deactivated on a particular VM 
> at a particular point in time.

Yes, that also works for me if it makes for an easier implementation.

Paolo
