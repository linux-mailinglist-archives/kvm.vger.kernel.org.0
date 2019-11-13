Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F3CFAFFE
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 12:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfKMLtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 06:49:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727785AbfKMLtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 06:49:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573645740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G01EHjr+CKVXPM2PZRKKQXmH8QDFFGSxENOhjpxoRvo=;
        b=OpLAPQJphoKb+a7qCe9QhgwQZfQXYMVsGeKt90Vpz68R/1VePYlL1QU8wFr/Nflk//sCLK
        +iRnI0HBjMIP5wXJbGqjWvtwsWrwynzbVO9rQTcCmkxlcVTVUkE6L2QKQE1BYqt2Dh3NBu
        v7/pCha+30iPjI/Un+vV1/Xh8rduJzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-9hIywWJBMECZd3PpD-Jc4g-1; Wed, 13 Nov 2019 06:48:57 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A78318A07C4;
        Wed, 13 Nov 2019 11:48:56 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D20485C1D4;
        Wed, 13 Nov 2019 11:48:51 +0000 (UTC)
Date:   Wed, 13 Nov 2019 12:48:49 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
Message-ID: <20191113124849.316a7b3b.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-5-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-5-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 9hIywWJBMECZd3PpD-Jc4g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:26 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> +/*
> + * Generic cmd executor for calls that only transport the cpu or guest
> + * handle and the command.
> + */
> +static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret)
> +{
> +=09int rc;
> +=09struct uv_cb_nodata uvcb =3D {
> +=09=09.header.cmd =3D cmd,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09=09.handle =3D handle,
> +=09};
> +
> +=09WARN(!handle, "No handle provided to Ultravisor call cmd %x\n", cmd);
> +=09rc =3D uv_call(0, (u64)&uvcb);
> +=09if (ret)
> +=09=09*ret =3D *(u32 *)&uvcb.header.rc;
> +=09return rc ? -EINVAL : 0;

Why go ahead with doing the uv call if it doesn't have a handle anyway?
Or why warn, if you already know it is going to fail? I assume this can
only happen if you have a logic error in the kvm code?

> +}

