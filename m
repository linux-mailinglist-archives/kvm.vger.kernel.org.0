Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A621DB8F2
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 18:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETQHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 12:07:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47860 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726525AbgETQHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 12:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589990867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fQKGsMsjEI47tjZWYdHWX5AT4E07YQAP5+tDCquOeU0=;
        b=K+rWIHfy97IbOYiH674N6z47ZVaCtaMYr/RkJZdZxzzuV1tfs82o5KcLWpDKW082rIqfFj
        8APmcywB9s8ikb7X+84M7NfuIYlT2Kx48ss54+Wl7b4TU0MzrSjGucxZbq4hxaxiZjIy9L
        bSINhURGcu0Ubk+lW7woND3axEch6jg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-IuMYnOiOPFKkgir_dK6JXQ-1; Wed, 20 May 2020 12:07:45 -0400
X-MC-Unique: IuMYnOiOPFKkgir_dK6JXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E9DB835B44;
        Wed, 20 May 2020 16:07:44 +0000 (UTC)
Received: from starship.fedora32vm (unknown [10.35.207.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23F1D341FD;
        Wed, 20 May 2020 16:07:41 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] Fix breakage from adding MSR_IA32_UMWAIT_CONTROL
Date:   Wed, 20 May 2020 19:07:38 +0300
Message-Id: <20200520160740.6144-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently code in kvm_get_supported_msrs always=0D
returns this msr as supported by KVM, however it=0D
is not supported at all on AMD and it is only supported=0D
on few select Intel systems.=0D
=0D
This happened to work in native virtualization case,=0D
because KVM's code also tries to read these msrs,=0D
and on an exception drops them from the supported msr list.=0D
=0D
However when running nested, and outer hypervisor set=0D
to ignore unknown msrs, the read from this msr doesn't get=0D
an excption, and thus KVM thinks that this msr should be on=0D
supported msr list.=0D
=0D
I don't think we should rely on exception to check if a feature=0D
is supported since that msr can be even in theory assigned to something=0D
else on AMD for example.=0D
=0D
Also I included a cosmetic fix for an issue I found in the same function.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  kvm: cosmetic: remove wrong braces in kvm_init_msr_list switch=0D
  kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally=0D
=0D
 arch/x86/kvm/x86.c | 7 +++++--=0D
 1 file changed, 5 insertions(+), 2 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

