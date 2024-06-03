Return-Path: <kvm+bounces-18640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC40F8D81B1
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43A641F22923
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8564086AC4;
	Mon,  3 Jun 2024 11:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKMomCzy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CF284A49
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717415754; cv=none; b=MNhukMNbbhQscuRXjxx8N0h4X5yn1Sjk9Tf1e2DdLkFh53T485TvuT/I7Udfmldfngc876KA3d6hHeJQm83GfFMxpJjQ+hql+Rk6dM0Tdn5B1H3cbg0GMZGES+K7f6IbzN7acn9bvnPfurBX5FXI/xoLII0z3Fcx3ukXgmr6lcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717415754; c=relaxed/simple;
	bh=AflJJBYuqHFcXzhY+0Ydj07HD0UoJoFDoHEHguGvC5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GG1GlBRUnnTaupvCylC6TvOwxHwyTto9P5OrNcLL9RTl90vsfocfJ9jvOYq6kPEwlsRcTx1aXULRuwldjPYeZEniQmoi6gKdecj7G0UN1OQoSwAETA8ZceWN0pPT75VdESUFIkjk95Fqc63K2YqGAzmD8pb0PHiX2ZrrOukhW8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKMomCzy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717415751;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=W62f82UZMHf0uefYVTTrEL80HQVAl8hkE/O4iaXRMVs=;
	b=UKMomCzyGqEQb8v5dbL1G223P5XJhO+wFIgsdTirvRKaq9823TvWh0GVDBG+bfTmHlqIvs
	nuVSSgDUal5wKGYbDpuHnqYgEN6/Ir/a2Mr/+0Va1yKimucM1HekYsP8LhoOKZEdpIQ+uW
	qZyl8EWHGHRsPqdmnSqSuRD3qiDllfc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-451-q5seXqRnOj6S-ekv4jK37Q-1; Mon,
 03 Jun 2024 07:55:47 -0400
X-MC-Unique: q5seXqRnOj6S-ekv4jK37Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E75371C0512B;
	Mon,  3 Jun 2024 11:55:46 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.80])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AD76C15C04;
	Mon,  3 Jun 2024 11:55:45 +0000 (UTC)
Date: Mon, 3 Jun 2024 12:55:43 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com,
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com,
	pbonzini@redhat.com, thomas.lendacky@amd.com,
	isaku.yamahata@intel.com, kvm@vger.kernel.org, anisinha@redhat.com
Subject: Re: [PATCH v4 29/31] hw/i386/sev: Allow use of pflash in conjunction
 with -bios
Message-ID: <Zl2vP9hohrgaPMTs@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-30-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240530111643.1091816-30-pankaj.gupta@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Thu, May 30, 2024 at 06:16:41AM -0500, Pankaj Gupta wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> SEV-ES and SEV-SNP support OVMF images with non-volatile storage in
> cases where the storage area is generated as a separate image as part
> of the OVMF build process.

IIUC, right now all OVMF builds for SEV/-ES/-SNP should be done as so
called "stateless" image. ie *without* any separate NVRAM image, because
that image will not be covered by the VM boot measurement and thus the
NVRAM state is liable to undermine  trust of the VM.

Using NVRAM for SNP is theoretically possible in future but would be
reliant on SVSM providing a secure encryption mechanism on the storage.



> 
> Currently these are exposed with unit=0 corresponding to the actual BIOS
> image, and unit=1 corresponding to the storage image. However, pflash
> images are mapped guest memory using read-only memslots, which are not
> allowed in conjunction with guest_memfd-backed ranges. This makes that
> approach unusable for SEV-SNP, where the BIOS range will be encrypted
> and mapped as private guest_memfd-backed memory. For this reason,
> SEV-SNP will instead rely on -bios to handle loading the BIOS image.
> 
> To allow for pflash to still be used for the storage image, rework the
> existing logic to remove assumptions that unit=0 contains the BIOS image
> when SEV-SNP, so that it can instead be used to handle only the storage
> image.

Mixing both BIOS and pflash is pretty undesirable, not least because
that setup cannot be currently represented by the firmware descriptor
format described by docs/interop/firmware.json.

So at the very least this patch is incomplete, as it would need to
propose changes to the firmware.json to allow this setup to be expressed.

