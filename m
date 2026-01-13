Return-Path: <kvm+bounces-67926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1651BD17DE2
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 11:08:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3C449302D2FE
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 10:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7791B30CDB1;
	Tue, 13 Jan 2026 10:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILrXWa7E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060C8343D9E
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 10:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768298636; cv=none; b=Qhb8Iw9/RfXXdtzd9fDyv1ILbK5iRrGRFISOfk3sOHhPJqO4znEGi92m+k0Lcmcc+5oqQ+kXGXAZO6El0pWJMC3m7sHzz+2c4ac1KTjpw2O1zfViNPIgr/thTnKXQU+/ZKxbs6+T5FAZvD61hCQpLGK16Uy9ei4e4h8OOwrOj/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768298636; c=relaxed/simple;
	bh=ZvfRMEkE8IjkZy776J8Usc9qkgZ/d5EiUknzOmL48iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/vnn1X2pKbqDhNvtBWzbYaz6hE2rmeASQ9OyHk1bNIYt0R6n42rPZtCj0qY1HrQzALQop3/RpPqyKiVrEsAMR3ILY6DQwyKe53CQkSk7sKCuzBSOe4FCfOYyDRLAyGp1gmDMOS19j2zzebwFSKhKaSNauxsJDOmEsg3DlVGjNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILrXWa7E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768298633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/TYOQZ+sW9A9pK1BbGpJJiCSp+iw4/edrNSXl/0rj/g=;
	b=ILrXWa7E1DBSdrUvX3bR1k7tyEYudZgVTHZZZfHTzeAQMCE2CyLVZ2yfmuaYGkNm7R2PWv
	/nnCHakH1ObIFlVWv1+w6YLEkKo2vda1aGK3Yp0qAdhh914fZx1Se0sJ3lWXp1Qp5b76gi
	19NmR+tCEH8hCNK7DoH0J27rza01+mo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-GgTxawCaOmuNm28Xr4nkTw-1; Tue,
 13 Jan 2026 05:03:50 -0500
X-MC-Unique: GgTxawCaOmuNm28Xr4nkTw-1
X-Mimecast-MFC-AGG-ID: GgTxawCaOmuNm28Xr4nkTw_1768298629
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C8561956095;
	Tue, 13 Jan 2026 10:03:49 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.45.224.56])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 338811956053;
	Tue, 13 Jan 2026 10:03:48 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id E1E4C1800081; Tue, 13 Jan 2026 11:03:45 +0100 (CET)
Date: Tue, 13 Jan 2026 11:03:45 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Oliver Steffen <osteffen@redhat.com>, qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, 
	Zhao Liu <zhao1.liu@intel.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Luigi Leonardi <leonardi@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Ani Sinha <anisinha@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v2 0/3] igvm: Supply MADT via IGVM parameter
Message-ID: <aWYS7RYg8E4V_g6b@sirius.home.kraxel.org>
References: <20251211103136.1578463-1-osteffen@redhat.com>
 <20251219140933.7b102fc5@imammedo>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219140933.7b102fc5@imammedo>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  Hi,

> Also seeing that regenerating tables every time helps,
> it hints that PCI subsystem is not configured when tables read 1st time.

This is the case.

> Main conditions to get acpi blob representing is that they should be read
> after guest firmware enumerated/configured PCI subsystem and
> firmware should use BIOSlinker workflow to load/postprocess
> tables otherwise all bets are off (even if this series works for now,
> it's subject to break without notice since user doesn't follow proper
> procedures for reading/processing ACPI blob).
> Hence I dislike this approach.

Well, the use case which needs this is a confidential VM with SVSM.  So
the SVSM firmware is the first thing which boots, sets up SVSM and the
services it provides (vTPM, in the future UEFI variable store), then
goes boot OVMF firmware which handles PCI initialization etc.

SVSM needs to know the SMP configuration, but it does not even look at
the PCI bus.

The MADT is static:  Nothing in there changes if the guest changes
hardware registers (such as pci bridge windows), nothing requires the
bios linker for cross-table references.  Given that I fail to see how
this can possibly break in the future.

> Alternatively, instead of ACPI tables one can use FW_CFG_MAX_CPUS
> like old SeaBIOS used to do if all you need is APIC IDs.
> Limitation of this approach is that one can't use sparse APIC ID
> configs.

Thats why the idea is to just use the MADT table for SMP discovery.
The APIC IDs are in there, and it also removes qemu-specific code from
SVSM.

take care,
  Gerd


