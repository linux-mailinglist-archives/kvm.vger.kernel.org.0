Return-Path: <kvm+bounces-21574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F202930132
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 22:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD7EA1F24020
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 20:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518743D0A9;
	Fri, 12 Jul 2024 20:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGDt0YzQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA46034CDE
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 20:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720814576; cv=none; b=qE/2TpnaiqCrGveauCwDna49hvF601DE2yh8g+68nKgqS52xrWOZ3L2ZLbIfatepNGWn4CT6HSzCsN4ZEHPIaDiObxbAccfDAJX5+sHQ02oh+Pw0j0UtJqdUxmnm06BIbUxF+Q391fp8cSmLYPM7nyCKip8S1CZPG6CX9eBA2gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720814576; c=relaxed/simple;
	bh=1zUPhysoViSxlYcRngclA3bOaQJucOi1Pj/v9a+PX74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=MkvL3Rxts+pdDclXBScqtZELtAryF/JZIFaIxYUokn6z8GLCkTkDHEv787gt1Vl07CjHV8PVCgl3kDtS65pZ3gy1ECxSUFC/XKCdNIxkgRQukHc+bbmRxfb1pDHHt0Dz+V81QxCCxE+rGUpq7jeZDjbpVDuQBggCTmEVkG1Jyc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGDt0YzQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720814573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WALHv74WV2cVjzZCL39eKCy6GimLkLb+2S99yNQNkn0=;
	b=ZGDt0YzQ7yBDe6FQzeSmt5qDS6ByfGKhz9KbZY91uby0W2w63mksgM00Msa4VWWW8df+N9
	csWWvZ/UwA3c8ZCw737HsFCAqq03mjQHqqCEAiMZOeQj1JFyC9HicjN2zKWdHNTfw+nAdI
	KCGZFVS7Q3HABV+6q7tgg+RChkx3H3Q=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-tiovavv0Na-6gWlNaYc6-A-1; Fri, 12 Jul 2024 16:02:52 -0400
X-MC-Unique: tiovavv0Na-6gWlNaYc6-A-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-70aff5bc227so1955880b3a.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 13:02:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720814571; x=1721419371;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WALHv74WV2cVjzZCL39eKCy6GimLkLb+2S99yNQNkn0=;
        b=HvknQmtcNdHvk6o+4sFwcHy6pJaOUKRb05Ov5y83xXg/XD8TN7nz/Hqcvlfh2j0XJ9
         EFqZm2NiAIbJF+qR8dj5DqoIWOCUE6lbUkAmRw0blNuvTtqrd5KI79aHQP+FAl0B6641
         ACAkn8e2bySGxlsj6kMGQ4piv9VakuXKNct5okB+43nEebruFgNdUwbh6GdNEGN5ZyWd
         DSkWrxXYXW/tYw1+Yx/0ERKvbJaoyk0LSHhUMxd6nUS1SquETqLYcrAv/U51eC3zi7B6
         BFNTKaOs0B2JkJGxtaWaKryE8hlfJSjLKgO1BWGNlrmViq7pUW0MC7JM6x8KfRowHYd8
         bDLg==
X-Forwarded-Encrypted: i=1; AJvYcCUORJ+W8coLMwn7v843eoKg3timGh/j7jX+Mso6uD1wO4M1z6e9YfiJw5mN8kU9yGQYtlQ9onCZ03S9lXg4uVuetM4h
X-Gm-Message-State: AOJu0YyaNg+JuuNAg8UF5ECIcZfFTF8okp1s2R2BHabqYxSxI2omIPqF
	+fNf0zi97TcMdgocfwE4+l7ga0xySt3ZW8ksbgIpA2TcsgB/Wjj1B+X+fMNTGrZ2hzkG8eYmuW0
	R/xdzdtz//EzmZjXwzLjy2+cpkN/nmM00a8PuAarTKjC8QXfzDg==
X-Received: by 2002:a05:6a00:3e25:b0:705:9fc7:9133 with SMTP id d2e1a72fcca58-70b435e7ee2mr15391777b3a.23.1720814571359;
        Fri, 12 Jul 2024 13:02:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNmlk9BsIdDCqjINYXL5lLBoE++woDa8pnC7jaIuaU38uh72LjbkqaARCHNWnS5/S8BJKC3A==
X-Received: by 2002:a05:6a00:3e25:b0:705:9fc7:9133 with SMTP id d2e1a72fcca58-70b435e7ee2mr15391739b3a.23.1720814570900;
        Fri, 12 Jul 2024 13:02:50 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a802:5d71:55fb:289:f049:5d12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b43967791sm7901658b3a.118.2024.07.12.13.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 13:02:50 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Leonardo Bras <leobras@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Leonardo Bras <leobras.c@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Date: Fri, 12 Jul 2024 17:02:30 -0300
Message-ID: <ZpGL1rEHNild9CG5@LeoBras>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <f06ef91d-7f8c-4f69-8535-fee372766a7f@redhat.com>
References: <CAJ6HWG7pgMu7sAUPykFPtsDfq5Kfh1WecRcgN5wpKQj_EyrbJA@mail.gmail.com> <68c39823-6b1d-4368-bd1e-a521ade8889b@paulmck-laptop> <ZkQ97QcEw34aYOB1@LeoBras> <17ebd54d-a058-4bc8-bd65-a175d73b6d1a@paulmck-laptop> <ZnPUTGSdF7t0DCwR@LeoBras> <ec8088fa-0312-4e98-9e0e-ba9a60106d58@paulmck-laptop> <ZnosF0tqZF72XARQ@LeoBras> <ZnosnIHh3b2vbXgX@LeoBras> <Zo8WuwOBSeAcHMp9@LeoBras> <f06ef91d-7f8c-4f69-8535-fee372766a7f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jul 12, 2024 at 05:57:10PM +0200, Paolo Bonzini wrote:
> On 7/11/24 01:18, Leonardo Bras wrote:
> > What are your thoughts on above results?
> > Anything you would suggest changing?
> 

Hello Paolo, thanks for the feedback!

> Can you run the test with a conditional on "!tick_nohz_full_cpu(vcpu->cpu)"?
> 
> If your hunch is correct that nohz-full CPUs already avoid invoke_rcu_core()
> you might get the best of both worlds.
> 
> tick_nohz_full_cpu() is very fast when there is no nohz-full CPU, because
> then it shortcuts on context_tracking_enabled() (which is just a static
> key).

But that would mean not noting an RCU quiescent state in guest_exit of 
nohz_full cpus, right?

The original issue we were dealing was having invoke_rcu_core() running on 
nohz_full cpus, and messing up the latency of RT workloads inside the VM.

While most of the invoke_rcu_core() get ignored by the nohz_full rule, 
there are some scenarios in which it the vcpu thread may take more than 1s 
between a guest_entry and the next one (VM busy), and those which did 
not get ignored have caused latency peaks in our tests.

The main idea of this patch is to note RCU quiescent states on guest_exit 
at nohz_full cpus (and use rcu.patience) to avoid running invoke_rcu_core()
between a guest_exit and the next guest_entry if it takes less than 
rcu.patience miliseconds between exit and entry, and thus avoiding the 
latency increase.

What I tried to prove above is that it also improves non-Isolated cores as 
well, since rcu_core will not be running as often, saving cpu cycles that 
can be used by the VM.


What are your thoughts on that?

Thanks!
Leo


