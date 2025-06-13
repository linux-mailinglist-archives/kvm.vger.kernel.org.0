Return-Path: <kvm+bounces-49402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA280AD894F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 12:19:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4875F188FDE3
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 10:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631282D2396;
	Fri, 13 Jun 2025 10:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jHjCG87S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CF02749DB
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 10:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749809896; cv=none; b=k/zWGxPJrIi6QaKnbNSM9fB3KD966E9/qrLNlS7wK0aFeazUTqtIp0czcOM7Dxp+/0xrw4JracigkLaULFaYygm6SgkAyhoPEB+ZDgfM2mZjTZ2lt7I5lcsIwSt2byom2Nq1CUrHLT52+N3KMZGdPrXjcNv/PHfLwJjNs18I108=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749809896; c=relaxed/simple;
	bh=tjNKkvo5/S6wtsunxSnvf6G3iE7LsT8AIxUWIhRBBIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxvPhFR3wF4bwa0jmTEHV90Q/2MnooFVqzkwRRNZsGNDKl85VW/ljtq2SWgFOXB/faYoOTnSbIlRIzEGFdRZuEGCubUYJcQvsHCEzw2+qZ7ceUG1ja6eCFSAFYTnfC927XEbUbV2CR+9aWhosZVUcnuGJXey3UlUaildHSj0J/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jHjCG87S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749809893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9Gppa7BAPiTJbTtafNpUQg+an3/WD3nhPG5Bw17Zkcg=;
	b=jHjCG87SBqo/fYiM0oSY7aj0Pf34QZ8bhYlGtYP0dE35efKkcHgDtncqHROVaZNIk/WSYm
	+8gHTi4FuowacNYNeXoz2M0l7DT2w+Zg++inmKFr0OiUMbkXh2YWeQq/KJgmRYpOWe4a9k
	n6B7clwkuAbxW9RklXj9PCOr38F/gEU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-Y2Arh02rNh-LyrC5ZhUfEg-1; Fri, 13 Jun 2025 06:18:12 -0400
X-MC-Unique: Y2Arh02rNh-LyrC5ZhUfEg-1
X-Mimecast-MFC-AGG-ID: Y2Arh02rNh-LyrC5ZhUfEg_1749809891
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4532ff43376so12666005e9.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 03:18:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749809891; x=1750414691;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Gppa7BAPiTJbTtafNpUQg+an3/WD3nhPG5Bw17Zkcg=;
        b=G09LMGW+sBKI7BmZX1QgyPRaaUtUaPeZqf4PnnOGi2qQjtdB/him9IDj5fS/vyK2te
         n/o2p/60LWVJpi8FxvRQrTnG+/sLjEEVgSh92f8+OjLGb57LKieh18p56XbAFccwXGWy
         ZYk9evXJUbqtcVUngmfBgXz0o42BVX1H+XguXpcQsJh7KjH2nux4VclgXWWw+yLwhXLl
         c7QuItrmyPAuKXRjDEfF1kyMMBwm+xyeiBH2xon1mT3Mrl5YMtks1IGma++TEhyTuuXP
         j8ZZITqoC+Xuc2zrC3IJC81qFuM+SNl02WMbSJc6Yf1KZG0ZO85d0cQdYE3S0Q1Gn1KB
         YNFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvX0Xlf3a6+ZBL3tE3I8/DGTMiLp3t67LnFv0mJ8+yzAPN8NsTNrHAbVG2CyNo/Jl8rBc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOM/4lFvlbCZfny/DrCTelOMS00qC+MQA0b7/IRso5MwJLqs8k
	kLgU6au3Qm0LsHapzJkvt86qSVcajtejbleFIS0+rcIilHXus9s0fmnFfUTu636rrhzoh2+fre+
	gLURI4m5NdVWyPZ95HqrB58lUq3CYm8NvFxVMejejxpIP64z+jRwTLg==
X-Gm-Gg: ASbGncsUmjeVuk0bwSMmH5TS8/7LKX/Puyht5aocsID6TAh21eFNrkoouJLzaosuEkA
	KWZI0vqG4geCE4QWAkrWeQprwBm3pVK+aT8pxZcvfAWb6xmJ51DjacKMDcIUaOYZjIASSVOQshE
	H6o8UjZu0hzz6dw3OEVcbGZQGPw4nvzylw0/de3O47FI3b2vcecD9mnWu1UaexNgpoSC1NpaihI
	zvetQ0in0EssFBf3yPdHkCqR1ZxF2Sy9F42ZYvGTAcp8PVjr8CyrbLNqDlmEJShrWStNtcLJK5J
	Hs0S+lJoQQP7dD85KO9WA9U0Ym3MEF9JG5AwoexJrT1WjJlsotXEEtOS25PvPA==
