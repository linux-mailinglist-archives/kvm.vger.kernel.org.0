Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D7110DB1D
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfK2VgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:36:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727378AbfK2VfR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:35:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUDNloV8++elS+YB1xoQTLeI0C6RrQjWp10JVReyn5w=;
        b=JeH8i2yyfDXtvyBRYVokN+w8YovVbOhtUeQ4wyIBVlqANM6gEe6PvmMF+gKsi80F0+3TUY
        pMx/Dgvuqy64T/j/OfYiQo13kGbXnPsJcgu1qZ+DuoAsLiaqr+3MNA4SoJYPZflMnOAMxQ
        IFmGRtHyUuZDriGai3mgr3Fjb7p7/2w=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-hlo-OIEGNi2h1oNcLDJtZQ-1; Fri, 29 Nov 2019 16:35:15 -0500
Received: by mail-qk1-f199.google.com with SMTP id o184so17663713qkf.14
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NO+3fvoemBR5nsjjdrhR5UeVlYU30oVRytgNjHOWnCo=;
        b=nG3Bw23sgvYBUU1V6+iPz2ClILWxxKrnFZdDe1+7NlOx5DAeZkkTrvEQCp2nnEpj/G
         ZGJSRWS9D5zPnybfyoiyuYNxKIEJEoWA6AvPrApHxxScwu0zCcrdqmocCzNMc/GNZmGs
         7crkkKYflSaywx/kbVEWJl+R9lBGebVMHutkfv7WdzdPw/QWj1adIHiE2yldOxngbe7T
         BCc1E+ffHjB78daM8wd4eUu8KqHg+Vj0j4yxc+MDBpG8T2q5HoEpIcKuhI+K7bzroqFi
         R1V8eTeXWkl9K1C0gdh5BbxfDiEgByL7KrCT2mBzTM7/MNsVsH9bJ4TfeCgDRjDgLM6+
         EV+Q==
X-Gm-Message-State: APjAAAX508XJSk1w6XRCiHB2rOxFM+al5pdg9s5qjaloBvnFV9JNw7Nv
        457LfeUhSLuomsABdMlMzKWdc6dYuUzSHzkXipAA0aDsIzaB/155uOdcL+JViDrCn6qZmICfz/A
        wvKGgPA57B6C+
X-Received: by 2002:ac8:7a83:: with SMTP id x3mr42376744qtr.141.1575063315144;
        Fri, 29 Nov 2019 13:35:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqw+Fj4K6gOnpyuxoxJo2w18VCH+besA2qvETUFyxVvcVY7e7/PmCE7wMyTDBAnPDr+9SenrOw==
X-Received: by 2002:ac8:7a83:: with SMTP id x3mr42376726qtr.141.1575063314922;
        Fri, 29 Nov 2019 13:35:14 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:14 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 05/15] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Fri, 29 Nov 2019 16:34:55 -0500
Message-Id: <20191129213505.18472-6-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: hlo-OIEGNi2h1oNcLDJtZQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no good reason to use both the dirty bitmap logging and the
new dirty ring buffer to track dirty bits.  We should be able to even
support both of them at the same time, but it could complicate things
which could actually help little.  Let's simply make it the rule
before we enable dirty ring on any arch, that we don't allow these two
interfaces to be used together.

The big world switch would be KVM_CAP_DIRTY_LOG_RING capability
enablement.  That's where we'll switch from the default dirty logging
way to the dirty ring way.  As long as kvm->dirty_ring_size is setup
correctly, we'll once and for all switch to the dirty ring buffer mode
for the current virtual machine.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/api.txt |  7 +++++++
 virt/kvm/kvm_main.c            | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.tx=
t
index fa622c9a2eb8..9f72ca1fd3e4 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -5487,3 +5487,10 @@ with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL,=
 and the
 KVM_RUN ioctl will return -EINTR. Once that happens, userspace
 should pause all the vcpus, then harvest all the dirty pages and
 rearm the dirty traps. It can unpause the guest after that.
+
+NOTE: the KVM_CAP_DIRTY_LOG_RING capability and the new ioctl
+KVM_RESET_DIRTY_RINGS are exclusive to the existing KVM_GET_DIRTY_LOG
+interface.  After enabling KVM_CAP_DIRTY_LOG_RING with an acceptable
+dirty ring size, the virtual machine will switch to the dirty ring
+tracking mode, and KVM_GET_DIRTY_LOG, KVM_CLEAR_DIRTY_LOG ioctls will
+stop working.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8642c977629b..782127d11e9d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1236,6 +1236,10 @@ int kvm_get_dirty_log(struct kvm *kvm,
 =09unsigned long n;
 =09unsigned long any =3D 0;
=20
+=09/* Dirty ring tracking is exclusive to dirty log tracking */
+=09if (kvm->dirty_ring_size)
+=09=09return -EINVAL;
+
 =09as_id =3D log->slot >> 16;
 =09id =3D (u16)log->slot;
 =09if (as_id >=3D KVM_ADDRESS_SPACE_NUM || id >=3D KVM_USER_MEM_SLOTS)
@@ -1293,6 +1297,10 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 =09unsigned long *dirty_bitmap;
 =09unsigned long *dirty_bitmap_buffer;
=20
+=09/* Dirty ring tracking is exclusive to dirty log tracking */
+=09if (kvm->dirty_ring_size)
+=09=09return -EINVAL;
+
 =09as_id =3D log->slot >> 16;
 =09id =3D (u16)log->slot;
 =09if (as_id >=3D KVM_ADDRESS_SPACE_NUM || id >=3D KVM_USER_MEM_SLOTS)
@@ -1364,6 +1372,10 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 =09unsigned long *dirty_bitmap;
 =09unsigned long *dirty_bitmap_buffer;
=20
+=09/* Dirty ring tracking is exclusive to dirty log tracking */
+=09if (kvm->dirty_ring_size)
+=09=09return -EINVAL;
+
 =09as_id =3D log->slot >> 16;
 =09id =3D (u16)log->slot;
 =09if (as_id >=3D KVM_ADDRESS_SPACE_NUM || id >=3D KVM_USER_MEM_SLOTS)
--=20
2.21.0

