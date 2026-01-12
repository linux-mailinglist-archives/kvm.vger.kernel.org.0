Return-Path: <kvm+bounces-67842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C1E3D15C0C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0A505301E691
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 23:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1582561A2;
	Mon, 12 Jan 2026 23:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OK70uyNv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA373BB40
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 23:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768259715; cv=none; b=J4fog0J3B9Q6nL+iwaUTHdDX3UbvPFhJCWGxW8vyyJRmBBBT2tUHYbqiv9us+dvj/BWqe6RlzUzMI4K9Cp1ocTMJtrcA7z8KnfJa8PEpuuNraZ3uJQ00F8Gcv01a6y2T6Y1+YshxoZFUDJg+mNzI7vHQ3JmEgOQP5gF90y00Yik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768259715; c=relaxed/simple;
	bh=D/QOV+PvgeGDhnZ/ix6Fp2phNTxa9gFGlVxWZXZmAqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItObdOuwATWNaw8ujsp7Psry+vGVwb8TdV/ebdVhryCWfOuQFLamCEpiNNEReXsXG0V/L2Nr4lD6SHH+EIzvVkQJ0Qj7B9xVR/YaYBX5hRh7KC4zqoS3/y1RgYYIYZzWHzVx6kKHnovtAkkrpC2TBH9CrMaHqla4ca/NXhlkiNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OK70uyNv; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee13dc0c52so60247761cf.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 15:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768259712; x=1768864512; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VrgEBLHMQ7w7z7OSk0+LmFxB5np8c3y6da/CYllo/d4=;
        b=OK70uyNvYv8MOnkRzIM/7MCuD5vzOxFDCxe/t23Tkzz3IrP8JXhtIyOyplRMi2R78y
         vAp0VFaeflBYfelfkHB3mKC0ITRu8vz9NXh7oaKcwQFx+lzTd3LJphaa+b2jBnqE+a7F
         6z4DKcNZvNHBKoMg5Esx8y0RGbOo/8PmOPk5KGw+V6qyb+SBKsVfSvHb8MNnr01Ct2c5
         GJvy4OUo5oHKfS1CH0WtCoFioAl0RV3IZZSIYXwouHHef7eQwJCXxJ+wVFJAe7iHpd8q
         brwZGuqGH7BJIR0DxBPeBQ5idtyo6+C5mIGzF/3szxPJeSzY56dtl3cu+oiLBYXfLRvW
         zR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768259712; x=1768864512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VrgEBLHMQ7w7z7OSk0+LmFxB5np8c3y6da/CYllo/d4=;
        b=jMOSTukSZiIR3jxDfvmLZrq/AikBWGnWYKBwohYlX7KOsT/76pMqzJNdKIkyhaDmRy
         Cki41foGp1BWeDwWwVMHwD8hBQUamBZZnjOyH/HeJ9XYvdEI2zlpxAE96ZgxRF1T2wuo
         OZZaai10AfdOejrdSj2JH76OIQwJAJgzoK9QI6WRmzNBzGpR8orj9kdzEHGBBRfxSmx6
         7cIFe6vuuc3z6CxzOXP6qpJmytw+sFHNxAwKjU8arXzhHoH9REHO3kqCMfDYssmoPRIY
         iykxLwES72HYlhnLlQUxTfzD3IaUidguhcAm5kkC1rz7KHKisQSNwYrRI5hnAmPFQGia
         Kcww==
X-Forwarded-Encrypted: i=1; AJvYcCUK2GGVfReCgx/oidLoSHHa7/gZdJKH8Od4AWlwcnmNtSGkZKIbStO59CrPUlVfXcwYgGk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8xuw0GTWJl08plmRmW3RcsnsTMdRdi731TywcUSVMM23k8SZ2
	+ne3T6jyNaWHepwKL+ahKq3dCcgz1fu4OcE2tqYJ4hGyrQgS/BPN5c5l4Cb8pQ==
