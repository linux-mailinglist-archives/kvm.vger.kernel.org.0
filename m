Return-Path: <kvm+bounces-6332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A93482EDC2
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 12:32:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 079E628311C
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 11:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E341B81B;
	Tue, 16 Jan 2024 11:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="JyKeXbNH"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2AE1B7F3;
	Tue, 16 Jan 2024 11:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1705404751; x=1706009551; i=markus.elfring@web.de;
	bh=iAhuJ/qQVCBNcDA7a+DCqneotDxV2KRsYE5G4LmVFbU=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:
	 In-Reply-To;
	b=JyKeXbNHh1YPE38KNNl4pFzENqsj94iAtCjxFl4cpg3AVhjVweCJdJorozew0HUk
	 PLmzumEy8feCAr8TbT+MBZ1mhVmeoj83jVdPwWDPACQlDR4uzRAW5gL6bzLHgBmuU
	 x5/uE4q7oGW3a97U56to2eqE9Rw/PM5uxjz8FbxMOdY7OBW0auQ/qqYofYNkRsy8H
	 2UUH2QOl1IPcazulENk6DKTVDNO88RnTMezLXmiQNQlce0tkmcPlIKh+wh0UVUpFj
	 UjoPCZFqwx/oaimbV+71yIdSWLYw4DiorsaP7SH5htwq0WUIeQ+5KgScr8jhDVIWe
	 G+umHwAdFkWxr8yYgw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.91.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MWQud-1rejZM22Z9-00Xum7; Tue, 16
 Jan 2024 12:32:31 +0100
Message-ID: <ab6bcd8b-f53c-47d1-8c55-c374a36d6ee4@web.de>
Date: Tue, 16 Jan 2024 12:32:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: vfio/platform: Use common error handling code in
 vfio_set_trigger()
To: Alex Williamson <alex.williamson@redhat.com>,
 Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
References: <f1977c1c-1c55-4194-9f72-f77120b2e4e5@web.de>
 <20240115133756.674ae019.alex.williamson@redhat.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240115133756.674ae019.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ePm0QBO8e1avTdTL7DQnx+zr63juMwHQUHf/MqZ58wen1wf5U7Q
 nC3rH0Y822QXoWWjh+pQEpbDg3/sfZlNbp5rzTmaueSlfOeDQMvjChS5PA1EA+f5QeXrAYB
 e+xUQZKDGO2NVaZScLr+gzBv1iRwO/Jvy96wltiWVBW9SPMZVrlzjcneICYitwJKhjV7c45
 nX3vUK8bTg9BmiqmeREfA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:l+D0pf4ENc4=;xhq2bwmffmLpT/ZH3Np3y9ADRoj
 N1+L5kyZkxluuNKM0B3HLryXKaZM4Bmw9IF71gmD/NvN1UXcaSimmSYleskDk34BmvCxiS9TR
 66TpSQspB5GxBzlTRs08LqIlhr3ZtazmIFo+aDOj/4vsyvwoEU3LZDFtS09e2cp8FH/5/dCaD
 2ofTW7FjWNm454s1g0YOwAOxtrh3VrvOhrCjAu4QAKd7q1XqNxnnRBJ3kPDKxpK0Ptj4DRpBH
 NuWUa4yasDkv+xadIkSmOpPv4Bffz7Xcr0naGYcd8lYVk13G/gTZbo36lmcsvsTybRAfYxBbY
 JXmiFDSXY7/VQFiVSS0EBgAWupLRkaZED1PgWePy6XbWCRmzYQAPNcQ6AZwpXk0BLXDhtzfMy
 tf/ELA4ixuI1t8LMyFCguwNiZm4vCEtLK2FVqXsGU5t0e+ZYSI+zHawXuT3Yb1qUDgrVw6SCL
 PLcMrk+MPln7inGNSpdqudNOuWGhX9xaFldslB4PJcmSfRlwUCBIJGb/m3hmz7HkcqFSo9apM
 rUK0eMourke44zu1lJWNTOPny8F1R5ewmQUzMuljl8vouB2W4fbYLSWyfS/UT8OEIFfq9kNA0
 qPcavZL6ErQm40yTY1xiNtzM1907n0Qwek8mnNT69k5EPJAm0zqd5IODeTFGviFfkwmNUL9fs
 MYbWxxYBxQiFT6UaSnfuwnjI6LgwsSYIm7eLB9DvNZdKTeTufFl6Jhu0vOwdKZgw6sOwCjgu3
 dShjq/T6s53g9+2ViAJY3i1bPI9L1aQkWO7izKuJ1acESISH3Xq4HvXvC67yAOdizA8Cwnzle
 TfM+g6Nf8G1KeCmXEUBlaIBN6su1NBFrqBdhbX28EyfGIuMKrfsFb7AEg17N/uNoIheUYfUs8
 dt/nEzFPSKmjlX7OOX9qrj4E3ttIaVZ0/fq+0cO30pBho+W+psAoBmc9174Lup6LaW7+dsY7g
 2IS9ig==

> TBH, this doesn't seem like a worthwhile exit point consolidation.  A
> change like this might be justified if there were some common unlock
> code that could be shared, but for a simple free and return errno by
> jumping to a different exception block, rather than even a common exit
> block, I don't see the value.

Can it be helpful to store the shown kfree() call only once
in this function implementation?

Regards,
Markus

