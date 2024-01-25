Return-Path: <kvm+bounces-7035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A672F83D06A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 00:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4CB8B245B5
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 23:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBA612E50;
	Thu, 25 Jan 2024 23:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i9Whz7eE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403DC7EC
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 23:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706224371; cv=none; b=ZdfDy/1U0n9Ly6mbhKLZIY1Y5QubQbGfQf5m5XBXgbWoq5GaLm2oEcnSg3z42I1PIPCSNw23xY9A7YyRyYE5AA8dWFWTxG48q3SXZd39Jxn2Phxm42MjBOGo4I8rXA1GJL31uucgWmSjvJ+FrM6qspfevMm3ScbPmhwDEaY/AS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706224371; c=relaxed/simple;
	bh=PE2NThtLqeiZ9yHpAgDTL3wHhDpgAgVQH3ZlQRk/574=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJqD6fJO9zVN6aZUOXki8NdcosUeGPROGme+ukGKHiO9jFtSaYR7OaDRlfHJmxleOu9OKoX8puW71CC3r4fNfo4NBqLzswPlppgC2EevXq3XO+6sHMQnRGCpg4wxzL5tJ9aaDMvrfHs05yfXWITgCrgjECc71kaF4/jaABjZinQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i9Whz7eE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706224368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lW3rN/GUfC9MH2Vd0nLE4NJgA/CgNgaKNYkIe/TMazY=;
	b=i9Whz7eEh9kfNDEcg/K56lUw08mIvRCqvZtM4ZNXvhZFVNBCtfLctuV/tPP27uxAC7sIHC
	OlgHryAekzzpkXw1SKxeYjvV3VPSUYR49EYQo/Z1KWiskQLfEG1DHG4fXDGPeBk30kz3N+
	qq75JEDrdaNfSpyoPBG4WSwcy7cXY2w=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-05J1jsUvMaikxClnnMY3Lw-1; Thu, 25 Jan 2024 18:12:46 -0500
X-MC-Unique: 05J1jsUvMaikxClnnMY3Lw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a2bffe437b5so349406366b.1
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 15:12:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706224365; x=1706829165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lW3rN/GUfC9MH2Vd0nLE4NJgA/CgNgaKNYkIe/TMazY=;
        b=dnqf6RcQkdIIdhokqsK4BsjxvFE+LrBVkGlCDja0fPfAvzANz4Clmn3v4yZ83Lm4pt
         +6KKlVuzgvevwuELAbei5pVyuudKDra21DUewCw8tl1QOPDD/uEj+mmFOa1Glou834ij
         PUy7WljCCY6FzWz/Gr6/KBFNfjzr7z90eNGWX17IucQuMry6eEAHcazVknl/yIkH+3KG
         AV3cVtv8A8Sr6Qv2cUbAbDy7PDb4WfEeus+L2ZY9Yi9hE64EMRE6EbH5/VCWrt7WJuX5
         DXGMipoku3CZpEH2DPiBjFiUxPaZFgg55sGTSMGG781u0GQmQmCt5uWJhwMaI+LkCdTK
         xzkA==
X-Gm-Message-State: AOJu0YxXa+3eufGWPMxTNLBwkzKQKZWkukxGDfrijfDo+Erv1q2k9tWE
	27M5TgnTnd8g/AZ+G6mHLc4lwYQcXttH4kzEAehnythJN9FDVelOYPFL3mYJlNjPnG8jeGV3Vqd
	HzULhgaN8BdHVPM9EGFAH/O5/HKwRDKBiiSaOvfEBrjJNPczczg==
X-Received: by 2002:a17:906:f29a:b0:a2f:6084:6d25 with SMTP id gu26-20020a170906f29a00b00a2f60846d25mr385791ejb.9.1706224365290;
        Thu, 25 Jan 2024 15:12:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6/b/VMaIYycfnZEd2c+y+wt/SpLdBsFee/6R/oZ1RoQsqu0/1+wMOZgV3xqKnPbnSER1Btg==
X-Received: by 2002:a17:906:f29a:b0:a2f:6084:6d25 with SMTP id gu26-20020a170906f29a00b00a2f60846d25mr385781ejb.9.1706224364936;
        Thu, 25 Jan 2024 15:12:44 -0800 (PST)
