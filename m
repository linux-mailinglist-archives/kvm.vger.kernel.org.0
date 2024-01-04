Return-Path: <kvm+bounces-5628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B2F0823F22
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 338A6286879
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 10:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40D420B0B;
	Thu,  4 Jan 2024 10:01:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8261B28D;
	Thu,  4 Jan 2024 10:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5570f246310so140588a12.0;
        Thu, 04 Jan 2024 02:01:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704362463; x=1704967263;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GB0K6qZx0zrh4wOwO3cUota9tes49aEfXI/3BFUe2E=;
        b=uhU/Mg8ZLGkhbQTzU6+UNwY6B97HIdyuAKs6Osxi+CishHgdLZUpY/s/Kc64vPNndX
         S1kh01MlKSJgOsBrouvdYEqefaOk15KT6Dg/AZOAi5CoULYLhkEJyWLa7nnOtjBXiSTw
         SS6RjRvBGi0JqmGwsjidI3B4ZBojrkFSCPf3Da92j76ELq4it1UCSKu8u+RbLHSeoqsa
         cSRB1+YaaU0zVT5x3HBRkjYvidp5RQqPm6ObP4I1bY7zarDLUdsid/AHXwrwAs3qSRCE
         XL1LRYH5PwvGF/8Dy3BA7Q1kfQdYrprp9iDLy3LD0jOzOmP3crhoJwITBElhjgRopgtd
         Tdog==
X-Gm-Message-State: AOJu0YyBEQocbWLti5+8+PMJVkZe0ENjzsyy5fU2qpMJgi+8/Pt5PM6c
	NTXroHy1ePJcEpJZo6fqJEQ=
X-Google-Smtp-Source: AGHT+IGjvlrpvxpGdqvKI6pU/xED0gs/zrXJ0SXIPkeujhOLk1Fr2e+e4PJdp/oh+sQSJFRciaazqw==
X-Received: by 2002:a50:a45b:0:b0:553:2b8:c9ff with SMTP id v27-20020a50a45b000000b0055302b8c9ffmr218889edb.76.1704362462773;
        Thu, 04 Jan 2024 02:01:02 -0800 (PST)
Received: from gmail.com (fwdproxy-cln-120.fbsv.net. [2a03:2880:31ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id en22-20020a056402529600b00553830eb2fcsm18446438edb.64.2024.01.04.02.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 02:01:02 -0800 (PST)
Date: Thu, 4 Jan 2024 02:01:00 -0800
From: Breno Leitao <leitao@debian.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Like Xu <like.xu@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Luwei Kang <luwei.kang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, rbc@meta.com
Subject: Re: [BUG] Guest OSes die simultaneously (bisected)
Message-ID: <ZZaB3CMiqkUU6qpG@gmail.com>
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>

On Wed, Jan 03, 2024 at 02:22:23PM -0800, Paul E. McKenney wrote:
> I was
> therefore forced to bisect among the commits backported to the internal
> v5.19-based kernel, which fingered the backported version of the patch
> called out above.

Just to add some context to these backport, this commit (c59a1f106f5c)
was backported to the internal v5.19-based kernel in order to easily
backport these two fixes.

	a16eb25b09c02a54c ("KVM: x86: Mask LVTPC when handling a PMI")
	73554b29bd70546c1 ("KVM: x86/pmu: Synthesize at most one PMI per VM-exit")

They are required to solve the softlockup problem reported here:

	https://lore.kernel.org/all/ZRwcpki67uhpAUKi@gmail.com/

