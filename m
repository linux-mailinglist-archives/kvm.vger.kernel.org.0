Return-Path: <kvm+bounces-36137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79194A1819D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2876D3A7E01
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950A51F428A;
	Tue, 21 Jan 2025 16:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRLg61UN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ED92AF0A;
	Tue, 21 Jan 2025 16:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737475301; cv=none; b=uPMYIFgTEEkwnHnEOAf/YrNwVvM5bV4fwSNoNx5Opl1VDO9TRQcJgkW0cMprQ+GspWK2k76z5vzdbuq6YeYcrAjdhSwJQiuJeY+nzwc1IYksi0fUJJR6RRbfdC0YdBVM/VQxifp3FuuYs3mz6J5zrXRiwdLwXWr68HXP0CbfObY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737475301; c=relaxed/simple;
	bh=6kzGPfRmY1SDk+ppbghfG0BjXMvZ0KnuxdMppUfQt64=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JThzpeyJ1XolpGA0jb6+knhMF24ElBo/D9dyVdnHEWqTvqxWxkqgyd+8D6mi5OO/sZiLAv6OjNM4BRziH1NT7/2ShICVZAcuSJ5WvXF+K7X05NSIy0HvTgUYYXhk0TvAT4i+2bmz3klw3kqaDvKcrKiP2qAqnG+gQ7gFjx400QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRLg61UN; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-385e0e224cbso3080076f8f.2;
        Tue, 21 Jan 2025 08:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737475298; x=1738080098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PuVp0kekam2/2W3fodEo/u1eEQQm10ttNQffjjABJUE=;
        b=VRLg61UNnjfcP0U3xjQ3giD4LOQg85DzrDJtCycy2rfdt2YSWMIZRqT2L5EHmUCM3H
         yuP6y4/Y41oumVklDpbhzk7/9KNdvpCR+wB1NHf1yLJ8LDxQysvbYkhvVuLSkRevAPeq
         6EVjYcClAklr0OvgM45ABP7X0LtYh+NMe0xQmJvBk0sETP3ln5OLTn+J1Bkt2INiUd5+
         f43aArN9oOuA/Gmm2BLIFAIhVHj6C354/wL+uf+8LeyY/pvt4rFD9hp+T6mOPFtU3RQN
         inuVBe6bkTVk1ppx4juzyZbdo/O1pQNAVe3DpZSooxeByEJQ00f58XGKDQYlCFC6UCyQ
         Re1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737475298; x=1738080098;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuVp0kekam2/2W3fodEo/u1eEQQm10ttNQffjjABJUE=;
        b=ZqYkgzTbhE/EdpH4ev/pIJ38TbbI1iBctIe0hBgRh01uhDb9VlGWEoUgaMViXhth1f
         oH2HrX1cRGmdFCcuQuNTIHdrLs267fvHSrJGdFTXc3crrefd7/mEDdkYhWFQy2BwsTmp
         eZVkpDuN8tTJsg/9d/5yGu1sqoaLyWrOpf3j+2irov9lL2ewilSZ5pXstLSs8BmL0yqI
         PARntCPaYvECelKafMMb5OKQgnqr4otD66FmFLEEixi/o7KPTYMJeK01P1+i4j1Flp0N
         kuh4dDSPCJRD0ZEzoGFEzAmvCSPcKGWowqvAIhte5a+aXl+697YHZe8hGRUMROau9QDN
         fwuA==
X-Forwarded-Encrypted: i=1; AJvYcCUVqnuyfjq5eFVMMDtWLPRUz+FPzDwwcviwCfzIJHeqPRGuOaB9ok50UcPyKrNX77h9P/8doHOhOir+P7k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdQjFefD0+O+hzonmHuiHvwwhLX8oGpZCC1CsbTrRMhox1TY8r
	4WeQEel5e37tuXYCECl/QnBZ0M8ScRRiwYuMduXgg2yLsKDK3L/M
X-Gm-Gg: ASbGncvumS9W/Gjyrk2kOr9vU9ok5uBC2GrPu6EJZwoA113/ESPxaESt9zcwVCIaauO
	XVDOs5QU8xkdaQcvrcn8kWfyzXLEtUjtE4LleREYXvZmdCeGf/Txz/iEMhAw0n6icBC/UEftEml
	K7cA3JH8cCenOsV3CPeWsKVuh8wf1kGlMBQp2GVb3WceE3jkFSf1e8ubkJLDHwgakp0S0aHfNpf
	WohszFrTCI8hLo6qpz+aXLwXybGc6vHmrusd6Gj6t+nM5J8JVeyi2t1NarT+CWGArYpei/Eexwc
	KqNtUyoMtuF1hy0z6S51ypuyug==
X-Google-Smtp-Source: AGHT+IGxrzZj/VeXjebh2v7qIbrDqZelxGqOr6d8+g6rm/rng6GhXPhzEZt4kU90ShHJCwJGMXjyNw==
X-Received: by 2002:a5d:5f50:0:b0:382:49f9:74bb with SMTP id ffacd0b85a97d-38bf57a9a6bmr17715595f8f.35.1737475296413;
        Tue, 21 Jan 2025 08:01:36 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221c25sm13552937f8f.23.2025.01.21.08.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 08:01:36 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <5cc5a8ef-b405-44f8-b799-ec9db39ac695@xen.org>
Date: Tue, 21 Jan 2025 16:01:33 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 01/10] KVM: x86: Don't take kvm->lock when iterating over
 vCPUs in suspend notifier
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-2-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250118005552.2626804-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/01/2025 00:55, Sean Christopherson wrote:
> When queueing vCPU PVCLOCK updates in response to SUSPEND or HIBERNATE,
> don't take kvm->lock as doing so can trigger a largely theoretical
> deadlock, it is perfectly safe to iterate over the xarray of vCPUs without
> holding kvm->lock, and kvm->lock doesn't protect kvm_set_guest_paused() in
> any way (pv_time.active and pvclock_set_guest_stopped_request are
> protected by vcpu->mutex, not kvm->lock).
> 
> Reported-by: syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/677c0f36.050a0220.3b3668.0014.GAE@google.com
> Fixes: 7d62874f69d7 ("kvm: x86: implement KVM PM-notifier")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Paul Durrant <paul@xen.org>

