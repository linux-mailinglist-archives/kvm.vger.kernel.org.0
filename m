Return-Path: <kvm+bounces-58592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A650B97293
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 20:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 566444A6E89
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA13E2F6198;
	Tue, 23 Sep 2025 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="WQYAWiKt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06316207DE2
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758650685; cv=none; b=cNAJqi6bmziDXQVQRq5t0nl9irWRYoYxEQLbmYxe/+rjjC62yO3DLxplWbV+LFUKQHo6dZ1yz4LUMEuFC4gJLWLmGe+FPQwkkXrdhPNRbKLMWSz6zGJ/Jykjwa1FG5R6o1Fil/4rL1OVgLeBIkSheGFgC1HBmF14Zd4dHBqzZbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758650685; c=relaxed/simple;
	bh=eacR98dkSUBbCzoaapJbuctQKrT9ktzzxDR7sXHJeA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7CmGM0GPe2ryj8FrTteeIjhrTh/0SxjVSqfjiRHV2Bk6dkwBNczzhK1NW+jM/Y4aw1962YFBEbT/vAIfYfx2ofhxdGruA8/JZicrAvNKl5jw6f+Z7QDjKlLMrC0MY36ACFRbsxfqKHBIT9Do/1YYShOmdWmISE7b+uHUQWCNUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=WQYAWiKt; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-793ef18e8a3so112813a34.0
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 11:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1758650682; x=1759255482; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fef98T7bnQVGONe9Wy0sE6xnXuSuMBBSdC/MAFgn2wI=;
        b=WQYAWiKt3Upk+fF1y9izJUMxx+Z8o3VV8ZVC5IjfLfKv59BtESSQq6kApDobd98MS3
         vFqvaR7LwPt+eB71zbIUBbdrwcEqHRzK00aoyglb9mMBQ87+vvimZWgjmWZom97Bh70z
         TVEmRQFrQOeSlwRqMtOXGLuH6wfw72aMZq7dfrx3n8memoPNUG0o2SuEalnnTCuWWKh1
         8jlFjkymsGnKG7qKzuId7U6prL+71SBDn0CXRk4ix/T+UbvSurU3LMI+arzIaxJz2XKz
         CrDGC5Aa1tk+vGJJ0OqkpnXvhnBMBcamO+wtAg5uliKU2EfR7TVYaHmdYZLDFiP8H/Pg
         Tt3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758650682; x=1759255482;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fef98T7bnQVGONe9Wy0sE6xnXuSuMBBSdC/MAFgn2wI=;
        b=NbQIwuhkfRDJGMisiDxS2hGb3H79Pk0G0zofqlvW0VbNSTZMh95x3ZxuPquHHUJigw
         t/ZMRKU2vzCNSE1a6PxzRBITMBR7tJ5+2l3AyTyZ9fCg4oAax1qmerc36kOtlYZ4sN/v
         28HLuwsxNqNSDqJeolSlObxThsfyC/gkJ6HvQb4V5kItbNVSjvcYP+KO2c7OMLqct3WS
         0UEGgOis2ltdHxjf4hKKpNwNd1rG1adNDDHzuMPYKJ454iGOahzBYHxP6FywahTo4Oiw
         JUnt83G1If7NmzLd1M61GIrw+VL2SjPGjAjvhmpJO5Bp1KKfpQzeUr+ZPQMDm9rjv89g
         gvkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYaIaHLx+OlYwVD/bwHtsVeVPr7pU8q2IhE3Q1YICcH6bTzOr5WP7A3UwZRv2FBRMvpxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQXyRmqprmS6PIyNES4p0ZpLAlMR405DMSPeKQZT1sor+04uSl
	pEtyVB3Vi4UZDNmkYsgWb916c46cLBMe0jMtTvc+QndFrEoTxx+F/ssaQ1tSjM5XWY0=