Received: from redhat.com ([2.52.130.36])
        by smtp.gmail.com with ESMTPSA id tx24-20020a1709078e9800b00a31c5caa750sm801027ejc.177.2024.01.25.15.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jan 2024 15:12:44 -0800 (PST)
Date: Thu, 25 Jan 2024 18:12:40 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Feng Liu <feliu@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH] virtio: uapi: Drop __packed attribute in
 linux/virtio_pci.h:
Message-ID: <20240125181227-mutt-send-email-mst@kernel.org>
References: <20240124172345.853129-1-suzuki.poulose@arm.com>
 <20240125174705-mutt-send-email-mst@kernel.org>
 <cbde8e52-f1a9-4c45-b82c-f3ca13b96991@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbde8e52-f1a9-4c45-b82c-f3ca13b96991@arm.com>

On Thu, Jan 25, 2024 at 11:10:16PM +0000, Suzuki K Poulose wrote:
> On 25/01/2024 22:48, Michael S. Tsirkin wrote:
> > On Wed, Jan 24, 2024 at 05:23:45PM +0000, Suzuki K Poulose wrote:
> > > Commit 92792ac752aa ("virtio-pci: Introduce admin command sending function")
> > > added "__packed" structures to UAPI header linux/virtio_pci.h. This triggers
> > > build failures in the consumer userspace applications without proper "definition"
> > > of __packed (e.g., kvmtool build fails).
> > > 
> > > Moreover, the structures are already packed well, and doesn't need explicit
> > > packing, similar to the rest of the structures in all virtio_* headers. Remove
> > > the __packed attribute.
> > > 
> > > Fixes: commit 92792ac752aa ("virtio-pci: Introduce admin command sending function")
> > 
> > 
> > Proper form is:
> > 
> > Fixes: 92792ac752aa ("virtio-pci: Introduce admin command sending function")
> 
> Apologies, for messing that up.


Pls repost a fixed one.

> > 
> > > Cc: Feng Liu <feliu@nvidia.com>
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Yishai Hadas <yishaih@nvidia.com>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > ---
> > >   include/uapi/linux/virtio_pci.h | 10 +++++-----
> > >   1 file changed, 5 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> > > index ef3810dee7ef..a8208492e822 100644
> > > --- a/include/uapi/linux/virtio_pci.h
> > > +++ b/include/uapi/linux/virtio_pci.h
> > > @@ -240,7 +240,7 @@ struct virtio_pci_cfg_cap {
> > >   #define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
> > >   #define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
> > > -struct __packed virtio_admin_cmd_hdr {
> > > +struct virtio_admin_cmd_hdr {
> > >   	__le16 opcode;
> > >   	/*
> > >   	 * 1 - SR-IOV
> > > @@ -252,20 +252,20 @@ struct __packed virtio_admin_cmd_hdr {
> > >   	__le64 group_member_id;
> > >   };
> > > -struct __packed virtio_admin_cmd_status {
> > > +struct virtio_admin_cmd_status {
> > >   	__le16 status;
> > >   	__le16 status_qualifier;
> > >   	/* Unused, reserved for future extensions. */
> > >   	__u8 reserved2[4];
> > >   };
> > > -struct __packed virtio_admin_cmd_legacy_wr_data {
> > > +struct virtio_admin_cmd_legacy_wr_data {
> > >   	__u8 offset; /* Starting offset of the register(s) to write. */
> > >   	__u8 reserved[7];
> > >   	__u8 registers[];
> > >   };
> > > -struct __packed virtio_admin_cmd_legacy_rd_data {
> > > +struct virtio_admin_cmd_legacy_rd_data {
> > >   	__u8 offset; /* Starting offset of the register(s) to read. */
> > >   };
> > > @@ -275,7 +275,7 @@ struct __packed virtio_admin_cmd_legacy_rd_data {
> > >   #define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
> > > -struct __packed virtio_admin_cmd_notify_info_data {
> > > +struct virtio_admin_cmd_notify_info_data {
> > >   	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
> > >   	__u8 bar; /* BAR of the member or the owner device */
> > >   	__u8 padding[6];
> > 
> > 
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > I will queue this.
> 
> Thanks
> Suzuki
> 
> > 
> > > -- 
> > > 2.34.1
> > 


