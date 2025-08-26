Return-Path: <kvm+bounces-55727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3BDDB354A1
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 08:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EB293B0EDA
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 06:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711782F549B;
	Tue, 26 Aug 2025 06:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="P31hKE4o";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="43nXdEzQ"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7278E29D05;
	Tue, 26 Aug 2025 06:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756189800; cv=none; b=G8o0vdGcdQv6xUCqKPyVYe5O5hoM+mXtDPMc0tAPRhaXYuM5HSiPsdmcuuD8OKRQHpPcLo93ORxhCV6wv0kV+A53fmdPmcS6veRiwftMLW295H9EoCyN+Kn8HM5yLGcnR3MOvK8h+Wh8oMS2rxGXkAPYOdJiuQnW39hfb1fUDnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756189800; c=relaxed/simple;
	bh=qpmfk+xfq/qcYNhcqT9cFC1mP1WvTyD18P6Uq/e6gC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLY3ygKv9+W9ZzoB9HCI/oA7QuqyEf+RHLG8xoZE3PCfnKY+UrIF5gNs/n6r3/uXLo7/Oc+1/du+ynqD1G69/GCV/ine2ieVNgmA0gTSSOLFCUk4yMWczWxarYA+0I9pIcoFHcXwTmFFHgBScx9soovyV+exN2ywLfp1DVcBdgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=P31hKE4o; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=43nXdEzQ; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Tue, 26 Aug 2025 08:29:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756189793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wsqQrehpilHddnDvFR3sXC4btLIz8Vlzv0GVLkTTpNk=;
	b=P31hKE4o3kX/G/zyz/dlj1MNG+6bFvJrakMcRfGHmbsOSNlD8HfOfkRG34jbCQ901GAg1F
	o9LGzz4tUm8EfkrAhvVsAnK5GJXlg73fYwFKOWe8+mLP8mhTXImGZMRvcsivJZfn5i42m/
	bteLNcq5jJAuY6jYbkmGz3RRtd/Wu/SMsm+EFZLHBWdIP77o7fQevPH7lSYjEtM9bNjcGr
	WXNRVIv0W8fEXQqYAgUOjBPBfJXl+hzY+r9cKGiuNMdRiOLKdhj3N3iim/k3kytyJYTk2J
	24cGSjB/gh93Jq1HNXRcrw6AlIVob9aGoWAWJMjb89kqGqj1qJyeQXUs6FE83Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756189793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wsqQrehpilHddnDvFR3sXC4btLIz8Vlzv0GVLkTTpNk=;
	b=43nXdEzQK0DNDN/8V97czMOpuC3TDyyjWE6PjXwXA7SoMZ7zLV/hvhgsylyBWbg7C4MmQv
	2NWCiPQ53aQB1pDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] vhost_task: Allow caller to omit handle_sigkill()
 callback
Message-ID: <20250826062952.pMTsCcyH@linutronix.de>
References: <20250826004012.3835150-1-seanjc@google.com>
 <20250826004012.3835150-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250826004012.3835150-3-seanjc@google.com>

On 2025-08-25 17:40:10 [-0700], Sean Christopherson wrote:
> Now that vhost_task provides an API to safely wake a task without relying
> on the caller to react to signalas, make handle_sigkill() optional and
                                  ^
Sounds Spanish :)

=E2=80=A6

Sebastian

