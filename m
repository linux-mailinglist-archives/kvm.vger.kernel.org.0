Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B10120563B
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732973AbgFWPoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:44:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732943AbgFWPoA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 11:44:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592927038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HKWiIbEnoBKdrEpt4leFANplYkn60/HbZQG9iAnotP8=;
        b=iK+UA3tacC/nXhBN9bE83DsBnwXD3TkkX0l3kzEWdUGRQRQZd8BG2ofSrZ8XfEQJo3dQ0N
        gVu+Kd4BBkon8hzJDMTPDzvu+aWhrU2KAAyX/X++Y6r7V3wFdWGTwezxp9N5/FsP9KDy0Q
        iaxHhxTohlMkkr9EsMevo2cqglWwcI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-GE8oYt_2NMWGgR_EhjhW6Q-1; Tue, 23 Jun 2020 11:43:57 -0400
X-MC-Unique: GE8oYt_2NMWGgR_EhjhW6Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F1958031E1;
        Tue, 23 Jun 2020 15:43:55 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EC8C5C240;
        Tue, 23 Jun 2020 15:43:42 +0000 (UTC)
Date:   Tue, 23 Jun 2020 17:43:40 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 2/7] accel/kvm: Simplify kvm_check_extension()
Message-ID: <20200623174340.0dbc1989.cohuck@redhat.com>
In-Reply-To: <20200623105052.1700-3-philmd@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
        <20200623105052.1700-3-philmd@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Jun 2020 12:50:47 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> In previous commit we let kvm_check_extension() use the
> global kvm_state. Since the KVMState* argument is now
> unused, drop it.
>=20
> Convert callers with this Coccinelle script:
>=20
>   @@
>   expression kvm_state, extension;
>   @@
>   -   kvm_check_extension(kvm_state, extension)
>   +   kvm_check_extension(extension)
>=20
> Unused variables manually removed:
> - CPUState* in hyperv_enabled()
> - KVMState* in kvm_arm_get_max_vm_ipa_size()
>=20
> Inspired-by: Paolo Bonzini <pbonzini@redhat.com>

=F0=9F=8C=9F=F0=9F=92=A1=F0=9F=8C=9F

> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  include/sysemu/kvm.h         |  2 +-
>  accel/kvm/kvm-all.c          | 64 ++++++++++++++++++------------------
>  hw/hyperv/hyperv.c           |  2 +-
>  hw/i386/kvm/clock.c          |  2 +-
>  hw/i386/kvm/i8254.c          |  4 +--
>  hw/i386/kvm/ioapic.c         |  2 +-
>  hw/intc/arm_gic_kvm.c        |  2 +-
>  hw/intc/openpic_kvm.c        |  2 +-
>  hw/intc/xics_kvm.c           |  2 +-
>  hw/s390x/s390-stattrib-kvm.c |  2 +-
>  target/arm/kvm.c             | 13 ++++----
>  target/arm/kvm32.c           |  2 +-
>  target/arm/kvm64.c           | 15 ++++-----
>  target/i386/kvm.c            | 61 ++++++++++++++++------------------
>  target/mips/kvm.c            |  4 +--
>  target/ppc/kvm.c             | 34 +++++++++----------
>  target/s390x/cpu_models.c    |  3 +-
>  target/s390x/kvm.c           | 30 ++++++++---------
>  18 files changed, 119 insertions(+), 127 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

