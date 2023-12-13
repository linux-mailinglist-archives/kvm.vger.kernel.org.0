Return-Path: <kvm+bounces-4398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 102A8812051
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 22:02:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BA821C21119
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 21:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03BD37E57B;
	Wed, 13 Dec 2023 21:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PdsXvN7U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF85BF3
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 13:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702501321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V9Y4tQelQotKGCNtpb33VNfk/Uf5WfNvGE9AkWeF3LY=;
	b=PdsXvN7UFkEWM9Hva38F7bgie3fBSeSJsKItXb3XPNhbN6RJykqY48+xx8TwL/sEHDkI8v
	eg7e25McNUOZxR+WRFLWjUCtPa6mUfE7FalXCVC7fn/3l1a2KyzDBJ4zUKoN2vlb4S1HRm
	LCOBbFZyx21M7J/1Ane/S9dImzUchiA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-dF0vmdgUP1aw5h4Fi8V0kg-1; Wed, 13 Dec 2023 16:01:57 -0500
X-MC-Unique: dF0vmdgUP1aw5h4Fi8V0kg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2D0B185A785;
	Wed, 13 Dec 2023 21:01:56 +0000 (UTC)
Received: from p1.localdomain.some.host.somewhere.org (ovpn-114-21.gru2.redhat.com [10.97.114.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D69BF2026D66;
	Wed, 13 Dec 2023 21:01:48 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>, Radoslaw Biernacki
 <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Akihiko Odaki
 <akihiko.odaki@daynix.com>, Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,
 kvm@vger.kernel.org, qemu-arm@nongnu.org, Philippe =?utf-8?Q?Mathieu-Daud?=
 =?utf-8?Q?=C3=A9?=
 <philmd@linaro.org>, Beraldo Leal <bleal@redhat.com>, Wainer dos Santos
 Moschetta <wainersm@redhat.com>, Sriram Yagnaraman
 <sriram.yagnaraman@est.tech>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 04/10] tests/avocado: machine aarch64: standardize
 location and RO/RW access
In-Reply-To: <2972842d-e4bf-49eb-9d72-01b8049f18bf@linaro.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-5-crosa@redhat.com>
 <2972842d-e4bf-49eb-9d72-01b8049f18bf@linaro.org>
Date: Wed, 13 Dec 2023 16:01:39 -0500
Message-ID: <87le9xvmto.fsf@p1.localdomain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org> writes:

> W dniu 8.12.2023 o=C2=A020:09, Cleber Rosa pisze:
>> The tests under machine_aarch64_virt.py do not need read-write access
>> to the ISOs.  The ones under machine_aarch64_sbsaref.py, on the other
>> hand, will need read-write access, so let's give each test an unique
>> file.
>>=20
>> And while at it, let's use a single code style and hash for the ISO
>> url.
>>=20
>> Signed-off-by: Cleber Rosa<crosa@redhat.com>
>
> It is ISO file, so sbsa-ref tests should be fine with readonly as well.
>
> Nothing gets installed so nothing is written. We only test does boot work=
s.

That was my original expectation too.  But, with nothing but the
following change:

diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/machi=
ne_aarch64_sbsaref.py
index 528c7d2934..436da4b156 100644
--- a/tests/avocado/machine_aarch64_sbsaref.py
+++ b/tests/avocado/machine_aarch64_sbsaref.py
@@ -129,7 +129,7 @@ def boot_alpine_linux(self, cpu):
             "-cpu",
             cpu,
             "-drive",
-            f"file=3D{iso_path},format=3Draw",
+            f"file=3D{iso_path},readonly=3Don,format=3Draw",
             "-device",
             "virtio-rng-pci,rng=3Drng0",
             "-object",

We get:

15:55:10 DEBUG| VM launch command: './qemu-system-aarch64 -display none -vg=
a none -chardev socket,id=3Dmon,fd=3D15 -mon chardev=3Dmon,mode=3Dcontrol -=
machine sbsa-ref -
chardev socket,id=3Dconsole,fd=3D20 -serial chardev:console -cpu cortex-a57=
 -drive if=3Dpflash,file=3D/home/cleber/avocado/job-results/job-2023-12-13T=
15.55-28ef2b5/test
-results/tmp_dirx8p5xzt4/1-tests_avocado_machine_aarch64_sbsaref.py_Aarch64=
SbsarefMachine.test_sbsaref_alpine_linux_cortex_a57/SBSA_FLASH0.fd,format=
=3Draw -drive=20
if=3Dpflash,file=3D/home/cleber/avocado/job-results/job-2023-12-13T15.55-28=
ef2b5/test-results/tmp_dirx8p5xzt4/1-tests_avocado_machine_aarch64_sbsaref.=
py_Aarch64Sbsa
refMachine.test_sbsaref_alpine_linux_cortex_a57/SBSA_FLASH1.fd,format=3Draw=
 -smp 1 -machine sbsa-ref -cpu cortex-a57 -drive file=3D/home/cleber/avocad=
o/data/cache/b
y_location/0154b7cd3a4f5e135299060c8cabbeec10b70b6d/alpine-standard-3.17.2-=
aarch64.iso,readonly=3Don,format=3Draw -device virtio-rng-pci,rng=3Drng0 -o=
bject rng-random
,id=3Drng0,filename=3D/dev/urandom'

Followed by:

15:55:10 DEBUG| Failed to establish session:
  | Traceback (most recent call last):
  |   File "/home/cleber/src/qemu/python/qemu/qmp/protocol.py", line 425, i=
n _session_guard
  |     await coro
  |   File "/home/cleber/src/qemu/python/qemu/qmp/qmp_client.py", line 253,=
 in _establish_session
  |     await self._negotiate()
  |   File "/home/cleber/src/qemu/python/qemu/qmp/qmp_client.py", line 305,=
 in _negotiate
  |     reply =3D await self._recv()
  |             ^^^^^^^^^^^^^^^^^^
  |   File "/home/cleber/src/qemu/python/qemu/qmp/protocol.py", line 1009, =
in _recv
  |     message =3D await self._do_recv()
  |               ^^^^^^^^^^^^^^^^^^^^^
  |   File "/home/cleber/src/qemu/python/qemu/qmp/qmp_client.py", line 402,=
 in _do_recv
  |     msg_bytes =3D await self._readline()
  |                 ^^^^^^^^^^^^^^^^^^^^^^
  |   File "/home/cleber/src/qemu/python/qemu/qmp/protocol.py", line 977, i=
n _readline
  |     raise EOFError
  | EOFError

With qemu-system-arch producing on stdout:

   qemu-system-aarch64: Block node is read-only

Any ideas on the reason or cause?

Thanks,
- Cleber.


