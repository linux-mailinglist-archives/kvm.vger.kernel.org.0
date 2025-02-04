Return-Path: <kvm+bounces-37243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF9FA276F1
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69E0A3A3FBF
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 16:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C35821519B;
	Tue,  4 Feb 2025 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D2S5vNUi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29393232
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 16:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738685765; cv=none; b=BrDKVGTRJNU2eaZbZTo4AogAygJy3PTjtMxpLz94UUiMkZocLP8bQToQrV95aR/lhwICrMg+r6+H5/9hQaVvnammzQ/drYcmf0fYIidWXvCr/WnDM2nKYMd1foDuXCxMaMQuLKpIn6goO/TmcmU+CI1tHWYa8SxcgTveI5qUSHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738685765; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YB9sVHmuqh/pAExQTAJTq/aUeKPWCo6WhWL6GxY0Ze4+334pOrtdcJXRuzCs47OlHWiv1Bbs+stmBlDjqYENAWzDcDIahmNThh0j0EiDWdYaFCn11Bgf8AEm5Caou0Z8gnvA+tkXZiC4ay/TvAAo6TotVXyBNPgA0UUQAum/1Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D2S5vNUi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738685763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=D2S5vNUiAMUTjsvcxKJBX4zuY8rM50to4+IbARXsA+XFXqYGGJBoZOl5PV8wKTftsjtnTh
	IPqojXaLZwxLiw2GpcveHiPa/O1yhlOxTRrajncy4Crg2OryBVrEoO/672UG3eyjLQDkXt
	ihPw54+kyGNcbOme3zM0FGsnc4qM1js=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-NefMONUHNcaM9JCWy--Unw-1; Tue,
 04 Feb 2025 11:15:58 -0500
X-MC-Unique: NefMONUHNcaM9JCWy--Unw-1
X-Mimecast-MFC-AGG-ID: NefMONUHNcaM9JCWy--Unw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E25019560A1;
	Tue,  4 Feb 2025 16:15:57 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5FECE3003E7F;
	Tue,  4 Feb 2025 16:15:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Fix spelling mistake "initally" -> "initially"
Date: Tue,  4 Feb 2025 11:15:53 -0500
Message-ID: <20250204161553.252280-1-pbonzini@redhat.com>
In-Reply-To: <20250204105647.367743-1-colin.i.king@gmail.com>
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



