Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12251CDD4E
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 16:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgEKOc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 10:32:59 -0400
Received: from mout.web.de ([212.227.15.14]:41277 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgEKOc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 10:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589207572;
        bh=rNkXSfW1gWhPaMVtisoobrPSgqZO7qvEPmo1s7Nj4HQ=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=cH7xF1SE7C+d8usuEdh5uEG2bmdSAidlfP1b8Rhvxcm4HyEa2YXZPDV7VDudYyMhQ
         7m/YmeAHTd6JRK5Jgcenr6CYYsOzdZ6tPahhwNLobuBdUsm0R4TGRdHvDPvwYv9396
         FrjCEL04LeoFjsnEFzwEggElKzrXHB0vdcny5ykQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.185.130]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Mg7Vd-1jm8810IXF-00NONl; Mon, 11
 May 2020 16:32:52 +0200
To:     Qian Cai <cai@lca.pw>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH] vfio/pci: Fix memory leaks of eventfd context in
 vfio_pci_release()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <4b456734-f3f1-0e41-eb3b-ad1b06068dac@web.de>
Date:   Mon, 11 May 2020 16:32:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1dfk9xpX1CYUSUY8i1BwK3V/oYnN4t1R6fXFMKWHQGSBNhR6SNq
 LFvkB0ntwWKa7lCT3YNOHRSvVffSKTm9vMZq+Wp6sw+z69NTBNsCEyUHWVD1VPGjmJFpcMA
 j5YQI4GAd0Ojp7aLeDfCTLsp5SavHnsTxyomd9Gs9IvP1wAYrL9MbEEnr4nNJCL6ek9hqyE
 9T6x18rQMCxXxii64NtoA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nKLnRso5E5A=:YZQXCS03lI0dxAFnLJA3Q0
 UHsvpLUQTQhCJbM6P1RqfVOqR0jXs6DqXfXypvx8yv7iUkjB8n34jQzAdBoMGxhGoejNhcrwn
 zgbR+ZW0y6RIVIWJNPRla1GMLSIHstzlIFuP9L4w2N4YdCyK5ynozcMfjCTdwucoJG6yge8X8
 K8bDyLQo8BZD+pOD+p6vRqbvSDJYaHwbCDMEmyzn7K+HSE9NfZS7Lcelfj2se4mSjLEPGWuJO
 vq0ZxgcfxDTMx8Frmdu0p0GvG0c4pstFBjqazKaTv3Qy6UlYkSaljLtQWwpbNHM8P5s70TjgR
 UD+Xpe3JR7jBUjnn6ZFh3YZ3MAJreD8rclSYoJy7A8zELfWEe/LjdMHTfpLlfmSp3/5K5D/43
 6oB4tO1OisSmLDVVr5OFO+pZXcOxERiwxiYejEB0NFxZ0vMXTRVmM0IIVHq+aoDtojaWg8RdV
 Qg3XzhJKaPXfHojIy9xfAWbFwZEPIzxbt7/jqYqq2HPqWU/trCUi0VKfd4vdOpXErwDGL7YZj
 p8Si77sz712OaFfzosvtpTMnhVA6T7QjcUZSBHPShhX/wsccA13atIxhoFYGgc6Xdp4g1Q+4R
 QVVkWiFsAjzNXg3wMXBUZSouTtQ9EPPrPD1OX4RgtprBkZLl23kwvZIDKFRjiQLlyr7arcomr
 D9gSt3hPaTuXIMKKgABZOCbBMDr4feRq2QRepiQ521pYEIzwPoe2jUHbuPBqmGq56kdf0uJFP
 BNZN9NiK4Ogn/SDlgNBzrYe5ydHpog2Y20i6rd0qEvn9XzVPM+j6QAPOuy8esWgUKOfcx8M6g
 9xnUrgBotNcp/blWPUoJKnQT9Lcyay9m4Q6OnmkkEF2qQCN2i/a/WnxP6mvXhIPl8LRTjDKHV
 HbXzbv6MtR0fAC+TaEpjURfWXhloRizjBbj+INUvCk9zLLUEmYnMSXXlVSa+CEfPWe+TFVbTf
 IDmPuQpEEZLmH+T+74CN4IKtVhpRlXjhNIF1bxVI4YEnOx+Fr+Pl+fh3vLm1CuuwMxsPUsXVF
 +M6mD1RSNr2fXoFxBvYhBpOXEhVS7+4wP7bh1JV+tGrzQKYDcXO3Qm8VratepbnUEhsvpTclH
 eipB5+LZFKKEtHQRY3NvaHnaP6ZiUwHwjX//Iw0VNysm1Xk+Whdk2+SXG2QNTeu+n1fR5u8jc
 roAcvOp8wCV7EQueeEyjvRL2tPuAgIQdbkWi1Amgk651xcHFxs57Mid54fFCDCJ30/4v4NgFg
 Z+Id7x12JicZuSibM
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Finished a qemu-kvm (-device vfio-pci,host=3D0001:01:00.0) triggers a fe=
w
> memory leaks after a while because vfio_pci_set_ctx_trigger_single()
> calls eventfd_ctx_fdget() without the matching eventfd_ctx_put() later.
> Fix it by calling eventfd_ctx_put() for those memory in
> vfio_pci_release() before vfio_device_release().
=E2=80=A6

Will a wording fine-tuning become helpful for this change description?

Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?

Regards,
Markus
