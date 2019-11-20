Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB7103A1B
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 13:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbfKTMd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 07:33:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34050 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727845AbfKTMd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 07:33:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574253235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hDEGjYwfPSlpk5kc526ke8LgFJkbaaKnKQB2+ZMTOJA=;
        b=X9vWOTuZagotUyLBMInYMeYDW1cVb3kftTfAjfI1MNGBdiyRAwFIZj4jnz754p10yW4Exu
        vqjWXTVs+FnstzzcYEFPitA2hXmpJtGdI/mkeLnzEZvlgxqqQXP470hKP50zY5Rp6GKzo3
        Gk799UGJ5e3IFoNdktnTtCUbMZsOYEc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-3sml9RpDNR2vlVLxTYXSTA-1; Wed, 20 Nov 2019 07:33:54 -0500
Received: by mail-wm1-f72.google.com with SMTP id 2so5055500wmd.3
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 04:33:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SJ127gtEOsgnqOjk57d0lGlsBueTu+Z8QRRvitzC3aU=;
        b=HZe+p4QrYBIfUcOIttTN189y2WJjBg/8irib2dhGcyILAKYbpnPMeO0xNm9D9PSXe0
         5p67pVdW1fFcUUgO6E/spDbXKes2yX3Ip3lwO1EF5k7Gq2cd72ho8h+j6Lxzl2wMvzFZ
         k71+f4ZiS4U+5ETWQKdIomjcA02eS/H4EUi7zwVvY8dO8hvVDnqj8IU5CtWDHsJ6OZmI
         BJUYS37e9l8EYbb/QFxsMW2K92zF13L6MFvqzD9OlPDJoZ6O/EKRau1DHgXVUJpOpmcO
         GDjbxXc6gSxS0EHfgdUGRPbprOCKFpKOu9Y93KLL0zhPPqP1oTK86JBv0WyNFfN45oE0
         XKxg==
X-Gm-Message-State: APjAAAVM+lNa3CxhI6RhjjjB1O060YywAev6PnjIwvqcCE4YPWjlTIcf
        N4p6PiHSw1Cd3wWbOcSwnPM5B/4cu71JgbMaItQole11oCLYsO59S5FsQJjJV+Parjt7EIWMbFT
        ftvg0Be+y9rz3
X-Received: by 2002:a1c:a512:: with SMTP id o18mr2866097wme.4.1574253233161;
        Wed, 20 Nov 2019 04:33:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjBY1pEIFdzQg3nliRwValwzusj6ZnGuzsbaO+x2qEPD7G2UTNso0DUkrCJFtjTT0/sXfFHw==
X-Received: by 2002:a1c:a512:: with SMTP id o18mr2866072wme.4.1574253232865;
        Wed, 20 Nov 2019 04:33:52 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:dc24:9a59:da87:5724? ([2001:b07:6468:f312:dc24:9a59:da87:5724])
        by smtp.gmail.com with ESMTPSA id m9sm30457516wro.66.2019.11.20.04.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 04:33:52 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Zero the IOAPIC scan request dest vCPUs bitmap
To:     Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        rkrcmar@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
References: <20191120121224.9850-1-nitesh@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <24c18608-2731-c560-8677-26498e848a39@redhat.com>
Date:   Wed, 20 Nov 2019 13:33:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120121224.9850-1-nitesh@redhat.com>
Content-Language: en-US
X-MC-Unique: 3sml9RpDNR2vlVLxTYXSTA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 13:12, Nitesh Narayan Lal wrote:
> Not zeroing the bitmap used for identifying the destination vCPUs for an
> IOAPIC scan request in fixed delivery mode could lead to waking up unwant=
ed
> vCPUs. This patch zeroes the vCPU bitmap before passing it to
> kvm_bitmap_or_dest_vcpus(), which is responsible for setting the bitmap
> with the bits corresponding to the destination vCPUs.
>=20
> Fixes: 7ee30bc132c6("KVM: x86: deliver KVM IOAPIC scan request to target =
vCPUs")
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  arch/x86/kvm/ioapic.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index ce30ef23c86b..9fd2dd89a1c5 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -332,6 +332,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *=
ioapic, u32 val)
>  =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
>  =09=09=09irq.dest_id =3D e->fields.dest_id;
>  =09=09=09irq.dest_mode =3D e->fields.dest_mode;
> +=09=09=09bitmap_zero(&vcpu_bitmap, 16);
>  =09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>  =09=09=09=09=09=09 &vcpu_bitmap);
>  =09=09=09if (old_dest_mode !=3D e->fields.dest_mode ||
>=20

Queued, thanks.

Paolo

