Return-Path: <kvm+bounces-2848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B247FE995
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:18:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C099281A88
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 07:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E441E537;
	Thu, 30 Nov 2023 07:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S/is66bp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F0D12C
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 23:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701328680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2p1/yCCqE7V/A9ix7GiHFBqyRKKVluWD2OXS34K6s/4=;
	b=S/is66bpE1pta0Bn6tbZNJpVxIMY9VIiGV2gI7Eyon9S/ydbnxx9ofvyV5wXsDCV1secLj
	ziYv1YLlJ4+UbdfhtyfevAZfj/jvh+6gkt8fNyEeVMjVvgbdQAySJbdespCprpvcWEFZ8C
	LkhDgSss4uXQk+VlsQP2DYJo4E77uAA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-GFOh08EMNVCDGI0zFC0TQQ-1; Thu,
 30 Nov 2023 02:17:56 -0500
X-MC-Unique: GFOh08EMNVCDGI0zFC0TQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31246285F981;
	Thu, 30 Nov 2023 07:17:56 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.148])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8473D2166B26;
	Thu, 30 Nov 2023 07:17:55 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 90DFA21E6A1F; Thu, 30 Nov 2023 08:17:54 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org,  Jean-Christophe Dubois <jcd@tribudubois.net>,
  Fabiano Rosas <farosas@suse.de>,  qemu-s390x@nongnu.org,  Song Gao
 <gaosong@loongson.cn>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Thomas Huth <thuth@redhat.com>,  Hyman Huang <yong.huang@smartx.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  David Woodhouse
 <dwmw2@infradead.org>,  Andrey Smirnov <andrew.smirnov@gmail.com>,  Peter
 Maydell <peter.maydell@linaro.org>,  Kevin Wolf <kwolf@redhat.com>,  Ilya
 Leoshkevich <iii@linux.ibm.com>,  Artyom Tarasenko <atar4qemu@gmail.com>,
  Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,  Max Filippov
 <jcmvbkbc@gmail.com>,  Alistair Francis <alistair.francis@wdc.com>,  Paul
 Durrant <paul@xen.org>,  Jagannathan Raman <jag.raman@oracle.com>,  Juan
 Quintela <quintela@redhat.com>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,
  qemu-arm@nongnu.org,  Jason Wang <jasowang@redhat.com>,  Gerd Hoffmann
 <kraxel@redhat.com>,  Hanna Reitz <hreitz@redhat.com>,  =?utf-8?Q?Marc-An?=
 =?utf-8?Q?dr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,  BALATON Zoltan <balaton@eik.bme.hu>,
  Daniel Henrique Barboza <danielhb413@gmail.com>,  Elena Ufimtseva
 <elena.ufimtseva@oracle.com>,  Aurelien Jarno <aurelien@aurel32.net>,
  Hailiang Zhang <zhanghailiang@xfusion.com>,  Roman Bolshakov
 <rbolshakov@ddn.com>,  Huacai Chen <chenhuacai@kernel.org>,  Fam Zheng
 <fam@euphon.net>,  Eric Blake <eblake@redhat.com>,  Jiri Slaby
 <jslaby@suse.cz>,  Alexander Graf <agraf@csgraf.de>,  Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>,  Weiwei Li <liwei1518@gmail.com>,  Eric
 Farman <farman@linux.ibm.com>,  Stafford Horne <shorne@gmail.com>,  David
 Hildenbrand <david@redhat.com>,  Markus Armbruster <armbru@redhat.com>,
  Reinoud Zandijk <reinoud@netbsd.org>,  Palmer Dabbelt
 <palmer@dabbelt.com>,  Cameron Esfahani <dirty@apple.com>,
  xen-devel@lists.xenproject.org,  Pavel Dovgalyuk
 <pavel.dovgaluk@ispras.ru>,  qemu-riscv@nongnu.org,  Aleksandar Rikalo
 <aleksandar.rikalo@syrmia.com>,  John Snow <jsnow@redhat.com>,  Sunil
 Muthuswamy <sunilmut@microsoft.com>,  Michael Roth <michael.roth@amd.com>,
  David Gibson <david@gibson.dropbear.id.au>,  "Michael S. Tsirkin"
 <mst@redhat.com>,  Richard Henderson <richard.henderson@linaro.org>,  Bin
 Meng <bin.meng@windriver.com>,  Stefano Stabellini
 <sstabellini@kernel.org>,  kvm@vger.kernel.org,  qemu-block@nongnu.org,
  Halil Pasic <pasic@linux.ibm.com>,  Peter Xu <peterx@redhat.com>,
  Anthony Perard <anthony.perard@citrix.com>,  Harsh Prateek Bora
 <harshpb@linux.ibm.com>,  Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,  Eduardo
 Habkost <eduardo@habkost.net>,  Paolo Bonzini <pbonzini@redhat.com>,
  Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,  =?utf-8?Q?C?=
 =?utf-8?Q?=C3=A9dric?= Le
 Goater <clg@kaod.org>,  qemu-ppc@nongnu.org,  Philippe =?utf-8?Q?Mathieu-?=
 =?utf-8?Q?Daud=C3=A9?=
 <philmd@linaro.org>,  Christian Borntraeger <borntraeger@linux.ibm.com>,
  Akihiko Odaki <akihiko.odaki@daynix.com>,  Leonardo Bras
 <leobras@redhat.com>,  Nicholas Piggin <npiggin@gmail.com>,  Jiaxun Yang
 <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 6/6] Rename "QEMU global mutex" to "BQL" in comments and
 docs
References: <20231129212625.1051502-1-stefanha@redhat.com>
	<20231129212625.1051502-7-stefanha@redhat.com>
Date: Thu, 30 Nov 2023 08:17:54 +0100
In-Reply-To: <20231129212625.1051502-7-stefanha@redhat.com> (Stefan Hajnoczi's
	message of "Wed, 29 Nov 2023 16:26:25 -0500")
Message-ID: <874jh3g15p.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Stefan Hajnoczi <stefanha@redhat.com> writes:

> The term "QEMU global mutex" is identical to the more widely used Big
> QEMU Lock ("BQL"). Update the code comments and documentation to use
> "BQL" instead of "QEMU global mutex".
>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

For QAPI
Acked-by: Markus Armbruster <armbru@redhat.com>


