Return-Path: <kvm+bounces-27697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BED0F98AA8D
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 19:04:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84BEA2887BB
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 17:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723FC1957F4;
	Mon, 30 Sep 2024 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="T7m7ADgb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB0F194ACB
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 17:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727715852; cv=none; b=Usv4MVpsjo8hBxuH57zM6NlLTl/zL5O7dE9vO2SDwWCeI7SqTElJ/FYM4YU6EKwbftnwDgYHmdo1KdA0H1ufEepcRW/beRSuujB8h9nMuY4EfWYZc0QWsartv5VeKypUPCCXTE2Vp3/zAU67/oovcdAZpqORpXG/0/N8w7TQgDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727715852; c=relaxed/simple;
	bh=Hxy5RRz3ZDbul6zT6nM1wJ24XgbC59beRrdTOnK6vH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aTqvPTER8TMBgODcqQHG7AbUhVkpQES2vKLpTR+Cc50RxofcVk2bSHtiPi7sgLRpjObnWd8EiCGQlDNpQIFaNFgzSEwERQH8sGpYoEQF0HX8LNq1qA9FmgDBrrd3+ksNh1iNl3BK5qvCTC3Izo2sDcj2aNfCVGPopdhJVtImwxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=T7m7ADgb; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2FF623F5BB
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1727715845;
	bh=uCq97dcBwspUfA12XvnHz7wkL3yN6ZAbWmU3HPjeKvM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=T7m7ADgb4MitXj+Zs9Dk7wDPbb2SS9YzRH+RhPdUYF56kUbnuhA4OKqw13PT3EFVb
	 Yw7BrIpYiuQcHFxQJiEe8pwVhquqjlk5O7Zp0l9cpR7Q86Jy8Nl4wHKvYxYZf7zCX7
	 +okTr3BxOH1zkZIYODG1cIs6LGqzygOSMr33kzkD8w8ICntiytFKXvx3smXD47jHXj
	 8ToN8YTlGNFGb4rH+LzrPj8e/RBGemf+mX5fg8vIW7Qr/vzISYIBgOdj3JAfga74Ef
	 e0IgoKIv01zv7syoBoTwZOP0naSaTYKK41Kg1ihvbo/79fViKWq9J989ZQb0gdsG0n
	 Kd1UmpWI0Y1dA==
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-50a3fbf5278so1275955e0c.0
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 10:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727715844; x=1728320644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uCq97dcBwspUfA12XvnHz7wkL3yN6ZAbWmU3HPjeKvM=;
        b=HNiDYLsfjxD14Y2wA5bOgUr6+S7S9R1ZAY6FquyO2yie6YiM4/EkBTaT+5oJa7kUZK
         MtvUUuzGy80Ew+SB9cKi7+/hURpWw9iIyxGY4wFAfeea6G4GmaEMN4QYOToLjzur5Uwu
         O4QkyH2WsA0vSdb0rqICj2pfHSCkXIHLHjeEM2j2JMg+pJNtX29xxiF0GjR3kSkEcbZX
         T8xCvkKRIA6sT5Gu1ZnANAr7skpvDVNAOIfhUAiDitITG3RdNtdRhj3esgusNadWDqiT
         rl0rXbs2GCz2HInS4+S9V/uSYdPr2HIW8uuq03J1jgPm5BSYtRkvwKQlvn4xsFzidz8j
         xEAw==
X-Forwarded-Encrypted: i=1; AJvYcCUTluwW28vEH7QOlGR7SxcO17uixytJq0TTL2iXRsrH7t1OIFoFhlAtPmIsQBhbEawS9Z0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI7MFOxEB0bH9PUWnfl8dMdrRTF7/HmHQ5XCy0wL1VPcpXyhh9
	uRha661cJv4W7Gr5+u1EjtZpstaAU6/fq1jRF9p3gZfQRN4mwn7G4d3z94Mu0mFFqdThXZeauOr
	Xnzeui8Hzg9Se5jTfglvME5WWV2xjcbMd38dG3c/5w5rcd7CqVjE7DHHQOsj5uyXJFxHD3dRRiu
	3fWOIFCZGiq+Y5gLXJJU7C+8dnd5NcgaDMj9G8181t
