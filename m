Return-Path: <kvm+bounces-26707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA149768CA
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:12:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86234283169
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 12:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2EB21A2635;
	Thu, 12 Sep 2024 12:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gCm1Rxo/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A0190662
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 12:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726143150; cv=none; b=NeainoEmOAkdNr4Cd1Gju+0CRTSztNjTIfq9aTfDvzStv8OQ/0FKisT7QP3cFbUtMN1Zo003xe6u4xMwvj4riEo+rmfsTe9OVbS2R70Pg5hj+Ff+Ocv33O627Rj8dJX8xjF2iyamvMXCUWWLrBOae2twMkKWnw0V3Yyv5Q6dUj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726143150; c=relaxed/simple;
	bh=wd5ai1IV/K/4awiwENQbpVdK+2t60tMTR/cv6Vz0pPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qsbox4jt0tc81UOAJoQ9PbdBxk6NHB8fIlMxpJh2NtdopOXhOZApkF5GgM+oozNSMB/eQIBPVaL0IupFEquKh8y/zuCItn0QhUlUXNpvHprxX9vY0J5407JI+OE+nd3ZczkeOM0GPD74K1EKeePtyaZLB0D7dWnyO5YcO5HbB7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gCm1Rxo/; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c3d20eed0bso1010432a12.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 05:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726143147; x=1726747947; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSke8FlFE4N6exTtc6EKOjb2LrZxkDR+LzQcBycp73g=;
        b=gCm1Rxo/fR2QI99lPbnmXKsr85jow1XAUacki3PnkvgwJU5kJ49pVVdActJ34gFYlX
         pKR5+4odfFFtLL5v3JuUN6shF0B+rh87uJqm+iPetjK62U8xiLmEaEZuUkr7AkPSH3cG
         iG7dHwIse8qsmtIfdg8vWqWb0iDF0YxClmDCZ++5t/HJ0s1V3HzAlZayYp64IvyR16IH
         LkxMSYEQ2uBqbTimOI5zIwPClIT1m4kWAGEZ5KN0ggnYf5wV9CY5fudk17nTWZrD8DA8
         9HxUXiUuhvRBS4CdxnVBt+rr/rqXysd6Otc/CYLxZuyQBsfmX7/mPt93/usp96S0ahHp
         LA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726143147; x=1726747947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pSke8FlFE4N6exTtc6EKOjb2LrZxkDR+LzQcBycp73g=;
        b=cDaI12Qxo1smwIqZS6QR8MWifAVhvNZEyO+cwuiDkQEzLhM2l7nOzzSU02IdY2PiuF
         3v9e5DX4jHwztdr/4iR2rh37D7t0nN9NvJdsuLISuOpy77R+JlIef3xq7iuTywVN2hIM
         FcqjGp08cIf67Z/KlGgY0h1FpCUIQbsyKRjk5oUAu80q80YHk5Mr4VizeOyHKS7QRtM2
         FrLqViX9SMcgiEGghGbA4e12fElSygM/wWzM+/2ZfPfH5lHpT43mtPu/YZxATFIgPOgA
         SjYdX7I88l2U2wAFyMLJ9/8j49EHjAhzgOwkrcd4vV69gyJ5PAjM8YY55NHMyaGtLLb7
         hfHA==
X-Forwarded-Encrypted: i=1; AJvYcCXsQDb4NhXqGIv3y3yp7TUaJmQVzO3eLwe7IBTslV36ccRd4XvHlpcZ/eyleMpgshxveOM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQtBjcAT5v5I5X5fwqYj/WMhROnOzwwZQZX92z1gQhMQGmODB3
	nDRtEFJMgD5EgW0GsHGO3guXIANbvewiroRnJ4hHFF26wVWqEniaHx0tlWnXdRf1W1bA7IWf62V
	XjR3OWJLDkW4QqfFdMJVcDOjyRGvtYRkp4eaDkA==
X-Google-Smtp-Source: AGHT+IETQd/3dKE+DCudKgky7MhTcKDOjT4e304Trb0+62Sgjre9CoznMfjV51Zt3iOwKhpGntAfXRHw7wfNzHrHWeQ=
X-Received: by 2002:a05:6402:3881:b0:5c0:8ea7:3deb with SMTP id
 4fb4d7f45d1cf-5c413e4c748mr1736077a12.22.1726143147135; Thu, 12 Sep 2024
 05:12:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
 <20240912073921.453203-15-pierrick.bouvier@linaro.org> <a0608783-d6d8-4ccc-a431-5fc1e96e0021@linaro.org>
In-Reply-To: <a0608783-d6d8-4ccc-a431-5fc1e96e0021@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Sep 2024 13:12:16 +0100
Message-ID: <CAFEAcA9rx6jSZ3SHa1=H+-r6H4KopK3dUG=qmqRgt=nVcs5ueA@mail.gmail.com>
Subject: Re: [PATCH v2 14/48] include/hw/s390x: replace assert(false) with g_assert_not_reached()
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org, 
	Jason Wang <jasowang@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Laurent Vivier <lvivier@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Klaus Jensen <its@irrelevant.dk>, WANG Xuerui <git@xen0n.name>, 
	Halil Pasic <pasic@linux.ibm.com>, Rob Herring <robh@kernel.org>, 
	Michael Rolnik <mrolnik@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Fabiano Rosas <farosas@suse.de>, 
	Corey Minyard <minyard@acm.org>, Keith Busch <kbusch@kernel.org>, Thomas Huth <thuth@redhat.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>, 
	Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jesper Devantier <foss@defmacro.it>, Hyman Huang <yong.huang@smartx.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, qemu-s390x@nongnu.org, 
	Laurent Vivier <laurent@vivier.eu>, qemu-riscv@nongnu.org, 
	"Richard W.M. Jones" <rjones@redhat.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
	Aurelien Jarno <aurelien@aurel32.net>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Akihiko Odaki <akihiko.odaki@daynix.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Hanna Reitz <hreitz@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, qemu-ppc@nongnu.org, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Alistair Francis <alistair.francis@wdc.com>, Bin Meng <bmeng.cn@gmail.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Helge Deller <deller@gmx.de>, Peter Xu <peterx@redhat.com>, 
	Daniel Henrique Barboza <danielhb413@gmail.com>, Dmitry Fleytman <dmitry.fleytman@gmail.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Yanan Wang <wangyanan55@huawei.com>, qemu-arm@nongnu.org, 
	Igor Mammedov <imammedo@redhat.com>, Jean-Christophe Dubois <jcd@tribudubois.net>, 
	Eric Farman <farman@linux.ibm.com>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, 
	qemu-block@nongnu.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, 
	Joel Stanley <joel@jms.id.au>, Eduardo Habkost <eduardo@habkost.net>, 
	David Gibson <david@gibson.dropbear.id.au>, Fam Zheng <fam@euphon.net>, 
	Weiwei Li <liwei1518@gmail.com>, Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Sept 2024 at 12:59, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.o=
rg> wrote:
>
> On 12/9/24 09:38, Pierrick Bouvier wrote:
> > This patch is part of a series that moves towards a consistent use of
> > g_assert_not_reached() rather than an ad hoc mix of different
> > assertion mechanisms.
> >
> > Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> > ---
> >   include/hw/s390x/cpu-topology.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
>
> We usually don't precise "include/" in patch subject:
> we treat include/FOO as part of FOO area.

I would say either is OK -- if you do
git log --oneline | grep ' include' |less

you can see plenty of examples where 'include' was used in
the subject-area prefix, especially if, as here, we're changing
just one file.

-- PMM

