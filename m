Return-Path: <kvm+bounces-6855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C298683B102
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 19:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7958F2865B8
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 18:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D3912AAE9;
	Wed, 24 Jan 2024 18:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y21U/Jzy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2387B1272DD
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 18:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706120541; cv=none; b=jaBmRzAJcdlDFr4iuc8Y6ybdJ4oH6HUe9pMmGfzLCurRQRfdxyN0/3T/TNmL1isVI+FVRwIOeHkbx8vNOdNiAmZFlAHJzYgIRyyY6G1StcsX/yM92ltADQ1xiReznMX2wIjqyl7nMCn5RWqJE4Fz6jZuLDHvOAckTxOoMM7Pjfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706120541; c=relaxed/simple;
	bh=wbZWmGrWH8JcJ771piCTg/bWVpmwahSuzv7Z+Mj+J1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lKYryB4TCad6/UnVlRdWCuzy+Dyv4oaeHLtu4+uTvcq5EH3f2LbzhTNwZzIUL49HnUWOkHyyi9ZgQh0b0olps4RfhTx2WGnSOQO8W4KAivDJeDE6wvw6folpkQm5kGBONsx3oJBr9o1/k8V53PrQ03az4VKQig8P+oBWuVlq6cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y21U/Jzy; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-338aca547d9so4613142f8f.0
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 10:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706120537; x=1706725337; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pnIYdN+laIAJSsus1mByKQQs+4v4u+0ydG/KXxGrtlA=;
        b=Y21U/JzyBLQRL1nCHZW5/jA/X2nh1EqyrqXEd9iivneEjsIQ+76eO7Yj1Qnh8WN1SJ
         /EGXnCDwg41+om+vv9X/aSQDEjkp8Xzv+n7tgvWqAsH4pWr0JkD4X/Z6WiH1v+5rMNog
         B8yb9RERpZzRNdFHuI3pHLZfMH3Vtc/RYIobxZ3Rzc+Nd5TkTlq34C2YurtyRYY7m/cD
         SReIz0ynLQMdSbjsUcfGuKg30+TGzbSlTYNZl4Knsq09O4gIv3ruY15jMwsu1yyqHHMk
         /ZyO+A6fIT4Ar2rcN8V3POsSoYbRaSDQjRDiSkqGPINkwdAhSO5EmslCkkwgK9tO/MDy
         EGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706120537; x=1706725337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnIYdN+laIAJSsus1mByKQQs+4v4u+0ydG/KXxGrtlA=;
        b=O2pUyiPVq+hldjdCx5bW3AokOmlVkB8+tZnNrl3ZrnOscGHHpklzeCwwDIFZA4BKet
         ml3yiByjcD7Z7Slk1ZVAh8wU950Im7sNbMS+j4k4i7UMIllLlYTvOV+oYVSGN9wRj+Ut
         EFSR+Qphj0hPIDa3hbl/WUgNBfHHiQWmN2bliyaCv8oJ+bacY1VrZrPUPHJs99OQRTUq
         AOhz6+9ylKNTlfn/S+ZWXugJ6fVXVbmk1SZSzZDnMIOwOFAj66l+Os3pYWIJr5wvXdsZ
         8Es9SJSt2q5YiccMUHPZSg6vVaHluw7xcPph4sWsEN+6Q8U5+atTU8q8WaQ4/xPpn66L
         h9yA==
X-Gm-Message-State: AOJu0YzXNNw/zB9SoKMt7udq7cW+ePQpGMW0CM50e3l5UfDIHP6UEm0z
	CvUuJtQMyP3YDs2EtSH2E690T+2GdWiY3EmqBoAkCmLSmjopU3k8OkeIeOAT4+c=
X-Google-Smtp-Source: AGHT+IHRmPShxmMLc/LTRITs/dmQsYbYRl3PA6qkdxRGGoc4nhXoojgy4gjjuy51N7s47SgWWFbo9g==
X-Received: by 2002:adf:f5c6:0:b0:337:cd6a:2952 with SMTP id k6-20020adff5c6000000b00337cd6a2952mr388281wrp.245.1706120537342;
        Wed, 24 Jan 2024 10:22:17 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id w14-20020a5d404e000000b00337d9a717bcsm14779739wrp.52.2024.01.24.10.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 10:22:16 -0800 (PST)
Date: Wed, 24 Jan 2024 18:22:23 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Feng Liu <feliu@nvidia.com>, "Michael S . Tsirkin" <mst@redhat.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] virtio: uapi: Drop __packed attribute in
 linux/virtio_pci.h:
Message-ID: <20240124182223.GA3941090@myrica>
References: <20240124172345.853129-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124172345.853129-1-suzuki.poulose@arm.com>

On Wed, Jan 24, 2024 at 05:23:45PM +0000, Suzuki K Poulose wrote:
> Commit 92792ac752aa ("virtio-pci: Introduce admin command sending function")
> added "__packed" structures to UAPI header linux/virtio_pci.h. This triggers
> build failures in the consumer userspace applications without proper "definition"
> of __packed (e.g., kvmtool build fails).
> 
> Moreover, the structures are already packed well, and doesn't need explicit
> packing, similar to the rest of the structures in all virtio_* headers. Remove
> the __packed attribute.
> 
> Fixes: commit 92792ac752aa ("virtio-pci: Introduce admin command sending function")
> Cc: Feng Liu <feliu@nvidia.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
>  include/uapi/linux/virtio_pci.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> index ef3810dee7ef..a8208492e822 100644
> --- a/include/uapi/linux/virtio_pci.h
> +++ b/include/uapi/linux/virtio_pci.h
> @@ -240,7 +240,7 @@ struct virtio_pci_cfg_cap {
>  #define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
>  #define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
>  
> -struct __packed virtio_admin_cmd_hdr {
> +struct virtio_admin_cmd_hdr {
>  	__le16 opcode;
>  	/*
>  	 * 1 - SR-IOV
> @@ -252,20 +252,20 @@ struct __packed virtio_admin_cmd_hdr {
>  	__le64 group_member_id;
>  };
>  
> -struct __packed virtio_admin_cmd_status {
> +struct virtio_admin_cmd_status {
>  	__le16 status;
>  	__le16 status_qualifier;
>  	/* Unused, reserved for future extensions. */
>  	__u8 reserved2[4];
>  };
>  
> -struct __packed virtio_admin_cmd_legacy_wr_data {
> +struct virtio_admin_cmd_legacy_wr_data {
>  	__u8 offset; /* Starting offset of the register(s) to write. */
>  	__u8 reserved[7];
>  	__u8 registers[];
>  };
>  
> -struct __packed virtio_admin_cmd_legacy_rd_data {
> +struct virtio_admin_cmd_legacy_rd_data {
>  	__u8 offset; /* Starting offset of the register(s) to read. */
>  };
>  
> @@ -275,7 +275,7 @@ struct __packed virtio_admin_cmd_legacy_rd_data {
>  
>  #define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
>  
> -struct __packed virtio_admin_cmd_notify_info_data {
> +struct virtio_admin_cmd_notify_info_data {
>  	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
>  	__u8 bar; /* BAR of the member or the owner device */
>  	__u8 padding[6];
> -- 
> 2.34.1
> 

