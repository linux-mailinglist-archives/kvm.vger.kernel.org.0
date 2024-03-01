Return-Path: <kvm+bounces-10695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D565686ED1D
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 00:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13E6F1C21C74
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 23:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E899A5F481;
	Fri,  1 Mar 2024 23:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HcF0iIua"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA9C5EE9D
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 23:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709337535; cv=none; b=l5vnm3NzeNUVzspQOsTJt/wzKR1hiPVTGenPFFBNzH601a+XkgCLgFUASlxD8Rt5tMctKvEgDYqpygA6Kv1vwJEkyXrwC7sGVxZ5xo6R18+sMthrSZrK7wX/nr/zeKrn87E8HK+2jx0wA3iZV1xf58yirR3vuGTUvfz5Onk1XFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709337535; c=relaxed/simple;
	bh=TEiZWx4zhHeYJu6Wn/bCg5XXbQXaRGha6ZvizIYbH7I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eAECmjtf7BfBnzuLrxnVMAO7z1C7FbCVXBmxcFzJKmWIYIXjhzmG3tc954OpliMugCkATzO0j5+RvEv1IT+iZrldmA8wHa9U9yRHQIKUevUUOPQHEepjauFd48H28129iMuqnQLV0C9rR7EDums+tOl9PZlP341Mz/4wfVtpNz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HcF0iIua; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709337532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YlCAVuX4UaRN1aV/EeYQU1fnCBON103irv5ZBsuVOqI=;
	b=HcF0iIuakwYsFtvRAu+TuIf3Bl4qy0S/msXCjzkIpExHT8+LmNsT38p6J2PHz7TvT+qj8Q
	LYbhDKeZ+jSJEqbSq0GcCVxYwCDNVTDiN18vFHO03aRkVJFmEbw3aEHVNoz9MdPPuvW1Dy
	CU/4YKILd4YgQ6dhiMhvGcN02EVPMxg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-svZGGjATOESsfk5FkegaOQ-1; Fri, 01 Mar 2024 18:58:51 -0500
X-MC-Unique: svZGGjATOESsfk5FkegaOQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7c7ba82fd11so230356839f.2
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 15:58:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709337530; x=1709942330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YlCAVuX4UaRN1aV/EeYQU1fnCBON103irv5ZBsuVOqI=;
        b=S2qfuZdoetVfh1Y/JtRD2Y2DzD1gJo0w7LF7rwrClxlsJv6WQiy+4g/uDXgo5FpCuM
         TSTytJsbVjvIQM7F0D1wa9XRw1h7he2xqOc3QBsNjlVjA53XieR5RwBNEqjZVs+sW7NR
         0+buz9EDyE/53WGAoRFpFZ7Dub09v3q4NICPWqM8NthGM4JUe8ebg6Xu+zcpSCAkB6EC
         qg1fLYiHYIgZPjwUSwPoz3EcYeZuH1gBCii5eZFfAgxhErOU1ZbErKUag9B/eYL2IRtG
         yVPglnSL/IMWtLqJT+MlLcYG/iJBSbhphgaly4A20J9tr2ywrhCDoPHKHWMdWQiht0Op
         qzyg==
X-Forwarded-Encrypted: i=1; AJvYcCWdo8q5Jb0ekmMUqCgMyLix8qEfIT9/jzsKy/Vwg/0kFyfvFYJ0H3vzlBzg1LZKlLwaBt/S+tUqPZeGA/Ta5rghN6WT
X-Gm-Message-State: AOJu0YzgoUYC/ocboUvGo6LpysMo3K5O+vwgEUNbeq4k1lAFmQmwE23E
	EAThjY426GlmaFkmv3bGnTJCcXBFc2WECipC9JpgN3F/TQ5G6cG70Yc9qDjqqxtV1MWyhR0Isni
	rJUmLvB6LRGLjVpVU3hc/tYsxf6z+NpcAzwKkrHFfcuJzCqnpIg==
X-Received: by 2002:a05:6e02:2164:b0:365:1b7c:670 with SMTP id s4-20020a056e02216400b003651b7c0670mr4106983ilv.8.1709337530259;
        Fri, 01 Mar 2024 15:58:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbRepeUVWR47zVjqTIDy6q8VcNd2j88dfXjLkatYc3K1nuWkkGOazRwHcZWscPqnqCuZazBQ==
X-Received: by 2002:a05:6e02:2164:b0:365:1b7c:670 with SMTP id s4-20020a056e02216400b003651b7c0670mr4106972ilv.8.1709337529949;
        Fri, 01 Mar 2024 15:58:49 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id y11-20020a92c74b000000b003642688819csm1177284ilp.69.2024.03.01.15.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 15:58:49 -0800 (PST)
Date: Fri, 1 Mar 2024 16:58:48 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: herbert@gondor.apana.org.au, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, qat-linux@intel.com,
 Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v4 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240301165848.37cfffaf.alex.williamson@redhat.com>
In-Reply-To: <20240228143402.89219-11-xin.zeng@intel.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
	<20240228143402.89219-11-xin.zeng@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Feb 2024 22:34:02 +0800
Xin Zeng <xin.zeng@intel.com> wrote:
> +static int
> +qat_vf_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct qat_vf_core_device *qat_vdev;
> +	int ret;
> +
> +	if (!pci_match_id(id, pdev)) {
> +		pci_err(pdev, "Incompatible device, disallowing driver_override\n");
> +		return -ENODEV;
> +	}

I think the question of whether this is the right thing to do is still
up for debate, but as noted in the thread where I raised the question,
this mechanism doesn't actually work.

The probe callback is passed the matching ID from the set of dynamic
IDs added via new_id, the driver id_table, or pci_device_id_any for a
strictly driver_override match.  Any of those would satisfy
pci_match_id().

If we wanted the probe function to exclusively match devices in the
id_table, we should call this as:

	if (!pci_match_id(qat_vf_vfio_pci_table, pdev))...

If we wanted to still allow dynamic IDs, the test might be more like:

	if (id == &pci_device_id_any)...

Allowing dynamic IDs but failing driver_override requires a slightly
more sophisticated user, but is inconsistent.  Do we have any
consensus on this?  Thanks,

Alex


> +
> +	qat_vdev = vfio_alloc_device(qat_vf_core_device, core_device.vdev, dev, &qat_vf_pci_ops);
> +	if (IS_ERR(qat_vdev))
> +		return PTR_ERR(qat_vdev);
> +
> +	pci_set_drvdata(pdev, &qat_vdev->core_device);
> +	ret = vfio_pci_core_register_device(&qat_vdev->core_device);
> +	if (ret)
> +		goto out_put_device;
> +
> +	return 0;
> +
> +out_put_device:
> +	vfio_put_device(&qat_vdev->core_device.vdev);
> +	return ret;
> +}


