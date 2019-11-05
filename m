Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C86F04AE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 19:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390628AbfKESEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 13:04:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30078 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388711AbfKESEV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 13:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572977060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h/Ru9i9uex0sqTYHLeYb4Ou1EJ/7I3XLakwycm5mngQ=;
        b=cp2mrMSGmItW8mfm+5EDjBq3bRE6oeJM4a9LtKkhMZeVrG6nHRYLOONVaku7lZv0W2145z
        MJMHkMThKIgjjWRIhf3uNhhoC0OpdOp4wTPo7cooVkyhXJ/oyLfPzyypMlL3Di3y+ibwuy
        5BBs9RpWdLiBqHtMty5Q0CvOSQPjgnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-gUYJOdAVPRSx_XyQJi64WA-1; Tue, 05 Nov 2019 13:04:17 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F02CD1800D53;
        Tue,  5 Nov 2019 18:04:15 +0000 (UTC)
Received: from gondolin (unknown [10.36.118.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0180F100164D;
        Tue,  5 Nov 2019 18:04:10 +0000 (UTC)
Date:   Tue, 5 Nov 2019 19:04:07 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 12/37] KVM: s390: protvirt: Handle SE notification
 interceptions
Message-ID: <20191105190407.68992d92.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-13-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-13-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: gUYJOdAVPRSx_XyQJi64WA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:34 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Since KVM doesn't emulate any form of load control and load psw
> instructions anymore, we wouldn't get an interception if PSWs or CRs
> are changed in the guest. That means we can't inject IRQs right after
> the guest is enabled for them.
>=20
> The new interception codes solve that problem by being a notification
> for changes to IRQ enablement relevant bits in CRs 0, 6 and 14, as
> well a the machine check mask bit in the PSW.
>=20
> No special handling is needed for these interception codes, the KVM
> pre-run code will consult all necessary CRs and PSW bits and inject
> IRQs the guest is enabled for.

Just to clarify: The hypervisor can still access the relevant bits for
pv guests, this is only about the notification, right?

>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  2 ++
>  arch/s390/kvm/intercept.c        | 18 ++++++++++++++++++
>  2 files changed, 20 insertions(+)

