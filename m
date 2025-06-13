Return-Path: <kvm+bounces-49404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF23AAD89BB
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 12:42:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7767E189EBC4
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 10:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CF12D5C9E;
	Fri, 13 Jun 2025 10:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UXtFZTh3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67305225771
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 10:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749811299; cv=none; b=K8YrlFj1Zon1iderG2RvD/myb4gHrkqg9kkpd5qZrpV5JP+KREEFAiwm7ixsWKtuZmoGbr3nHXIskG6fapbY7lvm7OlqjgIDWl4glDZwqw/w0t58bp/zTk4H9hJcEQXo78ONm5ZjTcsbU/6UrwimLTijYl+6XLZKPsMJBYqakuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749811299; c=relaxed/simple;
	bh=jkr/qj5NC7v8iEBMMpBxOxxy9HCQHlfXcp87Z4sWXP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sJkf7enlFqaqzSm2mkzkjkpjaZf8vmas3WN332lbTCuAgLSwA8+HatV1sBTMzfrKKXyETH/nVB+GAjokmqZTT0UcZJryg/+e9GdamVIzwlycIx18nRsrAfAxYsGFlnGLiJQBgdJvstfBULsSYj0JvXfX9vIy0fSseUApMnHGUIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UXtFZTh3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749811295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=figJZmNZUAIV8ivTAUr2WUKY/O33ofJJymTbtraOGVc=;
	b=UXtFZTh3l+3u9W9BbmQTyJgcfu/CTEIxgAhfWsXqN2aYvgdPfyr3P2muYJpzHGzEsinCsX
	qUhEIbvAVlmdFjFSKTdg9jyTn+ASr1QKXcju+vdl/e1tit0G3190aBlP5L2nDgGsouHHPw
	5rxxbEi3TT4M01eOiyL6PiAid3XV/WE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-ZsBUp_pgP-Gc3XO6e5YOWQ-1; Fri, 13 Jun 2025 06:41:34 -0400
X-MC-Unique: ZsBUp_pgP-Gc3XO6e5YOWQ-1
X-Mimecast-MFC-AGG-ID: ZsBUp_pgP-Gc3XO6e5YOWQ_1749811293
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a523ce0bb2so1047519f8f.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 03:41:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749811293; x=1750416093;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=figJZmNZUAIV8ivTAUr2WUKY/O33ofJJymTbtraOGVc=;
        b=SAzbbRaTppouujYgOl/95j7wPEuOcQ/GIMQpoefh+pJQkmgAJOs4FElmTqAmSccj4o
         QbL7BCxARvH8kqEmKdNWxRtfLHSmqA1cpKsAEUvKOOR6JjfBtp6/YzSf4v6WCcTZaWge
         yQNmQbEQATcipkMWDgUlyr0YTbzWYZO+CLfclYKPbrR/LUq2YSzZxyiNyEB6UpH6eh8q
         5tj4HcrWlU1LMwa+ERtMpGMlkkvjTSq+JZgMgvckqhGEJE4Yawot+Jnem7XZq3VJJevm
         SfXiAl1XAq37Yd50uEXN7f7R8opQkuajGV0f5CDoqAO2o4mQWGSmD9JTTEBQJuaAAypy
         34gQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2FC50wkvSjv+HUXm264WYlvy0NklN65vJ77vU55ZzcLYGsUvY7nBlIwk6DovFQ+VxCDs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoL5JkVjUihEXTgGC9KHiDOfjElHpnBMDJ8sM/L2iRgMYJOBPF
	/vnVdKKyxzdp2Vc99ee4se/tokkNqg54MW94xXhCeX79+plfOAbzaC9vGqf7Dzpfqf+Fjseu94E
	iQjPavDp4a7YNYS9220YwzbOPrUoaH3fSeibJZI8DSKFZOvO5udaUjA==
X-Gm-Gg: ASbGncsioyatY1Ma++L+ivOsTuk66o/teupjqUIxvi4rInH1Kztc9e6266KY+brp8sP
	moFf0sRgFX+FSCAkPBX2j7W9ec7gTctdj9bIakC9RqLoiOWwdbkBAR/8I+9ouxTyOUoKFz1OrxL
	Z6OkeuJ+8gj4pYB2eIxte2X6cOlgMorekgYKdQaPHbLIYhmdNgQPksaN+s8hgtk4NFNA68ulHJY
	aAavHgbNW4b+IfOeghll6bRzgXZM+BRNa0/md7tX2+VwDuQVv0fb4XkcdQyLT6xCFOUlReBAunX
	eOHWyd7Ag/fZ/DVJNZyCOOb7rkSR7CZhdelEzaHOgdjJbB3mqlleay/uBSyJfg==
