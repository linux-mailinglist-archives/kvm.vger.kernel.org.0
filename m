Return-Path: <kvm+bounces-19421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 482AE904E67
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 10:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C47E8B21946
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 08:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC37516D33B;
	Wed, 12 Jun 2024 08:46:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AB0BE78;
	Wed, 12 Jun 2024 08:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718181990; cv=none; b=QSdp81DbgvLTRdcyhpYiXlOlyVN/MsjOwKxZ8fRxiC+ZP9va5uIEybmqctYC7DTtL3kADpYFERs82KQDVN16pKOakSFi9E8ne7vD2f1JkuoHvvbuXp2qUvJrK2sZwoKXJzZ73QQ/2lwu8hoqaMHeHX6oLmEP4+xEMHdlqrpTYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718181990; c=relaxed/simple;
	bh=R1vqRfKVFJWm3sFf+UoENp3cDWuXzJxHPLytxKwx+yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GqqAQQUmv6KW4lFXc+cxAgEnJuuMXNDhNDCrFx+sm+tAVj8DuefGc9STFS2FPXwrXLrO+3xIEO6UM6+VX9+yIfMS1xdpWDidf8EsBryEC1Ki1YOFfulkrTOvTPsneaia6cNQOYxMFYzV/KfXcPIfReSt6OhTKDAzt9qxqhkwvLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 45C8Smwv013988;
	Wed, 12 Jun 2024 03:28:48 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 45C8SmlA013987;
	Wed, 12 Jun 2024 03:28:48 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Wed, 12 Jun 2024 03:28:47 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm-riscv@lists.infradead.org,
        kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o targets
Message-ID: <20240612082847.GG19790@gate.crashing.org>
References: <20240612044234.212156-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612044234.212156-1-npiggin@gmail.com>
User-Agent: Mutt/1.4.2.3i

On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
> arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
> in dependency chains that cause them to be made as intermediate files,
> which get removed when make finishes. This results in unnecessary
> partial rebuilds. If make is run again, this time the .aux.o targets
> are not intermediate, possibly due to being made via different
> dependencies.
> 
> Adding .aux.o files to .PRECIOUS prevents them being removed and solves
> the rebuild problem.
> 
> s390x does not have the problem because .SECONDARY prevents dependancies
> from being built as intermediate. However the same change is made for
> s390x, for consistency.

This is exactly what .SECONDARY is for, as its documentation says,
even.  Wouldn't it be better to just add a .SECONDARY to the other
targets as well?


Segher

