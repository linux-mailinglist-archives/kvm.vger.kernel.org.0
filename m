Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8A83F5877
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 08:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhHXGtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 02:49:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230192AbhHXGtX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 02:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629787716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rjxh505OL6u6F/NVid7cy0TCy5b55IVOXKH+vnMfT84=;
        b=fG8/ViQ+VBbzQSJqrOtexA1jB/lw6LUG0uWYJs7SQBaUhIJ4xVuSeF7x8yt7beAyU7ZlOG
        8ISCAJoBXyTg0USWkXcEsPqtS+/UG6fxXPgtWzg2GCIdaLIzhTKEnH4n/d5+qgbNMFCgjI
        PMMMBQKBiQiQ50f5htOgfEPV3dOgNdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-RrAzkk0ZP7S_RuhaqRrX3A-1; Tue, 24 Aug 2021 02:48:35 -0400
X-MC-Unique: RrAzkk0ZP7S_RuhaqRrX3A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3A88760C5;
        Tue, 24 Aug 2021 06:48:33 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-112-4.ams2.redhat.com [10.36.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 533BE6E0B7;
        Tue, 24 Aug 2021 06:48:33 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id DFD7011380A9; Tue, 24 Aug 2021 08:48:31 +0200 (CEST)
From:   Markus Armbruster <armbru@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH v12] qapi: introduce 'query-x86-cpuid' QMP command.
References: <20210728125402.2496-1-valeriy.vdovin@virtuozzo.com>
        <87eeb59vwt.fsf@dusky.pond.sub.org>
        <20210810185644.iyqt3iao2qdqd5jk@habkost.net>
        <2191952f-6989-771a-1f0a-ece58262d141@redhat.com>
        <CAOpTY_qbsqh9Tf8LB3EOOi_gkREotdpUyuF3-d_sBFsof3-9KQ@mail.gmail.com>
        <97ce9800-ff69-46cd-b6ab-c7645ee10d2c@redhat.com>
        <CAOpTY_rv4nZib1Eymm9ZVcLf=v=-QjpUm24U7FtS-1pUqS_6VQ@mail.gmail.com>
        <87lf4scmi5.fsf@dusky.pond.sub.org>
        <CAOpTY_p3vxv8dM54sLQ1WkEHesJ9w-famusHPw040e=HiZj9pw@mail.gmail.com>
Date:   Tue, 24 Aug 2021 08:48:31 +0200
In-Reply-To: <CAOpTY_p3vxv8dM54sLQ1WkEHesJ9w-famusHPw040e=HiZj9pw@mail.gmail.com>
        (Eduardo Habkost's message of "Mon, 23 Aug 2021 11:55:34 -0400")
Message-ID: <8735qzpccg.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> On Mon, Aug 23, 2021 at 9:35 AM Markus Armbruster <armbru@redhat.com> wro=
te:
>>
>> Eduardo Habkost <ehabkost@redhat.com> writes:
>>
>> > On Wed, Aug 11, 2021 at 9:44 AM Thomas Huth <thuth@redhat.com> wrote:
>> >>
>> >> On 11/08/2021 15.40, Eduardo Habkost wrote:
>> >> > On Wed, Aug 11, 2021 at 2:10 AM Thomas Huth <thuth@redhat.com> wrot=
e:
>> >> >>
>> >> >> On 10/08/2021 20.56, Eduardo Habkost wrote:
>> >> >>> On Sat, Aug 07, 2021 at 04:22:42PM +0200, Markus Armbruster wrote:
>> >> >>>> Is this intended to be a stable interface?  Interfaces intended =
just for
>> >> >>>> debugging usually aren't.
>> >> >>>
>> >> >>> I don't think we need to make it a stable interface, but I won't
>> >> >>> mind if we declare it stable.
>> >> >>
>> >> >> If we don't feel 100% certain yet, it's maybe better to introduce =
this with
>> >> >> a "x-" prefix first, isn't it? I.e. "x-query-x86-cpuid" ... then i=
t's clear
>> >> >> that this is only experimental/debugging/not-stable yet. Just my 0=
.02 =E2=82=AC.
>> >> >
>> >> > That would be my expectation. Is this a documented policy?
>> >> >
>> >>
>> >> According to docs/interop/qmp-spec.txt :
>> >>
>> >>   Any command or member name beginning with "x-" is deemed
>> >>   experimental, and may be withdrawn or changed in an incompatible
>> >>   manner in a future release.
>> >
>> > Thanks! I had looked at other QMP docs, but not qmp-spec.txt.
>> >
>> > In my reply above, please read "make it a stable interface" as
>> > "declare it as supported by not using the 'x-' prefix".
>> >
>> > I don't think we have to make it stable, but I won't argue against it
>> > if the current proposal is deemed acceptable by other maintainers.
>> >
>> > Personally, I'm still frustrated by the complexity of the current
>> > proposal, but I don't want to block it just because of my frustration.
>>
>> Is this a case of "there must be a simpler way", or did you actually
>> propose a simpler way?  I don't remember...
>>
>
> I did propose a simpler way at
> https://lore.kernel.org/qemu-devel/20210810195053.6vsjadglrexf6jwy@habkos=
t.net/

Valeriy, would the simpler way still work for you?

If no, please explain why.  If you already did, just provide a pointer.

If yes, we need to choose between the complex solution we have and the
simpler solution we still need to code up.  The latter is extra work,
but having to carry more complex code is going to be extra work, too.

