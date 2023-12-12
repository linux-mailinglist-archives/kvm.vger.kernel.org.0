Return-Path: <kvm+bounces-4219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F29AA80F473
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F6B51C20A57
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEEC7D88F;
	Tue, 12 Dec 2023 17:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HnM4jinW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B678E
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 09:22:38 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1d08383e566so52692255ad.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 09:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702401758; x=1703006558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ROCp0xNd0wyqOc7nplsrZkpuLfarMjHYIQNZwVviJ7k=;
        b=HnM4jinWoc7Y5b/wDcbxzJJepOv8cd4sO9RdKKADcqamDAueL8wrV0FHrWCfx3snha
         kb3yVOaEw20XaycdieaS9+JG3aDqvlg3rMLHPzUvrdZKKe+oObuCjpJh2kMuUU5v9xvT
         JbNB8Mfz5t85NmrqChVZgfsHz4/BQWiKq3Mekmx+fjBNSN5zFViZCwlKvVQx0hSmvPYO
         boqVaOAw0oI+3miZYt2kJU5fOatMy3jMXyJhVmgtoCpjfSy4xxzxdGN7eE0PDdnLo1OI
         Yo7RpJkmZDIhye5U5vsp5WjHIvgK1t98NzSPOJJq23OGuGmyh5cH+EGutSl2icqNBXHA
         uB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702401758; x=1703006558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ROCp0xNd0wyqOc7nplsrZkpuLfarMjHYIQNZwVviJ7k=;
        b=bh2prSV2dT2ozYHhUuBTdpzB3XfMYdXjQg4/XpOJ5ksxp3Auivnq1RzW815wHVX36B
         HS2K+1hJV2hakbj4MIxGV3XWVpoKYJV9hFj9WyUprJioXw6xu9ad2GXyb2RiKa22dUZr
         TQxKy0osJJklQX+wp68n17j2R/dsZYh8HimH4pmv07IPGYjWKcJYPRWRBET9wsxTpnKO
         qZlpRjq4X6kHcBJISJdRkWNfAQYUqkLgqLw7JoayjiC+picx2leO3h5XB5cPMDKT8ByG
         v3flYZxH+lfrkkAhJP6cki0IPmD/8ZBcLe5naoCsHudx8iS5upWUhP8wzKQSagd4EKwT
         zMMA==
X-Gm-Message-State: AOJu0YwHXBAOeVR5fHPosTsO/LuZ92vwiIEs9ocw1kblNWoxwnWTLB9i
	lIeFofh/8bUH47beViribL9VrYtBhFQ=
X-Google-Smtp-Source: AGHT+IEOEh3C8zTlAW12bJONZI+u1CmuqqelXRvUx1auEKYIObXd3RFyfjdun8PThEpN5T5kS2y4fIeGI98=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a504:b0:1d0:54ff:da25 with SMTP id
 s4-20020a170902a50400b001d054ffda25mr46568plq.0.1702401757577; Tue, 12 Dec
 2023 09:22:37 -0800 (PST)
Date: Tue, 12 Dec 2023 09:22:36 -0800
In-Reply-To: <20231212022749.625238-14-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231212022749.625238-1-yury.norov@gmail.com> <20231212022749.625238-14-yury.norov@gmail.com>
Message-ID: <ZXiW3AgIENf7whei@google.com>
Subject: Re: [PATCH v3 13/35] KVM: x86: hyper-v: optimize and cleanup kvm_hv_process_stimers()
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>, Matthew Wilcox <willy@infradead.org>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>, Alexey Klimov <klimov.linux@gmail.com>, 
	Bart Van Assche <bvanassche@acm.org>, Sergey Shtylyov <s.shtylyov@omp.ru>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 11, 2023, Yury Norov wrote:
> The function traverses stimer_pending_bitmap in a for-loop bit by bit.
> Simplify it by using atomic find_and_set_bit().

for_each_test_and_clear_bit(), not find_and_set_bit().

It might also be nice to call out that there are only 4 bits, i.e. that using
for_each_test_and_clear_bit() will still generate inline code.  Definitely not
mandatory though, just nice to have (I highly doubt this code would be sensitive
to using less optimal code).

> While here, refactor the logic by decreasing indentation level.
> 
> CC: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 40 ++++++++++++++++++++--------------------

This doesn't conflict with any of the in-flight Hyper-V changes, so with a fixed
changelog, feel free to take this through the bitmap tree.

Acked-by: Sean Christopherson <seanjc@google.com>

