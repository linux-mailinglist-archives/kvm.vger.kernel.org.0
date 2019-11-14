Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C17FCB1B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKNQvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 11:51:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55934 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726516AbfKNQvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 11:51:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573750284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eMj0lEH1ieqIpdoJGVUWt00wzdEOq4a3EmJThQTBTYc=;
        b=XlyTwRw87gNIjAWsCrn+iqWAk2FoG/7zrx1oWCHUgUv6t1whN7Do7pCoqYogMXt0jJFEqt
        pzlsb8qZN1NKadxDMGn6rVA3fR44L0D7ixQQRI5ivsdsa0gGrtrjBcAY9VPSftzuWNEQHs
        a/XxrTMOvquM96uTmumBLzCrD5Qo8/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-VVvBg4W1NXGe_QkGrHs_eQ-1; Thu, 14 Nov 2019 11:51:20 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DDFA802683;
        Thu, 14 Nov 2019 16:51:18 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-89.ams2.redhat.com [10.36.116.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFC9510013A1;
        Thu, 14 Nov 2019 16:51:14 +0000 (UTC)
Subject: Re: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
 <db451544-fcb1-9d81-7042-ef91c8324204@linux.ibm.com>
 <81ef68d4-5ec5-b14e-6c3d-6935e9a6a1c1@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <75b72389-eec5-200f-01af-512d1294f137@redhat.com>
Date:   Thu, 14 Nov 2019 17:51:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <81ef68d4-5ec5-b14e-6c3d-6935e9a6a1c1@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: VVvBg4W1NXGe_QkGrHs_eQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/2019 17.38, Pierre Morel wrote:
[...]
>>> +static char buffer[4096];
>>> +
>>> +static void delay(int d)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int i, j;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 while (d--)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 1000000; i; i--)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for=
 (j =3D 1000000; j; j--)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ;
>>> +}
>> You could set a timer.
>=20
> Hum, do we really want to do this?

I'm pretty sure that the compiler optimizes empty loops away. Maybe have
a look at the disassembly of your delay function...

Anyway, it's likely better to use STCK and friends to get a proper
timing. You could move get_clock_ms() from s390x/intercept.c to the
lib/s390x folder and then use that function here.

 Thomas

