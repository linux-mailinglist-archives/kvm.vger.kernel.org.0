Return-Path: <kvm+bounces-70024-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0DHfLWUlgmnPPgMAu9opvQ
	(envelope-from <kvm+bounces-70024-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 17:42:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC64DC244
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 17:42:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F1A4C313A0A5
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 16:32:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2453D3017;
	Tue,  3 Feb 2026 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RIlx7ISO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CkxsqLcq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A0A318131
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770136363; cv=none; b=axOqttAHE+Y4q561TKx69TNTAa7bLVB+ZBSTr0E49y39PqKzI9xPBrZQTgV/UxoHWyOogh/HqOqOzoPJgG3tYCBvzqFlWKt/39gTaKf3eJWTbw9fHL613aXlWL7QhhU3myzZWq2Qp/X6Vft+Ba8PmtWc/LuqFqaX9+4c57I4H9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770136363; c=relaxed/simple;
	bh=nMDYywolTcpM9+HqumygzRHiQf/9SwXRdwGj7z3TGDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rzc+wMo6AhRHqRo4hoTtkJkQFApBaCJKX0jotYABEbI+ULh/qAZJs2ywDsHeNTeD6ME8x8pNoC7qrMK73c4nRDKavDi9Ufg8sEJ+AxicpTHaFL55TyGDFKntfJiMfbvZtWFkz+8d24zxQ2Mb92qUyqci5I5I++Dbxwk6cb50LDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RIlx7ISO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CkxsqLcq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770136361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=owGj0OJ2wCHGfsqeNdhXTREIrZPWZ7iLe7nJQieUIZI=;
	b=RIlx7ISOFKuipIj9d0aSnSgCFqkYW7b35dnes9u0ivR1boMLx2mONyMooP+PsEhoU/RD3z
	DUtBbfLPlpLRPUR4T95G62/9YvbrBybUFqSPle6yYun1zgdyhEqY7Iajv3C5N156keN8ya
	xuCmMVqnnHVloTpDqrM3bgz5IZ765Io=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-ATDYQbcnMJ2Ryne7_K3hOA-1; Tue, 03 Feb 2026 11:32:40 -0500
X-MC-Unique: ATDYQbcnMJ2Ryne7_K3hOA-1
X-Mimecast-MFC-AGG-ID: ATDYQbcnMJ2Ryne7_K3hOA_1770136358
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4803b4e3b9eso47627745e9.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 08:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770136358; x=1770741158; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=owGj0OJ2wCHGfsqeNdhXTREIrZPWZ7iLe7nJQieUIZI=;
        b=CkxsqLcqYnh8eofuOTCHFMKyoDM96hU+nFI5RQCz6sitA/Dtus5kvxWmaMoWG6qct1
         7F370Vj0mum5KH2YFNI2Ul7zGIJtX6AEF0my02ZeUG9WRUylBTt7sRxEjgWYyvwY/e1D
         ofLJidoPG6ia2xmcsoysh/fp1NV0M/pFMrmRyOLRk3g6jScqellBiFa5TS3BCmA/65xL
         p1EjZDHeyCbModPxAOpBDkhdltMz2/OVEavHyAlbLyLXA2utLvaxxseBjOhymqlY4ArJ
         VpI7bPKYggkBnHL9EbBPu5Bu4cCGv/aAUBS/036AiZnZuur5XyZZkkF5IcQYcX7J9XVm
         VKfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770136358; x=1770741158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=owGj0OJ2wCHGfsqeNdhXTREIrZPWZ7iLe7nJQieUIZI=;
        b=eiTQYxylel6SmTbMZkK2AQPYR5FC9Nsc4PfyOuEh7v6r5DIUuWD2SYtLDHajIiQCys
         2JOrNmfaYauUZbzyR0NX+yrdhk9mNaeIKZGwfBlVKoTHoTtqBMNexf6EF5OXftsBX8v5
         FoKLfGzTawIPGsoW9TsWPWX7SuJGq3z6q4Kva1PCtxlKB8dv6bYI3f6ezygTDqp2ll23
         cyFRr7N/zrI6Xd6Gcz2WU+PTtRee7FgpSd3Ug6/0TnAMsoBAe29JdhSkxZ0M/vJdP54P
         cdaHKZ09FlcW9kJ79lgGxE/dHNKZG1OkkYoDo+tMnda7zmdFBtmP3i79IG32mU/5FX4+
         M6GA==
X-Forwarded-Encrypted: i=1; AJvYcCWDruvBHj06B665FHAsD1YoWMDRfvtUr4zHlImGLTXAjCfgICBuj+TU1OusZ6ExZzPNe4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn7mupScuZsfScb6ZZHEzteetpekVTZU99LMZMVCkF8cMWGSxV
	U/76ARkKx7Kyzb3fU7gCapLJdZkOVkiGFBo1m1i/zVkv1G8hUyc+v6pkJW6J7tqwzibxsKNB0Br
	EW7vnBBl/h9LO8CVyOBgvugqPKDANhE6fOvt/k+xyWkXzGLtGS3v/UQ==
X-Gm-Gg: AZuq6aLhnuxcljeVXjqJvclOwHpeQ0XX6hjYy0MfmfH/Ye27KJ8lseGZxVWinaV5B9c
	wDWzN2OR4y9VuBjWITDhK1RosslpFlvDAVSoSNS9SkcplGBmeKMi1/JKlZMXkulj6Q1l3HcCzdC
	G/5OCsiQiCC//NwQ21rfngBn0y0XQveA6l/QZzWKj3kK6mKt0flpM4bHlr/MQFG2AXgwjeRtooi
	0OLlgK4Fi++cAPdHolLja/galO2S5VFp0tVbB8SW/u0fl/+Xagap6S0bH3PpOagj4zoAfuvJH/8
	cQQ0QbP92C7HwHusY7WJzz++5JTv6KCZuuJ5ZaxqGNgFB6zg5jWSQP74ybuaa9sVtvZMULQ4Wsq
	AdKj+8IHCo/I6H48XLfUfkjIafxFg+Y45eQ==
X-Received: by 2002:a05:600c:1f08:b0:480:68ed:1e73 with SMTP id 5b1f17b1804b1-4830e98fa7fmr2683685e9.36.1770136358280;
        Tue, 03 Feb 2026 08:32:38 -0800 (PST)
X-Received: by 2002:a05:600c:1f08:b0:480:68ed:1e73 with SMTP id 5b1f17b1804b1-4830e98fa7fmr2683215e9.36.1770136357850;
        Tue, 03 Feb 2026 08:32:37 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4830ead1973sm515725e9.5.2026.02.03.08.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 08:32:37 -0800 (PST)
Date: Tue, 3 Feb 2026 11:32:34 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marc Morcos <marcmorcos@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Dr . David Alan Gilbert" <dave@treblig.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] Clean up TSAN warnings
Message-ID: <20260203113137-mutt-send-email-mst@kernel.org>
References: <20251213001443.2041258-1-marcmorcos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251213001443.2041258-1-marcmorcos@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,linaro.org,habkost.net,treblig.org,gmail.com,nongnu.org,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-70024-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1AC64DC244
X-Rspamd-Action: no action

On Sat, Dec 13, 2025 at 12:14:39AM +0000, Marc Morcos wrote:
> When running several tests with tsan, thread races were detected when reading certain variables. This should allieviate the problem.
> Additionally, the apicbase member of APICCommonState has been updated to 64 bit to reflect its 36 bit contents.


Doing a sweep over old threads, Paolo iiuc you will be
fixing it all up differently, yourself?

> Marc Morcos (4):
>   apic: Resize APICBASE
>   thread-pool: Fix thread race
>   qmp: Fix thread race
>   apic: Make apicbase accesses atomic to fix data race
> 
>  hw/i386/kvm/apic.c              | 12 ++++++++----
>  hw/intc/apic_common.c           | 24 ++++++++++++++----------
>  include/hw/i386/apic_internal.h |  2 +-
>  monitor/monitor.c               | 11 ++++++++++-
>  monitor/qmp.c                   |  6 ++++--
>  util/thread-pool.c              | 30 ++++++++++++++++--------------
>  6 files changed, 53 insertions(+), 32 deletions(-)
> 
> -- 
> 2.52.0.239.gd5f0c6e74e-goog


