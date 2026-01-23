Return-Path: <kvm+bounces-68951-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJuIBiI1c2lItAAAu9opvQ
	(envelope-from <kvm+bounces-68951-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 09:45:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 64AE672B16
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 09:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 16EB53009807
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 08:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3848338584;
	Fri, 23 Jan 2026 08:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6giiCqT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93E63242A3
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 08:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769157883; cv=pass; b=tqdqk42b34sANcIggsTF0dp7imL5cg90sjkE3SBiXG9tR65Y8K06pVbw6s1F8spdgSIq4vdNBZsvi6grNghk3r3yF04KGZDHu2QBBssBkrFjvnWOl2vpXOOTtsSh3LNpgmL4rrvflSZQ/Rjh17lo1tweYndRLyWhq/QbcOy/O8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769157883; c=relaxed/simple;
	bh=q0ix+xmFBGS5x5j4yOBrivR5GZGMnHUrvI1gZx8ZGr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MHkUK8s0/mQaUqlX79lHr5rHWKVS6m6QHVSVJYOsI1m+GazL/B2natz/oaYyGLykIwWwZ/UTDg94UNI8bdpGlAIDPbsbegoOtLz3+hFQrTRCwqH47rJtAzfj23O7LUcX7X7sybURj3b29WAWiktZ1Nq6qVkcP17pR1ANHjPia9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6giiCqT; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5018ec2ae21so25560241cf.0
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 00:44:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769157880; cv=none;
        d=google.com; s=arc-20240605;
        b=h5O1Q/sQPqADe4A6GYcrvX7X5l7SblAHUAp7Ku3osXB66UL1HJlEuA3bNO7m8qn0+1
         s27y16W0DNr6FKwXXqvULOgZU3moU6iiOuBib59dfTjNUpoj+r+nMh7AZmvPiaALcbkH
         XI3pBxux9tT9abAP6BjViXevD488C70UsgOHTvvEHWccdZ8kjH1KKdsToF0/grWwbkXe
         9co4tSfvuZMKO1wrCH4RiTHaYy7wO9f+Cz6d1zWCi8tnlhB6JWrtjcsOncZKg+IscPON
         JC2QP2leg69W0bLkix+ug3XXVAd7p3fOn/zBx9sD8xvUVt1sI3YbmZUCds1I1GDdn/9Z
         YE4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q0ix+xmFBGS5x5j4yOBrivR5GZGMnHUrvI1gZx8ZGr4=;
        fh=VQDDmZSzeo8Y9DERSBv35XDj6IzERDLfHUEmOx16aiI=;
        b=ZafjoEMkgd93Pg+Bt2l5FsZpZs7w0BNqagDDTxD9PYA5Ox60k83vMIuUDi/oetAGo5
         x1398JjF/fU6+la3PEOvH+JUOha5duTeZKaxuU26DeAYR/tnsU+bLyTq5iYfKAjthXR1
         nngZ+oNxtIO14exwc9so/lBt9VeWFe8jhZtjPaYUSx+8tawz5YrrsECXIIKBMmTykRPH
         Czb+RXmDj+k5ao5+JEzqiOBYVhqUJzlHnYzuQ4DwEtzHk4hDeVNNghfT0/HkApAXNZyV
         /SHM+dL1hn+I8/mjy6mszqkuUaik8JiZSaRbppY5pfpyNfzdI6bLXXp0WWr4Pkd4sP3G
         5cew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769157880; x=1769762680; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0ix+xmFBGS5x5j4yOBrivR5GZGMnHUrvI1gZx8ZGr4=;
        b=C6giiCqT5K1n+PFJstRqqSytqzmkroYqUs8fFBf1Fedr45gRLZi28f7PTy8TOpvN3q
         DOtLC0N6K7K1D2A8nyvlFgJTs4I04Mn3If81mQ5p7FyZe5zkk8J8aWdV6b6ROkTepV6H
         2Ty/MB+i83/QZ8XLIPP8qDHKxGY29FVQ6DWQwNcMAIM/8CAtoNvU1XaY8Ve/A113lgq7
         iYDqEz3kYAVupHhTGux+U2pK/U9RdMvMRNHU+QdWD2KHstR/E9Xsuts6IrYvsNaRNEub
         AHRrtbfcr4GLdYdaaZhtxqwBOMjNNMtJtbHbfN7Z2fTcckxxddBWWUK3Ef8g/iYQZQAV
         wvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769157880; x=1769762680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q0ix+xmFBGS5x5j4yOBrivR5GZGMnHUrvI1gZx8ZGr4=;
        b=DgRZzFE/UUmpkXGAFoT96/U5BrEjyCFsJBTajK/yhANdGEUMVu9k5qHF6m05rwetXK
         82/7/0eVXYmT0uH9AFgQwSFN/hpYvktyDf7+uMqNuBVIj8mm6DF589U2snORPfFFyx6I
         Z0XNG0IjAe6c/ooC6PksaTZikUAEfuXkXblJ/9XfBMC3P3SyUvbh5VG1nxTOtu5jE4cM
         ONwc257FXcb24wRmxaZZHYAddwO5y+RD2GFs+dBYXMcUtNd2nGHzdRh8ty+Q483nDibp
         bgJ2wrnxicqbGSPCEL4u4QQDdfq1J0n8m1TWtYRBRIPdoutwcrn5EF7eAVOvQAMVB7uF
         8M4Q==
X-Forwarded-Encrypted: i=1; AJvYcCW+9JSY4yYtlnLCG2NdC5eBLGlTsoci29rTtGq1yrDC1Xgv1714UIoJm7qrZspX41rGkx4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJZKo6wgUgKuf8Erpshb0DPJZWtvy2iD7L6tIsCWBCIkk3E8cp
	o9GUdtPpVaGz2VGBo/VtYP7lNGMuDMciixpVAhSXCTNilcxL+Z2y9+DUNboBOcL9a2x4U8566Zf
	zGRpM6s/GI+DC8JA7hzKJ6PQLNXlZLVL2PQ==
X-Gm-Gg: AZuq6aKpc2w42UVC/+4pRsynLuiNPvulDuPFbmd6gz0d7+nzNbwWatacRXsFDTMd0ua
	CCtuX0WLL29c83gz0nXRtDOvhxg00u+DCRGYSAdP+vXHeyjYtYaCSkUABKi44hxYvKkiohToB9a
	cVaZF1zvaIx5bK0z+242Di1hW84JjHT2SRZlsHIhYbx1v1GYJ85BJs9IRpYY5n52fHoM4BzmTPL
	fPfbXbA7Vw229Trl9wgpCwIZPcJiVu1vrgVm08D1bSv0oZzN+17qTW9luO0eCJ+DFaPDR8xWQNg
	fsMw4nxwicz8lkhA9TmuNuiwxmc=
X-Received: by 2002:a05:622a:1a93:b0:501:498e:5c29 with SMTP id
 d75a77b69052e-502f77d4a37mr30458991cf.59.1769157880449; Fri, 23 Jan 2026
 00:44:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
 <aXH4PpkC4AtccsOE@redhat.com> <CAMxuvaw04pDNzHyw5+Qcv_KfrhDTiyp+MNxpECp+HfTa5iLOGw@mail.gmail.com>
 <aXH-TlzxZ1gDvPH2@redhat.com> <CAFEAcA_u6QUhs+6-cyYm_qttsDiV2zHbsc-_FbTb8QzWXk6+tw@mail.gmail.com>
 <aXICpFZuNM9GG4Kv@redhat.com> <CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
 <82f74c82-c572-4ab9-b527-11ea287056d1@linaro.org>
In-Reply-To: <82f74c82-c572-4ab9-b527-11ea287056d1@linaro.org>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>
Date: Fri, 23 Jan 2026 12:44:28 +0400
X-Gm-Features: AZwV_Qi1gRi5xeDyNeB35CIP8lzUToeOVoLKCjAlrhjdcWtWqqH7vcnQjXP73Kc
Message-ID: <CAJ+F1CJtrv9YgDbiekVmDD2yT+6nUe39nLwLsKxvFOtMc1kUGA@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Peter Maydell <peter.maydell@linaro.org>, Stefan Hajnoczi <stefanha@gmail.com>, 
	Thomas Huth <thuth@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	John Levon <john.levon@nutanix.com>, Thanos Makatos <thanos.makatos@nutanix.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68951-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,linaro.org,gmail.com,nongnu.org,vger.kernel.org,gmx.de,ilande.co.uk,nutanix.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[marcandrelureau@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 64AE672B16
X-Rspamd-Action: no action

Hi

On Thu, Jan 22, 2026 at 7:46=E2=80=AFPM Pierrick Bouvier
<pierrick.bouvier@linaro.org> wrote:
>
> On 1/22/26 3:28 AM, Marc-Andr=C3=A9 Lureau wrote:
> > Hi
> >
> > On Thu, Jan 22, 2026 at 2:57=E2=80=AFPM Daniel P. Berrang=C3=A9 <berran=
ge@redhat.com> wrote:
> >>
> >> On Thu, Jan 22, 2026 at 10:54:42AM +0000, Peter Maydell wrote:
> >>> On Thu, 22 Jan 2026 at 10:40, Daniel P. Berrang=C3=A9 <berrange@redha=
t.com> wrote:
> >>>> Once we have written some scripts that can build gcc, binutils, linu=
x,
> >>>> busybox we've opened the door to be able to support every machine ty=
pe
> >>>> on every target, provided there has been a gcc/binutils/linux port a=
t
> >>>> some time (which covers practically everything). Adding new machines
> >>>> becomes cheap then - just a matter of identifying the Linux Kconfig
> >>>> settings, and everything else stays the same. Adding new targets mea=
ns
> >>>> adding a new binutils build target, which should again we relatively
> >>>> cheap, and also infrequent. This has potential to be massively more
> >>>> sustainable than a reliance on distros, and should put us on a pathw=
ay
> >>>> that would let us cover almost everything we ship.
> >>>
> >>> Isn't that essentially reimplementing half of buildroot, or the
> >>> system image builder that Rob Landley uses to produce toybox
> >>> test images ?
> >>
> >> If we can use existing tools to achieve this, that's fine.
> >>
> >
> > Imho, both approaches are complementary. Building images from scratch,
> > like toybox, to cover esoteric minimal systems. And more complete and
> > common OSes with mkosi which allows you to have things like python,
> > mesa, networking, systemd, tpm tools, etc for testing.. We don't want
> > to build that from scratch, do we?
> >
>
> I ran into this need recently, and simply used podman (or docker) for
> this purpose.
>
> $ podman build -t rootfs - < Dockerfile
> $ container=3D$(podman create rootfs)
> $ podman export -o /dev/stdout $container |
> /sbin/mke2fs -t ext4 -d - out.ext4 10g
> $ podman rm -f $container
>
> It allows to create image for any distro (used it for alpine and
> debian), as long as they publish a docker container. As well, it gives
> flexibility to have a custom init, skipping a lengthy emulated boot with
> a full system. As a bonus, it's quick to build, and does not require
> recompiling the world to get something.
>
> You can debug things too by running the container on your host machine,
> which is convenient.
>

Very nice! I didn't realize you could export and reuse a container that way=
.

I wonder how this workflow can be extended and compare to mkosi
(beside the limitation to produce tar/fs image)

For qemu VM testing, it would fit better along with our Dockerfile &
lcitool usage.

I wish a tool would help to (cross) create & boot such (reproducible)
images & vm easily.


> I took a look at bootc, but was not really convinced of what it added
> for my use case compared to the 4 commands above.
>

Having a regular VM bootable image could be desirable for some cases
(tpm, secure boot testing for ex).

--
Marc-Andr=C3=A9 Lureau

