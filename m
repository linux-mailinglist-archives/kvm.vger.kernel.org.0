Return-Path: <kvm+bounces-53373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F2D4B10B54
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:25:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F72D3A38F3
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCBA2D9783;
	Thu, 24 Jul 2025 13:24:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EA92D641C;
	Thu, 24 Jul 2025 13:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753363494; cv=none; b=i8S3jL4l4Y/Ow+d2AAyoyNluhc07oUpSNBDi46opsj42VIVUWtsIiOXGpuwenyTWhNvYUo4uye9yeleUChGBdQxw3MMhWHVPeGhAdyofXqORlN49P1AuQL8/Abnl9zVit7XoCtmrNlFw4+11RK6G74n9imtf7Sz+JHr3X4I3ltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753363494; c=relaxed/simple;
	bh=T0NQMfH/DqrpVZn61hgP3A1tKXJJh/zk0upUoo9/olU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BGL8eOBd62QseHStQWgbQjUhDmjAxzI6l84pugzq0swfAzaXx4BvWAqwsyBdiI7hkWRu7g95BYQ44bxi9pG9bqQfkcIoM7BeCN7EMlC9VcKgcseCuQo6bnPmjXyGqjqBNC7OZgIG4W/ubPOqBIrJsQ+ZdI6snICfjZsVs/f8pXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2CBA57998;
	Thu, 24 Jul 2025 13:24:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 862D820027;
	Thu, 24 Jul 2025 13:24:48 +0000 (UTC)
Date: Thu, 24 Jul 2025 09:24:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Bibo Mao <maobibo@loongson.cn>, LKML <linux-kernel@vger.kernel.org>,
 Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] LoongArch: KVM: Move kvm_iocsr tracepoint out of
 generic code
Message-ID: <20250724092448.4e84a589@batman.local.home>
In-Reply-To: <CAAhV-H4TGus35B6ONdkSOMwWw+H6NRmHStV-Xu7vUYYrkDGfUQ@mail.gmail.com>
References: <20250722094734.4920545b@gandalf.local.home>
	<2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
	<20250723214659.064b5d4a@gandalf.local.home>
	<15e46f69-f270-0520-1ad4-874448439d2b@loongson.cn>
	<CAAhV-H4TGus35B6ONdkSOMwWw+H6NRmHStV-Xu7vUYYrkDGfUQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fsfq8fom3zkmdm9cdzbnigwb7rn7crff
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 862D820027
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX185VQoLRm2vHT9R8dOyJNENrA6l4lO0Hn8=
X-HE-Tag: 1753363488-726373
X-HE-Meta: U2FsdGVkX1/2c1GOg2tcWnG2jdUemls9M8cVSFYKczaUEjC/q8AVOj0+I1EaJa1zGAru4N2VRbp6kPuVtaXrjRsBPYiReIutr9e/nimNwRf9tFn2cTbWfqJazdFSrE1wEaWMB32p27VQ9AfcmbYT6ODMFZpyNXvb8ToR8QsdFxdFXStDla55hnSA7S9KQiZYRDbcxGx2CmQLdqHSiN2wcfQAcLoZXXEyqZHFNa+zLEd2ZE0ksbsJk97OeVkyuKQEA9ZBJmhx8kIZOOsRP/8hMePRZNWH5BR3wgn0E6GmNc1h69TrTntsBdt4AskxGwYhMdZr7ppp9s1SjbOs6hHv75EPs7Fbpkv0TrrVCPLNAMjUSajsXnnzCA==

On Thu, 24 Jul 2025 19:56:42 +0800
Huacai Chen <chenhuacai@kernel.org> wrote:

> > > Should this go through the loongarch tree or should I take it?  
> > Huacai,
> >
> > What is your point about this?  
> I will take it, thanks.

Great! Thanks Huacai and Bibo,

-- Steve

