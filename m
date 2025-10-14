Return-Path: <kvm+bounces-60017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E4EBBD9BBA
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 15:32:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1C291881167
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 13:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE07B313E0E;
	Tue, 14 Oct 2025 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zjg6FyR6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77892D248A
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 13:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760448502; cv=none; b=mpbzZGykJrpYbzR4eo9FRUbLQDPS/YsClhd/pzdGR6qem5y2SMv4JWIqwX45JbObew+NWYc5/Fx5s5hbgpFtURkAaPtL+U7aMaYfOwTXTcXoAs7R1i0wkLTar5zFD64IBbqk7bXL7PYdOliAzursA/b2GR11mrQHNEC+rKX7QX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760448502; c=relaxed/simple;
	bh=TORf89kxAPruMWAxwwZpkmqfRfZXSRcqcOCEdZf5Ed4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pj9PIWgmQjxL9aHdt6LQAaKDs5VJvNA0XV3Bj318gZXyP6uVVPSyYZUgnknkGTsRW1rHI79RFrLnl1YRnB9vh4HHVkEiT9DBubxx6KgwYMMXAharirNEg/yCJs7cSb1ulAclDp2nYuQOeO6GBfWD1S9LAOb/HtIn4wwzD5etYVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zjg6FyR6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3307af9b595so8849792a91.0
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 06:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760448500; x=1761053300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KRjkMfm2bP+2xhdA92yWGD49fzo6BPa0LuWZXvUPrxA=;
        b=Zjg6FyR6ONCBw1ISq3+aIhtFrZLgI10cie7Y4jQLDEGgf0lOCZUo4OsKeXgxXP5V1I
         zYmWno13J3Z0WEShnXpdr6qnHFEvJgsBQFeAx8FJHI0kAk4U55R6BrcQDBDdnHPh5P0Q
         ka4cjkUAP/tgEZH8iq0Us5jOKljfxPXSuZ9z/hyW8tlJYThPZtNlBTWhLbhV5BoUUPLb
         v9VburUslRD1CI1T7fAxFdwCuIUWAj0+Zu3fJeWCHT7FvEG7FzG26Nt6WVkv1dpCoA8H
         3LRbZk7M2IhCQojl3pAeADbsb1g/iFuc55tAwwDos1uQn49FgxUK5Y7FNuBHooDDYMAE
         c+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760448500; x=1761053300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KRjkMfm2bP+2xhdA92yWGD49fzo6BPa0LuWZXvUPrxA=;
        b=Xv4vtD/Gr3IchSHLt3fRr/ipVpClfwy0thmGINPSBkgeFuA4xujvVF8tcoKd7yAWsR
         0OzE5Jbl9CaV+gUcxjIhZbB8d+rqPjnKNfM8kh+tnsUwj18NZNHpYbqD2rlcMD4A7wNq
         /FP1vNiFZ5x6jkA2tRVDPdKBhp1v5h8DIclrBEkDNc4I5AOmxyTY6zT7hf4WVSsf0Ilp
         lNPMgJm8t3yV6EdClafvxvawAZ49pkf+Qzn9sypdTG9mMM9KkV7k1YFuai+symGFO7E3
         m18KK2TszSVpCAFlJIs+bJ7IWOLdBXZKFJkJjK8YMfU496tzivvKXP5mxxpafzCuAAFz
         WdVA==
X-Forwarded-Encrypted: i=1; AJvYcCXCY/XFcMBW2j0YUECxOLnXVmO46nbQWrwYPEgGur1cXMcK3dIurqJRJ3HDN+VH2U9A4vc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEiqsaOfIZFsUihaK/1vjYHBalgvGGpTrAXX/OvtJVD4lVSnP5
	TQtFCRWxINJZIjvw3rk1L5Bwz+A5l2vVxpqXti2tQZisktiEskAp4ZdozaAKnHyc5RRCQYUb+WB
	2WQl3dA==
X-Google-Smtp-Source: AGHT+IGVUDXfEjxHF3D+9yDOYD8dNTWDN/VoE4bMUUCel8CPLfbdjARtih4c5//0jV2kl8OrGxXOC3GTZro=
X-Received: from pjbft23.prod.google.com ([2002:a17:90b:f97:b0:330:7be2:9bdc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c06:b0:339:eff5:ef26
 with SMTP id 98e67ed59e1d1-33b513ced9cmr34861576a91.30.1760448500020; Tue, 14
 Oct 2025 06:28:20 -0700 (PDT)
Date: Tue, 14 Oct 2025 06:28:17 -0700
In-Reply-To: <528d8293-a1a0-4d4f-87a6-e06eff7c559a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251012071607.17646-1-shivankg@amd.com> <aO0G9Ycu_SlISBih@google.com>
 <aO1CGlKGso4LLtS5@google.com> <528d8293-a1a0-4d4f-87a6-e06eff7c559a@amd.com>
Message-ID: <aO5P8TMihUZZaYX-@google.com>
Subject: Re: [PATCH V3 kvm-x86/gmem 1/2] KVM: guest_memfd: move
 kvm_gmem_get_index() and use in kvm_gmem_prepare_folio()
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: pbonzini@redhat.com, david@redhat.com, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 14, 2025, Shivank Garg wrote:
> On 10/13/2025 11:46 PM, Sean Christopherson wrote:
> I see you've already merged these changes into kvm-x86/gmem.

Yep.  I need to do testing (not really of these patches, but of other things I've
applied), and then you'll see the "official" thank you mails.

> Should I resend these patches with kvm-x86/next and --base, or is the current
> version sufficient?

Current version is sufficient, thanks!

