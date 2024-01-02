Return-Path: <kvm+bounces-5464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 440A682234C
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF1B528436E
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 21:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 374C2168B6;
	Tue,  2 Jan 2024 21:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ggWWJVG5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA306168A6
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 21:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40d8909a6feso18002715e9.2
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 13:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704231435; x=1704836235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/j7/rdcZmoVQjecAI6/HxXOPJUcRBJCUvX9qQzCAcW8=;
        b=ggWWJVG5FVbXeek9IpyzIHq4RNKlZa5M1hue33a74swFmWAIrwR3e6W8KjDuCmSKP9
         9bz8jspKLt+y6v9sRRrrF+slqx71SXpcGq3rA0c0lPwnhViYvD7EMH9cfEf/3QprTBCo
         bp9IynDl2Y5HwcqQlconpsBQADow3mzqu2QMNojzMGjWXt/qI+ILhFNdmHA6Nu5A6csx
         8kfdnCOXPdaVcfn4UcZfo1qxH0mT3IMGogr+krqyZE5UxHk4Nz++xoMmxr7aZ/kyNo3i
         G/icHpGSfvWwBd4qx9B09qPbkP67RwrK/plnuD5tC3wxwZt0PMhge800jzmQt9jLdYFP
         Rc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704231435; x=1704836235;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/j7/rdcZmoVQjecAI6/HxXOPJUcRBJCUvX9qQzCAcW8=;
        b=S+JMnjhBJYaNU9aHu2e5D3iNXG0/N2XbKgitBIoHHDarKPmaVvrIFQKnAjyQOC+8Cq
         O/AcYZuKbZpXLJz3KYWoaBnLuerVydhbCeJ7jh8p4rVV1bpe798VH+E8Ct3mMwa2w/Ah
         coay3cysa7P/uvAmJoq0/Hfcv0vjkl7tlny9i/PNyWWZzcuWQX+l86uQD2E5S4pFM/Ur
         dsR9NfYJIShXrQpcUzKH84jbajEXSZTRw/hlsmurVipFM3adBV1QI1Vw/85n7sTvHE5R
         P3OERHejXcpe4zVBJ+udIKEIq/utSHfYmjuUU0TBxlKOXwq4/bq68aUSPwNET2Y1rGQ5
         uFoA==
X-Gm-Message-State: AOJu0Yx5bNt4Yp1rAnjjEBX1pEngKSup3kICSq+hCQP4jeSdD8avq18o
	f1Q1zu8vKubX0nr0N25Z8XU=
X-Google-Smtp-Source: AGHT+IFrz+8G4XaufDC1u0mAfvhOGqc3F19J3DroZasFggdJGsufr8PGV5ZiaTqLN5DOoVoj9N8dAg==
X-Received: by 2002:a7b:ce13:0:b0:40d:6f34:5c13 with SMTP id m19-20020a7bce13000000b0040d6f345c13mr2971570wmc.231.1704231434891;
        Tue, 02 Jan 2024 13:37:14 -0800 (PST)
Received: from [127.0.0.1] (dynamic-089-014-091-072.89.14.pool.telefonica.de. [89.14.91.72])
        by smtp.gmail.com with ESMTPSA id p34-20020a05600c1da200b0040d8b4ebd55sm252596wms.0.2024.01.02.13.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jan 2024 13:37:14 -0800 (PST)
