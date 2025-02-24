Return-Path: <kvm+bounces-39033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4366A42A8D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19CF11896EE7
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E5126561F;
	Mon, 24 Feb 2025 18:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="QVK9OBJj"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD1C7BAEC;
	Mon, 24 Feb 2025 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420150; cv=none; b=J/jpvXJEUnF8ITfNYljzJqeqeievb+K+2bC73jmAT+ikJz1nFEWQnyeFaU+xzqKPKqnDQSFGIbPzOWe8DpqWl/PKTV0AdkVYd0R3oqhg6lKVyQHXW/Hg6bRBV6wPMswRBOyVK2R8uqIYm4ZKlWss5q3L52aPvWRXDlNaxakL7X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420150; c=relaxed/simple;
	bh=ZcSniXRgM+Ddmr47JfUfBW9xvN1HNe9i5drbqA1M/n4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=upXHWVJ3iVykRRB/vu/bS7MiuEckUXjgS4e0ztGbKxYeoiL9accuU1lXuAn2WmRstxEebUtGdyLWm52Fw9gCLZHzEnH7pHEpi4cqGo+LX6R0PFjO0/Rs3hjgwbQCjpaArgOD3Q3yESdUwzYVO4rMX9eNV0IELRcIW6aszFlYJL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=QVK9OBJj; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1740416264;
	bh=ZcSniXRgM+Ddmr47JfUfBW9xvN1HNe9i5drbqA1M/n4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=QVK9OBJjeDjcboUGIJNsj1/Yd213YN4Cc+1uJUcOc0TH4pwHTurFfHQ+hHR+shN4c
	 NEtsVESYC4pMVHGrop80zFSssiVTh2QtP520C9PdZM4L/alnUbI8LUFfRCqpXt0Gdj
	 wGk/29IBVVg2djOspxa+EzOJhlsUNaJrOaYywbt0=
Received: by gentwo.org (Postfix, from userid 1003)
	id 41A2940A17; Mon, 24 Feb 2025 08:57:44 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 4069040195;
	Mon, 24 Feb 2025 08:57:44 -0800 (PST)
Date: Mon, 24 Feb 2025 08:57:44 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    linux-acpi@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, 
    x86@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org, 
    arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com, 
    mtosatti@redhat.com, sudeep.holla@arm.com, maz@kernel.org, 
    misono.tomohiro@fujitsu.com, maobibo@loongson.cn, zhenglifeng1@huawei.com, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH v10 08/11] governors/haltpoll: drop kvm_para_available()
 check
In-Reply-To: <20250218213337.377987-9-ankur.a.arora@oracle.com>
Message-ID: <6d035996-8b8f-3d3d-d41e-6573f8a76f31@gentwo.org>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com> <20250218213337.377987-9-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 18 Feb 2025, Ankur Arora wrote:

> So, we can safely forgo the kvm_para_available() check. This also
> allows cpuidle-haltpoll to be tested on baremetal.

I would hope that we will have this functionality as the default on
baremetal after testing in the future.

Reviewed-by; Christoph Lameter (Ampere) <cl@linux.com>