X-Gm-Gg: ASbGncs/gyK538wpIuFV4xPk1eeXcr+cPyTLtJ6aIhE1WJCvE0g0Q0i3SJNuzPDwgKP
	MVBo4aNhSL2hQ4/bJj47VLPZT2OdsULyvQT4DdkZSwyv3itufPDW9SPvVjBtBjZq1A44BCh9MY/
	OhK4QvzHve+Pu4M4mdk00Uy1Z5ozYRJyVgC53cdy3FQX7P5iaW/RQvlxPNhm32GsyHTfDP/zmM7
	l7LAsEets3z4CC9+d94fQi0spwi1s2jIYrNLx5V/tjOl/W1Mjzf7fUz2gwgpnwYnEWPC9P+VHZW
	35ppbOh7n2Xfd9V1pOnf4P7XWPn/1vVNTewqIXU6beJQrxoYQB+PkrDFsyL8Bg6aCLWATeub
X-Google-Smtp-Source: AGHT+IF+0AOQOruq7bU6S/hoPn5x7ZCPYOkcXl/6V5elBa8VsAnFdyCH65bQxGi3os6/QzwpW2LcVQ==
X-Received: by 2002:a9d:4786:0:b0:757:1398:fbe2 with SMTP id 46e09a7af769-791647dea14mr1495970a34.16.1758650681894;
        Tue, 23 Sep 2025 11:04:41 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-625d881f9c4sm5075096eaf.5.2025.09.23.11.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 11:04:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v17NX-0000000Az64-1Lwe;
	Tue, 23 Sep 2025 15:04:39 -0300
Date: Tue, 23 Sep 2025 15:04:39 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Wathsala Vithanage <wathsala.vithanage@arm.com>
Cc: alex.williamson@redhat.com, pstanner@redhat.com, jeremy.linton@arm.com,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/1] vfio/pci: add PCIe TPH device ioctl
Message-ID: <20250923180439.GG2547959@ziepe.ca>
References: <20250916175626.698384-1-wathsala.vithanage@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916175626.698384-1-wathsala.vithanage@arm.com>

