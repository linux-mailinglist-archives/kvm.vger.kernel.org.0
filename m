Return-Path: <kvm+bounces-10521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 554BD86CEF5
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:26:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F5ABB2AD39
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47CCF160641;
	Thu, 29 Feb 2024 16:14:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F506160635
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.28.154.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709223281; cv=none; b=rqHqJoToLUJbiKBRul0RKs+YcBTujsNVNDuURH5WMLgWTAXpikLyFVU2ffrn1NHaLGrNBhxFZskQs5jl5ZyoU7NmoTjv61PdaXFeKfkQ03yZ7145uffC4ZZaqYxLPqbQ6qKlAIIYiKT2rY8Yi+t6aYvHsaJm2vPSacqzJZdkdaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709223281; c=relaxed/simple;
	bh=QDwmRzYCJuJ/pKcW0Gbx2VR/alyE9Rn8ptkm5Ft1Mbo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=aFruKcWAfWPtW5qDeiDdBxf5psy9OPJKwLSw98TYxHEI+i6TtYRt20bpAjTaqmB/7go3mRn+KOHpyMc3VuJAWUne5NMiOYtA2F4fLjnFTGKT5gWOQm/nZU+8G9lCGOzBcL5N2TYj6OQadZ59gqs44RE+Kd7axDOJP6gK9kMz3co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=maciej.szmigiero.name; arc=none smtp.client-ip=37.28.154.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maciej.szmigiero.name
Received: from MUA
	by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1rfiaU-0005pd-4A; Thu, 29 Feb 2024 16:44:46 +0100
Message-ID: <9e9472b0-e518-4ae0-9a69-ebfcd193a1ff@maciej.szmigiero.name>
Date: Thu, 29 Feb 2024 16:44:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vmbus: Print a warning when enabled without the
 recommended set of features
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
References: <e2d961d56d795fe42ea54f1272c7157e40aeae1e.1706198618.git.maciej.szmigiero@oracle.com>
Content-Language: en-US, pl-PL
Disposition-Notification-To: "Maciej S. Szmigiero"
 <mail@maciej.szmigiero.name>
In-Reply-To: <e2d961d56d795fe42ea54f1272c7157e40aeae1e.1706198618.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25.01.2024 17:19, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Some Windows versions crash at boot or fail to enable the VMBus device if
> they don't see the expected set of Hyper-V features (enlightenments).
> 
> Since this provides poor user experience let's warn user if the VMBus
> device is enabled without the recommended set of Hyper-V features.
> 
> The recommended set is the minimum set of Hyper-V features required to make
> the VMBus device work properly in Windows Server versions 2016, 2019 and
> 2022.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

@Paolo, @Marcelo: can I get some kind of Ack or comments for the KVM part?

Thanks,
Maciej


