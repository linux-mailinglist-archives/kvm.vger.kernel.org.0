Return-Path: <kvm+bounces-5888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C8A8287F9
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 342C2B2252B
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476B239AC8;
	Tue,  9 Jan 2024 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BIm3sN/V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D2B39AC1
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-50e72e3d435so2889388e87.2
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 06:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704810253; x=1705415053; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/fxIqo+g5WwjavjYufA4hFi1cRbz34uO2PZEzQMCek=;
        b=BIm3sN/VyN0kNdN6lntdUfhSh3BFOh7uxuB/k+9cswKmmcKSex0VYy5/q/fjmMe84n
         RE+IQ/EJjgUbHahj+jg4mvinka8QTJnT4akg84KySe15/Tv08Se7UH0ABgu9anK3Jhe/
         VSPlIXqEV7407UDnXrzIy8EFJq6T5K6xiNWs2id81Ns+9gPAfvnBFrlqq0UA+DQOmQiB
         9CRNu58igeWjQ7XHqLMmn7KDM/UUSTRrCF74nFjSbtZfvuumGUnFGTdKnPCld2B5fZYd
         wqe8CLb8nNQv5aD9zXudLMXTpCGo0xKl+cyyF9PBNG254yNA5WR0iGYD2gn3/dM5Xao9
         noXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704810253; x=1705415053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/fxIqo+g5WwjavjYufA4hFi1cRbz34uO2PZEzQMCek=;
        b=w/ZR068+LjZrvmxnsAIY7dy/mcU+goj+9Bk9DHqCR/gZS5M+HWY/8w3UHv4cZo7e2I
         3bt6eQR7ipzb+hih9vHbtZaK94pUChsyv67fK142xKSIA2XYg68E7DfWlUM3fHB9hRwY
         6g+vxY924g3RW+Db17+hYPLbzHEsxnTLDWFOlmspjTdqrjxGcQD/HOqNSVB3mwe3FN3D
         5dQPX1KwHYEIUTSuGqMJ2fgogjkTlyn+9M0CttAnc7lqLJloFRcg9XTxvQHXLDonGnDh
         BXT3e0e2wmr4fLgY6MaGBS2yJddtV5yk6/QCAWUOoeNqmw02D1BQfe0tf4RyM2pb7v4J
         K46A==
X-Gm-Message-State: AOJu0YxMqTs+f+UcpI6ht8ANSTrKUnYUS+MqYvC7IzQnEo39a4PTGgRt
	JFuMlJZp+KCn8+F8ArjEk+qUaOcay4WJ0YJDUWgcNlNblGHJTA==
X-Google-Smtp-Source: AGHT+IFrVXvHsq1m1peP2eO+e72Pz8YdISUp+RIUUAo1aE+Zj9tZO0OThcNuGgpWww0VuL5fmq96NN7TJ2JIvwtuWz4=
X-Received: by 2002:a05:6512:2001:b0:50e:a923:4bb with SMTP id
 a1-20020a056512200100b0050ea92304bbmr1442148lfb.133.1704810252732; Tue, 09
 Jan 2024 06:24:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240108163735.254732-1-stefanha@redhat.com>
In-Reply-To: <20240108163735.254732-1-stefanha@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 9 Jan 2024 14:24:01 +0000
Message-ID: <CAFEAcA_RYdGZRxOAD43phmj0WmHTbU01tiNTmC8CxHF2cpb6DQ@mail.gmail.com>
Subject: Re: [PULL 0/6] Block patches
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, qemu-s390x@nongnu.org, 
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>, qemu-block@nongnu.org, 
	Alistair Francis <alistair.francis@wdc.com>, Max Filippov <jcmvbkbc@gmail.com>, kvm@vger.kernel.org, 
	Daniel Henrique Barboza <danielhb413@gmail.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-arm@nongnu.org, 
	Jean-Christophe Dubois <jcd@tribudubois.net>, Jiri Slaby <jslaby@suse.cz>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Eric Blake <eblake@redhat.com>, Paul Durrant <paul@xen.org>, BALATON Zoltan <balaton@eik.bme.hu>, 
	Kevin Wolf <kwolf@redhat.com>, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Roman Bolshakov <rbolshakov@ddn.com>, Reinoud Zandijk <reinoud@netbsd.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, 
	xen-devel@lists.xenproject.org, Anthony Perard <anthony.perard@citrix.com>, 
	Weiwei Li <liwei1518@gmail.com>, qemu-ppc@nongnu.org, 
	Sunil Muthuswamy <sunilmut@microsoft.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Song Gao <gaosong@loongson.cn>, Aurelien Jarno <aurelien@aurel32.net>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, 
	Andrey Smirnov <andrew.smirnov@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexander Graf <agraf@csgraf.de>, 
	Markus Armbruster <armbru@redhat.com>, John Snow <jsnow@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Stefan Weil <sw@weilnetz.de>, 
	Harsh Prateek Bora <harshpb@linux.ibm.com>, Hailiang Zhang <zhanghailiang@xfusion.com>, 
	Hyman Huang <yong.huang@smartx.com>, Michael Roth <michael.roth@amd.com>, Fam Zheng <fam@euphon.net>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, David Gibson <david@gibson.dropbear.id.au>, 
	Artyom Tarasenko <atar4qemu@gmail.com>, Stafford Horne <shorne@gmail.com>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, David Woodhouse <dwmw2@infradead.org>, 
	Cameron Esfahani <dirty@apple.com>, Eric Farman <farman@linux.ibm.com>, Jason Wang <jasowang@redhat.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Ilya Leoshkevich <iii@linux.ibm.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Hanna Reitz <hreitz@redhat.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Jagannathan Raman <jag.raman@oracle.com>, 
	Elena Ufimtseva <elena.ufimtseva@oracle.com>, Bin Meng <bin.meng@windriver.com>, 
	Fabiano Rosas <farosas@suse.de>, Akihiko Odaki <akihiko.odaki@daynix.com>, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Jan 2024 at 16:37, Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> The following changes since commit ffd454c67e38cc6df792733ebc5d967eee28ac=
0d:
>
>   Merge tag 'pull-vfio-20240107' of https://github.com/legoater/qemu into=
 staging (2024-01-08 10:28:42 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/stefanha/qemu.git tags/block-pull-request
>
> for you to fetch changes up to 0b2675c473f68f13bc5ca1dd1c43ce421542e7b8:
>
>   Rename "QEMU global mutex" to "BQL" in comments and docs (2024-01-08 10=
:45:43 -0500)
>
> ----------------------------------------------------------------
> Pull request
>
> ----------------------------------------------------------------
>
> Philippe Mathieu-Daud=C3=A9 (1):
>   iothread: Remove unused Error** argument in aio_context_set_aio_params
>
> Stefan Hajnoczi (5):
>   system/cpus: rename qemu_mutex_lock_iothread() to bql_lock()
>   qemu/main-loop: rename QEMU_IOTHREAD_LOCK_GUARD to BQL_LOCK_GUARD
>   qemu/main-loop: rename qemu_cond_wait_iothread() to
>     qemu_cond_wait_bql()
>   Replace "iothread lock" with "BQL" in comments
>   Rename "QEMU global mutex" to "BQL" in comments and docs


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/9.0
for any user-visible changes.

-- PMM

