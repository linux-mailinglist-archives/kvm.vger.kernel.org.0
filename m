Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39D3E1E79
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 16:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392313AbfJWOox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 10:44:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2392310AbfJWOox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 10:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571841891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uf7ftM+TjCWiiMzN8AYw8EZ8RI4SD6HnWbZiIXVhH+c=;
        b=aXnNzRfPzV75mJN2oWn8bCAn2gVIgaryVjKrGJs8l/EptslGYjG/Kr++RkZQsin3WRFWBp
        rTZ9DYhiwS/AxM9kNOdDfcznfr1Gmit0yXcBaSQDoGrVodIUiDgU1uOfZcXIdzpQsPW7ji
        dn0+34ta+gOYLp3+UEVqb+9xwDZChy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-_rgTFrFcO-q0GmV5vlgQpQ-1; Wed, 23 Oct 2019 10:44:46 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C165C800D57
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 14:44:45 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68BF46375C;
        Wed, 23 Oct 2019 14:44:44 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 352181051A3;
        Wed, 23 Oct 2019 12:44:29 -0200 (BRST)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x9NEiPMY027777;
        Wed, 23 Oct 2019 12:44:25 -0200
Date:   Wed, 23 Oct 2019 12:44:25 -0200
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Radim Krcmar <rkrcmar@redhat.com>
Subject: Re: [patch 1/2] KVM: x86: switch KVMCLOCK base to CLOCK_MONOTONIC_RAW
Message-ID: <20191023144422.GA27674@amt.cnet>
References: <20180809145245.722399627@amt.cnet>
 <20180809145307.066923033@amt.cnet>
 <76fc525a-0ccc-be8d-5d66-c41853f9051e@redhat.com>
 <20180813125252.GA31066@amt.cnet>
MIME-Version: 1.0
In-Reply-To: <20180813125252.GA31066@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: _rgTFrFcO-q0GmV5vlgQpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 13, 2018 at 09:52:55AM -0300, Marcelo Tosatti wrote:
> On Fri, Aug 10, 2018 at 09:15:51AM +0200, Paolo Bonzini wrote:
> > On 09/08/2018 16:52, Marcelo Tosatti wrote:
> > > Commit 0bc48bea36d1 ("KVM: x86: update master clock before computing =
kvmclock_offset")
> > > switches the order of operations to avoid the conversion=20
> > >=20
> > > TSC (without frequency correction) ->
> > > system_timestamp (with frequency correction),=20
> > >=20
> > > which might cause a time jump.
> > >=20
> > > However, it leaves any other masterclock update unsafe, which include=
s,=20
> > > at the moment:
> > >=20
> > >         * HV_X64_MSR_REFERENCE_TSC MSR write.
> > >         * TSC writes.
> > >         * Host suspend/resume.
> > >=20
> > > Avoid the time jump issue by using frequency uncorrected
> > > CLOCK_MONOTONIC_RAW clock.=20
> > >=20
> > > Its the guests time keeping software responsability
> > > to track and correct a reference clock such as UTC.
> > >=20
> > > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> >=20
> > What happens across migration?
> >=20
> > Paolo
>=20
> You mean between
>=20
> frequency corrected host -> frequency uncorrected host
>=20
> And vice-versa?=20
>=20
> I'll check NTP's/Chrony's behaviour and let you know.
>=20
> Thanks

They will measure and adjust their frequency corrections
(which is necessary anyway due to temperature variations=20
for example).

http://doc.ntp.org/4.1.0/ntpd.htm

Frequency Discipline

The ntpd behavior at startup depends on whether the frequency file,
usually ntp.drift, exists. This file contains the latest estimate of
clock frequency error. When the ntpd is started and the file does not
exist, the ntpd enters a special mode designed to quickly adapt to the
particular system clock oscillator time and frequency error. This takes
approximately 15 minutes, after which the time and frequency are set to
nominal values and the ntpd enters normal mode, where the time and
frequency are continuously tracked relative to the server. After one
hour the frequency file is created and the current frequency offset
written to it. When the ntpd is started and the file does exist, the
ntpd frequency is initialized from the file and enters normal mode
immediately. After that the current frequency offset is written to the
file at hourly intervals.

