Return-Path: <kvm+bounces-3019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B6C7FFBFE
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 21:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05B41281A32
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F9053E1D;
	Thu, 30 Nov 2023 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TUgxmHM9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F96710EF
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701374937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQ5m3o7+UqdtWYSDU6QubOO0VIH9lcTK3EaDyGHvbxw=;
	b=TUgxmHM9JwEJ2vungQdnKYHPrNSGZqPYc5G12Qf5g9KY/XcvcFZDxf2kyZMTYnTxddX9P5
	0IsZ+/UFhuEVfaJ77yEAueTCv0zgJ8lHuI30DRBddkCPqkOQjkh7eNAWC4q0RC9qRd/yAX
	+ofgjUeMscWwgOxvhnVg2HbG52LCOCk=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-42pjk2rFPFGwcNpB_lgGHA-1; Thu, 30 Nov 2023 15:08:55 -0500
X-MC-Unique: 42pjk2rFPFGwcNpB_lgGHA-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-58dba38a819so212705eaf.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:08:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701374935; x=1701979735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQ5m3o7+UqdtWYSDU6QubOO0VIH9lcTK3EaDyGHvbxw=;
        b=G27B16TcKYopWYZfbaOrpSgcnp7/6CLqYtPr3+Nb42KbRsF4/+3i0LNDsuVSD3qYRu
         e+Bt8oMzZjhX35BkFIPiaqoZ6RqWrKm5CP7eiYC9HoWyNBT3KSsX79d+4Fyq15x4e7ju
         Kfqp46PbIf7rZ9Y6+IeX14yWvQArkKyHrIHHBVZc8PvA1UVUoLxztPh8Hyrk/2Q2fgMf
         ioL92cGYN0L2opR1WbNpQ0H7uDiYdRDiXSAzyvqMLW5slVQ1rTrw4IdqoqgoVxcZss9M
         Oql+hI/t0ugT4AALRQosIx4UvJD7v7tDwoyeZYoFsKe24LEOuvDHsM4Tq1RBYrpt5QTe
         89gA==
X-Gm-Message-State: AOJu0YyFtCO8xyJTwhkLez4MkB5I/MF19om7RZrG/6X+/Fq456fYZVBo
	DAzhvJ+OwHGyfKfQTEJNacl3PGkTr+/bJeFW9TzHxzVwKrHyoZTDTZxypOPYqvhtjq1PoX9iDL/
	oR7UfQjrgf7+U
X-Received: by 2002:a05:6820:a8f:b0:58d:e3d3:ec72 with SMTP id de15-20020a0568200a8f00b0058de3d3ec72mr3219627oob.0.1701374934928;
        Thu, 30 Nov 2023 12:08:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFrVwMaTOwUyaQhegCiYW255oqkz3A1nA2DFXZquNCGnC+wsIvv9V9+I7etJ6uoaw71Bi5Lw==
X-Received: by 2002:a05:6820:a8f:b0:58d:e3d3:ec72 with SMTP id de15-20020a0568200a8f00b0058de3d3ec72mr3219606oob.0.1701374934634;
        Thu, 30 Nov 2023 12:08:54 -0800 (PST)
Received: from x1n (cpe688f2e2cb7c3-cm688f2e2cb7c0.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id qr13-20020a05620a390d00b0077d5e1e4edesm790071qkn.57.2023.11.30.12.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 12:08:54 -0800 (PST)
Date: Thu, 30 Nov 2023 15:08:49 -0500
From: Peter Xu <peterx@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, Jean-Christophe Dubois <jcd@tribudubois.net>,
	Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>, Hyman Huang <yong.huang@smartx.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Paul Durrant <paul@xen.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Juan Quintela <quintela@redhat.com>,
	Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
	qemu-arm@nongnu.org, Jason Wang <jasowang@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Hailiang Zhang <zhanghailiang@xfusion.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Huacai Chen <chenhuacai@kernel.org>, Fam Zheng <fam@euphon.net>,
	Eric Blake <eblake@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
	Alexander Graf <agraf@csgraf.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Weiwei Li <liwei1518@gmail.com>, Eric Farman <farman@linux.ibm.com>,
	Stafford Horne <shorne@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Cameron Esfahani <dirty@apple.com>, xen-devel@lists.xenproject.org,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, qemu-riscv@nongnu.org,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	John Snow <jsnow@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Michael Roth <michael.roth@amd.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Bin Meng <bin.meng@windriver.com>,
	Stefano Stabellini <sstabellini@kernel.org>, kvm@vger.kernel.org,
	qemu-block@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
	Anthony Perard <anthony.perard@citrix.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
	qemu-ppc@nongnu.org,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Leonardo Bras <leobras@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 1/6] system/cpus: rename qemu_mutex_lock_iothread() to
 qemu_bql_lock()
Message-ID: <ZWjr0TKxihlpd1jm@x1n>
References: <20231129212625.1051502-1-stefanha@redhat.com>
 <20231129212625.1051502-2-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231129212625.1051502-2-stefanha@redhat.com>

On Wed, Nov 29, 2023 at 04:26:20PM -0500, Stefan Hajnoczi wrote:
> The Big QEMU Lock (BQL) has many names and they are confusing. The
> actual QemuMutex variable is called qemu_global_mutex but it's commonly
> referred to as the BQL in discussions and some code comments. The
> locking APIs, however, are called qemu_mutex_lock_iothread() and
> qemu_mutex_unlock_iothread().
> 
> The "iothread" name is historic and comes from when the main thread was
> split into into KVM vcpu threads and the "iothread" (now called the main
> loop thread). I have contributed to the confusion myself by introducing
> a separate --object iothread, a separate concept unrelated to the BQL.
> 
> The "iothread" name is no longer appropriate for the BQL. Rename the
> locking APIs to:
> - void qemu_bql_lock(void)
> - void qemu_bql_unlock(void)
> - bool qemu_bql_locked(void)
> 
> There are more APIs with "iothread" in their names. Subsequent patches
> will rename them. There are also comments and documentation that will be
> updated in later patches.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Acked-by: Peter Xu <peterx@redhat.com>

Two nickpicks:

  - BQL contains "QEMU" as the 2nd character, so maybe easier to further
    rename qemu_bql into bql_?

  - Could we keep the full spell of BQL at some places, so people can still
    reference it if not familiar?  IIUC most of the BQL helpers will root
    back to the major three functions (_lock, _unlock, _locked), perhaps
    add a comment of "BQL stands for..." over these three functions as
    comment?

Please take or ignore these nitpicks; my ACK will stand irrelevant.

Thanks,

-- 
Peter Xu


