Return-Path: <kvm+bounces-50951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22D3EAEAF33
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 08:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FB324E0BD3
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 06:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A69217F53;
	Fri, 27 Jun 2025 06:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D+V3PWQS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FWyCg1vt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D+V3PWQS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FWyCg1vt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E5A21517C
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 06:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751007075; cv=none; b=Cl2OqUVX5Ma23axi/P4ojsa+j/3SITUmKKHTlsifoBORiby3MHv3ntLlcPDRJCAym1iuqFg+OuDnIkCaATLiNcW4zDxVAfSEYdTJLLVDW3bTa0+A6M9eznbK1R3U6UyYuUt23FZFei//J+Bm6H4Qe7Gh0tX/J8jSKRuhxJMZweo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751007075; c=relaxed/simple;
	bh=IsoQY2OF4h28QLFNyHbtWM9Z7+gpRWPjDXcYAxaZTBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jO3TWpLWddyXs2YYKmsqqsr03OUy3yAIbHAaxwlFGIBe11NwgVnHWu14eD1/G/YzKhwvmYHyN7D6CCMOt8QGcIUoUHOxS3OJSH7+9vzhQgp7gTuLHWzhaN4RJ/7z8Z/OE64Gx8JBJ3aHMR3I6wPxYOAv+BfpFIKLdRO2Bd4MZBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D+V3PWQS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FWyCg1vt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D+V3PWQS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FWyCg1vt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0E4DB2116B;
	Fri, 27 Jun 2025 06:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751007072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g4LXbAAUippkeeXQUWYXMF4i0Pu0+xEpthWYGcl+dNA=;
	b=D+V3PWQSry1H18jcwfxT2ZiC7vuADMiqtS3LBL5fccyDDX3LWpz5zqZBYpjf7Mstq+3ads
	XBH5Uh0u3oHI2WnnomoFelU5Nv9mOoHIpwoeX3EprxRhHwGcdr8JOWx0v0iTuZ92lB7dK3
	Y01nf/Lu+oIp/Tzkj8pYUUSyUHFAHqg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751007072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g4LXbAAUippkeeXQUWYXMF4i0Pu0+xEpthWYGcl+dNA=;
	b=FWyCg1vtGD9HsNCvw4wXl8haw6ZvFY+CBZ9AGTQ2fCqMKSXFJrz0TwMvk4CaLXnVr2+a+J
	NeTVy0jZMWs/9vAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751007072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g4LXbAAUippkeeXQUWYXMF4i0Pu0+xEpthWYGcl+dNA=;
	b=D+V3PWQSry1H18jcwfxT2ZiC7vuADMiqtS3LBL5fccyDDX3LWpz5zqZBYpjf7Mstq+3ads
	XBH5Uh0u3oHI2WnnomoFelU5Nv9mOoHIpwoeX3EprxRhHwGcdr8JOWx0v0iTuZ92lB7dK3
	Y01nf/Lu+oIp/Tzkj8pYUUSyUHFAHqg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751007072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g4LXbAAUippkeeXQUWYXMF4i0Pu0+xEpthWYGcl+dNA=;
	b=FWyCg1vtGD9HsNCvw4wXl8haw6ZvFY+CBZ9AGTQ2fCqMKSXFJrz0TwMvk4CaLXnVr2+a+J
	NeTVy0jZMWs/9vAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 69A71138A7;
	Fri, 27 Jun 2025 06:51:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id s4FiGF8/XmjgPgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 27 Jun 2025 06:51:11 +0000
Message-ID: <d8ca2ed5-5656-405b-bf30-defcbc20c619@suse.de>
Date: Fri, 27 Jun 2025 08:51:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 8/9] fbcon: Use screen info to find primary device
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
References: <20250627043108.3141206-1-superm1@kernel.org>
 <20250627043108.3141206-9-superm1@kernel.org>
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
In-Reply-To: <20250627043108.3141206-9-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[amd.com,gmail.com,ffwll.ch,wunner.de,linux.intel.com,kernel.org,infradead.org,8bytes.org,arm.com,redhat.com,perex.cz,suse.com,lists.freedesktop.org,vger.kernel.org,lists.linux.dev,nvidia.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Level: 

Hi

Am 27.06.25 um 06:31 schrieb Mario Limonciello:
> From: Mario Limonciello <mario.limonciello@amd.com>
>
> On systems with non VGA GPUs fbcon can't find the primary GPU because
> video_is_primary_device() only checks the VGA arbiter.
>
> Add a screen info check to video_is_primary_device() so that callers
> can get accurate data on such systems.
>
> Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Thanks for sticking with it. This patch is also useful without the sysfs 
interface.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

Best regards
Thomas

> ---
> v5:
>   * Only change video-common.c
> v4:
>   * use helper
> ---
>   arch/x86/video/video-common.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
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

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstrasse 146, 90461 Nuernberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
HRB 36809 (AG Nuernberg)


