Return-Path: <kvm+bounces-42640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7075CA7BAF9
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:36:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A43437A9DA7
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45E91BEF87;
	Fri,  4 Apr 2025 10:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ICnrO4m3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAC32E62A0
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762892; cv=none; b=MncIM1fPj8QfmxVqqrFHtiNzVkE6nV/Zf7b1SPim2ME6AH3OHxIRcrzHQJrsUD/QWMTOAtknIGZTxH0/Vdw9Kz/RKGKDYzd/pN7gJdzonna6u5krVLpCrC2brOO/XGnUObxj9GCZBCKbKrLbNlrK74OPtMuXjQZq1yKiWSh0100=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762892; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o576B9y7w6d3JLN4+FZZCz4Iz8u0MQv34QGGdUCHJnYd/ul5NfhQU69W/i+qYUUHaDPHz1mB+ucRjaYnWXLEwncEUNEM/DXgYJ2J962qfZhzsYLgm+EF8VcZMYJJgVEkw2k6NQ6mjaFubY3P3vWY3lN/Mnk9byUmbvVclqsDbq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ICnrO4m3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=ICnrO4m3UNfhp48xu+adhgP/Wh8PCgJGI5RL6viXqLktes980sUt8X1GerLRQcOBlm62ph
	9UCLyxdBGGt7dJ0DjDrgIgx9hEtBPkalouglN4kADZFlhfvmSoSX2eqe9ycnhaNqxFWtjD
	I78ZBdgeGo7yO8N8T+q23hAx9oisss0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-6iY8ENh7PFSWUnP4_oTFLQ-1; Fri,
 04 Apr 2025 06:34:46 -0400
X-MC-Unique: 6iY8ENh7PFSWUnP4_oTFLQ-1
X-Mimecast-MFC-AGG-ID: 6iY8ENh7PFSWUnP4_oTFLQ_1743762885
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67047180AF57;
	Fri,  4 Apr 2025 10:34:45 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 84F4D19560AD;
	Fri,  4 Apr 2025 10:34:44 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>,
	mlevitsk@redhat.com
Subject: Re: [PATCH 0/2] KVM: VMX: Fix lockdep false positive on PI wakeup
Date: Fri,  4 Apr 2025 06:34:33 -0400
Message-ID: <20250404103432.187609-2-pbonzini@redhat.com>
In-Reply-To: <20250401154727.835231-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Queued, thanks.

Paolo



