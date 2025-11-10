Return-Path: <kvm+bounces-62549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B81BC4884D
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1447D3B9D3C
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBFDC32939E;
	Mon, 10 Nov 2025 18:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zm18xISC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C3131B10D
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 18:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798789; cv=none; b=is6Deh1nVcLflkKAz8yFfJzARxTFGqt6qN4QoUL0Xfm2pi8JRqwp4Rat2dtRWcTs2npzktIeLmHPho3OoWhW4QcYAD2VlbtCTCflADZrgAb91uCwJ6aLFRrWTTctQWqEjEek5ZQu7bQb4mFGLOBfp3OTzBhHHP1qaII5PzHy6YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798789; c=relaxed/simple;
	bh=oyHg3zXu/b6Cjpi2ub1O6Gg6iEOnJq+3EJOcKuli2yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bkVDt2XmiezcGD9f67SGSn9Gx57osQPJI1IRTNtTTHTl+wlJu83mTLN1X57PofJ/RFnB/citr5CzlTjE/zYtjN7vhIj9/zBeheed4bTqQ69XbJ+NfyEb/7ZecUhX96y2NEYm8b/b/2vIMQ6ZuM91rkyh/I2fY//MMQKuuRpjVk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zm18xISC; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3436cbb723fso1934705a91.2
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 10:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762798787; x=1763403587; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C2BTPYOB6RYO59SSrAH4Sj40+ULfOFTRdMdLYImnqNg=;
        b=zm18xISCBOnwtXjWi7UlBtcHz2uy2Pz+3eAgJC3hIHCKfTzWHMXVks190ul/Pf9FoX
         NGrIxQw1CnUVo9J6XxOX7uMBggSK0K3s+6+SH2SewrR0xuZ9PL5zGfvtAVbNQx+61t7M
         vzHvvs316Ab6AjWi7MtPeYX3f5OKGLyaYPsMv+5DN5R09uxtAoI+rGO9c52CjD5TLBQV
         GiK8qFW5ambNkDe26hQm0Qv+MecPXmfiypgAVVoqN8yTvydLiiTCwM5l6DTvmZwkRpd4
         RsBC2ult2pV7TN5d2uyG612B3M8x7mKXUystumlNq6c7BOZLiea5FJ1YkiK94vJzFukF
         mWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762798787; x=1763403587;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C2BTPYOB6RYO59SSrAH4Sj40+ULfOFTRdMdLYImnqNg=;
        b=O9l58XJKawygvBPW/ynFWP78hbHkDakFUzARBSoVNaxkExLcIgDBlVgRC1swQiwIZB
         dzaNZa4E12G+IkFMzd2oCVa4UmDOaa4hRcFVRDnZG8DhWHe6sLg/aGS4QJOarSOhuExF
         mjVZKHNQU7PcKkR0WxDUgCS3V9qy3T2aykQAbgvYyYo6CXMBjxaLgdt1fOjDESAyA38P
         /1C8kxnbUAVFsOkA3XBNSnoTYYOhYrjMs+VimlpTtmSOEwsUt31rxp1LbQ+/z4hcvT3l
         cMCg7QaCAc/v1chwXTpr5YCrmjGtumC2hri5nBlESTDsRbdhootm6+HErqgCwReaRPHc
         GStA==
X-Forwarded-Encrypted: i=1; AJvYcCUtTTnYDlSBMBuW6Tr4N/c2FVSRXlqMGqqr8fzUcr7WGL1eE5p0D5lFlITiWFp0Sv3kALI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7MIWTrUfS2PkI5fXboMUyonRs5qy5esLK7+GV0IV+JPSTP9Ry
	LImhDidoxNaBjMDqYnkQNn9xNaG1AXi6+u+60sgSOu9Y8QgNFhXpQ5ymG5A5SevIzw==
X-Gm-Gg: ASbGnctTX5EnL9RRCFqNQXx7AXwtDCaaTWMMhsi7J0bVJa8pvc3KfaCCtB31uQMa7EC
	LTupzGPtiy/b7Ltmkd44HOIpEykgY2UI+o28Yd7sZy66+ZPljni3TAUVqh26NX9btne+JUfvCYw
	JGE6Sb6bqfgEf9euFHMka0me3E8WLizLUK+fFuqHE9Kz+/IejELCWAP5fXNXB5ukEu5z4PE5oRy
	fUDvK/b4PtSZO76D1i1emaelx9DjZvOtjCU7G6xCmAMRfvTiWwszrq+qPAntaquLHXMMiur8CNE
	sTmhzmzGVaAa1g4P8hiTzclyNhL24Yzo5JhTSpgdXH4F+dnDxbuU9HiMeyWYUP9TqS0WgGp2aZp
	Yk5d2MQu8ZxfovmS/Zj2q7KsoFU9W7my4MD2BqYDX1eBHQG4NJciuPPdkuAnXXch6f7rdWoz0fi
	DDuhKwvCV5iSKmPttua4wv4SzlBwDiqatY2jjjHwVAJ+XSLz7PF4hq