X-Received: by 2002:a05:6122:d0f:b0:507:a6a3:6d7 with SMTP id 71dfb90a1353d-50ad3b8cffdmr397270e0c.1.1727715843960;
        Mon, 30 Sep 2024 10:04:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEI10r0Myyi5Nwjiwg4H3fq4K1wjxeTVvrkOnj6DDSqCblFOLZtzteahkiAAEq+1E70tbSFfRQUqLdEHoDATvY=
X-Received: by 2002:a05:6122:d0f:b0:507:a6a3:6d7 with SMTP id
 71dfb90a1353d-50ad3b8cffdmr397203e0c.1.1727715843469; Mon, 30 Sep 2024
 10:04:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929182103.21882-1-aleksandr.mikhalitsyn@canonical.com>
 <w3fc6fwdwaakygtoktjzavm4vsqq2ks3lnznyfcouesuu7cqog@uiq3y4gjj5m3>
 <CAEivzxe6MJWMPCYy1TEkp9fsvVMuoUu-k5XOt+hWg4rKR57qTw@mail.gmail.com> <ib52jo3gqsdmr23lpmsipytbxhecwvmjbjlgiw5ygwlbwletlu@rvuyibtxezwl>
In-Reply-To: <ib52jo3gqsdmr23lpmsipytbxhecwvmjbjlgiw5ygwlbwletlu@rvuyibtxezwl>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Mon, 30 Sep 2024 19:03:52 +0200
Message-ID: <CAEivzxdP+7q9vDk-0V8tPuCo1mFw92jVx0u3B8jkyYKv8sLcdA@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vsock: specify module version
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: kuba@kernel.org, stefanha@redhat.com, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 5:43=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> Hi Aleksandr,
>
> On Mon, Sep 30, 2024 at 04:43:36PM GMT, Aleksandr Mikhalitsyn wrote:
> >On Mon, Sep 30, 2024 at 4:27=E2=80=AFPM Stefano Garzarella
> ><sgarzare@redhat.com> wrote:
> >>
> >> On Sun, Sep 29, 2024 at 08:21:03PM GMT, Alexander Mikhalitsyn wrote:
> >> >Add an explicit MODULE_VERSION("0.0.1") specification for the vhost_v=
sock module.
> >> >
> >> >It is useful because it allows userspace to check if vhost_vsock is t=
here when it is
> >> >configured as a built-in.
> >> >
> >> >This is what we have *without* this change and when vhost_vsock is
> >> >configured
> >> >as a module and loaded:
> >> >
> >> >$ ls -la /sys/module/vhost_vsock
> >> >total 0
> >> >drwxr-xr-x   5 root root    0 Sep 29 19:00 .
> >> >drwxr-xr-x 337 root root    0 Sep 29 18:59 ..
> >> >-r--r--r--   1 root root 4096 Sep 29 20:05 coresize
> >> >drwxr-xr-x   2 root root    0 Sep 29 20:05 holders
> >> >-r--r--r--   1 root root 4096 Sep 29 20:05 initsize
> >> >-r--r--r--   1 root root 4096 Sep 29 20:05 initstate
> >> >drwxr-xr-x   2 root root    0 Sep 29 20:05 notes
> >> >-r--r--r--   1 root root 4096 Sep 29 20:05 refcnt
> >> >drwxr-xr-x   2 root root    0 Sep 29 20:05 sections
> >> >-r--r--r--   1 root root 4096 Sep 29 20:05 srcversion
> >> >-r--r--r--   1 root root 4096 Sep 29 20:05 taint
> >> >--w-------   1 root root 4096 Sep 29 19:00 uevent
> >> >
> >> >When vhost_vsock is configured as a built-in there is *no* /sys/modul=
e/vhost_vsock directory at all.
> >> >And this looks like an inconsistency.
> >> >
> >> >With this change, when vhost_vsock is configured as a built-in we get=
:
> >> >$ ls -la /sys/module/vhost_vsock/
> >> >total 0
> >> >drwxr-xr-x   2 root root    0 Sep 26 15:59 .
> >> >drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
> >> >--w-------   1 root root 4096 Sep 26 15:59 uevent
> >> >-r--r--r--   1 root root 4096 Sep 26 15:59 version
> >> >
> >> >Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical=
.com>
> >> >---
> >> > drivers/vhost/vsock.c | 1 +
> >> > 1 file changed, 1 insertion(+)
> >> >
> >> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >> >index 802153e23073..287ea8e480b5 100644
> >> >--- a/drivers/vhost/vsock.c
> >> >+++ b/drivers/vhost/vsock.c
> >> >@@ -956,6 +956,7 @@ static void __exit vhost_vsock_exit(void)
> >> >
> >> > module_init(vhost_vsock_init);
> >> > module_exit(vhost_vsock_exit);
> >> >+MODULE_VERSION("0.0.1");
> >
> >Hi Stefano,
> >
> >>
> >> I was looking at other commits to see how versioning is handled in ord=
er
> >> to make sense (e.g. using the same version of the kernel), and I saw
> >> many commits that are removing MODULE_VERSION because they say it
> >> doesn't make sense in in-tree modules.
> >
> >Yeah, I agree absolutely. I guess that's why all vhost modules have
> >had version 0.0.1 for years now
> >and there is no reason to increment version numbers at all.
>
> Yeah, I see.
>
> >
> >My proposal is not about version itself, having MODULE_VERSION
> >specified is a hack which
> >makes a built-in module appear in /sys/modules/ directory.
>
> Hmm, should we base a kind of UAPI on a hack?

