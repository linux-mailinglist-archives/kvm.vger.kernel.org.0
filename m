Return-Path: <kvm+bounces-31936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A059CDF9D
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 14:12:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CC77B22207
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 13:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A3D1BD50C;
	Fri, 15 Nov 2024 13:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="il4X6uxU"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DC3190056
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 13:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731676320; cv=none; b=Y2p2xgChW4eCqNF41pY1d/CVqBuoh+mMJkndBL/E4QI3Sfi9jECZeNhlM2UgYdGjma4ZhWK0z7lck24B2m5BfPh+UJS6NMOyGU8NaYWc5Eh4bg1C879a2F/QSozzvN6yGQCRyiDTjpQf+Pv2Em4clTt5LC2AQoIqIqCK8fXUM3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731676320; c=relaxed/simple;
	bh=W8Y1eENMRG4L9jmCSsCdBxkEH4ci3nJEqLCc6uPOVac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=leMm4dzYpbCSHaY6qz8X23FLhwcFttD/mr5ymsF8ecC9E8qriB1wiOuWTicBDfcf4gex/7zzrViv+brNaBLoMJcQ0+xb9woahbaXwSe0VJohzEMVVKRUWpzg8yAeWpOyenlGZGvjPL6PoJXM8GnJMpbruHOZHQ/XgxJbcrEpR8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=il4X6uxU; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:94a7:0:640:198e:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 7928F60B95;
	Fri, 15 Nov 2024 16:11:46 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8011:701:66e1:20a5:ba04:640b] (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id iBNATh5AZ4Y0-eb5xLDzW;
	Fri, 15 Nov 2024 16:11:45 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731676305;
	bh=rSFiDEf6GCIKTBQ64/uR6HhLtdm2bj5zXAbCmyeMcNA=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=il4X6uxUm0ofVSswfLGnPejKUM8ko6HdavmFpQ3KnETN3L80Vxe2qjBwhNTVS2DeN
	 kSxIk+MhYn7iyGpCel3004jaVwN8a723bt5XXbBmEA9gfpA9V+PmVf6mV9dcvptOhE
	 0pdMbHA1Gsg2qZCwzu2eRROLx0BaeBGd49wC3lY8=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <7e485305-8957-411a-a792-d07468f77264@yandex-team.ru>
Date: Fri, 15 Nov 2024 16:11:44 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] target/i386: Update EPYC CPU models for Cache
 property, RAS, SVM feature bits
To: Babu Moger <babu.moger@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com
References: <cover.1731616198.git.babu.moger@amd.com>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <cover.1731616198.git.babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

On 11/14/24 23:36, Babu Moger wrote:
> 
> This series addresses the following issues with EPYC CPU models.
> 
> 1. Update the L1, L2, L3 cache properties to match the actual hardware (PPR).
>     This needs to be updated on all the EPYC models.
> 2. RAS feature bits (SUCCOR, McaOverflowRecov).
> 3. Add SVM feature bits which are required in nested guests.
> 4. Add perfmon-v2 on Genoa.
> 5. Add missing feature bit fs-gs-base-ns(WRMSR to {FS,GS,KERNEL_G}S_BASE
>     is non-serializing).
> 

Seems good for me. I've tested cache changes.
If needed, Reviewed-by: Maksim Davydov <davydov-max@yandex-team.ru>

> Dropped EPYC-Turin model for now. Some of the feature bits
> (srso-user-kernel-no, eraps, rapsize) are still work in progress in
> the kernel. Will post them later.
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
> ---
> v4: Some of the patches in v3 are already merged. Posting the rest of the patches.
>      Dropped EPYC-Turin model for now. Will post them later.
>      Added SVM feature bit as discussed in
>      https://lore.kernel.org/kvm/b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.com/
>      Fixed the cache property details as discussed in
>      https://lore.kernel.org/kvm/20230504205313.225073-8-babu.moger@amd.com/
>      Thanks to Maksim and Paolo for their feedback.
> 
> v3: Added SBPB, IBPB_BRTYPE, SRSO_USER_KERNEL_NO, ERAPS and RAPSIZE bits
>      to EPYC-Turin.
> 
> v2: Fixed couple of typos.
>      Added Reviewed-by tag from Zhao.
>      Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of https://repo.or.cz/qemu/kevin into staging")
> 
> v3: https://lore.kernel.org/kvm/cover.1729807947.git.babu.moger@amd.com/
> v2: https://lore.kernel.org/kvm/cover.1723068946.git.babu.moger@amd.com/
> v1: https://lore.kernel.org/qemu-devel/cover.1718218999.git.babu.moger@amd.com/
> 
> 
> Babu Moger (5):
>    target/i386: Update EPYC CPU model for Cache property, RAS, SVM
>      feature bits
>    target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM
>      feature bits
>    target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM
>      feature bits
>    target/i386: Add feature that indicates WRMSR to BASE reg is
>      non-serializing
>    target/i386: Update EPYC-Genoa for Cache property, perfmon-v2, RAS and
>      SVM feature bits
> 
>   target/i386/cpu.c | 299 +++++++++++++++++++++++++++++++++++++++++++++-
>   target/i386/cpu.h |   2 +
>   2 files changed, 300 insertions(+), 1 deletion(-)
> 

-- 
Best regards,
Maksim Davydov

