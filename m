Return-Path: <kvm+bounces-20458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B061916126
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 10:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B75A281FCA
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 08:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921FE148319;
	Tue, 25 Jun 2024 08:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aq2/o9zR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680C21474AE
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 08:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719304114; cv=none; b=Cdcf6b9EOiPJAvUA07a4pg2ahuaq9G7rFGf9yuIMX2wx3rT7AZrEgqAlkTAXrzKbW/cL+f+hOGKRn1VTECvKSSG1wL641t833fKCN+fcHF6YyT3BFINdl15enykEbELbu+xi8jJSMhpxeryG+gwdwI7/qtPMY/b/sdxH1jl2Smw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719304114; c=relaxed/simple;
	bh=pcVPSWjSDwj2qdQTabx92V/Wxd+jwVnfvARxaXmoyNQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=qKygSUvfm1zvtetk66nh/2r+IFfpMNqCQyfAVow6MYLwQ3+6dKyAM0gy3qYLtwbWnFJFWOFmqLRsV/ZNwLMDl7C3RVd87ZrRYwdu7ENhw+Rxs7Nrlc/VKZqNe5d4pMtw19f4KMoBkVKU1dzp8ScXf+NHzKSgBpXk4dn/D2bEV+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Aq2/o9zR; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-79c05313ec8so31248685a.3
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 01:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719304112; x=1719908912; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pcVPSWjSDwj2qdQTabx92V/Wxd+jwVnfvARxaXmoyNQ=;
        b=Aq2/o9zRlaNzZKiU78LlOZAb7SdUDz9mIpnqUegGdhgcvr8mAmFsr3YA6wmoPW4o/H
         byc4CJMQGagozieUXB25WJWxuEA4WFAxfdDoqIIUu5i6BYFEWgJiaUtgd+zWALH0X9r1
         popZNXS5zlspxpH+2+MU+GCqBRj9HRMEOmXJz/Kjszy0Bcm9a6hQ/3qx9Xz3PKyiAzmr
         709+vohKLKlZeWgQolb8vN7zPq5+BigZPCwPq4A9nrIBK3raZ3X+jZxGU1OdH/ZX/c6Q
         E8maIIT0+PsEEW2wrue16u2RnLu6FS/q4w7sp/5qPfJ/Pt9KwJ6eY6ptuZ5qMdJwCMHF
         tt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719304112; x=1719908912;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pcVPSWjSDwj2qdQTabx92V/Wxd+jwVnfvARxaXmoyNQ=;
        b=E1/dMVEMjykpgUDQgMf4RF8sHGyzy6EgtN732Goj0ldNoOdJNHArSoWygmLE7EAhNw
         6zIO9GubO+1bj7rYGi0rggUxDFfkGUtxiqxpX48ctmKrDQrwx4bQ6Nj8CIDu1HPtQnOk
         cRDrh8cLZvD/bcVWdtDJE+4EUjfHDIm4HjU417E6qzN3fJlylmmm3h2l5CFEYYGIbF8V
         J+9EFFI7dl40sQ/fFCbLAUwcaFS3ao84G1ggr30FaZ8931H75nhnnQEHt9xqvqEa4Svs
         rtWD2+NAAGaJv/klX+glWHQz9yH3gxvqjqM+gqWIHcAZL6l5J2hsrnQKH/OEtorzjaZD
         7JqQ==
X-Gm-Message-State: AOJu0Ywjl+RCy9FMQl5zVKBDjuJHXxRTWZaLcrS6rjkOdQleOdayMqp8
	3y8JlI12Fy8iIWDREyTrd6E7j5nz8lbGQtRr3GXu/cpZ2YfqszCBPRBOqjcPA58x2YLgrL9ijDE
	V8ddJUnpVnvaFAGZfbt2QEsV08Jo4ORkc
X-Google-Smtp-Source: AGHT+IEQArkbUO7yi9tvMfZrJkZR3YQTLGFvlbBL8tzyddA4UbDJcdbb7Wx2IYALLAnUlgfXJWEIYQaUlwV++OGqWSo=
X-Received: by 2002:a05:6214:f64:b0:6b0:89ba:396a with SMTP id
 6a1803df08f44-6b53bfdc14emr104876816d6.47.1719304112249; Tue, 25 Jun 2024
 01:28:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Lokesh Chakka <lvenkatakumarchakka@gmail.com>
Date: Tue, 25 Jun 2024 13:58:21 +0530
Message-ID: <CACh--siitJ_cGuvq56oNTU-TYkd0VpBVBGsUU6AL20FtSYkD-g@mail.gmail.com>
Subject: adding two network cards connected b2b
To: kvm@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000df5e17061bb2ae94"

--000000000000df5e17061bb2ae94
Content-Type: multipart/alternative; boundary="000000000000df5e16061bb2ae92"

