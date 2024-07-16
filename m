Return-Path: <kvm+bounces-21713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9B29327E0
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:57:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AC60B2266E
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 13:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1918C19B591;
	Tue, 16 Jul 2024 13:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e0uDgno6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF51719AD6B
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 13:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721138239; cv=none; b=Kog67CZrMBKL2QEq2mOdLCew6J0jWEDwvq3KCqyj6jCpll4fm9siRs2iVoS8YgyzMFq18CZDSmuEkNFMyCNXdbt1HBko92OT/cWmbZ7Mwa0KCxJChqUr9dls8a59aclUaA0DncU8lchQC/PqYAuvpuCN+B0Me9oGs8mBAvavYtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721138239; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxel0cW4x/S03HcYuEADGf53DSxwuNY4Sh2IG+p6IO7ILvij0tvShl2Bp0FiDsEg3NfwBQHrWeakgT/i/GFAwkO/y/jOA7GkC0EaHE1ABWZ58Hjsmu6FxQ1GAeWovSNQcj//UBZUmB72t8KWzyA9DsPNZtOeShtF9w1vsPjn5+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e0uDgno6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721138236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=e0uDgno6N0v4A9+MnmhJgjegboo3eGNLiWD1UkaE72CCDLooQypJ/DuE/tqyalJajUg1g4
	cbh2WyODMWfNwvmj66g00AYGNtSzCQWF0CEuBFPyVXX/Z7HjFHeUSInB3XM+YmCn9G9lou
	qgudtU7cgeY2mCe4DMtX8LQnzKAP/B0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-573-gkiBvf-EPnyEqJ3yUaXpCg-1; Tue,
 16 Jul 2024 09:57:13 -0400
X-MC-Unique: gkiBvf-EPnyEqJ3yUaXpCg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CE4B1944DD9;
	Tue, 16 Jul 2024 13:57:12 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BA0C11955D42;
	Tue, 16 Jul 2024 13:57:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Clean up hugepage split error handling
Date: Tue, 16 Jul 2024 09:57:10 -0400
Message-ID: <20240716135710.70048-1-pbonzini@redhat.com>
In-Reply-To: <20240712151335.1242633-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Queued, thanks.

Paolo



