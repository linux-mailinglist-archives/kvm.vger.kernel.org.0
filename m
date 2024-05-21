Return-Path: <kvm+bounces-17819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D17308CA583
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 03:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8258A1F2153F
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C7CCA955;
	Tue, 21 May 2024 01:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ngnLFSgM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834C07F
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 01:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716253357; cv=none; b=SQuiC7B04cXLnFKshzxoIwGGFMzjbrwS/bW3U705lvDFpPCCUR4W1R1dMssZKEJlCEPkHmkyvg4UQLPkCSGDgIwbRseCTJGeqL2a5cttuQp5+iSw8uD3ITLii2HJa7+qbnvQr+Pe7HqyiUQDd2BieS/cGVttu1K+zJOibBdJ9A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716253357; c=relaxed/simple;
	bh=62s9ZBQLECjqwaw8IyELeu4N6Gxe1GRRUiarSV+DbTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VHdnqNmQMh58gUAaxOS4qpB4Zdfjwey4OOLOSWIrDp1avFhzBtQOckghgptEZA/LXuDZdq87qemWGRe5DK3X6rHrRIXnu2MR+TLtUZnZEERI5MmR0juTVJWmv2b0N7+miE6djo9Wzp9fpUrRs2sVvJCYOi2o8wsJyUkTv9GB3MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ngnLFSgM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ece5eeb7c0so10761359b3a.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 18:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716253356; x=1716858156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kj18FI+spxVo0wYyt5GLsAf9LnUaY68HrretgdhL1+Q=;
        b=ngnLFSgMBYAqDnM+eXECVqCMKjSpijc4jSlWkGw5T2ec4kJG64E+oRuDhS5t1B6MkL
         gDVNSvnk/OZqO3lw5Bknh66lBq23xfVujP6gY8JQ0LTOrK04gDP7QSfdE3YDCLaE/0f8
         0uO+/nvEfhV6n7Lv3hDDcaITVTe/dOpZGdQX52tfJ8jDwpkAz0VBjPf5Vytu9+67Osjf
         /GYqtinm8/UpkPqQFIuvegYwBU7PKbiWUOhv6lQvzJQ0guUjikqgfZbOnhhtcLouNAm1
         fWA8Rjr7NjV0TUfJLCDGAB3TvouPDYRKBLSanh/U6E5UjsCAr7NEbDVhw7g5HiogOg/H
         w4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716253356; x=1716858156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kj18FI+spxVo0wYyt5GLsAf9LnUaY68HrretgdhL1+Q=;
        b=e5wLepkFI5c0MDhEN5nVrReC2ZarL2q90w9xNgo22cLBZ849ZIg0xybKj6+i8aO6gb
         FQ+sN9z5vkDS7pTeJ8koNFFn6ckKCyenwXWomlivwvQXBJwnTcRgynhXxdSi67Nlzmr/
         KZ2H/84YWxzhCublWtdjXC0dMKBAy6NmxxYR8QOIUr0yQuctzNWiKhqrk3yzrn6dO3v4
         L9gLPtTAxt/Lqafd2+lZxRLnEQWf8iwX7Gv2jZ2FddentIU0v7ACDpFVX42gDsUUcdVB
         Z7ftmlFh3yYawCIdXqJQsF+U+iyBRQF3+0pqbnRKlPRUN2qBo9GjVfGGBP8tzZN4Jbtf
         cL0A==
X-Forwarded-Encrypted: i=1; AJvYcCVrzjApZx8+7ehacBPxuaMiFckAdqoXCHpBI6JICDXsDc2Ivx9lgk+ozpXiZsmc6FR7Nyux6dn4NP3+fBEi5NWi3dts
X-Gm-Message-State: AOJu0Yxw/gVw4ENT/s3tANzalonnj2iUtGi2lZEf8wHC1AaZs5afjQd4
	PuOB4f+A6vYrkzOmdKVVxhCoTcRJKQFDMupvsKkTImo2s+pRR0x+1wUhR0J3mpwpAtrpY5EWisL
	DCQ==
X-Google-Smtp-Source: AGHT+IG2yAJanvKyU97focG/MqnEJX7x8reSfJL3QGZKYOWsxkzVO6QuYNNBaybkLhpdSDhQ/N8gw84H7eA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a91:b0:6f4:d079:bb24 with SMTP id
 d2e1a72fcca58-6f4e0296acamr1399421b3a.1.1716253355725; Mon, 20 May 2024
 18:02:35 -0700 (PDT)
Date: Mon, 20 May 2024 18:02:34 -0700
In-Reply-To: <3e7413b5-482a-4243-be6c-21a0ee232cc4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com> <20240518000430.1118488-3-seanjc@google.com>
 <78b3a0ef-54dc-4f49-863e-fe8288a980a7@intel.com> <ZkvbUNGEZwUHgHV9@google.com>
 <b1def408-f6e8-4ab5-ac7a-52f11f490337@intel.com> <ZkvpDkOTW8SwrO5g@google.com>
 <3e7413b5-482a-4243-be6c-21a0ee232cc4@intel.com>
Message-ID: <ZkvyqjLoGxuf-AdC@google.com>
Subject: Re: [PATCH 2/9] KVM: nVMX: Initialize #VE info page for vmcs02 when
 proving #VE support
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, May 21, 2024, Kai Huang wrote:
> But now L0 always handles #VE exits from L2, and AFAICT L0 will just kill
> the L1, until the patch:
> 
> 	KVM: VMX: Don't kill the VM on an unexpected #VE
> 
> lands.
> 
> So looks that patch at least should be done first.  Otherwise it doesn't
> make a lot sense to kill L1 for #VE exits from L2.

I have no objection to changing the order.

