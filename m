Return-Path: <kvm+bounces-66527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 82403CD775E
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 00:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 829FA30184CE
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 23:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679B032F761;
	Mon, 22 Dec 2025 23:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Swuj+OYA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E824C2FFFBE
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 23:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766446666; cv=none; b=fRMKhEQz0rTyDEIHYsl6LLAOHIR5yubrGUwcBbOcv5IXYHd5S/DoZZcXq7ToEGzQHpqNs6DDrrLWrNm48EiwtxnXU61nmZ75Yo0Dr7O2fmB7ZiP6INhh9FPXqVcF+X3phYiC+VRKUmcSgBr9rtru0m8F+JcIZd8wx4FUVHfki0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766446666; c=relaxed/simple;
	bh=nY66VQOhbvqdzZgeGL+/FZXbOwO7nvJBigVU8eFU+VU=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:Cc:To:
	 Message-Id; b=sMvOdFiXTfGgwLLQrm+B7x6AYXb5KP2fQHp0btWPva9cA14uFBe/bVfiqHcMcxSRP3mbv1ZjtIqvOBlSTWkUjxAMqB2Yh0sWBwXlYrXEZ/vodVKmaLBxVs44el5F2x+ZvbAKhmTjTl4nfZe4ZVSJV/hutFqyLYM0pxQBr3FraH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Swuj+OYA; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88860551e39so35787096d6.3
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 15:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766446664; x=1767051464; darn=vger.kernel.org;
        h=message-id:to:cc:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FJvGwq+7Pamxnffgvl/Xh+Dw+LtLBntFoSfEkNe0+74=;
        b=Swuj+OYAPk+niqiClQn7cXdOSe0RYifqTLp+49YcHpXFJ3F+z/+lKk+J7PqHN62TK7
         awYbXttrcjGQbiY83e9ngG2ZVc/eGpJ0jthG3RBiJKUxdCV/PGQoJGQOPFXr+a/Y+qhj
         aH5bSu/WOLyXSw+TJpiV+jQ1StOJUT3ccC9q+AUS0sQ+TE/rXK6GD35+vTcIslLfh4jH
         AJ/XO9jezw9gTciHuz+4LNpyfmwRsTM3gomXPBAwMKOowdO3nQjpsltbAuPuzkFB7lov
         9a+M/cEXeeZH+WG85yuADxvI4jeOEwKuAMzcZYrQxO5NnJn7o6cPI2qW7qTdHmKO39Fp
         7iIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766446664; x=1767051464;
        h=message-id:to:cc:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FJvGwq+7Pamxnffgvl/Xh+Dw+LtLBntFoSfEkNe0+74=;
        b=pHks8Y0PcoS2bJ4NQ/09FHCasfcL+5tKPibVTG/KtBdWQX3fs1mxXuHYxT6juC0Huz
         bfpvlM/CB4EDioOH8bsrhHgaY6dOPe1aciK3vDEc7Gpp9mcAAK0OJTO89jH6cIACYJUe
         yK3PNvtQqlUbltB9RR+nf+x3M0EpwZRoLMslJw+jU8rC8q99/r/Qv6NxOgOSyoUZjsCg
         Cau/IyZ+8z1/B2/lVsEpuswKsA6R7DckV1e+mQ/uSNY6bo+EDFMs/FF3e/yGEdL8cpNL
         xS+0gSIUX8RUhA7L26XsRaC/bBQbnKYF1hrF2WLEjl3i5dQK1IrZlFlUq+dgv2Erge5q
         SvOw==
X-Forwarded-Encrypted: i=1; AJvYcCVptffFtdH5ecOhq0A7Hq3dF/has8lXZd8riRKAdyTDtroegAxszBPVANMYh7coHGp5Vso=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSkIFR2oIbmQFXOVW209U9Kh8QaueKrkVAQOLVLM2vjaY2eZ+S
	XNy0wLyuHIccCiF+0kA0jAoyzeUwO2a8YxeUjjz4z4LvG7zmiqZs747JbxjjKA==