--000000000000df5e16061bb2ae92
Content-Type: text/plain; charset="UTF-8"

hi,

I've created an Ubuntu 24.04 VM on the Ubuntu 24.04 host machine.
I want to create two NICs in the VM connected B2B for some experimental
testing activity.

I've these two configuration snippets

First snippet I'm not sure where to put.
Second snippet, I'm able to understand that, I have to place it inside the
devices node.

Can someone help me understand if

the attached snippets are right
and
parent node for the first snippet ?

Thanks & Regards
--
Lokesh Chakka.

--000000000000df5e16061bb2ae92
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>hi,</div><div><br></div><div>I&#39;ve created an Ubun=
tu 24.04 VM on the Ubuntu 24.04 host machine.<br></div><div><div><div dir=
=3D"ltr" class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><=
div><div dir=3D"ltr"><div><div dir=3D"ltr"><div><div>I want to create two N=
ICs in the VM connected B2B for some experimental testing activity.</div><d=
iv><br></div><div>I&#39;ve these two configuration snippets</div></div></di=
v></div></div></div></div></div></div></div></div></div><div><div dir=3D"lt=
r" class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D=
"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr"><di=
v><div dir=3D"ltr"><br><div dir=3D"ltr"><div><div>First snippet I&#39;m not=
 sure where to put.<br></div>Second snippet, I&#39;m able to understand tha=
t, I have to place it inside the devices node.</div><br></div><div>Can some=
one help me understand if</div><div><br></div><div>the attached snippets ar=
e right</div><div>and</div><div>parent node for the first snippet ?</div><b=
r>Thanks &amp; Regards<br>--<br>Lokesh Chakka.</div></div></div></div></div=
></div></div></div></div></div></div></div>

--000000000000df5e16061bb2ae92--
--000000000000df5e17061bb2ae94
Content-Type: text/plain; charset="US-ASCII"; name="xml_snippets.txt"
Content-Disposition: attachment; filename="xml_snippets.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_lxu59mjz0>
X-Attachment-Id: f_lxu59mjz0

PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KPG5ldHdvcms+CiAgPG5hbWU+bXkt
dmlydHVhbC1uZXR3b3JrPC9uYW1lPgogIDxicmlkZ2UgbmFtZT0ndmlyYnIxJyBzdHA9J29uJyBk
ZWxheT0nMCcvPgogIDxmb3J3YXJkIG1vZGU9J25hdCcvPgogIDxpcCBhZGRyZXNzPScxOTIuMTY4
LjEwMC4xJyBuZXRtYXNrPScyNTUuMjU1LjI1NS4wJz4KICAgIDxkaGNwPgogICAgICA8cmFuZ2Ug
c3RhcnQ9JzE5Mi4xNjguMTAwLjInIGVuZD0nMTkyLjE2OC4xMDAuMjU0Jy8+CiAgICA8L2RoY3A+
CiAgPC9pcD4KPC9uZXR3b3JrPgo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQo9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQo8
ZGV2aWNlcz4KICA8IS0tIEV4aXN0aW5nIGRldmljZSBjb25maWd1cmF0aW9ucyAtLT4KCiAgPGlu
dGVyZmFjZSB0eXBlPSduZXR3b3JrJz4KICAgIDxtYWMgYWRkcmVzcz0nNTI6NTQ6MDA6MTE6MjI6
MzMnLz4KICAgIDxzb3VyY2UgbmV0d29yaz0nbXktdmlydHVhbC1uZXR3b3JrJy8+CiAgICA8bW9k
ZWwgdHlwZT0ndmlydGlvJy8+CiAgICA8YWRkcmVzcyB0eXBlPSdwY2knIGRvbWFpbj0nMHgwMDAw
JyBidXM9JzB4MDAnIHNsb3Q9JzB4MDQnIGZ1bmN0aW9uPScweDAnLz4KICA8L2ludGVyZmFjZT4K
ICA8aW50ZXJmYWNlIHR5cGU9J25ldHdvcmsnPgogICAgPG1hYyBhZGRyZXNzPSc1Mjo1NDowMDo0
NDo1NTo2NicvPgogICAgPHNvdXJjZSBuZXR3b3JrPSdteS12aXJ0dWFsLW5ldHdvcmsnLz4KICAg
IDxtb2RlbCB0eXBlPSd2aXJ0aW8nLz4KICAgIDxhZGRyZXNzIHR5cGU9J3BjaScgZG9tYWluPScw
eDAwMDAnIGJ1cz0nMHgwMCcgc2xvdD0nMHgwNScgZnVuY3Rpb249JzB4MCcvPgogIDwvaW50ZXJm
YWNlPgo8L2RldmljZXM+Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Cj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Cg==
--000000000000df5e17061bb2ae94--

