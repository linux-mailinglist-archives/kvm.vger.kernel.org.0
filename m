Return-Path: <kvm+bounces-73178-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AEvkDA9Zq2mZcQEAu9opvQ
	(envelope-from <kvm+bounces-73178-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:45:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 03556228601
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4BC40302DF5F
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 22:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086D62ECE91;
	Fri,  6 Mar 2026 22:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="M8IUIwFI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-106101.protonmail.ch (mail-106101.protonmail.ch [79.135.106.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66755149C6F
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 22:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837125; cv=none; b=dRBodMY0uaciDQ4H6cLHoLANg4IO/6kj2bWPhdYeNW/DsKmuuqmaVXh6GR/yNb0xqXn1I42liv/A6PmoBhUzrS7vR5+Cvaf2Y40StrtCKACOua61eoocPRPgn5pAwPW4KifirpJdA9aS7tKgxGPoQN4mCiXZqUExk0/Gq9xqp5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837125; c=relaxed/simple;
	bh=RZlmmzm0R4exhEkMoRSbWb7EXNwLa4WbzlBeZQUuCJ8=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=ENi6cIo6QS89yA9T8IYUJ+0F0H3pc6m7bGM5OWSks/DH7HUp4k/sPCj09zytH//ZWCU2FEEDs2s6nUgO/tJkzrqwg0dXiGoVInoEcMLlCWx2q4z/dfd65pjNRhnboQ7pobUNaXA62WUI/Fuv7Rdurnbohx+b5zTY6bZjxrmohrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=M8IUIwFI; arc=none smtp.client-ip=79.135.106.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=3g62bbeu2rc6zar6om4ucwal2u.protonmail; t=1772837112; x=1773096312;
	bh=RZlmmzm0R4exhEkMoRSbWb7EXNwLa4WbzlBeZQUuCJ8=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=M8IUIwFIrpS+QA7cWmCMf81u2hu+Ok3jOSjjU3JV9vlwymH3n0w8Q0qhrpWZVw4JB
	 Hhsg17pS+GZ464nEqZQBC8l2gDuVRI5TjzjQyDuCaRapP0HNOkqZ+n2nn4CkDC7dIi
	 nwyAYK49fiM4irGZV0qF6x/2/VSuK1vfs7FVG+fs0v8QuOGBRIZVKVXAn0mtzWnL1N
	 ImH1R3Nof6P5jGhdqhhWd4uELMq6YkweYxn885e9akgr5ieAe0C4LiC3wDMzsdjolM
	 GNb7hhVYLG43zWcpjH9XoN2laK2p8Cl52GROJmr3sUrFJuHt7ZO0idnHpLJt9hJHbK
	 nrWxpgjsWghPw==
Date: Fri, 06 Mar 2026 22:45:09 +0000
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From: brianharveyos <brianharveyos@proton.me>
Subject: Bug 219161 - VM with virtio-net doesn't receive large UDP packets
Message-ID: <16uwcutC6tZWCoJJULgKBLI8zwKXyTeRpcUEYK4AUazFevxHg4FTd5lttS14E8oZrpLbWmARGhgpQTaUoZIEF5Ho_wepzZXWpgXBqHWTFTA=@proton.me>
Feedback-ID: 154631810:user:proton
X-Pm-Message-ID: a70a229e7efcf181f3c57e9ddd2f9c39784b87e9
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 03556228601
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[proton.me,quarantine];
	R_DKIM_ALLOW(-0.20)[proton.me:s=3g62bbeu2rc6zar6om4ucwal2u.protonmail];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-73178-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_TRACE(0.00)[proton.me:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brianharveyos@proton.me,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.983];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Apologies if this isn't the correct way to do this but I noticed this bug (=
219161) in bugzilla with no assignee. Is this something anyone is welcome t=
o submit a patch for or is it being actively worked on by someone else?

Thank you,
Brian Harvey

