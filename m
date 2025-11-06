Return-Path: <kvm+bounces-62232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F116C3CE1C
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 18:39:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 83E734EC104
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 17:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D08534DCEE;
	Thu,  6 Nov 2025 17:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CjTzGeZX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDD33254A6
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 17:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762450507; cv=none; b=LuROXTV8IzGarE4CyzdYhI/Em1TlKE2jDuQ+ONU/7V3pEVYYy/2oY2Oyv5gY6Tk1rbxBR/p9kKnnB8ROtHWxTW51n1qPPmW6V76BA6DabFd5c51MHo+fNAgufwhj3td2hUav+so0HYuzcbM3a+lCHsXz9HW20HWmfdxwsVWo9Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762450507; c=relaxed/simple;
	bh=zuH8vTEFQ81y0S9J2aMAnZJU8ZzAWmEuKbor7lXFpuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hti4PuWsVQZlmfCWS6dCaP6afratpHFK6/2mxSYQRO7y61LcLELEat5U85Cy00m/Cigq4s1FHUFW+NONVwOT9H8RKWj7M9khPnSFQHD+OY4ewtJB9xnIWFJYBJU8bgeCD5k40Ubb0488xqng43xrsWZeIrC0eKcXiihnQ4fv3cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CjTzGeZX; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-341c68c953bso1658355a91.1
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 09:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762450505; x=1763055305; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wqhRMbkeP5a6AhGXE/N+V0jVQXSY8bQ8HANY/uvlWJg=;
        b=CjTzGeZXQBYGpmPqpKVPSnVlaza3aGHJlLKRN7YTmp8JyVrLQfKvc6GMzagjLXJ+4P
         I+SCgC16TkeXmWOHrDuTfKRLsH3L+kv6mnO1Vt1kXwHt/nShOlpCa4I3rXtHHJm6+NSB
         pySO6vdgeoI4ss9uEvWcfq4QEZSL3LOL/kf+LB8LpD//Wonyqnk3NPH26G1gOgXT3WtW
         ujhioDza+TSgkT0a5v2Ac/qZeILjzpnJDJZUzUb93iySZWGg/xi1OXZ5aM9d+UHim5ht
         QsyHSdsJkHZTJX597NttpG4dTSo0IgmomO71D8J5VydDEIpfzXI5G97c/UFTuHZjIf8y
         UeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762450505; x=1763055305;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wqhRMbkeP5a6AhGXE/N+V0jVQXSY8bQ8HANY/uvlWJg=;
        b=uGwLv3SkoQJIoaYDnQfNA1F1ueyegkaHgxsFNkA9ay9aQ0pWEYOlGI1H+r2JY4wYue
         8eJ5gs6Ht3zaYMyIUDNk3DWLHJpPU5eDc9MZy63k73wGr/75ELMau2hO4gqijj5GSNyv
         IFQkXnxlRxsaH4VuJu2BhyR1T16QQQtxG1vSgeGFzpJJunIKVoQWxDyE3g3jOExW73dB
         Q3uL7QZLaPznAxqeCtIbB9HUEJxgvU8kD1OJ7GOpZBnFrGMSZPCTIGDybimYUaXY0gXY
         jApOkMH/MqEmbF0I4VzZA98qZErUMPqv3KfGuPBly1tb3j4IgeBeTxOYd4BisDHHe+TZ
         sDlw==
X-Forwarded-Encrypted: i=1; AJvYcCXFt8v1TMRbuJVsmM/3UmyebcIMtJ30F1epxLwQ2MbZYpcx41GU+J2Cfj3T/nJFq3PJSnk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtUaJPljWhkX2VynCicIXufaVzoqSehcQ7bPf5NaUmYyNpZOnl
	lu53gWD+IXjNdOClQ+mS0d46m3lxme5iapLsS9YO/dDFw1g2bGScJeu/+HzBU1eUcg==
X-Gm-Gg: ASbGnctb8V+UBQeFk3DWgEQB/LX+ucMxpY5vZLt+dL21+e9Kc5YMiN9s5Vb5erndJcf
	wlnw2FEtOEVMjcwk5ub5KzIgzxiJWqtXINGHnlQ0r3BDd/PyWC2vjVz6LN6E86biApXxbHAFwcV
	IbCvLEevZ/K/F/dpYhIfO9cVCnd52SIdhw8VNLPqjMcP9ub8Z/ilvjIf6zJo0e4/3rzY8o5242+
	Qq9myVzVGToi7igxLxG88vTR/lTpyFQQaejmNewVsS8eLKm+z+bR6H0LhwlTtGWckqRNYFUxton
	63gJcuzq4dcnOPsYFK3Gy/bizazjJnWxxRyDK1/NpZkDtqCnBLYBRsVR2tAG1UIa7i5+VAzFEjP
	hV80fcOeKbjtXquAb8iXOa2D5y03qmuQoyQ7mKnm3Y2wuQOctw1fgSs9z8VPdrpsYCB8mWS/VBI
	Z4aWfs3TikfmaHLWSlm78Q4zNddvdryR7McfhveQ1w9e4vOtvHjORn
