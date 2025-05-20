Return-Path: <kvm+bounces-47169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B0F2ABE252
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 20:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED8471688CF
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24A827EC7C;
	Tue, 20 May 2025 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="ZR0u9wVD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D751A83FB
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747764547; cv=none; b=glj/fNvcv+azuISM4/Cxvef8Ndn6XQ7TC4EEc716osFnk4+GKPRPkuZ0odD6/6EDPcjeO09yNpljqWAPoAmz0YYgBCMEwMR3GVTqz7lblaJfI684nH0xrYuJeft03+68L0udtrYBpObQ28+/Q2OUasuTrmFkIb4Sv+zj0cZyg0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747764547; c=relaxed/simple;
	bh=BaHb9YepuQP9xeHP9Bjcl5awLxF3SDbjBMq2/oSPwMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RU4iTStK7TXMYcCeViobr3VfBB2stHEfJ6ckWVT2fZsrF15CdRXe6C7VD8N34KWn66B3hs1z3rh1HfaaO5MPSSRHD+25K9SERkvprI+9s9YA4gjL7kvznX9z+eiAF7QFBUwiMskwAZyYFO28SfSXcZPLG+nSKJZ+kDsieq9gbFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=ZR0u9wVD; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7086dcab64bso55539907b3.1
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 11:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1747764544; x=1748369344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WU5udPTppsA55f4dR4/qInsRJDN9j9dX+VCWH1iJNOg=;
        b=ZR0u9wVDuhtIZjvVK6P7ZIx8ZC+Jfsz8zMXZCENHW6Q1spqYxp1fgHcUovF1clzN6x
         jYgRPW0qPRdQCf0YY7SO2qPzJ3JHd0jaHTow8gLRq212/xPIjAZml/bO7eoDghN2nupM
         Q7BPZXwtz2k0DiYbfoHxzbiWCVHkwocI5pAMDf/nO0JhMsKePZUFAGaXZWlABRAVaz2t
         jBHnqBCawJf5RdJYW4foAuahMe/irze9tmjYXphOdDvZwQ1ZUPIzfk/SmvcuzT2A+oX+
         uZLZxHmghka2F7wmJEWFtEQHZwtqcssLUTuJLDc5tQwdVr2Cn9eL3xhxOIY/mfMpw0aU
         S5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747764544; x=1748369344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WU5udPTppsA55f4dR4/qInsRJDN9j9dX+VCWH1iJNOg=;
        b=S+b13fn3ciY+1ceD6u9QsFychZlkSa+k45RJffflIuf93pkNf65lLevpyRjJjj3s4T
         Ae+/l/FkcSrbYHUrntnqG4kcuFSROxTGUrnAalPYR7j3YOaUG2cFhVDXZ9lLux8Y94W3
         o4+ZloQFXyRfGH5A9/hS+Ku3PX8LJ4jqMUhzSaNgaYmgWfJY57KQKrUfgHopcIduP1F6
         5POVlQSf7Iof+sCdDx2afRTUWJBM4g2NPbaL/UTu/K93uHrm2jIb/2TyPVHpQcb9OXA3
         xRx4gZ+JvNFYPyinW/70tE1xOM8aeIr5rirhe8hSPfmh8Swuh7Pc19a2D52TPpqGK+xH
         NkYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCna64TaPOaSx/I11ySqsWRDomWtgLvKG0vUX1wg67k7hL59yViCC7Sck+sxqrYzbrkKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZYzVky9dan+FGPyr5xXZz25tues6+YpDiTd0+6k5bw2xsNAkx
	nUX27xXucBnR427vnRIANldCynWpd+Ky09/rOd0sXpdfk/TX0CbRZoyRJcWnVJ3Y9S3aW9LGm2b
	gc1pzScQgvyQsthC6BBKdeJHkdxLcDE5QaSboJ/q1
X-Gm-Gg: ASbGnctXmiW7kRj6umPlv+OKpC7NWPhfLJmbGdwolHHDviSjdE46k4sAULYvXhXgai6
	pM7ZrcsHFkufeDt4L9HRAQrio5zn16ZqZz8EQ9Pson/1pkhgzVeRRN8A2G3rDfLi9IPhrlwcruz
	Rpqd21WTgLcutvRqbJ5NurFbyIvXAfn1tM
X-Google-Smtp-Source: AGHT+IGNWng09pZ5ljk/Okxa5nCSJCuR564MKYI0xijFRLTiDNOVwhoe3rjTtp+IDNpD1Sbw9/3ctQDVNFoPrswyl9o=
X-Received: by 2002:a05:690c:fc2:b0:70d:ee3b:bec8 with SMTP id
 00721157ae682-70dee3bc898mr20129937b3.16.1747764543919; Tue, 20 May 2025
 11:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <669e1abd542da9fbcfb466d134f01767@paul-moore.com> <20250520163355.13346-1-chath@bu.edu>
In-Reply-To: <20250520163355.13346-1-chath@bu.edu>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 20 May 2025 14:08:53 -0400
X-Gm-Features: AX0GCFs7DIkpyyhcy91W1pEATOT-GDHk2nbEDGbNZtBIXc8wd9A2olpvkvz8kXw
Message-ID: <CAHC9VhTx72aCwfR7rOCmsscEJBPHkDqdsJePGP6eW=DE0ZUSWA@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] audit accesses to unassigned PCI config regions
To: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
Cc: Yunxiang.Li@amd.com, alex.williamson@redhat.com, audit@vger.kernel.org, 
	avihaih@nvidia.com, bhelgaas@google.com, chath@bu.edu, eparis@redhat.com, 
	kevin.tian@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	schnelle@linux.ibm.com, xin.zeng@intel.com, xwill@bu.edu, yahui.cao@intel.com, 
	zhangdongdong@eswincomputing.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 12:34=E2=80=AFPM Chathura Rajapaksha
<chathura.abeyrathne.lk@gmail.com> wrote:
> On Fri, May 16, 2025 at 4:41=E2=80=AFPM Paul Moore <paul@paul-moore.com> =
wrote:
>
> > In the commit description you talk about a general PCIe device issue
> > in the first paragraph before going into the specifics of the VFIO
> > driver.  That's all well and good, but it makes me wonder if this
> > audit code above is better done as a generic PCI function that other
> > PCI drivers could use if they had similar concerns?  Please correct
> > me if I'm wrong, but other than symbol naming I don't see anyting
> > above which is specific to VFIO.  Thoughts?
>
> While the issue is independent of VFIO, the security and availability
> concerns arise when guests are able to write to unassigned PCI config
> regions on devices passed through using VFIO. That's why we thought it
> would be better to audit these accesses in the VFIO driver. Given this
> context, do you think it would be more appropriate to audit these
> accesses through a generic PCI function instead?

I would suggest a generic PCI function, e.g. pci_audit_access(...),
that lives in the general PCI code and would be suitable for callers
other than VFIO, that you can call from within vfio_config_do_rw()
when Bad Things happen.

Does that make sense?

--=20
paul-moore.com

