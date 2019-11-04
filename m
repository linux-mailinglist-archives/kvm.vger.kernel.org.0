Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1575EE35F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 16:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfKDPQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 10:16:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39216 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728346AbfKDPQp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 10:16:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572880604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94jUXg8YSFsR6CfFNt9OsbURbL8UvhaFzbBwaFpwKq0=;
        b=UIv0vT+eKktLq/2L5LBoHgSoR2lPUNoQryACjDC6cl3ucd8ZzxD72SznekXyRGwzWb6CUv
        NJf144CLqpwtjB/t1oHl6B8xcs1iz9qnsjh8cQ/LR4YtiaY6DzVyZ/ayNa4Dy8gIEWlt8F
        7RIZz9bOxSg9cMIpqdpDXEy4k2DVk1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-JLq42j5JNbqeO_nbIuntlA-1; Mon, 04 Nov 2019 10:16:40 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABB63800C73;
        Mon,  4 Nov 2019 15:16:39 +0000 (UTC)
Received: from amt.cnet (ovpn-112-10.gru2.redhat.com [10.97.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3A7026FA8;
        Mon,  4 Nov 2019 15:16:36 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 5E810105157;
        Mon,  4 Nov 2019 13:01:15 -0200 (BRST)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id xA4F1AkN016482;
        Mon, 4 Nov 2019 13:01:10 -0200
Date:   Mon, 4 Nov 2019 13:01:06 -0200
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH 5/5] cpuidle-haltpoll: fix up the branch check
Message-ID: <20191104150103.GA14887@amt.cnet>
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-6-git-send-email-zhenzhong.duan@oracle.com>
 <20191101212613.GB20672@amt.cnet>
 <bafc1688-02ea-77a4-fb1c-2fe6afa8a7cc@oracle.com>
MIME-Version: 1.0
In-Reply-To: <bafc1688-02ea-77a4-fb1c-2fe6afa8a7cc@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: JLq42j5JNbqeO_nbIuntlA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 04, 2019 at 11:10:25AM +0800, Zhenzhong Duan wrote:
>=20
> On 2019/11/2 5:26, Marcelo Tosatti wrote:
> >On Sat, Oct 26, 2019 at 11:23:59AM +0800, Zhenzhong Duan wrote:
> >>Ensure pool time is longer than block_ns, so there is a margin to
> >>avoid vCPU get into block state unnecessorily.
> >>
> >>Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> >>---
> >>  drivers/cpuidle/governors/haltpoll.c | 6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >>diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/gov=
ernors/haltpoll.c
> >>index 4b00d7a..59eadaf 100644
> >>--- a/drivers/cpuidle/governors/haltpoll.c
> >>+++ b/drivers/cpuidle/governors/haltpoll.c
> >>@@ -81,9 +81,9 @@ static void adjust_poll_limit(struct cpuidle_device *=
dev, unsigned int block_us)
> >>  =09u64 block_ns =3D block_us*NSEC_PER_USEC;
> >>  =09/* Grow cpu_halt_poll_us if
> >>-=09 * cpu_halt_poll_us < block_ns < guest_halt_poll_us
> >>+=09 * cpu_halt_poll_us <=3D block_ns < guest_halt_poll_us
> >>  =09 */
> >>-=09if (block_ns > dev->poll_limit_ns && block_ns <=3D guest_halt_poll_=
ns) {
> >>+=09if (block_ns >=3D dev->poll_limit_ns && block_ns < guest_halt_poll_=
ns) {
> >=09=09=09=09=09      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> >If block_ns =3D=3D guest_halt_poll_ns, you won't allow dev->poll_limit_n=
s to
> >grow. Why is that?
>=20
> Maybe I'm too strict here. My understanding is: if block_ns =3D guest_hal=
t_poll_ns,
> dev->poll_limit_ns will grow to guest_halt_poll_ns,=20

OK.

> then block_ns =3D dev->poll_limit_ns,

block_ns =3D dev->poll_limit_ns =3D guest_halt_poll_ns. OK.

> there is not a margin to ensure poll time is enough to cover the equal bl=
ock time.
> In this case, shrinking may be a better choice?

Ok, so you are considering _on the next_ halt instance, if block_ns =3D
guest_halt_poll_ns again?

Then without the suggested modification: we don't shrink, poll for
guest_halt_poll_ns again.

With your modification: we shrink, because block_ns =3D=3D
guest_halt_poll_ns.

IMO what really clarifies things here is either the real sleep pattern=20
or a synthetic sleep pattern similar to the real thing.

Do you have a scenario where the current algorithm is maintaining
a low dev->poll_limit_ns and performance is hurt?

If you could come up with examples, such as the client/server pair at
https://lore.kernel.org/lkml/20190514135022.GD4392@amt.cnet/T/

or just a sequence of delays:=20
block_ns, block_ns, block_ns-1,...

It would be easier to visualize this.

> >>@@ -101,7 +101,7 @@ static void adjust_poll_limit(struct cpuidle_device=
 *dev, unsigned int block_us)
> >>  =09=09=09val =3D guest_halt_poll_ns;
> >>  =09=09dev->poll_limit_ns =3D val;
> >>-=09} else if (block_ns > guest_halt_poll_ns &&
> >>+=09} else if (block_ns >=3D guest_halt_poll_ns &&
> >>  =09=09   guest_halt_poll_allow_shrink) {
> >>  =09=09unsigned int shrink =3D guest_halt_poll_shrink;
> >And here you shrink if block_ns =3D=3D guest_halt_poll_ns. Not sure
> >why that makes sense either.
>=20
> See above explanation.
>=20
> Zhenzhong