Date: Tue, 02 Jan 2024 21:37:00 +0000
From: Bernhard Beschow <shentey@gmail.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
CC: =?ISO-8859-1?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Artyom Tarasenko <atar4qemu@gmail.com>, Paul Durrant <paul@xen.org>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 =?ISO-8859-1?Q?C=E9dric_Le_Goater?= <clg@kaod.org>,
 Paolo Bonzini <pbonzini@redhat.com>, BALATON Zoltan <balaton@eik.bme.hu>,
 Jagannathan Raman <jag.raman@oracle.com>,
 Anthony Perard <anthony.perard@citrix.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
 Alexander Graf <agraf@csgraf.de>, Hailiang Zhang <zhanghailiang@xfusion.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Hyman Huang <yong.huang@smartx.com>, Fam Zheng <fam@euphon.net>,
 Song Gao <gaosong@loongson.cn>, Alistair Francis <alistair.francis@wdc.com>,
 =?ISO-8859-1?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 David Woodhouse <dwmw2@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Leonardo Bras <leobras@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
 Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Hildenbrand <david@redhat.com>, Michael Roth <michael.roth@amd.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Cameron Esfahani <dirty@apple.com>,
 qemu-ppc@nongnu.org, John Snow <jsnow@redhat.com>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 Weiwei Li <liwei1518@gmail.com>, Hanna Reitz <hreitz@redhat.com>,
 qemu-s390x@nongnu.org, qemu-block@nongnu.org,
 =?ISO-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 Andrey Smirnov <andrew.smirnov@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Kevin Wolf <kwolf@redhat.com>,
 Bin Meng <bin.meng@windriver.com>, Sunil Muthuswamy <sunilmut@microsoft.com>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-riscv@nongnu.org,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Stafford Horne <shorne@gmail.com>,
 Fabiano Rosas <farosas@suse.de>, Juan Quintela <quintela@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, qemu-arm@nongnu.org,
 Jason Wang <jasowang@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Max Filippov <jcmvbkbc@gmail.com>,
 Jean-Christophe Dubois <jcd@tribudubois.net>, Eric Blake <eblake@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, Halil Pasic <pasic@linux.ibm.com>,
 xen-devel@lists.xenproject.org,
 =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
 David Woodhouse <dwmw@amazon.co.uk>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_1/5=5D_system/cpus=3A_rename_?= =?US-ASCII?Q?qemu=5Fmutex=5Flock=5Fiothread=28=29_to_bql=5Flock=28=29?=
In-Reply-To: <20231212153905.631119-2-stefanha@redhat.com>
References: <20231212153905.631119-1-stefanha@redhat.com> <20231212153905.631119-2-stefanha@redhat.com>
Message-ID: <CFD7EE4A-D216-4CE8-B963-0CCEEA623E53@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 12=2E Dezember 2023 15:39:00 UTC schrieb Stefan Hajnoczi <stefanha@redh=
at=2Ecom>:
>The Big QEMU Lock (BQL) has many names and they are confusing=2E The
>actual QemuMutex variable is called qemu_global_mutex but it's commonly
>referred to as the BQL in discussions and some code comments=2E The
>locking APIs, however, are called qemu_mutex_lock_iothread() and
>qemu_mutex_unlock_iothread()=2E
>
>The "iothread" name is historic and comes from when the main thread was
>split into into KVM vcpu threads and the "iothread" (now called the main

Duplicate "into" here=2E

>loop thread)=2E I have contributed to the confusion myself by introducing
>a separate --object iothread, a separate concept unrelated to the BQL=2E
>
>The "iothread" name is no longer appropriate for the BQL=2E Rename the
>locking APIs to:
>- void bql_lock(void)
>- void bql_unlock(void)
>- bool bql_locked(void)
>
>There are more APIs with "iothread" in their names=2E Subsequent patches
>will rename them=2E There are also comments and documentation that will b=
e
>updated in later patches=2E
>
>Signed-off-by: Stefan Hajnoczi <stefanha@redhat=2Ecom>
>Reviewed-by: Paul Durrant <paul@xen=2Eorg>
>Acked-by: Fabiano Rosas <farosas@suse=2Ede>
>Acked-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>Reviewed-by: C=C3=A9dric Le Goater <clg@kaod=2Eorg>
>Acked-by: Peter Xu <peterx@redhat=2Ecom>
>Acked-by: Eric Farman <farman@linux=2Eibm=2Ecom>
>Reviewed-by: Harsh Prateek Bora <harshpb@linux=2Eibm=2Ecom>

