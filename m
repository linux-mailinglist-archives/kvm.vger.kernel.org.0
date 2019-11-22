Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBBC106FFB
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 12:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfKVLT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 06:19:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31391 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbfKVLT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 06:19:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574421565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yWN8xrHtD+VM+QZ/aEMLoMs5z3nBkdpI58n1H+EvsIo=;
        b=QYXKKfRgF/HjUeXLQi8pC4oY+Xc9yvtpsAzHcHiH7BpQppryH8yILfssZT6tN++sCIdx8M
        RflXbUDRsViqrwjcK8x92FuNroegVy5WiXAm0YXRgbSPIQC7W0h/ykStDe+0Ox3IHsfo2J
        esmjrT307Dj6MBKmukxY4hlcq5+jFsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-dr6Q_-ZANSKJj1SIAfbOQA-1; Fri, 22 Nov 2019 06:19:21 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC8B39B5FA;
        Fri, 22 Nov 2019 11:19:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA8576E718;
        Fri, 22 Nov 2019 11:19:19 +0000 (UTC)
Date:   Fri, 22 Nov 2019 12:19:17 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] runtime: set MAX_SMP to number of online
 cpus
Message-ID: <20191122111917.fzdrdjkbm2w3reph@kamzik.brq.redhat.com>
References: <20191120141928.6849-1-drjones@redhat.com>
 <86280ced-214f-eb0f-0662-0854e5c57991@arm.com>
MIME-Version: 1.0
In-Reply-To: <86280ced-214f-eb0f-0662-0854e5c57991@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: dr6Q_-ZANSKJj1SIAfbOQA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 10:45:08AM +0000, Alexandru Elisei wrote:
> Hi,
>=20
> On 11/20/19 2:19 PM, Andrew Jones wrote:
> > We can only use online cpus, so make sure we check specifically for
> > those.
> >
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  scripts/runtime.bash | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index 200d5b67290c..fbad0bd05fc5 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -1,5 +1,5 @@
> >  : "${RUNTIME_arch_run?}"
> > -: ${MAX_SMP:=3D$(getconf _NPROCESSORS_CONF)}
> > +: ${MAX_SMP:=3D$(getconf _NPROCESSORS_ONLN)}
>=20
> I tested it on my machine by offlining a CPU and calling getconf _NPROCES=
SORS_CONF
> (returned 32) and getconf _NPROCESSORS_ONLN (returned 31). man 3 sysconf =
also
> agrees with your patch.
>=20
> I am wondering though, if _NPROCESSORS_CONF is 8 and _NPROCESSORS_ONLN is=
 1
> (meaning that 7 CPUs were offlined), that means that qemu will create 8 V=
CPUs
> which will share the same physical CPU. Is that undesirable?

With KVM enabled that's not recommended. KVM_CAP_NR_VCPUS returns the
number of online VCPUs (at least for arm). Since the guest code may not
run as expected with overcommitted VCPUs we don't usually want to test
that way. OTOH, maybe we should write a test or two that does run with
overcommitted VCPUs in order to look for bugs in KVM.

Thanks,
drew

>=20
> Thanks,
> Alex
> >  : ${TIMEOUT:=3D90s}
> > =20
> >  PASS() { echo -ne "\e[32mPASS\e[0m"; }
>=20

