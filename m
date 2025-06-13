Return-Path: <kvm+bounces-49400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D916AD85BF
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 10:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD59B3B2B7E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65452727E8;
	Fri, 13 Jun 2025 08:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Af2vhC48"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201FA25B667
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 08:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749803792; cv=none; b=uGQCnHp/rmdGzCl+theFRpzRHVJvJEo1OTjshjxVjwzizRSKIQ2HqS44m9wARJN2uL3uWAb81HvuOxDXmjX6hQ7d1w77kuhDiuuLrnfP8yxxxnHixoD/4/e7wKwlbmWSvamsTgX6WhopjnUnab8Iu/qtmqfhGWqRQETYq7Ow7+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749803792; c=relaxed/simple;
	bh=FPw3brIpvUi2JK7P8dn/FyG4IDuKlXylOZkezsYRdkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mJtdDMTJKeRPV9HIKrvWryJuzxKJD878h41pl4r70MyGqlQyww7mPy8hZxB8lHzoTrLXWJgF6+Gyf2NEBbuBtcxdpHz3yAkaEpFw0pJSoluXAJFVo5UeNRkWStfg+5d3XDiSRRobuhKJ4psNKSJbm3NYIjE46MNsIQJVMN/tamk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Af2vhC48; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749803790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/I6+d9Yd3eLTkCHtR7fFtt05vaPNjoHu7+WkpC52NnU=;
	b=Af2vhC48IleSqrYRVmmsGzq1BB/cYMHLsuv0sqHTIEBo7kYxbFrrxK1a5sIvEBN9YC1DKi
	cUke+MTVktAi482B71B0OokhN4nN/rNquJav+O9rPTxgUoLKRGZqZFm3HuvItNgbgIUFUh
	CXtFpCRyGmofSW8FOVrjjpAAwNrNekY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-382FgyxJNy6gjTi8WTBRew-1; Fri, 13 Jun 2025 04:36:28 -0400
X-MC-Unique: 382FgyxJNy6gjTi8WTBRew-1
X-Mimecast-MFC-AGG-ID: 382FgyxJNy6gjTi8WTBRew_1749803787
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4f65a705dso943103f8f.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 01:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749803787; x=1750408587;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/I6+d9Yd3eLTkCHtR7fFtt05vaPNjoHu7+WkpC52NnU=;
        b=CyF035u7tq/I5hcXdBw+N3MoXF68xj4EysTudJs83/y1bieVz12AVJRRAqcwlgDcMW
         kQ+BUt9G34/QXDXblmhCMXZXonDjjJzNIsfeFOFEYC/qXVrAtyBjFPK5gM9XZj7oyCVn
         u/LrwQuZzyPuht4c7W+E63fOHfBa28MK2b5mSnLvzFxhuOFk7tdV/mHiL0OIRE9mLgu9
         Nv2/BycyWRhtOTvTiFLzxd7NrqoWrkw3gaGhpCKmjpFiObp2FsDphS+qL7eH8XHvLYHR
         mOR5bMoybATDHN63UdrvhdqAJSyLntciOCxDQLrM6JwTl721DU8N5DHYXszuBPRt59rh
         OGPA==
X-Forwarded-Encrypted: i=1; AJvYcCVeX30tgYdh61q/TFu9KifXs6d4KzYbzpzllxdz4Gu64NjHxv9w50Ku7XxqgvbVdTTyM8M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1F9wf2MIrUei26089B9J66x659oEOXfqQgjVUEEdZbykCW4aB
	G2I74DaYX9dtgdnanYFW64QTTBdIZg41DS/oKUrVUM55iczbMWmnACEqqc4p1c+ClgakCvOc50V
	4seHmInOpYUgdTyKXBCHkCNNANxkM8zcZQLdGbT+iz9AQ5S8VzrjqVA==
X-Gm-Gg: ASbGncshWA/aviDKA4s3WdHJBest5rZcia4+CKlj22SylxfxAtTZmacfWDZ7OroXkKs
	lY/Jb+jz2w5nhCp29HW+AKiXlN6rmBHe5tsjAxTL/67dha3TwdK6+qEAgUjQfGiyA3TkED/HyVC
	ehfD3uQCC0Jnl9MpYtW7Fxca6CQs9g49ITH13sS3BNL61p+dz853nkQ0iB9vKeQiaDismOq5jib
	Z58kE01rQyomPCP6fBvTh1V4A8sHM5QhcA0xsuYjSrmHXazgn6FApDDUVlnfaLnPq6r/nLe3/qC
	QBUX7p09eIbiwoKvlTXTfRZs1pMSZ9d2ypTIOssBDmNABfh0nl7KvxlI4eC1UQ==
