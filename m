Return-Path: <kvm+bounces-50529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DFD5AE6E60
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EAE15A7AA9
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE962EA16B;
	Tue, 24 Jun 2025 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="pGumHYEw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FCD2E9729
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 18:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750788774; cv=none; b=KkvzR0HfjoberDT5pNljx6f6v0EM0EAtQd4I+uY9ZtJuftoDbnI7gAhfelOhLjcO4vyhM310nvmJMTlrdktAeRdS0V8Tnc3cN+DsIMlcFjwnhgVyMBxdpubvMytlQ0MhwADV6UCwQcAG1cBpu2SJrlbkRgCrqy279UNQg49duwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750788774; c=relaxed/simple;
	bh=1RMvRPlD1Tqj4JYT7g9obPgUA64IytuZoSXX7HWT+oE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8dsRYg3BDOc8tMptS82CWy8DEJ4jvMynn4bMqAK2ItZVRt0I3SvTmb6Kfb04Jaa+1CCUf+T/ydGYEZrrlfdwT1Ag0LOq7OMWHMRh5+0UXHakRSPon5/k8Lc+vHz3TWk5p+qgal+EX39wihhL/TjEbZLBqm8i5hO1j8LwCW33Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=pGumHYEw; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7d20f79a00dso832112285a.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 11:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750788771; x=1751393571; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NTUhS7HsUi4ncH3W/Kp0Qjyu1eBnpAdLomHIncteQ/c=;
        b=pGumHYEwxOr6Wl2oNaXb7B7Fpcz66BBCS11Ajbc5FDYkJKly+MrYpZebFhcnLZpKLa
         FRqGDmcMxZNXYrFSKMjCQRK/Y1KUVcW1YslnMa32NvStOq0ckHrRHAj2OLQaX44c0J2h
         HHRuj2swJFFT95BeRgJByHinDEVaBqtjsxmp9FqsqQ1nAnClCY5GO0IqhceCrNxtnRRr
         XHHxWUCmWVT0F1Iq2WsEcpyMg+JynYD9kLi382fbtgyI8STrpBcrmpNjDKHX5lglOLZD
         HRedc/sVVbOrgMTIcmfu3WSdFeQfFbvDCpfw5tYNp7Gdk7OMVRfFS1Ukygq2HjkH4kMp
         r2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750788771; x=1751393571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NTUhS7HsUi4ncH3W/Kp0Qjyu1eBnpAdLomHIncteQ/c=;
        b=Q9ioba8dLu2V8/3Av8u95phSs5RcBMmIHhV2B6wZnx+cC53nFAX1AtTpNuk6eA9/kd
         slqQU/XE2fsDpKwjKj/Vg+Uf7JO4vRUXMffudByjTnkS3GpSzFCFFLqt2ou44hGUS8OP
         Ob/7byaZkd4POPIKmmDuQEd64/xWR8z3cysrPqCfQWk8duTa8NdqhEgZOC+2HX2DdEh0
         +Ju2Uj8WubZiUU+xLJm3GL4WKcIhE8MYYsZa4W4eWPShjQwPqIlbYd0F4phusOp0k+gZ
         n1vIWnjJTdFqLBYHUSfP9Kw6BRv4zliqrQhhiZOtCp38UKgt/0ou63tkIvW69S1WmzSz
         orXw==
X-Forwarded-Encrypted: i=1; AJvYcCXGDB/RuB7RQyN6YwCcbm1X5YDtuirauteq6AF0UurFQXtnc+u5MxrWd+7gdaBvll6bCFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDavNMJ82sUwCYAw78RS4mVKa5PYJpscnOXzPwRaGHU4jfIJWx
	gf0la3b+AjC94I7nqWpDL2ot3WNQE+4agvItRDISaXqOBAdfo443FdLnn3pGMsvAawY=
X-Gm-Gg: ASbGnctRGtXN5Ne4WIRILIj8uaaezxQ5uafKpH+7Q1sbx914KqdfUa+p1oqr/CKLUy+
	v0zPYe/YlFRLAsaUy2+L18884m17z9Mvc3t5l9vPhyCVbbFhyVuatUHjB3vyy0plt575Ns2CpGW
	oyX70vJ1DGeDTVh/iR+OdMPqZCYxaFJEvbfbjRK292HYXl1dyMjNCXkkXn6pWTR18fv86ugEBFq
	d2wUCLDQwOVZJd283dBkB9EdPEQncH6BTPUXOm3OLB/IURB7OlJU+XjNBWCjyshhsFLGtHwa2MU
	//iasLUVBFNkr8E61I8YdQRQ22H9+qx32qf6DTPS6EyjX3oOERJTCWtN7xgscV1r6kxEselCp+Y
	W4faa6nlzALlz8c1LffEf8X6bSvNe+PakfWl+VA==
X-Google-Smtp-Source: AGHT+IEVYAPwlqQ5K5sfPSeY4qX2lln3vN4YWLqtBK9131XNcH/wJIfhgNwEVLFl538+prOc0GcBxA==
X-Received: by 2002:a05:620a:2990:b0:7d0:98fc:83f9 with SMTP id af79cd13be357-7d4296ef4edmr4538185a.18.1750788770913;
        Tue, 24 Jun 2025 11:12:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3f99a6755sm527990185a.32.2025.06.24.11.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 11:12:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uU88X-00000000hAG-1TBX;
	Tue, 24 Jun 2025 15:12:49 -0300
Date: Tue, 24 Jun 2025 15:12:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alex Mastro <amastro@fb.com>, peterx@redhat.com, kbusch@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: print vfio-device name to fdinfo
Message-ID: <20250624181249.GD72557@ziepe.ca>
References: <20250623-vfio-fdinfo-v1-1-c9cec65a2922@fb.com>
 <20250623161831.12109402.alex.williamson@redhat.com>
 <20250624005605.GA72557@ziepe.ca>
 <20250624102303.75146159.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624102303.75146159.alex.williamson@redhat.com>

On Tue, Jun 24, 2025 at 10:23:03AM -0600, Alex Williamson wrote:

> I think we're specifically trying to gain visibility to the
> anon_inode:[vfio-device] in the legacy case.

Ah, I see.. 

> The @name passed to anon_inode_getfile_fmode() is described as the name
> of the "class", which is why I think we used the static
> "[vfio-device]", but I see KVM breaks the mold, adding the vcpu_id:
> 
> 	snprintf(name, sizeof(name), "kvm-vcpu-stats:%d", vcpu->vcpu_id);
> 
> We could do something similar, but maybe fdinfo is the better option,
> and if it is then dev_name() seems like the useful thing to add there
> (though we could add more than one thing).

I wouldn't encode a sysfspath (which is what you really need for a
device name) in the [] section.. fdinfo makes sense for that, but I
would return the full sysfs path to the device from the core code
rather than try to return just the BDF for PCI.

Prefix /sys/ and then userspace can inspect the directory for whatever
information it needs.

It could also return a %d within the [] that indicated which group it
was for. In most system that will tell you the device anyhow since
groups are singular.

> I don't recall if or how we accounted for the concept of vf_tokens in
> the cdev model and I don't see evidence that we did.  For instance
> vfio_pci_validate_vf_token() is only called from vfio_pci_core_match(),
> which is called as match through the vfio_device_ops, but only from
> vfio_group_ioctl_get_device_fd().  So using cdev, it appears we don't
> have the same opt-in requirement when using a VF where the PF is
> managed by a vfio-pci userspace driver.  Thanks,

Hmm.. I can't recall.

I wrote a small patch to correct this, I will post it.

Jason