X-Gm-Gg: AY/fxX7iAfKtbjWzmCz/Ln7Tz6ZHsJmIgpe1Zs6GFbNCbCD1gnLotSzayNfbfsBYJE4
	d2oil/U51DN4FgXuza/vGiWSKmedoXxxnAr+IVim8WRkeX/szLwJFGyDidN0CTRzDR6Yh6vEcIb
	8JjL9LC2J9g1bUcfwPE0/jCxT6OcGQg32uhHUvnhXFCaEc+36rNOkZl1OBNu3YG+NeWR3ZUB+IN
	9w5wWosNnE7feZ+W2A97krqNdtQe7oPsb89zNgnvhFczxoL88eNMXcrCTk1NAZp5lMzuYD6pRsb
	jJ6LYSfan+VI+lF4mDbiUyf+EGtFIhAoks4bX15Y/qhRYQ+lKciJqEzricuOpahQPHzOKHZg7Yh
	EeUmqUvC4pxkrLa1Oogpv2zM4Nh3Bun7foqhUA4MDLdqA+/hCyOSVyF+/txERyDIg+GvHd1a9v+
	kZFFKpu0bRP260zKjNdNiGqC2UebzBWo8BEzyxKQ8C8fl5nhZJ
X-Google-Smtp-Source: AGHT+IH04yosElyDXNujxX0PrNcUfcACTFFNNR9hYLNll/S61gWZPfwdzqxkwHHQqV8TVPhTPC/bVQ==
X-Received: by 2002:a05:622a:4d08:b0:4ee:1879:e473 with SMTP id d75a77b69052e-4f4abcf3b54mr205212151cf.32.1766446663663;
        Mon, 22 Dec 2025 15:37:43 -0800 (PST)
Received: from smtpclient.apple ([2600:4041:45af:2c00:59d7:91be:c779:cc7e])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac62fa56sm93666341cf.17.2025.12.22.15.37.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Dec 2025 15:37:43 -0800 (PST)
From: Patrick Bianchi <patrick.w.bianchi@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.3\))
Subject: Fwd: PCI Quirk - UGreen DXP8800 Plus
Date: Mon, 22 Dec 2025 18:37:32 -0500
References: <A005FF97-BB8D-49F6-994F-36C4A373FA59@gmail.com>
Cc: alex@shazbot.org,
 kvm@vger.kernel.org,
 Bjorn Helgaas <bhelgaas@google.com>
To: linux-pci@vger.kernel.org
Message-Id: <26F3F2EE-37D4-4F73-9A51-EDD662EBEFF2@gmail.com>
X-Mailer: Apple Mail (2.3826.700.81.1.3)

Hello everyone.  At the advice of Bjorn Helgaas, I=E2=80=99m forwarding =
this message to all of you.  Hope it=E2=80=99s helpful for future kernel =
revisions!



Begin forwarded message:

From: Patrick Bianchi <patrick.w.bianchi@gmail.com>
Subject: PCI Quirk - UGreen DXP8800 Plus
Date: December 20, 2025 at 9:56:10=E2=80=AFPM EST
To: bhelgaas@google.com

Hello!

Let me start this off by saying that I=E2=80=99ve never submitted =
anything like this before and I am not 100% sure I=E2=80=99m even in the =
right place.  I was advised by a member on the Proxmox community forums =
to submit my findings/request to the PCI subsystem maintainer and they =
gave me a link to this e-mail.  If I=E2=80=99m in the wrong place, =
please feel free to redirect me.

I stumbled upon this thread =
(https://forum.proxmox.com/threads/problems-with-pcie-passthrough-with-two=
-identical-devices.149003/) when looking for solutions to passing =
through the SATA controllers in my UGreen DXP8800 Plus NAS to a Proxmox =
VM.  In post #12 by user =E2=80=9Ccelemine1gig=E2=80=9D they explain =
that adding a PCI quirk and building a test kernel, which I did - over =
the course of three days and with a lot of help from Google Gemini!  =
I=E2=80=99m not very fluent in Linux or this type of thing at all, but =
I=E2=80=99m also not afraid to try by following some directions.  =
Thankfully, the proposed solution did work and now both of the NAS=E2=80=99=
s SATA controllers stay awake and are passed through to the VM.  I=E2=80=99=
ve pasted the quirk below.

I guess the end goal would be to have this added to future kernels so =
that people with this particular hardware combination don=E2=80=99t run =
into PCI reset problems and don=E2=80=99t have to build their own =
kernels at ever update.  Or at least that=E2=80=99s how I understand it =
from reading through that thread a few times.

I hope this was the right procedure for making this request.  Please let =
me know if there=E2=80=99s anything else you need from me.  Thank you!

-Patrick Bianchi



C:
/*
* Test patch for Asmedia SATA controller issues with PCI-pass-through
* Some Asmedia ASM1164 controllers do not seem to successfully
* complete a bus reset.
*/