X-Received: by 2002:a05:6000:1a88:b0:3a4:ec32:e4f3 with SMTP id ffacd0b85a97d-3a5686bca97mr2034772f8f.17.1749803787028;
        Fri, 13 Jun 2025 01:36:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7B45WXjbfZeSZHgqn1bgfNkrp3GCDXtD8bbtUbwmAb1jIo70JpQtuBxS5Aq1Xw+zIc42s3g==
X-Received: by 2002:a05:6000:1a88:b0:3a4:ec32:e4f3 with SMTP id ffacd0b85a97d-3a5686bca97mr2034642f8f.17.1749803786353;
        Fri, 13 Jun 2025 01:36:26 -0700 (PDT)
Received: from [192.168.0.4] (ltea-047-064-114-027.pools.arcor-ip.net. [47.64.114.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a72cd3sm1675721f8f.32.2025.06.13.01.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 01:36:25 -0700 (PDT)
Message-ID: <7e66e758-da47-47eb-9114-22f07e1ffdc9@redhat.com>
Date: Fri, 13 Jun 2025 10:36:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] python: convert packages to
 PEP517/pyproject.toml
To: John Snow <jsnow@redhat.com>, qemu-devel@nongnu.org
Cc: Joel Stanley <joel@jms.id.au>, Yi Liu <yi.l.liu@intel.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Helge Deller <deller@gmx.de>, Andrew Jeffery <andrew@codeconstruct.com.au>,
 Fabiano Rosas <farosas@suse.de>, Alexander Bulekov <alxndr@bu.edu>,
 Darren Kenny <darren.kenny@oracle.com>,
 Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Ed Maste <emaste@freebsd.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Warner Losh <imp@bsdimp.com>, Tyrone Ting <kfting@nuvoton.com>,
 Eric Blake <eblake@redhat.com>, Troy Lee <leetroy@gmail.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Michael Roth <michael.roth@amd.com>, Laurent Vivier <laurent@vivier.eu>,
 Ani Sinha <anisinha@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Steven Lee <steven_lee@aspeedtech.com>,
 Brian Cain <brian.cain@oss.qualcomm.com>, Li-Wen Hsu <lwhsu@freebsd.org>,
 Jamin Lin <jamin_lin@aspeedtech.com>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 qemu-block@nongnu.org, Bernhard Beschow <shentey@gmail.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 Maksim Davydov <davydov-max@yandex-team.ru>,
 Niek Linnenbank <nieklinnenbank@gmail.com>,
 =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Paul Durrant <paul@xen.org>,
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
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Qiuhao Li <Qiuhao.Li@outlook.com>, Hyman Huang <yong.huang@smartx.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-rust@nongnu.org, Bandan Das <bsd@redhat.com>,
 Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org, Fam Zheng <fam@euphon.net>, Jia Liu <proljc@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Alistair Francis <alistair@alistair23.me>, Kyle Evans <kevans@freebsd.org>,
 Alexandre Iooss <erdnaxe@crans.org>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Peter Xu <peterx@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?UTF-8?B?RnLDqWTDqXJpYyBCYXJyYXQ=?= <fbarrat@linux.ibm.com>,
 qemu-ppc@nongnu.org, Radoslaw Biernacki <rad@semihalf.com>,
 Beniamino Galvani <b.galvani@gmail.com>, David Hildenbrand
 <david@redhat.com>, Richard Henderson <richard.henderson@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>, Eduardo Habkost
 <eduardo@habkost.net>, Ahmed Karaman <ahmedkhaledkaraman@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>
References: <20250612205451.1177751-1-jsnow@redhat.com>
 <20250612205451.1177751-2-jsnow@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250612205451.1177751-2-jsnow@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2025 22.54, John Snow wrote:
> Newer versions of setuptools increasingly expect that packages are
> defined using the pyproject.toml/PEP517 packaging layout format. With
> 3.9 as our minimum, I believe it's finally appropriate to make the shift
> away from the legacy packaging format.
> 
> Update documentation and dependencies that change as a result of the
> different build/packaging/installation pathways.
> 
> This change has the effect of fixing "make check-dev", which has been
> broken on newer versions of Fedora for a while, now.
> 
> Signed-off-by: John Snow <jsnow@redhat.com>
> ---
>   python/README.rst        | 33 ++++++++++++++++-----------------
>   python/Makefile          | 18 +++++++++---------
>   python/pyproject.toml    | 10 ++++++++++
>   python/setup.py          | 40 ----------------------------------------
>   python/tests/minreqs.txt |  2 +-
>   5 files changed, 36 insertions(+), 67 deletions(-)
>   create mode 100644 python/pyproject.toml
>   delete mode 100755 python/setup.py

Reviewed-by: Thomas Huth <thuth@redhat.com>