X-Received: by 2002:a05:6000:240d:b0:3a4:f7df:baf5 with SMTP id ffacd0b85a97d-3a56850045amr2490763f8f.0.1749809890824;
        Fri, 13 Jun 2025 03:18:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUcCUzrmhym6DcEdRvbLCi/6KESO020/BzSayZJh8dRA2Gt3SPHJKtX4CLI2+Iv4DiusTsRA==
X-Received: by 2002:a05:6000:240d:b0:3a4:f7df:baf5 with SMTP id ffacd0b85a97d-3a56850045amr2490620f8f.0.1749809889999;
        Fri, 13 Jun 2025 03:18:09 -0700 (PDT)
Received: from [192.168.0.4] (ltea-047-064-114-027.pools.arcor-ip.net. [47.64.114.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b089d8sm1923446f8f.57.2025.06.13.03.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 03:18:09 -0700 (PDT)
Message-ID: <3797652b-86a5-4abf-becb-de62dfebccd4@redhat.com>
Date: Fri, 13 Jun 2025 12:18:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] python: update pylint ignores
To: John Snow <jsnow@redhat.com>, qemu-devel@nongnu.org
Cc: Joel Stanley <joel@jms.id.au>, Yi Liu <yi.l.liu@intel.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Helge Deller <deller@gmx.de>, Andrew Jeffery <andrew@codeconstruct.com.au>,
 Fabiano Rosas <farosas@suse.de>, Alexander Bulekov <alxndr@bu.edu>,
 Darren Kenny <darren.kenny@oracle.com>,
 Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Ed Maste <emaste@freebsd.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Warner Losh <imp@bsdimp.com>, Kevin Wolf <kwolf@redhat.com>,
 Tyrone Ting <kfting@nuvoton.com>, Eric Blake <eblake@redhat.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Troy Lee <leetroy@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Michael Roth <michael.roth@amd.com>, Laurent Vivier <laurent@vivier.eu>,
 Ani Sinha <anisinha@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Steven Lee <steven_lee@aspeedtech.com>,
 Brian Cain <brian.cain@oss.qualcomm.com>, Li-Wen Hsu <lwhsu@freebsd.org>,
 Jamin Lin <jamin_lin@aspeedtech.com>, qemu-block@nongnu.org,
 Bernhard Beschow <shentey@gmail.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 Maksim Davydov <davydov-max@yandex-team.ru>,
 Niek Linnenbank <nieklinnenbank@gmail.com>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Jagannathan Raman <jag.raman@oracle.com>,
 Igor Mitsyanko <i.mitsyanko@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
 Markus Armbruster <armbru@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Anton Johansson <anjo@rev.ng>,
 Peter Maydell <peter.maydell@linaro.org>, Eric Auger
 <eric.auger@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 qemu-arm@nongnu.org, Hao Wu <wuhaotsh@google.com>,
 Mads Ynddal <mads@ynddal.dk>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, qemu-riscv@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Rolnik <mrolnik@gmail.com>,
 Zhao Liu <zhao1.liu@intel.com>, Alessandro Di Federico <ale@rev.ng>,
 Antony Pavlov <antonynpavlov@gmail.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Hanna Reitz <hreitz@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Qiuhao Li <Qiuhao.Li@outlook.com>, Hyman Huang <yong.huang@smartx.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Bandan Das <bsd@redhat.com>,
 Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org, Fam Zheng <fam@euphon.net>, Jia Liu <proljc@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Alistair Francis <alistair@alistair23.me>,
 Subbaraya Sundeep <sundeep.lkml@gmail.com>, Kyle Evans <kevans@freebsd.org>,
 Song Gao <gaosong@loongson.cn>, Alexandre Iooss <erdnaxe@crans.org>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Peter Xu <peterx@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, BALATON Zoltan <balaton@eik.bme.hu>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?UTF-8?B?RnLDqWTDqXJpYyBCYXJyYXQ=?= <fbarrat@linux.ibm.com>,
 qemu-ppc@nongnu.org, Radoslaw Biernacki <rad@semihalf.com>,
 Beniamino Galvani <b.galvani@gmail.com>, David Hildenbrand
 <david@redhat.com>, Richard Henderson <richard.henderson@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>, Eduardo Habkost
 <eduardo@habkost.net>, Ahmed Karaman <ahmedkhaledkaraman@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>, Mahmoud Mandour
 <ma.mandourr@gmail.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>
References: <20250612205451.1177751-1-jsnow@redhat.com>
 <20250612205451.1177751-3-jsnow@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250612205451.1177751-3-jsnow@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2025 22.54, John Snow wrote:
> The next patch will synchronize the qemu.qmp library with the external,
> standalone version. That synchronization will require an extra ignore
> for pylint, so do that now.
> 
> Signed-off-by: John Snow <jsnow@redhat.com>
> ---
>   python/setup.cfg | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


