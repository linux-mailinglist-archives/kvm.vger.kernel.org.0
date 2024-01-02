Return-Path: <kvm+bounces-5457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4B78220F8
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 19:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 214921C21643
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229E0156FE;
	Tue,  2 Jan 2024 18:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VeHJCx+X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C731156D6
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 18:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d42ed4cdc7so10255ad.0
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 10:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704220056; x=1704824856; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b1iJ/PC7NOmh51+I0K/ABUi5e6j/sV3yKrMrNMnzSm4=;
        b=VeHJCx+XC6NsVNtSDdq4nzwvE5QLApzOSD3LC6QAiks6l6hgrneosAL3sAgaVMOOES
         8xHWKo0JZEBjfYgcBsaMy18H6oySwAleAgY7IswYQH3DVw8G/rgTtuBvHFgIXevnakL8
         Qd4GsIICEk5UyprNbn3nuuHBuQXPl61VEtIa9I251HIvtMjat5Qwr3gR01Rthlg5aDvh
         MP5KZel/e8SAM18eXoS8BJRvF1FGpaxrOQTBQfJCpget5NIcUAVfH7w8J8uDBQQ+YFlL
         ZrpYAe6VmpVu2quIXJu4qJCrc55WTmabsdBasWnxEXpkc1U+mX6eexIkTmv+biC7oYl7
         K4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704220056; x=1704824856;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b1iJ/PC7NOmh51+I0K/ABUi5e6j/sV3yKrMrNMnzSm4=;
        b=pv+gV3fAuSyAu2d5/ptWjMAiv1Po9Q10FWjJddlemwyo7GoqO36TyEI/PNowvrSApH
         TtnyOhRQaFbbdJ9kHaLranEo5VggC4Rjr67KbP5gS1UCsQVlwZrqhK2FpvOnPdGy2Uhx
         gBamS7FvRvm2AHwySbvqKjDlHz+c9ksHSD4/Gnc+xi1XppejFgcwSGFGTgQkWqDp2fUq
         ddYayVf4dfCfEQ2FDwwLRYFbWBiUxIzXSvZIqgcdPuNDnrazJyu7Qdln38Kb++GhgTtK
         mBKwRRvGThboxIleVQRh+JVUyQocH17YmaWffYEho4oU3f11V+EU1/GgPF8wF0co6Ta5
         jfNg==
X-Gm-Message-State: AOJu0YwaFIQMFLF/HraJz5t9BudsWF69rLYLzAn1RkO+pViId9Yhrfqt
	CfBBQAmFv4mkXxBesMjbVG86cwK+XAIr
X-Google-Smtp-Source: AGHT+IHOMqzyTbLqQB4plEq+ftykwfP/uDMXWaZhiDtsDLQcXDc5u4n5HeAdTpYbKpwo+95Zpg48bg==
X-Received: by 2002:a17:903:1106:b0:1d3:6f65:e332 with SMTP id n6-20020a170903110600b001d36f65e332mr1173410plh.27.1704220056231;
        Tue, 02 Jan 2024 10:27:36 -0800 (PST)
Received: from [2620:0:1008:15:c73b:7876:89ec:9102] ([2620:0:1008:15:c73b:7876:89ec:9102])
        by smtp.gmail.com with ESMTPSA id b24-20020a17090acc1800b0028ce507cd7dsm878217pju.55.2024.01.02.10.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 10:27:35 -0800 (PST)
Date: Tue, 2 Jan 2024 10:27:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Paolo Bonzini <pbonzini@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
    Vitaly Kuznetsov <vkuznets@redhat.com>, 
    Sean Christopherson <seanjc@google.com>, 
    Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
    kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Fix SEV check in sev_map_percpu_data()
In-Reply-To: <20240102133747.27053-1-kirill.shutemov@linux.intel.com>
Message-ID: <cb702fe9-11a6-8a0c-925a-179cb3f6c516@google.com>
References: <20240102133747.27053-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 2 Jan 2024, Kirill A. Shutemov wrote:

> The function sev_map_percpu_data() checks if it is running on an SEV
> platform by checking the CC_ATTR_GUEST_MEM_ENCRYPT attribute. However,
> this attribute is also defined for TDX.
> 
> To avoid false positives, add a cc_vendor check.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>

