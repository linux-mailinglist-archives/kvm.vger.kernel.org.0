Return-Path: <kvm+bounces-6148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0742482C2FD
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 16:45:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0426BB23063
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 15:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E4A6EB68;
	Fri, 12 Jan 2024 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIS0v6rx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11CF6EB4E
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705074294;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hfrdnEtpGn94s5HzyRrjF4o/Q8dg/DO4WQ288cW8ZFY=;
	b=IIS0v6rxG8BF4yx+wUvflCmoTmm5PfIVql+BgJmIggbd5XUgZwfuzm3ekEFsAX5X66zopR
	E3jhfiBC9K2WI43eVIAeGoF6VEg25xMGup3qsgPrFyeKhIbjsdBar/KgZydHWj78THxjmd
	/0M5K4KNMkWoHESJqV6UqUrbDBYiDtU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-qHMIU1caNEeRbQSiFqv-Ag-1; Fri,
 12 Jan 2024 10:44:52 -0500
X-MC-Unique: qHMIU1caNEeRbQSiFqv-Ag-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05F6E3C29A67;
	Fri, 12 Jan 2024 15:44:48 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 246D2492BC6;
	Fri, 12 Jan 2024 15:44:40 +0000 (UTC)
Date: Fri, 12 Jan 2024 15:44:37 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
	qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Song Gao <gaosong@loongson.cn>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Bin Meng <bin.meng@windriver.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Laurent Vivier <laurent@vivier.eu>,
	Paolo Bonzini <pbonzini@redhat.com>, Brian Cain <bcain@quicinc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Beraldo Leal <bleal@redhat.com>, Paul Durrant <paul@xen.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-arm@nongnu.org, Weiwei Li <liwei1518@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	John Snow <jsnow@redhat.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	qemu-riscv@nongnu.org, Alistair Francis <alistair.francis@wdc.com>
Subject: Re: [PATCH v2 12/43] qtest: bump boot-serial-test timeout to 3
 minutes
Message-ID: <ZaFeZXP-3sYdnZbS@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
 <20240103173349.398526-13-alex.bennee@linaro.org>
 <cf617223-0a0b-4d42-84a3-cd323ea4c421@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf617223-0a0b-4d42-84a3-cd323ea4c421@redhat.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Fri, Jan 12, 2024 at 04:13:16PM +0100, Thomas Huth wrote:
> On 03/01/2024 18.33, Alex Bennée wrote:
> > From: Daniel P. Berrangé <berrange@redhat.com>
> > 
> > The boot-serial-test takes about 1 + 1/2 minutes in a --enable-debug
> > build. Bumping to 3 minutes will give more headroom.
> > 
> > Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > Message-ID: <20230717182859.707658-9-berrange@redhat.com>
> > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > Message-Id: <20231215070357.10888-9-thuth@redhat.com>
> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> > ---
> >   tests/qtest/meson.build | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
> > index c7944e8dbe9..dc1e6da5c7b 100644
> > --- a/tests/qtest/meson.build
> > +++ b/tests/qtest/meson.build
> > @@ -6,6 +6,7 @@ slow_qtests = {
> >     'test-hmp' : 240,
> >     'pxe-test': 600,
> >     'prom-env-test': 360,
> > +  'boot-serial-test': 180,
> >   }
> >   qtests_generic = [
> 
> 3 minutes was obviously not enough:
> 
>  https://gitlab.com/qemu-project/qemu/-/jobs/5918818492#L4984
> 
> And in older runs, we can see that the boot-serial-test might take longer
> than 180s when run with TCI :
> 
>  https://gitlab.com/qemu-project/qemu/-/jobs/5890481086#L4772
> 
> So I think we should bump the timeout to 240s here. Alex, are you going to
> respin your pull request? If so, could you modify your patch? Otherwise I
> can also send a new version of this patch here, just let me know.

Agreed, 240s seems a good next attempt

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


