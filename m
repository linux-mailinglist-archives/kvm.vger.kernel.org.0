Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 386D8F770A
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKKOur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:50:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54706 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726973AbfKKOur (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 09:50:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573483845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=/Y+HzRAUFsvF1UeJYBbnveE27mBFQ3aDExiHToOSyEQ=;
        b=PEH98mcKSiWgCPrCFkofgFGsrtQ7Kp5QW4pL5JcfGWzbsVyXgVG7hfcbfSkiwmyPMDu8Wk
        e77CTRwDSH+eTQvBmq74LJlUtKrSZT2V/vQsuuAlcyUU55ICp4EqTecD+RpcEhzQfC/KEA
        JD4X8CPG4efNFOA1m4yVava6Y+7lXiQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-QrYni5D7PFicVS_JxDBOeQ-1; Mon, 11 Nov 2019 09:50:44 -0500
Received: by mail-wm1-f69.google.com with SMTP id i23so6997267wmb.3
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 06:50:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iaFA4bHv7jp36SejhQlPRd3q9YGfxhKuzIJmkD+93Io=;
        b=Mf7dA1OmZqZT5a7g0A/kEXg18EQC8dVWzkq+l4OrGKviaedekxULwIxedsXDr3SRUK
         YhaGz8hxEtO61zPuDGs/d1j6z3r91+5e2o0HaQCjcRutNpkOPg42Wosg8U2lcjuQ5iWN
         3RA88mKsZobEUOrYugOCShSXQX0XU32y+uU4zTYznzAxBK1zLyQzCI6dmOzB3/e/FEqF
         k4M3htlrmLEaZqJ3gVVuN3eSS5ko0JYIiPXy6MNnOh0YpyGjywN0tF8c5//WUKj2qG6f
         9YkAgerOiNMmPNR87y54+2aPYcSUNH23jgWj8OQVbFHXw14HXz3iEhO/2Hn+lRvtVlJW
         eaHg==
X-Gm-Message-State: APjAAAVblkS6aQ5VF90ctvg/LjR0ejki1C3O+BczL3s28mQCkoHR1mvy
        LFbAjHpGsDRwpRK8mpCdXXktq0sQIy9L04K9/2CrXlau+Evl0jF2MKCH50C9dF3Q7f9Jy3mURCW
        dOaPrzoQ5zx+f
X-Received: by 2002:a1c:3cc4:: with SMTP id j187mr21452271wma.95.1573483843232;
        Mon, 11 Nov 2019 06:50:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqyRwEQKjjsoIXFVPG/PbMwIt90Q3xXl7n2S/Gz45ULYs6aT865MpeUzZYI6Iq8zWHEBX+0ncA==
X-Received: by 2002:a1c:3cc4:: with SMTP id j187mr21452248wma.95.1573483842965;
        Mon, 11 Nov 2019 06:50:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id v184sm21048418wme.31.2019.11.11.06.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 06:50:42 -0800 (PST)
Subject: Re: [PATCH v1 2/3] KVM: VMX: Do not change PID.NDST when loading a
 blocked vCPU
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
 <20191106175602.4515-3-joao.m.martins@oracle.com>
 <15c8c821-25ff-eb62-abd3-8d7d69650744@redhat.com>
 <314a4120-036c-e954-bc9f-e57dee3bbb7c@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <49912d14-1f79-2658-9471-4193807ad667@redhat.com>
Date:   Mon, 11 Nov 2019 15:50:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <314a4120-036c-e954-bc9f-e57dee3bbb7c@oracle.com>
Content-Language: en-US
X-MC-Unique: QrYni5D7PFicVS_JxDBOeQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 15:48, Joao Martins wrote:
>>>
>>> Fixes: c112b5f50232 ("KVM: x86: Recompute PID.ON when clearing PID.SN")
>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> Something wrong in the SoB line?
>>
> I can't spot any mistake; at least it looks chained correctly for me. Wha=
t's the
> issue you see with the Sob line?

Liran's line after yours is confusing.  Did he help with the analysis or
anything like that?

Paolo

> The only thing I forgot was a:
>=20
> Tested-by: Nathan Ni <nathan.ni@oracle.com>
>=20
>> Otherwise looks good.
> If you want I can resubmit the series with the Tb and Jag Rb, unless you =
think
> it's OK doing on commit? Otherwise I can resubmit.

