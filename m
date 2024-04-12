Return-Path: <kvm+bounces-14567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4ED8A35E5
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4E8C285A62
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 18:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E9214F121;
	Fri, 12 Apr 2024 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l26RIRZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2BE14D44F
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 18:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712947278; cv=none; b=UAEaj4NF3bjGJac2Njm5Hks7IbLicMAbkH1X0f1q+YcFDW16wsbJXIUioZkruicTi0xq+vOKWkApZjbA9pwY8QNf73dkZQaLf74oQaSmDVJEpKFQ3GVCgs80vUkj067RVgJ/zBV3672EOPdds6xMuR+xW+ChN6hEmwG55jReT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712947278; c=relaxed/simple;
	bh=tE1aWPCZZJl7MoElbd+5YmoN+nAf47vnVFjNHq6stP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X8YC45vh40rOrEAoU97Krdizrfl+Qss0gn69me16ga/SVy2GKFMqYOAV6eeRwUi6VSFRvMKj7OuG7iA/q8YCw5oXGFqfm9oP8FFraVYOqunDAcyuWT2UM+XpIfnAIEWPRk4xpYBEVGqlRXbp5UahWKNJ4XY8+6OSpFJC8pza1Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l26RIRZ4; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e411e339b8so9844475ad.3
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 11:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712947277; x=1713552077; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tE1aWPCZZJl7MoElbd+5YmoN+nAf47vnVFjNHq6stP4=;
        b=l26RIRZ4eCzxi0G54QsV1tN3DWAZAO9tvG6qBXVNlzkcbSDDrb/Zos8YXzxelXJf8V
         XDhre1ImCXQPFJaKJS+twP0WAqoVo4EUsxgAs/9NDL3OZjGrAGXWH1J3ZNi54bkbQrCx
         3/8wRsn1vJxP8lwTWV3HPKLWI/xhF1W5VoVkN2o2ZUNCR5HFd3ZiGqMmYLJd+hAkPnCu
         edXOYMUy4nN9WuUHlDdLhg5cObvrfIKB5Eo3zJCcOuAsHkAkLfGr3/fH6NJNl/i+bNo+
         xJDihT7hERjqJTcTLyCK0Wq12d9LK5+yT5lVQeT/hnQ90zC6O3faWI6KZaHO5TOSP+CR
         hMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712947277; x=1713552077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tE1aWPCZZJl7MoElbd+5YmoN+nAf47vnVFjNHq6stP4=;
        b=sL4G4MJHYtWA0OsiDmT1Ta35ACh7KyWA/NdQMGa5NENU6rnkI8VnfqChCnXUSsJxfJ
         uv8pa9P2HSUgt8TDBFK/NstcMByBDfYT2P+KJ1DgJUBq9C20ZCGJjSMuG4BWYy8bXnHE
         l3ulIUUh9WeukN5xooFg/dKGPAvafUK0Cqj8h2TDSsZctmnZXSlNGejgaJU+hLXFmal5
         h2FLzJhMOtyCOCCKCT90uqceNwlzFUalkhg3LM1ZbSeHnBvV801S8mXJF16lrp9+QTe5
         deRQu2Q8ATEjUSelp+xKeZsSNmN7XUSelmKuDdo2vcK6XlXz1vOEQsT5hGTxZPXk05Sd
         zZng==
X-Forwarded-Encrypted: i=1; AJvYcCVisiH/sIh6C3pgPoRniMJHPasG3M+IWU5EQd8LGCgwNb97JCngIRvTkU8O0AOHMnoUViJfs/JZz6TKyITZGcIXEUVZ
X-Gm-Message-State: AOJu0YyLYsrNvmdn/C5WyMY4WKYuEsv89CUPvm6ZjxjX2uiWVuVVg5OD
	oYOrgs8O7srEsslwO8t3OREZu5EeUBBf3BHhMNjVV7EsWHwGcHL4RI7bYCOHFA==
X-Google-Smtp-Source: AGHT+IGQO04VC0zqxkXl9HI81WqEqxeP4e4k3T6O5AVuAZB5k5Q3DvX9OiYo61rtrsCcY43kj4509A==
X-Received: by 2002:a17:902:650a:b0:1e0:a1f4:95f with SMTP id b10-20020a170902650a00b001e0a1f4095fmr3460792plk.14.1712947276396;
        Fri, 12 Apr 2024 11:41:16 -0700 (PDT)
Received: from google.com (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b001dd0d0d26a4sm3384097plb.147.2024.04.12.11.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 11:41:15 -0700 (PDT)
Date: Fri, 12 Apr 2024 11:41:11 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhao <yuzhao@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Rientjes <rientjes@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] mm/kvm: Improve parallelism for access bit
 harvesting
Message-ID: <ZhmAR1akBHjvZ9_4@google.com>
References: <20240401232946.1837665-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401232946.1837665-1-jthoughton@google.com>

On 2024-04-01 11:29 PM, James Houghton wrote:
> This patchset adds a fast path in KVM to test and clear access bits on
> sptes without taking the mmu_lock. It also adds support for using a
> bitmap to (1) test the access bits for many sptes in a single call to
> mmu_notifier_test_young, and to (2) clear the access bits for many ptes
> in a single call to mmu_notifier_clear_young.

How much improvement would we get if we _just_ made test/clear_young
lockless on x86 and hold the read-lock on arm64? And then how much
benefit does the bitmap look-around add on top of that?

