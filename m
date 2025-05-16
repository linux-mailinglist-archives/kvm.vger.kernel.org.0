Return-Path: <kvm+bounces-46848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 652F0ABA2A4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 20:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7A6F1B630C5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 18:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B0327BF95;
	Fri, 16 May 2025 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTrNSVJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2711547C9;
	Fri, 16 May 2025 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747419487; cv=none; b=mTxJ0C/6loQXtaBqHWvtE+u7KFMegQNvqZ+p6NG7UdZ0E0Yjy5uv/hQLjIiAKfNkqu8INay3TrONrn4qrSSpmGIqZgw1XVwjdYeRdv+9NyMkXIOMNQhwkrcZNPW2L2uk+TYSdQUjeHxGa03cCDGuIhzLNWbdOy4YRJF60QCcAr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747419487; c=relaxed/simple;
	bh=cOVJifAOKkgfglWuMdO1Rvc0JWJU2TdrcFrHkX83Zr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jCLWzI6H803281PZcMqttdDDvylguCi2UKFtLFEfbyeOCH9iBOEqvqt0jHluhTTTVDKtqpbdCyjshtweAZeKhp+DL712id7/pVhD5nCgsi3kkfQxcv01U1ZsIo39IcZFv0J3So9/A9PPJNnF8KbQqytPI9WUQ0Yt+lf+cGhRGiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTrNSVJ3; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e732386e4b7so2630228276.1;
        Fri, 16 May 2025 11:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747419484; x=1748024284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOVJifAOKkgfglWuMdO1Rvc0JWJU2TdrcFrHkX83Zr8=;
        b=jTrNSVJ3qq2k7IFeUvnKSL5Vcxr1DpxTrqODySDe7TE6H5s4chCV0t51Yfb+Y/m1E7
         gbIcwOjwTQVSSeTtMN8xPUSbeectk6iuQbLVBT4Quq7Idi2gZCgNPxJ7KF2tGa6SZhhh
         333lTNPvaYXh58pR0H/X25QIpUZYOFSSsygh1Jdk0tJXwcxFrXhpEeO09fkqNy6iAfgr
         q2IsjlGgsHQ1HUw/0GzxA+2fZ2AX0B0VSboJIkdeZ54ihl9eG8pML27BZJgvyOj7czm4
         qzq+m4f0/vpzo3V+DIbZQROxJvPHKBesbIWgGxIlT7S5Ue9OQmR4O4SMC4DeUaTMiyJg
         I0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747419484; x=1748024284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cOVJifAOKkgfglWuMdO1Rvc0JWJU2TdrcFrHkX83Zr8=;
        b=cANvC3R97XAByDQTY1/GuWTvb8GzruSVapD6RSn3mwVUE8KQAIfSE0oQy3dsoL/UTv
         ixW0iBot6APGTxWEdk+kVP3dcw7F8A0n0DkcpojxjDUogzkwazAG4ViOR+5UHrpFTzcw
         74NkkXP4CmVvFrLTrfch7owOHfxL1hYSOVKIkDwGOC1IJY4h7TktWD1jSMb5b7mirDYk
         fLQJVgHjs9xJVwrYKUXKvanebk+UH/qbMUiC0DPsX2VmVq7WJA825rslRhjmiUrnjkF0
         NihQ8hY21fFTxAmpt+am6chibRpiw69oLfl0vgOEL9T/5fld2xNxyPHSyF1qz8YxooAU
         ZWPg==
X-Forwarded-Encrypted: i=1; AJvYcCUVfg094ZC6FPTL6568IJlV/TadXJclTQo3ki0/qZg5nBCpZ1k8SjQRj6MyXgf37e7U7fUP@vger.kernel.org, AJvYcCW9HvsccTswntTKPuisHwRVJXK505rGxtyYmlY50PWAzUOisgwCEosjGJnJZFlT0tXSUAlsJOTyxsD/rSej@vger.kernel.org, AJvYcCWce7b1oiI4nMnI7JVB8q5gj8P3s8wv09K4dPHQcNVbXxGqTZA9xEbCH04aXyw/dmLscAmFqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtXZH6RpSVmqqh0DfzH6coIa9JC1RC7yP+xIORs1g5RAHf5HCS
	F3e6xPfR874frLtgukZUipYAXG620+BGie9h4Rgq3eTpAN62rxYLFngV
X-Gm-Gg: ASbGncs8g8zoHO60IjiDK1iMMcWLbWhI24sUx62RwuzjyYad1beMr0aQ/kdVHd7oqvl
	vONOzPyoEgHxL0K+dQKPi03Ad1TrUC+AhkHqsvDT7iUU2cKhkgDLiKPmXGgpdMBhXAtgoRvJ7cd
	r+0Jxr6IclAT/4DlHmgoKXQ1z7Bx0lPlE3m5mUgzOPuYK3w/8slAnoG7dW58FyMhY9uSBVrTVdA
	XBbZ2jcgywWVY5WEBibxaZzeM/+ZScoyzieSVJccy0JhEbcG7GTvg5Bk46BxzJwWfKfg6YzBi+z
	XSd9gC/y5EnzQ4xWc2xeORpGBtXR2xIHV5RTejkIf/d9IFfcrZlRX/iJiFgVcuDbl9HYAxl1bCy
	J6GVFN+M/4GL5zHu51JOdSbMXTcAA
