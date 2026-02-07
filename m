Return-Path: <kvm+bounces-70546-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JMsI0BCh2keVgQAu9opvQ
	(envelope-from <kvm+bounces-70546-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 14:46:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D975F1060AB
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 14:46:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 721253019B99
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 13:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B953248867;
	Sat,  7 Feb 2026 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W8KH7Uwq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJIQla6C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7077A14A91
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770471987; cv=none; b=AZXHZgIzrK2AaQXHESBMQUBiNR14t4cSnYRbCVURSchmd9uUB4Hx5Rr+E94XenR4GFT2eJSek0yY2gsAuv6DsP0jdxyk1SqQmobG6DjehxEvqoxfACkaG4ZTrznFQBjlQ6lhc2+Cehs9eusu+OaXxzlGmRDhRuTr21EBDK0NPvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770471987; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jp9mvy+H1SKFDD4cu/UEHtuPK5ad7Bp8rNZvOdmDnT42lbjvO544rCS6Kqrd7QrHtI3Xi7az3+mONohlzuM2hD0tyFuAJpsi8fakWAhmvOL92YE5Orrs35smZ9rwF28e6x3jguOwEtQAio/7iqCtve4kXAv2U4MEoD85zWjKizY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W8KH7Uwq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CJIQla6C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770471986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=W8KH7Uwq9QIUguQKf4WPuza9ioojhZgN9gmnEJ9nufWtw9oOlyjAHOAuCm73qQzcwJ3Pfe
	VSMFB2H8GrLxIpSASgpGbmrivO7OFBo1l/aoAgQccUcdqtv6iU2bLC+c1U0HpsINRiFlsH
	OMMjA59s8tbC2zKJLg/cvJmJmVwrGyc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-02s6N3v9M5SVa21a42b7tw-1; Sat, 07 Feb 2026 08:46:25 -0500
X-MC-Unique: 02s6N3v9M5SVa21a42b7tw-1
X-Mimecast-MFC-AGG-ID: 02s6N3v9M5SVa21a42b7tw_1770471984
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-483129eb5ccso34353195e9.2
        for <kvm@vger.kernel.org>; Sat, 07 Feb 2026 05:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770471984; x=1771076784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=CJIQla6CATtLaI7XT7xQjmyDIpuIzfSU0f0+KGIUs/VbmpMNmwruNo7fxG9C6+kdyJ
         esgE2cGz6CFAR34TZUTBFmrf16dICNdFycqmhI5nDET0jYpnDPrUcGH5X78QElHBaIy1
         LNxrc0Hk0UZWsmHmMC3MhVxDGinNolCKAHAUL8m9dA9xH7jxtcyIE/RPSV3osW3EcwF4
         IQR9E9Wrjm3tqTACd51o1Spq0/axGj06OqxCzuZLEoUgu75d7BJ7+8noBJRzXaI4DNBt
         +av0VpfgSoieAuy6zzbkQ222IGPudqJQEEMlB2pgbv8KIoNvwOnXYsTHt8V/BF54yx9N
         m+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770471984; x=1771076784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=tTizH7VAddCNEK5XnNaj1NLrpYEquNPNUorPugLISQ8sBO1g2QVN+ROR3hZ1GwZiYC
         XehirPc7hxWXSa9VNEkaDr+26h6LTFed8JFeeYShEzl7xFAexo45dovjkQ2uWaYWCkZh
         fWMcdmUD0mj6OU/v0yyEv7WRjegKNYiglkl1wtk5cC5CwkWdVj0uyBKLQuewEFAIdJTw
         yysx8WLBvm1McgG43fh4Es8KyB0AEzB8aA/zuqxBDZxEdjAPcALtaTwBW5cdYc1JDoNN
         loLPjf3a1ojIUnRivNw/EeT6WbSwwN7Pr7SjiF4Jd68igSEApJ50nxh9kD3hBbwbLFL2
         7M4w==
X-Forwarded-Encrypted: i=1; AJvYcCVlU410IWugkTqlFrVs5C11rVpJOy6c/tT/4RAHAS9EziBq/5iNVGcjHBqQt/AcAcFIdVw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLvIyaizOiErWakGKPsGJBGtMxsikSBrUWqIQmSaV8MUFw+csq
	epQb3j/jM1Z9PzHcaeD/wfbBWGEA8DupHUFgzOWqVKihajITxh2h5MJ8wCw/3BdZ5l++hiNvgb0
	EGrSFp3kZtPAJSsHvocrYx6b+hl7KHBYTskJQmbXZC4atwsIOYodb5A==
X-Gm-Gg: AZuq6aKqAqKQDzy7uQKaTZU5cXq2kYNM/hmVICsqUJxJiUTiWo5UeU/2b3Kn1qPP+4R
	rjSs8sN4g4p0WkSWcsJ/40Nt+2wwfDwP+wremlAwjY3I2srXvMjniLPNl1E4Eh6O+EPvkv2ExsN
	COmMBIfWuXmgBCMAOYDDcR7zXelwtFR2kziM/oUJeu8NblUSj66rC6Dw2ygKkhh9hxZxzR5B8Oh
	sEHwW3tMIsEgP83acPUJOm5K5cpnUHj9xFlwRsJa7QNNTj1u20f/k+sulCymheBwU8gE9mP35dH
	sVhHWOOc3zJlt2N5IMHifeWM8ofC1hTv5yeE0X38wHgz59MfSfg6kdRKvpjUbVrb32ChK3867ek
	/w1H4jIiPnuV97fLtKYqaMF05DOmSupVFICO+dM/0E9Vd0Ri1o/KebPJezHEqXI5LSPdVrm5VPs
	OQ6xad/ktj8ZJw+Pa30nkgvwxBSwcal9cw3s1XUX2NHg==
X-Received: by 2002:a05:600c:19c7:b0:482:eec4:74c with SMTP id 5b1f17b1804b1-4832021c5cemr74399125e9.22.1770471984162;
        Sat, 07 Feb 2026 05:46:24 -0800 (PST)
X-Received: by 2002:a05:600c:19c7:b0:482:eec4:74c with SMTP id 5b1f17b1804b1-4832021c5cemr74398915e9.22.1770471983703;
        Sat, 07 Feb 2026 05:46:23 -0800 (PST)
Received: from [10.58.49.123] (93-44-32-35.ip95.fastwebnet.it. [93.44.32.35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d3e245sm207101655e9.8.2026.02.07.05.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 05:46:23 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	pbonzini@redhat.com,
	zhao1.liu@intel.com,
	mtosatti@redhat.com,
	sandipan.das@amd.com,
	babu.moger@amd.com,
	likexu@tencent.com,
	like.xu.linux@gmail.com,
	groug@kaod.org,
	khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com,
	davydov-max@yandex-team.ru,
	xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com,
	joe.jin@oracle.com,
	ewanhai-oc@zhaoxin.com,
	ewanhai@zhaoxin.com,
	zide.chen@intel.com
Subject: Re: [PATCH v9 0/5] target/i386/kvm/pmu: PMU Enhancement, Bugfix and Cleanup
Date: Sat,  7 Feb 2026 14:46:19 +0100
Message-ID: <20260207134620.638214-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109075508.113097-1-dongli.zhang@oracle.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[nongnu.org,vger.kernel.org,redhat.com,intel.com,amd.com,tencent.com,gmail.com,kaod.org,virtuozzo.com,yandex-team.ru,linux.intel.com,oracle.com,zhaoxin.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70546-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D975F1060AB
X-Rspamd-Action: no action

Queued, thanks.

Paolo


