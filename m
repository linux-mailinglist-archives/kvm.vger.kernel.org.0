Return-Path: <kvm+bounces-20171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCDE7911435
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 872FC285C0A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 21:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F517FBB6;
	Thu, 20 Jun 2024 21:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GSbiuySd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F68C6EB60
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918130; cv=none; b=G7oCjpTNULs4G+IEf9yjlEzdCrYQX6kwdiDQv+pLfsO+jFiXAf3e++kWEB/gQmUXqM0/VKayefZQhj76W0tcTiPwCZc7CXwJoBRP01ZL376ouKvtwS64++bNnk7Bhg7if3LXFk8sIfFMM8A2qRViSPs8aQhELwkP+QIxj/4HheI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918130; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSI0Z7vD+H/7JDfiKhCCuca8mcN+0RlPE3mtPZfJkHjUiwAJbFoOTx+bRq9CPCVvvhzIgHVN1WSd3mnZPdCwGmP/3DVBHUQiucnPBkPtGHPyaAe30xftV6lFIyKqn+lvgFferf/mbxBlpzMeM3hhZXn2zOqM6Ngde6oMOGuttZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GSbiuySd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718918128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=GSbiuySdwJK7uE0eIsehScwInbcm6OgpM4ITIlN2tOnnCMmUgGVRvaPQRargHqMsfVj7P+
	9wnbg1BHipEBsUJQOW5trGl/ZIqKGhpW4tr5Y8XAL+0DCwkdOmnvLPNox+IWFE4q6NZeCA
	vkTLIIUw7E5F3x9gTD8lkt1JTgvIgFw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-KFasPGq9OH2co6QFhcPzPw-1; Thu,
 20 Jun 2024 17:15:22 -0400
X-MC-Unique: KFasPGq9OH2co6QFhcPzPw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DC6319560AD;
	Thu, 20 Jun 2024 21:15:20 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 97C3719560B3;
	Thu, 20 Jun 2024 21:15:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: Simplify kvm_get_running_vcpu()
Date: Thu, 20 Jun 2024 17:15:17 -0400
Message-ID: <20240620211517.83191-1-pbonzini@redhat.com>
In-Reply-To: <20240620081114.70615-1-jiangshanlai@gmail.com>
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



