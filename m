Return-Path: <kvm+bounces-62231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 062FAC3CC7E
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 18:19:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78402188B47A
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 17:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213F5351FBB;
	Thu,  6 Nov 2025 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w4AKHo3S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFFD34F25E
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762449474; cv=none; b=RvSw9d/7JEF+F498yyqjk2jP+bFT5COUhAJxE219wZwolXj+hHF1ldmwfJg92h/AQEsw1ut2Cvj3xJAN2vkS0CJY250D+lhL+tW4pNs/wYNUy8q5lU4u2r0FkqwAUQuiq95zKo1I5MTF1d4vA2+V5pQFm5vWbZSkpDL7iYuteFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762449474; c=relaxed/simple;
	bh=UJl3TI/ILL+L2NZ+C5cZaJQp+uHS3WBY0UUH6UoHN8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlyvyRFmLEgtCCOJxJuo2E8rElnBZWuljgOs0/11V7W2Pbk6lr2r42/UpKgjo+GPf3x3vV6MvSzBUlAlUG+lVvH4e5olQGHd94L98+oYJ/YZKXcAp4SsUWnGH+COCUBeZ4XZEWuyIiJfIFV19/ctBTa5Pd3YdfWRArtCThCcb6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w4AKHo3S; arc=none smtp.client-ip=209.85.216.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-33db8fde85cso1139510a91.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 09:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762449472; x=1763054272; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e8rOmUB/Qab4XNuUxUB9H9N1Hcl6ltErOzE5ty1KzV8=;
        b=w4AKHo3S9eS/LeesnMUfXSDs1G0dLnrETNoCEg2s9Q9m0k86V2W/T4wfmli9HQ7cXH
         s+34AYGUN1hzBM0/wWgMu7RmRHyz1xpFL2dAyxu2MhMtlkbi6BEtdA818n3iFBU/SvJR
         nP7PAldxBu4nZ1FnHvUZRK5DrgyynjOZkCQMbjAQesWuHPZ9cNHUQY6zComg44CdCzAE
         nXQ5Og7BJNyv5HgqXGQGzyKh0+EgoSN/16X0GZCKsgugp1PAJYEwKBJL4fiWHprI88Sj
         YtUczu8xnDKGq546Nfl1sAyILPr4fdIW6Myk8MqKdKwQTdkIdE0/jJZqMKH0JSaAVg1g
         JC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762449472; x=1763054272;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e8rOmUB/Qab4XNuUxUB9H9N1Hcl6ltErOzE5ty1KzV8=;
        b=V+etsVXOSKnDw70ZkHQKMzOcZUeRz16hKuBMWrxyUHPN/cBF+pG/FhkKydW0rKRtx0
         2AahKpvMta0lC8HcRZb5ct9XGLWWae9FKjar4cWiR8Q2+FoWEmypRFKCW+aOe61hRY3+
         oaPRPKFUg4YXRR72bczOJww6+L5ubQ6PjSKHkAvdgVnYm/1zgsgJYItyqdgI7jRKfhbX
         cvkn6Pvs3S0p4FqpJ1nmWwasMkhweQ1TVu10237zOELdhptmv/yOxv27IlUt7zCVuTj3
         RaxPng48bfLlJqcUewR/Q50CpfROXfI2WG/yAbP2yH6GDxSLQA/9VE8T+gCKxcpWsPDs
         yB7g==
X-Forwarded-Encrypted: i=1; AJvYcCXz43ZAlViFq1ztpDkFj0T8TS8yLuHwkOY9YqNZ5lEv4DlJamGH0fkLYYFuG1a2RfLnBp4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdE679iyj1/93RWPIbxLAWQhpkGQDWsvE6kY+/1XM9bAcuSEQW
	jdr5UPvlyFcTe3RH3Jno0ByoUMwzgdwM/m4Fg1R7Xnrtrx5A/MPqaTRa9UUDP92Avw==
X-Gm-Gg: ASbGncv0v5kjbt3TqCxzzmr1fR5e14NAjoWgMfyR82yiSu5vAhvFmY2JMwrrW10mPJy
	2eMjt2YwHnENDeIVAvEa2VcIJ/wJ1oDA4dUuMaPi2oAUksdnzHYqHfUj64apBPxShbTOAoVFt/R
	De/kW1eW8bRlYA11MAIXWWe1+b2pLVLIwHXdDWULxc7EMYh3ejSkaHjMQ2hj8RwKXNAcSIPmmJK
	XEGCvgeMTWUY/UUzvVo9p/cUmy2dApK9LKVrsHGjWIa48+86iWeDpRng5hpF4nH3nvAawz2G8M6
	L/D3seXHm5ntFSBNmh8hEYT/cr3msNkxzEbGuLxwiPiwyF7+DVQ7pPPvbg4xzUltM4J+bVfU4EV
	8xrhM6U2GRuQfSRCrm5LeX/ffYaSTKA6WMpvujFyi2I+tHDOntIQDiXvlDKSQY326/et/KCU8Zc
	NiBfslw7hTJzjXYyyptF1Yz0IzBrfxrhXqOOZNLAwmIplwVU+nlkr0