On Tue, Sep 16, 2025 at 05:56:26PM +0000, Wathsala Vithanage wrote:
> +
> +static int vfio_pci_tph_get_st(struct vfio_pci_core_device *vdev,
> +			       struct vfio_pci_tph_entry *ents, int count)
> +{
> +	int i, mtype, err = 0;
> +	u32 cpu_uid;
> +
> +	for (i = 0; i < count && !err; i++) {
> +		if (ents[i].cpu_id >= nr_cpu_ids || !cpu_present(ents[i].cpu_id)) {
> +			err = -EINVAL;
> +			break;
> +		}
> +
> +		cpu_uid = topology_core_id(ents[i].cpu_id);

This should check the process has access to the given CPU:

                if (!cpumask_test_cpu(cpu_id, current->cpus_ptr)) {

> +		mtype = (ents[i].flags & VFIO_TPH_MEM_TYPE_MASK) >>
> +			VFIO_TPH_MEM_TYPE_SHIFT;

Why this weird encoding with flags? Just give it a normal member.

> +/**
> + * VFIO_DEVICE_PCI_TPH	- _IO(VFIO_TYPE, VFIO_BASE + 22)
> + *
> + * This command is used to control PCIe TLP Processing Hints (TPH)
> + * capability in a PCIe device.
> + * It supports following operations on a PCIe device with respect to TPH
> + * capability.
> + *
> + * - Enabling/disabling TPH capability in a PCIe device.
> + *
> + *   Setting VFIO_DEVICE_TPH_ENABLE flag enables TPH in no-steering-tag,
> + *   interrupt-vector, or device-specific mode defined in the PCIe specficiation
> + *   when feature flags TPH_ST_NS_MODE, TPH_ST_IV_MODE, and TPH_ST_DS_MODE are
> + *   set respectively. TPH_ST_xx_MODE macros are defined in
> + *   uapi/linux/pci_regs.h.
> + *
> + *   VFIO_DEVICE_TPH_DISABLE disables PCIe TPH on the device.
> + *
> + * - Writing STs to MSI-X or ST table in a PCIe device.
> + *
> + *   VFIO_DEVICE_TPH_SET_ST flag set steering tags on a device at an index in
> + *   MSI-X or ST-table depending on the VFIO_TPH_ST_x_MODE flag used and
> + *   returns the programmed steering tag values. The caller can set one or more
> + *   steering tags by passing an array of vfio_pci_tph_entry objects containing
> + *   cpu_id, cache_level, and MSI-X/ST-table index. The caller can also set the
> + *   intended memory type and the processing hint by setting VFIO_TPH_MEM_TYPE_x
> + *   and VFIO_TPH_HINT_x flags, respectively.

I'm not sure if the MSI-X mode is really safe to expose to
userspace.. I thought the hack was sort of OK if it was used with a
co-operating driver that didn't try to concurrently manipulate the
steering tags.

> + * - Reading Steering Tags (ST) from the host platform.
> + *
> + *   VFIO_DEVICE_TPH_GET_ST flags returns steering tags to the caller. Caller
> + *   can request one or more steering tags by passing an array of
> + *   vfio_pci_tph_entry objects. Steering Tag for each request is returned via
> + *   the st field in vfio_pci_tph_entry.
> + */
> +struct vfio_pci_tph_entry {
> +	/* in */
> +	__u32 cpu_id;			/* CPU logical ID */
> +	__u32 cache_level;		/* Cache level. L1 D= 0, L2D = 2, ...*/

Nothing reads cache_level ?

> +	__u8  flags;
> +#define VFIO_TPH_MEM_TYPE_MASK		0x1
> +#define VFIO_TPH_MEM_TYPE_SHIFT		0
> +#define VFIO_TPH_MEM_TYPE_VMEM		0   /* Request volatile memory ST */
> +#define VFIO_TPH_MEM_TYPE_PMEM		1   /* Request persistent memory ST */
> +
> +#define VFIO_TPH_HINT_SHIFT		1
> +#define VFIO_TPH_HINT_MASK		(0x3 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_BIDIR		0
> +#define VFIO_TPH_HINT_REQSTR		(1 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_TARGET		(2 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_TARGET_PRIO	(3 << VFIO_TPH_HINT_SHIFT)
> +	__u8  pad0;
> +	__u16 index;			/* MSI-X/ST-table index to set ST */
> +	/* out */
> +	__u16 st;			/* Steering-Tag */

I don't know if we should leak the HW steering tag to userspace??

> +	__u8  ph_ignore;		/* Platform ignored the Processing */
> +	__u8  pad1;
> +};
> +
> +struct vfio_pci_tph {
> +	__u32 argsz;			/* Size of vfio_pci_tph and ents[] */
> +	__u32 flags;
> +#define VFIO_TPH_ST_MODE_MASK		0x7
> +
> +#define VFIO_DEVICE_TPH_OP_SHIFT	3
> +#define VFIO_DEVICE_TPH_OP_MASK		(0x7 << VFIO_DEVICE_TPH_OP_SHIFT)
> +/* Enable TPH on device */
> +#define VFIO_DEVICE_TPH_ENABLE		0
> +/* Disable TPH on device */
> +#define VFIO_DEVICE_TPH_DISABLE		(1 << VFIO_DEVICE_TPH_OP_SHIFT)
> +/* Get steering-tags */
> +#define VFIO_DEVICE_TPH_GET_ST		(2 << VFIO_DEVICE_TPH_OP_SHIFT)
> +/* Set steering-tags */
> +#define VFIO_DEVICE_TPH_SET_ST		(4 << VFIO_DEVICE_TPH_OP_SHIFT)

Don't multiplex operations on flags, give it an op member if this is
the design.

> +	__u32 count;			/* Number of entries in ents[] */
> +	struct vfio_pci_tph_entry ents[];

This effectively makes vfio_pci_tph_entry extendable, you should try
to avoid that..

Jason

