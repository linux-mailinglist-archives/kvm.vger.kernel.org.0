Return-Path: <kvm+bounces-72453-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6G/QBPsqpmknLgAAu9opvQ
	(envelope-from <kvm+bounces-72453-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:27:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FAC91E71EC
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 404CC309D194
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67DFF20CCE4;
	Tue,  3 Mar 2026 00:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y/9POyzw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE5D201113
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497618; cv=none; b=J6AmWGvEoywEcnzjmu2Ugnp/v5d+7UfU+muO1rwKuEh5MvncFJ3/89njr6MqVo/PWy8jwrKI9WCkTqZ8/U4ZT/vHgKCsW/Vdzj+SY981vjfbDXeG5paoQlh9PJH5OEuCNFmQlRyqUfXIKvuCKs6TL6KEE70qzK1uv94q8oLzg7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497618; c=relaxed/simple;
	bh=45FwaD+aLfwCpOLp1QzR80s2bnH1PdYm5y06Mq7rG5M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=seos7kDWXEE8LFjWd4ylhFaNgPW7f6Y/lwWV+tLX0u9uEKefQuxhnA4brGwlIhZ4muM8DVzww2injgwZsqIdpszgFuQSLWPW0b2I2nycw5s20xltQ+R3XDkJwpJzgPh0WDgV5ebLnwAjQt67LGAVhnXrrJSdD5gT94HasWJz5Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y/9POyzw; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-463a075e177so26757819b6e.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 16:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772497616; x=1773102416; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x4ktjRaCV60il5GnKrl3u+MiHKCG6sTxE87cgQM8iWE=;
        b=y/9POyzwHlwetQ+M7I0WkuK6acC/pzzq8rN5ORcGLdJaNEltWiSBWYRpYm9Hk8wr2u
         Fz/LdH2IvlM0S/IsZiP9lGqvQo76tUiPpt+BRoi6CvpR2eIJiWz/+HT1TSPKx2jnHV7i
         zl1gZeLJTc3Q+qm4qq5Y8aBi8GSzyzEsJaU4ircC21nfzLaryy9v0yYCudeHWUwnTQ1l
         +XayaXukmQHRRI8VQcZg9+RVyOA1TVRfSExyXFtpPaLGp6pRJ+rVkO6x4duAGG5z+5xA
         LNeuuB9yKln4hvw495rRacM3LvDBuI8M4l7cqeVfi5lDlPgeBRHuzPaplpe5vlCCrWjp
         45Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772497616; x=1773102416;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x4ktjRaCV60il5GnKrl3u+MiHKCG6sTxE87cgQM8iWE=;
        b=ENlaktnD/jUIJFGAnmme+22Bm+x2igZNy8Jasbi41Bo6RPIdkjm+okeSVE8UvoYaqf
         R3T0T70hWwUqpxRfE2kcVWj+pcKuZtL6Z0Z/ZauhLtMoUl5/CExzyDCK0y1SOBoeWCZJ
         h0PIMVEBbPBnNagGPOsw8cu13S4/8fZCIdmsOGunO/jEMqNu1Xtlss/Nxh7B58QfrhCw
         sJjZISbl81hGAzyJ53a4PzZFUjeawJlq1l/pDU2qMtrr96bZ45Kc7mwTfB4/vdwH6BEQ
         ZhRJsxVjkUul/feu2R6exxlN0W+mMLMTDOh+kizs4Z4QD1n748nn7MDlThbNDQbV+4lj
         znxg==
X-Forwarded-Encrypted: i=1; AJvYcCXCPShCp1X2M9F+Hz9KoKmOI8GTDWj1uGrzXmx99SOf9jfA8r4YqQE59U1XZI4PDqi+Nc8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwSSSqCnkdymHUvtSnd3rN/nxZCCnASYKVwZ1H8EBfQw/YOUMg
	Prqmvat4aGPT6zQ2RDdYUlrDrn9T8KFOk55lGx77rzyRqicafJOfBKzN7bp7VH5TDyxybqyxyfW
	4tltqQQ==
X-Received: from oaccj12.prod.google.com ([2002:a05:687c:40c:b0:415:6b50:b04f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:3998:b0:45f:1387:973b
 with SMTP id 5614622812f47-464bec21345mr6172917b6e.6.1772497616259; Mon, 02
 Mar 2026 16:26:56 -0800 (PST)
Date: Mon, 2 Mar 2026 16:26:54 -0800
In-Reply-To: <CAO9r8zNe9_vhspg4T=zswZ3Hr31XJGPz8=aDbqVvL1Wa9_mrAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227213849.3653331-1-jmattson@google.com> <CAO9r8zNzhK90=+Pezqbea0aihMEp-dGidcJuXqZQKnmsM2JTDA@mail.gmail.com>
 <CALMp9eRP7-u+6r8-RoVru6PLSPr6fu+EuRgtsNLJE_1EpMJq8Q@mail.gmail.com> <CAO9r8zNe9_vhspg4T=zswZ3Hr31XJGPz8=aDbqVvL1Wa9_mrAQ@mail.gmail.com>
Message-ID: <aaYqzgO_Il2Pqixm@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Add retry loop to advanced RTM
 debugging subtest
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3FAC91E71EC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72453-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> On Mon, Mar 2, 2026 at 4:08=E2=80=AFPM Jim Mattson <jmattson@google.com> =
wrote:
> > > IIUC this will be in the order of 100s of milliseconds. Do we need to
> > > wait that long between retries? If the CPU is in a state where it wil=
l
> > > always abort RTM, 30 retries will end up taking seconds or 10s of
> > > seconds, right?
> >
> > I tried reducing the delay by a factor of 10. At 200 retries, I still
> > see a 2% skip rate on a Skylake Xeon E5 @ 2GHz. I'd like to get the
> > skip rate under 1%. But, maybe others don't care as much?
> >
> > Yes, 30 billion cycles is going to be on the order of 10 seconds.
>=20
> I personally care more about the test time than the fact that it won't
> test RTM 2% of the time, but my opinion doesn't really matter :P

I generally care more about runtime too, but isn't 10 seconds only the wors=
t
case scenario, and only on these fubar CPUs?  E.g. if there's no perf activ=
ity
in the host, or the CPU isn't one of these oddballs, isn't XBEGIN going to =
succeed
~100% of the time?

If this were a choice between "eat N seconds every time" and "skip the test=
",
I'd be a-ok with a skip rate of 50% if it meant reducing N.  But, assuming =
this
requires perf activity and a Skylake-era CPU, odds are good this will only =
be hit
in CI environments, at which point adding ~10 seconds to the worst case sce=
nario
isn't a bad tradeoff (so long as it doesn't push the total runtime close to=
 the
timeout).