Good question ;-)

>
> I don't want to block this change, but I just wonder why many modules
> are removing MODULE_VERSION and we are adding it instead.

Yep, that's a good point. I didn't know that other modules started to
remove MODULE_VERSION.

>
> >
> >I spent some time reading the code in kernel/params.c and
> >kernel/module/sysfs.c to figure out
> >why there is no /sys/module/vhost_vsock directory when vhost_vsock is
> >built-in. And figured out the
> >precise conditions which must be satisfied to have a module listed in
> >/sys/module.
> >
> >To be more precise, built-in module X appears in /sys/module/X if one
> >of two conditions are met:
> >- module has MODULE_VERSION declared
> >- module has any parameter declared
>
> At this point my question is, should we solve the problem higher and
> show all the modules in /sys/modules, either way?

Probably, yes. We can ask Luis Chamberlain's opinion on this one.

+cc Luis Chamberlain <mcgrof@kernel.org>

>
> Your use case makes sense to me, so that we could try something like
> that, but obviously it requires more work I think.

I personally am pretty happy to do more work on the generic side if
it's really valuable
for other use cases and folks support the idea.

My first intention was to make a quick and easy fix but it turns out
that there are some
drawbacks which I have not seen initially.

>
> Again, I don't want to block this patch, but I'd like to see if there's
> a better way than this hack :-)

Yeah, I understand. Thanks a lot for reacting to this patch. I
appreciate it a lot!

Kind regards,
Alex

>
> Thanks,
> Stefano
>
> >
> >Then I found "module: show version information for built-in modules in s=
ysfs":
> >https://github.com/torvalds/linux/commit/e94965ed5beb23c6fabf7ed31f625e6=
6d7ff28de
> >and it inspired me to make this minimalistic change.
> >
> >>
> >> In particular the interesting thing is from nfp, where
> >> `MODULE_VERSION(UTS_RELEASE);` was added with this commit:
> >>
> >> 1a5e8e350005 ("nfp: populate MODULE_VERSION")
> >>
> >> And then removed completely with this commit:
> >>
> >> b4f37219813f ("net/nfp: Update driver to use global kernel version")
> >>
> >> CCing Jakub since he was involved, so maybe he can give us some
> >> pointers.
> >
> >Kind regards,
> >Alex
> >
> >>
> >> Thanks,
> >> Stefano
> >>
> >> > MODULE_LICENSE("GPL v2");
> >> > MODULE_AUTHOR("Asias He");
> >> > MODULE_DESCRIPTION("vhost transport for vsock ");
> >> >--
> >> >2.34.1
> >> >
> >>
> >
>