X-Google-Smtp-Source: AGHT+IEe4Ce9FXlVu2kPVcwhzaBZbkaFMwwo+xcYRkopHjSo/+4yLjWlYJ21Dlx9C3qs+SHhovo0nw==
X-Received: by 2002:a17:90b:2d0d:b0:32e:e18a:3691 with SMTP id 98e67ed59e1d1-3436cd0c3b4mr11416880a91.35.1762798786537;
        Mon, 10 Nov 2025 10:19:46 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3434c30bffesm11373484a91.6.2025.11.10.10.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 10:19:45 -0800 (PST)
Date: Mon, 10 Nov 2025 18:19:41 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>,
	kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 01/12] vfio: selftests: Split run.sh into separate scripts
Message-ID: <aRIsvZhxD9kPfX-J@google.com>
References: <20251008232531.1152035-1-dmatlack@google.com>
 <20251008232531.1152035-2-dmatlack@google.com>
 <CAJHc60y=rcbXixxT+dmKebQP3txcQbCDKr_tGrqVxjn9AFHuVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60y=rcbXixxT+dmKebQP3txcQbCDKr_tGrqVxjn9AFHuVg@mail.gmail.com>

On 2025-11-10 08:51 AM, Raghavendra Rao Ananta wrote:
> On Thu, Oct 9, 2025 at 4:56 AM David Matlack <dmatlack@google.com> wrote:
> >
> > If the future, VFIO selftests can automatically detect set up devices by
> nit: s/If/In

Ack

> > +       rm -rf ${DEVICES_DIR}
> Since the cleanup.sh can potentially be run against a single device,
> we should probably check if no devices exist under ${DEVICES_DIR}
> before removing the entire dir.

Oof, good catch. Will fix in v2.

> > +function bind() {
> > +       write_to /sys/bus/pci/drivers/${2}/bind ${1}
> > +}
> Since these scripts reside within the selftests/vfio/ dir, and most of
> these functions target PCI aspects, should we hardcode `vfio-pci` as
> the driver instead of passing the arg around? This is a general
> question/suggestion for the patch. We can even rename it to
> <op>_vfio_pci() (bind_vfio_pci() for example) for better clarity.

This function is also used to bind the device back to whatever driver it
was originally bound to in cleanup.sh. So "${2}" is not always
"vfio-pci".

> > +function set_sriov_numvfs() {
> > +       write_to /sys/bus/pci/devices/${1}/sriov_numvfs ${2}
> > +}
> > +
> Similar to get_sriov_numvfs(), shall we check the existence of the
> 'sriov_numvfs' first? In the current workflow, we indirectly check for
> the file using get_sriov_numvfs() or look for 'sriov_numvfs' in the
> ${device_bdf}. However, an independent check would be cleaner and
> safer (for any future references). WDYT?

I don't think set_sriov_numvfs() should silently do nothing if
sriov_numvfs file does not exist. Calling set_sriov_numvfs() on a device
that does not support SR-IOV indicates a bug in the caller, so it should
fail IMO.

> > +               driver=$(get_driver ${device_bdf})
> > +               if [ "${driver}" ]; then
> > +                       unbind ${device_bdf} ${driver}
> > +                       echo ${driver} > ${device_dir}/driver
> Sorry, what is the purpose of writing the driver's name to the
> "driver" file? Isn't "unbind" sufficient?

So that cleanup.sh can bind the device back to this driver. The goal is
that cleanup.sh returns the device back to the state it was in before
setup.sh. i.e. cleanup.sh needs to undo everything done by setup.sh.

> > +               fi
> > +
> Since vfio-pci can be built as a module that may not be loaded yet (or
> even disabled), do you think it's worth checking before binding the
> device to the driver? Of course, these operations would fail, but
> would it be better if we informed users why?

If that were to happen, I think it will be debuggable by the user.

write_to() in lib.sh always prints out what setup.sh and cleanup.sh are
trying to do. So the user will see something like:

  echo BDF > /sys/bus/pci/drivers/vfio-pci/bind
  Error: No such file or directory

And then the user can go investigate why /sys/bus/pci/drivers/ does not
exist. I think if we try to make the script diagnose why something
failed, that will be an endless game of whack-a-mole and the scripts
will start getting long and complex.

