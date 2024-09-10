Return-Path: <kvm+bounces-26390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8259745EB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:25:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 293571F27185
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1421ABECD;
	Tue, 10 Sep 2024 22:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IsJPlDel";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+WN70kXv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IsJPlDel";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+WN70kXv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD77817BB3D
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726007117; cv=none; b=AosMSv8W+fx69KBmB9j5PbIzC1yNv2XzHz3xiM93z6tl2eerrvBZ/vCPMdzZwBajMiMWzWPRcu1aMVIrpBIncKbAyzPAJuL8DDp9iexwSFrrNB4XJjxfpD4+DmuiGQVaynnwDxHWhx0KgbPrLVn+2Uc2uRoahILB20ytNmlZgII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726007117; c=relaxed/simple;
	bh=964TAfua5Dy0nuXre0wI7J9Jd2aoCVngcNHjIHTW2V8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hC6oQ/ljP3RTBc12eJFN87Gj6jAki09e+XIckDYul9Yu2U8XwOnn7SUlcB/Dvs8Tq8rIl7mDDdTutYyTVA0M/yhWcWubxrVurKU6NdKxHSZfOhj3Yk/rPklthBzVWFSrdIe0CVviSVWYPO9jD0kj4a2Q4w5vXCPgFTIpoKuJ8cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IsJPlDel; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+WN70kXv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IsJPlDel; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+WN70kXv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BC4B521A5D;
	Tue, 10 Sep 2024 22:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726007113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ngJZupkt611k1HwvHZHIrGAiSEDttJWiwH4VezFYDA=;
	b=IsJPlDelGX+nr5/FOwAUoKaLDkVeGRuJsjO5Ttp4G9CVC8eAQ6FHB2Xq8OP01tyhxwVDav
	iE717wPn8F3aN4GfLXvPenoYL+iwTd4Ois6/1tyh0KpZFNFqpY71qwVM0Zvs9MwNUskY4G
	cCHTofFJ4qY03+SV7OnoAaZ4rE6z6sc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726007113;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ngJZupkt611k1HwvHZHIrGAiSEDttJWiwH4VezFYDA=;
	b=+WN70kXvXhiKPcyECLNcD1EOXXM2KPPgNHW0tek0hOiIIoHIYJJEOGAY5gHwpFw6254f9c
	UPV9Pe4BS9VBkVBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IsJPlDel;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+WN70kXv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726007113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ngJZupkt611k1HwvHZHIrGAiSEDttJWiwH4VezFYDA=;
	b=IsJPlDelGX+nr5/FOwAUoKaLDkVeGRuJsjO5Ttp4G9CVC8eAQ6FHB2Xq8OP01tyhxwVDav
	iE717wPn8F3aN4GfLXvPenoYL+iwTd4Ois6/1tyh0KpZFNFqpY71qwVM0Zvs9MwNUskY4G
	cCHTofFJ4qY03+SV7OnoAaZ4rE6z6sc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726007113;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ngJZupkt611k1HwvHZHIrGAiSEDttJWiwH4VezFYDA=;
	b=+WN70kXvXhiKPcyECLNcD1EOXXM2KPPgNHW0tek0hOiIIoHIYJJEOGAY5gHwpFw6254f9c
	UPV9Pe4BS9VBkVBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD737132CB;
	Tue, 10 Sep 2024 22:25:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9MvrNUjH4GbMOQAAD6G6ig
	(envelope-from <farosas@suse.de>); Tue, 10 Sep 2024 22:25:12 +0000
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
Subject: Re: [PATCH 08/39] migration: replace assert(0) with
 g_assert_not_reached()
In-Reply-To: <20240910221606.1817478-9-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-9-pierrick.bouvier@linaro.org>
Date: Tue, 10 Sep 2024 19:25:10 -0300
Message-ID: <87plpbqh89.fsf@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: BC4B521A5D
X-Spam-Level: 
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,redhat.com,jms.id.au,nongnu.org,acm.org,linux.ibm.com,kernel.org,xen0n.name,smartx.com,linux.vnet.ibm.com,gmail.com,wdc.com,ericsson.com,dabbelt.com,defmacro.it,vivier.eu,linaro.org,vger.kernel.org,euphon.net,habkost.net,oracle.com,gmx.de,ventanamicro.com,daynix.com,gibson.dropbear.id.au,aurel32.net,linux.alibaba.com,huawei.com,irrelevant.dk,tribudubois.net];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_GT_50(0.00)[64];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,linaro.org:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -5.01
X-Spam-Flag: NO

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>  migration/migration-hmp-cmds.c |  2 +-
>  migration/postcopy-ram.c       | 14 +++++++-------
>  migration/ram.c                |  6 +++---
>  3 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/migration/migration-hmp-cmds.c b/migration/migration-hmp-cmds.c
> index 7d608d26e19..e6e96aa6288 100644
> --- a/migration/migration-hmp-cmds.c
> +++ b/migration/migration-hmp-cmds.c
> @@ -636,7 +636,7 @@ void hmp_migrate_set_parameter(Monitor *mon, const QDict *qdict)
>          visit_type_bool(v, param, &p->direct_io, &err);
>          break;
>      default:
> -        assert(0);
> +        g_assert_not_reached();
>      }
>  
>      if (err) {
> diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
> index 1c374b7ea1e..f431bbc0d4f 100644
> --- a/migration/postcopy-ram.c
> +++ b/migration/postcopy-ram.c
> @@ -1411,40 +1411,40 @@ int postcopy_ram_incoming_init(MigrationIncomingState *mis)
>  
>  int postcopy_ram_incoming_cleanup(MigrationIncomingState *mis)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>      return -1;
>  }
>  
>  int postcopy_ram_prepare_discard(MigrationIncomingState *mis)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>      return -1;
>  }
>  
>  int postcopy_request_shared_page(struct PostCopyFD *pcfd, RAMBlock *rb,
>                                   uint64_t client_addr, uint64_t rb_offset)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>      return -1;
>  }
>  
>  int postcopy_ram_incoming_setup(MigrationIncomingState *mis)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>      return -1;
>  }
>  
>  int postcopy_place_page(MigrationIncomingState *mis, void *host, void *from,
>                          RAMBlock *rb)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>      return -1;
>  }
>  
>  int postcopy_place_page_zero(MigrationIncomingState *mis, void *host,
>                          RAMBlock *rb)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>      return -1;
>  }
>  
> @@ -1452,7 +1452,7 @@ int postcopy_wake_shared(struct PostCopyFD *pcfd,
>                           uint64_t client_addr,
>                           RAMBlock *rb)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>      return -1;
>  }
>  #endif
> diff --git a/migration/ram.c b/migration/ram.c
> index 67ca3d5d51a..0aa5d347439 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -1765,19 +1765,19 @@ bool ram_write_tracking_available(void)
>  
>  bool ram_write_tracking_compatible(void)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>      return false;
>  }
>  
>  int ram_write_tracking_start(void)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>      return -1;
>  }
>  
>  void ram_write_tracking_stop(void)
>  {
> -    assert(0);
> +    g_assert_not_reached();
>  }
>  #endif /* defined(__linux__) */

Reviewed-by: Fabiano Rosas <farosas@suse.de>

