Return-Path: <kvm+bounces-24288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E189536DF
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:16:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53BFFB211B5
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5F01ABEBB;
	Thu, 15 Aug 2024 15:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FfT6r+Uc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442C11A706B
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723735001; cv=none; b=TpUr+BeeFnU5fcQRfVcqbtp1fCz3n9WOrcnrlYdgw4Uth5xFNZiEP24tYbQc4I01v1ECBc10fjSz9OgztSCe7mcWLZePU+7nOYTKrvakbtpzPqTDsOQyj0JVrt+igZi8snXq9iV/6anH8ufJR05GZx0sx8dzT6bA6OozLHm27es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723735001; c=relaxed/simple;
	bh=p41m5YvSjQgQm0tkYUYL+QWq1GHejmaKGY1AgryhcvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gUN6WzqZsngg1kVwFt/eiSmWHlc+Wg2S4djo1Skr59ncubxWq71wpYVhuyJrIrg/0iJc4DJzKADHNsm+MM7wFD0I6nBuJQzBV+TwzN9+hCUbzOCPCt6cWnDJg2z4Yg0zjaE0/hEvfmd0yU404lpTALRNCVwpwnJG0vP+7WdoBGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FfT6r+Uc; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b198ecf931so421347b3.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 08:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723734999; x=1724339799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p41m5YvSjQgQm0tkYUYL+QWq1GHejmaKGY1AgryhcvY=;
        b=FfT6r+UcQKRbDGDpXZVInCWT+bvz8y/5VravLXNilCiXc9SEPhdOfUPXiV/l95mIS8
         n87pfIsw4zW2PNFrrE0OE9gs/LgZYmBXrVcQGrebSoz0bH5by+9z3DoAtrXAoWVX5uhF
         zSQ3XBVXhQHnFa4dfl2EOiZcIqVRKUlZMfMVsFuPXuOycAScZ/PnQ6MRfSEFuG1UxCpQ
         oGtinl8D/SAGb0rxH6F6jBlatWOxi187HS9Ohda5YEdTi+Qz+O49CvQVsAFolT7YPSR9
         itwURHhYcbFGsXU9PfOq2M7nPl7mi+YD5kjM0wQje7JLm2foqgu2DOECOrFyKKCAMdBx
         Dt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723734999; x=1724339799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p41m5YvSjQgQm0tkYUYL+QWq1GHejmaKGY1AgryhcvY=;
        b=GLVLaAtbi9IzQSDVGeM2eIxGacQTXCwSDA6ayAEAStwY+HiEVdPctqWJC3jsJGRHup
         2ahuavJay1MeIwTrwiPOE4fla8JNuvf3x70V5033tpSuiUnbnmjDLkQhedJxA7iqRRns
         7qFjVkYEa6mayWCSE4NrU0C+a/TKYKIKmKi2X3HIYZ8JWjof5HbEWHFVw+XHA8fZ0rvP
         G6JSWF+W7PU2zTfG2GMZ8PuYYTShemuEnz1SPkTBBeFve4LEFrYSh2d8pq21PgdRjUPv
         VbtoYgB5dDw2lhbaIcYjkhHfDY0hLXW63Tu7hdQ+HLZ7UYQJ2/30f6pzIiAlXm9nDMd5
         eMCg==
X-Forwarded-Encrypted: i=1; AJvYcCUr2PRq1ELuP7eTR38VH44v5QhGzSEE192CaO+c02lth01PVXvDnG2bIU+OnS9XLqX+I+A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfp5G8Uommss/t5oQcqdEnpFP+lMVl+A2vYrSF8pLIiJAvr1o+
	lZmF5NOIIwypkewlHfKlM7vempkysxCHV1hhiNMfSZhLazJn247sdN3JPXRed9Y0A2e1QJmT1ks
	U/Q==
X-Google-Smtp-Source: AGHT+IFFoxTCAf/VBwvpKjOPtp780LvH6h9NZi2W1UhdqbZyI4z9u0aCzY3G15g7VdYrZSLAaSVeTd6UZGw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:910e:0:b0:e0b:a34d:f223 with SMTP id
 3f1490d57ef6-e116cecab95mr69092276.5.1723734999238; Thu, 15 Aug 2024 08:16:39
 -0700 (PDT)
Date: Thu, 15 Aug 2024 08:16:37 -0700
In-Reply-To: <20240731143649.17082-1-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240731143649.17082-1-john.allen@amd.com>
Message-ID: <Zr4b1bpccYKpMUDA@google.com>
Subject: Re: [PATCH v2] KVM: x86: Advertise SUCCOR and OVERFLOW_RECOV cpuid bits
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	bp@alien8.de, mlevitsk@redhat.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, yazen.ghannam@amd.com
Content-Type: text/plain; charset="us-ascii"

s/cpuid/CPUID

On Wed, Jul 31, 2024, John Allen wrote:
> Handling deferred, uncorrected MCEs on AMD guests is now possible with
> additional support in qemu. Ensure that the SUCCOR and OVERFLOW_RECOV
> bits are advertised to the guest in KVM.

To host userspace, not the guest.

Please add a paragraph explaining (a) what these features do, (b) why
KVM doesn't need additional enabling, and (c) why KVM can't emulate these features
in software (though this can be omitted if it's quite obvious from (a)).

