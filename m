Return-Path: <kvm+bounces-25882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB43996BC78
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:35:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D62391C21E25
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68CE11D88CD;
	Wed,  4 Sep 2024 12:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PyWCUKSp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CEC1EBFEB
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 12:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725453302; cv=none; b=EhJi6cMdlG2KZ5AxHWnzbecAnVRIXAiRkw/r+RAUs9TTSTwUj/6M4Rl7iSPqe3ewJtqz4OWleGsU5LQxHIGn/IinWDGhPvEE4B6VCZYOuvwDkizoujuASjbmjSH1upEjhwSyaf3FsPDxgrtOK2HAyDKEftsK3S5Cpwx5ufTo/98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725453302; c=relaxed/simple;
	bh=G0d2Ftw1keF+MecVccHVBUEJn6uLHHjgQh3Tc33KnfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzM7A09w3vQi0T/9Umllq3scHJKuEibgitiBdV9TPBnaZ5XyH+J60GDrH6h1fpkiPe0DLoA24XGwN2Ot6i92pf7tOkaE4Re2F4DagkWy6AIvi8NWSciMzIwuxrDjNLzeIAs6dmAxNHtQq4qVs44ftv/YWsrBm3GsYX2sGkd1w9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PyWCUKSp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725453299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G0d2Ftw1keF+MecVccHVBUEJn6uLHHjgQh3Tc33KnfM=;
	b=PyWCUKSpcdHqbkiAzE0ME/xXEZXF4h/Y/kEMF63GrVxDOWW+3LwBFs9ytDLqhN2z+2fdrA
	lcpJB2lsmbOY96ArnyrSw+5GV5IwDQl3n6h+uDAzs+1cN/L1uM/mKHwWRA7bD+TrPw6gNo
	z0ZmBoLYIhn//cTVEobuszxzP1ZGaXg=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-sfhEdlqHNcmYJxWbqiya_Q-1; Wed, 04 Sep 2024 08:34:58 -0400
X-MC-Unique: sfhEdlqHNcmYJxWbqiya_Q-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-53349795d48so2358166e87.0
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 05:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725453297; x=1726058097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0d2Ftw1keF+MecVccHVBUEJn6uLHHjgQh3Tc33KnfM=;
        b=aGjuIjV7EDCdZUKkyXu3i7TerLVlAhmsQweEdM5RIcL+uZgkEhk37geVD1LXT0TJuC
         go+1G0taeN2m4LzSTjLQ4j/roinhg853zYsVl3Q0da3PwjnlNlN3mf/k3EUWOo3IfDNu
         GVOA0VkJxNFHGC/44nz7JXKd4RtRmP+azekXNidueMCBq1csx5zP+0g4e6L8doYeYCkj
         o14jdbe61af2ri74+CpFh2I2oKNyVZzLMSWTWtLgPTqtSKqF6bAy3YaZDLWYeVCCWTSW
         8FzKJZ80H6H6P8xpTJr2xVgy4Zn+aRFYGiRlTm7sD/6Fu3F18YRkPAqB/eoGcU+XKeeF
         4U8A==
X-Forwarded-Encrypted: i=1; AJvYcCWhlPzfS1jrOYl4OodPB1CHba7Kile+yOxRL4xKzxVSJl/TT9klW5b0JloozL4yb0WcXgo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3cyO0MBU75Qnpg0oRRyz+DhRO4AejfESjzlgqTx8hza/PkENZ
	VQLxIrjP5F7K8Bu+rlMlTIxTETBHewJFGjgQ4NFtzPSwABfGGvNNnDAPtbQ0Hdt3j069EoyuLOZ
	skgy8rZHLaj+bQsMYfsObpeNx+nhUgOwX9yzr1Mw/09jira5hC20ctDJeAL/y
X-Received: by 2002:a05:651c:547:b0:2ef:1b1f:4b4f with SMTP id 38308e7fff4ca-2f6104f259bmr138053231fa.34.1725453296961;
        Wed, 04 Sep 2024 05:34:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoRBDHPavq6UA0kKQTAAAvezahr5ruud7mw7u5FPzMvT3688Ku6QSAG1c69iTWmJdtOmQO5A==
X-Received: by 2002:a05:651c:547:b0:2ef:1b1f:4b4f with SMTP id 38308e7fff4ca-2f6104f259bmr138052911fa.34.1725453296364;
        Wed, 04 Sep 2024 05:34:56 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c24f0ed6d6sm4690183a12.90.2024.09.04.05.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 05:34:55 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: zhao1.liu@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v2] kvm: refactor core virtual machine creation into its own function
Date: Wed,  4 Sep 2024 14:34:49 +0200
Message-ID: <20240904123448.284294-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808113838.1697366-1-anisinha@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued (with conflicts fixed), thanks.

Paolo


