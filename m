Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB84104EAC
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 10:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKUJFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 04:05:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51113 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726522AbfKUJFK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 04:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574327108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=0QtQuu09o5QNKgYtWCF+4b0Y6CbLhNjyGhj4YvgNl5k=;
        b=GFdPAPox84ufM7eW/eJn5jYkSPz5kp1qJcBp5KyUa0dv0xLA+pbWVVYfSV9I1zvnZqVcO+
        AQLn2ClOHmA7Xxlj3qtxgvXJMNx6K7g/6ckCxM2gtNwbMWr7qjyMLzn38wmGGh+vKcOtP0
        EJIWKcqlkYyq6iGFMbcIEBkezEiBs30=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-MDPXXyYeP9a6ygcSF6LhPQ-1; Thu, 21 Nov 2019 04:05:07 -0500
Received: by mail-wr1-f71.google.com with SMTP id w4so1711342wro.10
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 01:05:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XBm+z3cdzTP7CNbhssHneXhkoTVhQCWR4VgNKD6J1z0=;
        b=UQGI1zi+McI3ApT42EXaUqjazEv07fxy45Nb71xSWt7Ouj1+0iG4kitbD5VAsE7zax
         H+Bl7YMzuPa15vVpINEYXktRW6Em1/131m8ZzXvlDEA6jgIqAOCg6dK5fvP3+N7iqTM5
         pGj1fpzQzFxGmHzCC2w2YATchw+WxfwRscm0OgsLJIFeVYd+8Z/DPmBPhlB35tkOv0Rt
         HtzeAhj7JVzlmfB7FslcUxHL7TGvOyzfbr0cP6qK8LOvXHuRtuJ3HkGJC6XSm6LnKZRW
         z3fFeASW5FljytSwm3Hc++adEuS+QvfhJYGkBgjsGxgeZuHGWDbuAJgv1SBh5ITjjGmE
         VivA==
X-Gm-Message-State: APjAAAU9g1RUZoPgPNopsED57NJGTMOhRdMXPnlU7sCic3zikrK2Fmkl
        eJ0SSaq7SgOIkWfmdPhkbexqOzAADUpq/cadcw6Gtdf0fIGBiGKlAHfrFOb6ZXPSdN32pejYIRm
        L0r/fcDiFxGa+
X-Received: by 2002:a5d:670a:: with SMTP id o10mr9449028wru.312.1574327106023;
        Thu, 21 Nov 2019 01:05:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqzJ6SdvqrxGlL+G5qHGtGh5pIp54sLOBUVVTvRXry36/euw4epCRoQtato4BdyE8ww3umRS3g==
X-Received: by 2002:a5d:670a:: with SMTP id o10mr9448981wru.312.1574327105645;
        Thu, 21 Nov 2019 01:05:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id h15sm2660920wrb.44.2019.11.21.01.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 01:05:05 -0800 (PST)
Subject: Re: [PATCH 5/5] KVM: vmx: use MSR_IA32_TSX_CTRL to hard-disable TSX
 on guest that lack it
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
 <1574101067-5638-6-git-send-email-pbonzini@redhat.com>
 <20191121022252.GX3812@habkost.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4a820b71-79eb-7d71-9cd2-93954cefcdd2@redhat.com>
Date:   Thu, 21 Nov 2019 10:05:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191121022252.GX3812@habkost.net>
Content-Language: en-US
X-MC-Unique: MDPXXyYeP9a6ygcSF6LhPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/11/19 03:22, Eduardo Habkost wrote:
> On Mon, Nov 18, 2019 at 07:17:47PM +0100, Paolo Bonzini wrote:
>> If X86_FEATURE_RTM is disabled, the guest should not be able to access
>> MSR_IA32_TSX_CTRL.  We can therefore use it in KVM to force all
>> transactions from the guest to abort.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>=20
> So, without this patch guest OSes will incorrectly report "Not
> affected" at /sys/devices/system/cpu/vulnerabilities/tsx_async_abort
> if RTM is disabled in the VM configuration.
>=20
> Is there anything host userspace can do to detect this situation
> and issue a warning on that case?
>=20
> Is there anything the guest kernel can do to detect this and not
> report a false negative at /sys/.../tsx_async_abort?

Unfortunately not.  The hypervisor needs to know about TAA in order to
mitigate it on behalf of the guest.  At least this doesn't require an
updated userspace and VM configuration!

Paolo

