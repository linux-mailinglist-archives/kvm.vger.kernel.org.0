Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A4510424F
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 18:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfKTRnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 12:43:13 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43162 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726675AbfKTRnN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 12:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574271792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ei2j9pcZbx3d1j0CtKByFB03xBBGoihrjw0BBTcm0X4=;
        b=Pa2XxbmgfOlEloIjhGagAjaijVVhaxDPr07EU4iNZnoyYCL4M2vDtbtfqNzCwYgJLyEeOM
        Blkb+tsBIPrQ8pTyKL6cyjWdQV6RWm8wKAflAygLj53UmTn4/9ETNU40mLWJFjNm3T6FUl
        9yNFl/jC02CnMQtK79RN6qRcyejx4Ao=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-vBsK_bOpMLG7OlAu00Qjdw-1; Wed, 20 Nov 2019 12:43:09 -0500
Received: by mail-wr1-f69.google.com with SMTP id m17so108886wrb.20
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 09:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nLIxPj7yq9atMLNEK/9ztrIlmkBLqwoJhmt0Png8OD4=;
        b=bpayreH/R+uulqPN1M44JV0vhuuMC+NxWv1Z3A13CZYrYQzRSL5kQu7x0mqeLxd4VO
         WoYrZd2LdyycXA3F8c7eJA3iARETNVbn+TPAFURtdE60ADai0XPcnE94Oxy9qESiARaZ
         bMiFq2iljVEqXJmxXQku0pMWdlT3Y/ddKtd591l+IgVgkAEtTy3Ei10KKwpBf/MgdY5b
         fLZ9B7xO1uYmTioyUJhwqqlCrgvEtzXorO05nQkHS8XO04AzbQrrv+N/j9+mG+L5ylKJ
         hehergzySVXeUxL8WMUIqHPeYl0+Rxc9fZ2Ftv9G4YygOlj93WJXMJZYFafAl0/ZfYtE
         otiQ==
X-Gm-Message-State: APjAAAVT7NZGkGyZI7YiPTJO4IRhfhk1GHKH33VpdLkqzkcg6J0FszC7
        WcGIxsILDgosc0lGEZWwiWYyTOTgWgsJcgdE3UBm6zIE2Xx7tH+dmJSgRjd6D0XM3+nGhSM1cGS
        K6ex3ImGdhA0F
X-Received: by 2002:a1c:9e10:: with SMTP id h16mr4667615wme.91.1574271787991;
        Wed, 20 Nov 2019 09:43:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqypL94NSqM7vsTdufH8pYYlerT4XH52xDr/GZ9SjjnraF3oQSDmxm/dAI68MX0mc/nT8wmsdA==
X-Received: by 2002:a1c:9e10:: with SMTP id h16mr4667586wme.91.1574271787710;
        Wed, 20 Nov 2019 09:43:07 -0800 (PST)
Received: from [192.168.178.40] ([151.48.115.61])
        by smtp.gmail.com with ESMTPSA id t185sm8025318wmf.45.2019.11.20.09.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 09:43:07 -0800 (PST)
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI
 fastpath
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
 <87r224gjyt.fsf@vitty.brq.redhat.com>
 <CANRm+CzcWDvRA0+iaQZ6hd2HGRKyZpRnurghQXdagDCffKaSPg@mail.gmail.com>
 <87lfscgigk.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f13b9873-5187-1558-2599-453041beed4a@redhat.com>
Date:   Wed, 20 Nov 2019 18:43:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87lfscgigk.fsf@vitty.brq.redhat.com>
Content-Language: en-US
X-MC-Unique: vBsK_bOpMLG7OlAu00Qjdw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 13:26, Vitaly Kuznetsov wrote:
> What about ' << 4', don't we still need it? :-) And better APIC_ICR
> instead of 0x300...
>=20
> Personally, I'd write something like
>=20
> if (index > APIC_BASE_MSR && (index - APIC_BASE_MSR) =3D=3D APIC_ICR >> 4=
)
>=20
> and let compiler optimize this, I bet it's going to be equally good.

Or "index =3D=3D APIC_BASE_MSR + (APIC_ICR >> 4)".

Paolo

