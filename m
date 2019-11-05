Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F49FF0537
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 19:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390517AbfKEShp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 13:37:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41077 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390432AbfKESho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 13:37:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572979064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a4dtXdaTiYLpfpYoM1CH1EkAiBmA1TT6WDo0Mc5/Xlc=;
        b=ijLk2L8a+2OWY/KrRb1nxj7/h3qyNHNhIQpNF1TOl8UXLRrFtbno7sVDSExoEEwULdSYo4
        wcxpb6Ud5d1AFPUqMiVWNpAYtHzqZI//HBvyCfwfYUj6Bm+LUBlTRfdMAz22NTxtCfLprT
        ZgMJff6TTlzrLMoDryTRno5es0R4BkE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-1-1DfZzkOaiF2BabvKz0jA-1; Tue, 05 Nov 2019 13:37:40 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F4225107ACC3;
        Tue,  5 Nov 2019 18:37:38 +0000 (UTC)
Received: from gondolin (unknown [10.36.118.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01ED95D9C9;
        Tue,  5 Nov 2019 18:37:32 +0000 (UTC)
Date:   Tue, 5 Nov 2019 19:37:30 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: [RFC 12/37] KVM: s390: protvirt: Handle SE notification
 interceptions
Message-ID: <20191105193730.606c3c9c.cohuck@redhat.com>
In-Reply-To: <f0837f93-ace8-b4e0-f69c-c1fbe7b95c6a@de.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-13-frankja@linux.ibm.com>
        <20191105190407.68992d92.cohuck@redhat.com>
        <f0837f93-ace8-b4e0-f69c-c1fbe7b95c6a@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 1-1DfZzkOaiF2BabvKz0jA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 5 Nov 2019 19:15:19 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 05.11.19 19:04, Cornelia Huck wrote:
> > On Thu, 24 Oct 2019 07:40:34 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> >> Since KVM doesn't emulate any form of load control and load psw
> >> instructions anymore, we wouldn't get an interception if PSWs or CRs
> >> are changed in the guest. That means we can't inject IRQs right after
> >> the guest is enabled for them.
> >>
> >> The new interception codes solve that problem by being a notification
> >> for changes to IRQ enablement relevant bits in CRs 0, 6 and 14, as
> >> well a the machine check mask bit in the PSW.
> >>
> >> No special handling is needed for these interception codes, the KVM
> >> pre-run code will consult all necessary CRs and PSW bits and inject
> >> IRQs the guest is enabled for. =20
> >=20
> > Just to clarify: The hypervisor can still access the relevant bits for
> > pv guests, this is only about the notification, right?
> >  =20
>=20
> Yes, the hypervisor (KVM) can always read the relevant PSW bits (I,E,M) a=
nd
> CR bits to decide if an interrupt can be delivered. All other bits of PSW
> and CRx are masked though.
> This is a new intercept for notification as we do no longer get an IC4 (i=
nstruction
> to handle) for load control and friends so that we can re-check the bits.=
=20

Ok, thanks!

> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>  arch/s390/include/asm/kvm_host.h |  2 ++
> >>  arch/s390/kvm/intercept.c        | 18 ++++++++++++++++++
> >>  2 files changed, 20 insertions(+) =20
> >  =20
>=20

