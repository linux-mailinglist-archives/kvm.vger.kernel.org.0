Return-Path: <kvm+bounces-15503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B988ACDC8
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:06:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A50D61C20D1B
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8473814EC7D;
	Mon, 22 Apr 2024 13:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qw3UZiZT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E43F14EC77
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 13:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713791203; cv=none; b=VTADl+tAUKFgUz8QY9yUEyFCmYkrmHvJlPIePJQMaoX52QcHHVHaQ1c+cKC8CaBYjAvnmOyrUzkEz0UF2bUyQvwkvXUbkcLd8E059NURE+taRbi6s569uwBqMs076ZiBT+e3sjknX8RTzJPzbvKKjNngZSBixdSUqobd6ip2H2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713791203; c=relaxed/simple;
	bh=g5dM56OQsuK11FfsV0dssIcrLxjbEh5TECTLujgTLMs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=a5LJGtRntmIgXB6qWHCKqL50aVAqyo4j1zEQ037v6EKE+DFckFuIxhBe60PoF3TFXUbgPbL1PHMT9eQoOLpgFGQq1h5CU37yxpRG37Ab/yZ9RKPaSEJGi9nqTSBD8f1PC4zfN0DpY6VmyrqSfHGUpIhCPMla2uJ6Hynir3ZWf3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qw3UZiZT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713791197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g5dM56OQsuK11FfsV0dssIcrLxjbEh5TECTLujgTLMs=;
	b=Qw3UZiZTa5R4EXpSxGIpi0Qw4Eek9tdAj0tlGHQ1MkZ1moZltzM0qaPg+ibQEXAoeb3rQb
	2hclrg6Kd1WaBBxEsxHmn7cFA9PGkW+9P+iPJrKpQAheBQQvBqDUODQNkObu12OIfF2m4Q
	XDTOd0RhVZUe20896c7iBXb8uWxaSas=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-OsbaLYA8My2t1KgeONgwIA-1; Mon,
 22 Apr 2024 09:06:34 -0400
X-MC-Unique: OsbaLYA8My2t1KgeONgwIA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7A6E3C23FC3;
	Mon, 22 Apr 2024 13:06:33 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.247])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B47CA200AFA2;
	Mon, 22 Apr 2024 13:06:33 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 8C17621E6680; Mon, 22 Apr 2024 15:06:32 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: <qemu-devel@nongnu.org>,  <kvm@vger.kernel.org>,  Tom Lendacky
 <thomas.lendacky@amd.com>,  "Paolo Bonzini" <pbonzini@redhat.com>,  Daniel
 P . =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Pankaj Gupta
 <pankaj.gupta@amd.com>,
  Xiaoyao Li <xiaoyao.li@intel.com>,  Isaku Yamahata
 <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 21/49] i386/sev: Introduce "sev-common" type to
 encapsulate common SEV state
In-Reply-To: <20240320083945.991426-22-michael.roth@amd.com> (Michael Roth's
	message of "Wed, 20 Mar 2024 03:39:17 -0500")
References: <20240320083945.991426-1-michael.roth@amd.com>
	<20240320083945.991426-22-michael.roth@amd.com>
Date: Mon, 22 Apr 2024 15:06:32 +0200
Message-ID: <87frvdeecn.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Michael Roth <michael.roth@amd.com> writes:

> Currently all SEV/SEV-ES functionality is managed through a single
> 'sev-guest' QOM type. With upcoming support for SEV-SNP, taking this
> same approach won't work well since some of the properties/state
> managed by 'sev-guest' is not applicable to SEV-SNP, which will instead
> rely on a new QOM type with its own set of properties/state.
>
> To prepare for this, this patch moves common state into an abstract
> 'sev-common' parent type to encapsulate properties/state that are
> common to both SEV/SEV-ES and SEV-SNP, leaving only SEV/SEV-ES-specific
> properties/state in the current 'sev-guest' type. This should not
> affect current behavior or command-line options.

QAPI schema refactoring except for the misleading "since" documentation
pointed out by Daniel
Acked-by: Markus Armbruster <armbru@redhat.com>

[...]


