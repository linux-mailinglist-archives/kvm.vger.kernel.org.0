Return-Path: <kvm+bounces-25684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7192D968A80
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 16:59:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89B641C2220A
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 14:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3602139C7;
	Mon,  2 Sep 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMeFqD3m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8338D19F11F
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725288997; cv=none; b=cPHuc7Z29FbK+iKUzjHl3W75fIOzj6/bqret3bW0iKEukGjfbXt+C8F1lcnNWIQ+SXEC5VBlvkuEI7lN/afO2ZD8zlHqY+aEihgCn7Lc+VWuMP9D3Om5qBxzXSRY2t0692nFTe3IkZT+xrPXhW0to0PyKNY0mB6hf/VynykYmIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725288997; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSeRwOLPi9LgPY0J1BZpxlKp1w8hrUyhYNxql8h7KUkFiL2zBThT6T4rXSEA2Bq94NVn5FOJzYvAmXjHSa5U7wwjvnXMaU4uq1eGLQRrLI9ex+ywfD+/nIojfFPZsQ4GZonlAkEU2Axs6bHTNY6re3OBcbkSd9Mwih5RgkDA9WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UMeFqD3m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725288994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=UMeFqD3m90e65JVyqo+xxe0dKi920UZ7+q6Zii6yRkurRa58vUjQPe6c1yWlQjXdkMMVAu
	ZT3IN9Sz0YR+GVR7QIQzBl7rnQXrPfqUOsYrMU2Nb6hoN/BEn5GC8TpzK0INbyKpyYxPEq
	TVP4KisqQX5sE/RA/uG7x+d+AWwEtxg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-281-ssdQZ4g1MhaeoubITEXOEA-1; Mon,
 02 Sep 2024 10:56:29 -0400
X-MC-Unique: ssdQZ4g1MhaeoubITEXOEA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 032ED1955D48;
	Mon,  2 Sep 2024 14:56:28 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EDA6819560A3;
	Mon,  2 Sep 2024 14:56:26 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Tom Dohrmann <erbse.13@gmx.de>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH] KVM: x86: Only advertise KVM_CAP_READONLY_MEM when supported by VM
Date: Mon,  2 Sep 2024 10:56:25 -0400
Message-ID: <20240902145625.173549-1-pbonzini@redhat.com>
In-Reply-To: <20240902144219.3716974-1-erbse.13@gmx.de>
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



