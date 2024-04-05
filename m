Return-Path: <kvm+bounces-13736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA529899FFC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1815E1C20FF6
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68C216F292;
	Fri,  5 Apr 2024 14:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ux9vDZpw"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9289B15FA95
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712328051; cv=none; b=ZPa6pSBipr+UfNQ6p7oik8EsSQKmlLzyxW+RfoZoLwTa9NGjydQUx2DgDMwpITXKWjnk5PnddoegGBYDbPHShvswXzYdA05bCQluKhbB/yWGfjqM1YnPBKrapw89flen6trdap19fh7+HjJUDfw5SnE5TqKwZKFMhp0vOuzv7Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712328051; c=relaxed/simple;
	bh=oYX9OpKf9lRJWaJQyTBBcK1gw/a3FUTAqBlbij5Tdr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNHv2oS7xcfC16exwbQ9loE+ZY01WRf5TIm0VLGT30z4QXuoA0r7NYxoMd1mipH4hkqlclmbW1QeUHLZJTlFn0KOnObyswE9d6AFD77Emq+Nr1kEMqWIl4+YaTTsE1u6toiwGvN3TVHfd9VzjydTOqcZiQD7aDP+DjGtPjdLbKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ux9vDZpw; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:40:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712328047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TYh56Y6+cJR5QvHZFNolO78UYixNYJhmA85Mhsxa60Y=;
	b=Ux9vDZpwjUfeEphV6zLy62Qysf7JZTJbSh4DroHq9gKjn4bsJqjEztCml2x8W7HxBvv1Ma
	DdgA3dTM3WtEoCX1ZkxTTBcGptJCRHXdIBc2iGtSXzWf3nRNwHMoiTNdzmtaBsD9J41xYx
	QJ8PXJ4cYcX1hIhdXogMZ3l+Orojjk8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Nadav Amit <namit@vmware.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Ricardo Koller <ricarkol@google.com>, rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC PATCH 15/17] shellcheck: Fix SC2048
Message-ID: <20240405-f8309ada9b50943a34fb4eda@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-16-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-16-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:47PM +1000, Nicholas Piggin wrote:
>   SC2048 (warning): Use "$@" (with quotes) to prevent whitespace
>   problems.
> 
> Not sure if there's a real bug.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  run_tests.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 116188e92..938bb8edf 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -44,7 +44,7 @@ fi
>  
>  only_tests=""
>  list_tests=""
> -args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- $*)
> +args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- "$@")
>  [ $? -ne 0 ] && exit 2;
>  set -- $args;
>  while [ $# -gt 0 ]; do
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