X-Received: by 2002:a05:6000:2312:b0:3a5:2599:4183 with SMTP id ffacd0b85a97d-3a568717a0bmr2102278f8f.25.1749811292813;
        Fri, 13 Jun 2025 03:41:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJlJNgrePZmATp2R205Kf4PA9FIhO0maj7nVLAo7B4qoXmvRW3bpUlsacbB7nyFhXz0AEztw==
X-Received: by 2002:a05:6000:2312:b0:3a5:2599:4183 with SMTP id ffacd0b85a97d-3a568717a0bmr2102200f8f.25.1749811292158;
        Fri, 13 Jun 2025 03:41:32 -0700 (PDT)
Received: from [192.168.0.4] (ltea-047-064-114-027.pools.arcor-ip.net. [47.64.114.27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e13c19esm48431355e9.25.2025.06.13.03.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 03:41:31 -0700 (PDT)
Message-ID: <932ebe19-e581-499b-9294-022f3fb4d76a@redhat.com>
Date: Fri, 13 Jun 2025 12:41:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] python: fix illegal escape sequences
To: John Snow <jsnow@redhat.com>, qemu-devel@nongnu.org
Cc: Joel Stanley <joel@jms.id.au>, Yi Liu <yi.l.liu@intel.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Helge Deller <deller@gmx.de>, Fabiano Rosas <farosas@suse.de>,
 Alexander Bulekov <alxndr@bu.edu>, Darren Kenny <darren.kenny@oracle.com>,
 Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Ed Maste <emaste@freebsd.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Warner Losh <imp@bsdimp.com>, Kevin Wolf <kwolf@redhat.com>,
 Tyrone Ting <kfting@nuvoton.com>, Eric Blake <eblake@redhat.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Troy Lee <leetroy@gmail.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Michael Roth <michael.roth@amd.com>, Laurent Vivier <laurent@vivier.eu>,
 Ani Sinha <anisinha@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Steven Lee <steven_lee@aspeedtech.com>,
 Brian Cain <brian.cain@oss.qualcomm.com>, Li-Wen Hsu <lwhsu@freebsd.org>,
 Jamin Lin <jamin_lin@aspeedtech.com>, qemu-s390x@nongnu.org,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 qemu-block@nongnu.org, Bernhard Beschow <shentey@gmail.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 Maksim Davydov <davydov-max@yandex-team.ru>,
 Niek Linnenbank <nieklinnenbank@gmail.com>,
 =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Paul Durrant <paul@xen.org>, Jagannathan Raman <jag.raman@oracle.com>,
 Igor Mitsyanko <i.mitsyanko@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
 Markus Armbruster <armbru@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Anton Johansson <anjo@rev.ng>,
 Peter Maydell <peter.maydell@linaro.org>, Cleber Rosa <crosa@redhat.com>,
 Eric Auger <eric.auger@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 qemu-arm@nongnu.org, Hao Wu <wuhaotsh@google.com>,
 Mads Ynddal <mads@ynddal.dk>, qemu-riscv@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Rolnik <mrolnik@gmail.com>,
 Zhao Liu <zhao1.liu@intel.com>, Alessandro Di Federico <ale@rev.ng>,
 Antony Pavlov <antonynpavlov@gmail.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Hanna Reitz <hreitz@redhat.com>,
 Qiuhao Li <Qiuhao.Li@outlook.com>, Hyman Huang <yong.huang@smartx.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Magnus Damm <magnus.damm@gmail.com>, qemu-rust@nongnu.org,
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
 <20250612205451.1177751-6-jsnow@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250612205451.1177751-6-jsnow@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2025 22.54, John Snow wrote:
> \{ is an illegal escape sequence, to get a literal backslash we need to
> use \\.
> 
> This is being fixed because of an issue spotted when attempting to use
> the pyupgrade script.
> 
> Signed-off-by: John Snow <jsnow@redhat.com>
> ---
>   scripts/feature_to_c.py | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/feature_to_c.py b/scripts/feature_to_c.py
> index 807af0e685c..5f8fa8ad5c6 100644
> --- a/scripts/feature_to_c.py
> +++ b/scripts/feature_to_c.py
> @@ -25,7 +25,7 @@ def writeliteral(indent, bytes):
>           elif c >= 32 and c < 127:
>               sys.stdout.write(c.to_bytes(1, 'big').decode())
>           else:
> -            sys.stdout.write(f'\{c:03o}')
> +            sys.stdout.write(f'\\{c:03o}')
>   
>       if quoted:
>           sys.stdout.write('"')

Reviewed-by: Thomas Huth <thuth@redhat.com>


