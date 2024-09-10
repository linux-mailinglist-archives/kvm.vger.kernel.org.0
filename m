Return-Path: <kvm+bounces-26391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A94AD9745ED
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD64E1C214FC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D426B1ABECE;
	Tue, 10 Sep 2024 22:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Uw2TIwur";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="thBj5R5t";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OfGUfAHm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GFI0CEfj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7443117BB3D
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726007169; cv=none; b=S6r4yQeV3zB2FX5kJwxWLCDpScz8VFm3/1sQxc4LQVnax4dAHOjQ8B71vVYex5Z5XAFvrOlftSeVeuQ82yQzr40i//Trt9VvFYlLnt8azPPy1KkuyMKrlmfdG0koM33KQ2j1HqRD9SsWzsP60s1oDR31ZtWlnz1iohOtqfAXfZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726007169; c=relaxed/simple;
	bh=KHEH2dumcGJ+iWLRTO+Pudo/yr85yi/H4tL3yocRdFE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YqqynVPzn1dKI6I5Z9yuBndlotThdS7v2DrzN9sf+7a72DlVd466v1v9TG3vPJGoP9bSm0Ux6/tXiBuYnhMdzjt9IC5v+ah70yLPeJsWFE/905PYH7+auY6O7H3glJKu3bd92IuTeWZ5kp8oOk2vh4GHlvG8Ex69fXTpBbLS+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Uw2TIwur; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=thBj5R5t; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OfGUfAHm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GFI0CEfj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8AFE821A7B;
	Tue, 10 Sep 2024 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726007165; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xyKU/vmnk31FcTe/MsOvbzJI78hDjVUhHHGOtjP8OL4=;
	b=Uw2TIwurMWwrXhFc8ZEDLaHSFKjWsOWdy5g4ZfwyzXlyZJIX0QbJ2JjXnutnFeFqkkDheX
	LboU7fwlbdqoxeBXZWm9i6uy71vhiFM+caKc1ypvV/uLEakczT10a0Fvpgo1V8NEDn6MWJ
	oPtxW+eqcgWIELFiduuueQ7Rqp79LNU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726007165;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xyKU/vmnk31FcTe/MsOvbzJI78hDjVUhHHGOtjP8OL4=;
	b=thBj5R5tCaylH/cQy9u92YD6gqaoN8WJKCM0oO2+EyrNIkTqb2W6TCv1pm2194xDQ5846w
	1AzHpA3lY2Y59uBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OfGUfAHm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GFI0CEfj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726007164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xyKU/vmnk31FcTe/MsOvbzJI78hDjVUhHHGOtjP8OL4=;
	b=OfGUfAHm/MLJluU8DNo+wJZ3HR15vrr4c1nygO9wkcAxfKNV/yzIfg3U25Gbn1M9WMwJp3
	pr3OzD1ncXh41vRKYO7Z/8DQsDb5e1CkS4loYWgEKvpt9CUU0XULBnd2g3hsyhP8ya3MwI
	P3in5dibnETCM0FR1FujLFLD4dTWsDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726007164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xyKU/vmnk31FcTe/MsOvbzJI78hDjVUhHHGOtjP8OL4=;
	b=GFI0CEfjgoLr2GcKjjlN24Y5lwQdxzsjekbGhLNFdLG7ZrNABA8Xf2mDv72hG5LnRfmijp
	FOzcuqyVVH4o5gAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD6FC132CB;
	Tue, 10 Sep 2024 22:26:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7OZUKnvH4GYbOgAAD6G6ig
	(envelope-from <farosas@suse.de>); Tue, 10 Sep 2024 22:26:03 +0000
From: Fabiano Rosas <farosas@suse.de>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones"
 <rjones@redhat.com>, Joel Stanley <joel@jms.id.au>, Kevin Wolf
 <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, Corey Minyard <minyard@acm.org>, Eric Farman
 <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, Keith Busch
 <kbusch@kernel.org>, WANG Xuerui <git@xen0n.name>, Hyman Huang
 <yong.huang@smartx.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>, Alistair Francis
 <alistair.francis@wdc.com>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, qemu-riscv@nongnu.org, Ani Sinha
 <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, Jesper Devantier
 <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>, Peter Maydell
 <peter.maydell@linaro.org>, Igor Mammedov <imammedo@redhat.com>,
 kvm@vger.kernel.org, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard
 Henderson <richard.henderson@linaro.org>, Fam Zheng <fam@euphon.net>,
 qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Nicholas Piggin
 <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Laurent Vivier
 <lvivier@redhat.com>, Rob Herring <robh@kernel.org>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org, "Maciej S. Szmigiero"
 <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org, Daniel Henrique
 Barboza <danielhb413@gmail.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Nina
 Schoetterl-Glausch
 <nsg@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, Helge Deller
 <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>, Daniel
 Henrique Barboza <dbarboza@ventanamicro.com>, Akihiko Odaki
 <akihiko.odaki@daynix.com>, Marcelo Tosatti <mtosatti@redhat.com>, David
 Gibson <david@gibson.dropbear.id.au>, Aurelien Jarno
 <aurelien@aurel32.net>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Yanan
 Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>, Bin Meng
 <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>, Klaus Jensen
 <its@irrelevant.dk>, Jean-Christophe Dubois <jcd@tribudubois.net>, Jason
 Wang <jasowang@redhat.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: Re: [PATCH 21/39] migration: replace assert(false) with
 g_assert_not_reached()
In-Reply-To: <20240910221606.1817478-22-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-22-pierrick.bouvier@linaro.org>
Date: Tue, 10 Sep 2024 19:26:01 -0300
Message-ID: <87mskfqh6u.fsf@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 8AFE821A7B
X-Spam-Level: 
X-Spamd-Result: default: False [-5.00 / 50.00];
	BAYES_HAM(-2.99)[99.94%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_CC(0.00)[intel.com,redhat.com,jms.id.au,nongnu.org,acm.org,linux.ibm.com,kernel.org,xen0n.name,smartx.com,linux.vnet.ibm.com,gmail.com,wdc.com,ericsson.com,dabbelt.com,defmacro.it,vivier.eu,linaro.org,vger.kernel.org,euphon.net,habkost.net,oracle.com,gmx.de,ventanamicro.com,daynix.com,gibson.dropbear.id.au,aurel32.net,linux.alibaba.com,huawei.com,irrelevant.dk,tribudubois.net];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[64];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,linaro.org:email,suse.de:email,suse.de:dkim,suse.de:mid]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -5.00
X-Spam-Flag: NO

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>  migration/dirtyrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
> index 1d9db812990..a28c07327e8 100644
> --- a/migration/dirtyrate.c
> +++ b/migration/dirtyrate.c
> @@ -228,7 +228,7 @@ static int time_unit_to_power(TimeUnit time_unit)
>      case TIME_UNIT_MILLISECOND:
>          return -3;
>      default:
> -        assert(false); /* unreachable */
> +        g_assert_not_reached(); /* unreachable */
>          return 0;
>      }
>  }

You could drop the comment that's now redundant.

Reviewed-by: Fabiano Rosas <farosas@suse.de>