X-Google-Smtp-Source: AGHT+IEMuhZXfrhRzZPgDXKf74LCucNnT8xcoW50rzL12P2WEHwgK0T6/7gvoTOtnyJThJPPYu//JA==
X-Received: by 2002:a17:90b:4c0f:b0:341:8adc:76d2 with SMTP id 98e67ed59e1d1-341a6d5aea7mr11537455a91.16.1762450504826;
        Thu, 06 Nov 2025 09:35:04 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3434c3566e7sm35903a91.19.2025.11.06.09.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:35:03 -0800 (PST)
Date: Thu, 6 Nov 2025 17:34:59 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] vfio: selftests: Add tests to validate SR-IOV UAPI
Message-ID: <aQzcQ0fJd-aCRThS@google.com>
References: <20251104003536.3601931-1-rananta@google.com>
 <20251104003536.3601931-5-rananta@google.com>
 <aQvzNZU9x9gmFzH3@google.com>
 <CAJHc60ycPfeba0hjiHLTgFO2JAjPsuWzHhJqVbqOTEaOPfNy_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60ycPfeba0hjiHLTgFO2JAjPsuWzHhJqVbqOTEaOPfNy_A@mail.gmail.com>

On 2025-11-06 10:35 PM, Raghavendra Rao Ananta wrote:
> On Thu, Nov 6, 2025 at 6:30 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> >
> > > +static const char *pf_dev_bdf;
> > > +static char vf_dev_bdf[16];
> >
> > vf_dev_bdf can be part of the test fixture instead of a global variable.
> > pf_dev_bdf should be the only global variable since we have to get it
> > from main() into the text fixture.
> >
> My understading is placing vars in FIXTURE() is helpful to get an
> access across various other FIXTURE_*() and TEST*() functions. Out of
> curiosity, is there an advantage here vs having them global?

Global variables are just generally a bad design pattern. IMO, only
variables that truly need to be global should be global.

The only variable that needs to be global is pf_dev_bdf.

Since vf_dev_bdf needs to be accessed within FIXTURE_SETUP(),
FIXTURE_TEARDOWN(), and TEST_F(), then FIXTURE() is the right home for
it. The whole point of FIXTURE() is to hold state for each TEST_F().

> 
> > > +
> > > +struct vfio_pci_device *pf_device;
> > > +struct vfio_pci_device *vf_device;
> >
> > These can be local variables in the places they are used.
> >
> I was a bit greedy to save a few lines, as they are reassigned in
> every TEST_F() anyway. Is there any advantage by making them local?

It's easy to mess up global variables. And also when reading the code it
is confusing to see a global variable that does not need to be global.
It makes me think I must be missing something.

As a general practice I think it's good to limit the scope of variables
to the minimum scope they are needed.

> > > +     snprintf(path, PATH_MAX, "%s/%s/sriov_numvfs", PCI_SYSFS_PATH, pf_dev_bdf);
> > > +     ASSERT_GT(fd = open(path, O_RDWR), 0);
> > > +     ASSERT_GT(read(fd, buf, ARRAY_SIZE(buf)), 0);
> > > +     nr_vfs = strtoul(buf, NULL, 0);
> > > +     if (nr_vfs == 0)
> >
> > If VFs are already enabled, shouldn't the test fail or skip?
> >
> My idea was to simply "steal" the device that was already created and
> use it. Do we want to skip it, as you suggested?

If a VF already exists it might be bound to a different driver, and may
be in use by something else. I think the only safe thing to do is to
bail if a VF already exists. If the test creates the VF, then it knows
that it owns it.

> > > +FIXTURE_TEARDOWN(vfio_pci_sriov_uapi_test)
> > > +{
> > > +}
> >
> > FIXTURE_TEARDOWN() should undo what FIXTURE_SETUP() did, i.e. write 0 to
> > sriov_numvfs. Otherwise running this test will leave behind SR-IOV
> > enabled on the PF.
> >
> I had this originally, but then realized that run.sh aready resets the
> sriov_numvfs to its original value. We can do it here too, if you'd
> like to keep the symmetry and make the test self-sufficient. With some
> of your other suggestions, I may have to do some more cleanup here
> now.

I think the test should return the PF back to the state it was in at the
start of the test. That way the test doesn't "leak" changes it made. The
best way to do that is to clean up in FIXTURE_TEARDOWN(). There might be
some other test that wants to run using the PF before run.sh does its
cleanup work.

> > You could also make this the users problem (the user has to provide a PF
> > with 1 VF where both PF and VF are bound to vfio-pci). But I think it
> > would be nice to make the test work automatically given a PF if we can.
> Let's go with the latter, assuming it doesn't get too complicated
> (currently, the setup part seems bigger than the actual test :) )

Let's create helpers for all the sysfs operations under lib.

e.g. tools/testing/selftests/vfio/lib/sysfs.c:

  int sysfs_get_sriov_totalvfs(const char *bdf);
  void sysfs_set_sriov_numvfs(const char *bdfs, int numvfs);
  ...

That will greatly simplify the amount of code in this test, and I think
it's highly likely we re-use those functions in other tests. And even if
we don't, it's nice to encapsulate all the sysfs code in one place for
readability and maintainability.

If you do this I think there's also some sysfs stuff in
vfio_pci_device.c that you can also pull out into this helper file.

