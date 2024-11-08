Return-Path: <kvm+bounces-31239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB96C9C18AB
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 10:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B97D8B24803
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 09:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F841E0B9C;
	Fri,  8 Nov 2024 09:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SOIHdhMD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A20C1494D4
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 09:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056583; cv=none; b=EkPRimVzIGDik9MREQi8byORPZFB+RQaoHEFZ7brEAWu8J0nLuYuE+3ZPLihmkfik+rERiIVDENpwkuS0WhaQxyyb+pNRVg0Z5hjcLfvdkWUkR+SQlHjuFrjH6rsJ4+cqmZdYB0E4HmNKGT5jfrS4AzY94sm3w7pNmhLsqKI4cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056583; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZH13vP+i2oiQskFnAbBBORHsieMK9e1BJQ+C6lcAhsrSBzW0gfMow5QiOSE2wzQjmNcbmqGmMOlN5VRSs0/ukX8kv3TNY8hLUoNOZz3138R0mM450I2UUkwwSr1qcT7iWO9yHdar0hIDSBGtGSfOMAJxwMt5g3rYvxSdeYAxOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SOIHdhMD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731056581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=SOIHdhMDtot+JbOwVWD9NG6uJ6tRzE1KhRm1ymVlrhcYnYiwxWRecHPxPEukASUisskwiY
	/wy5RteBkr5r5CMVeJgpROqweJN7kz87YgAOdv5Pii+IXMS4e1422NT54FEKFE+woAt2ku
	AALvlEoH8cSLk1W3dzVvIPVvwRqv/NM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-204-iCne93DxN2ONu9BrsURPKg-1; Fri,
 08 Nov 2024 04:02:58 -0500
X-MC-Unique: iCne93DxN2ONu9BrsURPKg-1
X-Mimecast-MFC-AGG-ID: iCne93DxN2ONu9BrsURPKg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0D551954128;
	Fri,  8 Nov 2024 09:02:56 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 08708300019E;
	Fri,  8 Nov 2024 09:02:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: John Sperbeck <jsperbeck@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: use X86_MEMTYPE_WB instead of VMX_BASIC_MEM_TYPE_WB
Date: Fri,  8 Nov 2024 04:02:51 -0500
Message-ID: <20241108090252.5439-1-pbonzini@redhat.com>
In-Reply-To: <20241106034031.503291-1-jsperbeck@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Queued, thanks.

Paolo


