Return-Path: <kvm+bounces-6268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B01382DE4E
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 18:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56B6B1F22A40
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 17:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1971802E;
	Mon, 15 Jan 2024 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="sgPKvRIr"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C5017C70;
	Mon, 15 Jan 2024 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1705338964; x=1705943764; i=markus.elfring@web.de;
	bh=/Ca96eOJyuxZcGSv7l/iefKgmthOd3AabqprAzeuaDY=;
	h=X-UI-Sender-Class:Date:To:Cc:From:Subject;
	b=sgPKvRIrBelWyeNzCjHkNZaM2fDhYHQ0kNneSgD1vuY6lY9XR7GqE5qdQ08EazWZ
	 jcjnsqrZsoC+wSJDq6Jqvj6eXNElZxygAZ5lC8ysod5DEWSeqKtDmn41Zhrllf3Ko
	 2LvpYP0x0ZV6RPaHg6TQ2nnWK7JxhudTgOY098If0ONgDJUkVNITIpdRin3o5o4ku
	 4t18SJI6FTXAIyBiMe05+tPlQSHL6H1EuvacnlNgM/zQdiK1qoje7RmfvM6fchNtu
	 ZfNL/r2ZEV54o8NCQeMpXrSsYm0fYAdc8ewWkqJ9YL3vlOYKjidLi4pqWZZoaoZ/3
	 n+zjN42TImfT2rZ6gw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.91.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MEUWM-1rNkoY35Y2-00FyPF; Mon, 15
 Jan 2024 18:16:04 +0100
Message-ID: <f1977c1c-1c55-4194-9f72-f77120b2e4e5@web.de>
Date: Mon, 15 Jan 2024 18:16:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kvm@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>,
 Eric Auger <eric.auger@redhat.com>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] vfio/platform: Use common error handling code in
 vfio_set_trigger()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Z7qzU6jLC5cPn/dLevgbgCx8zj31z9p9BzGnlUo6qnRP8d4y1Q4
 +LgCokwPLR5G9VadGZiu3ppi8llxC69DKuh3llJFNC6FiVQ+lswHbYdPzkGGPNUOBOlbCZz
 WIbrZQxOwm/G0FgSVHUwZUOW9jbGaBJZxNUPCLXMpKfI6tbRbQ2/IiFYhrw0LxbcSJEXNas
 DYbpsn2HWi/vpboCkYmlg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:RiqAqZK9y5E=;sYOKqyUlk+kJ4LlOPo3PXmIH83z
 pLTFVm2Les9olu7Uh211G5dElkH0PLTZHc0+i6Q6sjrOb8aneyH9PTlfzJr3O2eIvDvvq6Xf6
 qnR0o+e7TTAtFZFz3HkRly3edKY31eqbapPqVKji3GONpLBiJdF+h3XA3qoNhlRuqHMNDVkCH
 tV7K5DvGJ9Fs94RKL+s7zPWVaJgA1u8QM1uQnls50/y6dGgHwOpCXp0mkr+USqBzLTYy+9wEq
 r0fn9aCVUEg5/TNStg6AaOPLcu8z4KJWMS1eRx0WSMJaaMUBFEK0oOAlO4O9TYxF5NzkzFVuf
 GoD/VqVGnXJCYJyFl5Lr9V1JUlHqL75mpw7rkl92M1h10y7rBNfMC7QTrCHWB6zNFJFpFvrR7
 qTF1haSFmMdfAh+4P9X9cpMcTaI80gw0sQ9exKnOn/wZplLT/jd/otlpG7UUb+9gnQieSApQf
 JJBA9tuyzM7EnvgAE/kjy2lyS4UuQ8sMQGqKQZca8ZOeyExfvYcL+SiDlQ39ZtXVLd7arf/Lb
 SRy3UCgk6c1aO5mIcChHP+7a7FG1n5odboFiOJyUBCpfSKr2yDh115DfUfPeX8e8KaBBAs8t1
 zJgKfnUVHvo51Jj7OCCod7dQ2eE3LDV/sbH2IAKbfsBO1X1yUV7fgIZ4xBdh2sLz08AmVbrbr
 atd4nZ88pRufV0grZPqiSwQjBna/gmeHmLvUMmLHx93bmKIgE6Ht5cKAuXoiIkOtdaCdAXxXA
 B0VHsc7xwFvp0nCz9R8UmxPxJw13KsqeZnw/vJbvTTfOs/OzApL/yTJDGOXzfBxGsIYaXIGkw
 GWVewi5mfXCzNvqhp8ktmAV59SRLZ+BIzVy3ugjneh0/vNyoh2gVtUx7dcdCjWkYhbfeJWmWW
 cfx5OH4LpTFEvCJT0wdkQe3JmtaBjNuPTscVmFzNoi2739kp55BXZNLzY8OEI9T6RfJCthJ7w
 OAV3KA==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 15 Jan 2024 18:08:29 +0100

Add a jump target so that a bit of exception handling can be better reused
in an if branch of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/vfio/platform/vfio_platform_irq.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/plat=
form/vfio_platform_irq.c
index 61a1bfb68ac7..8604ce4f3fee 100644
=2D-- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -193,8 +193,8 @@ static int vfio_set_trigger(struct vfio_platform_devic=
e *vdev, int index,

 	trigger =3D eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
-		kfree(irq->name);
-		return PTR_ERR(trigger);
+		ret =3D PTR_ERR(trigger);
+		goto free_name;
 	}

 	irq->trigger =3D trigger;
@@ -202,9 +202,10 @@ static int vfio_set_trigger(struct vfio_platform_devi=
ce *vdev, int index,
 	irq_set_status_flags(irq->hwirq, IRQ_NOAUTOEN);
 	ret =3D request_irq(irq->hwirq, handler, 0, irq->name, irq);
 	if (ret) {
-		kfree(irq->name);
 		eventfd_ctx_put(trigger);
 		irq->trigger =3D NULL;
+free_name:
+		kfree(irq->name);
 		return ret;
 	}

=2D-
2.43.0