X-Google-Smtp-Source: AGHT+IF5dm3b+TfCvr+idRK4WAQL6ailGdHxqBosbW+mh5LC8pP1b83d5wfZFY8YbKRvEpQzBtUNuQ==
X-Received: by 2002:a17:90b:48ca:b0:340:bfcd:6af8 with SMTP id 98e67ed59e1d1-341a6bfb6bdmr10106676a91.4.1762449471620;
        Thu, 06 Nov 2025 09:17:51 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a699c98dsm6825962a91.17.2025.11.06.09.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:17:50 -0800 (PST)
Date: Thu, 6 Nov 2025 17:17:46 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
Message-ID: <aQzYOjWPs0qsW4YR@google.com>
References: <20251104003536.3601931-1-rananta@google.com>
 <20251104003536.3601931-2-rananta@google.com>
 <aQvjQDwU3f0crccT@google.com>
 <CAJHc60xb_=v9k46MEo=6S5QmMXKnd_1FiuWQr9dkCnE_XtTkfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60xb_=v9k46MEo=6S5QmMXKnd_1FiuWQr9dkCnE_XtTkfQ@mail.gmail.com>

On 2025-11-06 09:56 PM, Raghavendra Rao Ananta wrote:
> On Thu, Nov 6, 2025 at 5:22 AM David Matlack <dmatlack@google.com> wrote:
> > On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> >
> > > -struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_mode);
> > > +struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> > > +                                           const char *iommu_mode,
> > > +                                           const char *vf_token);
> >
> > Vipin is also looking at adding an optional parameter to
> > vfio_pci_device_init():
> > https://lore.kernel.org/kvm/20251018000713.677779-20-vipinsh@google.com/
> >
> > I am wondering if we should support an options struct for such
> > parameters. e.g. something like this
> >
> > diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
> > index b01068d98fda..cee837fe561c 100644
> > --- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
> > +++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
> > @@ -160,6 +160,10 @@ struct vfio_pci_driver {
> >         int msi;
> >  };
> >
> > +struct vfio_pci_device_options {
> > +       const char *vf_token;
> > +};
> > +
> >  struct vfio_pci_device {
> >         int fd;
> >
> > @@ -202,9 +206,18 @@ const char *vfio_pci_get_cdev_path(const char *bdf);
> >
> >  extern const char *default_iommu_mode;
> >
> > -struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> > -                                             const char *iommu_mode,
> > -                                             const char *vf_token);
> > +struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
> > +                                              const char *iommu_mode,
> > +                                              const struct vfio_pci_device_options *options);
> > +
> > +static inline struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> > +                                                          const char *iommu_mode)
> > +{
> > +       static const struct vfio_pci_device_options default_options = {};
> > +
> > +       return __vfio_pci_device_init(bdf, iommu_mode, &default_options);
> > +}
> > +
> >
> > This will avoid you having to update every test.
> >
> > You can create a helper function in vfio_pci_sriov_uapi_test.c to call
> > __vfio_pci_device_init() and abstract away the options stuff from your
> > test.
> >
> I like the idea of an optional expandable struct. I'll implement this in v2.

Just to make sure we're on the same page: I don't think you need to add
this in v2 since you don't need to call vfio_pci_device_init(). For the
inner functions that you want to call from your test, passing vf_token
directly makes more sense IMO. vfio_pci_device_init() will just pass in
NULL to those functions for vf_token by default.

If/when we want to pass vf_token to vfio_pci_device_init() we can add
the options struct.

> > No space necessary after a cast. This is another one checkpatch.pl will
> > catch for you.
> >
> >   CHECK:SPACING: No space is necessary after a cast
> >   #81: FILE: tools/testing/selftests/vfio/lib/vfio_pci_device.c:338:
> >   +       char *arg = (char *) bdf;
> >
> Actually, I did run checkpatch.pl on the entire series as:
> .$ ./scripts/checkpatch.pl *.patch
> 
> I didn't see any of these warnings. Are there any other options to consider?

Ah, I run with a few additional options. That's probably why we are
seeing different output. Here's what I have in my .bashrc:

function checkpatch() {
        scripts/checkpatch.pl \
                -q \
                --strict \
                --codespell \
                --no-signoff \
                --show-types \
                --ignore gerrit_change_id,FILE_PATH_CHANGES,NOT_UNIFIED_DIFF \
                --no-summary \
                "$@"
}

