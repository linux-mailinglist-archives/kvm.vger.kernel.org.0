Return-Path: <kvm+bounces-36366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D4BA1A5A5
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2C4C3A36B7
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C96321148A;
	Thu, 23 Jan 2025 14:20:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7785320F96B;
	Thu, 23 Jan 2025 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737642022; cv=none; b=fUBIsfxBwtHqsPIK/IDEGjY6d6lSUzmqVhtRbWYwF5f+QRKh6HSZoVlKO2lHNIAGkL4ypyFJ8psdk6Bdr9El0a/mbfh1qoY+Xq3JQNghP+RjBwaWL+IH+wbdQpIKzBV8G0zei7UkzSSMFwvOXw6Mg0YOQfDbT4NiWfMh5HjBLlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737642022; c=relaxed/simple;
	bh=0XgpFNiqBrZwOPcOSQr6PpF8QuiHUlFjdT+D+/Io9JU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pmcYtqKuHuHwPJyoputgxevZ8MLeefZz2xVUYA1GGvqV4QZaUm2v9RD3YPMfbRsZ8EN2fI+KTuMvGzOjwK4STa58TBr6NUzMYex/ropSc6qp89kgsxMB5Se+AwQyF5jGfpQ9iCZS3/GSb9Vjic5h816qQzwvyfBzNT+TcnEKKsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3FE41063;
	Thu, 23 Jan 2025 06:20:45 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 547893F694;
	Thu, 23 Jan 2025 06:20:14 -0800 (PST)
Date: Thu, 23 Jan 2025 14:20:07 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
	david@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 12/18] scripts/runtime: Add default
 arguments for kvmtool
Message-ID: <Z5JQF38bJQFeWrbJ@raptor>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-13-alexandru.elisei@arm.com>
 <20250121-16510b161f5b92ce9c5ae4e1@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121-16510b161f5b92ce9c5ae4e1@orel>

Hi,

On Thu, Jan 23, 2025 at 03:07:18PM +0100, Andrew Jones wrote:
> On Mon, Jan 20, 2025 at 04:43:10PM +0000, Alexandru Elisei wrote:
> > kvmtool, unless told otherwise, will do its best to make sure that a kernel
> > successfully boots in a virtual machine. Among things like automatically
> > creating a rootfs, it also adds extra parameters to the kernel command
> > line. This is actively harmful to kvm-unit-tests, because some tests parse
> > the kernel command line and they will fail if they encounter the options
> > added by kvmtool.
> > 
> > Fortunately for us, kvmtool commit 5613ae26b998 ("Add --nodefaults command
> > line argument") addded the --nodefaults kvmtool parameter which disables
> 
> added
> 
> > all the implicit virtual machine configuration that cannot be disabled by
> > using other parameters, like modifying the kernel command line. Always use
> > --nodefaults to allow a test to run.
> > 
> > kvmtool can be too verbose when running a virtual machine, and this is
> > controlled with parameters. Add those to the default kvmtool command line
> > to reduce this verbosity to a minimum.
> > 
> > Before:
> > 
> > $ vm run arm/selftest.flat --cpus 2 --mem 256 --params "setup smp=2 mem=256"
> >   Info: # lkvm run -k arm/selftest.flat -m 256 -c 2 --name guest-5035
> > Unknown subtest
> > 
> > EXIT: STATUS=127
> >   Warning: KVM compatibility warning.
> > 	virtio-9p device was not detected.
> > 	While you have requested a virtio-9p device, the guest kernel did not initialize it.
> > 	Please make sure that the guest kernel was compiled with CONFIG_NET_9P_VIRTIO=y enabled in .config.
> >   Warning: KVM compatibility warning.
> > 	virtio-net device was not detected.
> > 	While you have requested a virtio-net device, the guest kernel did not initialize it.
> > 	Please make sure that the guest kernel was compiled with CONFIG_VIRTIO_NET=y enabled in .config.
> >   Info: KVM session ended normally.
> > 
> > After:
> > 
> > $ vm run arm/selftest.flat --nodefaults --network mode=none --loglevel=warning --cpus 2 --mem 256 --params "setup smp=2 mem=256"
> 
> On riscv I've noticed that with --nodefaults if I don't add parameters
> with --params then kvmtool segfaults. I have to add --params "" to
> avoid it. Does that also happen on arm? Anyway, that's something we
> should fix in kvmtool rather than workaround it here.

This should fix it:

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 85c8f95604f6..f6a702533258 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -256,9 +256,10 @@ static int setup_fdt(struct kvm *kvm)
                if (kvm->cfg.kernel_cmdline)
                        _FDT(fdt_property_string(fdt, "bootargs",
                                                 kvm->cfg.kernel_cmdline));
-       } else
+       } else if (kvm->cfg.real_cmdline) {
                _FDT(fdt_property_string(fdt, "bootargs",
                                         kvm->cfg.real_cmdline));
+       }

        _FDT(fdt_property_string(fdt, "stdout-path", "serial0"));


Looking at the timestamp on the commit, the patch that added --nodefaults
came before the patch that added riscv to kvmtool (by about a month). Just
in case you want to add a Fixes tag.

Thanks,
Alex

