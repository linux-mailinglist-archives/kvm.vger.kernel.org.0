Return-Path: <kvm+bounces-67711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88433D119BA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 82D4D30542A2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9694C274B44;
	Mon, 12 Jan 2026 09:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QHic1MFj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F6926ED3F
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768211247; cv=none; b=DF/86nUt+qpvyNHMkw9727slMCJMTS+FrFRUvql/+vS95IuxwYgZKzKOPokomejWqVW5n0lRGAd1K9H80Qejzjfo4VebJC9oygLfiBLtZBwIKAH9gAbWLBS4PzfCe4rhEAbbuUdRW5z4p1k1yqCeaRGZWhMvg+PB802wrBOh7qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768211247; c=relaxed/simple;
	bh=mfQKeGrsediPlMzqizlKHHq5A8KP+0h20vSWP+ngmFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itF0dB/FqibAqQzlsmLTdDAmB/hNgsZkerxBBpULmsIhg0SKKkQC9yhgmWplDtbZYcfyQTPK8aPqiXpKP9S1uclXXFG6GeHdW3TCZNzPz9aiYclhtJqq3TOFU47pxabzdmPXJuqjuT0jNLbkgoXAcGm5rCfkxrNBOBWcdLCaOmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QHic1MFj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768211245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/xpliJRmZXL3L44FnOh0EpPOSn7gZgd4Fhy2XaIEneg=;
	b=QHic1MFj7+PoxKg9Vll2JzO7NfHUWqktX8lCjHXuRd/l7Nl7YV7YlqHFeaUPyCaA9nGhwK
	6jVsD6OECUjyWv2Pp7bpzEzZiFpd03TKopycDsydrz0nTwFFbQrxANam7J6nosFxpeRwP8
	sNo/YGWfqCbIz/6n+wZtwnuYhqvWCmE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-2tobds9zNwWwM0Aql9vJrw-1; Mon,
 12 Jan 2026 04:47:21 -0500
X-MC-Unique: 2tobds9zNwWwM0Aql9vJrw-1
X-Mimecast-MFC-AGG-ID: 2tobds9zNwWwM0Aql9vJrw_1768211240
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF91F1800365;
	Mon, 12 Jan 2026 09:47:19 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.45.224.56])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8911A30001A2;
	Mon, 12 Jan 2026 09:47:18 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 3351F1800081; Mon, 12 Jan 2026 10:47:16 +0100 (CET)
Date: Mon, 12 Jan 2026 10:47:16 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Luigi Leonardi <leonardi@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v3 1/6] hw/acpi: Make BIOS linker optional
Message-ID: <aWTCtoVLqRGkF3Y2@sirius.home.kraxel.org>
References: <20260109143413.293593-1-osteffen@redhat.com>
 <20260109143413.293593-2-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109143413.293593-2-osteffen@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Jan 09, 2026 at 03:34:08PM +0100, Oliver Steffen wrote:
> Make the BIOS linker optional in acpi_table_end().
> This makes it possible to call for example
> acpi_build_madt() from outside the ACPI table builder context.
> 
> Signed-off-by: Oliver Steffen <osteffen@redhat.com>
> ---
>  hw/acpi/aml-build.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
> index 2d5826a8f1..ed86867ae3 100644
> --- a/hw/acpi/aml-build.c
> +++ b/hw/acpi/aml-build.c
> @@ -1748,8 +1748,11 @@ void acpi_table_end(BIOSLinker *linker, AcpiTable *desc)
>       */
>      memcpy(len_ptr, &table_len_le, sizeof table_len_le);
>  
> -    bios_linker_loader_add_checksum(linker, ACPI_BUILD_TABLE_FILE,
> -        desc->table_offset, table_len, desc->table_offset + checksum_offset);
> +    if (linker != NULL) {
> +        bios_linker_loader_add_checksum(linker, ACPI_BUILD_TABLE_FILE,
> +                                        desc->table_offset, table_len,
> +                                        desc->table_offset + checksum_offset);
> +    }

else {
	// calculate + fill checksum directly
}

take care,
  Gerd


