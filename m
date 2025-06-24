Return-Path: <kvm+bounces-50470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B11CAE60B7
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 11:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 173273A3861
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C53F27B4E4;
	Tue, 24 Jun 2025 09:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MSed/gOg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FGlHU6cT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MSed/gOg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FGlHU6cT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B936823E347
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750756888; cv=none; b=X7+w2mlXNS+cn5zDR8YRj5LtXis3SciwIl8kb3drDQspX+DqqLf8VIr9uPhV12F4U6F5T462JVVc8mt+/mjeIRJgmD0LEHuc0FedngHvZAjHxBgQ60yMCmwfjx/43mHp9/rEO3OXg6ZFiYO7+4GwVtT66mP+vonv9VJz/4O/jAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750756888; c=relaxed/simple;
	bh=1VmIHrEJi7+TgM2h1vNk30KZb3WSLgma3zwXqeBdNN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fg++bNkgyBesuC9+rpfEDRoa2rY/to9PcwjasFz4eDu30gs/3ntdUgZL1y5zVNEgl1oAjKv9v6MSnndm0vZ9DdmxIAmO0NsG5vIR2IGZu0+ad4YxmOxI2AuEGUF6OYYy11tIzCNSxRmC0qGcOBc56JhuuW+NZUdObMKvSQQvhC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MSed/gOg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FGlHU6cT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MSed/gOg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FGlHU6cT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A1E821186;
	Tue, 24 Jun 2025 09:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750756885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VXfbAXcdsqOmp2mop/iwlMbChu1Cr1eVbF/0uqm/7eM=;
	b=MSed/gOgqnQMvyfCjYnczvc3IIOJRm+lQ4iB8eDpuvw1Vtq4mmd4zG8FMyXqbx01sGnrtq
	ta3DPWmRpinGmbl2+JT+z2p1e5Q/iZFa0FoSS67jw8QXEUTrBTCQZIjLaFKFbqxOzJTqMb
	nYG3v3cNgFwIjYb4Mq+33qblClEHaCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750756885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VXfbAXcdsqOmp2mop/iwlMbChu1Cr1eVbF/0uqm/7eM=;
	b=FGlHU6cT4cAUQ1HfmA3Mhak0dB8Oqk72snpqC3eeFTOY87QFb3LFWnBxyasdPwxoBW8OJT
	BykEH6NUv5bteDBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750756885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VXfbAXcdsqOmp2mop/iwlMbChu1Cr1eVbF/0uqm/7eM=;
	b=MSed/gOgqnQMvyfCjYnczvc3IIOJRm+lQ4iB8eDpuvw1Vtq4mmd4zG8FMyXqbx01sGnrtq
	ta3DPWmRpinGmbl2+JT+z2p1e5Q/iZFa0FoSS67jw8QXEUTrBTCQZIjLaFKFbqxOzJTqMb
	nYG3v3cNgFwIjYb4Mq+33qblClEHaCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750756885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VXfbAXcdsqOmp2mop/iwlMbChu1Cr1eVbF/0uqm/7eM=;
	b=FGlHU6cT4cAUQ1HfmA3Mhak0dB8Oqk72snpqC3eeFTOY87QFb3LFWnBxyasdPwxoBW8OJT
	BykEH6NUv5bteDBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 773B113751;
	Tue, 24 Jun 2025 09:21:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Iqi5GxRuWmg2GwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 24 Jun 2025 09:21:24 +0000
Message-ID: <f0e70269-b55e-4ac8-b052-da092a177eda@suse.de>
Date: Tue, 24 Jun 2025 11:21:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/8] PCI/VGA: Move check for firmware default out of
 VGA arbiter
To: Mario Limonciello <superm1@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Lukas Wunner <lukas@wunner.de>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux.dev>,
 "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
 "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
 "open list:SOUND" <linux-sound@vger.kernel.org>,
 Daniel Dadap <ddadap@nvidia.com>,
 Mario Limonciello <mario.limonciello@amd.com>
References: <20250623184757.3774786-1-superm1@kernel.org>
 <20250623184757.3774786-8-superm1@kernel.org>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <20250623184757.3774786-8-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[amd.com,gmail.com,ffwll.ch,wunner.de,linux.intel.com,kernel.org,infradead.org,8bytes.org,arm.com,redhat.com,perex.cz,suse.com,lists.freedesktop.org,vger.kernel.org,lists.linux.dev,nvidia.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,suse.de:mid,suse.de:email]
X-Spam-Level: 



