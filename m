Return-Path: <kvm+bounces-28601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9DE999CFF
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 08:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCF77282262
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 06:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7761B20A5FF;
	Fri, 11 Oct 2024 06:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=erbse.13@gmx.de header.b="mcy13GH2"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D05A635
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 06:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728629290; cv=none; b=r1+iJT99AR4y6faQgKgwJT4gnhwZ+rjX7cQqkBDrdLmFKG2R+eAoihBB7vGarg5bRgURvGAS7ql1pvBgQgVHKyfceARyvT8WEm7Ar35on5slMeachqQD4WgdoqdusbD43I9SFYeiwzcZEt7HgFnY3jaNiKjYxLVLOYIDotP26ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728629290; c=relaxed/simple;
	bh=8iQ4A48zAvNfdQF8giTtol9jIk7dLRP3vKbhM1WtYvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qG4VhuNBqVlwYgDVA/icdwEQiF0wX2ksY+suTYauMTyTvfau5aAGSulkaqX8dPzGy2Vy93Ejgizz4p20eHmffDpeghS67hOOvkH0akasLyGrzV6VovJkwJLllp9q6RvLZaoLIPtfqrz4SwZa2WepmR6Zijx0SH00O9ExZs6N/RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=erbse.13@gmx.de header.b=mcy13GH2; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1728629275; x=1729234075; i=erbse.13@gmx.de;
	bh=lRYoZ8ZEfCljSmCfJERXD2hAZ7vpp+9eIza9Jf6ArUA=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-Id:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mcy13GH2c7B4b6bNWJ8EqrvoZWXM9i4Sdx/BcE0wuAqorXMKoi0NsjtqwU9gbllf
	 HVhT/dB+YBmaHBjw3h+U7aTFB0NQHXVaMd3V0VqBzLHcbPLWgYmugic32HMIgV5tV
	 Ru+HdLBVjpa5EP6RJi0YC9rp5RNHXruIKDTM7d6uewT0F6PqOdSnqnoO7SWW69Pn1
	 trJcJJxrYT9+t1mOld9xlz4aSBiTmM1x4rUYKHYh+uKVnvqrbVK+d7h2dHfgzGlYK
	 7sPkcEijyjPCcu/jUQ0e+rajnUoz97H0iD0hjPKiYIgIeOLZY6Y2+pv8oa/ROf+1o
	 UNZrke6CdfTRCAQybg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from server ([88.152.43.130]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M1Ygz-1sxlaq0h5f-001DVC; Fri, 11
 Oct 2024 08:47:55 +0200
From: Tom Dohrmann <erbse.13@gmx.de>
To: qemu-devel@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Dohrmann <erbse.13@gmx.de>,
	kvm@vger.kernel.org
Subject: Ping: [PATCH] accel/kvm: check for KVM_CAP_READONLY_MEM on VM
Date: Fri, 11 Oct 2024 06:47:33 +0000
Message-Id: <20241011064733.1123414-1-erbse.13@gmx.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240903062953.3926498-1-erbse.13@gmx.de>
References: <20240903062953.3926498-1-erbse.13@gmx.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yBu2dyWc2rfrxhheMUw1/2gv0CZRx+bb9aEGiRV4t12nG6Z2+rV
 xABtV7yRCNtIR62RpiLJuuoEAK08SPtfKWWfAGKBUvE1UmB8f7d9G5yRiMdhFbL5rAMVMbw
 E3uHRQbwL0xZNnVihp2phu9lIP3lyeHYpELh81TvOp79Aau5yd+FeD8Wbv6uxCTPQbAv/KK
 sgCBtkfucoBkozorjhItg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Ji03cwJ+J28=;cQrWFO3UDht6/S+lT2Gsx8Keypb
 fTHArrX58iqM2zv7CW8U/TcW6hyDgCTYltUMTsVMh9snCDP053opKzDQNTitOcB/92HrLE/b+
 zxNFCeP1u49dIGHBVQrSzSzn7P8WGTHN9fKj6hJ/HhrV4VmTU35PmNc4uI0lgVbBlJCogNN15
 a6K2j6/4jcm8cgOgeGALOcQTEXPXHKyu+0gyQ+ltJtgSiwydwzkG+mezx38YUiMQrMZ6cvbUB
 PukxhyIVQv++ceuieF8+uYlr0EGwlpj/YDBLDj3oyvkLLP6T8ogMWfqOfEGyPcv/07Lfy4Moj
 7KDG1lPzsfY6K6PFHNEN4augZYWr4m1y35G6JRVaG4BVrAFPmicsAgFMOerqxtTgqBKDw9n0O
 muHGKp/4dijFnuktgAaaMlUSO6xSU2fGBB8/0ONrS3yfQMmvDSqkE1FRcBR/7jfqeUUnurpHb
 QougsDgXbLa7fYQ8N/9fDYKjZi1Hvyu2C6/gTeTLRDDXuXnAFbR5EdR3l/HGUKAJimwV+CxeF
 CZfqOanuwGudoKK2XXDHIBbYLjeDHeJSRnIP1i939qTcQzVXr1s1qIExL4jo1v3+gqEnhfoys
 U2Pr9Crm35otfpoT1EHFjH16m6UPiPVGnYtB1H6e0053pu9IxvVSt2EM4LKYMwE1RG17pmmy6
 3ecTzP1OGQpKL9m5Cj5/+h02mu0DZkHEyHoBRZ4rrCy7kLvEUwRN7x+PxMfMthIstf4Z/2Oug
 mMylFhiRikU5w6bSJxPlGoVh9s1AHU38j54Kkfz5aJ2fjg0GJH+D8v/eczwEbAovhnlT4nl2V
 n5gt2NRQ4NPhlxHHpg/sMPvSj0O5GgoTwbTjpBnWdPd1I=

I haven't heard anything about this patch for a while.
https://patchew.org/QEMU/20240903062953.3926498-1-erbse.13@gmx.de/

=46rom 5c1ad1ff44438402ec824a224ac4659c8044ec7e Mon Sep 17 00:00:00 2001
From: Tom Dohrmann <erbse.13@gmx.de>
Date: Tue, 3 Sep 2024 06:25:04 +0000
Subject: [PATCH] accel/kvm: check for KVM_CAP_READONLY_MEM on VM

KVM_CAP_READONLY_MEM used to be a global capability, but with the
introduction of AMD SEV-SNP confidential VMs, this extension is not
always available on all VM types [1,2].

Query the extension on the VM level instead of on the KVM level.

[1] https://patchwork.kernel.org/project/kvm/patch/20240809190319.1710470-=
2-seanjc@google.com/
[2] https://patchwork.kernel.org/project/kvm/patch/20240902144219.3716974-=
1-erbse.13@gmx.de/

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Tom Dohrmann <erbse.13@gmx.de>
=2D--
 accel/kvm/kvm-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..acc23092e7 100644
=2D-- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2603,7 +2603,7 @@ static int kvm_init(MachineState *ms)
     }

     kvm_readonly_mem_allowed =3D
-        (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
+        (kvm_vm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);

     kvm_resamplefds_allowed =3D
         (kvm_check_extension(s, KVM_CAP_IRQFD_RESAMPLE) > 0);
=2D-
2.34.1