X-Gm-Gg: AY/fxX6tGphYXTDmdB/h2UB2dPqgXsoqKHCKqt3FQSYzaZEV9UzfMXpwKQ6zzigTxfi
	6f5doEBolQh4Q9rzTLgOSvN1PhYmoM2yof2lfQHeDR3vIi3UgvT+ZOYTuADomHMoTg15ma1bLs8
	Sx/d/zttS58UhD9osDx5TaiJaWNZFm4Np88dEbFBACsezl59QL47EGLFuQnUYtijbngsucWgI4L
	2OjlQmhdygZAcO1YnYvZaWakGwYhxaUpJVdgA8MU803MnHm8Dl0SXR9GG7NJ0rUQ4nb+DtlbhOz
	GP0z78nDA3Jh1P6iOr4PGdful0IuLj7IBA2x18iw/B20AUXNasdYUgDm74noWY47we58Y6Jfthy
	24ilGhU43dVi/q9dHHMymQ+BqeeEh8W8uv6EOBu66omsM22wjLS5WCDMn1/8ypGBUtPaGGKHawL
	UCIyGVM6ejBqkWnQEu3UbcKjHFwTG5uljm5mxtenynrIZd
X-Google-Smtp-Source: AGHT+IEEIChW46EWJZZzmGq0dv1aKbX23y4OJcSbpVgI4A7CpdyG+MDzyxvMqujhAfbDeFoADMp1dQ==
X-Received: by 2002:a53:e303:0:b0:63f:a727:8403 with SMTP id 956f58d0204a3-64716bd78d9mr12404043d50.38.1768254541320;
        Mon, 12 Jan 2026 13:49:01 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:8::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d7f7c04sm8530959d50.2.2026.01.12.13.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 13:49:00 -0800 (PST)
Date: Mon, 12 Jan 2026 13:48:58 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org,
	berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH RFC net-next v13 00/13] vsock: add namespace support to
 vhost-vsock and loopback
Message-ID: <aWVsSq7lORhM+prM@devvm11784.nha0.facebook.com>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
 <aWGZILlNWzIbRNuO@devvm11784.nha0.facebook.com>
 <20260110191107-mutt-send-email-mst@kernel.org>
 <aWUnqbDlBmjfnC_Q@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWUnqbDlBmjfnC_Q@sgarzare-redhat>

On Mon, Jan 12, 2026 at 06:26:18PM +0100, Stefano Garzarella wrote:
> On Sat, Jan 10, 2026 at 07:12:07PM -0500, Michael S. Tsirkin wrote:
> > On Fri, Jan 09, 2026 at 04:11:12PM -0800, Bobby Eshleman wrote:
> > > On Tue, Dec 23, 2025 at 04:28:34PM -0800, Bobby Eshleman wrote:
> > > > This series adds namespace support to vhost-vsock and loopback. It does
> > > > not add namespaces to any of the other guest transports (virtio-vsock,
> > > > hyperv, or vmci).
> > > >
> > > > The current revision supports two modes: local and global. Local
> > > > mode is complete isolation of namespaces, while global mode is complete
> > > > sharing between namespaces of CIDs (the original behavior).
> > > >
> > > > The mode is set using the parent namespace's
> > > > /proc/sys/net/vsock/child_ns_mode and inherited when a new namespace is
> > > > created. The mode of the current namespace can be queried by reading
> > > > /proc/sys/net/vsock/ns_mode. The mode can not change after the namespace
> > > > has been created.
> > > >
> > > > Modes are per-netns. This allows a system to configure namespaces
> > > > independently (some may share CIDs, others are completely isolated).
> > > > This also supports future possible mixed use cases, where there may be
> > > > namespaces in global mode spinning up VMs while there are mixed mode
> > > > namespaces that provide services to the VMs, but are not allowed to
> > > > allocate from the global CID pool (this mode is not implemented in this
> > > > series).
> > > 
> > > Stefano, would like me to resend this without the RFC tag, or should I
> > > just leave as is for review? I don't have any planned changes at the
> > > moment.
> > > 
> > > Best,
> > > Bobby
> > 
> > i couldn't apply it on top of net-next so pls do.
> > 
> 
> Yeah, some difficulties to apply also here.
> I tried `base-commit: 962ac5ca99a5c3e7469215bf47572440402dfd59` as mentioned
> in the cover, but didn't apply. After several tries I successfully applied
> on top of commit bc69ed975203 ("Merge tag 'for_linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost")
> 
> So, I agree, better to resend and you can remove RFC.
> 
> BTW I'll do my best to start to review tomorrow!
> 
> Thanks,
> Stefano
> 

Sounds good to me. Sorry about that, I must have done something weird
with b4 to pin the base commit because it has been
962ac5ca99a5c3e7469215bf47572440402dfd59 for the last several revisions.

Looks like my local of this is actually based on:

7b8e9264f55a ("Merge tag 'net-6.19-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")

I'll re-apply to head and resend today!

While I'm at it I will try to address Michael's feedback and bump a
version.

Best,
Bobby

