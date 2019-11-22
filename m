Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13788107467
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 15:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfKVO6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 09:58:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28211 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727457AbfKVO6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 09:58:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574434684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TheCIOgiNmdRkwNggt18XlGiN0W6hd/ROjH5PP5VqM4=;
        b=ZNJQj2i5+kq0T4ilWy9A4cgCW6xcoVjbvPoDZ9HeXKxlYSDSdHBrHq8BrpFESQ9QzQ8yGk
        Fx+A4P51RxE8do63oJBLAUykkkRcS6IRBcDyLyAs7YLbbh/Tfqpt84H6OW2h0NZd8W8fiL
        aMhnAd7Kg02xn21CAT3KgPTOlG3PqGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-CRblwJYUPd-9MFiDlM3zCA-1; Fri, 22 Nov 2019 09:58:03 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB624801E5D;
        Fri, 22 Nov 2019 14:58:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E20765E8D;
        Fri, 22 Nov 2019 14:57:59 +0000 (UTC)
Date:   Fri, 22 Nov 2019 15:57:57 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] runtime: set MAX_SMP to number of online
 cpus
Message-ID: <20191122145757.d2qupmdewipajxnn@kamzik.brq.redhat.com>
References: <20191120141928.6849-1-drjones@redhat.com>
 <86280ced-214f-eb0f-0662-0854e5c57991@arm.com>
 <20191122111917.fzdrdjkbm2w3reph@kamzik.brq.redhat.com>
 <03b0c1e1-c7d6-66e2-e338-f6812c367791@arm.com>
MIME-Version: 1.0
In-Reply-To: <03b0c1e1-c7d6-66e2-e338-f6812c367791@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: CRblwJYUPd-9MFiDlM3zCA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 11:35:33AM +0000, Alexandru Elisei wrote:
> Hi,
>=20
> On 11/22/19 11:19 AM, Andrew Jones wrote:
> > On Fri, Nov 22, 2019 at 10:45:08AM +0000, Alexandru Elisei wrote:
> >> Hi,
> >>
> >> On 11/20/19 2:19 PM, Andrew Jones wrote:
> >>> We can only use online cpus, so make sure we check specifically for
> >>> those.
> >>>
> >>> Signed-off-by: Andrew Jones <drjones@redhat.com>
> >>> ---
> >>>  scripts/runtime.bash | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> >>> index 200d5b67290c..fbad0bd05fc5 100644
> >>> --- a/scripts/runtime.bash
> >>> +++ b/scripts/runtime.bash
> >>> @@ -1,5 +1,5 @@
> >>>  : "${RUNTIME_arch_run?}"
> >>> -: ${MAX_SMP:=3D$(getconf _NPROCESSORS_CONF)}
> >>> +: ${MAX_SMP:=3D$(getconf _NPROCESSORS_ONLN)}
> >> I tested it on my machine by offlining a CPU and calling getconf _NPRO=
CESSORS_CONF
> >> (returned 32) and getconf _NPROCESSORS_ONLN (returned 31). man 3 sysco=
nf also
> >> agrees with your patch.
> >>
> >> I am wondering though, if _NPROCESSORS_CONF is 8 and _NPROCESSORS_ONLN=
 is 1
> >> (meaning that 7 CPUs were offlined), that means that qemu will create =
8 VCPUs
> >> which will share the same physical CPU. Is that undesirable?
> > With KVM enabled that's not recommended. KVM_CAP_NR_VCPUS returns the
> > number of online VCPUs (at least for arm). Since the guest code may not
> > run as expected with overcommitted VCPUs we don't usually want to test
>=20
> Can you give more details about what may go wrong if several kvm-unit-tes=
ts VCPUs
> run on the same physical CPU? I was thinking that maybe we want to run th=
e VCPUs
> in parallel (each on its own physical CPU) to detect races in KVM, not be=
cause of
> a limitation in kvm-unit-tests.

There's no specific limitation in kvm-unit-tests. All guest kernels are at
risk of behaving strangely with overcommitted VCPUs.

A made-up example could be that a guest kernel thread T1 needs to wait for
another thread T2. T1 may choose not to yield because T2 appears to be
running on another CPU. But it isn't, because both T1's VCPU and T2's VCPU
are running on the same PCPU. In general, telling a guest kernel it can
run threads in parallel may cause it to make decisions that won't work
well when executed serially.

In kvm-unit-tests, where we can know that we're overcommitted in certain
test cases, we can actually write tests that will still behave
predictably. Knowing the test runs fine with overcommitted VCPUs will
allow us to check if KVM does as well.

Thanks,
drew

>=20
> Thanks,
> Alex
> > that way. OTOH, maybe we should write a test or two that does run with
> > overcommitted VCPUs in order to look for bugs in KVM.
> >
> > Thanks,
> > drew
> >> Thanks,
> >> Alex
> >>>  : ${TIMEOUT:=3D90s}
> >>> =20
> >>>  PASS() { echo -ne "\e[32mPASS\e[0m"; }
>=20

