Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B0910DB0C
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387474AbfK2Vfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:35:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54825 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387442AbfK2Vff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 16:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8QU/MqZQ7iCrQiVB69BeiYZxD7DRU81Tku8GelhIUiI=;
        b=IzUL7DAGXh3zcCOhlyhmqbCnoju7FiA+ci2onjymAWUoY4mtqhESoVqIgJyBFX8LZthTzw
        ozbuU+FB7Wnvty04KSmBpT1qyRn/CfvyeDrns8JQpHPGfsJfdxTSh8n6z2FEoOVMx/D4lc
        EUi930BTVYEuEw0Sj/SuGFj4ZuRV7qE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217--47cwsCDN7OljjmuqIJh2g-1; Fri, 29 Nov 2019 16:35:31 -0500
Received: by mail-qv1-f69.google.com with SMTP id b15so19641156qvw.6
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ph8QPMVUt3TogI2QUxz0d6tIzYuPtW9qXzgfM49LbX4=;
        b=H3nnhXxWUAMfafdT3Yf//OFdj90bZi46GuQ84WDgAbwvwnS0KI63vPDwEW9lUwtFOf
         lv3rpv7k9+MDr+d6g3mcdanPdi/P3NA36k0BhtHVO+HCVWrNBFqj028VYx2kdYpr3tsH
         maOHjdUe1hOJdSXKRzadVUSce0H/myi4nd5Wft4WugP8zZRWqWv3uNAn8qHbJ3qEAfBv
         H4fT87/u6Z1L6VcDDiFsEOvLxnEmc18HiHweQCNyegGp1fKGTfG+c7vA6hC8uxcoNBel
         IH2ffsvAJZUmKXreNhrsjex/Q6frpcY1GmjbquRPzvr0q8gR/MM8W/dXOWW9QzBC6+jr
         SyRA==
X-Gm-Message-State: APjAAAXra0vtlvIqU3y/yi92HXvJIV9XY377TCnCEUBIDysO9LZxLG35
        TKTQNSiIQuSWRhwtHD8kjXsjHrWXduPBz/xA7i94w9d1mNg5qvIaVJWbEno33MEpJuaN8/9Q4JR
        37qfFlez1YSlg
X-Received: by 2002:a05:6214:82:: with SMTP id n2mr19784795qvr.199.1575063330862;
        Fri, 29 Nov 2019 13:35:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+kM+aluFDpDmrKxZEi1V2tHOv0XcDObShdoHe1wBVP230mj/s8I3XMHXPIKR24luMQ/sn5A==
X-Received: by 2002:a05:6214:82:: with SMTP id n2mr19784772qvr.199.1575063330639;
        Fri, 29 Nov 2019 13:35:30 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:30 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 14/15] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Fri, 29 Nov 2019 16:35:04 -0500
Message-Id: <20191129213505.18472-15-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: -47cwsCDN7OljjmuqIJh2g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's only used to override the existing dirty ring size/count.  If
with a bigger ring count, we test async of dirty ring.  If with a
smaller ring count, we test ring full code path.

It has no use for non-dirty-ring tests.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/s=
elftests/kvm/dirty_log_test.c
index 4799db91e919..c9db136a1f12 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -157,6 +157,7 @@ enum log_mode_t {
 /* Mode of logging.  Default is LOG_MODE_DIRTY_LOG */
 static enum log_mode_t host_log_mode;
 pthread_t vcpu_thread;
+static uint32_t test_dirty_ring_count =3D TEST_DIRTY_RING_COUNT;
=20
 /* Only way to pass this to the signal handler */
 struct kvm_vm *current_vm;
@@ -216,7 +217,7 @@ static void dirty_ring_create_vm_done(struct kvm_vm *vm=
)
 =09 * Switch to dirty ring mode after VM creation but before any
 =09 * of the vcpu creation.
 =09 */
-=09vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT *
+=09vm_enable_dirty_ring(vm, test_dirty_ring_count *
 =09=09=09     sizeof(struct kvm_dirty_gfn));
 }
=20
@@ -658,6 +659,9 @@ static void help(char *name)
 =09printf("usage: %s [-h] [-i iterations] [-I interval] "
 =09       "[-p offset] [-m mode]\n", name);
 =09puts("");
+=09printf(" -c: specify dirty ring size, in number of entries\n");
+=09printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
+=09       TEST_DIRTY_RING_COUNT);
 =09printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 =09       TEST_HOST_LOOP_N);
 =09printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -713,8 +717,11 @@ int main(int argc, char *argv[])
 =09vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
 #endif
=20
-=09while ((opt =3D getopt(argc, argv, "hi:I:p:m:M:")) !=3D -1) {
+=09while ((opt =3D getopt(argc, argv, "c:hi:I:p:m:M:")) !=3D -1) {
 =09=09switch (opt) {
+=09=09case 'c':
+=09=09=09test_dirty_ring_count =3D strtol(optarg, NULL, 10);
+=09=09=09break;
 =09=09case 'i':
 =09=09=09iterations =3D strtol(optarg, NULL, 10);
 =09=09=09break;
--=20
2.21.0

