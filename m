Return-Path: <kvm+bounces-70728-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPQyDIRNi2mWTwAAu9opvQ
	(envelope-from <kvm+bounces-70728-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:23:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E0AE11C6D3
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:23:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8F8E303982F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A69E33BBAF;
	Tue, 10 Feb 2026 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XcM8sENa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hp9Xzyyr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4723626ED48
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737018; cv=none; b=boP0c0zuYBABhxOX7sTf+kJFw5BxY2jxCb7zfpPeyBHwe+rn+JFvj9m/+C6e6lsnMYclxIAXvxEJr56CvfL8w0iwPbic9SgGZTozokAwWaNjTAd1tWLbk6MOHKLCSD86D8YXW/vURdVOHjJaX5JGxQhQae5Gk4t0Wn8cwhwxsn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737018; c=relaxed/simple;
	bh=Ky8+Gi1YLPF+d0cjrPfnbJ5mA8pBCa9z5DRDnkOOg9w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h7aos8rWZ5/LlmB+rnF0VBOO2Juz2cDG5KS86K3c/rLhyQ4PK8xGlrSO1Ahb/kTHFVZrxXT9wg/wJTJ3BbhiDBSD1/MhZGJSt7RHeafGadyjnIZ67Bz1M1XgxooJgMatON5Ymi5rx53zpMqQ3GFSN2w4d82vwwziEERE4KEgmT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XcM8sENa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hp9Xzyyr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770737016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4KpXs4HueBD4PLnzFUzxY05xrYaFOtjFsDd93FCVpl4=;
	b=XcM8sENa/YHmtDAkIE3doe7OJIfsIzlwe/eQCZ6Nf3uX4tW/kw+bDMpXaed4meQbo7PfX7
	qIM40It7NAqVaJDTLr8hudrFBkNXa0b9ONlTdaxsK7GCJGDckl9CLZ3VJ/0cNAtPSIzi56
	Dxm7hUSPCLBQkWI+Wc6JQiiEQ9mCcJc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-MUAa2OKCORmKncG6Gkedew-1; Tue, 10 Feb 2026 10:23:35 -0500
X-MC-Unique: MUAa2OKCORmKncG6Gkedew-1
X-Mimecast-MFC-AGG-ID: MUAa2OKCORmKncG6Gkedew_1770737014
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5033b4d599eso200346731cf.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 07:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770737013; x=1771341813; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4KpXs4HueBD4PLnzFUzxY05xrYaFOtjFsDd93FCVpl4=;
        b=Hp9XzyyrDpd4htuD6V1GsJDgQNQ83DB87J+G7l6jkOhAVQ4/PkETqNSa/oE95G9Z2k
         AFPvCGqgZB0g9wn09Dd23l8cSA35QzBlJd2cHY+03Xu86DGhtPkwFrT6mUOOR40J6uQS
         wo4xbx57dyi9Z78aD0Jn5I/Wi3IljTzsl7hRUPSoIiF/j+s1sQWzDdhHK9thRHoBPCDv
         JEo3FGAjOxpggEvrTNyR3nSl9+qwLvrCnfn3O/EpveVaChiHk0kobwJBIPk6XmSefsR6
         5HN3bjXKftQUtNYwkfcwzOkzeZ32GcZ8v0elK2Gy34QeGaQ6QOD9jIIN6dssmPO10Iwy
         T/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770737013; x=1771341813;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4KpXs4HueBD4PLnzFUzxY05xrYaFOtjFsDd93FCVpl4=;
        b=E0jsTHYSl0dJOdXa27MkTClQoSWQcXtBenWYzBonSmZOmnyFKrvWYNp4MHbo6aVzUF
         cFjiXCSmvudRjFkUHhQ+gsZUz9DQu6AGzG0cdFf2cqqdNYyu4WDHjaIewLD8GxfKYNm6
         DBvM6Jqk0fJSeqBz5L3KDTsyWR93Ct9KEouVRMnd4zRFFhv5Tx6lBZs4htmIe0+R6AAw
         eVZn7YEIUHAVaXpljLj22CNWaczjo/MSIPS+QkPDP5t8/jDDwe95E50W2ngiUMPpReKG
         QISY7M0du2Vy3JGM/5T6+IUmGWnNKQTkl4gaM1uFd9lVTYXV8s5hxdPE/caAQqTXep0v
         7cjA==
X-Gm-Message-State: AOJu0YyVW0SzxouY+Dr+sgFbofzshrn8aU8tsYxW4lz3Sh3pxLDFQKkK
	Qw7NEn86Z1tHbKo69Fylsb6C86pC6zJe05aIVF6vHskwZ58fPgdAg/dEZYVioW/AysO1DeOw0+1
	EiVGFqdyJKye7XpVp5wGykOht+lO1/YPrqy2HHV45z6K9plkg3O1Q/MCw1Q+1GlL4HTghJ2NHN2
	Xr35GwxEWILuSxpp6ieQUVbkX0RCg5gTdU22h+UA==
X-Gm-Gg: AZuq6aJb7XJM/+SRXtZCvBs1babRuJBK5KoQNdNJCBEbIB0Nqy6FaWd2+zENVyDo1Zk
	oZDr8qHpc1bYrTOTwWkofUi9iHx09imFCtculwJ5K83PndFA2I82kxC6jYgbUvIx83u38UeJcVp
	MCP8LzVXI3mEBGpkTPWZsfyo3SpS8v/FOxf1Sy++yQXabesXaBSMoLbH12cLEc+tr6TMRxfm/F7
	7vgYWHeENk6MMkO8otGEofpxiUbiIV52BecigQ9dsjAnU1E7aiN87GtESOl/N3VYxoB1PtVBN7d
	veDDjNPiztlg7LgY/L+PACZxbIsa7eaHxCLdPF4UzQFe0dFducLbr8iXZG1XLdJSpLpYY7A/JiD
	VOM7iGKma3wUs2aZgi3eipBky5fUm
X-Received: by 2002:ac8:580c:0:b0:4ed:66bd:95ea with SMTP id d75a77b69052e-50673cdf42fmr31146571cf.29.1770737013247;
        Tue, 10 Feb 2026 07:23:33 -0800 (PST)
X-Received: by 2002:ac8:580c:0:b0:4ed:66bd:95ea with SMTP id d75a77b69052e-50673cdf42fmr31146151cf.29.1770737012833;
        Tue, 10 Feb 2026 07:23:32 -0800 (PST)
Received: from intellaptop.lan ([2607:fea8:fc01:88aa:f1de:f35:7935:804f])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5063928e05csm98081041cf.19.2026.02.10.07.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 07:23:31 -0800 (PST)
Message-ID: <d4ae36c621a77d21985396d5dc6247d76b08ba97.camel@redhat.com>
Subject: Re: Question: 'pmu' kvm unit test fails when run nested with NMI
 watchdog on the host
From: mlevitsk@redhat.com
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Feb 2026 10:23:30 -0500
In-Reply-To: <b0bdc3f140238d23e2de8f706c06331db1d57e79.camel@redhat.com>
References: <10d3f95717b7072e30576b7e3931ea277399fdf8.camel@redhat.com>
	 <2eae45e037c938785b9e36d0f5265becca953d9f.camel@redhat.com>
	 <b0bdc3f140238d23e2de8f706c06331db1d57e79.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[mlevitsk@redhat.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70728-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7E0AE11C6D3
X-Rspamd-Action: no action

On Wed, 2025-11-26 at 13:14 -0500, mlevitsk@redhat.com wrote:
> On Mon, 2025-11-10 at 14:51 -0500, mlevitsk@redhat.com=C2=A0wrote:
> > On Wed, 2025-11-05 at 15:29 -0500, mlevitsk@redhat.com=C2=A0wrote:
> > > Hi,
> > >=20
> > > I have a small, a bit philosophical question about the pmu kvm unit t=
est:
> > >=20
> > > One of the subtests of this test, tests all GP counters at once, and =
it depends on the NMI watchdog being disabled,
> > > because it occupies one GP counter.
> > >=20
> > > This works fine, except when this test is run nested. In this case, a=
ssuming that the host has the NMI watchdog enabled,
> > > the L1 still can=E2=80=99t use all counters and has no way of working=
 this around.
> > >=20
> > > Since AFAIK the current long term direction is vPMU, which is especia=
lly designed to address those kinds of issues,
> > > I am not sure it is worthy to attempt to fix this at L0 level (by red=
ucing the number of counters that the guest can see for example,
> > > which also won=E2=80=99t always fix the issue, since there could be m=
ore perf users on the host, and NMI watchdog can also
> > > get dynamically enabled and disabled).
> > >=20
> > > My question is: Since the test fails and since it interferes with CI,=
 does it make sense to add a workaround to the test,
> > > by making it use 1 counter less if run nested?=20
> > >=20
> > > As a bonus the test can also check the NMI watchdog state and also re=
duce the number of tested counters instead of being skipped,
> > > improving coverage.
> > >=20
> > > Does all this make sense? If not, what about making the =E2=80=98all_=
counters=E2=80=99 testcase optional (only print a warning) in case the test=
 is run nested?
> > >=20
> > > Best regards,
> > > 	Maxim Levitsky
> > >=20
> >=20
> > Kind ping on this question.
>=20
> Another kind ping on this question.

A ping on this question.

>=20
> Best regards,
> =C2=A0=C2=A0=C2=A0 Maxim Levitsky
>=20
> >=20
> > Best regards,
> > 	Maxim Levitsky
>=20