I really wish we didn't have to introduce this though - is there really
no way to make it possible to use pflash for both CODE & VARS with SNP,
as is done with traditional VMs, so we don't diverge in setup, needing
yet more changes up the mgmt stack ?

> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>  hw/i386/pc_sysfw.c | 47 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> index def77a442d..7f97e62b16 100644
> --- a/hw/i386/pc_sysfw.c
> +++ b/hw/i386/pc_sysfw.c
> @@ -125,21 +125,10 @@ void pc_system_flash_cleanup_unused(PCMachineState *pcms)
>      }
>  }
>  
> -/*
> - * Map the pcms->flash[] from 4GiB downward, and realize.
> - * Map them in descending order, i.e. pcms->flash[0] at the top,
> - * without gaps.
> - * Stop at the first pcms->flash[0] lacking a block backend.
> - * Set each flash's size from its block backend.  Fatal error if the
> - * size isn't a non-zero multiple of 4KiB, or the total size exceeds
> - * pcms->max_fw_size.
> - *
> - * If pcms->flash[0] has a block backend, its memory is passed to
> - * pc_isa_bios_init().  Merging several flash devices for isa-bios is
> - * not supported.
> - */
> -static void pc_system_flash_map(PCMachineState *pcms,
> -                                MemoryRegion *rom_memory)
> +static void pc_system_flash_map_partial(PCMachineState *pcms,
> +                                        MemoryRegion *rom_memory,
> +                                        hwaddr offset,
> +                                        bool storage_only)
>  {
>      X86MachineState *x86ms = X86_MACHINE(pcms);
>      PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
> @@ -154,6 +143,8 @@ static void pc_system_flash_map(PCMachineState *pcms,
>  
>      assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
>  
> +    total_size = offset;
> +
>      for (i = 0; i < ARRAY_SIZE(pcms->flash); i++) {
>          hwaddr gpa;
>  
> @@ -192,7 +183,7 @@ static void pc_system_flash_map(PCMachineState *pcms,
>          sysbus_realize_and_unref(SYS_BUS_DEVICE(system_flash), &error_fatal);
>          sysbus_mmio_map(SYS_BUS_DEVICE(system_flash), 0, gpa);
>  
> -        if (i == 0) {
> +        if (i == 0 && !storage_only) {
>              flash_mem = pflash_cfi01_get_memory(system_flash);
>              if (pcmc->isa_bios_alias) {
>                  x86_isa_bios_init(&x86ms->isa_bios, rom_memory, flash_mem,
> @@ -211,6 +202,25 @@ static void pc_system_flash_map(PCMachineState *pcms,
>      }
>  }
>  
> +/*
> + * Map the pcms->flash[] from 4GiB downward, and realize.
> + * Map them in descending order, i.e. pcms->flash[0] at the top,
> + * without gaps.
> + * Stop at the first pcms->flash[0] lacking a block backend.
> + * Set each flash's size from its block backend.  Fatal error if the
> + * size isn't a non-zero multiple of 4KiB, or the total size exceeds
> + * pcms->max_fw_size.
> + *
> + * If pcms->flash[0] has a block backend, its memory is passed to
> + * pc_isa_bios_init().  Merging several flash devices for isa-bios is
> + * not supported.
> + */
> +static void pc_system_flash_map(PCMachineState *pcms,
> +                                MemoryRegion *rom_memory)
> +{
> +    pc_system_flash_map_partial(pcms, rom_memory, 0, false);
> +}
> +
>  void pc_system_firmware_init(PCMachineState *pcms,
>                               MemoryRegion *rom_memory)
>  {
> @@ -238,9 +248,12 @@ void pc_system_firmware_init(PCMachineState *pcms,
>          }
>      }
>  
> -    if (!pflash_blk[0]) {
> +    if (!pflash_blk[0] || sev_snp_enabled()) {
>          /* Machine property pflash0 not set, use ROM mode */
>          x86_bios_rom_init(X86_MACHINE(pcms), "bios.bin", rom_memory, false);
> +        if (sev_snp_enabled()) {
> +            pc_system_flash_map_partial(pcms, rom_memory, 3653632, true);
> +        }
>      } else {
>          if (kvm_enabled() && !kvm_readonly_mem_enabled()) {
>              /*
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


