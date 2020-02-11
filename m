Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F55D1593A2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 16:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgBKPtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 10:49:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21329 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730428AbgBKPtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 10:49:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581436169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fz/9T71wlj0EphJ0rxzCeEvJ/uyMAvvoFKZFbiWI/y4=;
        b=IGL+kH9BxzcEu9fAG7Ks3CJTc6izgafKusYkdCFIPZoDy5rpoWbJo4q1cCYAf2FEa4SMJ4
        egCVLAekyYb1kxrxA97V4bbakJtsKtEFdG8d/Yg/G1hgZ9sj9e+nQNyE7+hsd4gJKqIvdA
        qYQJy36G68vn3q+nEm/peYLiaRg2kh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-Fnl9TNtkPa2RWvAp4KFIAw-1; Tue, 11 Feb 2020 10:49:25 -0500
X-MC-Unique: Fnl9TNtkPa2RWvAp4KFIAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E16361800D42;
        Tue, 11 Feb 2020 15:49:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C64C260499;
        Tue, 11 Feb 2020 15:49:22 +0000 (UTC)
Date:   Tue, 11 Feb 2020 16:49:20 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        alexandru.elisei@arm.com
Subject: Re: [PATCH kvm-unit-tests v2] arm64: timer: Speed up gic-timer-state
 check
Message-ID: <20200211154920.gxb32rzzcbnuo34v@kamzik.brq.redhat.com>
References: <20200211133705.1398-1-drjones@redhat.com>
 <60c6c4c7-1d6b-5b64-adc1-8e96f45332c6@huawei.com>
 <83803119-0ea8-078d-628b-537c3d9525b1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <83803119-0ea8-078d-628b-537c3d9525b1@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 11:32:14PM +0800, Zenghui Yu wrote:
> On 2020/2/11 22:50, Zenghui Yu wrote:
> > Hi Drew,
> >=20
> > On 2020/2/11 21:37, Andrew Jones wrote:
> > > Let's bail out of the wait loop if we see the expected state
> > > to save over six seconds of run time. Make sure we wait a bit
> > > before reading the registers and double check again after,
> > > though, to somewhat mitigate the chance of seeing the expected
> > > state by accident.
> > >=20
> > > We also take this opportunity to push more IRQ state code to
> > > the library.
> > >=20
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> >=20
> > [...]
> >=20
> > > +
> > > +enum gic_irq_state gic_irq_state(int irq)
> >=20
> > This is a *generic* name while this function only deals with PPI.
> > Maybe we can use something like gic_ppi_state() instead?=A0 Or you
> > will have to take all interrupt types into account in a single
> > function, which is not a easy job I think.
>=20
> Just to follow up, gic_irq_get_irqchip_state()/gic_peek_irq() [*] is
> the Linux implementation of this for PPIs and SPIs.
>=20
> [*] linux/drivers/irqchip/irq-gic-v3.c
>

Thanks. I just skimmed that now and it looks like the diff I sent is
pretty close. But, I do see a bug in my diff (missing '* 4' on the
offset calculation).

Thanks,
drew=20

