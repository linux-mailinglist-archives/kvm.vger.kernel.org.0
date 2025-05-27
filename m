Return-Path: <kvm+bounces-47801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44FD3AC52FD
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA64A1BA3420
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 16:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E4627FD49;
	Tue, 27 May 2025 16:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gM2ubTg6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9331A27EC9C
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748363025; cv=none; b=vDEKTQynJ+fzu3GeHikSU2QvpavMPkZ6k6p5e+xT9fy6jrBfvg11fJV2YckIlSZqxu4XyKekausYjdtuQu80maglWSpUX+Gnnp9DwVrQSEOII0tojegSeNJM0w84inBFmWVb82nLvWAzAD0rDxWH6nHxpWDBszMC9wc2GJvhqvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748363025; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9GrAWizaJqPUEt+mou2LXdCfSAjxk3gEYtD+VTwz/zDxzzqqRvKbzLWGM9uPeebh8djTGRTOp3IJl4S1FUDd6exvQjUTgdKUyvMiOQAGrtfJG8DsqP00YGajYFwGXp7cuSq4uWZX+0gcQrcLHAFvLPnAp4tSH4FJwbQBa6zFE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gM2ubTg6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748363022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=gM2ubTg68thx2bOX5ROWmGjiZMxKxTH7uvgakbk5oPOQlHrA/8YE4QAXeJwy5uegG32ZYO
	Vh263X0O6s88UhSxHHDt2jpHbDIBfkUHT/owDt2Z1y0ovCuKScSSC0ri3A24/VMj8n9QKH
	AQAkGPLnGKLG5JQBkm+iLnX4lgA3GuE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-VtMr-klIPlqQN7sTfDOvJQ-1; Tue,
 27 May 2025 12:23:40 -0400
X-MC-Unique: VtMr-klIPlqQN7sTfDOvJQ-1
X-Mimecast-MFC-AGG-ID: VtMr-klIPlqQN7sTfDOvJQ_1748363020
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B8AD1800256
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 16:23:40 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 945A0180049D;
	Tue, 27 May 2025 16:23:39 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org
Subject: Re: [PATCH v5 0/6] KVM: lockdep improvements
Date: Tue, 27 May 2025 12:23:31 -0400
Message-ID: <20250527162330.611961-2-pbonzini@redhat.com>
In-Reply-To: <20250512180407.659015-1-mlevitsk@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Queued, thanks.

Paolo



