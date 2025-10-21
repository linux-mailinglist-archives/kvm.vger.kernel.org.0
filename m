Return-Path: <kvm+bounces-60657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A8CEBF5F34
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 13:08:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 83DA14E5424
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 11:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4982B2F28EB;
	Tue, 21 Oct 2025 11:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ubj3blZh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rnq1UIRV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="B/lq3WTD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dx2E3qT9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE079189F20
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 11:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761044893; cv=none; b=gs6iJYetoZU9uQXub6hkhQ3BpXxJSi1dwkTMfMsz2wZZyeF1++HCXZQXfKdSNZv8JR+Uy37stcGvnLTBOh9i7rnBSDjxZ3qgQw/Uaowksu7YY6XwbNnPWz5kkPrDU9Jd0WQV0YqtA+jSXS7fW1FIbfkvpZ6MIKRhQAyXCkIxAe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761044893; c=relaxed/simple;
	bh=DbtyNuRktw7R6edieFJwQL0E1aEpLyO994NJ3NxhaQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVWibJkeUtcNCljXCgbSqRviXAKyPgAb738tmmp+C+8quk+BsDRV9cityTeeuisJKO0pEvhaBOwfK6+VubWkPHM5e50riZVBFhn/lMq0Rc26gg5Bq7RHvROfTDRUH5g/a8Z0thkP8MEZwQG6gGIVW1uShqr6ZXCFmycvMviTPP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ubj3blZh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rnq1UIRV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=B/lq3WTD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dx2E3qT9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from kitsune.suse.cz (unknown [10.100.12.127])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 82D611F397;
	Tue, 21 Oct 2025 11:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761044884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AaBBd+XdryUfpAsID7YC7Ekp97FYZ09q7tdZODr7lks=;
	b=ubj3blZhn7dJbHx6ALKD0ISKr/cmhyzYQl2hRSLgIKbVR92Fp3/hJgCoP7Whj+7OUHlMA9
	cZlT7drJ6jg4OLmJbPSHfnPZPKesiCsVDQsH0fjnRCXrL2yGohWqqRFpY9pspJhUQ3luzN
	8ZmQUY2/rpg7FGKTIgqDZeuHJCXuhts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761044884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AaBBd+XdryUfpAsID7YC7Ekp97FYZ09q7tdZODr7lks=;
	b=rnq1UIRVjq6ZITQA/eaMk71CQCsyuxsbrstkgcjh7EhOTXUCUL4LCR0XY+FvFNCdsGmkNT
	ydQxx2pJRI8Q8UCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761044880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AaBBd+XdryUfpAsID7YC7Ekp97FYZ09q7tdZODr7lks=;
	b=B/lq3WTD319V36Nb4MLJVyyeULhm50bw+ULGwvnlOEDhiF5yx39eauFSn71Lj7yh0Cylc+
	6vN2HBcj0a226D5Yp8aKq5uBXPTiS2/Nc9qFUfblU7zBjNhe4yUax+c22mG6JrRJ9rHbXH
	xmy5O6EtL3G26o1QI6mddXv9lWtsDHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761044880;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AaBBd+XdryUfpAsID7YC7Ekp97FYZ09q7tdZODr7lks=;
	b=dx2E3qT9/Gvlkm58DN/iTQygC9LYkVHzTXnwGobWYkBE3ylrhqeh8jsw66DlyCq7Tdhu7p
	uf//8HCHtTa3NeCQ==
Date: Tue, 21 Oct 2025 13:07:59 +0200
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 00/11] hw/ppc/spapr: Remove deprecated pseries-3.0 ->
 pseries-4.2 machines
Message-ID: <aPdpjysqFBAMTvG-@kitsune.suse.cz>
References: <20251021084346.73671-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251021084346.73671-1-philmd@linaro.org>
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_COUNT_ZERO(0.00)[0];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[kitsune.suse.cz:mid,kitsune.suse.cz:helo];
	FREEMAIL_CC(0.00)[nongnu.org,linux.ibm.com,gmail.com,vger.kernel.org,redhat.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.30

Hello,

I noticed removal of old pSeries revisions.

FTR to boot Linux 3.0 I need pSeries-2.7 (already removed earlier).

The thing that broke booting linux 3.0 for me is
357d1e3bc7d2d80e5271bc4f3ac8537e30dc8046 spapr: Improved placement of
PCI host bridges in guest memory map

I do not use Linux 3.0 anymore which is the reason I did not notice this
breakage due to old platform revision removal.

At the same time quemu is sometimes touted as a way to run old OS
revisions. That does not work very well for pSeries.

Thanks

Michal

On Tue, Oct 21, 2025 at 10:43:34AM +0200, Philippe Mathieu-Daudé wrote:
> v2: Rebased on https://lore.kernel.org/qemu-devel/20251009184057.19973-1-harshpb@linux.ibm.com/
> 
> Remove the deprecated pseries-3.0 up to pseries-4.2 machines,
> which are older than 6 years. Remove resulting dead code.
> 
> Harsh Prateek Bora (5):
>   ppc/spapr: remove deprecated machine pseries-3.0
>   ppc/spapr: remove deprecated machine pseries-3.1
>   ppc/spapr: remove deprecated machine pseries-4.0
>   ppc/spapr: remove deprecated machine pseries-4.1
>   ppc/spapr: remove deprecated machine pseries-4.2
> 
> Philippe Mathieu-Daudé (6):
>   hw/ppc/spapr: Remove SpaprMachineClass::nr_xirqs field
>   hw/ppc/spapr: Inline spapr_dtb_needed()
>   hw/ppc/spapr: Inline few SPAPR_IRQ_* uses
>   target/ppc/kvm: Remove kvmppc_get_host_serial() as unused
>   target/ppc/kvm: Remove kvmppc_get_host_model() as unused
>   hw/ppc/spapr: Remove SpaprMachineClass::phb_placement callback
> 
>  include/hw/ppc/spapr.h     |  16 --
>  include/hw/ppc/spapr_irq.h |   1 -
>  target/ppc/kvm_ppc.h       |  12 --
>  hw/ppc/spapr.c             | 299 ++++++++-----------------------------
>  hw/ppc/spapr_caps.c        |  12 +-
>  hw/ppc/spapr_events.c      |  20 +--
>  hw/ppc/spapr_hcall.c       |   5 -
>  hw/ppc/spapr_irq.c         |  36 +----
>  hw/ppc/spapr_pci.c         |  32 +---
>  hw/ppc/spapr_vio.c         |   9 --
>  target/ppc/kvm.c           |  11 --
>  11 files changed, 77 insertions(+), 376 deletions(-)
> 
> -- 
> 2.51.0
> 
> 

