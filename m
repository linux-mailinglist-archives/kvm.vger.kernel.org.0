Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A4A114087
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 13:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbfLEMII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 07:08:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729099AbfLEMIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 07:08:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575547687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KKnePFkA3a3Jg8CAkFy2V9ZPhak/skft+CWcf44aQ2I=;
        b=E9hsmWva3PFczTfk8cjepVm1S4/kqFrUW8TnW3GL7/r9wVZFUoCEXCwdAsYqJxvdVbismT
        v6Ix0OzyNLh42JGPoUCriw3g13TZBF2AXJsqYbm82Iv3pPbx2JMTiN9F7ZY3QPJO1CarQb
        +O5hEuCpeNirNPIGLEwjDEJwQg5XEQc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-4J0bsfccOw67RqrmXTQTzA-1; Thu, 05 Dec 2019 07:08:03 -0500
Received: by mail-qt1-f198.google.com with SMTP id r9so2305960qtc.4
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 04:08:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Yem3+ayZlS+BgE7nY75md4w+1lEY3LEm7zBYY/k2QI0=;
        b=ECrQECCWcthXpMfgiJTIYS5+man4fRf0fQXNMQzDhj0UXVleOID9UNvPo/6Kq3j/Cp
         7WbaPoJ+FT3W+ONkcMklPO+FaMOPeHNTReAsmGYC0MgRAQ+gxJUJNtTX6x5YUDUl3WkP
         MMezaKV+4fc6LOY5dda0n2HJCdToEuquDOvgGtcTiX8tJ5tgj+rOPk8eHbNCIfyZIQiG
         NOKJSiBTp63LpoXVwn29pfoOWM0mGISuK1O2+CzedZoLVL8MFNZWmztV6spd3XwP45Fc
         9jM32stWO0m+JR43kw4yjF0y16Yye2PPHMvg0Oa9pURvGgEwSLve1OF8wmz6j21iUOBe
         hlnA==
X-Gm-Message-State: APjAAAV/m1WEcEKRPcNcXVsDAVPb0OGdB80jjTn+fMxWkx42jIIa+U93
        yDzDfZ6WXcYtZVE4qz0q1r2GY9vqXXMxIfC52fxARtWVn7VzLt8clSiYW6KPSn6Kpy3beFuuP9u
        5cm9UIWjnE+zz
X-Received: by 2002:a37:4fd8:: with SMTP id d207mr8005355qkb.464.1575547683443;
        Thu, 05 Dec 2019 04:08:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqzv5vOShNoFbd+6gSSN/Gfy3KctDqYfqTl5MT4r+Q4WJy0wMFLWSpW3G+um69pHLx6/zwlxIA==
X-Received: by 2002:a37:4fd8:: with SMTP id d207mr8005316qkb.464.1575547683077;
        Thu, 05 Dec 2019 04:08:03 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::3])
        by smtp.gmail.com with ESMTPSA id y184sm4852359qkd.128.2019.12.05.04.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 04:08:02 -0800 (PST)
Date:   Thu, 5 Dec 2019 07:08:00 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191205120800.GA9673@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191204195230.GF19939@xz-x1>
 <efa1523f-2cff-8d65-7b43-4a19eff89051@redhat.com>
MIME-Version: 1.0
In-Reply-To: <efa1523f-2cff-8d65-7b43-4a19eff89051@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: 4J0bsfccOw67RqrmXTQTzA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 05, 2019 at 02:51:15PM +0800, Jason Wang wrote:
>=20
> On 2019/12/5 =E4=B8=8A=E5=8D=883:52, Peter Xu wrote:
> > On Wed, Dec 04, 2019 at 12:04:53PM +0100, Paolo Bonzini wrote:
> > > On 04/12/19 11:38, Jason Wang wrote:
> > > > > +=C2=A0=C2=A0=C2=A0 entry =3D &ring->dirty_gfns[ring->dirty_index=
 & (ring->size - 1)];
> > > > > +=C2=A0=C2=A0=C2=A0 entry->slot =3D slot;
> > > > > +=C2=A0=C2=A0=C2=A0 entry->offset =3D offset;
> > > >=20
> > > > Haven't gone through the whole series, sorry if it was a silly ques=
tion
> > > > but I wonder things like this will suffer from similar issue on
> > > > virtually tagged archs as mentioned in [1].
> > > There is no new infrastructure to track the dirty pages---it's just a
> > > different way to pass them to userspace.
> > >=20
> > > > Is this better to allocate the ring from userspace and set to KVM
> > > > instead? Then we can use copy_to/from_user() friends (a little bit =
slow
> > > > on recent CPUs).
> > > Yeah, I don't think that would be better than mmap.
> > Yeah I agree, because I didn't see how copy_to/from_user() helped to
> > do icache/dcache flushings...
>=20
>=20
> It looks to me one advantage is that exact the same VA is used by both
> userspace and kernel so there will be no alias.

Hmm.. but what if the page is mapped more than once in user?  Thanks,

--=20
Peter Xu

