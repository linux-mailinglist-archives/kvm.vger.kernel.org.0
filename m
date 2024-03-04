Return-Path: <kvm+bounces-10807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E00B68703CD
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 15:12:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9706C1F27325
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 14:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C453FE58;
	Mon,  4 Mar 2024 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKsDLpWW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D916224D5
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709561541; cv=none; b=Olq+DiGQK0AjG182BUEBkeXR6fR65REmDv6x2L1H2hZZquUTLV2oLBLQJ7MY3M3hzxixtg+b9W6lYJ6S7T2UQT/74uom6lx783rHwKC9diEGBNDzBv4xU82GXdjts+eYSSAe+drCg4kPbKH8B1kWrlRKW1u/ugpY4iPZghNtiPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709561541; c=relaxed/simple;
	bh=zyU8OAaqXm01dsjCjsgaQarI+GzpnXDfMLft566jRnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iEFY9xjZEVhJQ4lzspo/hrzYpxmQGsdnd/Ks7iVG+fyaJOkRxKmQcojQVdaJQLFwlnl12wGHPQSQIYpc1ByMusrA+LjH7aHbcceuctK0kSxmaFhealaJFMhczuVVMB9/69+C1bmS5eItWsYHJYv1bzHqJsPMMDYX5KwRVyWYb9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKsDLpWW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF20FC433F1;
	Mon,  4 Mar 2024 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709561540;
	bh=zyU8OAaqXm01dsjCjsgaQarI+GzpnXDfMLft566jRnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKsDLpWWlF1QIjl/vumS758lnlbpZ3QzdDDncUFJ5tZv2AIHoqbmelObdEBxbgXiL
	 TanwNWAZQHjIi9ZknC5MbSp8g0XVWBgUv+yoTgLC7aNH1o2/mWSg3X+d+GkmiEznOF
	 TiBV0jNS1daoB5cenmZq/HOC/EYiczyYgMOyWxEQrseD0kyQ6M+CMeLgoVpFW8s77l
	 ke9OSY3k+/kvQPxdxsZ5FUMFuEWD29RPufKQygNItv5mREgVwiFTQIIs5FI+lHYI0J
	 Mm+7tzVOLuijIieJKmXZmgBsgN6vZLg6QkinevbxBqHhxn2oGrrPyQomNEf+68WlkU
	 2LaaeKg+o5JIw==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Yanwu Shen <ywsplz@gmail.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool] Fix 9pfs open device file security flaw
Date: Mon,  4 Mar 2024 14:12:15 +0000
Message-Id: <170956055640.3262348.5676703851463538355.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240303183659.20656-1-ywsplz@gmail.com>
References: <20240303183659.20656-1-ywsplz@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 04 Mar 2024 02:36:59 +0800, Yanwu Shen wrote:
> 


Applied to kvmtool (master), thanks!

[1/1] Fix 9pfs open device file security flaw
      https://git.kernel.org/will/kvmtool/c/4d2c017f4153

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

