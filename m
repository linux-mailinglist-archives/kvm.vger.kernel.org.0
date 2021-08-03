Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1582D3DEFCA
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 16:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbhHCOLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 10:11:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236463AbhHCOLU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 10:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627999869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=wZGKe2wrWDov8oH2GjTl3SddEb8NEziHSjmQEX1UATI=;
        b=iXKdKzGcSsUd3UixCbxlnBJuOsNNLDdKPUJCKyi9nnkLXglEdlezhLSF/NFCBJuPtYLb/f
        gu51yxJ5yhATzSWsXQO9hcHziqCtwBIoVfZzXp4yqH4xDF8j0/T1iNxl5IV6EXqlIQTfwB
        jPJHegcc1c6gvUTw2/9ytiRrLQhdOF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-QkFnusHmM2ip4KI3apCewg-1; Tue, 03 Aug 2021 10:11:07 -0400
X-MC-Unique: QkFnusHmM2ip4KI3apCewg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 425EF101C8A6;
        Tue,  3 Aug 2021 14:11:06 +0000 (UTC)
Received: from localhost (unknown [10.39.194.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D066C60C05;
        Tue,  3 Aug 2021 14:11:05 +0000 (UTC)
Date:   Tue, 3 Aug 2021 15:11:04 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jenifer Abrams <jhopper@redhat.com>, atheurer@redhat.com,
        jmario@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: What does KVM_HINTS_REALTIME do?
Message-ID: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HZ3NvMQNQUV6k23c"
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--HZ3NvMQNQUV6k23c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
I was just in a discussion where we realized KVM_HINTS_REALTIME is a
little underdocumented. Here is attempt to address that. Please correct
me if there are inaccuracies or reply if you have additional questions:

KVM_HINTS_REALTIME (aka QEMU kvm-hint-dedicated) is defined as follows
in Documentation/virt/kvm/cpuid.rst:

  guest checks this feature bit to determine that vCPUs are never
  preempted for an unlimited time allowing optimizations

Users or management tools set this flag themselves (it is not set
automatically). This raises the question of what effects this flag has
and when it should be set.

When should I set KVM_HINTS_REALTIME?
-------------------------------------
When vCPUs are pinned to dedicated pCPUs. Even better if the isolcpus=
kernel parameter is used on the host so there are no disturbances.

Is the flag guest-wide or per-vCPU?
-----------------------------------
This flag is guest-wide so all vCPUs should be dedicated, not just some
of them.

Which Linux guest features are affected?
----------------------------------------
PV spinlocks, PV TLB flush, and PV sched yield are disabled by
KVM_HINTS_REALTIME. This is because no other vCPUs or host tasks will be
running on the pCPUs, so there is no benefit in involving the host.

The cpuidle-haltpoll driver is enabled by KVM_HINTS_REALTIME. This
driver performs busy waiting inside the guest before halting the CPU in
order to avoid the vCPU's wakeup latency. This driver also has a boolean
"force" module parameter if you wish to enable it without setting
KVM_HINTS_REALTIME.

When KVM_HINTS_REALTIME is set, the KVM_CAP_X86_DISABLE_EXITS capability
can also be used to disable MWAIT/HLT/PAUSE/CSTATE exits. This improves
the latency of these operations. The user or management tools need to
disable these exits themselves, e.g. with QEMU's -overcommit cpu-pm=on.

Stefan

--HZ3NvMQNQUV6k23c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmEJTngACgkQnKSrs4Gr
c8jhXQf/aLxBmw/J3BuBM0fmfjNKr33JgNjPAHR4TusVgQA4SHeuYbcTrdELPdjN
T+X1Cw4tdaAh+KgMfrDoV0GzbrYo01O/9GVH+AoBMSwi0rH+dTPgYgh8K9PjXk8a
XT0s4DIYh0vp5IHRvvIpLAFcMJSFp5VrGfro4bli0HQJRrIe8oTQvzuJBFXjN69G
iQWDniFEpEd0QWs7Omu1Lvj53GtiI1/wW0jXgYZisE6tMR2s3cOOBpMUxBl2UlSl
/RhUhq2y8Q8VqVAesSXmoiBC6moNfJ57lRgzmCcSB5xQXyU0KtDjbvzuMy4n7U9Z
n7DSaYZVi1HMpUBa6/vpPB7IRZAMDQ==
=//eQ
-----END PGP SIGNATURE-----

--HZ3NvMQNQUV6k23c--