Am 23.06.25 um 20:47 schrieb Mario Limonciello:
> From: Mario Limonciello <mario.limonciello@amd.com>
>
> The x86 specific check for whether a framebuffer belongs to a device
> works for display devices as well as VGA devices.  Callers to
> video_is_primary_device() can benefit from checking non-VGA display
> devices.
>
> Move the x86 specific check into x86 specific code, and adjust VGA
> arbiter to call that code as well. This allows fbcon to find the
> right PCI device on systems that don't have VGA devices.
>
> Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v4:
>   * use helper
> ---
>   arch/x86/video/video-common.c | 13 ++++++++++++-
>   drivers/pci/vgaarb.c          | 36 ++---------------------------------
>   2 files changed, 14 insertions(+), 35 deletions(-)
>
> diff --git a/arch/x86/video/video-common.c b/arch/x86/video/video-common.c
> index 81fc97a2a837a..917568e4d7fb1 100644
> --- a/arch/x86/video/video-common.c
> +++ b/arch/x86/video/video-common.c
> @@ -9,6 +9,7 @@
>   
>   #include <linux/module.h>
>   #include <linux/pci.h>
> +#include <linux/screen_info.h>
>   #include <linux/vgaarb.h>
>   
>   #include <asm/video.h>
> @@ -27,6 +28,7 @@ EXPORT_SYMBOL(pgprot_framebuffer);
>   
>   bool video_is_primary_device(struct device *dev)
>   {
> +	struct screen_info *si = &screen_info;
>   	struct pci_dev *pdev;
>   
>   	if (!dev_is_pci(dev))
> @@ -34,7 +36,16 @@ bool video_is_primary_device(struct device *dev)
>   
>   	pdev = to_pci_dev(dev);
>   
> -	return (pdev == vga_default_device());
> +	if (!pci_is_display(pdev))
> +		return false;
> +
> +	if (pdev == vga_default_device())
> +		return true;
> +
> +	if (pdev == screen_info_pci_dev(si))
> +		return true;
> +
> +	return false;
>   }
>   EXPORT_SYMBOL(video_is_primary_device);
>   
> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
> index 78748e8d2dbae..15ab58c70b016 100644
> --- a/drivers/pci/vgaarb.c
> +++ b/drivers/pci/vgaarb.c
> @@ -26,12 +26,12 @@
>   #include <linux/poll.h>
>   #include <linux/miscdevice.h>
>   #include <linux/slab.h>
> -#include <linux/screen_info.h>
>   #include <linux/vt.h>
>   #include <linux/console.h>
>   #include <linux/acpi.h>
>   #include <linux/uaccess.h>
>   #include <linux/vgaarb.h>
> +#include <asm/video.h>
>   
>   static void vga_arbiter_notify_clients(void);
>   
> @@ -554,38 +554,6 @@ void vga_put(struct pci_dev *pdev, unsigned int rsrc)
>   }
>   EXPORT_SYMBOL(vga_put);
>   
> -static bool vga_is_firmware_default(struct pci_dev *pdev)
> -{
> -#if defined(CONFIG_X86)
> -	u64 base = screen_info.lfb_base;
> -	u64 size = screen_info.lfb_size;
> -	struct resource *r;
> -	u64 limit;
> -
> -	/* Select the device owning the boot framebuffer if there is one */
> -
> -	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> -		base |= (u64)screen_info.ext_lfb_base << 32;
> -
> -	limit = base + size;
> -
> -	/* Does firmware framebuffer belong to us? */
> -	pci_dev_for_each_resource(pdev, r) {
> -		if (resource_type(r) != IORESOURCE_MEM)
> -			continue;
> -
> -		if (!r->start || !r->end)
> -			continue;
> -
> -		if (base < r->start || limit >= r->end)
> -			continue;
> -
> -		return true;
> -	}
> -#endif
> -	return false;
> -}
> -
>   static bool vga_arb_integrated_gpu(struct device *dev)
>   {
>   #if defined(CONFIG_ACPI)
> @@ -623,7 +591,7 @@ static bool vga_is_boot_device(struct vga_device *vgadev)
>   	if (boot_vga && boot_vga->is_firmware_default)
>   		return false;
>   
> -	if (vga_is_firmware_default(pdev)) {
> +	if (video_is_primary_device(&pdev->dev)) {

Doesn't this generate a cyclic dependency between vgaarb and video? I 
find this call cycle hard to reason about because 
vgaarb_default_device() depends on the results of these boot-device 
tests. Maybe keep vga_is_firmware_default() and just replace its content 
with a call to screen_info_pci_dev().
Best regards
Thomas

>   		vgadev->is_firmware_default = true;
>   		return true;
>   	}

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstrasse 146, 90461 Nuernberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
HRB 36809 (AG Nuernberg)


