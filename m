Return-Path: <kvm+bounces-7740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D325845CD7
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:16:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B3C2B33822
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88D3779FA;
	Thu,  1 Feb 2024 16:03:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69DE626C7;
	Thu,  1 Feb 2024 16:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706803407; cv=none; b=WFHymVsd3mE/tgfnF2qmbDB0u9HcXWaN9VrZLv3ofix6ixaLYcYjuFGc3UGA7kuQQOvkIijKDDOvZ9E0TBA95Fr5e1Dt6E/U48RWqDUU0w/1X8iRcWag8yl+n/HAurcNU6t8KlvpvxoTw8Drx8HhN5oxcAeAw8/V+hjmrbycYGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706803407; c=relaxed/simple;
	bh=EJmqbrqIJ3FH5+WRXMg4jroAaU9htXPNpxM5BsQhv1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=COKvHifAUFTp4wNcEfG7Eo7BSsOUFJwGCn4nTyxS+pCQDMCaBcYlSqMPTiIzJyAPfEbDNfIcqqpPzhcouNG4GmAZ2+FptWc5aFuFH+22Bxi+0kLybMLJKJWMpom3EoBK8EzTRB6f0wkHY02zaM1WovdgD0SYZ8VoN34PtjKcunY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A909FDA7;
	Thu,  1 Feb 2024 08:04:03 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC9523F738;
	Thu,  1 Feb 2024 08:03:19 -0800 (PST)
Message-ID: <db7a9399-702a-423a-8ad2-8ab7261a39ac@arm.com>
Date: Thu, 1 Feb 2024 16:03:18 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio: uapi: Drop __packed attribute in
 linux/virtio_pci.h
Content-Language: en-US
To: linux-kernel@vger.kernel.org, mst@redhat.com
Cc: kvm@vger.kernel.org, Feng Liu <feliu@nvidia.com>,
 Yishai Hadas <yishaih@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240125181227-mutt-send-email-mst@kernel.org>
 <20240125232039.913606-1-suzuki.poulose@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240125232039.913606-1-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/01/2024 23:20, Suzuki K Poulose wrote:
> Commit 92792ac752aa ("virtio-pci: Introduce admin command sending function")
> added "__packed" structures to UAPI header linux/virtio_pci.h. This triggers
> build failures in the consumer userspace applications without proper "definition"
> of __packed (e.g., kvmtool build fails).
> 
> Moreover, the structures are already packed well, and doesn't need explicit
> packing, similar to the rest of the structures in all virtio_* headers. Remove
> the __packed attribute.
> 
> Fixes: 92792ac752aa ("virtio-pci: Introduce admin command sending function")
> Cc: Feng Liu <feliu@nvidia.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---

Gentle ping.

Suzuki


> 
> Changes since v1:
>   - Fix description for the "Fixes" tag format
>   - Collect Tags from Jean-Philippe and Michael
> 
> ---
>   include/uapi/linux/virtio_pci.h | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> index ef3810dee7ef..a8208492e822 100644
> --- a/include/uapi/linux/virtio_pci.h
> +++ b/include/uapi/linux/virtio_pci.h
> @@ -240,7 +240,7 @@ struct virtio_pci_cfg_cap {
>   #define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
>   #define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
>   
> -struct __packed virtio_admin_cmd_hdr {
> +struct virtio_admin_cmd_hdr {
>   	__le16 opcode;
>   	/*
>   	 * 1 - SR-IOV
> @@ -252,20 +252,20 @@ struct __packed virtio_admin_cmd_hdr {
>   	__le64 group_member_id;
>   };
>   
> -struct __packed virtio_admin_cmd_status {
> +struct virtio_admin_cmd_status {
>   	__le16 status;
>   	__le16 status_qualifier;
>   	/* Unused, reserved for future extensions. */
>   	__u8 reserved2[4];
>   };
>   
> -struct __packed virtio_admin_cmd_legacy_wr_data {
> +struct virtio_admin_cmd_legacy_wr_data {
>   	__u8 offset; /* Starting offset of the register(s) to write. */
>   	__u8 reserved[7];
>   	__u8 registers[];
>   };
>   
> -struct __packed virtio_admin_cmd_legacy_rd_data {
> +struct virtio_admin_cmd_legacy_rd_data {
>   	__u8 offset; /* Starting offset of the register(s) to read. */
>   };
>   
> @@ -275,7 +275,7 @@ struct __packed virtio_admin_cmd_legacy_rd_data {
>   
>   #define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
>   
> -struct __packed virtio_admin_cmd_notify_info_data {
> +struct virtio_admin_cmd_notify_info_data {
>   	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
>   	__u8 bar; /* BAR of the member or the owner device */
>   	__u8 padding[6];


