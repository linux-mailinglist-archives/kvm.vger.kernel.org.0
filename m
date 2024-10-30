Return-Path: <kvm+bounces-29985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE92D9B58B9
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 01:39:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F24111C22B7E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 00:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6E02208A9;
	Wed, 30 Oct 2024 00:38:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64468199BC;
	Wed, 30 Oct 2024 00:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730248739; cv=none; b=Pr19rai5e8xvm/hAsLTzfb8TqOhHWaCTzQHbwQJZJybKJ6s6GlvKAlj75+qW9NWSvnI8VBFaxOtmUdYT04Fh1ovHIYSFRgdRrjQ8wF5+pqNaJsAqc0u4wm2abizWDEapQgSjvIVjY3vMQIr2ZBf0LeuukrZAUaRK4+88Pt0VmWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730248739; c=relaxed/simple;
	bh=rkksetQkS32x1ce8YQ4WQNe3ZEDMkXX61wVutmiE07I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L0PSEMUXndp/9nbmsTcgQmAR3rckuw/dm25r2XTJ/kKHg+MwUwSMSE2ao1wfNmvZnDgAqB6hYCujhtszIT5yr68do5Xr2aIoct/7kVagTX/kSx5SQ9T8zFhp/aScGGBD78/C6gt0LUR8sGlCLyw4hzPKisNCP1H5eCM+9Y+8nGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6e38fa1f82fso55081777b3.1;
        Tue, 29 Oct 2024 17:38:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730248736; x=1730853536;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rkksetQkS32x1ce8YQ4WQNe3ZEDMkXX61wVutmiE07I=;
        b=bPjsfRST/4pUevcq5kOgjFhXJ2i6/NIcKtq6AgHXQLo8RkCqpvzeuC+mY14QhxSAcj
         3AxkBYs+lx9bhI8tEPMiWmtbgVblSAvL6y8V0jkMNXqfm8o4wa/V4UHlxj4vGf24fO6Y
         0CBNQHnpdnSIJWh1CJvNBTsRXxYKn8Cb4q10sFDMdQvRtxw3MAQkqohi/NGmKJoEl+j0
         jzh/CNnCJmHNqQfCs5JfoY2t9vCBMChIzAMNosjk3H26ox+W8npY5/QGNWdFkkHcWQRS
         IwYuiWLfmDoRDlO/HtUd49kMcsQ5M9nt13AEBEH40Csdr517SAxGQAB0Xp2lpr/hMd5E
         vD1g==
X-Forwarded-Encrypted: i=1; AJvYcCWpRlZeA7xesGazaeNxxApE2v8SeeFm3pVcB60ATzDHCL/1wSAt09VUPhA0U4M+OL2JqICZ@vger.kernel.org, AJvYcCWqu4No6XJj4V0senBAa6o/lpGqoLsv0eKuzMJGgT57CQxed6OoOZjlqxTCjWziOFEv4XhRoNzmqjF651E0@vger.kernel.org, AJvYcCXHulqmR+Zsiu75dwlZAVuwkx5MOqbxdBuvfBIMdSfn94sMlxDUzxFWX5BcxmQV8vBtMYp7//xV@vger.kernel.org
X-Gm-Message-State: AOJu0YxOf11sMHiyrkvLZ01sO03YCLmgRQjzHyQ3Z0A2CuMSCWws0Ozy
	iANlvVTpv1keaRTl2AQvb+7owxdisS+4O6z+inJjK535T+11ld1g8pDUQw==
X-Google-Smtp-Source: AGHT+IHr7Z4HK0mHflR6XwefGKtCLEos/0zl2k3Hx703kVhDOm+HsXucC18OA4YqBEO5tT3tkukwww==
X-Received: by 2002:a05:690c:10c:b0:6ea:29cb:970f with SMTP id 00721157ae682-6ea29cbedd4mr40702457b3.43.1730248736172;
        Tue, 29 Oct 2024 17:38:56 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e9c6c989f6sm21957117b3.130.2024.10.29.17.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 17:38:55 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6e38fa1f82fso55081607b3.1;
        Tue, 29 Oct 2024 17:38:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUUmzpaYapoPQTXaymlXEvsQ1By3Pix44XiIi8oNJLPbuAccvLrRrSUBoAMBiSUEnVEqeRVsdU1ZTruzG60@vger.kernel.org, AJvYcCWdAW5i1W+AHxP7O3f2rtF3hVLUg/tEZk8JEkuhwPgoAxD08GC2rhpOg74Bb5B93x3V+TprQzJp@vger.kernel.org, AJvYcCXmN4nQiqYu5axzwv96YQ7PcB32yKVzK2ZvJr6cQKk5zTynuuB3PNPfS0RZ8OednWu9yQi2@vger.kernel.org
X-Received: by 2002:a05:690c:eca:b0:6ea:2ac4:9e85 with SMTP id
 00721157ae682-6ea2ac4a180mr46049427b3.1.1730248735120; Tue, 29 Oct 2024
 17:38:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZyAnSAw34jwWicJl@slm.duckdns.org> <1998a069-50a0-46a2-8420-ebdce7725720@redhat.com>
 <ZyF858Ruj-jgdLLw@slm.duckdns.org>
In-Reply-To: <ZyF858Ruj-jgdLLw@slm.duckdns.org>
From: Luca Boccassi <bluca@debian.org>
Date: Wed, 30 Oct 2024 00:38:43 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnQ79RRXGi11a3KO6Y2FcpVGL4adAT9yAKb2AK5Z2=1YSw@mail.gmail.com>
Message-ID: <CAMw=ZnQ79RRXGi11a3KO6Y2FcpVGL4adAT9yAKb2AK5Z2=1YSw@mail.gmail.com>
Subject: Re: cgroup2 freezer and kvm_vm_worker_thread()
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Roman Gushchin <roman.gushchin@linux.dev>, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 30 Oct 2024 at 00:25, Tejun Heo <tj@kernel.org> wrote:
> If that can't be done, we can add a mechanism to ignore these tasks when
> determining when a cgroup is frozen provided that this doesn't affect the
> snapshotting (ie. when taking a snapshot of frozen cgroup, activities from
> the kthreads won't corrupt the snapshot).

What do these kvm kthreads actually do?

So one of the use cases in systemd is to freeze the entire user
session before suspend, so that the encryption key for the home
directory (homed) can be removed from memory (until after resume,
after the user has typed the password in the screen lock again),
without the risk of having programs trying to access the now
inaccessible files in the home directory. So if qemu is frozen, but
the kvm kthread is not and somehow lets the VM or part of it still run
and use files (e.g.: write to the disk image that is stored in the
homedir) that are now inaccessible, that would be problematic for this
use case.