X-Google-Smtp-Source: AGHT+IFg4SVeF1nkllpnnckIcQ27PUkeLDLWxWkuBT+D/NpxGX21o4kenkdJCNNoY2uLqASSjw9AZw==
X-Received: by 2002:a05:6902:1b09:b0:e79:7ba6:f8d with SMTP id 3f1490d57ef6-e7b6d3bb248mr4919654276.7.1747419484486;
        Fri, 16 May 2025 11:18:04 -0700 (PDT)
Received: from master.chath-257608.iommu-security-pg0.clemson.cloudlab.us ([130.127.134.87])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e7b6ac88539sm700971276.19.2025.05.16.11.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 11:18:03 -0700 (PDT)
From: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
X-Google-Original-From: Chathura Rajapaksha <chath@bu.edu>
To: jgg@ziepe.ca
Cc: Yunxiang.Li@amd.com,
	alex.williamson@redhat.com,
	audit@vger.kernel.org,
	avihaih@nvidia.com,
	bhelgaas@google.com,
	chath@bu.edu,
	chathura.abeyrathne.lk@gmail.com,
	eparis@redhat.com,
	giovanni.cabiddu@intel.com,
	kevin.tian@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	paul@paul-moore.com,
	schnelle@linux.ibm.com,
	xin.zeng@intel.com,
	yahui.cao@intel.com,
	zhangdongdong@eswincomputing.com
Subject: Re: [RFC PATCH 0/2] vfio/pci: Block and audit accesses to unassigned config regions
Date: Fri, 16 May 2025 18:17:54 +0000
Message-Id: <20250516181754.7283-1-chath@bu.edu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429134408.GC2260621@ziepe.ca>
References: <20250429134408.GC2260621@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Jason and Alex,

Thank you for the comments, and apologies for the delayed response.

On Mon, Apr 28, 2025 at 9:24 AM
Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > Some PCIe devices trigger PCI bus errors when accesses are made to
> > unassigned regions within their PCI configuration space. On certain
> > platforms, this can lead to host system hangs or reboots.
>
> Do you have an example of this? What do you mean by bus error?

By PCI bus error, I was referring to AER-reported uncorrectable errors.
For example:
pcieport 0000:c0:01.1: PCIe Bus Error: severity=Uncorrected (Fatal), type=Transaction Layer, (Requester ID)
pcieport 0000:c0:01.1:   device [1022:1483] error status/mask=00004000/07a10000
pcieport 0000:c0:01.1:    [14] CmpltTO                (First)

In another case, with a different device on a separate system, we
observed an uncorrectable machine check exception:
mce: [Hardware Error]: CPU 10: Machine Check Exception: 5 Bank 6: fb80000000000e0b

> I would expect the device to return some constant like 0, or to return
> an error TLP. The host bridge should convert the error TLP to
> 0XFFFFFFF like all other read error conversions.
>
> Is it a device problem or host bridge problem you are facing?

We haven’t been able to confirm definitively whether it’s a device or
host bridge issue due to limited visibility into platform internals.
However, we suspect it’s device-specific, as the same device triggered
similar failures across two different systems when writing to a
specific unassigned region in its config space. That said, we haven’t
exhaustively tested across devices and platforms.

If you have suggestions for identifying whether this stems from the
device or host bridge, we’d appreciate the guidance.

On Mon, Apr 28, 2025 at 4:26 PM
Alex Williamson <alex.williamson@redhat.com> wrote:
> Or system problem.  Is it the access itself that generates a problem or
> is it what the device does as a result of the access?  If the latter,
> does this only remove a config space fuzzing attack vector against that
> behavior or do we expect the device cannot generate the same behavior
> via MMIO or IO register accesses?

Unfortunately, we can't say for certain whether the fault lies in the
access itself or in the device's response. The cloud environments we
tested on don’t provide sufficient low-level hardware insight to
determine that. Please let me know if you have any pointers on how to
determine this at the kernel level.

This patch specifically aims to eliminate the config space fuzzing
vector. We have not investigated whether similar behavior can be
triggered through MMIO or IO register accesses.

> > No module parameters please.
> >
> > At worst the kernel should maintain a quirks list to control this,
> > maybe with a sysfs to update it.
>
> No module parameters might be difficult if we end up managing this as a
> default policy selection, but certainly agree that if we get into
> device specific behaviors we probably want those quirks automatically
> deployed by the kernel.  Thanks,

We used module parameters to give the flexibility to block unassigned
config space accesses on specific devices, especially in cases where new
problematic devices might emerge.

Is it feasible to support such use cases using a quirk-based mechanism?
For example, could we implement a quirk table that’s updateable via
sysfs, as you suggested?

Thank you for your time, and again, apologies for the delayed response.

Thanks,
Chathura

