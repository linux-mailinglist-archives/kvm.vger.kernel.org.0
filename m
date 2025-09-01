Return-Path: <kvm+bounces-56436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 36898B3E238
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 465207A8A36
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 12:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A19E276024;
	Mon,  1 Sep 2025 12:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IVNnrs4g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44842275B0A
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 12:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756728424; cv=none; b=GnYaZJZOgsd48E4ei790tE0A/Iydro0fzizEIqS0MunHOryXVXxwNhg9LN+8y+votgDKwzsCQViKddwr7afFKY0D6WEsIwdlY44Qy+alkGa1+jkXjqrnsQ4pEt40ni1+sCrc7aJ67MM6xikvTc74LaYZt3cCjytWLWNvoEN6aJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756728424; c=relaxed/simple;
	bh=HjLc63Sr9zMo+O1rUh2PLUYqrsWWsCLMVGpbHPeJIdQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qqnnur1LnBbZ7eAMix5T0TFU3OuaALquzWBPNwfpFyNGzcdzzRTS2QUjennx2uja/guKbQxEtAv5AQruA/0peyQt/+EENedG2KoY5BxczACbbkGY5sPTcu6yvPjl/DbGGepOxITZxKkp6mTKFUAH0wFg2k6oLlng0TSHYWNjNFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IVNnrs4g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756728422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references; bh=HeESvz4evdpMIU4ZA8+B0q1pn/ain6zFFUIPf5rD2ko=;
	b=IVNnrs4g8HqwmXNqeliPjPo/minJy+r41XXYcpA8Rd/rY34nUweJb9+AEy+6GuBRB5OYEx
	7R7gHKy1TiMOjAGN9jrXgBqUAUcP/YQ2cLDAI2a4d6WAa31gHw6cRyCcutOfdcIeTQZJIi
	402ytqUkoqDfAGFNpvpcoxZG8teG+Uw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-CN-7Fuf1PtyvOu6lQ5nHqQ-1; Mon,
 01 Sep 2025 08:07:01 -0400
X-MC-Unique: CN-7Fuf1PtyvOu6lQ5nHqQ-1
X-Mimecast-MFC-AGG-ID: CN-7Fuf1PtyvOu6lQ5nHqQ_1756728420
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AEDA1800340;
	Mon,  1 Sep 2025 12:07:00 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0970718003FC;
	Mon,  1 Sep 2025 12:07:00 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 5498321E6A27; Mon, 01 Sep 2025 14:06:57 +0200 (CEST)
Resent-To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Resent-From: Markus Armbruster <armbru@redhat.com>
Resent-Date: Mon, 01 Sep 2025 14:06:57 +0200
Resent-Message-ID: <8734965qce.fsf@pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,  mtosatti@redhat.com,  kvm@vger.kernel.org,
  aharivel@redhat.com
Subject: Re: [PATCH 0/2] A fix and cleanup around
 qio_channel_socket_connect_sync()
In-Reply-To: <20250723133257.1497640-1-armbru@redhat.com> (Markus Armbruster's
	message of "Wed, 23 Jul 2025 15:32:55 +0200")
References: <20250723133257.1497640-1-armbru@redhat.com>
Date: Mon, 01 Sep 2025 13:14:05 +0200
Message-ID: <87349677cy.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Lines: 1
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Queued.  Thanks for the review!


