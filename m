Return-Path: <kvm+bounces-24805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A90995AC50
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 05:59:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06221281A0A
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 03:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4370A381C8;
	Thu, 22 Aug 2024 03:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqaFpXLa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1F62E644;
	Thu, 22 Aug 2024 03:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724299148; cv=none; b=QHmviTHzt1SLzjloPLHi8NhZ33Karsas0cwis/9fJGwLbG/4WRjLagZKxW45D8b5hR8hync/AITRkIiKaJfmBmxcga4VdOG2YyFXFvMsznl2imyDCSI4Ihkv4bLSf9dfHfqFKdTqc3xO2jLiCkO5tNMJsYbATJAQUGn8J0fIqJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724299148; c=relaxed/simple;
	bh=MeUaIymMWet32UJr/UCPvNt4T3nq4nqzI61CVdg0XFc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hdD0xbRhopy0D4MBZRKbou+FBW9W0pkXXQlPc9X4XM3rvLjK1bNuY7iBcOC9GoQGCjSFkimqVMh0HGR3bKMtRE7H9I59ezRihzWe2db/wBsUnf7AL55njt/YrYM1fXqTwdmfG8Mvylc2BwWmS3n3iOsjR5jSrf44Xwrl9D0uqY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IqaFpXLa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D854C4AF09;
	Thu, 22 Aug 2024 03:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724299147;
	bh=MeUaIymMWet32UJr/UCPvNt4T3nq4nqzI61CVdg0XFc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IqaFpXLafjAn3gFHbE3Avza/+ergXjXsURmfn1nc96I21IgbyAp3IFHUfKBJ8IkrM
	 KbPZvIH8QwNb5lI4zjYq40LMvg6oJ2fwPJprnRKLnMlZZZ3+xzRK8DROCHWddfiNe2
	 02Jhvckthxrri4w888p1nL3A/zNBeK8TVrMnoh1TGoB8lpJKb048k00MlHzC0XAj4h
	 haqjQ8nkxVyayvp8ght5uS4Li/Svb7f9uatYHSOS/zfVZRbqlxJgNBPDD5vxdLNHr9
	 bc/QCVAWFsSwhqtsDmvOBKu6wv0C2oH9W4MzRfbfp88VLGN7lFyvUIdIoKK7f6kMVs
	 80fZdHBTViAsw==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v4 18/43] arm64: RME: Handle realm enter/exit
In-Reply-To: <20240821153844.60084-19-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-19-steven.price@arm.com>
Date: Thu, 22 Aug 2024 09:28:56 +0530
Message-ID: <yq5a5xrt2oov.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> +	/* Exit to VMM to complete the change */
> +	kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
> +				      ripas == 1);
> +


s/1/RMI_RAM ?

May be we can make it an enum like rsi_ripas

modified   arch/arm64/include/asm/rmi_smc.h
@@ -62,9 +62,11 @@
 #define RMI_ERROR_REC		3
 #define RMI_ERROR_RTT		4
 
-#define RMI_EMPTY		0
-#define RMI_RAM			1
-#define RMI_DESTROYED		2
+enum rmi_ripas {
+	RMI_EMPTY,
+	RMI_RAM,
+	RMI_DESTROYED,
+};
 
 #define RMI_NO_MEASURE_CONTENT	0
 #define RMI_MEASURE_CONTENT	1
modified   arch/arm64/kvm/rme-exit.c
@@ -112,7 +112,7 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
 
 	/* Exit to VMM to complete the change */
 	kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
-				      ripas == 1);
+				      ripas == RMI_RAM);
 
 	return 0;
 }

